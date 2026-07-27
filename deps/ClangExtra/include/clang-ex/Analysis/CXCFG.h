#ifndef LLVM_CLANG_C_EXTRA_CXCFG_H
#define LLVM_CLANG_C_EXTRA_CXCFG_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/AST/CXStmt.h"

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

// CFGCXXRecordTypedCall

// Static clang::CFGCXXRecordTypedCall::isCXXRecordTypedCall — whether a CFG models the
// call E as a CXXRecordTypedCall element instead of a plain Statement element (true for a
// prvalue of class type). PARTIAL: it asserts E is a CallExpr or an ObjCMessageExpr, so
// the Julia wrapper restates that precondition.
bool clang_CFGCXXRecordTypedCall_isCXXRecordTypedCall(CXExpr E);

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

bool clang_CFGBlock_empty(CXCFGBlock B);

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

// DeleteDtor kind — clang::CFGDeleteDtor::getDeleteExpr. // helper
CXCXXDeleteExpr clang_CFGBlock_getElementDeleteExpr(CXCFGBlock B, unsigned I);

// DeleteDtor kind — clang::CFGDeleteDtor::getCXXRecordDecl. // helper
CXCXXRecordDecl clang_CFGBlock_getElementCXXRecordDecl(CXCFGBlock B, unsigned I);

// CleanupFunction kind — clang::CFGCleanupFunction::getFunctionDecl. PARTIAL:
// that accessor dereferences the VarDecl's CleanupAttr with no null check; the
// attribute is guaranteed only because clang's own CFGCleanupFunction constructor
// asserts it, so the shim reaches it exclusively through the kind-checked
// getAs<CFGCleanupFunction> below and returns NULL for every other kind. // helper
CXFunctionDecl clang_CFGBlock_getElementCleanupFunctionDecl(CXCFGBlock B, unsigned I);

// Destructor of a dtor-family element (AutomaticObjectDtor, DeleteDtor, BaseDtor,
// MemberDtor, TemporaryDtor) — clang::CFGImplicitDtor::getDestructorDecl, which is
// undefined on a non-dtor kind (its switch ends in llvm_unreachable); the shim
// guards with getAs<CFGImplicitDtor> and returns NULL otherwise. // helper
CXCXXDestructorDecl clang_CFGBlock_getElementDestructorDecl(CXCFGBlock B, unsigned I,
                                                            CXASTContext Ctx);

// clang::CFGImplicitDtor::isNoReturn is not exported from libclang-cpp; unwrappable.

// pred_begin / pred_end / pred_rbegin / pred_rend / preds
// succ_begin / succ_end / succ_rbegin / succ_rend / succs
// (iterator surface: use succ_size/pred_size + getSucc/getPred below)

unsigned clang_CFGBlock_succ_size(CXCFGBlock B);

// succ_empty

bool clang_CFGBlock_succ_empty(CXCFGBlock B);

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

bool clang_CFGBlock_pred_empty(CXCFGBlock B);

// The I-th predecessor's reachable block (0 <= I < pred_size; order is
// arbitrary); NULL for an unreachable edge. // helper
CXCFGBlock clang_CFGBlock_getPred(CXCFGBlock B, unsigned I);

// clang::CFGBlock::AdjacentBlock::isReachable for the I-th predecessor. // helper
bool clang_CFGBlock_isPredReachable(CXCFGBlock B, unsigned I);

// clang::CFGBlock::AdjacentBlock::getPossiblyUnreachableBlock for the I-th
// predecessor; NULL for a plain reachable edge. // helper
CXCFGBlock clang_CFGBlock_getPredPossiblyUnreachableBlock(CXCFGBlock B, unsigned I);

// FilterEdge / filtered_pred_start_end / filtered_succ_start_end

// Static clang::CFGBlock::FilterEdge. FilterOptions is a two-bit-field value type,
// flattened here into its two booleans (clang's defaults: IgnoreNullPredecessors
// on, IgnoreDefaultsWithCoveredEnums off).
bool clang_CFGBlock_FilterEdge(bool IgnoreNullPredecessors,
                               bool IgnoreDefaultsWithCoveredEnums, CXCFGBlock Src,
                               CXCFGBlock Dst);

