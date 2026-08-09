#ifndef LLVM_CLANG_C_EXTRA_CXASTUNIT_H
#define LLVM_CLANG_C_EXTRA_CXASTUNIT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Frontend/ASTUnit.h: enum class clang::CaptureDiagsKind
typedef enum CXCaptureDiagsKind {
  CXCaptureDiagsKind_None,
  CXCaptureDiagsKind_All,
  CXCaptureDiagsKind_AllWithoutNonErrorsFromIncludes,
} CXCaptureDiagsKind;

// A unit built by clang_ASTUnit_create owns a FileManager, a SourceManager and
// the diagnostics engine it was handed, but no Preprocessor, ASTContext or
// Sema: those appear only once a parse has run (or, for the context, once
// clang_ASTUnit_setASTContext has installed one). Each accessor below that
// reaches one of them restates that as a precondition.

bool clang_ASTUnit_isMainFileAST(CXASTUnit AU);

// The bit CIndex uses to mark a unit that is in an inconsistent state and must
// not be freed. clang::ASTUnit declares it as a bit-field with no in-class
// initializer, so its value before the first clang_ASTUnit_setUnsafeToFree is
// whatever the constructor left there and is not part of this API's contract.
bool clang_ASTUnit_isUnsafeToFree(CXASTUnit AU);

void clang_ASTUnit_setUnsafeToFree(CXASTUnit AU, bool Value);

// isUnsafeToFree
// setUnsafeToFree

CXDiagnosticsEngine clang_ASTUnit_getDiagnostics(CXASTUnit AU);

CXSourceManager clang_ASTUnit_getSourceManager(CXASTUnit AU);

// helper: whether a parse has installed a preprocessor yet, i.e. whether
// clang_ASTUnit_getPreprocessor returns a non-null handle.
bool clang_ASTUnit_hasPreprocessor(CXASTUnit AU);

// Total: reads PP through getPreprocessorPtr instead of dereferencing it, so a unit that
// has never parsed yields nullptr rather than tripping libstdc++'s shared_ptr assertion.
CXPreprocessor clang_ASTUnit_getPreprocessor(CXASTUnit AU);

// getPreprocessorPtr

// PRECONDITION: the unit must have an AST context, installed either by a parse
// or by clang_ASTUnit_setASTContext. The member is a null IntrusiveRefCntPtr
// otherwise and the accessor returns *Ctx.
CXASTContext clang_ASTUnit_getASTContext(CXASTUnit AU);

// Not an adoption: the context is stored in an IntrusiveRefCntPtr, so this
// retains it and the unit's destructor releases it. Whoever created the context
// (a CompilerInstance) keeps its own reference and its own ownership.
void clang_ASTUnit_setASTContext(CXASTUnit AU, CXASTContext Ctx);

// setPreprocessor
// enableSourceFileDiagnostics

bool clang_ASTUnit_hasSema(CXASTUnit AU);

// PRECONDITION: clang_ASTUnit_hasSema. The C++ accessor asserts on it.
CXSema clang_ASTUnit_getSema(CXASTUnit AU);

// getLangOpts
// getHeaderSearchOpts
// getPreprocessorOpts

CXFileManager clang_ASTUnit_getFileManager(CXASTUnit AU);

// Borrowed view of the unit's own FileSystemOptions. Unlike the language,
// header-search and preprocessor option sets — which the unit keeps in
// std::shared_ptr members and whose accessors dereference them — this one is a
// by-value member, so it is valid on a unit that has never parsed.
CXFileSystemOptions clang_ASTUnit_getFileSystemOpts(CXASTUnit AU);

// getFileSystemOpts
// getASTReader

// Caller frees the string with clang_disposeString.
CXString clang_ASTUnit_getOriginalSourceFileName(CXASTUnit AU);

// getASTMutationListener
// getDeserializationListener

bool clang_ASTUnit_getOnlyLocalDecls(CXASTUnit AU);

bool clang_ASTUnit_getOwnsRemappedFileBuffers(CXASTUnit AU);

void clang_ASTUnit_setOwnsRemappedFileBuffers(CXASTUnit AU, bool Value);

// Caller frees the string with clang_disposeString. Empty when the unit has
// neither a frontend input nor a main file registered.
CXString clang_ASTUnit_getMainFileName(CXASTUnit AU);

