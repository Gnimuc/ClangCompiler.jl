#ifndef LLVM_CLANG_C_EXTRA_CXCFGREACHABILITYANALYSIS_H
#define LLVM_CLANG_C_EXTRA_CXCFGREACHABILITYANALYSIS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CFGReverseBlockReachabilityAnalysis
// Block-to-block reachability over one CFG, with a per-destination cache filled lazily by
// a reverse (predecessor) search. The same object is also reachable BORROWED, without a
// create/dispose of its own, as clang_AnalysisDeclContext_getCFGReachablityAnalysis.

// CALLER-OWNED — pair with clang_CFGReverseBlockReachabilityAnalysis_dispose. The analysis
// keeps no reference to G beyond its block count, but every block later handed to
// isReachable has to come from G.
CXCFGReverseBlockReachabilityAnalysis
clang_CFGReverseBlockReachabilityAnalysis_create(CXCFG G);

void clang_CFGReverseBlockReachabilityAnalysis_dispose(
    CXCFGReverseBlockReachabilityAnalysis A);

// Whether Dst can be reached from Src. PARTIAL: clang indexes two llvm::BitVectors with
// Src->getBlockID() and Dst->getBlockID(), both sized from the CFG the analysis was
// constructed over and neither bounds-checked, so both blocks must belong to that graph.
bool clang_CFGReverseBlockReachabilityAnalysis_isReachable(
    CXCFGReverseBlockReachabilityAnalysis A, CXCFGBlock Src, CXCFGBlock Dst);

// mapReachability (private)

LLVM_CLANG_C_EXTERN_C_END

#endif
