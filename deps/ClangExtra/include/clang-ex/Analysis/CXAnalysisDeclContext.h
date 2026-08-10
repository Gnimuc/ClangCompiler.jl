#ifndef LLVM_CLANG_C_EXTRA_CXANALYSISDECLCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXANALYSISDECLCONTEXT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// AnalysisDeclContext is the per-Decl hub of clang's flow analyses: it owns the Decl's
// CFG, the Stmt->CFGBlock map over that CFG, the ParentMap of its body, and the reverse
// block-reachability analysis, all built lazily on first request and cached. Every
// analysis in clang/Analysis/Analyses is entered through one of these.
//
// Two satellite classes are reachable ONLY as borrowed views onto an AnalysisDeclContext's
// cache, so they are declared here rather than in file pairs of their own:
// clang/Analysis/CFGStmtMap.h and clang/AST/ParentMap.h. Neither is wrapped as an owned
// cluster — there is no _create/_dispose for either, because the context that built one
// deletes it.
//
// ManagedAnalysis (the base of LiveVariables and PostOrderCFGView) and the
// LocationContext / StackFrameContext / BlockInvocationContext / LocationContextManager
// hierarchy are not wrapped.

// AnalysisDeclContext

// A context of its own for D, not registered with any manager — CALLER-OWNED, pair with
// clang_AnalysisDeclContext_dispose. Mgr may be NULL; when it is not, the context borrows
// nothing from the manager but its body-synthesis policy, and the manager does NOT take
// ownership (that only happens through clang_AnalysisDeclContextManager_getContext).
//
// PARTIAL: clang::AnalysisDeclContext::getBody switches on D's kind and ends in
// llvm_unreachable, so every accessor below that reaches the body — getBody, getCFG,
// getUnoptimizedCFG, getCFGStmtMap, getCFGReachablityAnalysis, getParentMap, dumpCFG — is
// undefined unless D is a FunctionDecl, ObjCMethodDecl, BlockDecl or FunctionTemplateDecl.
// The Julia wrapper restates that as the receiver's type.
CXAnalysisDeclContext clang_AnalysisDeclContext_create(CXAnalysisDeclContextManager Mgr,
                                                       CXDecl D);

// The (Mgr, D, const CFG::BuildOptions &) constructor: the new context starts from a copy
// of BuildOptions instead of a default-constructed one. BuildOptions must not be NULL.
// CALLER-OWNED, as above. // helper
CXAnalysisDeclContext clang_AnalysisDeclContext_createWithOptions(
    CXAnalysisDeclContextManager Mgr, CXDecl D, CXCFGBuildOptions BuildOptions);

void clang_AnalysisDeclContext_dispose(CXAnalysisDeclContext ADC);

CXASTContext clang_AnalysisDeclContext_getASTContext(CXAnalysisDeclContext ADC);

CXDecl clang_AnalysisDeclContext_getDecl(CXAnalysisDeclContext ADC);

// NULL for a standalone context.
CXAnalysisDeclContextManager clang_AnalysisDeclContext_getManager(CXAnalysisDeclContext ADC);

// The options this context builds its CFG from. BORROWED — it is a member of the context,
// so never pass it to clang_CFGBuildOptions_dispose, and it dies with the context. Mutating
// it after the CFG has been built (clang_AnalysisDeclContext_isCFGBuilt) changes nothing:
// the graph is cached.
CXCFGBuildOptions clang_AnalysisDeclContext_getCFGBuildOptions(CXAnalysisDeclContext ADC);

bool clang_AnalysisDeclContext_getAddEHEdges(CXAnalysisDeclContext ADC);

bool clang_AnalysisDeclContext_getUseUnoptimizedCFG(CXAnalysisDeclContext ADC);

bool clang_AnalysisDeclContext_getAddImplicitDtors(CXAnalysisDeclContext ADC);

bool clang_AnalysisDeclContext_getAddInitializers(CXAnalysisDeclContext ADC);

// Force the CFG builder to give S a block of its own. Only meaningful before the CFG is
// built.
void clang_AnalysisDeclContext_registerForcedBlockExpression(CXAnalysisDeclContext ADC,
                                                             CXStmt S);

// getBlockForRegisteredExpression is not wrapped: it asserts that S was registered, and
// dereferences a DenseMap end() iterator when it was not, with no public predicate to gate
// it on. Use clang_CFGStmtMap_getBlock instead — a registered expression heads its own
// block, so the map finds it.

