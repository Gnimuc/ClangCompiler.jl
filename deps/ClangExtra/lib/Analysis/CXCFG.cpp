#include "clang-ex/Analysis/CXCFG.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Attr.h"
#include "clang/AST/Decl.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/ConstructionContext.h"
#include "llvm/Support/raw_ostream.h"
#include <iterator>
#include <memory>

// CFGCXXRecordTypedCall

bool clang_CFGCXXRecordTypedCall_isCXXRecordTypedCall(CXExpr E) {
  return clang::CFGCXXRecordTypedCall::isCXXRecordTypedCall(reinterpret_cast<clang::Expr *>(E));
}

// CFGBlock

size_t clang_CFGBlock_getIndexInCFG(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->getIndexInCFG();
}

// front
// back
// begin / end / rbegin / rend / ref_begin / ref_end / rref_begin / rref_end /
// refs / rrefs

unsigned clang_CFGBlock_size(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->size();
}


bool clang_CFGBlock_empty(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->empty();
}

CXCFGElementKind clang_CFGBlock_getElementKind(CXCFGBlock B, unsigned I) {
  return static_cast<CXCFGElementKind>(
      (*reinterpret_cast<clang::CFGBlock *>(B))[I].getKind());
}

CXStmt clang_CFGBlock_getElementStmt(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGStmt> CS = E.getAs<clang::CFGStmt>())
    return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(CS->getStmt()));
  return nullptr;
}

CXConstructionContext clang_CFGBlock_getElementConstructionContext(CXCFGBlock B,
                                                                   unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGConstructor> CE = E.getAs<clang::CFGConstructor>())
    return reinterpret_cast<CXConstructionContext>(const_cast<clang::ConstructionContext *>(CE->getConstructionContext()));
  if (std::optional<clang::CFGCXXRecordTypedCall> RC =
          E.getAs<clang::CFGCXXRecordTypedCall>())
    return reinterpret_cast<CXConstructionContext>(const_cast<clang::ConstructionContext *>(RC->getConstructionContext()));
  return nullptr;
}

CXCXXCtorInitializer clang_CFGBlock_getElementInitializer(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGInitializer> CI = E.getAs<clang::CFGInitializer>())
    return reinterpret_cast<CXCXXCtorInitializer>(CI->getInitializer());
  return nullptr;
}

CXVarDecl clang_CFGBlock_getElementVarDecl(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGScopeBegin> SB = E.getAs<clang::CFGScopeBegin>())
    return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(SB->getVarDecl()));
  if (std::optional<clang::CFGScopeEnd> SE = E.getAs<clang::CFGScopeEnd>())
    return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(SE->getVarDecl()));
  if (std::optional<clang::CFGLifetimeEnds> LE = E.getAs<clang::CFGLifetimeEnds>())
    return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(LE->getVarDecl()));
  if (std::optional<clang::CFGAutomaticObjDtor> AD =
          E.getAs<clang::CFGAutomaticObjDtor>())
    return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(AD->getVarDecl()));
  if (std::optional<clang::CFGCleanupFunction> CF =
          E.getAs<clang::CFGCleanupFunction>())
    return reinterpret_cast<CXVarDecl>(const_cast<clang::VarDecl *>(CF->getVarDecl()));
  return nullptr;
}

CXStmt clang_CFGBlock_getElementTriggerStmt(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGScopeBegin> SB = E.getAs<clang::CFGScopeBegin>())
    return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(SB->getTriggerStmt()));
  if (std::optional<clang::CFGScopeEnd> SE = E.getAs<clang::CFGScopeEnd>())
    return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(SE->getTriggerStmt()));
  if (std::optional<clang::CFGLifetimeEnds> LE = E.getAs<clang::CFGLifetimeEnds>())
    return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(LE->getTriggerStmt()));
  if (std::optional<clang::CFGAutomaticObjDtor> AD =
          E.getAs<clang::CFGAutomaticObjDtor>())
    return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(AD->getTriggerStmt()));
  return nullptr;
}

CXStmt clang_CFGBlock_getElementLoopStmt(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGLoopExit> LE = E.getAs<clang::CFGLoopExit>())
    return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(LE->getLoopStmt()));
  return nullptr;
}

