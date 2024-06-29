#include "clang-ex/Lex/CXToken.h"
#include "clang/Lex/Token.h"

CXAnnotationValue clang_Token_getAnnotationValue(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getAnnotationValue();
}

CXSourceLocation_ clang_Token_getLocation(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getLocation().getPtrEncoding();
}

CXSourceLocation_ clang_Token_getAnnotationEndLoc(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getAnnotationEndLoc().getPtrEncoding();
}

bool clang_Token_isKind_eof(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::eof);
}

bool clang_Token_isKind_identifier(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::identifier);
}

bool clang_Token_isKind_coloncolon(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::coloncolon);
}

bool clang_Token_isKind_annot_cxxscope(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_cxxscope);
}

bool clang_Token_isKind_annot_typename(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_typename);
}

bool clang_Token_isKind_annot_template_id(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_template_id);
}

bool clang_Token_isKind_kw_enum(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::kw_enum);
}

bool clang_Token_isKind_kw_typename(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::kw_typename);
}