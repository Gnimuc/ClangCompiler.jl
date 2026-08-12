using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "raw lexer lifecycle" begin
    ci = CC.CompilerInstance()  # only used as the provider of default language options
    lang_opts = CC.getLangOpts(ci)
    fm = CC.FileManager()
    diag = CC.DiagnosticsEngine()
    sm = CC.SourceManager(fm, diag)
    code = "int lexer_probe = 1;"
    fid_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbuf", true)
    fid = CC.FileID(sm, fid_buf)  # the source manager takes ownership of this buffer
    lex_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbuf", true)
    lex = CC.Lexer(fid, lex_buf, sm, lang_opts)
    @test lex isa CC.Lexer
    @test lex.ptr != C_NULL

    # the buffer comes back byte for byte, and its length is the bound `seek` is checked against
    @test CC.getBufferLength(lex) == ncodeunits(code)
    @test CC.getBuffer(lex) == code

    # the lexer's location tracks its buffer offset, before and after a seek
    @test CC.getCurrentBufferOffset(lex) == 0
    @test CC.getFileOffset(sm, CC.getSourceLocation(lex)) == 0
    CC.seek(lex, 4, false)
    @test CC.getCurrentBufferOffset(lex) == 4
    @test CC.getFileOffset(sm, CC.getSourceLocation(lex)) == 4
    # offset 4 is the start of the identifier, so that is what lexes next
    tok = CC.Token()
    CC.LexFromRawLexer(lex, tok)
    @test CC.getSpelling(tok, sm, lang_opts) == "lexer_probe"
    CC.dispose(tok)

    # seeking to exactly the end is legal (the buffer is NUL-terminated); past it is not
    CC.seek(lex, ncodeunits(code), false)
    @test CC.getCurrentBufferOffset(lex) == ncodeunits(code)
    @test_throws AssertionError CC.seek(lex, ncodeunits(code) + 1, false)

    dispose(lex)
    CC.LLVM.dispose(lex_buf)  # the lexer only borrowed it
    dispose(fid)
    dispose(sm)
    dispose(fm)
    dispose(diag)
    dispose(ci)
end

@testset "Lexer | static utilities needing no interpreter" begin
    ci = CC.CompilerInstance()  # only used as the provider of default language options
    opts = CC.getLangOpts(ci)

    # Stringify escapes the way the `#` operator does
    @test CC.Stringify("plain") == "plain"
    @test CC.Stringify("a\"b") == "a\\\"b"
    @test CC.Stringify("a\\b") == "a\\\\b"
    @test CC.Stringify("a\nb") == "a\\nb"
    # charify escapes the single quote instead of the double quote
    @test CC.Stringify("it's", true) == "it\\'s"
    @test CC.Stringify("it's", false) == "it's"

    # identifier-continuation classification ('$' is DollarIdents-dependent, so not asserted)
    @test CC.isAsciiIdentifierContinueChar('a', opts)
    @test CC.isAsciiIdentifierContinueChar('Z', opts)
    @test CC.isAsciiIdentifierContinueChar('7', opts)
    @test CC.isAsciiIdentifierContinueChar('_', opts)
    @test !CC.isAsciiIdentifierContinueChar('-', opts)
    @test_throws AssertionError CC.isAsciiIdentifierContinueChar('é', opts)

    # the preamble is the leading comments and directives, and stops before the first decl
    src = "// leading comment\n#include <cstddef>\nint after_preamble = 1;\n"
    size, at_sol = CC.ComputePreamble(src, opts)
    @test at_sol
    @test src[1:size] == "// leading comment\n#include <cstddef>\n"
    @test !occursin("after_preamble", src[1:size])
    # capping the line count shortens it
    @test first(CC.ComputePreamble(src, opts, 1)) < size

    dispose(ci)
end