CXCXXBindTemporaryExpr clang_CFGBlock_getElementBindTemporaryExpr(CXCFGBlock B,
                                                                  unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGTemporaryDtor> TD = E.getAs<clang::CFGTemporaryDtor>())
    return reinterpret_cast<CXCXXBindTemporaryExpr>(const_cast<clang::CXXBindTemporaryExpr *>(TD->getBindTemporaryExpr()));
  return nullptr;
}

CXCXXBaseSpecifier clang_CFGBlock_getElementBaseSpecifier(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGBaseDtor> BD = E.getAs<clang::CFGBaseDtor>())
    return reinterpret_cast<CXCXXBaseSpecifier>(const_cast<clang::CXXBaseSpecifier *>(BD->getBaseSpecifier()));
  return nullptr;
}

CXFieldDecl clang_CFGBlock_getElementFieldDecl(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGMemberDtor> MD = E.getAs<clang::CFGMemberDtor>())
    return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(MD->getFieldDecl()));
  return nullptr;
}

CXCXXNewExpr clang_CFGBlock_getElementAllocatorExpr(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGNewAllocator> NA = E.getAs<clang::CFGNewAllocator>())
    return reinterpret_cast<CXCXXNewExpr>(const_cast<clang::CXXNewExpr *>(NA->getAllocatorExpr()));
  return nullptr;
}

CXString clang_CFGBlock_printElementAsString(CXCFGBlock B, unsigned I) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  (*reinterpret_cast<clang::CFGBlock *>(B))[I].dumpToStream(OS);
  return extra::makeCXString(OS.str());
}

void clang_CFGBlock_dumpElement(CXCFGBlock B, unsigned I) {
  (*reinterpret_cast<clang::CFGBlock *>(B))[I].dump();
}

// pred_begin / pred_end / pred_rbegin / pred_rend / preds
// succ_begin / succ_end / succ_rbegin / succ_rend / succs

CXCXXDeleteExpr clang_CFGBlock_getElementDeleteExpr(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGDeleteDtor> DD = E.getAs<clang::CFGDeleteDtor>())
    return reinterpret_cast<CXCXXDeleteExpr>(const_cast<clang::CXXDeleteExpr *>(DD->getDeleteExpr()));
  return nullptr;
}

CXCXXRecordDecl clang_CFGBlock_getElementCXXRecordDecl(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGDeleteDtor> DD = E.getAs<clang::CFGDeleteDtor>())
    return reinterpret_cast<CXCXXRecordDecl>(const_cast<clang::CXXRecordDecl *>(DD->getCXXRecordDecl()));
  return nullptr;
}

CXFunctionDecl clang_CFGBlock_getElementCleanupFunctionDecl(CXCFGBlock B, unsigned I) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGCleanupFunction> CF = E.getAs<clang::CFGCleanupFunction>())
    return reinterpret_cast<CXFunctionDecl>(const_cast<clang::FunctionDecl *>(CF->getFunctionDecl()));
  return nullptr;
}

CXCXXDestructorDecl clang_CFGBlock_getElementDestructorDecl(CXCFGBlock B, unsigned I,
                                                            CXASTContext Ctx) {
  clang::CFGElement E = (*reinterpret_cast<clang::CFGBlock *>(B))[I];
  if (std::optional<clang::CFGImplicitDtor> ID = E.getAs<clang::CFGImplicitDtor>())
    return reinterpret_cast<CXCXXDestructorDecl>(const_cast<clang::CXXDestructorDecl *>(
        ID->getDestructorDecl(*reinterpret_cast<clang::ASTContext *>(Ctx))));
  return nullptr;
}

// clang::CFGImplicitDtor::isNoReturn is not exported from libclang-cpp; unwrappable.

unsigned clang_CFGBlock_succ_size(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->succ_size();
}


bool clang_CFGBlock_succ_empty(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->succ_empty();
}

CXCFGBlock clang_CFGBlock_getSucc(CXCFGBlock B, unsigned I) {
  return reinterpret_cast<CXCFGBlock>((reinterpret_cast<clang::CFGBlock *>(B)->succ_begin() + I)->getReachableBlock());
}

bool clang_CFGBlock_isSuccReachable(CXCFGBlock B, unsigned I) {
  return (reinterpret_cast<clang::CFGBlock *>(B)->succ_begin() + I)->isReachable();
}

CXCFGBlock clang_CFGBlock_getSuccPossiblyUnreachableBlock(CXCFGBlock B, unsigned I) {
  return reinterpret_cast<CXCFGBlock>((reinterpret_cast<clang::CFGBlock *>(B)->succ_begin() + I)
      ->getPossiblyUnreachableBlock());
}

