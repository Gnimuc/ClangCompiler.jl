#ifndef LLVM_CLANG_C_EXTRA_CXLIVEVARIABLES_H
#define LLVM_CLANG_C_EXTRA_CXLIVEVARIABLES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// LiveVariables (clang/Analysis/Analyses/LiveVariables.h) — the classic backwards dataflow
// over an AnalysisDeclContext's CFG. The result is polled, never pushed: LiveVariables
// itself is a lattice of ImmutableSets with no CX handle, and the three isLive queries are
// the whole read surface.
//
// LiveVariables::LivenessValues (a triple of llvm::ImmutableSet) is not wrapped — the sets
// are only reachable through the Observer callback, which is not wrapped either.

// clang::LiveVariables::computeLiveness. The returned analysis is CALLER-OWNED (the
// std::unique_ptr is released) — pair with clang_LiveVariables_dispose. NULL when ADC has
// no CFG, i.e. when its Decl has no body. killAtAssign true is
// clang::LiveVariables::create, the flavour the analyzer uses, in which assigning to a
// variable kills the value it held; false is clang::RelaxedLiveVariables::create, which
// keeps it live. There is no separate RelaxedLiveVariables handle: the two differ only in
// this flag and in the analysis tag AnalysisDeclContext caches them under, and
// getAnalysis<T> is not wrapped.
CXLiveVariables clang_LiveVariables_computeLiveness(CXAnalysisDeclContext ADC,
                                                    bool killAtAssign);

void clang_LiveVariables_dispose(CXLiveVariables LV);

// Whether D is live at the END of B. B must be a block of the CFG the analysis was
// computed over; clang looks it up in a DenseMap keyed on the block pointer, so a block of
// any other graph is simply absent and reads back as not live.
bool clang_LiveVariables_isLive(CXLiveVariables LV, CXCFGBlock B, CXVarDecl D);

// The (Stmt, VarDecl) overload — whether D is live at the beginning of S. Statement-level
// liveness is only recorded for block-level expressions, and clang's lookup is a
// default-constructing DenseMap probe, so a statement the analysis never recorded reads
// back as not live rather than failing.
bool clang_LiveVariables_isLiveAtStmt(CXLiveVariables LV, CXStmt S, CXVarDecl D);

// The (Stmt, Expr) overload — whether the value of the block-level expression Val is live
// before Loc. Same default-constructing lookup as above.
bool clang_LiveVariables_isExprLiveAtStmt(CXLiveVariables LV, CXStmt Loc, CXExpr Val);

// clang::LiveVariables::dumpBlockLiveness / dumpExprLiveness, written straight to
// llvm::errs().
void clang_LiveVariables_dumpBlockLiveness(CXLiveVariables LV, CXSourceManager M);

void clang_LiveVariables_dumpExprLiveness(CXLiveVariables LV, CXSourceManager M);

// runOnAllBlocks (LiveVariables::Observer is a virtual interface; a Julia implementation of
// it would need a trampoline, and the isLive queries above cover the same information)
// create / getTag (the ManagedAnalysis registration surface; getAnalysis<T> is not wrapped)

LLVM_CLANG_C_EXTERN_C_END

#endif
