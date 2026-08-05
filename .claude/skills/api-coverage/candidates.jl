# Wrap candidates, found with this package instead of with libclang.
#
#   julia --project .claude/skills/api-coverage/candidates.jl                    # the default sweep
#   julia --project .claude/skills/api-coverage/candidates.jl Sema Decl          # named classes
#   julia --project .claude/skills/api-coverage/candidates.jl --json out.json    # machine-readable
#
# This replaces gapmap.jl, which drove Clang.jl's libclang bindings — the C API this package
# exists to reach past. libclang's cursor model cannot see most of what decides whether a method
# can be wrapped, so that tool produced names and left the judgement to someone reading headers.
# Everything here comes from a real `clang::CXXMethodDecl`, through the package's own high-level
# API: `find_decl`, `definition`, `members`, `signature`, `mangled_name`.
#
# THE QUESTION IT ANSWERS is "would a wrapper for this LINK", which cost this branch two CI
# rounds. `Sema::CheckBitwiseOperands` and `CheckLogicalOperands` were written and dropped
# because libclang-cpp exports neither; `FileManager::getVirtualFileRef` failed on Windows alone
# over a mangled name. Both are decidable before any C++ is written.
#
# Linkability is NOT "is the symbol exported". A method defined inline in its header has no
# out-of-line symbol at all — `Decl::getLocation` is `{ return Loc; }` — and a shim compiles its
# own copy, so it links with nothing exported. Checking exports alone rejects some of the
# most-used accessors in the API. The rule is: a body visible in the header, OR an exported
# symbol. Validated against eight methods whose real outcome this branch already knows; see
# test/skills/candidates.jl.

using ClangCompiler
const CC = ClangCompiler

const ROOT = normpath(joinpath(@__DIR__, "..", "..", ".."))
const ART = expanduser("~/.julia/artifacts/03178ba795d55ba102446a8eaccae5b1667dcc46")

# The headers the wrapper layer actually mirrors, in the order src/clang/api/ is laid out.
const HEADERS = ["clang/AST/ASTContext.h", "clang/AST/DeclBase.h", "clang/AST/Decl.h",
                 "clang/AST/DeclCXX.h", "clang/AST/DeclTemplate.h", "clang/AST/Expr.h",
                 "clang/AST/ExprCXX.h", "clang/AST/Stmt.h", "clang/AST/StmtCXX.h",
                 "clang/AST/Type.h", "clang/AST/Mangle.h", "clang/AST/RecordLayout.h",
                 "clang/AST/TemplateBase.h", "clang/AST/APValue.h", "clang/AST/Comment.h",
                 "clang/Basic/SourceManager.h", "clang/Basic/TargetInfo.h",
                 "clang/Basic/IdentifierTable.h", "clang/Basic/FileManager.h",
                 "clang/Basic/Module.h", "clang/Lex/Preprocessor.h", "clang/Lex/Lexer.h",
                 "clang/Lex/HeaderSearch.h", "clang/Lex/PreprocessingRecord.h",
                 "clang/Sema/Sema.h", "clang/Sema/Lookup.h", "clang/Analysis/CFG.h",
                 "clang/Frontend/CompilerInstance.h", "clang/Driver/Driver.h"]

# Classes worth sweeping by default: the ones src/clang/api/ has a file for.
const DEFAULT_CLASSES = ["ASTContext", "Decl", "NamedDecl", "ValueDecl", "DeclaratorDecl",
                         "VarDecl", "FunctionDecl", "FieldDecl", "TagDecl", "RecordDecl",
                         "EnumDecl", "TypedefNameDecl", "CXXRecordDecl", "CXXMethodDecl",
                         "CXXConstructorDecl", "CXXDestructorDecl", "ClassTemplateDecl",
                         "FunctionTemplateDecl", "TemplateDecl", "Expr", "Stmt", "Type",
                         "FunctionType", "RecordType", "QualType", "ASTRecordLayout",
                         "SourceManager", "TargetInfo", "IdentifierInfo", "FileManager",
                         "Module", "Preprocessor", "Lexer", "HeaderSearch", "Sema",
                         "LookupResult", "CFG", "CompilerInstance", "MangleContext"]

