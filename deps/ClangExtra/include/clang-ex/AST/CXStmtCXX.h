#ifndef LLVM_CLANG_C_EXTRA_CXSTMTCXX_H
#define LLVM_CLANG_C_EXTRA_CXSTMTCXX_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CXXCatchStmt
CXVarDecl clang_CXXCatchStmt_getExceptionDecl(CXCXXCatchStmt CS);

CXQualType clang_CXXCatchStmt_getCaughtType(CXCXXCatchStmt CS);

CXStmt clang_CXXCatchStmt_getHandlerBlock(CXCXXCatchStmt CS);

// CXXTryStmt
CXCompoundStmt clang_CXXTryStmt_getTryBlock(CXCXXTryStmt TS);

unsigned clang_CXXTryStmt_getNumHandlers(CXCXXTryStmt TS);

CXCXXCatchStmt clang_CXXTryStmt_getHandler(CXCXXTryStmt TS, unsigned i);

// CXXForRangeStmt
CXVarDecl clang_CXXForRangeStmt_getLoopVariable(CXCXXForRangeStmt FRS);

CXExpr clang_CXXForRangeStmt_getRangeInit(CXCXXForRangeStmt FRS);

CXStmt clang_CXXForRangeStmt_getBody(CXCXXForRangeStmt FRS);

CXDeclStmt clang_CXXForRangeStmt_getBeginStmt(CXCXXForRangeStmt FRS);

CXDeclStmt clang_CXXForRangeStmt_getEndStmt(CXCXXForRangeStmt FRS);

// CXXCatchStmt
CXSourceLocation_ clang_CXXCatchStmt_getCatchLoc(CXCXXCatchStmt S);

// CXXTryStmt
CXSourceLocation_ clang_CXXTryStmt_getTryLoc(CXCXXTryStmt S);

// CXXForRangeStmt
CXSourceLocation_ clang_CXXForRangeStmt_getForLoc(CXCXXForRangeStmt S);

CXSourceLocation_ clang_CXXForRangeStmt_getCoawaitLoc(CXCXXForRangeStmt S);

CXSourceLocation_ clang_CXXForRangeStmt_getColonLoc(CXCXXForRangeStmt S);

CXSourceLocation_ clang_CXXForRangeStmt_getRParenLoc(CXCXXForRangeStmt S);


LLVM_CLANG_C_EXTERN_C_END

#endif