unsigned clang_CFGBlock_pred_size(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->pred_size();
}


bool clang_CFGBlock_pred_empty(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->pred_empty();
}

CXCFGBlock clang_CFGBlock_getPred(CXCFGBlock B, unsigned I) {
  return reinterpret_cast<CXCFGBlock>((reinterpret_cast<clang::CFGBlock *>(B)->pred_begin() + I)->getReachableBlock());
}

// FilterEdge / filtered_pred_start_end / filtered_succ_start_end

bool clang_CFGBlock_isPredReachable(CXCFGBlock B, unsigned I) {
  return (reinterpret_cast<clang::CFGBlock *>(B)->pred_begin() + I)->isReachable();
}

CXCFGBlock clang_CFGBlock_getPredPossiblyUnreachableBlock(CXCFGBlock B, unsigned I) {
  return reinterpret_cast<CXCFGBlock>((reinterpret_cast<clang::CFGBlock *>(B)->pred_begin() + I)
      ->getPossiblyUnreachableBlock());
}

bool clang_CFGBlock_FilterEdge(bool IgnoreNullPredecessors,
                               bool IgnoreDefaultsWithCoveredEnums, CXCFGBlock Src,
                               CXCFGBlock Dst) {
  clang::CFGBlock::FilterOptions F;
  F.IgnoreNullPredecessors = IgnoreNullPredecessors;
  F.IgnoreDefaultsWithCoveredEnums = IgnoreDefaultsWithCoveredEnums;
  return clang::CFGBlock::FilterEdge(F, reinterpret_cast<clang::CFGBlock *>(Src),
                                     reinterpret_cast<clang::CFGBlock *>(Dst));
}

unsigned clang_CFGBlock_getNumFilteredSuccs(CXCFGBlock B, bool IgnoreNullPredecessors,
                                            bool IgnoreDefaultsWithCoveredEnums) {
  clang::CFGBlock::FilterOptions F;
  F.IgnoreNullPredecessors = IgnoreNullPredecessors;
  F.IgnoreDefaultsWithCoveredEnums = IgnoreDefaultsWithCoveredEnums;
  const clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  unsigned N = 0;
  for (auto It = Blk->filtered_succ_start_end(F); It.hasMore(); ++It)
    ++N;
  return N;
}

void clang_CFGBlock_getFilteredSuccs(CXCFGBlock B, bool IgnoreNullPredecessors,
                                     bool IgnoreDefaultsWithCoveredEnums, CXCFGBlock *Buf,
                                     unsigned N) {
  clang::CFGBlock::FilterOptions F;
  F.IgnoreNullPredecessors = IgnoreNullPredecessors;
  F.IgnoreDefaultsWithCoveredEnums = IgnoreDefaultsWithCoveredEnums;
  const clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  unsigned J = 0;
  for (auto It = Blk->filtered_succ_start_end(F); It.hasMore() && J < N; ++It, ++J)
    Buf[J] = reinterpret_cast<CXCFGBlock>(const_cast<clang::CFGBlock *>(*It));
}

unsigned clang_CFGBlock_getNumFilteredPreds(CXCFGBlock B, bool IgnoreNullPredecessors,
                                            bool IgnoreDefaultsWithCoveredEnums) {
  clang::CFGBlock::FilterOptions F;
  F.IgnoreNullPredecessors = IgnoreNullPredecessors;
  F.IgnoreDefaultsWithCoveredEnums = IgnoreDefaultsWithCoveredEnums;
  const clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  unsigned N = 0;
  for (auto It = Blk->filtered_pred_start_end(F); It.hasMore(); ++It)
    ++N;
  return N;
}

void clang_CFGBlock_getFilteredPreds(CXCFGBlock B, bool IgnoreNullPredecessors,
                                     bool IgnoreDefaultsWithCoveredEnums, CXCFGBlock *Buf,
                                     unsigned N) {
  clang::CFGBlock::FilterOptions F;
  F.IgnoreNullPredecessors = IgnoreNullPredecessors;
  F.IgnoreDefaultsWithCoveredEnums = IgnoreDefaultsWithCoveredEnums;
  const clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  unsigned J = 0;
  for (auto It = Blk->filtered_pred_start_end(F); It.hasMore() && J < N; ++It, ++J)
    Buf[J] = reinterpret_cast<CXCFGBlock>(const_cast<clang::CFGBlock *>(*It));
}
// setTerminator / setLabel / setLoopTarget / setHasNoReturnElement

