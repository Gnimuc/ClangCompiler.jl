#include "clang-ex/Driver/CXCompilation.h"
#include "utils.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/ToolChain.h"
#include "llvm/Option/ArgList.h"
#include <string>

void clang_Compilation_dispose(CXCompilation C) {
  delete reinterpret_cast<clang::driver::Compilation *>(C);
}

CXDriver clang_Compilation_getDriver(CXCompilation C) {
  return reinterpret_cast<CXDriver>(const_cast<clang::driver::Driver *>(
      &reinterpret_cast<clang::driver::Compilation *>(C)->getDriver()));
}

CXToolChain clang_Compilation_getDefaultToolChain(CXCompilation C) {
  return reinterpret_cast<CXToolChain>(const_cast<clang::driver::ToolChain *>(
      &reinterpret_cast<clang::driver::Compilation *>(C)->getDefaultToolChain()));
}

unsigned clang_Compilation_getActiveOffloadKinds(CXCompilation C) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->getActiveOffloadKinds();
}

CXString clang_Compilation_getSysRoot(CXCompilation C) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::Compilation *>(C)->getSysRoot().str());
}

unsigned clang_Compilation_getNumTempFiles(CXCompilation C) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::driver::Compilation *>(C)->getTempFiles().size());
}

const char *clang_Compilation_getTempFile(CXCompilation C, unsigned i) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->getTempFiles()[i];
}

bool clang_Compilation_isForDiagnostics(CXCompilation C) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->isForDiagnostics();
}

bool clang_Compilation_containsError(CXCompilation C) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->containsError();
}

void clang_Compilation_setContainsError(CXCompilation C) {
  reinterpret_cast<clang::driver::Compilation *>(C)->setContainsError();
}
