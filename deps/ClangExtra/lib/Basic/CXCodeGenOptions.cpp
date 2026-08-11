#include "clang-ex/Basic/CXCodeGenOptions.h"
#include "utils.h"
#include "clang/Basic/CodeGenOptions.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

#include <memory>

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

unsigned clang_CodeGenOptions_getClearASTBeforeBackend(CXCodeGenOptions CGO) {
  return reinterpret_cast<clang::CodeGenOptions *>(CGO)->ClearASTBeforeBackend;
}

void clang_CodeGenOptions_setClearASTBeforeBackend(CXCodeGenOptions CGO, unsigned Value) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->ClearASTBeforeBackend = Value;
}

unsigned clang_CodeGenOptions_getDisableFree(CXCodeGenOptions CGO) {
  return reinterpret_cast<clang::CodeGenOptions *>(CGO)->DisableFree;
}

void clang_CodeGenOptions_setDisableFree(CXCodeGenOptions CGO, unsigned Value) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->DisableFree = Value;
}

unsigned clang_CodeGenOptions_getOptimizationLevel(CXCodeGenOptions CGO) {
  return reinterpret_cast<clang::CodeGenOptions *>(CGO)->OptimizationLevel;
}

void clang_CodeGenOptions_setOptimizationLevel(CXCodeGenOptions CGO, unsigned Level) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->OptimizationLevel = Level;
}

unsigned clang_CodeGenOptions_getOptimizeSize(CXCodeGenOptions CGO) {
  return reinterpret_cast<clang::CodeGenOptions *>(CGO)->OptimizeSize;
}

void clang_CodeGenOptions_setOptimizeSize(CXCodeGenOptions CGO, unsigned Level) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->OptimizeSize = Level;
}

CXDebugInfoKind clang_CodeGenOptions_getDebugInfo(CXCodeGenOptions CGO) {
  return static_cast<CXDebugInfoKind>(
      reinterpret_cast<clang::CodeGenOptions *>(CGO)->getDebugInfo());
}

void clang_CodeGenOptions_setDebugInfo(CXCodeGenOptions CGO, CXDebugInfoKind Kind) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->setDebugInfo(
      static_cast<llvm::codegenoptions::DebugInfoKind>(Kind));
}

CXRelocModel clang_CodeGenOptions_getRelocationModel(CXCodeGenOptions CGO) {
  return static_cast<CXRelocModel>(
      reinterpret_cast<clang::CodeGenOptions *>(CGO)->RelocationModel);
}

void clang_CodeGenOptions_setRelocationModel(CXCodeGenOptions CGO, CXRelocModel Model) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->RelocationModel =
      static_cast<llvm::Reloc::Model>(Model);
}

CXString clang_CodeGenOptions_getCodeModel(CXCodeGenOptions CGO) {
  return extra::makeCXString(reinterpret_cast<clang::CodeGenOptions *>(CGO)->CodeModel);
}

void clang_CodeGenOptions_setCodeModel(CXCodeGenOptions CGO, const char *Model) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->CodeModel = std::string(Model);
}

CXString clang_CodeGenOptions_getMainFileName(CXCodeGenOptions CGO) {
  return extra::makeCXString(reinterpret_cast<clang::CodeGenOptions *>(CGO)->MainFileName);
}

void clang_CodeGenOptions_setMainFileName(CXCodeGenOptions CGO, const char *Name) {
  reinterpret_cast<clang::CodeGenOptions *>(CGO)->MainFileName = std::string(Name);
}