void clang_CFGBlock_setTerminator(CXCFGBlock B, CXStmt S, CXCFGTerminatorKind K) {
  clang::CFGTerminator T(reinterpret_cast<clang::Stmt *>(S),
                         static_cast<clang::CFGTerminator::Kind>(K));
  reinterpret_cast<clang::CFGBlock *>(B)->setTerminator(T);
}

void clang_CFGBlock_setLabel(CXCFGBlock B, CXStmt Statement) {
  reinterpret_cast<clang::CFGBlock *>(B)->setLabel(reinterpret_cast<clang::Stmt *>(Statement));
}

void clang_CFGBlock_setLoopTarget(CXCFGBlock B, CXStmt LoopTarget) {
  reinterpret_cast<clang::CFGBlock *>(B)->setLoopTarget(reinterpret_cast<clang::Stmt *>(LoopTarget));
}

void clang_CFGBlock_setHasNoReturnElement(CXCFGBlock B) {
  reinterpret_cast<clang::CFGBlock *>(B)->setHasNoReturnElement();
}

bool clang_CFGBlock_isInevitablySinking(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->isInevitablySinking();
}

bool clang_CFGBlock_hasTerminator(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->getTerminator().isValid();
}

CXCFGTerminatorKind clang_CFGBlock_getTerminatorKind(CXCFGBlock B) {
  return static_cast<CXCFGTerminatorKind>(
      reinterpret_cast<clang::CFGBlock *>(B)->getTerminator().getKind());
}

bool clang_CFGBlock_isTerminatorStmtBranch(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->getTerminator().isStmtBranch();
}

bool clang_CFGBlock_isTerminatorTemporaryDtorsBranch(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->getTerminator().isTemporaryDtorsBranch();
}

bool clang_CFGBlock_isTerminatorVirtualBaseBranch(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->getTerminator().isVirtualBaseBranch();
}

CXStmt clang_CFGBlock_getTerminatorStmt(CXCFGBlock B) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CFGBlock *>(B)->getTerminatorStmt());
}

CXExpr clang_CFGBlock_getLastCondition(CXCFGBlock B) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::CFGBlock *>(B)->getLastCondition()));
}

CXStmt clang_CFGBlock_getTerminatorCondition(CXCFGBlock B, bool StripParens) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CFGBlock *>(B)->getTerminatorCondition(StripParens));
}

CXStmt clang_CFGBlock_getLoopTarget(CXCFGBlock B) {
  return reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(reinterpret_cast<clang::CFGBlock *>(B)->getLoopTarget()));
}

CXStmt clang_CFGBlock_getLabel(CXCFGBlock B) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CFGBlock *>(B)->getLabel());
}

bool clang_CFGBlock_hasNoReturnElement(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->hasNoReturnElement();
}

unsigned clang_CFGBlock_getBlockID(CXCFGBlock B) {
  return reinterpret_cast<clang::CFGBlock *>(B)->getBlockID();
}

CXCFG clang_CFGBlock_getParent(CXCFGBlock B) {
  return reinterpret_cast<CXCFG>(reinterpret_cast<clang::CFGBlock *>(B)->getParent());
}

void clang_CFGBlock_dump(CXCFGBlock B, CXCFG G, CXASTContext Ctx, bool ShowColors) {
  reinterpret_cast<clang::CFGBlock *>(B)->dump(
      reinterpret_cast<clang::CFG *>(G), reinterpret_cast<clang::ASTContext *>(Ctx)->getLangOpts(),
      ShowColors);
}

// dump

CXString clang_CFGBlock_printAsString(CXCFGBlock B, CXCFG G, CXASTContext Ctx) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFGBlock *>(B)->print(
      OS, reinterpret_cast<clang::CFG *>(G),
      reinterpret_cast<clang::ASTContext *>(Ctx)->getLangOpts(), /*ShowColors=*/false);
  return extra::makeCXString(OS.str());
}

// printTerminator / printTerminatorJson / printAsOperand

CXString clang_CFGBlock_printTerminatorAsString(CXCFGBlock B, CXASTContext Ctx) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFGBlock *>(B)->printTerminator(
      OS, reinterpret_cast<clang::ASTContext *>(Ctx)->getLangOpts());
  return extra::makeCXString(OS.str());
}

