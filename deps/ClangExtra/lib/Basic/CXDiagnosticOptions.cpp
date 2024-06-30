#include "clang-ex/Basic/CXDiagnosticOptions.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "llvm/Support/raw_ostream.h"

CXDiagnosticOptions clang_DiagnosticOptions_create(CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::DiagnosticOptions> ptr =
      std::make_unique<clang::DiagnosticOptions>();

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::DiagnosticOptions`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_DiagnosticOptions_dispose(CXDiagnosticOptions DO) {
  delete static_cast<clang::DiagnosticOptions *>(DO);
}

void clang_DiagnosticOptions_setShowColors(CXDiagnosticOptions DO, bool ShowColors) {
  static_cast<clang::DiagnosticOptions *>(DO)->ShowColors = ShowColors;
}

void clang_DiagnosticOptions_setShowPresumedLoc(CXDiagnosticOptions DO,
                                                bool ShowPresumedLoc) {
  static_cast<clang::DiagnosticOptions *>(DO)->ShowPresumedLoc = ShowPresumedLoc;
}

void clang_DiagnosticOptions_PrintStats(CXDiagnosticOptions DO) {
  auto Opts = static_cast<clang::DiagnosticOptions *>(DO);
  llvm::errs() << "\n*** DiagnosticOptions Stats:\n";
  llvm::errs() << "  DiagnosticLogFile: " << Opts->DiagnosticLogFile << "\n";
  llvm::errs() << "  DiagnosticSerializationFile: " << Opts->DiagnosticSerializationFile
               << "\n";

  llvm::errs() << "  Warnings: \n";
  for (const auto &WN : Opts->Warnings)
    llvm::errs() << "    " << WN << "\n";

  llvm::errs() << "  UndefPrefixes: \n";
  for (const auto &UP : Opts->UndefPrefixes)
    llvm::errs() << "    " << UP << "\n";

  llvm::errs() << "  Remarks: \n";
  for (const auto &RM : Opts->Remarks)
    llvm::errs() << "    " << RM << "\n";

  llvm::errs() << "  VerifyPrefixes: \n";
  for (const auto &VP : Opts->VerifyPrefixes)
    llvm::errs() << "    " << VP << "\n";

  llvm::errs() << "  Options: \n";
  llvm::errs() << "    ShowColors: " << Opts->ShowColors << "\n";
  llvm::errs() << "    ShowPresumedLoc: " << Opts->ShowPresumedLoc << "\n";
}