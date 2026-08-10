#include "clang-ex/AST/CXStmt.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/ExprConcepts.h"
#include "clang/AST/ExprObjC.h"
#include "clang/AST/ExprOpenMP.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/StmtCXX.h"
#include "clang/AST/StmtObjC.h"
#include "clang/AST/StmtOpenMP.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Lex/Token.h"
#include "llvm/ADT/FoldingSet.h"
#include "llvm/ADT/SmallVector.h"
#include "clang/AST/ODRHash.h"
#include <tuple>

// GCCAsmStmt (paren / label / operand tail)
CXSourceLocation_ clang_GCCAsmStmt_getRParenLoc(CXGCCAsmStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getRParenLoc().getPtrEncoding());
}

CXAddrLabelExpr clang_GCCAsmStmt_getLabelExpr(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXAddrLabelExpr>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getLabelExpr(I));
}

CXString clang_GCCAsmStmt_getLabelName(CXGCCAsmStmt S, unsigned I) {
  return extra::makeCXString(reinterpret_cast<clang::GCCAsmStmt *>(S)->getLabelName(I).str());
}

int clang_GCCAsmStmt_getNamedOperand(CXGCCAsmStmt S, const char *SymbolicName) {
  return reinterpret_cast<clang::GCCAsmStmt *>(S)->getNamedOperand(
      llvm::StringRef(SymbolicName));
}

void clang_GCCAsmStmt_setInputExpr(CXGCCAsmStmt S, unsigned I, CXExpr E) {
  reinterpret_cast<clang::GCCAsmStmt *>(S)->setInputExpr(I, reinterpret_cast<clang::Expr *>(E));
}

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
  CX##CLASS clang_Stmt_castTo##CLASS(CXStmt S) {                                           \
    return reinterpret_cast<CX##CLASS>(                                                    \
        llvm::dyn_cast_or_null<clang::CLASS>(reinterpret_cast<clang::Stmt *>(S)));         \
  }                                                                                        \
  bool clang_Stmt_is##CLASS(CXStmt S) {                                                    \
    return llvm::isa_and_nonnull<clang::CLASS>(reinterpret_cast<clang::Stmt *>(S));        \
  }
#define ABSTRACT_STMT(STMT) STMT
#include "clang-ex/AST/StmtNodes.inc"

CXStmtClass clang_Stmt_getStmtClass(CXStmt S) {
  return static_cast<CXStmtClass>(reinterpret_cast<clang::Stmt *>(S)->getStmtClass());
}

const char *clang_Stmt_getStmtClassName(CXStmt S) {
  return reinterpret_cast<clang::Stmt *>(S)->getStmtClassName();
}

CXSourceLocation_ clang_Stmt_getBeginLoc(CXStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Stmt *>(S)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_Stmt_getEndLoc(CXStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Stmt *>(S)->getEndLoc().getPtrEncoding());
}

CXSourceRange_ clang_Stmt_getSourceRange(CXStmt S) {
  auto rng = reinterpret_cast<clang::Stmt *>(S)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXString clang_Stmt_dumpToString(CXStmt S, CXASTContext Ctx) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::Stmt *>(S)->dump(OS, *reinterpret_cast<clang::ASTContext *>(Ctx));
  return extra::makeCXString(OS.str());
}

void clang_Stmt_dump(CXStmt S) { return reinterpret_cast<clang::Stmt *>(S)->dump(); }

size_t clang_Stmt_getNumChildren(CXStmt S) {
  size_t N = 0;
  for (clang::Stmt *Child : reinterpret_cast<clang::Stmt *>(S)->children()) {
    (void)Child;
    ++N;
  }
  return N;
}

void clang_Stmt_getChildren(CXStmt S, CXStmt *Buf) {
  size_t I = 0;
  for (clang::Stmt *Child : reinterpret_cast<clang::Stmt *>(S)->children())
    Buf[I++] = reinterpret_cast<CXStmt>(Child);
}

namespace {
size_t subtreeSize(clang::Stmt *S) {
  if (!S)
    return 0;
  size_t N = 1;
  for (clang::Stmt *Child : S->children())
    N += subtreeSize(Child);
  return N;
}

void collectSubtree(clang::Stmt *S, CXStmt *&Nodes, CXStmtClass *&Classes) {
  if (!S)
    return;
  *Nodes++ = reinterpret_cast<CXStmt>(S);
  *Classes++ = static_cast<CXStmtClass>(S->getStmtClass());
  for (clang::Stmt *Child : S->children())
    collectSubtree(Child, Nodes, Classes);
}
} // namespace

size_t clang_Stmt_getSubtreeSize(CXStmt S) {
  return subtreeSize(reinterpret_cast<clang::Stmt *>(S));
}

void clang_Stmt_collectSubtree(CXStmt S, CXStmt *Nodes, CXStmtClass *Classes) {
  collectSubtree(reinterpret_cast<clang::Stmt *>(S), Nodes, Classes);
}

// DeclStmt
bool clang_DeclStmt_isSingleDecl(CXDeclStmt DS) {
  return reinterpret_cast<clang::DeclStmt *>(DS)->isSingleDecl();
}

CXDecl clang_DeclStmt_getSingleDecl(CXDeclStmt DS) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::DeclStmt *>(DS)->getSingleDecl());
}

size_t clang_DeclStmt_getNumDecls(CXDeclStmt DS) {
  auto *D = reinterpret_cast<clang::DeclStmt *>(DS);
  size_t N = 0;
  for (auto *X : D->decls()) {
    (void)X;
    ++N;
  }
  return N;
}

void clang_DeclStmt_getDecls(CXDeclStmt DS, CXDecl *Buf) {
  auto *D = reinterpret_cast<clang::DeclStmt *>(DS);
  size_t I = 0;
  for (auto *X : D->decls())
    Buf[I++] = reinterpret_cast<CXDecl>(X);
}

// CompoundStmt
unsigned clang_CompoundStmt_size(CXCompoundStmt CS) {
  return reinterpret_cast<clang::CompoundStmt *>(CS)->size();
}

CXStmt clang_CompoundStmt_body_front(CXCompoundStmt CS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CompoundStmt *>(CS)->body_front());
}

CXStmt clang_CompoundStmt_body_back(CXCompoundStmt CS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CompoundStmt *>(CS)->body_back());
}

CXSourceLocation_ clang_CompoundStmt_getLBracLoc(CXCompoundStmt CS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CompoundStmt *>(CS)->getLBracLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CompoundStmt_getRBracLoc(CXCompoundStmt CS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CompoundStmt *>(CS)->getRBracLoc().getPtrEncoding());
}

// SwitchCase
CXSwitchCase clang_SwitchCase_getNextSwitchCase(CXSwitchCase SC) {
  return reinterpret_cast<CXSwitchCase>(reinterpret_cast<clang::SwitchCase *>(SC)->getNextSwitchCase());
}

CXStmt clang_SwitchCase_getSubStmt(CXSwitchCase SC) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::SwitchCase *>(SC)->getSubStmt());
}

// CaseStmt
CXExpr clang_CaseStmt_getLHS(CXCaseStmt CS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CaseStmt *>(CS)->getLHS());
}

CXExpr clang_CaseStmt_getRHS(CXCaseStmt CS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CaseStmt *>(CS)->getRHS());
}

// LabelStmt
const char *clang_LabelStmt_getName(CXLabelStmt LS) {
  return reinterpret_cast<clang::LabelStmt *>(LS)->getName();
}

CXLabelDecl clang_LabelStmt_getDecl(CXLabelStmt LS) {
  return reinterpret_cast<CXLabelDecl>(reinterpret_cast<clang::LabelStmt *>(LS)->getDecl());
}

CXStmt clang_LabelStmt_getSubStmt(CXLabelStmt LS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::LabelStmt *>(LS)->getSubStmt());
}

// IfStmt
CXExpr clang_IfStmt_getCond(CXIfStmt IS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::IfStmt *>(IS)->getCond());
}

CXStmt clang_IfStmt_getThen(CXIfStmt IS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::IfStmt *>(IS)->getThen());
}

CXStmt clang_IfStmt_getElse(CXIfStmt IS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::IfStmt *>(IS)->getElse());
}

bool clang_IfStmt_hasElseStorage(CXIfStmt IS) {
  return reinterpret_cast<clang::IfStmt *>(IS)->hasElseStorage();
}

bool clang_IfStmt_hasInitStorage(CXIfStmt IS) {
  return reinterpret_cast<clang::IfStmt *>(IS)->hasInitStorage();
}

bool clang_IfStmt_hasVarStorage(CXIfStmt IS) {
  return reinterpret_cast<clang::IfStmt *>(IS)->hasVarStorage();
}

CXStmt clang_IfStmt_getInit(CXIfStmt IS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::IfStmt *>(IS)->getInit());
}

CXVarDecl clang_IfStmt_getConditionVariable(CXIfStmt IS) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::IfStmt *>(IS)->getConditionVariable());
}

CXSourceLocation_ clang_IfStmt_getIfLoc(CXIfStmt IS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IfStmt *>(IS)->getIfLoc().getPtrEncoding());
}