CXString clang_CFGBlock_printTerminatorJsonAsString(CXCFGBlock B, CXASTContext Ctx,
                                                    bool AddQuotes) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFGBlock *>(B)->printTerminatorJson(
      OS, reinterpret_cast<clang::ASTContext *>(Ctx)->getLangOpts(), AddQuotes);
  return extra::makeCXString(OS.str());
}

CXString clang_CFGBlock_printAsOperandAsString(CXCFGBlock B) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFGBlock *>(B)->printAsOperand(OS, /*PrintType=*/false);
  return extra::makeCXString(OS.str());
}
// addSuccessor / appendStmt / appendConstructor / appendCXXRecordTypedCall /
// appendInitializer / appendNewAllocator / appendScopeBegin / appendScopeEnd /
// appendBaseDtor / appendMemberDtor / appendTemporaryDtor /
// appendAutomaticObjDtor / appendCleanupFunction / appendLifetimeEnds /
// appendLoopExit / appendDeleteDtor

void clang_CFGBlock_addSuccessor(CXCFGBlock B, CXCFGBlock Succ, bool IsReachable) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  clang::CFGBlock::AdjacentBlock Adj(reinterpret_cast<clang::CFGBlock *>(Succ), IsReachable);
  Blk->addSuccessor(Adj, C);
}

void clang_CFGBlock_appendStmt(CXCFGBlock B, CXStmt S) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendStmt(reinterpret_cast<clang::Stmt *>(S), C);
}

void clang_CFGBlock_appendConstructor(CXCFGBlock B, CXCXXConstructExpr CE,
                                      CXConstructionContext CC) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendConstructor(reinterpret_cast<clang::CXXConstructExpr *>(CE),
                         reinterpret_cast<clang::ConstructionContext *>(CC), C);
}

void clang_CFGBlock_appendCXXRecordTypedCall(CXCFGBlock B, CXExpr E,
                                             CXConstructionContext CC) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendCXXRecordTypedCall(reinterpret_cast<clang::Expr *>(E),
                                reinterpret_cast<clang::ConstructionContext *>(CC), C);
}

void clang_CFGBlock_appendInitializer(CXCFGBlock B, CXCXXCtorInitializer Init) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendInitializer(reinterpret_cast<clang::CXXCtorInitializer *>(Init), C);
}

void clang_CFGBlock_appendScopeBegin(CXCFGBlock B, CXVarDecl VD, CXStmt S) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendScopeBegin(reinterpret_cast<clang::VarDecl *>(VD), reinterpret_cast<clang::Stmt *>(S),
                        C);
}

void clang_CFGBlock_appendScopeEnd(CXCFGBlock B, CXVarDecl VD, CXStmt S) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendScopeEnd(reinterpret_cast<clang::VarDecl *>(VD), reinterpret_cast<clang::Stmt *>(S), C);
}

void clang_CFGBlock_appendBaseDtor(CXCFGBlock B, CXCXXBaseSpecifier BS) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendBaseDtor(reinterpret_cast<clang::CXXBaseSpecifier *>(BS), C);
}

void clang_CFGBlock_appendMemberDtor(CXCFGBlock B, CXFieldDecl FD) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendMemberDtor(reinterpret_cast<clang::FieldDecl *>(FD), C);
}

void clang_CFGBlock_appendTemporaryDtor(CXCFGBlock B, CXCXXBindTemporaryExpr E) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendTemporaryDtor(reinterpret_cast<clang::CXXBindTemporaryExpr *>(E), C);
}

void clang_CFGBlock_appendAutomaticObjDtor(CXCFGBlock B, CXVarDecl VD, CXStmt S) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendAutomaticObjDtor(reinterpret_cast<clang::VarDecl *>(VD),
                              reinterpret_cast<clang::Stmt *>(S), C);
}

void clang_CFGBlock_appendCleanupFunction(CXCFGBlock B, CXVarDecl VD) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendCleanupFunction(reinterpret_cast<clang::VarDecl *>(VD), C);
}

void clang_CFGBlock_appendLifetimeEnds(CXCFGBlock B, CXVarDecl VD, CXStmt S) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendLifetimeEnds(reinterpret_cast<clang::VarDecl *>(VD), reinterpret_cast<clang::Stmt *>(S),
                          C);
}

