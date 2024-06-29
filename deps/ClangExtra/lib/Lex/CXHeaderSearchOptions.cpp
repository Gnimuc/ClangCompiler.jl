#include "clang-ex/Lex/CXHeaderSearchOptions.h"
#include "clang/Lex/HeaderSearchOptions.h"
#include "llvm/Support/raw_ostream.h"

size_t clang_HeaderSearchOptions_GetResourceDirLength(CXHeaderSearchOptions HSO) {
  return static_cast<clang::HeaderSearchOptions *>(HSO)->ResourceDir.size();
}

void clang_HeaderSearchOptions_GetResourceDir(CXHeaderSearchOptions HSO, char *ResourcesDir,
                                              size_t N) {
  auto s = static_cast<clang::HeaderSearchOptions *>(HSO)->ResourceDir;
  std::copy_n(s.begin(), N, ResourcesDir);
}

void clang_HeaderSearchOptions_SetResourceDir(CXHeaderSearchOptions HSO,
                                              const char *ResourcesDir, size_t N) {
  static_cast<clang::HeaderSearchOptions *>(HSO)->ResourceDir =
      std::string(ResourcesDir, N);
}

void clang_HeaderSearchOptions_PrintStats(CXHeaderSearchOptions HSO) {
  auto Opts = static_cast<clang::HeaderSearchOptions *>(HSO);
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