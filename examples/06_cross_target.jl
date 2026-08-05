# =================================================================================================
# Cross-target inspection: ABI answers about a machine you are not running on.
#
#     julia --project examples/06_cross_target.jl
#
# A C++ compiler is not one program: it is a program parameterised by a *target*. How wide `long`
# is, where a field lands inside a struct, which `#ifdef` branch survives, what prefix the object
# file puts on a symbol -- the standard pins none of it down (it fixes minimum ranges for `long`,
# never a width). Clang models the answers in a single object, `clang::TargetInfo`, built from the
# target triple; everything downstream (the preprocessor's predefined macros, `ASTContext`'s layout
# engine, the name mangler) reads from it.
#
# `create_interpreter` takes that triple as a keyword. Unpinned, the interpreter is configured for
# the host platform; pass a triple and clang is handed that `--target=` together with the `-isystem`
# include paths of that platform's GCC shard, so it parses and lays out types as it would there.
#
#     create_interpreter(String[])                             # target = this machine
#     create_interpreter(String[]; triple="x86_64-linux-gnu")  # target = someone else's machine
#
# THE LIMIT, stated up front: only *parsing and AST inspection* cross-target. The JIT underneath
# still emits code for the host, so a pinned interpreter must never be asked to execute anything.
# The last act of this script shows exactly where that boundary sits.
#
# Why it matters beyond curiosity: every value in the table below is normally decided by whichever
# machine happens to run your code, which is why so many tests can only assert `isa Integer` about
# them. Pinned, they become equalities that read the same on a macOS laptop and on a Linux CI runner
# -- the same expected value on every platform, checked without owning the platform.
#
# FIRST RUN IS SLOW: pinning a triple downloads that target's GCC shard -- a large artifact, fetched
# once per target and cached in ~/.julia/artifacts afterwards. Three targets are pinned here.
# =================================================================================================

using ClangCompiler
using ClangCompiler: create_interpreter, dispose
import ClangCompiler as CC

# -------------------------------------------------------------------------------------------------
# One C++ source, shown unchanged to every target below. Not a line of it names a platform.
# -------------------------------------------------------------------------------------------------
const SOURCE = """
namespace abi {

// Clang predefines a different macro set per target -- `_WIN32` exists only when the triple says
// Windows -- so the target decides which declarations even reach the AST. This is the mechanism by
// which real system headers hand you a different type on every platform.
#ifdef _WIN32
using handle = void *;   // a Windows kernel handle
#else
using handle = int;      // a POSIX file descriptor
#endif

// Every member is a scalar whose width the *target*, not the standard, chooses. The padding
// between them is therefore a target decision too.
struct Message {
    char     tag;        // 1 byte everywhere; what follows it is the interesting part
    long     id;         // 8 bytes under LP64, 4 under Windows' LLP64 and under 32-bit ELF
    void    *payload;    // pointer width
    wchar_t  unit;       // 4 bytes on ELF targets, 2 on Windows
    handle   owner;      // the type itself differs, see above
};

// A free function whose parameter types are spelled into its symbol name by the C++ ABI.
long checksum(const Message &m, int seed);

}  // namespace abi
"""

# Compiled and *run* in the final act -- deliberately not part of SOURCE.
# `__builtin_offsetof` is what the `offsetof` macro in <cstddef> expands to, so using it directly
# keeps this probe free of any `#include` and makes the source above the only thing being measured.
const RUNTIME_PROBE = """
extern "C" int host_sizeof_message() { return (int)sizeof(abi::Message); }
extern "C" int host_offsetof_id()    { return (int)__builtin_offsetof(abi::Message, id); }
"""

# The targets to compare. `nothing` means "take this machine's", which is what you get when you
# leave the keyword off. All three pinned triples ship as GCC shards with this package.
const TARGETS = [("host", nothing, "whatever machine you are on"),
                 ("x86_64-linux-gnu", "x86_64-linux-gnu", "LP64 ELF, Itanium C++ ABI"),
                 ("x86_64-w64-mingw32", "x86_64-w64-mingw32", "LLP64 Windows, 64-bit"),
                 ("i686-linux-gnu", "i686-linux-gnu", "ILP32 ELF, 32-bit")]

