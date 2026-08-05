#ifndef LLVM_CLANG_C_EXTRA_CXEXPR_H
#define LLVM_CLANG_C_EXTRA_CXEXPR_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXOperatorKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXTypeTraits.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"
#include "clang-ex/AST/CXAPValue.h"
#include "clang-ex/Basic/CXLangOptions.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Expr::Classification
// A CXClassification is owned: clang::Expr::Classification is a by-value pair of
// small enums with no pointer form, so it is heap-boxed here and every function
// returning one pairs with clang_Classification_dispose. The box also carries the
// flag recording whether modifiability was tested — the class keeps that state in a
// private member only clang::Expr may read, and getModifiable() asserts on it, so the
// flag is the only way the Julia layer can observe the precondition
// (MARSHALLING.md §13).

// mirrors clang::Expr::Classification::Kinds (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXClassification_Kinds {
  CXClassification_CL_LValue,
  CXClassification_CL_XValue,
  CXClassification_CL_Function,
  CXClassification_CL_Void,
  CXClassification_CL_AddressableVoid,
  CXClassification_CL_DuplicateVectorComponents,
  CXClassification_CL_MemberFunction,
  CXClassification_CL_SubObjCPropertySetting,
  CXClassification_CL_ClassTemporary,
  CXClassification_CL_ArrayTemporary,
  CXClassification_CL_ObjCMessageRValue,
  CXClassification_CL_PRValue
} CXClassification_Kinds;

// mirrors clang::Expr::Classification::ModifiableType (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXClassification_ModifiableType {
  CXClassification_CM_Untested,
  CXClassification_CM_Modifiable,
  CXClassification_CM_RValue,
  CXClassification_CM_Function,
  CXClassification_CM_LValueCast,
  CXClassification_CM_NoSetterProperty,
  CXClassification_CM_ConstQualified,
  CXClassification_CM_ConstQualifiedField,
  CXClassification_CM_ConstAddrSpace,
  CXClassification_CM_ArrayType,
  CXClassification_CM_IncompleteType
} CXClassification_ModifiableType;

// Classify runs the C++11 value-category taxonomy; the result carries no
// modifiability verdict (CM_Untested).
CXClassification clang_Expr_Classify(CXExpr E, CXASTContext Ctx);

// ClassifyModifiable additionally tests modifiability. *Loc is always written: it
// receives the location that makes E non-modifiable, or an invalid location when E is
// modifiable.
CXClassification clang_Expr_ClassifyModifiable(CXExpr E, CXASTContext Ctx,
                                               CXSourceLocation_ *Loc);

// makeSimpleLValue is static: it builds the CL_LValue/CM_Modifiable classification and
// takes no receiver.
CXClassification clang_Classification_makeSimpleLValue(void);

void clang_Classification_dispose(CXClassification C);

CXClassification_Kinds clang_Classification_getKind(CXClassification C);

// helper: the gate the two modifiability accessors assert on. True for a
// classification from clang_Expr_ClassifyModifiable or
// clang_Classification_makeSimpleLValue, false for one from clang_Expr_Classify.
bool clang_Classification_isModifiableTested(CXClassification C);

// PARTIAL: clang::Expr::Classification::getModifiable asserts that modifiability was
// tested. The shim is total by contract, so the Julia wrapper restates the
// precondition through clang_Classification_isModifiableTested (Invariant 3).
CXClassification_ModifiableType clang_Classification_getModifiable(CXClassification C);

bool clang_Classification_isLValue(CXClassification C);

bool clang_Classification_isXValue(CXClassification C);

bool clang_Classification_isGLValue(CXClassification C);

bool clang_Classification_isPRValue(CXClassification C);

bool clang_Classification_isRValue(CXClassification C);

// PARTIAL: isModifiable goes through getModifiable and inherits its assert.
bool clang_Classification_isModifiable(CXClassification C);

// Expr
bool clang_Expr_isOBJCGCCandidate(CXExpr E, CXASTContext Ctx);

// BinaryOperator
// The FPOptionsOverride opaque integer encoding (MARSHALLING.md §7): the FPOptions
// bits in the high half, the override mask in the low half. getFPFeatures is guarded
// by the HasFPFeatures bit and yields the default-constructed (zero) encoding when the
// operator has no trailing slot, so it is total.
uint64_t clang_BinaryOperator_getFPFeatures(CXBinaryOperator BO);

// PARTIAL: clang::BinaryOperator::getStoredFPFeatures asserts hasStoredFPFeatures() —
// the trailing slot exists only when the operator was allocated with one.
uint64_t clang_BinaryOperator_getStoredFPFeatures(CXBinaryOperator BO);

// CallExpr
// The same opaque FPOptionsOverride encoding; total for the same reason.
uint64_t clang_CallExpr_getFPFeatures(CXCallExpr E);

// PARTIAL: clang::CallExpr::getStoredFPFeatures asserts hasStoredFPFeatures().
uint64_t clang_CallExpr_getStoredFPFeatures(CXCallExpr E);

// UnaryOperator
// UnaryOperator spells the total accessor getFPOptionsOverride; same encoding.
uint64_t clang_UnaryOperator_getFPOptionsOverride(CXUnaryOperator E);

// PARTIAL: clang::UnaryOperator::getStoredFPFeatures reads the trailing slot through
// getTrailingFPFeatures(), which asserts hasStoredFPFeatures().
uint64_t clang_UnaryOperator_getStoredFPFeatures(CXUnaryOperator E);

// Expr
CXQualType clang_Expr_getType(CXExpr E);

CXExprValueKind clang_Expr_getValueKind(CXExpr E);

bool clang_Expr_isLValue(CXExpr E);

bool clang_Expr_isPRValue(CXExpr E);

bool clang_Expr_isXValue(CXExpr E);

bool clang_Expr_isGLValue(CXExpr E);

CXExpr clang_Expr_IgnoreImpCasts(CXExpr E);

CXExpr clang_Expr_IgnoreCasts(CXExpr E);

CXExpr clang_Expr_IgnoreParens(CXExpr E);

CXExpr clang_Expr_IgnoreParenCasts(CXExpr E);

CXExpr clang_Expr_IgnoreParenImpCasts(CXExpr E);

bool clang_Expr_containsErrors(CXExpr E);

bool clang_Expr_containsUnexpandedParameterPack(CXExpr E);

bool clang_Expr_hasPlaceholderType(CXExpr E);

bool clang_Expr_isDefaultArgument(CXExpr E);

bool clang_Expr_isImplicitCXXThis(CXExpr E);

bool clang_Expr_isInstantiationDependent(CXExpr E);

bool clang_Expr_isObjCSelfExpr(CXExpr E);

bool clang_Expr_isOrdinaryOrBitFieldObject(CXExpr E);

bool clang_Expr_isTypeDependent(CXExpr E);

bool clang_Expr_isValueDependent(CXExpr E);

bool clang_Expr_refersToBitField(CXExpr E);

bool clang_Expr_refersToGlobalRegisterVar(CXExpr E);

bool clang_Expr_refersToMatrixElement(CXExpr E);

bool clang_Expr_refersToVectorElement(CXExpr E);

CXSourceLocation_ clang_Expr_getExprLoc(CXExpr E);

// Fold E to a compile-time constant. Returns an OWNED CXAPValue (dispose via
// clang_APValue_dispose) on success, or nullptr if E is not a constant
// expression. See CXAPValue.h / MARSHALLING.md §3.
CXAPValue clang_Expr_EvaluateAsRValue(CXExpr E, CXASTContext Ctx);

// Constant-evaluation predicates (all use the strict SE_NoSideEffects policy).
bool clang_Expr_isEvaluatable(CXExpr E, CXASTContext Ctx);

bool clang_Expr_isIntegerConstantExpr(CXExpr E, CXASTContext Ctx);

bool clang_Expr_isCXX11ConstantExpr(CXExpr E, CXASTContext Ctx);

// Fold E as a boolean condition: 1 / 0 for true / false, or -1 when E is not a
// constant condition.
int clang_Expr_EvaluateAsBooleanCondition(CXExpr E, CXASTContext Ctx);

// Fold E to an integer constant. Returns an OWNED CXAPValue (dispose) on
// success, or nullptr when E is not an integer constant.
CXAPValue clang_Expr_EvaluateAsInt(CXExpr E, CXASTContext Ctx);

// Fold E to a floating constant. Returns the folded bits as a caller-owned
// LLVMGenericValueRef (APFloat::bitcastToAPInt in GV->IntVal, released via
// llvm-c), or nullptr when E is not a floating constant.
LLVMGenericValueRef clang_Expr_EvaluateAsFloat(CXExpr E, CXASTContext Ctx);

// DeclRefExpr
CXValueDecl clang_DeclRefExpr_getDecl(CXDeclRefExpr DRE);

CXNamedDecl clang_DeclRefExpr_getFoundDecl(CXDeclRefExpr DRE);

bool clang_DeclRefExpr_hasQualifier(CXDeclRefExpr DRE);

CXSourceLocation_ clang_DeclRefExpr_getLocation(CXDeclRefExpr DRE);

// Returns an owned box; release with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_DeclRefExpr_getNameInfo(CXDeclRefExpr DRE);

// IntegerLiteral
CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                             CXQualType T, CXSourceLocation_ L);

CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL);

CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL);

CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL);

void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL, CXSourceLocation_ L);

// The result is allocated with `new llvm::GenericValue`; the caller owns it
// (LLVM-C disposal), matching clang_TemplateArgument_getAsIntegral.
LLVMGenericValueRef clang_IntegerLiteral_getValue(CXIntegerLiteral IL);

// CharacterLiteral
// mirrors clang::CharacterLiteralKind (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXCharacterLiteralKind {
  CXCharacterLiteralKind_Ascii,
  CXCharacterLiteralKind_Wide,
  CXCharacterLiteralKind_UTF8,
  CXCharacterLiteralKind_UTF16,
  CXCharacterLiteralKind_UTF32
} CXCharacterLiteralKind;

// mirrors clang::StringLiteralKind (clang/AST/Expr.h; synced by static_assert in
// lib/Basic/CXEnumSync.cpp)
typedef enum CXStringLiteralKind {
  CXStringLiteralKind_Ordinary,
  CXStringLiteralKind_Wide,
  CXStringLiteralKind_UTF8,
  CXStringLiteralKind_UTF16,
  CXStringLiteralKind_UTF32,
  CXStringLiteralKind_Unevaluated
} CXStringLiteralKind;

// mirrors clang::PredefinedIdentKind (clang/AST/Expr.h; synced by static_assert
// in lib/Basic/CXEnumSync.cpp)
typedef enum CXPredefinedIdentKind {
  CXPredefinedIdentKind_Func,
  CXPredefinedIdentKind_Function,
  CXPredefinedIdentKind_LFunction,
  CXPredefinedIdentKind_FuncDName,
  CXPredefinedIdentKind_FuncSig,
  CXPredefinedIdentKind_LFuncSig,
  CXPredefinedIdentKind_PrettyFunction,
  CXPredefinedIdentKind_PrettyFunctionNoVirtual
} CXPredefinedIdentKind;

unsigned clang_CharacterLiteral_getValue(CXCharacterLiteral CL);

CXCharacterLiteralKind clang_CharacterLiteral_getKind(CXCharacterLiteral CL);

// FloatingLiteral
double clang_FloatingLiteral_getValueAsApproximateDouble(CXFloatingLiteral FL);

// StringLiteral
CXString clang_StringLiteral_getBytes(CXStringLiteral SL);

unsigned clang_StringLiteral_getByteLength(CXStringLiteral SL);

unsigned clang_StringLiteral_getLength(CXStringLiteral SL);

unsigned clang_StringLiteral_getCharByteWidth(CXStringLiteral SL);

// ParenExpr
CXExpr clang_ParenExpr_getSubExpr(CXParenExpr PE);

// UnaryOperator
CXUnaryOperatorKind clang_UnaryOperator_getOpcode(CXUnaryOperator UO);

CXExpr clang_UnaryOperator_getSubExpr(CXUnaryOperator UO);

CXSourceLocation_ clang_UnaryOperator_getOperatorLoc(CXUnaryOperator UO);

bool clang_UnaryOperator_isPrefix(CXUnaryOperator UO);

bool clang_UnaryOperator_isPostfix(CXUnaryOperator UO);

bool clang_UnaryOperator_isIncrementOp(CXUnaryOperator UO);

bool clang_UnaryOperator_isDecrementOp(CXUnaryOperator UO);

// ArraySubscriptExpr
CXExpr clang_ArraySubscriptExpr_getLHS(CXArraySubscriptExpr ASE);

CXExpr clang_ArraySubscriptExpr_getRHS(CXArraySubscriptExpr ASE);

CXExpr clang_ArraySubscriptExpr_getBase(CXArraySubscriptExpr ASE);

CXExpr clang_ArraySubscriptExpr_getIdx(CXArraySubscriptExpr ASE);

// CallExpr
CXExpr clang_CallExpr_getCallee(CXCallExpr CE);

CXDecl clang_CallExpr_getCalleeDecl(CXCallExpr CE);

CXFunctionDecl clang_CallExpr_getDirectCallee(CXCallExpr CE);

unsigned clang_CallExpr_getNumArgs(CXCallExpr CE);

CXExpr clang_CallExpr_getArg(CXCallExpr CE, unsigned Arg);

CXSourceLocation_ clang_CallExpr_getRParenLoc(CXCallExpr CE);

// MemberExpr
CXExpr clang_MemberExpr_getBase(CXMemberExpr ME);

CXValueDecl clang_MemberExpr_getMemberDecl(CXMemberExpr ME);

bool clang_MemberExpr_isArrow(CXMemberExpr ME);

CXSourceLocation_ clang_MemberExpr_getMemberLoc(CXMemberExpr ME);

bool clang_MemberExpr_isImplicitAccess(CXMemberExpr ME);

// Returns an owned box; release with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_MemberExpr_getMemberNameInfo(CXMemberExpr ME);

// CastExpr
CXCastKind clang_CastExpr_getCastKind(CXCastExpr CE);

const char *clang_CastExpr_getCastKindName(CXCastExpr CE);

CXExpr clang_CastExpr_getSubExpr(CXCastExpr CE);

CXExpr clang_CastExpr_getSubExprAsWritten(CXCastExpr CE);

// ImplicitCastExpr
bool clang_ImplicitCastExpr_isPartOfExplicitCast(CXImplicitCastExpr ICE);

// ExplicitCastExpr
CXQualType clang_ExplicitCastExpr_getTypeAsWritten(CXExplicitCastExpr ECE);

// CStyleCastExpr
CXCStyleCastExpr clang_CStyleCastExpr_CreateWithNoTypeInfo(CXASTContext C, CXQualType T,
                                                           CXExprValueKind VK, CXCastKind K,
                                                           CXExpr Op);

CXCStyleCastExpr clang_CStyleCastExpr_CreateEmpty(CXASTContext C, unsigned PathSize,
                                                  bool HasFPFeatures);

CXSourceLocation_ clang_CStyleCastExpr_getLParenLoc(CXCStyleCastExpr CSCE);

void clang_CStyleCastExpr_setLParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L);

CXSourceLocation_ clang_CStyleCastExpr_getRParenLoc(CXCStyleCastExpr CSCE);