// Filtered edge walks — clang::CFGBlock::filtered_succ_start_end /
// filtered_pred_start_end, whose FilteredCFGBlockIterator drops every edge that
// FilterEdge rejects. That iterator is forward-only, so the walk is exposed as the
// count+fill pair of MARSHALLING.md §6: the count is exact and `Buf` receives
// min(N, count) blocks. FilterOptions is flattened into its two booleans, as in
// clang_CFGBlock_FilterEdge above; the defaults clang's own FilterOptions constructor
// installs are IgnoreNullPredecessors on, IgnoreDefaultsWithCoveredEnums off. A slot is
// NULL when a surviving edge has no reachable block. // helper
unsigned clang_CFGBlock_getNumFilteredSuccs(CXCFGBlock B, bool IgnoreNullPredecessors,
                                            bool IgnoreDefaultsWithCoveredEnums);

void clang_CFGBlock_getFilteredSuccs(CXCFGBlock B, bool IgnoreNullPredecessors,
                                     bool IgnoreDefaultsWithCoveredEnums, CXCFGBlock *Buf,
                                     unsigned N); // helper

unsigned clang_CFGBlock_getNumFilteredPreds(CXCFGBlock B, bool IgnoreNullPredecessors,
                                            bool IgnoreDefaultsWithCoveredEnums); // helper

void clang_CFGBlock_getFilteredPreds(CXCFGBlock B, bool IgnoreNullPredecessors,
                                     bool IgnoreDefaultsWithCoveredEnums, CXCFGBlock *Buf,
                                     unsigned N); // helper
// setTerminator / setLabel / setLoopTarget / setHasNoReturnElement

// The CFGTerminator value type is flattened into its two constructor arguments —
// the branch statement and its kind (MARSHALLING.md §7); clang's default kind is
// StmtBranch. A NULL statement stores the invalid terminator that
// clang_CFGBlock_hasTerminator reports as absent.
void clang_CFGBlock_setTerminator(CXCFGBlock B, CXStmt S, CXCFGTerminatorKind K);

// Clang expects a LabelStmt, SwitchCase or CXXCatchStmt here; nothing checks it.
void clang_CFGBlock_setLabel(CXCFGBlock B, CXStmt Statement);

void clang_CFGBlock_setLoopTarget(CXCFGBlock B, CXStmt LoopTarget);

void clang_CFGBlock_setHasNoReturnElement(CXCFGBlock B);

bool clang_CFGBlock_isInevitablySinking(CXCFGBlock B);

// The CFGTerminator value type is decomposed into the two accessors below plus
// getTerminatorStmt (MARSHALLING.md §7). getTerminatorKind is only meaningful
// when hasTerminator is true.
bool clang_CFGBlock_hasTerminator(CXCFGBlock B); // helper

CXCFGTerminatorKind clang_CFGBlock_getTerminatorKind(CXCFGBlock B); // helper

// clang::CFGTerminator::isStmtBranch. NOTE: the absent terminator is an empty
// PointerIntPair whose kind reads back as StmtBranch, so this is also true when
// clang_CFGBlock_hasTerminator is false. // helper
bool clang_CFGBlock_isTerminatorStmtBranch(CXCFGBlock B);

// clang::CFGTerminator::isTemporaryDtorsBranch. // helper
bool clang_CFGBlock_isTerminatorTemporaryDtorsBranch(CXCFGBlock B);

// clang::CFGTerminator::isVirtualBaseBranch. // helper
bool clang_CFGBlock_isTerminatorVirtualBaseBranch(CXCFGBlock B);

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

// clang::CFGBlock::printTerminator rendered into a CXString. // helper
CXString clang_CFGBlock_printTerminatorAsString(CXCFGBlock B, CXASTContext Ctx);

// clang::CFGBlock::printTerminatorJson rendered into a CXString. // helper
CXString clang_CFGBlock_printTerminatorJsonAsString(CXCFGBlock B, CXASTContext Ctx,
                                                    bool AddQuotes);