void clang_CFGBlock_appendLoopExit(CXCFGBlock B, CXStmt LoopStmt) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendLoopExit(reinterpret_cast<clang::Stmt *>(LoopStmt), C);
}

void clang_CFGBlock_appendNewAllocator(CXCFGBlock B, CXCXXNewExpr NE) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendNewAllocator(reinterpret_cast<clang::CXXNewExpr *>(NE), C);
}

void clang_CFGBlock_appendDeleteDtor(CXCFGBlock B, CXCXXRecordDecl RD, CXCXXDeleteExpr DE) {
  clang::CFGBlock *Blk = reinterpret_cast<clang::CFGBlock *>(B);
  clang::BumpVectorContext &C = Blk->getParent()->getBumpVectorContext();
  Blk->appendDeleteDtor(reinterpret_cast<clang::CXXRecordDecl *>(RD),
                        reinterpret_cast<clang::CXXDeleteExpr *>(DE), C);
}

// appendConstructor / appendCXXRecordTypedCall / appendNewAllocator /
// appendCleanupFunction / appendDeleteDtor

// CFG

// CFG::BuildOptions

CXCFGBuildOptions clang_CFGBuildOptions_create(void) {
  auto BO = std::make_unique<clang::CFG::BuildOptions>();
  return reinterpret_cast<CXCFGBuildOptions>(BO.release());
}

void clang_CFGBuildOptions_dispose(CXCFGBuildOptions BO) {
  delete reinterpret_cast<clang::CFG::BuildOptions *>(BO);
}

bool clang_CFGBuildOptions_alwaysAdd(CXCFGBuildOptions BO, CXStmt S) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->alwaysAdd(
      reinterpret_cast<clang::Stmt *>(S));
}

void clang_CFGBuildOptions_setAlwaysAdd(CXCFGBuildOptions BO, CXStmtClass SC, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->setAlwaysAdd(
      static_cast<clang::Stmt::StmtClass>(SC), Val);
}

void clang_CFGBuildOptions_setAllAlwaysAdd(CXCFGBuildOptions BO) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->setAllAlwaysAdd();
}

void clang_CFGBuildOptions_setAddRichCXXConstructors(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddRichCXXConstructors = Val;
}

void clang_CFGBuildOptions_setMarkElidedCXXConstructors(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->MarkElidedCXXConstructors = Val;
}

bool clang_CFGBuildOptions_getPruneTriviallyFalseEdges(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->PruneTriviallyFalseEdges;
}

void clang_CFGBuildOptions_setPruneTriviallyFalseEdges(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->PruneTriviallyFalseEdges = Val;
}

bool clang_CFGBuildOptions_getAddEHEdges(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddEHEdges;
}

void clang_CFGBuildOptions_setAddEHEdges(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddEHEdges = Val;
}

bool clang_CFGBuildOptions_getAddStaticInitBranches(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddStaticInitBranches;
}

void clang_CFGBuildOptions_setAddStaticInitBranches(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddStaticInitBranches = Val;
}

bool clang_CFGBuildOptions_getAddCXXDefaultInitExprInCtors(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddCXXDefaultInitExprInCtors;
}

void clang_CFGBuildOptions_setAddCXXDefaultInitExprInCtors(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddCXXDefaultInitExprInCtors = Val;
}

bool clang_CFGBuildOptions_getAddCXXDefaultInitExprInAggregates(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddCXXDefaultInitExprInAggregates;
}

void clang_CFGBuildOptions_setAddCXXDefaultInitExprInAggregates(CXCFGBuildOptions BO,
                                                                bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddCXXDefaultInitExprInAggregates = Val;
}

bool clang_CFGBuildOptions_getAddRichCXXConstructors(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddRichCXXConstructors;
}

bool clang_CFGBuildOptions_getMarkElidedCXXConstructors(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->MarkElidedCXXConstructors;
}

bool clang_CFGBuildOptions_getAddVirtualBaseBranches(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddVirtualBaseBranches;
}

void clang_CFGBuildOptions_setAddVirtualBaseBranches(CXCFGBuildOptions BO, bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->AddVirtualBaseBranches = Val;
}

bool clang_CFGBuildOptions_getOmitImplicitValueInitializers(CXCFGBuildOptions BO) {
  return reinterpret_cast<clang::CFG::BuildOptions *>(BO)->OmitImplicitValueInitializers;
}