// getASTFileName

// Top-level declarations.
// PRECONDITION for all four: !clang_ASTUnit_isMainFileAST — the C++ range
// accessors assert on it, because a unit loaded from an AST file keeps its
// top-level declarations in the serialized reader instead.
// The count is exact and no slot is null.
size_t clang_ASTUnit_top_level_size(CXASTUnit AU);

bool clang_ASTUnit_top_level_empty(CXASTUnit AU);

// helper — the index half of a count+index pair over top_level_begin(), which
// is random-access (std::vector<Decl *>::iterator).
// PRECONDITION: Index < clang_ASTUnit_top_level_size.
CXDecl clang_ASTUnit_getTopLevelDecl(CXASTUnit AU, unsigned Index);

// The unit does not own the declaration; it appends the pointer only.
void clang_ASTUnit_addTopLevelDecl(CXASTUnit AU, CXDecl D);

// File-level declarations.
// The unit does not own the declaration; the table stores the pointer only.
// PRECONDITION: D's location must belong to the unit's OWN source manager --
// the implementation decomposes it there, and a location minted by another
// SourceManager indexes an entry table that does not describe it. Declarations
// that came from an AST file, or whose location is invalid or non-local, are
// dropped silently.
void clang_ASTUnit_addFileLevelDecl(CXASTUnit AU, CXDecl D);

// findFileRegionDecls: two-call protocol, because the C++ method appends into a
// SmallVectorImpl instead of exposing a container. getNumFileRegionDecls runs
// the search and reports the count; findFileRegionDecls runs it again and fills
// a caller buffer of exactly that size. Length may be 0 to designate a point at
// Offset. The count is exact and no slot is null.
// PRECONDITION for both: File must come from the unit's own source manager, and
// the unit must have an AST context with an external source whenever File is a
// loaded (AST-file) FileID -- Clang asserts on that one.
size_t clang_ASTUnit_getNumFileRegionDecls(CXASTUnit AU, CXFileID File, unsigned Offset,
                                           unsigned Length);

void clang_ASTUnit_findFileRegionDecls(CXASTUnit AU, CXFileID File, unsigned Offset,
                                       unsigned Length, CXDecl *Buf);

// The running hash of the top-level declaration and macro definition names that
// the top-level tracking action maintains while parsing.
unsigned clang_ASTUnit_getCurrentTopLevelHashValue(CXASTUnit AU);

// helper — the write half of the C++ accessor, which hands back an `unsigned &`
// the C surface cannot express.
void clang_ASTUnit_setCurrentTopLevelHashValue(CXASTUnit AU, unsigned Value);

// Unlike clang_SourceManager_translateFileLineCol this checks whether the
// requested position lies inside the precompiled preamble, returning a "loaded"
// location when it does.
// PRECONDITION: Line and Col are one-based; clang::SourceManager asserts that
// both are non-zero. The result is an invalid location when File has no FileID
// in the unit's source manager.
CXSourceLocation_ clang_ASTUnit_getLocation(CXASTUnit AU, CXFileEntry File, unsigned Line,
                                            unsigned Col);

// Both mappings hand Loc straight back when the unit has no precompiled
// preamble, which is every unit built by clang_ASTUnit_create.
CXSourceLocation_ clang_ASTUnit_mapLocationFromPreamble(CXASTUnit AU,
                                                        CXSourceLocation_ Loc);

CXSourceLocation_ clang_ASTUnit_mapLocationToPreamble(CXASTUnit AU, CXSourceLocation_ Loc);

// PRECONDITION for both: Loc must come from the unit's own source manager.
// False when Loc is invalid or the unit has no such FileID.
bool clang_ASTUnit_isInPreambleFileID(CXASTUnit AU, CXSourceLocation_ Loc);

bool clang_ASTUnit_isInMainFileID(CXASTUnit AU, CXSourceLocation_ Loc);

// Invalid location when the unit's source manager has no main file ID.
CXSourceLocation_ clang_ASTUnit_getStartOfMainFileID(CXASTUnit AU);

// Invalid location when the unit has no precompiled preamble.
CXSourceLocation_ clang_ASTUnit_getEndOfPreambleFileID(CXASTUnit AU);

