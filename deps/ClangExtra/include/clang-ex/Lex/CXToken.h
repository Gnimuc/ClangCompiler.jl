#ifndef LLVM_CLANG_C_EXTRA_CXTOKEN_H
#define LLVM_CLANG_C_EXTRA_CXTOKEN_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXAnnotationValue clang_Token_getAnnotationValue(CXToken_ Tok);

CXSourceLocation_ clang_Token_getLocation(CXToken_ Tok);
CXSourceLocation_ clang_Token_getAnnotationEndLoc(CXToken_ Tok);

bool clang_Token_isKind_eof(CXToken_ Tok);
bool clang_Token_isKind_identifier(CXToken_ Tok);
bool clang_Token_isKind_coloncolon(CXToken_ Tok);

bool clang_Token_isKind_annot_cxxscope(CXToken_ Tok);
bool clang_Token_isKind_annot_typename(CXToken_ Tok);
bool clang_Token_isKind_annot_template_id(CXToken_ Tok);

bool clang_Token_isKind_kw_enum(CXToken_ Tok);
bool clang_Token_isKind_kw_typename(CXToken_ Tok);

LLVM_CLANG_C_EXTERN_C_END

#endif