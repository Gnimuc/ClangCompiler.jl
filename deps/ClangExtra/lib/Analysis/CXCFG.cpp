#include "clang-ex/Analysis/CXCFG.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Decl.h"
#include "clang/Analysis/CFG.h"
#include "llvm/Support/raw_ostream.h"

// CFGBlock

size_t clang_CFGBlock_getIndexInCFG(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->getIndexInCFG();
}

// front
// back
// begin / end / rbegin / rend / ref_begin / ref_end / rref_begin / rref_end /
// refs / rrefs

unsigned clang_CFGBlock_size(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->size();
}

// empty

CXCFGElementKind clang_CFGBlock_getElementKind(CXCFGBlock B, unsigned I) {
  return static_cast<CXCFGElementKind>(
      (*static_cast<clang::CFGBlock *>(B))[I].getKind());
}

CXStmt clang_CFGBlock_getElementStmt(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGStmt> CS = E.getAs<clang::CFGStmt>())
    return const_cast<clang::Stmt *>(CS->getStmt());
  return nullptr;
}

CXCXXCtorInitializer clang_CFGBlock_getElementInitializer(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGInitializer> CI = E.getAs<clang::CFGInitializer>())
    return CI->getInitializer();
  return nullptr;
}

CXVarDecl clang_CFGBlock_getElementVarDecl(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGScopeBegin> SB = E.getAs<clang::CFGScopeBegin>())
    return const_cast<clang::VarDecl *>(SB->getVarDecl());
  if (std::optional<clang::CFGScopeEnd> SE = E.getAs<clang::CFGScopeEnd>())
    return const_cast<clang::VarDecl *>(SE->getVarDecl());
  if (std::optional<clang::CFGLifetimeEnds> LE = E.getAs<clang::CFGLifetimeEnds>())
    return const_cast<clang::VarDecl *>(LE->getVarDecl());
  if (std::optional<clang::CFGAutomaticObjDtor> AD =
          E.getAs<clang::CFGAutomaticObjDtor>())
    return const_cast<clang::VarDecl *>(AD->getVarDecl());
  if (std::optional<clang::CFGCleanupFunction> CF =
          E.getAs<clang::CFGCleanupFunction>())
    return const_cast<clang::VarDecl *>(CF->getVarDecl());
  return nullptr;
}

CXStmt clang_CFGBlock_getElementTriggerStmt(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGScopeBegin> SB = E.getAs<clang::CFGScopeBegin>())
    return const_cast<clang::Stmt *>(SB->getTriggerStmt());
  if (std::optional<clang::CFGScopeEnd> SE = E.getAs<clang::CFGScopeEnd>())
    return const_cast<clang::Stmt *>(SE->getTriggerStmt());
  if (std::optional<clang::CFGLifetimeEnds> LE = E.getAs<clang::CFGLifetimeEnds>())
    return const_cast<clang::Stmt *>(LE->getTriggerStmt());
  if (std::optional<clang::CFGAutomaticObjDtor> AD =
          E.getAs<clang::CFGAutomaticObjDtor>())
    return const_cast<clang::Stmt *>(AD->getTriggerStmt());
  return nullptr;
}

CXStmt clang_CFGBlock_getElementLoopStmt(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGLoopExit> LE = E.getAs<clang::CFGLoopExit>())
    return const_cast<clang::Stmt *>(LE->getLoopStmt());
  return nullptr;
}

CXCXXBindTemporaryExpr clang_CFGBlock_getElementBindTemporaryExpr(CXCFGBlock B,
                                                                  unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGTemporaryDtor> TD = E.getAs<clang::CFGTemporaryDtor>())
    return const_cast<clang::CXXBindTemporaryExpr *>(TD->getBindTemporaryExpr());
  return nullptr;
}

CXCXXBaseSpecifier clang_CFGBlock_getElementBaseSpecifier(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGBaseDtor> BD = E.getAs<clang::CFGBaseDtor>())
    return const_cast<clang::CXXBaseSpecifier *>(BD->getBaseSpecifier());
  return nullptr;
}

