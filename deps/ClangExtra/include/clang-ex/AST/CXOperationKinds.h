#ifndef LLVM_CLANG_C_EXTRA_CXOPERATIONKINDS_H
#define LLVM_CLANG_C_EXTRA_CXOPERATIONKINDS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXCastKind {
  CXCastKind_CK_Dependent,
  CXCastKind_CK_BitCast,
  CXCastKind_CK_LValueBitCast,
  CXCastKind_CK_LValueToRValueBitCast,
  CXCastKind_CK_LValueToRValue,
  CXCastKind_CK_NoOp,
  CXCastKind_CK_BaseToDerived,
  CXCastKind_CK_DerivedToBase,
  CXCastKind_CK_UncheckedDerivedToBase,
  CXCastKind_CK_Dynamic,
  CXCastKind_CK_ToUnion,
  CXCastKind_CK_ArrayToPointerDecay,
  CXCastKind_CK_FunctionToPointerDecay,
  CXCastKind_CK_NullToPointer,
  CXCastKind_CK_NullToMemberPointer,
  CXCastKind_CK_BaseToDerivedMemberPointer,
  CXCastKind_CK_DerivedToBaseMemberPointer,
  CXCastKind_CK_MemberPointerToBoolean,
  CXCastKind_CK_ReinterpretMemberPointer,
  CXCastKind_CK_UserDefinedConversion,
  CXCastKind_CK_ConstructorConversion,
  CXCastKind_CK_IntegralToPointer,
  CXCastKind_CK_PointerToIntegral,
  CXCastKind_CK_PointerToBoolean,
  CXCastKind_CK_ToVoid,
  CXCastKind_CK_MatrixCast,
  CXCastKind_CK_VectorSplat,
  CXCastKind_CK_IntegralCast,
  CXCastKind_CK_IntegralToBoolean,
  CXCastKind_CK_IntegralToFloating,
  CXCastKind_CK_FloatingToFixedPoint,
  CXCastKind_CK_FixedPointToFloating,
  CXCastKind_CK_FixedPointCast,
  CXCastKind_CK_FixedPointToIntegral,
  CXCastKind_CK_IntegralToFixedPoint,
  CXCastKind_CK_FixedPointToBoolean,
  CXCastKind_CK_FloatingToIntegral,
  CXCastKind_CK_FloatingToBoolean,
  CXCastKind_CK_BooleanToSignedIntegral,
  CXCastKind_CK_FloatingCast,
  CXCastKind_CK_CPointerToObjCPointerCast,
  CXCastKind_CK_BlockPointerToObjCPointerCast,
  CXCastKind_CK_AnyPointerToBlockPointerCast,
  CXCastKind_CK_ObjCObjectLValueCast,
  CXCastKind_CK_FloatingRealToComplex,
  CXCastKind_CK_FloatingComplexToReal,
  CXCastKind_CK_FloatingComplexToBoolean,
  CXCastKind_CK_FloatingComplexCast,
  CXCastKind_CK_FloatingComplexToIntegralComplex,
  CXCastKind_CK_IntegralRealToComplex,
  CXCastKind_CK_IntegralComplexToReal,
  CXCastKind_CK_IntegralComplexToBoolean,
  CXCastKind_CK_IntegralComplexCast,
  CXCastKind_CK_IntegralComplexToFloatingComplex,
  CXCastKind_CK_ARCProduceObject,
  CXCastKind_CK_ARCConsumeObject,
  CXCastKind_CK_ARCReclaimReturnedObject,
  CXCastKind_CK_ARCExtendBlockObject,
  CXCastKind_CK_AtomicToNonAtomic,
  CXCastKind_CK_NonAtomicToAtomic,
  CXCastKind_CK_CopyAndAutoreleaseBlockObject,
  CXCastKind_CK_BuiltinFnToFnPtr,
  CXCastKind_CK_ZeroToOCLOpaqueType,
  CXCastKind_CK_AddressSpaceConversion,
  CXCastKind_CK_IntToOCLSampler
} CXCastKind;

LLVM_CLANG_C_EXTERN_C_END

#endif