void clang_CStyleCastExpr_setRParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L);

CXSourceLocation_ clang_CStyleCastExpr_getBeginLoc(CXCStyleCastExpr CSCE);

CXSourceLocation_ clang_CStyleCastExpr_getEndLoc(CXCStyleCastExpr CSCE);

// BinaryOperator
CXBinaryOperatorKind clang_BinaryOperator_getOpcode(CXBinaryOperator BO);

CXExpr clang_BinaryOperator_getLHS(CXBinaryOperator BO);

CXExpr clang_BinaryOperator_getRHS(CXBinaryOperator BO);

CXSourceLocation_ clang_BinaryOperator_getOperatorLoc(CXBinaryOperator BO);

const char *clang_BinaryOperator_getOpcodeStr(CXBinaryOperator BO);

bool clang_BinaryOperator_isAssignmentOp(CXBinaryOperator BO);

bool clang_BinaryOperator_isCompoundAssignmentOp(CXBinaryOperator BO);

bool clang_BinaryOperator_isComparisonOp(CXBinaryOperator BO);

// CompoundAssignOperator
CXQualType clang_CompoundAssignOperator_getComputationLHSType(CXCompoundAssignOperator CAO);

CXQualType
clang_CompoundAssignOperator_getComputationResultType(CXCompoundAssignOperator CAO);

// AbstractConditionalOperator
CXExpr clang_AbstractConditionalOperator_getCond(CXAbstractConditionalOperator ACO);

CXExpr clang_AbstractConditionalOperator_getTrueExpr(CXAbstractConditionalOperator ACO);

CXExpr clang_AbstractConditionalOperator_getFalseExpr(CXAbstractConditionalOperator ACO);

// InitListExpr
unsigned clang_InitListExpr_getNumInits(CXInitListExpr ILE);

CXExpr clang_InitListExpr_getInit(CXInitListExpr ILE, unsigned Init);

bool clang_InitListExpr_isSemanticForm(CXInitListExpr ILE);

CXInitListExpr clang_InitListExpr_getSyntacticForm(CXInitListExpr ILE);

// UnaryExprOrTypeTraitExpr
bool clang_UnaryExprOrTypeTraitExpr_isArgumentType(CXUnaryExprOrTypeTraitExpr E);

CXQualType clang_UnaryExprOrTypeTraitExpr_getArgumentType(CXUnaryExprOrTypeTraitExpr E);

CXQualType clang_UnaryExprOrTypeTraitExpr_getTypeOfArgument(CXUnaryExprOrTypeTraitExpr E);

CXSourceLocation_ clang_UnaryExprOrTypeTraitExpr_getOperatorLoc(CXUnaryExprOrTypeTraitExpr E);

CXSourceLocation_ clang_UnaryExprOrTypeTraitExpr_getRParenLoc(CXUnaryExprOrTypeTraitExpr E);

// StringLiteral
bool clang_StringLiteral_isOrdinary(CXStringLiteral E);

bool clang_StringLiteral_isWide(CXStringLiteral E);

bool clang_StringLiteral_isUTF8(CXStringLiteral E);

bool clang_StringLiteral_isUTF16(CXStringLiteral E);

bool clang_StringLiteral_isUTF32(CXStringLiteral E);

bool clang_StringLiteral_isUnevaluated(CXStringLiteral E);

bool clang_StringLiteral_isPascal(CXStringLiteral E);

bool clang_StringLiteral_containsNonAscii(CXStringLiteral E);

bool clang_StringLiteral_containsNonAsciiOrNull(CXStringLiteral E);

unsigned clang_StringLiteral_getNumConcatenated(CXStringLiteral E);

// CharacterLiteral
CXSourceLocation_ clang_CharacterLiteral_getLocation(CXCharacterLiteral E);

// UnaryOperator
bool clang_UnaryOperator_canOverflow(CXUnaryOperator E);

bool clang_UnaryOperator_isIncrementDecrementOp(CXUnaryOperator E);

bool clang_UnaryOperator_isArithmeticOp(CXUnaryOperator E);

bool clang_UnaryOperator_hasStoredFPFeatures(CXUnaryOperator E);

// CallExpr
bool clang_CallExpr_usesADL(CXCallExpr E);

bool clang_CallExpr_hasStoredFPFeatures(CXCallExpr E);

unsigned clang_CallExpr_getBuiltinCallee(CXCallExpr E);

bool clang_CallExpr_isCallToStdMove(CXCallExpr E);

// MemberExpr
bool clang_MemberExpr_hasQualifier(CXMemberExpr E);

CXSourceLocation_ clang_MemberExpr_getTemplateKeywordLoc(CXMemberExpr E);

CXSourceLocation_ clang_MemberExpr_getLAngleLoc(CXMemberExpr E);

CXSourceLocation_ clang_MemberExpr_getRAngleLoc(CXMemberExpr E);

bool clang_MemberExpr_hasTemplateKeyword(CXMemberExpr E);

bool clang_MemberExpr_hasExplicitTemplateArgs(CXMemberExpr E);

unsigned clang_MemberExpr_getNumTemplateArgs(CXMemberExpr E);

CXSourceLocation_ clang_MemberExpr_getOperatorLoc(CXMemberExpr E);

bool clang_MemberExpr_hadMultipleCandidates(CXMemberExpr E);

// InitListExpr
bool clang_InitListExpr_hasArrayFiller(CXInitListExpr E);

bool clang_InitListExpr_hasDesignatedInit(CXInitListExpr E);

bool clang_InitListExpr_isExplicit(CXInitListExpr E);

bool clang_InitListExpr_isStringLiteralInit(CXInitListExpr E);

bool clang_InitListExpr_isTransparent(CXInitListExpr E);

CXSourceLocation_ clang_InitListExpr_getLBraceLoc(CXInitListExpr E);

CXSourceLocation_ clang_InitListExpr_getRBraceLoc(CXInitListExpr E);

bool clang_InitListExpr_isSyntacticForm(CXInitListExpr E);

bool clang_InitListExpr_hadArrayRangeDesignator(CXInitListExpr E);

// ParenExpr
CXSourceLocation_ clang_ParenExpr_getLParen(CXParenExpr E);

CXSourceLocation_ clang_ParenExpr_getRParen(CXParenExpr E);

// ArraySubscriptExpr
CXSourceLocation_ clang_ArraySubscriptExpr_getRBracketLoc(CXArraySubscriptExpr E);

// DeclRefExpr
bool clang_DeclRefExpr_hasTemplateKWAndArgsInfo(CXDeclRefExpr E);

CXSourceLocation_ clang_DeclRefExpr_getTemplateKeywordLoc(CXDeclRefExpr E);

CXSourceLocation_ clang_DeclRefExpr_getLAngleLoc(CXDeclRefExpr E);

CXSourceLocation_ clang_DeclRefExpr_getRAngleLoc(CXDeclRefExpr E);

bool clang_DeclRefExpr_hasTemplateKeyword(CXDeclRefExpr E);

bool clang_DeclRefExpr_hasExplicitTemplateArgs(CXDeclRefExpr E);

unsigned clang_DeclRefExpr_getNumTemplateArgs(CXDeclRefExpr E);

bool clang_DeclRefExpr_hadMultipleCandidates(CXDeclRefExpr E);

bool clang_DeclRefExpr_refersToEnclosingVariableOrCapture(CXDeclRefExpr E);

bool clang_DeclRefExpr_isImmediateEscalating(CXDeclRefExpr E);

bool clang_DeclRefExpr_isCapturedByCopyInLambdaWithExplicitObjectParameter(CXDeclRefExpr E);

// CastExpr
bool clang_CastExpr_path_empty(CXCastExpr E);

unsigned clang_CastExpr_path_size(CXCastExpr E);

bool clang_CastExpr_hasStoredFPFeatures(CXCastExpr E);

bool clang_CastExpr_changesVolatileQualification(CXCastExpr E);

// ConstantExpr
bool clang_ConstantExpr_isImmediateInvocation(CXConstantExpr E);

bool clang_ConstantExpr_hasAPValueResult(CXConstantExpr E);

// StmtExpr
CXSourceLocation_ clang_StmtExpr_getLParenLoc(CXStmtExpr E);

CXSourceLocation_ clang_StmtExpr_getRParenLoc(CXStmtExpr E);

unsigned clang_StmtExpr_getTemplateDepth(CXStmtExpr E);

// CompoundLiteralExpr
bool clang_CompoundLiteralExpr_isFileScope(CXCompoundLiteralExpr E);

CXSourceLocation_ clang_CompoundLiteralExpr_getLParenLoc(CXCompoundLiteralExpr E);


// UnaryExprOrTypeTraitExpr
CXTypeSourceInfo clang_UnaryExprOrTypeTraitExpr_getArgumentTypeInfo(CXUnaryExprOrTypeTraitExpr E);

CXExpr clang_UnaryExprOrTypeTraitExpr_getArgumentExpr(CXUnaryExprOrTypeTraitExpr E);

// MemberExpr
CXNestedNameSpecifier clang_MemberExpr_getQualifier(CXMemberExpr E);

// InitListExpr
CXExpr clang_InitListExpr_getArrayFiller(CXInitListExpr E);

CXFieldDecl clang_InitListExpr_getInitializedFieldInUnion(CXInitListExpr E);

CXInitListExpr clang_InitListExpr_getSemanticForm(CXInitListExpr E);

// DeclRefExpr
CXNestedNameSpecifier clang_DeclRefExpr_getQualifier(CXDeclRefExpr E);

// CastExpr
CXNamedDecl clang_CastExpr_getConversionFunction(CXCastExpr E);

CXFieldDecl clang_CastExpr_getTargetUnionField(CXCastExpr E);

// StmtExpr
CXCompoundStmt clang_StmtExpr_getSubStmt(CXStmtExpr E);

// CompoundLiteralExpr
CXExpr clang_CompoundLiteralExpr_getInitializer(CXCompoundLiteralExpr E);

CXTypeSourceInfo clang_CompoundLiteralExpr_getTypeSourceInfo(CXCompoundLiteralExpr E);

// StringLiteral
// getString asserts char width 1 (or unevaluated) upstream; NUL-safe copy via
// makeCXString(std::string). Julia reads with get_string.
CXString clang_StringLiteral_getString(CXStringLiteral SL);

CXStringLiteralKind clang_StringLiteral_getKind(CXStringLiteral SL);

CXSourceLocation_ clang_StringLiteral_getBeginLoc(CXStringLiteral SL);

CXSourceLocation_ clang_StringLiteral_getEndLoc(CXStringLiteral SL);

// UnaryExprOrTypeTraitExpr
CXUnaryExprOrTypeTrait
clang_UnaryExprOrTypeTraitExpr_getKind(CXUnaryExprOrTypeTraitExpr E);

// PredefinedExpr
CXPredefinedIdentKind clang_PredefinedExpr_getIdentKind(CXPredefinedExpr E);

// getFunctionName returns the interior StringLiteral (nullptr when the
// predefined expr carries no function-name literal); borrowed, no dispose.
CXStringLiteral clang_PredefinedExpr_getFunctionName(CXPredefinedExpr E);

CXString clang_PredefinedExpr_getIdentKindName(CXPredefinedExpr E);

// CastExpr
// getPathElement returns the I-th inheritance-path base specifier
// (0-based, I < path_size()); the CXXBaseSpecifier is AST-owned, borrowed.
CXCXXBaseSpecifier clang_CastExpr_getPathElement(CXCastExpr E, unsigned I);

// Expr
// mirrors clang::Expr::ConstantExprKind (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXExpr_ConstantExprKind {
  CXExpr_ConstantExprKind_Normal,
  CXExpr_ConstantExprKind_NonClassTemplateArgument,
  CXExpr_ConstantExprKind_ClassTemplateArgument,
  CXExpr_ConstantExprKind_ImmediateInvocation
} CXExpr_ConstantExprKind;

// mirrors clang::Expr::NullPointerConstantKind (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXExpr_NullPointerConstantKind {
  CXExpr_NPCK_NotNull = 0,
  CXExpr_NPCK_ZeroExpression,
  CXExpr_NPCK_ZeroLiteral,
  CXExpr_NPCK_CXX11_nullptr,
  CXExpr_NPCK_GNUNull
} CXExpr_NullPointerConstantKind;

// mirrors clang::Expr::NullPointerConstantValueDependence (clang/AST/Expr.h;
// synced by static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXExpr_NullPointerConstantValueDependence {
  CXExpr_NPC_NeverValueDependent = 0,
  CXExpr_NPC_ValueDependentIsNull,
  CXExpr_NPC_ValueDependentIsNotNull
} CXExpr_NullPointerConstantValueDependence;

CXExprObjectKind clang_Expr_getObjectKind(CXExpr E);

CXFieldDecl clang_Expr_getSourceBitField(CXExpr E);

CXDecl clang_Expr_getReferencedDeclOfCallee(CXExpr E);

CXCXXRecordDecl clang_Expr_getBestDynamicClassType(CXExpr E);

bool clang_Expr_isKnownToHaveBooleanValue(CXExpr E, bool Semantic);

CXExpr clang_Expr_IgnoreImplicit(CXExpr E);

CXExpr clang_Expr_IgnoreImplicitAsWritten(CXExpr E);

CXExpr clang_Expr_IgnoreParenBaseCasts(CXExpr E);

CXExpr clang_Expr_IgnoreParenLValueCasts(CXExpr E);

CXExpr clang_Expr_IgnoreUnlessSpelledInSource(CXExpr E);

CXExpr clang_Expr_IgnoreParenNoopCasts(CXExpr E, CXASTContext Ctx);

bool clang_Expr_isCXX98IntegralConstantExpr(CXExpr E, CXASTContext Ctx);

// The `const Expr **Culprit` out-param is not exposed.
bool clang_Expr_isConstantInitializer(CXExpr E, CXASTContext Ctx, bool ForRef);

CXValueDecl clang_Expr_getAsBuiltinConstantDeclRef(CXExpr E, CXASTContext Ctx);

bool clang_Expr_HasSideEffects(CXExpr E, CXASTContext Ctx, bool IncludePossibleEffects);

bool clang_Expr_hasNonTrivialCall(CXExpr E, CXASTContext Ctx);

bool clang_Expr_isBoundMemberFunction(CXExpr E, CXASTContext Ctx);

// findBoundMemberType is static: E is the operand, not a receiver.
CXQualType clang_Expr_findBoundMemberType(CXExpr E);

// isSameComparisonOperand is static: both arguments are operands.
bool clang_Expr_isSameComparisonOperand(CXExpr E1, CXExpr E2);

bool clang_Expr_isTemporaryObject(CXExpr E, CXASTContext Ctx, CXCXXRecordDecl TempTy);

// getValueKindForType is static: T is the queried type, not a receiver.
CXExprValueKind clang_Expr_getValueKindForType(CXQualType T);

CXExpr_NullPointerConstantKind
clang_Expr_isNullPointerConstant(CXExpr E, CXASTContext Ctx,
                                 CXExpr_NullPointerConstantValueDependence NPC);