@testset "Lexer | statics over a parsed translation unit" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             #define MACINNER(x) x
             #define MACOUTER(x) x
             int MACOUTER(MACINNER(mac_probe)) = 1;
             struct IndentProbe {
                 int field;
             };
             int mfcr_probe = 1;
             """)
    sm = CC.getSourceManager(CC.get_instance(I))
    opts = CC.getLangOpts(CC.get_instance(I))

    f = DeclFinder(I)

    # getImmediateMacroNameForDiagnostics names the OUTERMOST macro, getImmediateMacroName
    # the innermost -- the whole reason both exist
    @test f(I, "mac_probe")
    mloc = CC.getLocation(get_decl(f))
    @test CC.isMacroID(mloc)
    outer = CC.getImmediateMacroNameForDiagnostics(mloc, sm, opts)
    inner = CC.getImmediateMacroName(mloc, sm, opts)
    @test outer == "MACOUTER"
    @test inner == "MACINNER"
    @test outer != inner
    @test_throws AssertionError CC.getImmediateMacroNameForDiagnostics(CC.SourceLocation(), sm, opts)

    # indentation is the leading whitespace of the line: the record sits in column 0, its
    # field is indented four spaces. The field is reached through the record rather than by
    # name, since a member is not a top-level lookup result.
    @test f(I, "IndentProbe")
    rd = CC.CXXRecordDecl(get_decl(f))
    rloc = CC.getLocation(CC.NamedDecl(rd))
    @test CC.getIndentationForLine(CC.getFileLoc(sm, rloc), sm) == ""
    members = collect(CC.decls_in(CC.castToDeclContext(rd)))
    fld = only(filter(d -> d isa CC.FieldDecl, members))
    floc = CC.getLocation(CC.NamedDecl(fld))
    @test CC.getIndentationForLine(CC.getFileLoc(sm, floc), sm) == "    "
    @test_throws AssertionError CC.getIndentationForLine(CC.SourceLocation(), sm)

    # a plain file range maps to itself, and the mapped text is the declaration
    @test f(I, "mfcr_probe")
    d = get_decl(f)
    csr = CC.makeFileCharRange(CC.getTokenRange(CC.getSourceRange(d)), sm, opts)
    @test CC.isValid(csr)
    @test CC.getFileOffset(sm, CC.getBegin(csr)) == CC.getFileOffset(sm, CC.getBeginLoc(CC.getSourceRange(d)))
    @test CC.getSourceText(CC.getAsRange(csr), false, sm, opts) == "int mfcr_probe = 1"

    # findLocationAfterToken: the token after the type is the identifier, and asking for a
    # kind that is not there answers with an invalid location
    dloc = CC.getBeginLoc(CC.getSourceRange(d))
    nxt = CC.Token()
    @test CC.findNextToken(dloc, sm, opts, nxt)
    after = CC.findLocationAfterToken(dloc, CC.getKind(nxt), sm, opts)
    @test CC.isValid(after)
    @test CC.getFileOffset(sm, after) ==
          CC.getFileOffset(sm, CC.getLocation(nxt)) + CC.MeasureTokenLength(CC.getLocation(nxt), sm, opts)
    # the identifier is not an `=`, so no location comes back for that kind
    eq = CC.Token()
    @test CC.findNextToken(CC.getLocation(nxt), sm, opts, eq)
    @test CC.getKind(eq) != CC.getKind(nxt)
    @test CC.isInvalid(CC.findLocationAfterToken(dloc, CC.getKind(eq), sm, opts))
    CC.dispose(nxt)
    CC.dispose(eq)

    dispose(f)
    dispose(I)
end

@testset "Lexer | token prefix length over a spliced token" begin
    I = create_interpreter(String[])
    # the identifier is spelled across an escaped newline, so its physical extent (11) and
    # its cleaned spelling (9, "splicetok") differ
    CC.parse(I, "int splice\\\ntok = 1;")
    sm = CC.getSourceManager(CC.get_instance(I))
    opts = CC.getLangOpts(CC.get_instance(I))

    f = DeclFinder(I)
    @test f(I, "splicetok")
    loc = CC.getLocation(get_decl(f))

    @test CC.cleaned_token_length(loc, sm, opts) == 9
    @test CC.MeasureTokenLength(loc, sm, opts) == 11
    # a prefix inside the first line measures as itself; one past the splice picks up the
    # two physical characters the escaped newline occupies
    @test CC.getTokenPrefixLength(loc, 2, sm, opts) == 2
    @test CC.getTokenPrefixLength(loc, 9, sm, opts) == 11
    # the bound is the cleaned length, so 10 is rejected even though 10 <= MeasureTokenLength
    @test_throws AssertionError CC.getTokenPrefixLength(loc, 10, sm, opts)

    # AdvanceToTokenCharacter counts in the SPELLING too, so it must land exactly where
    # getTokenPrefixLength says: the n-th spelling character sits that many physical bytes in.
    # A shim that ignored `characters`, or counted raw bytes, breaks this for n = 9 — the one
    # that crosses the splice.
    base = CC.getFileOffset(sm, loc)
    for n in (0, 2, 9)
        adv = CC.AdvanceToTokenCharacter(loc, n, sm, opts)
        @test CC.getFileOffset(sm, adv) - base == CC.getTokenPrefixLength(loc, n, sm, opts)
    end

    # getAsCharRange widens a token range: the end moves from the START of the last token to
    # just past it, which is MeasureTokenLength — 11 here, the physical extent including the
    # splice, not the 9 characters it spells.
    cr = CC.getAsCharRange(CC.SourceRange(loc, loc), sm, opts)
    @test cr.is_token_range == false
    @test CC.getFileOffset(sm, cr.range.begin_loc) == base
    @test CC.getFileOffset(sm, cr.range.end_loc) - base == CC.MeasureTokenLength(loc, sm, opts)

    dispose(f)
    dispose(I)
end
