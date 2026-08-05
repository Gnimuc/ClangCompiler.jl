# =====================================================================================
# 03 — Type safety: what the opaque handle layer buys you
# =====================================================================================
#
# Clang's C++ API is a deep single-inheritance hierarchy with a few deliberate exceptions.
# `libclangex`, the C shim this package talks to, cannot express any of that: C has no
# subtyping, so every entry point takes a pointer and immediately asserts what it is.
# Literally — this is the shim, verbatim:
#
#     bool clang_DeclContext_isNamespace(CXDeclContext DC) {
#       return reinterpret_cast<clang::DeclContext *>(DC)->isNamespace();
#     }
#
# No RTTI, no `dyn_cast`, no null test. That is on purpose: a check per call is a branch on
# every node of every traversal, and C has no vocabulary for "this pointer is a DeclContext"
# anyway. The shim is *check-free by contract*, and the contract is enforced exactly one
# level up — in Julia, by the code this example is about.
#
# When every handle was `Ptr{Cvoid}`, that contract had nothing behind it. Handing an
# `IfStmt *` to `clang_WhileStmt_getCond` compiled, ran, reinterpreted the pointer, and read
# whichever trailing slot a `WhileStmt` keeps its condition in. No crash. No diagnostic. And
# not even a dependably wrong answer: §2 measures that exact call returning the *correct*
# node for one `if` and the init-statement of another. A mistake that agrees with the truth
# on the input you happened to test is the shape of bug a test suite cannot corner.
#
# Now each clang class has its own opaque handle type — `Ptr{CXIfStmtImpl}`,
# `Ptr{CXWhileStmtImpl}`, `Ptr{CXDeclImpl}`, one per class — and `src/clang/handles.jl`
# out-specialises Julia's own permissive pointer conversions so that crossing between two of
# them raises. This file walks five consequences of that, each shown failing out loud.
#
# Run:  julia --project examples/03_type_safety.jl
# =====================================================================================

using ClangCompiler
import ClangCompiler as CC

# The raw binding module. Nothing in normal use reaches for it; §2 does, to show that even
# the type-erased layer underneath cannot be fed the wrong class any more.
using ClangCompiler.LibClangEx: CXDecl, CXIfStmt, CXWhileStmt, CXDeclContext

# One translation unit with everything the five sections need: a namespace and a struct
# (both are declarations that are *also* DeclContexts — see §5), one function whose body
# holds an `if` and a `while` side by side, and a second `if` that carries an init-statement
# — the two differ in their trailing storage, which is what §1 measures.
const CXX = """
namespace geom {

struct Point { double x; double y; };

int halvings_to_zero(int n) {
    int k = 0;
    if (n < 0) {
        n = -n;
    } else {
        k = 1;
    }
    while (n > 0) {
        n = n / 2;
        ++k;
    }
    return k;
}

int lowest_set_bit(int n) {
    if (int m = n & -n; m != 0) {
        return m;
    } else {
        return 0;
    }
}

}  // namespace geom
"""

# ------------------------------------------------------------------------------------
# Printing helpers. Nothing clang-specific — they exist so the sections below read as
# statements about C++ rather than as string formatting.
# ------------------------------------------------------------------------------------

function banner(title)
    println()
    println("=" ^ 88)
    println("  ", title)
    println("=" ^ 88)
end

function wrapped(text; indent="       ", width=84)
    line = ""
    for word in split(text)
        if isempty(line)
            line = word
        elseif length(line) + 1 + length(word) <= width
            line *= " " * word
        else
            println(indent, line)
            line = word
        end
    end
    isempty(line) || println(indent, line)
end

# The lines of an exception worth reading: the claim itself, plus — for a MethodError — the
# signature Julia was looking for, which is where the class requirement is written down.
function salient(e)
    lines = split(sprint(showerror, e), '\n')
    out = [strip(lines[1])]
    for l in lines[2:end]
        occursin("!Matched", l) && push!(out, strip(l))
    end
    return out
end

# Run something that must not be allowed to happen, and show how the refusal reaches a user.
function refused(label, thunk)
    println("  ", label)
    try
        thunk()
        println("       !! NO ERROR — the guarantee this section documents is gone")
    catch e
        for l in salient(e)
            wrapped(l)
        end
    end
end

# Run something that IS allowed, and show what came back.
function allowed(label, thunk)
    println("  ", label)
    println("       ok — ", thunk())
