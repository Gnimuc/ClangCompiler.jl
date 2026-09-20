using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Comments" begin
    I = CC.create_interpreter()
    CC.parse(I, """
             /// \\brief Adds two numbers.
             /// \\param a the first addend
             /// \\param b the second addend
             int cc_doc_add(int a, int b) { return a + b; }
             """)

    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(ci)
    pp = CC.getPreprocessor(ci)

    f = CC.DeclFinder(I)
    @test f(I, "cc_doc_add")
    d = CC.get_decl(f)

    rc = CC.getRawCommentForAnyRedecl(ctx, d)
    @test !CC.is_null_handle(rc)
    # adjacent `///` lines are fused; a single-line `///` would be RCK_BCPLSlash
    @test CC.getKind(rc) == CC.CXRawCommentKind_RCK_Merged
    @test !(CC.isAttached(rc))
    @test !(CC.isTrailingComment(rc))
    @test CC.isDocumentation(rc)
    txt = CC.getRawText(rc, sm)
    @test occursin("brief", txt)
    @test !isempty(CC.getBriefText(rc, ctx))
    rng = CC.getSourceRange(rc)
    @test CC.isValid(rng.begin_loc)
    @test CC.isValid(rng.end_loc)

    fc = CC.getCommentForDecl(ctx, d, pp)
    @test !CC.is_null_handle(fc)
    @test CC.getCommentKindName(fc) == "FullComment"
    @test CC.isValid((CC.getSourceRange(fc)).begin_loc)
    @test CC.isValid((CC.getSourceRange(fc)).end_loc)
    n = Int(CC.child_count(fc))
    names = String[]
    params = String[]
    for i = 0:(n - 1)
        c = CC.getChild(fc, i)
        @test !isempty(CC.getCommentKindName(c))
        for j = 0:(Int(CC.child_count(c)) - 1)
            gc = CC.getChild(c, j)
            tc = CC.TextComment(gc)
            tc.ptr != C_NULL && @test !isempty(CC.getText(tc))
        end
        bcc = CC.BlockCommandComment(c)
        if bcc.ptr != C_NULL
            push!(names, CC.getCommandName(bcc, ctx))
        end
        pcc = CC.ParamCommandComment(c)
        if pcc.ptr != C_NULL && CC.hasParamName(pcc)
            push!(params, CC.getParamNameAsWritten(pcc))
        end
    end
    # ParamCommandComment is a BlockCommandComment, so both `\param`s appear in `names`
    @test names == ["brief", "param", "param"]
    @test params == ["a", "b"]

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Comment subclasses" begin
    I = CC.create_interpreter()
    CC.parse(I, """
             /// \\brief Adds two numbers.
             /// \\param a the first addend
             /// \\param[out] b the second addend
             /// \\return the sum
             int cc_doc_add3(int a, int b) { return a + b; }
             """)

    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)

    f = CC.DeclFinder(I)
    @test f(I, "cc_doc_add3")
    d = CC.get_decl(f)

    fc = CC.getCommentForDecl(ctx, d, pp)
    @test !CC.is_null_handle(fc)
    @test CC.isValid(CC.getBeginLoc(fc))
    @test CC.isValid(CC.getEndLoc(fc))
    @test CC.isValid(CC.getLocation(fc))

    dirs = Bool[]
    pdirs = CC.CXParamCommandPassDirection[]
    cmds = Tuple{String,Int}[]
    pidx = Int[]
    saw_non_ws_text = false
    for i = 0:(Int(CC.child_count(fc)) - 1)
        c = CC.getChild(fc, i)
        @test CC.isValid(CC.getBeginLoc(c))

        bcc = CC.BlockCommandComment(c)
        if bcc.ptr != C_NULL
            cname = CC.getCommandName(bcc, ctx)
            push!(cmds, (cname, Int(CC.getCommandID(bcc))))
            @test CC.isValid(CC.getCommandNameBeginLoc(bcc))
            @test CC.getCommandMarker(bcc) == CC.CXCommandMarkerKind_CMK_Backslash
            @test CC.hasNonWhitespaceParagraph(bcc)
            narg = Int(CC.getNumArgs(bcc))
            if cname == "brief" || cname == "return"
                @test narg == 0
            else
                # `\param` stores the parameter name as argument 0
                @test narg >= 1
                @test !isempty(CC.getArgText(bcc, 0))
                @test CC.isValid((CC.getArgRange(bcc, 0)).begin_loc)
                @test CC.isValid((CC.getArgRange(bcc, 0)).end_loc)
            end
            para = CC.getParagraph(bcc)
            @test !CC.is_null_handle(para)
            # `hasNonWhitespaceParagraph` was just asserted, so this paragraph is the
            # non-whitespace one -- the two accessors have to agree
            @test !CC.isWhitespace(para)
            for j = 0:(Int(CC.child_count(para)) - 1)
                tc = CC.TextComment(CC.getChild(para, j))
                tc.ptr == C_NULL && continue
                if !CC.isWhitespace(tc)
                    saw_non_ws_text = true
                    @test occursin("two numbers", CC.getText(tc)) ||
                          occursin("first addend", CC.getText(tc)) ||
                          occursin("second addend", CC.getText(tc)) ||
                          occursin("sum", CC.getText(tc))
                end
            end
        end

        pcc = CC.ParamCommandComment(c)
        if pcc.ptr != C_NULL
            push!(pdirs, CC.getDirection(pcc))
            push!(dirs, CC.isDirectionExplicit(pcc))
            @test CC.isParamIndexValid(pcc)
            @test !(CC.isVarArgParam(pcc))
            CC.hasParamName(pcc) && @test CC.isValid((CC.getParamNameRange(pcc)).begin_loc)
            CC.hasParamName(pcc) && @test CC.isValid((CC.getParamNameRange(pcc)).end_loc)
            if CC.isParamIndexValid(pcc) && !CC.isVarArgParam(pcc)
                push!(pidx, Int(CC.getParamIndex(pcc)))
            end
        end
    end
    @test saw_non_ws_text
    # `\param a` is written with no direction and `\param[out] b` with one, so this
    # source puts one comment on each side. A predicate reading a neighbouring bit --
    # or the direction enum itself, which is set either way -- is constant here.
    @test sort(dirs) == [false, true]
    @test sort(pdirs) == [CC.CXParamCommandPassDirection_In, CC.CXParamCommandPassDirection_Out]

    # The command ID indexes clang's CommandTraits table, so its numeric value moves
    # with the clang release and pinning it would break on the next one. What does not
    # move is that the ID and the name agree: this source writes \brief, \param twice
    # and \return, so three distinct names carry three distinct IDs and the repeated
    # name repeats its own. A swallowed ID collapses that to one and fails here.
    @test length(cmds) == 4
    @test length(unique(last.(cmds))) == length(unique(first.(cmds))) == 3
    @test allunique(unique(cmds))
    for (n1, i1) in cmds, (n2, i2) in cmds
        @test (n1 == n2) == (i1 == i2)
    end

    # `\param a` and `\param[out] b` name the first and second parameters of
    # `cc_doc_add3(int a, int b)`. An accessor ignoring its subject reports 0 twice.
    @test sort(pidx) == [0, 1]

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Comment inline content, HTML tags and tparam" begin
    I = create_interpreter()
    CC.parse(I, """
             /// \\brief Adds <b class="lead">two</b> \\c int values.
             /// \\tparam T the element type
             /// \\param a the first addend
             template <typename T> T cc_doc_rich(T a) { return a; }
             """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)

    f = DeclFinder(I)
    @test f(I, "cc_doc_rich")
    # Comment Sema resolves a \tparam name against the template parameter list that
    # DeclInfo carries, and only the FunctionTemplateDecl has one — the FunctionDecl it
    # templates does not, so its \tparam stays unresolved.
    d = first(x for x in CC.get_decls(f) if CC.getDeclKindName(x) == "FunctionTemplate")

    fc = CC.getCommentForDecl(ctx, d, pp)
    @test !CC.is_null_handle(fc)
    owner = CC.getDecl(fc)
    @test CC.getDeclKindName(owner) == "FunctionTemplate"
    @test CC.getNameAsString(CC.NamedDecl(owner)) == "cc_doc_rich"

    nodes = CC.Comment[]
    queue = CC.Comment[CC.getChild(fc, i) for i = 0:(Int(CC.child_count(fc)) - 1)]
    while !isempty(queue)
        c = popfirst!(queue)
        push!(nodes, c)
        for i = 0:(Int(CC.child_count(c)) - 1)
            push!(queue, CC.getChild(c, i))
        end
    end
    @test !isempty(nodes)

    inline_names = String[]
    inline_cmds = Tuple{String,Int}[]
    tag_names = String[]
    attr_names = String[]
    tparam_names = String[]
    n_end_tags = 0
    for c in nodes
        icc = CC.InlineCommandComment(c)
        if icc.ptr != C_NULL
            push!(inline_cmds, (CC.getCommandName(icc, ctx), Int(CC.getCommandID(icc))))
            @test CC.isValid((CC.getCommandNameRange(icc)).begin_loc)
            @test CC.isValid((CC.getCommandNameRange(icc)).end_loc)
            @test CC.getRenderKind(icc) == CC.CXInlineCommandRenderKind_Monospaced
            push!(inline_names, CC.getCommandName(icc, ctx))
            @test CC.getNumArgs(icc) == 1
            @test CC.getArgText(icc, 0) == "int"
            @test CC.isValid((CC.getArgRange(icc, 0)).begin_loc)
            @test CC.isValid((CC.getArgRange(icc, 0)).end_loc)
        end

        hst = CC.HTMLStartTagComment(c)
        if hst.ptr != C_NULL
            @test CC.isValid((CC.getTagNameSourceRange(hst)).begin_loc)
            @test CC.isValid((CC.getTagNameSourceRange(hst)).end_loc)
            @test !(CC.isMalformed(hst))
            @test !(CC.isSelfClosing(hst))
            push!(tag_names, CC.getTagName(hst))
            @test CC.getNumAttrs(hst) == 1
            push!(attr_names, CC.getAttrName(hst, 0))
            @test CC.getAttrValue(hst, 0) == "lead"
        end

        het = CC.HTMLEndTagComment(c)
        if het.ptr != C_NULL
            n_end_tags += 1
            @test !(CC.isMalformed(het))
            push!(tag_names, CC.getTagName(het))
        end

        tpc = CC.TParamCommandComment(c)
        if tpc.ptr != C_NULL
            @test CC.isPositionValid(tpc)
            if CC.hasParamName(tpc)
                push!(tparam_names, CC.getParamNameAsWritten(tpc))
                @test CC.isValid((CC.getParamNameRange(tpc)).begin_loc)
                @test CC.isValid((CC.getParamNameRange(tpc)).end_loc)
            end
            # `T` is the sole parameter of the sole template parameter list of
            # cc_doc_rich, so Sema resolves the \tparam to position {0} and the
            # depth/index accessors are in range.
            @test CC.getDepth(tpc) == 1
            @test CC.getIndex(tpc, 0) == 0
            @test_throws AssertionError CC.getIndex(tpc, 1)
        end
    end

    @test "c" in inline_names
    # same agreement as the block commands: the table index is not pinnable across
    # clang releases, but a name and its ID have to identify each other
    @test !isempty(inline_cmds)
    for (n1, i1) in inline_cmds, (n2, i2) in inline_cmds
        @test (n1 == n2) == (i1 == i2)
    end
    @test "b" in tag_names
    @test n_end_tags == 1
    @test attr_names == ["class"]
    @test tparam_names == ["T"]

    dispose(f)
    dispose(I)
