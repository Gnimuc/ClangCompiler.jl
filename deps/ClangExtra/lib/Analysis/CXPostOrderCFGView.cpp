#include "clang-ex/Analysis/CXPostOrderCFGView.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/Analyses/PostOrderCFGView.h"

// PostOrderCFGView

unsigned clang_PostOrderCFGView_getBlocksInReversePostOrder(CXCFG G, CXCFGBlock *Buf,
                                                            unsigned N) {
  clang::PostOrderCFGView View(reinterpret_cast<clang::CFG *>(G));
  unsigned Count = 0;
  for (const clang::CFGBlock *B : View) {
    if (Count < N)
      Buf[Count] = reinterpret_cast<CXCFGBlock>(const_cast<clang::CFGBlock *>(B));
    ++Count;
  }
  return Count;
}
