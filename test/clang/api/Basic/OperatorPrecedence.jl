using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# getBinOpPrecedence takes a raw clang::tok::TokenKind, so the kinds are obtained the way
# any caller would obtain them: by lexing the operators and reading the tokens' kinds.
# Nothing here needs an interpreter.

@testset "getBinOpPrecedence | the C99 precedence ladder" begin
    ci = CC.CompilerInstance()  # only used as the provider of default language options
    lang_opts = CC.getLangOpts(ci)
    fm = CC.FileManager()
    diag = CC.DiagnosticsEngine()
    sm = CC.SourceManager(fm, diag)

    code = "a , b = c ? d || e && f | g ^ h & i == j < k << l + m * n > o >> p"
    fid_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "precbuf", true)
    fid = CC.FileID(sm, fid_buf)  # the source manager takes ownership of this buffer
    lex_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "precbuf", true)
    lex = CC.Lexer(fid, lex_buf, sm, lang_opts)

    # Bounded rather than "until eof": a lexer that stopped producing tokens would otherwise
    # spin here instead of failing the count below.
    kinds = Dict{String,UInt32}()
    for _ = 1:(2 * ncodeunits(code))
        tok = CC.Token()
        CC.LexFromRawLexer(lex, tok)
        spelling = CC.getSpelling(tok, sm, lang_opts)
        kind = CC.getKind(tok)
        CC.dispose(tok)
        isempty(spelling) && break
        kinds[spelling] = kind
    end
    # the loop below proves nothing if the lexer produced nothing
    @test length(kinds) >= 16

    expected = ["," => CC.CXPrecLevel_Comma,
                "=" => CC.CXPrecLevel_Assignment,
                "?" => CC.CXPrecLevel_Conditional,
                "||" => CC.CXPrecLevel_LogicalOr,
                "&&" => CC.CXPrecLevel_LogicalAnd,
                "|" => CC.CXPrecLevel_InclusiveOr,
                "^" => CC.CXPrecLevel_ExclusiveOr,
                "&" => CC.CXPrecLevel_And,
                "==" => CC.CXPrecLevel_Equality,
                "<" => CC.CXPrecLevel_Relational,
                "<<" => CC.CXPrecLevel_Shift,
                "+" => CC.CXPrecLevel_Additive,
                "*" => CC.CXPrecLevel_Multiplicative]
    for (spelling, level) in expected
        @test CC.getBinOpPrecedence(kinds[spelling], true, true) == level
    end

    # An identifier is not a binary operator, which is the answer that keeps the mapping from
    # being "some level for everything".
    @test CC.getBinOpPrecedence(kinds["a"], true, true) == CC.CXPrecLevel_Unknown

    # The two switches exist for exactly two tokens, and they do not work the same way.
    #
    # `>` reads off GreaterThanIsOperator alone: an operator where one is allowed, and
    # otherwise the token that closes a template argument list. CPlusPlus11 does not enter
    # into it.
    @test CC.getBinOpPrecedence(kinds[">"], true, true) == CC.CXPrecLevel_Relational
    @test CC.getBinOpPrecedence(kinds[">"], true, false) == CC.CXPrecLevel_Relational
    @test CC.getBinOpPrecedence(kinds[">"], false, true) == CC.CXPrecLevel_Unknown
    @test CC.getBinOpPrecedence(kinds[">"], false, false) == CC.CXPrecLevel_Unknown

    # `>>` is a shift in three of the four combinations, and the one exception is the
    # C++11 rule itself: only when `>` is NOT an operator (so we are inside a template
    # argument list) AND C++11 applies does `>>` stop being a shift and become two closing
    # angle brackets. Before C++11 it stayed a shift there, which is why C++03 made you
    # write `vector<vector<int> >` with the space.
    @test CC.getBinOpPrecedence(kinds[">>"], true, true) == CC.CXPrecLevel_Shift
    @test CC.getBinOpPrecedence(kinds[">>"], true, false) == CC.CXPrecLevel_Shift
    @test CC.getBinOpPrecedence(kinds[">>"], false, false) == CC.CXPrecLevel_Shift
    @test CC.getBinOpPrecedence(kinds[">>"], false, true) == CC.CXPrecLevel_Unknown
    # neither switch touches any other operator
    @test CC.getBinOpPrecedence(kinds["<"], false, false) == CC.CXPrecLevel_Relational
    @test CC.getBinOpPrecedence(kinds["<<"], false, false) == CC.CXPrecLevel_Shift

    # Low numbers bind more weakly, which is the ordering the whole ladder is for.
    @test Int(CC.getBinOpPrecedence(kinds["+"], true, true)) <
          Int(CC.getBinOpPrecedence(kinds["*"], true, true))
    @test Int(CC.getBinOpPrecedence(kinds[","], true, true)) <
          Int(CC.getBinOpPrecedence(kinds["="], true, true))

    dispose(lex)
    CC.LLVM.dispose(lex_buf)  # the lexer only borrowed it
    dispose(fid)
    dispose(sm)
    dispose(fm)
    dispose(diag)
    dispose(ci)
end
