#include "clang-ex/Basic/CXLangOptions.h"
#include "utils.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/Support/Errc.h"

bool clang_LangOptions_isCompilingModule(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isCompilingModule();
}

bool clang_LangOptions_isCompilingModuleInterface(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isCompilingModuleInterface();
}

bool clang_LangOptions_isCompilingModuleImplementation(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isCompilingModuleImplementation();
}

bool clang_LangOptions_isSignedOverflowDefined(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSignedOverflowDefined();
}

bool clang_LangOptions_isSubscriptPointerArithmetic(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSubscriptPointerArithmetic();
}

bool clang_LangOptions_isNoBuiltinFunc(CXLangOptions LO, const char *Name) {
  return static_cast<clang::LangOptions *>(LO)->isNoBuiltinFunc(llvm::StringRef(Name));
}

bool clang_LangOptions_assumeFunctionsAreConvergent(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->assumeFunctionsAreConvergent();
}

unsigned clang_LangOptions_getOpenCLCompatibleVersion(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->getOpenCLCompatibleVersion();
}

CXString clang_LangOptions_getOpenCLVersionString(CXLangOptions LO) {
  return extra::makeCXString(
      static_cast<clang::LangOptions *>(LO)->getOpenCLVersionString());
}

bool clang_LangOptions_requiresStrictPrototypes(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->requiresStrictPrototypes();
}

bool clang_LangOptions_implicitFunctionsAllowed(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->implicitFunctionsAllowed();
}

bool clang_LangOptions_hasAtExit(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasAtExit();
}

bool clang_LangOptions_isImplicitIntRequired(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isImplicitIntRequired();
}

bool clang_LangOptions_isImplicitIntAllowed(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isImplicitIntAllowed();
}

bool clang_LangOptions_hasSjLjExceptions(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasSjLjExceptions();
}

bool clang_LangOptions_hasSEHExceptions(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasSEHExceptions();
}

bool clang_LangOptions_hasDWARFExceptions(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasDWARFExceptions();
}

bool clang_LangOptions_hasWasmExceptions(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasWasmExceptions();
}

bool clang_LangOptions_isSYCL(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSYCL();
}

void clang_LangOptions_PrintStats(CXLangOptions LO) {
  auto Opts = static_cast<clang::LangOptions *>(LO);
  llvm::errs() << "\n*** LangOptions Stats:\n";
  llvm::errs() << "  Options: \n";
  llvm::errs() << "    C99: " << Opts->C99 << "\n";
  llvm::errs() << "    C11: " << Opts->C11 << "\n";
  llvm::errs() << "    C17: " << Opts->C17 << "\n";
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