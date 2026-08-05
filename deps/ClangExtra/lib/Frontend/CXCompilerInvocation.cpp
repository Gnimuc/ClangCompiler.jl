#include "clang-ex/Frontend/CXCompilerInvocation.h"
#include "utils.h"
#include "clang/Basic/FileSystemOptions.h"
#include "clang/Frontend/DependencyOutputOptions.h"
#include "clang/Frontend/MigratorOptions.h"
#include "clang/Frontend/PreprocessorOutputOptions.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/Utils.h"
#include "clang/APINotes/APINotesOptions.h"
#include "clang/Basic/Diagnostic.h"

CXCompilerInvocation clang_CompilerInvocation_create(void) {
  auto Invoc = std::make_unique<clang::CompilerInvocation>();
  return reinterpret_cast<CXCompilerInvocation>(Invoc.release());
}

void clang_CompilerInvocation_dispose(CXCompilerInvocation CI) {
  delete reinterpret_cast<clang::CompilerInvocation *>(CI);
}

// Runs the driver to translate driver-style arguments (argv[0] excluded) into
// a CompilerInvocation, reporting problems through the borrowed engine — the
// cc1-parsing CompilerInvocation::CreateFromArgs would reject driver flags
// like --target. The explicit Retain pins the engine so the temporary
// IntrusiveRefCntPtr inside CreateInvocationOptions cannot delete it; the
// caller keeps sole ownership (its dispose deletes unconditionally).
CXCompilerInvocation clang_CompilerInvocation_createFromCommandLine(
    const char **command_line_args_with_src, int num_command_line_args,
    CXDiagnosticsEngine Diags) {
  auto *DE = reinterpret_cast<clang::DiagnosticsEngine *>(Diags);
  DE->Retain();
  clang::CreateInvocationOptions Opts;
  Opts.Diags = llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE);
  auto Invoc = clang::createInvocation(
      llvm::ArrayRef(command_line_args_with_src, num_command_line_args), Opts);
  return reinterpret_cast<CXCompilerInvocation>(Invoc.release());
}

// Options
CXLangOptions clang_CompilerInvocation_getLangOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getLangOpts();
  return reinterpret_cast<CXLangOptions>(&Opts);
}

CXAnalyzerOptions clang_CompilerInvocation_getAnalyzerOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getAnalyzerOpts();
  return reinterpret_cast<CXAnalyzerOptions>(&Opts);
}

CXMigratorOptions clang_CompilerInvocation_getMigratorOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getMigratorOpts();
  return reinterpret_cast<CXMigratorOptions>(&Opts);
}

CXFileSystemOptions clang_CompilerInvocation_getFileSystemOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getFileSystemOpts();
  return reinterpret_cast<CXFileSystemOptions>(&Opts);
}

CXDependencyOutputOptions
clang_CompilerInvocation_getDependencyOutputOpts(CXCompilerInvocation CI) {
  auto &Opts =
      reinterpret_cast<clang::CompilerInvocation *>(CI)->getDependencyOutputOpts();
  return reinterpret_cast<CXDependencyOutputOptions>(&Opts);
}

CXPreprocessorOutputOptions
clang_CompilerInvocation_getPreprocessorOutputOpts(CXCompilerInvocation CI) {
  auto &Opts =
      reinterpret_cast<clang::CompilerInvocation *>(CI)->getPreprocessorOutputOpts();
  return reinterpret_cast<CXPreprocessorOutputOptions>(&Opts);
}

CXString clang_CompilerInvocation_getModuleHash(CXCompilerInvocation CI) {
  return extra::makeCXString(
      reinterpret_cast<clang::CompilerInvocation *>(CI)->getModuleHash());
}
CXCodeGenOptions clang_CompilerInvocation_getCodeGenOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getCodeGenOpts();
  return reinterpret_cast<CXCodeGenOptions>(&Opts);
}

CXDiagnosticOptions clang_CompilerInvocation_getDiagnosticOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getDiagnosticOpts();
  return reinterpret_cast<CXDiagnosticOptions>(&Opts);
}

CXFrontendOptions clang_CompilerInvocation_getFrontendOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getFrontendOpts();
  return reinterpret_cast<CXFrontendOptions>(&Opts);
}

CXHeaderSearchOptions
clang_CompilerInvocation_getHeaderSearchOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getHeaderSearchOpts();
  return reinterpret_cast<CXHeaderSearchOptions>(&Opts);
}

CXPreprocessorOptions
clang_CompilerInvocation_getPreprocessorOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getPreprocessorOpts();
  return reinterpret_cast<CXPreprocessorOptions>(&Opts);
}

CXTargetOptions clang_CompilerInvocation_getTargetOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getTargetOpts();
  return reinterpret_cast<CXTargetOptions>(&Opts);
}

CXAPINotesOptions clang_CompilerInvocation_getAPINotesOpts(CXCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CompilerInvocation *>(CI)->getAPINotesOpts();
  return reinterpret_cast<CXAPINotesOptions>(&Opts);
}

CXStringSet *clang_CompilerInvocation_getCC1CommandLine(CXCompilerInvocation CI) {
  return extra::makeCXStringSet(
      reinterpret_cast<clang::CompilerInvocation *>(CI)->getCC1CommandLine());
}

// Option resets
void clang_CompilerInvocation_resetNonModularOptions(CXCompilerInvocation CI) {
  reinterpret_cast<clang::CompilerInvocation *>(CI)->resetNonModularOptions();
}