end

@testset "Comment verbatim nodes, DeclInfo and resolved parameter names" begin
    I = create_interpreter()
    CC.parse(I, """
             /// \\brief Adds two numbers.
             /// \\defgroup cc_doc_vb_group The verbatim group
             /// \\code
             ///   int r = cc_doc_vb(1, 2);
             /// \\endcode
             /// \\param a the first addend
             /// \\param b the second addend
             int cc_doc_vb(int a, int b) { return a + b; }

             /// \\brief Identity for <b class="lead">any</b> type.
             /// \\tparam T the element type
             /// \\param x the value
             template <typename T> T cc_doc_vb_ident(T x) { return x; }
             """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)

    # ParamCommandComment::getDirectionAsString is static — it needs no comment node.
    @test CC.getDirectionAsString(CC.CXParamCommandPassDirection_In) == "[in]"
    @test CC.getDirectionAsString(CC.CXParamCommandPassDirection_Out) == "[out]"
    @test CC.getDirectionAsString(CC.CXParamCommandPassDirection_InOut) == "[in,out]"

    function collect_nodes(root)
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

    f = DeclFinder(I)
    @test f(I, "cc_doc_vb")
    d = get_decl(f)

    fc = CC.getCommentForDecl(ctx, d, pp)
    @test !CC.is_null_handle(fc)
    # getBlocks() as count+index: FullComment::child_begin/child_end walk exactly
    # the Blocks array, so the two views must agree element for element.
    nb = Int(CC.getNumBlocks(fc))
    @test nb == Int(CC.child_count(fc))
    @test nb >= 1
    for i = 0:(nb - 1)
        @test CC.getBlock(fc, i).ptr == CC.getChild(fc, i).ptr
    end

    di = CC.getDeclInfo(fc)
    @test !CC.is_null_handle(di)
    @test CC.getKind(di) == CC.CXDeclInfo_FunctionKind
    @test CC.getTemplateKind(di) == CC.CXDeclInfo_NotTemplate
    @test CC.involvesFunctionType(di)

    close_names = String[]
    block_lines = String[]
    line_texts = String[]
    verbatim_lines = String[]
    param_names = String[]
    for c in collect_nodes(fc)
        bcc = CC.BlockCommandComment(c)
        bcc.ptr != C_NULL && @test CC.isValid((CC.getCommandNameRange(bcc, ctx)).begin_loc)
        bcc.ptr != C_NULL && @test CC.isValid((CC.getCommandNameRange(bcc, ctx)).end_loc)

        vbc = CC.VerbatimBlockComment(c)
        if vbc.ptr != C_NULL
            push!(close_names, CC.getCloseName(vbc))
            nl = Int(CC.getNumLines(vbc))
            @test nl >= 1
            for k = 0:(nl - 1)
                push!(block_lines, CC.getText(vbc, k))
            end
        end

        vblc = CC.VerbatimBlockLineComment(c)
        vblc.ptr != C_NULL && push!(line_texts, CC.getText(vblc))

        vlc = CC.VerbatimLineComment(c)
        if vlc.ptr != C_NULL
            push!(verbatim_lines, CC.getText(vlc))
            @test CC.isValid((CC.getTextRange(vlc)).begin_loc)
            @test CC.isValid((CC.getTextRange(vlc)).end_loc)
        end

        pcc = CC.ParamCommandComment(c)
        if pcc.ptr != C_NULL && CC.isParamIndexValid(pcc)
            push!(param_names, CC.getParamName(pcc, fc))
        end
    end

    @test "endcode" in close_names
    @test any(s -> occursin("cc_doc_vb", s), block_lines)
    # getText(vbc, i) forwards to Lines[i]->getText(), the same nodes the walk saw.
    @test line_texts == block_lines
    @test any(s -> occursin("cc_doc_vb_group", s), verbatim_lines)
    @test param_names == ["a", "b"]

    @test f(I, "cc_doc_vb_ident")
    td = first(x for x in CC.get_decls(f) if CC.getDeclKindName(x) == "FunctionTemplate")
    tfc = CC.getCommentForDecl(ctx, td, pp)
    @test !CC.is_null_handle(tfc)
    tdi = CC.getDeclInfo(tfc)
    @test CC.getKind(tdi) == CC.CXDeclInfo_FunctionKind
    @test CC.getTemplateKind(tdi) == CC.CXDeclInfo_Template
    @test CC.involvesFunctionType(tdi)

    n_attrs = 0
    tparam_names = String[]
    for c in collect_nodes(tfc)
        hst = CC.HTMLStartTagComment(c)
        if hst.ptr != C_NULL
            for k = 0:(Int(CC.getNumAttrs(hst)) - 1)
                n_attrs += 1
                @test CC.isValid((CC.getAttrNameRange(hst, k)).begin_loc)
                @test CC.isValid((CC.getAttrNameRange(hst, k)).end_loc)
                @test CC.isValid(CC.getAttrNameLocEnd(hst, k))
            end
        end

        tpc = CC.TParamCommandComment(c)
        if tpc.ptr != C_NULL && CC.isPositionValid(tpc)
            push!(tparam_names, CC.getParamName(tpc, tfc))
        end
    end
    @test n_attrs == 1
    @test tparam_names == ["T"]

    dispose(f)
    dispose(I)
