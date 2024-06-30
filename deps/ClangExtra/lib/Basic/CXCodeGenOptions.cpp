#include "clang-ex/Basic/CXCodeGenOptions.h"
#include "clang/Basic/CodeGenOptions.h"
#include "llvm/Support/raw_ostream.h"

CXCodeGenOptions clang_CodeGenOptions_create(void) {
  auto CGO = std::make_unique<clang::CodeGenOptions>();
  return CGO.release();
}

void clang_CodeGenOptions_dispose(CXCodeGenOptions DO) {
  delete static_cast<clang::CodeGenOptions *>(DO);
}

const char *clang_CodeGenOptions_getArgv0(CXCodeGenOptions CGO) {
  return static_cast<clang::CodeGenOptions *>(CGO)->Argv0;
}

void clang_CodeGenOptions_PrintStats(CXCodeGenOptions CGO) {
  auto Opts = static_cast<clang::CodeGenOptions *>(CGO);
  llvm::errs() << "\n*** CodeGenOptions Stats:\n";
  llvm::errs() << "  CodeModel: " << Opts->CodeModel << "\n";
  llvm::errs() << "  DebugPass: " << Opts->DebugPass << "\n";
  llvm::errs() << "  FloatABI: " << Opts->FloatABI << "\n";
  llvm::errs() << "  LimitFloatPrecision: " << Opts->LimitFloatPrecision << "\n";
  llvm::errs() << "  MainFileName: " << Opts->MainFileName << "\n";
  llvm::errs() << "  TrapFuncName: " << Opts->TrapFuncName << "\n";

  llvm::errs() << "  DependentLibraries: \n";
  for (const auto &Dep : Opts->DependentLibraries)
    llvm::errs() << "    " << Dep << "\n";

  llvm::errs() << "  LinkerOptions: \n";
  for (const auto &Opt : Opts->LinkerOptions)
    llvm::errs() << "    " << Opt << "\n";

  llvm::errs() << "  CudaGpuBinaryFileName: " << Opts->CudaGpuBinaryFileName << "\n";
}