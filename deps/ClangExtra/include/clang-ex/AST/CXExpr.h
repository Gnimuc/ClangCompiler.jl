#ifndef LLVM_CLANG_C_EXTRA_CXEXPR_H
#define LLVM_CLANG_C_EXTRA_CXEXPR_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
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

// DeclRefExpr
CXValueDecl clang_DeclRefExpr_getDecl(CXDeclRefExpr DRE);

CXNamedDecl clang_DeclRefExpr_getFoundDecl(CXDeclRefExpr DRE);

bool clang_DeclRefExpr_hasQualifier(CXDeclRefExpr DRE);

CXSourceLocation_ clang_DeclRefExpr_getLocation(CXDeclRefExpr DRE);

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

LLVM_CLANG_C_EXTERN_C_END

#endif
