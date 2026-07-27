#include "clang-ex/Driver/CXDriver.h"
#include "utils.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Driver/Driver.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/VirtualFileSystem.h"
#include <memory>
#include <string>

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallString.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/ToolChain.h"
#include "llvm/Support/raw_ostream.h"

CXDriver clang_Driver_create(const char *ClangExecutable, const char *TargetTriple,
                             CXDiagnosticsEngine Diags) {
  return std::make_unique<clang::driver::Driver>(
             llvm::StringRef(ClangExecutable), llvm::StringRef(TargetTriple),
             *static_cast<clang::DiagnosticsEngine *>(Diags))
      .release();
}

void clang_Driver_dispose(CXDriver D) { delete static_cast<clang::driver::Driver *>(D); }

bool clang_Driver_CCCIsCXX(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->CCCIsCXX();
}

bool clang_Driver_CCCIsCPP(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->CCCIsCPP();
}

bool clang_Driver_CCCIsCC(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->CCCIsCC();
}

bool clang_Driver_IsCLMode(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->IsCLMode();
}

bool clang_Driver_IsFlangMode(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->IsFlangMode();
}

bool clang_Driver_IsDXCMode(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->IsDXCMode();
}

CXString clang_Driver_getCCCGenericGCCName(CXDriver D) {
  return extra::makeCXString(
      static_cast<clang::driver::Driver *>(D)->getCCCGenericGCCName());
}

CXDiagnosticsEngine clang_Driver_getDiags(CXDriver D) {
  return &static_cast<clang::driver::Driver *>(D)->getDiags();
}

bool clang_Driver_getCheckInputsExist(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->getCheckInputsExist();
}

void clang_Driver_setCheckInputsExist(CXDriver D, bool Value) {
  static_cast<clang::driver::Driver *>(D)->setCheckInputsExist(Value);
}

CXString clang_Driver_getTitle(CXDriver D) {
  return extra::makeCXString(static_cast<clang::driver::Driver *>(D)->getTitle());
}

void clang_Driver_setTitle(CXDriver D, const char *Value) {
  static_cast<clang::driver::Driver *>(D)->setTitle(std::string(Value));
}

CXString clang_Driver_getTargetTriple(CXDriver D) {
  return extra::makeCXString(static_cast<clang::driver::Driver *>(D)->getTargetTriple());
}

const char *clang_Driver_getClangProgramPath(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->getClangProgramPath();
}

const char *clang_Driver_getInstalledDir(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->getInstalledDir();
}

const char *clang_Driver_getDir(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->Dir.c_str();
}

const char *clang_Driver_getResourceDir(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->ResourceDir.c_str();
}

const char *clang_Driver_getSysRoot(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->SysRoot.c_str();
}

const char *clang_Driver_getDyldPrefix(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->DyldPrefix.c_str();
}

const char *clang_Driver_getDefaultImageName(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->getDefaultImageName();
}

CXLTOKind clang_Driver_getLTOMode(CXDriver D, bool IsOffload) {
  return static_cast<CXLTOKind>(
      static_cast<clang::driver::Driver *>(D)->getLTOMode(IsOffload));
}

unsigned clang_Driver_getNumConfigFiles(CXDriver D) {
  return static_cast<unsigned>(
      static_cast<clang::driver::Driver *>(D)->getConfigFiles().size());
}

const char *clang_Driver_getConfigFile(CXDriver D, unsigned i) {
  return static_cast<clang::driver::Driver *>(D)->getConfigFiles()[i].c_str();
}

bool clang_Driver_getProbePrecompiled(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->getProbePrecompiled();
}

void clang_Driver_setProbePrecompiled(CXDriver D, bool Value) {
  static_cast<clang::driver::Driver *>(D)->setProbePrecompiled(Value);
}

const char *clang_Driver_getPrependArg(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->getPrependArg();
}

void clang_Driver_setPrependArg(CXDriver D, const char *Value) {
  static_cast<clang::driver::Driver *>(D)->setPrependArg(Value);
}

void clang_Driver_setInstalledDir(CXDriver D, const char *Value) {
  static_cast<clang::driver::Driver *>(D)->setInstalledDir(llvm::StringRef(Value));
}