// Both endpoints go through the matching mapLocation*Preamble.
CXSourceRange_ clang_ASTUnit_mapRangeFromPreamble(CXASTUnit AU, CXSourceRange_ R);

CXSourceRange_ clang_ASTUnit_mapRangeToPreamble(CXASTUnit AU, CXSourceRange_ R);

// How many times a precompiled preamble has been built for this unit.
unsigned clang_ASTUnit_getPreambleCounterForTests(CXASTUnit AU);

// Stored diagnostics. A unit only fills this vector while parsing, and only
// when it was created with a capturing CXCaptureDiagsKind.
// The count is exact and no slot is null.
size_t clang_ASTUnit_stored_diag_size(CXASTUnit AU);

// helper — the index half of a count+index pair over stored_diag_begin(), which
// is random-access (the iterator is a plain StoredDiagnostic *). The result is
// a BORROWED interior pointer into the unit's own vector: never pass it to
// clang_StoredDiagnostic_dispose, and re-read it after anything that reparses
// the unit.
// PRECONDITION: Index < clang_ASTUnit_stored_diag_size.
CXStoredDiagnostic clang_ASTUnit_getStoredDiagnostic(CXASTUnit AU, unsigned Index);

// helper — the index stored_diag_afterDriver_begin() denotes, i.e. how many of
// the stored diagnostics came from the driver rather than from the parse. Like
// the C++ accessor this clamps a stale driver count back to 0.
size_t clang_ASTUnit_stored_diag_afterDriver_index(CXASTUnit AU);

// Cached global code-completion results; 0 unless the unit caches them.
size_t clang_ASTUnit_cached_completion_size(CXASTUnit AU);

// visitLocalTopLevelDecls

// heap-boxes the `clang::FileEntryRef` (call `clang_FileEntryRef_dispose` to
// release); returns nullptr when the unit included no precompiled header.
CXFileEntryRef clang_ASTUnit_getPCHFile(CXASTUnit AU);

bool clang_ASTUnit_isModuleFile(CXASTUnit AU);

// The buffer is caller-owned: release it with LLVMDisposeMemoryBuffer. Returns
// nullptr when the file cannot be read, after logging the error message.
LLVMMemoryBufferRef clang_ASTUnit_getBufferForFile(CXASTUnit AU, const char *Filename);

CXTranslationUnitKind clang_ASTUnit_getTranslationUnitKind(CXASTUnit AU);

// addFileLevelDecl
// findFileRegionDecls
// getLocation
// mapLocationFromPreamble
// mapLocationToPreamble
// mapRangeFromPreamble
// mapRangeToPreamble
// getStartOfMainFileID
// getEndOfPreambleFileID
// isInMainFileID
// isInPreambleFileID
// visitLocalTopLevelDecls
// getPCHFile
// isModuleFile
// getBufferForFile
// getTranslationUnitKind
// getInputKind

// Creates an empty parse-based unit (clang::ASTUnit::create).
// ADOPTION: the invocation is rewrapped in a fresh shared_ptr and freed with
// the unit, so calling clang_CompilerInvocation_dispose on it afterwards is a
// double free. The diagnostics engine stays the caller's: it is pinned with an
// explicit Retain (MARSHALLING.md section 12) so the unit's release cannot
// delete it.
CXASTUnit clang_ASTUnit_create(CXCompilerInvocation CI, CXDiagnosticsEngine Diags,
                               CXCaptureDiagsKind CaptureDiagnostics,
                               bool UserFilesAreVolatile);

void clang_ASTUnit_dispose(CXASTUnit AU);

// clang/Frontend/ASTUnit.h: enum clang::ASTUnit::WhatToLoad
typedef enum CXASTUnit_WhatToLoad {
  CXASTUnit_LoadPreprocessorOnly,
  CXASTUnit_LoadASTOnly,
  CXASTUnit_LoadEverything
} CXASTUnit_WhatToLoad;

