#ifndef LLVM_CLANG_C_EXTRA_CXEXPR_H
#define LLVM_CLANG_C_EXTRA_CXEXPR_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
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

// IntegerLiteral
CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                             CXQualType T, CXSourceLocation_ L);

CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL);

CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL);

CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL);

void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL, CXSourceLocation_ L);

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

LLVM_CLANG_C_EXTERN_C_END

#endif