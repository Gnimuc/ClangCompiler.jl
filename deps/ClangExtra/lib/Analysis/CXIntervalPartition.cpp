#include "clang-ex/Analysis/CXIntervalPartition.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/Analyses/IntervalPartition.h"
#include <optional>

unsigned clang_getIntervalWTO(CXCFG G, CXCFGBlock *Buf, unsigned N, bool *Found) {
  std::optional<clang::WeakTopologicalOrdering> WTO =
      clang::getIntervalWTO(*reinterpret_cast<clang::CFG *>(G));
  if (Found)
    *Found = WTO.has_value();
  if (!WTO)
    return 0;
  unsigned Count = 0;
  for (const clang::CFGBlock *B : *WTO) {
    if (Count < N)
      Buf[Count] = reinterpret_cast<CXCFGBlock>(const_cast<clang::CFGBlock *>(B));
    ++Count;
  }
  return Count;
}
