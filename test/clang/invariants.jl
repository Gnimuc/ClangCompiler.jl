using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

# Relationships that must hold over every node of any AST, whatever the values are.
#
# Pinning an observed value catches a regression away from what the shim returns today; it
# says nothing about whether today's answer is right, and it cannot separate two results of
# the same type. An accessor handing back a sibling member -- getBeginLoc returning the end
# location, getLHS returning the right operand -- passes every null check and every `isa`.
# These assertions are what does separate them, and none of them depends on the host: they
# are statements about clang's own model, not about a target.
#
# `.claude/skills/suite-audit/mutants.jl` is the acceptance test. Each testset below names the mutant it kills.

const INV_SRC = """
struct InvB { int b; virtual ~InvB() {} };
struct InvD : InvB { int d; };

int inv_add(int a, int b, int c) { return a + b * c - a; }

int inv_driver(int p, int q) {
    int r = inv_add(p, q, p + q);
    int s = (p < q) ? p * 2 : q - 3;
    for (int i = 0; i < 4; ++i) { r += i * s; }
    InvD obj;
    obj.d = r;
    InvB *bp = &obj;
    return r + s + obj.b + bp->b;
}
"""

# Every Stmt in the translation unit, resolved to its concrete carrier.
function inv_nodes(I)
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    out = CC.AbstractStmt[]
    for d in CC.decls(tu)
        d isa CC.AbstractFunctionDecl || continue
        body = CC.getBody(d)
        CC.is_null_handle(body) && continue
        append!(out, CC.subtree(body))
    end
    return out
end

@testset "AST invariants" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, INV_SRC)
    sm = CC.getSourceManager(CC.get_sema(I))
    nodes = inv_nodes(I)
    @test length(nodes) > 40          # the walk really reached the bodies

    @testset "a node's range runs forward and contains its children's" begin
        # Ordering alone is too weak to pin the two ends apart: an accessor that returns the
        # end location for both still satisfies "end is not before begin". Containment is
        # what separates them -- a parent's range spans every child's, so reporting the end
        # as the beginning puts the parent's start after its first child's.
        ok(loc) = CC.isValid(loc) && CC.isFileID(loc)
        ordered = contained = 0
        for n in nodes
            b, e = CC.getBeginLoc(n), CC.getEndLoc(n)
            (ok(b) && ok(e)) || continue
            @test !CC.isBeforeInTranslationUnit(sm, e, b)
            ordered += 1
            for k in CC.children(n)
                kb, ke = CC.getBeginLoc(k), CC.getEndLoc(k)
                (ok(kb) && ok(ke)) || continue
                @test !CC.isBeforeInTranslationUnit(sm, kb, b)   # parent starts no later
                @test !CC.isBeforeInTranslationUnit(sm, e, ke)   # and ends no earlier
                contained += 1
            end
        end
        @test ordered > 40
        @test contained > 20
    end

    @testset "operand accessors are distinct (kills swap_lhs_rhs)" begin
        bins = filter(n -> n isa CC.AbstractBinaryOperator, nodes)
        @test !isempty(bins)
        for bo in bins
            lhs, rhs = CC.getLHS(bo), CC.getRHS(bo)
            @test !CC.is_null_handle(lhs)
            @test !CC.is_null_handle(rhs)
            # the two operands of a binary operator are different nodes
            @test lhs != rhs
            # and each is a child of the operator, which pins them to this node
            kids = collect(CC.children(bo))
            @test lhs in kids
            @test rhs in kids
        end
    end

    @testset "indexed accessors are injective (kills first_arg_always, off_by_one_arg)" begin
        calls = filter(n -> n isa CC.AbstractCallExpr, nodes)
        @test !isempty(calls)
        multi = 0
        for c in calls
            n = Int(CC.getNumArgs(c))
            # A CallExpr's children are the callee followed by the arguments in order, so
            # argument i is child i+2. Asserting that POSITION, one index at a time, is what
            # catches a shifted index: the mismatch fires at i = 0, before the loop reaches
            # the end and reads past it. Collecting the arguments first and comparing after
            # would instead run off the end and die inside clang, which reports a crash
            # rather than a test failure.
            kids = collect(CC.children(c))
            @test length(kids) == n + 1
            @test CC.getCallee(c).ptr == kids[1].ptr
            for i = 0:(n - 1)
                @test CC.getArg(c, i).ptr == kids[i + 2].ptr
            end
            n > 1 && (multi += 1)
        end
        @test multi > 0               # at least one call has enough arguments to discriminate
    end

    @testset "a typed expression has a type (kills null_qualtype)" begin
        exprs = filter(n -> n isa CC.AbstractExpr, nodes)
        @test !isempty(exprs)
        for e in exprs
            # the sole typeless expression clang builds is an unevaluated string literal,
            # which is what a static_assert message is -- none occurs in this source
            @test !CC.isNull(CC.getType(e))
        end
    end

    @testset "the child relation round-trips" begin
        # every node reached from a body is either that body or some node's child, so a
        # traversal accessor cannot silently invent or drop nodes
        for d in CC.decls(CC.castToDeclContext(CC.getTranslationUnitDecl(CC.getASTContext(CC.get_sema(I)))))
            d isa CC.AbstractFunctionDecl || continue
            body = CC.getBody(d)
            CC.is_null_handle(body) && continue
            # the walk hands back many statement classes; carrier equality is the `Stmt *`
            # clang compares, so a set of them holds nodes rather than handles
            walked = CC.subtree(body)
            reached = Set{CC.AbstractStmt}([body])
            for n in walked, k in CC.children(n)
                push!(reached, k)
            end
            @test all(in(reached), walked)
        end
    end

    dispose(I)
end
