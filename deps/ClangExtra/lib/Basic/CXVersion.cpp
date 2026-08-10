#include "clang-ex/Basic/CXVersion.h"
#include "utils.h"

#include "clang/Basic/Version.h"

CXString clang_getClangFullVersion(void) {
  return extra::makeCXString(clang::getClangFullVersion());
}

CXString clang_getClangToolFullVersion(const char *ToolName) {
  return extra::makeCXString(
      clang::getClangToolFullVersion(llvm::StringRef(ToolName)));
}

CXString clang_getClangRepositoryPath(void) {
  return extra::makeCXString(clang::getClangRepositoryPath());
}

CXString clang_getClangRevision(void) {
  return extra::makeCXString(clang::getClangRevision());
}

CXString clang_getLLVMRevision(void) {
  return extra::makeCXString(clang::getLLVMRevision());
}

CXString clang_getClangVendor(void) {
  return extra::makeCXString(clang::getClangVendor());
}

CXString clang_getClangFullCPPVersion(void) {
  return extra::makeCXString(clang::getClangFullCPPVersion());
}
