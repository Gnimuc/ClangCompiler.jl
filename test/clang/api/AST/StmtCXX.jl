using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "StmtCXX range-for and coroutine accessors" begin
    function find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, c)
            r === nothing || return r
        end
        return nothing
    end

    # --- CXXForRangeStmt: range-based for over an array ---
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    int sum_range() {
        int arr[3] = {1, 2, 3};
        int total = 0;
        for (int x : arr) { total += x; }
        return total;
    }
    """)
    finder = DeclFinder(I)
    @test finder(I, "sum_range")
    fd = CC.FunctionDecl(get_decl(finder))
    frs = find_node(CC.CXXForRangeStmt, CC.resolve(CC.getBody(fd)))
    @test frs isa CC.CXXForRangeStmt
    if frs isa CC.CXXForRangeStmt
        # no init-statement in this form -> a null carrier, still an AbstractStmt
        @test CC.getInit(frs) isa CC.AbstractStmt
        @test !CC.is_null_handle(CC.getRangeStmt(frs))
        @test !CC.is_null_handle(CC.getLoopVarStmt(frs))
        @test CC.getCond(frs) isa CC.Expr_   # implicit __begin != __end
        @test CC.getInc(frs) isa CC.Expr_    # implicit ++__begin
    end
    dispose(I)

    # --- CoroutineBodyStmt / CoreturnStmt: a minimal coroutine ---
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
    cbs = find_node(CC.CoroutineBodyStmt, root)
    @test cbs isa CC.CoroutineBodyStmt
    if cbs isa CC.CoroutineBodyStmt
        @test !(CC.hasDependentPromiseType(cbs))
        @test CC.hasDependentPromiseType(cbs) == false
        @test CC.resolve(CC.getBody(cbs)) isa CC.CompoundStmt
        @test !CC.is_null_handle(CC.getPromiseDecl(cbs))
        @test CC.getInitSuspendStmt(cbs) isa CC.AbstractStmt
        @test CC.getFinalSuspendStmt(cbs) isa CC.AbstractStmt
        @test CC.getExceptionHandler(cbs) isa CC.AbstractStmt
        @test !CC.is_null_handle(CC.getAllocate(cbs))
        @test !CC.is_null_handle(CC.getDeallocate(cbs))
        @test CC.getReturnStmt(cbs) isa CC.AbstractStmt

        crs = find_node(CC.CoreturnStmt, root)
        @test crs isa CC.CoreturnStmt
        if crs isa CC.CoreturnStmt
            @test !CC.is_null_handle(CC.getKeywordLoc(crs))
            @test !(CC.isImplicit(crs))
            # `co_return;` has no operand -> null carrier
            @test CC.is_null_handle(CC.getOperand(crs))
            @test !CC.is_null_handle(CC.getPromiseCall(crs))
        end
    end
    dispose(J)
end

@testset "CXXForRangeStmt subexpression setters and comment-node refinement" begin
    function find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, c)
            r === nothing || return r
        end
        return nothing
    end

    # Walk a comment tree, exercising the abstract-tier predicates on every node and
    # the ParagraphComment refinement wherever it applies. Returns the paragraph count.
    function walk_comment(c, n)
        c.ptr == C_NULL && return n
        @test CC.isInlineContentComment(c) isa Bool  # shape-only
        @test CC.isBlockContentComment(c) isa Bool  # shape-only
        @test !(CC.isHTMLTagComment(c))
        pc = CC.ParagraphComment(c)
        if pc.ptr != C_NULL
            n += 1
            @test CC.getCommentKind(pc) == CC.CXCommentKind_ParagraphComment
            @test CC.isBlockContentComment(c)
            @test !(CC.isWhitespace(pc))
        end
        for j = 0:(CC.child_count(c) - 1)
            n = walk_comment(CC.getChild(c, j), n)
        end
        return n
    end

    # The init-statement form of the range-based `for` is C++20, and it is the only
    # spelling that gives getInit() a non-null statement to hand back to setInit().
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    /// Sums the elements of a fixed array.
    /// \\returns the sum of the three elements.
    int cc_doc_sum() {
        int arr[3] = {1, 2, 3};
        int total = 0;
        for (int base = 0; int x : arr) { total += x + base; }
        return total;
    }
    """)
    finder = DeclFinder(I)
    @test finder(I, "cc_doc_sum")
    decl = get_decl(finder)
    fd = CC.FunctionDecl(decl)

    frs = find_node(CC.CXXForRangeStmt, CC.resolve(CC.getBody(fd)))
    @test frs isa CC.CXXForRangeStmt
    if frs isa CC.CXXForRangeStmt
        # Every setter is handed back the node its own getter just returned, so the
        # loop is left exactly as Sema built it.
        init, rng = CC.getInit(frs), CC.getRangeStmt(frs)
        beg, fin = CC.getBeginStmt(frs), CC.getEndStmt(frs)
        inc, lv = CC.getInc(frs), CC.getLoopVarStmt(frs)
        if init.ptr != C_NULL
            CC.setInit(frs, init)
            @test CC.getInit(frs).ptr == init.ptr
        end
        CC.setRangeStmt(frs, rng)
        @test CC.getRangeStmt(frs).ptr == rng.ptr
        if beg.ptr != C_NULL
            CC.setBeginStmt(frs, beg)
            @test CC.getBeginStmt(frs).ptr == beg.ptr
        end
        if fin.ptr != C_NULL
            CC.setEndStmt(frs, fin)
            @test CC.getEndStmt(frs).ptr == fin.ptr
        end
        if inc.ptr != C_NULL
            CC.setInc(frs, inc)
            @test CC.getInc(frs).ptr == inc.ptr
        end
        CC.setLoopVarStmt(frs, lv)
        @test CC.getLoopVarStmt(frs).ptr == lv.ptr
    end

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)
    fc = CC.getCommentForDecl(ctx, decl, pp)
    @test fc isa CC.FullComment
    if fc.ptr != C_NULL
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
        @test walk_comment(fc, 0) >= 1
    end

    dispose(finder)
    dispose(I)
