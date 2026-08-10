#include "clang-ex/Frontend/CXFrontendActions.h"
#include "clang/Frontend/FrontendActions.h"

#include <memory>

// Each factory names clang::FrontendAction as the unique_ptr's element type, so the
// derived-to-base conversion is the one the unique_ptr converting constructor performs and
// the only cast written is the handle reinterpret. That matters because the handle these
// return is the base one, and it is deleted through clang::FrontendAction's virtual
// destructor by clang_FrontendAction_dispose.

// Custom Consumer Actions
CXFrontendAction clang_ReadPCHAndPreprocessAction_create(void) {
  std::unique_ptr<clang::FrontendAction> FA =
      std::make_unique<clang::ReadPCHAndPreprocessAction>();
  return reinterpret_cast<CXFrontendAction>(FA.release());
}

// AST Consumer Actions
CXFrontendAction clang_ASTPrintAction_create(void) {
  std::unique_ptr<clang::FrontendAction> FA = std::make_unique<clang::ASTPrintAction>();
  return reinterpret_cast<CXFrontendAction>(FA.release());
}

CXFrontendAction clang_ASTDumpAction_create(void) {
  std::unique_ptr<clang::FrontendAction> FA = std::make_unique<clang::ASTDumpAction>();
  return reinterpret_cast<CXFrontendAction>(FA.release());
}

CXFrontendAction clang_GeneratePCHAction_create(void) {
  std::unique_ptr<clang::FrontendAction> FA = std::make_unique<clang::GeneratePCHAction>();
  return reinterpret_cast<CXFrontendAction>(FA.release());
}

CXFrontendAction clang_SyntaxOnlyAction_create(void) {
  std::unique_ptr<clang::FrontendAction> FA = std::make_unique<clang::SyntaxOnlyAction>();
  return reinterpret_cast<CXFrontendAction>(FA.release());
}