end

@testset "Comment node kinds and mutators; coroutine body sub-statements" begin
    # --- documentation comment node kinds and mutators ---
    I = create_interpreter()
    CC.parse(I, """
             /// \\brief Adds <b>two</b> numbers.
             /// \\param a the first addend
             /// \\param b the second addend
             int cc_mutate_add(int a, int b) { return a + b; }
             """)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(get_instance(I))
    f = DeclFinder(I)
    @test f(I, "cc_mutate_add")
    fc = CC.getCommentForDecl(ctx, get_decl(f), pp)
    @test !CC.is_null_handle(fc)

    # child_count is an unsigned C count: widen it before building a range, or a
    # childless node turns `0:(n - 1)` into a 2^32-long loop.
    nchild(c) = Int(CC.child_count(c))
    nodes = CC.Comment[]
    queue = CC.Comment[CC.getChild(fc, i) for i = 0:(nchild(fc) - 1)]
    while !isempty(queue)
        c = popfirst!(queue)
        push!(nodes, c)
        append!(queue, CC.Comment[CC.getChild(c, i) for i = 0:(nchild(c) - 1)])
    end
    @test !isempty(nodes)

    # getCommentKind and getCommentKindName are stamped from the same class list,
    # so the enumerator name is always the kind name with the mirror's prefix.
    @test CC.getCommentKind(fc) == CC.CXCommentKind_FullComment
    @test string(CC.getCommentKind(fc)) == "CXCommentKind_FullComment"
    for c in nodes
        @test string(CC.getCommentKind(c)) == "CXCommentKind_" * CC.getCommentKindName(c)
    end

    texts = filter(t -> t.ptr != C_NULL, [CC.TextComment(c) for c in nodes])
    @test !isempty(texts)
    if !isempty(texts)
        tc = first(texts)
        @test !(CC.hasTrailingNewline(tc))
        CC.addTrailingNewline(tc)
        @test CC.hasTrailingNewline(tc)
    end

    tags = filter(h -> h.ptr != C_NULL, [CC.HTMLStartTagComment(c) for c in nodes])
    @test !isempty(tags)   # the <b> opening the brief paragraph
    if !isempty(tags)
        h = first(tags)
        # Feeding setGreaterLoc back the range end it already carries is a no-op.
        e = CC.getSourceRange(h).end_loc
        CC.setGreaterLoc(h, e)
        @test CC.getSourceRange(h).end_loc.ptr == e.ptr
        @test !(CC.isSelfClosing(h))
        CC.setSelfClosing(h)
        @test CC.isSelfClosing(h)
        @test !(CC.isMalformed(h))
        CC.setIsMalformed(h)
        @test CC.isMalformed(h)
    end

    blocks = filter(b -> b.ptr != C_NULL, [CC.BlockCommandComment(c) for c in nodes])
    @test !isempty(blocks)
    for b in blocks
        p = CC.getParagraph(b)
        p.ptr == C_NULL && continue
        CC.setParagraph(b, p)
        @test CC.getParagraph(b).ptr == p.ptr
    end

    params = filter(p -> p.ptr != C_NULL, [CC.ParamCommandComment(c) for c in nodes])
    @test !isempty(params)
    for p in params
        d, ex = CC.getDirection(p), CC.isDirectionExplicit(p)
        CC.setDirection(p, d, ex)
        @test CC.getDirection(p) == d
        @test CC.isDirectionExplicit(p) == ex
        if CC.isParamIndexValid(p) && !CC.isVarArgParam(p)
            idx = CC.getParamIndex(p)
            CC.setParamIndex(p, idx)
            @test CC.getParamIndex(p) == idx
        end
    end
    # setIsVarArgParam is one-way — getParamIndex asserts afterwards — so it runs last.
    if !isempty(params)
        p = last(params)
        CC.setIsVarArgParam(p)
        @test CC.isVarArgParam(p)
        @test CC.isParamIndexValid(p)
    end
    dispose(I)

    # --- coroutine body sub-statements and range-for setters ---
    function find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, c)
            r === nothing || return r
        end
        return nothing
    end

    # The interpreter runs -nostdinc, so <coroutine> is on no host's include path:
    # the minimal coroutine support library has to travel with the test.
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
    struct moved_task {
        struct promise_type {
            moved_task get_return_object() { return {}; }
            std::suspend_always initial_suspend() noexcept { return {}; }
            std::suspend_always final_suspend() noexcept { return {}; }
            void return_void() noexcept {}
            void unhandled_exception() noexcept {}
        };
    };
    moved_task coro_with_param(int a) {
        co_await std::suspend_always{};
        co_return;
    }
    int sum_over_array() {
        int arr[3] = {1, 2, 3};
        int total = 0;
        for (int x : arr) { total += x; }
        return total;
    }
    """)

    cf = DeclFinder(J)
    @test cf(J, "coro_with_param")
    cfd = CC.FunctionDecl(get_decl(cf))
    croot = CC.resolve(CC.getBody(cfd))
    cbs = find_node(CC.CoroutineBodyStmt, croot)
    @test cbs isa CC.CoroutineBodyStmt
    pds = CC.getPromiseDeclStmt(cbs)
    @test !CC.is_null_handle(pds)
    @test CC.resolve(pds) isa CC.DeclStmt
    # this promise has no `get_return_object_on_allocation_failure`
    @test CC.is_null_handle(CC.getReturnStmtOnAllocFailure(cbs))
    @test !CC.is_null_handle(CC.getReturnValueInit(cbs))
    # `co_return;` yields nothing
    @test CC.is_null_handle(CC.getReturnValue(cbs))
    @test Int(CC.getNumParamMoves(cbs)) == 1
    @test CC.resolve(CC.getParamMove(cbs, 0)) isa CC.DeclStmt
    @test_throws AssertionError CC.getParamMove(cbs, 1)

    crs = find_node(CC.CoreturnStmt, croot)
    @test crs isa CC.CoreturnStmt
    v = CC.isImplicit(crs)
    CC.setIsImplicit(crs, v)
    @test CC.isImplicit(crs) == v

    rf = DeclFinder(J)
    @test rf(J, "sum_over_array")
    rfd = CC.FunctionDecl(get_decl(rf))
    frs = find_node(CC.CXXForRangeStmt, CC.resolve(CC.getBody(rfd)))
    @test frs isa CC.CXXForRangeStmt
    body = CC.getBody(frs)
    CC.setBody(frs, body)
    @test CC.getBody(frs).ptr == body.ptr
    cond = CC.getCond(frs)
    CC.setCond(frs, cond)
    @test CC.getCond(frs).ptr == cond.ptr
    dispose(J)
end

@testset "RawComment | formatted text and almost-trailing comments" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             /// a documented function
             /// spanning two lines
             int rc_documented(int a);
             int rc_plain(int b); // not a trailing doc comment
             """)
    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(ci)
    diags = CC.getDiagnostics(ci)

    f = DeclFinder(I)
    @test f(I, "rc_documented")
    fd = CC.FunctionDecl(get_decl(f))
    rc = CC.getRawCommentForDeclNoCache(ctx, fd)
    @test !CC.is_null_handle(rc)

    raw = CC.getRawText(rc, sm)
    fmt = CC.getFormattedText(rc, sm, diags)
    # the decoration is present in the raw bytes and gone from the formatted text, while the
    # words survive both
    @test occursin("///", raw)
    @test !occursin("///", fmt)
    @test occursin("a documented function", fmt)
    @test occursin("spanning two lines", fmt)
    @test fmt != raw

    # a `///` comment above a declaration is a real doc comment, not an almost-trailing one
    @test !CC.isAlmostTrailingComment(rc)

    dispose(f)
    dispose(I)
