#include "clang-ex/Lex/CXPreprocessorOptions.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "llvm/Support/raw_ostream.h"

size_t clang_PreprocessorOptions_getIncludesNum(CXPreprocessorOptions PPO) {
  return static_cast<clang::PreprocessorOptions *>(PPO)->Includes.size();
}

void clang_PreprocessorOptions_getIncludes(CXPreprocessorOptions PPO, const char **IncsOut,
                                           size_t Num) {
  auto &Incs = static_cast<clang::PreprocessorOptions *>(PPO)->Includes;
  for (auto &Inc : Incs) {
    auto i = &Inc - &Incs[0];
    if (i < Num)
      IncsOut[i] = Inc.c_str();
  }
}

void clang_PreprocessorOptions_PrintStats(CXPreprocessorOptions PPO) {
  auto Opts = static_cast<clang::PreprocessorOptions *>(PPO);
  llvm::errs() << "\n*** PreprocessorOptions Stats:\n";
  llvm::errs() << "  Macros: \n";
  for (const auto &M : Opts->Macros)
    llvm::errs() << "    " << M.first << "  (isUndef:" << M.second << ")\n";

  llvm::errs() << "  Includes: \n";
  for (const auto &Inc : Opts->Includes)
    llvm::errs() << "    " << Inc << "\n";

  llvm::errs() << "  MacroIncludes: \n";
  for (const auto &Inc : Opts->MacroIncludes)
    llvm::errs() << "    " << Inc << "\n";

  llvm::errs() << "  ImplicitPCHInclude: " << Opts->ImplicitPCHInclude << "\n";

  llvm::errs() << "  ChainedIncludes: \n";
  for (const auto &Inc : Opts->ChainedIncludes)
    llvm::errs() << "    " << Inc << "\n";

  llvm::errs() << "  Options: \n";
  llvm::errs() << "    UsePredefines: " << Opts->UsePredefines << "\n";
  llvm::errs() << "    DetailedRecord: " << Opts->DetailedRecord << "\n";
  llvm::errs() << "    SingleFileParseMode: " << Opts->SingleFileParseMode << "\n";

  llvm::errs() << "  RemappedFiles: \n";
  for (const auto &RF : Opts->RemappedFiles)
    llvm::errs() << "    " << RF.first << "  ->  " << RF.second << "\n";
}