"""
Run `f` on an interpreter for `triple` and dispose of it afterwards, whatever `f` does.

An interpreter owns a whole `CompilerInstance` -- source manager, preprocessor, AST context, JIT --
none of which Julia's GC knows about, so every `create_interpreter` needs its matching `dispose`.
"""
function with_interpreter(f, triple)
    I = create_interpreter(String[]; triple=triple)
    try
        return f(I)
    finally
        dispose(I)
    end
end

"Clang answers width questions in bits; a C++ programmer asks them in bytes."
bytes(bits) = Int(bits) ÷ 8

"""
Everything this script wants to know about one target, read out of a parsed `SOURCE`.

The facts are an ordered `label => value` list rather than a struct so that the table below can be
printed, and compared across targets, without naming any of them twice.
"""
function abi_facts(I)
    # `TargetInfo` is clang's model of the machine. Built from the triple, it is the origin of every
    # scalar width and alignment in the compiler -- nothing consults the host at any point.
    ti = CC.getTarget(CC.get_instance(I))
    # `ASTContext` owns the AST *and* the layout engine. Its size/alignment queries all bottom out
    # in the `TargetInfo` above, which is why a pinned interpreter lays records out foreign-style.
    ctx = CC.get_ast_context(I)

    # `find_decl` does an ordinary C++ lookup and hands back the decl resolved to its concrete
    # class: a `CXXRecordDecl` here, not a base-typed `NamedDecl`.
    msg = CC.find_decl(I, "abi::Message")
    msgty = CC.getTypeDeclType(ctx, msg)          # the QualType that names the record
    fields = CC.getFields(msg)                    # non-static data members, in layout order
    offsets = CC.field_offsets(ctx, msg)          # their offsets, in bits, from the record layout

    alias = CC.find_decl(I, "abi::handle")        # a TypeAliasDecl -- it exists on every target,
    aliased = CC.getUnderlyingType(alias)         # but names a different type on each

    facts = Pair{String,String}[]
    push!(facts, "sizeof(void *)" => "$(bytes(CC.getPointerWidth(ti))) bytes")
    push!(facts, "sizeof(long)" => "$(bytes(CC.getLongWidth(ti))) bytes")
    push!(facts, "sizeof(wchar_t)" => "$(bytes(CC.getWCharWidth(ti))) bytes")
    # `long double` is the loudest disagreement in C++: Apple's arm64 makes it plain `double`, while
    # x86 keeps the 80-bit x87 value and pads it out to the stack slot the ABI wants.
    push!(facts, "sizeof(long double)" => "$(bytes(CC.getLongDoubleWidth(ti))) bytes")
    # Alignment is a separate quantity from width: the next two rows are the same type, and on
    # 32-bit x86 they disagree -- a `double` there is 8 bytes wide but only 4-byte aligned.
    push!(facts, "sizeof(double)" => "$(bytes(CC.getDoubleWidth(ti))) bytes")
    push!(facts, "alignof(double)" => "$(bytes(CC.getDoubleAlign(ti))) bytes")
    push!(facts, "byte order" => CC.isLittleEndian(ti) ? "little" : "big")

    push!(facts, "abi::handle names" => CC.getAsString(aliased))
    push!(facts, "sizeof(abi::Message)" => "$(bytes(CC.getTypeSize(ctx, msgty))) bytes")
    push!(facts, "alignof(abi::Message)" => "$(bytes(CC.getTypeAlign(ctx, msgty))) bytes")
    for (field, offset) in zip(fields, offsets)
        push!(facts, "  offset of .$(CC.getName(field))" => "$(bytes(offset)) bytes")
    end

    # The mangler is picked by the ABI the triple selects: Itanium for ELF, Mach-O and MinGW,
    # Microsoft for an `-msvc` triple. `createMangleContext` returns a caller-owned object with no
    # dispose entry point -- a known gap in the C shim, not an omission here.
    mangler = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    itanium = CC.getKind(mangler) === CC.CXMangleContext_MK_Itanium
    push!(facts, "C++ mangling ABI" => itanium ? "Itanium" : "Microsoft")

    return (; clang_triple=CC.getTriple(ti),
            facts=facts,
            mangled=CC.mangleName(mangler, CC.find_decl(I, "abi::checksum")),
            # What the object format prepends to every symbol on top of the mangled name; "" on ELF,
            # "_" on Mach-O. Asked of clang rather than assumed, because it is a target decision too.
            label_prefix=CC.getUserLabelPrefix(ti),
            message_size=bytes(CC.getTypeSize(ctx, msgty)),
            offsets=[bytes(o) for o in offsets],
            id_offset=bytes(offsets[2]))
