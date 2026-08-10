#include "clang-ex/Analysis/CXCFGReachabilityAnalysis.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/Analyses/CFGReachabilityAnalysis.h"
#include <memory>

// CFGReverseBlockReachabilityAnalysis

CXCFGReverseBlockReachabilityAnalysis
clang_CFGReverseBlockReachabilityAnalysis_create(CXCFG G) {
  return reinterpret_cast<CXCFGReverseBlockReachabilityAnalysis>(
      std::make_unique<clang::CFGReverseBlockReachabilityAnalysis>(
          *reinterpret_cast<clang::CFG *>(G))
          .release());
}

void clang_CFGReverseBlockReachabilityAnalysis_dispose(
    CXCFGReverseBlockReachabilityAnalysis A) {
  delete reinterpret_cast<clang::CFGReverseBlockReachabilityAnalysis *>(A);
}

bool clang_CFGReverseBlockReachabilityAnalysis_isReachable(
    CXCFGReverseBlockReachabilityAnalysis A, CXCFGBlock Src, CXCFGBlock Dst) {
  return reinterpret_cast<clang::CFGReverseBlockReachabilityAnalysis *>(A)->isReachable(
      reinterpret_cast<clang::CFGBlock *>(Src), reinterpret_cast<clang::CFGBlock *>(Dst));
}

// mapReachability
