#include "clang-ex/Analysis/Analyses/CXExprMutationAnalyzer.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Decl.h"
#include "clang/AST/Expr.h"
#include "clang/AST/Stmt.h"
#include "clang/Analysis/Analyses/ExprMutationAnalyzer.h"
#include <memory>

// ExprMutationAnalyzer

CXExprMutationAnalyzer clang_ExprMutationAnalyzer_create(CXStmt Stm,
                                                         CXASTContext Context) {
  return reinterpret_cast<CXExprMutationAnalyzer>(
      std::make_unique<clang::ExprMutationAnalyzer>(
          *reinterpret_cast<clang::Stmt *>(Stm),
          *reinterpret_cast<clang::ASTContext *>(Context))
          .release());
}

void clang_ExprMutationAnalyzer_dispose(CXExprMutationAnalyzer EMA) {
  delete reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA);
}

bool clang_ExprMutationAnalyzer_isMutated(CXExprMutationAnalyzer EMA, CXExpr Exp) {
  return reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)->isMutated(
      reinterpret_cast<clang::Expr *>(Exp));
}

bool clang_ExprMutationAnalyzer_isMutatedFromDecl(CXExprMutationAnalyzer EMA, CXDecl Dec) {
  return reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)->isMutated(
      reinterpret_cast<clang::Decl *>(Dec));
}

CXStmt clang_ExprMutationAnalyzer_findMutation(CXExprMutationAnalyzer EMA, CXExpr Exp) {
  return reinterpret_cast<CXStmt>(
      const_cast<clang::Stmt *>(reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)
                                    ->findMutation(reinterpret_cast<clang::Expr *>(Exp))));
}

CXStmt clang_ExprMutationAnalyzer_findMutationFromDecl(CXExprMutationAnalyzer EMA,
                                                       CXDecl Dec) {
  return reinterpret_cast<CXStmt>(
      const_cast<clang::Stmt *>(reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)
                                    ->findMutation(reinterpret_cast<clang::Decl *>(Dec))));
}

bool clang_ExprMutationAnalyzer_isPointeeMutated(CXExprMutationAnalyzer EMA, CXExpr Exp) {
  return reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)->isPointeeMutated(
      reinterpret_cast<clang::Expr *>(Exp));
}

bool clang_ExprMutationAnalyzer_isPointeeMutatedFromDecl(CXExprMutationAnalyzer EMA,
                                                         CXDecl Dec) {
  return reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)->isPointeeMutated(
      reinterpret_cast<clang::Decl *>(Dec));
}

CXStmt clang_ExprMutationAnalyzer_findPointeeMutation(CXExprMutationAnalyzer EMA,
                                                      CXExpr Exp) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(
      reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)->findPointeeMutation(
          reinterpret_cast<clang::Expr *>(Exp))));
}

CXStmt clang_ExprMutationAnalyzer_findPointeeMutationFromDecl(CXExprMutationAnalyzer EMA,
                                                              CXDecl Dec) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(
      reinterpret_cast<clang::ExprMutationAnalyzer *>(EMA)->findPointeeMutation(
          reinterpret_cast<clang::Decl *>(Dec))));
}

bool clang_ExprMutationAnalyzer_isUnevaluated(CXStmt Smt, CXStmt Stm,
                                              CXASTContext Context) {
  (void)Stm;
  return clang::ExprMutationAnalyzer::isUnevaluated(
      reinterpret_cast<clang::Stmt *>(Smt),
      *reinterpret_cast<clang::ASTContext *>(Context));
}

// FunctionParmMutationAnalyzer. The C++ constructor is private and needs a
// Memoized cache the analyzer stores itself in; the box owns that cache.
namespace {
struct FunctionParmMutationAnalyzerBox {
  clang::ExprMutationAnalyzer::Memoized Memorized;
  clang::FunctionParmMutationAnalyzer *Analyzer;

  FunctionParmMutationAnalyzerBox(const clang::FunctionDecl &Func,
                                  clang::ASTContext &Context)
      : Analyzer(clang::FunctionParmMutationAnalyzer::getFunctionParmMutationAnalyzer(
            Func, Context, Memorized)) {}
};
} // namespace

CXFunctionParmMutationAnalyzer
clang_FunctionParmMutationAnalyzer_create(CXFunctionDecl Func, CXASTContext Context) {
  return reinterpret_cast<CXFunctionParmMutationAnalyzer>(
      std::make_unique<FunctionParmMutationAnalyzerBox>(
          *reinterpret_cast<clang::FunctionDecl *>(Func),
          *reinterpret_cast<clang::ASTContext *>(Context))
          .release());
}

void clang_FunctionParmMutationAnalyzer_dispose(CXFunctionParmMutationAnalyzer FPMA) {
  delete reinterpret_cast<FunctionParmMutationAnalyzerBox *>(FPMA);
}

bool clang_FunctionParmMutationAnalyzer_isMutated(CXFunctionParmMutationAnalyzer FPMA,
                                                  CXParmVarDecl Parm) {
  return reinterpret_cast<FunctionParmMutationAnalyzerBox *>(FPMA)->Analyzer->isMutated(
      reinterpret_cast<clang::ParmVarDecl *>(Parm));
}

CXStmt clang_FunctionParmMutationAnalyzer_findMutation(CXFunctionParmMutationAnalyzer FPMA,
                                                       CXParmVarDecl Parm) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(
      reinterpret_cast<FunctionParmMutationAnalyzerBox *>(FPMA)->Analyzer->findMutation(
          reinterpret_cast<clang::ParmVarDecl *>(Parm))));
}
