using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

# The literal parsers turn a token's SPELLING into a value. Tokens are produced here by
# raw-lexing a buffer registered in the interpreter's own source manager, because the
# preprocessor has to be able to spell them back.

"Raw-lex `code` in `ci`'s source manager and return every token before eof."
function lit_raw_tokens(ci, code, name)
    sm = CC.getSourceManager(ci)
    opts = CC.getLangOpts(ci)
    # One buffer, and the lexer reads the very buffer the source manager owns.
    #
    # A raw-lexed token's getLiteralData() points INTO the buffer the lexer read, and the
    # tokens outlive this call -- StringLiteralParser reads their spelling later, through
    # that pointer. Lexing from a second, private copy and freeing it here therefore handed
    # back tokens whose text was already freed: the parser then set hadError and produced
    # nothing, for every input, while the SourceLocations stayed perfectly valid so the
    # tokens still looked healthy. Reading the spelling appeared to work too, right up until
    # the freed page was reused.
    #
    # `FileID(sm, owned)` donates the buffer to the source manager, which keeps it alive for
    # the interpreter's life -- so this is both the safe lifetime and what a real caller
    # does, since clang lexes out of `SM.getBufferOrFake(FID)`.
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

@testset "NumericLiteralParser | classification, radix and value" begin
    I = create_interpreter(["-std=c++17"])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)
    opts = CC.getLangOpts(ci)

    toks = lit_raw_tokens(ci, "0x10ull 1.5f 42 0755 0b1011 2.0", "numlit-probe")
    @test all(CC.is_numeric_constant, toks)
    @test length(toks) == 6
    parsers = [CC.NumericLiteralParser(pp, t) for t in toks]
    @test all(p -> p !== nothing, parsers)
    hexull, onefive, fortytwo, octal, binary, twopointoh = parsers

    for p in parsers
        @test CC.hadError(p) == false
    end

    # 0x10ull: hexadecimal, unsigned, long long -- and *not* long, which is the one
    # distinction the suffix flags are easy to get wrong
    @test CC.isIntegerLiteral(hexull)
    @test CC.isFloatingLiteral(hexull) == false
    @test CC.isFixedPointLiteral(hexull) == false
    @test CC.getRadix(hexull) == 16
    @test CC.isUnsigned(hexull)
    @test CC.isLongLong(hexull)
    @test CC.isLong(hexull) == false
    @test CC.GetIntegerValue(hexull) == (UInt64(16), false)
    # the digits exclude both the 0x prefix and the ull suffix
    @test CC.getLiteralDigits(hexull) == "10"

    # the three other radices clang recognizes
    @test CC.getRadix(fortytwo) == 10
    @test CC.GetIntegerValue(fortytwo) == (UInt64(42), false)
    @test CC.isUnsigned(fortytwo) == false
    @test CC.getRadix(octal) == 8
    @test CC.GetIntegerValue(octal) == (UInt64(0o755), false)
    @test CC.getRadix(binary) == 2
    @test CC.GetIntegerValue(binary) == (UInt64(0b1011), false)

    # 1.5f is floating and carries the float suffix; 2.0 is floating with none
    @test CC.isFloatingLiteral(onefive)
    @test CC.isIntegerLiteral(onefive) == false
    @test CC.isFloat(onefive)
    @test CC.isFloat(twopointoh) == false
    v, status = CC.GetFloatValue(onefive)
    @test v == 1.5
    @test status == 0                       # 1.5 is exactly representable, so opOK
    @test CC.GetFloatValue(twopointoh)[1] == 2.0

    # the two conversions are partial in opposite directions
    @test_throws AssertionError CC.GetFloatValue(fortytwo)
    @test_throws AssertionError CC.GetIntegerValue(onefive)

    # no user-defined suffix anywhere above, and asking for one is refused rather than
    # tripping clang's assert
    @test all(p -> CC.hasUDSuffix(p) == false, parsers)
    @test_throws AssertionError CC.getUDSuffix(fortytwo)
    @test_throws AssertionError CC.getUDSuffixOffset(fortytwo)

    for p in parsers
        dispose(p)
    end
    for t in toks
        dispose(t)
    end

    # a user-defined suffix, which is what hasUDSuffix is for
    ud = lit_raw_tokens(ci, "42_km", "numlit-ud")
    udp = CC.NumericLiteralParser(pp, only(ud))
    @test udp !== nothing
    @test CC.hadError(udp) == false
    @test CC.hasUDSuffix(udp)
    @test CC.getUDSuffix(udp) == "_km"
    @test CC.getUDSuffixOffset(udp) == 2     # "42" then the suffix
    @test CC.GetIntegerValue(udp) == (UInt64(42), false)
    dispose(udp)
    dispose(only(ud))

    # the static validity check: an underscore-led suffix is always a ud-suffix in C++11
    # and later, an arbitrary letter run is not
    @test CC.isValidNumericUDSuffix(opts, "_km")
    @test CC.isValidNumericUDSuffix(opts, "zz") == false

    # the kind gate: a string literal is not a ppnumber
    other = lit_raw_tokens(ci, "\"not a number\"", "numlit-gate")
    @test CC.NumericLiteralParser(pp, only(other)) === nothing
    dispose(only(other))

    dispose(I)
end