CXFieldDecl clang_CFGBlock_getElementFieldDecl(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGMemberDtor> MD = E.getAs<clang::CFGMemberDtor>())
    return const_cast<clang::FieldDecl *>(MD->getFieldDecl());
  return nullptr;
}

CXCXXNewExpr clang_CFGBlock_getElementAllocatorExpr(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*static_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGNewAllocator> NA = E.getAs<clang::CFGNewAllocator>())
    return const_cast<clang::CXXNewExpr *>(NA->getAllocatorExpr());
  return nullptr;
}

CXString clang_CFGBlock_printElementAsString(CXCFGBlock B, unsigned I) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  (*static_cast<clang::CFGBlock *>(B))[I].dumpToStream(OS);
  return extra::makeCXString(OS.str());
}

// pred_begin / pred_end / pred_rbegin / pred_rend / preds
// succ_begin / succ_end / succ_rbegin / succ_rend / succs

unsigned clang_CFGBlock_succ_size(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->succ_size();
}

// succ_empty

CXCFGBlock clang_CFGBlock_getSucc(CXCFGBlock B, unsigned I) {
  return (static_cast<clang::CFGBlock *>(B)->succ_begin() + I)->getReachableBlock();
}

bool clang_CFGBlock_isSuccReachable(CXCFGBlock B, unsigned I) {
  return (static_cast<clang::CFGBlock *>(B)->succ_begin() + I)->isReachable();
}

CXCFGBlock clang_CFGBlock_getSuccPossiblyUnreachableBlock(CXCFGBlock B, unsigned I) {
  return (static_cast<clang::CFGBlock *>(B)->succ_begin() + I)
      ->getPossiblyUnreachableBlock();
}

unsigned clang_CFGBlock_pred_size(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->pred_size();
}

// pred_empty

CXCFGBlock clang_CFGBlock_getPred(CXCFGBlock B, unsigned I) {
  return (static_cast<clang::CFGBlock *>(B)->pred_begin() + I)->getReachableBlock();
}

// FilterEdge / filtered_pred_start_end / filtered_succ_start_end
// setTerminator / setLabel / setLoopTarget / setHasNoReturnElement

bool clang_CFGBlock_isInevitablySinking(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->isInevitablySinking();
}

bool clang_CFGBlock_hasTerminator(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->getTerminator().isValid();
}

CXCFGTerminatorKind clang_CFGBlock_getTerminatorKind(CXCFGBlock B) {
  return static_cast<CXCFGTerminatorKind>(
      static_cast<clang::CFGBlock *>(B)->getTerminator().getKind());
}

CXStmt clang_CFGBlock_getTerminatorStmt(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->getTerminatorStmt();
}

CXExpr clang_CFGBlock_getLastCondition(CXCFGBlock B) {
  return const_cast<clang::Expr *>(
      static_cast<clang::CFGBlock *>(B)->getLastCondition());
}

CXStmt clang_CFGBlock_getTerminatorCondition(CXCFGBlock B, bool StripParens) {
  return static_cast<clang::CFGBlock *>(B)->getTerminatorCondition(StripParens);
}

CXStmt clang_CFGBlock_getLoopTarget(CXCFGBlock B) {
  return const_cast<clang::Stmt *>(static_cast<clang::CFGBlock *>(B)->getLoopTarget());
}

CXStmt clang_CFGBlock_getLabel(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->getLabel();
}

bool clang_CFGBlock_hasNoReturnElement(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->hasNoReturnElement();
}

unsigned clang_CFGBlock_getBlockID(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->getBlockID();
}

CXCFG clang_CFGBlock_getParent(CXCFGBlock B) {
  return static_cast<clang::CFGBlock *>(B)->getParent();
}

// dump