// Fold E to an integer constant expression. Returns the value as a
// caller-owned LLVMGenericValueRef (APSInt in GV->IntVal, released via llvm-c),
// or nullptr when E is not an integer constant expression. The optional
// SourceLocation out-param is not exposed. See MARSHALLING.md §1/§8.
LLVMGenericValueRef clang_Expr_getIntegerConstantExpr(CXExpr E, CXASTContext Ctx);

// EvaluateKnownConstInt asserts that E constant-folds to an integer; the caller
// must have established that (clang_Expr_isIntegerConstantExpr). The result is a
// caller-owned LLVMGenericValueRef.
LLVMGenericValueRef clang_Expr_EvaluateKnownConstInt(CXExpr E, CXASTContext Ctx);

LLVMGenericValueRef clang_Expr_EvaluateKnownConstIntCheckOverflow(CXExpr E,
                                                                  CXASTContext Ctx);

// Fold E as a constant lvalue. Returns an OWNED CXAPValue (dispose via
// clang_APValue_dispose), or nullptr when E is not a constant lvalue.
CXAPValue clang_Expr_EvaluateAsLValue(CXExpr E, CXASTContext Ctx, bool InConstantContext);

// Fold E as a constant expression of the given kind. Returns an OWNED CXAPValue
// (dispose), or nullptr when E is not a constant expression.
CXAPValue clang_Expr_EvaluateAsConstantExpr(CXExpr E, CXASTContext Ctx,
                                            CXExpr_ConstantExprKind Kind);

// __builtin_object_size: returns true and fills *Result on success, leaving
// *Result untouched otherwise.
bool clang_Expr_tryEvaluateObjectSize(CXExpr E, CXASTContext Ctx, unsigned Type,
                                      uint64_t *Result);

bool clang_Expr_tryEvaluateStrLen(CXExpr E, CXASTContext Ctx, uint64_t *Result);

// BinaryOperator
// The opcode-taking members below are static: Opc is the queried opcode, not a
// receiver.
CXBinaryOperatorKind clang_BinaryOperator_getOverloadedOpcode(CXOverloadedOperatorKind OO);

