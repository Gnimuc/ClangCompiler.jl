#include "clang-ex/Basic/CXLangOptions.h"
#include "utils.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/LangStandard.h"
#include "llvm/Support/Errc.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/TargetParser/Triple.h"
#include <string>
#include <vector>

bool clang_LangOptions_isCompilingModule(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isCompilingModule();
}

bool clang_LangOptions_isCompilingModuleInterface(CXLangOptions LO) {
  // LLVM 20 dropped the named predicate; it was getCompilingModule() ==
  // CMK_ModuleInterface.
  return reinterpret_cast<clang::LangOptions *>(LO)->getCompilingModule() ==
         clang::LangOptions::CMK_ModuleInterface;
}

bool clang_LangOptions_isCompilingModuleImplementation(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isCompilingModuleImplementation();
}

bool clang_LangOptions_trackLocalOwningModule(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->trackLocalOwningModule();
}

bool clang_LangOptions_isSignedOverflowDefined(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isSignedOverflowDefined();
}

bool clang_LangOptions_isSubscriptPointerArithmetic(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isSubscriptPointerArithmetic();
}

bool clang_LangOptions_isCompatibleWithMSVC(CXLangOptions LO,
                                            CXMSVCMajorVersion MajorVersion) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isCompatibleWithMSVC(
      static_cast<clang::LangOptions::MSVCMajorVersion>(MajorVersion));
}

void clang_LangOptions_resetNonModularOptions(CXLangOptions LO) {
  reinterpret_cast<clang::LangOptions *>(LO)->resetNonModularOptions();
}

bool clang_LangOptions_isNoBuiltinFunc(CXLangOptions LO, const char *Name) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isNoBuiltinFunc(llvm::StringRef(Name));
}

bool clang_LangOptions_allowsNonTrivialObjCLifetimeQualifiers(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->allowsNonTrivialObjCLifetimeQualifiers();
}

bool clang_LangOptions_getBorland(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->Borland;
}

bool clang_LangOptions_getMicrosoftExt(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->MicrosoftExt;
}

bool clang_LangOptions_getCPlusPlus(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->CPlusPlus;
}

bool clang_LangOptions_getCPlusPlus11(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->CPlusPlus11;
}

bool clang_LangOptions_hasLangStandard(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->LangStd !=
         clang::LangStandard::lang_unspecified;
}

CXStringSet *clang_LangOptions_setLangDefaults(CXLangOptions LO, CXLanguage Lang,
                                               const char *Triple,
                                               CXLangStandardKind LangStd) {
  std::vector<std::string> Includes;
  clang::LangOptions::setLangDefaults(
      *reinterpret_cast<clang::LangOptions *>(LO), static_cast<clang::Language>(Lang),
      llvm::Triple(llvm::StringRef(Triple)), Includes,
      static_cast<clang::LangStandard::Kind>(LangStd));
  return extra::makeCXStringSet(Includes);
}

bool clang_LangOptions_assumeFunctionsAreConvergent(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->assumeFunctionsAreConvergent();
}

unsigned clang_LangOptions_getOpenCLCompatibleVersion(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->getOpenCLCompatibleVersion();
}

CXString clang_LangOptions_getOpenCLVersionString(CXLangOptions LO) {
  return extra::makeCXString(
      reinterpret_cast<clang::LangOptions *>(LO)->getOpenCLVersionString());
}

bool clang_LangOptions_requiresStrictPrototypes(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->requiresStrictPrototypes();
}

bool clang_LangOptions_implicitFunctionsAllowed(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->implicitFunctionsAllowed();
}

bool clang_LangOptions_hasAtExit(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasAtExit();
}

bool clang_LangOptions_isImplicitIntRequired(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isImplicitIntRequired();
}

bool clang_LangOptions_isImplicitIntAllowed(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isImplicitIntAllowed();
}

bool clang_LangOptions_hasSignReturnAddress(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasSignReturnAddress();
}

bool clang_LangOptions_isSignReturnAddressWithAKey(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isSignReturnAddressWithAKey();
}

bool clang_LangOptions_isSignReturnAddressScopeAll(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isSignReturnAddressScopeAll();
}

bool clang_LangOptions_hasSjLjExceptions(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasSjLjExceptions();
}

bool clang_LangOptions_hasSEHExceptions(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasSEHExceptions();
}

bool clang_LangOptions_hasDWARFExceptions(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasDWARFExceptions();
}

bool clang_LangOptions_hasWasmExceptions(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasWasmExceptions();
}

bool clang_LangOptions_isSYCL(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isSYCL();
}

