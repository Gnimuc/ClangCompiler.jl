#include "clang-ex/StaticAnalyzer/Frontend/CXAnalysisAction.h"

#include "clang/Frontend/FrontendAction.h"
#include "clang/StaticAnalyzer/Frontend/FrontendActions.h"

#include <memory>

CXFrontendAction clang_ento_AnalysisAction_create(void) {
  auto A = std::make_unique<clang::ento::AnalysisAction>();
  // Implicit derived-to-base conversion, not a cast: the handle is declared at
  // FrontendAction, so the pointer that crosses has to be one.
  clang::FrontendAction *Base = A.release();
  return reinterpret_cast<CXFrontendAction>(Base);
}

void clang_ento_AnalysisAction_dispose(CXFrontendAction FA) {
  delete reinterpret_cast<clang::FrontendAction *>(FA);
}