CXOverloadedOperatorKind
clang_BinaryOperator_getOverloadedOperator(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isPtrMemOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isMultiplicativeOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isAdditiveOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isShiftOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isBitwiseOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isRelationalOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isEqualityOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isCommaOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isLogicalOp(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isShiftAssignOp(CXBinaryOperatorKind Opc);

CXBinaryOperatorKind clang_BinaryOperator_negateComparisonOp(CXBinaryOperatorKind Opc);

CXBinaryOperatorKind clang_BinaryOperator_reverseComparisonOp(CXBinaryOperatorKind Opc);

CXBinaryOperatorKind
clang_BinaryOperator_getOpForCompoundAssignment(CXBinaryOperatorKind Opc);

bool clang_BinaryOperator_isNullPointerArithmeticExtension(CXASTContext Ctx,
                                                           CXBinaryOperatorKind Opc,
                                                           CXExpr LHS, CXExpr RHS);

bool clang_BinaryOperator_hasStoredFPFeatures(CXBinaryOperator BO);

// UnaryOperator
// getOpcodeStr/getOverloadedOpcode/getOverloadedOperator are static: they take
// an opcode, not a receiver.
const char *clang_UnaryOperator_getOpcodeStr(CXUnaryOperatorKind Op);

CXUnaryOperatorKind clang_UnaryOperator_getOverloadedOpcode(CXOverloadedOperatorKind OO,
                                                            bool Postfix);

CXOverloadedOperatorKind clang_UnaryOperator_getOverloadedOperator(CXUnaryOperatorKind Opc);

void clang_UnaryOperator_setOperatorLoc(CXUnaryOperator UO, CXSourceLocation_ L);

// CallExpr
CXQualType clang_CallExpr_getCallReturnType(CXCallExpr CE, CXASTContext Ctx);

// The returned Attr is AST-owned, borrowed (nullptr when the callee carries no
// warn_unused_result attribute).
CXAttr clang_CallExpr_getUnusedResultAttr(CXCallExpr CE, CXASTContext Ctx);

bool clang_CallExpr_hasUnusedResultAttr(CXCallExpr CE, CXASTContext Ctx);

bool clang_CallExpr_isUnevaluatedBuiltinCall(CXCallExpr CE, CXASTContext Ctx);

bool clang_CallExpr_isBuiltinAssumeFalse(CXCallExpr CE, CXASTContext Ctx);

void clang_CallExpr_setRParenLoc(CXCallExpr CE, CXSourceLocation_ L);

// MemberExpr
// getFoundDecl returns a DeclAccessPair by value; its parts are exposed
// separately (MARSHALLING.md §7).
CXNamedDecl clang_MemberExpr_getFoundDecl(CXMemberExpr E);

// helper
CXAccessSpecifier clang_MemberExpr_getFoundDeclAccess(CXMemberExpr E);

// getTemplateArg returns the I-th explicit template argument (0-based,
// I < getNumTemplateArgs()); the TemplateArgumentLoc is AST-owned, borrowed.
CXTemplateArgumentLoc clang_MemberExpr_getTemplateArg(CXMemberExpr E, unsigned I);

CXNonOdrUseReason clang_MemberExpr_isNonOdrUse(CXMemberExpr E);

bool clang_MemberExpr_performsVirtualDispatch(CXMemberExpr E, CXLangOptions LO);

void clang_MemberExpr_setMemberLoc(CXMemberExpr E, CXSourceLocation_ L);

// DeclRefExpr
// getTemplateArg returns the I-th explicit template argument (0-based,
// I < getNumTemplateArgs()); the TemplateArgumentLoc is AST-owned, borrowed.
CXTemplateArgumentLoc clang_DeclRefExpr_getTemplateArg(CXDeclRefExpr E, unsigned I);

CXNonOdrUseReason clang_DeclRefExpr_isNonOdrUse(CXDeclRefExpr E);

void clang_DeclRefExpr_setLocation(CXDeclRefExpr E, CXSourceLocation_ L);

// CastExpr
// getTargetFieldForToUnionCast is static: both arguments are types.
CXFieldDecl clang_CastExpr_getTargetFieldForToUnionCast(CXQualType UnionType,
                                                        CXQualType OpType);

// ExplicitCastExpr
CXTypeSourceInfo clang_ExplicitCastExpr_getTypeInfoAsWritten(CXExplicitCastExpr E);

// InitListExpr
bool clang_InitListExpr_isIdiomaticZeroInitializer(CXInitListExpr E, CXLangOptions LO);

void clang_InitListExpr_setLBraceLoc(CXInitListExpr E, CXSourceLocation_ L);

void clang_InitListExpr_setRBraceLoc(CXInitListExpr E, CXSourceLocation_ L);

// AbstractConditionalOperator
CXSourceLocation_
clang_AbstractConditionalOperator_getQuestionLoc(CXAbstractConditionalOperator ACO);

CXSourceLocation_
clang_AbstractConditionalOperator_getColonLoc(CXAbstractConditionalOperator ACO);

// ParenListExpr
// getNumExprs + getExpr are the count+index pair (MARSHALLING.md §6); the count
// is exact and no slot is null.
unsigned clang_ParenListExpr_getNumExprs(CXParenListExpr E);

CXExpr clang_ParenListExpr_getExpr(CXParenListExpr E, unsigned Init);

CXSourceLocation_ clang_ParenListExpr_getLParenLoc(CXParenListExpr E);

CXSourceLocation_ clang_ParenListExpr_getRParenLoc(CXParenListExpr E);

// ConstantExpr
// getResultAsAPSInt requires an integral stored result (check
// clang_ConstantExpr_hasAPValueResult first); the caller owns the returned
// LLVMGenericValueRef.
LLVMGenericValueRef clang_ConstantExpr_getResultAsAPSInt(CXConstantExpr E);

// Returns an OWNED copy of the stored result; release with
// clang_APValue_dispose.
CXAPValue clang_ConstantExpr_getAPValueResult(CXConstantExpr E);

// FloatingLiteral
// The exact value crosses as APFloat::bitcastToAPInt in GV->IntVal
// (MARSHALLING.md §2); the caller owns the LLVMGenericValueRef.
LLVMGenericValueRef clang_FloatingLiteral_getValue(CXFloatingLiteral FL);

bool clang_FloatingLiteral_isExact(CXFloatingLiteral FL);

CXSourceLocation_ clang_FloatingLiteral_getLocation(CXFloatingLiteral FL);

void clang_FloatingLiteral_setLocation(CXFloatingLiteral FL, CXSourceLocation_ L);

// StringLiteral
// getCodeUnit is 0-based, I < getLength(); getStrTokenLoc is 0-based,
// TokNum < getNumConcatenated().
unsigned clang_StringLiteral_getCodeUnit(CXStringLiteral SL, size_t I);

CXSourceLocation_ clang_StringLiteral_getStrTokenLoc(CXStringLiteral SL, unsigned TokNum);

// DesignatedInitExpr
// size + getDesignator are the count+index pair over the designator array
// (MARSHALLING.md §6); getNumSubExprs + getSubExpr the pair over the index
// expressions. Both counts are exact and no slot is null.
unsigned clang_DesignatedInitExpr_size(CXDesignatedInitExpr E);

// The returned Designator is AST-owned (interior to E), borrowed.
CXDesignator clang_DesignatedInitExpr_getDesignator(CXDesignatedInitExpr E, unsigned Idx);

CXExpr clang_DesignatedInitExpr_getArrayIndex(CXDesignatedInitExpr E, CXDesignator D);

CXExpr clang_DesignatedInitExpr_getArrayRangeStart(CXDesignatedInitExpr E, CXDesignator D);

CXExpr clang_DesignatedInitExpr_getArrayRangeEnd(CXDesignatedInitExpr E, CXDesignator D);

CXSourceRange_ clang_DesignatedInitExpr_getDesignatorsSourceRange(CXDesignatedInitExpr E);

CXSourceLocation_ clang_DesignatedInitExpr_getEqualOrColonLoc(CXDesignatedInitExpr E);

bool clang_DesignatedInitExpr_isDirectInit(CXDesignatedInitExpr E);

bool clang_DesignatedInitExpr_usesGNUSyntax(CXDesignatedInitExpr E);

CXExpr clang_DesignatedInitExpr_getInit(CXDesignatedInitExpr E);

unsigned clang_DesignatedInitExpr_getNumSubExprs(CXDesignatedInitExpr E);

CXExpr clang_DesignatedInitExpr_getSubExpr(CXDesignatedInitExpr E, unsigned Idx);

// DesignatedInitExpr::Designator
bool clang_Designator_isFieldDesignator(CXDesignator D);

bool clang_Designator_isArrayDesignator(CXDesignator D);

bool clang_Designator_isArrayRangeDesignator(CXDesignator D);

// getFieldName/getFieldDecl/getDotLoc/getFieldLoc are valid only when
// isFieldDesignator(). getFieldDecl is nullptr until Sema resolves the name.
CXIdentifierInfo clang_Designator_getFieldName(CXDesignator D);

CXFieldDecl clang_Designator_getFieldDecl(CXDesignator D);

CXSourceLocation_ clang_Designator_getDotLoc(CXDesignator D);

CXSourceLocation_ clang_Designator_getFieldLoc(CXDesignator D);

// getArrayIndex/getLBracketLoc/getRBracketLoc are valid only when
// isArrayDesignator() or isArrayRangeDesignator(); getEllipsisLoc additionally
// requires isArrayRangeDesignator().
unsigned clang_Designator_getArrayIndex(CXDesignator D);

CXSourceLocation_ clang_Designator_getLBracketLoc(CXDesignator D);

CXSourceLocation_ clang_Designator_getEllipsisLoc(CXDesignator D);

CXSourceLocation_ clang_Designator_getRBracketLoc(CXDesignator D);

CXSourceLocation_ clang_Designator_getBeginLoc(CXDesignator D);

CXSourceLocation_ clang_Designator_getEndLoc(CXDesignator D);

// AtomicExpr
// getOp returns clang::AtomicExpr::AtomicOp as a plain unsigned: its enumerator
// list is generated from clang/Basic/Builtins.def and is not mirrored here.
unsigned clang_AtomicExpr_getOp(CXAtomicExpr E);

CXString clang_AtomicExpr_getOpAsString(CXAtomicExpr E);

unsigned clang_AtomicExpr_getNumSubExprs(CXAtomicExpr E);

// helper: getSubExprs()[I]. I must be < getNumSubExprs(). Reaching a particular
// operand through the named accessors (getVal1/getVal2/getOrderFail/getWeak/
// getScope) asserts on the op's arity; this index form is the total one.
CXExpr clang_AtomicExpr_getSubExpr(CXAtomicExpr E, unsigned I);

bool clang_AtomicExpr_isCmpXChg(CXAtomicExpr E);

// GenericSelectionExpr
unsigned clang_GenericSelectionExpr_getNumAssocs(CXGenericSelectionExpr E);

bool clang_GenericSelectionExpr_isResultDependent(CXGenericSelectionExpr E);

// getResultIndex asserts !isResultDependent().
unsigned clang_GenericSelectionExpr_getResultIndex(CXGenericSelectionExpr E);

bool clang_GenericSelectionExpr_isExprPredicate(CXGenericSelectionExpr E);

// getControllingExpr asserts isExprPredicate() (a _Generic controlled by a type
// has no controlling expression).
CXExpr clang_GenericSelectionExpr_getControllingExpr(CXGenericSelectionExpr E);

// helper: getAssocExprs()[I]. I must be < getNumAssocs().
CXExpr clang_GenericSelectionExpr_getAssocExpr(CXGenericSelectionExpr E, unsigned I);

// ChooseExpr
CXExpr clang_ChooseExpr_getCond(CXChooseExpr E);

CXExpr clang_ChooseExpr_getLHS(CXChooseExpr E);

CXExpr clang_ChooseExpr_getRHS(CXChooseExpr E);

bool clang_ChooseExpr_isConditionDependent(CXChooseExpr E);

// isConditionTrue asserts !isConditionDependent().
bool clang_ChooseExpr_isConditionTrue(CXChooseExpr E);

// ShuffleVectorExpr
unsigned clang_ShuffleVectorExpr_getNumSubExprs(CXShuffleVectorExpr E);

// getExpr asserts Index < getNumSubExprs().
CXExpr clang_ShuffleVectorExpr_getExpr(CXShuffleVectorExpr E, unsigned Index);

// ExtVectorElementExpr
CXExpr clang_ExtVectorElementExpr_getBase(CXExtVectorElementExpr E);

unsigned clang_ExtVectorElementExpr_getNumElements(CXExtVectorElementExpr E);

// OpaqueValueExpr
CXSourceLocation_ clang_OpaqueValueExpr_getLocation(CXOpaqueValueExpr E);

// The source expression may be null (an OpaqueValueExpr synthesised without one).
CXExpr clang_OpaqueValueExpr_getSourceExpr(CXOpaqueValueExpr E);

bool clang_OpaqueValueExpr_isUnique(CXOpaqueValueExpr E);

// ConditionalOperator
CXExpr clang_ConditionalOperator_getLHS(CXConditionalOperator E);

CXExpr clang_ConditionalOperator_getRHS(CXConditionalOperator E);

// BinaryConditionalOperator
CXExpr clang_BinaryConditionalOperator_getCommon(CXBinaryConditionalOperator E);

CXOpaqueValueExpr
clang_BinaryConditionalOperator_getOpaqueValue(CXBinaryConditionalOperator E);

// AddrLabelExpr
CXSourceLocation_ clang_AddrLabelExpr_getAmpAmpLoc(CXAddrLabelExpr E);

CXSourceLocation_ clang_AddrLabelExpr_getLabelLoc(CXAddrLabelExpr E);

CXLabelDecl clang_AddrLabelExpr_getLabel(CXAddrLabelExpr E);

// GNUNullExpr
CXSourceLocation_ clang_GNUNullExpr_getTokenLocation(CXGNUNullExpr E);

// VAArgExpr
CXExpr clang_VAArgExpr_getSubExpr(CXVAArgExpr E);

bool clang_VAArgExpr_isMicrosoftABI(CXVAArgExpr E);

CXTypeSourceInfo clang_VAArgExpr_getWrittenTypeInfo(CXVAArgExpr E);

CXSourceLocation_ clang_VAArgExpr_getBuiltinLoc(CXVAArgExpr E);

CXSourceLocation_ clang_VAArgExpr_getRParenLoc(CXVAArgExpr E);

// ImaginaryLiteral
CXExpr clang_ImaginaryLiteral_getSubExpr(CXImaginaryLiteral E);

// MatrixSubscriptExpr
bool clang_MatrixSubscriptExpr_isIncomplete(CXMatrixSubscriptExpr E);

CXExpr clang_MatrixSubscriptExpr_getBase(CXMatrixSubscriptExpr E);

CXExpr clang_MatrixSubscriptExpr_getRowIdx(CXMatrixSubscriptExpr E);

// getColumnIdx returns null for an incomplete subscript (cast_or_null upstream).
CXExpr clang_MatrixSubscriptExpr_getColumnIdx(CXMatrixSubscriptExpr E);

CXSourceLocation_ clang_MatrixSubscriptExpr_getRBracketLoc(CXMatrixSubscriptExpr E);

// ConvertVectorExpr
CXExpr clang_ConvertVectorExpr_getSrcExpr(CXConvertVectorExpr E);

CXTypeSourceInfo clang_ConvertVectorExpr_getTypeSourceInfo(CXConvertVectorExpr E);

CXSourceLocation_ clang_ConvertVectorExpr_getBuiltinLoc(CXConvertVectorExpr E);

CXSourceLocation_ clang_ConvertVectorExpr_getRParenLoc(CXConvertVectorExpr E);

// ChooseExpr
// getChosenSubExpr asserts !isConditionDependent(); the Julia wrapper restates it.
CXExpr clang_ChooseExpr_getChosenSubExpr(CXChooseExpr E);

CXSourceLocation_ clang_ChooseExpr_getBuiltinLoc(CXChooseExpr E);

CXSourceLocation_ clang_ChooseExpr_getRParenLoc(CXChooseExpr E);

// SourceLocExpr
CXString clang_SourceLocExpr_getBuiltinStr(CXSourceLocExpr E);

bool clang_SourceLocExpr_isIntType(CXSourceLocExpr E);

CXDeclContext clang_SourceLocExpr_getParentContext(CXSourceLocExpr E);

CXSourceLocation_ clang_SourceLocExpr_getLocation(CXSourceLocExpr E);

// BlockExpr
CXBlockDecl clang_BlockExpr_getBlockDecl(CXBlockExpr E);

CXSourceLocation_ clang_BlockExpr_getCaretLocation(CXBlockExpr E);

CXStmt clang_BlockExpr_getBody(CXBlockExpr E);

// AtomicExpr
// getPtr/getOrder read SubExprs[PTR]/[ORDER]; both slots are always populated
// for a well-formed AtomicExpr, so these are total (unlike the arity-gated
// getVal1/getVal2/getWeak/getScope/getOrderFail accessors).
CXExpr clang_AtomicExpr_getPtr(CXAtomicExpr E);

CXExpr clang_AtomicExpr_getOrder(CXAtomicExpr E);

CXQualType clang_AtomicExpr_getValueType(CXAtomicExpr E);

bool clang_AtomicExpr_isVolatile(CXAtomicExpr E);

bool clang_AtomicExpr_isOpenCL(CXAtomicExpr E);

CXSourceLocation_ clang_AtomicExpr_getBuiltinLoc(CXAtomicExpr E);

CXSourceLocation_ clang_AtomicExpr_getRParenLoc(CXAtomicExpr E);

// GenericSelectionExpr
bool clang_GenericSelectionExpr_isTypePredicate(CXGenericSelectionExpr E);

// getResultExpr asserts !isResultDependent(); the Julia wrapper restates it.
CXExpr clang_GenericSelectionExpr_getResultExpr(CXGenericSelectionExpr E);

CXSourceLocation_ clang_GenericSelectionExpr_getGenericLoc(CXGenericSelectionExpr E);

CXSourceLocation_ clang_GenericSelectionExpr_getDefaultLoc(CXGenericSelectionExpr E);

CXSourceLocation_ clang_GenericSelectionExpr_getRParenLoc(CXGenericSelectionExpr E);

// ArrayInitLoopExpr
CXOpaqueValueExpr clang_ArrayInitLoopExpr_getCommonExpr(CXArrayInitLoopExpr E);

CXExpr clang_ArrayInitLoopExpr_getSubExpr(CXArrayInitLoopExpr E);

// PseudoObjectExpr
CXExpr clang_PseudoObjectExpr_getSyntacticForm(CXPseudoObjectExpr E);

// getResultExprIndex returns PseudoObjectExpr::NoResult (~0u) when there is no
// result-bearing semantic expression.
unsigned clang_PseudoObjectExpr_getResultExprIndex(CXPseudoObjectExpr E);

// getResultExpr may be null when the pseudo-object has no result-bearing expr.
CXExpr clang_PseudoObjectExpr_getResultExpr(CXPseudoObjectExpr E);

unsigned clang_PseudoObjectExpr_getNumSemanticExprs(CXPseudoObjectExpr E);

// helper: getSemanticExpr(Index). Index must be < getNumSemanticExprs().
CXExpr clang_PseudoObjectExpr_getSemanticExpr(CXPseudoObjectExpr E, unsigned Index);

// OffsetOfNode
// mirrors clang::OffsetOfNode::Kind (clang/AST/Expr.h; synced by static_assert in
// lib/Basic/CXEnumSync.cpp)
typedef enum CXOffsetOfNode_Kind {
  CXOffsetOfNode_Kind_Array,
  CXOffsetOfNode_Kind_Field,
  CXOffsetOfNode_Kind_Identifier,
  CXOffsetOfNode_Kind_Base
} CXOffsetOfNode_Kind;

CXOffsetOfNode_Kind clang_OffsetOfNode_getKind(CXOffsetOfNode N);

// getArrayExprIndex asserts getKind() == Array, then shifts the payload word; on any
// other kind it reinterprets a pointer as an index. The returned value indexes the
// owning OffsetOfExpr's operand list (clang_OffsetOfExpr_getIndexExpr).
unsigned clang_OffsetOfNode_getArrayExprIndex(CXOffsetOfNode N);

// getField asserts getKind() == Field; on any other kind it reinterprets the payload
// as a FieldDecl *.
CXFieldDecl clang_OffsetOfNode_getField(CXOffsetOfNode N);

// getFieldName asserts getKind() == Field || getKind() == Identifier. It returns null
// for an unnamed (anonymous) field.
CXIdentifierInfo clang_OffsetOfNode_getFieldName(CXOffsetOfNode N);

// getBase asserts getKind() == Base; on any other kind it reinterprets the payload as
// a CXXBaseSpecifier *.
CXCXXBaseSpecifier clang_OffsetOfNode_getBase(CXOffsetOfNode N);

// A Base node is synthesised by Sema from a base-class path and carries no written
// range: its two locations are default-constructed (invalid), unlike the other kinds.
CXSourceRange_ clang_OffsetOfNode_getSourceRange(CXOffsetOfNode N);

CXSourceLocation_ clang_OffsetOfNode_getBeginLoc(CXOffsetOfNode N);

CXSourceLocation_ clang_OffsetOfNode_getEndLoc(CXOffsetOfNode N);

// OffsetOfExpr
CXSourceLocation_ clang_OffsetOfExpr_getOperatorLoc(CXOffsetOfExpr E);

CXSourceLocation_ clang_OffsetOfExpr_getRParenLoc(CXOffsetOfExpr E);

CXTypeSourceInfo clang_OffsetOfExpr_getTypeSourceInfo(CXOffsetOfExpr E);

// getComponent asserts Idx < getNumComponents(). The node is interior to the
// OffsetOfExpr's trailing storage (AST-arena memory): borrowed, never freed.
CXOffsetOfNode clang_OffsetOfExpr_getComponent(CXOffsetOfExpr E, unsigned Idx);

unsigned clang_OffsetOfExpr_getNumComponents(CXOffsetOfExpr E);

// getIndexExpr asserts Idx < getNumExpressions().
CXExpr clang_OffsetOfExpr_getIndexExpr(CXOffsetOfExpr E, unsigned Idx);

unsigned clang_OffsetOfExpr_getNumExpressions(CXOffsetOfExpr E);

// ExtVectorElementExpr
CXIdentifierInfo clang_ExtVectorElementExpr_getAccessor(CXExtVectorElementExpr E);

CXSourceLocation_ clang_ExtVectorElementExpr_getAccessorLoc(CXExtVectorElementExpr E);

bool clang_ExtVectorElementExpr_containsDuplicateElements(CXExtVectorElementExpr E);

bool clang_ExtVectorElementExpr_isArrow(CXExtVectorElementExpr E);

// Expr
// One step only: returns the implicit object argument when E is a call to a conversion
// operator, and E itself otherwise. Total.
CXExpr clang_Expr_IgnoreConversionOperatorSingleStep(CXExpr E);

// Expr
// setType asserts the new type is null or not a reference type (C++ [expr]p6);
// the Julia wrapper restates that precondition (and requires a non-null type).
void clang_Expr_setType(CXExpr E, CXQualType T);

bool clang_Expr_isReadIfDiscardedInCPlusPlus11(CXExpr E);

void clang_Expr_setValueKind(CXExpr E, CXExprValueKind Cat);

void clang_Expr_setObjectKind(CXExpr E, CXExprObjectKind Cat);

// The Expr-returning half of getBestDynamicClassType: it steps out through
// paren/base casts, comma right operands and materialized temporaries, and
// returns E itself when none of those apply. Unlike getBestDynamicClassType it
// requires no class type — it is total.
CXExpr clang_Expr_getBestDynamicClassTypeExpr(CXExpr E);

// The no-argument overload: the vectors collecting the comma left operands and
// the subobject adjustments stay inside the shim, so only the walked-to
// expression crosses.
CXExpr clang_Expr_skipRValueSubobjectAdjustments(CXExpr E);

// FullExpr
CXExpr clang_FullExpr_getSubExpr(CXFullExpr E);

// ConstantExpr
// mirrors clang::ConstantResultStorageKind (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXConstantResultStorageKind {
  CXConstantResultStorageKind_None,
  CXConstantResultStorageKind_Int64,
  CXConstantResultStorageKind_APValue
} CXConstantResultStorageKind;

CXConstantResultStorageKind clang_ConstantExpr_getResultStorageKind(CXConstantExpr E);

// The kind of the folded result cached in E; CXAPValueKind_None means no result
// is cached (the same condition clang_ConstantExpr_hasAPValueResult reports).
CXAPValueKind clang_ConstantExpr_getResultAPValueKind(CXConstantExpr E);

// ShuffleVectorExpr
CXSourceLocation_ clang_ShuffleVectorExpr_getBuiltinLoc(CXShuffleVectorExpr E);

void clang_ShuffleVectorExpr_setBuiltinLoc(CXShuffleVectorExpr E, CXSourceLocation_ L);

CXSourceLocation_ clang_ShuffleVectorExpr_getRParenLoc(CXShuffleVectorExpr E);

void clang_ShuffleVectorExpr_setRParenLoc(CXShuffleVectorExpr E, CXSourceLocation_ L);

// SourceLocExpr
// mirrors clang::SourceLocIdentKind (clang/AST/Expr.h; synced by static_assert
// in lib/Basic/CXEnumSync.cpp)
typedef enum CXSourceLocIdentKind {
  CXSourceLocIdentKind_Function,
  CXSourceLocIdentKind_FuncSig,
  CXSourceLocIdentKind_File,
  CXSourceLocIdentKind_FileName,
  CXSourceLocIdentKind_Line,
  CXSourceLocIdentKind_Column,
  CXSourceLocIdentKind_SourceLocStruct
} CXSourceLocIdentKind;

CXSourceLocIdentKind clang_SourceLocExpr_getIdentKind(CXSourceLocExpr E);

// MayBeDependent is static: Kind is the queried kind, not a receiver.
bool clang_SourceLocExpr_MayBeDependent(CXSourceLocIdentKind Kind);

// BlockExpr
// getFunctionType reaches the signature through
// cast<BlockPointerType>(getType())->getPointeeType()->castAs<FunctionProtoType>(),
// which is unchecked; it is total for a well-formed BlockExpr, whose type is
// always a block pointer to a prototyped function. The Julia wrapper restates
// the block-pointer half.
CXFunctionProtoType clang_BlockExpr_getFunctionType(CXBlockExpr E);

// AtomicExpr
// The four arity-gated operand accessors. Upstream asserts NumSubExprs > slot
// (VAL1 = 2, ORDER_FAIL = 3, VAL2 = 4, WEAK = 5) and the Julia wrappers restate
// that bound. getVal1 and getVal2 additionally special-case two op families
// (__c11_atomic_init/__opencl_atomic_init read slot 1; __atomic_exchange/
// __scoped_atomic_exchange read slot 3) which carry fewer operands; for those,
// read the slot directly with clang_AtomicExpr_getSubExpr.
CXExpr clang_AtomicExpr_getVal1(CXAtomicExpr E);

CXExpr clang_AtomicExpr_getOrderFail(CXAtomicExpr E);

CXExpr clang_AtomicExpr_getVal2(CXAtomicExpr E);

CXExpr clang_AtomicExpr_getWeak(CXAtomicExpr E);

// Expr
// mirrors clang::Expr::isModifiableLvalueResult (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXExpr_isModifiableLvalueResult {
  CXExpr_MLV_Valid,
  CXExpr_MLV_NotObjectType,
  CXExpr_MLV_IncompleteVoidType,
  CXExpr_MLV_DuplicateVectorComponents,
  CXExpr_MLV_InvalidExpression,
  CXExpr_MLV_LValueCast,
  CXExpr_MLV_IncompleteType,
  CXExpr_MLV_ConstQualified,
  CXExpr_MLV_ConstQualifiedField,
  CXExpr_MLV_ConstAddrSpace,
  CXExpr_MLV_ArrayType,
  CXExpr_MLV_NoSetterProperty,
  CXExpr_MLV_MemberFunction,
  CXExpr_MLV_SubObjCPropertySetting,
  CXExpr_MLV_InvalidMessageExpression,
  CXExpr_MLV_ClassTemporary,
  CXExpr_MLV_ArrayTemporary
} CXExpr_isModifiableLvalueResult;