CXString clang_CFGBlock_printAsString(CXCFGBlock B, CXCFG G, CXASTContext Ctx) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::CFGBlock *>(B)->print(
      OS, static_cast<clang::CFG *>(G),
      static_cast<clang::ASTContext *>(Ctx)->getLangOpts(), /*ShowColors=*/false);
  return extra::makeCXString(OS.str());
}

// printTerminator / printTerminatorJson / printAsOperand
// addSuccessor / appendStmt / appendConstructor / appendCXXRecordTypedCall /
// appendInitializer / appendNewAllocator / appendScopeBegin / appendScopeEnd /
// appendBaseDtor / appendMemberDtor / appendTemporaryDtor /
// appendAutomaticObjDtor / appendCleanupFunction / appendLifetimeEnds /
// appendLoopExit / appendDeleteDtor

// CFG

CXCFG clang_CFG_buildCFG(CXDecl D, CXStmt S, CXASTContext Ctx, bool AddInitializers,
                         bool AddImplicitDtors, bool AddLifetime, bool AddLoopExit,
                         bool AddTemporaryDtors, bool AddScopes,
                         bool AddCXXNewAllocator) {
  clang::CFG::BuildOptions BO;
  BO.AddInitializers = AddInitializers;
  BO.AddImplicitDtors = AddImplicitDtors;
  BO.AddLifetime = AddLifetime;
  BO.AddLoopExit = AddLoopExit;
  BO.AddTemporaryDtors = AddTemporaryDtors;
  BO.AddScopes = AddScopes;
  BO.AddCXXNewAllocator = AddCXXNewAllocator;
  return clang::CFG::buildCFG(static_cast<clang::Decl *>(D),
                              static_cast<clang::Stmt *>(S),
                              static_cast<clang::ASTContext *>(Ctx), BO)
      .release();
}

void clang_CFG_dispose(CXCFG G) { delete static_cast<clang::CFG *>(G); }

// createBlock
// setEntry
// setIndirectGotoBlock
// front / back
// begin / end / rbegin / rend / nodes / const_nodes / reverse_nodes /
// const_reverse_nodes / nodes_begin / nodes_end

unsigned clang_CFG_getNumBlocks(CXCFG G) {
  clang::CFG *C = static_cast<clang::CFG *>(G);
  return static_cast<unsigned>(C->end() - C->begin());
}

CXCFGBlock clang_CFG_getBlock(CXCFG G, unsigned I) {
  return *(static_cast<clang::CFG *>(G)->begin() + I);
}

CXCFGBlock clang_CFG_getEntry(CXCFG G) {
  return &static_cast<clang::CFG *>(G)->getEntry();
}

CXCFGBlock clang_CFG_getExit(CXCFG G) {
  return &static_cast<clang::CFG *>(G)->getExit();
}

CXCFGBlock clang_CFG_getIndirectGotoBlock(CXCFG G) {
  return static_cast<clang::CFG *>(G)->getIndirectGotoBlock();
}

// try_blocks / try_blocks_begin / try_blocks_end / addTryDispatchBlock
// addSyntheticDeclStmt / synthetic_stmts / synthetic_stmt_begin /
// synthetic_stmt_end
// VisitBlockStmts (template callback — MARSHALLING.md §10)

unsigned clang_CFG_getNumBlockIDs(CXCFG G) {
  return static_cast<clang::CFG *>(G)->getNumBlockIDs();
}

// size (a pure renaming of getNumBlockIDs)

bool clang_CFG_isLinear(CXCFG G) {
  return static_cast<clang::CFG *>(G)->isLinear();
}

// viewCFG

CXString clang_CFG_printAsString(CXCFG G, CXASTContext Ctx) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::CFG *>(G)->print(
      OS, static_cast<clang::ASTContext *>(Ctx)->getLangOpts(),
      /*ShowColors=*/false);
  return extra::makeCXString(OS.str());
}

// dump
// getAllocator
// getBumpVectorContext