end

const LABEL_W = 26
const COL_W = 21

banner(title) = (println("\n", title); println(repeat("=", length(title))))
row(label, cells) = println(rstrip(rpad(label, LABEL_W) * join(rpad.(cells, COL_W))))

# -------------------------------------------------------------------------------------------------
# Act 1 -- parse the same source once per target.
# -------------------------------------------------------------------------------------------------
banner("Four compilers, one source")
println("Each column is a separate clang, built for a different target. The source is byte-identical.")
println("(A pinned triple downloads that target's GCC shard the first time -- this may take a while.)\n")

results = map(TARGETS) do (name, triple, note)
    print("  building clang for ", rpad(name, COL_W), "... ")
    facts = with_interpreter(triple) do I
        CC.parse(I, SOURCE)   # parse only: no code is generated, so a foreign target is fine
        return abi_facts(I)
    end
    println("ok -> ", rpad(facts.clang_triple, 26), "(", note, ")")
    return facts
end

# -------------------------------------------------------------------------------------------------
# Act 2 -- the answers, side by side.
# -------------------------------------------------------------------------------------------------
banner("What each target says about the same declarations")
row("", [name for (name, _, _) in TARGETS])
row("", [repeat("-", 18) for _ in TARGETS])
for i in eachindex(first(results).facts)
    row(first(results).facts[i].first, [r.facts[i].second for r in results])
end

# The interesting rows are computed, not narrated: ask how many facts the pinned targets disagree
# about. The host column is excluded because it is a wildcard -- it duplicates one of the others on
# some machines and none of them on others.
pinned = results[2:end]
disagreements = count(eachindex(first(pinned).facts)) do i
    return length(unique(r.facts[i].second for r in pinned)) > 1
end
println("\n", disagreements, " of ", length(first(pinned).facts),
        " facts differ between the three pinned targets -- with nothing in the source to explain it.")

# The nastiest row is the one that looks harmless. Read it out of the values rather than asserting
# it in prose, so the claim is only made when the numbers back it.
linux64, win64, ilp32 = results[2], results[3], results[4]
same_size = linux64.message_size == win64.message_size
# The claim below is "every offset after the first differs", so check exactly that -- a weaker guard
# (any difference anywhere) would let the sentence print on numbers that do not support it.
first_agrees = linux64.offsets[1] == win64.offsets[1]
rest_all_differ = all(linux64.offsets[i] != win64.offsets[i] for i in 2:length(linux64.offsets))
if same_size && first_agrees && rest_all_differ
    println("\nWatch sizeof(abi::Message) on the two 64-bit targets: both ",
            linux64.message_size, " bytes, and every offset after .tag different.")
    println("A byte-for-byte copy of that struct from one to the other agrees about exactly one field,")
    println("and no size check anywhere would notice.")
end

# -------------------------------------------------------------------------------------------------
# Act 3 -- the symbol name, which is an ABI decision rather than a layout one.
# -------------------------------------------------------------------------------------------------
banner("How `abi::checksum` is mangled")
println("The mangled name is what `MangleContext` returns; the object format then prepends its own")
println("global prefix, shown in the middle column, to get the symbol a linker actually sees.\n")
println("  ", rpad("", COL_W), rpad("mangled by clang", 34), rpad("symbol prefix", 15), "linker sees")
for ((name, _, _), r) in zip(TARGETS, results)
    println("  ", rpad(name, COL_W), rpad(r.mangled, 34),
            rpad(isempty(r.label_prefix) ? "(none)" : "\"$(r.label_prefix)\"", 15),
            r.label_prefix * r.mangled)