// The optional SourceLocation out-param (the location that makes the lvalue
// non-modifiable) is not exposed.
CXExpr_isModifiableLvalueResult clang_Expr_isModifiableLvalue(CXExpr E, CXASTContext Ctx);

// Folds E only for the side effect of diagnosing signed integer overflow; a
// non-constant E is ignored. Nothing crosses back.
void clang_Expr_EvaluateForOverflow(CXExpr E, CXASTContext Ctx);

// isPotentialConstantExpr is static: FD is the queried function, not a receiver.
// Upstream hands FD->getBody() straight to the constant evaluator, so FD must have
// a definition; the Julia wrapper restates that. The PartialDiagnosticAt vector
// explaining a false result stays inside the shim.
bool clang_Expr_isPotentialConstantExpr(CXFunctionDecl FD);

// hasAnyTypeDependentArguments is static: (Exprs, NumExprs) is the queried array
// (MARSHALLING.md §11), not a receiver. An empty array answers false.
bool clang_Expr_hasAnyTypeDependentArguments(const CXExpr *Exprs, unsigned NumExprs);

// The subexpression to warn on, its location and the two highlight ranges upstream
// fills in stay inside the shim; only the predicate crosses.
bool clang_Expr_isUnusedResultAWarning(CXExpr E, CXASTContext Ctx);

// StringLiteral
// The literal re-spelled as source: encoding prefix, quotes and escapes.
CXString clang_StringLiteral_outputString(CXStringLiteral SL);

// getLocationOfByte asserts a narrow literal kind (Ordinary/UTF8/Unevaluated) and
// walks the concatenated tokens, asserting ByteNo lands inside one of them; the
// Julia wrapper restates both. The two optional out-params (index of the token
// holding the byte, and the byte's offset inside it) are not exposed.
CXSourceLocation_ clang_StringLiteral_getLocationOfByte(CXStringLiteral SL, unsigned ByteNo,
                                                        CXSourceManager SM,
                                                        CXLangOptions Features,
                                                        CXTargetInfo_ Target);

// PredefinedExpr
bool clang_PredefinedExpr_isTransparent(CXPredefinedExpr E);

CXSourceLocation_ clang_PredefinedExpr_getLocation(CXPredefinedExpr E);

// ComputeName is static: IK is the queried kind and CurrentDecl the declaration
// being named, not a receiver. Upstream dereferences CurrentDecl immediately, so it
// must be non-null.
CXString clang_PredefinedExpr_ComputeName(CXPredefinedIdentKind IK, CXDecl CurrentDecl);

// ConstantExpr
// getStorageKind is static: V is the queried value, not a receiver.
CXConstantResultStorageKind clang_ConstantExpr_getStorageKind(CXAPValue V);

// helper: the (const Type *, const ASTContext &) overload of the static
// getStorageKind. It measures an integral or enumeration T with getTypeInfo, so T
// must be complete; the Julia wrapper restates that.
CXConstantResultStorageKind clang_ConstantExpr_getStorageKindForType(CXType_ T,
                                                                     CXASTContext Ctx);

// ShuffleVectorExpr
// getShuffleMaskIdx asserts N < getNumSubExprs() - 2 (the mask starts after the two
// vector operands). The entry crosses as a caller-owned LLVMGenericValueRef (APSInt
// in GV->IntVal, released via llvm-c). See MARSHALLING.md §1.
LLVMGenericValueRef clang_ShuffleVectorExpr_getShuffleMaskIdx(CXShuffleVectorExpr E,
                                                              CXASTContext Ctx, unsigned N);

// ExtVectorElementExpr
// Count+fill over the selected element indices (MARSHALLING.md §6): the count is
// clang_ExtVectorElementExpr_getNumElements and Elts must have room for exactly that
// many entries, all of which are written.
void clang_ExtVectorElementExpr_getEncodedElementAccess(CXExtVectorElementExpr E,
                                                        unsigned *Elts);

// GenericSelectionExpr
// helper: getAssocTypeSourceInfos()[I]. I must be < getNumAssocs(). The slot is null
// for the `default` association, which has no written type.
CXTypeSourceInfo clang_GenericSelectionExpr_getAssocTypeSourceInfo(CXGenericSelectionExpr E,
                                                                   unsigned I);

// ArrayInitLoopExpr
// getArraySize reaches the extent through an unchecked
// cast<ConstantArrayType>(getType()->castAsArrayTypeUnsafe()); the Julia wrapper
// restates that the loop's type is a constant array. The extent crosses as a
// caller-owned LLVMGenericValueRef (APInt in GV->IntVal). See MARSHALLING.md §1.
LLVMGenericValueRef clang_ArrayInitLoopExpr_getArraySize(CXArrayInitLoopExpr E);

// DesignatedInitExpr::Designator
CXSourceRange_ clang_Designator_getSourceRange(CXDesignator D);

// ParenExpr
void clang_ParenExpr_setSubExpr(CXParenExpr E, CXExpr SubExpr);

void clang_ParenExpr_setLParen(CXParenExpr E, CXSourceLocation_ L);

void clang_ParenExpr_setRParen(CXParenExpr E, CXSourceLocation_ L);

// UnaryOperator
void clang_UnaryOperator_setOpcode(CXUnaryOperator UO, CXUnaryOperatorKind Opc);

void clang_UnaryOperator_setSubExpr(CXUnaryOperator UO, CXExpr E);

void clang_UnaryOperator_setCanOverflow(CXUnaryOperator UO, bool C);

// ArraySubscriptExpr
// setLHS/setRHS write the syntactic operands: for the reversed spelling 4[A] the
// LHS is the index, not the base.
void clang_ArraySubscriptExpr_setLHS(CXArraySubscriptExpr E, CXExpr LHS);

void clang_ArraySubscriptExpr_setRHS(CXArraySubscriptExpr E, CXExpr RHS);

void clang_ArraySubscriptExpr_setRBracketLoc(CXArraySubscriptExpr E, CXSourceLocation_ L);

// BinaryOperator
void clang_BinaryOperator_setOpcode(CXBinaryOperator BO, CXBinaryOperatorKind Opc);

void clang_BinaryOperator_setLHS(CXBinaryOperator BO, CXExpr E);

void clang_BinaryOperator_setRHS(CXBinaryOperator BO, CXExpr E);

void clang_BinaryOperator_setOperatorLoc(CXBinaryOperator BO, CXSourceLocation_ L);

// CharacterLiteral
void clang_CharacterLiteral_setValue(CXCharacterLiteral CL, unsigned Val);

void clang_CharacterLiteral_setKind(CXCharacterLiteral CL, CXCharacterLiteralKind Kind);

void clang_CharacterLiteral_setLocation(CXCharacterLiteral CL, CXSourceLocation_ L);

// print is static: (Val, Kind) is the queried literal, not a receiver. The literal
// re-spelled as source (encoding prefix, quotes and escapes) crosses as a CXString.
CXString clang_CharacterLiteral_print(unsigned Val, CXCharacterLiteralKind Kind);

// GenericSelectionExpr
// getControllingType reaches the trailing TypeSourceInfo through an index that
// asserts isTypePredicate(); the Julia wrapper restates that.
CXTypeSourceInfo clang_GenericSelectionExpr_getControllingType(CXGenericSelectionExpr E);

// AtomicExpr
// helper: whether the operation carries a synchronisation-scope operand, i.e.
// whether getScopeModel() is non-null. Only the OpenCL, HIP and __scoped_atomic_*
// op families do. This is the gate clang_AtomicExpr_getScope asserts on
// (MARSHALLING.md §13).
bool clang_AtomicExpr_hasScopeModel(CXAtomicExpr E);

// getScope reads the last operand slot and asserts getScopeModel(); the Julia
// wrapper restates that precondition through clang_AtomicExpr_hasScopeModel.
CXExpr clang_AtomicExpr_getScope(CXAtomicExpr E);

// FullExpr
// setSubExpr rewrites the wrapped subexpression in place; the full expression's own
// dependence bits are not recomputed.
void clang_FullExpr_setSubExpr(CXFullExpr E, CXExpr SubExpr);

// DeclRefExpr
// setDecl reads NewD's type and its ASTContext while recomputing the reference's
// dependence bits, so NewD must be non-null.
void clang_DeclRefExpr_setDecl(CXDeclRefExpr E, CXValueDecl NewD);

void clang_DeclRefExpr_setHadMultipleCandidates(CXDeclRefExpr E, bool V);

// UnaryExprOrTypeTraitExpr
// setKind asserts the kind fits the bit-field; every CXUnaryExprOrTypeTrait enumerator
// does.
void clang_UnaryExprOrTypeTraitExpr_setKind(CXUnaryExprOrTypeTraitExpr E,
                                            CXUnaryExprOrTypeTrait K);

// helper: the setArgument(Expr *) overload, which also clears isArgumentType(). The
// setArgument(TypeSourceInfo *) overload is not exposed.
void clang_UnaryExprOrTypeTraitExpr_setArgumentExpr(CXUnaryExprOrTypeTraitExpr E,
                                                    CXExpr Arg);

// CallExpr
void clang_CallExpr_setCallee(CXCallExpr CE, CXExpr F);

// setArg asserts Arg < getNumArgs(). Upstream leaves the call's dependence bits stale
// afterwards; recomputing them is the caller's job.
void clang_CallExpr_setArg(CXCallExpr CE, unsigned Arg, CXExpr ArgExpr);

// MemberExpr
void clang_MemberExpr_setBase(CXMemberExpr E, CXExpr Base);

// setMemberDecl reads D's type while recomputing the access's dependence bits, so D
// must be non-null.
void clang_MemberExpr_setMemberDecl(CXMemberExpr E, CXValueDecl D);

void clang_MemberExpr_setArrow(CXMemberExpr E, bool A);

void clang_MemberExpr_setHadMultipleCandidates(CXMemberExpr E, bool V);

// CastExpr
void clang_CastExpr_setCastKind(CXCastExpr E, CXCastKind K);

void clang_CastExpr_setSubExpr(CXCastExpr E, CXExpr SubExpr);

// ImplicitCastExpr
void clang_ImplicitCastExpr_setIsPartOfExplicitCast(CXImplicitCastExpr E,
                                                    bool PartOfExplicitCast);

// ExplicitCastExpr
void clang_ExplicitCastExpr_setTypeInfoAsWritten(CXExplicitCastExpr E,
                                                 CXTypeSourceInfo WrittenTy);

// InitListExpr
// setInit asserts Init < getNumInits(); a non-null Val's dependence bits are folded
// into the list's.
void clang_InitListExpr_setInit(CXInitListExpr E, unsigned Init, CXExpr Val);

// setArrayFiller asserts !hasArrayFiller() and additionally writes the filler into
// every still-empty slot of the list.
void clang_InitListExpr_setArrayFiller(CXInitListExpr E, CXExpr Filler);

// setInitializedFieldInUnion asserts no other field is recorded yet (only one member
// of a union may be initialized).
void clang_InitListExpr_setInitializedFieldInUnion(CXInitListExpr E, CXFieldDecl FD);

// setSyntacticForm makes Init the syntactic form of E and E the semantic form of Init,
// writing both objects; Init must be non-null.
void clang_InitListExpr_setSyntacticForm(CXInitListExpr E, CXInitListExpr Init);

void clang_InitListExpr_sawArrayRangeDesignator(CXInitListExpr E, bool ARD);

// UnaryOperator
// isFPContractableWithinStatement / isFEnvAccessOn read the operator's stored FP
// features overridden by LO. Both are total: the stored-features branch of
// getFPFeaturesInEffect is guarded by the HasFPFeatures bit, so no assert fires.
// Only meaningful for operations on floating-point types.
bool clang_UnaryOperator_isFPContractableWithinStatement(CXUnaryOperator UO,
                                                         CXLangOptions LO);

bool clang_UnaryOperator_isFEnvAccessOn(CXUnaryOperator UO, CXLangOptions LO);

// UnaryExprOrTypeTraitExpr
void clang_UnaryExprOrTypeTraitExpr_setOperatorLoc(CXUnaryExprOrTypeTraitExpr E,
                                                   CXSourceLocation_ L);

void clang_UnaryExprOrTypeTraitExpr_setRParenLoc(CXUnaryExprOrTypeTraitExpr E,
                                                 CXSourceLocation_ L);

// BinaryOperator
// Same shape and same totality as the UnaryOperator pair above.
bool clang_BinaryOperator_isFPContractableWithinStatement(CXBinaryOperator BO,
                                                          CXLangOptions LO);

bool clang_BinaryOperator_isFEnvAccessOn(CXBinaryOperator BO, CXLangOptions LO);

// StmtExpr
// setSubStmt stores S unchecked; getSubStmt then cast<CompoundStmt>s the slot, so S
// must be a CompoundStmt and non-null. The statement expression's dependence bits and
// template depth are not recomputed.
void clang_StmtExpr_setSubStmt(CXStmtExpr E, CXCompoundStmt S);

void clang_StmtExpr_setLParenLoc(CXStmtExpr E, CXSourceLocation_ L);

void clang_StmtExpr_setRParenLoc(CXStmtExpr E, CXSourceLocation_ L);

// ChooseExpr
// setIsConditionTrue overwrites the cached "condition is non-zero" flag without
// re-evaluating the condition, so a value inconsistent with getCond() makes
// getChosenSubExpr() report the other arm.
void clang_ChooseExpr_setIsConditionTrue(CXChooseExpr E, bool IsTrue);

// setCond/setLHS/setRHS store the operand unchecked; the matching getters cast<Expr>
// the slot, so each operand must be non-null. Upstream leaves the choose expression's
// dependence bits stale afterwards; recomputing them is the caller's job.
void clang_ChooseExpr_setCond(CXChooseExpr E, CXExpr Cond);

void clang_ChooseExpr_setLHS(CXChooseExpr E, CXExpr LHS);

void clang_ChooseExpr_setRHS(CXChooseExpr E, CXExpr RHS);

void clang_ChooseExpr_setBuiltinLoc(CXChooseExpr E, CXSourceLocation_ L);

void clang_ChooseExpr_setRParenLoc(CXChooseExpr E, CXSourceLocation_ L);

// VAArgExpr
// setSubExpr stores Sub unchecked; getSubExpr cast<Expr>s the slot, so Sub must be
// non-null. The dependence bits are not recomputed.
void clang_VAArgExpr_setSubExpr(CXVAArgExpr E, CXExpr Sub);

void clang_VAArgExpr_setIsMicrosoftABI(CXVAArgExpr E, bool IsMS);

// setWrittenTypeInfo writes the pointer half of a PointerIntPair, leaving the
// Microsoft-ABI flag that shares the word untouched.
void clang_VAArgExpr_setWrittenTypeInfo(CXVAArgExpr E, CXTypeSourceInfo TI);

void clang_VAArgExpr_setBuiltinLoc(CXVAArgExpr E, CXSourceLocation_ L);

void clang_VAArgExpr_setRParenLoc(CXVAArgExpr E, CXSourceLocation_ L);

// OpaqueValueExpr
// setIsUnique asserts that a unique opaque value has a source expression; the Julia
// wrapper restates that through clang_OpaqueValueExpr_getSourceExpr.
void clang_OpaqueValueExpr_setIsUnique(CXOpaqueValueExpr E, bool V);

