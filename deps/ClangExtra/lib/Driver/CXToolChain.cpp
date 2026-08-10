#include "clang-ex/Driver/CXToolChain.h"
#include "utils.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/ToolChain.h"
#include "clang/Driver/Types.h"
#include <optional>
#include <string>
#include <vector>

CXDriver clang_ToolChain_getDriver(CXToolChain TC) {
  return reinterpret_cast<CXDriver>(const_cast<clang::driver::Driver *>(
      &reinterpret_cast<clang::driver::ToolChain *>(TC)->getDriver()));
}

CXString clang_ToolChain_getTripleString(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getTripleString());
}

CXString clang_ToolChain_getArchName(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getArchName().str());
}

CXString clang_ToolChain_getOS(CXToolChain TC) {
  return extra::makeCXString(reinterpret_cast<clang::driver::ToolChain *>(TC)->getOS().str());
}

bool clang_ToolChain_isCrossCompiling(CXToolChain TC) {
  return reinterpret_cast<clang::driver::ToolChain *>(TC)->isCrossCompiling();
}

CXString clang_ToolChain_getDefaultUniversalArchName(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getDefaultUniversalArchName().str());
}

// clang's path_list is a SmallVector<std::string, 16>; makeCXStringSet takes a
// std::vector, so each list is copied once on the way out.
static CXStringSet *makePathSet(const clang::driver::ToolChain::path_list &Paths) {
  return extra::makeCXStringSet(std::vector<std::string>(Paths.begin(), Paths.end()));
}

CXString clang_ToolChain_getCompilerRTPath(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getCompilerRTPath());
}

CXString clang_ToolChain_getRuntimePath(CXToolChain TC) {
  std::optional<std::string> P =
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getRuntimePath();
  return extra::makeCXString(P ? *P : std::string());
}

CXString clang_ToolChain_getStdlibPath(CXToolChain TC) {
  std::optional<std::string> P =
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getStdlibPath();
  return extra::makeCXString(P ? *P : std::string());
}

CXStringSet *clang_ToolChain_getArchSpecificLibPaths(CXToolChain TC) {
  return makePathSet(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getArchSpecificLibPaths());
}

CXStringSet *clang_ToolChain_getLibraryPaths(CXToolChain TC) {
  return makePathSet(reinterpret_cast<clang::driver::ToolChain *>(TC)->getLibraryPaths());
}

CXStringSet *clang_ToolChain_getFilePaths(CXToolChain TC) {
  return makePathSet(reinterpret_cast<clang::driver::ToolChain *>(TC)->getFilePaths());
}

CXStringSet *clang_ToolChain_getProgramPaths(CXToolChain TC) {
  return makePathSet(reinterpret_cast<clang::driver::ToolChain *>(TC)->getProgramPaths());
}

CXString clang_ToolChain_GetLinkerPath(CXToolChain TC, bool *LinkerIsLLD) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->GetLinkerPath(LinkerIsLLD));
}

CXString clang_ToolChain_GetStaticLibToolPath(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->GetStaticLibToolPath());
}

CXString clang_ToolChain_computeSysRoot(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->computeSysRoot());
}

CXString clang_ToolChain_getOSLibName(CXToolChain TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->getOSLibName().str());
}

const char *clang_ToolChain_getDefaultLinker(CXToolChain TC) {
  return reinterpret_cast<clang::driver::ToolChain *>(TC)->getDefaultLinker();
}

bool clang_ToolChain_isPICDefault(CXToolChain TC) {
  return reinterpret_cast<clang::driver::ToolChain *>(TC)->isPICDefault();
}

bool clang_ToolChain_isPICDefaultForced(CXToolChain TC) {
  return reinterpret_cast<clang::driver::ToolChain *>(TC)->isPICDefaultForced();
}

CXCXXStdlibType clang_ToolChain_GetDefaultCXXStdlibType(CXToolChain TC) {
  return static_cast<CXCXXStdlibType>(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->GetDefaultCXXStdlibType());
}

CXRuntimeLibType clang_ToolChain_GetDefaultRuntimeLibType(CXToolChain TC) {
  return static_cast<CXRuntimeLibType>(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->GetDefaultRuntimeLibType());
}

unsigned clang_ToolChain_LookupTypeForExtension(CXToolChain TC, const char *Ext) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::driver::ToolChain *>(TC)->LookupTypeForExtension(
          llvm::StringRef(Ext)));
}
