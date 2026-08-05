#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILERINSTANCE_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILERINSTANCE_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Lex/CXPreprocessorOptions.h"
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
    CXCompilerInstance CI, const char *Path, int64_t ModificationTime,
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

// Removes the current AST consumer and hands ownership to the caller: the instance's
// unique_ptr is emptied, so clang_CompilerInstance_hasASTConsumer is false afterwards.
// Returns NULL when none was set. There is deliberately no clang_ASTConsumer_dispose: the
// only consumer this API can produce is an Interpreter's CodeGenerator, which that
// interpreter still owns, so a taken handle must be re-installed with setASTConsumer or
// dropped -- never deleted.
CXASTConsumer clang_CompilerInstance_takeASTConsumer(CXCompilerInstance CI);

// helper. Builds a FrontendInputFile for Path -- InputKind(Language::Unknown,
// InputKind::Source), not preprocessed, not a header unit -- and initializes the instance's
// source manager with it as the main file, so getMainFileID names it afterwards. IsSystem
// selects the FileID's CharacteristicKind (C_System rather than C_User). Only the input
// kind's *format* is read, which is why the language is left unspecified.
// Returns false and reports err_fe_error_reading through the instance's diagnostics engine
// when the file cannot be read; that diagnostic is an error, not a fatal one, so the engine
// stays usable. Path of "-" would read the process's standard input (FileManager::getSTDIN);
// the Julia wrapper rejects it.
// PRECONDITION: the instance must have diagnostics, a file manager and a source manager --
// the member overload forwards through getDiagnostics()/getFileManager()/getSourceManager(),
// each of which asserts on a null member.
bool clang_CompilerInstance_InitializeSourceManagerFromFile(CXCompilerInstance CI,
                                                            const char *Path, bool IsSystem);

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

// Attach an external AST source that reads the precompiled header at Path to this
// instance's AST context. Nothing is returned: on failure nothing is attached and the
// reason is reported through the instance's diagnostics engine, so
// clang_CompilerInstance_hasASTReader is the success signal.
// DisableValidation does more than pick which checks are fatal: with its PCH bit set the
// ASTReader is built with a SimpleASTReaderListener instead of a PCHValidator, so a
// language-option, target or version mismatch is neither diagnosed nor a failure. A
// structurally invalid file is still refused and still diagnosed either way.
// DeserializationListener is clang's own `void *` -- clang casts it to
// ASTDeserializationListener * internally. This package can construct no listener, so the
// Julia wrapper always passes NULL and false.
// PRECONDITION: requires an invocation (the body reads HeaderSearchOpts, PreprocessorOpts
// and FrontendOpts through the unchecked `Invocation->` forwarders), a preprocessor and an
// AST context (getPreprocessor() and getASTContext() each assert on a null member). One
// more precondition has no flag to gate on and is documented instead: the reader is
// attached to the AST context, so this must run before anything parses into that context.
// The body also reaches getPCHContainerReader(), which calls
// llvm::report_fatal_error("unknown module format") when HeaderSearchOptions::ModuleFormat
// names a format PCHContainerOperations never registered. Latent today because nothing
// here exposes ModuleFormat, so it keeps its "raw" default; a ModuleFormat setter must
// arrive together with a gate on this.
void clang_CompilerInstance_createPCHExternalASTSource(
    CXCompilerInstance CI, const char *Path,
    CXDisableValidationForModuleKind DisableValidation,
    bool AllowPCHWithCompilerErrors, void *DeserializationListener,
    bool OwnDeserializationListener);

// helper. Whether a PCH or module file has been loaded into this instance -- that is,
// whether clang_CompilerInstance_createPCHExternalASTSource succeeded -- the gate that a
// void loader has to export rather than document (MARSHALLING.md section 13). Total: the
// C++ getter returns the member, which is null until something loads it.
// Deliberately a predicate rather than a CXASTReader handle: clang::ASTReader has no
// wrapped accessors, so a handle would be a type a caller could hold and do nothing with.
bool clang_CompilerInstance_hasASTReader(CXCompilerInstance CI);

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