// clang::CFGBlock::printAsOperand rendered into a CXString: the LLVM-style operand label
// "BB#<block id>". // helper
CXString clang_CFGBlock_printAsOperandAsString(CXCFGBlock B);
// addSuccessor / appendStmt / appendConstructor / appendCXXRecordTypedCall /
// appendInitializer / appendNewAllocator / appendScopeBegin / appendScopeEnd /
// appendBaseDtor / appendMemberDtor / appendTemporaryDtor /
// appendAutomaticObjDtor / appendCleanupFunction / appendLifetimeEnds /
// appendLoopExit / appendDeleteDtor

// Mutation of a block's contents. Every clang::CFGBlock append/addSuccessor method
// takes the owning CFG's BumpVectorContext (elements and edges are allocated from
// the CFG's arena); these wrappers drop that parameter and read it from
// B->getParent() instead, so a block can never be grown out of a foreign arena.
// The element list is stored in reverse, so an appended element becomes index 0
// and every element already in the block shifts up by one.

// clang::CFGBlock::AdjacentBlock is flattened into the successor block plus its
// reachability flag (MARSHALLING.md §7). This also registers B as a predecessor of
// Succ; an unreachable edge reads back through
// clang_CFGBlock_getSuccPossiblyUnreachableBlock, with a NULL clang_CFGBlock_getSucc.
void clang_CFGBlock_addSuccessor(CXCFGBlock B, CXCFGBlock Succ, bool IsReachable);

void clang_CFGBlock_appendStmt(CXCFGBlock B, CXStmt S);

void clang_CFGBlock_appendInitializer(CXCFGBlock B, CXCXXCtorInitializer Init);

void clang_CFGBlock_appendScopeBegin(CXCFGBlock B, CXVarDecl VD, CXStmt S);

void clang_CFGBlock_appendScopeEnd(CXCFGBlock B, CXVarDecl VD, CXStmt S);

void clang_CFGBlock_appendBaseDtor(CXCFGBlock B, CXCXXBaseSpecifier BS);

void clang_CFGBlock_appendMemberDtor(CXCFGBlock B, CXFieldDecl FD);

void clang_CFGBlock_appendTemporaryDtor(CXCFGBlock B, CXCXXBindTemporaryExpr E);

void clang_CFGBlock_appendAutomaticObjDtor(CXCFGBlock B, CXVarDecl VD, CXStmt S);

// PARTIAL: clang::CFGBlock::appendCleanupFunction builds a CFGCleanupFunction, whose
// constructor asserts VD carries a CleanupAttr, and
// clang_CFGBlock_getElementCleanupFunctionDecl then dereferences that attribute with no
// null check. The Julia wrapper restates the precondition.
void clang_CFGBlock_appendCleanupFunction(CXCFGBlock B, CXVarDecl VD);

void clang_CFGBlock_appendLifetimeEnds(CXCFGBlock B, CXVarDecl VD, CXStmt S);

void clang_CFGBlock_appendLoopExit(CXCFGBlock B, CXStmt LoopStmt);

void clang_CFGBlock_appendNewAllocator(CXCFGBlock B, CXCXXNewExpr NE);

void clang_CFGBlock_appendDeleteDtor(CXCFGBlock B, CXCXXRecordDecl RD, CXCXXDeleteExpr DE);

// appendConstructor / appendCXXRecordTypedCall (both take a
// clang::ConstructionContext, which has no CX handle) / appendNewAllocator /
// appendCleanupFunction / appendDeleteDtor

// CFG

// CFG::BuildOptions
// The alwaysAdd mask is a std::bitset carrying one bit per Stmt class, so unlike the
// BuildOptions booleans it is stateful and cannot be flattened into a parameter list.
// It crosses as a caller-owned object instead: create it, set bits on it, hand it to
// clang_CFG_buildCFGWithOptions, dispose it. The booleans stay flattened (they are the
// trailing parameters of clang_CFG_buildCFGWithOptions, matching clang_CFG_buildCFG's),
// and every other BuildOptions field keeps its clang default.
CXCFGBuildOptions clang_CFGBuildOptions_create(void);

void clang_CFGBuildOptions_dispose(CXCFGBuildOptions BO);

// Whether S's statement class is set in the alwaysAdd mask.
bool clang_CFGBuildOptions_alwaysAdd(CXCFGBuildOptions BO, CXStmt S);

