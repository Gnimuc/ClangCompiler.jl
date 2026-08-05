// Compile-time sync tables for hand-mirrored enums. Conversion at the C
// boundary is a bare static_cast in both directions, so an upstream
// renumbering silently corrupts every value crossing the boundary. Each
// mirrored enum gets one ENUM_SYNC line per enumerator; an LLVM bump that
// shifts values then fails this translation unit instead of shipping wrong
// numbers. When adding a new mirrored enum, add its table here.
// CXTypes.h must precede the pure-enum headers: they use the extern-C macros
// without including clang-c/ExternC.h themselves.
#include "clang-ex/CXTypes.h"

#include "clang-ex/AST/CXAPValue.h"
#include "clang-ex/AST/CXAttr.h"
#include "clang-ex/AST/CXExpr.h"
#include "clang-ex/AST/CXExprCXX.h"
#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXLinkage.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXVisibility.h"
#include "clang-ex/AST/CXNestedNameSpecifier.h"
#include "clang-ex/AST/CXDeclCXX.h"
#include "clang-ex/Basic/CXLambda.h"
#include "clang-ex/Basic/CXExceptionSpecificationType.h"
#include "clang-ex/Basic/CXTypeTraits.h"
#include "clang-ex/Basic/CXIdentifierTable.h"
#include "clang-ex/Basic/CXTokenKinds.h"
#include "clang-ex/Basic/CXModule.h"
#include "clang-ex/AST/CXDecl.h"
#include "clang-ex/AST/CXDeclBase.h"
#include "clang-ex/AST/CXDeclarationName.h"
#include "clang-ex/AST/CXType.h"
#include "clang-ex/AST/CXTemplateBase.h"
#include "clang-ex/AST/CXComment.h"
#include "clang-ex/Sema/CXLookup.h"
#include "clang-ex/Sema/CXSema.h"
#include "clang-ex/Analysis/CXCFG.h"
#include "clang-ex/Basic/CXDiagnostic.h"
#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang-ex/Basic/CXDiagnosticOptions.h"
#include "clang-ex/Basic/CXSourceManager.h"
#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXTargetCXXABI.h"
#include "clang-ex/Basic/CXTargetInfo.h"
#include "clang-ex/Lex/CXToken.h"
#include "clang-ex/AST/CXASTContext.h"
#include "clang-ex/AST/CXComment.h"
#include "clang-ex/Sema/CXLookup.h"

#include "clang-ex/AST/CXStmt.h"
#include "clang-ex/AST/CXTemplateName.h"
#include "clang-ex/Analysis/CXConstructionContext.h"
#include "clang-ex/Basic/CXBuiltins.h"
#include "clang-ex/Basic/CXCapturedStmt.h"
#include "clang-ex/Basic/CXExpressionTraits.h"
#include "clang-ex/Basic/CXFloatModeKind.h"
#include "clang-ex/Basic/CXLangOptions.h"
#include "clang-ex/Driver/CXDriver.h"
#include "clang-ex/Lex/CXMacroInfo.h"
#include "clang-ex/AST/CXParentMapContext.h"
#include "clang-ex/Lex/CXModuleMap.h"
#include "clang-ex/Lex/CXPreprocessingRecord.h"
#include "clang-ex/Lex/CXPreprocessor.h"
#include "clang-ex/Lex/CXPreprocessorOptions.h"
#include "clang-ex/Sema/CXOverload.h"
#include "clang-ex/Sema/CXScope.h"
#include "clang-ex/Sema/CXTemplate.h"
#include "clang/AST/APValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Attr.h"
#include "clang/AST/Comment.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/DeclarationName.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/OperationKinds.h"
#include "clang/AST/RawCommentList.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/TemplateBase.h"
#include "clang/AST/TemplateName.h"
#include "clang/AST/Type.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/ConstructionContext.h"
#include "clang/Basic/AddressSpaces.h"
#include "clang/Basic/Builtins.h"
#include "clang/Basic/CapturedStmt.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/DiagnosticIDs.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Basic/ExceptionSpecificationType.h"
#include "clang/Basic/ExpressionTraits.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/Lambda.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/Linkage.h"
#include "clang/Basic/Module.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/Specifiers.h"
#include "clang/Basic/TargetCXXABI.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/TokenKinds.h"
#include "clang/Basic/TypeTraits.h"
#include "clang/Basic/Visibility.h"
#include "clang/Driver/Driver.h"
#include "clang/Lex/MacroInfo.h"
#include "clang/AST/ASTTypeTraits.h"
#include "clang/Lex/ModuleMap.h"
#include "clang/Lex/PreprocessingRecord.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "clang/Lex/Token.h"
#include "clang/Sema/Lookup.h"
#include "clang/Sema/Overload.h"
#include "clang/Sema/Scope.h"
#include "clang/Sema/Sema.h"
#include "clang/Sema/Template.h"
#include "llvm/ADT/FloatingPointMode.h"
#include "llvm/Support/MemoryBuffer.h"

#define ENUM_SYNC(cx, cpp)                                                                 \
  static_assert(static_cast<int>(cx) == static_cast<int>(cpp), #cx " != " #cpp)

// clang/Basic/Linkage.h: enum class Linkage : unsigned char
ENUM_SYNC(CXLinkage_Invalid, clang::Linkage::Invalid);
ENUM_SYNC(CXLinkage_None, clang::Linkage::None);
ENUM_SYNC(CXLinkage_Internal, clang::Linkage::Internal);
ENUM_SYNC(CXLinkage_UniqueExternal, clang::Linkage::UniqueExternal);
ENUM_SYNC(CXLinkage_VisibleNone, clang::Linkage::VisibleNone);
ENUM_SYNC(CXLinkage_Module, clang::Linkage::Module);
ENUM_SYNC(CXLinkage_External, clang::Linkage::External);
static_assert(sizeof(CXLinkage) == sizeof(clang::Linkage), "CXLinkage size");

// clang/Basic/Linkage.h: enum LanguageLinkage
ENUM_SYNC(CXLanguageLinkage_CLanguageLinkage, clang::CLanguageLinkage);
ENUM_SYNC(CXLanguageLinkage_CXXLanguageLinkage, clang::CXXLanguageLinkage);
ENUM_SYNC(CXLanguageLinkage_NoLanguageLinkage, clang::NoLanguageLinkage);

// clang/Basic/Visibility.h: enum Visibility
ENUM_SYNC(CXVisibility_HiddenVisibility, clang::HiddenVisibility);
ENUM_SYNC(CXVisibility_ProtectedVisibility, clang::ProtectedVisibility);
ENUM_SYNC(CXVisibility_DefaultVisibility, clang::DefaultVisibility);

// clang/Basic/LangOptions.h: enum TranslationUnitKind
ENUM_SYNC(CXTranslationUnitKind_TU_Complete, clang::TU_Complete);
ENUM_SYNC(CXTranslationUnitKind_TU_Prefix, clang::TU_Prefix);
ENUM_SYNC(CXTranslationUnitKind_TU_Module, clang::TU_Module);
ENUM_SYNC(CXTranslationUnitKind_TU_Incremental, clang::TU_Incremental);

// clang/Basic/Specifiers.h: enum class ExplicitSpecKind
ENUM_SYNC(CXExplicitSpecKind_ResolvedFalse, clang::ExplicitSpecKind::ResolvedFalse);
ENUM_SYNC(CXExplicitSpecKind_ResolvedTrue, clang::ExplicitSpecKind::ResolvedTrue);
ENUM_SYNC(CXExplicitSpecKind_Unresolved, clang::ExplicitSpecKind::Unresolved);

// clang/Basic/Specifiers.h: enum AccessSpecifier
ENUM_SYNC(CXAccessSpecifier_AS_public, clang::AS_public);
ENUM_SYNC(CXAccessSpecifier_AS_protected, clang::AS_protected);
ENUM_SYNC(CXAccessSpecifier_AS_private, clang::AS_private);
ENUM_SYNC(CXAccessSpecifier_AS_none, clang::AS_none);

// clang/Basic/Specifiers.h: enum ExprValueKind
ENUM_SYNC(CXExprValueKind_VK_PRValue, clang::VK_PRValue);
ENUM_SYNC(CXExprValueKind_VK_LValue, clang::VK_LValue);
ENUM_SYNC(CXExprValueKind_VK_XValue, clang::VK_XValue);

// clang/Basic/Specifiers.h: enum class ConstexprSpecKind
ENUM_SYNC(CXConstexprSpecKind_Unspecified, clang::ConstexprSpecKind::Unspecified);
ENUM_SYNC(CXConstexprSpecKind_Constexpr, clang::ConstexprSpecKind::Constexpr);
ENUM_SYNC(CXConstexprSpecKind_Consteval, clang::ConstexprSpecKind::Consteval);
ENUM_SYNC(CXConstexprSpecKind_Constinit, clang::ConstexprSpecKind::Constinit);

// clang/Basic/Specifiers.h: enum TemplateSpecializationKind
ENUM_SYNC(CXTemplateSpecializationKind_TSK_Undeclared, clang::TSK_Undeclared);
ENUM_SYNC(CXTemplateSpecializationKind_TSK_ImplicitInstantiation,
          clang::TSK_ImplicitInstantiation);
ENUM_SYNC(CXTemplateSpecializationKind_TSK_ExplicitSpecialization,
          clang::TSK_ExplicitSpecialization);
ENUM_SYNC(CXTemplateSpecializationKind_TSK_ExplicitInstantiationDeclaration,
          clang::TSK_ExplicitInstantiationDeclaration);
ENUM_SYNC(CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition,
          clang::TSK_ExplicitInstantiationDefinition);

// clang/Basic/Specifiers.h: enum ThreadStorageClassSpecifier
ENUM_SYNC(CXThreadStorageClassSpecifier_TSCS_unspecified, clang::TSCS_unspecified);
ENUM_SYNC(CXThreadStorageClassSpecifier_TSCS___thread, clang::TSCS___thread);
ENUM_SYNC(CXThreadStorageClassSpecifier_TSCS_thread_local, clang::TSCS_thread_local);
ENUM_SYNC(CXThreadStorageClassSpecifier_TSCS__Thread_local, clang::TSCS__Thread_local);

// clang/Basic/Specifiers.h: enum StorageClass
ENUM_SYNC(CXStorageClass_SC_None, clang::SC_None);
ENUM_SYNC(CXStorageClass_SC_Extern, clang::SC_Extern);
ENUM_SYNC(CXStorageClass_SC_Static, clang::SC_Static);
ENUM_SYNC(CXStorageClass_SC_PrivateExtern, clang::SC_PrivateExtern);
ENUM_SYNC(CXStorageClass_SC_Auto, clang::SC_Auto);
ENUM_SYNC(CXStorageClass_SC_Register, clang::SC_Register);

// clang/Basic/Specifiers.h: enum InClassInitStyle
ENUM_SYNC(CXInClassInitStyle_ICIS_NoInit, clang::ICIS_NoInit);
ENUM_SYNC(CXInClassInitStyle_ICIS_CopyInit, clang::ICIS_CopyInit);
ENUM_SYNC(CXInClassInitStyle_ICIS_ListInit, clang::ICIS_ListInit);

// clang/Basic/Specifiers.h: enum StorageDuration
ENUM_SYNC(CXStorageDuration_SD_FullExpression, clang::SD_FullExpression);
ENUM_SYNC(CXStorageDuration_SD_Automatic, clang::SD_Automatic);
ENUM_SYNC(CXStorageDuration_SD_Thread, clang::SD_Thread);
ENUM_SYNC(CXStorageDuration_SD_Static, clang::SD_Static);
ENUM_SYNC(CXStorageDuration_SD_Dynamic, clang::SD_Dynamic);

// clang/AST/OperationKinds.def: enum CastKind
ENUM_SYNC(CXCastKind_CK_Dependent, clang::CK_Dependent);
ENUM_SYNC(CXCastKind_CK_BitCast, clang::CK_BitCast);
ENUM_SYNC(CXCastKind_CK_LValueBitCast, clang::CK_LValueBitCast);
ENUM_SYNC(CXCastKind_CK_LValueToRValueBitCast, clang::CK_LValueToRValueBitCast);
ENUM_SYNC(CXCastKind_CK_LValueToRValue, clang::CK_LValueToRValue);
ENUM_SYNC(CXCastKind_CK_NoOp, clang::CK_NoOp);
ENUM_SYNC(CXCastKind_CK_BaseToDerived, clang::CK_BaseToDerived);
ENUM_SYNC(CXCastKind_CK_DerivedToBase, clang::CK_DerivedToBase);
ENUM_SYNC(CXCastKind_CK_UncheckedDerivedToBase, clang::CK_UncheckedDerivedToBase);
ENUM_SYNC(CXCastKind_CK_Dynamic, clang::CK_Dynamic);
ENUM_SYNC(CXCastKind_CK_ToUnion, clang::CK_ToUnion);
ENUM_SYNC(CXCastKind_CK_ArrayToPointerDecay, clang::CK_ArrayToPointerDecay);
ENUM_SYNC(CXCastKind_CK_FunctionToPointerDecay, clang::CK_FunctionToPointerDecay);
ENUM_SYNC(CXCastKind_CK_NullToPointer, clang::CK_NullToPointer);
ENUM_SYNC(CXCastKind_CK_NullToMemberPointer, clang::CK_NullToMemberPointer);
ENUM_SYNC(CXCastKind_CK_BaseToDerivedMemberPointer, clang::CK_BaseToDerivedMemberPointer);
ENUM_SYNC(CXCastKind_CK_DerivedToBaseMemberPointer, clang::CK_DerivedToBaseMemberPointer);
ENUM_SYNC(CXCastKind_CK_MemberPointerToBoolean, clang::CK_MemberPointerToBoolean);
ENUM_SYNC(CXCastKind_CK_ReinterpretMemberPointer, clang::CK_ReinterpretMemberPointer);
ENUM_SYNC(CXCastKind_CK_UserDefinedConversion, clang::CK_UserDefinedConversion);
ENUM_SYNC(CXCastKind_CK_ConstructorConversion, clang::CK_ConstructorConversion);
ENUM_SYNC(CXCastKind_CK_IntegralToPointer, clang::CK_IntegralToPointer);
ENUM_SYNC(CXCastKind_CK_PointerToIntegral, clang::CK_PointerToIntegral);
ENUM_SYNC(CXCastKind_CK_PointerToBoolean, clang::CK_PointerToBoolean);
ENUM_SYNC(CXCastKind_CK_ToVoid, clang::CK_ToVoid);
ENUM_SYNC(CXCastKind_CK_MatrixCast, clang::CK_MatrixCast);
ENUM_SYNC(CXCastKind_CK_VectorSplat, clang::CK_VectorSplat);
ENUM_SYNC(CXCastKind_CK_IntegralCast, clang::CK_IntegralCast);
ENUM_SYNC(CXCastKind_CK_IntegralToBoolean, clang::CK_IntegralToBoolean);
ENUM_SYNC(CXCastKind_CK_IntegralToFloating, clang::CK_IntegralToFloating);
ENUM_SYNC(CXCastKind_CK_FloatingToFixedPoint, clang::CK_FloatingToFixedPoint);
ENUM_SYNC(CXCastKind_CK_FixedPointToFloating, clang::CK_FixedPointToFloating);
ENUM_SYNC(CXCastKind_CK_FixedPointCast, clang::CK_FixedPointCast);
ENUM_SYNC(CXCastKind_CK_FixedPointToIntegral, clang::CK_FixedPointToIntegral);
ENUM_SYNC(CXCastKind_CK_IntegralToFixedPoint, clang::CK_IntegralToFixedPoint);
ENUM_SYNC(CXCastKind_CK_FixedPointToBoolean, clang::CK_FixedPointToBoolean);
ENUM_SYNC(CXCastKind_CK_FloatingToIntegral, clang::CK_FloatingToIntegral);
ENUM_SYNC(CXCastKind_CK_FloatingToBoolean, clang::CK_FloatingToBoolean);
ENUM_SYNC(CXCastKind_CK_BooleanToSignedIntegral, clang::CK_BooleanToSignedIntegral);
ENUM_SYNC(CXCastKind_CK_FloatingCast, clang::CK_FloatingCast);
ENUM_SYNC(CXCastKind_CK_CPointerToObjCPointerCast, clang::CK_CPointerToObjCPointerCast);
ENUM_SYNC(CXCastKind_CK_BlockPointerToObjCPointerCast,
          clang::CK_BlockPointerToObjCPointerCast);
ENUM_SYNC(CXCastKind_CK_AnyPointerToBlockPointerCast,
          clang::CK_AnyPointerToBlockPointerCast);
ENUM_SYNC(CXCastKind_CK_ObjCObjectLValueCast, clang::CK_ObjCObjectLValueCast);
ENUM_SYNC(CXCastKind_CK_FloatingRealToComplex, clang::CK_FloatingRealToComplex);
ENUM_SYNC(CXCastKind_CK_FloatingComplexToReal, clang::CK_FloatingComplexToReal);
ENUM_SYNC(CXCastKind_CK_FloatingComplexToBoolean, clang::CK_FloatingComplexToBoolean);
ENUM_SYNC(CXCastKind_CK_FloatingComplexCast, clang::CK_FloatingComplexCast);
ENUM_SYNC(CXCastKind_CK_FloatingComplexToIntegralComplex,
          clang::CK_FloatingComplexToIntegralComplex);
ENUM_SYNC(CXCastKind_CK_IntegralRealToComplex, clang::CK_IntegralRealToComplex);
ENUM_SYNC(CXCastKind_CK_IntegralComplexToReal, clang::CK_IntegralComplexToReal);
ENUM_SYNC(CXCastKind_CK_IntegralComplexToBoolean, clang::CK_IntegralComplexToBoolean);
ENUM_SYNC(CXCastKind_CK_IntegralComplexCast, clang::CK_IntegralComplexCast);
ENUM_SYNC(CXCastKind_CK_IntegralComplexToFloatingComplex,
          clang::CK_IntegralComplexToFloatingComplex);
ENUM_SYNC(CXCastKind_CK_ARCProduceObject, clang::CK_ARCProduceObject);
ENUM_SYNC(CXCastKind_CK_ARCConsumeObject, clang::CK_ARCConsumeObject);
ENUM_SYNC(CXCastKind_CK_ARCReclaimReturnedObject, clang::CK_ARCReclaimReturnedObject);
ENUM_SYNC(CXCastKind_CK_ARCExtendBlockObject, clang::CK_ARCExtendBlockObject);
ENUM_SYNC(CXCastKind_CK_AtomicToNonAtomic, clang::CK_AtomicToNonAtomic);
ENUM_SYNC(CXCastKind_CK_NonAtomicToAtomic, clang::CK_NonAtomicToAtomic);
ENUM_SYNC(CXCastKind_CK_CopyAndAutoreleaseBlockObject,
          clang::CK_CopyAndAutoreleaseBlockObject);
ENUM_SYNC(CXCastKind_CK_BuiltinFnToFnPtr, clang::CK_BuiltinFnToFnPtr);
ENUM_SYNC(CXCastKind_CK_ZeroToOCLOpaqueType, clang::CK_ZeroToOCLOpaqueType);
ENUM_SYNC(CXCastKind_CK_AddressSpaceConversion, clang::CK_AddressSpaceConversion);
ENUM_SYNC(CXCastKind_CK_IntToOCLSampler, clang::CK_IntToOCLSampler);

// clang/AST/OperationKinds.def: enum BinaryOperatorKind
ENUM_SYNC(CXBinaryOperatorKind_BO_PtrMemD, clang::BO_PtrMemD);
ENUM_SYNC(CXBinaryOperatorKind_BO_PtrMemI, clang::BO_PtrMemI);
ENUM_SYNC(CXBinaryOperatorKind_BO_Mul, clang::BO_Mul);
ENUM_SYNC(CXBinaryOperatorKind_BO_Div, clang::BO_Div);
ENUM_SYNC(CXBinaryOperatorKind_BO_Rem, clang::BO_Rem);
ENUM_SYNC(CXBinaryOperatorKind_BO_Add, clang::BO_Add);
ENUM_SYNC(CXBinaryOperatorKind_BO_Sub, clang::BO_Sub);
ENUM_SYNC(CXBinaryOperatorKind_BO_Shl, clang::BO_Shl);
ENUM_SYNC(CXBinaryOperatorKind_BO_Shr, clang::BO_Shr);
ENUM_SYNC(CXBinaryOperatorKind_BO_Cmp, clang::BO_Cmp);
ENUM_SYNC(CXBinaryOperatorKind_BO_LT, clang::BO_LT);
ENUM_SYNC(CXBinaryOperatorKind_BO_GT, clang::BO_GT);
ENUM_SYNC(CXBinaryOperatorKind_BO_LE, clang::BO_LE);
ENUM_SYNC(CXBinaryOperatorKind_BO_GE, clang::BO_GE);
ENUM_SYNC(CXBinaryOperatorKind_BO_EQ, clang::BO_EQ);
ENUM_SYNC(CXBinaryOperatorKind_BO_NE, clang::BO_NE);
ENUM_SYNC(CXBinaryOperatorKind_BO_And, clang::BO_And);
ENUM_SYNC(CXBinaryOperatorKind_BO_Xor, clang::BO_Xor);
ENUM_SYNC(CXBinaryOperatorKind_BO_Or, clang::BO_Or);
ENUM_SYNC(CXBinaryOperatorKind_BO_LAnd, clang::BO_LAnd);
ENUM_SYNC(CXBinaryOperatorKind_BO_LOr, clang::BO_LOr);
ENUM_SYNC(CXBinaryOperatorKind_BO_Assign, clang::BO_Assign);
ENUM_SYNC(CXBinaryOperatorKind_BO_MulAssign, clang::BO_MulAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_DivAssign, clang::BO_DivAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_RemAssign, clang::BO_RemAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_AddAssign, clang::BO_AddAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_SubAssign, clang::BO_SubAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_ShlAssign, clang::BO_ShlAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_ShrAssign, clang::BO_ShrAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_AndAssign, clang::BO_AndAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_XorAssign, clang::BO_XorAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_OrAssign, clang::BO_OrAssign);
ENUM_SYNC(CXBinaryOperatorKind_BO_Comma, clang::BO_Comma);

// clang/AST/OperationKinds.def: enum UnaryOperatorKind
ENUM_SYNC(CXUnaryOperatorKind_UO_PostInc, clang::UO_PostInc);
ENUM_SYNC(CXUnaryOperatorKind_UO_PostDec, clang::UO_PostDec);
ENUM_SYNC(CXUnaryOperatorKind_UO_PreInc, clang::UO_PreInc);
ENUM_SYNC(CXUnaryOperatorKind_UO_PreDec, clang::UO_PreDec);
ENUM_SYNC(CXUnaryOperatorKind_UO_AddrOf, clang::UO_AddrOf);
ENUM_SYNC(CXUnaryOperatorKind_UO_Deref, clang::UO_Deref);
ENUM_SYNC(CXUnaryOperatorKind_UO_Plus, clang::UO_Plus);
ENUM_SYNC(CXUnaryOperatorKind_UO_Minus, clang::UO_Minus);
ENUM_SYNC(CXUnaryOperatorKind_UO_Not, clang::UO_Not);
ENUM_SYNC(CXUnaryOperatorKind_UO_LNot, clang::UO_LNot);
ENUM_SYNC(CXUnaryOperatorKind_UO_Real, clang::UO_Real);
ENUM_SYNC(CXUnaryOperatorKind_UO_Imag, clang::UO_Imag);
ENUM_SYNC(CXUnaryOperatorKind_UO_Extension, clang::UO_Extension);
ENUM_SYNC(CXUnaryOperatorKind_UO_Coawait, clang::UO_Coawait);

// clang/AST/Expr.h: enum class CharacterLiteralKind
ENUM_SYNC(CXCharacterLiteralKind_Ascii, clang::CharacterLiteralKind::Ascii);
ENUM_SYNC(CXCharacterLiteralKind_Wide, clang::CharacterLiteralKind::Wide);
ENUM_SYNC(CXCharacterLiteralKind_UTF8, clang::CharacterLiteralKind::UTF8);
ENUM_SYNC(CXCharacterLiteralKind_UTF16, clang::CharacterLiteralKind::UTF16);
ENUM_SYNC(CXCharacterLiteralKind_UTF32, clang::CharacterLiteralKind::UTF32);

// clang/AST/ExprCXX.h: enum class CXXConstructionKind
ENUM_SYNC(CXCXXConstructionKind_Complete, clang::CXXConstructionKind::Complete);
ENUM_SYNC(CXCXXConstructionKind_NonVirtualBase, clang::CXXConstructionKind::NonVirtualBase);
ENUM_SYNC(CXCXXConstructionKind_VirtualBase, clang::CXXConstructionKind::VirtualBase);
ENUM_SYNC(CXCXXConstructionKind_Delegating, clang::CXXConstructionKind::Delegating);

// clang/AST/ExprCXX.h: enum class CXXNewInitializationStyle
ENUM_SYNC(CXCXXNewInitializationStyle_None, clang::CXXNewInitializationStyle::None);
ENUM_SYNC(CXCXXNewInitializationStyle_Parens, clang::CXXNewInitializationStyle::Parens);
ENUM_SYNC(CXCXXNewInitializationStyle_Braces, clang::CXXNewInitializationStyle::Braces);

// clang/AST/APValue.h: enum ValueKind (nested in clang::APValue)
ENUM_SYNC(CXAPValueKind_None, clang::APValue::None);
ENUM_SYNC(CXAPValueKind_Indeterminate, clang::APValue::Indeterminate);
ENUM_SYNC(CXAPValueKind_Int, clang::APValue::Int);
ENUM_SYNC(CXAPValueKind_Float, clang::APValue::Float);
ENUM_SYNC(CXAPValueKind_FixedPoint, clang::APValue::FixedPoint);
ENUM_SYNC(CXAPValueKind_ComplexInt, clang::APValue::ComplexInt);
ENUM_SYNC(CXAPValueKind_ComplexFloat, clang::APValue::ComplexFloat);
ENUM_SYNC(CXAPValueKind_LValue, clang::APValue::LValue);
ENUM_SYNC(CXAPValueKind_Vector, clang::APValue::Vector);
ENUM_SYNC(CXAPValueKind_Array, clang::APValue::Array);
ENUM_SYNC(CXAPValueKind_Struct, clang::APValue::Struct);
ENUM_SYNC(CXAPValueKind_Union, clang::APValue::Union);
ENUM_SYNC(CXAPValueKind_MemberPointer, clang::APValue::MemberPointer);
ENUM_SYNC(CXAPValueKind_AddrLabelDiff, clang::APValue::AddrLabelDiff);

ENUM_SYNC(CXNestedNameSpecifierKind_Identifier, clang::NestedNameSpecifier::Identifier);
ENUM_SYNC(CXNestedNameSpecifierKind_Namespace, clang::NestedNameSpecifier::Namespace);
ENUM_SYNC(CXNestedNameSpecifierKind_NamespaceAlias, clang::NestedNameSpecifier::NamespaceAlias);
ENUM_SYNC(CXNestedNameSpecifierKind_TypeSpec, clang::NestedNameSpecifier::TypeSpec);
ENUM_SYNC(CXNestedNameSpecifierKind_TypeSpecWithTemplate, clang::NestedNameSpecifier::TypeSpecWithTemplate);
ENUM_SYNC(CXNestedNameSpecifierKind_Global, clang::NestedNameSpecifier::Global);
ENUM_SYNC(CXNestedNameSpecifierKind_Super, clang::NestedNameSpecifier::Super);

// clang/AST/DeclBase.h: enum class DeductionCandidate : unsigned char
ENUM_SYNC(CXDeductionCandidate_Normal, clang::DeductionCandidate::Normal);
ENUM_SYNC(CXDeductionCandidate_Copy, clang::DeductionCandidate::Copy);
ENUM_SYNC(CXDeductionCandidate_Aggregate, clang::DeductionCandidate::Aggregate);

// clang/Basic/Lambda.h: enum LambdaCaptureDefault
ENUM_SYNC(CXLambdaCaptureDefault_LCD_None, clang::LCD_None);
ENUM_SYNC(CXLambdaCaptureDefault_LCD_ByCopy, clang::LCD_ByCopy);
ENUM_SYNC(CXLambdaCaptureDefault_LCD_ByRef, clang::LCD_ByRef);

// clang/Basic/Lambda.h: enum LambdaCaptureKind
ENUM_SYNC(CXLambdaCaptureKind_LCK_This, clang::LCK_This);
ENUM_SYNC(CXLambdaCaptureKind_LCK_StarThis, clang::LCK_StarThis);
ENUM_SYNC(CXLambdaCaptureKind_LCK_ByCopy, clang::LCK_ByCopy);
ENUM_SYNC(CXLambdaCaptureKind_LCK_ByRef, clang::LCK_ByRef);
ENUM_SYNC(CXLambdaCaptureKind_LCK_VLAType, clang::LCK_VLAType);

// clang/Basic/Specifiers.h: enum CallingConv (mirrored as CXCallingConv_ due to libclang name collision)
ENUM_SYNC(CXCallingConv_CC_C, clang::CC_C);
ENUM_SYNC(CXCallingConv_CC_X86StdCall, clang::CC_X86StdCall);
ENUM_SYNC(CXCallingConv_CC_X86FastCall, clang::CC_X86FastCall);
ENUM_SYNC(CXCallingConv_CC_X86ThisCall, clang::CC_X86ThisCall);
ENUM_SYNC(CXCallingConv_CC_X86VectorCall, clang::CC_X86VectorCall);
ENUM_SYNC(CXCallingConv_CC_X86Pascal, clang::CC_X86Pascal);
ENUM_SYNC(CXCallingConv_CC_Win64, clang::CC_Win64);
ENUM_SYNC(CXCallingConv_CC_X86_64SysV, clang::CC_X86_64SysV);
ENUM_SYNC(CXCallingConv_CC_X86RegCall, clang::CC_X86RegCall);
ENUM_SYNC(CXCallingConv_CC_AAPCS, clang::CC_AAPCS);
ENUM_SYNC(CXCallingConv_CC_AAPCS_VFP, clang::CC_AAPCS_VFP);
ENUM_SYNC(CXCallingConv_CC_IntelOclBicc, clang::CC_IntelOclBicc);
ENUM_SYNC(CXCallingConv_CC_SpirFunction, clang::CC_SpirFunction);
ENUM_SYNC(CXCallingConv_CC_OpenCLKernel, clang::CC_OpenCLKernel);
ENUM_SYNC(CXCallingConv_CC_Swift, clang::CC_Swift);
ENUM_SYNC(CXCallingConv_CC_SwiftAsync, clang::CC_SwiftAsync);
ENUM_SYNC(CXCallingConv_CC_PreserveMost, clang::CC_PreserveMost);
ENUM_SYNC(CXCallingConv_CC_PreserveAll, clang::CC_PreserveAll);
ENUM_SYNC(CXCallingConv_CC_AArch64VectorCall, clang::CC_AArch64VectorCall);
ENUM_SYNC(CXCallingConv_CC_AArch64SVEPCS, clang::CC_AArch64SVEPCS);
ENUM_SYNC(CXCallingConv_CC_AMDGPUKernelCall, clang::CC_AMDGPUKernelCall);
ENUM_SYNC(CXCallingConv_CC_M68kRTD, clang::CC_M68kRTD);

// clang/Basic/ExceptionSpecificationType.h: enum ExceptionSpecificationType (backfill: this mirror previously had NO sync table)
ENUM_SYNC(CXExceptionSpecificationType_EST_None, clang::EST_None);
ENUM_SYNC(CXExceptionSpecificationType_EST_DynamicNone, clang::EST_DynamicNone);
ENUM_SYNC(CXExceptionSpecificationType_EST_Dynamic, clang::EST_Dynamic);
ENUM_SYNC(CXExceptionSpecificationType_EST_MSAny, clang::EST_MSAny);
ENUM_SYNC(CXExceptionSpecificationType_EST_NoThrow, clang::EST_NoThrow);
ENUM_SYNC(CXExceptionSpecificationType_EST_BasicNoexcept, clang::EST_BasicNoexcept);
ENUM_SYNC(CXExceptionSpecificationType_EST_DependentNoexcept, clang::EST_DependentNoexcept);
ENUM_SYNC(CXExceptionSpecificationType_EST_NoexceptFalse, clang::EST_NoexceptFalse);
ENUM_SYNC(CXExceptionSpecificationType_EST_NoexceptTrue, clang::EST_NoexceptTrue);
ENUM_SYNC(CXExceptionSpecificationType_EST_Unevaluated, clang::EST_Unevaluated);
ENUM_SYNC(CXExceptionSpecificationType_EST_Uninstantiated, clang::EST_Uninstantiated);
ENUM_SYNC(CXExceptionSpecificationType_EST_Unparsed, clang::EST_Unparsed);
ENUM_SYNC(CXStringLiteralKind_Ordinary, clang::StringLiteralKind::Ordinary);
ENUM_SYNC(CXStringLiteralKind_Wide, clang::StringLiteralKind::Wide);
ENUM_SYNC(CXStringLiteralKind_UTF8, clang::StringLiteralKind::UTF8);
ENUM_SYNC(CXStringLiteralKind_UTF16, clang::StringLiteralKind::UTF16);
ENUM_SYNC(CXStringLiteralKind_UTF32, clang::StringLiteralKind::UTF32);
ENUM_SYNC(CXStringLiteralKind_Unevaluated, clang::StringLiteralKind::Unevaluated);
ENUM_SYNC(CXPredefinedIdentKind_Func, clang::PredefinedIdentKind::Func);
ENUM_SYNC(CXPredefinedIdentKind_Function, clang::PredefinedIdentKind::Function);
ENUM_SYNC(CXPredefinedIdentKind_LFunction, clang::PredefinedIdentKind::LFunction);
ENUM_SYNC(CXPredefinedIdentKind_FuncDName, clang::PredefinedIdentKind::FuncDName);
ENUM_SYNC(CXPredefinedIdentKind_FuncSig, clang::PredefinedIdentKind::FuncSig);
ENUM_SYNC(CXPredefinedIdentKind_LFuncSig, clang::PredefinedIdentKind::LFuncSig);
ENUM_SYNC(CXPredefinedIdentKind_PrettyFunction, clang::PredefinedIdentKind::PrettyFunction);
ENUM_SYNC(CXPredefinedIdentKind_PrettyFunctionNoVirtual, clang::PredefinedIdentKind::PrettyFunctionNoVirtual);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_SizeOf, clang::UETT_SizeOf);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_DataSizeOf, clang::UETT_DataSizeOf);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_AlignOf, clang::UETT_AlignOf);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_PreferredAlignOf, clang::UETT_PreferredAlignOf);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_VecStep, clang::UETT_VecStep);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_OpenMPRequiredSimdAlign, clang::UETT_OpenMPRequiredSimdAlign);
ENUM_SYNC(CXUnaryExprOrTypeTrait_UETT_VectorElements, clang::UETT_VectorElements);

