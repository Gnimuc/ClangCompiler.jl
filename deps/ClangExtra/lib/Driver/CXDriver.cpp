#include "clang-ex/Driver/CXDriver.h"
#include "clang/Driver/Driver.h"

size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath) {
  return clang::driver::Driver::GetResourcesPath(BinaryPath).size();
}

void clang_Driver_GetResourcesPath(const char *BinaryPath, char *ResourcesPath, size_t N) {
  auto s = clang::driver::Driver::GetResourcesPath(BinaryPath);
  std::copy_n(s.begin(), N, ResourcesPath);
}