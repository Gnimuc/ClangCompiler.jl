using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Analysis | CFG" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int cfg_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; } else { acc = 2; }
                while (acc < 10) { acc += x; }
                return acc;
            }
            """)
        @assert f(I, "cfg_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        @test fd.ptr != C_NULL
        @test CC.hasBody(fd)
        body = CC.getBody(fd)
        ctx = CC.get_ast_context(I)

        cfg = CC.buildCFG(fd, body, ctx)
        @test cfg isa CC.CFG
        @test cfg.ptr != C_NULL

        n = Int(CC.getNumBlocks(cfg))
        @test n == CC.getNumBlockIDs(cfg)
        @test n >= 4
        @test !CC.isLinear(cfg)
        @test CC.getIndirectGotoBlock(cfg).ptr == C_NULL

        entry = CC.getEntry(cfg)
        exit_ = CC.getExit(cfg)
        @test entry isa CC.CFGBlock && entry.ptr != C_NULL
        @test exit_.ptr != C_NULL
        @test CC.pred_size(entry) == 0
        @test CC.succ_size(entry) == 1
        @test CC.succ_size(exit_) == 0
        @test CC.pred_size(exit_) >= 1
        @test CC.getPred(exit_, 0).ptr != C_NULL

        # the entry block is element-free and terminator-free
        @test CC.size(entry) == 0
        @test !CC.hasTerminator(entry)
        @test CC.getTerminatorStmt(entry).ptr == C_NULL
        @test CC.getLabel(entry).ptr == C_NULL
        @test CC.getLoopTarget(entry).ptr == C_NULL
        @test !CC.hasNoReturnElement(entry)
        @test !CC.isInevitablySinking(entry)

        found_branch = false
        found_stmt = false
        ids = UInt32[]
        for i in 0:(n - 1)
            b = CC.getBlock(cfg, i)
            @test CC.getIndexInCFG(b) == i
            @test CC.getParent(b).ptr == cfg.ptr
            push!(ids, CC.getBlockID(b))
            if CC.hasTerminator(b)
                found_branch = true
                @test CC.getTerminatorKind(b) ==
                      CC.LibClangEx.CXCFGTerminatorKind_StmtBranch
                ts = CC.getTerminatorStmt(b)
                @test ts.ptr != C_NULL
                @test CC.resolve(ts) isa CC.AbstractStmt
                @test CC.getTerminatorCondition(b).ptr != C_NULL
                @test CC.getLastCondition(b) isa CC.Expr_
                for j in 0:(Int(CC.succ_size(b)) - 1)
                    @test CC.isSuccReachable(b, j)
                    @test CC.getSucc(b, j).ptr != C_NULL
                    @test CC.getSuccPossiblyUnreachableBlock(b, j).ptr == C_NULL
                end
            end
            for j in 0:(Int(CC.size(b)) - 1)
                k = CC.getElementKind(b, j)
                if k == CC.LibClangEx.CXCFGElementKind_Statement
                    found_stmt = true
                    @test CC.getElementStmt(b, j).ptr != C_NULL
                    # kind-mismatched payload accessors yield the NULL sentinel
                    @test CC.getElementInitializer(b, j).ptr == C_NULL
                    @test CC.getElementVarDecl(b, j).ptr == C_NULL
                    @test CC.getElementTriggerStmt(b, j).ptr == C_NULL
                    @test CC.getElementLoopStmt(b, j).ptr == C_NULL
                    @test CC.getElementBindTemporaryExpr(b, j).ptr == C_NULL
                    @test CC.getElementBaseSpecifier(b, j).ptr == C_NULL
                    @test CC.getElementFieldDecl(b, j).ptr == C_NULL
                    @test CC.getElementAllocatorExpr(b, j).ptr == C_NULL
                    @test !isempty(CC.printElementAsString(b, j))
                end
            end
        end
        @test found_branch && found_stmt
        @test length(unique(ids)) == n

        @test !isempty(CC.printAsString(cfg, ctx))
        @test occursin("ENTRY", CC.printAsString(entry, cfg, ctx))

        # element-producing build options: implicit dtors + loop exits
        CC.parse(I, """
            struct CfgRAII { int v; CfgRAII(int x) : v(x) {} ~CfgRAII(); };
            int cfg_fn2(int n) {
                CfgRAII r(n);
                while (n > 0) { --n; }
                return r.v;
            }
            """)
        @assert f(I, "cfg_fn2")
        fd2 = CC.getAsFunction(CC.get_decl(f))
        cfg2 = CC.buildCFG(fd2, CC.getBody(fd2), ctx, false, true, false, true,
                           false, false, false)
        @test cfg2.ptr != C_NULL
        found_dtor = false
        found_loop_exit = false
        for i in 0:(Int(CC.getNumBlocks(cfg2)) - 1)
            b = CC.getBlock(cfg2, i)
            for j in 0:(Int(CC.size(b)) - 1)
                k = CC.getElementKind(b, j)
                if k == CC.LibClangEx.CXCFGElementKind_AutomaticObjectDtor
                    found_dtor = true
                    vd = CC.getElementVarDecl(b, j)
                    @test vd.ptr != C_NULL
                    @test CC.getName(vd) == "r"
                    @test CC.getElementTriggerStmt(b, j).ptr != C_NULL
                elseif k == CC.LibClangEx.CXCFGElementKind_LoopExit
                    found_loop_exit = true
                    @test CC.getElementLoopStmt(b, j).ptr != C_NULL
                end
            end
        end
        @test found_dtor
        @test found_loop_exit
        CC.dispose(cfg2)
        CC.dispose(cfg)
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
