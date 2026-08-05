#ifndef LLVM_CLANG_C_EXTRA_CXSPECIFIERS_H
#define LLVM_CLANG_C_EXTRA_CXSPECIFIERS_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXExplicitSpecKind : unsigned {
  CXExplicitSpecKind_ResolvedFalse,
  CXExplicitSpecKind_ResolvedTrue,
  CXExplicitSpecKind_Unresolved,
} CXExplicitSpecKind;

typedef enum CXAccessSpecifier {
  CXAccessSpecifier_AS_public,
  CXAccessSpecifier_AS_protected,
  CXAccessSpecifier_AS_private,
  CXAccessSpecifier_AS_none
} CXAccessSpecifier;

typedef enum CXExprValueKind {
  CXExprValueKind_VK_PRValue,
  CXExprValueKind_VK_LValue,
  CXExprValueKind_VK_XValue,
} CXExprValueKind;

typedef enum CXExprObjectKind {
  CXExprObjectKind_OK_Ordinary,
  CXExprObjectKind_OK_BitField,
  CXExprObjectKind_OK_VectorComponent,
  CXExprObjectKind_OK_ObjCProperty,
  CXExprObjectKind_OK_ObjCSubscript,
  CXExprObjectKind_OK_MatrixComponent
} CXExprObjectKind;

typedef enum CXNonOdrUseReason {
  CXNonOdrUseReason_NOUR_None = 0,
  CXNonOdrUseReason_NOUR_Unevaluated,
  CXNonOdrUseReason_NOUR_Constant,
  CXNonOdrUseReason_NOUR_Discarded
} CXNonOdrUseReason;

typedef enum CXConstexprSpecKind {
  CXConstexprSpecKind_Unspecified,
  CXConstexprSpecKind_Constexpr,
  CXConstexprSpecKind_Consteval,
  CXConstexprSpecKind_Constinit
} CXConstexprSpecKind;

typedef enum CXTemplateSpecializationKind {
  CXTemplateSpecializationKind_TSK_Undeclared = 0,
  CXTemplateSpecializationKind_TSK_ImplicitInstantiation,
  CXTemplateSpecializationKind_TSK_ExplicitSpecialization,
  CXTemplateSpecializationKind_TSK_ExplicitInstantiationDeclaration,
  CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition
} CXTemplateSpecializationKind;

typedef enum CXThreadStorageClassSpecifier {
  CXThreadStorageClassSpecifier_TSCS_unspecified,
  CXThreadStorageClassSpecifier_TSCS___thread,
  CXThreadStorageClassSpecifier_TSCS_thread_local,
  CXThreadStorageClassSpecifier_TSCS__Thread_local
} CXThreadStorageClassSpecifier;

typedef enum CXStorageClass {
  CXStorageClass_SC_None,
  CXStorageClass_SC_Extern,
  CXStorageClass_SC_Static,
  CXStorageClass_SC_PrivateExtern,
  CXStorageClass_SC_Auto,
  CXStorageClass_SC_Register
} CXStorageClass;

typedef enum CXInClassInitStyle {
  CXInClassInitStyle_ICIS_NoInit,
  CXInClassInitStyle_ICIS_CopyInit,
  CXInClassInitStyle_ICIS_ListInit
} CXInClassInitStyle;

typedef enum CXStorageDuration {
  CXStorageDuration_SD_FullExpression,
  CXStorageDuration_SD_Automatic,
  CXStorageDuration_SD_Thread,
  CXStorageDuration_SD_Static,
  CXStorageDuration_SD_Dynamic
} CXStorageDuration;

