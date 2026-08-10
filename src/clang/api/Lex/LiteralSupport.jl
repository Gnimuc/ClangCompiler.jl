# NumericLiteralParser
"""
    NumericLiteralParser(spelling::AbstractString, loc::SourceLocation,
                         src_mgr::AbstractSourceManager, opts::AbstractLangOptions,
                         target::AbstractTargetInfo,
                         diag::AbstractDiagnosticsEngine) -> NumericLiteralParser
Parse `spelling` — the spelling of a `numeric_constant` token, prefix and suffix included —
as a ppnumber.

`loc` and `src_mgr` only place the diagnostics this reports on `diag`. The shim copies
`spelling`, so the caller's string does not have to outlive the parser.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function NumericLiteralParser(spelling::AbstractString, loc::SourceLocation,
                              src_mgr::AbstractSourceManager, opts::AbstractLangOptions,
                              target::AbstractTargetInfo,
                              diag::AbstractDiagnosticsEngine)
    @check_ptrs src_mgr opts target diag
    p = clang_NumericLiteralParser_create(spelling, ncodeunits(spelling), loc, src_mgr,
                                          opts, target, diag)
    @assert p != C_NULL "Failed to create NumericLiteralParser"
    return NumericLiteralParser(p)
end

"""
    NumericLiteralParser(pp::AbstractPreprocessor, tok::AbstractToken) -> Union{NumericLiteralParser,Nothing}
Parse `tok`'s spelling as a ppnumber, taking the source manager, language options, target
and diagnostics from `pp`.