libclang_cpp() = first(filter(isfile,
                              [joinpath(ART, "lib", "libclang-cpp" * e)
                               for e in (".dylib", ".so", ".dll")]))

"""
    symkey(s) -> String

One spelling for a symbol however it was obtained. `nm` prints the platform's leading
underscore, `mangleName` returns the bare Itanium name, and `getAllManglings` returns it with
the underscore already applied — so comparing raw strings marks every constructor unlinkable.
Itanium names begin `_Z`, so dropping the leading underscores makes all three agree.
"""
symkey(s) = replace(s, r"^_+" => "")

"Every symbol libclang-cpp defines, keyed for comparison."
function exported_symbols()
    syms = Set{String}()
    for line in eachline(`nm -gU $(libclang_cpp())`)
        m = match(r"\s[TtWwSsBbDdVv]\s+(\S+)$", line)
        m === nothing || push!(syms, symkey(m.captures[1]))
    end
    return syms
end

"""
    wrapped_names() -> Set{String}

`clang_<Class>_<method>` names already bound in lib/<major>/LibClangEx.jl, lower-cased.

Case-insensitively, because the shim does not always spell its own class prefix the way the
C++ class does, and an exact compare turns one mis-cased segment into a whole class reported
as unwrapped — it once hid all 44 of `clang::Value`'s methods, every one of them bound.
"""
function wrapped_names()
    s = Set{String}()
    for line in eachline(joinpath(ROOT, "lib", string(Base.libllvm_version.major),
                                  "LibClangEx.jl"))
        m = match(r"@ccall libclangex\.(\w+)\(", line)
        m === nothing || push!(s, lowercase(m.captures[1]))
    end
    return s
end

# Why a linkable method might still not be worth wrapping. These came from gapdiff.jl, which
# ran them over libclang's JSON; here they run over a real signature, so the parameter list is
# a list rather than a string that happened to contain the word.

"""
A C++ range accessor.

MARSHALLING.md §6 crosses these as a `getNum<Xs>` + `get<X>(i)` pair (or count+fill) that
deliberately shares no name with the C++ method, so asking whether `clang_Stmt_child_begin` is
bound answers nothing — `clang_Stmt_getNumChildren` is what got written. These are neither
blocked nor viable, they are *a third thing*, and counting them as either is what made the
survey's headline numbers wrong in one direction.

A range is also spelled two to eight times (begin/end, const overloads, rbegin/rend, the
`iterator_range` accessor) for what is one crossing; its own shape counts it once.
"""
const RANGE = r"^(begin|end|rbegin|rend)$|_(begin|end|rbegin|rend|size|empty)$|^(begin|end)_"

"""
C++ types with no C ABI — a thin wrapper has nothing to marshal them as.

Deliberately *narrower* than it looks. `ArrayRef`, `SmallVector` and `raw_ostream` are gone
because §11, §6 and §5 are exactly the patterns for them; bare `llvm::` is gone because it
swallowed `iterator_range`, `Expected` and `ErrorOr`, which §6 and §4 cover. What is left is
the set with no pattern and no obvious one: allocators, hash tables, the profiling accumulator,
the virtual filesystem, and the parser's own in-flight state.
"""
const BLOCKED = r"MultiExpr|function_ref|std::function|unique_function|
                 InitializedEntity|InitializationKind|CachedTokens|
                 SmallBitVector|PartialDiagnostic|sema::|std::tuple|
                 BumpPtrAllocator|StringMap|DenseMap|FoldingSetNodeID|
                 DirectoryLookup|vfs::|omp::GV|
                 Declarator|CXXScopeSpec|ParsedAttr|AttributeList|DeclSpec"x

"""
Surface this package deliberately does not carry.

`OCL` is not a synonym for `OpenCL` here, it is the spelling clang actually uses:
`Type::isOCLImage2dArrayMSAADepthROType` and the `isOCLIntelSubgroupAVC*` family are 48 rows
— every remaining `Type` gap — and matching only "OpenCL" left all of them looking like work.
"""
const OUT_OF_SCOPE = r"OMP|OpenMP|ObjC|OpenCL|OCL"

