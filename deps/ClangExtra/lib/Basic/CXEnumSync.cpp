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

#include "clang/AST/APValue.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/OperationKinds.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/Linkage.h"
#include "clang/Basic/Specifiers.h"
#include "clang/Basic/Visibility.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/DeclBase.h"
#include "clang/Basic/Lambda.h"
#include "clang/Basic/ExceptionSpecificationType.h"
#include "clang/Basic/TypeTraits.h"

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

#undef ENUM_SYNC