// SwitchStmt
CXExpr clang_SwitchStmt_getCond(CXSwitchStmt SS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::SwitchStmt *>(SS)->getCond());
}

CXStmt clang_SwitchStmt_getBody(CXSwitchStmt SS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::SwitchStmt *>(SS)->getBody());
}

CXSwitchCase clang_SwitchStmt_getSwitchCaseList(CXSwitchStmt SS) {
  return reinterpret_cast<CXSwitchCase>(reinterpret_cast<clang::SwitchStmt *>(SS)->getSwitchCaseList());
}

bool clang_SwitchStmt_isAllEnumCasesCovered(CXSwitchStmt SS) {
  return reinterpret_cast<clang::SwitchStmt *>(SS)->isAllEnumCasesCovered();
}

// WhileStmt
CXExpr clang_WhileStmt_getCond(CXWhileStmt WS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::WhileStmt *>(WS)->getCond());
}

CXStmt clang_WhileStmt_getBody(CXWhileStmt WS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::WhileStmt *>(WS)->getBody());
}

CXVarDecl clang_WhileStmt_getConditionVariable(CXWhileStmt WS) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::WhileStmt *>(WS)->getConditionVariable());
}

CXSourceLocation_ clang_WhileStmt_getWhileLoc(CXWhileStmt WS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::WhileStmt *>(WS)->getWhileLoc().getPtrEncoding());
}

// DoStmt
CXExpr clang_DoStmt_getCond(CXDoStmt DS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DoStmt *>(DS)->getCond());
}

CXStmt clang_DoStmt_getBody(CXDoStmt DS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::DoStmt *>(DS)->getBody());
}

CXSourceLocation_ clang_DoStmt_getDoLoc(CXDoStmt DS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DoStmt *>(DS)->getDoLoc().getPtrEncoding());
}

CXSourceLocation_ clang_DoStmt_getWhileLoc(CXDoStmt DS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DoStmt *>(DS)->getWhileLoc().getPtrEncoding());
}

// ForStmt
CXStmt clang_ForStmt_getInit(CXForStmt FS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::ForStmt *>(FS)->getInit());
}

CXExpr clang_ForStmt_getCond(CXForStmt FS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ForStmt *>(FS)->getCond());
}

CXExpr clang_ForStmt_getInc(CXForStmt FS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ForStmt *>(FS)->getInc());
}

CXStmt clang_ForStmt_getBody(CXForStmt FS) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::ForStmt *>(FS)->getBody());
}

CXVarDecl clang_ForStmt_getConditionVariable(CXForStmt FS) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::ForStmt *>(FS)->getConditionVariable());
}

CXSourceLocation_ clang_ForStmt_getForLoc(CXForStmt FS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ForStmt *>(FS)->getForLoc().getPtrEncoding());
}

// GotoStmt
CXLabelDecl clang_GotoStmt_getLabel(CXGotoStmt GS) {
  return reinterpret_cast<CXLabelDecl>(reinterpret_cast<clang::GotoStmt *>(GS)->getLabel());
}

CXSourceLocation_ clang_GotoStmt_getGotoLoc(CXGotoStmt GS) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GotoStmt *>(GS)->getGotoLoc().getPtrEncoding());
}

// ReturnStmt
CXExpr clang_ReturnStmt_getRetValue(CXReturnStmt RS) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ReturnStmt *>(RS)->getRetValue());
}

// IfStmt
CXSourceLocation_ clang_IfStmt_getElseLoc(CXIfStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IfStmt *>(S)->getElseLoc().getPtrEncoding());
}

bool clang_IfStmt_isConsteval(CXIfStmt S) {
  return reinterpret_cast<clang::IfStmt *>(S)->isConsteval();
}

bool clang_IfStmt_isNonNegatedConsteval(CXIfStmt S) {
  return reinterpret_cast<clang::IfStmt *>(S)->isNonNegatedConsteval();
}

bool clang_IfStmt_isNegatedConsteval(CXIfStmt S) {
  return reinterpret_cast<clang::IfStmt *>(S)->isNegatedConsteval();
}

bool clang_IfStmt_isConstexpr(CXIfStmt S) {
  return reinterpret_cast<clang::IfStmt *>(S)->isConstexpr();
}

bool clang_IfStmt_isObjCAvailabilityCheck(CXIfStmt S) {
  return reinterpret_cast<clang::IfStmt *>(S)->isObjCAvailabilityCheck();
}

CXStmt clang_IfStmt_getNondiscardedCase(CXIfStmt S, CXASTContext Ctx) {
  auto Case = reinterpret_cast<clang::IfStmt *>(S)->getNondiscardedCase(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
  return reinterpret_cast<CXStmt>(Case ? *Case : nullptr);
}

CXSourceLocation_ clang_IfStmt_getLParenLoc(CXIfStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IfStmt *>(S)->getLParenLoc().getPtrEncoding());
}

CXSourceLocation_ clang_IfStmt_getRParenLoc(CXIfStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IfStmt *>(S)->getRParenLoc().getPtrEncoding());
}

// SwitchStmt
bool clang_SwitchStmt_hasInitStorage(CXSwitchStmt S) {
  return reinterpret_cast<clang::SwitchStmt *>(S)->hasInitStorage();
}

bool clang_SwitchStmt_hasVarStorage(CXSwitchStmt S) {
  return reinterpret_cast<clang::SwitchStmt *>(S)->hasVarStorage();
}

CXSourceLocation_ clang_SwitchStmt_getSwitchLoc(CXSwitchStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SwitchStmt *>(S)->getSwitchLoc().getPtrEncoding());
}

CXSourceLocation_ clang_SwitchStmt_getLParenLoc(CXSwitchStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SwitchStmt *>(S)->getLParenLoc().getPtrEncoding());
}

CXSourceLocation_ clang_SwitchStmt_getRParenLoc(CXSwitchStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SwitchStmt *>(S)->getRParenLoc().getPtrEncoding());
}

// WhileStmt
bool clang_WhileStmt_hasVarStorage(CXWhileStmt S) {
  return reinterpret_cast<clang::WhileStmt *>(S)->hasVarStorage();
}

CXSourceLocation_ clang_WhileStmt_getLParenLoc(CXWhileStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::WhileStmt *>(S)->getLParenLoc().getPtrEncoding());
}

CXSourceLocation_ clang_WhileStmt_getRParenLoc(CXWhileStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::WhileStmt *>(S)->getRParenLoc().getPtrEncoding());
}

// DoStmt
CXSourceLocation_ clang_DoStmt_getRParenLoc(CXDoStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DoStmt *>(S)->getRParenLoc().getPtrEncoding());
}

// ForStmt
CXSourceLocation_ clang_ForStmt_getLParenLoc(CXForStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ForStmt *>(S)->getLParenLoc().getPtrEncoding());
}

CXSourceLocation_ clang_ForStmt_getRParenLoc(CXForStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ForStmt *>(S)->getRParenLoc().getPtrEncoding());
}

// GotoStmt
CXSourceLocation_ clang_GotoStmt_getLabelLoc(CXGotoStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GotoStmt *>(S)->getLabelLoc().getPtrEncoding());
}

// IndirectGotoStmt
CXSourceLocation_ clang_IndirectGotoStmt_getGotoLoc(CXIndirectGotoStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IndirectGotoStmt *>(S)->getGotoLoc().getPtrEncoding());
}

CXSourceLocation_ clang_IndirectGotoStmt_getStarLoc(CXIndirectGotoStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IndirectGotoStmt *>(S)->getStarLoc().getPtrEncoding());
}

// ContinueStmt
CXSourceLocation_ clang_ContinueStmt_getContinueLoc(CXContinueStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ContinueStmt *>(S)->getContinueLoc().getPtrEncoding());
}

// BreakStmt
CXSourceLocation_ clang_BreakStmt_getBreakLoc(CXBreakStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::BreakStmt *>(S)->getBreakLoc().getPtrEncoding());
}

// ReturnStmt
CXSourceLocation_ clang_ReturnStmt_getReturnLoc(CXReturnStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ReturnStmt *>(S)->getReturnLoc().getPtrEncoding());
}

// SwitchCase
CXSourceLocation_ clang_SwitchCase_getKeywordLoc(CXSwitchCase S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SwitchCase *>(S)->getKeywordLoc().getPtrEncoding());
}

CXSourceLocation_ clang_SwitchCase_getColonLoc(CXSwitchCase S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SwitchCase *>(S)->getColonLoc().getPtrEncoding());
}

// CaseStmt
bool clang_CaseStmt_caseStmtIsGNURange(CXCaseStmt S) {
  return reinterpret_cast<clang::CaseStmt *>(S)->caseStmtIsGNURange();
}

CXSourceLocation_ clang_CaseStmt_getCaseLoc(CXCaseStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CaseStmt *>(S)->getCaseLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CaseStmt_getEllipsisLoc(CXCaseStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CaseStmt *>(S)->getEllipsisLoc().getPtrEncoding());
}

// DefaultStmt
CXSourceLocation_ clang_DefaultStmt_getDefaultLoc(CXDefaultStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DefaultStmt *>(S)->getDefaultLoc().getPtrEncoding());
}

