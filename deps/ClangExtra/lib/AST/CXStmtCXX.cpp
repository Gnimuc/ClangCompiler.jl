#include "clang-ex/AST/CXStmtCXX.h"
#include "clang/AST/StmtCXX.h"
#include "clang/AST/DeclarationName.h"
#include "clang/AST/NestedNameSpecifier.h"

#include <memory>

// CXXCatchStmt
CXVarDecl clang_CXXCatchStmt_getExceptionDecl(CXCXXCatchStmt CS) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::CXXCatchStmt *>(CS)->getExceptionDecl());
}

CXQualType clang_CXXCatchStmt_getCaughtType(CXCXXCatchStmt CS) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::CXXCatchStmt *>(CS)->getCaughtType().getAsOpaquePtr());
}

CXStmt clang_CXXCatchStmt_getHandlerBlock(CXCXXCatchStmt CS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CXXCatchStmt *>(CS)->getHandlerBlock());
}

// CXXTryStmt
CXCompoundStmt clang_CXXTryStmt_getTryBlock(CXCXXTryStmt TS) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::CXXTryStmt *>(TS)->getTryBlock());
}

unsigned clang_CXXTryStmt_getNumHandlers(CXCXXTryStmt TS) {
  return reinterpret_cast<clang::CXXTryStmt *>(TS)->getNumHandlers();
}

CXCXXCatchStmt clang_CXXTryStmt_getHandler(CXCXXTryStmt TS, unsigned i) {
  return reinterpret_cast<CXCXXCatchStmt>(reinterpret_cast<clang::CXXTryStmt *>(TS)->getHandler(i));
}

// CXXForRangeStmt
CXVarDecl clang_CXXForRangeStmt_getLoopVariable(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getLoopVariable());
}

CXExpr clang_CXXForRangeStmt_getRangeInit(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getRangeInit());
}

CXStmt clang_CXXForRangeStmt_getBody(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getBody());
}

CXDeclStmt clang_CXXForRangeStmt_getBeginStmt(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getBeginStmt());
}

CXDeclStmt clang_CXXForRangeStmt_getEndStmt(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getEndStmt());
}

// CXXCatchStmt
CXSourceLocation_ clang_CXXCatchStmt_getCatchLoc(CXCXXCatchStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXCatchStmt *>(S)->getCatchLoc().getPtrEncoding());
}

// CXXTryStmt
CXSourceLocation_ clang_CXXTryStmt_getTryLoc(CXCXXTryStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXTryStmt *>(S)->getTryLoc().getPtrEncoding());
}

// CXXForRangeStmt
CXSourceLocation_ clang_CXXForRangeStmt_getForLoc(CXCXXForRangeStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXForRangeStmt *>(S)->getForLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CXXForRangeStmt_getCoawaitLoc(CXCXXForRangeStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXForRangeStmt *>(S)->getCoawaitLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CXXForRangeStmt_getColonLoc(CXCXXForRangeStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXForRangeStmt *>(S)->getColonLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CXXForRangeStmt_getRParenLoc(CXCXXForRangeStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CXXForRangeStmt *>(S)->getRParenLoc().getPtrEncoding());
}

// CXXForRangeStmt
CXStmt clang_CXXForRangeStmt_getInit(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getInit());
}

CXDeclStmt clang_CXXForRangeStmt_getRangeStmt(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getRangeStmt());
}

CXExpr clang_CXXForRangeStmt_getCond(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getCond());
}

CXExpr clang_CXXForRangeStmt_getInc(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getInc());
}

CXDeclStmt clang_CXXForRangeStmt_getLoopVarStmt(CXCXXForRangeStmt FRS) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->getLoopVarStmt());
}

void clang_CXXForRangeStmt_setInit(CXCXXForRangeStmt FRS, CXStmt S) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setInit(reinterpret_cast<clang::Stmt *>(S));
}

void clang_CXXForRangeStmt_setRangeInit(CXCXXForRangeStmt FRS, CXExpr E) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setRangeInit(reinterpret_cast<clang::Expr *>(E));
}

void clang_CXXForRangeStmt_setRangeStmt(CXCXXForRangeStmt FRS, CXStmt S) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setRangeStmt(reinterpret_cast<clang::Stmt *>(S));
}

void clang_CXXForRangeStmt_setBeginStmt(CXCXXForRangeStmt FRS, CXStmt S) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setBeginStmt(reinterpret_cast<clang::Stmt *>(S));
}

void clang_CXXForRangeStmt_setEndStmt(CXCXXForRangeStmt FRS, CXStmt S) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setEndStmt(reinterpret_cast<clang::Stmt *>(S));
}

void clang_CXXForRangeStmt_setCond(CXCXXForRangeStmt FRS, CXExpr E) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setCond(reinterpret_cast<clang::Expr *>(E));
}

void clang_CXXForRangeStmt_setInc(CXCXXForRangeStmt FRS, CXExpr E) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setInc(reinterpret_cast<clang::Expr *>(E));
}

void clang_CXXForRangeStmt_setLoopVarStmt(CXCXXForRangeStmt FRS, CXStmt S) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setLoopVarStmt(reinterpret_cast<clang::Stmt *>(S));
}

void clang_CXXForRangeStmt_setBody(CXCXXForRangeStmt FRS, CXStmt S) {
  reinterpret_cast<clang::CXXForRangeStmt *>(FRS)->setBody(reinterpret_cast<clang::Stmt *>(S));
}

