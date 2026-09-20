using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

if !@isdefined(_stmtcxx_find_node)
    function _stmtcxx_find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = _stmtcxx_find_node(T, c)
            r === nothing || return r
        end
        return nothing
    end

    function _stmtcxx_collect_stmts(::Type{T}, x, acc) where {T}
        x isa T && push!(acc, x)
        for c in CC.children(x)
            _stmtcxx_collect_stmts(T, c, acc)
        end
        return acc
    end

    function _stmtcxx_collect_comments(root)
        nodes = CC.Comment[]
        queue = CC.Comment[CC.getChild(root, i) for i = 0:(Int(CC.child_count(root)) - 1)]
        while !isempty(queue)
            c = popfirst!(queue)
            push!(nodes, c)
            for i = 0:(Int(CC.child_count(c)) - 1)
                push!(queue, CC.getChild(c, i))
            end
        end
        return nodes
    end

    # Walk a comment tree, exercising the abstract-tier predicates on every node and
    # the ParagraphComment refinement wherever it applies. Returns the paragraph count.
    function _stmtcxx_walk_comment(c, n)
        c.ptr == C_NULL && return n
        # InlineContentComment and BlockContentComment are disjoint branches of the
        # Comment hierarchy, so no node is both. Two predicates wired to the same
        # underlying query -- the way a copy-paste slip in the shim reads -- would be
        # equal instead, and both true on every content node.
        @test !(CC.isInlineContentComment(c) && CC.isBlockContentComment(c))
        @test !(CC.isHTMLTagComment(c))
        pc = CC.ParagraphComment(c)
        if pc.ptr != C_NULL
            n += 1
            @test CC.getCommentKind(pc) == CC.CXCommentKind_ParagraphComment
            @test CC.isBlockContentComment(c)
            @test !(CC.isWhitespace(pc))
        end
        for j = 0:(CC.child_count(c) - 1)
            n = _stmtcxx_walk_comment(CC.getChild(c, j), n)
        end
        return n
    end
end

