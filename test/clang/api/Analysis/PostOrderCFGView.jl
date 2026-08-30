using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "Analysis | PostOrderCFGView" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int po_acyclic(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; } else { acc = 2; }
                return acc;
            }
            int po_loop(int n) {
                int acc = 0;
                while (n > 0) { acc += n; --n; }
                return acc;
            }
            """)
        ctx = CC.get_ast_context(I)

        @assert f(I, "po_acyclic")
        fd = CC.getAsFunction(CC.get_decl(f))
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx)
        try
            rpo = CC.getBlocksInReversePostOrder(cfg)
            n = Int(CC.getNumBlocks(cfg))
            @test !isempty(rpo)
            @test length(rpo) <= n
            # no block is visited twice
            @test length(unique(b.ptr for b in rpo)) == length(rpo)
            # every block of the order belongs to this graph
            @test all(b -> CC.getParent(b).ptr == cfg.ptr, rpo)
            # the entry comes first
            @test rpo[1].ptr == CC.getEntry(cfg).ptr

            # this body has no loops, so the order is a true topological one: every block
            # follows all of its predecessors
            rank = Dict(b.ptr => i for (i, b) in enumerate(rpo))
            for (i, b) in enumerate(rpo)
                for j = 0:(Int(CC.pred_size(b)) - 1)
                    p = CC.getPred(b, j)
                    p.ptr == C_NULL && continue
                    haskey(rank, p.ptr) || continue
                    @test rank[p.ptr] < i
                end
            end
        finally
            CC.dispose(cfg)
        end

        # with a loop the order can no longer be topological: the back edge runs the other
        # way, and exactly the back edges do
        @assert f(I, "po_loop")
        lfd = CC.getAsFunction(CC.get_decl(f))
        lcfg = CC.buildCFG(lfd, CC.getBody(lfd), ctx)
        try
            rpo = CC.getBlocksInReversePostOrder(lcfg)
            @test rpo[1].ptr == CC.getEntry(lcfg).ptr
            rank = Dict(b.ptr => i for (i, b) in enumerate(rpo))
            back_edges = 0
            for (i, b) in enumerate(rpo)
                for j = 0:(Int(CC.pred_size(b)) - 1)
                    p = CC.getPred(b, j)
                    p.ptr == C_NULL && continue
                    haskey(rank, p.ptr) || continue
                    rank[p.ptr] > i && (back_edges += 1)
                end
            end
            @test back_edges >= 1
        finally
            CC.dispose(lcfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