# Real methods that must NOT be wrapped. `classof`/`classofKind` are the RTTI predicates the
# stamped cast families already provide per class, and `CreateDeserialized` belongs to AST
# reading. Without this they come back `viable`, which is a standing invitation to wrap them.
const COVERED_OTHERWISE = r"^(classof|classofKind|CreateDeserialized)$"

"""
    shape_of(sig) -> Symbol

`:parser_action` for an `ActOn*`, which needs an in-flight parse; `:covered_otherwise` for the
handful the stamped families already provide; `:out_of_scope` for the subsystems this package
does not carry; `:range` for a begin/end accessor, which §6 crosses under a different name;
`:blocked` when a parameter or the return type is a C++ type with no C ABI; `:viable`
otherwise.

`:viable` is not a to-do list — it means no *mechanical* blocker was found, and the measured
conversion rate on this repo is about 15% outside Sema and 2% within it. It is a filter, never
an estimate.

`:range` is tested *before* `:blocked` on purpose. A range accessor names an iterator type, so
the old ordering reported all of them blocked; and moving `iterator` out of `BLOCKED` without
giving ranges their own shape would have made them `:viable` instead, which is worse — it reads
as a to-do list of methods that must never be wrapped one-to-one.
"""
function shape_of(sig)
    startswith(sig.name, "ActOn") && return :parser_action
    occursin(COVERED_OTHERWISE, sig.name) && return :covered_otherwise
    text = join(sig.parameters, " ") * " " * sig.return_type
    occursin(OUT_OF_SCOPE, text * sig.name) && return :out_of_scope
    # clang spells it `createCodeCompletionConsumer`, and "CodeComplete" is not a prefix of
    # "CodeCompletion" — they diverge at the 11th character, so the old literal never fired.
    occursin("CodeComplet", sig.name) && return :out_of_scope
    occursin(RANGE, sig.name) && return :range
    occursin(BLOCKED, text) && return :blocked
    return :viable
end

"""
    linkage_of(m, syms, exports) -> Symbol

`:inline` when the header carries a body a shim can compile its own copy of, `:exported` when
one of the out-of-line symbols is there to call, `:missing` when neither — the last being the
only one that cannot be wrapped. `syms` is a list because a constructor has more than one.
"""
function linkage_of(m, syms, exports)
    (CC.doesThisDeclarationHaveABody(m) || CC.hasBody(m)) && return :inline
    any(sym -> symkey(sym) in exports, syms) && return :exported
    return :missing
end

"""
    manglings_of(mc, ng, m) -> Vector{String}

Every linker symbol `m` could be emitted under. One for an ordinary method; several for a
constructor or destructor, which have complete-object, base-object and (for a ctor) allocating
variants — `mangleName` refuses those outright, because clang's entry point wants to be told
which variant is meant and aborts on a bare decl.
"""
function manglings_of(mc, ng, m)
    if m isa CC.AbstractCXXConstructorDecl || m isa CC.AbstractCXXDestructorDecl
        return try
            CC.getAllManglings(ng, m)
        catch
            String[]
        end
    end
    return try
        [CC.mangleName(mc, m)]
    catch
        String[]
    end
end

"""
    base_chain(I, clsname) -> Vector{String}

`clsname` followed by every transitive base's unqualified name.

A wrapper types its receiver at the abstract of the class that *declares* the method, so the
one bound on `NamedDecl` already serves every `FunctionDecl` — asking only whether
`clang_FunctionDecl_getNameForDiagnostic` exists reports a reachable method as a gap. Walks
the chain rather than the direct bases because the declaring class is often two levels up
(`CXXMethodDecl` -> `FunctionDecl` -> `DeclaratorDecl` -> `ValueDecl` -> `NamedDecl`).
"""
function base_chain(I, clsname)
    seen = String[]
    todo = [clsname]
    while !isempty(todo)
        cur = pop!(todo)
        cur in seen && continue
        push!(seen, cur)
        rd = try
            CC.find_decl(I, "clang::" * cur)
        catch
            nothing
        end
        (rd === nothing || !(rd isa CC.AbstractTagDecl)) && continue
        d = CC.definition(rd)
        d === nothing && continue
        r = CC.resolve(d)
        r isa CC.AbstractCXXRecordDecl || continue
        # A base's spelling is the name of the type as written -- `getBases` yields
        # `CXXBaseSpecifier`s and `get_name` on the specifier's QualType is already the
        # unqualified class name, so there is no decl round trip to get wrong. A template base
        # (`Redeclarable<FunctionDecl>`) spells its arguments and simply fails the next lookup.
        for bs in CC.getBases(r)
            push!(todo, CC.get_name(CC.getType(bs)))
        end
    end
    return seen
