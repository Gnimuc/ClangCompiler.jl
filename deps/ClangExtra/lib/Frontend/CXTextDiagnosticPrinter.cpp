#include "clang-ex/Frontend/CXTextDiagnosticPrinter.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "llvm/Support/raw_ostream.h"

CXDiagnosticConsumer clang_TextDiagnosticPrinter_create(CXDiagnosticOptions Opts,
                                                        CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::DiagnosticConsumer> ptr =
      std::make_unique<clang::TextDiagnosticPrinter>(
          llvm::errs(), static_cast<clang::DiagnosticOptions *>(Opts));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::TextDiagnosticPrinter`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}
