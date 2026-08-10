using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "Analysis | AnalysisDeclContext" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int adc_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; } else { acc = 2; }
                while (acc < 10) { acc += x; }
                return acc;
            }
            int adc_no_body(int);
            struct AdcTag { int v; };
            """)
        @assert f(I, "adc_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        ctx = CC.get_ast_context(I)

        adc = CC.AnalysisDeclContext(fd)
        try
            @test CC.getDecl(adc).ptr == fd.ptr
            @test CC.getASTContext(adc).ptr == ctx.ptr
            # a standalone context belongs to no manager
            @test CC.is_null_handle(CC.getManager(adc))
            @test !CC.isCFGBuilt(adc)

            body = CC.getBody(adc)
            @test body.ptr == CC.getBody(fd).ptr
            body2, autosynthesized = CC.getBodyWithAutosynthesized(adc)
            @test body2.ptr == body.ptr
            @test !autosynthesized
            @test !CC.isBodyAutosynthesized(adc)
            @test !CC.isBodyAutosynthesizedFromModelFile(adc)

            # the borrowed build options are the ones the four convenience readers report
            bo = CC.getCFGBuildOptions(adc)
            @test CC.getPruneTriviallyFalseEdges(bo)
            @test CC.getUseUnoptimizedCFG(adc) == !CC.getPruneTriviallyFalseEdges(bo)
            @test CC.getAddEHEdges(adc) == CC.getAddEHEdges(bo)
            @test CC.getAddImplicitDtors(adc) == CC.getAddImplicitDtors(bo)
            @test CC.getAddInitializers(adc) == CC.getAddInitializers(bo)
            @test !CC.getAddImplicitDtors(adc)
            @test !CC.getAddInitializers(adc)

            cfg = CC.getCFG(adc)
            @test !CC.is_null_handle(cfg)
            @test CC.isCFGBuilt(adc)
            # the graph is cached, not rebuilt
            @test CC.getCFG(adc).ptr == cfg.ptr
            @test CC.getNumBlocks(cfg) >= 4
            @test !CC.isLinear(cfg)
            @test CC.getEntry(cfg).ptr != CC.getExit(cfg).ptr

            # the unpruned graph is a second, separately cached graph
            ucfg = CC.getUnoptimizedCFG(adc)
            @test !CC.is_null_handle(ucfg)
            @test ucfg.ptr != cfg.ptr
            @test CC.getUnoptimizedCFG(adc).ptr == ucfg.ptr

            # the reachability analysis is borrowed and cached too
            ra = CC.getCFGReachablityAnalysis(adc)
            @test !CC.is_null_handle(ra)
            @test CC.getCFGReachablityAnalysis(adc).ptr == ra.ptr
            @test CC.isReachable(ra, CC.getEntry(cfg), CC.getExit(cfg))
            @test !CC.isReachable(ra, CC.getExit(cfg), CC.getEntry(cfg))

            # CFGStmtMap: every block-level statement lands in a block of this graph, and a
            # terminator lands in the block it terminates
            m = CC.getCFGStmtMap(adc)
            @test !CC.is_null_handle(m)
            @test CC.getCFGStmtMap(adc).ptr == m.ptr
            mapped_stmts = 0
            mapped_terminators = 0
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                if CC.hasTerminator(b)
                    t = CC.getTerminatorStmt(b)
                    @test CC.getBlock(m, t).ptr == b.ptr
                    mapped_terminators += 1
                end
                for j in 0:(Int(CC.size(b)) - 1)
                    CC.getElementKind(b, j) ==
                        CC.LibClangEx.CXCFGElementKind_Statement || continue
                    s = CC.getElementStmt(b, j)
                    landed = CC.getBlock(m, s)
                    @test !CC.is_null_handle(landed)
                    @test CC.getParent(landed).ptr == cfg.ptr
                    mapped_stmts += 1
                end
            end
            @test mapped_terminators == 2
            @test mapped_stmts > 0

            # ParentMap: the body is the root, and the condition of each branch hangs off
            # the statement that terminates its block
            pm = CC.getParentMap(adc)
            @test CC.getParentMap(adc).ptr == pm.ptr
            @test !CC.hasParent(pm, body)
            @test CC.is_null_handle(CC.getParent(pm, body))
            # `body` is no ParenExpr and has no parent, so no parenthesis chain encloses it
            @test CC.is_null_handle(CC.getOuterParenParent(pm, body))

            conditions = 0
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                CC.hasTerminator(b) || continue
                cond = CC.getLastCondition(b)
                CC.is_null_handle(cond) && continue
                conditions += 1
                @test CC.hasParent(pm, cond)
                @test CC.getParent(pm, cond).ptr == CC.getTerminatorStmt(b).ptr
                @test CC.isConsumedExpr(pm, cond)
            end
            @test conditions == 2

            # `acc += x;` is an expression whose value nobody reads: the two outcomes of
            # isConsumedExpr both occur over this body
            consumed = false
            discarded = false
            for s in CC.getBlockStmts(cfg)
                e = CC.resolve(s)
                e isa CC.AbstractExpr || continue
                if CC.isConsumedExpr(pm, e)
                    consumed = true
                else
                    discarded = true
                end
            end
            @test consumed
            @test discarded

            # the ignore-* walks never stop on the node kind they promise to skip
            for s in CC.getBlockStmts(cfg)
                p = CC.getParentIgnoreParens(pm, s)
                CC.is_null_handle(p) || @test !(CC.resolve(p) isa CC.AbstractParenExpr)
                p = CC.getParentIgnoreParenCasts(pm, s)
                if !CC.is_null_handle(p)
                    r = CC.resolve(p)
                    @test !(r isa CC.AbstractParenExpr) && !(r isa CC.AbstractCastExpr)
                end
                p = CC.getParentIgnoreParenImpCasts(pm, s)
                if !CC.is_null_handle(p)
                    r = CC.resolve(p)
                    @test !(r isa CC.AbstractParenExpr) && !(r isa CC.AbstractImplicitCastExpr)
                end
            end

            # an operand of an implicit cast: the cast is its parent, and the ignore-* walk
            # steps over it.
            #
            # The search runs over the body's own subtree rather than getBlockStmts: clang's
            # CFG lists whole statements, so every parent reachable that way is an enclosing
            # statement (CompoundStmt/IfStmt/WhileStmt/ReturnStmt) and no cast is ever the
            # parent. The lvalue-to-rvalue casts this exercises sit one level below, on the
            # DeclRefExprs that read `x` and `acc`.
            skipped_a_cast = false
            function each_stmt(f, s, depth=0)
                depth > 32 && return
                for c in CC.children(s)
                    CC.is_null_handle(c) && continue
                    f(c)
                    each_stmt(f, c, depth + 1)
                end
            end
            each_stmt(CC.getBody(adc)) do s
                p = CC.getParent(pm, s)
                CC.is_null_handle(p) && return
                CC.resolve(p) isa CC.AbstractImplicitCastExpr || return
                skipped_a_cast = true
                @test CC.getParentIgnoreParenImpCasts(pm, s).ptr != p.ptr
                @test CC.getParentIgnoreParenCasts(pm, s).ptr != p.ptr
            end
            @test skipped_a_cast

            dumped = redirect_stderr(devnull) do
                CC.dumpCFG(adc) === nothing && CC.dumpCFG(adc, true) === nothing
            end
            @test dumped

            # a plain C++ function has no self and captures no block variables
            @test CC.is_null_handle(CC.getSelfDecl(adc))
            @test !CC.isInStdNamespace(adc)
            # the analysis spelling of a name: qualified, and parameterized in C++
            name = CC.getFunctionName(fd)
            @test startswith(name, "adc_fn")
            @test occursin("int", name)
        finally
            CC.dispose(adc)
        end

        # forcing an expression to be block-level has to happen before the graph is built,
        # so it needs a context of its own; the forced statement is still block-level
        # afterwards, which is what the stmt map reports
        forced = CC.AnalysisDeclContext(fd)
        try
            base = CC.AnalysisDeclContext(fd)
            target = CC.Stmt(C_NULL)
            try
                bcfg = CC.getCFG(base)
                for i in 0:(Int(CC.getNumBlocks(bcfg)) - 1)
                    b = CC.getBlock(bcfg, i)
                    CC.hasTerminator(b) || continue
                    CC.size(b) > 0 || continue
                    CC.getElementKind(b, 0) ==
                        CC.LibClangEx.CXCFGElementKind_Statement || continue
                    target = CC.getElementStmt(b, 0)
                    break
                end
            finally
                CC.dispose(base)
            end
            @test !CC.is_null_handle(target)

            @test !CC.isCFGBuilt(forced)
            CC.registerForcedBlockExpression(forced, target)
            fcfg = CC.getCFG(forced)
            @test !CC.is_null_handle(fcfg)
            fmap = CC.getCFGStmtMap(forced)
            landed = CC.getBlock(fmap, target)
            @test !CC.is_null_handle(landed)
            @test CC.getParent(landed).ptr == fcfg.ptr
        finally
            CC.dispose(forced)
        end

        # a declaration with no body: everything downstream of the body is absent, and
        # nothing crashes on the way there
        @assert f(I, "adc_no_body")
        nb = CC.getAsFunction(CC.get_decl(f))
        nbc = CC.AnalysisDeclContext(nb)
        try
            @test CC.is_null_handle(CC.getBody(nbc))
            @test CC.is_null_handle(CC.getCFG(nbc))
            @test CC.isCFGBuilt(nbc)
            @test CC.is_null_handle(CC.getCFGStmtMap(nbc))
            @test CC.is_null_handle(CC.getCFGReachablityAnalysis(nbc))
            @test CC.is_null_handle(CC.getUnoptimizedCFG(nbc))
            @test startswith(CC.getFunctionName(nb), "adc_no_body")
        finally
            CC.dispose(nbc)
        end

        # a declaration that names no function gets the empty spelling
        @assert f(I, "AdcTag")
        @test isempty(CC.getFunctionName(CC.get_decl(f)))
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | AnalysisDeclContext parenthesized conditions" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int adc_paren_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; }
                if (((x > 1))) { acc = 2; }
                return acc;
            }
            """)
        @assert f(I, "adc_paren_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        adc = CC.AnalysisDeclContext(fd)
        try
            cfg = CC.getCFG(adc)
            @test !CC.is_null_handle(cfg)
            pm = CC.getParentMap(adc)

            direct = 0
            through_parens = 0
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                CC.hasTerminator(b) || continue
                cond = CC.getLastCondition(b)
                CC.is_null_handle(cond) && continue
                term = CC.getTerminatorStmt(b)
                # the parentheses do not change which statement the walk arrives at
                @test CC.getParentIgnoreParens(pm, cond).ptr == term.ptr
                if CC.getParent(pm, cond).ptr == term.ptr
                    direct += 1
                else
                    through_parens += 1
                    @test CC.resolve(CC.getParent(pm, cond)) isa CC.AbstractParenExpr
                    # the outermost paren of that chain is the if's own operand
                    outer = CC.getOuterParenParent(pm, CC.getParent(pm, cond))
                    @test CC.is_null_handle(outer) ||
                          CC.resolve(outer) isa CC.AbstractParenExpr
                end
            end
            @test direct == 1
            @test through_parens == 1
        finally
            CC.dispose(adc)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | AnalysisDeclContextManager" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            struct MgrRAII { int v; MgrRAII(int x) : v(x) {} ~MgrRAII(); };
            int mgr_fn(int n) {
                MgrRAII r(n);
                while (n > 0) { --n; }
                return r.v;
            }
            int mgr_other(int n) { return n + 1; }
            """)
        ctx = CC.get_ast_context(I)
        mgr = CC.AnalysisDeclContextManager(ctx)
        try
            @test !CC.synthesizeBodies(mgr)
            # clang's constructor defaults, read back through the borrowed options object
            mbo = CC.getCFGBuildOptions(mgr)
            @test CC.getPruneTriviallyFalseEdges(mbo)
            @test !CC.getUseUnoptimizedCFG(mgr)
            @test CC.getAddCXXNewAllocator(mbo)
            @test CC.getAddRichCXXConstructors(mbo)
            @test CC.getMarkElidedCXXConstructors(mbo)
            @test CC.getAddVirtualBaseBranches(mbo)
            @test !CC.getAddImplicitDtors(mbo)
            @test !CC.getAddLoopExit(mbo)

            # tuning the manager's options reaches the contexts it creates afterwards
            CC.setAddImplicitDtors(mbo, true)
            CC.setAddLoopExit(mbo, true)
            @test CC.getAddImplicitDtors(mbo)
            @test CC.getAddLoopExit(mbo)

            @assert f(I, "mgr_fn")
            fd = CC.getAsFunction(CC.get_decl(f))
            adc = CC.getContext(mgr, fd)
            @test CC.getManager(adc).ptr == mgr.ptr
            @test CC.getDecl(adc).ptr == fd.ptr
            @test CC.getAddImplicitDtors(adc)
            # the same declaration comes back with the same cached context
            @test CC.getContext(mgr, fd).ptr == adc.ptr

            @assert f(I, "mgr_other")
            other = CC.getAsFunction(CC.get_decl(f))
            @test CC.getContext(mgr, other).ptr != adc.ptr

            cfg = CC.getCFG(adc)
            @test !CC.is_null_handle(cfg)
            found_dtor = false
            found_loop_exit = false
            for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                b = CC.getBlock(cfg, i)
                for j in 0:(Int(CC.size(b)) - 1)
                    k = CC.getElementKind(b, j)
                    if k == CC.LibClangEx.CXCFGElementKind_AutomaticObjectDtor
                        found_dtor = true
                    elseif k == CC.LibClangEx.CXCFGElementKind_LoopExit
                        found_loop_exit = true
                    end
                end
            end
            @test found_dtor
            @test found_loop_exit

            CC.clear(mgr)
            # after clear, the manager mints a fresh context for the same declaration
            @test CC.getContext(mgr, fd).ptr != C_NULL
        finally
            CC.dispose(mgr)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end

@testset "Analysis | AnalysisDeclContext with explicit build options" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int adc_opt_fn(int n) {
                int acc = 0;
                while (n > 0) { acc += n; --n; }
                return acc;
            }
            """)
        @assert f(I, "adc_opt_fn")
        fd = CC.getAsFunction(CC.get_decl(f))

        opts = CC.CFGBuildOptions()
        try
            # the seven build-option booleans that buildCFG takes as parameters are the only
            # way to reach this path, and nothing overwrites them here
            @test !CC.getAddLoopExit(opts)
            CC.setAddLoopExit(opts, true)
            @test CC.getAddLoopExit(opts)
            CC.setAddScopes(opts, true)
            @test CC.getAddScopes(opts)

            adc = CC.AnalysisDeclContext(fd, opts)
            try
                @test CC.getAddLoopExit(CC.getCFGBuildOptions(adc))
                @test CC.getAddScopes(CC.getCFGBuildOptions(adc))
                cfg = CC.getCFG(adc)
                @test !CC.is_null_handle(cfg)
                kinds = Set{CC.LibClangEx.CXCFGElementKind}()
                for i in 0:(Int(CC.getNumBlocks(cfg)) - 1)
                    b = CC.getBlock(cfg, i)
                    for j in 0:(Int(CC.size(b)) - 1)
                        push!(kinds, CC.getElementKind(b, j))
                    end
                end
                @test CC.LibClangEx.CXCFGElementKind_LoopExit in kinds
                @test CC.LibClangEx.CXCFGElementKind_ScopeBegin in kinds
            finally
                CC.dispose(adc)
            end

            # the same seven read back off a default options object as clang's defaults
            fresh = CC.CFGBuildOptions()
            try
                @test !CC.getAddInitializers(fresh)
                @test !CC.getAddImplicitDtors(fresh)
                @test !CC.getAddLifetime(fresh)
                @test !CC.getAddLoopExit(fresh)
                @test !CC.getAddTemporaryDtors(fresh)
                @test !CC.getAddScopes(fresh)
                @test !CC.getAddCXXNewAllocator(fresh)
                for (get, set) in ((CC.getAddInitializers, CC.setAddInitializers),
                                   (CC.getAddImplicitDtors, CC.setAddImplicitDtors),
                                   (CC.getAddLifetime, CC.setAddLifetime),
                                   (CC.getAddLoopExit, CC.setAddLoopExit),
                                   (CC.getAddTemporaryDtors, CC.setAddTemporaryDtors),
                                   (CC.getAddScopes, CC.setAddScopes),
                                   (CC.getAddCXXNewAllocator, CC.setAddCXXNewAllocator))
                    set(fresh, true)
                    @test get(fresh)
                    set(fresh, false)
                    @test !get(fresh)
                end
            finally
                CC.dispose(fresh)
            end
        finally
            CC.dispose(opts)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