// clang::AnalysisDeclContext::getBody. Both overloads are folded into this one entry
// point: IsAutosynthesized may be NULL, in which case the zero-argument overload is
// called; otherwise it receives whether the body came from clang's BodyFarm rather than
// from source. NULL when the Decl has no body.
CXStmt clang_AnalysisDeclContext_getBody(CXAnalysisDeclContext ADC,
                                         bool *IsAutosynthesized);

bool clang_AnalysisDeclContext_isBodyAutosynthesized(CXAnalysisDeclContext ADC);

bool clang_AnalysisDeclContext_isBodyAutosynthesizedFromModelFile(CXAnalysisDeclContext ADC);

// The Decl's control-flow graph, built on first call from
// clang_AnalysisDeclContext_getCFGBuildOptions and cached. BORROWED — owned by the
// context, never pass it to clang_CFG_dispose, and it dies with the context. NULL when the
// Decl has no body or clang cannot build a graph for it.
CXCFG clang_AnalysisDeclContext_getCFG(CXAnalysisDeclContext ADC);

// The Stmt -> CFGBlock map over clang_AnalysisDeclContext_getCFG. BORROWED, as above; NULL
// exactly when getCFG is NULL.
CXCFGStmtMap clang_AnalysisDeclContext_getCFGStmtMap(CXAnalysisDeclContext ADC);

// Block-to-block reachability over clang_AnalysisDeclContext_getCFG. BORROWED, as above;
// NULL exactly when getCFG is NULL. The same class is separately caller-ownable through
// clang_CFGReverseBlockReachabilityAnalysis_create.
CXCFGReverseBlockReachabilityAnalysis
clang_AnalysisDeclContext_getCFGReachablityAnalysis(CXAnalysisDeclContext ADC);

// A second graph of the same body with PruneTriviallyFalseEdges off, cached separately
// from getCFG's. BORROWED, as above.
CXCFG clang_AnalysisDeclContext_getUnoptimizedCFG(CXAnalysisDeclContext ADC);

// PARTIAL: clang::AnalysisDeclContext::dumpCFG dereferences getCFG() with no null check,
// so it is undefined when clang_AnalysisDeclContext_getCFG is NULL.
void clang_AnalysisDeclContext_dumpCFG(CXAnalysisDeclContext ADC, bool ShowColors);

bool clang_AnalysisDeclContext_isCFGBuilt(CXAnalysisDeclContext ADC);

// The parent map of the Decl's body. BORROWED — a member of the context, dies with it.
// PARTIAL: clang::ParentMap holds a null map when it was built from a null Stmt, and every
// ParentMap accessor below dereferences that map, so this is only usable when
// clang_AnalysisDeclContext_getBody is non-NULL.
CXParentMap clang_AnalysisDeclContext_getParentMap(CXAnalysisDeclContext ADC);

// clang::AnalysisDeclContext::getReferencedBlockVars as the count+fill pair of
// MARSHALLING.md §6 — the iterator_range it returns is over a random-access array, but the
// range value type has no CX handle. The count is exact and Buf receives min(N, count)
// VarDecls, none of them NULL. // helper
unsigned clang_AnalysisDeclContext_getNumReferencedBlockVars(CXAnalysisDeclContext ADC,
                                                             CXBlockDecl BD);

void clang_AnalysisDeclContext_getReferencedBlockVars(CXAnalysisDeclContext ADC,
                                                      CXBlockDecl BD, CXVarDecl *Buf,
                                                      unsigned N); // helper

// NULL unless the Decl is an ObjCMethodDecl, or a BlockDecl that captured self.
CXImplicitParamDecl clang_AnalysisDeclContext_getSelfDecl(CXAnalysisDeclContext ADC);

// getStackFrame / getBlockInvocationContext (LocationContext is not wrapped)
// getAnalysis<T> (template — the concrete analyses have their own entry points:
// clang_LiveVariables_computeLiveness, clang_PostOrderCFGView_getBlocksInReversePostOrder)

// Static clang::AnalysisDeclContext::isInStdNamespace.
bool clang_AnalysisDeclContext_isInStdNamespace(CXDecl D);

// Static clang::AnalysisDeclContext::getFunctionName — the qualified, parameterized name
// clang's analysis diagnostics print for D. Empty for a Decl that names no function.
CXString clang_AnalysisDeclContext_getFunctionName(CXDecl D);

// AnalysisDeclContextManager

