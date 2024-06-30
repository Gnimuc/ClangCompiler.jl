#include "clang-ex/Basic/CXTargetOptions.h"
#include "clang/Basic/TargetOptions.h"
#include "llvm/Support/Errc.h"

CXTargetOptions clang_TargetOptions_create(void) {
  auto TO = std::make_unique<clang::TargetOptions>();
  return TO.release();
}

void clang_TargetOptions_dispose(CXTargetOptions TO) {
  delete static_cast<clang::TargetOptions *>(TO);
}

void clang_TargetOptions_setTriple(CXTargetOptions TO, const char *TripleStr, size_t Num) {
  static_cast<clang::TargetOptions *>(TO)->Triple = std::string(TripleStr, Num);
}

void clang_TargetOptions_PrintStats(CXTargetOptions TO) {
  auto Opts = static_cast<clang::TargetOptions *>(TO);
  llvm::errs() << "\n*** TargetOptions Stats:\n";
  llvm::errs() << "  Triple: " << Opts->Triple << "\n";
  llvm::errs() << "  HostTriple: " << Opts->HostTriple << "\n";
  llvm::errs() << "  CPU: " << Opts->CPU << "\n";
  llvm::errs() << "  FPMath: " << Opts->FPMath << "\n";
  llvm::errs() << "  ABI: " << Opts->ABI << "\n";
  llvm::errs() << "  EABIVersion: " << static_cast<int>(Opts->EABIVersion) << "\n";
  llvm::errs() << "  LinkerVersion: " << Opts->LinkerVersion << "\n";

  llvm::errs() << "  FeaturesAsWritten: \n";
  for (const auto &Feature : Opts->FeaturesAsWritten)
    llvm::errs() << "    " << Feature << "\n";

  llvm::errs() << "  Features: \n";
  for (const auto &Feature : Opts->Features)
    llvm::errs() << "    " << Feature << "\n";

  llvm::errs() << "  ForceEnableInt128: " << Opts->ForceEnableInt128 << "\n";
  llvm::errs() << "  NVPTXUseShortPointers: " << Opts->NVPTXUseShortPointers << "\n";
  llvm::errs() << "  CodeModel: " << Opts->CodeModel << "\n";
  llvm::errs() << "  SDKVersion: " << Opts->SDKVersion << "\n";
}