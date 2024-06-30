#include "clang-ex/Frontend/CXTextDiagnosticPrinter.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "llvm/Support/raw_ostream.h"

CXDiagnosticConsumer clang_TextDiagnosticPrinter_create(CXDiagnosticOptions Opts) {
  auto DS = std::make_unique<clang::TextDiagnosticPrinter>(
      llvm::errs(), static_cast<clang::DiagnosticOptions *>(Opts));
  return DS.release();
}
