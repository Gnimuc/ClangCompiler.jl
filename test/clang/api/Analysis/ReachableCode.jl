using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Analysis | ReachableCode | ScanReachableFromBlock" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int rcs_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; } else { acc = 2; }
                return acc;
            }
            """)
        @assert f(I, "rcs_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        cfg = CC.buildCFG(fd, CC.getBody(fd), CC.get_ast_context(I))
        @test cfg.ptr != C_NULL
        try
            entry = CC.getEntry(cfg)
            exit_ = CC.getExit(cfg)
            n = Int(CC.getNumBlocks(cfg))

            from_entry = CC.ScanReachableFromBlock(entry)
            @test length(from_entry) == n
            @test length(unique(b.ptr for b in from_entry)) == length(from_entry)
            @test all(b -> CC.getParent(b).ptr == cfg.ptr, from_entry)
            @test entry.ptr in [b.ptr for b in from_entry]

            # the exit reaches only itself
            from_exit = CC.ScanReachableFromBlock(exit_)
            @test length(from_exit) == 1
            @test from_exit[1].ptr == exit_.ptr

            # every block reaches at least itself, and none reaches more than the whole
            # graph
            for i in 0:(n - 1)
                b = CC.getBlock(cfg, i)
                reach = CC.ScanReachableFromBlock(b)
                @test b.ptr in [r.ptr for r in reach]
                @test 1 <= length(reach) <= n
            end
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | ReachableCode | FindUnreachableCode" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int rc_live(int x) {
                if (x > 0) { return 1; }
                return x;
            }
            int rc_dead(int x) {
                return x;
                return x + 1;
            }
            int rc_no_body(int);
            """)
        pp = CC.getPreprocessor(CC.get_instance(I))

        # nothing dead: the analysis reports nothing
        @assert f(I, "rc_live")
        live = CC.getAsFunction(CC.get_decl(f))
        ladc = CC.AnalysisDeclContext(live)
        try
            r = CC.UnreachableCodeResult(ladc, pp)
            try
                @test CC.getNumUnreachable(r) == 0
            finally
                CC.dispose(r)
            end
        finally
            CC.dispose(ladc)
        end

        # a statement after an unconditional return is dead
        @assert f(I, "rc_dead")
        dead = CC.getAsFunction(CC.get_decl(f))
        dadc = CC.AnalysisDeclContext(dead)
        try
            r = CC.UnreachableCodeResult(dadc, pp)
            try
                n = Int(CC.getNumUnreachable(r))
                @test n >= 1
                kinds = [CC.getKind(r, i) for i in 0:(n - 1)]
                @test CC.LibClangEx.CXUnreachableKind_UK_Return in kinds
                for i in 0:(n - 1)
                    # the location is what identifies the dead region, and clang always
                    # supplies one
                    @test CC.isValid(CC.getLocation(r, i))
                    # R1/R2 are the OPTIONAL extra ranges a diagnostic would underline
                    # alongside that location, not the region itself: a plain statement
                    # after an unconditional `return` is reported with both left empty.
                    # What does hold structurally is the ordering -- R2 is never filled on
                    # its own -- which is also what would catch a shim marshalling the two
                    # ranges in the wrong order.
                    @test !CC.isValid(CC.getR2(r, i)) || CC.isValid(CC.getR1(r, i))
                    # this code is dead unconditionally: there is no condition to name
                    @test !CC.isValid(CC.getConditionValRange(r, i))
                    @test !CC.getHasFallThroughAttr(r, i)
                end
            finally
                CC.dispose(r)
            end
        finally
            CC.dispose(dadc)
        end

        # no body, no CFG, no reports -- and no crash
        @assert f(I, "rc_no_body")
        nb = CC.getAsFunction(CC.get_decl(f))
        nadc = CC.AnalysisDeclContext(nb)
        try
            r = CC.UnreachableCodeResult(nadc, pp)
            try
                @test CC.getNumUnreachable(r) == 0
            finally
                CC.dispose(r)
            end
        finally
            CC.dispose(nadc)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
