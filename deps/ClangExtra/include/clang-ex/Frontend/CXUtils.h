#ifndef LLVM_CLANG_C_EXTRA_CXUTILS_H
#define LLVM_CLANG_C_EXTRA_CXUTILS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// InitializePreprocessor
// DoPrintPreprocessedInput

// DependencyCollector
// Records every file a translation unit reads. Attach it to a preprocessor before the parse
// and read the list back afterwards -- the answer to "which headers would invalidate this
// cached translation unit", which nothing else in this library can produce.
//
// The base class is concrete: sawDependency() keeps everything except <built-in> and system
// files, and needSystemDependencies() is false, so a plain collector already collects the
// user headers. There are no trampolines here; a caller who needs different filtering
// should read the list and filter it.
CXDependencyCollector clang_DependencyCollector_create(void);

// Releases a collector of either class through DependencyCollector's virtual destructor.
// PRECONDITION: nothing it was attached to may still be running. attachToPreprocessor
// installs PPCallbacks that hold this pointer and are owned by the preprocessor, so the
// collector has to outlive every preprocessor it was attached to.
void clang_DependencyCollector_dispose(CXDependencyCollector DC);

// Installs the collector's callbacks on PP. Not an adoption in the ownership sense -- the
// preprocessor owns the callback object it creates, not the collector -- but it does create
// the lifetime constraint the dispose above documents.
void clang_DependencyCollector_attachToPreprocessor(CXDependencyCollector DC,
                                                    CXPreprocessor PP);

unsigned clang_DependencyCollector_getDependenciesNum(CXDependencyCollector DC);

// PRECONDITION: Idx < clang_DependencyCollector_getDependenciesNum. Caller frees the string
// with clang_disposeString.
CXString clang_DependencyCollector_getDependency(CXDependencyCollector DC, unsigned Idx);

// Whether the collector wants system headers offered to it as well. False for the base
// class, and DependencyFileGenerator answers with its options' IncludeSystemHeaders.
bool clang_DependencyCollector_needSystemDependencies(CXDependencyCollector DC);

// Offers one filename to the collector exactly as the preprocessor callbacks would, so a
// caller can seed or extend the list without a parse. Honours sawDependency() and the
// already-seen set, like the callbacks do.
void clang_DependencyCollector_maybeAddDependency(CXDependencyCollector DC,
                                                  const char *Filename, bool FromModule,
                                                  bool IsSystem, bool IsModuleFile,
                                                  bool IsMissing);

// attachToASTReader

// DependencyFileGenerator
// The same collector, writing a make-style .d file when the main file finishes instead of
// only holding the list in memory. Returns the BASE handle and shares the dispose above.
//
// Everything it needs is copied out of Opts here, so Opts may be released or reused
// afterwards. The fields it reads are OutputFile (where the .d goes), Targets (the
// left-hand sides), IncludeSystemHeaders, UsePhonyTargets, AddMissingHeaderDeps,
// IncludeModuleFiles and OutputFormat.
CXDependencyCollector
clang_DependencyFileGenerator_create(CXDependencyOutputOptions Opts);

// Writes the dependency file. Reports err_fe_error_opening through Diags if the output path
// cannot be opened; with an empty OutputFile it writes nothing at all.
// PRECONDITION: the generator must be one clang_DependencyFileGenerator_create returned --
// the base class's finishedMainFile does nothing, so calling this on a plain collector is
// silently a no-op rather than an error.
void clang_DependencyFileGenerator_finishedMainFile(CXDependencyCollector DC,
                                                    CXDiagnosticsEngine Diags);

// ModuleDependencyCollector
// AttachDependencyGraphGen
// AttachHeaderIncludeGen
// createChainedIncludesSource

// createInvocation
// Runs the driver over a full driver-style argv and returns the CompilerInvocation a `-cc1`
// subprocess would have been given. This is the option-carrying entry point;
// clang_CompilerInvocation_createFromCommandLine keeps the older, flag-only signature and
// its own argv[0] convention.
//
// Args[0] is the driver name, NOT the first flag: clang::createInvocation hands it to the
// Driver as the executable path and splices "-fsyntax-only" in at index 1. Passing a flag
// there loses that flag silently.
//
// `Diags` may be NULL, in which case parse problems go to stderr; when given it is borrowed
// and stays owned by the caller.
//
// RecoverOnError asks for a possibly-incorrect invocation instead of NULL when the command
// line does not fully parse. ProbePrecompiled lets the driver look for `X.h.pch` next to an
// `-include X.h` and rewrite it to `-include-pch`, which is the command-line route to
// consuming a precompiled header; clang's own default for it is false and this shim does
// not second-guess that.
//
// When OutCC1Args is non-NULL it receives the `-cc1` argument list the driver produced --
// which the driver fills in even in some cases where the return value is NULL, so it is
// worth asking for on a failure. The set is always written and may be empty. Caller frees
// it with clang_disposeStringSet.
//
// Returns NULL when no invocation could be determined. Caller-owned on success; release it
// with clang_CompilerInvocation_dispose.
CXCompilerInvocation clang_createInvocation(const char **Args, int NumArgs,
                                            CXDiagnosticsEngine Diags, bool RecoverOnError,
                                            bool ProbePrecompiled,
                                            CXStringSet **OutCC1Args);

LLVM_CLANG_C_EXTERN_C_END

#endif
