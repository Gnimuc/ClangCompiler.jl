#include "clang-ex/Analysis/CXCloneDetection.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Stmt.h"
#include "clang/Analysis/CloneDetection.h"
#include "clang/Basic/SourceLocation.h"
#include <memory>
#include <vector>

namespace {

// What CXCloneDetector actually points at. clang::CloneDetector::findClones writes its
// clone groups into a std::vector the caller supplies and keeps no copy, so the handle has
// to stand for the detector and that vector together — otherwise the results would die
// before the first accessor ran.
struct CloneDetectorState {
  clang::CloneDetector Detector;
  std::vector<clang::CloneDetector::CloneGroup> Results;
};

const clang::StmtSequence &getClone(CXCloneDetector CD, unsigned G, unsigned I) {
  return reinterpret_cast<CloneDetectorState *>(CD)->Results[G][I];
}

} // namespace

// CloneDetector

CXCloneDetector clang_CloneDetector_create(void) {
  return reinterpret_cast<CXCloneDetector>(std::make_unique<CloneDetectorState>().release());
}

void clang_CloneDetector_dispose(CXCloneDetector CD) {
  delete reinterpret_cast<CloneDetectorState *>(CD);
}

void clang_CloneDetector_analyzeCodeBody(CXCloneDetector CD, CXDecl D) {
  reinterpret_cast<CloneDetectorState *>(CD)->Detector.analyzeCodeBody(
      reinterpret_cast<clang::Decl *>(D));
}

// constrainClones

void clang_CloneDetector_findClones(CXCloneDetector CD, unsigned MinComplexity,
                                    unsigned MinGroupSize) {
  auto *State = reinterpret_cast<CloneDetectorState *>(CD);
  State->Results.clear();
  State->Detector.findClones(State->Results,
                             clang::RecursiveCloneTypeIIHashConstraint(),
                             clang::MinComplexityConstraint(MinComplexity),
                             clang::MinGroupSizeConstraint(MinGroupSize),
                             clang::RecursiveCloneTypeIIVerifyConstraint(),
                             clang::OnlyLargestCloneConstraint());
}

unsigned clang_CloneDetector_getNumCloneGroups(CXCloneDetector CD) {
  return reinterpret_cast<CloneDetectorState *>(CD)->Results.size();
}

unsigned clang_CloneDetector_getCloneGroupSize(CXCloneDetector CD, unsigned G) {
  return reinterpret_cast<CloneDetectorState *>(CD)->Results[G].size();
}

// StmtSequence

CXDecl clang_CloneDetector_getCloneContainingDecl(CXCloneDetector CD, unsigned G,
                                                  unsigned I) {
  return reinterpret_cast<CXDecl>(
      const_cast<clang::Decl *>(getClone(CD, G, I).getContainingDecl()));
}

unsigned clang_CloneDetector_getCloneNumStmts(CXCloneDetector CD, unsigned G, unsigned I) {
  return getClone(CD, G, I).size();
}

bool clang_CloneDetector_cloneHoldsSequence(CXCloneDetector CD, unsigned G, unsigned I) {
  return getClone(CD, G, I).holdsSequence();
}

CXStmt clang_CloneDetector_getCloneStmt(CXCloneDetector CD, unsigned G, unsigned I,
                                        unsigned J) {
  return reinterpret_cast<CXStmt>(
      const_cast<clang::Stmt *>(getClone(CD, G, I).begin()[J]));
}

CXSourceRange_ clang_CloneDetector_getCloneSourceRange(CXCloneDetector CD, unsigned G,
                                                       unsigned I) {
  const clang::StmtSequence &Seq = getClone(CD, G, I);
  clang::SourceRange Rng;
  if (!Seq.empty())
    Rng = Seq.getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(Rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(Rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_CloneDetector_cloneContains(CXCloneDetector CD, unsigned G, unsigned I,
                                       unsigned OtherG, unsigned OtherI) {
  const clang::StmtSequence &Seq = getClone(CD, G, I);
  const clang::StmtSequence &Other = getClone(CD, OtherG, OtherI);
  if (Seq.empty() || Other.empty())
    return false;
  return Seq.contains(Other);
}
