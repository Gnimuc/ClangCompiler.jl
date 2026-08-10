#include "clang-ex/Analysis/CXAnalysisDeclContext.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/ParentMap.h"
#include "clang/AST/Stmt.h"
#include "clang/Analysis/AnalysisDeclContext.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/CFGStmtMap.h"
#include "clang/Analysis/Analyses/CFGReachabilityAnalysis.h"
#include <iterator>
#include <memory>
#include <string>

// AnalysisDeclContext

CXAnalysisDeclContext clang_AnalysisDeclContext_create(CXAnalysisDeclContextManager Mgr,
                                                       CXDecl D) {
  return reinterpret_cast<CXAnalysisDeclContext>(
      std::make_unique<clang::AnalysisDeclContext>(
          reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr),
          reinterpret_cast<clang::Decl *>(D))
          .release());
}

CXAnalysisDeclContext clang_AnalysisDeclContext_createWithOptions(
    CXAnalysisDeclContextManager Mgr, CXDecl D, CXCFGBuildOptions BuildOptions) {
  return reinterpret_cast<CXAnalysisDeclContext>(
      std::make_unique<clang::AnalysisDeclContext>(
          reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr),
          reinterpret_cast<clang::Decl *>(D),
          *reinterpret_cast<clang::CFG::BuildOptions *>(BuildOptions))
          .release());
}

void clang_AnalysisDeclContext_dispose(CXAnalysisDeclContext ADC) {
  delete reinterpret_cast<clang::AnalysisDeclContext *>(ADC);
}

CXASTContext clang_AnalysisDeclContext_getASTContext(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXASTContext>(
      &reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getASTContext());
}

CXDecl clang_AnalysisDeclContext_getDecl(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXDecl>(const_cast<clang::Decl *>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getDecl()));
}

CXAnalysisDeclContextManager clang_AnalysisDeclContext_getManager(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXAnalysisDeclContextManager>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getManager());
}

CXCFGBuildOptions clang_AnalysisDeclContext_getCFGBuildOptions(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXCFGBuildOptions>(
      &reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getCFGBuildOptions());
}

bool clang_AnalysisDeclContext_getAddEHEdges(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getAddEHEdges();
}

bool clang_AnalysisDeclContext_getUseUnoptimizedCFG(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getUseUnoptimizedCFG();
}

bool clang_AnalysisDeclContext_getAddImplicitDtors(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getAddImplicitDtors();
}

bool clang_AnalysisDeclContext_getAddInitializers(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getAddInitializers();
}

void clang_AnalysisDeclContext_registerForcedBlockExpression(CXAnalysisDeclContext ADC,
                                                             CXStmt S) {
  reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->registerForcedBlockExpression(
      reinterpret_cast<clang::Stmt *>(S));
}

// getBlockForRegisteredExpression

CXStmt clang_AnalysisDeclContext_getBody(CXAnalysisDeclContext ADC,
                                         bool *IsAutosynthesized) {
  clang::AnalysisDeclContext *C = reinterpret_cast<clang::AnalysisDeclContext *>(ADC);
  if (!IsAutosynthesized)
    return reinterpret_cast<CXStmt>(C->getBody());
  bool Synthesized = false;
  clang::Stmt *Body = C->getBody(Synthesized);
  *IsAutosynthesized = Synthesized;
  return reinterpret_cast<CXStmt>(Body);
}

bool clang_AnalysisDeclContext_isBodyAutosynthesized(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->isBodyAutosynthesized();
}

bool clang_AnalysisDeclContext_isBodyAutosynthesizedFromModelFile(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)
      ->isBodyAutosynthesizedFromModelFile();
}

CXCFG clang_AnalysisDeclContext_getCFG(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXCFG>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getCFG());
}

CXCFGStmtMap clang_AnalysisDeclContext_getCFGStmtMap(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXCFGStmtMap>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getCFGStmtMap());
}

CXCFGReverseBlockReachabilityAnalysis
clang_AnalysisDeclContext_getCFGReachablityAnalysis(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXCFGReverseBlockReachabilityAnalysis>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getCFGReachablityAnalysis());
}

CXCFG clang_AnalysisDeclContext_getUnoptimizedCFG(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXCFG>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getUnoptimizedCFG());
}

void clang_AnalysisDeclContext_dumpCFG(CXAnalysisDeclContext ADC, bool ShowColors) {
  reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->dumpCFG(ShowColors);
}

bool clang_AnalysisDeclContext_isCFGBuilt(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->isCFGBuilt();
}

CXParentMap clang_AnalysisDeclContext_getParentMap(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXParentMap>(
      &reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getParentMap());
}

unsigned clang_AnalysisDeclContext_getNumReferencedBlockVars(CXAnalysisDeclContext ADC,
                                                             CXBlockDecl BD) {
  auto Vars = reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getReferencedBlockVars(
      reinterpret_cast<clang::BlockDecl *>(BD));
  return static_cast<unsigned>(std::distance(Vars.begin(), Vars.end()));
}

void clang_AnalysisDeclContext_getReferencedBlockVars(CXAnalysisDeclContext ADC,
                                                      CXBlockDecl BD, CXVarDecl *Buf,
                                                      unsigned N) {
  auto Vars = reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getReferencedBlockVars(
      reinterpret_cast<clang::BlockDecl *>(BD));
  unsigned I = 0;
  for (const clang::VarDecl *VD : Vars) {
    if (I >= N)
      break;
    Buf[I++] = reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(VD));
  }
}

