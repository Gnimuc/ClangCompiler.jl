using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

"Run the uninitialized-values analysis over `name` and hand the result to `body`."
function uv_run(body, f, I, name)
    @assert f(I, name)
    fd = CC.getAsFunction(CC.get_decl(f))
    adc = CC.AnalysisDeclContext(fd)
    try
        # The analysis reads variable references out of the CFG's block-level elements, so
        # the CFG has to carry them. clang's own AnalysisBasedWarnings sets this before
        # building; without it the CFG holds whole statements only and the analysis reports
        # no uses at all, however uninitialised the source is.
        CC.setAllAlwaysAdd(CC.getCFGBuildOptions(adc))
        r = CC.UninitVariablesResult(adc)
        try
            body(adc, r)
        finally
            CC.dispose(r)
        end
    finally
        CC.dispose(adc)
    end
end

@testset "Analysis | UninitializedValues" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int uv_always(int c) {
                int y;
                return y;
            }
            int uv_sometimes(int c) {
                int x;
                if (c) { x = 1; }
                return x;
            }
            int uv_clean(int c) {
                int z = 0;
                if (c) { z = 1; }
                return z;
            }
            int uv_self(int c) {
                int w = w;
                return w + c;
            }
            """)

        # a read on every path: the strongest verdict clang has
        uv_run(f, I, "uv_always") do adc, r
            n = Int(CC.getNumUses(r))
            @test n >= 1
            @test CC.getNumVariablesAnalyzed(r) >= 1
            @test CC.getNumBlockVisits(r) >= 1
            @test CC.getNumSelfInits(r) == 0
            names = [CC.getName(CC.getVarDecl(r, i)) for i = 0:(n - 1)]
            @test "y" in names
            i = findfirst(==("y"), names) - 1
            @test CC.getKind(r, i) == CC.LibClangEx.CXUninitUseKind_Always
            # a plain read is not a const-reference use
            @test !CC.isConstRefUse(r, i)
            # the user expression is a read of `y` inside this body
            u = CC.getUser(r, i)
            @test !CC.is_null_handle(u)
            @test CC.resolve(u) isa CC.AbstractExpr
            # `Always` needs no guilty branch to justify it
            @test CC.getNumBranches(r, i) == 0
        end

        # a read on one path only: clang names the branch that makes it happen
        uv_run(f, I, "uv_sometimes") do adc, r
            n = Int(CC.getNumUses(r))
            @test n >= 1
            names = [CC.getName(CC.getVarDecl(r, i)) for i = 0:(n - 1)]
            @test "x" in names
            i = findfirst(==("x"), names) - 1
            k = CC.getKind(r, i)
            @test k == CC.LibClangEx.CXUninitUseKind_Sometimes || k == CC.LibClangEx.CXUninitUseKind_Maybe
            nb = Int(CC.getNumBranches(r, i))
            # getKind reports Sometimes exactly when it has branches to blame, and Maybe
            # exactly when it has none
            if k == CC.LibClangEx.CXUninitUseKind_Sometimes
                @test nb > 0
            else
                @test nb == 0
            end
            for j = 0:(nb - 1)
                t = CC.getBranchTerminator(r, i, j)
                @test !CC.is_null_handle(t)
                @test CC.resolve(t) isa CC.AbstractIfStmt
                # the guilty output is one of the terminator's two successors
                @test CC.getBranchOutput(r, i, j) < 2
            end
        end

        # every path initializes: nothing to report
        uv_run(f, I, "uv_clean") do adc, r
            @test CC.getNumUses(r) == 0
            @test CC.getNumSelfInits(r) == 0
            @test CC.getNumVariablesAnalyzed(r) >= 1
        end

        # `int w = w;` is its own callback, with no UninitUse attached
        uv_run(f, I, "uv_self") do adc, r
            n = Int(CC.getNumSelfInits(r))
            @test n >= 1
            @test "w" in [CC.getName(CC.getSelfInit(r, i)) for i = 0:(n - 1)]
        end

        # the explicit three-argument form reaches the same analysis
        @assert f(I, "uv_always")
        fd = CC.getAsFunction(CC.get_decl(f))
        adc = CC.AnalysisDeclContext(fd)
        try
            # same precondition as uv_run above: the CFG must carry the variable references
            CC.setAllAlwaysAdd(CC.getCFGBuildOptions(adc))
            cfg = CC.getCFG(adc)
            dc = CC.castToDeclContext(CC.getDecl(adc))
            r = CC.UninitVariablesResult(dc, cfg, adc)
            try
                @test CC.getNumUses(r) >= 1
            finally
                CC.dispose(r)
            end
            # the CFG has to be the one this context built
            other = CC.buildCFG(fd, CC.getBody(fd), CC.get_ast_context(I))
            try
                @test_throws AssertionError CC.UninitVariablesResult(dc, other, adc)
            finally
                CC.dispose(other)
            end
        finally
            CC.dispose(adc)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
