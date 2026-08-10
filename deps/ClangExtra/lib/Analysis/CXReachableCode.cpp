#include "clang-ex/Analysis/CXReachableCode.h"
#include "clang/Analysis/AnalysisDeclContext.h"
#include "clang/Analysis/CFG.h"
#include "clang/Analysis/Analyses/ReachableCode.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/ADT/BitVector.h"
#include <memory>
#include <vector>

namespace {

// One clang::reachable_code::Callback::HandleUnreachable report, copied out of the
// arguments it is handed.
struct UnreachableRecord {
  clang::reachable_code::UnreachableKind UK = clang::reachable_code::UK_Other;
  clang::SourceLocation L;
  clang::SourceRange ConditionVal;
  clang::SourceRange R1;
  clang::SourceRange R2;
  bool HasFallThroughAttr = false;
};

struct UnreachableCodeResult {
  std::vector<UnreachableRecord> Records;
};

// The one fixed callback subclass the shim compiles: it records instead of diagnosing.
class CollectingCallback : public clang::reachable_code::Callback {
  UnreachableCodeResult &R;

public:
  explicit CollectingCallback(UnreachableCodeResult &R) : R(R) {}

  void HandleUnreachable(clang::reachable_code::UnreachableKind UK, clang::SourceLocation L,
                         clang::SourceRange ConditionVal, clang::SourceRange R1,
                         clang::SourceRange R2, bool HasFallThroughAttr) override {
    UnreachableRecord Rec;
    Rec.UK = UK;
    Rec.L = L;
    Rec.ConditionVal = ConditionVal;
    Rec.R1 = R1;
    Rec.R2 = R2;
    Rec.HasFallThroughAttr = HasFallThroughAttr;
    R.Records.push_back(Rec);
  }
};

CXSourceRange_ makeRange(clang::SourceRange SR) {
  return CXSourceRange_{
      reinterpret_cast<CXSourceLocation_>(SR.getBegin().getPtrEncoding()),
      reinterpret_cast<CXSourceLocation_>(SR.getEnd().getPtrEncoding())};
}

} // namespace

unsigned clang_reachable_code_ScanReachableFromBlock(CXCFGBlock Start, CXCFGBlock *Buf,
                                                     unsigned N) {
  clang::CFGBlock *B = reinterpret_cast<clang::CFGBlock *>(Start);
  clang::CFG *G = B->getParent();
  llvm::BitVector Reachable(G->getNumBlockIDs(), false);
  clang::reachable_code::ScanReachableFromBlock(B, Reachable);
  unsigned Count = 0;
  for (clang::CFG::iterator I = G->begin(), E = G->end(); I != E; ++I) {
    clang::CFGBlock *Block = *I;
    if (!Block || !Reachable[Block->getBlockID()])
      continue;
    if (Count < N)
      Buf[Count] = reinterpret_cast<CXCFGBlock>(Block);
    ++Count;
  }
  return Count;
}

CXUnreachableCodeResult clang_UnreachableCodeResult_create(CXAnalysisDeclContext ADC,
                                                           CXPreprocessor PP) {
  auto R = std::make_unique<UnreachableCodeResult>();
  CollectingCallback CB(*R);
  clang::reachable_code::FindUnreachableCode(
      *reinterpret_cast<clang::AnalysisDeclContext *>(ADC),
      *reinterpret_cast<clang::Preprocessor *>(PP), CB);
  return reinterpret_cast<CXUnreachableCodeResult>(R.release());
}

void clang_UnreachableCodeResult_dispose(CXUnreachableCodeResult R) {
  delete reinterpret_cast<UnreachableCodeResult *>(R);
}

unsigned clang_UnreachableCodeResult_getNumUnreachable(CXUnreachableCodeResult R) {
  return static_cast<unsigned>(
      reinterpret_cast<UnreachableCodeResult *>(R)->Records.size());
}

CXUnreachableKind clang_UnreachableCodeResult_getKind(CXUnreachableCodeResult R,
                                                      unsigned I) {
  return static_cast<CXUnreachableKind>(
      reinterpret_cast<UnreachableCodeResult *>(R)->Records[I].UK);
}

CXSourceLocation_ clang_UnreachableCodeResult_getLocation(CXUnreachableCodeResult R,
                                                          unsigned I) {
  return reinterpret_cast<CXSourceLocation_>(
      reinterpret_cast<UnreachableCodeResult *>(R)->Records[I].L.getPtrEncoding());
}

CXSourceRange_ clang_UnreachableCodeResult_getConditionValRange(CXUnreachableCodeResult R,
                                                                unsigned I) {
  return makeRange(reinterpret_cast<UnreachableCodeResult *>(R)->Records[I].ConditionVal);
}

CXSourceRange_ clang_UnreachableCodeResult_getR1(CXUnreachableCodeResult R, unsigned I) {
  return makeRange(reinterpret_cast<UnreachableCodeResult *>(R)->Records[I].R1);
}

CXSourceRange_ clang_UnreachableCodeResult_getR2(CXUnreachableCodeResult R, unsigned I) {
  return makeRange(reinterpret_cast<UnreachableCodeResult *>(R)->Records[I].R2);
}

bool clang_UnreachableCodeResult_getHasFallThroughAttr(CXUnreachableCodeResult R,
                                                       unsigned I) {
  return reinterpret_cast<UnreachableCodeResult *>(R)->Records[I].HasFallThroughAttr;
}
