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

CXAPINotesOptions clang_CompilerInvocation_getAPINotesOpts(CXCompilerInvocation CI);

// The `-cc1` command line that reproduces this invocation, regenerated on every
// call (the strings are copies, not views into the invocation). Caller frees the
// set with clang_disposeStringSet.
CXStringSet *clang_CompilerInvocation_getCC1CommandLine(CXCompilerInvocation CI);

// Option resets
// Both mutate the invocation in place and leave it usable.
void clang_CompilerInvocation_resetNonModularOptions(CXCompilerInvocation CI);

void clang_CompilerInvocation_clearImplicitModuleBuildOptions(CXCompilerInvocation CI);

// Command-line entry points
// Fills `Res` from a `-cc1` argument list, which must NOT contain "-cc1" itself,
// reporting problems through the borrowed engine. Returns false on a parse error;
// recovery is best-effort, so `Res` ends up in an arbitrary but valid-to-access
// state either way. Neither `Res` nor `Diags` is adopted. `Argv0` may be NULL;
// when given it is the program path the default resource directory comes from.
bool clang_CompilerInvocation_CreateFromArgs(CXCompilerInvocation Res, const char **Args,
                                             int NumArgs, CXDiagnosticsEngine Diags,
                                             const char *Argv0);

// Pure path arithmetic over the located executable — nothing on disk is checked.
// `MainAddr` may be NULL: it is only consulted by the dladdr fallback inside
// llvm::sys::fs::getMainExecutable, which macOS, Linux and Windows do not take.
// Caller frees the string with clang_disposeString.
CXString clang_CompilerInvocation_GetResourcesPath(const char *Argv0, void *MainAddr);

// Checks that `Args` parses and re-serializes unchanged, reporting every
// difference through the borrowed engine. Only meaningful for command lines that
// are already canonical, such as one getCC1CommandLine produced. `Diags` is not
// adopted. `Argv0` may be NULL.
bool clang_CompilerInvocation_checkCC1RoundTrip(const char **Args, int NumArgs,
                                                CXDiagnosticsEngine Diags,
                                                const char *Argv0);

// CowCompilerInvocation
// clang::CowCompilerInvocation is a copy-on-write sibling of CompilerInvocation:
// both derive from CompilerInvocationBase, but neither derives from the other, so
// CXCowCompilerInvocation is a separate handle type and only the accessors below
// accept it. Passing one to a clang_CompilerInvocation_* function is undefined.
CXCowCompilerInvocation clang_CowCompilerInvocation_create(void);

// Deep-copies every option object out of `CInv`. `CInv` is NOT adopted: it keeps
// its own storage, stays independently usable, and its owner still disposes it.
// The returned invocation is caller-owned (clang_CowCompilerInvocation_dispose).
CXCowCompilerInvocation
clang_CowCompilerInvocation_createFromInvocation(CXCompilerInvocation CInv);

void clang_CowCompilerInvocation_dispose(CXCowCompilerInvocation CI);

// The `-cc1` command line that reproduces this invocation, regenerated on every
// call. Caller frees the set with clang_disposeStringSet.
CXStringSet *clang_CowCompilerInvocation_getCC1CommandLine(CXCowCompilerInvocation CI);

// Mutable option accessors
// Each one first detaches this invocation's copy-on-write storage for that option
// object from any invocation still sharing it, then returns a borrowed interior
// view of this invocation's own copy — never dispose a return value.
// Read-only view of this invocation's clang::LangOptions — unlike getMutLangOpts it does
// NOT detach the copy-on-write storage, so it is safe to call for a query such as
// clang_LangOptions_hasLangStandard.
CXLangOptions clang_CowCompilerInvocation_getLangOpts(CXCowCompilerInvocation CI);

CXLangOptions clang_CowCompilerInvocation_getMutLangOpts(CXCowCompilerInvocation CI);

CXTargetOptions clang_CowCompilerInvocation_getMutTargetOpts(CXCowCompilerInvocation CI);

CXDiagnosticOptions
clang_CowCompilerInvocation_getMutDiagnosticOpts(CXCowCompilerInvocation CI);

CXHeaderSearchOptions
clang_CowCompilerInvocation_getMutHeaderSearchOpts(CXCowCompilerInvocation CI);

CXPreprocessorOptions
clang_CowCompilerInvocation_getMutPreprocessorOpts(CXCowCompilerInvocation CI);

CXAnalyzerOptions
clang_CowCompilerInvocation_getMutAnalyzerOpts(CXCowCompilerInvocation CI);

CXMigratorOptions
clang_CowCompilerInvocation_getMutMigratorOpts(CXCowCompilerInvocation CI);

CXAPINotesOptions
clang_CowCompilerInvocation_getMutAPINotesOpts(CXCowCompilerInvocation CI);

CXCodeGenOptions clang_CowCompilerInvocation_getMutCodeGenOpts(CXCowCompilerInvocation CI);

CXFileSystemOptions
clang_CowCompilerInvocation_getMutFileSystemOpts(CXCowCompilerInvocation CI);

CXFrontendOptions
clang_CowCompilerInvocation_getMutFrontendOpts(CXCowCompilerInvocation CI);

CXDependencyOutputOptions
clang_CowCompilerInvocation_getMutDependencyOutputOpts(CXCowCompilerInvocation CI);

CXPreprocessorOutputOptions
clang_CowCompilerInvocation_getMutPreprocessorOutputOpts(CXCowCompilerInvocation CI);

LLVM_CLANG_C_EXTERN_C_END

#endif