// clang/AST/Attrs.inc: enum VisibilityAttr::VisibilityType (class-local)
ENUM_SYNC(CXVisibilityAttr_Default, clang::VisibilityAttr::Default);
ENUM_SYNC(CXVisibilityAttr_Hidden, clang::VisibilityAttr::Hidden);
ENUM_SYNC(CXVisibilityAttr_Protected, clang::VisibilityAttr::Protected);

// clang/AST/TemplateBase.h: enum TemplateArgument::ArgKind
ENUM_SYNC(CXTemplateArgument_Null, clang::TemplateArgument::Null);
ENUM_SYNC(CXTemplateArgument_Type, clang::TemplateArgument::Type);
ENUM_SYNC(CXTemplateArgument_Declaration, clang::TemplateArgument::Declaration);
ENUM_SYNC(CXTemplateArgument_NullPtr, clang::TemplateArgument::NullPtr);
ENUM_SYNC(CXTemplateArgument_Integral, clang::TemplateArgument::Integral);
ENUM_SYNC(CXTemplateArgument_StructuralValue, clang::TemplateArgument::StructuralValue);
ENUM_SYNC(CXTemplateArgument_Template, clang::TemplateArgument::Template);
ENUM_SYNC(CXTemplateArgument_TemplateExpansion, clang::TemplateArgument::TemplateExpansion);
ENUM_SYNC(CXTemplateArgument_Expression, clang::TemplateArgument::Expression);
ENUM_SYNC(CXTemplateArgument_Pack, clang::TemplateArgument::Pack);

// clang/AST/DeclCXX.h: enum CXXRecordDecl::LambdaDependencyKind
ENUM_SYNC(CXLambdaDependencyKind_Unknown, clang::CXXRecordDecl::LDK_Unknown);
ENUM_SYNC(CXLambdaDependencyKind_AlwaysDependent, clang::CXXRecordDecl::LDK_AlwaysDependent);
ENUM_SYNC(CXLambdaDependencyKind_NeverDependent, clang::CXXRecordDecl::LDK_NeverDependent);

// clang/AST/DeclCXX.h: enum class LinkageSpecLanguageIDs
ENUM_SYNC(CXLinkageSpecDecl_lang_c, clang::LinkageSpecLanguageIDs::C);
ENUM_SYNC(CXLinkageSpecDecl_lang_cxx, clang::LinkageSpecLanguageIDs::CXX);

// clang/AST/Decl.h: enum class ImplicitParamKind
ENUM_SYNC(CXImplicitParamKind_ObjCSelf, clang::ImplicitParamKind::ObjCSelf);
ENUM_SYNC(CXImplicitParamKind_ObjCCmd, clang::ImplicitParamKind::ObjCCmd);
ENUM_SYNC(CXImplicitParamKind_CXXThis, clang::ImplicitParamKind::CXXThis);
ENUM_SYNC(CXImplicitParamKind_CXXVTT, clang::ImplicitParamKind::CXXVTT);
ENUM_SYNC(CXImplicitParamKind_CapturedContext, clang::ImplicitParamKind::CapturedContext);
ENUM_SYNC(CXImplicitParamKind_ThreadPrivateVar, clang::ImplicitParamKind::ThreadPrivateVar);
ENUM_SYNC(CXImplicitParamKind_Other, clang::ImplicitParamKind::Other);

// clang/AST/Decl.h: enum class MultiVersionKind
ENUM_SYNC(CXMultiVersionKind_None, clang::MultiVersionKind::None);
ENUM_SYNC(CXMultiVersionKind_Target, clang::MultiVersionKind::Target);
ENUM_SYNC(CXMultiVersionKind_CPUSpecific, clang::MultiVersionKind::CPUSpecific);
ENUM_SYNC(CXMultiVersionKind_CPUDispatch, clang::MultiVersionKind::CPUDispatch);
ENUM_SYNC(CXMultiVersionKind_TargetClones, clang::MultiVersionKind::TargetClones);
ENUM_SYNC(CXMultiVersionKind_TargetVersion, clang::MultiVersionKind::TargetVersion);

// clang/AST/Decl.h: enum FunctionDecl::TemplatedKind
ENUM_SYNC(CXFunctionDecl_TK_NonTemplate, clang::FunctionDecl::TK_NonTemplate);
ENUM_SYNC(CXFunctionDecl_TK_FunctionTemplate, clang::FunctionDecl::TK_FunctionTemplate);
ENUM_SYNC(CXFunctionDecl_TK_MemberSpecialization,
          clang::FunctionDecl::TK_MemberSpecialization);
ENUM_SYNC(CXFunctionDecl_TK_FunctionTemplateSpecialization,
          clang::FunctionDecl::TK_FunctionTemplateSpecialization);
ENUM_SYNC(CXFunctionDecl_TK_DependentFunctionTemplateSpecialization,
          clang::FunctionDecl::TK_DependentFunctionTemplateSpecialization);
ENUM_SYNC(CXFunctionDecl_TK_DependentNonTemplate,
          clang::FunctionDecl::TK_DependentNonTemplate);

// clang/AST/Decl.h: enum class RecordArgPassingKind
ENUM_SYNC(CXRecordDecl_APK_CanPassInRegs, clang::RecordArgPassingKind::CanPassInRegs);
ENUM_SYNC(CXRecordDecl_APK_CannotPassInRegs, clang::RecordArgPassingKind::CannotPassInRegs);
ENUM_SYNC(CXRecordDecl_APK_CanNeverPassInRegs,
          clang::RecordArgPassingKind::CanNeverPassInRegs);

// clang/AST/Type.h: enum class ArraySizeModifier
ENUM_SYNC(CXArraySizeModifier_Normal, clang::ArraySizeModifier::Normal);
ENUM_SYNC(CXArraySizeModifier_Static, clang::ArraySizeModifier::Static);
ENUM_SYNC(CXArraySizeModifier_Star, clang::ArraySizeModifier::Star);

// clang/AST/Type.h: enum class TagTypeKind
ENUM_SYNC(CXTagTypeKind_Struct, clang::TagTypeKind::Struct);
ENUM_SYNC(CXTagTypeKind_Interface, clang::TagTypeKind::Interface);
ENUM_SYNC(CXTagTypeKind_Union, clang::TagTypeKind::Union);
ENUM_SYNC(CXTagTypeKind_Class, clang::TagTypeKind::Class);
ENUM_SYNC(CXTagTypeKind_Enum, clang::TagTypeKind::Enum);

// clang/AST/Type.h: enum class ElaboratedTypeKeyword
ENUM_SYNC(CXElaboratedTypeKeyword_Struct, clang::ElaboratedTypeKeyword::Struct);
ENUM_SYNC(CXElaboratedTypeKeyword_Interface, clang::ElaboratedTypeKeyword::Interface);
ENUM_SYNC(CXElaboratedTypeKeyword_Union, clang::ElaboratedTypeKeyword::Union);
ENUM_SYNC(CXElaboratedTypeKeyword_Class, clang::ElaboratedTypeKeyword::Class);
ENUM_SYNC(CXElaboratedTypeKeyword_Enum, clang::ElaboratedTypeKeyword::Enum);
ENUM_SYNC(CXElaboratedTypeKeyword_Typename, clang::ElaboratedTypeKeyword::Typename);
ENUM_SYNC(CXElaboratedTypeKeyword_None, clang::ElaboratedTypeKeyword::None);

