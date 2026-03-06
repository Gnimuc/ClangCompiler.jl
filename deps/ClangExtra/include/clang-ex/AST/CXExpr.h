#ifndef LLVM_CLANG_C_EXTRA_CXEXPR_H
#define LLVM_CLANG_C_EXTRA_CXEXPR_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Expr (base)
CXQualType clang_Expr_getType(CXExpr E);
CXExprValueKind clang_Expr_getValueKind(CXExpr E);
bool clang_Expr_isLValue(CXExpr E);
bool clang_Expr_isPRValue(CXExpr E);
bool clang_Expr_isXValue(CXExpr E);
bool clang_Expr_isGLValue(CXExpr E);
bool clang_Expr_isIntegerConstantExpr(CXExpr E, CXASTContext Ctx);
bool clang_Expr_isEvaluatable(CXExpr E, CXASTContext Ctx);
CXSourceLocation_ clang_Expr_getExprLoc(CXExpr E);
CXSourceLocation_ clang_Expr_getBeginLoc(CXExpr E);
CXSourceLocation_ clang_Expr_getEndLoc(CXExpr E);
CXExpr clang_Expr_IgnoreParens(CXExpr E);
CXExpr clang_Expr_IgnoreImpCasts(CXExpr E);
CXExpr clang_Expr_IgnoreParenImpCasts(CXExpr E);
CXExpr clang_Expr_IgnoreCasts(CXExpr E);

// DeclRefExpr
CXDeclRefExpr clang_DeclRefExpr_Create(CXASTContext Ctx, CXValueDecl D,
                                       CXQualType T, CXExprValueKind VK,
                                       CXSourceLocation_ L);
CXValueDecl clang_DeclRefExpr_getDecl(CXDeclRefExpr E);
CXSourceLocation_ clang_DeclRefExpr_getLocation(CXDeclRefExpr E);
CXSourceLocation_ clang_DeclRefExpr_getBeginLoc(CXDeclRefExpr E);
CXSourceLocation_ clang_DeclRefExpr_getEndLoc(CXDeclRefExpr E);

// IntegerLiteral
CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                             CXQualType T, CXSourceLocation_ L);
CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL);
CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL);
CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL);
void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL, CXSourceLocation_ L);

// FloatingLiteral
CXFloatingLiteral clang_FloatingLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                               bool IsExact, CXQualType T,
                                               CXSourceLocation_ L);
double clang_FloatingLiteral_getValueAsApproximateDouble(CXFloatingLiteral FL);
CXSourceLocation_ clang_FloatingLiteral_getLocation(CXFloatingLiteral FL);
void clang_FloatingLiteral_setLocation(CXFloatingLiteral FL, CXSourceLocation_ L);
CXSourceLocation_ clang_FloatingLiteral_getBeginLoc(CXFloatingLiteral FL);
CXSourceLocation_ clang_FloatingLiteral_getEndLoc(CXFloatingLiteral FL);

// CharacterLiteral
CXCharacterLiteral clang_CharacterLiteral_Create(CXASTContext C, unsigned Val,
                                                 CXQualType T, CXSourceLocation_ L);
unsigned clang_CharacterLiteral_getValue(CXCharacterLiteral CL);
CXSourceLocation_ clang_CharacterLiteral_getLocation(CXCharacterLiteral CL);
void clang_CharacterLiteral_setLocation(CXCharacterLiteral CL, CXSourceLocation_ L);
CXSourceLocation_ clang_CharacterLiteral_getBeginLoc(CXCharacterLiteral CL);
CXSourceLocation_ clang_CharacterLiteral_getEndLoc(CXCharacterLiteral CL);

// StringLiteral
CXSourceLocation_ clang_StringLiteral_getBeginLoc(CXStringLiteral SL);
CXSourceLocation_ clang_StringLiteral_getEndLoc(CXStringLiteral SL);
unsigned clang_StringLiteral_getByteLength(CXStringLiteral SL);
unsigned clang_StringLiteral_getLength(CXStringLiteral SL);
unsigned clang_StringLiteral_getCharByteWidth(CXStringLiteral SL);

// ParenExpr
CXExpr clang_ParenExpr_getSubExpr(CXParenExpr PE);
CXSourceLocation_ clang_ParenExpr_getLParen(CXParenExpr PE);
CXSourceLocation_ clang_ParenExpr_getRParen(CXParenExpr PE);
CXSourceLocation_ clang_ParenExpr_getBeginLoc(CXParenExpr PE);
CXSourceLocation_ clang_ParenExpr_getEndLoc(CXParenExpr PE);

// UnaryOperator
CXUnaryOperator clang_UnaryOperator_Create(CXASTContext C, CXExpr Input,
                                           CXUnaryOperatorKind Opc, CXQualType T,
                                           CXExprValueKind VK, CXSourceLocation_ L,
                                           bool CanOverflow);
CXUnaryOperatorKind clang_UnaryOperator_getOpcode(CXUnaryOperator UO);
CXExpr clang_UnaryOperator_getSubExpr(CXUnaryOperator UO);
CXSourceLocation_ clang_UnaryOperator_getOperatorLoc(CXUnaryOperator UO);
void clang_UnaryOperator_setOperatorLoc(CXUnaryOperator UO, CXSourceLocation_ L);
CXSourceLocation_ clang_UnaryOperator_getBeginLoc(CXUnaryOperator UO);
CXSourceLocation_ clang_UnaryOperator_getEndLoc(CXUnaryOperator UO);
bool clang_UnaryOperator_isPrefix(CXUnaryOperatorKind Opc);
bool clang_UnaryOperator_isPostfix(CXUnaryOperatorKind Opc);
bool clang_UnaryOperator_isIncrementDecrementOp(CXUnaryOperatorKind Opc);
bool clang_UnaryOperator_isArithmeticOp(CXUnaryOperatorKind Opc);