void clang_CFGBuildOptions_setOmitImplicitValueInitializers(CXCFGBuildOptions BO,
                                                            bool Val) {
  reinterpret_cast<clang::CFG::BuildOptions *>(BO)->OmitImplicitValueInitializers = Val;
}

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
  return reinterpret_cast<CXCFG>(clang::CFG::buildCFG(reinterpret_cast<clang::Decl *>(D),
                              reinterpret_cast<clang::Stmt *>(S),
                              reinterpret_cast<clang::ASTContext *>(Ctx), BO)
      .release());
}

CXCFG clang_CFG_buildCFGWithOptions(CXDecl D, CXStmt S, CXASTContext Ctx,
                                    CXCFGBuildOptions BO, bool AddInitializers,
                                    bool AddImplicitDtors, bool AddLifetime,
                                    bool AddLoopExit, bool AddTemporaryDtors,
                                    bool AddScopes, bool AddCXXNewAllocator) {
  clang::CFG::BuildOptions Opts = *reinterpret_cast<clang::CFG::BuildOptions *>(BO);
  Opts.AddInitializers = AddInitializers;
  Opts.AddImplicitDtors = AddImplicitDtors;
  Opts.AddLifetime = AddLifetime;
  Opts.AddLoopExit = AddLoopExit;
  Opts.AddTemporaryDtors = AddTemporaryDtors;
  Opts.AddScopes = AddScopes;
  Opts.AddCXXNewAllocator = AddCXXNewAllocator;
  return reinterpret_cast<CXCFG>(clang::CFG::buildCFG(reinterpret_cast<clang::Decl *>(D), reinterpret_cast<clang::Stmt *>(S),
                              reinterpret_cast<clang::ASTContext *>(Ctx), Opts)
      .release());
}

void clang_CFG_dispose(CXCFG G) { delete reinterpret_cast<clang::CFG *>(G); }

// createBlock
// setEntry
// setIndirectGotoBlock

CXCFGBlock clang_CFG_createBlock(CXCFG G) {
  return reinterpret_cast<CXCFGBlock>(reinterpret_cast<clang::CFG *>(G)->createBlock());
}

void clang_CFG_setEntry(CXCFG G, CXCFGBlock B) {
  reinterpret_cast<clang::CFG *>(G)->setEntry(reinterpret_cast<clang::CFGBlock *>(B));
}

void clang_CFG_setIndirectGotoBlock(CXCFG G, CXCFGBlock B) {
  reinterpret_cast<clang::CFG *>(G)->setIndirectGotoBlock(reinterpret_cast<clang::CFGBlock *>(B));
}

CXCFGBlock clang_CFG_front(CXCFG G) { return reinterpret_cast<CXCFGBlock>(&reinterpret_cast<clang::CFG *>(G)->front()); }

CXCFGBlock clang_CFG_back(CXCFG G) { return reinterpret_cast<CXCFGBlock>(&reinterpret_cast<clang::CFG *>(G)->back()); }
// front / back
// begin / end / rbegin / rend / nodes / const_nodes / reverse_nodes /
// const_reverse_nodes / nodes_begin / nodes_end

unsigned clang_CFG_getNumBlocks(CXCFG G) {
  clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  return static_cast<unsigned>(C->end() - C->begin());
}

CXCFGBlock clang_CFG_getBlock(CXCFG G, unsigned I) {
  return reinterpret_cast<CXCFGBlock>(*(reinterpret_cast<clang::CFG *>(G)->begin() + I));
}

CXCFGBlock clang_CFG_getEntry(CXCFG G) {
  return reinterpret_cast<CXCFGBlock>(&reinterpret_cast<clang::CFG *>(G)->getEntry());
}

CXCFGBlock clang_CFG_getExit(CXCFG G) {
  return reinterpret_cast<CXCFGBlock>(&reinterpret_cast<clang::CFG *>(G)->getExit());
}

CXCFGBlock clang_CFG_getIndirectGotoBlock(CXCFG G) {
  return reinterpret_cast<CXCFGBlock>(reinterpret_cast<clang::CFG *>(G)->getIndirectGotoBlock());
}

// try_blocks / try_blocks_begin / try_blocks_end / addTryDispatchBlock

unsigned clang_CFG_getNumTryBlocks(CXCFG G) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  return static_cast<unsigned>(std::distance(C->try_blocks_begin(), C->try_blocks_end()));
}