// PredefinedExpr
void clang_PredefinedExpr_setLocation(CXPredefinedExpr E, CXSourceLocation_ L);

// CompoundLiteralExpr
// setInitializer stores Init unchecked; getInitializer cast<Expr>s the slot, so Init must
// be non-null. The literal's dependence bits are not recomputed.
void clang_CompoundLiteralExpr_setInitializer(CXCompoundLiteralExpr E, CXExpr Init);

void clang_CompoundLiteralExpr_setFileScope(CXCompoundLiteralExpr E, bool FS);

void clang_CompoundLiteralExpr_setLParenLoc(CXCompoundLiteralExpr E, CXSourceLocation_ L);

// setTypeSourceInfo writes the pointer half of a PointerIntPair, leaving the file-scope
// flag that shares the word untouched.
void clang_CompoundLiteralExpr_setTypeSourceInfo(CXCompoundLiteralExpr E,
                                                 CXTypeSourceInfo TI);

// CompoundAssignOperator
void clang_CompoundAssignOperator_setComputationLHSType(CXCompoundAssignOperator CAO,
                                                        CXQualType T);

void clang_CompoundAssignOperator_setComputationResultType(CXCompoundAssignOperator CAO,
                                                           CXQualType T);

// AddrLabelExpr
void clang_AddrLabelExpr_setAmpAmpLoc(CXAddrLabelExpr E, CXSourceLocation_ L);

void clang_AddrLabelExpr_setLabelLoc(CXAddrLabelExpr E, CXSourceLocation_ L);

// setLabel stores L unchecked; getLabel hands the slot straight back, so a null L makes
// every later reader see a null label.
void clang_AddrLabelExpr_setLabel(CXAddrLabelExpr E, CXLabelDecl L);

// ConvertVectorExpr
void clang_ConvertVectorExpr_setTypeSourceInfo(CXConvertVectorExpr E, CXTypeSourceInfo TI);

// GNUNullExpr
void clang_GNUNullExpr_setTokenLocation(CXGNUNullExpr E, CXSourceLocation_ L);

// DesignatedInitUpdateExpr
// getBase cast<Expr>s the base slot, so it must hold a non-null expression.
CXExpr clang_DesignatedInitUpdateExpr_getBase(CXDesignatedInitUpdateExpr E);

void clang_DesignatedInitUpdateExpr_setBase(CXDesignatedInitUpdateExpr E, CXExpr Base);

// getUpdater cast<InitListExpr>s the updater slot, so it must hold a non-null
// InitListExpr — upstream types the setter's parameter as Expr * anyway.
CXInitListExpr clang_DesignatedInitUpdateExpr_getUpdater(CXDesignatedInitUpdateExpr E);

void clang_DesignatedInitUpdateExpr_setUpdater(CXDesignatedInitUpdateExpr E,
                                               CXInitListExpr Updater);

// ExtVectorElementExpr
// setBase stores Base unchecked; getBase cast<Expr>s the slot, so Base must be non-null.
// The dependence bits are not recomputed.
void clang_ExtVectorElementExpr_setBase(CXExtVectorElementExpr E, CXExpr Base);

// setAccessor stores II unchecked; getAccessor dereferences the slot, so II must be
// non-null.
void clang_ExtVectorElementExpr_setAccessor(CXExtVectorElementExpr E, CXIdentifierInfo II);

void clang_ExtVectorElementExpr_setAccessorLoc(CXExtVectorElementExpr E,
                                               CXSourceLocation_ L);

// Expr
// mirrors clang::Expr::LValueClassification (clang/AST/Expr.h; synced by
// static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXExpr_LValueClassification {
  CXExpr_LV_Valid,
  CXExpr_LV_NotObjectType,
  CXExpr_LV_IncompleteVoidType,
  CXExpr_LV_DuplicateVectorComponents,
  CXExpr_LV_InvalidExpression,
  CXExpr_LV_InvalidMessageExpression,
  CXExpr_LV_MemberFunction,
  CXExpr_LV_SubObjCPropertySetting,
  CXExpr_LV_ClassTemporary,
  CXExpr_LV_ArrayTemporary
} CXExpr_LValueClassification;

// The coarse view of the Classify taxonomy: CXExpr_LV_Valid means E is an l-value, every
// other enumerator names the reason it is not.
CXExpr_LValueClassification clang_Expr_ClassifyLValue(CXExpr E, CXASTContext Ctx);

// The opaque integer encoding of clang::FPOptions (MARSHALLING.md §7): the settings in
// effect for E once LO's defaults and any trailing override slot are folded together.
// Total — an expression with no slot reads FPOptions::defaultWithoutTrailingStorage(LO).
unsigned clang_Expr_getFPFeaturesInEffect(CXExpr E, CXLangOptions LO);

// PARTIAL: the constant evaluator asserts that E is not value-dependent. Static — FD is
// the hypothetical enclosing function, not a receiver. The diagnostics explaining a false
// answer are not exposed.
bool clang_Expr_isPotentialConstantExprUnevaluated(CXExpr E, CXFunctionDecl FD);

// PARTIAL: clang::Expr::EvaluateAsInitializer asserts that E is not value-dependent.
// Returns an OWNED CXAPValue (dispose via clang_APValue_dispose) when E folds to a
// constant initializer for VD, or nullptr otherwise. See CXAPValue.h / MARSHALLING.md §3.
// The notes explaining a failure are not exposed.
CXAPValue clang_Expr_EvaluateAsInitializer(CXExpr E, CXASTContext Ctx, CXVarDecl VD,
                                           bool IsConstantInitializer);

// PARTIAL: clang::Expr::EvaluateWithSubstitution asserts that E is not value-dependent.
// Args is a (buffer, count) pair matched positionally against Callee's parameters
// (MARSHALLING.md §11); This is the object argument of a member call, or nullptr.
// Returns an OWNED CXAPValue on success, nullptr when E does not fold.
CXAPValue clang_Expr_EvaluateWithSubstitution(CXExpr E, CXASTContext Ctx,
                                              CXFunctionDecl Callee, const CXExpr *Args,
                                              unsigned NumArgs, CXExpr This);

// CallExpr
// UsesADL is clang::CallExpr::ADLCallKind flattened to a bool (NotADL / UsesADL);
// clang_CallExpr_usesADL reads the same flag back.
void clang_CallExpr_setADLCallKind(CXCallExpr E, bool UsesADL);

// CastExpr
// The same FPOptionsOverride opaque integer encoding as BinaryOperator/CallExpr;
// getFPFeatures is guarded by the HasFPFeatures bit and yields the default-constructed
// (zero) encoding when the cast has no trailing slot, so it is total.
uint64_t clang_CastExpr_getFPFeatures(CXCastExpr E);

// PARTIAL: clang::CastExpr::getStoredFPFeatures asserts hasStoredFPFeatures().
uint64_t clang_CastExpr_getStoredFPFeatures(CXCastExpr E);

// OffsetOfExpr
void clang_OffsetOfExpr_setOperatorLoc(CXOffsetOfExpr E, CXSourceLocation_ L);

void clang_OffsetOfExpr_setRParenLoc(CXOffsetOfExpr E, CXSourceLocation_ R);

// setTypeSourceInfo stores TSI unchecked; getTypeSourceInfo hands the slot straight back,
// so a null TSI makes every later reader see a null record type.
void clang_OffsetOfExpr_setTypeSourceInfo(CXOffsetOfExpr E, CXTypeSourceInfo TSI);

// PARTIAL: the index-expression array holds getNumExpressions() slots, so Idx must be
// below that. Upstream's own assert compares Idx against getNumComponents(), which is the
// larger of the two and therefore does not bound the write.
void clang_OffsetOfExpr_setIndexExpr(CXOffsetOfExpr E, unsigned Idx, CXExpr Value);

// InitListExpr
// reserveInits only grows the backing storage; getNumInits is unchanged.
void clang_InitListExpr_reserveInits(CXInitListExpr E, CXASTContext C, unsigned NumInits);

// Replaces the initializer at Init and returns the one it displaced. An Init past the end
// extends the list with null entries first, in which case the return is null.
CXExpr clang_InitListExpr_updateInit(CXInitListExpr E, CXASTContext C, unsigned Init,
                                     CXExpr Value);

// PARTIAL: clang::InitListExpr::markError asserts isSemanticForm().
void clang_InitListExpr_markError(CXInitListExpr E);

// DesignatedInitExpr
void clang_DesignatedInitExpr_setEqualOrColonLoc(CXDesignatedInitExpr E,
                                                 CXSourceLocation_ L);

void clang_DesignatedInitExpr_setGNUSyntax(CXDesignatedInitExpr E, bool GNU);

// setInit stores Init unchecked; getInit cast<Expr>s the slot, so Init must be non-null.
void clang_DesignatedInitExpr_setInit(CXDesignatedInitExpr E, CXExpr Init);

// PARTIAL: clang::DesignatedInitExpr::setSubExpr asserts Idx < getNumSubExprs().
void clang_DesignatedInitExpr_setSubExpr(CXDesignatedInitExpr E, unsigned Idx,
                                         CXExpr Value);

// SourceLocExpr
// Returns an OWNED CXAPValue (dispose via clang_APValue_dispose) holding what E evaluates
// to. DefaultExpr may be nullptr, in which case E's own location and parent context are
// used instead of a default-argument/default-initializer use site.
CXAPValue clang_SourceLocExpr_EvaluateInContext(CXSourceLocExpr E, CXASTContext Ctx,
                                                CXExpr DefaultExpr);

// CallExpr
// computeDependence recomputes the call's dependence bits from its callee and its
// arguments; clang_CallExpr_setArg deliberately leaves them stale and this is the
// recomputation it defers to the caller.
void clang_CallExpr_computeDependence(CXCallExpr CE);

// markDependentForPostponedNameLookup ORs the type/value/instantiation dependence bits in
// unconditionally (MSVC-compatible delayed name lookup); it never clears them.
// clang_CallExpr_computeDependence is the way back.
void clang_CallExpr_markDependentForPostponedNameLookup(CXCallExpr CE);

// PARTIAL: clang::CallExpr::shrinkNumArgs asserts NewNumArgs <= getNumArgs(); the trailing
// argument array can never be grown back.
void clang_CallExpr_shrinkNumArgs(CXCallExpr CE, unsigned NewNumArgs);

// InitListExpr
// resizeInits makes getNumInits() exactly NumInits: growing appends null slots, shrinking
// truncates the tail and leaves the surviving entries untouched.
void clang_InitListExpr_resizeInits(CXInitListExpr E, CXASTContext C, unsigned NumInits);

// DeclRefExpr
void clang_DeclRefExpr_setIsImmediateEscalating(CXDeclRefExpr E, bool Set);

// FloatingLiteral
void clang_FloatingLiteral_setExact(CXFloatingLiteral E, bool Exact);

// BinaryOperator
// helper: the static clang::BinaryOperator::isCompoundAssignmentOp(Opcode) overload — the
// receiver-taking spelling is clang_BinaryOperator_isCompoundAssignmentOp. This is the gate
// clang_BinaryOperator_Create and clang_CompoundAssignOperator_Create assert on.
bool clang_BinaryOperator_isCompoundAssignmentOpKind(CXBinaryOperatorKind Opc);

// PARTIAL: clang::BinaryOperator's constructor asserts !isCompoundAssignmentOp(Opc) — a
// compound assignment must go through clang_CompoundAssignOperator_Create. FPFeatures is
// the opaque clang::FPOptionsOverride encoding; 0 means "no override" and is the only value
// that leaves hasStoredFPFeatures false.
CXBinaryOperator clang_BinaryOperator_Create(CXASTContext C, CXExpr LHS, CXExpr RHS,
                                             CXBinaryOperatorKind Opc, CXQualType ResTy,
                                             CXExprValueKind VK, CXExprObjectKind OK,
                                             CXSourceLocation_ OpLoc, uint64_t FPFeatures);

// The shell clang deserializes into: the opcode starts at BO_Comma and the type is null,
// but both operand slots are left uninitialized, so clang_BinaryOperator_setLHS/setRHS must
// run before any reader touches them.
CXBinaryOperator clang_BinaryOperator_CreateEmpty(CXASTContext C, bool HasFPFeatures);

// CompoundAssignOperator
// PARTIAL: the mirror precondition — clang::CompoundAssignOperator's constructor asserts
// isCompoundAssignmentOp(Opc).
CXCompoundAssignOperator clang_CompoundAssignOperator_Create(
    CXASTContext C, CXExpr LHS, CXExpr RHS, CXBinaryOperatorKind Opc, CXQualType ResTy,
    CXExprValueKind VK, CXExprObjectKind OK, CXSourceLocation_ OpLoc, uint64_t FPFeatures,
    CXQualType CompLHSType, CXQualType CompResultType);

// UnaryOperator
// FPFeatures is the same opaque clang::FPOptionsOverride encoding as above.
CXUnaryOperator clang_UnaryOperator_Create(CXASTContext C, CXExpr Input,
                                           CXUnaryOperatorKind Opc, CXQualType Type,
                                           CXExprValueKind VK, CXExprObjectKind OK,
                                           CXSourceLocation_ L, bool CanOverflow,
                                           uint64_t FPFeatures);

// ImplicitCastExpr
// The inheritance path is always empty: clang::ImplicitCastExpr::Create's optional
// CXXCastPath is passed as nullptr and is not exposed. FPO is the opaque
// clang::FPOptionsOverride encoding.
CXImplicitCastExpr clang_ImplicitCastExpr_Create(CXASTContext C, CXQualType T, CXCastKind K,
                                                 CXExpr Op, CXExprValueKind VK,
                                                 uint64_t FPO);

// The shell clang deserializes into: the operand slot and the cast kind are left
// uninitialized, so clang_CastExpr_setSubExpr and clang_CastExpr_setCastKind must run
// before any reader touches them.
CXImplicitCastExpr clang_ImplicitCastExpr_CreateEmpty(CXASTContext C, unsigned PathSize,
                                                      bool HasFPFeatures);

// MemberExpr
// CreateImplicit reads MemberDecl->getAccess(), so MemberDecl must be non-null. The access
// it builds carries no nested-name qualifier, no explicit template arguments and no written
// source locations.
CXMemberExpr clang_MemberExpr_CreateImplicit(CXASTContext C, CXExpr Base, bool IsArrow,
                                             CXValueDecl MemberDecl, CXQualType T,
                                             CXExprValueKind VK, CXExprObjectKind OK);

// PredefinedExpr
// SL may be null, in which case the expression carries no function-name literal and
// clang_PredefinedExpr_getFunctionName returns null.
CXPredefinedExpr clang_PredefinedExpr_Create(CXASTContext C, CXSourceLocation_ L,
                                             CXQualType FNTy, CXPredefinedIdentKind IK,
                                             bool IsTransparent, CXStringLiteral SL);

// ParenListExpr
// Exprs is a (buffer, count) pair rebuilt as an ArrayRef (MARSHALLING.md section 11); the
// expressions are copied into the node's trailing storage, so the buffer need not outlive
// the call. An empty list is allowed.
CXParenListExpr clang_ParenListExpr_Create(CXASTContext C, CXSourceLocation_ LParenLoc,
                                           const CXExpr *Exprs, unsigned NumExprs,
                                           CXSourceLocation_ RParenLoc);