// clang/Basic/AddressSpaces.h: enum class LangAS : unsigned
ENUM_SYNC(CXLangAS_Default, clang::LangAS::Default);
ENUM_SYNC(CXLangAS_opencl_global, clang::LangAS::opencl_global);
ENUM_SYNC(CXLangAS_opencl_local, clang::LangAS::opencl_local);
ENUM_SYNC(CXLangAS_opencl_constant, clang::LangAS::opencl_constant);
ENUM_SYNC(CXLangAS_opencl_private, clang::LangAS::opencl_private);
ENUM_SYNC(CXLangAS_opencl_generic, clang::LangAS::opencl_generic);
ENUM_SYNC(CXLangAS_opencl_global_device, clang::LangAS::opencl_global_device);
ENUM_SYNC(CXLangAS_opencl_global_host, clang::LangAS::opencl_global_host);
ENUM_SYNC(CXLangAS_cuda_device, clang::LangAS::cuda_device);
ENUM_SYNC(CXLangAS_cuda_constant, clang::LangAS::cuda_constant);
ENUM_SYNC(CXLangAS_cuda_shared, clang::LangAS::cuda_shared);
ENUM_SYNC(CXLangAS_sycl_global, clang::LangAS::sycl_global);
ENUM_SYNC(CXLangAS_sycl_global_device, clang::LangAS::sycl_global_device);
ENUM_SYNC(CXLangAS_sycl_global_host, clang::LangAS::sycl_global_host);
ENUM_SYNC(CXLangAS_sycl_local, clang::LangAS::sycl_local);
ENUM_SYNC(CXLangAS_sycl_private, clang::LangAS::sycl_private);
ENUM_SYNC(CXLangAS_ptr32_sptr, clang::LangAS::ptr32_sptr);
ENUM_SYNC(CXLangAS_ptr32_uptr, clang::LangAS::ptr32_uptr);
ENUM_SYNC(CXLangAS_ptr64, clang::LangAS::ptr64);
ENUM_SYNC(CXLangAS_hlsl_groupshared, clang::LangAS::hlsl_groupshared);
ENUM_SYNC(CXLangAS_wasm_funcref, clang::LangAS::wasm_funcref);
ENUM_SYNC(CXLangAS_FirstTargetAddressSpace, clang::LangAS::FirstTargetAddressSpace);
static_assert(sizeof(CXLangAS) == sizeof(clang::LangAS), "CXLangAS size");
// clang/Basic/TargetCXXABI.h: enum TargetCXXABI::Kind (enumerators from TargetCXXABI.def)
ENUM_SYNC(CXTargetCXXABI_GenericItanium, clang::TargetCXXABI::GenericItanium);
ENUM_SYNC(CXTargetCXXABI_GenericARM, clang::TargetCXXABI::GenericARM);
ENUM_SYNC(CXTargetCXXABI_iOS, clang::TargetCXXABI::iOS);
ENUM_SYNC(CXTargetCXXABI_AppleARM64, clang::TargetCXXABI::AppleARM64);
ENUM_SYNC(CXTargetCXXABI_WatchOS, clang::TargetCXXABI::WatchOS);
ENUM_SYNC(CXTargetCXXABI_GenericAArch64, clang::TargetCXXABI::GenericAArch64);
ENUM_SYNC(CXTargetCXXABI_GenericMIPS, clang::TargetCXXABI::GenericMIPS);
ENUM_SYNC(CXTargetCXXABI_WebAssembly, clang::TargetCXXABI::WebAssembly);
ENUM_SYNC(CXTargetCXXABI_Fuchsia, clang::TargetCXXABI::Fuchsia);
ENUM_SYNC(CXTargetCXXABI_XL, clang::TargetCXXABI::XL);
ENUM_SYNC(CXTargetCXXABI_Microsoft, clang::TargetCXXABI::Microsoft);
// clang/Basic/TargetInfo.h: enum TransferrableTargetInfo::IntType
ENUM_SYNC(CXTargetInfo_NoInt, clang::TargetInfo::NoInt);
ENUM_SYNC(CXTargetInfo_SignedChar, clang::TargetInfo::SignedChar);
ENUM_SYNC(CXTargetInfo_UnsignedChar, clang::TargetInfo::UnsignedChar);
ENUM_SYNC(CXTargetInfo_SignedShort, clang::TargetInfo::SignedShort);
ENUM_SYNC(CXTargetInfo_UnsignedShort, clang::TargetInfo::UnsignedShort);
ENUM_SYNC(CXTargetInfo_SignedInt, clang::TargetInfo::SignedInt);
ENUM_SYNC(CXTargetInfo_UnsignedInt, clang::TargetInfo::UnsignedInt);
ENUM_SYNC(CXTargetInfo_SignedLong, clang::TargetInfo::SignedLong);
ENUM_SYNC(CXTargetInfo_UnsignedLong, clang::TargetInfo::UnsignedLong);
ENUM_SYNC(CXTargetInfo_SignedLongLong, clang::TargetInfo::SignedLongLong);
ENUM_SYNC(CXTargetInfo_UnsignedLongLong, clang::TargetInfo::UnsignedLongLong);
// clang/Basic/TargetInfo.h: enum TargetInfo::BuiltinVaListKind
ENUM_SYNC(CXTargetInfo_CharPtrBuiltinVaList, clang::TargetInfo::CharPtrBuiltinVaList);
ENUM_SYNC(CXTargetInfo_VoidPtrBuiltinVaList, clang::TargetInfo::VoidPtrBuiltinVaList);
ENUM_SYNC(CXTargetInfo_AArch64ABIBuiltinVaList, clang::TargetInfo::AArch64ABIBuiltinVaList);
ENUM_SYNC(CXTargetInfo_PNaClABIBuiltinVaList, clang::TargetInfo::PNaClABIBuiltinVaList);
ENUM_SYNC(CXTargetInfo_PowerABIBuiltinVaList, clang::TargetInfo::PowerABIBuiltinVaList);
ENUM_SYNC(CXTargetInfo_X86_64ABIBuiltinVaList, clang::TargetInfo::X86_64ABIBuiltinVaList);
ENUM_SYNC(CXTargetInfo_AAPCSABIBuiltinVaList, clang::TargetInfo::AAPCSABIBuiltinVaList);
ENUM_SYNC(CXTargetInfo_SystemZBuiltinVaList, clang::TargetInfo::SystemZBuiltinVaList);
ENUM_SYNC(CXTargetInfo_HexagonBuiltinVaList, clang::TargetInfo::HexagonBuiltinVaList);

// clang/Basic/SourceManager.h: enum SrcMgr::CharacteristicKind
ENUM_SYNC(CXCharacteristicKind_C_User, clang::SrcMgr::C_User);
ENUM_SYNC(CXCharacteristicKind_C_System, clang::SrcMgr::C_System);
ENUM_SYNC(CXCharacteristicKind_C_ExternCSystem, clang::SrcMgr::C_ExternCSystem);
ENUM_SYNC(CXCharacteristicKind_C_User_ModuleMap, clang::SrcMgr::C_User_ModuleMap);
ENUM_SYNC(CXCharacteristicKind_C_System_ModuleMap, clang::SrcMgr::C_System_ModuleMap);

// clang/Lex/Token.h: enum Token::TokenFlags
ENUM_SYNC(CXTokenFlags_StartOfLine, clang::Token::StartOfLine);
ENUM_SYNC(CXTokenFlags_LeadingSpace, clang::Token::LeadingSpace);
ENUM_SYNC(CXTokenFlags_DisableExpand, clang::Token::DisableExpand);
ENUM_SYNC(CXTokenFlags_NeedsCleaning, clang::Token::NeedsCleaning);
ENUM_SYNC(CXTokenFlags_LeadingEmptyMacro, clang::Token::LeadingEmptyMacro);
ENUM_SYNC(CXTokenFlags_HasUDSuffix, clang::Token::HasUDSuffix);
ENUM_SYNC(CXTokenFlags_HasUCN, clang::Token::HasUCN);
ENUM_SYNC(CXTokenFlags_IgnoredComma, clang::Token::IgnoredComma);
ENUM_SYNC(CXTokenFlags_StringifiedInMacro, clang::Token::StringifiedInMacro);
ENUM_SYNC(CXTokenFlags_CommaAfterElided, clang::Token::CommaAfterElided);
ENUM_SYNC(CXTokenFlags_IsEditorPlaceholder, clang::Token::IsEditorPlaceholder);
ENUM_SYNC(CXTokenFlags_IsReinjected, clang::Token::IsReinjected);
static_assert(sizeof(CXTokenFlags) == sizeof(clang::Token::TokenFlags), "CXTokenFlags size");

// clang/Basic/IdentifierTable.h: enum class ReservedIdentifierStatus
ENUM_SYNC(CXReservedIdentifierStatus_NotReserved, clang::ReservedIdentifierStatus::NotReserved);
ENUM_SYNC(CXReservedIdentifierStatus_StartsWithUnderscoreAtGlobalScope, clang::ReservedIdentifierStatus::StartsWithUnderscoreAtGlobalScope);
ENUM_SYNC(CXReservedIdentifierStatus_StartsWithUnderscoreAndIsExternC, clang::ReservedIdentifierStatus::StartsWithUnderscoreAndIsExternC);
ENUM_SYNC(CXReservedIdentifierStatus_StartsWithDoubleUnderscore, clang::ReservedIdentifierStatus::StartsWithDoubleUnderscore);
ENUM_SYNC(CXReservedIdentifierStatus_StartsWithUnderscoreFollowedByCapitalLetter, clang::ReservedIdentifierStatus::StartsWithUnderscoreFollowedByCapitalLetter);
ENUM_SYNC(CXReservedIdentifierStatus_ContainsDoubleUnderscore, clang::ReservedIdentifierStatus::ContainsDoubleUnderscore);
// clang/Basic/IdentifierTable.h: enum class ReservedLiteralSuffixIdStatus
ENUM_SYNC(CXReservedLiteralSuffixIdStatus_NotReserved, clang::ReservedLiteralSuffixIdStatus::NotReserved);
ENUM_SYNC(CXReservedLiteralSuffixIdStatus_NotStartsWithUnderscore, clang::ReservedLiteralSuffixIdStatus::NotStartsWithUnderscore);
ENUM_SYNC(CXReservedLiteralSuffixIdStatus_ContainsDoubleUnderscore, clang::ReservedLiteralSuffixIdStatus::ContainsDoubleUnderscore);
// clang/Basic/TokenKinds.h: enum PPKeywordKind (X-macro-generated from the PPKEYWORD lines in clang/Basic/TokenKinds.def)
ENUM_SYNC(CXPPKeywordKind_pp_not_keyword, clang::tok::pp_not_keyword);
ENUM_SYNC(CXPPKeywordKind_pp_if, clang::tok::pp_if);
ENUM_SYNC(CXPPKeywordKind_pp_ifdef, clang::tok::pp_ifdef);
ENUM_SYNC(CXPPKeywordKind_pp_ifndef, clang::tok::pp_ifndef);
ENUM_SYNC(CXPPKeywordKind_pp_elif, clang::tok::pp_elif);
ENUM_SYNC(CXPPKeywordKind_pp_elifdef, clang::tok::pp_elifdef);
ENUM_SYNC(CXPPKeywordKind_pp_elifndef, clang::tok::pp_elifndef);
ENUM_SYNC(CXPPKeywordKind_pp_else, clang::tok::pp_else);
ENUM_SYNC(CXPPKeywordKind_pp_endif, clang::tok::pp_endif);
ENUM_SYNC(CXPPKeywordKind_pp_defined, clang::tok::pp_defined);
ENUM_SYNC(CXPPKeywordKind_pp_include, clang::tok::pp_include);
ENUM_SYNC(CXPPKeywordKind_pp___include_macros, clang::tok::pp___include_macros);
ENUM_SYNC(CXPPKeywordKind_pp_define, clang::tok::pp_define);
ENUM_SYNC(CXPPKeywordKind_pp_undef, clang::tok::pp_undef);
ENUM_SYNC(CXPPKeywordKind_pp_line, clang::tok::pp_line);
ENUM_SYNC(CXPPKeywordKind_pp_error, clang::tok::pp_error);
ENUM_SYNC(CXPPKeywordKind_pp_pragma, clang::tok::pp_pragma);
ENUM_SYNC(CXPPKeywordKind_pp_import, clang::tok::pp_import);
ENUM_SYNC(CXPPKeywordKind_pp_include_next, clang::tok::pp_include_next);
ENUM_SYNC(CXPPKeywordKind_pp_warning, clang::tok::pp_warning);
ENUM_SYNC(CXPPKeywordKind_pp_ident, clang::tok::pp_ident);
ENUM_SYNC(CXPPKeywordKind_pp_sccs, clang::tok::pp_sccs);
ENUM_SYNC(CXPPKeywordKind_pp_assert, clang::tok::pp_assert);
ENUM_SYNC(CXPPKeywordKind_pp_unassert, clang::tok::pp_unassert);
ENUM_SYNC(CXPPKeywordKind_pp___public_macro, clang::tok::pp___public_macro);
ENUM_SYNC(CXPPKeywordKind_pp___private_macro, clang::tok::pp___private_macro);
// clang/Basic/Module.h: enum Module::ModuleKind
ENUM_SYNC(CXModuleKind_ModuleMapModule, clang::Module::ModuleMapModule);
ENUM_SYNC(CXModuleKind_ModuleHeaderUnit, clang::Module::ModuleHeaderUnit);
ENUM_SYNC(CXModuleKind_ModuleInterfaceUnit, clang::Module::ModuleInterfaceUnit);
ENUM_SYNC(CXModuleKind_ModuleImplementationUnit, clang::Module::ModuleImplementationUnit);
ENUM_SYNC(CXModuleKind_ModulePartitionInterface, clang::Module::ModulePartitionInterface);
ENUM_SYNC(CXModuleKind_ModulePartitionImplementation, clang::Module::ModulePartitionImplementation);
ENUM_SYNC(CXModuleKind_ExplicitGlobalModuleFragment, clang::Module::ExplicitGlobalModuleFragment);
ENUM_SYNC(CXModuleKind_PrivateModuleFragment, clang::Module::PrivateModuleFragment);
ENUM_SYNC(CXModuleKind_ImplicitGlobalModuleFragment, clang::Module::ImplicitGlobalModuleFragment);

// clang/Basic/Diagnostic.h: enum DiagnosticsEngine::Level
ENUM_SYNC(CXDiagnosticsEngine_Ignored, clang::DiagnosticsEngine::Ignored);
ENUM_SYNC(CXDiagnosticsEngine_Note, clang::DiagnosticsEngine::Note);
ENUM_SYNC(CXDiagnosticsEngine_Remark, clang::DiagnosticsEngine::Remark);
ENUM_SYNC(CXDiagnosticsEngine_Warning, clang::DiagnosticsEngine::Warning);
ENUM_SYNC(CXDiagnosticsEngine_Error, clang::DiagnosticsEngine::Error);
ENUM_SYNC(CXDiagnosticsEngine_Fatal, clang::DiagnosticsEngine::Fatal);

// clang/Basic/DiagnosticIDs.h: enum class diag::Severity
ENUM_SYNC(CXDiag_Severity_Ignored, clang::diag::Severity::Ignored);
ENUM_SYNC(CXDiag_Severity_Remark, clang::diag::Severity::Remark);
ENUM_SYNC(CXDiag_Severity_Warning, clang::diag::Severity::Warning);
ENUM_SYNC(CXDiag_Severity_Error, clang::diag::Severity::Error);
ENUM_SYNC(CXDiag_Severity_Fatal, clang::diag::Severity::Fatal);

// clang/Basic/DiagnosticIDs.h: enum class diag::Flavor
ENUM_SYNC(CXDiag_Flavor_WarningOrError, clang::diag::Flavor::WarningOrError);
ENUM_SYNC(CXDiag_Flavor_Remark, clang::diag::Flavor::Remark);

// clang/Basic/DiagnosticOptions.h: enum OverloadsShown : unsigned
ENUM_SYNC(CXOverloadsShown_Ovl_All, clang::Ovl_All);
ENUM_SYNC(CXOverloadsShown_Ovl_Best, clang::Ovl_Best);
static_assert(sizeof(CXOverloadsShown) == sizeof(clang::OverloadsShown), "CXOverloadsShown size");

// clang/Analysis/CFG.h: enum Kind (nested in clang::CFGElement)
ENUM_SYNC(CXCFGElementKind_Initializer, clang::CFGElement::Initializer);
ENUM_SYNC(CXCFGElementKind_ScopeBegin, clang::CFGElement::ScopeBegin);
ENUM_SYNC(CXCFGElementKind_ScopeEnd, clang::CFGElement::ScopeEnd);
ENUM_SYNC(CXCFGElementKind_NewAllocator, clang::CFGElement::NewAllocator);
ENUM_SYNC(CXCFGElementKind_LifetimeEnds, clang::CFGElement::LifetimeEnds);
ENUM_SYNC(CXCFGElementKind_LoopExit, clang::CFGElement::LoopExit);
ENUM_SYNC(CXCFGElementKind_Statement, clang::CFGElement::Statement);
ENUM_SYNC(CXCFGElementKind_Constructor, clang::CFGElement::Constructor);
ENUM_SYNC(CXCFGElementKind_CXXRecordTypedCall, clang::CFGElement::CXXRecordTypedCall);
ENUM_SYNC(CXCFGElementKind_AutomaticObjectDtor, clang::CFGElement::AutomaticObjectDtor);
ENUM_SYNC(CXCFGElementKind_DeleteDtor, clang::CFGElement::DeleteDtor);
ENUM_SYNC(CXCFGElementKind_BaseDtor, clang::CFGElement::BaseDtor);
ENUM_SYNC(CXCFGElementKind_MemberDtor, clang::CFGElement::MemberDtor);
ENUM_SYNC(CXCFGElementKind_TemporaryDtor, clang::CFGElement::TemporaryDtor);
ENUM_SYNC(CXCFGElementKind_CleanupFunction, clang::CFGElement::CleanupFunction);
// clang/Analysis/CFG.h: enum Kind (nested in clang::CFGTerminator)
ENUM_SYNC(CXCFGTerminatorKind_StmtBranch, clang::CFGTerminator::StmtBranch);
ENUM_SYNC(CXCFGTerminatorKind_TemporaryDtorsBranch, clang::CFGTerminator::TemporaryDtorsBranch);
ENUM_SYNC(CXCFGTerminatorKind_VirtualBaseBranch, clang::CFGTerminator::VirtualBaseBranch);


// clang/Basic/Specifiers.h: enum ExprObjectKind
ENUM_SYNC(CXExprObjectKind_OK_Ordinary, clang::OK_Ordinary);
ENUM_SYNC(CXExprObjectKind_OK_BitField, clang::OK_BitField);
ENUM_SYNC(CXExprObjectKind_OK_VectorComponent, clang::OK_VectorComponent);
ENUM_SYNC(CXExprObjectKind_OK_ObjCProperty, clang::OK_ObjCProperty);
ENUM_SYNC(CXExprObjectKind_OK_ObjCSubscript, clang::OK_ObjCSubscript);
ENUM_SYNC(CXExprObjectKind_OK_MatrixComponent, clang::OK_MatrixComponent);

// clang/Basic/Specifiers.h: enum NonOdrUseReason
ENUM_SYNC(CXNonOdrUseReason_NOUR_None, clang::NOUR_None);
ENUM_SYNC(CXNonOdrUseReason_NOUR_Unevaluated, clang::NOUR_Unevaluated);
ENUM_SYNC(CXNonOdrUseReason_NOUR_Constant, clang::NOUR_Constant);
ENUM_SYNC(CXNonOdrUseReason_NOUR_Discarded, clang::NOUR_Discarded);

// clang/AST/Expr.h: enum class ConstantExprKind (nested in clang::Expr)
ENUM_SYNC(CXExpr_ConstantExprKind_Normal, clang::Expr::ConstantExprKind::Normal);
ENUM_SYNC(CXExpr_ConstantExprKind_NonClassTemplateArgument, clang::Expr::ConstantExprKind::NonClassTemplateArgument);
ENUM_SYNC(CXExpr_ConstantExprKind_ClassTemplateArgument, clang::Expr::ConstantExprKind::ClassTemplateArgument);
ENUM_SYNC(CXExpr_ConstantExprKind_ImmediateInvocation, clang::Expr::ConstantExprKind::ImmediateInvocation);

// clang/AST/Expr.h: enum NullPointerConstantKind (nested in clang::Expr)
ENUM_SYNC(CXExpr_NPCK_NotNull, clang::Expr::NPCK_NotNull);
ENUM_SYNC(CXExpr_NPCK_ZeroExpression, clang::Expr::NPCK_ZeroExpression);
ENUM_SYNC(CXExpr_NPCK_ZeroLiteral, clang::Expr::NPCK_ZeroLiteral);
ENUM_SYNC(CXExpr_NPCK_CXX11_nullptr, clang::Expr::NPCK_CXX11_nullptr);
ENUM_SYNC(CXExpr_NPCK_GNUNull, clang::Expr::NPCK_GNUNull);

// clang/AST/Expr.h: enum NullPointerConstantValueDependence (nested in clang::Expr)
ENUM_SYNC(CXExpr_NPC_NeverValueDependent, clang::Expr::NPC_NeverValueDependent);
ENUM_SYNC(CXExpr_NPC_ValueDependentIsNull, clang::Expr::NPC_ValueDependentIsNull);
ENUM_SYNC(CXExpr_NPC_ValueDependentIsNotNull, clang::Expr::NPC_ValueDependentIsNotNull);

