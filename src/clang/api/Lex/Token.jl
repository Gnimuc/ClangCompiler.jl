# Token
getLocation(x::Token) = SourceLocation(clang_Token_getLocation(x))

getAnnotationEndLoc(x::Token) = SourceLocation(clang_Token_getAnnotationEndLoc(x))
getAnnotationRange(x::Token) = SourceRange(getLocation(x), getAnnotationEndLoc(x))

getName(x::Token) = unsafe_string(clang_Token_getName(x))
getIdentifierInfo(x::Token) = IdentifierInfo(clang_Token_getIdentifierInfo(x))

is_eof(Tok::AbstractToken) = clang_Token_isKind_eof(Tok)
is_annot_repl_input_end(Tok::AbstractToken) = clang_Token_isKind_annot_repl_input_end(Tok)
is_identifier(Tok::AbstractToken) = clang_Token_isKind_identifier(Tok)
is_coloncolon(Tok::AbstractToken) = clang_Token_isKind_coloncolon(Tok)

is_annot_cxxscope(Tok::AbstractToken) = clang_Token_isKind_annot_cxxscope(Tok)
is_annot_typename(Tok::AbstractToken) = clang_Token_isKind_annot_typename(Tok)
is_annot_template_id(Tok::AbstractToken) = clang_Token_isKind_annot_template_id(Tok)

is_kw_enum(Tok::AbstractToken) = clang_Token_isKind_kw_enum(Tok)
is_kw_typename(Tok::AbstractToken) = clang_Token_isKind_kw_typename(Tok)

# AnnotationValue
function getAnnotationValue(x::Token)
    return AnnotationValue(clang_Token_getAnnotationValue(x))
end

is_raw_identifier(Tok::AbstractToken) = clang_Token_isKind_raw_identifier(Tok)
is_numeric_constant(Tok::AbstractToken) = clang_Token_isKind_numeric_constant(Tok)

"""
    Token() -> Token
Create an empty token initialized via `startToken`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function Token()
    tok = clang_Token_create()
    @assert tok != C_NULL "Failed to create Token"
    return Token(tok)
end

dispose(x::Token) = clang_Token_dispose(x)

"""
    getKind(x::AbstractToken) -> UInt32
Return the raw `clang::tok::TokenKind` value of this token.

The token-kind enum is not mirrored; use `getName` for the kind's spelling.
"""
function getKind(x::AbstractToken)
    @check_ptrs x
    return clang_Token_getKind(x)
end

function is(x::AbstractToken, kind::Integer)
    @check_ptrs x
    return clang_Token_is(x, kind)
end

function isNot(x::AbstractToken, kind::Integer)
    @check_ptrs x
    return clang_Token_isNot(x, kind)
end

function isAnyIdentifier(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isAnyIdentifier(x)
end

function isLiteral(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isLiteral(x)
end

function isAnnotation(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isAnnotation(x)
end

function isRegularKeywordAttribute(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isRegularKeywordAttribute(x)
end

function getLength(x::AbstractToken)
    @check_ptrs x
    @assert !isAnnotation(x) "annotation tokens have no length"
    return clang_Token_getLength(x)
end

function getLastLoc(x::AbstractToken)
    @check_ptrs x
    return SourceLocation(clang_Token_getLastLoc(x))
end

function getEndLoc(x::AbstractToken)
    @check_ptrs x
    return SourceLocation(clang_Token_getEndLoc(x))
end

function startToken(x::AbstractToken)
    @check_ptrs x
    return clang_Token_startToken(x)
end

function hasPtrData(x::AbstractToken)
    @check_ptrs x
    return clang_Token_hasPtrData(x)
end

function getRawIdentifier(x::AbstractToken)
    @check_ptrs x
    @assert is_raw_identifier(x) "not a raw-identifier token"
    return get_string(clang_Token_getRawIdentifier(x))
end

function getFlag(x::AbstractToken, flag::CXTokenFlags)
    @check_ptrs x
    return clang_Token_getFlag(x, flag)
end

function getFlags(x::AbstractToken)
    @check_ptrs x
    return clang_Token_getFlags(x)
end

function setFlagValue(x::AbstractToken, flag::CXTokenFlags, val::Bool)
    @check_ptrs x
    return clang_Token_setFlagValue(x, flag, val)
end

function isAtStartOfLine(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isAtStartOfLine(x)
end

function hasLeadingSpace(x::AbstractToken)
    @check_ptrs x
    return clang_Token_hasLeadingSpace(x)
end

function isExpandDisabled(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isExpandDisabled(x)
end

function needsCleaning(x::AbstractToken)
    @check_ptrs x
    return clang_Token_needsCleaning(x)
end

function hasLeadingEmptyMacro(x::AbstractToken)
    @check_ptrs x
    return clang_Token_hasLeadingEmptyMacro(x)
end

function hasUDSuffix(x::AbstractToken)
    @check_ptrs x
    return clang_Token_hasUDSuffix(x)
end

function hasUCN(x::AbstractToken)
    @check_ptrs x
    return clang_Token_hasUCN(x)
end

function stringifiedInMacro(x::AbstractToken)
    @check_ptrs x
    return clang_Token_stringifiedInMacro(x)
end

function commaAfterElided(x::AbstractToken)
    @check_ptrs x
    return clang_Token_commaAfterElided(x)
end

function isEditorPlaceholder(x::AbstractToken)
    @check_ptrs x
    return clang_Token_isEditorPlaceholder(x)
end

"""
    setIdentifierInfo(x::AbstractToken, ii::AbstractIdentifierInfo)