// ConstantExpr
// Create caches Result in the node, sizing the trailing result storage from
// clang_ConstantExpr_getStorageKind(Result). Result is copied, so the caller keeps
// ownership of its CXAPValue.
CXConstantExpr clang_ConstantExpr_Create(CXASTContext C, CXExpr E, CXAPValue Result);

// The shell clang deserializes into: clang::FullExpr's EmptyShell constructor leaves the
// wrapped subexpression uninitialized, so clang_FullExpr_setSubExpr must run before any
// reader touches it. Only the result-storage accessors are safe beforehand.
CXConstantExpr clang_ConstantExpr_CreateEmpty(CXASTContext C,
                                              CXConstantResultStorageKind StorageKind);

// RecoveryExpr
// SubExprs is a (buffer, count) pair rebuilt as an ArrayRef (MARSHALLING.md section 11).
// PARTIAL: clang::RecoveryExpr's constructor dereferences T and asserts both that T is
// non-null and that no slot of SubExprs is null. An empty list is allowed.
CXRecoveryExpr clang_RecoveryExpr_Create(CXASTContext C, CXQualType T,
                                         CXSourceLocation_ BeginLoc,
                                         CXSourceLocation_ EndLoc, const CXExpr *SubExprs,
                                         unsigned NumSubExprs);

// helper: getNumSubExpressions + getSubExpression are the count+index pair over
// clang::RecoveryExpr::subExpressions() (MARSHALLING.md section 6); the count is exact and
// no slot is null.
unsigned clang_RecoveryExpr_getNumSubExpressions(CXRecoveryExpr E);

// helper: subExpressions()[I]. I must be < clang_RecoveryExpr_getNumSubExpressions(E).
CXExpr clang_RecoveryExpr_getSubExpression(CXRecoveryExpr E, unsigned I);

// Expr
// Fold E to a fixed-point constant. Returns an OWNED CXAPValue (dispose via
// clang_APValue_dispose) on success, or nullptr when E is not a fixed-point constant.
// The evaluator rejects every expression whose type is not a fixed-point type before it
// folds anything, so a translation unit built without -ffixed-point never succeeds here.
CXAPValue clang_Expr_EvaluateAsFixedPoint(CXExpr E, CXASTContext Ctx);

// ConstantExpr
// PARTIAL: clang::ConstantExpr::MoveIntoResult asserts
// clang_ConstantExpr_getStorageKind(Value) <= clang_ConstantExpr_getResultStorageKind(E),
// and its Int64 branch then reads Value's integer outright, so a node whose result storage
// is Int64 additionally needs an integral Value. Value is copied; the caller keeps it.
void clang_ConstantExpr_SetResult(CXConstantExpr E, CXAPValue Value, CXASTContext Ctx);

// FloatingLiteral
// The raw llvm::APFloatBase::Semantics enumerator naming the literal's float format
// (32-bit IEEE, x87, ...). It crosses as a plain unsigned rather than as a mirrored enum
// because the enumeration is LLVM's, not Clang's (MARSHALLING.md section 0).
unsigned clang_FloatingLiteral_getRawSemantics(CXFloatingLiteral E);

// setRawSemantics reinterprets the stored bit pattern under the new format instead of
// converting it, so a Sem inconsistent with that pattern changes the value read back.
void clang_FloatingLiteral_setRawSemantics(CXFloatingLiteral E, unsigned Sem);

// Value is the bit pattern an llvm::APFloat of E's OWN semantics bitcasts to - the
// encoding clang_FloatingLiteral_getValue returns in GV->IntVal (MARSHALLING.md section
// 2). Rebuilding the APFloat with getSemantics() inside the shim is what keeps
// clang::FloatingLiteral::setValue's "Inconsistent semantics" assert satisfied, so
// Value's width must match those semantics. The GenericValue stays the caller's.
void clang_FloatingLiteral_setValue(CXFloatingLiteral E, CXASTContext C,
                                    LLVMGenericValueRef Value);

// ImaginaryLiteral
// setSubExpr stores S unchecked; getSubExpr cast<Expr>s the slot, so S must be non-null.
// The literal's dependence bits are not recomputed.
void clang_ImaginaryLiteral_setSubExpr(CXImaginaryLiteral E, CXExpr S);

// MatrixSubscriptExpr
// The operand setters store their argument unchecked and recompute no dependence bits.
// getBase and getRowIdx cast<Expr> their slot, so both must stay non-null.
void clang_MatrixSubscriptExpr_setBase(CXMatrixSubscriptExpr E, CXExpr Base);

void clang_MatrixSubscriptExpr_setRowIdx(CXMatrixSubscriptExpr E, CXExpr RowIdx);

// The column slot is read with cast_or_null and may legitimately be null - the incomplete
// subscript an unfinished m[i] carries; this wrapper only ever writes a real operand.
void clang_MatrixSubscriptExpr_setColumnIdx(CXMatrixSubscriptExpr E, CXExpr ColumnIdx);

void clang_MatrixSubscriptExpr_setRBracketLoc(CXMatrixSubscriptExpr E, CXSourceLocation_ L);

// CallExpr
// getNumRawSubExprs + getRawSubExpr are the count+index pair over
// clang::CallExpr::getRawSubExprs() (MARSHALLING.md section 6) - the callee, the pre-args
// and the arguments in one flat view, which is why the count exceeds getNumArgs. Slot 0
// is always the callee; the count is exact.
unsigned clang_CallExpr_getNumRawSubExprs(CXCallExpr E);

// helper: getRawSubExprs()[I]. I must be < clang_CallExpr_getNumRawSubExprs(E). A slot
// of a still-building call may be null.
CXStmt clang_CallExpr_getRawSubExpr(CXCallExpr E, unsigned I);

// PARTIAL: clang::CallExpr::setStoredFPFeatures asserts hasStoredFPFeatures() - the
// trailing slot exists only when the call was allocated with one. F is the same opaque
// FPOptionsOverride encoding clang_CallExpr_getStoredFPFeatures returns.
void clang_CallExpr_setStoredFPFeatures(CXCallExpr E, uint64_t F);

// BinaryOperator
// PARTIAL: clang::BinaryOperator::setStoredFPFeatures asserts the HasFPFeatures bit. F is
// the same opaque FPOptionsOverride encoding clang_BinaryOperator_getStoredFPFeatures
// returns.
void clang_BinaryOperator_setStoredFPFeatures(CXBinaryOperator BO, uint64_t F);

// ShuffleVectorExpr
// Exprs is a (buffer, count) pair rebuilt as an ArrayRef (MARSHALLING.md section 11). The
// operands are copied into freshly allocated ASTContext storage and the previous array is
// deallocated, so the buffer need not outlive the call. Upstream casts every slot to Expr
// and constant-folds slots 2 and up, so the first two entries must be the vector operands
// and the rest integer constant expressions.
void clang_ShuffleVectorExpr_setExprs(CXShuffleVectorExpr E, CXASTContext C,
                                      const CXExpr *Exprs, unsigned NumExprs);

// DesignatedInitExpr::Designator
// PARTIAL: setFieldDecl asserts isFieldDesignator(). FD replaces whatever the field slot
// held, including a still-unresolved identifier.
void clang_Designator_setFieldDecl(CXDesignator D, CXFieldDecl FD);

// BlockExpr
// setBlockDecl stores BD unchecked; getCaretLocation, getBody and getFunctionType all
// reach through the slot, so BD must be non-null before any of them runs.
void clang_BlockExpr_setBlockDecl(CXBlockExpr E, CXBlockDecl BD);

// Expr
// The whole clang::ExprDependence bitmask in one call. It is an LLVM bitmask enum whose
// combined enumerators (TypeValue, TypeValueInstantiation, ErrorDependent, ...) duplicate
// values, which a Julia @enum rejects, so it is not mirrored; the bits
// (clang/AST/DependenceFlags.h) are 1 UnexpandedPack, 2 Instantiation, 4 Type, 8 Value and
// 16 Error. The numbering is NOT the one clang_Type_getDependence returns.
unsigned clang_Expr_getDependence(CXExpr E);

// Total — E may be any expression. StrictFlexArraysLevel selects the -fstrict-flex-arrays
// rule to apply instead of being read out of Ctx, so the answer does not depend on how the
// translation unit was configured; an expression that is not a member, declaration or ivar
// reference, or whose type is neither a constant nor an incomplete array, answers false.
bool clang_Expr_isFlexibleArrayMemberLike(CXExpr E, CXASTContext Ctx,
                                          CXStrictFlexArraysLevelKind StrictFlexArraysLevel,
                                          bool IgnoreTemplateOrMacroSubstitution);

// StringLiteral
// PARTIAL: for every Kind but Unevaluated clang asserts that Ty is a constant array type,
// and that StrLen is a whole multiple of the Kind's character width. Str is a
// (pointer, length) byte pair copied into Ctx's arena, so it need not outlive the call.
// Locs is a (buffer, count) pair holding the start location of each concatenated token
// (MARSHALLING.md section 11); NumConcatenated must be at least 1 and must match the number
// of locations supplied.
CXStringLiteral clang_StringLiteral_Create(CXASTContext Ctx, const char *Str, size_t StrLen,
                                           CXStringLiteralKind Kind, bool Pascal,
                                           CXQualType Ty, const CXSourceLocation_ *Locs,
                                           unsigned NumConcatenated);

// The empty string-literal shell clang deserializes into. NumConcatenated, Length and
// CharByteWidth are stored and read back; the Length * CharByteWidth character bytes, the
// NumConcatenated token locations and the expression's type are left uninitialized.
CXStringLiteral clang_StringLiteral_CreateEmpty(CXASTContext Ctx, unsigned NumConcatenated,
                                                unsigned Length, unsigned CharByteWidth);

// PredefinedExpr
// The empty __func__-family shell clang deserializes into. The identifier kind, the source
// location and the HasFunctionName string-literal slot are left uninitialized, so only the
// node's statement class may be read straight away.
CXPredefinedExpr clang_PredefinedExpr_CreateEmpty(CXASTContext Ctx, bool HasFunctionName);

// UnaryOperator
// The empty unary-operator shell clang deserializes into. The operand, the opcode, the
// operator location and the HasFPFeatures trailing FPOptionsOverride are left
// uninitialized, so only the node's statement class may be read straight away.
CXUnaryOperator clang_UnaryOperator_CreateEmpty(CXASTContext C, bool HasFPFeatures);

// OffsetOfExpr
// The empty __builtin_offsetof shell clang deserializes into. NumComps and NumExprs are
// stored, but the component slots, the index-expression slots, the type and the source
// locations behind them are left uninitialized.
CXOffsetOfExpr clang_OffsetOfExpr_CreateEmpty(CXASTContext C, unsigned NumComps,
                                              unsigned NumExprs);

// CallExpr
// The empty call shell clang deserializes into. NumArgs is stored and reads back, but the
// callee slot, the argument slots and the HasFPFeatures trailing FPOptionsOverride are left
// uninitialized.
CXCallExpr clang_CallExpr_CreateEmpty(CXASTContext Ctx, unsigned NumArgs,
                                      bool HasFPFeatures);

// MemberExpr
// The empty member-access shell clang deserializes into. The base, the member declaration
// and every trailing slot the four shape flags reserve are left uninitialized, so only the
// node's statement class may be read straight away.
CXMemberExpr clang_MemberExpr_CreateEmpty(CXASTContext Context, bool HasQualifier,
                                          bool HasFoundDecl, bool HasTemplateKWAndArgsInfo,
                                          unsigned NumTemplateArgs);

// CompoundAssignOperator
// The empty compound-assignment shell clang deserializes into. The operands, the opcode,
// the computation types and the HasFPFeatures trailing FPOptionsOverride are left
// uninitialized, so only the node's statement class may be read straight away.
CXCompoundAssignOperator clang_CompoundAssignOperator_CreateEmpty(CXASTContext C,
                                                                  bool HasFPFeatures);

// DesignatedInitExpr::Designator
// A clang::DesignatedInitExpr::Designator is a by-value tagged union with no pointer form,
// so each factory below heap-boxes its result: the returned CXDesignator is OWNED and must
// be released with clang_Designator_dispose. The borrowed interior pointer that
// clang_DesignatedInitExpr_getDesignator returns must never be passed to that dispose.
CXDesignator clang_Designator_CreateFieldDesignator(CXIdentifierInfo FieldName,
                                                    CXSourceLocation_ DotLoc,
                                                    CXSourceLocation_ FieldLoc);

// Index is the position of the index expression in the owning DesignatedInitExpr's
// subexpression array, not the value of the subscript.
CXDesignator clang_Designator_CreateArrayDesignator(unsigned Index,
                                                    CXSourceLocation_ LBracketLoc,
                                                    CXSourceLocation_ RBracketLoc);

// The GNU `[first ... last]` form; Index names the first of the two index expressions.
CXDesignator clang_Designator_CreateArrayRangeDesignator(unsigned Index,
                                                         CXSourceLocation_ LBracketLoc,
                                                         CXSourceLocation_ EllipsisLoc,
                                                         CXSourceLocation_ RBracketLoc);

// Release a Designator produced by one of the clang_Designator_Create* factories.
void clang_Designator_dispose(CXDesignator D);

// DesignatedInitExpr
// The empty designated-initializer shell clang deserializes into. The designator list
// starts out empty — clang_DesignatedInitExpr_size reads 0 and
// clang_DesignatedInitExpr_setDesignators is how it gets filled — and the NumIndexExprs
// subexpression slots are reserved but uninitialized.
CXDesignatedInitExpr clang_DesignatedInitExpr_CreateEmpty(CXASTContext C,
                                                          unsigned NumIndexExprs);

// Desigs is a (handle-buffer, count) pair of CXDesignator handles, each dereferenced and
// copied into freshly allocated ASTContext storage (MARSHALLING.md section 11), so neither
// the buffer nor the designators it names need outlive the call. This replaces the whole
// designator list and does not touch the node's index-expression slots.
void clang_DesignatedInitExpr_setDesignators(CXDesignatedInitExpr E, CXASTContext C,
                                             const CXDesignator *Desigs,
                                             unsigned NumDesigs);

// ParenListExpr
// The empty paren-list shell clang deserializes into. NumExprs is stored and reads back,
// but the operand slots and both parenthesis locations are left uninitialized.
CXParenListExpr clang_ParenListExpr_CreateEmpty(CXASTContext Ctx, unsigned NumExprs);

// GenericSelectionExpr
// The empty _Generic shell clang deserializes into. The controlling expression, the
// NumAssocs association expressions and their type-source-info slots, and the result index
// are left uninitialized, so only the node's statement class may be read straight away.
CXGenericSelectionExpr clang_GenericSelectionExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumAssocs);

// RecoveryExpr
// The empty recovery shell clang deserializes into. The NumSubExprs operand slots and the
// source range are left uninitialized, so only the node's statement class may be read
// straight away.
CXRecoveryExpr clang_RecoveryExpr_CreateEmpty(CXASTContext Ctx, unsigned NumSubExprs);