@testset "CXXForRangeStmt accessors, subexpression setters, and comment refinement" begin
    # The init-statement form is C++20, and it is the only spelling that gives
    # getInit() a non-null statement. The no-init form is the complementary polarity.
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    /// Sums the elements of a fixed array.
    /// \\returns the sum of the three elements.
    int cc_doc_sum() {
        int arr[3] = {1, 2, 3};
        int total = 0;
        for (int x : arr) { total += x; }
        for (int base = 0; int x : arr) { total += x + base; }
        return total;
    }
    """)
    finder = DeclFinder(I)
    @test finder(I, "cc_doc_sum")
    decl = get_decl(finder)
    fd = CC.FunctionDecl(decl)
    frss = _stmtcxx_collect_stmts(CC.CXXForRangeStmt, CC.resolve(CC.getBody(fd)), CC.CXXForRangeStmt[])
    @test length(frss) == 2
    noinit = only(f for f in frss if CC.getInit(f).ptr == C_NULL)
    within = only(f for f in frss if CC.getInit(f).ptr != C_NULL)

    # the condition and increment clang synthesises are `__begin != __end` and
    # `++__begin`; asserting their operators is what separates the two accessors,
    # which `isa Expr_` cannot do because both wrappers return one
    cond = CC.resolve(CC.getCond(noinit))
    @test cond isa CC.AbstractBinaryOperator
    @test CC.getOpcode(cond) == CC.LibClangEx.CXBinaryOperatorKind_BO_NE
    inc = CC.resolve(CC.getInc(noinit))
    @test inc isa CC.AbstractUnaryOperator
    @test CC.getOpcode(inc) == CC.LibClangEx.CXUnaryOperatorKind_UO_PreInc
    @test CC.getRangeStmt(noinit).ptr != C_NULL
    @test CC.getLoopVarStmt(noinit).ptr != C_NULL

    # Every setter is handed back the node its own getter just returned, so the
    # loop is left exactly as Sema built it.
    init, rng = CC.getInit(within), CC.getRangeStmt(within)
    beg, fin = CC.getBeginStmt(within), CC.getEndStmt(within)
    inc2, lv = CC.getInc(within), CC.getLoopVarStmt(within)
    @test init.ptr != C_NULL
    CC.setInit(within, init)
    @test CC.getInit(within).ptr == init.ptr
    CC.setRangeStmt(within, rng)
    @test CC.getRangeStmt(within).ptr == rng.ptr
    @test beg.ptr != C_NULL
    CC.setBeginStmt(within, beg)
    @test CC.getBeginStmt(within).ptr == beg.ptr
    @test fin.ptr != C_NULL
    CC.setEndStmt(within, fin)
    @test CC.getEndStmt(within).ptr == fin.ptr
    @test inc2.ptr != C_NULL
    CC.setInc(within, inc2)
    @test CC.getInc(within).ptr == inc2.ptr
    CC.setLoopVarStmt(within, lv)
    @test CC.getLoopVarStmt(within).ptr == lv.ptr

    # setRangeInit writes the slot setRangeStmt owns, so the expression shows up in
    # the raw child list; neither getRangeStmt nor getRangeInit may run until the
    # __range declaration statement is put back.
    rs = CC.getRangeStmt(noinit)
    rinit = CC.getRangeInit(noinit)
    @test rinit.ptr != C_NULL
    CC.setRangeInit(noinit, rinit)
    @test any(c -> c.ptr == rinit.ptr, CC.children(noinit))
    CC.setRangeStmt(noinit, rs)
    @test CC.getRangeStmt(noinit).ptr == rs.ptr

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)
    fc = CC.getCommentForDecl(ctx, decl, pp)
    @test fc.ptr != C_NULL
    # Both dumpers write to stderr and return nothing.
    @test CC.dump(fc) === nothing
    @test CC.dumpColor(fc) === nothing
    @test CC.FullComment(fc).ptr == fc.ptr
    @test CC.ParagraphComment(fc).ptr == C_NULL
    @test CC.isInlineContentComment(fc) == false
    @test CC.isBlockContentComment(fc) == false
    @test CC.isHTMLTagComment(fc) == false
    # The free-text first line parses to a paragraph, and so does the body of the
    # \returns command, so at least one node refines to ParagraphComment.
    @test _stmtcxx_walk_comment(fc, 0) >= 1

    dispose(finder)
    dispose(I)
end

@testset "CoroutineBodyStmt view, __if_exists polarities, and verbatim setters" begin
    # The interpreter runs -nostdinc, so <coroutine> is not on the include path on
    # any host. Provide the minimal coroutine support library inline (the same shim
    # clang's own coroutine tests use) so the coroutine actually lowers everywhere.
    J = create_interpreter(["-std=c++20"])
    CC.parse(J, """
    namespace std {
    template <class Ret, class... Args> struct coroutine_traits {
        using promise_type = typename Ret::promise_type;
    };
    template <class Promise = void> struct coroutine_handle;
    template <> struct coroutine_handle<void> {
        static coroutine_handle from_address(void *) noexcept { return {}; }
        void *address() const noexcept { return nullptr; }
    };
    template <class Promise> struct coroutine_handle {
        operator coroutine_handle<>() const noexcept { return {}; }
        static coroutine_handle from_address(void *) noexcept { return {}; }
        static coroutine_handle from_promise(Promise &) noexcept { return {}; }
        void *address() const noexcept { return nullptr; }
        Promise &promise() const noexcept { return *static_cast<Promise *>(nullptr); }
    };
    struct suspend_always {
        bool await_ready() const noexcept { return false; }
        void await_suspend(coroutine_handle<>) const noexcept {}
        void await_resume() const noexcept {}
    };
    }
    struct task {
        struct promise_type {
            task get_return_object() { return {}; }
            std::suspend_always initial_suspend() noexcept { return {}; }
            std::suspend_always final_suspend() noexcept { return {}; }
            void return_void() noexcept {}
            void unhandled_exception() noexcept {}
        };
    };
    task coro() {
        co_await std::suspend_always{};
        co_return;
    }
    """)
    cfinder = DeclFinder(J)
    @test cfinder(J, "coro")
    cfd = CC.FunctionDecl(get_decl(cfinder))
    root = CC.resolve(CC.getBody(cfd))
    cbs = _stmtcxx_find_node(CC.CoroutineBodyStmt, root)
    @test cbs isa CC.CoroutineBodyStmt
    @test CC.hasDependentPromiseType(cbs) == false
    @test CC.resolve(CC.getBody(cbs)) isa CC.CompoundStmt
    @test CC.getPromiseDecl(cbs).ptr != C_NULL
    @test CC.getInitSuspendStmt(cbs).ptr != CC.getFinalSuspendStmt(cbs).ptr
    @test CC.getAllocate(cbs).ptr != C_NULL
    @test CC.getDeallocate(cbs).ptr != C_NULL
    @test CC.getAllocate(cbs).ptr != CC.getDeallocate(cbs).ptr
    @test CC.getExceptionHandler(cbs).ptr != CC.getBody(cbs).ptr
    @test CC.getReturnStmt(cbs).ptr != CC.getBody(cbs).ptr

    n = CC.getNumChildrenExclBody(cbs)
    @test n >= 2
    body = CC.getBody(cbs)
    for i = 0:(Int(n) - 1)
        # what "ExclBody" means: the body is the one child this view never yields
        @test CC.getChildExclBody(cbs, i).ptr != body.ptr
    end
    # The coroutine body is slot 0 of the full child list and the promise
    # declaration slot 1, so the body-excluded view starts at the promise.
    @test CC.getChildExclBody(cbs, 0).ptr == CC.getPromiseDeclStmt(cbs).ptr
    @test CC.getChildExclBody(cbs, n - 1).ptr != CC.getChildExclBody(cbs, 0).ptr

    crs = _stmtcxx_find_node(CC.CoreturnStmt, root)
    @test crs isa CC.CoreturnStmt
    @test !CC.is_null_handle(CC.getKeywordLoc(crs))
    @test !(CC.isImplicit(crs))
    # `co_return;` has no operand -> null carrier
    @test CC.is_null_handle(CC.getOperand(crs))
    @test !CC.is_null_handle(CC.getPromiseCall(crs))
    dispose(J)

    # --- MSDependentExistsStmt: a dependent __if_exists / __if_not_exists pair ---
    K = create_interpreter(["-std=c++20", "-fms-extensions"])
    CC.parse(K, """
    template <typename T> void cc_mse_probe() {
        __if_exists(T::member) { int found = 1; }
        __if_not_exists(T::missing) { int absent = 1; }
    }
    """)
    mf = DeclFinder(K)
    @test mf(K, "cc_mse_probe")
    mtd = first(d for d in CC.get_decls(mf) if CC.getDeclKindName(d) == "FunctionTemplate")
    mfd = CC.getTemplatedDecl(CC.FunctionTemplateDecl(mtd))
    mses = _stmtcxx_collect_stmts(CC.MSDependentExistsStmt, CC.resolve(CC.getBody(mfd)), CC.MSDependentExistsStmt[])
    @test length(mses) == 2
    # the source writes one `__if_exists` and one `__if_not_exists`, so the predicate has
    # to separate them; one wired to a constant or to the wrong bit gives 0 or 2
    @test count(CC.isIfExists, mses) == 1
    for m in mses
        @test CC.isIfNotExists(m) == !CC.isIfExists(m)
        @test CC.isValid((CC.getQualifierRange(m)).begin_loc)
        @test CC.isValid((CC.getQualifierRange(m)).end_loc)
        @test !CC.is_null_handle(CC.getQualifier(m))
        @test CC.getSubStmt(m) isa CC.CompoundStmt
        ni = CC.getNameInfo(m)
        @test !isempty(CC.getAsString(ni))
        dispose(ni)
    end
    dispose(K)

    # --- VerbatimBlockComment / TParamCommandComment array setters ---
    L = create_interpreter()
    CC.parse(L, """
             /// \\brief Duplicates a value.
             /// \\code
             ///   int a = cc_cmt_dup(1);
             ///   int b = cc_cmt_dup(2);
             /// \\endcode
             /// \\tparam T the element type
             /// \\param x the value
             template <typename T> T cc_cmt_dup(T x) { return x; }
             """)
    lctx = CC.get_ast_context(L)
    lpp = CC.getPreprocessor(get_instance(L))
    lf = DeclFinder(L)
    @test lf(L, "cc_cmt_dup")
    ltd = first(d for d in CC.get_decls(lf) if CC.getDeclKindName(d) == "FunctionTemplate")
    lfc = CC.getCommentForDecl(lctx, ltd, lpp)
    @test lfc.ptr != C_NULL
    nodes = _stmtcxx_collect_comments(lfc)

    vbcs = [CC.VerbatimBlockComment(c) for c in nodes]
    filter!(v -> v.ptr != C_NULL, vbcs)
    @test !isempty(vbcs)
    for vbc in vbcs
        old_close = CC.getCloseName(vbc)
        CC.setCloseName(vbc, lctx, "cc_close_probe", CC.getEndLoc(vbc))
        @test CC.getCloseName(vbc) == "cc_close_probe"
        CC.setCloseName(vbc, lctx, old_close, CC.getEndLoc(vbc))
        @test CC.getCloseName(vbc) == old_close

        nl = Int(CC.getNumLines(vbc))
        @test nl >= 2
        lines = [CC.VerbatimBlockLineComment(CC.getChild(vbc, i)) for i = 0:(nl - 1)]
        @test all(l -> l.ptr != C_NULL, lines)
        texts = [CC.getText(vbc, i) for i = 0:(nl - 1)]
        @test texts[1] != texts[end]
        CC.setLines(vbc, lctx, reverse(lines))
        @test Int(CC.getNumLines(vbc)) == nl
        @test [CC.getText(vbc, i) for i = 0:(nl - 1)] == reverse(texts)
        CC.setLines(vbc, lctx, lines)
        @test [CC.getText(vbc, i) for i = 0:(nl - 1)] == texts
    end

    tpcs = [CC.TParamCommandComment(c) for c in nodes]
    filter!(t -> t.ptr != C_NULL && CC.isPositionValid(t), tpcs)
    @test !isempty(tpcs)
    for tpc in tpcs
        d = Int(CC.getDepth(tpc))
        orig = [CC.getIndex(tpc, k) for k = 0:(d - 1)]
        CC.setPosition(tpc, lctx, [7])
        @test Int(CC.getDepth(tpc)) == 1
        @test CC.getIndex(tpc, 0) == 7
        # Restore before anything resolves the parameter name against the position.
        CC.setPosition(tpc, lctx, orig)
        @test Int(CC.getDepth(tpc)) == d
        @test [CC.getIndex(tpc, k) for k = 0:(d - 1)] == orig
    end
    dispose(L)
end
