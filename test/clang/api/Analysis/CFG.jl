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

@testset "Analysis | CFG tail" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            struct CfgTailRAII { int v; CfgTailRAII(int x) : v(x) {} ~CfgTailRAII(); };
            int cfg_tail_fn(int n) {
                CfgTailRAII r(n);
                int acc = 0;
                if (n > 0) { acc = 1; } else { acc = 2; }
                while (acc < 10) { acc += n; }
                return acc + r.v;
            }
            """)
        @assert f(I, "cfg_tail_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        ctx = CC.get_ast_context(I)
        # AddImplicitDtors so the graph carries dtor-family elements
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx, false, true, false, false, false,
                          false, false)
        @test cfg.ptr != C_NULL
        try
            # CFG tail: try-dispatch blocks and the synthetic-DeclStmt map
            @test CC.getNumTryBlocks(cfg) == 0
            @test CC.getNumSyntheticDeclStmts(cfg) isa Integer

            entry = CC.getEntry(cfg)
            exit_ = CC.getExit(cfg)
            @test isempty(entry)
            @test CC.pred_empty(entry)
            @test !CC.succ_empty(entry)
            @test CC.succ_empty(exit_)
            @test !CC.pred_empty(exit_)
            @test CC.FilterEdge(entry, exit_) isa Bool
            @test CC.FilterEdge(entry, exit_, false, false) isa Bool

            for j in 0:(Int(CC.pred_size(exit_)) - 1)
                @test CC.isPredReachable(exit_, j) isa Bool
                @test CC.getPredPossiblyUnreachableBlock(exit_, j) isa CC.CFGBlock
            end

            n = Int(CC.getNumBlocks(cfg))
            found_terminator = false
            found_dtor = false
            found_declstmt = false
            for i in 0:(n - 1)
                b = CC.getBlock(cfg, i)
                @test isempty(b) == (CC.size(b) == 0)
                if CC.hasTerminator(b)
                    found_terminator = true
                    @test !isempty(CC.printTerminatorAsString(b, ctx))
                    @test CC.printTerminatorJsonAsString(b, ctx) isa String
                    @test CC.printTerminatorJsonAsString(b, ctx, true) isa String
                end
                for j in 0:(Int(CC.size(b)) - 1)
                    k = CC.getElementKind(b, j)
                    if k == CC.LibClangEx.CXCFGElementKind_AutomaticObjectDtor
                        found_dtor = true
                        @test CC.getElementDestructorDecl(b, j, ctx) isa
                              CC.CXXDestructorDecl
                        # kind-mismatched payloads still yield the NULL sentinel
                        @test CC.getElementDeleteExpr(b, j).ptr == C_NULL
                        @test CC.getElementCXXRecordDecl(b, j).ptr == C_NULL
                        @test CC.getElementCleanupFunctionDecl(b, j).ptr == C_NULL
                    elseif k == CC.LibClangEx.CXCFGElementKind_Statement
                        @test CC.getElementDestructorDecl(b, j, ctx).ptr == C_NULL
                        s = CC.resolve(CC.getElementStmt(b, j))
                        if s isa CC.DeclStmt
                            found_declstmt = true
                            # a real DeclStmt of the body is not a synthetic one
                            @test CC.getSyntheticDeclStmtSource(cfg, s).ptr == C_NULL
                        end
                    end
                end
            end
            @test found_terminator
            @test found_dtor
            @test found_declstmt
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | CFG mutation" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            struct CfgMutBase { int b; ~CfgMutBase(); };
            struct CfgMutMember { int m; ~CfgMutMember(); };
            struct CfgMutTmp { CfgMutTmp(); ~CfgMutTmp(); };
            void cfg_mut_sink(const CfgMutTmp &);
            struct CfgMutDerived : CfgMutBase {
                CfgMutMember mem;
                CfgMutDerived(int x) : CfgMutBase(), mem() { (void)x; }
            };
            int cfg_mut_fn(int n) {
                CfgMutDerived d(n);
                int e = 0;
                cfg_mut_sink(CfgMutTmp());
                while (n > 0) { --n; }
                return n + e;
            }
            """)
        ctx = CC.get_ast_context(I)
        @assert f(I, "cfg_mut_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        # implicit dtors + loop exits + temporary dtors, so the graph carries the
        # payloads the appenders below re-attach to a hand-made block
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx, false, true, false, true, true, false,
                          false)
        @test cfg.ptr != C_NULL
        try
            stmt = nothing
            vd = nothing
            trigger = nothing
            loop_stmt = nothing
            bind_temp = nothing
            decl_stmts = CC.DeclStmt[]
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                for j in 0:(Int(CC.size(b)) - 1)
                    k = CC.getElementKind(b, j)
                    if k == CC.LibClangEx.CXCFGElementKind_Statement
                        s = CC.getElementStmt(b, j)
                        stmt === nothing && (stmt = s)
                        r = CC.resolve(s)
                        r isa CC.DeclStmt && push!(decl_stmts, r)
                    elseif k == CC.LibClangEx.CXCFGElementKind_AutomaticObjectDtor
                        if vd === nothing
                            vd = CC.getElementVarDecl(b, j)
                            trigger = CC.getElementTriggerStmt(b, j)
                        end
                    elseif k == CC.LibClangEx.CXCFGElementKind_LoopExit
                        loop_stmt === nothing && (loop_stmt = CC.getElementLoopStmt(b, j))
                    elseif k == CC.LibClangEx.CXCFGElementKind_TemporaryDtor
                        bind_temp === nothing &&
                            (bind_temp = CC.getElementBindTemporaryExpr(b, j))
                    end
                end
            end
            @test stmt !== nothing && stmt.ptr != C_NULL
            @test vd !== nothing && vd.ptr != C_NULL
            @test trigger !== nothing && trigger.ptr != C_NULL
            @test loop_stmt !== nothing && loop_stmt.ptr != C_NULL
            @test bind_temp !== nothing && bind_temp.ptr != C_NULL
            @test length(decl_stmts) >= 2

            # the record-shaped payloads come from the AST, not from the graph
            @assert f(I, "CfgMutDerived")
            rd = CC.CXXRecordDecl(CC.get_tag(f).ptr)
            @test CC.hasDefinition(rd)
            @test CC.getNumBases(rd) >= 1
            base_spec = CC.getBase(rd, 0)
            fields = CC.getFields(rd)
            @test !isempty(fields)
            field = fields[1]
            ctor_init = nothing
            for c in CC.getCtors(rd)
                if CC.getNumCtorInitializers(c) > 0
                    ctor_init = CC.getCtorInitializer(c, 0)
                    break
                end
            end
            @test ctor_init !== nothing && ctor_init.ptr != C_NULL

            n0 = Int(CC.getNumBlocks(cfg))
            nb = CC.createBlock(cfg)
            @test nb isa CC.CFGBlock
            @test nb.ptr != C_NULL
            @test Int(CC.getNumBlocks(cfg)) == n0 + 1
            @test CC.getParent(nb).ptr == cfg.ptr
            @test isempty(nb)

            CC.setLabel(nb, stmt)
            @test CC.getLabel(nb).ptr == stmt.ptr
            CC.setLoopTarget(nb, loop_stmt)
            @test CC.getLoopTarget(nb).ptr == loop_stmt.ptr
            @test !CC.hasNoReturnElement(nb)
            CC.setHasNoReturnElement(nb)
            @test CC.hasNoReturnElement(nb)
            @test !CC.hasTerminator(nb)
            CC.setTerminator(nb, stmt)
            @test CC.hasTerminator(nb)
            @test CC.getTerminatorStmt(nb).ptr == stmt.ptr
            @test CC.getTerminatorKind(nb) == CC.LibClangEx.CXCFGTerminatorKind_StmtBranch
            CC.setTerminator(nb, stmt, CC.LibClangEx.CXCFGTerminatorKind_VirtualBaseBranch)
            @test CC.getTerminatorKind(nb) ==
                  CC.LibClangEx.CXCFGTerminatorKind_VirtualBaseBranch

            exit_ = CC.getExit(cfg)
            s0 = Int(CC.succ_size(nb))
            CC.addSuccessor(nb, exit_)
            @test Int(CC.succ_size(nb)) == s0 + 1
            @test CC.getSucc(nb, s0).ptr == exit_.ptr
            @test CC.isSuccReachable(nb, s0)
            CC.addSuccessor(nb, exit_, false)
            @test Int(CC.succ_size(nb)) == s0 + 2
            @test !CC.isSuccReachable(nb, s0 + 1)
            @test CC.getSucc(nb, s0 + 1).ptr == C_NULL
            @test CC.getSuccPossiblyUnreachableBlock(nb, s0 + 1).ptr == exit_.ptr

            # the element list is stored in reverse: an appended element is index 0
            sz = Int(CC.size(nb))
            CC.appendStmt(nb, stmt)
            @test Int(CC.size(nb)) == sz + 1
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_Statement
            @test CC.getElementStmt(nb, 0).ptr == stmt.ptr

            CC.appendInitializer(nb, ctor_init)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_Initializer
            @test CC.getElementInitializer(nb, 0).ptr == ctor_init.ptr

            CC.appendScopeBegin(nb, vd, trigger)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_ScopeBegin
            @test CC.getElementVarDecl(nb, 0).ptr == vd.ptr
            @test CC.getElementTriggerStmt(nb, 0).ptr == trigger.ptr

            CC.appendScopeEnd(nb, vd, trigger)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_ScopeEnd

            CC.appendBaseDtor(nb, base_spec)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_BaseDtor
            @test CC.getElementBaseSpecifier(nb, 0).ptr == base_spec.ptr

            CC.appendMemberDtor(nb, field)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_MemberDtor
            @test CC.getElementFieldDecl(nb, 0).ptr == field.ptr

            CC.appendTemporaryDtor(nb, bind_temp)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_TemporaryDtor
            @test CC.getElementBindTemporaryExpr(nb, 0).ptr == bind_temp.ptr

            CC.appendAutomaticObjDtor(nb, vd, trigger)
            @test CC.getElementKind(nb, 0) ==
                  CC.LibClangEx.CXCFGElementKind_AutomaticObjectDtor

            CC.appendLifetimeEnds(nb, vd, trigger)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_LifetimeEnds

            CC.appendLoopExit(nb, loop_stmt)
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_LoopExit
            @test CC.getElementLoopStmt(nb, 0).ptr == loop_stmt.ptr

            @test Int(CC.size(nb)) == sz + 10
            @test !isempty(nb)

            old_entry = CC.getEntry(cfg)
            CC.setEntry(cfg, nb)
            @test CC.getEntry(cfg).ptr == nb.ptr
            CC.setEntry(cfg, old_entry)
            @test CC.getEntry(cfg).ptr == old_entry.ptr

            @test CC.getIndirectGotoBlock(cfg).ptr == C_NULL
            CC.setIndirectGotoBlock(cfg, nb)
            @test CC.getIndirectGotoBlock(cfg).ptr == nb.ptr

            t0 = Int(CC.getNumTryBlocks(cfg))
            CC.addTryDispatchBlock(cfg, nb)
            @test Int(CC.getNumTryBlocks(cfg)) == t0 + 1
            @test CC.getTryBlock(cfg, t0).ptr == nb.ptr

            synthetic = decl_stmts[1]
            si = findfirst(d -> d.ptr != synthetic.ptr, decl_stmts)
            @test si !== nothing
            source = decl_stmts[si]
            @test CC.isSingleDecl(synthetic)
            m0 = Int(CC.getNumSyntheticDeclStmts(cfg))
            @test CC.getSyntheticDeclStmtSource(cfg, synthetic).ptr == C_NULL
            CC.addSyntheticDeclStmt(cfg, synthetic, source)
            @test Int(CC.getNumSyntheticDeclStmts(cfg)) == m0 + 1
            @test CC.getSyntheticDeclStmtSource(cfg, synthetic).ptr == source.ptr
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | CFG append" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            struct CfgAppS { int v; ~CfgAppS(); };
            int cfg_app_fn(int n) {
                CfgAppS *p = new CfgAppS();
                delete p;
                return n;
            }
            """)
        @assert f(I, "cfg_app_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        ctx = CC.get_ast_context(I)
        # AddImplicitDtors so `delete p` yields a DeleteDtor element and
        # AddCXXNewAllocator so `new CfgAppS()` yields a NewAllocator element
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx, false, true, false, false, false, false, true)
        @test cfg.ptr != C_NULL
        try
            new_expr = nothing
            del_expr = nothing
            rec_decl = nothing
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                for j in 0:(Int(CC.size(b)) - 1)
                    k = CC.getElementKind(b, j)
                    if k == CC.LibClangEx.CXCFGElementKind_NewAllocator
                        new_expr === nothing && (new_expr = CC.getElementAllocatorExpr(b, j))
                    elseif k == CC.LibClangEx.CXCFGElementKind_DeleteDtor
                        if del_expr === nothing
                            del_expr = CC.getElementDeleteExpr(b, j)
                            rec_decl = CC.getElementCXXRecordDecl(b, j)
                        end
                    end
                end
            end
            @test new_expr !== nothing && new_expr.ptr != C_NULL
            @test del_expr !== nothing && del_expr.ptr != C_NULL
            @test rec_decl !== nothing && rec_decl.ptr != C_NULL

            # append onto a fresh block; the element list is stored in reverse, so the
            # most recently appended element is index 0 and earlier ones shift up
            nb = CC.createBlock(cfg)
            @test isempty(nb)

            CC.appendNewAllocator(nb, new_expr)
            @test Int(CC.size(nb)) == 1
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_NewAllocator
            @test CC.getElementAllocatorExpr(nb, 0).ptr == new_expr.ptr

            CC.appendDeleteDtor(nb, rec_decl, del_expr)
            @test Int(CC.size(nb)) == 2
            @test CC.getElementKind(nb, 0) == CC.LibClangEx.CXCFGElementKind_DeleteDtor
            @test CC.getElementDeleteExpr(nb, 0).ptr == del_expr.ptr
            @test CC.getElementCXXRecordDecl(nb, 0).ptr == rec_decl.ptr
            # the earlier NewAllocator element shifted up to index 1
            @test CC.getElementKind(nb, 1) == CC.LibClangEx.CXCFGElementKind_NewAllocator
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | CFG cleanup, terminator kind and operand label" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            extern "C" void cfg_d_cleanup_hook(int *p);
            struct CfgDRec { int v; };
            CfgDRec cfg_d_make_rec();
            int cfg_d_make_int();
            int cfg_d_fn(int n) {
                int guarded __attribute__((cleanup(cfg_d_cleanup_hook))) = n;
                CfgDRec r = cfg_d_make_rec();
                if (n > 0) { return guarded + r.v; }
                return cfg_d_make_int();
            }
            """)
        @assert f(I, "cfg_d_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        ctx = CC.get_ast_context(I)
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx, false, false, false, false, false, false,
                          false)
        @test cfg.ptr != C_NULL
        try
            vd = nothing
            rec_call = nothing
            int_call = nothing
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                for j in 0:(Int(CC.size(b)) - 1)
                    CC.getElementKind(b, j) == CC.LibClangEx.CXCFGElementKind_Statement ||
                        continue
                    s = CC.resolve(CC.getElementStmt(b, j))
                    if s isa CC.DeclStmt && CC.isSingleDecl(s)
                        d = CC.getSingleDecl(s)
                        # a CleanupAttr's only subject is a local variable, so the decl
                        # carrying one is a VarDecl
                        if CC.hasAttrOfKind(d, CC.LibClangEx.CXAttrKind_Cleanup)
                            vd = CC.VarDecl(d.ptr)
                        end
                    elseif s isa CC.CallExpr
                        callee = CC.getDirectCallee(s)
                        if callee.ptr != C_NULL
                            nm = CC.getName(callee)
                            nm == "cfg_d_make_rec" && (rec_call = CC.isCXXRecordTypedCall(s))
                            nm == "cfg_d_make_int" && (int_call = CC.isCXXRecordTypedCall(s))
                        end
                    end
                end
            end

            # a call yielding a class prvalue is CXXRecordTypedCall-shaped; one returning
            # int is not
            @test rec_call === true
            @test int_call === false

            # printAsOperand is the LLVM-style label, derived from the block id
            entry = CC.getEntry(cfg)
            @test CC.printAsOperandAsString(entry) ==
                  "BB#" * string(Int(CC.getBlockID(entry)))

            # the `if` gives exactly one block a statement-branch terminator
            branch = nothing
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                CC.hasTerminator(b) && branch === nothing && (branch = b)
            end
            @test branch !== nothing
            @test CC.getTerminatorKind(branch) ==
                  CC.LibClangEx.CXCFGTerminatorKind_StmtBranch
            @test CC.isTerminatorStmtBranch(branch)
            @test !CC.isTerminatorTemporaryDtorsBranch(branch)
            @test !CC.isTerminatorVirtualBaseBranch(branch)

            # a fresh block has no terminator at all, yet the empty PointerIntPair still
            # reads back kind StmtBranch — hence the pairing with hasTerminator
            nb = CC.createBlock(cfg)
            @test !CC.hasTerminator(nb)
            @test CC.isTerminatorStmtBranch(nb)
            CC.setTerminator(nb, CC.getBody(fd),
                             CC.LibClangEx.CXCFGTerminatorKind_VirtualBaseBranch)
            @test CC.hasTerminator(nb)
            @test CC.isTerminatorVirtualBaseBranch(nb)
            @test !CC.isTerminatorStmtBranch(nb)
            @test !CC.isTerminatorTemporaryDtorsBranch(nb)

            # the cleanup-attributed local, appended onto a block of its own
            @test vd !== nothing && vd.ptr != C_NULL
            cb = CC.createBlock(cfg)
            CC.appendCleanupFunction(cb, vd)
            @test Int(CC.size(cb)) == 1
            @test CC.getElementKind(cb, 0) ==
                  CC.LibClangEx.CXCFGElementKind_CleanupFunction
            @test CC.getElementVarDecl(cb, 0).ptr == vd.ptr
            hook = CC.getElementCleanupFunctionDecl(cb, 0)
            @test hook.ptr != C_NULL
            @test CC.getName(hook) == "cfg_d_cleanup_hook"
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | CFG BuildOptions, filtered edges, front/back" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        CC.parse(I, """
            int cfg_e_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = x + 1; } else { acc = x - 1; }
                while (acc < 10) { acc += x; }
                return acc;
            }
            """)
        @assert f(I, "cfg_e_fn")
        fd = CC.getAsFunction(get_decl(f))
        @test fd.ptr != C_NULL
        @test CC.hasBody(fd)
        body = CC.getBody(fd)
        ctx = CC.get_ast_context(I)

        opts = CC.CFGBuildOptions()
        try
            @test opts isa CC.CFGBuildOptions
            @test opts.ptr != C_NULL

            # round-trip the mask through the body's own statement class, so nothing here
            # depends on which class the host's parser produced
            sc = CC.getStmtClass(body)
            @test CC.alwaysAdd(opts, body) isa Bool
            @test !CC.alwaysAdd(opts, body)
            CC.setAlwaysAdd(opts, sc)
            @test CC.alwaysAdd(opts, body)
            CC.setAlwaysAdd(opts, sc, false)
            @test !CC.alwaysAdd(opts, body)
            CC.setAllAlwaysAdd(opts)
            @test CC.alwaysAdd(opts, body)

            cfg = CC.buildCFGWithOptions(fd, body, ctx, opts)
            try
                @test cfg isa CC.CFG
                @test cfg.ptr != C_NULL
                n = Int(CC.getNumBlocks(cfg))
                @test n >= 4

                # front/back are the two ends of the very list getBlock indexes
                @test CC.front(cfg) isa CC.CFGBlock
                @test CC.back(cfg) isa CC.CFGBlock
                @test CC.front(cfg).ptr == CC.getBlock(cfg, 0).ptr
                @test CC.back(cfg).ptr == CC.getBlock(cfg, n - 1).ptr

                entry = CC.getEntry(cfg)
                exit_ = CC.getExit(cfg)

                for i in 0:(n - 1)
                    b = CC.getBlock(cfg, i)
                    fs = CC.getFilteredSuccs(b)
                    fp = CC.getFilteredPreds(b)
                    @test fs isa Vector{CC.CFGBlock}
                    @test fp isa Vector{CC.CFGBlock}
                    # the count call and the fill call agree, and both are subsets of the
                    # unfiltered edge lists
                    @test length(fs) == Int(CC.getNumFilteredSuccs(b))
                    @test length(fp) == Int(CC.getNumFilteredPreds(b))
                    @test length(fs) <= Int(CC.succ_size(b))
                    @test length(fp) <= Int(CC.pred_size(b))
                    # non-default FilterOptions still return a well-formed count
                    @test CC.getNumFilteredSuccs(b, false, false) isa Integer
                end

                # a successor walk filters nothing here: its source block is never null
                @test length(CC.getFilteredSuccs(entry)) == Int(CC.succ_size(entry))
                @test isempty(CC.getFilteredPreds(entry))
                @test isempty(CC.getFilteredSuccs(exit_))
                @test length(CC.getFilteredPreds(exit_)) <= Int(CC.pred_size(exit_))
            finally
                CC.dispose(cfg)
            end
        finally
            CC.dispose(opts)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