ENUM_SYNC(CXAvailabilityResult_AR_Available, clang::AR_Available);
ENUM_SYNC(CXAvailabilityResult_AR_NotYetIntroduced, clang::AR_NotYetIntroduced);
ENUM_SYNC(CXAvailabilityResult_AR_Deprecated, clang::AR_Deprecated);
ENUM_SYNC(CXAvailabilityResult_AR_Unavailable, clang::AR_Unavailable);
ENUM_SYNC(CXDecl_IDNS_Label, clang::Decl::IDNS_Label);
ENUM_SYNC(CXDecl_IDNS_Tag, clang::Decl::IDNS_Tag);
ENUM_SYNC(CXDecl_IDNS_Type, clang::Decl::IDNS_Type);
ENUM_SYNC(CXDecl_IDNS_Member, clang::Decl::IDNS_Member);
ENUM_SYNC(CXDecl_IDNS_Namespace, clang::Decl::IDNS_Namespace);
ENUM_SYNC(CXDecl_IDNS_Ordinary, clang::Decl::IDNS_Ordinary);
ENUM_SYNC(CXDecl_IDNS_ObjCProtocol, clang::Decl::IDNS_ObjCProtocol);
ENUM_SYNC(CXDecl_IDNS_OrdinaryFriend, clang::Decl::IDNS_OrdinaryFriend);
ENUM_SYNC(CXDecl_IDNS_TagFriend, clang::Decl::IDNS_TagFriend);
ENUM_SYNC(CXDecl_IDNS_Using, clang::Decl::IDNS_Using);
ENUM_SYNC(CXDecl_IDNS_NonMemberOperator, clang::Decl::IDNS_NonMemberOperator);
ENUM_SYNC(CXDecl_IDNS_LocalExtern, clang::Decl::IDNS_LocalExtern);
ENUM_SYNC(CXDecl_IDNS_OMPReduction, clang::Decl::IDNS_OMPReduction);
ENUM_SYNC(CXDecl_IDNS_OMPMapper, clang::Decl::IDNS_OMPMapper);
ENUM_SYNC(CXDecl_Unowned, clang::Decl::ModuleOwnershipKind::Unowned);
ENUM_SYNC(CXDecl_Visible, clang::Decl::ModuleOwnershipKind::Visible);
ENUM_SYNC(CXDecl_VisibleWhenImported, clang::Decl::ModuleOwnershipKind::VisibleWhenImported);
ENUM_SYNC(CXDecl_ReachableWhenImported, clang::Decl::ModuleOwnershipKind::ReachableWhenImported);
ENUM_SYNC(CXDecl_ModulePrivate, clang::Decl::ModuleOwnershipKind::ModulePrivate);
ENUM_SYNC(CXDecl_FOK_None, clang::Decl::FOK_None);
ENUM_SYNC(CXDecl_FOK_Declared, clang::Decl::FOK_Declared);
ENUM_SYNC(CXDecl_FOK_Undeclared, clang::Decl::FOK_Undeclared);
ENUM_SYNC(CXDeclarationName_Identifier, clang::DeclarationName::Identifier);
ENUM_SYNC(CXDeclarationName_ObjCZeroArgSelector, clang::DeclarationName::ObjCZeroArgSelector);
ENUM_SYNC(CXDeclarationName_ObjCOneArgSelector, clang::DeclarationName::ObjCOneArgSelector);
ENUM_SYNC(CXDeclarationName_CXXConstructorName, clang::DeclarationName::CXXConstructorName);
ENUM_SYNC(CXDeclarationName_CXXDestructorName, clang::DeclarationName::CXXDestructorName);
ENUM_SYNC(CXDeclarationName_CXXConversionFunctionName, clang::DeclarationName::CXXConversionFunctionName);
ENUM_SYNC(CXDeclarationName_CXXOperatorName, clang::DeclarationName::CXXOperatorName);
ENUM_SYNC(CXDeclarationName_CXXDeductionGuideName, clang::DeclarationName::CXXDeductionGuideName);
ENUM_SYNC(CXDeclarationName_CXXLiteralOperatorName, clang::DeclarationName::CXXLiteralOperatorName);
ENUM_SYNC(CXDeclarationName_CXXUsingDirective, clang::DeclarationName::CXXUsingDirective);
ENUM_SYNC(CXDeclarationName_ObjCMultiArgSelector, clang::DeclarationName::ObjCMultiArgSelector);

ENUM_SYNC(CXVarDecl_CInit, clang::VarDecl::CInit);
ENUM_SYNC(CXVarDecl_CallInit, clang::VarDecl::CallInit);
ENUM_SYNC(CXVarDecl_ListInit, clang::VarDecl::ListInit);
ENUM_SYNC(CXVarDecl_ParenListInit, clang::VarDecl::ParenListInit);
ENUM_SYNC(CXVarDecl_TLS_None, clang::VarDecl::TLS_None);
ENUM_SYNC(CXVarDecl_TLS_Static, clang::VarDecl::TLS_Static);
ENUM_SYNC(CXVarDecl_TLS_Dynamic, clang::VarDecl::TLS_Dynamic);
ENUM_SYNC(CXVarDecl_DeclarationOnly, clang::VarDecl::DeclarationOnly);
ENUM_SYNC(CXVarDecl_TentativeDefinition, clang::VarDecl::TentativeDefinition);
ENUM_SYNC(CXVarDecl_Definition, clang::VarDecl::Definition);

// clang/AST/Type.h: enum QualType::DestructionKind
ENUM_SYNC(CXDestructionKind_DK_none, clang::QualType::DK_none);
ENUM_SYNC(CXDestructionKind_DK_cxx_destructor, clang::QualType::DK_cxx_destructor);
ENUM_SYNC(CXDestructionKind_DK_objc_strong_lifetime, clang::QualType::DK_objc_strong_lifetime);
ENUM_SYNC(CXDestructionKind_DK_objc_weak_lifetime, clang::QualType::DK_objc_weak_lifetime);
ENUM_SYNC(CXDestructionKind_DK_nontrivial_c_struct, clang::QualType::DK_nontrivial_c_struct);

// clang/AST/ASTContext.h: enum class AlignRequirementKind
ENUM_SYNC(CXAlignRequirementKind_None, clang::AlignRequirementKind::None);
ENUM_SYNC(CXAlignRequirementKind_RequiredByTypedef, clang::AlignRequirementKind::RequiredByTypedef);
ENUM_SYNC(CXAlignRequirementKind_RequiredByRecord, clang::AlignRequirementKind::RequiredByRecord);
ENUM_SYNC(CXAlignRequirementKind_RequiredByEnum, clang::AlignRequirementKind::RequiredByEnum);

// clang/AST/Type.h: enum Type::ScalarTypeKind
ENUM_SYNC(CXScalarTypeKind_STK_CPointer, clang::Type::STK_CPointer);
ENUM_SYNC(CXScalarTypeKind_STK_BlockPointer, clang::Type::STK_BlockPointer);
ENUM_SYNC(CXScalarTypeKind_STK_ObjCObjectPointer, clang::Type::STK_ObjCObjectPointer);
ENUM_SYNC(CXScalarTypeKind_STK_MemberPointer, clang::Type::STK_MemberPointer);
ENUM_SYNC(CXScalarTypeKind_STK_Bool, clang::Type::STK_Bool);
ENUM_SYNC(CXScalarTypeKind_STK_Integral, clang::Type::STK_Integral);
ENUM_SYNC(CXScalarTypeKind_STK_Floating, clang::Type::STK_Floating);
ENUM_SYNC(CXScalarTypeKind_STK_IntegralComplex, clang::Type::STK_IntegralComplex);
ENUM_SYNC(CXScalarTypeKind_STK_FloatingComplex, clang::Type::STK_FloatingComplex);
ENUM_SYNC(CXScalarTypeKind_STK_FixedPoint, clang::Type::STK_FixedPoint);

// clang/AST/RawCommentList.h: enum RawComment::CommentKind
ENUM_SYNC(CXRawCommentKind_RCK_Invalid, clang::RawComment::RCK_Invalid);
ENUM_SYNC(CXRawCommentKind_RCK_OrdinaryBCPL, clang::RawComment::RCK_OrdinaryBCPL);
ENUM_SYNC(CXRawCommentKind_RCK_OrdinaryC, clang::RawComment::RCK_OrdinaryC);
ENUM_SYNC(CXRawCommentKind_RCK_BCPLSlash, clang::RawComment::RCK_BCPLSlash);
ENUM_SYNC(CXRawCommentKind_RCK_BCPLExcl, clang::RawComment::RCK_BCPLExcl);
ENUM_SYNC(CXRawCommentKind_RCK_JavaDoc, clang::RawComment::RCK_JavaDoc);
ENUM_SYNC(CXRawCommentKind_RCK_Qt, clang::RawComment::RCK_Qt);
ENUM_SYNC(CXRawCommentKind_RCK_Merged, clang::RawComment::RCK_Merged);


// clang/Sema/Sema.h: enum Sema::LookupNameKind
ENUM_SYNC(CXLookupNameKind_LookupOrdinaryName, clang::Sema::LookupOrdinaryName);
ENUM_SYNC(CXLookupNameKind_LookupTagName, clang::Sema::LookupTagName);
ENUM_SYNC(CXLookupNameKind_LookupLabel, clang::Sema::LookupLabel);
ENUM_SYNC(CXLookupNameKind_LookupMemberName, clang::Sema::LookupMemberName);
ENUM_SYNC(CXLookupNameKind_LookupOperatorName, clang::Sema::LookupOperatorName);
ENUM_SYNC(CXLookupNameKind_LookupDestructorName, clang::Sema::LookupDestructorName);
ENUM_SYNC(CXLookupNameKind_LookupNestedNameSpecifierName, clang::Sema::LookupNestedNameSpecifierName);
ENUM_SYNC(CXLookupNameKind_LookupNamespaceName, clang::Sema::LookupNamespaceName);
ENUM_SYNC(CXLookupNameKind_LookupUsingDeclName, clang::Sema::LookupUsingDeclName);
ENUM_SYNC(CXLookupNameKind_LookupRedeclarationWithLinkage, clang::Sema::LookupRedeclarationWithLinkage);
ENUM_SYNC(CXLookupNameKind_LookupLocalFriendName, clang::Sema::LookupLocalFriendName);
ENUM_SYNC(CXLookupNameKind_LookupObjCProtocolName, clang::Sema::LookupObjCProtocolName);
ENUM_SYNC(CXLookupNameKind_LookupObjCImplicitSelfParam, clang::Sema::LookupObjCImplicitSelfParam);
ENUM_SYNC(CXLookupNameKind_LookupOMPReductionName, clang::Sema::LookupOMPReductionName);
ENUM_SYNC(CXLookupNameKind_LookupOMPMapperName, clang::Sema::LookupOMPMapperName);
ENUM_SYNC(CXLookupNameKind_LookupAnyName, clang::Sema::LookupAnyName);

// clang/Sema/Sema.h: enum class Sema::CompleteTypeKind (alias Default omitted)
ENUM_SYNC(CXCompleteTypeKind_Normal, clang::Sema::CompleteTypeKind::Normal);
ENUM_SYNC(CXCompleteTypeKind_AcceptSizeless, clang::Sema::CompleteTypeKind::AcceptSizeless);

// clang/Sema/Sema.h: enum Sema::RedeclarationKind
ENUM_SYNC(CXRedeclarationKind_NotForRedeclaration, clang::Sema::NotForRedeclaration);
ENUM_SYNC(CXRedeclarationKind_ForVisibleRedeclaration, clang::Sema::ForVisibleRedeclaration);
ENUM_SYNC(CXRedeclarationKind_ForExternalRedeclaration, clang::Sema::ForExternalRedeclaration);


// clang/Sema/Lookup.h: enum LookupResult::LookupResultKind
ENUM_SYNC(CXLookupResultKind_NotFound, clang::LookupResult::NotFound);
ENUM_SYNC(CXLookupResultKind_NotFoundInCurrentInstantiation, clang::LookupResult::NotFoundInCurrentInstantiation);
ENUM_SYNC(CXLookupResultKind_Found, clang::LookupResult::Found);
ENUM_SYNC(CXLookupResultKind_FoundOverloaded, clang::LookupResult::FoundOverloaded);
ENUM_SYNC(CXLookupResultKind_FoundUnresolvedValue, clang::LookupResult::FoundUnresolvedValue);
ENUM_SYNC(CXLookupResultKind_Ambiguous, clang::LookupResult::Ambiguous);

// clang/Sema/Lookup.h: enum LookupResult::AmbiguityKind
ENUM_SYNC(CXAmbiguityKind_AmbiguousBaseSubobjectTypes, clang::LookupResult::AmbiguousBaseSubobjectTypes);
ENUM_SYNC(CXAmbiguityKind_AmbiguousBaseSubobjects, clang::LookupResult::AmbiguousBaseSubobjects);
ENUM_SYNC(CXAmbiguityKind_AmbiguousReference, clang::LookupResult::AmbiguousReference);
ENUM_SYNC(CXAmbiguityKind_AmbiguousReferenceToPlaceholderVariable, clang::LookupResult::AmbiguousReferenceToPlaceholderVariable);
ENUM_SYNC(CXAmbiguityKind_AmbiguousTagHiding, clang::LookupResult::AmbiguousTagHiding);

ENUM_SYNC(CXUserDefinedLiteral_LOK_Raw, clang::UserDefinedLiteral::LOK_Raw);
ENUM_SYNC(CXUserDefinedLiteral_LOK_Template, clang::UserDefinedLiteral::LOK_Template);
ENUM_SYNC(CXUserDefinedLiteral_LOK_Integer, clang::UserDefinedLiteral::LOK_Integer);
ENUM_SYNC(CXUserDefinedLiteral_LOK_Floating, clang::UserDefinedLiteral::LOK_Floating);
ENUM_SYNC(CXUserDefinedLiteral_LOK_String, clang::UserDefinedLiteral::LOK_String);
ENUM_SYNC(CXUserDefinedLiteral_LOK_Character, clang::UserDefinedLiteral::LOK_Character);

// clang/Basic/Linkage.h: enum GVALinkage
ENUM_SYNC(CXGVALinkage_GVA_Internal, clang::GVA_Internal);
ENUM_SYNC(CXGVALinkage_GVA_AvailableExternally, clang::GVA_AvailableExternally);
ENUM_SYNC(CXGVALinkage_GVA_DiscardableODR, clang::GVA_DiscardableODR);
ENUM_SYNC(CXGVALinkage_GVA_StrongExternal, clang::GVA_StrongExternal);
ENUM_SYNC(CXGVALinkage_GVA_StrongODR, clang::GVA_StrongODR);

// clang/AST/ASTContext.h: enum class ASTContext::InlineVariableDefinitionKind
ENUM_SYNC(CXInlineVariableDefinitionKind_None,
          clang::ASTContext::InlineVariableDefinitionKind::None);
ENUM_SYNC(CXInlineVariableDefinitionKind_Weak,
          clang::ASTContext::InlineVariableDefinitionKind::Weak);
ENUM_SYNC(CXInlineVariableDefinitionKind_WeakUnknown,
          clang::ASTContext::InlineVariableDefinitionKind::WeakUnknown);
ENUM_SYNC(CXInlineVariableDefinitionKind_Strong,
          clang::ASTContext::InlineVariableDefinitionKind::Strong);

// clang/Driver/Driver.h: enum clang::driver::LTOKind
ENUM_SYNC(CXLTOKind_LTOK_None, clang::driver::LTOK_None);
ENUM_SYNC(CXLTOKind_LTOK_Full, clang::driver::LTOK_Full);
ENUM_SYNC(CXLTOKind_LTOK_Thin, clang::driver::LTOK_Thin);
ENUM_SYNC(CXLTOKind_LTOK_Unknown, clang::driver::LTOK_Unknown);

// clang/AST/Type.h: enum class VectorKind
ENUM_SYNC(CXVectorKind_Generic, clang::VectorKind::Generic);
ENUM_SYNC(CXVectorKind_AltiVecVector, clang::VectorKind::AltiVecVector);
ENUM_SYNC(CXVectorKind_AltiVecPixel, clang::VectorKind::AltiVecPixel);
ENUM_SYNC(CXVectorKind_AltiVecBool, clang::VectorKind::AltiVecBool);
ENUM_SYNC(CXVectorKind_Neon, clang::VectorKind::Neon);
ENUM_SYNC(CXVectorKind_NeonPoly, clang::VectorKind::NeonPoly);
ENUM_SYNC(CXVectorKind_SveFixedLengthData, clang::VectorKind::SveFixedLengthData);
ENUM_SYNC(CXVectorKind_SveFixedLengthPredicate, clang::VectorKind::SveFixedLengthPredicate);
ENUM_SYNC(CXVectorKind_RVVFixedLengthData, clang::VectorKind::RVVFixedLengthData);
ENUM_SYNC(CXVectorKind_RVVFixedLengthMask, clang::VectorKind::RVVFixedLengthMask);

// clang/AST/Comment.h: enum clang::comments::CommandMarkerKind
ENUM_SYNC(CXCommandMarkerKind_CMK_Backslash, clang::comments::CMK_Backslash);
ENUM_SYNC(CXCommandMarkerKind_CMK_At, clang::comments::CMK_At);

// clang/AST/Comment.h: enum class clang::comments::ParamCommandPassDirection
ENUM_SYNC(CXParamCommandPassDirection_In, clang::comments::ParamCommandPassDirection::In);
ENUM_SYNC(CXParamCommandPassDirection_Out, clang::comments::ParamCommandPassDirection::Out);
ENUM_SYNC(CXParamCommandPassDirection_InOut,
          clang::comments::ParamCommandPassDirection::InOut);

// clang/AST/Type.h: enum class AutoTypeKeyword
ENUM_SYNC(CXAutoTypeKeyword_Auto, clang::AutoTypeKeyword::Auto);
ENUM_SYNC(CXAutoTypeKeyword_DecltypeAuto, clang::AutoTypeKeyword::DecltypeAuto);
ENUM_SYNC(CXAutoTypeKeyword_GNUAutoType, clang::AutoTypeKeyword::GNUAutoType);

// clang/Basic/IdentifierTable.h: enum ObjCStringFormatFamily
ENUM_SYNC(CXObjCStringFormatFamily_SFF_None, clang::SFF_None);
ENUM_SYNC(CXObjCStringFormatFamily_SFF_NSString, clang::SFF_NSString);
ENUM_SYNC(CXObjCStringFormatFamily_SFF_CFString, clang::SFF_CFString);

// clang/AST/DeclBase.h: enum clang::Decl::ObjCDeclQualifier
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_None, clang::Decl::OBJC_TQ_None);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_In, clang::Decl::OBJC_TQ_In);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_Inout, clang::Decl::OBJC_TQ_Inout);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_Out, clang::Decl::OBJC_TQ_Out);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_Bycopy, clang::Decl::OBJC_TQ_Bycopy);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_Byref, clang::Decl::OBJC_TQ_Byref);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_Oneway, clang::Decl::OBJC_TQ_Oneway);
ENUM_SYNC(CXObjCDeclQualifier_OBJC_TQ_CSNullability, clang::Decl::OBJC_TQ_CSNullability);

// clang/AST/Expr.h: enum clang::OffsetOfNode::Kind
ENUM_SYNC(CXOffsetOfNode_Kind_Array, clang::OffsetOfNode::Array);
ENUM_SYNC(CXOffsetOfNode_Kind_Field, clang::OffsetOfNode::Field);
ENUM_SYNC(CXOffsetOfNode_Kind_Identifier, clang::OffsetOfNode::Identifier);
ENUM_SYNC(CXOffsetOfNode_Kind_Base, clang::OffsetOfNode::Base);

// clang/Basic/TypeTraits.h: enum ArrayTypeTrait
ENUM_SYNC(CXArrayTypeTrait_ATT_ArrayRank, clang::ATT_ArrayRank);
ENUM_SYNC(CXArrayTypeTrait_ATT_ArrayExtent, clang::ATT_ArrayExtent);

// clang/Basic/ExpressionTraits.h: enum ExpressionTrait
ENUM_SYNC(CXExpressionTrait_ET_IsLValueExpr, clang::ET_IsLValueExpr);
ENUM_SYNC(CXExpressionTrait_ET_IsRValueExpr, clang::ET_IsRValueExpr);

// clang/AST/Type.h: enum QualType::PrimitiveDefaultInitializeKind
ENUM_SYNC(CXPrimitiveDefaultInitializeKind_PDIK_Trivial, clang::QualType::PDIK_Trivial);
ENUM_SYNC(CXPrimitiveDefaultInitializeKind_PDIK_ARCStrong, clang::QualType::PDIK_ARCStrong);
ENUM_SYNC(CXPrimitiveDefaultInitializeKind_PDIK_ARCWeak, clang::QualType::PDIK_ARCWeak);
ENUM_SYNC(CXPrimitiveDefaultInitializeKind_PDIK_Struct, clang::QualType::PDIK_Struct);

// clang/AST/Type.h: enum QualType::PrimitiveCopyKind
ENUM_SYNC(CXPrimitiveCopyKind_PCK_Trivial, clang::QualType::PCK_Trivial);
ENUM_SYNC(CXPrimitiveCopyKind_PCK_VolatileTrivial, clang::QualType::PCK_VolatileTrivial);
ENUM_SYNC(CXPrimitiveCopyKind_PCK_ARCStrong, clang::QualType::PCK_ARCStrong);
ENUM_SYNC(CXPrimitiveCopyKind_PCK_ARCWeak, clang::QualType::PCK_ARCWeak);
ENUM_SYNC(CXPrimitiveCopyKind_PCK_Struct, clang::QualType::PCK_Struct);

// clang/AST/Type.h: enum RefQualifierKind
ENUM_SYNC(CXRefQualifierKind_RQ_None, clang::RQ_None);
ENUM_SYNC(CXRefQualifierKind_RQ_LValue, clang::RQ_LValue);
ENUM_SYNC(CXRefQualifierKind_RQ_RValue, clang::RQ_RValue);

// clang/Basic/ExceptionSpecificationType.h: enum CanThrowResult
ENUM_SYNC(CXCanThrowResult_CT_Cannot, clang::CT_Cannot);
ENUM_SYNC(CXCanThrowResult_CT_Dependent, clang::CT_Dependent);
ENUM_SYNC(CXCanThrowResult_CT_Can, clang::CT_Can);

