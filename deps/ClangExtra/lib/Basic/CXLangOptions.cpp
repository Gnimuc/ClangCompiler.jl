#include "clang-ex/Basic/CXLangOptions.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/Support/Errc.h"

void clang_LangOptions_PrintStats(CXLangOptions LO) {
  auto Opts = static_cast<clang::LangOptions *>(LO);
  llvm::errs() << "\n*** LangOptions Stats:\n";
  llvm::errs() << "  Options: \n";
  llvm::errs() << "    C99: " << Opts->C99 << "\n";
  llvm::errs() << "    C11: " << Opts->C11 << "\n";
  llvm::errs() << "    C17: " << Opts->C17 << "\n";
  llvm::errs() << "    C2x: " << Opts->C2x << "\n";
  llvm::errs() << "    MSVCCompat: " << Opts->MSVCCompat << "\n";
  llvm::errs() << "    AsmBlocks: " << Opts->AsmBlocks << "\n";
  llvm::errs() << "    Borland: " << Opts->Borland << "\n";
  llvm::errs() << "    CPlusPlus: " << Opts->CPlusPlus << "\n";
  llvm::errs() << "    CPlusPlus11: " << Opts->CPlusPlus11 << "\n";
  llvm::errs() << "    CPlusPlus14: " << Opts->CPlusPlus14 << "\n";
  llvm::errs() << "    CPlusPlus17: " << Opts->CPlusPlus17 << "\n";
  llvm::errs() << "    CPlusPlus20: " << Opts->CPlusPlus20 << "\n";
  llvm::errs() << "    ObjC: " << Opts->ObjC << "\n";
}