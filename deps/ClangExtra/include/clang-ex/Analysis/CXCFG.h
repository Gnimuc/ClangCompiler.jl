#ifndef LLVM_CLANG_C_EXTRA_CXCFG_H
#define LLVM_CLANG_C_EXTRA_CXCFG_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::CFGElement::Kind (a plain enum nested in CFGElement). Kept in
// declaration order; the STMT_BEGIN/STMT_END/DTOR_BEGIN/DTOR_END range aliases
// are omitted — alias enumerators duplicate values, which the generated Julia
// @enum cannot carry — and omitting them does not shift the numbering.
// CXEnumSync.cpp proves value-for-value equality.
typedef enum CXCFGElementKind {
  CXCFGElementKind_Initializer,
  CXCFGElementKind_ScopeBegin,
  CXCFGElementKind_ScopeEnd,
  CXCFGElementKind_NewAllocator,
  CXCFGElementKind_LifetimeEnds,
  CXCFGElementKind_LoopExit,
  CXCFGElementKind_Statement,
  CXCFGElementKind_Constructor,
  CXCFGElementKind_CXXRecordTypedCall,
  CXCFGElementKind_AutomaticObjectDtor,
  CXCFGElementKind_DeleteDtor,
  CXCFGElementKind_BaseDtor,
  CXCFGElementKind_MemberDtor,
  CXCFGElementKind_TemporaryDtor,
  CXCFGElementKind_CleanupFunction
} CXCFGElementKind;

// Mirrors clang::CFGTerminator::Kind (a plain enum nested in CFGTerminator).
// The NumKindsMinusOne assertion alias is omitted (duplicate value).
// CXEnumSync.cpp proves value-for-value equality.
typedef enum CXCFGTerminatorKind {
  CXCFGTerminatorKind_StmtBranch,
  CXCFGTerminatorKind_TemporaryDtorsBranch,
  CXCFGTerminatorKind_VirtualBaseBranch
} CXCFGTerminatorKind;

// CFGBlock
// All CXCFGBlock handles are interior to their parent CXCFG and are
// invalidated when the CFG is disposed; they are never disposed themselves.

size_t clang_CFGBlock_getIndexInCFG(CXCFGBlock B);

// front
// back
// begin / end / rbegin / rend / ref_begin / ref_end / rref_begin / rref_end /
// refs / rrefs (iterator surface: use the element count+index accessors below)

// Number of CFGElements in the block.
unsigned clang_CFGBlock_size(CXCFGBlock B);

// empty

// Indexed CFGElement access, 0 <= I < clang_CFGBlock_size (elements are in
// execution order). CFGElement is a two-word value type; instead of heap-boxing
// it, the kind discriminator and the per-kind payloads are exposed directly
// (MARSHALLING.md §8). Each payload accessor returns NULL unless the element is
// of the kind(s) it names.
CXCFGElementKind clang_CFGBlock_getElementKind(CXCFGBlock B, unsigned I); // helper

// The top-level Stmt of a statement-family element (Statement, Constructor,
// CXXRecordTypedCall) — clang::CFGStmt::getStmt. // helper
CXStmt clang_CFGBlock_getElementStmt(CXCFGBlock B, unsigned I);

// Initializer kind — clang::CFGInitializer::getInitializer. // helper
CXCXXCtorInitializer clang_CFGBlock_getElementInitializer(CXCFGBlock B, unsigned I);

// ScopeBegin / ScopeEnd / LifetimeEnds / AutomaticObjectDtor / CleanupFunction
// kinds — the element's VarDecl payload. // helper
CXVarDecl clang_CFGBlock_getElementVarDecl(CXCFGBlock B, unsigned I);

// ScopeBegin / ScopeEnd / LifetimeEnds / AutomaticObjectDtor kinds — the
// element's trigger-statement payload. // helper
CXStmt clang_CFGBlock_getElementTriggerStmt(CXCFGBlock B, unsigned I);

// LoopExit kind — clang::CFGLoopExit::getLoopStmt. // helper
CXStmt clang_CFGBlock_getElementLoopStmt(CXCFGBlock B, unsigned I);

// TemporaryDtor kind — clang::CFGTemporaryDtor::getBindTemporaryExpr. // helper
CXCXXBindTemporaryExpr clang_CFGBlock_getElementBindTemporaryExpr(CXCFGBlock B,
                                                                  unsigned I);

// BaseDtor kind — clang::CFGBaseDtor::getBaseSpecifier. // helper
CXCXXBaseSpecifier clang_CFGBlock_getElementBaseSpecifier(CXCFGBlock B, unsigned I);

// MemberDtor kind — clang::CFGMemberDtor::getFieldDecl. // helper
CXFieldDecl clang_CFGBlock_getElementFieldDecl(CXCFGBlock B, unsigned I);

// NewAllocator kind — clang::CFGNewAllocator::getAllocatorExpr. // helper
CXCXXNewExpr clang_CFGBlock_getElementAllocatorExpr(CXCFGBlock B, unsigned I);

// clang::CFGElement::dumpToStream rendered into a CXString. // helper
CXString clang_CFGBlock_printElementAsString(CXCFGBlock B, unsigned I);

// pred_begin / pred_end / pred_rbegin / pred_rend / preds
// succ_begin / succ_end / succ_rbegin / succ_rend / succs
// (iterator surface: use succ_size/pred_size + getSucc/getPred below)

unsigned clang_CFGBlock_succ_size(CXCFGBlock B);