// BinaryOperator
CXBinaryOperator clang_BinaryOperator_Create(CXASTContext C, CXExpr LHS, CXExpr RHS,
                                             CXBinaryOperatorKind Opc, CXQualType T,
                                             CXExprValueKind VK, CXSourceLocation_ L);
CXBinaryOperatorKind clang_BinaryOperator_getOpcode(CXBinaryOperator BO);
CXExpr clang_BinaryOperator_getLHS(CXBinaryOperator BO);
CXExpr clang_BinaryOperator_getRHS(CXBinaryOperator BO);
CXSourceLocation_ clang_BinaryOperator_getOperatorLoc(CXBinaryOperator BO);
void clang_BinaryOperator_setOperatorLoc(CXBinaryOperator BO, CXSourceLocation_ L);
CXSourceLocation_ clang_BinaryOperator_getBeginLoc(CXBinaryOperator BO);
CXSourceLocation_ clang_BinaryOperator_getEndLoc(CXBinaryOperator BO);
bool clang_BinaryOperator_isAssignmentOp(CXBinaryOperatorKind Opc);
bool clang_BinaryOperator_isCompoundAssignmentOp(CXBinaryOperatorKind Opc);
bool clang_BinaryOperator_isComparisonOp(CXBinaryOperatorKind Opc);
bool clang_BinaryOperator_isLogicalOp(CXBinaryOperatorKind Opc);
bool clang_BinaryOperator_isAdditiveOp(CXBinaryOperatorKind Opc);
bool clang_BinaryOperator_isMultiplicativeOp(CXBinaryOperatorKind Opc);

// CastExpr (base for ImplicitCastExpr, CStyleCastExpr, etc.)
CXCastKind clang_CastExpr_getCastKind(CXCastExpr CE);
CXExpr clang_CastExpr_getSubExpr(CXCastExpr CE);
CXExpr clang_CastExpr_getSubExprAsWritten(CXCastExpr CE);

// ImplicitCastExpr
CXImplicitCastExpr clang_ImplicitCastExpr_Create(CXASTContext C, CXQualType T,
                                                  CXCastKind K, CXExpr Op,
                                                  CXExprValueKind VK);
CXSourceLocation_ clang_ImplicitCastExpr_getBeginLoc(CXImplicitCastExpr ICE);
CXSourceLocation_ clang_ImplicitCastExpr_getEndLoc(CXImplicitCastExpr ICE);

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

// CallExpr
CXExpr clang_CallExpr_getCallee(CXCallExpr CE);
unsigned clang_CallExpr_getNumArgs(CXCallExpr CE);
CXExpr clang_CallExpr_getArg(CXCallExpr CE, unsigned Idx);
void clang_CallExpr_setArg(CXCallExpr CE, unsigned Idx, CXExpr Arg);
CXSourceLocation_ clang_CallExpr_getBeginLoc(CXCallExpr CE);
CXSourceLocation_ clang_CallExpr_getEndLoc(CXCallExpr CE);
CXQualType clang_CallExpr_getCallReturnType(CXCallExpr CE, CXASTContext Ctx);

// MemberExpr
CXExpr clang_MemberExpr_getBase(CXMemberExpr ME);
CXValueDecl clang_MemberExpr_getMemberDecl(CXMemberExpr ME);
bool clang_MemberExpr_isArrow(CXMemberExpr ME);
CXSourceLocation_ clang_MemberExpr_getMemberLoc(CXMemberExpr ME);
CXSourceLocation_ clang_MemberExpr_getBeginLoc(CXMemberExpr ME);
CXSourceLocation_ clang_MemberExpr_getEndLoc(CXMemberExpr ME);

// ArraySubscriptExpr
CXExpr clang_ArraySubscriptExpr_getBase(CXArraySubscriptExpr ASE);
CXExpr clang_ArraySubscriptExpr_getIdx(CXArraySubscriptExpr ASE);
CXExpr clang_ArraySubscriptExpr_getLHS(CXArraySubscriptExpr ASE);
CXExpr clang_ArraySubscriptExpr_getRHS(CXArraySubscriptExpr ASE);
CXSourceLocation_ clang_ArraySubscriptExpr_getBeginLoc(CXArraySubscriptExpr ASE);
CXSourceLocation_ clang_ArraySubscriptExpr_getEndLoc(CXArraySubscriptExpr ASE);

// ConditionalOperator
CXExpr clang_ConditionalOperator_getCond(CXConditionalOperator CO);
CXExpr clang_ConditionalOperator_getTrueExpr(CXConditionalOperator CO);
CXExpr clang_ConditionalOperator_getFalseExpr(CXConditionalOperator CO);
CXSourceLocation_ clang_ConditionalOperator_getBeginLoc(CXConditionalOperator CO);
CXSourceLocation_ clang_ConditionalOperator_getEndLoc(CXConditionalOperator CO);

// InitListExpr
unsigned clang_InitListExpr_getNumInits(CXInitListExpr ILE);
CXExpr clang_InitListExpr_getInit(CXInitListExpr ILE, unsigned Idx);
CXExpr clang_InitListExpr_getArrayFiller(CXInitListExpr ILE);
bool clang_InitListExpr_hasArrayFiller(CXInitListExpr ILE);
CXSourceLocation_ clang_InitListExpr_getBeginLoc(CXInitListExpr ILE);
CXSourceLocation_ clang_InitListExpr_getEndLoc(CXInitListExpr ILE);

LLVM_CLANG_C_EXTERN_C_END

#endif
