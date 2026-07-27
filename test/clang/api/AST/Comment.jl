using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
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
    @test rc isa CC.RawComment
    if rc.ptr != C_NULL
        @test CC.getKind(rc) isa Enum
        @test CC.isAttached(rc) isa Bool
        @test CC.isTrailingComment(rc) isa Bool
        @test CC.isDocumentation(rc) isa Bool
        txt = CC.getRawText(rc, sm)
        @test txt isa String
        @test occursin("brief", txt)
        @test CC.getBriefText(rc, ctx) isa String
        rng = CC.getSourceRange(rc)
        @test rng isa CC.SourceRange
        @test rng.begin_loc isa CC.SourceLocation
    end

    fc = CC.getCommentForDecl(ctx, d, pp)
    @test fc isa CC.FullComment
    if fc.ptr != C_NULL
        @test CC.getCommentKindName(fc) == "FullComment"
        @test CC.getSourceRange(fc) isa CC.SourceRange
        n = CC.child_count(fc)
        @test n isa Integer
        @test n >= 0
        names = String[]
        params = String[]
        for i in 0:(n - 1)
            c = CC.getChild(fc, i)
            @test c isa CC.Comment
            @test CC.getCommentKindName(c) isa String
            for j in 0:(CC.child_count(c) - 1)
                gc = CC.getChild(c, j)
                tc = CC.TextComment(gc)
                tc.ptr != C_NULL && @test CC.getText(tc) isa String
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
        @test all(x -> x isa String, names)
        @test all(x -> x isa String, params)
        @test issubset(params, ["a", "b"])
    end

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
    @test fc isa CC.FullComment
    if fc.ptr != C_NULL
        @test CC.getBeginLoc(fc) isa CC.SourceLocation
        @test CC.getEndLoc(fc) isa CC.SourceLocation
        @test CC.getLocation(fc) isa CC.SourceLocation

        for i in 0:(CC.child_count(fc) - 1)
            c = CC.getChild(fc, i)
            @test CC.getBeginLoc(c) isa CC.SourceLocation

            for j in 0:(CC.child_count(c) - 1)
                gc = CC.getChild(c, j)
                tc = CC.TextComment(gc)
                if tc.ptr != C_NULL
                    @test CC.getText(tc) isa String
                    @test CC.isWhitespace(tc) isa Bool
                    @test CC.hasTrailingNewline(tc) isa Bool
                end
            end

            bcc = CC.BlockCommandComment(c)
            if bcc.ptr != C_NULL
                @test CC.getCommandID(bcc) isa Integer
                @test CC.getCommandNameBeginLoc(bcc) isa CC.SourceLocation
                @test CC.getCommandMarker(bcc) isa Enum
                @test CC.hasNonWhitespaceParagraph(bcc) isa Bool
                n = CC.getNumArgs(bcc)
                @test n isa Integer
                for k in 0:(n - 1)
                    @test CC.getArgText(bcc, k) isa String
                    @test CC.getArgRange(bcc, k) isa CC.SourceRange
                end
                para = CC.getParagraph(bcc)
                @test para isa CC.ParagraphComment
                para.ptr != C_NULL && @test CC.isWhitespace(para) isa Bool
            end

            pcc = CC.ParamCommandComment(c)
            if pcc.ptr != C_NULL
                @test CC.getDirection(pcc) isa Enum
                @test CC.isDirectionExplicit(pcc) isa Bool
                @test CC.isParamIndexValid(pcc) isa Bool
                @test CC.isVarArgParam(pcc) isa Bool
                CC.hasParamName(pcc) && @test CC.getParamNameRange(pcc) isa CC.SourceRange
                if CC.isParamIndexValid(pcc) && !CC.isVarArgParam(pcc)
                    @test CC.getParamIndex(pcc) isa Integer
                end
            end
        end
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Comment inline content, HTML tags and tparam" begin
    I = create_interpreter()
    CC.parse(I, """
             /// \\brief Adds <b class="lead">two</b> \\c int values.
             /// \\tparam T the element type
             /// \\param a the first addend
             int cc_doc_rich(int a) { return a; }
             """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)

    f = DeclFinder(I)
    @test f(I, "cc_doc_rich")
    d = get_decl(f)

    fc = CC.getCommentForDecl(ctx, d, pp)
    @test fc isa CC.FullComment
    if fc.ptr != C_NULL
        owner = CC.getDecl(fc)
        @test owner isa CC.Decl
        @test owner.ptr != C_NULL

        nodes = CC.Comment[]
        queue = CC.Comment[CC.getChild(fc, i) for i in 0:(CC.child_count(fc) - 1)]
        while !isempty(queue)
            c = popfirst!(queue)
            push!(nodes, c)
            for i in 0:(CC.child_count(c) - 1)
                push!(queue, CC.getChild(c, i))
            end
        end
        @test !isempty(nodes)

        inline_names = String[]
        tag_names = String[]
        attr_names = String[]
        tparam_names = String[]
        n_end_tags = 0
        for c in nodes
            icc = CC.InlineCommandComment(c)
            if icc.ptr != C_NULL
                @test CC.getCommandID(icc) isa Integer
                @test CC.getCommandNameRange(icc) isa CC.SourceRange
                @test CC.getRenderKind(icc) isa Enum
                push!(inline_names, CC.getCommandName(icc, ctx))
                na = CC.getNumArgs(icc)
                @test na isa Integer
                for k in 0:(na - 1)
                    @test CC.getArgText(icc, k) isa String
                    @test CC.getArgRange(icc, k) isa CC.SourceRange
                end
            end

            hst = CC.HTMLStartTagComment(c)
            if hst.ptr != C_NULL
                @test CC.getTagNameSourceRange(hst) isa CC.SourceRange
                @test CC.isMalformed(hst) isa Bool
                @test CC.isSelfClosing(hst) isa Bool
                push!(tag_names, CC.getTagName(hst))
                nattr = CC.getNumAttrs(hst)
                @test nattr isa Integer
                for k in 0:(nattr - 1)
                    push!(attr_names, CC.getAttrName(hst, k))
                    @test CC.getAttrValue(hst, k) isa String
                end
            end

            het = CC.HTMLEndTagComment(c)
            if het.ptr != C_NULL
                n_end_tags += 1
                @test CC.isMalformed(het) isa Bool
                push!(tag_names, CC.getTagName(het))
            end

            tpc = CC.TParamCommandComment(c)
            if tpc.ptr != C_NULL
                @test CC.isPositionValid(tpc) isa Bool
                if CC.hasParamName(tpc)
                    push!(tparam_names, CC.getParamNameAsWritten(tpc))
                    @test CC.getParamNameRange(tpc) isa CC.SourceRange
                end
                if CC.isPositionValid(tpc)
                    dep = CC.getDepth(tpc)
                    @test dep isa Integer
                    @test dep > 0
                    for k in 0:(dep - 1)
                        @test CC.getIndex(tpc, k) isa Integer
                    end
                end
            end
        end

        @test "c" in inline_names
        @test "b" in tag_names
        @test n_end_tags == 1
        @test attr_names == ["class"]
        @test tparam_names == ["T"]
    end

    dispose(f)
    dispose(I)
end