bool clang_LangOptions_hasDefaultVisibilityExportMapping(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasDefaultVisibilityExportMapping();
}

bool clang_LangOptions_isExplicitDefaultVisibilityExportMapping(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isExplicitDefaultVisibilityExportMapping();
}

bool clang_LangOptions_isAllDefaultVisibilityExportMapping(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->isAllDefaultVisibilityExportMapping();
}

bool clang_LangOptions_hasGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->hasGlobalAllocationFunctionVisibility();
}

bool clang_LangOptions_hasDefaultGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)
      ->hasDefaultGlobalAllocationFunctionVisibility();
}

bool clang_LangOptions_hasProtectedGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)
      ->hasProtectedGlobalAllocationFunctionVisibility();
}

bool clang_LangOptions_hasHiddenGlobalAllocationFunctionVisibility(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)
      ->hasHiddenGlobalAllocationFunctionVisibility();
}

CXString clang_LangOptions_remapPathPrefix(CXLangOptions LO, const char *Path) {
  llvm::SmallString<256> Buf(Path);
  reinterpret_cast<clang::LangOptions *>(LO)->remapPathPrefix(Buf);
  return extra::makeCXString(Buf.str().str());
}

CXRoundingMode clang_LangOptions_getDefaultRoundingMode(CXLangOptions LO) {
  return static_cast<CXRoundingMode>(
      reinterpret_cast<clang::LangOptions *>(LO)->getDefaultRoundingMode());
}

CXFPExceptionModeKind clang_LangOptions_getDefaultExceptionMode(CXLangOptions LO) {
  return static_cast<CXFPExceptionModeKind>(
      reinterpret_cast<clang::LangOptions *>(LO)->getDefaultExceptionMode());
}

// FPOptions
unsigned clang_FPOptions_defaultWithoutTrailingStorage(CXLangOptions LO) {
  return clang::FPOptions::defaultWithoutTrailingStorage(
             *reinterpret_cast<clang::LangOptions *>(LO))
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
  auto Opts = reinterpret_cast<clang::LangOptions *>(LO);
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

bool clang_LangOptions_getModules(CXLangOptions LO) {
  return reinterpret_cast<clang::LangOptions *>(LO)->Modules;
}

bool clang_FPOptions_allowFPContractWithinStatement(unsigned FPO) {
  return clang::FPOptions::getFromOpaqueInt(FPO).allowFPContractWithinStatement();
}

bool clang_FPOptions_allowFPContractAcrossStatement(unsigned FPO) {
  return clang::FPOptions::getFromOpaqueInt(FPO).allowFPContractAcrossStatement();
}

bool clang_FPOptions_isFPConstrained(unsigned FPO) {
  return clang::FPOptions::getFromOpaqueInt(FPO).isFPConstrained();
}

uint64_t clang_FPOptions_getChangesFrom(unsigned FPO, unsigned Base) {
  return clang::FPOptions::getFromOpaqueInt(FPO)
      .getChangesFrom(clang::FPOptions::getFromOpaqueInt(Base))
      .getAsOpaqueInt();
}

unsigned clang_FPOptionsOverride_applyOverrides(uint64_t FPO, unsigned Base) {
  return clang::FPOptionsOverride::getFromOpaqueInt(FPO)
      .applyOverrides(clang::FPOptions::getFromOpaqueInt(Base))
      .getAsOpaqueInt();
}

bool clang_FPOptionsOverride_requiresTrailingStorage(uint64_t FPO) {
  return clang::FPOptionsOverride::getFromOpaqueInt(FPO).requiresTrailingStorage();
}

uint64_t clang_FPOptionsOverride_setAllowFPContractWithinStatement(uint64_t FPO) {
  clang::FPOptionsOverride O = clang::FPOptionsOverride::getFromOpaqueInt(FPO);
  O.setAllowFPContractWithinStatement();
  return O.getAsOpaqueInt();
}

uint64_t clang_FPOptionsOverride_setAllowFPContractAcrossStatement(uint64_t FPO) {
  clang::FPOptionsOverride O = clang::FPOptionsOverride::getFromOpaqueInt(FPO);
  O.setAllowFPContractAcrossStatement();
  return O.getAsOpaqueInt();
}

uint64_t clang_FPOptionsOverride_setDisallowFPContract(uint64_t FPO) {
  clang::FPOptionsOverride O = clang::FPOptionsOverride::getFromOpaqueInt(FPO);
  O.setDisallowFPContract();
  return O.getAsOpaqueInt();
}
