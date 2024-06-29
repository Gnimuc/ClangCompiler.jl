#ifndef LIBCLANGEX_CXSPECIFIERS_H
#define LIBCLANGEX_CXSPECIFIERS_H

#ifdef __cplusplus
extern "C" {
#endif

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
  CXExprValueKind_VK_RValue,
  CXExprValueKind_VK_LValue,
  CXExprValueKind_VK_XValue,
} CXExprValueKind;

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

#ifdef __cplusplus
}
#endif
#endif