// LabelStmt
CXSourceLocation_ clang_LabelStmt_getIdentLoc(CXLabelStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::LabelStmt *>(S)->getIdentLoc().getPtrEncoding());
}

bool clang_LabelStmt_isSideEntry(CXLabelStmt S) {
  return reinterpret_cast<clang::LabelStmt *>(S)->isSideEntry();
}

// NullStmt
CXSourceLocation_ clang_NullStmt_getSemiLoc(CXNullStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::NullStmt *>(S)->getSemiLoc().getPtrEncoding());
}

bool clang_NullStmt_hasLeadingEmptyMacro(CXNullStmt S) {
  return reinterpret_cast<clang::NullStmt *>(S)->hasLeadingEmptyMacro();
}

// CompoundStmt
bool clang_CompoundStmt_body_empty(CXCompoundStmt S) {
  return reinterpret_cast<clang::CompoundStmt *>(S)->body_empty();
}

bool clang_CompoundStmt_hasStoredFPFeatures(CXCompoundStmt S) {
  return reinterpret_cast<clang::CompoundStmt *>(S)->hasStoredFPFeatures();
}

// IfStmt
void clang_IfStmt_setInit(CXIfStmt S, CXStmt Init) {
  reinterpret_cast<clang::IfStmt *>(S)->setInit(reinterpret_cast<clang::Stmt *>(Init));
}

void clang_IfStmt_setCond(CXIfStmt S, CXExpr Cond) {
  reinterpret_cast<clang::IfStmt *>(S)->setCond(reinterpret_cast<clang::Expr *>(Cond));
}

void clang_IfStmt_setThen(CXIfStmt S, CXStmt Then) {
  reinterpret_cast<clang::IfStmt *>(S)->setThen(reinterpret_cast<clang::Stmt *>(Then));
}

void clang_IfStmt_setElse(CXIfStmt S, CXStmt Else) {
  reinterpret_cast<clang::IfStmt *>(S)->setElse(reinterpret_cast<clang::Stmt *>(Else));
}

CXDeclStmt clang_IfStmt_getConditionVariableDeclStmt(CXIfStmt S) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::IfStmt *>(S)->getConditionVariableDeclStmt());
}

// SwitchStmt
CXStmt clang_SwitchStmt_getInit(CXSwitchStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::SwitchStmt *>(S)->getInit());
}

CXVarDecl clang_SwitchStmt_getConditionVariable(CXSwitchStmt S) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::SwitchStmt *>(S)->getConditionVariable());
}

CXDeclStmt clang_SwitchStmt_getConditionVariableDeclStmt(CXSwitchStmt S) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::SwitchStmt *>(S)->getConditionVariableDeclStmt());
}

void clang_SwitchStmt_setInit(CXSwitchStmt S, CXStmt Init) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setInit(reinterpret_cast<clang::Stmt *>(Init));
}

void clang_SwitchStmt_setCond(CXSwitchStmt S, CXExpr Cond) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setCond(reinterpret_cast<clang::Expr *>(Cond));
}

void clang_SwitchStmt_setBody(CXSwitchStmt S, CXStmt Body) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setBody(reinterpret_cast<clang::Stmt *>(Body));
}

// WhileStmt
void clang_WhileStmt_setCond(CXWhileStmt S, CXExpr Cond) {
  reinterpret_cast<clang::WhileStmt *>(S)->setCond(reinterpret_cast<clang::Expr *>(Cond));
}

void clang_WhileStmt_setBody(CXWhileStmt S, CXStmt Body) {
  reinterpret_cast<clang::WhileStmt *>(S)->setBody(reinterpret_cast<clang::Stmt *>(Body));
}

// DoStmt
void clang_DoStmt_setCond(CXDoStmt S, CXExpr Cond) {
  reinterpret_cast<clang::DoStmt *>(S)->setCond(reinterpret_cast<clang::Expr *>(Cond));
}

void clang_DoStmt_setBody(CXDoStmt S, CXStmt Body) {
  reinterpret_cast<clang::DoStmt *>(S)->setBody(reinterpret_cast<clang::Stmt *>(Body));
}

// ForStmt
void clang_ForStmt_setInit(CXForStmt S, CXStmt Init) {
  reinterpret_cast<clang::ForStmt *>(S)->setInit(reinterpret_cast<clang::Stmt *>(Init));
}

void clang_ForStmt_setCond(CXForStmt S, CXExpr Cond) {
  reinterpret_cast<clang::ForStmt *>(S)->setCond(reinterpret_cast<clang::Expr *>(Cond));
}

void clang_ForStmt_setInc(CXForStmt S, CXExpr Inc) {
  reinterpret_cast<clang::ForStmt *>(S)->setInc(reinterpret_cast<clang::Expr *>(Inc));
}

void clang_ForStmt_setBody(CXForStmt S, CXStmt Body) {
  reinterpret_cast<clang::ForStmt *>(S)->setBody(reinterpret_cast<clang::Stmt *>(Body));
}

// AttributedStmt
CXStmt clang_AttributedStmt_getSubStmt(CXAttributedStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::AttributedStmt *>(S)->getSubStmt());
}

CXSourceLocation_ clang_AttributedStmt_getAttrLoc(CXAttributedStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AttributedStmt *>(S)->getAttrLoc().getPtrEncoding());
}

unsigned clang_AttributedStmt_getNumAttrs(CXAttributedStmt S) {
  return reinterpret_cast<clang::AttributedStmt *>(S)->getAttrs().size();
}

void clang_AttributedStmt_getAttrs(CXAttributedStmt S, CXAttr *Buf) {
  size_t I = 0;
  for (const clang::Attr *A : reinterpret_cast<clang::AttributedStmt *>(S)->getAttrs())
    Buf[I++] = reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(A));
}

// AsmStmt
CXSourceLocation_ clang_AsmStmt_getAsmLoc(CXAsmStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AsmStmt *>(S)->getAsmLoc().getPtrEncoding());
}

bool clang_AsmStmt_isSimple(CXAsmStmt S) {
  return reinterpret_cast<clang::AsmStmt *>(S)->isSimple();
}

bool clang_AsmStmt_isVolatile(CXAsmStmt S) {
  return reinterpret_cast<clang::AsmStmt *>(S)->isVolatile();
}

CXString clang_AsmStmt_generateAsmString(CXAsmStmt S, CXASTContext Ctx) {
  auto *AS = reinterpret_cast<clang::AsmStmt *>(S);
  return extra::makeCXString(
      AS->generateAsmString(*reinterpret_cast<clang::ASTContext *>(Ctx)));
}

unsigned clang_AsmStmt_getNumOutputs(CXAsmStmt S) {
  return reinterpret_cast<clang::AsmStmt *>(S)->getNumOutputs();
}

CXString clang_AsmStmt_getOutputConstraint(CXAsmStmt S, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<clang::AsmStmt *>(S)->getOutputConstraint(I).str());
}

CXExpr clang_AsmStmt_getOutputExpr(CXAsmStmt S, unsigned I) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::AsmStmt *>(S)->getOutputExpr(I)));
}

bool clang_AsmStmt_isOutputPlusConstraint(CXAsmStmt S, unsigned I) {
  return reinterpret_cast<clang::AsmStmt *>(S)->isOutputPlusConstraint(I);
}

unsigned clang_AsmStmt_getNumPlusOperands(CXAsmStmt S) {
  return reinterpret_cast<clang::AsmStmt *>(S)->getNumPlusOperands();
}

unsigned clang_AsmStmt_getNumInputs(CXAsmStmt S) {
  return reinterpret_cast<clang::AsmStmt *>(S)->getNumInputs();
}

CXString clang_AsmStmt_getInputConstraint(CXAsmStmt S, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<clang::AsmStmt *>(S)->getInputConstraint(I).str());
}

CXExpr clang_AsmStmt_getInputExpr(CXAsmStmt S, unsigned I) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::AsmStmt *>(S)->getInputExpr(I)));
}

unsigned clang_AsmStmt_getNumClobbers(CXAsmStmt S) {
  return reinterpret_cast<clang::AsmStmt *>(S)->getNumClobbers();
}

CXString clang_AsmStmt_getClobber(CXAsmStmt S, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<clang::AsmStmt *>(S)->getClobber(I).str());
}

// GCCAsmStmt
CXStringLiteral clang_GCCAsmStmt_getAsmString(CXGCCAsmStmt S) {
  return reinterpret_cast<CXStringLiteral>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getAsmString());
}

CXString clang_GCCAsmStmt_getOutputName(CXGCCAsmStmt S, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<clang::GCCAsmStmt *>(S)->getOutputName(I).str());
}

CXString clang_GCCAsmStmt_getInputName(CXGCCAsmStmt S, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<clang::GCCAsmStmt *>(S)->getInputName(I).str());
}

bool clang_GCCAsmStmt_isAsmGoto(CXGCCAsmStmt S) {
  return reinterpret_cast<clang::GCCAsmStmt *>(S)->isAsmGoto();
}

unsigned clang_GCCAsmStmt_getNumLabels(CXGCCAsmStmt S) {
  return reinterpret_cast<clang::GCCAsmStmt *>(S)->getNumLabels();
}

