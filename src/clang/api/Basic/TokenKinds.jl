# TokenKinds — free functions in the `clang::tok` namespace. `kind` is a raw
# `clang::tok::TokenKind` value (e.g. from `getTokenID(::AbstractIdentifierInfo)`).

getTokenName(kind::Integer) = unsafe_string(clang_tok_getTokenName(kind))

"""
    getPunctuatorSpelling(kind::Integer) -> Union{String,Nothing}
Return the spelling of simple punctuation tokens like `!` or `%`, or `nothing` for
literal and annotation tokens.
"""
function getPunctuatorSpelling(kind::Integer)
    p = clang_tok_getPunctuatorSpelling(kind)
    return p == C_NULL ? nothing : unsafe_string(p)
end

"""
    getKeywordSpelling(kind::Integer) -> Union{String,Nothing}
Return the spelling of simple keyword and contextual keyword tokens like `int`, or
`nothing` for other token kinds.
"""
function getKeywordSpelling(kind::Integer)
    p = clang_tok_getKeywordSpelling(kind)
    return p == C_NULL ? nothing : unsafe_string(p)
end

"""
    getPPKeywordSpelling(kind::CXPPKeywordKind) -> Union{String,Nothing}
Return the spelling of a preprocessor keyword, such as "else", or `nothing` when the
kind has no spelling.
"""
function getPPKeywordSpelling(kind::CXPPKeywordKind)
    p = clang_tok_getPPKeywordSpelling(kind)
    return p == C_NULL ? nothing : unsafe_string(p)
end

isAnyIdentifier(kind::Integer) = clang_tok_isAnyIdentifier(kind)

isStringLiteral(kind::Integer) = clang_tok_isStringLiteral(kind)

isLiteral(kind::Integer) = clang_tok_isLiteral(kind)

isAnnotation(kind::Integer) = clang_tok_isAnnotation(kind)

isPragmaAnnotation(kind::Integer) = clang_tok_isPragmaAnnotation(kind)