// The manager caches one AnalysisDeclContext per Decl. Its constructor's thirteen
// CFG-building flags are not parameters here: every one of them is stored into the
// manager's own clang::CFG::BuildOptions, which
// clang_AnalysisDeclContextManager_getCFGBuildOptions hands back mutable, so the
// CXCFGBuildOptions setters cover them all (MARSHALLING.md §7 — a stateful value member
// crosses as a borrowed handle rather than as a parameter list). The manager is created
// with clang's own defaults for those thirteen: PruneTriviallyFalseEdges,
// AddCXXNewAllocator, AddRichCXXConstructors, MarkElidedCXXConstructors and
// AddVirtualBaseBranches on, the rest off. SynthesizeBodies is the one constructor
// argument that is not a BuildOptions field — clang::AnalysisDeclContextManager has no
// setter for it — so it stays a parameter. The CodeInjector argument is always null.
// CALLER-OWNED: pair with clang_AnalysisDeclContextManager_dispose.
CXAnalysisDeclContextManager clang_AnalysisDeclContextManager_create(CXASTContext ASTCtx,
                                                                     bool SynthesizeBodies);

// Deletes the manager AND every AnalysisDeclContext it handed out through
// clang_AnalysisDeclContextManager_getContext.
void clang_AnalysisDeclContextManager_dispose(CXAnalysisDeclContextManager Mgr);

// The context for D, created on first request from the manager's BuildOptions and cached.
// BORROWED: it is owned by the manager, so never pass it to
// clang_AnalysisDeclContext_dispose. For a FunctionDecl, clang first redirects D to the
// redeclaration that carries the body, so two declarations of one function share a context.
CXAnalysisDeclContext clang_AnalysisDeclContextManager_getContext(
    CXAnalysisDeclContextManager Mgr, CXDecl D);

bool clang_AnalysisDeclContextManager_getUseUnoptimizedCFG(CXAnalysisDeclContextManager Mgr);

// The BuildOptions every context this manager creates starts from. BORROWED — a member of
// the manager, never pass it to clang_CFGBuildOptions_dispose. Contexts already handed out
// keep the copy they were created with.
CXCFGBuildOptions clang_AnalysisDeclContextManager_getCFGBuildOptions(
    CXAnalysisDeclContextManager Mgr);

bool clang_AnalysisDeclContextManager_synthesizeBodies(CXAnalysisDeclContextManager Mgr);

// getStackFrame (LocationContext is not wrapped)
// getBodyFarm (BodyFarm is not wrapped)

// Discards every cached AnalysisDeclContext; each handle
// clang_AnalysisDeclContextManager_getContext returned is dangling afterwards.
void clang_AnalysisDeclContextManager_clear(CXAnalysisDeclContextManager Mgr);

// CFGStmtMap (clang/Analysis/CFGStmtMap.h)
// Borrowed satellite of AnalysisDeclContext — see the note at the top of this header.
// Build / ~CFGStmtMap

// The block S appears in, walking up the ParentMap when S itself is not a block-level
// statement. A terminator maps to the block it terminates rather than to the block it is a
// block-level expression of; a CaseStmt or LabelStmt maps to the block it labels. NULL when
// no ancestor of S is in the graph, and NULL for a NULL S.
CXCFGBlock clang_CFGStmtMap_getBlock(CXCFGStmtMap M, CXStmt S);

// ParentMap (clang/AST/ParentMap.h)
// Borrowed satellite of AnalysisDeclContext — see the note at the top of this header. The
// two mutators (addStmt, setParent) are deliberately not wrapped: they rewrite a map the
// AnalysisDeclContext owns and hands to its CFGStmtMap.

// The immediate parent of S in the body this map was built over; NULL for the root and for
// any statement the map never saw.
CXStmt clang_ParentMap_getParent(CXParentMap PM, CXStmt S);

// addStmt / setParent

CXStmt clang_ParentMap_getParentIgnoreParens(CXParentMap PM, CXStmt S);

CXStmt clang_ParentMap_getParentIgnoreParenCasts(CXParentMap PM, CXStmt S);

CXStmt clang_ParentMap_getParentIgnoreParenImpCasts(CXParentMap PM, CXStmt S);

// The outermost ParenExpr of the parenthesis chain S sits in; NULL when no parentheses
// enclose it.
CXStmt clang_ParentMap_getOuterParenParent(CXParentMap PM, CXStmt S);

bool clang_ParentMap_hasParent(CXParentMap PM, CXStmt S);

// Whether E's value is used by its parent rather than discarded.
bool clang_ParentMap_isConsumedExpr(CXParentMap PM, CXExpr E);

LLVM_CLANG_C_EXTERN_C_END

#endif
