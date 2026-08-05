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
  return Invoc.release();
}

void clang_CompilerInvocation_dispose(CXCompilerInvocation CI) {
  delete static_cast<clang::CompilerInvocation *>(CI);
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
  auto *DE = static_cast<clang::DiagnosticsEngine *>(Diags);
  DE->Retain();
  clang::CreateInvocationOptions Opts;
  Opts.Diags = llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE);
  auto Invoc = clang::createInvocation(
      llvm::ArrayRef(command_line_args_with_src, num_command_line_args), Opts);
  return Invoc.release();
}

// Options
CXLangOptions clang_CompilerInvocation_getLangOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getLangOpts();
  return &Opts;
}

CXAnalyzerOptions clang_CompilerInvocation_getAnalyzerOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getAnalyzerOpts();
  return &Opts;
}

CXMigratorOptions clang_CompilerInvocation_getMigratorOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getMigratorOpts();
  return &Opts;
}

CXFileSystemOptions clang_CompilerInvocation_getFileSystemOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getFileSystemOpts();
  return &Opts;
}

CXDependencyOutputOptions
clang_CompilerInvocation_getDependencyOutputOpts(CXCompilerInvocation CI) {
  auto &Opts =
      static_cast<clang::CompilerInvocation *>(CI)->getDependencyOutputOpts();
  return &Opts;
}

CXPreprocessorOutputOptions
clang_CompilerInvocation_getPreprocessorOutputOpts(CXCompilerInvocation CI) {
  auto &Opts =
      static_cast<clang::CompilerInvocation *>(CI)->getPreprocessorOutputOpts();
  return &Opts;
}

CXString clang_CompilerInvocation_getModuleHash(CXCompilerInvocation CI) {
  return extra::makeCXString(
      static_cast<clang::CompilerInvocation *>(CI)->getModuleHash());
}
CXCodeGenOptions clang_CompilerInvocation_getCodeGenOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getCodeGenOpts();
  return &Opts;
}

CXDiagnosticOptions clang_CompilerInvocation_getDiagnosticOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getDiagnosticOpts();
  return &Opts;
}

CXFrontendOptions clang_CompilerInvocation_getFrontendOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getFrontendOpts();
  return &Opts;
}

CXHeaderSearchOptions
clang_CompilerInvocation_getHeaderSearchOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getHeaderSearchOpts();
  return &Opts;
}

CXPreprocessorOptions
clang_CompilerInvocation_getPreprocessorOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getPreprocessorOpts();
  return &Opts;
}

CXTargetOptions clang_CompilerInvocation_getTargetOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getTargetOpts();
  return &Opts;
}

CXAPINotesOptions clang_CompilerInvocation_getAPINotesOpts(CXCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CompilerInvocation *>(CI)->getAPINotesOpts();
  return &Opts;
}

CXStringSet *clang_CompilerInvocation_getCC1CommandLine(CXCompilerInvocation CI) {
  return extra::makeCXStringSet(
      static_cast<clang::CompilerInvocation *>(CI)->getCC1CommandLine());
}

// Option resets
void clang_CompilerInvocation_resetNonModularOptions(CXCompilerInvocation CI) {
  static_cast<clang::CompilerInvocation *>(CI)->resetNonModularOptions();
}

void clang_CompilerInvocation_clearImplicitModuleBuildOptions(CXCompilerInvocation CI) {
  static_cast<clang::CompilerInvocation *>(CI)->clearImplicitModuleBuildOptions();
}

// Command-line entry points
bool clang_CompilerInvocation_CreateFromArgs(CXCompilerInvocation Res, const char **Args,
                                             int NumArgs, CXDiagnosticsEngine Diags,
                                             const char *Argv0) {
  return clang::CompilerInvocation::CreateFromArgs(
      *static_cast<clang::CompilerInvocation *>(Res), llvm::ArrayRef(Args, NumArgs),
      *static_cast<clang::DiagnosticsEngine *>(Diags), Argv0);
}