CXImplicitParamDecl clang_AnalysisDeclContext_getSelfDecl(CXAnalysisDeclContext ADC) {
  return reinterpret_cast<CXImplicitParamDecl>(const_cast<clang::ImplicitParamDecl *>(
      reinterpret_cast<clang::AnalysisDeclContext *>(ADC)->getSelfDecl()));
}

// getStackFrame / getBlockInvocationContext / getAnalysis<T>

bool clang_AnalysisDeclContext_isInStdNamespace(CXDecl D) {
  return clang::AnalysisDeclContext::isInStdNamespace(reinterpret_cast<clang::Decl *>(D));
}

CXString clang_AnalysisDeclContext_getFunctionName(CXDecl D) {
  return extra::makeCXString(
      clang::AnalysisDeclContext::getFunctionName(reinterpret_cast<clang::Decl *>(D)));
}

// AnalysisDeclContextManager

CXAnalysisDeclContextManager clang_AnalysisDeclContextManager_create(CXASTContext ASTCtx,
                                                                     bool SynthesizeBodies) {
  // Only the eight leading constructor arguments have to be spelled out to reach
  // synthesizeBodies; each is passed clang's own default, as are the five that follow it.
  return reinterpret_cast<CXAnalysisDeclContextManager>(
      std::make_unique<clang::AnalysisDeclContextManager>(
          *reinterpret_cast<clang::ASTContext *>(ASTCtx),
          /*useUnoptimizedCFG=*/false, /*addImplicitDtors=*/false,
          /*addInitializers=*/false, /*addTemporaryDtors=*/false, /*addLifetime=*/false,
          /*addLoopExit=*/false, /*addScopes=*/false, SynthesizeBodies)
          .release());
}

void clang_AnalysisDeclContextManager_dispose(CXAnalysisDeclContextManager Mgr) {
  delete reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr);
}

CXAnalysisDeclContext clang_AnalysisDeclContextManager_getContext(
    CXAnalysisDeclContextManager Mgr, CXDecl D) {
  return reinterpret_cast<CXAnalysisDeclContext>(
      reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr)->getContext(
          reinterpret_cast<clang::Decl *>(D)));
}

bool clang_AnalysisDeclContextManager_getUseUnoptimizedCFG(CXAnalysisDeclContextManager Mgr) {
  return reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr)->getUseUnoptimizedCFG();
}

CXCFGBuildOptions clang_AnalysisDeclContextManager_getCFGBuildOptions(
    CXAnalysisDeclContextManager Mgr) {
  return reinterpret_cast<CXCFGBuildOptions>(
      &reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr)->getCFGBuildOptions());
}

bool clang_AnalysisDeclContextManager_synthesizeBodies(CXAnalysisDeclContextManager Mgr) {
  return reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr)->synthesizeBodies();
}

// getStackFrame / getBodyFarm

void clang_AnalysisDeclContextManager_clear(CXAnalysisDeclContextManager Mgr) {
  reinterpret_cast<clang::AnalysisDeclContextManager *>(Mgr)->clear();
}

// CFGStmtMap
// Build / ~CFGStmtMap

CXCFGBlock clang_CFGStmtMap_getBlock(CXCFGStmtMap M, CXStmt S) {
  return reinterpret_cast<CXCFGBlock>(
      reinterpret_cast<clang::CFGStmtMap *>(M)->getBlock(reinterpret_cast<clang::Stmt *>(S)));
}

// ParentMap

CXStmt clang_ParentMap_getParent(CXParentMap PM, CXStmt S) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::ParentMap *>(PM)->getParent(
      reinterpret_cast<clang::Stmt *>(S)));
}

// addStmt / setParent

CXStmt clang_ParentMap_getParentIgnoreParens(CXParentMap PM, CXStmt S) {
  return reinterpret_cast<CXStmt>(
      reinterpret_cast<clang::ParentMap *>(PM)->getParentIgnoreParens(
          reinterpret_cast<clang::Stmt *>(S)));
}

CXStmt clang_ParentMap_getParentIgnoreParenCasts(CXParentMap PM, CXStmt S) {
  return reinterpret_cast<CXStmt>(
      reinterpret_cast<clang::ParentMap *>(PM)->getParentIgnoreParenCasts(
          reinterpret_cast<clang::Stmt *>(S)));
}

CXStmt clang_ParentMap_getParentIgnoreParenImpCasts(CXParentMap PM, CXStmt S) {
  return reinterpret_cast<CXStmt>(
      reinterpret_cast<clang::ParentMap *>(PM)->getParentIgnoreParenImpCasts(
          reinterpret_cast<clang::Stmt *>(S)));
}

CXStmt clang_ParentMap_getOuterParenParent(CXParentMap PM, CXStmt S) {
  return reinterpret_cast<CXStmt>(
      reinterpret_cast<clang::ParentMap *>(PM)->getOuterParenParent(
          reinterpret_cast<clang::Stmt *>(S)));
}

bool clang_ParentMap_hasParent(CXParentMap PM, CXStmt S) {
  return reinterpret_cast<clang::ParentMap *>(PM)->hasParent(
      reinterpret_cast<clang::Stmt *>(S));
}

bool clang_ParentMap_isConsumedExpr(CXParentMap PM, CXExpr E) {
  return reinterpret_cast<clang::ParentMap *>(PM)->isConsumedExpr(
      reinterpret_cast<clang::Expr *>(E));
}
