#include "clang-ex/Lex/CXHeaderSearchOptions.h"
#include "utils.h"
#include "clang/Lex/HeaderSearchOptions.h"
#include "llvm/Support/raw_ostream.h"

namespace {

clang::HeaderSearchOptions *opts(CXHeaderSearchOptions HSO) {
  return reinterpret_cast<clang::HeaderSearchOptions *>(HSO);
}

} // namespace

size_t clang_HeaderSearchOptions_GetResourceDirLength(CXHeaderSearchOptions HSO) {
  return reinterpret_cast<clang::HeaderSearchOptions *>(HSO)->ResourceDir.size();
}

void clang_HeaderSearchOptions_GetResourceDir(CXHeaderSearchOptions HSO, char *ResourcesDir,
                                              size_t N) {
  auto s = reinterpret_cast<clang::HeaderSearchOptions *>(HSO)->ResourceDir;
  std::copy_n(s.begin(), N, ResourcesDir);
}

void clang_HeaderSearchOptions_SetResourceDir(CXHeaderSearchOptions HSO,
                                              const char *ResourcesDir, size_t N) {
  reinterpret_cast<clang::HeaderSearchOptions *>(HSO)->ResourceDir =
      std::string(ResourcesDir, N);
}

CXString clang_HeaderSearchOptions_getSysroot(CXHeaderSearchOptions HSO) {
  return extra::makeCXString(opts(HSO)->Sysroot);
}

void clang_HeaderSearchOptions_setSysroot(CXHeaderSearchOptions HSO, const char *Sysroot) {
  opts(HSO)->Sysroot = Sysroot ? std::string(Sysroot) : std::string();
}

CXString clang_HeaderSearchOptions_getModuleCachePath(CXHeaderSearchOptions HSO) {
  return extra::makeCXString(opts(HSO)->ModuleCachePath);
}

void clang_HeaderSearchOptions_setModuleCachePath(CXHeaderSearchOptions HSO,
                                                  const char *Path) {
  opts(HSO)->ModuleCachePath = Path ? std::string(Path) : std::string();
}

bool clang_HeaderSearchOptions_getUseBuiltinIncludes(CXHeaderSearchOptions HSO) {
  return opts(HSO)->UseBuiltinIncludes;
}

void clang_HeaderSearchOptions_setUseBuiltinIncludes(CXHeaderSearchOptions HSO,
                                                     bool Value) {
  opts(HSO)->UseBuiltinIncludes = Value;
}

bool clang_HeaderSearchOptions_getUseStandardSystemIncludes(CXHeaderSearchOptions HSO) {
  return opts(HSO)->UseStandardSystemIncludes;
}

void clang_HeaderSearchOptions_setUseStandardSystemIncludes(CXHeaderSearchOptions HSO,
                                                            bool Value) {
  opts(HSO)->UseStandardSystemIncludes = Value;
}

bool clang_HeaderSearchOptions_getUseStandardCXXIncludes(CXHeaderSearchOptions HSO) {
  return opts(HSO)->UseStandardCXXIncludes;
}

void clang_HeaderSearchOptions_setUseStandardCXXIncludes(CXHeaderSearchOptions HSO,
                                                         bool Value) {
  opts(HSO)->UseStandardCXXIncludes = Value;
}

bool clang_HeaderSearchOptions_getVerbose(CXHeaderSearchOptions HSO) {
  return opts(HSO)->Verbose;
}

void clang_HeaderSearchOptions_setVerbose(CXHeaderSearchOptions HSO, bool Value) {
  opts(HSO)->Verbose = Value;
}

void clang_HeaderSearchOptions_PrintStats(CXHeaderSearchOptions HSO) {
  auto Opts = reinterpret_cast<clang::HeaderSearchOptions *>(HSO);
  llvm::errs() << "\n*** HeaderSearchOptions Stats:\n";
  llvm::errs() << "  Sysroot: " << Opts->Sysroot << "\n";

  llvm::errs() << "  UserEntries: \n";
  for (const auto &UE : Opts->UserEntries)
    llvm::errs() << "    " << UE.Path << "  (IsFramework:" << UE.IsFramework
                 << "; IgnoreSysRoot:" << UE.IgnoreSysRoot << ")\n";

  llvm::errs() << "  SystemHeaderPrefixes: \n";
  for (const auto &PF : Opts->SystemHeaderPrefixes)
    llvm::errs() << "    " << PF.Prefix << "  (IsSystemHeader:" << PF.IsSystemHeader
                 << ")\n";

  llvm::errs() << "  ResourceDir: " << Opts->ResourceDir << "\n";
  llvm::errs() << "  ModuleCachePath: " << Opts->ModuleCachePath << "\n";
  llvm::errs() << "  ModuleUserBuildPath: " << Opts->ModuleUserBuildPath << "\n";

  llvm::errs() << "  PrebuiltModulePaths: \n";
  for (const auto &Path : Opts->PrebuiltModulePaths)
    llvm::errs() << "    " << Path << "\n";

  llvm::errs() << "  ModuleFormat: " << Opts->ModuleFormat << "\n";

  llvm::errs() << "  VFSOverlayFiles: \n";
  for (const auto &VFS : Opts->VFSOverlayFiles)
    llvm::errs() << "    " << VFS << "\n";

  llvm::errs() << "  Options: \n";
  llvm::errs() << "    UseBuiltinIncludes: " << Opts->UseBuiltinIncludes << "\n";
  llvm::errs() << "    UseStandardSystemIncludes: " << Opts->UseStandardSystemIncludes
               << "\n";
  llvm::errs() << "    UseStandardCXXIncludes: " << Opts->UseStandardCXXIncludes << "\n";
  llvm::errs() << "    UseLibcxx: " << Opts->UseLibcxx << "\n";
  llvm::errs() << "    Verbose: " << Opts->Verbose << "\n";
  llvm::errs() << "    ModulesValidateSystemHeaders: " << Opts->ModulesValidateSystemHeaders
               << "\n";
  llvm::errs() << "    ValidateASTInputFilesContent: " << Opts->ValidateASTInputFilesContent
               << "\n";
  llvm::errs() << "    UseDebugInfo: " << Opts->UseDebugInfo << "\n";
}