Store `ii` as this token's identifier. The token borrows `ii`, which is owned by the
identifier table.
"""
function setIdentifierInfo(x::AbstractToken, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_Token_setIdentifierInfo(x, ii)
end

"""
    setKind(x::AbstractToken, kind::Integer)
Set the raw `clang::tok::TokenKind` value of this token.

The token-kind enum is not mirrored; the only portable source of a `kind` value is
`getKind` on another token.
"""
function setKind(x::AbstractToken, kind::Integer)
    @check_ptrs x
    return clang_Token_setKind(x, kind)
end

"""
    setLocation(x::AbstractToken, loc::SourceLocation)
Set the location of the first character of this token.
"""
function setLocation(x::AbstractToken, loc::SourceLocation)
    @check_ptrs x
    return clang_Token_setLocation(x, loc)
end

"""
    setLength(x::AbstractToken, len::Integer)
Set the length in characters of this token. `x` must not be an annotation token — an
annotation stores its end location in the same field, and Clang asserts.
"""
function setLength(x::AbstractToken, len::Integer)
    @check_ptrs x
    @assert !isAnnotation(x) "annotation tokens have no length field"
    return clang_Token_setLength(x, len)
end

"""
    setFlag(x::AbstractToken, flag::CXTokenFlags)
Set `flag` on this token. Spelling of `Token::setFlag`, implemented over `setFlagValue`.
"""
setFlag(x::AbstractToken, flag::CXTokenFlags) = setFlagValue(x, flag, true)

"""
    clearFlag(x::AbstractToken, flag::CXTokenFlags)
Unset `flag` on this token. Spelling of `Token::clearFlag`, implemented over
`setFlagValue`.
"""
clearFlag(x::AbstractToken, flag::CXTokenFlags) = setFlagValue(x, flag, false)

"""
    getLiteralData(x::AbstractToken) -> String
Return the text of this literal token, copied out of the source buffer. `x` must be a
literal (`isLiteral`); Clang asserts otherwise. Returns an empty string when the literal's
text was not recorded.
"""
function getLiteralData(x::AbstractToken)
    @check_ptrs x
    @assert isLiteral(x) "token must be a literal"
    p = clang_Token_getLiteralData(x)
    p == C_NULL && return ""
    return unsafe_string(p, getLength(x))
end
