using ClangCompiler
import ClangCompiler as CC
using Test

"Every statement of the subtree rooted at `s`, `s` included, skipping NULL slots."
function emu_descendants(s)
    out = CC.Stmt[]
    stack = CC.Stmt[s]
    while !isempty(stack)
        c = pop!(stack)
        CC.is_null_handle(c) && continue
        push!(out, c)
        append!(stack, CC.getChildren(c))
    end
    return out
end

@testset "Analysis | ExprMutationAnalyzer" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            void emu_fn(int a, int b, int *p, const int *q) {
                int local = a;
                b = 3;
                *p = 4;
                (void)q;
                (void)local;
            }
            """)
        @assert f(I, "emu_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        body = CC.getBody(fd)
        @test CC.getNumParams(fd) == 4
        a, b = CC.getParamDecl(fd, 0), CC.getParamDecl(fd, 1)
        p, q = CC.getParamDecl(fd, 2), CC.getParamDecl(fd, 3)

        ema = CC.ExprMutationAnalyzer(body, ctx)
        try
            # `a` is only read, `b` is assigned: the whole point of the analyzer is that
            # it separates these two
            @test !CC.isMutated(ema, a)
            @test CC.isMutated(ema, b)
            @test CC.is_null_handle(CC.findMutation(ema, a))
            mut = CC.findMutation(ema, b)
            @test !CC.is_null_handle(mut)
            # the mutation it points at is inside the body it was built over
            @test mut.ptr in Set(s.ptr for s in emu_descendants(body))

            # `*p = 4` writes through the pointee, not through `p` itself
            @test !CC.isMutated(ema, p)
            @test !CC.isMutated(ema, q)
            # the pointee queries are their own pair of entry points; assert what their
            # contract fixes — `isPointeeMutated` is `findPointeeMutation != nullptr` —
            # rather than an answer, because clang 18 still ships the pointee finder list
            # as a `{/*TODO*/}` stub and reports nothing for either pointer
            for d in (p, q)
                @test CC.isPointeeMutated(ema, d) == !CC.is_null_handle(CC.findPointeeMutation(ema, d))
            end

            # the Expr overloads answer for one reference rather than for the whole
            # declaration, so at least one reference to `b` has to carry the mutation
            refs = [r for r in map(CC.resolve, emu_descendants(body)) if r isa CC.AbstractDeclRefExpr]
            @test !isempty(refs)
            mutated_refs = [r for r in refs if CC.isMutated(ema, r)]
            @test !isempty(mutated_refs)
            @test all(r -> !CC.is_null_handle(CC.findMutation(ema, r)), mutated_refs)
            for r in refs
                @test CC.isPointeeMutated(ema, r) == !CC.is_null_handle(CC.findPointeeMutation(ema, r))
            end
        finally
            CC.dispose(ema)
        end

        # unevaluated operands: the assignment inside `sizeof` never happens, so clang
        # reports the parameter as not mutated even though the source spells `n = 3`
        CC.reset(f)
        CC.parse(I, """
            void emu_unev(int n) { int z = sizeof(n = 3); (void)z; }
            """)
        @assert f(I, "emu_unev")
        ufd = CC.getAsFunction(CC.get_decl(f))
        ubody = CC.getBody(ufd)
        un = CC.getParamDecl(ufd, 0)
        uema = CC.ExprMutationAnalyzer(ubody, ctx)
        try
            @test !CC.isMutated(uema, un)
        finally
            CC.dispose(uema)
        end
        # and the static predicate says the same thing about the subtree, while the body
        # itself is of course evaluated
        @test !CC.isUnevaluated(ubody, ubody, ctx)
        @test any(s -> CC.isUnevaluated(s, ubody, ctx), emu_descendants(ubody))

        # FunctionParmMutationAnalyzer asks the same question one parameter at a time
        fpma = CC.FunctionParmMutationAnalyzer(fd, ctx)
        try
            @test !CC.isMutated(fpma, a)
            @test CC.isMutated(fpma, b)
            @test CC.is_null_handle(CC.findMutation(fpma, a))
            @test !CC.is_null_handle(CC.findMutation(fpma, b))
            # it is a wrapper over the same analysis, so it must agree with the standalone
            # one on every parameter
            for parm in (a, b, p, q)
                @test CC.isMutated(fpma, parm) == (!CC.is_null_handle(CC.findMutation(fpma, parm)))
            end
        finally
            CC.dispose(fpma)
        end

        # a function with no body cannot be analyzed: clang dereferences getBody()
        CC.reset(f)
        CC.parse(I, "void emu_no_body(int k);")
        @assert f(I, "emu_no_body")
        nfd = CC.getAsFunction(CC.get_decl(f))
        @test !CC.hasBody(nfd)
        @test_throws AssertionError CC.FunctionParmMutationAnalyzer(nfd, ctx)
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
