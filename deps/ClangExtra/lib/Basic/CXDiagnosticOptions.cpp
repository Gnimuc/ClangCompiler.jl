#include "clang-ex/Basic/CXDiagnosticOptions.h"
#include "utils.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>

CXDiagnosticOptions clang_DiagnosticOptions_create(void) {
  auto DO = std::make_unique<clang::DiagnosticOptions>();
  // DiagnosticOptions is a RefCountedBase, so hand it back already holding the caller's own
  // reference rather than at a count of zero. Every consumer that takes it borrows it
  // through an IntrusiveRefCntPtr -- a TextDiagnosticPrinter parks one in a member, a
  // DiagnosticsEngine does the same, the serialized-diagnostics writer keeps one in its
  // shared state, and ToolInvocation::run builds a printer and an engine on the stack for
  // the length of a single run -- and a borrow that starts from zero goes 0 -> 1 -> 0 and
  // deletes the options when the consumer goes out of scope, leaving the caller with a
  // dangling handle. Starting at one turns every such borrow into 1 -> 2 -> 1, which is why
  // clang_ToolInvocation_setDiagnosticOptions no longer pins the object itself.
  DO->Retain();
  return reinterpret_cast<CXDiagnosticOptions>(DO.release());
}

void clang_DiagnosticOptions_dispose(CXDiagnosticOptions DO) {
  // Balances the Retain in clang_DiagnosticOptions_create; the last Release deletes.
  reinterpret_cast<clang::DiagnosticOptions *>(DO)->Release();
}

void clang_DiagnosticOptions_setShowColors(CXDiagnosticOptions DO, bool ShowColors) {
  reinterpret_cast<clang::DiagnosticOptions *>(DO)->ShowColors = ShowColors;
}

void clang_DiagnosticOptions_setShowPresumedLoc(CXDiagnosticOptions DO,
                                                bool ShowPresumedLoc) {
  reinterpret_cast<clang::DiagnosticOptions *>(DO)->ShowPresumedLoc = ShowPresumedLoc;
}

void clang_DiagnosticOptions_PrintStats(CXDiagnosticOptions DO) {
  auto Opts = reinterpret_cast<clang::DiagnosticOptions *>(DO);
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

// VerifyPrefixes
unsigned clang_DiagnosticOptions_getVerifyPrefixesNum(CXDiagnosticOptions DO) {
  return reinterpret_cast<clang::DiagnosticOptions *>(DO)->VerifyPrefixes.size();
}

CXString clang_DiagnosticOptions_getVerifyPrefix(CXDiagnosticOptions DO, unsigned Idx) {
  return extra::makeCXString(
      reinterpret_cast<clang::DiagnosticOptions *>(DO)->VerifyPrefixes[Idx]);
}

void clang_DiagnosticOptions_addVerifyPrefix(CXDiagnosticOptions DO, const char *Prefix) {
  auto &Prefixes = reinterpret_cast<clang::DiagnosticOptions *>(DO)->VerifyPrefixes;
  Prefixes.emplace_back(Prefix);
  llvm::sort(Prefixes);
}