// succ_empty

// The I-th successor's reachable block (0 <= I < succ_size; successor order is
// terminator-specific). NULL for an optimized-out/unreachable edge — see
// clang_CFGBlock_isSuccReachable / getSuccPossiblyUnreachableBlock. // helper
CXCFGBlock clang_CFGBlock_getSucc(CXCFGBlock B, unsigned I);

// clang::CFGBlock::AdjacentBlock::isReachable for the I-th successor. // helper
bool clang_CFGBlock_isSuccReachable(CXCFGBlock B, unsigned I);

// clang::CFGBlock::AdjacentBlock::getPossiblyUnreachableBlock for the I-th
// successor; NULL for a plain reachable edge. // helper
CXCFGBlock clang_CFGBlock_getSuccPossiblyUnreachableBlock(CXCFGBlock B, unsigned I);

unsigned clang_CFGBlock_pred_size(CXCFGBlock B);

// pred_empty

// The I-th predecessor's reachable block (0 <= I < pred_size; order is
// arbitrary); NULL for an unreachable edge. // helper
CXCFGBlock clang_CFGBlock_getPred(CXCFGBlock B, unsigned I);

// FilterEdge / filtered_pred_start_end / filtered_succ_start_end
// setTerminator / setLabel / setLoopTarget / setHasNoReturnElement

bool clang_CFGBlock_isInevitablySinking(CXCFGBlock B);

// The CFGTerminator value type is decomposed into the two accessors below plus
// getTerminatorStmt (MARSHALLING.md §7). getTerminatorKind is only meaningful
// when hasTerminator is true.
bool clang_CFGBlock_hasTerminator(CXCFGBlock B); // helper

CXCFGTerminatorKind clang_CFGBlock_getTerminatorKind(CXCFGBlock B); // helper

CXStmt clang_CFGBlock_getTerminatorStmt(CXCFGBlock B);

CXExpr clang_CFGBlock_getLastCondition(CXCFGBlock B);

CXStmt clang_CFGBlock_getTerminatorCondition(CXCFGBlock B, bool StripParens);

CXStmt clang_CFGBlock_getLoopTarget(CXCFGBlock B);

CXStmt clang_CFGBlock_getLabel(CXCFGBlock B);

bool clang_CFGBlock_hasNoReturnElement(CXCFGBlock B);

unsigned clang_CFGBlock_getBlockID(CXCFGBlock B);

// The parent CFG; BORROWED — never pass it to clang_CFG_dispose.
CXCFG clang_CFGBlock_getParent(CXCFGBlock B);

// dump
// clang::CFGBlock::print rendered into a CXString (no colors). // helper
CXString clang_CFGBlock_printAsString(CXCFGBlock B, CXCFG G, CXASTContext Ctx);

// printTerminator / printTerminatorJson / printAsOperand
// addSuccessor / appendStmt / appendConstructor / appendCXXRecordTypedCall /
// appendInitializer / appendNewAllocator / appendScopeBegin / appendScopeEnd /
// appendBaseDtor / appendMemberDtor / appendTemporaryDtor /
// appendAutomaticObjDtor / appendCleanupFunction / appendLifetimeEnds /
// appendLoopExit / appendDeleteDtor

// CFG

// clang::CFG::buildCFG returns std::unique_ptr<CFG>; the wrapper releases it,
// so the returned CFG is CALLER-OWNED — pair with clang_CFG_dispose. NULL when
// clang cannot build a CFG for the input. BuildOptions is flattened to the
// element-producing booleans below (each maps onto the same-named field);
// every other option keeps its default (PruneTriviallyFalseEdges stays true).
CXCFG clang_CFG_buildCFG(CXDecl D, CXStmt S, CXASTContext Ctx, bool AddInitializers,
                         bool AddImplicitDtors, bool AddLifetime, bool AddLoopExit,
                         bool AddTemporaryDtors, bool AddScopes,
                         bool AddCXXNewAllocator);

void clang_CFG_dispose(CXCFG G);

// createBlock
// setEntry
// setIndirectGotoBlock
// front / back
// begin / end / rbegin / rend / nodes / const_nodes / reverse_nodes /
// const_reverse_nodes / nodes_begin / nodes_end

// Block count+index access; the block list is random-access (MARSHALLING.md §6).
unsigned clang_CFG_getNumBlocks(CXCFG G); // helper

CXCFGBlock clang_CFG_getBlock(CXCFG G, unsigned I); // helper

CXCFGBlock clang_CFG_getEntry(CXCFG G);

CXCFGBlock clang_CFG_getExit(CXCFG G);

// NULL when the function contains no indirect goto.
CXCFGBlock clang_CFG_getIndirectGotoBlock(CXCFG G);

// try_blocks / try_blocks_begin / try_blocks_end / addTryDispatchBlock
// addSyntheticDeclStmt / synthetic_stmts / synthetic_stmt_begin /
// synthetic_stmt_end
// VisitBlockStmts (template callback — MARSHALLING.md §10)

unsigned clang_CFG_getNumBlockIDs(CXCFG G);

// size (a pure renaming of getNumBlockIDs)

bool clang_CFG_isLinear(CXCFG G);

// viewCFG

// clang::CFG::print rendered into a CXString (no colors). // helper
CXString clang_CFG_printAsString(CXCFG G, CXASTContext Ctx);

// dump
// getAllocator
// getBumpVectorContext

LLVM_CLANG_C_EXTERN_C_END

#endif