// Set or clear one statement class in the mask. SC must be a real CXStmtClass
// enumerator: clang indexes an exactly-sized std::bitset with it, so an out-of-range
// value is undefined behaviour.
void clang_CFGBuildOptions_setAlwaysAdd(CXCFGBuildOptions BO, CXStmtClass SC, bool Val);

void clang_CFGBuildOptions_setAllAlwaysAdd(CXCFGBuildOptions BO);

// clang::CFG::buildCFG returns std::unique_ptr<CFG>; the wrapper releases it,
// so the returned CFG is CALLER-OWNED — pair with clang_CFG_dispose. NULL when
// clang cannot build a CFG for the input. BuildOptions is flattened to the
// element-producing booleans below (each maps onto the same-named field);
// every other option keeps its default (PruneTriviallyFalseEdges stays true).
CXCFG clang_CFG_buildCFG(CXDecl D, CXStmt S, CXASTContext Ctx, bool AddInitializers,
                         bool AddImplicitDtors, bool AddLifetime, bool AddLoopExit,
                         bool AddTemporaryDtors, bool AddScopes,
                         bool AddCXXNewAllocator);

// clang_CFG_buildCFG with the alwaysAdd mask of BO applied on top; every other
// parameter means exactly what it does there, and BO must not be NULL. BO is only read
// during the call — the resulting graph keeps no reference to it. The returned CFG is
// CALLER-OWNED — pair with clang_CFG_dispose. // helper
CXCFG clang_CFG_buildCFGWithOptions(CXDecl D, CXStmt S, CXASTContext Ctx,
                                    CXCFGBuildOptions BO, bool AddInitializers,
                                    bool AddImplicitDtors, bool AddLifetime,
                                    bool AddLoopExit, bool AddTemporaryDtors,
                                    bool AddScopes, bool AddCXXNewAllocator);

void clang_CFG_dispose(CXCFG G);

// createBlock
// setEntry
// setIndirectGotoBlock

// Creates a new empty block owned by the CFG; the handle is interior and is
// released with the graph (never disposed on its own).
CXCFGBlock clang_CFG_createBlock(CXCFG G);

void clang_CFG_setEntry(CXCFG G, CXCFGBlock B);

void clang_CFG_setIndirectGotoBlock(CXCFG G, CXCFGBlock B);

// The first and last entry of the graph's block list — clang::CFG::front /
// clang::CFG::back, i.e. the same blocks as clang_CFG_getBlock at index 0 and
// clang_CFG_getNumBlocks() - 1. PARTIAL: both dereference a list element with no
// emptiness check, so the graph must hold at least one block.
CXCFGBlock clang_CFG_front(CXCFG G);

CXCFGBlock clang_CFG_back(CXCFG G);
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

// Try-dispatch block count+index access (MARSHALLING.md §6); TryDispatchBlocks is a
// random-access std::vector, so index i is try_blocks_begin() + i. // helper
unsigned clang_CFG_getNumTryBlocks(CXCFG G);

CXCFGBlock clang_CFG_getTryBlock(CXCFG G, unsigned I); // helper
// addSyntheticDeclStmt / synthetic_stmts / synthetic_stmt_begin /
// synthetic_stmt_end

void clang_CFG_addTryDispatchBlock(CXCFG G, CXCFGBlock Block);

// PARTIAL: clang::CFG::addSyntheticDeclStmt asserts that Synthetic is a
// single-declaration DeclStmt, that it differs from Source, and that it is not
// already in the map; the Julia wrapper restates all three.
void clang_CFG_addSyntheticDeclStmt(CXCFG G, CXDeclStmt Synthetic, CXDeclStmt Source);

// The synthetic-DeclStmt map is a llvm::DenseMap with no stable iteration order, so
// it is exposed as a size plus a by-key lookup rather than count+index: the source
// DeclStmt that Synthetic was synthesized from, NULL when it is not in the map.
unsigned clang_CFG_getNumSyntheticDeclStmts(CXCFG G); // helper

CXDeclStmt clang_CFG_getSyntheticDeclStmtSource(CXCFG G, CXDeclStmt Synthetic); // helper
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
