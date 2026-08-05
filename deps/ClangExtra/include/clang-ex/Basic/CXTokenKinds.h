#ifndef LLVM_CLANG_C_EXTRA_CXTOKENKINDS_H
#define LLVM_CLANG_C_EXTRA_CXTOKENKINDS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// mirrors clang::tok::PPKeywordKind (clang/Basic/TokenKinds.h; the enumerators are
// X-macro-generated from the PPKEYWORD lines in clang/Basic/TokenKinds.def, so this
// order tracks that file). Synced by static_assert in lib/Basic/CXEnumSync.cpp. The
// trailing clang::tok::NUM_PP_KEYWORDS is a computed sentinel and is intentionally
// not mirrored.
typedef enum CXPPKeywordKind {
  CXPPKeywordKind_pp_not_keyword,
  CXPPKeywordKind_pp_if,
  CXPPKeywordKind_pp_ifdef,
  CXPPKeywordKind_pp_ifndef,
  CXPPKeywordKind_pp_elif,
  CXPPKeywordKind_pp_elifdef,
  CXPPKeywordKind_pp_elifndef,
  CXPPKeywordKind_pp_else,
  CXPPKeywordKind_pp_endif,
  CXPPKeywordKind_pp_defined,
  CXPPKeywordKind_pp_include,
  CXPPKeywordKind_pp___include_macros,
  CXPPKeywordKind_pp_define,
  CXPPKeywordKind_pp_undef,
  CXPPKeywordKind_pp_line,
  CXPPKeywordKind_pp_error,
  CXPPKeywordKind_pp_pragma,
  CXPPKeywordKind_pp_import,
  CXPPKeywordKind_pp_include_next,
  CXPPKeywordKind_pp_warning,
  CXPPKeywordKind_pp_ident,
  CXPPKeywordKind_pp_sccs,
  CXPPKeywordKind_pp_assert,
  CXPPKeywordKind_pp_unassert,
  CXPPKeywordKind_pp___public_macro,
  CXPPKeywordKind_pp___private_macro
} CXPPKeywordKind;

// Kind is a raw clang::tok::TokenKind value in every function below (that enum's
// ~450 .def-generated enumerators are not mirrored; obtain values from
// clang_IdentifierInfo_getTokenID). Kind must be < clang::tok::NUM_TOKENS.

const char *clang_tok_getTokenName(unsigned Kind);

// returns NULL for non-punctuator kinds
const char *clang_tok_getPunctuatorSpelling(unsigned Kind);

// returns NULL for non-keyword kinds
const char *clang_tok_getKeywordSpelling(unsigned Kind);

// returns NULL when the kind has no spelling
const char *clang_tok_getPPKeywordSpelling(CXPPKeywordKind Kind);

bool clang_tok_isAnyIdentifier(unsigned Kind);

bool clang_tok_isStringLiteral(unsigned Kind);

bool clang_tok_isLiteral(unsigned Kind);

bool clang_tok_isAnnotation(unsigned Kind);

bool clang_tok_isPragmaAnnotation(unsigned Kind);

// isRegularKeywordAttribute

LLVM_CLANG_C_EXTERN_C_END

#endif
