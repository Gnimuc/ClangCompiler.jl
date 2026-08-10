#include "clang-ex/ExtractAPI/CXExtractAPIAction.h"

#include "clang/ExtractAPI/FrontendActions.h"
#include "clang/Frontend/FrontendAction.h"

#include <memory>

CXFrontendAction clang_ExtractAPIAction_create(void) {
  auto A = std::make_unique<clang::ExtractAPIAction>();
  // Implicit derived-to-base conversion, not a cast: the handle is declared at
  // FrontendAction, so the pointer that crosses has to be one.
  clang::FrontendAction *Base = A.release();
  return reinterpret_cast<CXFrontendAction>(Base);
}

void clang_ExtractAPIAction_dispose(CXFrontendAction FA) {
  delete reinterpret_cast<clang::FrontendAction *>(FA);
}
