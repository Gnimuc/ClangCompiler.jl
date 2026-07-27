#ifndef LLVM_CLANG_C_EXTRA_CXTYPETRAITS_H
#define LLVM_CLANG_C_EXTRA_CXTYPETRAITS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// mirrors clang::UnaryExprOrTypeTrait (clang/Basic/TypeTraits.h; the enumerators
// are X-macro-generated from clang/Basic/TokenKinds.def, so this order tracks the
// UNARY_EXPR_OR_TYPE_TRAIT / CXX11_UNARY_EXPR_OR_TYPE_TRAIT lines in that file).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp. The trailing
// clang::UETT_Last is a computed sentinel aliasing the last trait and is
// intentionally not mirrored.
typedef enum CXUnaryExprOrTypeTrait {
  CXUnaryExprOrTypeTrait_UETT_SizeOf,
  CXUnaryExprOrTypeTrait_UETT_DataSizeOf,
  CXUnaryExprOrTypeTrait_UETT_AlignOf,
  CXUnaryExprOrTypeTrait_UETT_PreferredAlignOf,
  CXUnaryExprOrTypeTrait_UETT_VecStep,
  CXUnaryExprOrTypeTrait_UETT_OpenMPRequiredSimdAlign,
  CXUnaryExprOrTypeTrait_UETT_VectorElements
} CXUnaryExprOrTypeTrait;

// mirrors clang::ArrayTypeTrait (clang/Basic/TypeTraits.h; the enumerators are
// X-macro-generated from the ARRAY_TYPE_TRAIT lines of
// clang/Basic/TokenKinds.def, so this order tracks that file). Synced by
// static_assert in lib/Basic/CXEnumSync.cpp. The trailing clang::ATT_Last is a
// computed sentinel aliasing the last trait and is intentionally not mirrored.
typedef enum CXArrayTypeTrait {
  CXArrayTypeTrait_ATT_ArrayRank,
  CXArrayTypeTrait_ATT_ArrayExtent
} CXArrayTypeTrait;

LLVM_CLANG_C_EXTERN_C_END

#endif
