#ifndef LLVM_CLANG_C_EXTRA_CXCALLGRAPH_H
#define LLVM_CLANG_C_EXTRA_CXCALLGRAPH_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CallGraph

// clang::CallGraph is a RecursiveASTVisitor subclass whose only visitor entry point is
// addToCallGraph; the traversal is a fixed use inside this library's translation unit, not
// something a caller can extend, so instantiating it here stays on the right side of
// MARSHALLING.md §10. The graph is CALLER-OWNED — pair with clang_CallGraph_dispose — and
// it owns every CXCallGraphNode it hands out: those handles are interior and die with it.
// The Decls and Exprs it points at belong to the ASTContext that was parsed, so the graph
// must not outlive that context.
CXCallGraph clang_CallGraph_create(void);

void clang_CallGraph_dispose(CXCallGraph CG);

// clang::CallGraph::addToCallGraph — walk D (recursively, including template
// instantiations and implicit code) and add every function definition it contains, plus
// the calls their bodies make. Pass the TranslationUnitDecl to graph a whole TU. May be
// called more than once; the graph accumulates.
void clang_CallGraph_addToCallGraph(CXCallGraph CG, CXDecl D);

// Static clang::CallGraph::includeInGraph — whether D is a definition the graph would take
// as a node of its own. PARTIAL: it opens with assert(D) and then reads D's body and
// source location, so D must not be NULL.
bool clang_CallGraph_includeInGraph(CXDecl D);

// Static clang::CallGraph::includeCalleeInGraph — the same test relaxed to permit a
// declaration without a definition, which is what a callee edge may point at. D must not
// be NULL.
bool clang_CallGraph_includeCalleeInGraph(CXDecl D);

// The node for D, or NULL when D has none. NOTE: unlike clang_CallGraph_getOrInsertNode
// this does NOT canonicalize D first, so a non-canonical redeclaration of a graphed
// function misses.
CXCallGraphNode clang_CallGraph_getNode(CXCallGraph CG, CXDecl D);

// The node for D, created (and linked as a callee of the root) if the graph has none.
// D is canonicalized first, except for an ObjCMethodDecl. Passing NULL returns the root
// node, which is the entry clang itself stores under the null key.
CXCallGraphNode clang_CallGraph_getOrInsertNode(CXCallGraph CG, CXDecl D);

// begin / end (FunctionMap iterators — a llvm::DenseMap, so no stable order; use
// clang_CallGraph_getNodes below)

// The number of nodes in the graph, the root node included.
unsigned clang_CallGraph_size(CXCallGraph CG);

// The virtual root: a node with no Decl, whose callees are every function the graph knows
// about that could be called from outside. Interior to the graph, never disposed.
CXCallGraphNode clang_CallGraph_getRoot(CXCallGraph CG);

// nodes_iterator / const_nodes_iterator (the parentless-node walk; not wrapped)

// clang::CallGraph::print rendered into a CXString. // helper
CXString clang_CallGraph_printAsString(CXCallGraph CG);

void clang_CallGraph_dump(CXCallGraph CG);

// viewGraph (spawns an external graphviz viewer)

// clang::CallGraph::addNodesForBlocks — add a node for every BlockDecl declared directly
// inside D. addToCallGraph already does this for each function it visits.
void clang_CallGraph_addNodesForBlocks(CXCallGraph CG, CXDeclContext D);

// VisitFunctionDecl / VisitObjCMethodDecl / TraverseStmt / shouldWalkTypesOfTypeLocs /
// shouldVisitTemplateInstantiations / shouldVisitImplicitCode (the RecursiveASTVisitor
// hooks that clang_CallGraph_addToCallGraph drives)

// The whole node set as one flat array (count+fill, MARSHALLING.md §6): the count is
// clang_CallGraph_size, Buf receives min(N, size) nodes, and no slot is ever NULL. The
// backing container is a llvm::DenseMap, so the ORDER IS UNSPECIFIED and must not be
// relied on — only the set is meaningful. The root node is one of the entries; it is the
// one whose clang_CallGraphNode_getDecl is NULL. // helper
void clang_CallGraph_getNodes(CXCallGraph CG, CXCallGraphNode *Buf, unsigned N);

// CallGraphNode
// A CallGraphNode is owned by the CallGraph that created it and is invalidated by
// clang_CallGraph_dispose; it is never disposed on its own.

// CallRecord (the {Callee, CallExpr} pair) is flattened into the two indexed accessors
// below (MARSHALLING.md §7).

// begin / end / callees (iterator surface: use size + the indexed accessors below)

bool clang_CallGraphNode_empty(CXCallGraphNode N);

unsigned clang_CallGraphNode_size(CXCallGraphNode N);

// The destination of the I-th callee edge, 0 <= I < clang_CallGraphNode_size. Never NULL.
// // helper
CXCallGraphNode clang_CallGraphNode_getCallee(CXCallGraphNode N, unsigned I);

// The call expression that produced the I-th callee edge, 0 <= I < size. NULL for the
// root node's edges, which clang creates with no call site. // helper
CXExpr clang_CallGraphNode_getCallExpr(CXCallGraphNode N, unsigned I);

// clang::CallGraphNode::addCallee, with the CallRecord flattened into its two members.
// Callee must not be NULL; CallExpr may be.
void clang_CallGraphNode_addCallee(CXCallGraphNode N, CXCallGraphNode Callee,
                                   CXExpr CallExpr);

// The function/method this node stands for. NULL for the graph's virtual root.
CXDecl clang_CallGraphNode_getDecl(CXCallGraphNode N);

// clang::CallGraphNode::getDefinition — the defining FunctionDecl of this node's Decl.
// clang's own accessor dereferences both getDecl() and getAsFunction() unguarded, so the
// shim guards them: NULL for the root node (no Decl) and for a node whose Decl is not a
// function (an ObjCMethodDecl or a BlockDecl), as well as for a function with no
// definition in this TU.
CXFunctionDecl clang_CallGraphNode_getDefinition(CXCallGraphNode N);

// clang::CallGraphNode::print rendered into a CXString: the qualified name of the node's
// Decl, or "< >" for the root. // helper
CXString clang_CallGraphNode_printAsString(CXCallGraphNode N);

void clang_CallGraphNode_dump(CXCallGraphNode N);

LLVM_CLANG_C_EXTERN_C_END

#endif