end

@testset "RawCommentList | comments attached to a file" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             /// first documented declaration
             int rcl_one(int a);
             /// second documented declaration
             int rcl_two(int b);
             """)
    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(ci)

    rcl = CC.getComments(ctx)
    # the parse attached comments, so the list is not empty
    @test !CC.empty(rcl)

    f = DeclFinder(I)
    @test f(I, "rcl_one")
    fd = CC.FunctionDecl(get_decl(f))
    fid = CC.getFileID(sm, CC.getLocation(fd))
    comments = CC.getCommentsInFile(rcl, fid)
    # both comments the source declares are present, and their texts are the ones written
    @test length(comments) >= 2
    texts = [CC.getRawText(c, sm) for c in comments]
    @test any(t -> occursin("first documented declaration", t), texts)
    @test any(t -> occursin("second documented declaration", t), texts)
    # they come back in source order
    offsets = [CC.getFileOffset(sm, CC.getBeginLoc(CC.getSourceRange(c))) for c in comments]
    @test issorted(offsets)

    # the incremental snippet is not the interpreter's main file, so that FileID
    # answers with an empty snapshot rather than the comments above
    other = CC.getMainFileID(sm)
    @test isempty(CC.getCommentsInFile(rcl, other))
    CC.dispose(other)

    CC.dispose(fid)
    dispose(f)
    dispose(I)
end
