# =====================================================================================
# 02 — A tour of the Clang AST
#
# Clang does not hand you a parse tree of text. It hands you the *semantic* tree it
# built while type-checking: names are already resolved, overloads already picked,
# implicit conversions already materialised as real nodes. Anything you could ask the
# compiler, you can ask this tree.
#
# This example walks from source text down to individual nodes and back out again:
#
#   1. translation_unit            the root every declaration hangs from
#   2. top_level_decls             what the file declares at its outermost scope
#   3. resolve                     a base-typed handle -> the class clang actually built
#   4. decls_in + castToDeclContext   descend one scope at a time
#   5. find_decl                   jump straight to "geom::total_norm"
#   6. children vs subtree         one level down vs the whole subtree
#   7. a node histogram            what a function is really made of
#   8. every call site             matching on an abstract supertype
#   9. every local and its type    DeclStmt -> VarDecl -> QualType
#  10. dump_ast                    clang's own rendering of the nodes you just walked
#
# Source locations appear throughout, so the printed line numbers refer to the listing
# in step 0.
#
# The lesson: the entire AST is reachable, and every node arrives as its concrete Julia
# type, so an analysis is `isa` plus a walk.
#
# Run with:  julia --project examples/02_ast_tour.jl
# =====================================================================================

using ClangCompiler
using ClangCompiler: create_interpreter, dispose
import ClangCompiler as CC

rule(title) = println("\n", "─"^86, "\n  ", title, "\n", "─"^86)

# Carriers print as `ClangCompiler.ForStmt`; in a table the module prefix is noise.
tyname(x) = string(nameof(typeof(x)))

# The C++ we will study. Small, but with one of everything an AST walker meets: a
# namespace, a class with data members and a member function, control flow (if / for /
# ternary), a member call, an array subscript and a return.
const SOURCE = """
namespace geom {

struct Point {
    double x;
    double y;
    double norm2() const { return x * x + y * y; }
};

int clamp(int v, int lo, int hi) {
    if (v < lo) {
        return lo;
    }
    return v > hi ? hi : v;
}

double total_norm(const Point *pts, int n) {
    double acc = 0.0;
    for (int i = 0; i < n; ++i) {
        acc += pts[i].norm2();
    }
    return acc;
}

}  // namespace geom

int entry_point(int v) { return geom::clamp(v, 0, 10); }
"""

# `create_interpreter` spins up a full Clang instance in-process: driver, preprocessor,
# Sema, CodeGen and a JIT. Parsing through it means the AST walked below is the same one
# the compiler would emit code from — not a lookalike built by a separate parser.
I = create_interpreter(String[])

