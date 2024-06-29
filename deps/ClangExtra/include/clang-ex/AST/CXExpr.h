#ifndef LIBCLANGEX_CXEXPR_H
#define LIBCLANGEX_CXEXPR_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

#ifdef __cplusplus
extern "C" {
#endif

// IntegerLiteral
CINDEX_LINKAGE CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C,
                                                            LLVMGenericValueRef Val,
                                                            CXQualType T,
                                                            CXSourceLocation_ L);

CINDEX_LINKAGE CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL);

CINDEX_LINKAGE CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL);

CINDEX_LINKAGE CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL);

CINDEX_LINKAGE void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL,
                                                     CXSourceLocation_ L);

// CStyleCastExpr
CINDEX_LINKAGE CXCStyleCastExpr clang_CStyleCastExpr_CreateWithNoTypeInfo(
    CXASTContext C, CXQualType T, CXExprValueKind VK, CXCastKind K, CXExpr Op);

CINDEX_LINKAGE CXCStyleCastExpr clang_CStyleCastExpr_CreateEmpty(CXASTContext C,
                                                                 unsigned PathSize,
                                                                 bool HasFPFeatures);

CINDEX_LINKAGE CXSourceLocation_ clang_CStyleCastExpr_getLParenLoc(CXCStyleCastExpr CSCE);

CINDEX_LINKAGE void clang_CStyleCastExpr_setLParenLoc(CXCStyleCastExpr CSCE,
                                                      CXSourceLocation_ L);

CINDEX_LINKAGE CXSourceLocation_ clang_CStyleCastExpr_getRParenLoc(CXCStyleCastExpr CSCE);

CINDEX_LINKAGE void clang_CStyleCastExpr_setRParenLoc(CXCStyleCastExpr CSCE,
                                                      CXSourceLocation_ L);

CINDEX_LINKAGE CXSourceLocation_ clang_CStyleCastExpr_getBeginLoc(CXCStyleCastExpr CSCE);

CINDEX_LINKAGE CXSourceLocation_ clang_CStyleCastExpr_getEndLoc(CXCStyleCastExpr CSCE);

#ifdef __cplusplus
}
#endif
#endif