end

addr(x) = repr(UInt(getfield(x, :ptr)))
delta(a, b) = Int64(UInt64(getfield(a, :ptr))) - Int64(UInt64(getfield(b, :ptr)))

# The first node of a given class inside a statement. `subtree` yields *resolved* carriers,
# so `isa` here tests the concrete C++ class rather than the static type of a base handle.
function first_node(::Type{T}, root) where {T}
    for n in CC.subtree(root)
        n isa T && return n
    end
    return nothing
end

# The body of a named function, resolved to its concrete class.
body_of(I, name) = CC.resolve(CC.getBody(CC.find_decl(I, name)))

# ------------------------------------------------------------------------------------

function main()
    I = CC.create_interpreter(String[])
    try
        CC.parse(I, CXX)

        # ============================================================================
        banner("§0  Real AST nodes, each carried by its own Julia type")
        # ============================================================================
        #
        # `find_decl` performs an ordinary qualified lookup and then *resolves*: it asks
        # clang for the declaration's kind and returns the carrier for that concrete class.
        # This matters more than it looks. A carrier typed at a base is not wrong — the
        # pointer is right — but `d isa FunctionDecl` is then silently false, and every
        # method declared on the derived class is a MethodError away. Resolution is what
        # makes the Julia type track the C++ dynamic type.
        ns = CC.find_decl(I, "geom")                     # NamespaceDecl
        pt = CC.find_decl(I, "geom::Point")              # CXXRecordDecl
        fd = CC.find_decl(I, "geom::halvings_to_zero")   # FunctionDecl

        for (name, d) in (("geom", ns), ("geom::Point", pt), ("geom::halvings_to_zero", fd))
            loc = CC.source_location(I, d)
            println("  ", rpad(name, 24), rpad(string(nameof(typeof(d))), 16),
                    addr(d), "   line ", loc.line)
        end

        # `getBody` is declared on `clang::FunctionDecl` as returning `Stmt *`, so the
        # wrapper hands back a `Stmt` carrier: the pointer's static type, faithfully. The
        # dynamic class is a `CompoundStmt`, and `resolve` is what asks clang which.
        body_base = CC.getBody(fd)
        body = CC.resolve(body_base)
        println()
        println("  getBody(fd)          -> ", rpad(nameof(typeof(body_base)), 14),
                "the static type C++ declares: `Stmt *`")
        println("  resolve(getBody(fd)) -> ", rpad(nameof(typeof(body)), 14),
                "the dynamic class clang reports — same address: ",
                addr(body) == addr(body_base))

        # Walk the body and pick out the two loop/branch nodes.
        ifs = first_node(CC.IfStmt, body)
        whs = first_node(CC.WhileStmt, body)
        println()
        println("  the `if`    -> ", rpad(string(nameof(typeof(ifs))), 12), addr(ifs))
        println("  the `while` -> ", rpad(string(nameof(typeof(whs))), 12), addr(whs))
        println()
        wrapped("Both are `clang::Stmt` subclasses and neither derives from the other. In C++ " *
                "that makes them non-substitutable at compile time. The next section is that " *
                "same rule, transported into Julia.", indent="  ", width=86)

        # ============================================================================
        banner("§1  Dispatch is the type check: a method belongs to one class")
        # ============================================================================
        #
        # `IfStmt::getElseLoc()` exists; `WhileStmt::getElseLoc()` does not, because a while
        # loop has no `else` keyword to locate. In C++ the second spelling is a compile
        # error. Here the wrapper is declared `getElseLoc(x::AbstractIfStmt)`, so the same
        # mistake is a MethodError — raised before any pointer reaches the shim.
        else_loc = CC.source_location(I, CC.getElseLoc(ifs))
        println("  getElseLoc(::IfStmt)  -> line ", else_loc.line, ", column ", else_loc.column,
                "   (the `else` keyword in the source above)")
        println()
        refused("getElseLoc(::WhileStmt) — a while loop has no `else`", () -> CC.getElseLoc(whs))
        println()
        refused("getWhileLoc(::IfStmt) — and not the other way either", () -> CC.getWhileLoc(ifs))
        println()
        # What the first refusal prevents, forced through anyway. The one spelling dispatch
        # cannot see is naming the target handle outright — `CXIfStmt(p)` is Julia's own
        # `Ptr{T}(::Ptr)` constructor and bitcasts by definition — and that is exactly the call
        # the shim received when every handle was `void *`. §2 and §5 reach for it again too.
        #
        # clang's `IfStmt::getElseLoc()` is
        #     hasElseStorage() ? *getTrailingObjects<SourceLocation>() : SourceLocation()
        # and `hasElseStorage()` is `IfStmtBits.HasElse`, one bit of the bitfield union every
        # `Stmt` shares. A `WhileStmt` keeps a flag of its own in that word and never writes
        # that bit, so here the guard reads clear and clang fabricates an empty location rather
        # than dereferencing a trailing object the smaller `WhileStmt` allocation does not own.
        raw_else = CC.LibClangEx.clang_IfStmt_getElseLoc(CXIfStmt(whs.ptr))
        forced_else = CC.source_location(I, CC.SourceLocation(raw_else))
        println("  forcing getElseLoc onto the while loop anyway:")
        println("       -> line ", forced_else.line, ", column ", forced_else.column,
                "   an `else` keyword clang never parsed")
        println()
        wrapped("An invalid location reports no failure. It is the ordinary value meaning " *
                "\"no such token\", indistinguishable from the one a genuinely absent `else` " *
                "produces, and a caller that asked where the `else` is has simply been told " *
                "something untrue. Which bit gets read is a layout accident, so the same call " *
                "on a different pair of classes can just as easily return a plausible line and " *
                "column. The MethodError costs one dispatch and removes the question.",
                indent="  ", width=86)
        println()
        # Back to the `getWhileLoc` refusal, and its candidate list: `AbstractDoStmt` is
        # offered too, because `do { } while (…);` really does have a `while` keyword and clang
        # really does declare the method on both. The layer mirrors clang's API surface; it
        # does not invent a stricter one. Where clang shares a method, so does this.
        println("  and where clang shares a member, dispatch shares it too:")
        println("       getCond(::IfStmt)    -> ", nameof(typeof(CC.resolve(CC.getCond(ifs)))))
        println("       getCond(::WhileStmt) -> ", nameof(typeof(CC.resolve(CC.getCond(whs)))))
        println()
        wrapped("The signature is the check. There is no `if kind == …` anywhere in the " *
                "wrapper and nothing to pay at runtime: Julia picked the method by type, and " *
                "for the two refusals above no method exists that would have accepted the " *
                "argument at all.", indent="  ", width=86)

        # ============================================================================
        banner("§2  A carrier cannot be built from a foreign handle")
        # ============================================================================
        #
        # Dispatch covers the calls you write. It does not cover the calls you *construct*:
        # `IfStmt(p)` takes any `p` and converts. And `Ptr` is Julia's most permissive type
        # — `convert(Ptr{A}, ::Ptr{B})` bitcasts between any two pointer types without
        # looking, by design, because that is what a C pointer means.
        #
        # That single permissiveness was the whole hole, and it had four doors. All four
        # bottom out in `convert` or `unsafe_convert` on `Ptr`, so two methods in
        # `handles.jl` — one per conversion — close all four at once, rather than a rule
        # every call site has to remember. (A third method, in §3, covers the one route into
        # the same hole that is not a pointer at all.)
        #
        # `CXDecl(C_NULL)` below is a null handle *of a named class* — a `Decl *`, in C++
        # terms. Its value is harmless; its type is the point.
        foreign = CXDecl(C_NULL)

        refused("door 1 — the carrier constructor: IfStmt(::Ptr{CXDeclImpl})",
                () -> CC.IfStmt(foreign))
        println()
        refused("door 2 — a ccall argument: clang_WhileStmt_getCond(if_handle)",
                () -> CC.LibClangEx.clang_WhileStmt_getCond(ifs.ptr))
        println()
        refused("door 3 — an out-parameter cell: Ref{CXWhileStmt}(if_handle)",
                () -> Ref{CXWhileStmt}(ifs.ptr))
        println()
        refused("door 4 — an array slot: Vector{CXWhileStmt}[1] = if_handle",
                () -> (v = Vector{CXWhileStmt}(undef, 1); v[1] = ifs.ptr; v))
        println()
        wrapped("Door 2 is the one worth dwelling on. `clang_WhileStmt_getCond` is a raw " *
                "binding — the layer with no type safety of its own, a bare ccall. It is " *
                "still unreachable with an IfStmt, because a ccall argument is marshalled " *
                "through `unsafe_convert`, and that is one of the three methods handles.jl " *
                "defines.", indent="  ", width=86)
        println()
        # And that door is worth forcing open once, because what comes through it is the
        # reason the whole layer exists. `WhileStmt::getCond()` returns
        # `getTrailingObjects<Stmt *>()[condOffset()]`, and `condOffset()` counts the optional
        # trailing objects a *while loop* would be carrying. An `IfStmt` counts different ones
        # — an init-statement and a condition variable, either of which shifts its condition
        # one slot further along. So whether the misdirected call happens to be right is a
        # property of the particular `if`:
        ifs2 = first_node(CC.IfStmt, body_of(I, "geom::lowest_set_bit"))
        got = String[]
        println("  clang_WhileStmt_getCond, forced onto two different `if` statements:")
        for (label, node) in (("if (n < 0)", ifs), ("if (int m = n & -n; m != 0)", ifs2))
            forced = CC.Expr_(CC.LibClangEx.clang_WhileStmt_getCond(CXWhileStmt(node.ptr)))
            push!(got, string(nameof(typeof(CC.resolve(forced)))))
            println("       ", rpad(label, 28), "-> ", rpad(got[end], 16),
                    addr(forced) == addr(CC.getCond(node)) ? "the true condition, by accident" :
                    "not the condition at all")
        end
        println()
        wrapped("Read the first line, then the second. The `if` with no init-statement and no " *
                "condition variable puts its condition in the slot a `WhileStmt` reads, so the " *
                "misdirected call returns the right node and every test written against it " *
                "passes. Add the init-statement and the same call hands back a $(got[end]) " *
                "instead — through a return type declared `CXExpr`, so the carrier built from " *
                "it would announce itself as an expression and every `Expr` method would " *
                "dispatch on it happily. That is the failure the ArgumentError above replaces: " *
                "not a crash, but a wrong node with a confident type on it.",
                indent="  ", width=86)

        # ============================================================================
        banner("§3  An integer is not a handle — and C_NULL still is")
        # ============================================================================
        #
        # Base converts `Int`/`UInt` to any pointer type, which is the one non-pointer route
        # into the same hole: an address printed by a debugger, a value round-tripped
        # through an integer variable, a hand-computed offset. `handles.jl`
        # out-specialises exactly that method for CX handles.
        #
        # The integer below is not a made-up address. It is the *correct* one — the very
        # `IfStmt` from §0, with its type thrown away. The layer still refuses it, and that
        # is the right call: what a handle type records is not that an address is valid but
        # which clang class produced it, and an integer has forgotten that.
        refused("IfStmt(UInt(if_handle)) — the right address, minus its provenance",
                () -> CC.IfStmt(UInt(ifs.ptr)))
        println()
        # But the layer is precise, not blunt. `Ptr{Cvoid}` is deliberately left alone: it is
        # not a CX handle, it is what `C_NULL` is, and a null carrier is a legal value
        # everywhere in this package — it is how clang says "no such node", and what
        # `@check_ptrs` tests for at the top of every wrapper.
        allowed("IfStmt(C_NULL) — the absent node is still expressible",
                () -> (n = CC.IfStmt(C_NULL); "$(nameof(typeof(n))), is_null_handle = " *
                                              "$(CC.is_null_handle(n))"))

        # ============================================================================
        banner("§4  The crossings that ARE legal, and why")
        # ============================================================================
        #
        # A layer that refused every crossing would be unusable: clang's hierarchies exist
        # to be walked up and down. Both directions are one spelling — the carrier's own
        # constructor — and neither is ever a bare reinterpretation.
        #
        # Widening first. In C++ this is written nothing at all: a `IfStmt *` converts to a
        # `Stmt *` implicitly, and it is sound because these hierarchies are singly inherited,
        # so the base subobject shares its address with the object. Here is that measured
        # rather than asserted:
        as_stmt = CC.Stmt(ifs)
        println("  Stmt(if_stmt)")
        println("       IfStmt  @ ", addr(ifs))
        println("       Stmt    @ ", addr(as_stmt), "     delta = ", delta(as_stmt, ifs), " bytes")
        println()
        # And the widening is usually not written here either — a wrapper declared on
        # `AbstractStmt` accepts an `IfStmt` directly, because marshalling is keyed on the
        # abstract types rather than per carrier. What the base carrier costs you is the same
        # thing it costs in C++: with the static type at the base, the derived methods are gone.
        allowed("getBeginLoc(if_stmt) — no widening written, the Stmt-level method applies",
                () -> nameof(typeof(CC.getBeginLoc(ifs))))
        refused("getElseLoc(::Stmt) — the base carrier no longer names an IfStmt",
                () -> CC.getElseLoc(as_stmt))
        println()
        # Narrowing is C++'s `cast<T>`, and it is checked: the shim runs clang's own `classof`
        # through `dyn_cast_or_null`, so the carrier that comes back cannot be lying about its
        # pointee. This is the whole of the difference from a `reinterpret_cast` — the cast
        # asks clang, every time, and costs one ccall.
        back = CC.IfStmt(as_stmt)
        println("  IfStmt(as_stmt) -> ", nameof(typeof(back)),
                "   same address: ", addr(back) == addr(ifs))
        # Ask for a class the node is not and it says so, naming both:
        refused("WhileStmt(as_stmt) — this node is an if, not a while",
                () -> CC.WhileStmt(as_stmt))
        println()
        # The predicate beside it is `isa<T>`, for when you want the question without the
        # exception; and `resolve` asks clang which class it is rather than proposing one.
        println("  isIfStmt(as_stmt)         -> ", CC.isIfStmt(as_stmt))
        println("  isWhileStmt(as_stmt)      -> ", CC.isWhileStmt(as_stmt))
        println("  resolve(as_stmt)          -> ", nameof(typeof(CC.resolve(as_stmt))),
                "   (clang was asked; nothing was proposed)")
        println()
        # Most code should need none of the three. `resolve` hands back the concrete carrier,
        # and from there Julia's own subtype relation IS the cast — against the *abstract*
        # type, which is where clang's hierarchy lives. A carrier is a leaf: `CXXMethodDecl`
        # is not a subtype of `FunctionDecl`, but both are `AbstractFunctionDecl`, exactly as
        # `dyn_cast<FunctionDecl>` accepts both.
        wrapped("resolve(x) isa AbstractIfStmt  is  isa<IfStmt>(x)  — no ccall, no API. " *
                "x::AbstractIfStmt  is  cast<IfStmt>(x), and raises on a mismatch. Better " *
                "still, write the method: a function declared on AbstractIfStmt is reached " *
                "by dispatch, and the check happens before the call rather than inside it.",
                indent="  ", width=86)

        # ============================================================================
        banner("§5  The exception: a Decl that is also a DeclContext")
        # ============================================================================
        #
        # §4's "the base is at the same address" is true of clang's AST hierarchies and
        # false of the one place they stop being a hierarchy. A namespace is declared
        #
        #     class NamespaceDecl : public NamedDecl, public DeclContext
        #
        # so `Decl` and `DeclContext` are not base and derived at all — they are *sibling*
        # bases of every concrete declaration that is also a scope. Converting between them
        # is a cross-cast: down to the most-derived type, then back up the other base. That
        # is why `Decl::castToDeclContext` is a switch over `getKind()`, and why the offset
        # it applies is not a constant. Measured on this very translation unit:
        ns_dc = CC.castToDeclContext(ns)     # NamespaceDecl -> DeclContext
        pt_dc = CC.castToDeclContext(pt)     # CXXRecordDecl -> DeclContext

        println("  NamespaceDecl  @ ", addr(ns), "  ->  DeclContext @ ", addr(ns_dc),
                "   delta = +", delta(ns_dc, ns))
        println("  CXXRecordDecl  @ ", addr(pt), "  ->  DeclContext @ ", addr(pt_dc),
                "   delta = +", delta(pt_dc, pt))
        println()
        wrapped("One cast, one program, two offsets: +$(delta(ns_dc, ns)) and " *
                "+$(delta(pt_dc, pt)). `NamedDecl` precedes `DeclContext` in a NamespaceDecl, " *
                "`TypeDecl` precedes it in a TagDecl, and the two bases are not the same size. " *
                "Compare that with §4, where widening an IfStmt to its Stmt base moved the " *
                "pointer by $(delta(as_stmt, ifs)). A layer that reused the raw pointer here " *
                "would be wrong by that many bytes and would never mention it.",
                indent="  ", width=86)
        println()

        # So this package models the two bases as *disjoint* Julia hierarchies: no carrier
        # subtypes both, and the raw crossing is refused like any other.
        refused("DeclContext(namespace_decl.ptr) — reusing the pointer is not allowed",
                () -> CC.DeclContext(ns.ptr))
        println()

        # What replaces it is `AnyDeclContext`: the union of `DeclContext` with exactly the
        # declarations clang marks DECL_CONTEXT in DeclNodes.inc. It is the type nearly every
        # `DeclContext` parameter in this package carries, and the marshalling method behind
        # it is the single one in the package that does not reinterpret — it calls the pivot
        # as the argument is converted. So the declaration itself can be passed where C++
        # would pass `NamespaceDecl *` to a `DeclContext *` parameter, and no call site that
        # hands over the carrier can forget the cast.
        #
        # "Nearly" every: a name clang declares on *both* `Decl` and `DeclContext` is
        # ambiguous over the union and keeps the narrow type. `getDeclKindName` below is that
        # case, and it is a call that needs qualifying in C++ too — which is why it is spelled
        # here against `ns_dc` and not against `ns`.
        println("  isNamespace(ns)                     = ", CC.isNamespace(ns),
                "    (the NamespaceDecl, pivoted on the way in)")
        println("  isNamespace(castToDeclContext(ns))  = ", CC.isNamespace(ns_dc),
                "    (the DeclContext, spelled out)")
        println("  isRecord(pt)                        = ", CC.isRecord(pt))
        println("  getDeclKindName(ns_dc)              = ", CC.getDeclKindName(ns_dc))
        println()

        # And here is the bug that shape prevents, reproduced deliberately — with the same
        # spelling §1 and §2 used, naming the target handle type outright. `CXDeclContext(p)`
        # is Julia's own `Ptr{T}(::Ptr)` constructor, which bitcasts by definition. You cannot
        # reach it by accident (you had to write the class you were asserting), and it is the
        # mechanism the checked casts in §4 are built from. Used wrongly, it is precisely the
        # old `void *` behaviour:
        forced = CC.DeclContext(CXDeclContext(ns.ptr))   # the pivot skipped; off by the delta above
        println("  forcing the crossing anyway, with the pivot skipped:")
        println("       isNamespace       = ", rpad(CC.isNamespace(forced), 7),
                "clang, asked properly, says ", CC.isNamespace(ns_dc))
        println("       isTranslationUnit = ", rpad(CC.isTranslationUnit(forced), 7),
                "clang, asked properly, says ", CC.isTranslationUnit(ns_dc))
        println()
        wrapped("No crash, no null, no diagnostic. `DeclContext` keeps its class tag in a " *
                "bitfield at its own offset 0, so reading it $(delta(ns_dc, ns)) bytes early " *
                "lands elsewhere inside the live NamespaceDecl and returns whatever is there. " *
                "Every predicate downstream then answers about a class this node never had, " *
                "and answers confidently. That is the failure mode typed handles remove — and " *
                "note that it failed *uniformly*, which was the only lucky part: `DeclContext` " *
                "is never the first base of any class in the Decl headers, so passing the " *
                "most-derived pointer instead would not have rescued a single call site.",
                indent="  ", width=86)

        # ============================================================================
        banner("The argument, in one paragraph")
        # ============================================================================
        wrapped("The C shim asserts and never checks — that is not a defect to be fixed but " *
                "the only thing C can do, and paying for a check per node would be paying it " *
                "on every traversal in every program. So the class discipline lives in Julia, " *
                "where it costs nothing at runtime: one handle type per clang class, three " *
                "conversion methods that refuse a mismatch, dispatch that admits only the " *
                "classes a method is declared on, and one checked cast per class for the " *
                "crossings that are genuinely intended. What used to be a silent wrong answer " *
                "is an exception with both class names in it, thrown before anything reaches " *
                "the shim — and most walks never write a cast at all, because `resolve` plus " *
                "dispatch on the abstract types is the same question asked for free.",
                indent="  ", width=86)
        println()
    finally
        # Create -> use -> dispose. The interpreter owns the ASTContext every carrier above
        # points into; each one is a borrowed pointer with no lifetime of its own, so nothing
        # printed above may be touched after this line.
        CC.dispose(I)
    end
    return nothing
end

main()
