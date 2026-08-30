using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "Analysis | IntervalPartition" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int wto_reducible(int n) {
                int acc = 0;
                if (n > 0) { acc = 1; }
                while (n > 0) { acc += n; --n; }
                return acc;
            }
            void wto_irreducible(int x) {
                if (x > 0) goto L2;
            L1:
                x = x + 1;
            L2:
                x = x - 1;
                if (x > 0) goto L1;
            }
            """)
        ctx = CC.get_ast_context(I)

        @assert f(I, "wto_reducible")
        fd = CC.getAsFunction(CC.get_decl(f))
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx)
        try
            wto = CC.getIntervalWTO(cfg)
            @test wto !== nothing
            @test !isempty(wto)
            @test length(wto) <= Int(CC.getNumBlocks(cfg))
            @test length(unique(b.ptr for b in wto)) == length(wto)
            @test all(b -> CC.getParent(b).ptr == cfg.ptr, wto)
            @test any(b -> b.ptr == CC.getEntry(cfg).ptr, wto)
            @test any(b -> CC.hasTerminator(b), wto)

            # the `while` is the one place the ordering has to fold back on itself
            rank = Dict(b.ptr => i for (i, b) in enumerate(wto))
            backward = 0
            for (i, b) in enumerate(wto)
                for j = 0:(Int(CC.succ_size(b)) - 1)
                    s = CC.getSucc(b, j)
                    s.ptr == C_NULL && continue
                    haskey(rank, s.ptr) || continue
                    rank[s.ptr] <= i && (backward += 1)
                end
            end
            @test backward >= 1
        finally
            CC.dispose(cfg)
        end

        # a loop entered at two different blocks has no weak topological ordering
        @assert f(I, "wto_irreducible")
        ifd = CC.getAsFunction(CC.get_decl(f))
        icfg = CC.buildCFG(ifd, CC.getBody(ifd), ctx)
        try
            @test CC.getIntervalWTO(icfg) === nothing
        finally
            CC.dispose(icfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
