#include "clang-ex/Frontend/CXCompilerInvocation.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/Utils.h"
#include <cstdio>

CXCompilerInvocation clang_CompilerInvocation_create(CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CompilerInvocation> ptr =
      std::make_unique<clang::CompilerInvocation>();

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::CompilerInvocation`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_CompilerInvocation_dispose(CXCompilerInvocation CI) {
  delete static_cast<clang::CompilerInvocation *>(CI);
}

CXCompilerInvocation clang_CompilerInvocation_createFromCommandLine(
    const char **command_line_args_with_src, int num_command_line_args,
    CXDiagnosticsEngine Diags, CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CompilerInvocation> ptr = clang::createInvocationFromCommandLine(
      llvm::makeArrayRef(command_line_args_with_src, num_command_line_args),
      llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(
          static_cast<clang::DiagnosticsEngine *>(Diags)));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::CompilerInvocation`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
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