// clang::CallingConv (clang/Basic/Specifiers.h). Trailing underscore: libclang's
// clang-c/Index.h defines an unrelated `enum CXCallingConv` (Index.h:2961). Order
// and values must stay identical to the pinned Clang header; the ENUM_SYNC table
// in lib/Basic/CXEnumSync.cpp fails the build if an LLVM bump renumbers them.
typedef enum CXCallingConv_ {
  CXCallingConv_CC_C,
  CXCallingConv_CC_X86StdCall,
  CXCallingConv_CC_X86FastCall,
  CXCallingConv_CC_X86ThisCall,
  CXCallingConv_CC_X86VectorCall,
  CXCallingConv_CC_X86Pascal,
  CXCallingConv_CC_Win64,
  CXCallingConv_CC_X86_64SysV,
  CXCallingConv_CC_X86RegCall,
  CXCallingConv_CC_AAPCS,
  CXCallingConv_CC_AAPCS_VFP,
  CXCallingConv_CC_IntelOclBicc,
  CXCallingConv_CC_SpirFunction,
  CXCallingConv_CC_OpenCLKernel,
  CXCallingConv_CC_Swift,
  CXCallingConv_CC_SwiftAsync,
  CXCallingConv_CC_PreserveMost,
  CXCallingConv_CC_PreserveAll,
  CXCallingConv_CC_AArch64VectorCall,
  CXCallingConv_CC_AArch64SVEPCS,
  CXCallingConv_CC_AMDGPUKernelCall,
  CXCallingConv_CC_M68kRTD
} CXCallingConv_;

// Mirrors clang::IfStatementKind (clang/Basic/Specifiers.h): whether an `if`
// statement is an ordinary if, an `if constexpr`, an `if consteval` or an
// `if ! consteval`. Order and values must stay identical to the pinned Clang
// header; the ENUM_SYNC table in lib/Basic/CXEnumSync.cpp fails the build if an
// LLVM bump renumbers them.
typedef enum CXIfStatementKind : unsigned {
  CXIfStatementKind_Ordinary,
  CXIfStatementKind_Constexpr,
  CXIfStatementKind_ConstevalNonNegated,
  CXIfStatementKind_ConstevalNegated
} CXIfStatementKind;

// Mirrors clang::NullabilityKind (clang/Basic/Specifiers.h): the nullability a
// `_Nonnull` / `_Nullable` / `_Null_unspecified` / `_Nullable_result` annotation
// records. Order and values must stay identical to the pinned Clang header; the
// ENUM_SYNC table in lib/Basic/CXEnumSync.cpp fails the build if an LLVM bump
// renumbers them.
typedef enum CXNullabilityKind : unsigned char {
  CXNullabilityKind_NonNull,
  CXNullabilityKind_Nullable,
  CXNullabilityKind_Unspecified,
  CXNullabilityKind_NullableResult
} CXNullabilityKind;

// Mirrors clang::ParameterABI (clang/Basic/Specifiers.h): the ABI treatment one
// function parameter gets, as carried by clang::FunctionType::ExtParameterInfo.
// Order and values must stay identical to the pinned Clang header; the ENUM_SYNC
// table in lib/Basic/CXEnumSync.cpp fails the build if an LLVM bump renumbers
// them.
typedef enum CXParameterABI {
  CXParameterABI_Ordinary,
  CXParameterABI_SwiftIndirectResult,
  CXParameterABI_SwiftErrorResult,
  CXParameterABI_SwiftContext,
  CXParameterABI_SwiftAsyncContext
} CXParameterABI;

// Mirrors clang::MSInheritanceModel (clang/Basic/Specifiers.h): the Microsoft C++ ABI
// member-pointer representation a class is given. Order and values must stay identical
// to the pinned Clang header; the ENUM_SYNC table in lib/Basic/CXEnumSync.cpp fails the
// build if an LLVM bump renumbers them.
typedef enum CXMSInheritanceModel {
  CXMSInheritanceModel_Single = 0,
  CXMSInheritanceModel_Multiple = 1,
  CXMSInheritanceModel_Virtual = 2,
  CXMSInheritanceModel_Unspecified = 3
} CXMSInheritanceModel;

LLVM_CLANG_C_EXTERN_C_END

#endif