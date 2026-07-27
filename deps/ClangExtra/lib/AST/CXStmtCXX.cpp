#include "clang-ex/AST/CXStmtCXX.h"
#include "clang/AST/StmtCXX.h"

// CXXCatchStmt
CXVarDecl clang_CXXCatchStmt_getExceptionDecl(CXCXXCatchStmt CS) {
  return static_cast<clang::CXXCatchStmt *>(CS)->getExceptionDecl();
}

CXQualType clang_CXXCatchStmt_getCaughtType(CXCXXCatchStmt CS) {
  return static_cast<clang::CXXCatchStmt *>(CS)->getCaughtType().getAsOpaquePtr();
}

CXStmt clang_CXXCatchStmt_getHandlerBlock(CXCXXCatchStmt CS) {
  return static_cast<clang::CXXCatchStmt *>(CS)->getHandlerBlock();
}

// CXXTryStmt
CXCompoundStmt clang_CXXTryStmt_getTryBlock(CXCXXTryStmt TS) {
  return static_cast<clang::CXXTryStmt *>(TS)->getTryBlock();
}

unsigned clang_CXXTryStmt_getNumHandlers(CXCXXTryStmt TS) {
  return static_cast<clang::CXXTryStmt *>(TS)->getNumHandlers();
}

CXCXXCatchStmt clang_CXXTryStmt_getHandler(CXCXXTryStmt TS, unsigned i) {
  return static_cast<clang::CXXTryStmt *>(TS)->getHandler(i);
}

// CXXForRangeStmt
CXVarDecl clang_CXXForRangeStmt_getLoopVariable(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getLoopVariable();
}

CXExpr clang_CXXForRangeStmt_getRangeInit(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getRangeInit();
}

CXStmt clang_CXXForRangeStmt_getBody(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getBody();
}

CXDeclStmt clang_CXXForRangeStmt_getBeginStmt(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getBeginStmt();
}

CXDeclStmt clang_CXXForRangeStmt_getEndStmt(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getEndStmt();
}

// CXXCatchStmt
CXSourceLocation_ clang_CXXCatchStmt_getCatchLoc(CXCXXCatchStmt S) {
  return static_cast<clang::CXXCatchStmt *>(S)->getCatchLoc().getPtrEncoding();
}

// CXXTryStmt
CXSourceLocation_ clang_CXXTryStmt_getTryLoc(CXCXXTryStmt S) {
  return static_cast<clang::CXXTryStmt *>(S)->getTryLoc().getPtrEncoding();
}

// CXXForRangeStmt
CXSourceLocation_ clang_CXXForRangeStmt_getForLoc(CXCXXForRangeStmt S) {
  return static_cast<clang::CXXForRangeStmt *>(S)->getForLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXForRangeStmt_getCoawaitLoc(CXCXXForRangeStmt S) {
  return static_cast<clang::CXXForRangeStmt *>(S)->getCoawaitLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXForRangeStmt_getColonLoc(CXCXXForRangeStmt S) {
  return static_cast<clang::CXXForRangeStmt *>(S)->getColonLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXForRangeStmt_getRParenLoc(CXCXXForRangeStmt S) {
  return static_cast<clang::CXXForRangeStmt *>(S)->getRParenLoc().getPtrEncoding();
}

// CXXForRangeStmt
CXStmt clang_CXXForRangeStmt_getInit(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getInit();
}

CXDeclStmt clang_CXXForRangeStmt_getRangeStmt(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getRangeStmt();
}

CXExpr clang_CXXForRangeStmt_getCond(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getCond();
}

CXExpr clang_CXXForRangeStmt_getInc(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getInc();
}

CXDeclStmt clang_CXXForRangeStmt_getLoopVarStmt(CXCXXForRangeStmt FRS) {
  return static_cast<clang::CXXForRangeStmt *>(FRS)->getLoopVarStmt();
}

// CoroutineBodyStmt
bool clang_CoroutineBodyStmt_hasDependentPromiseType(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->hasDependentPromiseType();
}

CXCompoundStmt clang_CoroutineBodyStmt_getBody(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getBody();
}

CXVarDecl clang_CoroutineBodyStmt_getPromiseDecl(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getPromiseDecl();
}

CXStmt clang_CoroutineBodyStmt_getInitSuspendStmt(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getInitSuspendStmt();
}

CXStmt clang_CoroutineBodyStmt_getFinalSuspendStmt(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getFinalSuspendStmt();
}

CXStmt clang_CoroutineBodyStmt_getExceptionHandler(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getExceptionHandler();
}

CXExpr clang_CoroutineBodyStmt_getAllocate(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getAllocate();
}

CXExpr clang_CoroutineBodyStmt_getDeallocate(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getDeallocate();
}

CXStmt clang_CoroutineBodyStmt_getReturnStmt(CXCoroutineBodyStmt CBS) {
  return static_cast<clang::CoroutineBodyStmt *>(CBS)->getReturnStmt();
}

// CoreturnStmt
CXSourceLocation_ clang_CoreturnStmt_getKeywordLoc(CXCoreturnStmt CRS) {
  return static_cast<clang::CoreturnStmt *>(CRS)->getKeywordLoc().getPtrEncoding();
}

CXExpr clang_CoreturnStmt_getOperand(CXCoreturnStmt CRS) {
  return static_cast<clang::CoreturnStmt *>(CRS)->getOperand();
}

CXExpr clang_CoreturnStmt_getPromiseCall(CXCoreturnStmt CRS) {
  return static_cast<clang::CoreturnStmt *>(CRS)->getPromiseCall();
}

bool clang_CoreturnStmt_isImplicit(CXCoreturnStmt CRS) {
  return static_cast<clang::CoreturnStmt *>(CRS)->isImplicit();
}
