#include "clang-ex/AST/CXStmt.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/ExprConcepts.h"
#include "clang/AST/ExprObjC.h"
#include "clang/AST/ExprOpenMP.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/StmtCXX.h"
#include "clang/AST/StmtObjC.h"
#include "clang/AST/StmtOpenMP.h"

// Drift alarm: the vendored StmtNodes.inc must match the pinned LLVM version.
// One assert per concrete class proves CXStmtClass equals clang's StmtClass
// value-for-value; the count assert catches classes appended at the end
// (which per-class asserts alone would miss).
#define STMT(CLASS, PARENT)                                                                \
  static_assert(static_cast<int>(CXStmtClass_##CLASS##Class) ==                            \
                    static_cast<int>(clang::Stmt::CLASS##Class),                           \
                "CXStmtClass drift: " #CLASS);
#define ABSTRACT_STMT(STMT)
#include "clang-ex/AST/StmtNodes.inc"

namespace {
enum : int {
  CXStmtClassCount = 0
#define STMT(CLASS, PARENT) +1
#define ABSTRACT_STMT(STMT)
#include "clang-ex/AST/StmtNodes.inc"
};
} // namespace
static_assert(CXStmtClassCount == static_cast<int>(clang::Stmt::lastStmtConstant),
              "CXStmtClass drift: vendored StmtNodes.inc is missing classes");

#define STMT(CLASS, PARENT)                                                                \
  CXStmt clang_Stmt_castTo##CLASS(CXStmt S) {                                              \
    return llvm::dyn_cast_or_null<clang::CLASS>(static_cast<clang::Stmt *>(S));            \
  }                                                                                        \
  bool clang_Stmt_is##CLASS(CXStmt S) {                                                    \
    return llvm::isa_and_nonnull<clang::CLASS>(static_cast<clang::Stmt *>(S));             \
  }
#define ABSTRACT_STMT(STMT) STMT
#include "clang-ex/AST/StmtNodes.inc"

CXStmtClass clang_Stmt_getStmtClass(CXStmt S) {
  return static_cast<CXStmtClass>(static_cast<clang::Stmt *>(S)->getStmtClass());
}

const char *clang_Stmt_getStmtClassName(CXStmt S) {
  return static_cast<clang::Stmt *>(S)->getStmtClassName();
}

CXSourceLocation_ clang_Stmt_getBeginLoc(CXStmt S) {
  return static_cast<clang::Stmt *>(S)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Stmt_getEndLoc(CXStmt S) {
  return static_cast<clang::Stmt *>(S)->getEndLoc().getPtrEncoding();
}

CXSourceRange_ clang_Stmt_getSourceRange(CXStmt S) {
  auto rng = static_cast<clang::Stmt *>(S)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

void clang_Stmt_dump(CXStmt S) { return static_cast<clang::Stmt *>(S)->dump(); }

size_t clang_Stmt_getNumChildren(CXStmt S) {
  size_t N = 0;
  for (clang::Stmt *Child : static_cast<clang::Stmt *>(S)->children()) {
    (void)Child;
    ++N;
  }
  return N;
}

void clang_Stmt_getChildren(CXStmt S, CXStmt *Buf) {
  size_t I = 0;
  for (clang::Stmt *Child : static_cast<clang::Stmt *>(S)->children())
    Buf[I++] = Child;
}

// DeclStmt
bool clang_DeclStmt_isSingleDecl(CXDeclStmt DS) {
  return static_cast<clang::DeclStmt *>(DS)->isSingleDecl();
}

CXDecl clang_DeclStmt_getSingleDecl(CXDeclStmt DS) {
  return static_cast<clang::DeclStmt *>(DS)->getSingleDecl();
}

// CompoundStmt
unsigned clang_CompoundStmt_size(CXCompoundStmt CS) {
  return static_cast<clang::CompoundStmt *>(CS)->size();
}

CXStmt clang_CompoundStmt_body_front(CXCompoundStmt CS) {
  return static_cast<clang::CompoundStmt *>(CS)->body_front();
}

CXStmt clang_CompoundStmt_body_back(CXCompoundStmt CS) {
  return static_cast<clang::CompoundStmt *>(CS)->body_back();
}

CXSourceLocation_ clang_CompoundStmt_getLBracLoc(CXCompoundStmt CS) {
  return static_cast<clang::CompoundStmt *>(CS)->getLBracLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CompoundStmt_getRBracLoc(CXCompoundStmt CS) {
  return static_cast<clang::CompoundStmt *>(CS)->getRBracLoc().getPtrEncoding();
}

// SwitchCase
CXSwitchCase clang_SwitchCase_getNextSwitchCase(CXSwitchCase SC) {
  return static_cast<clang::SwitchCase *>(SC)->getNextSwitchCase();
}

CXStmt clang_SwitchCase_getSubStmt(CXSwitchCase SC) {
  return static_cast<clang::SwitchCase *>(SC)->getSubStmt();
}

// CaseStmt
CXExpr clang_CaseStmt_getLHS(CXCaseStmt CS) {
  return static_cast<clang::CaseStmt *>(CS)->getLHS();
}

CXExpr clang_CaseStmt_getRHS(CXCaseStmt CS) {
  return static_cast<clang::CaseStmt *>(CS)->getRHS();
}

// LabelStmt
const char *clang_LabelStmt_getName(CXLabelStmt LS) {
  return static_cast<clang::LabelStmt *>(LS)->getName();
}

CXLabelDecl clang_LabelStmt_getDecl(CXLabelStmt LS) {
  return static_cast<clang::LabelStmt *>(LS)->getDecl();
}

CXStmt clang_LabelStmt_getSubStmt(CXLabelStmt LS) {
  return static_cast<clang::LabelStmt *>(LS)->getSubStmt();
}

// IfStmt
CXExpr clang_IfStmt_getCond(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->getCond();
}

CXStmt clang_IfStmt_getThen(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->getThen();
}

CXStmt clang_IfStmt_getElse(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->getElse();
}

bool clang_IfStmt_hasElseStorage(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->hasElseStorage();
}

bool clang_IfStmt_hasInitStorage(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->hasInitStorage();
}

bool clang_IfStmt_hasVarStorage(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->hasVarStorage();
}

CXStmt clang_IfStmt_getInit(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->getInit();
}

CXVarDecl clang_IfStmt_getConditionVariable(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->getConditionVariable();
}

CXSourceLocation_ clang_IfStmt_getIfLoc(CXIfStmt IS) {
  return static_cast<clang::IfStmt *>(IS)->getIfLoc().getPtrEncoding();
}

// SwitchStmt
CXExpr clang_SwitchStmt_getCond(CXSwitchStmt SS) {
  return static_cast<clang::SwitchStmt *>(SS)->getCond();
}

CXStmt clang_SwitchStmt_getBody(CXSwitchStmt SS) {
  return static_cast<clang::SwitchStmt *>(SS)->getBody();
}

CXSwitchCase clang_SwitchStmt_getSwitchCaseList(CXSwitchStmt SS) {
  return static_cast<clang::SwitchStmt *>(SS)->getSwitchCaseList();
}

bool clang_SwitchStmt_isAllEnumCasesCovered(CXSwitchStmt SS) {
  return static_cast<clang::SwitchStmt *>(SS)->isAllEnumCasesCovered();
}

// WhileStmt
CXExpr clang_WhileStmt_getCond(CXWhileStmt WS) {
  return static_cast<clang::WhileStmt *>(WS)->getCond();
}

CXStmt clang_WhileStmt_getBody(CXWhileStmt WS) {
  return static_cast<clang::WhileStmt *>(WS)->getBody();
}

CXVarDecl clang_WhileStmt_getConditionVariable(CXWhileStmt WS) {
  return static_cast<clang::WhileStmt *>(WS)->getConditionVariable();
}

CXSourceLocation_ clang_WhileStmt_getWhileLoc(CXWhileStmt WS) {
  return static_cast<clang::WhileStmt *>(WS)->getWhileLoc().getPtrEncoding();
}

// DoStmt
CXExpr clang_DoStmt_getCond(CXDoStmt DS) {
  return static_cast<clang::DoStmt *>(DS)->getCond();
}

CXStmt clang_DoStmt_getBody(CXDoStmt DS) {
  return static_cast<clang::DoStmt *>(DS)->getBody();
}

CXSourceLocation_ clang_DoStmt_getDoLoc(CXDoStmt DS) {
  return static_cast<clang::DoStmt *>(DS)->getDoLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DoStmt_getWhileLoc(CXDoStmt DS) {
  return static_cast<clang::DoStmt *>(DS)->getWhileLoc().getPtrEncoding();
}

// ForStmt
CXStmt clang_ForStmt_getInit(CXForStmt FS) {
  return static_cast<clang::ForStmt *>(FS)->getInit();
}

CXExpr clang_ForStmt_getCond(CXForStmt FS) {
  return static_cast<clang::ForStmt *>(FS)->getCond();
}

CXExpr clang_ForStmt_getInc(CXForStmt FS) {
  return static_cast<clang::ForStmt *>(FS)->getInc();
}

CXStmt clang_ForStmt_getBody(CXForStmt FS) {
  return static_cast<clang::ForStmt *>(FS)->getBody();
}

CXVarDecl clang_ForStmt_getConditionVariable(CXForStmt FS) {
  return static_cast<clang::ForStmt *>(FS)->getConditionVariable();
}

CXSourceLocation_ clang_ForStmt_getForLoc(CXForStmt FS) {
  return static_cast<clang::ForStmt *>(FS)->getForLoc().getPtrEncoding();
}

// GotoStmt
CXLabelDecl clang_GotoStmt_getLabel(CXGotoStmt GS) {
  return static_cast<clang::GotoStmt *>(GS)->getLabel();
}

CXSourceLocation_ clang_GotoStmt_getGotoLoc(CXGotoStmt GS) {
  return static_cast<clang::GotoStmt *>(GS)->getGotoLoc().getPtrEncoding();
}

// ReturnStmt
CXExpr clang_ReturnStmt_getRetValue(CXReturnStmt RS) {
  return static_cast<clang::ReturnStmt *>(RS)->getRetValue();
}