CXIdentifierInfo clang_GCCAsmStmt_getOutputIdentifier(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getOutputIdentifier(I));
}

CXStringLiteral clang_GCCAsmStmt_getOutputConstraintLiteral(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXStringLiteral>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getOutputConstraintLiteral(I));
}

CXIdentifierInfo clang_GCCAsmStmt_getInputIdentifier(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getInputIdentifier(I));
}

CXStringLiteral clang_GCCAsmStmt_getInputConstraintLiteral(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXStringLiteral>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getInputConstraintLiteral(I));
}

CXIdentifierInfo clang_GCCAsmStmt_getLabelIdentifier(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getLabelIdentifier(I));
}

CXStringLiteral clang_GCCAsmStmt_getClobberStringLiteral(CXGCCAsmStmt S, unsigned I) {
  return reinterpret_cast<CXStringLiteral>(reinterpret_cast<clang::GCCAsmStmt *>(S)->getClobberStringLiteral(I));
}

// MSAsmStmt
CXString clang_MSAsmStmt_getAsmString(CXMSAsmStmt S) {
  return extra::makeCXString(
      reinterpret_cast<clang::MSAsmStmt *>(S)->getAsmString().str());
}

bool clang_MSAsmStmt_hasBraces(CXMSAsmStmt S) {
  return reinterpret_cast<clang::MSAsmStmt *>(S)->hasBraces();
}

CXSourceLocation_ clang_MSAsmStmt_getLBraceLoc(CXMSAsmStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MSAsmStmt *>(S)->getLBraceLoc().getPtrEncoding());
}

// ValueStmt
CXExpr clang_ValueStmt_getExprStmt(CXValueStmt S) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ValueStmt *>(S)->getExprStmt());
}

// CompoundStmt
CXStmt clang_CompoundStmt_getStmtExprResult(CXCompoundStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CompoundStmt *>(S)->getStmtExprResult());
}

// IndirectGotoStmt
CXExpr clang_IndirectGotoStmt_getTarget(CXIndirectGotoStmt S) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::IndirectGotoStmt *>(S)->getTarget());
}

CXLabelDecl clang_IndirectGotoStmt_getConstantTarget(CXIndirectGotoStmt S) {
  return reinterpret_cast<CXLabelDecl>(reinterpret_cast<clang::IndirectGotoStmt *>(S)->getConstantTarget());
}

// ReturnStmt
CXVarDecl clang_ReturnStmt_getNRVOCandidate(CXReturnStmt S) {
  return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(
      reinterpret_cast<clang::ReturnStmt *>(S)->getNRVOCandidate()));
}

// SEHTryStmt
bool clang_SEHTryStmt_getIsCXXTry(CXSEHTryStmt S) {
  return reinterpret_cast<clang::SEHTryStmt *>(S)->getIsCXXTry();
}

CXSourceLocation_ clang_SEHTryStmt_getTryLoc(CXSEHTryStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SEHTryStmt *>(S)->getTryLoc().getPtrEncoding());
}

CXCompoundStmt clang_SEHTryStmt_getTryBlock(CXSEHTryStmt S) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::SEHTryStmt *>(S)->getTryBlock());
}

CXStmt clang_SEHTryStmt_getHandler(CXSEHTryStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::SEHTryStmt *>(S)->getHandler());
}

// clang::SEHTryStmt::getExceptHandler is not exported from clang-cpp; reimplement
// it as dyn_cast<SEHExceptStmt>(getHandler()) — getHandler() is header-inline and
// dyn_cast is header-only, so no external symbol is required.
CXSEHExceptStmt clang_SEHTryStmt_getExceptHandler(CXSEHTryStmt S) {
  return reinterpret_cast<CXSEHExceptStmt>(llvm::dyn_cast_or_null<clang::SEHExceptStmt>(
      reinterpret_cast<clang::SEHTryStmt *>(S)->getHandler()));
}

// clang::SEHTryStmt::getFinallyHandler is not exported from clang-cpp; same
// reimplementation over getHandler().
CXSEHFinallyStmt clang_SEHTryStmt_getFinallyHandler(CXSEHTryStmt S) {
  return reinterpret_cast<CXSEHFinallyStmt>(llvm::dyn_cast_or_null<clang::SEHFinallyStmt>(
      reinterpret_cast<clang::SEHTryStmt *>(S)->getHandler()));
}

// SEHExceptStmt
CXSourceLocation_ clang_SEHExceptStmt_getExceptLoc(CXSEHExceptStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SEHExceptStmt *>(S)->getExceptLoc().getPtrEncoding());
}

CXExpr clang_SEHExceptStmt_getFilterExpr(CXSEHExceptStmt S) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::SEHExceptStmt *>(S)->getFilterExpr());
}

CXCompoundStmt clang_SEHExceptStmt_getBlock(CXSEHExceptStmt S) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::SEHExceptStmt *>(S)->getBlock());
}

// SEHFinallyStmt
CXSourceLocation_ clang_SEHFinallyStmt_getFinallyLoc(CXSEHFinallyStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SEHFinallyStmt *>(S)->getFinallyLoc().getPtrEncoding());
}

CXCompoundStmt clang_SEHFinallyStmt_getBlock(CXSEHFinallyStmt S) {
  return reinterpret_cast<CXCompoundStmt>(reinterpret_cast<clang::SEHFinallyStmt *>(S)->getBlock());
}

// SEHLeaveStmt
CXSourceLocation_ clang_SEHLeaveStmt_getLeaveLoc(CXSEHLeaveStmt S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SEHLeaveStmt *>(S)->getLeaveLoc().getPtrEncoding());
}

// WhileStmt
CXDeclStmt clang_WhileStmt_getConditionVariableDeclStmt(CXWhileStmt S) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::WhileStmt *>(S)->getConditionVariableDeclStmt());
}

// ForStmt
CXDeclStmt clang_ForStmt_getConditionVariableDeclStmt(CXForStmt S) {
  return reinterpret_cast<CXDeclStmt>(reinterpret_cast<clang::ForStmt *>(S)->getConditionVariableDeclStmt());
}

// CapturedStmt
CXStmt clang_CapturedStmt_getCapturedStmt(CXCapturedStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CapturedStmt *>(S)->getCapturedStmt());
}

CXCapturedDecl clang_CapturedStmt_getCapturedDecl(CXCapturedStmt S) {
  return reinterpret_cast<CXCapturedDecl>(reinterpret_cast<clang::CapturedStmt *>(S)->getCapturedDecl());
}

CXRecordDecl clang_CapturedStmt_getCapturedRecordDecl(CXCapturedStmt S) {
  return reinterpret_cast<CXRecordDecl>(const_cast<clang::RecordDecl *>(
      reinterpret_cast<clang::CapturedStmt *>(S)->getCapturedRecordDecl()));
}

unsigned clang_CapturedStmt_capture_size(CXCapturedStmt S) {
  return reinterpret_cast<clang::CapturedStmt *>(S)->capture_size();
}

bool clang_CapturedStmt_capturesVariable(CXCapturedStmt S, CXVarDecl Var) {
  return reinterpret_cast<clang::CapturedStmt *>(S)->capturesVariable(
      reinterpret_cast<clang::VarDecl *>(Var));
}

// Stmt
CXLikelihood clang_Stmt_getLikelihood(CXStmt S) {
  return static_cast<CXLikelihood>(
      clang::Stmt::getLikelihood(reinterpret_cast<clang::Stmt *>(S)));
}

CXAttr clang_Stmt_getLikelihoodAttr(CXStmt S) {
  return reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(
      clang::Stmt::getLikelihoodAttr(reinterpret_cast<clang::Stmt *>(S))));
}

CXLikelihood clang_Stmt_getLikelihoodOfAttrs(const CXAttr *Attrs, unsigned NumAttrs) {
  llvm::SmallVector<const clang::Attr *, 4> As;
  As.reserve(NumAttrs);
  for (unsigned I = 0; I < NumAttrs; ++I)
    As.push_back(reinterpret_cast<const clang::Attr *>(Attrs[I]));
  return static_cast<CXLikelihood>(clang::Stmt::getLikelihood(As));
}

CXLikelihood clang_Stmt_getLikelihoodOfBranches(CXStmt Then, CXStmt Else) {
  return static_cast<CXLikelihood>(clang::Stmt::getLikelihood(
      reinterpret_cast<clang::Stmt *>(Then), reinterpret_cast<clang::Stmt *>(Else)));
}

bool clang_Stmt_determineLikelihoodConflict(CXStmt Then, CXStmt Else, CXAttr *ThenAttr,
                                            CXAttr *ElseAttr) {
  auto [Conflict, TA, EA] = clang::Stmt::determineLikelihoodConflict(
      reinterpret_cast<clang::Stmt *>(Then), reinterpret_cast<clang::Stmt *>(Else));
  *ThenAttr = reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(TA));
  *ElseAttr = reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(EA));
  return Conflict;
}

int64_t clang_Stmt_getID(CXStmt S, CXASTContext Ctx) {
  return reinterpret_cast<clang::Stmt *>(S)->getID(*reinterpret_cast<clang::ASTContext *>(Ctx));
}

