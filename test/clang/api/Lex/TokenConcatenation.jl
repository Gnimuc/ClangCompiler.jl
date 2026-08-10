using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

"Raw-lex `code` in `ci`'s source manager and return every token before eof."
function tc_raw_tokens(ci, code, name)
    sm = CC.getSourceManager(ci)
    opts = CC.getLangOpts(ci)
    # Lex from the very buffer the source manager owns, not a private copy.
    #
    # A raw-lexed token's getLiteralData() points INTO the buffer the lexer read, and these
    # tokens outlive this call. AvoidConcat reads their text -- its rule for an identifier
    # followed by a numeric constant is `GetFirstChar(Tok) != '.'` -- so lexing from a second
    # copy and freeing it here made that read land on freed memory, and `.5` stopped looking
    # like it starts with a dot. The token metadata all stayed intact, so nothing looked wrong.
    #
    # `FileID(sm, owned)` donates the buffer to the source manager, which keeps it alive for
    # the interpreter's life -- the same lifetime clang relies on, since it lexes out of
    # `SM.getBufferOrFake(FID)`.
    owned = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), name, true)
    fid = CC.FileID(sm, owned)              # the source manager takes ownership of `owned`
    lex = CC.Lexer(fid, owned, sm, opts)
    toks = CC.Token[]
    while true
        t = CC.Token()
        CC.LexFromRawLexer(lex, t)
        if CC.is_eof(t)
            CC.dispose(t)
            break
        end
        push!(toks, t)
    end
    dispose(lex)
    dispose(fid)                            # frees the boxed FileID, not the donated buffer
    return toks
end

@testset "TokenConcatenation | when a printed token stream needs a space" begin
    I = create_interpreter(["-std=c++17"])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)
    tc = CC.TokenConcatenation(pp)

    toks = tc_raw_tokens(ci, "tcfoo tcbar 5 .5", "tokconcat-probe")
    @test length(toks) == 4
    foo, bar, five, dotfive = toks

    # raw lexing does not look identifiers up, so the two identifier tokens are given the
    # identifier kind and their IdentifierInfo here -- that is the state a token stream
    # coming out of the preprocessor is in, and what AvoidConcat reads
    ii_foo = CC.getIdentifierInfo(pp, "tcfoo")
    ii_bar = CC.getIdentifierInfo(pp, "tcbar")
    ident_kind = CC.getTokenID(ii_foo)
    CC.setKind(foo, ident_kind)
    CC.setIdentifierInfo(foo, ii_foo)
    CC.setKind(bar, ident_kind)
    CC.setIdentifierInfo(bar, ii_bar)

    none = CC.Token()   # "no token before the previous one"

    # `tcfoo` then `tcbar` would lex back as the single identifier `tcfootcbar`
    @test CC.AvoidConcat(tc, none, foo, bar) == true
    # `tcfoo` then `5` would lex back as `tcfoo5`
    @test CC.AvoidConcat(tc, none, foo, five) == true
    # but `tcfoo` then `.5` is already two tokens when printed adjacent, so no space is
    # needed -- the case that makes this a real decision rather than "identifiers always"
    @test CC.AvoidConcat(tc, none, foo, dotfive) == false

    dispose(none)
    for t in toks
        dispose(t)
    end
    dispose(tc)
    dispose(I)
end
