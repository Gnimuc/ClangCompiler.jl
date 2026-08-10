#include "clang-ex/Frontend/CXDependencyOutputOptions.h"
#include "utils.h"
#include "clang/Frontend/DependencyOutputOptions.h"

#include <memory>

CXDependencyOutputOptions clang_DependencyOutputOptions_create(void) {
  auto Opts = std::make_unique<clang::DependencyOutputOptions>();
  return reinterpret_cast<CXDependencyOutputOptions>(Opts.release());
}

void clang_DependencyOutputOptions_dispose(CXDependencyOutputOptions DOO) {
  delete reinterpret_cast<clang::DependencyOutputOptions *>(DOO);
}

// Flags
bool clang_DependencyOutputOptions_getIncludeSystemHeaders(CXDependencyOutputOptions DOO) {
  return reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->IncludeSystemHeaders;
}

void clang_DependencyOutputOptions_setIncludeSystemHeaders(CXDependencyOutputOptions DOO,
                                                           bool Value) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->IncludeSystemHeaders = Value;
}

bool clang_DependencyOutputOptions_getUsePhonyTargets(CXDependencyOutputOptions DOO) {
  return reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->UsePhonyTargets;
}

void clang_DependencyOutputOptions_setUsePhonyTargets(CXDependencyOutputOptions DOO,
                                                      bool Value) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->UsePhonyTargets = Value;
}

bool clang_DependencyOutputOptions_getAddMissingHeaderDeps(CXDependencyOutputOptions DOO) {
  return reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->AddMissingHeaderDeps;
}

void clang_DependencyOutputOptions_setAddMissingHeaderDeps(CXDependencyOutputOptions DOO,
                                                           bool Value) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->AddMissingHeaderDeps = Value;
}

bool clang_DependencyOutputOptions_getIncludeModuleFiles(CXDependencyOutputOptions DOO) {
  return reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->IncludeModuleFiles;
}

void clang_DependencyOutputOptions_setIncludeModuleFiles(CXDependencyOutputOptions DOO,
                                                         bool Value) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->IncludeModuleFiles = Value;
}

CXDependencyOutputFormat
clang_DependencyOutputOptions_getOutputFormat(CXDependencyOutputOptions DOO) {
  return static_cast<CXDependencyOutputFormat>(
      reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->OutputFormat);
}

void clang_DependencyOutputOptions_setOutputFormat(CXDependencyOutputOptions DOO,
                                                   CXDependencyOutputFormat Format) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->OutputFormat =
      static_cast<clang::DependencyOutputFormat>(Format);
}

// OutputFile
CXString clang_DependencyOutputOptions_getOutputFile(CXDependencyOutputOptions DOO) {
  return extra::makeCXString(
      reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->OutputFile);
}

void clang_DependencyOutputOptions_setOutputFile(CXDependencyOutputOptions DOO,
                                                 const char *Path) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->OutputFile = Path;
}

// Targets
unsigned clang_DependencyOutputOptions_getTargetsNum(CXDependencyOutputOptions DOO) {
  return reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->Targets.size();
}

CXString clang_DependencyOutputOptions_getTarget(CXDependencyOutputOptions DOO,
                                                 unsigned Idx) {
  return extra::makeCXString(
      reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->Targets[Idx]);
}

void clang_DependencyOutputOptions_addTarget(CXDependencyOutputOptions DOO,
                                             const char *Target) {
  reinterpret_cast<clang::DependencyOutputOptions *>(DOO)->Targets.emplace_back(Target);
}