bool clang_Driver_isSaveTempsEnabled(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->isSaveTempsEnabled();
}

bool clang_Driver_isSaveTempsObj(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->isSaveTempsObj();
}

bool clang_Driver_embedBitcodeEnabled(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->embedBitcodeEnabled();
}

bool clang_Driver_embedBitcodeInObject(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->embedBitcodeInObject();
}

bool clang_Driver_embedBitcodeMarkerOnly(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->embedBitcodeMarkerOnly();
}

bool clang_Driver_offloadHostOnly(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->offloadHostOnly();
}

bool clang_Driver_offloadDeviceOnly(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->offloadDeviceOnly();
}

bool clang_Driver_hasHeaderMode(CXDriver D) {
  return static_cast<clang::driver::Driver *>(D)->hasHeaderMode();
}

bool clang_Driver_isUsingLTO(CXDriver D, bool IsOffload) {
  return static_cast<clang::driver::Driver *>(D)->isUsingLTO(IsOffload);
}

CXCompilation clang_Driver_BuildCompilation(CXDriver D, const char **Args,
                                            unsigned NumArgs) {
  return static_cast<clang::driver::Driver *>(D)->BuildCompilation(
      llvm::ArrayRef<const char *>(Args, NumArgs));
}

CXString clang_Driver_PrintVersion(CXDriver D, CXCompilation C) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::driver::Driver *>(D)->PrintVersion(
      *static_cast<clang::driver::Compilation *>(C), OS);
  return extra::makeCXString(S);
}

CXString clang_Driver_GetFilePath(CXDriver D, const char *Name, CXToolChain TC) {
  return extra::makeCXString(static_cast<clang::driver::Driver *>(D)->GetFilePath(
      llvm::StringRef(Name), *static_cast<clang::driver::ToolChain *>(TC)));
}

CXString clang_Driver_GetProgramPath(CXDriver D, const char *Name, CXToolChain TC) {
  return extra::makeCXString(static_cast<clang::driver::Driver *>(D)->GetProgramPath(
      llvm::StringRef(Name), *static_cast<clang::driver::ToolChain *>(TC)));
}

size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath) {
  return clang::driver::Driver::GetResourcesPath(BinaryPath).size();
}

void clang_Driver_GetResourcesPath(const char *BinaryPath, char *ResourcesPath, size_t N) {
  auto s = clang::driver::Driver::GetResourcesPath(BinaryPath);
  std::copy_n(s.begin(), N, ResourcesPath);
}
CXString clang_Driver_GetTemporaryPath(CXDriver D, const char *Prefix, const char *Suffix) {
  return extra::makeCXString(static_cast<clang::driver::Driver *>(D)->GetTemporaryPath(
      llvm::StringRef(Prefix), llvm::StringRef(Suffix)));
}

CXString clang_Driver_GetTemporaryDirectory(CXDriver D, const char *Prefix) {
  return extra::makeCXString(static_cast<clang::driver::Driver *>(D)->GetTemporaryDirectory(
      llvm::StringRef(Prefix)));
}

bool clang_Driver_GetReleaseVersion(const char *Str, unsigned *Major, unsigned *Minor,
                                    unsigned *Micro, bool *HadExtra) {
  unsigned Ma = 0, Mi = 0, Mc = 0;
  bool Extra = false;
  bool Parsed =
      clang::driver::Driver::GetReleaseVersion(llvm::StringRef(Str), Ma, Mi, Mc, Extra);
  *Major = Ma;
  *Minor = Mi;
  *Micro = Mc;
  *HadExtra = Extra;
  return Parsed;
}

bool clang_Driver_GetReleaseVersionDigits(const char *Str, unsigned *Digits, unsigned N) {
  for (unsigned I = 0; I != N; ++I)
    Digits[I] = 0;
  return clang::driver::Driver::GetReleaseVersion(
      llvm::StringRef(Str), llvm::MutableArrayRef<unsigned>(Digits, N));
}

CXString clang_Driver_getDefaultModuleCachePath(void) {
  llvm::SmallString<128> Path;
  if (!clang::driver::Driver::getDefaultModuleCachePath(Path))
    return extra::makeCXString(std::string());
  return extra::makeCXString(Path.str().str());
}