// Reads a serialized AST back from disk, returning nullptr when the file could not be
// loaded (the reason goes to Diags). Caller-owned: release with clang_ASTUnit_dispose.
// This is the only way to obtain a unit whose main file and original source file differ:
// clang_ASTUnit_getMainFileName then names Filename while
// clang_ASTUnit_getOriginalSourceFileName names the source the AST was built from.
// Diags stays the caller's: it lands in an IntrusiveRefCntPtr member, so it is pinned with
// an explicit Retain (MARSHALLING.md section 12) and must outlive the unit.
// FileSystemOpts is borrowed and copied; pass NULL for a default-constructed set.
// HSOpts is COPIED rather than adopted -- clang wants a std::shared_ptr and rewrapping a
// borrowed handle in one would make the unit's release free the caller's object
// (MARSHALLING.md section 14). Pass NULL for a default-constructed set.
// PCHContainerOperations and the VFS are not part of the C surface: the shim supplies the
// raw PCH container reader and the real file system, which are clang's own defaults.
CXASTUnit clang_ASTUnit_LoadFromASTFile(const char *Filename, CXASTUnit_WhatToLoad ToLoad,
                                        CXDiagnosticsEngine Diags,
                                        CXFileSystemOptions FileSystemOpts,
                                        CXHeaderSearchOptions HSOpts, bool OnlyLocalDecls,
                                        CXCaptureDiagsKind CaptureDiagnostics,
                                        bool AllowASTWithCompilerErrors,
                                        bool UserFilesAreVolatile);

// LoadFromCompilerInvocationAction

// Runs a whole frontend parse of the invocation's single input file and returns the
// resulting unit, or nullptr when the parse could not be set up. Caller-owned: release it
// with clang_ASTUnit_dispose. Unlike a unit from clang_ASTUnit_create, the result carries
// a Preprocessor, an ASTContext, a Sema and the file's top-level declarations.
// ADOPTION: CI is rewrapped in a fresh shared_ptr and freed with the unit -- including on
// the failure path, where the unit is destroyed before this returns -- so calling
// clang_CompilerInvocation_dispose on it afterwards is a double free.
// Diags and FileMgr stay the caller's: the unit holds each in an IntrusiveRefCntPtr, so
// both are pinned with an explicit Retain (MARSHALLING.md section 12) and the unit's
// release cannot delete them. Both must still outlive the unit, which points at them.
// PRECONDITION: FileMgr must be non-null -- its file-system options are copied before the
// parse -- and the invocation must carry exactly one input, of source kind and not LLVM
// IR: clang reads Inputs[0] unconditionally and asserts on the rest.
// PCHContainerOperations is not part of the C surface; the shim supplies a
// default-constructed one, which registers the raw PCH container reader and writer.
// PrecompilePreambleAfterNParses > 0 builds a precompiled preamble, writing temporary PCH
// files; 0 disables preambles, and this library wraps no Reparse.
CXASTUnit clang_ASTUnit_LoadFromCompilerInvocation(
    CXCompilerInvocation CI, CXDiagnosticsEngine Diags, CXFileManager FileMgr,
    bool OnlyLocalDecls, CXCaptureDiagsKind CaptureDiagnostics,
    unsigned PrecompilePreambleAfterNParses, CXTranslationUnitKind TUKind,
    bool CacheCodeCompletionResults, bool IncludeBriefCommentsInCodeCompletion,
    bool UserFilesAreVolatile);

// LoadFromCommandLine
// Reparse
// ResetForParse
// CodeComplete

// Serializes the translation unit to File as a Clang AST file, through
// llvm::writeToOutput: a "<File>.temp-stream-%%%%%%" temporary renamed into place once it
// is written ("-" writes to stdout and "/dev/null" discards, as everywhere in LLVM).
// Returns TRUE on error and false on success -- clang's sense, not the usual one.
// PRECONDITION: clang_ASTUnit_hasSema. Serialization builds its ASTWriter over
// ASTUnit::getSema(), which asserts when the unit holds no Sema -- the state every unit
// clang_ASTUnit_create produces is in. Second precondition, from libclang's own gate
// around this call: serializing an AST that holds invalid nodes can crash the writer, so
// clang_DiagnosticsEngine_hasUnrecoverableErrorOccurred must be false on the unit's
// engine. libclang covers that case with a CrashRecoveryContext instead; this library has
// no such net.
// Every failure reports the same flag: a unit whose module loader failed fatally refuses
// to write, as does a temporary that cannot be created, written or renamed. Diagnostics
// are not a failure -- an AST with errors is written, carrying its uncompilable-error bit.
bool clang_ASTUnit_Save(CXASTUnit AU, const char *File);

// serialize

LLVM_CLANG_C_EXTERN_C_END

#endif
