#include "clang-ex/Basic/CXLangOptions.h"
#include "utils.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/LangStandard.h"
#include "llvm/Support/Errc.h"
#include "llvm/ADT/SmallString.h"

bool clang_LangOptions_isCompilingModule(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isCompilingModule();
}

bool clang_LangOptions_isCompilingModuleInterface(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isCompilingModuleInterface();
}

bool clang_LangOptions_isCompilingModuleImplementation(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isCompilingModuleImplementation();
}

bool clang_LangOptions_trackLocalOwningModule(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->trackLocalOwningModule();
}

bool clang_LangOptions_isSignedOverflowDefined(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSignedOverflowDefined();
}

bool clang_LangOptions_isSubscriptPointerArithmetic(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSubscriptPointerArithmetic();
}

bool clang_LangOptions_isCompatibleWithMSVC(CXLangOptions LO,
                                            CXMSVCMajorVersion MajorVersion) {
  return static_cast<clang::LangOptions *>(LO)->isCompatibleWithMSVC(
      static_cast<clang::LangOptions::MSVCMajorVersion>(MajorVersion));
}

void clang_LangOptions_resetNonModularOptions(CXLangOptions LO) {
  static_cast<clang::LangOptions *>(LO)->resetNonModularOptions();
}

bool clang_LangOptions_isNoBuiltinFunc(CXLangOptions LO, const char *Name) {
  return static_cast<clang::LangOptions *>(LO)->isNoBuiltinFunc(llvm::StringRef(Name));
}

bool clang_LangOptions_allowsNonTrivialObjCLifetimeQualifiers(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->allowsNonTrivialObjCLifetimeQualifiers();
}

bool clang_LangOptions_getBorland(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->Borland;
}

bool clang_LangOptions_hasLangStandard(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->LangStd !=
         clang::LangStandard::lang_unspecified;
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

bool clang_LangOptions_hasSignReturnAddress(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasSignReturnAddress();
}

bool clang_LangOptions_isSignReturnAddressWithAKey(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSignReturnAddressWithAKey();
}

bool clang_LangOptions_isSignReturnAddressScopeAll(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isSignReturnAddressScopeAll();
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

bool clang_LangOptions_hasDefaultVisibilityExportMapping(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasDefaultVisibilityExportMapping();
}

bool clang_LangOptions_isExplicitDefaultVisibilityExportMapping(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isExplicitDefaultVisibilityExportMapping();
}

bool clang_LangOptions_isAllDefaultVisibilityExportMapping(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->isAllDefaultVisibilityExportMapping();
}

bool clang_LangOptions_hasGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)->hasGlobalAllocationFunctionVisibility();
}

bool clang_LangOptions_hasDefaultGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)
      ->hasDefaultGlobalAllocationFunctionVisibility();
}

bool clang_LangOptions_hasProtectedGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)
      ->hasProtectedGlobalAllocationFunctionVisibility();
}

bool clang_LangOptions_hasHiddenGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return static_cast<clang::LangOptions *>(LO)
      ->hasHiddenGlobalAllocationFunctionVisibility();
}

CXString clang_LangOptions_remapPathPrefix(CXLangOptions LO, const char *Path) {
  llvm::SmallString<256> Buf(Path);
  static_cast<clang::LangOptions *>(LO)->remapPathPrefix(Buf);
  return extra::makeCXString(Buf.str().str());
}

CXRoundingMode clang_LangOptions_getDefaultRoundingMode(CXLangOptions LO) {
  return static_cast<CXRoundingMode>(
      static_cast<clang::LangOptions *>(LO)->getDefaultRoundingMode());
}

CXFPExceptionModeKind clang_LangOptions_getDefaultExceptionMode(CXLangOptions LO) {
  return static_cast<CXFPExceptionModeKind>(
      static_cast<clang::LangOptions *>(LO)->getDefaultExceptionMode());
}

// FPOptions
unsigned clang_FPOptions_defaultWithoutTrailingStorage(CXLangOptions LO) {
  return clang::FPOptions::defaultWithoutTrailingStorage(
             *static_cast<clang::LangOptions *>(LO))
      .getAsOpaqueInt();
}

CXRoundingMode clang_FPOptions_getRoundingMode(unsigned FPO) {
  return static_cast<CXRoundingMode>(
      clang::FPOptions::getFromOpaqueInt(FPO).getRoundingMode());
}

CXFPExceptionModeKind clang_FPOptions_getExceptionMode(unsigned FPO) {
  return static_cast<CXFPExceptionModeKind>(
      clang::FPOptions::getFromOpaqueInt(FPO).getExceptionMode());
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