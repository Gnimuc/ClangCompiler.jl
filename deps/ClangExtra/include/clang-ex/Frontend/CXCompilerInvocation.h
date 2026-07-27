#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILERINVOCATION_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILERINVOCATION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXCompilerInvocation clang_CompilerInvocation_create(void);

void clang_CompilerInvocation_dispose(CXCompilerInvocation CI);

// Caller-owned on success (share clang_CompilerInvocation_dispose); nullptr when
// the arguments do not parse.
CXCompilerInvocation clang_CompilerInvocation_createFromCommandLine(
    const char **command_line_args_with_src, int num_command_line_args,
    CXDiagnosticsEngine Diags);

// Options
// The option accessors below return borrowed interior views of storage owned by
// the invocation (clang/StaticAnalyzer/Core/AnalyzerOptions.h,
// clang/Frontend/MigratorOptions.h, clang/Basic/FileSystemOptions.h,
// clang/Frontend/DependencyOutputOptions.h,
// clang/Frontend/PreprocessorOutputOptions.h) — never dispose them.
CXLangOptions clang_CompilerInvocation_getLangOpts(CXCompilerInvocation CI);

CXAnalyzerOptions clang_CompilerInvocation_getAnalyzerOpts(CXCompilerInvocation CI);

CXMigratorOptions clang_CompilerInvocation_getMigratorOpts(CXCompilerInvocation CI);

CXFileSystemOptions clang_CompilerInvocation_getFileSystemOpts(CXCompilerInvocation CI);

CXDependencyOutputOptions
clang_CompilerInvocation_getDependencyOutputOpts(CXCompilerInvocation CI);

CXPreprocessorOutputOptions
clang_CompilerInvocation_getPreprocessorOutputOpts(CXCompilerInvocation CI);

// Hash string uniquely identifying the conditions a module built with this
// invocation would be built under. Caller frees it with clang_disposeString.
CXString clang_CompilerInvocation_getModuleHash(CXCompilerInvocation CI);
CXCodeGenOptions clang_CompilerInvocation_getCodeGenOpts(CXCompilerInvocation CI);

CXDiagnosticOptions clang_CompilerInvocation_getDiagnosticOpts(CXCompilerInvocation CI);

CXFrontendOptions clang_CompilerInvocation_getFrontendOpts(CXCompilerInvocation CI);

CXHeaderSearchOptions clang_CompilerInvocation_getHeaderSearchOpts(CXCompilerInvocation CI);

CXPreprocessorOptions clang_CompilerInvocation_getPreprocessorOpts(CXCompilerInvocation CI);

CXTargetOptions clang_CompilerInvocation_getTargetOpts(CXCompilerInvocation CI);

LLVM_CLANG_C_EXTERN_C_END

#endif