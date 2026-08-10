#ifndef LLVM_CLANG_C_EXTRA_CXATTRIBUTES_H
#define LLVM_CLANG_C_EXTRA_CXATTRIBUTES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::AttributeCommonInfo::Syntax` (clang/Basic/AttributeCommonInfo.h): the
// source form an attribute was written in. Named after the class rather than the bare enum
// (`Syntax`), which alone would say nothing. Numbering starts at 1, and TableGen depends on
// the order — see the note in clang's own header. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXAttributeCommonInfoSyntax {
  CXAttributeCommonInfoSyntax_AS_GNU = 1,
  CXAttributeCommonInfoSyntax_AS_CXX11,
  CXAttributeCommonInfoSyntax_AS_C23,
  CXAttributeCommonInfoSyntax_AS_Declspec,
  CXAttributeCommonInfoSyntax_AS_Microsoft,
  CXAttributeCommonInfoSyntax_AS_Keyword,
  CXAttributeCommonInfoSyntax_AS_Pragma,
  CXAttributeCommonInfoSyntax_AS_ContextSensitiveKeyword,
  CXAttributeCommonInfoSyntax_AS_HLSLSemantic,
  CXAttributeCommonInfoSyntax_AS_Implicit
} CXAttributeCommonInfoSyntax;

// clang::hasAttribute, the engine behind __has_attribute / __has_cpp_attribute: the
// version number clang implements the named attribute at, or 0 when it does not implement
// it in that syntax for that target and language mode.
//
// `Scope` is the `[[scope::attr]]` qualifier and may be NULL for an unscoped attribute;
// `Attr` names the attribute itself and must not be NULL. Both are IdentifierInfos from
// the preprocessor's own table — clang_Preprocessor_getIdentifierInfo is what makes them.
int clang_hasAttribute(CXAttributeCommonInfoSyntax Syntax, CXIdentifierInfo Scope,
                       CXIdentifierInfo Attr, CXTargetInfo_ Target,
                       CXLangOptions LangOpts);

LLVM_CLANG_C_EXTERN_C_END

#endif
