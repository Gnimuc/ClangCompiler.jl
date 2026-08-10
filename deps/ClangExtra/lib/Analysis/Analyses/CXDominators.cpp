#include "clang-ex/Analysis/Analyses/CXDominators.h"
#include "utils.h"
#include "clang/Analysis/Analyses/Dominators.h"
#include "clang/Analysis/CFG.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <string>

// CFGDomTree

CXCFGDomTree clang_CFGDomTree_create(CXCFG G) {
  return reinterpret_cast<CXCFGDomTree>(
      std::make_unique<clang::CFGDomTree>(reinterpret_cast<clang::CFG *>(G)).release());
}

void clang_CFGDomTree_dispose(CXCFGDomTree DT) {
  delete reinterpret_cast<clang::CFGDomTree *>(DT);
}

// getBase

CXCFG clang_CFGDomTree_getCFG(CXCFGDomTree DT) {
  return reinterpret_cast<CXCFG>(reinterpret_cast<clang::CFGDomTree *>(DT)->getCFG());
}

CXCFGBlock clang_CFGDomTree_getRoot(CXCFGDomTree DT) {
  return reinterpret_cast<CXCFGBlock>(reinterpret_cast<clang::CFGDomTree *>(DT)->getRoot());
}

// getRootNode

unsigned clang_CFGDomTree_getNumRoots(CXCFGDomTree DT) {
  return reinterpret_cast<clang::CFGDomTree *>(DT)->getBase().root_size();
}

bool clang_CFGDomTree_hasNode(CXCFGDomTree DT, CXCFGBlock B) {
  return reinterpret_cast<clang::CFGDomTree *>(DT)->getBase().getNode(
             reinterpret_cast<clang::CFGBlock *>(B)) != nullptr;
}

// compare

void clang_CFGDomTree_buildDominatorTree(CXCFGDomTree DT, CXCFG G) {
  reinterpret_cast<clang::CFGDomTree *>(DT)->buildDominatorTree(
      reinterpret_cast<clang::CFG *>(G));
}

void clang_CFGDomTree_dump(CXCFGDomTree DT) {
  reinterpret_cast<clang::CFGDomTree *>(DT)->dump();
}

bool clang_CFGDomTree_dominates(CXCFGDomTree DT, CXCFGBlock A, CXCFGBlock B) {
  return reinterpret_cast<clang::CFGDomTree *>(DT)->dominates(
      reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B));
}

bool clang_CFGDomTree_properlyDominates(CXCFGDomTree DT, CXCFGBlock A, CXCFGBlock B) {
  return reinterpret_cast<clang::CFGDomTree *>(DT)->properlyDominates(
      reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B));
}

CXCFGBlock clang_CFGDomTree_findNearestCommonDominator(CXCFGDomTree DT, CXCFGBlock A,
                                                       CXCFGBlock B) {
  return reinterpret_cast<CXCFGBlock>(
      reinterpret_cast<clang::CFGDomTree *>(DT)->findNearestCommonDominator(
          reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B)));
}

void clang_CFGDomTree_changeImmediateDominator(CXCFGDomTree DT, CXCFGBlock N,
                                               CXCFGBlock NewIDom) {
  reinterpret_cast<clang::CFGDomTree *>(DT)->changeImmediateDominator(
      reinterpret_cast<clang::CFGBlock *>(N),
      reinterpret_cast<clang::CFGBlock *>(NewIDom));
}

bool clang_CFGDomTree_isReachableFromEntry(CXCFGDomTree DT, CXCFGBlock A) {
  return reinterpret_cast<clang::CFGDomTree *>(DT)->isReachableFromEntry(
      reinterpret_cast<clang::CFGBlock *>(A));
}

void clang_CFGDomTree_releaseMemory(CXCFGDomTree DT) {
  reinterpret_cast<clang::CFGDomTree *>(DT)->releaseMemory();
}

CXString clang_CFGDomTree_printAsString(CXCFGDomTree DT) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFGDomTree *>(DT)->print(OS);
  return extra::makeCXString(OS.str());
}

// CFGPostDomTree

CXCFGPostDomTree clang_CFGPostDomTree_create(CXCFG G) {
  return reinterpret_cast<CXCFGPostDomTree>(
      std::make_unique<clang::CFGPostDomTree>(reinterpret_cast<clang::CFG *>(G))
          .release());
}

void clang_CFGPostDomTree_dispose(CXCFGPostDomTree PDT) {
  delete reinterpret_cast<clang::CFGPostDomTree *>(PDT);
}

CXCFG clang_CFGPostDomTree_getCFG(CXCFGPostDomTree PDT) {
  return reinterpret_cast<CXCFG>(
      reinterpret_cast<clang::CFGPostDomTree *>(PDT)->getCFG());
}

CXCFGBlock clang_CFGPostDomTree_getRoot(CXCFGPostDomTree PDT) {
  return reinterpret_cast<CXCFGBlock>(
      reinterpret_cast<clang::CFGPostDomTree *>(PDT)->getRoot());
}

