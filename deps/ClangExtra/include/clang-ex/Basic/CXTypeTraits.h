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

// mirrors clang::TypeTrait (clang/Basic/TypeTraits.h; the enumerators are X-macro-generated
// from the TYPE_TRAIT_1 / TYPE_TRAIT_2 / TYPE_TRAIT_N lines of clang/Basic/TokenKinds.def -
// every unary trait first, then every binary one, then every n-ary one, each group in that
// file's order). Synced by static_assert in lib/Basic/CXEnumSync.cpp. The trailing
// clang::UTT_Last / BTT_Last / TT_Last are computed sentinels aliasing the last trait of
// each group and are intentionally not mirrored.
typedef enum CXTypeTrait {
  CXTypeTrait_UTT_IsInterfaceClass,
  CXTypeTrait_UTT_IsSealed,
  CXTypeTrait_UTT_IsDestructible,
  CXTypeTrait_UTT_IsTriviallyDestructible,
  CXTypeTrait_UTT_IsNothrowDestructible,
  CXTypeTrait_UTT_HasNothrowMoveAssign,
  CXTypeTrait_UTT_HasTrivialMoveAssign,
  CXTypeTrait_UTT_HasTrivialMoveConstructor,
  CXTypeTrait_UTT_HasNothrowAssign,
  CXTypeTrait_UTT_HasNothrowCopy,
  CXTypeTrait_UTT_HasNothrowConstructor,
  CXTypeTrait_UTT_HasTrivialAssign,
  CXTypeTrait_UTT_HasTrivialCopy,
  CXTypeTrait_UTT_HasTrivialDefaultConstructor,
  CXTypeTrait_UTT_HasTrivialDestructor,
  CXTypeTrait_UTT_HasVirtualDestructor,
  CXTypeTrait_UTT_IsAbstract,
  CXTypeTrait_UTT_IsAggregate,
  CXTypeTrait_UTT_IsClass,
  CXTypeTrait_UTT_IsEmpty,
  CXTypeTrait_UTT_IsEnum,
  CXTypeTrait_UTT_IsFinal,
  CXTypeTrait_UTT_IsLiteral,
  CXTypeTrait_UTT_IsPOD,
  CXTypeTrait_UTT_IsPolymorphic,
  CXTypeTrait_UTT_IsStandardLayout,
  CXTypeTrait_UTT_IsTrivial,
  CXTypeTrait_UTT_IsTriviallyCopyable,
  CXTypeTrait_UTT_IsUnion,
  CXTypeTrait_UTT_HasUniqueObjectRepresentations,
  CXTypeTrait_UTT_IsTriviallyRelocatable,
  CXTypeTrait_UTT_IsTriviallyEqualityComparable,
  CXTypeTrait_UTT_IsBoundedArray,
  CXTypeTrait_UTT_IsUnboundedArray,
  CXTypeTrait_UTT_IsNullPointer,
  CXTypeTrait_UTT_IsScopedEnum,
  CXTypeTrait_UTT_IsReferenceable,
  CXTypeTrait_UTT_CanPassInRegs,
  CXTypeTrait_UTT_IsArithmetic,
  CXTypeTrait_UTT_IsFloatingPoint,
  CXTypeTrait_UTT_IsIntegral,
  CXTypeTrait_UTT_IsCompleteType,
  CXTypeTrait_UTT_IsVoid,
  CXTypeTrait_UTT_IsArray,
  CXTypeTrait_UTT_IsFunction,
  CXTypeTrait_UTT_IsReference,
  CXTypeTrait_UTT_IsLvalueReference,
  CXTypeTrait_UTT_IsRvalueReference,
  CXTypeTrait_UTT_IsFundamental,
  CXTypeTrait_UTT_IsObject,
  CXTypeTrait_UTT_IsScalar,
  CXTypeTrait_UTT_IsCompound,
  CXTypeTrait_UTT_IsPointer,
  CXTypeTrait_UTT_IsMemberObjectPointer,
  CXTypeTrait_UTT_IsMemberFunctionPointer,
  CXTypeTrait_UTT_IsMemberPointer,
  CXTypeTrait_UTT_IsConst,
  CXTypeTrait_UTT_IsVolatile,
  CXTypeTrait_UTT_IsSigned,
  CXTypeTrait_UTT_IsUnsigned,
  CXTypeTrait_BTT_TypeCompatible,
  CXTypeTrait_BTT_IsNothrowAssignable,
  CXTypeTrait_BTT_IsAssignable,
  CXTypeTrait_BTT_IsBaseOf,
  CXTypeTrait_BTT_IsConvertibleTo,
  CXTypeTrait_BTT_IsTriviallyAssignable,
  CXTypeTrait_BTT_ReferenceBindsToTemporary,
  CXTypeTrait_BTT_ReferenceConstructsFromTemporary,
  CXTypeTrait_BTT_IsSame,
  CXTypeTrait_BTT_IsConvertible,
  CXTypeTrait_TT_IsConstructible,
  CXTypeTrait_TT_IsNothrowConstructible,
  CXTypeTrait_TT_IsTriviallyConstructible
} CXTypeTrait;

LLVM_CLANG_C_EXTERN_C_END

#endif
