# Token
getLocation(x::Token) = SourceLocation(clang_Token_getLocation(x))

getAnnotationEndLoc(x::Token) = SourceLocation(clang_Token_getAnnotationEndLoc(x))
getAnnotationRange(x::Token) = SourceRange(getLocation(x), getAnnotationEndLoc(x))

is_eof(Tok) = clang_Token_isKind_eof(Tok)
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
