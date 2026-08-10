#ifndef LLVM_CLANG_C_EXTRA_CXDOMINATORS_H
#define LLVM_CLANG_C_EXTRA_CXDOMINATORS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CFGDominatorTreeImpl
// clang::CFGDominatorTreeImpl is a class template, but clang/Analysis/Analyses/Dominators.h
// itself names the only two instantiations that exist — CFGDomTree
// (CFGDominatorTreeImpl<false>) and CFGPostDomTree (CFGDominatorTreeImpl<true>) — and
// exports an anchor() for each, so the shim wraps those two aliases rather than inventing
// a template surface. The two families below are the same method set, except that
// isReachableFromEntry exists only on the forward tree: llvm's own accessor opens with
// assert(!isPostDominator()).
//
// Both trees hold a bare CFG * and DomTreeNodes keyed on CFGBlock *, so a tree must not
// outlive the CXCFG it was built from, and clang_CFG_dispose invalidates it.

// CFGDomTree

// clang::CFGDominatorTreeImpl<false>'s CFG * constructor. G must not be NULL
// (buildDominatorTree asserts it). The default constructor is deliberately not exposed:
// it leaves the class's `cfg` member uninitialized, so clang_CFGDomTree_getCFG and
// clang_CFGDomTree_dump would read garbage until buildDominatorTree ran. The tree is
// CALLER-OWNED — pair with clang_CFGDomTree_dispose.
CXCFGDomTree clang_CFGDomTree_create(CXCFG G);

void clang_CFGDomTree_dispose(CXCFGDomTree DT);

// getBase (the llvm::DominatorTreeBase the two helpers below reach through)

// The CFG the tree was last built for; BORROWED, never disposed through this handle.
CXCFG clang_CFGDomTree_getCFG(CXCFGDomTree DT);

// The root of the tree — for a forward tree, the CFG's entry block. PARTIAL:
// llvm::DominatorTreeBase::getRoot asserts there is exactly one root, so gate on
// clang_CFGDomTree_getNumRoots() == 1 (which a forward tree always satisfies).
CXCFGBlock clang_CFGDomTree_getRoot(CXCFGDomTree DT);

// getRootNode (llvm::DomTreeNodeBase has no CX handle)

// llvm::DominatorTreeBase::root_size — the gate for clang_CFGDomTree_getRoot. // helper
unsigned clang_CFGDomTree_getNumRoots(CXCFGDomTree DT);

// Whether B has a node in the tree — llvm::DominatorTreeBase::getNode != nullptr. It is
// the gate for clang_CFGDomTree_findNearestCommonDominator (which asserts both operands
// are in the tree) and for clang_CFGDomTree_dump (which dereferences the node of every
// block of the CFG). A block the dominator-tree builder never reached — unreachable code
// the CFG still carries — has no node. // helper
bool clang_CFGDomTree_hasNode(CXCFGDomTree DT, CXCFGBlock B);

// compare: uninstantiable in clang 18. clang::CFGDominatorTreeImpl::compare is declared
// const but calls the non-const getRootNode(), so the template body only fails when a
// caller forces the instantiation — which no in-tree caller does. Wrapping it does not
// compile; the same applies to the post-dominator alias below.

// Rebuild the tree for G, which becomes the tree's CFG. G must not be NULL.
void clang_CFGDomTree_buildDominatorTree(CXCFGDomTree DT, CXCFG G);

// clang::CFGDominatorTreeImpl::dump — one "(block id,immediate dominator id)" line per
// block, on llvm::errs(). PARTIAL: it dereferences the tree node of every block of the
// CFG with no null check, so every block must satisfy clang_CFGDomTree_hasNode.
void clang_CFGDomTree_dump(CXCFGDomTree DT);

// Whether A dominates B — every path from the entry to B goes through A. A block
// dominates itself. Total: an operand with no tree node is treated as unreachable, which
// everything dominates and which dominates nothing.
bool clang_CFGDomTree_dominates(CXCFGDomTree DT, CXCFGBlock A, CXCFGBlock B);

// clang_CFGDomTree_dominates with the reflexive case removed: false when A == B.
bool clang_CFGDomTree_properlyDominates(CXCFGDomTree DT, CXCFGBlock A, CXCFGBlock B);

// The nearest block that dominates both A and B. PARTIAL: llvm asserts that A and B are
// non-NULL, belong to the same CFG, and both have a tree node
// (clang_CFGDomTree_hasNode).
CXCFGBlock clang_CFGDomTree_findNearestCommonDominator(CXCFGDomTree DT, CXCFGBlock A,
                                                       CXCFGBlock B);

// llvm::DominatorTreeBase::changeImmediateDominator. PARTIAL: it asserts that both
// blocks have a tree node (clang_CFGDomTree_hasNode). Mutates the tree only — the CFG is
// untouched, and a later clang_CFGDomTree_buildDominatorTree discards the change.
void clang_CFGDomTree_changeImmediateDominator(CXCFGDomTree DT, CXCFGBlock N,
                                               CXCFGBlock NewIDom);

// Whether A is reachable from the CFG's entry block. Total: a block with no tree node is
// exactly the unreachable case, and reads back false.
bool clang_CFGDomTree_isReachableFromEntry(CXCFGDomTree DT, CXCFGBlock A);