unsigned clang_CFGPostDomTree_getNumRoots(CXCFGPostDomTree PDT) {
  return reinterpret_cast<clang::CFGPostDomTree *>(PDT)->getBase().root_size();
}

bool clang_CFGPostDomTree_hasNode(CXCFGPostDomTree PDT, CXCFGBlock B) {
  return reinterpret_cast<clang::CFGPostDomTree *>(PDT)->getBase().getNode(
             reinterpret_cast<clang::CFGBlock *>(B)) != nullptr;
}

// compare

void clang_CFGPostDomTree_buildDominatorTree(CXCFGPostDomTree PDT, CXCFG G) {
  reinterpret_cast<clang::CFGPostDomTree *>(PDT)->buildDominatorTree(
      reinterpret_cast<clang::CFG *>(G));
}

void clang_CFGPostDomTree_dump(CXCFGPostDomTree PDT) {
  reinterpret_cast<clang::CFGPostDomTree *>(PDT)->dump();
}

bool clang_CFGPostDomTree_dominates(CXCFGPostDomTree PDT, CXCFGBlock A, CXCFGBlock B) {
  return reinterpret_cast<clang::CFGPostDomTree *>(PDT)->dominates(
      reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B));
}

bool clang_CFGPostDomTree_properlyDominates(CXCFGPostDomTree PDT, CXCFGBlock A,
                                            CXCFGBlock B) {
  return reinterpret_cast<clang::CFGPostDomTree *>(PDT)->properlyDominates(
      reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B));
}

CXCFGBlock clang_CFGPostDomTree_findNearestCommonDominator(CXCFGPostDomTree PDT,
                                                           CXCFGBlock A, CXCFGBlock B) {
  return reinterpret_cast<CXCFGBlock>(
      reinterpret_cast<clang::CFGPostDomTree *>(PDT)->findNearestCommonDominator(
          reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B)));
}

void clang_CFGPostDomTree_changeImmediateDominator(CXCFGPostDomTree PDT, CXCFGBlock N,
                                                   CXCFGBlock NewIDom) {
  reinterpret_cast<clang::CFGPostDomTree *>(PDT)->changeImmediateDominator(
      reinterpret_cast<clang::CFGBlock *>(N),
      reinterpret_cast<clang::CFGBlock *>(NewIDom));
}

void clang_CFGPostDomTree_releaseMemory(CXCFGPostDomTree PDT) {
  reinterpret_cast<clang::CFGPostDomTree *>(PDT)->releaseMemory();
}

CXString clang_CFGPostDomTree_printAsString(CXCFGPostDomTree PDT) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CFGPostDomTree *>(PDT)->print(OS);
  return extra::makeCXString(OS.str());
}

// ControlDependencyCalculator

CXControlDependencyCalculator clang_ControlDependencyCalculator_create(CXCFG G) {
  return reinterpret_cast<CXControlDependencyCalculator>(
      std::make_unique<clang::ControlDependencyCalculator>(
          reinterpret_cast<clang::CFG *>(G))
          .release());
}

void clang_ControlDependencyCalculator_dispose(CXControlDependencyCalculator CDC) {
  delete reinterpret_cast<clang::ControlDependencyCalculator *>(CDC);
}

CXCFGPostDomTree
clang_ControlDependencyCalculator_getCFGPostDomTree(CXControlDependencyCalculator CDC) {
  return reinterpret_cast<CXCFGPostDomTree>(const_cast<clang::CFGPostDomTree *>(
      &reinterpret_cast<clang::ControlDependencyCalculator *>(CDC)->getCFGPostDomTree()));
}

unsigned clang_ControlDependencyCalculator_getNumControlDependencies(
    CXControlDependencyCalculator CDC, CXCFGBlock A) {
  return reinterpret_cast<clang::ControlDependencyCalculator *>(CDC)
      ->getControlDependencies(reinterpret_cast<clang::CFGBlock *>(A))
      .size();
}

void clang_ControlDependencyCalculator_getControlDependencies(
    CXControlDependencyCalculator CDC, CXCFGBlock A, CXCFGBlock *Buf, unsigned N) {
  if (!Buf)
    return;
  const auto &Deps = reinterpret_cast<clang::ControlDependencyCalculator *>(CDC)
                         ->getControlDependencies(reinterpret_cast<clang::CFGBlock *>(A));
  unsigned Count = Deps.size() < N ? static_cast<unsigned>(Deps.size()) : N;
  for (unsigned I = 0; I < Count; ++I)
    Buf[I] = reinterpret_cast<CXCFGBlock>(Deps[I]);
}

bool clang_ControlDependencyCalculator_isControlDependent(
    CXControlDependencyCalculator CDC, CXCFGBlock A, CXCFGBlock B) {
  return reinterpret_cast<clang::ControlDependencyCalculator *>(CDC)->isControlDependent(
      reinterpret_cast<clang::CFGBlock *>(A), reinterpret_cast<clang::CFGBlock *>(B));
}

void clang_ControlDependencyCalculator_dump(CXControlDependencyCalculator CDC) {
  reinterpret_cast<clang::ControlDependencyCalculator *>(CDC)->dump();
}
