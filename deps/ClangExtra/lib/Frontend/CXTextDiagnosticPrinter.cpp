#include "clang-ex/Frontend/CXTextDiagnosticPrinter.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "llvm/Support/raw_ostream.h"

CXDiagnosticConsumer clang_TextDiagnosticPrinter_create(CXDiagnosticOptions Opts) {
  auto DS = std::make_unique<clang::TextDiagnosticPrinter>(
      llvm::errs(), reinterpret_cast<clang::DiagnosticOptions *>(Opts));
  return reinterpret_cast<CXDiagnosticConsumer>(DS.release());
}