void clang_CompilerInvocation_clearImplicitModuleBuildOptions(CXCompilerInvocation CI) {
  reinterpret_cast<clang::CompilerInvocation *>(CI)->clearImplicitModuleBuildOptions();
}

// Command-line entry points
bool clang_CompilerInvocation_CreateFromArgs(CXCompilerInvocation Res, const char **Args,
                                             int NumArgs, CXDiagnosticsEngine Diags,
                                             const char *Argv0) {
  return clang::CompilerInvocation::CreateFromArgs(
      *reinterpret_cast<clang::CompilerInvocation *>(Res), llvm::ArrayRef(Args, NumArgs),
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags), Argv0);
}

CXString clang_CompilerInvocation_GetResourcesPath(const char *Argv0, void *MainAddr) {
  return extra::makeCXString(clang::CompilerInvocation::GetResourcesPath(Argv0, MainAddr));
}

bool clang_CompilerInvocation_checkCC1RoundTrip(const char **Args, int NumArgs,
                                                CXDiagnosticsEngine Diags,
                                                const char *Argv0) {
  return clang::CompilerInvocation::checkCC1RoundTrip(
      llvm::ArrayRef(Args, NumArgs), *reinterpret_cast<clang::DiagnosticsEngine *>(Diags),
      Argv0);
}

// CowCompilerInvocation
CXCowCompilerInvocation clang_CowCompilerInvocation_create(void) {
  auto Invoc = std::make_unique<clang::CowCompilerInvocation>();
  return reinterpret_cast<CXCowCompilerInvocation>(Invoc.release());
}

CXCowCompilerInvocation
clang_CowCompilerInvocation_createFromInvocation(CXCompilerInvocation CInv) {
  auto Invoc = std::make_unique<clang::CowCompilerInvocation>(
      *reinterpret_cast<clang::CompilerInvocation *>(CInv));
  return reinterpret_cast<CXCowCompilerInvocation>(Invoc.release());
}

void clang_CowCompilerInvocation_dispose(CXCowCompilerInvocation CI) {
  delete reinterpret_cast<clang::CowCompilerInvocation *>(CI);
}

CXStringSet *clang_CowCompilerInvocation_getCC1CommandLine(CXCowCompilerInvocation CI) {
  return extra::makeCXStringSet(
      reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getCC1CommandLine());
}

// Mutable option accessors
CXLangOptions clang_CowCompilerInvocation_getLangOpts(CXCowCompilerInvocation CI) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(
      &reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getLangOpts()));
}

CXLangOptions clang_CowCompilerInvocation_getMutLangOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutLangOpts();
  return reinterpret_cast<CXLangOptions>(&Opts);
}

CXTargetOptions clang_CowCompilerInvocation_getMutTargetOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutTargetOpts();
  return reinterpret_cast<CXTargetOptions>(&Opts);
}

CXDiagnosticOptions
clang_CowCompilerInvocation_getMutDiagnosticOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutDiagnosticOpts();
  return reinterpret_cast<CXDiagnosticOptions>(&Opts);
}

CXHeaderSearchOptions
clang_CowCompilerInvocation_getMutHeaderSearchOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutHeaderSearchOpts();
  return reinterpret_cast<CXHeaderSearchOptions>(&Opts);
}

CXPreprocessorOptions
clang_CowCompilerInvocation_getMutPreprocessorOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutPreprocessorOpts();
  return reinterpret_cast<CXPreprocessorOptions>(&Opts);
}

CXAnalyzerOptions
clang_CowCompilerInvocation_getMutAnalyzerOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutAnalyzerOpts();
  return reinterpret_cast<CXAnalyzerOptions>(&Opts);
}

CXMigratorOptions
clang_CowCompilerInvocation_getMutMigratorOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutMigratorOpts();
  return reinterpret_cast<CXMigratorOptions>(&Opts);
}

CXAPINotesOptions
clang_CowCompilerInvocation_getMutAPINotesOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutAPINotesOpts();
  return reinterpret_cast<CXAPINotesOptions>(&Opts);
}

CXCodeGenOptions clang_CowCompilerInvocation_getMutCodeGenOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutCodeGenOpts();
  return reinterpret_cast<CXCodeGenOptions>(&Opts);
}

CXFileSystemOptions
clang_CowCompilerInvocation_getMutFileSystemOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutFileSystemOpts();
  return reinterpret_cast<CXFileSystemOptions>(&Opts);
}

CXFrontendOptions
clang_CowCompilerInvocation_getMutFrontendOpts(CXCowCompilerInvocation CI) {
  auto &Opts = reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutFrontendOpts();
  return reinterpret_cast<CXFrontendOptions>(&Opts);
}

CXDependencyOutputOptions
clang_CowCompilerInvocation_getMutDependencyOutputOpts(CXCowCompilerInvocation CI) {
  auto &Opts =
      reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutDependencyOutputOpts();
  return reinterpret_cast<CXDependencyOutputOptions>(&Opts);
}

CXPreprocessorOutputOptions
clang_CowCompilerInvocation_getMutPreprocessorOutputOpts(CXCowCompilerInvocation CI) {
  auto &Opts =
      reinterpret_cast<clang::CowCompilerInvocation *>(CI)->getMutPreprocessorOutputOpts();
  return reinterpret_cast<CXPreprocessorOutputOptions>(&Opts);
}
