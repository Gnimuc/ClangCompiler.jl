using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "html | EscapeText over a string" begin
    # the three characters that would otherwise be read as markup
    @test CC.EscapeText("a<b&c>d") == "a&lt;b&amp;c&gt;d"
    # text with nothing to escape is handed straight back
    @test CC.EscapeText("plain") == "plain"
    # spaces are only escaped when asked for
    @test CC.EscapeText("a b") == "a b"
    @test CC.EscapeText("a b", true) == "a&nbsp;b"
end

@testset "html | document, escaping, line numbers and highlighting" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCHtmlTag { int a; };")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    pp = CC.getPreprocessor(ci)

    f = DeclFinder(I)
    @test f(I, "CCHtmlTag")
    r = CC.getSourceRange(get_decl(f))
    loc = CC.getBeginLoc(r)
    @test CC.isValid(loc)
    fid = CC.getFileID(sm, loc)
    @test CC.isValid(fid)

    # a wrapper document, with the title clang was given
    doc = CC.Rewriter(sm, lo)
    CC.AddHeaderFooterInternalBuiltinCSS(doc, fid, "CCHtmlTitle")
    @test CC.hasChangesForFileID(doc, fid)
    html = CC.getRewriteBufferText(doc, fid)
    @test occursin("<title>CCHtmlTitle</title>", html)
    @test occursin("</html>", html)
    # the source it wraps is still in there
    @test occursin("struct CCHtmlTag", html)
    dispose(doc)

    # line numbering inserts markup without losing the source
    numbered = CC.Rewriter(sm, lo)
    CC.AddLineNumbers(numbered, fid)
    @test CC.hasChangesForFileID(numbered, fid)
    @test occursin("CCHtmlTag", CC.getRewriteBufferText(numbered, fid))
    dispose(numbered)

    # arbitrary tags around a range clang chose
    tagged = CC.Rewriter(sm, lo)
    CC.HighlightRange(tagged, CC.getTokenRange(r), "<b>", "</b>")
    @test CC.hasChangesForFileID(tagged, fid)
    marked = CC.getRewriteBufferText(tagged, fid)
    @test occursin("<b>", marked)
    @test occursin("</b>", marked)
    dispose(tagged)

    # clang's own lexer decides what a keyword is
    highlighted = CC.Rewriter(sm, lo)
    CC.SyntaxHighlight(highlighted, fid, pp)
    @test CC.hasChangesForFileID(highlighted, fid)
    @test occursin("<span class='keyword'>", CC.getRewriteBufferText(highlighted, fid))
    dispose(highlighted)

    dispose(fid)
    dispose(f)
    dispose(I)
end

# HighlightMacros re-enters a token stream into the preprocessor it is handed, so it runs
# against an interpreter of its own that is thrown away straight afterwards.
@testset "html | HighlightMacros" begin
    I = create_interpreter(String[])
    CC.parse(I, "#define CCHTML_ONE 1\nstruct CCHtmlMacroTag { int a = CCHTML_ONE; };")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    pp = CC.getPreprocessor(ci)

    f = DeclFinder(I)
    @test f(I, "CCHtmlMacroTag")
    loc = CC.getBeginLoc(CC.getSourceRange(get_decl(f)))
    fid = CC.getFileID(sm, loc)
    @test CC.isValid(fid)

    rw = CC.Rewriter(sm, lo)
    CC.HighlightMacros(rw, fid, pp)
    # whatever markup clang chose, the source it annotated is still readable
    text = CC.getRewriteBufferText(rw, fid)
    @test CC.hasChangesForFileID(rw, fid)
    @test occursin("CCHtmlMacroTag", text)

    dispose(rw)
    dispose(fid)
    dispose(f)
    dispose(I)
end