// CallExpr
// Args is a (handle, count) pair rebuilt as an ArrayRef<clang::Expr *> in the shim
// (MARSHALLING.md §11); the operands are copied into the node's trailing storage, so the
// buffer need not outlive the call and may be empty. FPFeatures is the
// clang::FPOptionsOverride opaque integer encoding (0 = no override). MinNumArgs reserves
// default-argument slots past NumArgs. UsesADL is the two-state
// clang::CallExpr::ADLCallKind flattened to bool.
CXCallExpr clang_CallExpr_Create(CXASTContext Ctx, CXExpr Fn, const CXExpr *Args,
                                 unsigned NumArgs, CXQualType Ty, CXExprValueKind VK,
                                 CXSourceLocation_ RParenLoc, uint64_t FPFeatures,
                                 unsigned MinNumArgs, bool UsesADL);

// DeclRefExpr
// Also recomputes the node's dependence bits, which reads the referenced decl and the
// expression's type — both always populated on a well-formed DeclRefExpr.
void clang_DeclRefExpr_setCapturedByCopyInLambdaWithExplicitObjectParameter(
    CXDeclRefExpr E, bool Set, CXASTContext Ctx);

// FixedPointLiteral
// The empty fixed-point shell clang deserializes into. Only the statement class is
// initialized: the type, the stored value and the scale carry no default initializer, so
// reading getScale/getLocation/getBeginLoc before setScale/setLocation have run is UB
// (MARSHALLING.md §13). The class publishes no flag recording which slots were written,
// so the Julia wrapper documents the precondition instead of asserting it.
CXFixedPointLiteral clang_FixedPointLiteral_Create(CXASTContext C);

CXSourceLocation_ clang_FixedPointLiteral_getLocation(CXFixedPointLiteral E);

void clang_FixedPointLiteral_setLocation(CXFixedPointLiteral E, CXSourceLocation_ L);

unsigned clang_FixedPointLiteral_getScale(CXFixedPointLiteral E);

void clang_FixedPointLiteral_setScale(CXFixedPointLiteral E, unsigned S);

// SYCLUniqueStableNameExpr
CXTypeSourceInfo
clang_SYCLUniqueStableNameExpr_getTypeSourceInfo(CXSYCLUniqueStableNameExpr E);

// TSI must be non-null — clang's constructor asserts on it. The result type is fixed to
// `const char *` by clang, and the node is ASTContext-arena memory (borrowed, no dispose).
CXSYCLUniqueStableNameExpr clang_SYCLUniqueStableNameExpr_Create(CXASTContext Ctx,
                                                                 CXSourceLocation_ OpLoc,
                                                                 CXSourceLocation_ LParen,
                                                                 CXSourceLocation_ RParen,
                                                                 CXTypeSourceInfo TSI);

CXSourceLocation_ clang_SYCLUniqueStableNameExpr_getLocation(CXSYCLUniqueStableNameExpr E);

CXSourceLocation_
clang_SYCLUniqueStableNameExpr_getLParenLocation(CXSYCLUniqueStableNameExpr E);

CXSourceLocation_
clang_SYCLUniqueStableNameExpr_getRParenLocation(CXSYCLUniqueStableNameExpr E);

// Mangles the stored type's canonical name through a freshly created Itanium mangler, so
// the result does not follow the target's C++ ABI. Dereferences getTypeSourceInfo()
// unchecked: valid only on a node clang parsed or clang_SYCLUniqueStableNameExpr_Create
// built, never on a deserialization shell whose type-source-info slot is uninitialized.
CXString clang_SYCLUniqueStableNameExpr_ComputeName(CXSYCLUniqueStableNameExpr E,
                                                    CXASTContext Ctx);

// DeclRefExpr
// The extent of getQualifierLoc(). NestedNameSpecifierLoc has no handle of its own, so it
// crosses as its two parts (MARSHALLING.md §7): the qualifier through getQualifier, its
// source range here. Invalid when the reference is unqualified.
CXSourceRange_ clang_DeclRefExpr_getQualifierRange(CXDeclRefExpr E);

// Appends the written template arguments, and the angle-bracket locations, to List. List
// is caller-owned (clang_TemplateArgumentListInfo_create / _dispose). A reference with no
// explicit argument list leaves List untouched, so the call is total.
void clang_DeclRefExpr_copyTemplateArgumentsInto(CXDeclRefExpr E,
                                                 CXTemplateArgumentListInfo List);

// FixedPointLiteral
// CreateFromRawInt builds a literal over a raw two's-complement value. The llvm::APInt is
// rebuilt inside the shim from (Value, BitWidth) rather than crossing as an
// LLVMGenericValueRef, matching clang_ASTContext_getConstantArrayType (MARSHALLING.md
// §11). BitWidth must be non-zero and Ty non-null; the node is ASTContext-arena memory
// (borrowed, no dispose).
CXFixedPointLiteral clang_FixedPointLiteral_CreateFromRawInt(CXASTContext C, uint64_t Value,
                                                             unsigned BitWidth,
                                                             CXQualType Ty,
                                                             CXSourceLocation_ L,
                                                             unsigned Scale);

// The stored value rendered as a fixed-point fraction in the given radix. Reads the stored
// value and the scale, neither of which carries a default initializer, so this is UB on a
// clang_FixedPointLiteral_Create shell whose slots were never written (MARSHALLING.md
// §13).
CXString clang_FixedPointLiteral_getValueAsString(CXFixedPointLiteral E, unsigned Radix);

// OffsetOfExpr
// setComponent overwrites the Idx-th component in place; Idx must be < getNumComponents()
// (clang asserts). The OffsetOfNode is copied by value, so N stays owned by whatever
// produced it.
void clang_OffsetOfExpr_setComponent(CXOffsetOfExpr E, unsigned Idx, CXOffsetOfNode N);

// MemberExpr
// The extent of getQualifierLoc(); see clang_DeclRefExpr_getQualifierRange.
CXSourceRange_ clang_MemberExpr_getQualifierRange(CXMemberExpr E);

// Appends the written template arguments to List; see
// clang_DeclRefExpr_copyTemplateArgumentsInto.
void clang_MemberExpr_copyTemplateArgumentsInto(CXMemberExpr E,
                                                CXTemplateArgumentListInfo List);

// BinaryOperator
// setHasStoredFPFeatures only flips the bit recording that a trailing FPOptionsOverride
// slot is present; it does not allocate one. Setting it on an operator clang allocated
// without the slot makes getStoredFPFeatures read past the node, and BinaryOperator
// publishes no independent record of how it was allocated, so the Julia wrapper documents
// the precondition instead of asserting it (MARSHALLING.md §13).
void clang_BinaryOperator_setHasStoredFPFeatures(CXBinaryOperator BO, bool B);

// DesignatedInitExpr
// ExpandDesignator replaces the Idx-th designator with the N designators in Ds, a buffer
// of CXDesignator handles whose pointees are copied by value (MARSHALLING.md §11). Idx
// must be < size(). Unless N == 1 the designator array is reallocated in the ASTContext,
// which dangles every CXDesignator previously obtained from E.
void clang_DesignatedInitExpr_ExpandDesignator(CXDesignatedInitExpr E, CXASTContext Ctx,
                                               unsigned Idx, const CXDesignator *Ds,
                                               unsigned N);

// GenericSelectionExpr
// getAssocType and isAssocSelected are the two remaining fields of the by-value
// clang::GenericSelectionExpr::Association aggregate (MARSHALLING.md §7); its expression
// and type-source-info fields already cross as getAssocExpr / getAssocTypeSourceInfo. I
// must be < getNumAssocs() (clang asserts). getAssocType is the null QualType on a
// `default:` arm, which carries no written type; isAssocSelected is false for every arm
// while the selection is still result-dependent.
CXQualType clang_GenericSelectionExpr_getAssocType(CXGenericSelectionExpr E, unsigned I);

bool clang_GenericSelectionExpr_isAssocSelected(CXGenericSelectionExpr E, unsigned I);

// AsTypeExpr
// __builtin_astype is spelled only in OpenCL, so a C++ parse never produces an AsTypeExpr;
// Create builds one straight into the ASTContext arena (borrowed, no dispose). SrcExpr and
// DstType must both be non-null — the constructor computes the node's dependence from
// both.
CXAsTypeExpr clang_AsTypeExpr_Create(CXASTContext Ctx, CXExpr SrcExpr, CXQualType DstType,
                                     CXExprValueKind VK, CXExprObjectKind OK,
                                     CXSourceLocation_ BuiltinLoc,
                                     CXSourceLocation_ RParenLoc);

CXExpr clang_AsTypeExpr_getSrcExpr(CXAsTypeExpr E);

CXSourceLocation_ clang_AsTypeExpr_getBuiltinLoc(CXAsTypeExpr E);

CXSourceLocation_ clang_AsTypeExpr_getRParenLoc(CXAsTypeExpr E);

// Expr::EvalStatus / Expr::EvalResult
// A CXEvalResult is owned: clang::Expr::EvalResult is a by-value struct (an APValue plus
// the status of the fold that produced it) with no pointer form, so clang_EvalResult_create
// heap-boxes one and clang_EvalResult_dispose releases it. clang::Expr::EvalStatus is
// EvalResult's base class, and the C surface carries no subtyping, so the EvalStatus
// accessors below take the same handle.
// A freshly created result holds no value: run one of the evaluators further down first.
// clang never clears the status flags between evaluations into the same result, so use a
// fresh result per evaluation whenever the flags matter.
CXEvalResult clang_EvalResult_create(void);

void clang_EvalResult_dispose(CXEvalResult R);

// helper: the EvalResult::Val member. The APValue is interior to the box (borrowed) and
// must never be passed to clang_APValue_dispose; it carries the None kind until an
// evaluator has filled the result.
CXAPValue clang_EvalResult_getVal(CXEvalResult R);

bool clang_EvalStatus_hasSideEffects(CXEvalResult R);

// helper: the EvalStatus::HasUndefinedBehavior member — true when the expression folded but
// its evaluation is undefined (INT_MAX + 1 folds to INT_MIN, 1.0 / 0.0 folds to Inf).
bool clang_EvalStatus_hasUndefinedBehavior(CXEvalResult R);

// PARTIAL: clang::Expr::EvalResult::isGlobalLValue asserts that the folded value is an
// lvalue, so the Julia wrapper restates that precondition through clang_APValue_isLValue on
// clang_EvalResult_getVal (Invariant 3).
bool clang_EvalResult_isGlobalLValue(CXEvalResult R);

// Expr
// helper: the EvalResult-filling form of clang::Expr::EvaluateAsRValue, which keeps the
// side-effect and undefined-behaviour status that the CXAPValue-returning
// clang_Expr_EvaluateAsRValue discards. Result holds whatever the failed evaluation left
// behind when this returns false.
bool clang_Expr_EvaluateAsRValueIntoResult(CXExpr E, CXASTContext Ctx,
                                           bool InConstantContext, CXEvalResult Result);

// helper: the EvalResult-filling form of clang::Expr::EvaluateAsLValue. This is the only
// evaluator that leaves an lvalue in Result, so it is the one that makes
// clang_EvalResult_isGlobalLValue callable.
bool clang_Expr_EvaluateAsLValueIntoResult(CXExpr E, CXASTContext Ctx,
                                           bool InConstantContext, CXEvalResult Result);

// EvaluateCharRangeAsString folds SizeExpression to a count and PtrExpression to a
// character pointer, then reads that many code units. The returned CXString is the decoded
// text and is always written — it is the empty string when *Succeeded comes back false.
// Status collects the evaluation's flags. E only scopes the evaluation; it need not be
// related to either operand.
CXString clang_Expr_EvaluateCharRangeAsString(CXExpr E, CXExpr SizeExpression,
                                              CXExpr PtrExpression, CXASTContext Ctx,
                                              CXEvalResult Status, bool *Succeeded);

// DeclRefExpr
// CreateEmpty allocates the trailing storage the four arguments describe but writes only
// the node's statement class: the referenced decl, the name info, the qualifier and the
// HasQualifier/HasFoundDecl/HasTemplateKWAndArgsInfo bits themselves are left
// uninitialized. clang asserts NumTemplateArgs == 0 || HasTemplateKWAndArgsInfo.
CXDeclRefExpr clang_DeclRefExpr_CreateEmpty(CXASTContext C, bool HasQualifier,
                                            bool HasFoundDecl,
                                            bool HasTemplateKWAndArgsInfo,
                                            unsigned NumTemplateArgs);

// FloatingLiteral
// CreateEmpty wraps the clang::FloatingLiteral::Create(ASTContext, EmptyShell) overload —
// the deserialization shell. Only the node's statement class may be read straight away;
// write the raw semantics, the exactness flag, the value and the location before reading
// them back.
CXFloatingLiteral clang_FloatingLiteral_CreateEmpty(CXASTContext C);

// SYCLUniqueStableNameExpr
// CreateEmpty is the deserialization shell: the type-source-info and all three locations
// are left uninitialized, so only the node's statement class may be read straight away.
CXSYCLUniqueStableNameExpr clang_SYCLUniqueStableNameExpr_CreateEmpty(CXASTContext Ctx);

// CallExpr
// PARTIAL: setNumArgsUnsafe writes the argument count with no check at all. The argument
// slots live in trailing storage sized once at construction, so NewNumArgs must not exceed
// the count the node was built with; nothing in the C++ API reports that capacity, so the
// Julia wrapper documents the precondition instead of asserting it. shrinkNumArgs is the
// checked way down.
void clang_CallExpr_setNumArgsUnsafe(CXCallExpr E, unsigned NewNumArgs);

// BlockVarCopyInit
// A clang::BlockVarCopyInit is a by-value PointerIntPair — the expression that copies a
// __block variable into its block, plus whether that copy can throw — with no pointer form,
// so clang_BlockVarCopyInit_create heap-boxes one and clang_BlockVarCopyInit_dispose
// releases it. The boxed expression is AST-owned and outlives the box.
CXBlockVarCopyInit clang_BlockVarCopyInit_create(CXExpr CopyExpr, bool CanThrow);

void clang_BlockVarCopyInit_dispose(CXBlockVarCopyInit BVCI);

CXExpr clang_BlockVarCopyInit_getCopyExpr(CXBlockVarCopyInit BVCI);

bool clang_BlockVarCopyInit_canThrow(CXBlockVarCopyInit BVCI);

void clang_BlockVarCopyInit_setExprAndFlag(CXBlockVarCopyInit BVCI, CXExpr CopyExpr,
                                           bool CanThrow);

// PseudoObjectExpr
// CreateEmpty wraps the clang::PseudoObjectExpr::Create(ASTContext, EmptyShell, unsigned)
// overload. NumSemanticExprs is stored and reads back through getNumSemanticExprs, but the
// syntactic slot, the semantic slots and the result index are left uninitialized.
CXPseudoObjectExpr clang_PseudoObjectExpr_CreateEmpty(CXASTContext Context,
                                                      unsigned NumSemanticExprs);

// Replaces the operand with a type operand. TInfo must be non-null: once the is-type bit is
// set, clang_UnaryExprOrTypeTraitExpr_getArgumentType dereferences it unchecked.
void clang_UnaryExprOrTypeTraitExpr_setArgumentTypeInfo(CXUnaryExprOrTypeTraitExpr E,
                                                        CXTypeSourceInfo TInfo);

LLVM_CLANG_C_EXTERN_C_END

#endif