// Drop the computed tree. The CFG pointer survives, so the tree can be rebuilt; every
// query in between behaves as if no block were reachable.
void clang_CFGDomTree_releaseMemory(CXCFGDomTree DT);

// clang::CFGDominatorTreeImpl::print rendered into a CXString. // helper
CXString clang_CFGDomTree_printAsString(CXCFGDomTree DT);

// CFGPostDomTree
// clang::CFGDominatorTreeImpl<true>: the same tree computed on the reversed graph, so
// "A post-dominates B" means every path from B to the exit goes through A. There is no
// isReachableFromEntry here — llvm's accessor asserts it is not called on a post-dominator
// tree.

CXCFGPostDomTree clang_CFGPostDomTree_create(CXCFG G);

void clang_CFGPostDomTree_dispose(CXCFGPostDomTree PDT);

CXCFG clang_CFGPostDomTree_getCFG(CXCFGPostDomTree PDT);

// PARTIAL, and materially so on a post-dominator tree: llvm asserts there is exactly one
// root, and a CFG whose exit is unreachable (an infinite loop) or that has several exits
// gives a different count. Gate on clang_CFGPostDomTree_getNumRoots() == 1.
CXCFGBlock clang_CFGPostDomTree_getRoot(CXCFGPostDomTree PDT);

unsigned clang_CFGPostDomTree_getNumRoots(CXCFGPostDomTree PDT); // helper

bool clang_CFGPostDomTree_hasNode(CXCFGPostDomTree PDT, CXCFGBlock B); // helper

// compare (see clang_CFGDomTree_compare above: uninstantiable in clang 18)

void clang_CFGPostDomTree_buildDominatorTree(CXCFGPostDomTree PDT, CXCFG G);

// PARTIAL for the same reason as clang_CFGDomTree_dump: every block of the CFG must
// satisfy clang_CFGPostDomTree_hasNode.
void clang_CFGPostDomTree_dump(CXCFGPostDomTree PDT);

bool clang_CFGPostDomTree_dominates(CXCFGPostDomTree PDT, CXCFGBlock A, CXCFGBlock B);

bool clang_CFGPostDomTree_properlyDominates(CXCFGPostDomTree PDT, CXCFGBlock A,
                                            CXCFGBlock B);

CXCFGBlock clang_CFGPostDomTree_findNearestCommonDominator(CXCFGPostDomTree PDT,
                                                           CXCFGBlock A, CXCFGBlock B);

void clang_CFGPostDomTree_changeImmediateDominator(CXCFGPostDomTree PDT, CXCFGBlock N,
                                                   CXCFGBlock NewIDom);

// isReachableFromEntry is not wrapped for the post-dominator tree: llvm's accessor opens
// with assert(!this->isPostDominator()).

void clang_CFGPostDomTree_releaseMemory(CXCFGPostDomTree PDT);

CXString clang_CFGPostDomTree_printAsString(CXCFGPostDomTree PDT); // helper

// ControlDependencyCalculator
// A post-dominator tree plus llvm's iterated-dominance-frontier calculator over it: B is
// a control dependency of A when B's branch decides whether A executes. Everything is
// inline in clang/Analysis/Analyses/Dominators.h over llvm::IDFCalculatorBase, so it
// compiles into this library rather than resolving against libclang-cpp.

// G must not be NULL — the embedded CFGPostDomTree's buildDominatorTree asserts it. The
// calculator is CALLER-OWNED, and like the trees above it must not outlive G.
CXControlDependencyCalculator clang_ControlDependencyCalculator_create(CXCFG G);

void clang_ControlDependencyCalculator_dispose(CXControlDependencyCalculator CDC);

// The post-dominator tree the calculator computes over; BORROWED, owned by the
// calculator — never pass it to clang_CFGPostDomTree_dispose.
CXCFGPostDomTree
clang_ControlDependencyCalculator_getCFGPostDomTree(CXControlDependencyCalculator CDC);

// The control dependencies of A, as the count+fill pair of MARSHALLING.md §6: the set is
// a llvm::SmallVector computed lazily and then memoized, so the count call and the fill
// call agree, and no slot is ever NULL. A must be a block of the CFG the calculator was
// built from. // helper
unsigned
clang_ControlDependencyCalculator_getNumControlDependencies(CXControlDependencyCalculator CDC,
                                                            CXCFGBlock A);

void
clang_ControlDependencyCalculator_getControlDependencies(CXControlDependencyCalculator CDC,
                                                         CXCFGBlock A, CXCFGBlock *Buf,
                                                         unsigned N); // helper

// Whether B is one of A's control dependencies. Both must be blocks of the calculator's
// CFG.
bool clang_ControlDependencyCalculator_isControlDependent(CXControlDependencyCalculator CDC,
                                                          CXCFGBlock A, CXCFGBlock B);

// clang::ControlDependencyCalculator::dump — one "(block id,dependency id)" line per
// dependency, on llvm::errs().
void clang_ControlDependencyCalculator_dump(CXControlDependencyCalculator CDC);

LLVM_CLANG_C_EXTERN_C_END

#endif
