#ifndef LLVM_CLANG_C_EXTRA_CXEXPR_H
#define LLVM_CLANG_C_EXTRA_CXEXPR_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXTypeTraits.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

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


LLVM_CLANG_C_EXTERN_C_END

#endif