end

@testset "Range-for range slot, coroutine sub-statement view, __if_exists and verbatim setters" begin
    function find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, c)
            r === nothing || return r
        end
        return nothing
    end

    function collect_stmts(::Type{T}, x, acc) where {T}
        x isa T && push!(acc, x)
        for c in CC.children(x)
            collect_stmts(T, c, acc)
        end
        return acc
    end

    function collect_comments(root)
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

    # --- CXXForRangeStmt::setRangeInit: the RANGE slot round-trips ---
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    int cc_rangeinit_sum() {
        int arr[3] = {1, 2, 3};
        int total = 0;
        for (int x : arr) { total += x; }
        return total;
    }
    """)
    f = DeclFinder(I)
    @test f(I, "cc_rangeinit_sum")
    fd = CC.FunctionDecl(get_decl(f))
    frs = find_node(CC.CXXForRangeStmt, CC.resolve(CC.getBody(fd)))
    @test frs isa CC.CXXForRangeStmt
    if frs isa CC.CXXForRangeStmt
        rs = CC.getRangeStmt(frs)
        init = CC.getRangeInit(frs)
        @test init isa CC.Expr_
        @test init.ptr != C_NULL
        # setRangeInit writes the slot setRangeStmt owns, so the expression shows up in
        # the raw child list; neither getRangeStmt nor getRangeInit may run until the
        # __range declaration statement is put back.
        CC.setRangeInit(frs, init)
        @test any(c -> c.ptr == init.ptr, CC.children(frs))
        CC.setRangeStmt(frs, rs)
        @test CC.getRangeStmt(frs).ptr == rs.ptr
    end
    dispose(I)

    # --- CoroutineBodyStmt::childrenExclBody as count+index ---
    # The interpreter runs -nostdinc, so <coroutine> is not on the include path on any
    # host. Provide the minimal coroutine support library inline so the coroutine lowers
    # everywhere.
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
    struct cc_excl_task {
        struct promise_type {
            cc_excl_task get_return_object() { return {}; }
            std::suspend_always initial_suspend() noexcept { return {}; }
            std::suspend_always final_suspend() noexcept { return {}; }
            void return_void() noexcept {}
            void unhandled_exception() noexcept {}
        };
    };
    cc_excl_task cc_excl_coro(int p) {
        (void)p;
        co_await std::suspend_always{};
        co_return;
    }
    """)
    cf = DeclFinder(J)
    @test cf(J, "cc_excl_coro")
    cfd = CC.FunctionDecl(get_decl(cf))
    cbs = find_node(CC.CoroutineBodyStmt, CC.resolve(CC.getBody(cfd)))
    @test cbs isa CC.CoroutineBodyStmt
    if cbs isa CC.CoroutineBodyStmt
        n = CC.getNumChildrenExclBody(cbs)
        @test n isa Integer
        @test n > 0
        for i = 0:(Int(n) - 1)
            @test CC.getChildExclBody(cbs, i) isa CC.Stmt  # shape-only
        end
        # The coroutine body is slot 0 of the full child list and the promise
        # declaration slot 1, so the body-excluded view starts at the promise.
        @test CC.getChildExclBody(cbs, 0).ptr == CC.getPromiseDeclStmt(cbs).ptr
    end
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
    mses = collect_stmts(CC.MSDependentExistsStmt, CC.resolve(CC.getBody(mfd)),
                         CC.MSDependentExistsStmt[])
    @test length(mses) == 2
    for m in mses
        @test !CC.is_null_handle(CC.getKeywordLoc(m))
        @test CC.isIfExists(m) isa Bool  # shape-only
        @test CC.isIfNotExists(m) == !CC.isIfExists(m)
        @test CC.getQualifierRange(m) isa CC.SourceRange  # shape-only
        @test !CC.is_null_handle(CC.getQualifier(m))
        @test CC.getSubStmt(m) isa CC.CompoundStmt
        @test CC.getSubStmt(m).ptr != C_NULL
        ni = CC.getNameInfo(m)
        @test ni isa CC.DeclarationNameInfo
        @test ni.ptr != C_NULL
        @test !isempty(CC.getAsString(ni))
        dispose(ni)
    end
    @test any(CC.isIfExists, mses)
    @test any(CC.isIfNotExists, mses)
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
    @test lfc isa CC.FullComment
    if lfc.ptr != C_NULL
        nodes = collect_comments(lfc)

        vbcs = [CC.VerbatimBlockComment(c) for c in nodes]
        filter!(v -> v.ptr != C_NULL, vbcs)
        @test !isempty(vbcs)
        for vbc in vbcs
            old_close = CC.getCloseName(vbc)
            @test old_close isa String
            CC.setCloseName(vbc, lctx, "cc_close_probe", CC.getEndLoc(vbc))
            @test CC.getCloseName(vbc) == "cc_close_probe"
            CC.setCloseName(vbc, lctx, old_close, CC.getEndLoc(vbc))
            @test CC.getCloseName(vbc) == old_close

            nl = Int(CC.getNumLines(vbc))
            @test nl >= 2
            if nl >= 2
                lines = [CC.VerbatimBlockLineComment(CC.getChild(vbc, i)) for i = 0:(nl - 1)]
                @test all(l -> l.ptr != C_NULL, lines)
                texts = [CC.getText(vbc, i) for i = 0:(nl - 1)]
                CC.setLines(vbc, lctx, reverse(lines))
                @test Int(CC.getNumLines(vbc)) == nl
                @test [CC.getText(vbc, i) for i = 0:(nl - 1)] == reverse(texts)
                CC.setLines(vbc, lctx, lines)
                @test [CC.getText(vbc, i) for i = 0:(nl - 1)] == texts
            end
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
    end
    dispose(L)
end