// clang/AST/Stmt.h: enum clang::Stmt::Likelihood
ENUM_SYNC(CXLikelihood_LH_Unlikely, clang::Stmt::LH_Unlikely);
ENUM_SYNC(CXLikelihood_LH_None, clang::Stmt::LH_None);
ENUM_SYNC(CXLikelihood_LH_Likely, clang::Stmt::LH_Likely);

// clang/AST/Comment.h: enum class clang::comments::InlineCommandRenderKind
ENUM_SYNC(CXInlineCommandRenderKind_Normal,
          clang::comments::InlineCommandRenderKind::Normal);
ENUM_SYNC(CXInlineCommandRenderKind_Bold, clang::comments::InlineCommandRenderKind::Bold);
ENUM_SYNC(CXInlineCommandRenderKind_Monospaced,
          clang::comments::InlineCommandRenderKind::Monospaced);
ENUM_SYNC(CXInlineCommandRenderKind_Emphasized,
          clang::comments::InlineCommandRenderKind::Emphasized);
ENUM_SYNC(CXInlineCommandRenderKind_Anchor,
          clang::comments::InlineCommandRenderKind::Anchor);

// clang/AST/Expr.h: enum class ConstantResultStorageKind
ENUM_SYNC(CXConstantResultStorageKind_None, clang::ConstantResultStorageKind::None);
ENUM_SYNC(CXConstantResultStorageKind_Int64, clang::ConstantResultStorageKind::Int64);
ENUM_SYNC(CXConstantResultStorageKind_APValue, clang::ConstantResultStorageKind::APValue);

// clang/AST/Expr.h: enum class SourceLocIdentKind
ENUM_SYNC(CXSourceLocIdentKind_Function, clang::SourceLocIdentKind::Function);
ENUM_SYNC(CXSourceLocIdentKind_FuncSig, clang::SourceLocIdentKind::FuncSig);
ENUM_SYNC(CXSourceLocIdentKind_File, clang::SourceLocIdentKind::File);
ENUM_SYNC(CXSourceLocIdentKind_FileName, clang::SourceLocIdentKind::FileName);
ENUM_SYNC(CXSourceLocIdentKind_Line, clang::SourceLocIdentKind::Line);
ENUM_SYNC(CXSourceLocIdentKind_Column, clang::SourceLocIdentKind::Column);
ENUM_SYNC(CXSourceLocIdentKind_SourceLocStruct, clang::SourceLocIdentKind::SourceLocStruct);

// clang/AST/Expr.h: enum isModifiableLvalueResult (nested in clang::Expr)
ENUM_SYNC(CXExpr_MLV_Valid, clang::Expr::MLV_Valid);
ENUM_SYNC(CXExpr_MLV_NotObjectType, clang::Expr::MLV_NotObjectType);
ENUM_SYNC(CXExpr_MLV_IncompleteVoidType, clang::Expr::MLV_IncompleteVoidType);
ENUM_SYNC(CXExpr_MLV_DuplicateVectorComponents, clang::Expr::MLV_DuplicateVectorComponents);
ENUM_SYNC(CXExpr_MLV_InvalidExpression, clang::Expr::MLV_InvalidExpression);
ENUM_SYNC(CXExpr_MLV_LValueCast, clang::Expr::MLV_LValueCast);
ENUM_SYNC(CXExpr_MLV_IncompleteType, clang::Expr::MLV_IncompleteType);
ENUM_SYNC(CXExpr_MLV_ConstQualified, clang::Expr::MLV_ConstQualified);
ENUM_SYNC(CXExpr_MLV_ConstQualifiedField, clang::Expr::MLV_ConstQualifiedField);
ENUM_SYNC(CXExpr_MLV_ConstAddrSpace, clang::Expr::MLV_ConstAddrSpace);
ENUM_SYNC(CXExpr_MLV_ArrayType, clang::Expr::MLV_ArrayType);
ENUM_SYNC(CXExpr_MLV_NoSetterProperty, clang::Expr::MLV_NoSetterProperty);
ENUM_SYNC(CXExpr_MLV_MemberFunction, clang::Expr::MLV_MemberFunction);
ENUM_SYNC(CXExpr_MLV_SubObjCPropertySetting, clang::Expr::MLV_SubObjCPropertySetting);
ENUM_SYNC(CXExpr_MLV_InvalidMessageExpression, clang::Expr::MLV_InvalidMessageExpression);
ENUM_SYNC(CXExpr_MLV_ClassTemporary, clang::Expr::MLV_ClassTemporary);
ENUM_SYNC(CXExpr_MLV_ArrayTemporary, clang::Expr::MLV_ArrayTemporary);

// clang/Basic/CapturedStmt.h: enum CapturedRegionKind
ENUM_SYNC(CXCapturedRegionKind_CR_Default, clang::CR_Default);
ENUM_SYNC(CXCapturedRegionKind_CR_ObjCAtFinally, clang::CR_ObjCAtFinally);
ENUM_SYNC(CXCapturedRegionKind_CR_OpenMP, clang::CR_OpenMP);

// clang/AST/Stmt.h: enum clang::CapturedStmt::VariableCaptureKind
ENUM_SYNC(CXVariableCaptureKind_VCK_This, clang::CapturedStmt::VCK_This);
ENUM_SYNC(CXVariableCaptureKind_VCK_ByRef, clang::CapturedStmt::VCK_ByRef);
ENUM_SYNC(CXVariableCaptureKind_VCK_ByCopy, clang::CapturedStmt::VCK_ByCopy);
ENUM_SYNC(CXVariableCaptureKind_VCK_VLAType, clang::CapturedStmt::VCK_VLAType);

// clang/Basic/Builtins.h: enum BuiltinTemplateKind : int
ENUM_SYNC(CXBuiltinTemplateKind_BTK__make_integer_seq, clang::BTK__make_integer_seq);
ENUM_SYNC(CXBuiltinTemplateKind_BTK__type_pack_element, clang::BTK__type_pack_element);

// clang/Basic/Specifiers.h: enum class IfStatementKind : unsigned
ENUM_SYNC(CXIfStatementKind_Ordinary, clang::IfStatementKind::Ordinary);
ENUM_SYNC(CXIfStatementKind_Constexpr, clang::IfStatementKind::Constexpr);
ENUM_SYNC(CXIfStatementKind_ConstevalNonNegated,
          clang::IfStatementKind::ConstevalNonNegated);
ENUM_SYNC(CXIfStatementKind_ConstevalNegated, clang::IfStatementKind::ConstevalNegated);

// clang/Basic/LangOptions.h: enum clang::LangOptions::FPEvalMethodKind
ENUM_SYNC(CXFPEvalMethodKind_FEM_Indeterminable, clang::LangOptions::FEM_Indeterminable);
ENUM_SYNC(CXFPEvalMethodKind_FEM_Source, clang::LangOptions::FEM_Source);
ENUM_SYNC(CXFPEvalMethodKind_FEM_Double, clang::LangOptions::FEM_Double);
ENUM_SYNC(CXFPEvalMethodKind_FEM_Extended, clang::LangOptions::FEM_Extended);
ENUM_SYNC(CXFPEvalMethodKind_FEM_UnsetOnCommandLine,
          clang::LangOptions::FEM_UnsetOnCommandLine);

// clang/AST/Type.h: enum clang::FunctionType::ArmStateValue : unsigned
ENUM_SYNC(CXArmStateValue_ARM_None, clang::FunctionType::ARM_None);
ENUM_SYNC(CXArmStateValue_ARM_Preserves, clang::FunctionType::ARM_Preserves);
ENUM_SYNC(CXArmStateValue_ARM_In, clang::FunctionType::ARM_In);
ENUM_SYNC(CXArmStateValue_ARM_Out, clang::FunctionType::ARM_Out);
ENUM_SYNC(CXArmStateValue_ARM_InOut, clang::FunctionType::ARM_InOut);

// clang/AST/Type.h: enum clang::UnaryTransformType::UTTKind
ENUM_SYNC(CXUTTKind_AddLvalueReference, clang::UnaryTransformType::AddLvalueReference);
ENUM_SYNC(CXUTTKind_AddPointer, clang::UnaryTransformType::AddPointer);
ENUM_SYNC(CXUTTKind_AddRvalueReference, clang::UnaryTransformType::AddRvalueReference);
ENUM_SYNC(CXUTTKind_Decay, clang::UnaryTransformType::Decay);
ENUM_SYNC(CXUTTKind_MakeSigned, clang::UnaryTransformType::MakeSigned);
ENUM_SYNC(CXUTTKind_MakeUnsigned, clang::UnaryTransformType::MakeUnsigned);
ENUM_SYNC(CXUTTKind_RemoveAllExtents, clang::UnaryTransformType::RemoveAllExtents);
ENUM_SYNC(CXUTTKind_RemoveConst, clang::UnaryTransformType::RemoveConst);
ENUM_SYNC(CXUTTKind_RemoveCV, clang::UnaryTransformType::RemoveCV);
ENUM_SYNC(CXUTTKind_RemoveCVRef, clang::UnaryTransformType::RemoveCVRef);
ENUM_SYNC(CXUTTKind_RemoveExtent, clang::UnaryTransformType::RemoveExtent);
ENUM_SYNC(CXUTTKind_RemovePointer, clang::UnaryTransformType::RemovePointer);
ENUM_SYNC(CXUTTKind_RemoveReference, clang::UnaryTransformType::RemoveReference);
ENUM_SYNC(CXUTTKind_RemoveRestrict, clang::UnaryTransformType::RemoveRestrict);
ENUM_SYNC(CXUTTKind_RemoveVolatile, clang::UnaryTransformType::RemoveVolatile);
ENUM_SYNC(CXUTTKind_EnumUnderlyingType, clang::UnaryTransformType::EnumUnderlyingType);

// clang/AST/Type.h: enum clang::UnaryTransformType::UTTKind
ENUM_SYNC(CXUTTKind_AddLvalueReference, clang::UnaryTransformType::AddLvalueReference);
ENUM_SYNC(CXUTTKind_AddPointer, clang::UnaryTransformType::AddPointer);
ENUM_SYNC(CXUTTKind_AddRvalueReference, clang::UnaryTransformType::AddRvalueReference);
ENUM_SYNC(CXUTTKind_Decay, clang::UnaryTransformType::Decay);
ENUM_SYNC(CXUTTKind_MakeSigned, clang::UnaryTransformType::MakeSigned);
ENUM_SYNC(CXUTTKind_MakeUnsigned, clang::UnaryTransformType::MakeUnsigned);
ENUM_SYNC(CXUTTKind_RemoveAllExtents, clang::UnaryTransformType::RemoveAllExtents);
ENUM_SYNC(CXUTTKind_RemoveConst, clang::UnaryTransformType::RemoveConst);
ENUM_SYNC(CXUTTKind_RemoveCV, clang::UnaryTransformType::RemoveCV);
ENUM_SYNC(CXUTTKind_RemoveCVRef, clang::UnaryTransformType::RemoveCVRef);
ENUM_SYNC(CXUTTKind_RemoveExtent, clang::UnaryTransformType::RemoveExtent);
ENUM_SYNC(CXUTTKind_RemovePointer, clang::UnaryTransformType::RemovePointer);
ENUM_SYNC(CXUTTKind_RemoveReference, clang::UnaryTransformType::RemoveReference);
ENUM_SYNC(CXUTTKind_RemoveRestrict, clang::UnaryTransformType::RemoveRestrict);
ENUM_SYNC(CXUTTKind_RemoveVolatile, clang::UnaryTransformType::RemoveVolatile);
ENUM_SYNC(CXUTTKind_EnumUnderlyingType, clang::UnaryTransformType::EnumUnderlyingType);

// clang/Basic/TargetInfo.h: enum clang::OpenCLTypeKind : uint8_t
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_Default, clang::OCLTK_Default);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_ClkEvent, clang::OCLTK_ClkEvent);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_Event, clang::OCLTK_Event);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_Image, clang::OCLTK_Image);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_Pipe, clang::OCLTK_Pipe);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_Queue, clang::OCLTK_Queue);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_ReserveID, clang::OCLTK_ReserveID);
ENUM_SYNC(CXOpenCLTypeKind_OCLTK_Sampler, clang::OCLTK_Sampler);

// clang/Analysis/ConstructionContext.h: enum Kind (nested in
// clang::ConstructionContext)
ENUM_SYNC(CXConstructionContextKind_SimpleVariableKind,
          clang::ConstructionContext::SimpleVariableKind);
ENUM_SYNC(CXConstructionContextKind_CXX17ElidedCopyVariableKind,
          clang::ConstructionContext::CXX17ElidedCopyVariableKind);
ENUM_SYNC(CXConstructionContextKind_SimpleConstructorInitializerKind,
          clang::ConstructionContext::SimpleConstructorInitializerKind);
ENUM_SYNC(CXConstructionContextKind_CXX17ElidedCopyConstructorInitializerKind,
          clang::ConstructionContext::CXX17ElidedCopyConstructorInitializerKind);
ENUM_SYNC(CXConstructionContextKind_NewAllocatedObjectKind,
          clang::ConstructionContext::NewAllocatedObjectKind);
ENUM_SYNC(CXConstructionContextKind_SimpleTemporaryObjectKind,
          clang::ConstructionContext::SimpleTemporaryObjectKind);
ENUM_SYNC(CXConstructionContextKind_ElidedTemporaryObjectKind,
          clang::ConstructionContext::ElidedTemporaryObjectKind);
ENUM_SYNC(CXConstructionContextKind_SimpleReturnedValueKind,
          clang::ConstructionContext::SimpleReturnedValueKind);
ENUM_SYNC(CXConstructionContextKind_CXX17ElidedCopyReturnedValueKind,
          clang::ConstructionContext::CXX17ElidedCopyReturnedValueKind);
ENUM_SYNC(CXConstructionContextKind_ArgumentKind, clang::ConstructionContext::ArgumentKind);
ENUM_SYNC(CXConstructionContextKind_LambdaCaptureKind,
          clang::ConstructionContext::LambdaCaptureKind);

// clang/Basic/Specifiers.h: enum class NullabilityKind : uint8_t
ENUM_SYNC(CXNullabilityKind_NonNull, clang::NullabilityKind::NonNull);
ENUM_SYNC(CXNullabilityKind_Nullable, clang::NullabilityKind::Nullable);
ENUM_SYNC(CXNullabilityKind_Unspecified, clang::NullabilityKind::Unspecified);
ENUM_SYNC(CXNullabilityKind_NullableResult, clang::NullabilityKind::NullableResult);

// clang/Basic/Specifiers.h: enum class ParameterABI
ENUM_SYNC(CXParameterABI_Ordinary, clang::ParameterABI::Ordinary);
ENUM_SYNC(CXParameterABI_SwiftIndirectResult, clang::ParameterABI::SwiftIndirectResult);
ENUM_SYNC(CXParameterABI_SwiftErrorResult, clang::ParameterABI::SwiftErrorResult);
ENUM_SYNC(CXParameterABI_SwiftContext, clang::ParameterABI::SwiftContext);
ENUM_SYNC(CXParameterABI_SwiftAsyncContext, clang::ParameterABI::SwiftAsyncContext);

// clang/Basic/TargetInfo.h: enum class clang::FloatModeKind (a bitmask; the
// LLVM_MARK_AS_BITMASK_ENUM alias enumerator is omitted from the mirror)
ENUM_SYNC(CXFloatModeKind_NoFloat, clang::FloatModeKind::NoFloat);
ENUM_SYNC(CXFloatModeKind_Half, clang::FloatModeKind::Half);
ENUM_SYNC(CXFloatModeKind_Float, clang::FloatModeKind::Float);
ENUM_SYNC(CXFloatModeKind_Double, clang::FloatModeKind::Double);
ENUM_SYNC(CXFloatModeKind_LongDouble, clang::FloatModeKind::LongDouble);
ENUM_SYNC(CXFloatModeKind_Float128, clang::FloatModeKind::Float128);
ENUM_SYNC(CXFloatModeKind_Ibm128, clang::FloatModeKind::Ibm128);

// clang/AST/Expr.h: enum Kinds (nested in clang::Expr::Classification)
ENUM_SYNC(CXClassification_CL_LValue, clang::Expr::Classification::CL_LValue);
ENUM_SYNC(CXClassification_CL_XValue, clang::Expr::Classification::CL_XValue);
ENUM_SYNC(CXClassification_CL_Function, clang::Expr::Classification::CL_Function);
ENUM_SYNC(CXClassification_CL_Void, clang::Expr::Classification::CL_Void);
ENUM_SYNC(CXClassification_CL_AddressableVoid,
          clang::Expr::Classification::CL_AddressableVoid);
ENUM_SYNC(CXClassification_CL_DuplicateVectorComponents,
          clang::Expr::Classification::CL_DuplicateVectorComponents);
ENUM_SYNC(CXClassification_CL_MemberFunction,
          clang::Expr::Classification::CL_MemberFunction);
ENUM_SYNC(CXClassification_CL_SubObjCPropertySetting,
          clang::Expr::Classification::CL_SubObjCPropertySetting);
ENUM_SYNC(CXClassification_CL_ClassTemporary,
          clang::Expr::Classification::CL_ClassTemporary);
ENUM_SYNC(CXClassification_CL_ArrayTemporary,
          clang::Expr::Classification::CL_ArrayTemporary);
ENUM_SYNC(CXClassification_CL_ObjCMessageRValue,
          clang::Expr::Classification::CL_ObjCMessageRValue);
ENUM_SYNC(CXClassification_CL_PRValue, clang::Expr::Classification::CL_PRValue);

// clang/AST/Expr.h: enum ModifiableType (nested in clang::Expr::Classification)
ENUM_SYNC(CXClassification_CM_Untested, clang::Expr::Classification::CM_Untested);
ENUM_SYNC(CXClassification_CM_Modifiable, clang::Expr::Classification::CM_Modifiable);
ENUM_SYNC(CXClassification_CM_RValue, clang::Expr::Classification::CM_RValue);
ENUM_SYNC(CXClassification_CM_Function, clang::Expr::Classification::CM_Function);
ENUM_SYNC(CXClassification_CM_LValueCast, clang::Expr::Classification::CM_LValueCast);
ENUM_SYNC(CXClassification_CM_NoSetterProperty,
          clang::Expr::Classification::CM_NoSetterProperty);
ENUM_SYNC(CXClassification_CM_ConstQualified,
          clang::Expr::Classification::CM_ConstQualified);
ENUM_SYNC(CXClassification_CM_ConstQualifiedField,
          clang::Expr::Classification::CM_ConstQualifiedField);
ENUM_SYNC(CXClassification_CM_ConstAddrSpace,
          clang::Expr::Classification::CM_ConstAddrSpace);
ENUM_SYNC(CXClassification_CM_ArrayType, clang::Expr::Classification::CM_ArrayType);
ENUM_SYNC(CXClassification_CM_IncompleteType,
          clang::Expr::Classification::CM_IncompleteType);

// clang/AST/Expr.h: enum LValueClassification (nested in clang::Expr)
ENUM_SYNC(CXExpr_LV_Valid, clang::Expr::LV_Valid);
ENUM_SYNC(CXExpr_LV_NotObjectType, clang::Expr::LV_NotObjectType);
ENUM_SYNC(CXExpr_LV_IncompleteVoidType, clang::Expr::LV_IncompleteVoidType);
ENUM_SYNC(CXExpr_LV_DuplicateVectorComponents, clang::Expr::LV_DuplicateVectorComponents);
ENUM_SYNC(CXExpr_LV_InvalidExpression, clang::Expr::LV_InvalidExpression);
ENUM_SYNC(CXExpr_LV_InvalidMessageExpression, clang::Expr::LV_InvalidMessageExpression);
ENUM_SYNC(CXExpr_LV_MemberFunction, clang::Expr::LV_MemberFunction);
ENUM_SYNC(CXExpr_LV_SubObjCPropertySetting, clang::Expr::LV_SubObjCPropertySetting);
ENUM_SYNC(CXExpr_LV_ClassTemporary, clang::Expr::LV_ClassTemporary);
ENUM_SYNC(CXExpr_LV_ArrayTemporary, clang::Expr::LV_ArrayTemporary);

// clang/AST/Type.h: enum clang::Qualifiers::GC
ENUM_SYNC(CXQualifiers_GCNone, clang::Qualifiers::GCNone);
ENUM_SYNC(CXQualifiers_Weak, clang::Qualifiers::Weak);
ENUM_SYNC(CXQualifiers_Strong, clang::Qualifiers::Strong);

// clang/AST/Type.h: enum clang::Qualifiers::ObjCLifetime
ENUM_SYNC(CXQualifiers_OCL_None, clang::Qualifiers::OCL_None);
ENUM_SYNC(CXQualifiers_OCL_ExplicitNone, clang::Qualifiers::OCL_ExplicitNone);
ENUM_SYNC(CXQualifiers_OCL_Strong, clang::Qualifiers::OCL_Strong);
ENUM_SYNC(CXQualifiers_OCL_Weak, clang::Qualifiers::OCL_Weak);
ENUM_SYNC(CXQualifiers_OCL_Autoreleasing, clang::Qualifiers::OCL_Autoreleasing);

// clang/AST/Comment.h: enum DeclKind (nested in clang::comments::DeclInfo)
ENUM_SYNC(CXDeclInfo_OtherKind, clang::comments::DeclInfo::OtherKind);
ENUM_SYNC(CXDeclInfo_FunctionKind, clang::comments::DeclInfo::FunctionKind);
ENUM_SYNC(CXDeclInfo_ClassKind, clang::comments::DeclInfo::ClassKind);
ENUM_SYNC(CXDeclInfo_VariableKind, clang::comments::DeclInfo::VariableKind);
ENUM_SYNC(CXDeclInfo_NamespaceKind, clang::comments::DeclInfo::NamespaceKind);
ENUM_SYNC(CXDeclInfo_TypedefKind, clang::comments::DeclInfo::TypedefKind);
ENUM_SYNC(CXDeclInfo_EnumKind, clang::comments::DeclInfo::EnumKind);