CXCFGBlock clang_CFG_getTryBlock(CXCFG G, unsigned I) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  return reinterpret_cast<CXCFGBlock>(const_cast<clang::CFGBlock *>(*(C->try_blocks_begin() + I)));
}
// addSyntheticDeclStmt / synthetic_stmts / synthetic_stmt_begin /
// synthetic_stmt_end

void clang_CFG_addTryDispatchBlock(CXCFG G, CXCFGBlock Block) {
  reinterpret_cast<clang::CFG *>(G)->addTryDispatchBlock(reinterpret_cast<clang::CFGBlock *>(Block));
}

void clang_CFG_addSyntheticDeclStmt(CXCFG G, CXDeclStmt Synthetic, CXDeclStmt Source) {
  reinterpret_cast<clang::CFG *>(G)->addSyntheticDeclStmt(
      reinterpret_cast<clang::DeclStmt *>(Synthetic), reinterpret_cast<clang::DeclStmt *>(Source));
}

unsigned clang_CFG_getNumSyntheticDeclStmts(CXCFG G) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  return static_cast<unsigned>(
      std::distance(C->synthetic_stmt_begin(), C->synthetic_stmt_end()));
}

CXDeclStmt clang_CFG_getSyntheticDeclStmtSource(CXCFG G, CXDeclStmt Synthetic) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  const clang::DeclStmt *Key = reinterpret_cast<clang::DeclStmt *>(Synthetic);
  for (auto I = C->synthetic_stmt_begin(), E = C->synthetic_stmt_end(); I != E; ++I)
    if (I->first == Key)
      return reinterpret_cast<CXDeclStmt>(const_cast<clang::DeclStmt *>(I->second));
  return nullptr;
}
// VisitBlockStmts (template callback — MARSHALLING.md §10)

void clang_CFG_getSyntheticDeclStmts(CXCFG G, CXDeclStmt *SyntheticBuf,
                                     CXDeclStmt *SourceBuf, unsigned N) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  unsigned J = 0;
  for (auto I = C->synthetic_stmt_begin(), E = C->synthetic_stmt_end(); I != E && J < N;
       ++I, ++J) {
    SyntheticBuf[J] = reinterpret_cast<CXDeclStmt>(const_cast<clang::DeclStmt *>(I->first));
    SourceBuf[J] = reinterpret_cast<CXDeclStmt>(const_cast<clang::DeclStmt *>(I->second));
  }
}

unsigned clang_CFG_getNumBlockStmts(CXCFG G) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  unsigned Count = 0;
  for (auto I = C->begin(), E = C->end(); I != E; ++I)
    for (auto BI = (*I)->begin(), BE = (*I)->end(); BI != BE; ++BI)
      if (BI->getAs<clang::CFGStmt>())
        ++Count;
  return Count;
}

void clang_CFG_getBlockStmts(CXCFG G, CXStmt *Buf, unsigned N) {
  const clang::CFG *C = reinterpret_cast<clang::CFG *>(G);
  unsigned J = 0;
  for (auto I = C->begin(), E = C->end(); I != E && J < N; ++I)
    for (auto BI = (*I)->begin(), BE = (*I)->end(); BI != BE && J < N; ++BI)
      if (std::optional<clang::CFGStmt> CS = BI->getAs<clang::CFGStmt>())
        Buf[J++] = reinterpret_cast<CXStmt>(const_cast<clang::Stmt *>(CS->getStmt()));
}

unsigned clang_CFG_getNumBlockIDs(CXCFG G) {
  return reinterpret_cast<clang::CFG *>(G)->getNumBlockIDs();
}

// size (a pure renaming of getNumBlockIDs)

bool clang_CFG_isLinear(CXCFG G) {
  return reinterpret_cast<clang::CFG *>(G)->isLinear();
}

// viewCFG

CXString clang_CFG_printAsString(CXCFG G, CXASTContext Ctx) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFG *>(G)->print(
      OS, reinterpret_cast<clang::ASTContext *>(Ctx)->getLangOpts(),
      /*ShowColors=*/false);
  return extra::makeCXString(OS.str());
}

void clang_CFG_dump(CXCFG G, CXASTContext Ctx, bool ShowColors) {
  reinterpret_cast<clang::CFG *>(G)->dump(reinterpret_cast<clang::ASTContext *>(Ctx)->getLangOpts(),
                                     ShowColors);
}

// dump
// getAllocator
// getBumpVectorContext
