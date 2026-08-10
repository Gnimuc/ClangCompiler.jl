using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

"Map local variable name -> VarDecl, read off the DeclStmts the graph carries."
function lv_locals(cfg)
    out = Dict{String,Any}()
    for s in CC.getBlockStmts(cfg)
        ds = CC.resolve(s)
        ds isa CC.AbstractDeclStmt || continue
        for i in 0:(CC.getNumDecls(ds) - 1)
            d = CC.resolve(CC.getDecl(ds, i))
            d isa CC.AbstractVarDecl || continue
            out[CC.getName(d)] = d
        end
    end
    return out
end

@testset "Analysis | LiveVariables" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int lv_fn(int x) {
                int a = x;
                int b = 0;
                if (x > 0) { a = 1; } else { a = 2; }
                return a;
            }
            int lv_no_body(int);
            """)
        @assert f(I, "lv_fn")
        fd = CC.getAsFunction(CC.get_decl(f))

        adc = CC.AnalysisDeclContext(fd)
        try
            # Liveness is computed over the CFG's block-level elements, so the CFG has to
            # carry the DeclRefExprs that read a variable. clang's own AnalysisBasedWarnings
            # does this before building; without it the CFG holds whole statements only and
            # every query below answers "not live" for every variable.
            CC.setAllAlwaysAdd(CC.getCFGBuildOptions(adc))
            cfg = CC.getCFG(adc)
            @test !CC.is_null_handle(cfg)
            blocks = [CC.getBlock(cfg, i) for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)]
            locals = lv_locals(cfg)
            @test haskey(locals, "a")
            @test haskey(locals, "b")
            va = locals["a"]
            vb = locals["b"]

            # exactly one block branches on `x > 0`
            branching = [b for b in blocks if CC.hasTerminator(b)]
            @test length(branching) == 1
            cond = branching[1]

            strict = CC.computeLiveness(adc, true)
            relaxed = CC.computeLiveness(adc, false)
            try
                @test !CC.is_null_handle(strict)
                @test !CC.is_null_handle(relaxed)
                @test strict.ptr != relaxed.ptr

                # both arms assign `a` before anything reads it, so killing at assignment
                # makes `a` dead where the branch is decided and keeping it alive does not
                @test !CC.isLive(strict, cond, va)
                @test CC.isLive(relaxed, cond, va)

                # `a` is read by the return, so it is live at the end of both arms
                @test count(b -> CC.isLive(strict, b, va), blocks) == 2

                # `b` is never read: no flavour of the analysis ever calls it live
                @test !any(b -> CC.isLive(strict, b, vb), blocks)
                @test !any(b -> CC.isLive(relaxed, b, vb), blocks)

                # the function's CompoundStmt is not a block-level statement, so the
                # statement-level queries fall through to the empty liveness set for it
                body = CC.getBody(adc)
                @test !CC.isLive(strict, body, va)
                @test !CC.isLive(strict, body, vb)
                for s in CC.getBlockStmts(cfg)
                    e = CC.resolve(s)
                    e isa CC.AbstractExpr || continue
                    @test !CC.isLive(strict, body, e)
                end

                sm = CC.getSourceManager(CC.get_instance(I))
                dumped = redirect_stderr(devnull) do
                    CC.dumpBlockLiveness(strict, sm) === nothing &&
                        CC.dumpExprLiveness(strict, sm) === nothing
                end
                @test dumped
            finally
                CC.dispose(relaxed)
                CC.dispose(strict)
            end
        finally
            CC.dispose(adc)
        end

        # no body, no CFG, no liveness
        @assert f(I, "lv_no_body")
        nb = CC.getAsFunction(CC.get_decl(f))
        nbc = CC.AnalysisDeclContext(nb)
        try
            lv = CC.computeLiveness(nbc)
            @test CC.is_null_handle(lv)
        finally
            CC.dispose(nbc)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