CXString clang_CompilerInvocation_GetResourcesPath(const char *Argv0, void *MainAddr) {
  return extra::makeCXString(clang::CompilerInvocation::GetResourcesPath(Argv0, MainAddr));
}

bool clang_CompilerInvocation_checkCC1RoundTrip(const char **Args, int NumArgs,
                                                CXDiagnosticsEngine Diags,
                                                const char *Argv0) {
  return clang::CompilerInvocation::checkCC1RoundTrip(
      llvm::ArrayRef(Args, NumArgs), *static_cast<clang::DiagnosticsEngine *>(Diags),
      Argv0);
}

// CowCompilerInvocation
CXCowCompilerInvocation clang_CowCompilerInvocation_create(void) {
  auto Invoc = std::make_unique<clang::CowCompilerInvocation>();
  return Invoc.release();
}

CXCowCompilerInvocation
clang_CowCompilerInvocation_createFromInvocation(CXCompilerInvocation CInv) {
  auto Invoc = std::make_unique<clang::CowCompilerInvocation>(
      *static_cast<clang::CompilerInvocation *>(CInv));
  return Invoc.release();
}

void clang_CowCompilerInvocation_dispose(CXCowCompilerInvocation CI) {
  delete static_cast<clang::CowCompilerInvocation *>(CI);
}

CXStringSet *clang_CowCompilerInvocation_getCC1CommandLine(CXCowCompilerInvocation CI) {
  return extra::makeCXStringSet(
      static_cast<clang::CowCompilerInvocation *>(CI)->getCC1CommandLine());
}

// Mutable option accessors
CXLangOptions clang_CowCompilerInvocation_getLangOpts(CXCowCompilerInvocation CI) {
  return const_cast<clang::LangOptions *>(
      &static_cast<clang::CowCompilerInvocation *>(CI)->getLangOpts());
}

CXLangOptions clang_CowCompilerInvocation_getMutLangOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutLangOpts();
  return &Opts;
}

CXTargetOptions clang_CowCompilerInvocation_getMutTargetOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutTargetOpts();
  return &Opts;
}

CXDiagnosticOptions
clang_CowCompilerInvocation_getMutDiagnosticOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutDiagnosticOpts();
  return &Opts;
}

CXHeaderSearchOptions
clang_CowCompilerInvocation_getMutHeaderSearchOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutHeaderSearchOpts();
  return &Opts;
}

CXPreprocessorOptions
clang_CowCompilerInvocation_getMutPreprocessorOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutPreprocessorOpts();
  return &Opts;
}

CXAnalyzerOptions
clang_CowCompilerInvocation_getMutAnalyzerOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutAnalyzerOpts();
  return &Opts;
}

CXMigratorOptions
clang_CowCompilerInvocation_getMutMigratorOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutMigratorOpts();
  return &Opts;
}

CXAPINotesOptions
clang_CowCompilerInvocation_getMutAPINotesOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutAPINotesOpts();
  return &Opts;
}

CXCodeGenOptions clang_CowCompilerInvocation_getMutCodeGenOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutCodeGenOpts();
  return &Opts;
}

CXFileSystemOptions
clang_CowCompilerInvocation_getMutFileSystemOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutFileSystemOpts();
  return &Opts;
}

CXFrontendOptions
clang_CowCompilerInvocation_getMutFrontendOpts(CXCowCompilerInvocation CI) {
  auto &Opts = static_cast<clang::CowCompilerInvocation *>(CI)->getMutFrontendOpts();
  return &Opts;
}

CXDependencyOutputOptions
clang_CowCompilerInvocation_getMutDependencyOutputOpts(CXCowCompilerInvocation CI) {
  auto &Opts =
      static_cast<clang::CowCompilerInvocation *>(CI)->getMutDependencyOutputOpts();
  return &Opts;
}

CXPreprocessorOutputOptions
clang_CowCompilerInvocation_getMutPreprocessorOutputOpts(CXCowCompilerInvocation CI) {
  auto &Opts =
      static_cast<clang::CowCompilerInvocation *>(CI)->getMutPreprocessorOutputOpts();
  return &Opts;
}
