using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Index | CommentToXMLConverter" begin
    # Same interpreter construction as test/clang/api/AST/Comment.jl: doc comments have to
    # be attached for getCommentForDecl to hand back anything.
    I = CC.create_interpreter()
    CC.parse(I, """
             /// \\brief Adds two numbers, one of which is <b>bold</b>.
             /// \\param a the first addend
             /// \\param b the second addend
             int cxml_add(int a, int b) { return a + b; }
             """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)

    f = DeclFinder(I)
    @test f(I, "cxml_add")
    d = get_decl(f)
    fc = CC.getCommentForDecl(ctx, d, pp)
    @test fc.ptr != C_NULL

    conv = CC.CommentToXMLConverter()

    xml = CC.convertCommentToXML(conv, fc, ctx)
    @test !isempty(xml)
    # The XML form is the structured one: it names the declaration it documents, and it
    # carries the parameter names the doc comment declared.
    @test occursin("cxml_add", xml)
    @test occursin("<Name>", xml)
    @test occursin("a", xml)
    @test occursin("b", xml)

    html = CC.convertCommentToHTML(conv, fc, ctx)
    @test !isempty(html)
    # Two different renderings of one comment: the HTML form is not the XML form, but both
    # carry the prose.
    @test html != xml
    @test occursin("addend", html)
    @test occursin("addend", xml)

    # The converter caches formatting state; a second conversion of the same comment must
    # still produce the same text.
    @test CC.convertCommentToXML(conv, fc, ctx) == xml

    # convertHTMLTagNodeToText needs an HTML tag node, which is what the `<b>` above puts
    # into the comment's paragraph. Asserted found rather than skipped: a walk that finds
    # nothing would leave the conversion untested.
    # The search is over the WHOLE subtree, not the first two levels: `\brief` wraps its
    # prose in a BlockCommandComment, so the `<b>` sits at FullComment > BlockCommandComment
    # > ParagraphComment > HTMLStartTagComment -- one deeper than a bare paragraph would put
    # it, and a two-level walk finds nothing.
    function find_html_start(c)
        for i = 0:(CC.child_count(c) - 1)
            ch = CC.getChild(c, i)
            CC.is_null_handle(ch) && continue
            h = CC.HTMLStartTagComment(ch)
            h.ptr == C_NULL || return h
            found = find_html_start(ch)
            found === nothing || return found
        end
        return nothing
    end
    htc = find_html_start(fc)
    @test htc !== nothing
    tag_text = CC.convertHTMLTagNodeToText(conv, htc, ctx)
    @test occursin("b", tag_text)

    CC.dispose(conv)
    dispose(f)
    dispose(I)
end