end
if length(unique(r.mangled for r in pinned)) == 1
    println("\nThe mangled names are identical, and deliberately so. Mangling follows the C++ ABI, which")
    println("the triple selects independently of the word size: all three pinned targets are Itanium,")
    println("MinGW included -- it takes an `-msvc` triple to switch to the Microsoft mangler. What pinning")
    println("buys here is not a difference but a guarantee: the string is a function of the triple, so a")
    println("test that pins one can assert it verbatim without asking which machine is running.")
end

# -------------------------------------------------------------------------------------------------
# Act 4 -- where cross-targeting stops.
# -------------------------------------------------------------------------------------------------
banner("The boundary: parsing crosses targets, execution does not")
println("The three pinned interpreters above only ever parsed. Nothing they produced was executed,")
println("because the JIT behind `Interpreter` emits for *this* machine -- asking one to run foreign")
println("code is not a diagnostic, it is a wrong answer or a crash.")
println("\nSo the numbers below come from actually running compiled code, which means they can only")
println("ever be the host's:\n")

host = first(results)
with_interpreter(nothing) do I
    CC.parse(I, SOURCE)              # the declarations
    CC.compile(I, RUNTIME_PROBE)     # parse *and* JIT-compile: these two get real machine code

    # `get_function_pointer` looks a symbol up by its *IR* name: the mangled name without the global
    # prefix from the table above. (The other spelling, prefix included, is what
    # `get_symbol_address_from_linker_name` takes -- two entry points, and the difference is exactly
    # that prefix.) Either way the name is the mangled one, which is why these probes are
    # `extern "C"`: a C++ function like `abi::checksum` is only findable as `_ZN3abi...`.
    size_fp = CC.get_function_pointer(I, "host_sizeof_message")
    offset_fp = CC.get_function_pointer(I, "host_offsetof_id")

    runtime_size = ccall(size_fp, Cint, ())
    runtime_offset = ccall(offset_fp, Cint, ())

    println("  sizeof(abi::Message)    executed: ", rpad("$runtime_size bytes", 12),
            "inspected, host column: ", host.message_size, " bytes")
    println("  offsetof(Message, id)   executed: ", rpad("$runtime_offset bytes", 12),
            "inspected, host column: ", host.id_offset, " bytes")
    println("\n  the executed answer equals the inspected host answer: ",
            runtime_size == host.message_size && runtime_offset == host.id_offset)
    # Whether the host happens to agree with a pinned column is a property of *this* machine, and is
    # the whole reason the pinned columns exist.
    println("  the host happens to agree with x86_64-linux-gnu here: ",
            host.message_size == linux64.message_size && host.id_offset == linux64.id_offset)
    # Name a target this host demonstrably cannot answer for, chosen from the measurements rather
    # than assumed -- on a 32-bit runner the i686 column is the one the host reproduces.
    foreign = findfirst(r -> r.message_size != host.message_size, pinned)
    if foreign !== nothing
        println("  ... but it could never have produced the ", TARGETS[foreign + 1][1], " answer (",
                pinned[foreign].message_size, " bytes) by running anything.")
    end
    return nothing
end

banner("The lesson")
println("""
An interpreter pinned with `triple=` answers ABI questions about a platform you do not have. Sizes,
alignments, record offsets, which `#ifdef` branch survives and how a name mangles all come from that
target's `TargetInfo`, so every machine that asks gets the same answer. That is what turns an
assertion nobody can write -- the value depends on the runner -- into one anybody can:

    I = create_interpreter(String[]; triple="i686-linux-gnu")
    parse(I, source)
    getTypeSize(ctx, message_type) == $(ilp32.message_size * 8)   # bits, and true on every CI runner

Keep it to parsing and AST inspection. The moment code has to run, the host is back in charge.""")