Returns `nothing` when `tok` is not a `numeric_constant`, which is the token kind the
parser is defined on.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function NumericLiteralParser(pp::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs pp tok
    p = clang_NumericLiteralParser_createFromToken(pp, tok)
    return p == C_NULL ? nothing : NumericLiteralParser(p)
end

dispose(x::NumericLiteralParser) = clang_NumericLiteralParser_dispose(x)

"""
    hadError(x::AbstractNumericLiteralParser) -> Bool
Return whether the spelling was not a well-formed ppnumber. Every classification and value
below is meaningless when this is `true`.
"""
function hadError(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_hadError(x)
end

function isUnsigned(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isUnsigned(x)
end

"""
    isLong(x::AbstractNumericLiteralParser) -> Bool
Return whether the literal carries an `l` suffix. This is *not* set for `ll`; see
[`isLongLong`](@ref).
"""
function isLong(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isLong(x)
end

function isLongLong(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isLongLong(x)
end

function isSizeT(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isSizeT(x)
end

function isHalf(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isHalf(x)
end

function isFloat(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isFloat(x)
end

function isImaginary(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isImaginary(x)
end

function isFloat16(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isFloat16(x)
end

function isFloat128(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isFloat128(x)
end

function isFract(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isFract(x)
end

function isAccum(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isAccum(x)
end

function isBitInt(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isBitInt(x)
end

"""
    getMicrosoftInteger(x::AbstractNumericLiteralParser) -> UInt8
Return the width named by a Microsoft `i8`/`i16`/`i32`/`i64` suffix, or `0` when there is
none.
"""
function getMicrosoftInteger(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_getMicrosoftInteger(x)
end

function isFixedPointLiteral(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isFixedPointLiteral(x)
end

function isIntegerLiteral(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isIntegerLiteral(x)
end

function isFloatingLiteral(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_isFloatingLiteral(x)
end

function hasUDSuffix(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_hasUDSuffix(x)
end

"""
    getUDSuffix(x::AbstractNumericLiteralParser) -> String
Return the user-defined suffix. `hasUDSuffix(x)` must hold; Clang asserts it.
"""
function getUDSuffix(x::AbstractNumericLiteralParser)
    @check_ptrs x
    @assert hasUDSuffix(x) "the literal carries no user-defined suffix"
    return get_string(clang_NumericLiteralParser_getUDSuffix(x))
end

"""
    getUDSuffixOffset(x::AbstractNumericLiteralParser) -> Cuint
Return where the user-defined suffix starts in the spelling. `hasUDSuffix(x)` must hold;
Clang asserts it.
"""
function getUDSuffixOffset(x::AbstractNumericLiteralParser)
    @check_ptrs x
    @assert hasUDSuffix(x) "the literal carries no user-defined suffix"
    return clang_NumericLiteralParser_getUDSuffixOffset(x)
end

"""
    isValidNumericUDSuffix(opts::AbstractLangOptions, suffix::AbstractString) -> Bool
Return whether `suffix` is a suffix a numeric literal may carry: either one of the
language's own suffixes or a reserved user-defined one.
"""
function isValidNumericUDSuffix(opts::AbstractLangOptions, suffix::AbstractString)
    @check_ptrs opts
    return clang_NumericLiteralParser_isValidUDSuffix(opts, suffix)
end

"""
    getRadix(x::AbstractNumericLiteralParser) -> Cuint
Return the radix the literal was written in: 2, 8, 10 or 16.
"""
function getRadix(x::AbstractNumericLiteralParser)
    @check_ptrs x
    return clang_NumericLiteralParser_getRadix(x)
end

"""
    GetIntegerValue(x::AbstractNumericLiteralParser) -> Tuple{UInt64,Bool}
Return the literal's value truncated to 64 bits, and whether it overflowed those 64 bits.

`isIntegerLiteral(x)` must hold and `hadError(x)` must not: the digit markers the
conversion reads are only set up for a well-formed integer.
"""
function GetIntegerValue(x::AbstractNumericLiteralParser)
    @check_ptrs x
    @assert !hadError(x) "the literal did not parse"
    @assert isIntegerLiteral(x) "not an integer literal"
    value = Ref{UInt64}(0)
    overflow = clang_NumericLiteralParser_GetIntegerValue(x, value)
    return (value[], overflow)
end

"""
    GetFloatValue(x::AbstractNumericLiteralParser) -> Tuple{Float64,Cuint}
Return the literal converted to a `Float64`, and the raw `llvm::APFloat::opStatus` bitmask
the conversion reported — `0` is exact, `16` is the usual "inexact" answer for a decimal
that no binary float represents.

`isFloatingLiteral(x)` must hold and `hadError(x)` must not.
"""
function GetFloatValue(x::AbstractNumericLiteralParser)
    @check_ptrs x
    @assert !hadError(x) "the literal did not parse"
    @assert isFloatingLiteral(x) "not a floating literal"
    value = Ref{Cdouble}(0.0)
    status = clang_NumericLiteralParser_GetFloatValue(x, value)
    return (value[], status)
end

"""
    getLiteralDigits(x::AbstractNumericLiteralParser) -> String
Return the digits alone, without the radix prefix or the suffix. `hadError(x)` must not
hold; Clang asserts it.
"""
function getLiteralDigits(x::AbstractNumericLiteralParser)
    @check_ptrs x
    @assert !hadError(x) "the literal did not parse"
    return get_string(clang_NumericLiteralParser_getLiteralDigits(x))
end

# CharLiteralParser
"""
    CharLiteralParser(pp::AbstractPreprocessor, text::AbstractString, loc::SourceLocation,
                      kind::Integer) -> Union{CharLiteralParser,Nothing}
Evaluate `text` — the spelling of a character literal, prefix and quotes included — as the
character-constant kind `kind` (a raw `clang::tok::TokenKind` value).

Returns `nothing` unless `kind` is one of the five character-constant kinds and `text` is
long enough to hold its quotes.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CharLiteralParser(pp::AbstractPreprocessor, text::AbstractString,
                           loc::SourceLocation, kind::Integer)
    @check_ptrs pp
    p = clang_CharLiteralParser_create(pp, text, ncodeunits(text), loc, kind)
    return p == C_NULL ? nothing : CharLiteralParser(p)
end

"""
    CharLiteralParser(pp::AbstractPreprocessor, tok::AbstractToken) -> Union{CharLiteralParser,Nothing}
Evaluate `tok` as a character literal, taking its spelling, location and kind from the
token. Returns `nothing` when `tok` is not a character constant.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CharLiteralParser(pp::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs pp tok
    p = clang_CharLiteralParser_createFromToken(pp, tok)
    return p == C_NULL ? nothing : CharLiteralParser(p)
end

dispose(x::CharLiteralParser) = clang_CharLiteralParser_dispose(x)

function hadError(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_hadError(x)
end

function isOrdinary(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_isOrdinary(x)
end

function isWide(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_isWide(x)
end

function isUTF8(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_isUTF8(x)
end

function isUTF16(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_isUTF16(x)
end

function isUTF32(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_isUTF32(x)
end

"""
    isMultiChar(x::AbstractCharLiteralParser) -> Bool
Return whether the literal held several characters, as `'ab'` does; its value is then
implementation defined.
"""
function isMultiChar(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_isMultiChar(x)
end

"""
    getValue(x::AbstractCharLiteralParser) -> UInt64
Return the literal's value, with escape sequences and universal character names decoded.
"""
function getValue(x::AbstractCharLiteralParser)
    @check_ptrs x
    return clang_CharLiteralParser_getValue(x)
end

"""
    getUDSuffix(x::AbstractCharLiteralParser) -> String
Return the user-defined suffix, or `""` when the literal carries none.
"""
function getUDSuffix(x::AbstractCharLiteralParser)
    @check_ptrs x
    return get_string(clang_CharLiteralParser_getUDSuffix(x))
end

"""
    getUDSuffixOffset(x::AbstractCharLiteralParser) -> Cuint
Return where the user-defined suffix starts in the spelling. The literal must carry one;
Clang asserts it.
"""
function getUDSuffixOffset(x::AbstractCharLiteralParser)
    @check_ptrs x
    @assert !isempty(getUDSuffix(x)) "the literal carries no user-defined suffix"
    return clang_CharLiteralParser_getUDSuffixOffset(x)
end

# StringLiteralParser
"""
    StringLiteralParser(toks::AbstractVector{Token}, src_mgr::AbstractSourceManager,
                        opts::AbstractLangOptions, target::AbstractTargetInfo,
                        diag=nothing) -> Union{StringLiteralParser,Nothing}
Concatenate `toks` — adjacent string-literal tokens, which is translation phase 6 — and
decode their escape sequences and universal character names.

Returns `nothing` unless `toks` is non-empty and every token is a string literal long
enough to hold its quotes. `diag` may be `nothing`, which turns the semantic checking of
the literals off.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function StringLiteralParser(toks::AbstractVector{Token}, src_mgr::AbstractSourceManager,
                             opts::AbstractLangOptions, target::AbstractTargetInfo,
                             diag::Union{AbstractDiagnosticsEngine,Nothing}=nothing)
    @check_ptrs src_mgr opts target
    for tok in toks
        @check_ptrs tok
    end
    handles = CXToken_[Base.unsafe_convert(CXToken_, tok) for tok in toks]
    d = diag === nothing ? CXDiagnosticsEngine(C_NULL) :
        Base.unsafe_convert(CXDiagnosticsEngine, diag)
    p = clang_StringLiteralParser_create(handles, length(handles), src_mgr, opts, target, d)
    return p == C_NULL ? nothing : StringLiteralParser(p)
end

"""
    StringLiteralParser(toks::AbstractVector{Token}, pp::AbstractPreprocessor,
                        method::CXStringLiteralEvalMethod=CXStringLiteralEvalMethod_Evaluated) -> Union{StringLiteralParser,Nothing}
The preprocessor-driven overload, which additionally handles the Microsoft function-local
predefined macros and can decode in unevaluated mode — what a `static_assert` message or an
`asm` string needs.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function StringLiteralParser(toks::AbstractVector{Token}, pp::AbstractPreprocessor,
                             method::CXStringLiteralEvalMethod=CXStringLiteralEvalMethod_Evaluated)
    @check_ptrs pp
    for tok in toks
        @check_ptrs tok
    end
    handles = CXToken_[Base.unsafe_convert(CXToken_, tok) for tok in toks]
    p = clang_StringLiteralParser_createFromPreprocessor(handles, length(handles), pp,
                                                         method)
    return p == C_NULL ? nothing : StringLiteralParser(p)
end

dispose(x::StringLiteralParser) = clang_StringLiteralParser_dispose(x)

function hadError(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_hadError(x)
end

"""
    GetStringLength(x::AbstractStringLiteralParser) -> Cuint
Return the number of decoded bytes.
"""
function GetStringLength(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_GetStringLength(x)
end

"""
    GetString(x::AbstractStringLiteralParser) -> Vector{UInt8}
Return the decoded bytes. This is binary data: a decoded `\\0` is a byte in it rather than
a terminator, and a wide or UTF-16/32 literal decodes to its target-endian code units, so
the result is a byte vector rather than a `String`.
"""
function GetString(x::AbstractStringLiteralParser)
    @check_ptrs x
    n = GetStringLength(x)
    bytes = Vector{UInt8}(undef, n)
    n > 0 && clang_StringLiteralParser_GetString(x, bytes, n)
    return bytes
end

"""
    GetNumStringChars(x::AbstractStringLiteralParser) -> Cuint
Return the length in characters of the element type the literal produces, i.e. the decoded
byte count divided by the character width.
"""
function GetNumStringChars(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_GetNumStringChars(x)
end

"""
    getOffsetOfStringByte(x::AbstractStringLiteralParser, tok::AbstractToken, byte_no::Integer) -> Cuint
Return where byte `byte_no` of the decoded string starts inside `tok`'s spelling, advancing
over escape sequences. `byte_no` is relative to `tok`'s own contribution, and `tok` must be
one of the tokens `x` was built from.

Clang only handles the narrow and UTF-8 forms here and asserts on the others, so `x` must
be ordinary or UTF-8. Every decoded byte comes from at least one spelling character, which
is what bounds `byte_no` by the token's length.
"""
function getOffsetOfStringByte(x::AbstractStringLiteralParser, tok::AbstractToken,
                               byte_no::Integer)
    @check_ptrs x tok
    @assert isOrdinary(x) || isUTF8(x) "byte offsets are only defined for narrow and UTF-8 literals"
    @assert 0 <= byte_no < getLength(tok) "byte offset out of range for this token"
    return clang_StringLiteralParser_getOffsetOfStringByte(x, tok, byte_no)
end

function isOrdinary(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isOrdinary(x)
end

function isWide(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isWide(x)
end

function isUTF8(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isUTF8(x)
end

function isUTF16(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isUTF16(x)
end

function isUTF32(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isUTF32(x)
end

"""
    isPascal(x::AbstractStringLiteralParser) -> Bool
Return whether the literal used the Pascal-string extension `"\\pfoo"`, whose first decoded
byte is the length.
"""
function isPascal(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isPascal(x)
end

function isUnevaluated(x::AbstractStringLiteralParser)
    @check_ptrs x
    return clang_StringLiteralParser_isUnevaluated(x)
end

"""
    getUDSuffix(x::AbstractStringLiteralParser) -> String
Return the user-defined suffix, or `""` when no token carried one.
"""
function getUDSuffix(x::AbstractStringLiteralParser)
    @check_ptrs x
    return get_string(clang_StringLiteralParser_getUDSuffix(x))
end

"""
    getUDSuffixToken(x::AbstractStringLiteralParser) -> Cuint
Return the index, among the concatenated tokens, of the one carrying the user-defined
suffix. There must be one; Clang asserts it.
"""
function getUDSuffixToken(x::AbstractStringLiteralParser)
    @check_ptrs x
    @assert !isempty(getUDSuffix(x)) "no token carried a user-defined suffix"
    return clang_StringLiteralParser_getUDSuffixToken(x)
end

"""
    getUDSuffixOffset(x::AbstractStringLiteralParser) -> Cuint
Return where the user-defined suffix starts in that token's spelling. There must be one;
Clang asserts it.
"""
function getUDSuffixOffset(x::AbstractStringLiteralParser)
    @check_ptrs x
    @assert !isempty(getUDSuffix(x)) "no token carried a user-defined suffix"
    return clang_StringLiteralParser_getUDSuffixOffset(x)
end

"""
    isValidStringUDSuffix(opts::AbstractLangOptions, suffix::AbstractString) -> Bool
Return whether `suffix` is a suffix a string literal may carry.
"""
function isValidStringUDSuffix(opts::AbstractLangOptions, suffix::AbstractString)
    @check_ptrs opts
    return clang_StringLiteralParser_isValidUDSuffix(opts, suffix)
end
