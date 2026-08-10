#include "clang-ex/Analysis/CXLiveVariables.h"
#include "clang/AST/Decl.h"
#include "clang/AST/Expr.h"
#include "clang/AST/Stmt.h"
#include "clang/Analysis/AnalysisDeclContext.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/Analyses/LiveVariables.h"
#include "clang/Basic/SourceManager.h"
#include <memory>

// LiveVariables

CXLiveVariables clang_LiveVariables_computeLiveness(CXAnalysisDeclContext ADC,
                                                    bool killAtAssign) {
  return reinterpret_cast<CXLiveVariables>(
      clang::LiveVariables::computeLiveness(
          *reinterpret_cast<clang::AnalysisDeclContext *>(ADC), killAtAssign)
          .release());
}

void clang_LiveVariables_dispose(CXLiveVariables LV) {
  delete reinterpret_cast<clang::LiveVariables *>(LV);
}

bool clang_LiveVariables_isLive(CXLiveVariables LV, CXCFGBlock B, CXVarDecl D) {
  return reinterpret_cast<clang::LiveVariables *>(LV)->isLive(
      reinterpret_cast<clang::CFGBlock *>(B), reinterpret_cast<clang::VarDecl *>(D));
}

bool clang_LiveVariables_isLiveAtStmt(CXLiveVariables LV, CXStmt S, CXVarDecl D) {
  return reinterpret_cast<clang::LiveVariables *>(LV)->isLive(
      reinterpret_cast<clang::Stmt *>(S), reinterpret_cast<clang::VarDecl *>(D));
}

bool clang_LiveVariables_isExprLiveAtStmt(CXLiveVariables LV, CXStmt Loc, CXExpr Val) {
  return reinterpret_cast<clang::LiveVariables *>(LV)->isLive(
      reinterpret_cast<clang::Stmt *>(Loc), reinterpret_cast<clang::Expr *>(Val));
}

void clang_LiveVariables_dumpBlockLiveness(CXLiveVariables LV, CXSourceManager M) {
  reinterpret_cast<clang::LiveVariables *>(LV)->dumpBlockLiveness(
      *reinterpret_cast<clang::SourceManager *>(M));
}

void clang_LiveVariables_dumpExprLiveness(CXLiveVariables LV, CXSourceManager M) {
  reinterpret_cast<clang::LiveVariables *>(LV)->dumpExprLiveness(
      *reinterpret_cast<clang::SourceManager *>(M));
}

// runOnAllBlocks / create / getTag