void clang_Stmt_dumpPretty(CXStmt S, CXASTContext Ctx) {
  reinterpret_cast<clang::Stmt *>(S)->dumpPretty(*reinterpret_cast<clang::ASTContext *>(Ctx));
}

CXString clang_Stmt_printPretty(CXStmt S, CXASTContext Ctx, unsigned Indentation) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::Stmt *>(S)->printPretty(OS, nullptr, C->getPrintingPolicy(),
                                             Indentation, "\n", C);
  return extra::makeCXString(Str);
}

CXString clang_Stmt_printJson(CXStmt S, CXASTContext Ctx, bool AddQuotes) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::Stmt *>(S)->printJson(OS, nullptr, C->getPrintingPolicy(), AddQuotes);
  return extra::makeCXString(Str);
}

CXStmt clang_Stmt_IgnoreContainers(CXStmt S, bool IgnoreCaptured) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::Stmt *>(S)->IgnoreContainers(IgnoreCaptured));
}

CXStmt clang_Stmt_stripLabelLikeStatements(CXStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::Stmt *>(S)->stripLabelLikeStatements());
}

// DeclStmt
CXDeclGroupRef clang_DeclStmt_getDeclGroup(CXDeclStmt S) {
  return reinterpret_cast<CXDeclGroupRef>(reinterpret_cast<clang::DeclStmt *>(S)->getDeclGroup().getAsOpaquePtr());
}

