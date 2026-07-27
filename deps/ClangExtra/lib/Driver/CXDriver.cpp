#include "clang-ex/Driver/CXDriver.h"
#include "utils.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Driver/Driver.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/VirtualFileSystem.h"
#include <memory>
#include <string>

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

size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath) {
  return clang::driver::Driver::GetResourcesPath(BinaryPath).size();
}

void clang_Driver_GetResourcesPath(const char *BinaryPath, char *ResourcesPath, size_t N) {
  auto s = clang::driver::Driver::GetResourcesPath(BinaryPath);
  std::copy_n(s.begin(), N, ResourcesPath);
}