@testset "CharLiteralParser | value and encoding" begin
    I = create_interpreter(["-std=c++17"])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)

    toks = lit_raw_tokens(ci, "'A' '\\n' 'ab' L'A' u8'A'", "charlit-probe")
    @test length(toks) == 5
    plain, escaped, multi, wide, utf8 = toks

    pa = CC.CharLiteralParser(pp, plain)
    @test pa !== nothing
    @test CC.hadError(pa) == false
    @test CC.isOrdinary(pa)
    @test CC.isWide(pa) == false
    @test CC.isMultiChar(pa) == false
    @test CC.getValue(pa) == UInt64('A')
    @test CC.getUDSuffix(pa) == ""
    @test_throws AssertionError CC.getUDSuffixOffset(pa)

    # the escape is decoded, which the spelling alone never is
    pe = CC.CharLiteralParser(pp, escaped)
    @test pe !== nothing
    @test CC.getValue(pe) == UInt64('\n')
    @test CC.getValue(pe) != UInt64('\\')

    pm = CC.CharLiteralParser(pp, multi)
    @test pm !== nothing
    @test CC.isMultiChar(pm)
    @test CC.isOrdinary(pm)

    pw = CC.CharLiteralParser(pp, wide)
    @test pw !== nothing
    @test CC.isWide(pw)
    @test CC.isOrdinary(pw) == false
    @test CC.getValue(pw) == UInt64('A')

    pu = CC.CharLiteralParser(pp, utf8)
    @test pu !== nothing
    @test CC.isUTF8(pu)
    @test CC.isOrdinary(pu) == false
    @test CC.isWide(pu) == false
    @test CC.getValue(pu) == UInt64('A')

    for p in (pa, pe, pm, pw, pu)
        dispose(p)
    end
    for t in toks
        dispose(t)
    end

    # the kind gates, on both entry points
    num = lit_raw_tokens(ci, "42", "charlit-gate")
    @test CC.CharLiteralParser(pp, only(num)) === nothing
    @test CC.CharLiteralParser(pp, "42", CC.getLocation(only(num)), CC.getKind(only(num))) === nothing
    dispose(only(num))

    dispose(I)
end

@testset "StringLiteralParser | phase-6 concatenation and escape decoding" begin
    I = create_interpreter(["-std=c++17"])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)
    sm = CC.getSourceManager(ci)
    opts = CC.getLangOpts(ci)
    target = CC.getTarget(ci)

    toks = lit_raw_tokens(ci, "\"a\\n\" \"b\"", "strlit-probe")
    @test length(toks) == 2

    sp = CC.StringLiteralParser(toks, pp)
    @test sp !== nothing
    @test CC.hadError(sp) == false
    # translation phase 6: the two adjacent literals become one string, and \n is one byte
    @test CC.GetString(sp) == UInt8['a', '\n', 'b']
    @test CC.GetStringLength(sp) == 3
    @test CC.GetNumStringChars(sp) == 3
    @test CC.isOrdinary(sp)
    @test CC.isWide(sp) == false
    @test CC.isPascal(sp) == false
    @test CC.isUnevaluated(sp) == false
    @test CC.getUDSuffix(sp) == ""
    @test_throws AssertionError CC.getUDSuffixToken(sp)
    @test_throws AssertionError CC.getUDSuffixOffset(sp)

    # byte 0 of the first token sits just past its opening quote; byte 1 is where the
    # two-character escape starts
    @test CC.getOffsetOfStringByte(sp, toks[1], 0) == 1
    @test CC.getOffsetOfStringByte(sp, toks[1], 1) == 2
    @test_throws AssertionError CC.getOffsetOfStringByte(sp, toks[1], CC.getLength(toks[1]))

    # the preprocessor-free constructor must decode identically -- it is the same parser
    # with the diagnostics turned off
    sp2 = CC.StringLiteralParser(toks, sm, opts, target)
    @test sp2 !== nothing
    @test CC.GetString(sp2) == CC.GetString(sp)
    dispose(sp2)

    # unevaluated mode is a different answer from the same tokens
    spu = CC.StringLiteralParser(toks, pp, CC.LibClangEx.CXStringLiteralEvalMethod_Unevaluated)
    @test spu !== nothing
    @test CC.isUnevaluated(spu)
    dispose(spu)

    dispose(sp)
    for t in toks
        dispose(t)
    end

    # an embedded NUL is a byte of the result, not a terminator: this is why the decoded
    # string crosses as bytes rather than as a C string
    nul = lit_raw_tokens(ci, "\"\\0a\"", "strlit-nul")
    spn = CC.StringLiteralParser(nul, pp)
    @test spn !== nothing
    @test CC.GetString(spn) == UInt8[0x00, 0x61]
    @test CC.GetStringLength(spn) == 2
    dispose(spn)
    dispose(only(nul))

    # a wide literal counts characters, not bytes
    wide = lit_raw_tokens(ci, "L\"ab\"", "strlit-wide")
    spw = CC.StringLiteralParser(wide, pp)
    @test spw !== nothing
    @test CC.isWide(spw)
    @test CC.isOrdinary(spw) == false
    @test CC.GetNumStringChars(spw) == 2
    @test CC.GetStringLength(spw) > CC.GetNumStringChars(spw)
    dispose(spw)
    dispose(only(wide))

    # the gates: no tokens at all, and a token that is not a string literal
    @test CC.StringLiteralParser(CC.Token[], pp) === nothing
    num = lit_raw_tokens(ci, "42", "strlit-gate")
    @test CC.StringLiteralParser(num, pp) === nothing
    dispose(only(num))

    # the static validity check, the string-literal counterpart of the numeric one
    @test CC.isValidStringUDSuffix(opts, "_tag")
    @test CC.isValidStringUDSuffix(opts, "zz") == false

    dispose(I)
end
