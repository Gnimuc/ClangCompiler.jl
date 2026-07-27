#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILERINSTANCE_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILERINSTANCE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXCompilerInstance clang_CompilerInstance_create(void);

void clang_CompilerInstance_dispose(CXCompilerInstance CI);

// Diagnostics
bool clang_CompilerInstance_hasDiagnostics(CXCompilerInstance CI);

CXDiagnosticsEngine clang_CompilerInstance_getDiagnostics(CXCompilerInstance CI);

void clang_CompilerInstance_setDiagnostics(CXCompilerInstance CI,
                                           CXDiagnosticsEngine Value);

CXDiagnosticConsumer clang_CompilerInstance_getDiagnosticClient(CXCompilerInstance CI);

void clang_CompilerInstance_createDiagnostics(CXCompilerInstance CI,
                                              CXDiagnosticConsumer DC,
                                              bool ShouldOwnClient);

// FileManager
bool clang_CompilerInstance_hasFileManager(CXCompilerInstance CI);

CXFileManager clang_CompilerInstance_getFileManager(CXCompilerInstance CI);

void clang_CompilerInstance_setFileManager(CXCompilerInstance CI, CXFileManager FM);

CXFileManager clang_CompilerInstance_createFileManager(CXCompilerInstance CI);

CXFileManager clang_CompilerInstance_createFileManagerWithVOFS4PCH(
    CXCompilerInstance CI, const char *Path, time_t ModificationTime,
    LLVMMemoryBufferRef PCHBuffer);

// SourceManager
bool clang_CompilerInstance_hasSourceManager(CXCompilerInstance CI);

CXSourceManager clang_CompilerInstance_getSourceManager(CXCompilerInstance CI);

void clang_CompilerInstance_setSourceManager(CXCompilerInstance CI, CXSourceManager SM);

void clang_CompilerInstance_createSourceManager(CXCompilerInstance CI,
                                                CXFileManager FileMgr);

// Invocation
bool clang_CompilerInstance_hasInvocation(CXCompilerInstance CI);

CXCompilerInvocation clang_CompilerInstance_getInvocation(CXCompilerInstance CI);

void clang_CompilerInstance_setInvocation(CXCompilerInstance CI, CXCompilerInvocation CInv);

// Target
bool clang_CompilerInstance_hasTarget(CXCompilerInstance CI);

CXTargetInfo_ clang_CompilerInstance_getTarget(CXCompilerInstance CI);

void clang_CompilerInstance_setTarget(CXCompilerInstance CI, CXTargetInfo_ Info);

void clang_CompilerInstance_setTargetAndLangOpts(CXCompilerInstance CI);

// Preprocessor
bool clang_CompilerInstance_hasPreprocessor(CXCompilerInstance CI);

CXPreprocessor clang_CompilerInstance_getPreprocessor(CXCompilerInstance CI);

void clang_CompilerInstance_setPreprocessor(CXCompilerInstance CI, CXPreprocessor PP);

void clang_CompilerInstance_createPreprocessor(CXCompilerInstance CI,
                                               CXTranslationUnitKind TUKind);

// Sema
bool clang_CompilerInstance_hasSema(CXCompilerInstance CI);

CXSema clang_CompilerInstance_getSema(CXCompilerInstance CI);

void clang_CompilerInstance_setSema(CXCompilerInstance CI, CXSema S);

void clang_CompilerInstance_createSema(CXCompilerInstance CI, CXTranslationUnitKind TUKind);

// ASTContext
bool clang_CompilerInstance_hasASTContext(CXCompilerInstance CI);

CXASTContext clang_CompilerInstance_getASTContext(CXCompilerInstance CI);

void clang_CompilerInstance_setASTContext(CXCompilerInstance CI, CXASTContext Ctx);

void clang_CompilerInstance_createASTContext(CXCompilerInstance CI);

// ASTConsumer
bool clang_CompilerInstance_hasASTConsumer(CXCompilerInstance CI);

CXASTConsumer clang_CompilerInstance_getASTConsumer(CXCompilerInstance CI);

void clang_CompilerInstance_setASTConsumer(CXCompilerInstance CI, CXASTConsumer CG);

// Options
CXCodeGenOptions clang_CompilerInstance_getCodeGenOpts(CXCompilerInstance CI);

CXDiagnosticOptions clang_CompilerInstance_getDiagnosticOpts(CXCompilerInstance CI);

CXFrontendOptions clang_CompilerInstance_getFrontendOpts(CXCompilerInstance CI);

CXHeaderSearchOptions clang_CompilerInstance_getHeaderSearchOpts(CXCompilerInstance CI);

CXPreprocessorOptions clang_CompilerInstance_getPreprocessorOpts(CXCompilerInstance CI);

CXTargetOptions clang_CompilerInstance_getTargetOpts(CXCompilerInstance CI);