try
    # `parse` runs the front end over the text — preprocess, parse, type-check — and adds
    # what it built to the one translation unit this interpreter keeps. Diagnostics go to
    # stderr and a rejected input comes back as a *null* partial translation unit; nothing
    # is thrown, so code that cares tests the handle, as this does.
    ptu = CC.parse(I, SOURCE)
    ptu.ptr == C_NULL && error("the snippet under study did not parse")

    # ================================================================================
    rule("0. The source under study (line numbers are what clang will report)")
    # ================================================================================
    for (i, line) in enumerate(split(rstrip(SOURCE), '\n'))
        println("  ", lpad(i, 3), " │ ", line)
    end

    # ================================================================================
    rule("1. The translation unit: the root every declaration hangs from")
    # ================================================================================
    # `clang::TranslationUnitDecl` is both a Decl and a DeclContext — a declaration that
    # *contains* declarations. It is the implicit outermost scope of the file.
    tu = CC.translation_unit(I)
    println("  translation unit  : ", tyname(tu))
    println("  clang's kind name : ", CC.getDeclKindName(tu))

    # `decls` flattens every nested context under it — namespace members, class members,
    # locals, the lot. Bulk-extracted in two FFI calls, however large the tree is.
    all_decls = CC.decls(CC.castToDeclContext(tu))
    println("  declarations below it, recursively: ", length(all_decls))

    # ================================================================================
    rule("2. top_level_decls: what the file declares at its outermost scope")
    # ================================================================================
    # Direct children only, so a namespace comes back as a single NamespaceDecl — its
    # contents are one level further down, which is what step 4 descends into.
    #
    # Look at the second column: each element is *already* the concrete Julia carrier for
    # the class clang built. `NamespaceDecl`, not a generic `Decl`.
    for d in CC.top_level_decls(I)
        name = d isa CC.AbstractNamedDecl ? CC.getName(d) : "<unnamed>"
        println("    ", rpad(name, 14), rpad(tyname(d), 18),
                "line ", CC.source_location(I, d).line)
    end

    # ================================================================================
    rule("3. resolve: turning a base-typed handle into the class clang actually built")
    # ================================================================================
    # Clang's C++ accessors are declared with the statically known return type, which is
    # usually a base: `FunctionDecl::getBody()` returns `Stmt *`, because a body need not be
    # a `CompoundStmt` — write a function-try-block (`int f() try {...} catch (...) {...}`)
    # and the body is a `CXXTryStmt`. The wrapper stays faithful to that, so the carrier you
    # get back is a `Stmt` — and `isa CompoundStmt` is then false, not because the node is
    # anything else but because nobody has asked yet.
    #
    # `resolve` asks: it reads the node's `getStmtClass()` (or `getKind()` for a Decl) and
    # re-wraps the same pointer in the matching Julia type. Same address, real type.
    clamp_fd = CC.find_decl(I, "geom::clamp")
    raw_body = CC.getBody(clamp_fd)
    body = CC.resolve(raw_body)

    println("    getBody(clamp) -> ", rpad(tyname(raw_body), 14),
            "  isa CompoundStmt = ", raw_body isa CC.CompoundStmt)
    println("    resolve(...)   -> ", rpad(tyname(body), 14),
            "  isa CompoundStmt = ", body isa CC.CompoundStmt)
    println("    same node?        ", raw_body.ptr == body.ptr,
            "  (resolve re-wraps a pointer, it does not follow one)")
    println()
    println("  The traversal helpers — top_level_decls, decls_in, children, subtree,")
    println("  find_decl — all resolve for you. This is the one place the seam shows.")

    # ================================================================================
    rule("4. Descending a scope: decls_in + castToDeclContext")
    # ================================================================================
    # In Clang a namespace or class declaration inherits *two* independent bases: a
    # `Decl` (something declared) and a `DeclContext` (something that declares). Neither
    # derives from the other — they are sibling bases — so the two subobjects sit at
    # different offsets, and the offset differs from class to class, which is why
    # `Decl::castToDeclContext` is a switch over the decl's kind rather than a constant
    # adjustment. You cannot reinterpret one as the other; `castToDeclContext` performs the
    # real pivot, which is why descending a scope always goes through it.
    ns = CC.find_decl(I, "geom")
    println("  geom is a ", tyname(ns), ", and as a DeclContext it holds:")
    for d in CC.decls_in(CC.castToDeclContext(ns))
        name = d isa CC.AbstractNamedDecl ? CC.getName(d) : "<unnamed>"
        println("    ", rpad(name, 14), tyname(d))
    end

    # One scope further, into the class. A record keeps one decl list like any other
    # context: clang's `fields()` and `methods()` are filtered views over it, not separate
    # storage, so `decls_in` on the class would show the same members interleaved — plus
    # the injected-class-name, the implicit `Point` C++ inserts into the class's own scope
    # so the class can name itself from inside.
    point = CC.find_decl(I, "geom::Point")
    println("\n  geom::Point is a ", tyname(point), ", whose members are:")
    for f in CC.getFields(point)
        # A field's type is a QualType: the type together with its cv-qualifiers.
        println("    field   ", rpad(CC.getName(f), 8), CC.getAsString(CC.getType(f)))
    end
    for m in CC.getMethods(point)
        # `getType` on a function gives its *function type*; clang prints the whole
        # signature, the trailing `const` included. The empty parameter list comes out
        # `(void)` because `QualType::getAsString()` prints under a default PrintingPolicy,
        # which is a C one; `printAsString(qt, ctx)` uses this translation unit's own policy
        # and spells the same type `double () const`.
        println("    method  ", rpad(CC.getName(m), 8), CC.getAsString(CC.getType(m)))
    end

    # ================================================================================
    rule("5. find_decl: skipping the walk entirely")
    # ================================================================================
    # `find_decl` runs a real C++ name lookup — the same one the compiler performs for a
    # qualified-id — so nested names work and the result comes back already resolved.
    fd = CC.find_decl(I, "geom::total_norm")
    loc = CC.source_location(I, fd)
    println("    find_decl(I, \"geom::total_norm\")")
    println("      -> ", tyname(fd), ", qualified name ", CC.getQualifiedNameAsString(fd))
    println("      signature : ", CC.getAsString(CC.getType(fd)))
    println("      declared  : ", loc.file, ":", loc.line, ":", loc.column)
    println("      parameters: ", CC.getNumParams(fd))
    println()
    # The buffer name rather than a path: text handed to `parse` has no file behind it.
    println("  `file` above is the name clang gave the in-memory buffer, not a path —")
    println("  this source was never on disk.")
    println()
    println("  A name that is not there comes back as nothing, so it is testable:")
    println("    find_decl(I, \"geom::no_such_thing\") -> ",
            repr(CC.find_decl(I, "geom::no_such_thing")))

    # ================================================================================
    rule("6. children vs subtree: one level down, or all of it")
    # ================================================================================
    fn_body = CC.resolve(CC.getBody(fd))

    # `children` is the direct-children view: exactly the sub-statements clang lists for
    # this one node, resolved, with null slots (a missing `else`, say) dropped.
    kids = CC.children(fn_body)

    # `subtree` is the whole subtree in pre-order, the node itself first. It is
    # bulk-extracted in a single pair of FFI calls, so it costs the same two round trips
    # whether the function has ten nodes or ten thousand.
    whole = CC.subtree(fn_body)

    println("  the body of geom::total_norm is a ", tyname(fn_body))
    println("    children(body) = ", length(kids), " nodes   (one level down)")
    println("    subtree(body)  = ", length(whole), " nodes   (everything, pre-order)")
    println()
    println("  children(body) — the three statements the body is written as:")
    for (i, c) in enumerate(kids)
        println("    ", i, ". ", rpad(tyname(c), 16), "line ",
                CC.source_location(I, c).line, "   subtree = ",
                length(CC.subtree(c)), " nodes")
    end
    # A tree really is a tree: the parent plus its children's subtrees is the whole thing.
    println("    1 + ", join([string(length(CC.subtree(c))) for c in kids], " + "),
            " = ", 1 + sum(length(CC.subtree(c)) for c in kids),
            "  == subtree(body) = ", length(whole))
    println()
    println("  subtree(body) — the same nodes flattened, pre-order, first 10 of ",
            length(whole), ":")
    for (i, n) in enumerate(whole[1:10])
        println("    ", lpad(i, 2), ". ", CC.getStmtClassName(n))
    end

    # ================================================================================
    rule("7. Analysis 1: what is this function actually made of?")
    # ================================================================================
    # A histogram over `subtree` is the shape of many real static-analysis passes: one
    # flat walk, one dictionary. The nodes are already typed, so nothing here needs a
    # string compare — the class name is tallied only because it is what a human reads.
    hist = Dict{String,Int}()
    for n in whole
        hist[CC.getStmtClassName(n)] = get(hist, CC.getStmtClassName(n), 0) + 1
    end
    for (k, v) in sort!(collect(hist); by=x -> (-x[2], x[1]))
        println("    ", lpad(v, 3), "  ", k)
    end
    println()
    println("  Nothing in the source text says \"cast\", yet clang built ",
            get(hist, "ImplicitCastExpr", 0), " ImplicitCastExpr nodes")
    println("  while type-checking. Each one names the conversion it stands for, and clang")
    println("  will say which — the same name the dump in step 10 prints in angle brackets:")
    # `getCastKindName` is declared on CastExpr, so it reaches every cast node, written or
    # implicit. An lvalue-to-rvalue cast is the read of a variable's value that C++ leaves
    # unwritten: `i` and `n` in the loop condition, `pts` and `i` in `pts[i]`, `acc` in the
    # return. The `.norm2()` call needs none — a member call binds to the object, not to its
    # value — and neither does the left of `acc += ...`, which stays an lvalue.
    ckinds = Dict{String,Int}()
    for n in whole
        n isa CC.AbstractCastExpr || continue
        ckinds[CC.getCastKindName(n)] = get(ckinds, CC.getCastKindName(n), 0) + 1
    end
    for (k, v) in sort!(collect(ckinds); by=x -> (-x[2], x[1]))
        println("    ", lpad(v, 3), "  <", k, ">")
    end
    println()
    println("  `acc += ...` is a CompoundAssignOperator, a class clang derives from")
    println("  BinaryOperator to hold the computation type an `op=` needs. The carriers")
    println("  mirror that: `isa AbstractBinaryOperator` — the filter this loop ran —")
    println("  matches the class and everything under it, `isa BinaryOperator` only itself:")
    for n in whole
        n isa CC.AbstractBinaryOperator || continue
        println("    ", rpad(CC.getStmtClassName(n), 24), " isa BinaryOperator = ",
                n isa CC.BinaryOperator)
    end
    println()
    println("  The AST records the semantics, not the spelling.")

    # ================================================================================
    rule("8. Analysis 2: every call site, with the callee clang resolved it to")
    # ================================================================================
    # `CXXMemberCallExpr` derives from `CallExpr` in Clang, and the Julia carriers mirror
    # that hierarchy: both are `<: AbstractCallExpr`. Matching on the abstract supertype
    # catches the whole family — precisely what C++ code spelling
    # `if (auto *ce = dyn_cast<CallExpr>(s))` is doing.
    println("    ln:col  caller            call node          callee              resolve")
    for fname in ("geom::clamp", "geom::total_norm", "entry_point")
        f = CC.find_decl(I, fname)
        for n in CC.subtree(CC.resolve(CC.getBody(f)))
            n isa CC.AbstractCallExpr || continue
            callee = CC.getDirectCallee(n)   # null for a call through a function pointer
            callee.ptr == C_NULL && continue
            at = CC.source_location(I, n)
            println("    ", rpad(string(at.line, ":", at.column), 8), rpad(fname, 18),
                    rpad(tyname(n), 19), rpad(CC.getQualifiedNameAsString(callee), 20),
                    tyname(CC.resolve(callee)))
        end
    end
    println()
    println("  Two node classes, one uniform answer. `CallExpr::getDirectCallee` is declared")
    println("  to return `FunctionDecl *`, so both callees arrive at that base — the last")
    println("  column is what `resolve` then makes of them — and the qualified name is the")
    println("  one clang resolved to: `geom::Point::norm2`, though the call site only ever")
    println("  wrote `.norm2()`.")

    # ================================================================================
    rule("9. Analysis 3: every local variable and the type clang gave it")
    # ================================================================================
    # A local declaration appears inside a body as a `DeclStmt` wrapping one or more
    # `VarDecl`s. `for (int i = ...)` puts its induction variable in a DeclStmt too, which
    # is why a plain walk finds loop variables with no special case for loops.
    for fname in ("geom::clamp", "geom::total_norm")
        f = CC.find_decl(I, fname)
        println("  ", fname, ":")
        found = 0
        for n in CC.subtree(CC.resolve(CC.getBody(f)))
            n isa CC.DeclStmt || continue
            for d in CC.getDecls(n)
                vd = CC.resolve(d)          # a DeclStmt hands out base-typed Decls
                vd isa CC.VarDecl || continue
                found += 1
                println("      local  ", rpad(CC.getName(vd), 6), ": ",
                        rpad(CC.getAsString(CC.getType(vd)), 16),
                        "line ", CC.source_location(I, vd).line)
            end
        end
        found == 0 && println("      local  (none — this function declares no variables)")
        # Parameters are not statements: clang hangs them off the FunctionDecl itself, so no
        # DeclStmt in the body ever mentions them and `getParamDecl` is the only way in.
        for i in 0:(CC.getNumParams(f) - 1)
            p = CC.getParamDecl(f, i)
            println("      param  ", rpad(CC.getName(p), 6), ": ",
                    CC.getAsString(CC.getType(p)))
        end
    end

    # ================================================================================
    rule("10. dump_ast: clang's own rendering of a node you just walked")
    # ================================================================================
    # Everything above was reached from Julia. `dump_ast` hands the same subtree to clang
    # to print, the way `clang -Xclang -ast-dump` would. Read the two renderings side by
    # side: the class names are identical, because they *are* the same nodes.
    ret = last(CC.children(CC.resolve(CC.getBody(clamp_fd))))
    # The text is sliced out of SOURCE by the line clang reported, not retyped here, so the
    # statement shown is the one the node actually came from.
    ret_line = CC.source_location(I, ret).line
    println("  the last statement of geom::clamp is a ", tyname(ret), " on line ", ret_line,
            ":  ", strip(split(rstrip(SOURCE), '\n')[ret_line]), "\n")

    println("  walked from Julia with children(), one level at a time:")
    function show_tree(n, depth=0)
        println("    ", "  "^depth, CC.getStmtClassName(n))
        for c in CC.children(n)
            show_tree(c, depth + 1)
        end
        return nothing
    end
    show_tree(ret)

    println("\n  the same node, dumped by clang itself:")
    flush(stdout)
    CC.dump_ast(ret)
    flush(stdout)

    println()
    println("  Node for node, the two trees are the same shape — the walk above visited")
    println("  exactly what clang printed. What the dump adds is per-node detail the")
    println("  accessors will also give you: each expression's type, the cast kind")
    println("  (<LValueToRValue>), the value category, and the ParmVar each name binds to.")

    println("\n", "─"^86)
    println("  Every node above arrived as a concrete Julia type — CompoundStmt, ForStmt,")
    println("  CXXMemberCallExpr, VarDecl — so an analysis is `isa` plus a walk, and the")
    println("  abstract supertypes mirror clang's own class hierarchy for the rest.")
    println("─"^86)
finally
    # Create -> use -> dispose. The interpreter owns the LLVM context, the JIT and the
    # whole AST; every carrier printed above is a borrowed pointer into it, and none of
    # them outlives this call.
    dispose(I)
end