// NullStmt
void clang_NullStmt_setSemiLoc(CXNullStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::NullStmt *>(S)->setSemiLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// SwitchCase
void clang_SwitchCase_setKeywordLoc(CXSwitchCase S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::SwitchCase *>(S)->setKeywordLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_SwitchCase_setColonLoc(CXSwitchCase S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::SwitchCase *>(S)->setColonLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// CaseStmt
void clang_CaseStmt_setLHS(CXCaseStmt S, CXExpr Val) {
  reinterpret_cast<clang::CaseStmt *>(S)->setLHS(reinterpret_cast<clang::Expr *>(Val));
}

void clang_CaseStmt_setRHS(CXCaseStmt S, CXExpr Val) {
  reinterpret_cast<clang::CaseStmt *>(S)->setRHS(reinterpret_cast<clang::Expr *>(Val));
}

void clang_CaseStmt_setSubStmt(CXCaseStmt S, CXStmt Sub) {
  reinterpret_cast<clang::CaseStmt *>(S)->setSubStmt(reinterpret_cast<clang::Stmt *>(Sub));
}

// DefaultStmt
void clang_DefaultStmt_setSubStmt(CXDefaultStmt S, CXStmt Sub) {
  reinterpret_cast<clang::DefaultStmt *>(S)->setSubStmt(reinterpret_cast<clang::Stmt *>(Sub));
}

// LabelStmt
void clang_LabelStmt_setSubStmt(CXLabelStmt S, CXStmt Sub) {
  reinterpret_cast<clang::LabelStmt *>(S)->setSubStmt(reinterpret_cast<clang::Stmt *>(Sub));
}

// ContinueStmt
void clang_ContinueStmt_setContinueLoc(CXContinueStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::ContinueStmt *>(S)->setContinueLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// BreakStmt
void clang_BreakStmt_setBreakLoc(CXBreakStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::BreakStmt *>(S)->setBreakLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// ReturnStmt
void clang_ReturnStmt_setRetValue(CXReturnStmt S, CXExpr E) {
  reinterpret_cast<clang::ReturnStmt *>(S)->setRetValue(reinterpret_cast<clang::Expr *>(E));
}

// DeclStmt
void clang_DeclStmt_setStartLoc(CXDeclStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DeclStmt *>(S)->setStartLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_DeclStmt_setEndLoc(CXDeclStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DeclStmt *>(S)->setEndLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// CompoundStmt
uint64_t clang_CompoundStmt_getStoredFPFeatures(CXCompoundStmt S) {
  return reinterpret_cast<clang::CompoundStmt *>(S)->getStoredFPFeatures().getAsOpaqueInt();
}

// IfStmt
void clang_IfStmt_setIfLoc(CXIfStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::IfStmt *>(S)->setIfLoc(clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_IfStmt_setElseLoc(CXIfStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::IfStmt *>(S)->setElseLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_IfStmt_setLParenLoc(CXIfStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::IfStmt *>(S)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_IfStmt_setRParenLoc(CXIfStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::IfStmt *>(S)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// SwitchStmt
void clang_SwitchStmt_setSwitchLoc(CXSwitchStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setSwitchLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_SwitchStmt_setLParenLoc(CXSwitchStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_SwitchStmt_setRParenLoc(CXSwitchStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_SwitchStmt_setAllEnumCasesCovered(CXSwitchStmt S) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setAllEnumCasesCovered();
}

// WhileStmt
void clang_WhileStmt_setWhileLoc(CXWhileStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::WhileStmt *>(S)->setWhileLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_WhileStmt_setLParenLoc(CXWhileStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::WhileStmt *>(S)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_WhileStmt_setRParenLoc(CXWhileStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::WhileStmt *>(S)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// DoStmt
void clang_DoStmt_setDoLoc(CXDoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DoStmt *>(S)->setDoLoc(clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_DoStmt_setWhileLoc(CXDoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DoStmt *>(S)->setWhileLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_DoStmt_setRParenLoc(CXDoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DoStmt *>(S)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// ForStmt
void clang_ForStmt_setForLoc(CXForStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::ForStmt *>(S)->setForLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_ForStmt_setLParenLoc(CXForStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::ForStmt *>(S)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_ForStmt_setRParenLoc(CXForStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::ForStmt *>(S)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// CapturedStmt
CXCapturedRegionKind clang_CapturedStmt_getCapturedRegionKind(CXCapturedStmt S) {
  return static_cast<CXCapturedRegionKind>(
      reinterpret_cast<clang::CapturedStmt *>(S)->getCapturedRegionKind());
}

void clang_CapturedStmt_setCapturedRegionKind(CXCapturedStmt S, CXCapturedRegionKind Kind) {
  reinterpret_cast<clang::CapturedStmt *>(S)->setCapturedRegionKind(
      static_cast<clang::CapturedRegionKind>(Kind));
}

CXCapturedStmtCapture clang_CapturedStmt_getCapture(CXCapturedStmt S, unsigned I) {
  return reinterpret_cast<CXCapturedStmtCapture>(reinterpret_cast<clang::CapturedStmt *>(S)->capture_begin() + I);
}

CXExpr clang_CapturedStmt_getCaptureInit(CXCapturedStmt S, unsigned I) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CapturedStmt *>(S)->capture_init_begin()[I]);
}

// CapturedStmt::Capture
CXVariableCaptureKind clang_CapturedStmtCapture_getCaptureKind(CXCapturedStmtCapture C) {
  return static_cast<CXVariableCaptureKind>(
      reinterpret_cast<clang::CapturedStmt::Capture *>(C)->getCaptureKind());
}

CXSourceLocation_ clang_CapturedStmtCapture_getLocation(CXCapturedStmtCapture C) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CapturedStmt::Capture *>(C)->getLocation().getPtrEncoding());
}

bool clang_CapturedStmtCapture_capturesThis(CXCapturedStmtCapture C) {
  return reinterpret_cast<clang::CapturedStmt::Capture *>(C)->capturesThis();
}

bool clang_CapturedStmtCapture_capturesVariable(CXCapturedStmtCapture C) {
  return reinterpret_cast<clang::CapturedStmt::Capture *>(C)->capturesVariable();
}

bool clang_CapturedStmtCapture_capturesVariableByCopy(CXCapturedStmtCapture C) {
  return reinterpret_cast<clang::CapturedStmt::Capture *>(C)->capturesVariableByCopy();
}

bool clang_CapturedStmtCapture_capturesVariableArrayType(CXCapturedStmtCapture C) {
  return reinterpret_cast<clang::CapturedStmt::Capture *>(C)->capturesVariableArrayType();
}

CXVarDecl clang_CapturedStmtCapture_getCapturedVar(CXCapturedStmtCapture C) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::CapturedStmt::Capture *>(C)->getCapturedVar());
}

// LabelStmt
void clang_LabelStmt_setIdentLoc(CXLabelStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::LabelStmt *>(S)->setIdentLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_LabelStmt_setDecl(CXLabelStmt S, CXLabelDecl D) {
  reinterpret_cast<clang::LabelStmt *>(S)->setDecl(reinterpret_cast<clang::LabelDecl *>(D));
}

void clang_LabelStmt_setSideEntry(CXLabelStmt S, bool SE) {
  reinterpret_cast<clang::LabelStmt *>(S)->setSideEntry(SE);
}

// GotoStmt
void clang_GotoStmt_setLabel(CXGotoStmt S, CXLabelDecl D) {
  reinterpret_cast<clang::GotoStmt *>(S)->setLabel(reinterpret_cast<clang::LabelDecl *>(D));
}

void clang_GotoStmt_setGotoLoc(CXGotoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::GotoStmt *>(S)->setGotoLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_GotoStmt_setLabelLoc(CXGotoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::GotoStmt *>(S)->setLabelLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// IndirectGotoStmt
void clang_IndirectGotoStmt_setGotoLoc(CXIndirectGotoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::IndirectGotoStmt *>(S)->setGotoLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_IndirectGotoStmt_setStarLoc(CXIndirectGotoStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::IndirectGotoStmt *>(S)->setStarLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_IndirectGotoStmt_setTarget(CXIndirectGotoStmt S, CXExpr E) {
  reinterpret_cast<clang::IndirectGotoStmt *>(S)->setTarget(reinterpret_cast<clang::Expr *>(E));
}

// DeclStmt
void clang_DeclStmt_setDeclGroup(CXDeclStmt S, CXDeclGroupRef DG) {
  reinterpret_cast<clang::DeclStmt *>(S)->setDeclGroup(
      clang::DeclGroupRef::getFromOpaquePtr(DG));
}

// SwitchCase
void clang_SwitchCase_setNextSwitchCase(CXSwitchCase S, CXSwitchCase Next) {
  reinterpret_cast<clang::SwitchCase *>(S)->setNextSwitchCase(
      reinterpret_cast<clang::SwitchCase *>(Next));
}

// CaseStmt
void clang_CaseStmt_setCaseLoc(CXCaseStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::CaseStmt *>(S)->setCaseLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CaseStmt_setEllipsisLoc(CXCaseStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::CaseStmt *>(S)->setEllipsisLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// DefaultStmt
void clang_DefaultStmt_setDefaultLoc(CXDefaultStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DefaultStmt *>(S)->setDefaultLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// IfStmt
void clang_IfStmt_setConditionVariableDeclStmt(CXIfStmt S, CXDeclStmt CondVar) {
  reinterpret_cast<clang::IfStmt *>(S)->setConditionVariableDeclStmt(
      reinterpret_cast<clang::DeclStmt *>(CondVar));
}

void clang_IfStmt_setStatementKind(CXIfStmt S, CXIfStatementKind Kind) {
  reinterpret_cast<clang::IfStmt *>(S)->setStatementKind(
      static_cast<clang::IfStatementKind>(Kind));
}

CXIfStatementKind clang_IfStmt_getStatementKind(CXIfStmt S) {
  return static_cast<CXIfStatementKind>(
      reinterpret_cast<clang::IfStmt *>(S)->getStatementKind());
}

// SwitchStmt
void clang_SwitchStmt_setConditionVariableDeclStmt(CXSwitchStmt S, CXDeclStmt CondVar) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setConditionVariableDeclStmt(
      reinterpret_cast<clang::DeclStmt *>(CondVar));
}

void clang_SwitchStmt_setSwitchCaseList(CXSwitchStmt S, CXSwitchCase First) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setSwitchCaseList(
      reinterpret_cast<clang::SwitchCase *>(First));
}

// WhileStmt
void clang_WhileStmt_setConditionVariableDeclStmt(CXWhileStmt S, CXDeclStmt CondVar) {
  reinterpret_cast<clang::WhileStmt *>(S)->setConditionVariableDeclStmt(
      reinterpret_cast<clang::DeclStmt *>(CondVar));
}

// ForStmt
void clang_ForStmt_setConditionVariableDeclStmt(CXForStmt S, CXDeclStmt CondVar) {
  reinterpret_cast<clang::ForStmt *>(S)->setConditionVariableDeclStmt(
      reinterpret_cast<clang::DeclStmt *>(CondVar));
}

// ReturnStmt
void clang_ReturnStmt_setReturnLoc(CXReturnStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::ReturnStmt *>(S)->setReturnLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// AsmStmt
void clang_AsmStmt_setAsmLoc(CXAsmStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::AsmStmt *>(S)->setAsmLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_AsmStmt_setSimple(CXAsmStmt S, bool V) {
  reinterpret_cast<clang::AsmStmt *>(S)->setSimple(V);
}

void clang_AsmStmt_setVolatile(CXAsmStmt S, bool V) {
  reinterpret_cast<clang::AsmStmt *>(S)->setVolatile(V);
}

// GCCAsmStmt
void clang_GCCAsmStmt_setRParenLoc(CXGCCAsmStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::GCCAsmStmt *>(S)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// SEHLeaveStmt
void clang_SEHLeaveStmt_setLeaveLoc(CXSEHLeaveStmt S, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::SEHLeaveStmt *>(S)->setLeaveLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// CapturedStmt
void clang_CapturedStmt_setCapturedDecl(CXCapturedStmt S, CXCapturedDecl D) {
  reinterpret_cast<clang::CapturedStmt *>(S)->setCapturedDecl(
      reinterpret_cast<clang::CapturedDecl *>(D));
}

void clang_CapturedStmt_setCapturedRecordDecl(CXCapturedStmt S, CXRecordDecl D) {
  reinterpret_cast<clang::CapturedStmt *>(S)->setCapturedRecordDecl(
      reinterpret_cast<clang::RecordDecl *>(D));
}

// Stmt (colour dump, controlled pretty-printing, structural profile)
void clang_Stmt_dumpColor(CXStmt S) { reinterpret_cast<clang::Stmt *>(S)->dumpColor(); }

CXString clang_Stmt_printPrettyControlled(CXStmt S, CXASTContext Ctx,
                                          unsigned Indentation) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::Stmt *>(S)->printPrettyControlled(OS, nullptr, C->getPrintingPolicy(),
                                                       Indentation, "\n", C);
  return extra::makeCXString(Str);
}

unsigned clang_Stmt_getProfileHash(CXStmt S, CXASTContext Ctx, bool Canonical,
                                   bool ProfileLambdaExpr) {
  llvm::FoldingSetNodeID ID;
  reinterpret_cast<clang::Stmt *>(S)->Profile(ID, *reinterpret_cast<clang::ASTContext *>(Ctx),
                                         Canonical, ProfileLambdaExpr);
  return ID.ComputeHash();
}

// GCCAsmStmt
void clang_GCCAsmStmt_setAsmString(CXGCCAsmStmt S, CXStringLiteral E) {
  reinterpret_cast<clang::GCCAsmStmt *>(S)->setAsmString(reinterpret_cast<clang::StringLiteral *>(E));
}

// MSAsmStmt
unsigned clang_MSAsmStmt_getNumAsmToks(CXMSAsmStmt S) {
  return reinterpret_cast<clang::MSAsmStmt *>(S)->getNumAsmToks();
}

CXToken_ clang_MSAsmStmt_getAsmTok(CXMSAsmStmt S, unsigned I) {
  return reinterpret_cast<CXToken_>(reinterpret_cast<clang::MSAsmStmt *>(S)->getAsmToks() + I);
}

void clang_MSAsmStmt_setLBraceLoc(CXMSAsmStmt S, CXSourceLocation_ L) {
  reinterpret_cast<clang::MSAsmStmt *>(S)->setLBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_MSAsmStmt_setEndLoc(CXMSAsmStmt S, CXSourceLocation_ L) {
  reinterpret_cast<clang::MSAsmStmt *>(S)->setEndLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_MSAsmStmt_setInputExpr(CXMSAsmStmt S, unsigned I, CXExpr E) {
  reinterpret_cast<clang::MSAsmStmt *>(S)->setInputExpr(I, reinterpret_cast<clang::Expr *>(E));
}

// ReturnStmt
void clang_ReturnStmt_setNRVOCandidate(CXReturnStmt S, CXVarDecl Var) {
  reinterpret_cast<clang::ReturnStmt *>(S)->setNRVOCandidate(reinterpret_cast<clang::VarDecl *>(Var));
}

// Statement factories (clang/AST/Stmt.h)
// CompoundStmt
CXCompoundStmt clang_CompoundStmt_CreateEmpty(CXASTContext Ctx, unsigned NumStmts,
                                              bool HasFPFeatures) {
  return reinterpret_cast<CXCompoundStmt>(clang::CompoundStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx), NumStmts,
                                          HasFPFeatures));
}

// CaseStmt
CXCaseStmt clang_CaseStmt_Create(CXASTContext Ctx, CXExpr LHS, CXExpr RHS,
                                 CXSourceLocation_ CaseLoc, CXSourceLocation_ EllipsisLoc,
                                 CXSourceLocation_ ColonLoc) {
  return reinterpret_cast<CXCaseStmt>(clang::CaseStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::Expr *>(LHS),
      reinterpret_cast<clang::Expr *>(RHS), clang::SourceLocation::getFromPtrEncoding(CaseLoc),
      clang::SourceLocation::getFromPtrEncoding(EllipsisLoc),
      clang::SourceLocation::getFromPtrEncoding(ColonLoc)));
}

CXCaseStmt clang_CaseStmt_CreateEmpty(CXASTContext Ctx, bool CaseStmtIsGNURange) {
  return reinterpret_cast<CXCaseStmt>(clang::CaseStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                      CaseStmtIsGNURange));
}

// IfStmt
CXIfStmt clang_IfStmt_Create(CXASTContext Ctx, CXSourceLocation_ IL, CXIfStatementKind Kind,
                             CXStmt Init, CXVarDecl Var, CXExpr Cond, CXSourceLocation_ LPL,
                             CXSourceLocation_ RPL, CXStmt Then, CXSourceLocation_ EL,
                             CXStmt Else) {
  return reinterpret_cast<CXIfStmt>(clang::IfStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), clang::SourceLocation::getFromPtrEncoding(IL),
      static_cast<clang::IfStatementKind>(Kind), reinterpret_cast<clang::Stmt *>(Init),
      reinterpret_cast<clang::VarDecl *>(Var), reinterpret_cast<clang::Expr *>(Cond),
      clang::SourceLocation::getFromPtrEncoding(LPL),
      clang::SourceLocation::getFromPtrEncoding(RPL), reinterpret_cast<clang::Stmt *>(Then),
      clang::SourceLocation::getFromPtrEncoding(EL), reinterpret_cast<clang::Stmt *>(Else)));
}

CXIfStmt clang_IfStmt_CreateEmpty(CXASTContext Ctx, bool HasElse, bool HasVar,
                                  bool HasInit) {
  return reinterpret_cast<CXIfStmt>(clang::IfStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx), HasElse, HasVar,
                                    HasInit));
}

void clang_IfStmt_setConditionVariable(CXIfStmt S, CXASTContext Ctx, CXVarDecl V) {
  reinterpret_cast<clang::IfStmt *>(S)->setConditionVariable(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::VarDecl *>(V));
}

// SwitchStmt
CXSwitchStmt clang_SwitchStmt_Create(CXASTContext Ctx, CXStmt Init, CXVarDecl Var,
                                     CXExpr Cond, CXSourceLocation_ LParenLoc,
                                     CXSourceLocation_ RParenLoc) {
  return reinterpret_cast<CXSwitchStmt>(clang::SwitchStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::Stmt *>(Init),
      reinterpret_cast<clang::VarDecl *>(Var), reinterpret_cast<clang::Expr *>(Cond),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

CXSwitchStmt clang_SwitchStmt_CreateEmpty(CXASTContext Ctx, bool HasInit, bool HasVar) {
  return reinterpret_cast<CXSwitchStmt>(clang::SwitchStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx), HasInit,
                                        HasVar));
}

void clang_SwitchStmt_setConditionVariable(CXSwitchStmt S, CXASTContext Ctx, CXVarDecl VD) {
  reinterpret_cast<clang::SwitchStmt *>(S)->setConditionVariable(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::VarDecl *>(VD));
}

void clang_SwitchStmt_addSwitchCase(CXSwitchStmt S, CXSwitchCase SC) {
  reinterpret_cast<clang::SwitchStmt *>(S)->addSwitchCase(reinterpret_cast<clang::SwitchCase *>(SC));
}

// WhileStmt
CXWhileStmt clang_WhileStmt_Create(CXASTContext Ctx, CXVarDecl Var, CXExpr Cond,
                                   CXStmt Body, CXSourceLocation_ WL,
                                   CXSourceLocation_ LParenLoc,
                                   CXSourceLocation_ RParenLoc) {
  return reinterpret_cast<CXWhileStmt>(clang::WhileStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::VarDecl *>(Var),
      reinterpret_cast<clang::Expr *>(Cond), reinterpret_cast<clang::Stmt *>(Body),
      clang::SourceLocation::getFromPtrEncoding(WL),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

CXWhileStmt clang_WhileStmt_CreateEmpty(CXASTContext Ctx, bool HasVar) {
  return reinterpret_cast<CXWhileStmt>(clang::WhileStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx), HasVar));
}

void clang_WhileStmt_setConditionVariable(CXWhileStmt S, CXASTContext Ctx, CXVarDecl V) {
  reinterpret_cast<clang::WhileStmt *>(S)->setConditionVariable(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::VarDecl *>(V));
}

// ForStmt
void clang_ForStmt_setConditionVariable(CXForStmt S, CXASTContext Ctx, CXVarDecl V) {
  reinterpret_cast<clang::ForStmt *>(S)->setConditionVariable(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::VarDecl *>(V));
}

// ReturnStmt
CXReturnStmt clang_ReturnStmt_Create(CXASTContext Ctx, CXSourceLocation_ RL, CXExpr E,
                                     CXVarDecl NRVOCandidate) {
  return reinterpret_cast<CXReturnStmt>(clang::ReturnStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), clang::SourceLocation::getFromPtrEncoding(RL),
      reinterpret_cast<clang::Expr *>(E), reinterpret_cast<clang::VarDecl *>(NRVOCandidate)));
}

CXReturnStmt clang_ReturnStmt_CreateEmpty(CXASTContext Ctx, bool HasNRVOCandidate) {
  return reinterpret_cast<CXReturnStmt>(clang::ReturnStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                        HasNRVOCandidate));
}

// SEHExceptStmt
CXSEHExceptStmt clang_SEHExceptStmt_Create(CXASTContext Ctx, CXSourceLocation_ ExceptLoc,
                                           CXExpr FilterExpr, CXCompoundStmt Block) {
  return reinterpret_cast<CXSEHExceptStmt>(clang::SEHExceptStmt::Create(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                      clang::SourceLocation::getFromPtrEncoding(ExceptLoc),
                                      reinterpret_cast<clang::Expr *>(FilterExpr),
                                      reinterpret_cast<clang::CompoundStmt *>(Block)));
}

// SEHFinallyStmt
CXSEHFinallyStmt clang_SEHFinallyStmt_Create(CXASTContext Ctx, CXSourceLocation_ FinallyLoc,
                                             CXCompoundStmt Block) {
  return reinterpret_cast<CXSEHFinallyStmt>(clang::SEHFinallyStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      clang::SourceLocation::getFromPtrEncoding(FinallyLoc),
      reinterpret_cast<clang::CompoundStmt *>(Block)));
}

// SEHTryStmt
CXSEHTryStmt clang_SEHTryStmt_Create(CXASTContext Ctx, bool IsCXXTry,
                                     CXSourceLocation_ TryLoc, CXCompoundStmt TryBlock,
                                     CXStmt Handler) {
  return reinterpret_cast<CXSEHTryStmt>(clang::SEHTryStmt::Create(*reinterpret_cast<clang::ASTContext *>(Ctx), IsCXXTry,
                                   clang::SourceLocation::getFromPtrEncoding(TryLoc),
                                   reinterpret_cast<clang::CompoundStmt *>(TryBlock),
                                   reinterpret_cast<clang::Stmt *>(Handler)));
}

// CompoundStmt
CXCompoundStmt clang_CompoundStmt_Create(CXASTContext Ctx, const CXStmt *Stmts,
                                         unsigned NumStmts, uint64_t FPFeatures,
                                         CXSourceLocation_ LB, CXSourceLocation_ RB) {
  llvm::SmallVector<clang::Stmt *, 8> Body;
  Body.reserve(NumStmts);
  for (unsigned I = 0; I < NumStmts; ++I)
    Body.push_back(reinterpret_cast<clang::Stmt *>(Stmts[I]));
  return reinterpret_cast<CXCompoundStmt>(clang::CompoundStmt::Create(*reinterpret_cast<clang::ASTContext *>(Ctx), Body,
                                     clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures),
                                     clang::SourceLocation::getFromPtrEncoding(LB),
                                     clang::SourceLocation::getFromPtrEncoding(RB)));
}

// AttributedStmt
CXAttributedStmt clang_AttributedStmt_Create(CXASTContext Ctx, CXSourceLocation_ Loc,
                                             const CXAttr *Attrs, unsigned NumAttrs,
                                             CXStmt SubStmt) {
  llvm::SmallVector<const clang::Attr *, 4> As;
  As.reserve(NumAttrs);
  for (unsigned I = 0; I < NumAttrs; ++I)
    As.push_back(reinterpret_cast<const clang::Attr *>(Attrs[I]));
  return reinterpret_cast<CXAttributedStmt>(clang::AttributedStmt::Create(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                       clang::SourceLocation::getFromPtrEncoding(Loc), As,
                                       reinterpret_cast<clang::Stmt *>(SubStmt)));
}

CXAttributedStmt clang_AttributedStmt_CreateEmpty(CXASTContext Ctx, unsigned NumAttrs) {
  return reinterpret_cast<CXAttributedStmt>(clang::AttributedStmt::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                            NumAttrs));
}

// GCCAsmStmt::AsmStringPiece
unsigned clang_GCCAsmStmt_getNumAsmStringPieces(CXGCCAsmStmt S, CXASTContext Ctx,
                                                unsigned *DiagID, unsigned *DiagOffs) {
  llvm::SmallVector<clang::GCCAsmStmt::AsmStringPiece, 4> Pieces;
  unsigned Offs = 0;
  unsigned Diag = reinterpret_cast<clang::GCCAsmStmt *>(S)->AnalyzeAsmString(
      Pieces, *reinterpret_cast<clang::ASTContext *>(Ctx), Offs);
  if (DiagID)
    *DiagID = Diag;
  if (DiagOffs)
    *DiagOffs = Offs;
  return static_cast<unsigned>(Pieces.size());
}

void clang_GCCAsmStmt_getAsmStringPieces(CXGCCAsmStmt S, CXASTContext Ctx,
                                         CXGCCAsmStmtAsmStringPiece *Buf) {
  llvm::SmallVector<clang::GCCAsmStmt::AsmStringPiece, 4> Pieces;
  unsigned Offs = 0;
  reinterpret_cast<clang::GCCAsmStmt *>(S)->AnalyzeAsmString(
      Pieces, *reinterpret_cast<clang::ASTContext *>(Ctx), Offs);
  for (size_t I = 0; I < Pieces.size(); ++I)
    Buf[I] = reinterpret_cast<CXGCCAsmStmtAsmStringPiece>(new clang::GCCAsmStmt::AsmStringPiece(Pieces[I])); // NOLINT(*-owning-memory)
}

void clang_GCCAsmStmtAsmStringPiece_dispose(CXGCCAsmStmtAsmStringPiece P) {
  delete reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P); // NOLINT(*-owning-memory)
}

bool clang_GCCAsmStmtAsmStringPiece_isString(CXGCCAsmStmtAsmStringPiece P) {
  return reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P)->isString();
}

bool clang_GCCAsmStmtAsmStringPiece_isOperand(CXGCCAsmStmtAsmStringPiece P) {
  return reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P)->isOperand();
}

CXString clang_GCCAsmStmtAsmStringPiece_getString(CXGCCAsmStmtAsmStringPiece P) {
  return extra::makeCXString(
      reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P)->getString());
}

unsigned clang_GCCAsmStmtAsmStringPiece_getOperandNo(CXGCCAsmStmtAsmStringPiece P) {
  return reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P)->getOperandNo();
}

CXSourceRange_ clang_GCCAsmStmtAsmStringPiece_getRange(CXGCCAsmStmtAsmStringPiece P) {
  clang::CharSourceRange R =
      reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P)->getRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

char clang_GCCAsmStmtAsmStringPiece_getModifier(CXGCCAsmStmtAsmStringPiece P) {
  return reinterpret_cast<clang::GCCAsmStmt::AsmStringPiece *>(P)->getModifier();
}

// CompoundStmt
CXStmt clang_CompoundStmt_getBodyStmt(CXCompoundStmt CS, unsigned I) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CompoundStmt *>(CS)->body_begin()[I]);
}

// DeclStmt
CXDecl clang_DeclStmt_getDecl(CXDeclStmt DS, unsigned I) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::DeclStmt *>(DS)->decl_begin()[I]);
}

// Stmt
void clang_Stmt_addStmtClass(CXStmtClass SC) {
  clang::Stmt::addStmtClass(static_cast<clang::Stmt::StmtClass>(SC));
}

unsigned clang_Stmt_getODRHash(CXStmt S) {
  clang::ODRHash Hash;
  llvm::FoldingSetNodeID ID;
  reinterpret_cast<clang::Stmt *>(S)->ProcessODRHash(ID, Hash);
  return ID.ComputeHash();
}

// CapturedStmt::Capture
CXCapturedStmtCapture clang_CapturedStmtCapture_create(CXSourceLocation_ Loc,
                                                       CXVariableCaptureKind Kind,
                                                       CXVarDecl Var) {
  return reinterpret_cast<CXCapturedStmtCapture>(new clang::CapturedStmt::Capture( // NOLINT(*-owning-memory)
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::CapturedStmt::VariableCaptureKind>(Kind),
      reinterpret_cast<clang::VarDecl *>(Var)));
}

void clang_CapturedStmtCapture_dispose(CXCapturedStmtCapture C) {
  delete reinterpret_cast<clang::CapturedStmt::Capture *>(C); // NOLINT(*-owning-memory)
}

// CapturedStmt
CXCapturedStmt clang_CapturedStmt_Create(CXASTContext Ctx, CXStmt S,
                                         CXCapturedRegionKind Kind,
                                         const CXCapturedStmtCapture *Captures,
                                         const CXExpr *CaptureInits, unsigned NumCaptures,
                                         CXCapturedDecl CD, CXRecordDecl RD) {
  llvm::SmallVector<clang::CapturedStmt::Capture, 4> Caps;
  llvm::SmallVector<clang::Expr *, 4> Inits;
  Caps.reserve(NumCaptures);
  Inits.reserve(NumCaptures);
  for (unsigned I = 0; I < NumCaptures; ++I) {
    Caps.push_back(*reinterpret_cast<clang::CapturedStmt::Capture *>(Captures[I]));
    Inits.push_back(reinterpret_cast<clang::Expr *>(CaptureInits[I]));
  }
  return reinterpret_cast<CXCapturedStmt>(clang::CapturedStmt::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::Stmt *>(S),
      static_cast<clang::CapturedRegionKind>(Kind), Caps, Inits,
      reinterpret_cast<clang::CapturedDecl *>(CD), reinterpret_cast<clang::RecordDecl *>(RD)));
}

CXCapturedStmt clang_CapturedStmt_CreateDeserialized(CXASTContext Ctx,
                                                     unsigned NumCaptures) {
  return reinterpret_cast<CXCapturedStmt>(clang::CapturedStmt::CreateDeserialized(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                                 NumCaptures));
}

// GCCAsmStmt
CXGCCAsmStmt clang_GCCAsmStmt_Create(CXASTContext Ctx, CXSourceLocation_ AsmLoc,
                                     bool IsSimple, bool IsVolatile, unsigned NumOutputs,
                                     unsigned NumInputs, const CXIdentifierInfo *Names,
                                     const CXStringLiteral *Constraints,
                                     const CXExpr *Exprs, CXStringLiteral AsmStr,
                                     unsigned NumClobbers, const CXStringLiteral *Clobbers,
                                     unsigned NumLabels, CXSourceLocation_ RParenLoc) {
  const unsigned NumExprs = NumOutputs + NumInputs + NumLabels;
  const unsigned NumConstraints = NumOutputs + NumInputs;
  llvm::SmallVector<clang::IdentifierInfo *, 4> Ns;
  llvm::SmallVector<clang::Expr *, 4> Es;
  llvm::SmallVector<clang::StringLiteral *, 4> Cs;
  llvm::SmallVector<clang::StringLiteral *, 4> Cls;
  Ns.reserve(NumExprs);
  Es.reserve(NumExprs);
  for (unsigned I = 0; I < NumExprs; ++I) {
    Ns.push_back(reinterpret_cast<clang::IdentifierInfo *>(Names[I]));
    Es.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  }
  Cs.reserve(NumConstraints);
  for (unsigned I = 0; I < NumConstraints; ++I)
    Cs.push_back(reinterpret_cast<clang::StringLiteral *>(Constraints[I]));
  Cls.reserve(NumClobbers);
  for (unsigned I = 0; I < NumClobbers; ++I)
    Cls.push_back(reinterpret_cast<clang::StringLiteral *>(Clobbers[I]));
  clang::ASTContext &C = *reinterpret_cast<clang::ASTContext *>(Ctx);
  return reinterpret_cast<CXGCCAsmStmt>(new (C) clang::GCCAsmStmt(
      C, clang::SourceLocation::getFromPtrEncoding(AsmLoc), IsSimple, IsVolatile,
      NumOutputs, NumInputs, Ns.data(), Cs.data(), Es.data(),
      reinterpret_cast<clang::StringLiteral *>(AsmStr), NumClobbers, Cls.data(), NumLabels,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

// MSAsmStmt
CXMSAsmStmt clang_MSAsmStmt_Create(
    CXASTContext Ctx, CXSourceLocation_ AsmLoc, CXSourceLocation_ LBraceLoc, bool IsSimple,
    bool IsVolatile, const CXToken_ *AsmToks, unsigned NumAsmToks, unsigned NumOutputs,
    unsigned NumInputs, const char **Constraints, const CXExpr *Exprs, const char *AsmStr,
    const char **Clobbers, unsigned NumClobbers, CXSourceLocation_ EndLoc) {
  const unsigned NumOperands = NumOutputs + NumInputs;
  llvm::SmallVector<clang::Token, 8> Toks;
  llvm::SmallVector<llvm::StringRef, 4> Cs;
  llvm::SmallVector<clang::Expr *, 4> Es;
  llvm::SmallVector<llvm::StringRef, 4> Cls;
  Toks.reserve(NumAsmToks);
  for (unsigned I = 0; I < NumAsmToks; ++I)
    Toks.push_back(*reinterpret_cast<clang::Token *>(AsmToks[I]));
  Cs.reserve(NumOperands);
  Es.reserve(NumOperands);
  for (unsigned I = 0; I < NumOperands; ++I) {
    Cs.emplace_back(Constraints[I]);
    Es.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  }
  Cls.reserve(NumClobbers);
  for (unsigned I = 0; I < NumClobbers; ++I)
    Cls.emplace_back(Clobbers[I]);
  clang::ASTContext &C = *reinterpret_cast<clang::ASTContext *>(Ctx);
  return reinterpret_cast<CXMSAsmStmt>(new (C) clang::MSAsmStmt(C, clang::SourceLocation::getFromPtrEncoding(AsmLoc),
                                  clang::SourceLocation::getFromPtrEncoding(LBraceLoc),
                                  IsSimple, IsVolatile, Toks, NumOutputs, NumInputs, Cs, Es,
                                  llvm::StringRef(AsmStr), Cls,
                                  clang::SourceLocation::getFromPtrEncoding(EndLoc)));
}
