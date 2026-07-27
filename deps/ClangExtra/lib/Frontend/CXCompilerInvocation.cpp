#include "clang-ex/Frontend/CXCompilerInvocation.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/Utils.h"

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