// CoroutineBodyStmt
bool clang_CoroutineBodyStmt_hasDependentPromiseType(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->hasDependentPromiseType();
}

CXCompoundStmt clang_CoroutineBodyStmt_getBody(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getBody());
}

CXStmt clang_CoroutineBodyStmt_getPromiseDeclStmt(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getPromiseDeclStmt());
}

CXVarDecl clang_CoroutineBodyStmt_getPromiseDecl(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getPromiseDecl());
}

CXStmt clang_CoroutineBodyStmt_getInitSuspendStmt(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getInitSuspendStmt());
}

CXStmt clang_CoroutineBodyStmt_getFinalSuspendStmt(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getFinalSuspendStmt());
}

CXStmt clang_CoroutineBodyStmt_getExceptionHandler(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getExceptionHandler());
}

CXStmt clang_CoroutineBodyStmt_getFallthroughHandler(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getFallthroughHandler());
}

CXExpr clang_CoroutineBodyStmt_getAllocate(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getAllocate());
}

CXExpr clang_CoroutineBodyStmt_getDeallocate(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getDeallocate());
}

CXStmt clang_CoroutineBodyStmt_getResultDecl(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getResultDecl());
}

CXExpr clang_CoroutineBodyStmt_getReturnValueInit(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getReturnValueInit());
}

CXExpr clang_CoroutineBodyStmt_getReturnValue(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getReturnValue());
}

CXStmt clang_CoroutineBodyStmt_getReturnStmt(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getReturnStmt());
}

CXStmt clang_CoroutineBodyStmt_getReturnStmtOnAllocFailure(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getReturnStmtOnAllocFailure());
}

unsigned clang_CoroutineBodyStmt_getNumParamMoves(CXCoroutineBodyStmt CBS) {
  return reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getParamMoves().size();
}

CXStmt clang_CoroutineBodyStmt_getParamMove(CXCoroutineBodyStmt CBS, unsigned I) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(
      reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->getParamMoves()[I]));
}

unsigned clang_CoroutineBodyStmt_getNumChildrenExclBody(CXCoroutineBodyStmt CBS) {
  auto Range = reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->childrenExclBody();
  unsigned N = 0;
  for (auto It = Range.begin(), End = Range.end(); It != End; ++It)
    ++N;
  return N;
}

CXStmt clang_CoroutineBodyStmt_getChildExclBody(CXCoroutineBodyStmt CBS, unsigned I) {
  auto Range = reinterpret_cast<clang::CoroutineBodyStmt *>(CBS)->childrenExclBody();
  auto It = Range.begin();
  for (unsigned J = 0; J != I; ++J)
    ++It;
  return reinterpret_cast<CXStmt>(*It);
}

// CoreturnStmt
CXSourceLocation_ clang_CoreturnStmt_getKeywordLoc(CXCoreturnStmt CRS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CoreturnStmt *>(CRS)->getKeywordLoc().getPtrEncoding());
}

CXExpr clang_CoreturnStmt_getOperand(CXCoreturnStmt CRS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CoreturnStmt *>(CRS)->getOperand());
}

CXExpr clang_CoreturnStmt_getPromiseCall(CXCoreturnStmt CRS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CoreturnStmt *>(CRS)->getPromiseCall());
}

bool clang_CoreturnStmt_isImplicit(CXCoreturnStmt CRS) {
  return reinterpret_cast<clang::CoreturnStmt *>(CRS)->isImplicit();
}

void clang_CoreturnStmt_setIsImplicit(CXCoreturnStmt CRS, bool Value) {
  reinterpret_cast<clang::CoreturnStmt *>(CRS)->setIsImplicit(Value);
}

// MSDependentExistsStmt
CXSourceLocation_ clang_MSDependentExistsStmt_getKeywordLoc(CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)->getKeywordLoc().getPtrEncoding());
}

bool clang_MSDependentExistsStmt_isIfExists(CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)->isIfExists();
}

bool clang_MSDependentExistsStmt_isIfNotExists(CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)->isIfNotExists();
}

CXSourceRange_ clang_MSDependentExistsStmt_getQualifierRange(CXMSDependentExistsStmt MSS) {
  auto *S = reinterpret_cast<clang::MSDependentExistsStmt *>(MSS);
  clang::SourceRange R = S->getQualifierLoc().getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXNestedNameSpecifier
clang_MSDependentExistsStmt_getQualifier(CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)
      ->getQualifierLoc()
      .getNestedNameSpecifier());
}

CXDeclarationNameInfo clang_MSDependentExistsStmt_getNameInfo(CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<CXDeclarationNameInfo>(std::make_unique<clang::DeclarationNameInfo>(
             reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)->getNameInfo())
      .release());
}

CXCompoundStmt clang_MSDependentExistsStmt_getSubStmt(CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)->getSubStmt());
}

CXNestedNameSpecifierLoc clang_MSDependentExistsStmt_getQualifierLoc(
    CXMSDependentExistsStmt MSS) {
  return reinterpret_cast<CXNestedNameSpecifierLoc>(std::make_unique<clang::NestedNameSpecifierLoc>(
             reinterpret_cast<clang::MSDependentExistsStmt *>(MSS)->getQualifierLoc())
      .release());
}
