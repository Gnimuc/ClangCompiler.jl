#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILERINVOCATION_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILERINVOCATION_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXCompilerInvocation clang_CompilerInvocation_create(CXInit_Error *ErrorCode);

void clang_CompilerInvocation_dispose(CXCompilerInvocation CI);

// CXCompilerInvocation clang_CompilerInvocation_createFromCommandLine(
//     const char **command_line_args_with_src, int num_command_line_args,
//     CXDiagnosticsEngine Diags, CXInit_Error *ErrorCode);

// Options
CXCodeGenOptions clang_CompilerInvocation_getCodeGenOpts(CXCompilerInvocation CI);

CXDiagnosticOptions clang_CompilerInvocation_getDiagnosticOpts(CXCompilerInvocation CI);

CXFrontendOptions clang_CompilerInvocation_getFrontendOpts(CXCompilerInvocation CI);

CXHeaderSearchOptions clang_CompilerInvocation_getHeaderSearchOpts(CXCompilerInvocation CI);

CXPreprocessorOptions clang_CompilerInvocation_getPreprocessorOpts(CXCompilerInvocation CI);

CXTargetOptions clang_CompilerInvocation_getTargetOpts(CXCompilerInvocation CI);

LLVM_CLANG_C_EXTERN_C_END

#endif