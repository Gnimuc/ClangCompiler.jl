#ifndef LIBCLANGEX_CXTOKEN_H
#define LIBCLANGEX_CXTOKEN_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXAnnotationValue clang_Token_getAnnotationValue(CXToken_ Tok);

CINDEX_LINKAGE CXSourceLocation_ clang_Token_getLocation(CXToken_ Tok);
CINDEX_LINKAGE CXSourceLocation_ clang_Token_getAnnotationEndLoc(CXToken_ Tok);

CINDEX_LINKAGE bool clang_Token_isKind_eof(CXToken_ Tok);
CINDEX_LINKAGE bool clang_Token_isKind_identifier(CXToken_ Tok);
CINDEX_LINKAGE bool clang_Token_isKind_coloncolon(CXToken_ Tok);

CINDEX_LINKAGE bool clang_Token_isKind_annot_cxxscope(CXToken_ Tok);
CINDEX_LINKAGE bool clang_Token_isKind_annot_typename(CXToken_ Tok);
CINDEX_LINKAGE bool clang_Token_isKind_annot_template_id(CXToken_ Tok);

CINDEX_LINKAGE bool clang_Token_isKind_kw_enum(CXToken_ Tok);
CINDEX_LINKAGE bool clang_Token_isKind_kw_typename(CXToken_ Tok);

#ifdef __cplusplus
}
#endif
#endif