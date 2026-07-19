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