CXLangOptions clang_CompilerInstance_getLangOpts(CXCompilerInstance CI);

// Action
bool clang_CompilerInstance_ExecuteAction(CXCompilerInstance CI, CXFrontendAction Act);

// Forwarding options
// PRECONDITION for every accessor in this block: the instance must have an
// invocation (clang_CompilerInstance_hasInvocation) — CompilerInstance forwards
// through an unchecked `Invocation->` dereference. Returns are borrowed views.
CXAnalyzerOptions clang_CompilerInstance_getAnalyzerOpts(CXCompilerInstance CI);

CXDependencyOutputOptions
clang_CompilerInstance_getDependencyOutputOpts(CXCompilerInstance CI);

CXFileSystemOptions clang_CompilerInstance_getFileSystemOpts(CXCompilerInstance CI);

CXPreprocessorOutputOptions
clang_CompilerInstance_getPreprocessorOutputOpts(CXCompilerInstance CI);

CXAPINotesOptions clang_CompilerInstance_getAPINotesOpts(CXCompilerInstance CI);

// Module loading
// PRECONDITION: requires an invocation (reads FrontendOpts through it).
bool clang_CompilerInstance_shouldBuildGlobalModuleIndex(CXCompilerInstance CI);

void clang_CompilerInstance_setBuildGlobalModuleIndex(CXCompilerInstance CI, bool Build);

bool clang_CompilerInstance_hadModuleLoaderFatalFailure(CXCompilerInstance CI);

// PRECONDITION: requires an invocation (reads HeaderSearchOpts and the module
// hash through it). Caller frees the string with clang_disposeString.
CXString clang_CompilerInstance_getSpecificModuleCachePath(CXCompilerInstance CI);

// AuxTarget
// PRECONDITION: requires an invocation and diagnostics (reads TargetOpts and
// reports through getDiagnostics()).
bool clang_CompilerInstance_createTarget(CXCompilerInstance CI);

// Returns NULL when no auxiliary target has been set.
CXTargetInfo_ clang_CompilerInstance_getAuxTarget(CXCompilerInstance CI);

void clang_CompilerInstance_setAuxTarget(CXCompilerInstance CI, CXTargetInfo_ Info);

// Code completion
bool clang_CompilerInstance_hasCodeCompletionConsumer(CXCompilerInstance CI);

// Output files
// The underlying output streams must have been closed beforehand.
void clang_CompilerInstance_clearOutputFiles(CXCompilerInstance CI, bool EraseFiles);

// Plugins
// PRECONDITION: requires an invocation (reads FrontendOpts through it).
void clang_CompilerInstance_LoadRequestedPlugins(CXCompilerInstance CI);

// Frontend timer
bool clang_CompilerInstance_hasFrontendTimer(CXCompilerInstance CI);

// getFrontendTimer is not exposed as a handle: llvm::Timer is an LLVM type with
// no llvm-c representation (MARSHALLING.md section 0), so the timer's state is
// published through these two composite accessors instead of a parallel CX type.
// PRECONDITION for both: clang_CompilerInstance_hasFrontendTimer — the C++
// accessor asserts on it.
// helper. Caller frees the string with clang_disposeString.
CXString clang_CompilerInstance_getFrontendTimerName(CXCompilerInstance CI);

// helper.
bool clang_CompilerInstance_isFrontendTimerRunning(CXCompilerInstance CI);

void clang_CompilerInstance_createFrontendTimer(CXCompilerInstance CI);

// Ownership transfer
// Each of these drops the instance's ownership of a component without destroying
// it: the object goes to llvm::BuryPointer and lives until the process exits.
// They are the escape hatch for a component some other owner has already adopted.
void clang_CompilerInstance_resetAndLeakFileManager(CXCompilerInstance CI);

void clang_CompilerInstance_resetAndLeakSourceManager(CXCompilerInstance CI);

// Buries a *copy* of the owning shared_ptr, so unlike its siblings this leaves the
// instance's own pointer in place: hasPreprocessor still holds afterwards.
void clang_CompilerInstance_resetAndLeakPreprocessor(CXCompilerInstance CI);

void clang_CompilerInstance_resetAndLeakASTContext(CXCompilerInstance CI);

void clang_CompilerInstance_resetAndLeakSema(CXCompilerInstance CI);

// --- The module-building flag, inherited from clang::ModuleLoader --------------------
//
// BuildingModule is set by the ModuleLoader constructor (clang/Lex/ModuleLoader.h), so
// both of these are total.

// Whether this instance is building a module.
bool clang_CompilerInstance_buildingModule(CXCompilerInstance CI);

// Set whether this instance is building a module.
void clang_CompilerInstance_setBuildingModule(CXCompilerInstance CI, bool Flag);

LLVM_CLANG_C_EXTERN_C_END

#endif