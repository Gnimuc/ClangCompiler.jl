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

LLVM_CLANG_C_EXTERN_C_BEGIN

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

LLVM_CLANG_C_EXTERN_C_END

#endif
