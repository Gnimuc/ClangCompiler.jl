#ifndef LLVM_CLANG_C_EXTRA_CXEXPRESSIONTRAITS_H
#define LLVM_CLANG_C_EXTRA_CXEXPRESSIONTRAITS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// mirrors clang::ExpressionTrait (clang/Basic/ExpressionTraits.h; the
// enumerators are X-macro-generated from the EXPRESSION_TRAIT lines of
// clang/Basic/TokenKinds.def, so this order tracks that file). Synced by
// static_assert in lib/Basic/CXEnumSync.cpp. The trailing clang::ET_Last is a
// computed sentinel aliasing the last trait and is intentionally not mirrored.
typedef enum CXExpressionTrait {
  CXExpressionTrait_ET_IsLValueExpr,
  CXExpressionTrait_ET_IsRValueExpr
} CXExpressionTrait;

LLVM_CLANG_C_EXTERN_C_END

#endif
