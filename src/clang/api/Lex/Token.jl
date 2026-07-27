# Token
getLocation(x::Token) = SourceLocation(clang_Token_getLocation(x))

getAnnotationEndLoc(x::Token) = SourceLocation(clang_Token_getAnnotationEndLoc(x))
getAnnotationRange(x::Token) = SourceRange(getLocation(x), getAnnotationEndLoc(x))

getName(x::Token) = unsafe_string(clang_Token_getName(x))
getIdentifierInfo(x::Token) = IdentifierInfo(clang_Token_getIdentifierInfo(x))

is_eof(Tok) = clang_Token_isKind_eof(Tok)
is_annot_repl_input_end(Tok) = clang_Token_isKind_annot_repl_input_end(Tok)
is_identifier(Tok) = clang_Token_isKind_identifier(Tok)
is_coloncolon(Tok) = clang_Token_isKind_coloncolon(Tok)

is_annot_cxxscope(Tok) = clang_Token_isKind_annot_cxxscope(Tok)
is_annot_typename(Tok) = clang_Token_isKind_annot_typename(Tok)
is_annot_template_id(Tok) = clang_Token_isKind_annot_template_id(Tok)

is_kw_enum(Tok) = clang_Token_isKind_kw_enum(Tok)
is_kw_typename(Tok) = clang_Token_isKind_kw_typename(Tok)

# AnnotationValue
function getAnnotationValue(x::Token)
    return AnnotationValue(clang_Token_getAnnotationValue(x))
end


is_raw_identifier(Tok) = clang_Token_isKind_raw_identifier(Tok)
is_numeric_constant(Tok) = clang_Token_isKind_numeric_constant(Tok)

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