end

"""
    wrapped_forms(cls, name) -> Vector{String}

Every symbol spelling under which `cls::name` may legitimately be bound, lower-cased.

The exact spelling is evidence of coverage; its *absence* is not evidence of a gap, because
three MARSHALLING.md sections cross a value by renaming it. The forms here are the ones this
shim actually uses — read off the bound symbols rather than invented:

  - §6 counts as `getNum<X>` (the overwhelming majority) or `<x>_size`;
  - §5 strings as `<name>AsString` / `<name>ToString`, and a `print<X>(raw_ostream&)` as
    `get<X>AsString` alongside `print<X>ToString`.

Deliberately conservative: a form is listed only when the rename is mechanical from the C++
name. A §7 decomposition that shares no noun with its method (`getFloatTypeSemantics` ->
`getFloatTypeSemanticsPrecision`) is not derivable here and stays reported as a gap — this
oracle may under-report coverage, never over-report it, because a false "wrapped" hides real
work while a false "unwrapped" only wastes a reader's time.
"""
function wrapped_forms(cls, name)
    forms = String[name]
    # §5: a raw_ostream sink becomes a returned string.
    if startswith(name, "print")
        rest = name[6:end]
        append!(forms, ["$(name)ToString", "$(name)AsString",
                        "get$(rest)AsString", "get$(rest)ToString"])
    end
    append!(forms, ["$(name)AsString", "$(name)ToString"])

    # §6: a range or ArrayRef return becomes a count plus an indexed accessor —
    # `getModuleInitializers` is bound as `getNumModuleInitializers` + `getModuleInitializer`.
    #
    # Only the COUNT is taken as evidence. The singular accessor would collide by accident
    # (`getTypes` would be "covered" by any unrelated `clang_ASTContext_getType`), whereas a
    # `getNum<X>` exists for one reason only: somebody crossed that range. Requiring the count
    # keeps this oracle one-sided, which is the property the whole file is built on.
    stem = startswith(name, "get") ? name[4:end] : uppercasefirst(name)
    append!(forms, ["getNum$(stem)", "$(lowercase(stem))_size"])

    return lowercase.("clang_" * cls * "_" .* forms)
end

"Is `name` bound for `cls` or for any class it inherits from, under any legitimate spelling?"
function is_wrapped(chain, name, wrapped)
    for cls in chain, f in wrapped_forms(cls, name)
        f in wrapped && return true
    end
    return false
end

"Every public, non-deleted, non-operator method of `clsname`, classified."
function survey(I, mc, ng, clsname, exports, wrapped)
    rd = try
        CC.find_decl(I, "clang::" * clsname)
    catch
        nothing
    end
    (rd === nothing || !(rd isa CC.AbstractTagDecl)) && return nothing
    CC.definition(rd) === nothing && return nothing

    chain = base_chain(I, clsname)
    out = NamedTuple[]
    for m in CC.members(rd)
        m isa CC.AbstractCXXMethodDecl || continue
        CC.getAccess(m) == CC.LibClangEx.CXAccessSpecifier_AS_public || continue
        sig = CC.signature(m)
        sig.is_deleted && continue
        (startswith(sig.name, "operator") || startswith(sig.name, "~")) && continue

        syms = manglings_of(mc, ng, m)
        push!(out, (; class=clsname, sig..., shape=shape_of(sig),
                    linkage=linkage_of(m, syms, exports),
                    symbol=isempty(syms) ? "" : first(syms),
                    wrapped=is_wrapped(chain, sig.name, wrapped)))
    end
    return out