// clang/AST/Comment.h: enum TemplateDeclKind (nested in clang::comments::DeclInfo)
ENUM_SYNC(CXDeclInfo_NotTemplate, clang::comments::DeclInfo::NotTemplate);
ENUM_SYNC(CXDeclInfo_Template, clang::comments::DeclInfo::Template);
ENUM_SYNC(CXDeclInfo_TemplateSpecialization,
          clang::comments::DeclInfo::TemplateSpecialization);
ENUM_SYNC(CXDeclInfo_TemplatePartialSpecialization,
          clang::comments::DeclInfo::TemplatePartialSpecialization);

// clang/AST/Type.h: enum class TypeOfKind
ENUM_SYNC(CXTypeOfKind_Qualified, clang::TypeOfKind::Qualified);
ENUM_SYNC(CXTypeOfKind_Unqualified, clang::TypeOfKind::Unqualified);

// clang/Basic/Specifiers.h: enum class MSInheritanceModel
ENUM_SYNC(CXMSInheritanceModel_Single, clang::MSInheritanceModel::Single);
ENUM_SYNC(CXMSInheritanceModel_Multiple, clang::MSInheritanceModel::Multiple);
ENUM_SYNC(CXMSInheritanceModel_Virtual, clang::MSInheritanceModel::Virtual);
ENUM_SYNC(CXMSInheritanceModel_Unspecified, clang::MSInheritanceModel::Unspecified);

// clang/Basic/TypeTraits.h: enum TypeTrait
ENUM_SYNC(CXTypeTrait_UTT_IsInterfaceClass, clang::UTT_IsInterfaceClass);
ENUM_SYNC(CXTypeTrait_UTT_IsSealed, clang::UTT_IsSealed);
ENUM_SYNC(CXTypeTrait_UTT_IsDestructible, clang::UTT_IsDestructible);
ENUM_SYNC(CXTypeTrait_UTT_IsTriviallyDestructible, clang::UTT_IsTriviallyDestructible);
ENUM_SYNC(CXTypeTrait_UTT_IsNothrowDestructible, clang::UTT_IsNothrowDestructible);
ENUM_SYNC(CXTypeTrait_UTT_HasNothrowMoveAssign, clang::UTT_HasNothrowMoveAssign);
ENUM_SYNC(CXTypeTrait_UTT_HasTrivialMoveAssign, clang::UTT_HasTrivialMoveAssign);
ENUM_SYNC(CXTypeTrait_UTT_HasTrivialMoveConstructor, clang::UTT_HasTrivialMoveConstructor);
ENUM_SYNC(CXTypeTrait_UTT_HasNothrowAssign, clang::UTT_HasNothrowAssign);
ENUM_SYNC(CXTypeTrait_UTT_HasNothrowCopy, clang::UTT_HasNothrowCopy);
ENUM_SYNC(CXTypeTrait_UTT_HasNothrowConstructor, clang::UTT_HasNothrowConstructor);
ENUM_SYNC(CXTypeTrait_UTT_HasTrivialAssign, clang::UTT_HasTrivialAssign);
ENUM_SYNC(CXTypeTrait_UTT_HasTrivialCopy, clang::UTT_HasTrivialCopy);
ENUM_SYNC(CXTypeTrait_UTT_HasTrivialDefaultConstructor,
          clang::UTT_HasTrivialDefaultConstructor);
ENUM_SYNC(CXTypeTrait_UTT_HasTrivialDestructor, clang::UTT_HasTrivialDestructor);
ENUM_SYNC(CXTypeTrait_UTT_HasVirtualDestructor, clang::UTT_HasVirtualDestructor);
ENUM_SYNC(CXTypeTrait_UTT_IsAbstract, clang::UTT_IsAbstract);
ENUM_SYNC(CXTypeTrait_UTT_IsAggregate, clang::UTT_IsAggregate);
ENUM_SYNC(CXTypeTrait_UTT_IsClass, clang::UTT_IsClass);
ENUM_SYNC(CXTypeTrait_UTT_IsEmpty, clang::UTT_IsEmpty);
ENUM_SYNC(CXTypeTrait_UTT_IsEnum, clang::UTT_IsEnum);
ENUM_SYNC(CXTypeTrait_UTT_IsFinal, clang::UTT_IsFinal);
ENUM_SYNC(CXTypeTrait_UTT_IsLiteral, clang::UTT_IsLiteral);
ENUM_SYNC(CXTypeTrait_UTT_IsPOD, clang::UTT_IsPOD);
ENUM_SYNC(CXTypeTrait_UTT_IsPolymorphic, clang::UTT_IsPolymorphic);
ENUM_SYNC(CXTypeTrait_UTT_IsStandardLayout, clang::UTT_IsStandardLayout);
ENUM_SYNC(CXTypeTrait_UTT_IsTrivial, clang::UTT_IsTrivial);
ENUM_SYNC(CXTypeTrait_UTT_IsTriviallyCopyable, clang::UTT_IsTriviallyCopyable);
ENUM_SYNC(CXTypeTrait_UTT_IsUnion, clang::UTT_IsUnion);
ENUM_SYNC(CXTypeTrait_UTT_HasUniqueObjectRepresentations,
          clang::UTT_HasUniqueObjectRepresentations);
ENUM_SYNC(CXTypeTrait_UTT_IsTriviallyRelocatable, clang::UTT_IsTriviallyRelocatable);
ENUM_SYNC(CXTypeTrait_UTT_IsTriviallyEqualityComparable,
          clang::UTT_IsTriviallyEqualityComparable);
ENUM_SYNC(CXTypeTrait_UTT_IsBoundedArray, clang::UTT_IsBoundedArray);
ENUM_SYNC(CXTypeTrait_UTT_IsUnboundedArray, clang::UTT_IsUnboundedArray);
ENUM_SYNC(CXTypeTrait_UTT_IsNullPointer, clang::UTT_IsNullPointer);
ENUM_SYNC(CXTypeTrait_UTT_IsScopedEnum, clang::UTT_IsScopedEnum);
ENUM_SYNC(CXTypeTrait_UTT_IsReferenceable, clang::UTT_IsReferenceable);
ENUM_SYNC(CXTypeTrait_UTT_CanPassInRegs, clang::UTT_CanPassInRegs);
ENUM_SYNC(CXTypeTrait_UTT_IsArithmetic, clang::UTT_IsArithmetic);
ENUM_SYNC(CXTypeTrait_UTT_IsFloatingPoint, clang::UTT_IsFloatingPoint);
ENUM_SYNC(CXTypeTrait_UTT_IsIntegral, clang::UTT_IsIntegral);
ENUM_SYNC(CXTypeTrait_UTT_IsCompleteType, clang::UTT_IsCompleteType);
ENUM_SYNC(CXTypeTrait_UTT_IsVoid, clang::UTT_IsVoid);
ENUM_SYNC(CXTypeTrait_UTT_IsArray, clang::UTT_IsArray);
ENUM_SYNC(CXTypeTrait_UTT_IsFunction, clang::UTT_IsFunction);
ENUM_SYNC(CXTypeTrait_UTT_IsReference, clang::UTT_IsReference);
ENUM_SYNC(CXTypeTrait_UTT_IsLvalueReference, clang::UTT_IsLvalueReference);
ENUM_SYNC(CXTypeTrait_UTT_IsRvalueReference, clang::UTT_IsRvalueReference);
ENUM_SYNC(CXTypeTrait_UTT_IsFundamental, clang::UTT_IsFundamental);
ENUM_SYNC(CXTypeTrait_UTT_IsObject, clang::UTT_IsObject);
ENUM_SYNC(CXTypeTrait_UTT_IsScalar, clang::UTT_IsScalar);
ENUM_SYNC(CXTypeTrait_UTT_IsCompound, clang::UTT_IsCompound);
ENUM_SYNC(CXTypeTrait_UTT_IsPointer, clang::UTT_IsPointer);
ENUM_SYNC(CXTypeTrait_UTT_IsMemberObjectPointer, clang::UTT_IsMemberObjectPointer);
ENUM_SYNC(CXTypeTrait_UTT_IsMemberFunctionPointer, clang::UTT_IsMemberFunctionPointer);
ENUM_SYNC(CXTypeTrait_UTT_IsMemberPointer, clang::UTT_IsMemberPointer);
ENUM_SYNC(CXTypeTrait_UTT_IsConst, clang::UTT_IsConst);
ENUM_SYNC(CXTypeTrait_UTT_IsVolatile, clang::UTT_IsVolatile);
ENUM_SYNC(CXTypeTrait_UTT_IsSigned, clang::UTT_IsSigned);
ENUM_SYNC(CXTypeTrait_UTT_IsUnsigned, clang::UTT_IsUnsigned);
ENUM_SYNC(CXTypeTrait_BTT_TypeCompatible, clang::BTT_TypeCompatible);
ENUM_SYNC(CXTypeTrait_BTT_IsNothrowAssignable, clang::BTT_IsNothrowAssignable);
ENUM_SYNC(CXTypeTrait_BTT_IsAssignable, clang::BTT_IsAssignable);
ENUM_SYNC(CXTypeTrait_BTT_IsBaseOf, clang::BTT_IsBaseOf);
ENUM_SYNC(CXTypeTrait_BTT_IsConvertibleTo, clang::BTT_IsConvertibleTo);
ENUM_SYNC(CXTypeTrait_BTT_IsTriviallyAssignable, clang::BTT_IsTriviallyAssignable);
ENUM_SYNC(CXTypeTrait_BTT_ReferenceBindsToTemporary, clang::BTT_ReferenceBindsToTemporary);
ENUM_SYNC(CXTypeTrait_BTT_ReferenceConstructsFromTemporary,
          clang::BTT_ReferenceConstructsFromTemporary);
ENUM_SYNC(CXTypeTrait_BTT_IsSame, clang::BTT_IsSame);
ENUM_SYNC(CXTypeTrait_BTT_IsConvertible, clang::BTT_IsConvertible);
ENUM_SYNC(CXTypeTrait_TT_IsConstructible, clang::TT_IsConstructible);
ENUM_SYNC(CXTypeTrait_TT_IsNothrowConstructible, clang::TT_IsNothrowConstructible);
ENUM_SYNC(CXTypeTrait_TT_IsTriviallyConstructible, clang::TT_IsTriviallyConstructible);

// clang/AST/ASTContext.h: enum clang::ASTContext::GetBuiltinTypeError
ENUM_SYNC(CXGetBuiltinTypeError_GE_None, clang::ASTContext::GE_None);
ENUM_SYNC(CXGetBuiltinTypeError_GE_Missing_type, clang::ASTContext::GE_Missing_type);
ENUM_SYNC(CXGetBuiltinTypeError_GE_Missing_stdio, clang::ASTContext::GE_Missing_stdio);
ENUM_SYNC(CXGetBuiltinTypeError_GE_Missing_setjmp, clang::ASTContext::GE_Missing_setjmp);
ENUM_SYNC(CXGetBuiltinTypeError_GE_Missing_ucontext,
          clang::ASTContext::GE_Missing_ucontext);

// clang/Basic/TargetInfo.h: enum TargetInfo::CallingConvCheckResult
ENUM_SYNC(CXTargetInfo_CCCR_OK, clang::TargetInfo::CCCR_OK);
ENUM_SYNC(CXTargetInfo_CCCR_Warning, clang::TargetInfo::CCCR_Warning);
ENUM_SYNC(CXTargetInfo_CCCR_Ignore, clang::TargetInfo::CCCR_Ignore);
ENUM_SYNC(CXTargetInfo_CCCR_Error, clang::TargetInfo::CCCR_Error);

// clang/Basic/TargetInfo.h: enum TargetInfo::CallingConvKind
ENUM_SYNC(CXTargetInfo_CCK_Default, clang::TargetInfo::CCK_Default);
ENUM_SYNC(CXTargetInfo_CCK_ClangABI4OrPS4, clang::TargetInfo::CCK_ClangABI4OrPS4);
ENUM_SYNC(CXTargetInfo_CCK_MicrosoftWin64, clang::TargetInfo::CCK_MicrosoftWin64);

// clang/Basic/LangOptions.h: enum class LangOptions::StrictFlexArraysLevelKind
ENUM_SYNC(CXStrictFlexArraysLevelKind_Default,
          clang::LangOptions::StrictFlexArraysLevelKind::Default);
ENUM_SYNC(CXStrictFlexArraysLevelKind_OneZeroOrIncomplete,
          clang::LangOptions::StrictFlexArraysLevelKind::OneZeroOrIncomplete);
ENUM_SYNC(CXStrictFlexArraysLevelKind_ZeroOrIncomplete,
          clang::LangOptions::StrictFlexArraysLevelKind::ZeroOrIncomplete);
ENUM_SYNC(CXStrictFlexArraysLevelKind_IncompleteOnly,
          clang::LangOptions::StrictFlexArraysLevelKind::IncompleteOnly);

// clang/AST/Type.h: enum class QualType::NonConstantStorageReason
ENUM_SYNC(CXNonConstantStorageReason_MutableField,
          clang::QualType::NonConstantStorageReason::MutableField);
ENUM_SYNC(CXNonConstantStorageReason_NonConstNonReferenceType,
          clang::QualType::NonConstantStorageReason::NonConstNonReferenceType);
ENUM_SYNC(CXNonConstantStorageReason_NonTrivialCtor,
          clang::QualType::NonConstantStorageReason::NonTrivialCtor);
ENUM_SYNC(CXNonConstantStorageReason_NonTrivialDtor,
          clang::QualType::NonConstantStorageReason::NonTrivialDtor);

// clang/Basic/LangOptions.h: enum class clang::MSVtorDispMode
ENUM_SYNC(CXMSVtorDispMode_Never, clang::MSVtorDispMode::Never);
ENUM_SYNC(CXMSVtorDispMode_ForVBaseOverride, clang::MSVtorDispMode::ForVBaseOverride);
ENUM_SYNC(CXMSVtorDispMode_ForVFTable, clang::MSVtorDispMode::ForVFTable);

// llvm/Support/MemoryBuffer.h: enum llvm::MemoryBuffer::BufferKind, returned by
// clang::SrcMgr::ContentCache::getMemoryBufferKind
ENUM_SYNC(CXBufferKind_MemoryBuffer_Malloc, llvm::MemoryBuffer::MemoryBuffer_Malloc);
ENUM_SYNC(CXBufferKind_MemoryBuffer_MMap, llvm::MemoryBuffer::MemoryBuffer_MMap);

// clang/Lex/MacroInfo.h: enum clang::MacroDirective::Kind
ENUM_SYNC(CXMacroDirectiveKind_MD_Define, clang::MacroDirective::MD_Define);
ENUM_SYNC(CXMacroDirectiveKind_MD_Undefine, clang::MacroDirective::MD_Undefine);
ENUM_SYNC(CXMacroDirectiveKind_MD_Visibility, clang::MacroDirective::MD_Visibility);

// clang/AST/Comment.h: enum class clang::comments::CommentKind
ENUM_SYNC(CXCommentKind_None, clang::comments::CommentKind::None);
ENUM_SYNC(CXCommentKind_VerbatimBlockLineComment,
          clang::comments::CommentKind::VerbatimBlockLineComment);
ENUM_SYNC(CXCommentKind_TextComment, clang::comments::CommentKind::TextComment);
ENUM_SYNC(CXCommentKind_InlineCommandComment,
          clang::comments::CommentKind::InlineCommandComment);
ENUM_SYNC(CXCommentKind_HTMLStartTagComment,
          clang::comments::CommentKind::HTMLStartTagComment);
ENUM_SYNC(CXCommentKind_HTMLEndTagComment, clang::comments::CommentKind::HTMLEndTagComment);
ENUM_SYNC(CXCommentKind_FullComment, clang::comments::CommentKind::FullComment);
ENUM_SYNC(CXCommentKind_ParagraphComment, clang::comments::CommentKind::ParagraphComment);
ENUM_SYNC(CXCommentKind_BlockCommandComment,
          clang::comments::CommentKind::BlockCommandComment);
ENUM_SYNC(CXCommentKind_VerbatimLineComment,
          clang::comments::CommentKind::VerbatimLineComment);
ENUM_SYNC(CXCommentKind_VerbatimBlockComment,
          clang::comments::CommentKind::VerbatimBlockComment);
ENUM_SYNC(CXCommentKind_TParamCommandComment,
          clang::comments::CommentKind::TParamCommandComment);
ENUM_SYNC(CXCommentKind_ParamCommandComment,
          clang::comments::CommentKind::ParamCommandComment);

// clang/AST/TemplateName.h: enum class clang::TemplateName::Qualified
ENUM_SYNC(CXTemplateName_Qualified_None, clang::TemplateName::Qualified::None);
ENUM_SYNC(CXTemplateName_Qualified_AsWritten, clang::TemplateName::Qualified::AsWritten);
ENUM_SYNC(CXTemplateName_Qualified_Fully, clang::TemplateName::Qualified::Fully);

// CXCaptureDiagsKind is synced in lib/Frontend/CXASTUnit.cpp instead: clang/Frontend/
// ASTUnit.h includes clang-c/Index.h, whose declarations collide with this library's own
// (clang_TargetInfo_getTriple, the CXLinkage enumerators, ...), so that header cannot be
// pulled into this file.

// clang/Basic/LangOptions.h: enum clang::LangOptions::MSVCMajorVersion
ENUM_SYNC(CXMSVCMajorVersion_MSVC2010, clang::LangOptions::MSVC2010);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2012, clang::LangOptions::MSVC2012);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2013, clang::LangOptions::MSVC2013);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2015, clang::LangOptions::MSVC2015);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2017, clang::LangOptions::MSVC2017);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2017_5, clang::LangOptions::MSVC2017_5);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2017_7, clang::LangOptions::MSVC2017_7);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2019, clang::LangOptions::MSVC2019);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2019_5, clang::LangOptions::MSVC2019_5);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2019_8, clang::LangOptions::MSVC2019_8);
ENUM_SYNC(CXMSVCMajorVersion_MSVC2022_3, clang::LangOptions::MSVC2022_3);

// clang/Basic/LangOptions.h: enum clang::LangOptions::FPExceptionModeKind
ENUM_SYNC(CXFPExceptionModeKind_FPE_Ignore, clang::LangOptions::FPE_Ignore);
ENUM_SYNC(CXFPExceptionModeKind_FPE_MayTrap, clang::LangOptions::FPE_MayTrap);
ENUM_SYNC(CXFPExceptionModeKind_FPE_Strict, clang::LangOptions::FPE_Strict);
ENUM_SYNC(CXFPExceptionModeKind_FPE_Default, clang::LangOptions::FPE_Default);

// llvm/ADT/FloatingPointMode.h: enum class llvm::RoundingMode : int8_t
ENUM_SYNC(CXRoundingMode_TowardZero, llvm::RoundingMode::TowardZero);
ENUM_SYNC(CXRoundingMode_NearestTiesToEven, llvm::RoundingMode::NearestTiesToEven);
ENUM_SYNC(CXRoundingMode_TowardPositive, llvm::RoundingMode::TowardPositive);
ENUM_SYNC(CXRoundingMode_TowardNegative, llvm::RoundingMode::TowardNegative);
ENUM_SYNC(CXRoundingMode_NearestTiesToAway, llvm::RoundingMode::NearestTiesToAway);
ENUM_SYNC(CXRoundingMode_Dynamic, llvm::RoundingMode::Dynamic);
ENUM_SYNC(CXRoundingMode_Invalid, llvm::RoundingMode::Invalid);

// clang/Lex/PreprocessingRecord.h: enum clang::PreprocessedEntity::EntityKind
ENUM_SYNC(CXPreprocessedEntityKind_InvalidKind, clang::PreprocessedEntity::InvalidKind);
ENUM_SYNC(CXPreprocessedEntityKind_MacroExpansionKind,
          clang::PreprocessedEntity::MacroExpansionKind);
ENUM_SYNC(CXPreprocessedEntityKind_MacroDefinitionKind,
          clang::PreprocessedEntity::MacroDefinitionKind);
ENUM_SYNC(CXPreprocessedEntityKind_InclusionDirectiveKind,
          clang::PreprocessedEntity::InclusionDirectiveKind);

// clang/Lex/PreprocessingRecord.h: enum clang::InclusionDirective::InclusionKind
ENUM_SYNC(CXInclusionKind_Include, clang::InclusionDirective::Include);
ENUM_SYNC(CXInclusionKind_Import, clang::InclusionDirective::Import);
ENUM_SYNC(CXInclusionKind_IncludeNext, clang::InclusionDirective::IncludeNext);
ENUM_SYNC(CXInclusionKind_IncludeMacros, clang::InclusionDirective::IncludeMacros);

// clang/Basic/Diagnostic.h: enum DiagnosticsEngine::ArgumentKind
ENUM_SYNC(CXDiagnosticsEngine_ak_std_string, clang::DiagnosticsEngine::ak_std_string);
ENUM_SYNC(CXDiagnosticsEngine_ak_c_string, clang::DiagnosticsEngine::ak_c_string);
ENUM_SYNC(CXDiagnosticsEngine_ak_sint, clang::DiagnosticsEngine::ak_sint);
ENUM_SYNC(CXDiagnosticsEngine_ak_uint, clang::DiagnosticsEngine::ak_uint);
ENUM_SYNC(CXDiagnosticsEngine_ak_tokenkind, clang::DiagnosticsEngine::ak_tokenkind);
ENUM_SYNC(CXDiagnosticsEngine_ak_identifierinfo,
          clang::DiagnosticsEngine::ak_identifierinfo);
