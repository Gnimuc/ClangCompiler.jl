#include "clang-ex/Basic/CXCodeGenOptions.h"
#include "clang/Basic/CodeGenOptions.h"
#include "llvm/Support/raw_ostream.h"

CXCodeGenOptions clang_CodeGenOptions_create(void) {
  auto CGO = std::make_unique<clang::CodeGenOptions>();
  return reinterpret_cast<CXCodeGenOptions>(CGO.release());
}

void clang_CodeGenOptions_dispose(CXCodeGenOptions DO) {
  delete reinterpret_cast<clang::CodeGenOptions *>(DO);
}

const char *clang_CodeGenOptions_getArgv0(CXCodeGenOptions CGO) {
  return reinterpret_cast<clang::CodeGenOptions *>(CGO)->Argv0;
}

unsigned clang_CodeGenOptions_getCommandLineArgsNum(CXCodeGenOptions CGO) {
  return reinterpret_cast<clang::CodeGenOptions *>(CGO)->CommandLineArgs.size();
}

void clang_CodeGenOptions_getCommandLineArgs(CXCodeGenOptions CGO, const char **Buf,
                                             unsigned N) {
  const auto &Args = reinterpret_cast<clang::CodeGenOptions *>(CGO)->CommandLineArgs;
  for (unsigned I = 0; I < N && I < Args.size(); ++I)
    Buf[I] = Args[I].c_str();
}

void clang_CodeGenOptions_PrintStats(CXCodeGenOptions CGO) {
  auto Opts = reinterpret_cast<clang::CodeGenOptions *>(CGO);
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
