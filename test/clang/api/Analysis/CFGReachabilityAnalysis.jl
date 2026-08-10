using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "Analysis | CFGReachabilityAnalysis" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int cra_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; } else { acc = 2; }
                while (acc < 10) { acc += x; }
                return acc;
            }
            """)
        @assert f(I, "cra_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        ctx = CC.get_ast_context(I)
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx)
        @test cfg.ptr != C_NULL
        try
            entry = CC.getEntry(cfg)
            exit_ = CC.getExit(cfg)
            blocks = [CC.getBlock(cfg, i) for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)]

            a = CC.CFGReverseBlockReachabilityAnalysis(cfg)
            try
                @test CC.isReachable(a, entry, exit_)
                @test !CC.isReachable(a, exit_, entry)

                # the entry has no predecessors, so nothing reaches it -- itself included
                for b in blocks
                    @test !CC.isReachable(a, b, entry)
                end
                # the exit has no successors, so it reaches nothing
                for b in blocks
                    @test !CC.isReachable(a, exit_, b)
                end

                # the whole body is reachable from the entry
                @test count(b -> CC.isReachable(a, entry, b), blocks) == length(blocks) - 1

                # clang's reachability is STRICT: no block reports reaching itself, not
                # even one sitting on the `while` loop's back edge. (The map is built from
                # each block's predecessors and never seeded with the block itself.)
                @test count(b -> CC.isReachable(a, b, b), blocks) == 0

                # Cycle membership shows up the other way, as MUTUAL reachability between
                # two distinct blocks -- which is also what proves the analysis follows back
                # edges at all: over a DAG no such pair can exist, so an implementation that
                # walked successors only forwards would report none.
                mutual = 0
                for x in blocks, y in blocks
                    CC.getBlockID(x) < CC.getBlockID(y) || continue
                    CC.isReachable(a, x, y) && CC.isReachable(a, y, x) && (mutual += 1)
                end
                @test mutual > 0
            finally
                CC.dispose(a)
            end

            # the borrowed analysis an AnalysisDeclContext caches answers the same way
            adc = CC.AnalysisDeclContext(fd)
            try
                acfg = CC.getCFG(adc)
                ra = CC.getCFGReachablityAnalysis(adc)
                @test !CC.is_null_handle(ra)
                aentry = CC.getEntry(acfg)
                aexit = CC.getExit(acfg)
                @test CC.isReachable(ra, aentry, aexit)
                @test !CC.isReachable(ra, aexit, aentry)
                @test !CC.isReachable(ra, aentry, aentry)
            finally
                CC.dispose(adc)
            end
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