ENUM_SYNC(CXDiagnosticsEngine_ak_addrspace, clang::DiagnosticsEngine::ak_addrspace);
ENUM_SYNC(CXDiagnosticsEngine_ak_qual, clang::DiagnosticsEngine::ak_qual);
ENUM_SYNC(CXDiagnosticsEngine_ak_qualtype, clang::DiagnosticsEngine::ak_qualtype);
ENUM_SYNC(CXDiagnosticsEngine_ak_declarationname,
          clang::DiagnosticsEngine::ak_declarationname);
ENUM_SYNC(CXDiagnosticsEngine_ak_nameddecl, clang::DiagnosticsEngine::ak_nameddecl);
ENUM_SYNC(CXDiagnosticsEngine_ak_nestednamespec,
          clang::DiagnosticsEngine::ak_nestednamespec);
ENUM_SYNC(CXDiagnosticsEngine_ak_declcontext, clang::DiagnosticsEngine::ak_declcontext);
ENUM_SYNC(CXDiagnosticsEngine_ak_qualtype_pair, clang::DiagnosticsEngine::ak_qualtype_pair);
ENUM_SYNC(CXDiagnosticsEngine_ak_attr, clang::DiagnosticsEngine::ak_attr);

// clang/Basic/IdentifierTable.h: enum ObjCMethodFamily
ENUM_SYNC(CXObjCMethodFamily_OMF_None, clang::OMF_None);
ENUM_SYNC(CXObjCMethodFamily_OMF_alloc, clang::OMF_alloc);
ENUM_SYNC(CXObjCMethodFamily_OMF_copy, clang::OMF_copy);
ENUM_SYNC(CXObjCMethodFamily_OMF_init, clang::OMF_init);
ENUM_SYNC(CXObjCMethodFamily_OMF_mutableCopy, clang::OMF_mutableCopy);
ENUM_SYNC(CXObjCMethodFamily_OMF_new, clang::OMF_new);
ENUM_SYNC(CXObjCMethodFamily_OMF_autorelease, clang::OMF_autorelease);
ENUM_SYNC(CXObjCMethodFamily_OMF_dealloc, clang::OMF_dealloc);
ENUM_SYNC(CXObjCMethodFamily_OMF_finalize, clang::OMF_finalize);
ENUM_SYNC(CXObjCMethodFamily_OMF_release, clang::OMF_release);
ENUM_SYNC(CXObjCMethodFamily_OMF_retain, clang::OMF_retain);
ENUM_SYNC(CXObjCMethodFamily_OMF_retainCount, clang::OMF_retainCount);
ENUM_SYNC(CXObjCMethodFamily_OMF_self, clang::OMF_self);
ENUM_SYNC(CXObjCMethodFamily_OMF_initialize, clang::OMF_initialize);
ENUM_SYNC(CXObjCMethodFamily_OMF_performSelector, clang::OMF_performSelector);

// clang/Basic/IdentifierTable.h: enum ObjCInstanceTypeFamily
ENUM_SYNC(CXObjCInstanceTypeFamily_OIT_None, clang::OIT_None);
ENUM_SYNC(CXObjCInstanceTypeFamily_OIT_Array, clang::OIT_Array);
ENUM_SYNC(CXObjCInstanceTypeFamily_OIT_Dictionary, clang::OIT_Dictionary);
ENUM_SYNC(CXObjCInstanceTypeFamily_OIT_Singleton, clang::OIT_Singleton);
ENUM_SYNC(CXObjCInstanceTypeFamily_OIT_Init, clang::OIT_Init);
ENUM_SYNC(CXObjCInstanceTypeFamily_OIT_ReturnsSelf, clang::OIT_ReturnsSelf);

// clang/Sema/Sema.h: enum Sema::CXXSpecialMember
ENUM_SYNC(CXCXXSpecialMember_CXXDefaultConstructor, clang::Sema::CXXDefaultConstructor);
ENUM_SYNC(CXCXXSpecialMember_CXXCopyConstructor, clang::Sema::CXXCopyConstructor);
ENUM_SYNC(CXCXXSpecialMember_CXXMoveConstructor, clang::Sema::CXXMoveConstructor);
ENUM_SYNC(CXCXXSpecialMember_CXXCopyAssignment, clang::Sema::CXXCopyAssignment);
ENUM_SYNC(CXCXXSpecialMember_CXXMoveAssignment, clang::Sema::CXXMoveAssignment);
ENUM_SYNC(CXCXXSpecialMember_CXXDestructor, clang::Sema::CXXDestructor);
ENUM_SYNC(CXCXXSpecialMember_CXXInvalid, clang::Sema::CXXInvalid);

// clang/Sema/Sema.h: enum Sema::SpecialMemberOverloadResult::Kind
ENUM_SYNC(CXSpecialMemberOverloadResultKind_NoMemberOrDeleted,
          clang::Sema::SpecialMemberOverloadResult::NoMemberOrDeleted);
ENUM_SYNC(CXSpecialMemberOverloadResultKind_Ambiguous,
          clang::Sema::SpecialMemberOverloadResult::Ambiguous);
ENUM_SYNC(CXSpecialMemberOverloadResultKind_Success,
          clang::Sema::SpecialMemberOverloadResult::Success);

// clang/Sema/Overload.h: enum BadConversionSequence::FailureKind
ENUM_SYNC(CXBadConversionSequence_no_conversion,
          clang::BadConversionSequence::no_conversion);
ENUM_SYNC(CXBadConversionSequence_unrelated_class,
          clang::BadConversionSequence::unrelated_class);
ENUM_SYNC(CXBadConversionSequence_bad_qualifiers,
          clang::BadConversionSequence::bad_qualifiers);
ENUM_SYNC(CXBadConversionSequence_lvalue_ref_to_rvalue,
          clang::BadConversionSequence::lvalue_ref_to_rvalue);
ENUM_SYNC(CXBadConversionSequence_rvalue_ref_to_lvalue,
          clang::BadConversionSequence::rvalue_ref_to_lvalue);
ENUM_SYNC(CXBadConversionSequence_too_few_initializers,
          clang::BadConversionSequence::too_few_initializers);
ENUM_SYNC(CXBadConversionSequence_too_many_initializers,
          clang::BadConversionSequence::too_many_initializers);

// clang/Sema/Overload.h: enum ImplicitConversionSequence::Kind
ENUM_SYNC(CXImplicitConversionSequence_StandardConversion,
          clang::ImplicitConversionSequence::StandardConversion);
ENUM_SYNC(CXImplicitConversionSequence_StaticObjectArgumentConversion,
          clang::ImplicitConversionSequence::StaticObjectArgumentConversion);
ENUM_SYNC(CXImplicitConversionSequence_UserDefinedConversion,
          clang::ImplicitConversionSequence::UserDefinedConversion);
ENUM_SYNC(CXImplicitConversionSequence_AmbiguousConversion,
          clang::ImplicitConversionSequence::AmbiguousConversion);
ENUM_SYNC(CXImplicitConversionSequence_EllipsisConversion,
          clang::ImplicitConversionSequence::EllipsisConversion);
ENUM_SYNC(CXImplicitConversionSequence_BadConversion,
          clang::ImplicitConversionSequence::BadConversion);

// clang/Sema/Overload.h: enum OverloadCandidateSet::CandidateSetKind
ENUM_SYNC(CXOverloadCandidateSet_CSK_Normal, clang::OverloadCandidateSet::CSK_Normal);
ENUM_SYNC(CXOverloadCandidateSet_CSK_Operator, clang::OverloadCandidateSet::CSK_Operator);
ENUM_SYNC(CXOverloadCandidateSet_CSK_InitByUserDefinedConversion,
          clang::OverloadCandidateSet::CSK_InitByUserDefinedConversion);
ENUM_SYNC(CXOverloadCandidateSet_CSK_InitByConstructor,
          clang::OverloadCandidateSet::CSK_InitByConstructor);

// clang/Sema/Template.h: enum class TemplateSubstitutionKind : char
ENUM_SYNC(CXTemplateSubstitutionKind_Specialization,
          clang::TemplateSubstitutionKind::Specialization);
ENUM_SYNC(CXTemplateSubstitutionKind_Rewrite, clang::TemplateSubstitutionKind::Rewrite);

// clang/Sema/Sema.h: enum class Sema::CheckConstexprKind
ENUM_SYNC(CXCheckConstexprKind_Diagnose, clang::Sema::CheckConstexprKind::Diagnose);
ENUM_SYNC(CXCheckConstexprKind_CheckValid, clang::Sema::CheckConstexprKind::CheckValid);

// clang/Sema/Sema.h: enum Sema::AssignConvertType
ENUM_SYNC(CXAssignConvertType_Compatible, clang::Sema::Compatible);
ENUM_SYNC(CXAssignConvertType_PointerToInt, clang::Sema::PointerToInt);
ENUM_SYNC(CXAssignConvertType_IntToPointer, clang::Sema::IntToPointer);
ENUM_SYNC(CXAssignConvertType_FunctionVoidPointer, clang::Sema::FunctionVoidPointer);
ENUM_SYNC(CXAssignConvertType_IncompatiblePointer, clang::Sema::IncompatiblePointer);
ENUM_SYNC(CXAssignConvertType_IncompatibleFunctionPointer,
          clang::Sema::IncompatibleFunctionPointer);
ENUM_SYNC(CXAssignConvertType_IncompatibleFunctionPointerStrict,
          clang::Sema::IncompatibleFunctionPointerStrict);
ENUM_SYNC(CXAssignConvertType_IncompatiblePointerSign,
          clang::Sema::IncompatiblePointerSign);
ENUM_SYNC(CXAssignConvertType_CompatiblePointerDiscardsQualifiers,
          clang::Sema::CompatiblePointerDiscardsQualifiers);
ENUM_SYNC(CXAssignConvertType_IncompatiblePointerDiscardsQualifiers,
          clang::Sema::IncompatiblePointerDiscardsQualifiers);
ENUM_SYNC(CXAssignConvertType_IncompatibleNestedPointerAddressSpaceMismatch,
          clang::Sema::IncompatibleNestedPointerAddressSpaceMismatch);
ENUM_SYNC(CXAssignConvertType_IncompatibleNestedPointerQualifiers,
          clang::Sema::IncompatibleNestedPointerQualifiers);
ENUM_SYNC(CXAssignConvertType_IncompatibleVectors, clang::Sema::IncompatibleVectors);
ENUM_SYNC(CXAssignConvertType_IntToBlockPointer, clang::Sema::IntToBlockPointer);
ENUM_SYNC(CXAssignConvertType_IncompatibleBlockPointer,
          clang::Sema::IncompatibleBlockPointer);
ENUM_SYNC(CXAssignConvertType_IncompatibleObjCQualifiedId,
          clang::Sema::IncompatibleObjCQualifiedId);
ENUM_SYNC(CXAssignConvertType_IncompatibleObjCWeakRef,
          clang::Sema::IncompatibleObjCWeakRef);
ENUM_SYNC(CXAssignConvertType_Incompatible, clang::Sema::Incompatible);

// clang/Sema/Sema.h: enum Sema::AllowFoldKind
ENUM_SYNC(CXAllowFoldKind_NoFold, clang::Sema::NoFold);
ENUM_SYNC(CXAllowFoldKind_AllowFold, clang::Sema::AllowFold);

// clang/Sema/Sema.h: enum Sema::AssignmentAction
ENUM_SYNC(CXAssignmentAction_AA_Assigning, clang::Sema::AA_Assigning);
ENUM_SYNC(CXAssignmentAction_AA_Passing, clang::Sema::AA_Passing);
ENUM_SYNC(CXAssignmentAction_AA_Returning, clang::Sema::AA_Returning);
ENUM_SYNC(CXAssignmentAction_AA_Converting, clang::Sema::AA_Converting);
ENUM_SYNC(CXAssignmentAction_AA_Initializing, clang::Sema::AA_Initializing);
ENUM_SYNC(CXAssignmentAction_AA_Sending, clang::Sema::AA_Sending);
ENUM_SYNC(CXAssignmentAction_AA_Casting, clang::Sema::AA_Casting);
ENUM_SYNC(CXAssignmentAction_AA_Passing_CFAudited, clang::Sema::AA_Passing_CFAudited);

// clang/Sema/Sema.h: enum Sema::CheckedConversionKind
ENUM_SYNC(CXCheckedConversionKind_CCK_ImplicitConversion,
          clang::Sema::CCK_ImplicitConversion);
ENUM_SYNC(CXCheckedConversionKind_CCK_CStyleCast, clang::Sema::CCK_CStyleCast);
ENUM_SYNC(CXCheckedConversionKind_CCK_FunctionalCast, clang::Sema::CCK_FunctionalCast);
ENUM_SYNC(CXCheckedConversionKind_CCK_OtherCast, clang::Sema::CCK_OtherCast);
ENUM_SYNC(CXCheckedConversionKind_CCK_ForBuiltinOverloadedOp,
          clang::Sema::CCK_ForBuiltinOverloadedOp);

// clang/Sema/Sema.h: enum Sema::ReferenceCompareResult
ENUM_SYNC(CXReferenceCompareResult_Ref_Incompatible, clang::Sema::Ref_Incompatible);
ENUM_SYNC(CXReferenceCompareResult_Ref_Related, clang::Sema::Ref_Related);
ENUM_SYNC(CXReferenceCompareResult_Ref_Compatible, clang::Sema::Ref_Compatible);

// clang/Sema/Sema.h: enum Sema::ReferenceConversionsScope::ReferenceConversions
// (the LLVM_MARK_AS_BITMASK_ENUM alias enumerator is omitted)
ENUM_SYNC(CXReferenceConversions_Qualification,
          clang::Sema::ReferenceConversionsScope::Qualification);
ENUM_SYNC(CXReferenceConversions_NestedQualification,
          clang::Sema::ReferenceConversionsScope::NestedQualification);
ENUM_SYNC(CXReferenceConversions_Function,
          clang::Sema::ReferenceConversionsScope::Function);
ENUM_SYNC(CXReferenceConversions_DerivedToBase,
          clang::Sema::ReferenceConversionsScope::DerivedToBase);
ENUM_SYNC(CXReferenceConversions_ObjC, clang::Sema::ReferenceConversionsScope::ObjC);
ENUM_SYNC(CXReferenceConversions_ObjCLifetime,
          clang::Sema::ReferenceConversionsScope::ObjCLifetime);

// clang/Sema/Overload.h: enum ImplicitConversionRank
ENUM_SYNC(CXImplicitConversionRank_ICR_Exact_Match, clang::ICR_Exact_Match);
ENUM_SYNC(CXImplicitConversionRank_ICR_Promotion, clang::ICR_Promotion);
ENUM_SYNC(CXImplicitConversionRank_ICR_Conversion, clang::ICR_Conversion);
ENUM_SYNC(CXImplicitConversionRank_ICR_OCL_Scalar_Widening, clang::ICR_OCL_Scalar_Widening);
ENUM_SYNC(CXImplicitConversionRank_ICR_Complex_Real_Conversion,
          clang::ICR_Complex_Real_Conversion);
ENUM_SYNC(CXImplicitConversionRank_ICR_Writeback_Conversion,
          clang::ICR_Writeback_Conversion);
ENUM_SYNC(CXImplicitConversionRank_ICR_C_Conversion, clang::ICR_C_Conversion);
ENUM_SYNC(CXImplicitConversionRank_ICR_C_Conversion_Extension,
          clang::ICR_C_Conversion_Extension);

// clang/Sema/Sema.h: enum Sema::VarArgKind
ENUM_SYNC(CXVarArgKind_VAK_Valid, clang::Sema::VAK_Valid);
ENUM_SYNC(CXVarArgKind_VAK_ValidInCXX11, clang::Sema::VAK_ValidInCXX11);
ENUM_SYNC(CXVarArgKind_VAK_Undefined, clang::Sema::VAK_Undefined);
ENUM_SYNC(CXVarArgKind_VAK_MSVCUndefined, clang::Sema::VAK_MSVCUndefined);
ENUM_SYNC(CXVarArgKind_VAK_Invalid, clang::Sema::VAK_Invalid);

// clang/Sema/Sema.h: enum Sema::CCEKind
ENUM_SYNC(CXCCEKind_CCEK_CaseValue, clang::Sema::CCEK_CaseValue);
ENUM_SYNC(CXCCEKind_CCEK_Enumerator, clang::Sema::CCEK_Enumerator);
ENUM_SYNC(CXCCEKind_CCEK_TemplateArg, clang::Sema::CCEK_TemplateArg);
ENUM_SYNC(CXCCEKind_CCEK_ArrayBound, clang::Sema::CCEK_ArrayBound);
ENUM_SYNC(CXCCEKind_CCEK_ExplicitBool, clang::Sema::CCEK_ExplicitBool);
ENUM_SYNC(CXCCEKind_CCEK_Noexcept, clang::Sema::CCEK_Noexcept);
ENUM_SYNC(CXCCEKind_CCEK_StaticAssertMessageSize,
          clang::Sema::CCEK_StaticAssertMessageSize);
ENUM_SYNC(CXCCEKind_CCEK_StaticAssertMessageData,
          clang::Sema::CCEK_StaticAssertMessageData);

ENUM_SYNC(CXAllowedExplicit_None, clang::Sema::AllowedExplicit::None);
ENUM_SYNC(CXAllowedExplicit_Conversions, clang::Sema::AllowedExplicit::Conversions);
ENUM_SYNC(CXAllowedExplicit_All, clang::Sema::AllowedExplicit::All);

ENUM_SYNC(CXObjCLiteralKind_LK_Array, clang::Sema::LK_Array);
ENUM_SYNC(CXObjCLiteralKind_LK_Dictionary, clang::Sema::LK_Dictionary);
ENUM_SYNC(CXObjCLiteralKind_LK_Numeric, clang::Sema::LK_Numeric);
ENUM_SYNC(CXObjCLiteralKind_LK_Boxed, clang::Sema::LK_Boxed);
ENUM_SYNC(CXObjCLiteralKind_LK_String, clang::Sema::LK_String);
ENUM_SYNC(CXObjCLiteralKind_LK_Block, clang::Sema::LK_Block);
ENUM_SYNC(CXObjCLiteralKind_LK_None, clang::Sema::LK_None);

// clang/Sema/Sema.h: enum Sema::TemplateParameterListEqualKind
ENUM_SYNC(CXTemplateParameterListEqualKind_TPL_TemplateMatch,
          clang::Sema::TPL_TemplateMatch);
ENUM_SYNC(CXTemplateParameterListEqualKind_TPL_TemplateTemplateParmMatch,
          clang::Sema::TPL_TemplateTemplateParmMatch);
ENUM_SYNC(CXTemplateParameterListEqualKind_TPL_TemplateTemplateArgumentMatch,
          clang::Sema::TPL_TemplateTemplateArgumentMatch);
ENUM_SYNC(CXTemplateParameterListEqualKind_TPL_TemplateParamsEquivalent,
          clang::Sema::TPL_TemplateParamsEquivalent);

// clang/Sema/Sema.h: enum Sema::TemplateDeductionResult
ENUM_SYNC(CXTemplateDeductionResult_TDK_Success, clang::Sema::TDK_Success);
ENUM_SYNC(CXTemplateDeductionResult_TDK_Invalid, clang::Sema::TDK_Invalid);
ENUM_SYNC(CXTemplateDeductionResult_TDK_InstantiationDepth,
          clang::Sema::TDK_InstantiationDepth);
ENUM_SYNC(CXTemplateDeductionResult_TDK_Incomplete, clang::Sema::TDK_Incomplete);
ENUM_SYNC(CXTemplateDeductionResult_TDK_IncompletePack, clang::Sema::TDK_IncompletePack);
ENUM_SYNC(CXTemplateDeductionResult_TDK_Inconsistent, clang::Sema::TDK_Inconsistent);
ENUM_SYNC(CXTemplateDeductionResult_TDK_Underqualified, clang::Sema::TDK_Underqualified);
ENUM_SYNC(CXTemplateDeductionResult_TDK_SubstitutionFailure,
          clang::Sema::TDK_SubstitutionFailure);
ENUM_SYNC(CXTemplateDeductionResult_TDK_DeducedMismatch, clang::Sema::TDK_DeducedMismatch);
ENUM_SYNC(CXTemplateDeductionResult_TDK_DeducedMismatchNested,
          clang::Sema::TDK_DeducedMismatchNested);
ENUM_SYNC(CXTemplateDeductionResult_TDK_NonDeducedMismatch,
          clang::Sema::TDK_NonDeducedMismatch);
ENUM_SYNC(CXTemplateDeductionResult_TDK_TooManyArguments,
          clang::Sema::TDK_TooManyArguments);
ENUM_SYNC(CXTemplateDeductionResult_TDK_TooFewArguments, clang::Sema::TDK_TooFewArguments);
ENUM_SYNC(CXTemplateDeductionResult_TDK_InvalidExplicitArguments,
          clang::Sema::TDK_InvalidExplicitArguments);
ENUM_SYNC(CXTemplateDeductionResult_TDK_NonDependentConversionFailure,
          clang::Sema::TDK_NonDependentConversionFailure);
ENUM_SYNC(CXTemplateDeductionResult_TDK_ConstraintsNotSatisfied,
          clang::Sema::TDK_ConstraintsNotSatisfied);