end

render(s) = string(s.name, "(", join(s.parameters, ", "), ")",
                   s.is_const ? " const" : "", s.is_static ? " [static]" : "",
                   " -> ", s.return_type)

function main(args)
    json_out = nothing
    i = findfirst(==("--json"), args)
    if i !== nothing
        json_out = args[i + 1]
        args = [a for (k, a) in enumerate(args) if k != i && k != i + 1]
    end
    classes = isempty(args) ? DEFAULT_CLASSES : args

    exports = exported_symbols()
    wrapped = wrapped_names()
    println("libclang-cpp exports $(length(exports)) symbols; libclangex binds $(length(wrapped))")

    I = CC.create_interpreter(["-std=c++17", "-I", joinpath(ART, "include"), "-fno-rtti"])
    rows = NamedTuple[]
    try
        CC.parse(I, join("#include \"" .* HEADERS .* "\"\n"))
        ctx = CC.get_ast_context(I)
        mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
        ng = CC.ASTNameGenerator(ctx)
        try
            missed = String[]
            for c in classes
                r = survey(I, mc, ng, c, exports, wrapped)
                r === nothing ? push!(missed, c) : append!(rows, r)
            end
            isempty(missed) ||
                println("not found (no complete definition in these headers): ",
                        join(missed, ", "))
        finally
            CC.dispose(ng)
            CC.dispose(mc)
        end
    finally
        CC.dispose(I)
    end

    open_ = filter(r -> !r.wrapped && r.linkage != :missing && r.shape == :viable, rows)
    dead = filter(r -> r.linkage == :missing, rows)
    unwrapped = filter(r -> !r.wrapped, rows)
    println("\n$(length(rows)) public methods over $(length(classes)) classes: ",
            "$(count(r -> r.wrapped, rows)) wrapped, $(length(unwrapped)) not\n")
    println("of the $(length(unwrapped)) unwrapped:")
    println("  ", lpad(length(dead), 5), "  cannot link at all — declaration only, nothing exported")
    for k in (:parser_action, :covered_otherwise, :out_of_scope, :range, :blocked)
        n = count(r -> r.shape == k && r.linkage != :missing, unwrapped)
        println("  ", lpad(n, 5), "  ", k)
    end
    println("  ", lpad(length(open_), 5), "  VIABLE — linkable, in scope, nothing mechanical in the way")
    println("           (a filter, not an estimate: about 15% of these convert outside Sema, 2% within)\n")

    by_class = Dict{String,Int}()
    for r in open_
        by_class[r.class] = get(by_class, r.class, 0) + 1
    end
    println("open candidates by class (most first):")
    for (c, n) in first(sort(collect(by_class); by=p -> -p[2]), 20)
        println("  ", rpad(c, 24), n)
    end

    if !isempty(dead)
        println("\nNOT linkable — declaration only, nothing exported. Do not wrap these:")
        for r in dead
            println("  ", rpad(r.class * "::" * r.name, 44), r.symbol)
        end
    end

    if json_out !== nothing
        open(json_out, "w") do io
            println(io, "[")
            for (k, r) in enumerate(rows)
                print(io, "  {\"class\":\"", r.class, "\",\"name\":\"", r.name,
                      "\",\"return\":\"", r.return_type,
                      "\",\"params\":", length(r.parameters),
                      ",\"const\":", r.is_const, ",\"static\":", r.is_static,
                      ",\"linkage\":\"", r.linkage, "\",\"shape\":\"", r.shape,
                      "\",\"wrapped\":", r.wrapped, "}")
                println(io, k == length(rows) ? "" : ",")
            end
            println(io, "]")
        end
        println("\nwrote $(length(rows)) rows to $json_out")
    end
    return 0
end

# Running the file sweeps; `include`rs (selfcheck.jl) set NO_MAIN first.
isdefined(Main, :CANDIDATES_NO_MAIN) || exit(main(copy(ARGS)))

