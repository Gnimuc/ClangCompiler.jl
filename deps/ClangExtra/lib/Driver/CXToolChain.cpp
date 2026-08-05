#include "clang-ex/Driver/CXToolChain.h"
#include "utils.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/ToolChain.h"
#include <string>

CXDriver clang_ToolChain_getDriver(CXToolChain TC) {
  return const_cast<clang::driver::Driver *>(
      &static_cast<clang::driver::ToolChain *>(TC)->getDriver());
}

CXString clang_ToolChain_getTripleString(CXToolChain TC) {
  return extra::makeCXString(
      static_cast<clang::driver::ToolChain *>(TC)->getTripleString());
}

CXString clang_ToolChain_getArchName(CXToolChain TC) {
  return extra::makeCXString(
      static_cast<clang::driver::ToolChain *>(TC)->getArchName().str());
}

CXString clang_ToolChain_getOS(CXToolChain TC) {
  return extra::makeCXString(static_cast<clang::driver::ToolChain *>(TC)->getOS().str());
}

bool clang_ToolChain_isCrossCompiling(CXToolChain TC) {
  return static_cast<clang::driver::ToolChain *>(TC)->isCrossCompiling();
}