ENUM_SYNC(CXTemplateDeductionResult_TDK_MiscellaneousDeductionFailure,
          clang::Sema::TDK_MiscellaneousDeductionFailure);
ENUM_SYNC(CXTemplateDeductionResult_TDK_CUDATargetMismatch,
          clang::Sema::TDK_CUDATargetMismatch);
ENUM_SYNC(CXTemplateDeductionResult_TDK_AlreadyDiagnosed,
          clang::Sema::TDK_AlreadyDiagnosed);

// clang/Sema/Sema.h: enum class Sema::ConditionKind
ENUM_SYNC(CXConditionKind_Boolean, clang::Sema::ConditionKind::Boolean);
ENUM_SYNC(CXConditionKind_ConstexprIf, clang::Sema::ConditionKind::ConstexprIf);
ENUM_SYNC(CXConditionKind_Switch, clang::Sema::ConditionKind::Switch);

// clang/Sema/Sema.h: enum Sema::FormatStringType
ENUM_SYNC(CXFormatStringType_FST_Scanf, clang::Sema::FST_Scanf);
ENUM_SYNC(CXFormatStringType_FST_Printf, clang::Sema::FST_Printf);
ENUM_SYNC(CXFormatStringType_FST_NSString, clang::Sema::FST_NSString);
ENUM_SYNC(CXFormatStringType_FST_Strftime, clang::Sema::FST_Strftime);
ENUM_SYNC(CXFormatStringType_FST_Strfmon, clang::Sema::FST_Strfmon);
ENUM_SYNC(CXFormatStringType_FST_Kprintf, clang::Sema::FST_Kprintf);
ENUM_SYNC(CXFormatStringType_FST_FreeBSDKPrintf, clang::Sema::FST_FreeBSDKPrintf);
ENUM_SYNC(CXFormatStringType_FST_OSTrace, clang::Sema::FST_OSTrace);
ENUM_SYNC(CXFormatStringType_FST_OSLog, clang::Sema::FST_OSLog);
ENUM_SYNC(CXFormatStringType_FST_Unknown, clang::Sema::FST_Unknown);

// clang/Sema/Overload.h: enum OverloadCandidateRewriteKind
ENUM_SYNC(CXOverloadCandidateRewriteKind_CRK_None, clang::CRK_None);
ENUM_SYNC(CXOverloadCandidateRewriteKind_CRK_DifferentOperator,
          clang::CRK_DifferentOperator);
ENUM_SYNC(CXOverloadCandidateRewriteKind_CRK_Reversed, clang::CRK_Reversed);

// clang/Sema/Sema.h: enum class Sema::FunctionEmissionStatus
ENUM_SYNC(CXFunctionEmissionStatus_Emitted, clang::Sema::FunctionEmissionStatus::Emitted);
ENUM_SYNC(CXFunctionEmissionStatus_CUDADiscarded,
          clang::Sema::FunctionEmissionStatus::CUDADiscarded);
ENUM_SYNC(CXFunctionEmissionStatus_OMPDiscarded,
          clang::Sema::FunctionEmissionStatus::OMPDiscarded);
ENUM_SYNC(CXFunctionEmissionStatus_TemplateDiscarded,
          clang::Sema::FunctionEmissionStatus::TemplateDiscarded);
ENUM_SYNC(CXFunctionEmissionStatus_Unknown, clang::Sema::FunctionEmissionStatus::Unknown);

// clang/Sema/Sema.h: enum Sema::VariadicCallType
ENUM_SYNC(CXVariadicCallType_VariadicFunction, clang::Sema::VariadicFunction);
ENUM_SYNC(CXVariadicCallType_VariadicBlock, clang::Sema::VariadicBlock);
ENUM_SYNC(CXVariadicCallType_VariadicMethod, clang::Sema::VariadicMethod);
ENUM_SYNC(CXVariadicCallType_VariadicConstructor, clang::Sema::VariadicConstructor);
ENUM_SYNC(CXVariadicCallType_VariadicDoesNotApply, clang::Sema::VariadicDoesNotApply);

// clang/Sema/Sema.h: enum Sema::ArithConvKind
ENUM_SYNC(CXArithConvKind_ACK_Arithmetic, clang::Sema::ACK_Arithmetic);
ENUM_SYNC(CXArithConvKind_ACK_BitwiseOp, clang::Sema::ACK_BitwiseOp);
ENUM_SYNC(CXArithConvKind_ACK_Comparison, clang::Sema::ACK_Comparison);
ENUM_SYNC(CXArithConvKind_ACK_Conditional, clang::Sema::ACK_Conditional);
ENUM_SYNC(CXArithConvKind_ACK_CompAssign, clang::Sema::ACK_CompAssign);

// clang/Sema/Sema.h: enum Sema::TrivialABIHandling
ENUM_SYNC(CXTrivialABIHandling_TAH_IgnoreTrivialABI, clang::Sema::TAH_IgnoreTrivialABI);
ENUM_SYNC(CXTrivialABIHandling_TAH_ConsiderTrivialABI, clang::Sema::TAH_ConsiderTrivialABI);

// clang/Sema/Overload.h: enum NarrowingKind
ENUM_SYNC(CXNarrowingKind_NK_Not_Narrowing, clang::NK_Not_Narrowing);
ENUM_SYNC(CXNarrowingKind_NK_Type_Narrowing, clang::NK_Type_Narrowing);
ENUM_SYNC(CXNarrowingKind_NK_Constant_Narrowing, clang::NK_Constant_Narrowing);
ENUM_SYNC(CXNarrowingKind_NK_Variable_Narrowing, clang::NK_Variable_Narrowing);
ENUM_SYNC(CXNarrowingKind_NK_Dependent_Narrowing, clang::NK_Dependent_Narrowing);

// clang/Sema/Sema.h: enum Sema::AllocationFunctionScope
ENUM_SYNC(CXAllocationFunctionScope_AFS_Global, clang::Sema::AFS_Global);
ENUM_SYNC(CXAllocationFunctionScope_AFS_Class, clang::Sema::AFS_Class);
ENUM_SYNC(CXAllocationFunctionScope_AFS_Both, clang::Sema::AFS_Both);

// clang/Sema/Sema.h: enum class Sema::FnBodyKind
ENUM_SYNC(CXFnBodyKind_Other, clang::Sema::FnBodyKind::Other);
ENUM_SYNC(CXFnBodyKind_Default, clang::Sema::FnBodyKind::Default);
ENUM_SYNC(CXFnBodyKind_Delete, clang::Sema::FnBodyKind::Delete);

// clang/Sema/Sema.h: enum class Sema::ExpressionEvaluationContext
ENUM_SYNC(CXExpressionEvaluationContext_Unevaluated,
          clang::Sema::ExpressionEvaluationContext::Unevaluated);
ENUM_SYNC(CXExpressionEvaluationContext_UnevaluatedList,
          clang::Sema::ExpressionEvaluationContext::UnevaluatedList);
ENUM_SYNC(CXExpressionEvaluationContext_DiscardedStatement,
          clang::Sema::ExpressionEvaluationContext::DiscardedStatement);
ENUM_SYNC(CXExpressionEvaluationContext_UnevaluatedAbstract,
          clang::Sema::ExpressionEvaluationContext::UnevaluatedAbstract);
ENUM_SYNC(CXExpressionEvaluationContext_ConstantEvaluated,
          clang::Sema::ExpressionEvaluationContext::ConstantEvaluated);
ENUM_SYNC(CXExpressionEvaluationContext_ImmediateFunctionContext,
          clang::Sema::ExpressionEvaluationContext::ImmediateFunctionContext);
ENUM_SYNC(CXExpressionEvaluationContext_PotentiallyEvaluated,
          clang::Sema::ExpressionEvaluationContext::PotentiallyEvaluated);
ENUM_SYNC(CXExpressionEvaluationContext_PotentiallyEvaluatedIfUsed,
          clang::Sema::ExpressionEvaluationContext::PotentiallyEvaluatedIfUsed);

// clang/Sema/Sema.h: enum Sema::ExpressionEvaluationContextRecord::ExpressionKind
ENUM_SYNC(CXExpressionKind_EK_Decltype,
          clang::Sema::ExpressionEvaluationContextRecord::EK_Decltype);
ENUM_SYNC(CXExpressionKind_EK_TemplateArgument,
          clang::Sema::ExpressionEvaluationContextRecord::EK_TemplateArgument);
ENUM_SYNC(CXExpressionKind_EK_Other,
          clang::Sema::ExpressionEvaluationContextRecord::EK_Other);

// clang/Sema/Sema.h: enum Sema::CUDAFunctionTarget
ENUM_SYNC(CXCUDAFunctionTarget_CFT_Device, clang::Sema::CFT_Device);
ENUM_SYNC(CXCUDAFunctionTarget_CFT_Global, clang::Sema::CFT_Global);
ENUM_SYNC(CXCUDAFunctionTarget_CFT_Host, clang::Sema::CFT_Host);
ENUM_SYNC(CXCUDAFunctionTarget_CFT_HostDevice, clang::Sema::CFT_HostDevice);
ENUM_SYNC(CXCUDAFunctionTarget_CFT_InvalidTarget, clang::Sema::CFT_InvalidTarget);

// clang/Sema/Sema.h: enum Sema::CUDAFunctionPreference
ENUM_SYNC(CXCUDAFunctionPreference_CFP_Never, clang::Sema::CFP_Never);
ENUM_SYNC(CXCUDAFunctionPreference_CFP_WrongSide, clang::Sema::CFP_WrongSide);
ENUM_SYNC(CXCUDAFunctionPreference_CFP_HostDevice, clang::Sema::CFP_HostDevice);
ENUM_SYNC(CXCUDAFunctionPreference_CFP_SameSide, clang::Sema::CFP_SameSide);
ENUM_SYNC(CXCUDAFunctionPreference_CFP_Native, clang::Sema::CFP_Native);

// clang/Sema/Overload.h: enum OverloadingResult
ENUM_SYNC(CXOverloadingResult_OR_Success, clang::OR_Success);
ENUM_SYNC(CXOverloadingResult_OR_No_Viable_Function, clang::OR_No_Viable_Function);
ENUM_SYNC(CXOverloadingResult_OR_Ambiguous, clang::OR_Ambiguous);
ENUM_SYNC(CXOverloadingResult_OR_Deleted, clang::OR_Deleted);

// clang/Sema/Sema.h: enum Sema::AlignPackInfo::Mode
ENUM_SYNC(CXAlignPackInfo_Native, clang::Sema::AlignPackInfo::Native);
ENUM_SYNC(CXAlignPackInfo_Natural, clang::Sema::AlignPackInfo::Natural);
ENUM_SYNC(CXAlignPackInfo_Packed, clang::Sema::AlignPackInfo::Packed);
ENUM_SYNC(CXAlignPackInfo_Mac68k, clang::Sema::AlignPackInfo::Mac68k);

// clang/Sema/Sema.h: enum class Sema::DefaultedComparisonKind
ENUM_SYNC(CXDefaultedComparisonKind_None, clang::Sema::DefaultedComparisonKind::None);
ENUM_SYNC(CXDefaultedComparisonKind_Equal, clang::Sema::DefaultedComparisonKind::Equal);
ENUM_SYNC(CXDefaultedComparisonKind_ThreeWay,
          clang::Sema::DefaultedComparisonKind::ThreeWay);
ENUM_SYNC(CXDefaultedComparisonKind_NotEqual,
          clang::Sema::DefaultedComparisonKind::NotEqual);
ENUM_SYNC(CXDefaultedComparisonKind_Relational,
          clang::Sema::DefaultedComparisonKind::Relational);

// clang/Sema/Sema.h: enum class Sema::TemplateNameKindForDiagnostics
ENUM_SYNC(CXTemplateNameKindForDiagnostics_ClassTemplate,
          clang::Sema::TemplateNameKindForDiagnostics::ClassTemplate);
ENUM_SYNC(CXTemplateNameKindForDiagnostics_FunctionTemplate,
          clang::Sema::TemplateNameKindForDiagnostics::FunctionTemplate);
ENUM_SYNC(CXTemplateNameKindForDiagnostics_VarTemplate,
          clang::Sema::TemplateNameKindForDiagnostics::VarTemplate);
ENUM_SYNC(CXTemplateNameKindForDiagnostics_AliasTemplate,
          clang::Sema::TemplateNameKindForDiagnostics::AliasTemplate);
ENUM_SYNC(CXTemplateNameKindForDiagnostics_TemplateTemplateParam,
          clang::Sema::TemplateNameKindForDiagnostics::TemplateTemplateParam);
ENUM_SYNC(CXTemplateNameKindForDiagnostics_Concept,
          clang::Sema::TemplateNameKindForDiagnostics::Concept);
ENUM_SYNC(CXTemplateNameKindForDiagnostics_DependentTemplate,
          clang::Sema::TemplateNameKindForDiagnostics::DependentTemplate);

// clang/Sema/Sema.h: enum Sema::NonTagKind
ENUM_SYNC(CXNonTagKind_NTK_NonStruct, clang::Sema::NTK_NonStruct);
ENUM_SYNC(CXNonTagKind_NTK_NonClass, clang::Sema::NTK_NonClass);
ENUM_SYNC(CXNonTagKind_NTK_NonUnion, clang::Sema::NTK_NonUnion);
ENUM_SYNC(CXNonTagKind_NTK_NonEnum, clang::Sema::NTK_NonEnum);
ENUM_SYNC(CXNonTagKind_NTK_Typedef, clang::Sema::NTK_Typedef);
ENUM_SYNC(CXNonTagKind_NTK_TypeAlias, clang::Sema::NTK_TypeAlias);
ENUM_SYNC(CXNonTagKind_NTK_Template, clang::Sema::NTK_Template);
ENUM_SYNC(CXNonTagKind_NTK_TypeAliasTemplate, clang::Sema::NTK_TypeAliasTemplate);
ENUM_SYNC(CXNonTagKind_NTK_TemplateTemplateArgument,
          clang::Sema::NTK_TemplateTemplateArgument);

// clang/Sema/Sema.h: enum Sema::AccessResult
ENUM_SYNC(CXAccessResult_AR_accessible, clang::Sema::AR_accessible);
ENUM_SYNC(CXAccessResult_AR_inaccessible, clang::Sema::AR_inaccessible);
ENUM_SYNC(CXAccessResult_AR_dependent, clang::Sema::AR_dependent);
ENUM_SYNC(CXAccessResult_AR_delayed, clang::Sema::AR_delayed);

// clang/Sema/Overload.h: enum OverloadCandidateDisplayKind
ENUM_SYNC(CXOverloadCandidateDisplayKind_OCD_AllCandidates, clang::OCD_AllCandidates);
ENUM_SYNC(CXOverloadCandidateDisplayKind_OCD_ViableCandidates, clang::OCD_ViableCandidates);
ENUM_SYNC(CXOverloadCandidateDisplayKind_OCD_AmbiguousCandidates,
          clang::OCD_AmbiguousCandidates);

// clang/Sema/Scope.h: enum Scope::ScopeFlags
ENUM_SYNC(CXScopeFlags_FnScope, clang::Scope::FnScope);
ENUM_SYNC(CXScopeFlags_BreakScope, clang::Scope::BreakScope);
ENUM_SYNC(CXScopeFlags_ContinueScope, clang::Scope::ContinueScope);
ENUM_SYNC(CXScopeFlags_DeclScope, clang::Scope::DeclScope);
ENUM_SYNC(CXScopeFlags_ControlScope, clang::Scope::ControlScope);
ENUM_SYNC(CXScopeFlags_ClassScope, clang::Scope::ClassScope);
ENUM_SYNC(CXScopeFlags_BlockScope, clang::Scope::BlockScope);
ENUM_SYNC(CXScopeFlags_TemplateParamScope, clang::Scope::TemplateParamScope);
ENUM_SYNC(CXScopeFlags_FunctionPrototypeScope, clang::Scope::FunctionPrototypeScope);
ENUM_SYNC(CXScopeFlags_FunctionDeclarationScope, clang::Scope::FunctionDeclarationScope);
ENUM_SYNC(CXScopeFlags_AtCatchScope, clang::Scope::AtCatchScope);
ENUM_SYNC(CXScopeFlags_ObjCMethodScope, clang::Scope::ObjCMethodScope);
ENUM_SYNC(CXScopeFlags_SwitchScope, clang::Scope::SwitchScope);
ENUM_SYNC(CXScopeFlags_TryScope, clang::Scope::TryScope);
ENUM_SYNC(CXScopeFlags_FnTryCatchScope, clang::Scope::FnTryCatchScope);
ENUM_SYNC(CXScopeFlags_OpenMPDirectiveScope, clang::Scope::OpenMPDirectiveScope);
ENUM_SYNC(CXScopeFlags_OpenMPLoopDirectiveScope, clang::Scope::OpenMPLoopDirectiveScope);
ENUM_SYNC(CXScopeFlags_OpenMPSimdDirectiveScope, clang::Scope::OpenMPSimdDirectiveScope);
ENUM_SYNC(CXScopeFlags_EnumScope, clang::Scope::EnumScope);
ENUM_SYNC(CXScopeFlags_SEHTryScope, clang::Scope::SEHTryScope);
ENUM_SYNC(CXScopeFlags_SEHExceptScope, clang::Scope::SEHExceptScope);
ENUM_SYNC(CXScopeFlags_SEHFilterScope, clang::Scope::SEHFilterScope);
ENUM_SYNC(CXScopeFlags_CompoundStmtScope, clang::Scope::CompoundStmtScope);
ENUM_SYNC(CXScopeFlags_ClassInheritanceScope, clang::Scope::ClassInheritanceScope);
ENUM_SYNC(CXScopeFlags_CatchScope, clang::Scope::CatchScope);
ENUM_SYNC(CXScopeFlags_ConditionVarScope, clang::Scope::ConditionVarScope);
ENUM_SYNC(CXScopeFlags_OpenMPOrderClauseScope, clang::Scope::OpenMPOrderClauseScope);
ENUM_SYNC(CXScopeFlags_LambdaScope, clang::Scope::LambdaScope);

ENUM_SYNC(CXTPOC_TPOC_Call, clang::TPOC_Call);
ENUM_SYNC(CXTPOC_TPOC_Conversion, clang::TPOC_Conversion);
ENUM_SYNC(CXTPOC_TPOC_Other, clang::TPOC_Other);

ENUM_SYNC(CXFormatArgumentPassingKind_FAPK_Fixed, clang::Sema::FAPK_Fixed);
ENUM_SYNC(CXFormatArgumentPassingKind_FAPK_Variadic, clang::Sema::FAPK_Variadic);
ENUM_SYNC(CXFormatArgumentPassingKind_FAPK_VAList, clang::Sema::FAPK_VAList);

// clang/Driver/Driver.h: enum clang::driver::ModuleHeaderMode
ENUM_SYNC(CXModuleHeaderMode_HeaderMode_None, clang::driver::HeaderMode_None);
ENUM_SYNC(CXModuleHeaderMode_HeaderMode_Default, clang::driver::HeaderMode_Default);
ENUM_SYNC(CXModuleHeaderMode_HeaderMode_User, clang::driver::HeaderMode_User);
ENUM_SYNC(CXModuleHeaderMode_HeaderMode_System, clang::driver::HeaderMode_System);

// clang/AST/ASTTypeTraits.h: enum TraversalKind
ENUM_SYNC(CXTraversalKind_TK_AsIs, clang::TK_AsIs);
ENUM_SYNC(CXTraversalKind_TK_IgnoreUnlessSpelledInSource,
          clang::TK_IgnoreUnlessSpelledInSource);

// clang/Lex/ModuleMap.h: enum clang::ModuleMap::ModuleHeaderRole
ENUM_SYNC(CXModuleHeaderRole_NormalHeader, clang::ModuleMap::NormalHeader);
ENUM_SYNC(CXModuleHeaderRole_PrivateHeader, clang::ModuleMap::PrivateHeader);
ENUM_SYNC(CXModuleHeaderRole_TextualHeader, clang::ModuleMap::TextualHeader);
ENUM_SYNC(CXModuleHeaderRole_ExcludedHeader, clang::ModuleMap::ExcludedHeader);

// clang/Lex/Preprocessor.h: enum clang::MacroUse
ENUM_SYNC(CXMacroUse_MU_Other, clang::MU_Other);
ENUM_SYNC(CXMacroUse_MU_Define, clang::MU_Define);
ENUM_SYNC(CXMacroUse_MU_Undef, clang::MU_Undef);

// clang/Lex/PreprocessorOptions.h: enum class DisableValidationForModuleKind
ENUM_SYNC(CXDisableValidationForModuleKind_None, clang::DisableValidationForModuleKind::None);
ENUM_SYNC(CXDisableValidationForModuleKind_PCH, clang::DisableValidationForModuleKind::PCH);
ENUM_SYNC(CXDisableValidationForModuleKind_Module,
          clang::DisableValidationForModuleKind::Module);
ENUM_SYNC(CXDisableValidationForModuleKind_All, clang::DisableValidationForModuleKind::All);

// clang/Sema/Sema.h: enum clang::Sema::NamedReturnInfo::Status
ENUM_SYNC(CXNamedReturnInfo_None, clang::Sema::NamedReturnInfo::None);
ENUM_SYNC(CXNamedReturnInfo_MoveEligible, clang::Sema::NamedReturnInfo::MoveEligible);
ENUM_SYNC(CXNamedReturnInfo_MoveEligibleAndCopyElidable,
          clang::Sema::NamedReturnInfo::MoveEligibleAndCopyElidable);

#undef ENUM_SYNC
