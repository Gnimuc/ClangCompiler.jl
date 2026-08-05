#ifndef LLVM_CLANG_C_EXTRA_CXSOURCEMANAGER_H
#define LLVM_CLANG_C_EXTRA_CXSOURCEMANAGER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXSourceManager clang_SourceManager_create(CXDiagnosticsEngine Diag, CXFileManager FileMgr,
                                           bool UserFilesAreVolatile);

void clang_SourceManager_dispose(CXSourceManager SM);

void clang_SourceManager_PrintStats(CXSourceManager SM);

// dumps the whole SLocEntry table to stderr.
void clang_SourceManager_dump(CXSourceManager SM);

bool clang_FileID_isValid(CXFileID FID);

bool clang_FileID_isInvalid(CXFileID FID);

// this allocates; call `clang_FileID_dispose` to release.
CXFileID clang_FileID_getSentinel(void);

unsigned clang_FileID_getHashValue(CXFileID FID);

void clang_FileID_dispose(CXFileID FID);

CXFileID clang_SourceManager_createFileIDFromMemoryBuffer(CXSourceManager SM,
                                                          LLVMMemoryBufferRef MB);

CXFileID clang_SourceManager_createFileIDFromFileEntry(CXSourceManager SM,
                                                       CXFileEntryRef FER,
                                                       CXSourceLocation_ Loc);

CXFileID clang_SourceManager_getMainFileID(CXSourceManager SM);

void clang_SourceManager_setMainFileID(CXSourceManager SM, CXFileID ID);

void clang_SourceManager_overrideFileContents(CXSourceManager SM, CXFileEntryRef FER,
                                              LLVMMemoryBufferRef MB);

CXSourceLocation_ clang_SourceManager_getLocForStartOfFile(CXSourceManager SM,
                                                           CXFileID FID);

CXSourceLocation_ clang_SourceManager_getLocForEndOfFile(CXSourceManager SM, CXFileID FID);

// clang/Basic/SourceManager.h: enum SrcMgr::CharacteristicKind, mirrored in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXCharacteristicKind {
  CXCharacteristicKind_C_User,
  CXCharacteristicKind_C_System,
  CXCharacteristicKind_C_ExternCSystem,
  CXCharacteristicKind_C_User_ModuleMap,
  CXCharacteristicKind_C_System_ModuleMap
} CXCharacteristicKind;

CXDiagnosticsEngine clang_SourceManager_getDiagnostics(CXSourceManager SM);

CXFileManager clang_SourceManager_getFileManager(CXSourceManager SM);

// defaults to true.
void clang_SourceManager_setOverridenFilesKeepOriginalName(CXSourceManager SM, bool Value);

bool clang_SourceManager_userFilesAreVolatile(CXSourceManager SM);

// drops every FileID/SLocEntry the manager has handed out and restarts its address space,
// so every SourceLocation and CXFileID obtained earlier is stale afterwards.
void clang_SourceManager_clearIDTables(CXSourceManager SM);

// Initializes SM to replay the compilation `Old` describes, inheriting `Old`'s content
// caches as *unowned* buffer views — so `Old` must outlive SM. SM must still be fresh (its
// main FileID unset); replaying into a manager that already handed out FileIDs corrupts its
// address space.
void clang_SourceManager_initializeForReplay(CXSourceManager SM, CXSourceManager Old);

// helper: the size of `getModuleBuildStack()`.
unsigned clang_SourceManager_getModuleBuildStackSize(CXSourceManager SM);

// helper: one entry of `getModuleBuildStack()`. `Index` must be <
// `clang_SourceManager_getModuleBuildStackSize`. Returns the borrowed module name (*Length
// is filled when non-null); *ImportLoc receives the import location when non-null. Both
// dangle once the stack is mutated.
const char *clang_SourceManager_getModuleBuildStackEntry(CXSourceManager SM, unsigned Index,
                                                         size_t *Length,
                                                         CXSourceLocation_ *ImportLoc);

// ImportLoc is paired with SM itself to build the `clang::FullSourceLoc` Clang stores.
void clang_SourceManager_pushModuleBuildStack(CXSourceManager SM, const char *ModuleName,
                                              CXSourceLocation_ ImportLoc);

bool clang_SourceManager_isMainFile(CXSourceManager SM, CXFileEntry FE);

// this allocates; call `clang_FileID_dispose` to release. The returned FileID is invalid
// (hash value 0) when no precompiled preamble was set.
CXFileID clang_SourceManager_getPreambleFileID(CXSourceManager SM);

// the preamble FileID must not have been set already — Clang asserts it.
void clang_SourceManager_setPreambleFileID(CXSourceManager SM, CXFileID Preamble);

// this allocates; call `clang_FileID_dispose` to release.
CXFileID clang_SourceManager_getOrCreateFileID(CXSourceManager SM, CXFileEntryRef FER,
                                               CXCharacteristicKind FileCharacter);

// creates the SLocEntry for substituting a macro argument into a function-like macro's
// body and returns the start of the expansion.
CXSourceLocation_ clang_SourceManager_createMacroArgExpansionLoc(
    CXSourceManager SM, CXSourceLocation_ SpellingLoc, CXSourceLocation_ ExpansionLoc,
    unsigned Length);

// creates the SLocEntry for one macro use and returns the start of the expansion. The macro
// body begins at SpellingLoc and runs for Length bytes; the use spans
// [ExpansionLocStart, ExpansionLocEnd]. LoadedID/LoadedOffset place the entry in the loaded
// half of the address space and are 0 for a locally created expansion.
CXSourceLocation_ clang_SourceManager_createExpansionLoc(
    CXSourceManager SM, CXSourceLocation_ SpellingLoc, CXSourceLocation_ ExpansionLocStart,
    CXSourceLocation_ ExpansionLocEnd, unsigned Length, bool ExpansionIsTokenRange,
    int LoadedID, uint32_t LoadedOffset);

// TokenStart and TokenEnd must be in the same FileID — Clang asserts it.
CXSourceLocation_ clang_SourceManager_createTokenSplitLoc(CXSourceManager SM,
                                                          CXSourceLocation_ SpellingLoc,
                                                          CXSourceLocation_ TokenStart,
                                                          CXSourceLocation_ TokenEnd);

// borrowed; *Length is filled when non-null. Returns nullptr when the file has no valid
// buffer (the std::nullopt case).
const char *clang_SourceManager_getMemoryBufferDataForFileOrNone(CXSourceManager SM,
                                                                 CXFileEntryRef FER,
                                                                 size_t *Length);

// borrowed; *Length is filled when non-null. Falls back to Clang's fake recovery buffer
// when the file has no valid one, so the result is never nullptr.
const char *clang_SourceManager_getMemoryBufferDataForFileOrFake(CXSourceManager SM,
                                                                 CXFileEntryRef FER,
                                                                 size_t *Length);

bool clang_SourceManager_isFileOverridden(CXSourceManager SM, CXFileEntry FE);

// `clang_SourceManager_isFileOverridden` must hold for FER's file — Clang asserts it.
// Heap-boxes the resulting `clang::FileEntryRef` (call `clang_FileEntryRef_dispose` to
// release) and returns nullptr when the bypassed file is not in the filesystem (the
// std::nullopt case). Call it before parsing begins.
CXFileEntryRef clang_SourceManager_bypassFileContentsOverride(CXSourceManager SM,
                                                              CXFileEntryRef FER);

void clang_SourceManager_setFileIsTransient(CXSourceManager SM, CXFileEntryRef FER);

void clang_SourceManager_setAllFilesAreTransient(CXSourceManager SM, bool Transient);

// borrowed; returns nullptr when the FileID has no file entry (e.g. a memory-buffer
// FileID).
CXFileEntry clang_SourceManager_getFileEntryForID(CXSourceManager SM, CXFileID FID);

// heap-boxes the `clang::FileEntryRef` (call `clang_FileEntryRef_dispose` to release);
// returns nullptr when the FileID has no file entry.
CXFileEntryRef clang_SourceManager_getFileEntryRefForID(CXSourceManager SM, CXFileID FID);

// borrowed; *Length is filled when non-null. Returns nullptr for non-files and built-in
// buffers (the std::nullopt case).
const char *clang_SourceManager_getNonBuiltinFilenameForID(CXSourceManager SM, CXFileID FID,
                                                           size_t *Length);

// borrowed; `clang_SLocEntry_isFile` must hold for E — Clang asserts it. Returns nullptr
// when the entry's content cache records no file entry.
CXFileEntry clang_SourceManager_getFileEntryForSLocEntry(CXSourceManager SM, CXSLocEntry E);

// borrowed pointer into the buffer, exactly *Length bytes; *Length and *Invalid are
// filled when non-null.
const char *clang_SourceManager_getBufferData(CXSourceManager SM, CXFileID FID,
                                              size_t *Length, bool *Invalid);

// borrowed; *Length is filled when non-null. Returns nullptr when the buffer is invalid
// (the std::nullopt case).
const char *clang_SourceManager_getBufferDataOrNone(CXSourceManager SM, CXFileID FID,
                                                    size_t *Length);

// borrowed; *Length is filled when non-null. Falls back to Clang's fake recovery buffer
// when the buffer is invalid, so the result is never nullptr. Loc is where a "cannot open
// file" diagnostic is reported.
const char *clang_SourceManager_getBufferDataOrFake(CXSourceManager SM, CXFileID FID,
                                                    CXSourceLocation_ Loc, size_t *Length);

// borrowed; *Length is filled when non-null. Returns nullptr when the buffer has not been
// loaded yet (the std::nullopt case).
const char *clang_SourceManager_getBufferDataIfLoaded(CXSourceManager SM, CXFileID FID,
                                                      size_t *Length);

unsigned clang_SourceManager_getNumCreatedFIDsForFileID(CXSourceManager SM, CXFileID FID);

// Force must be true unless `clang_SourceManager_getNumCreatedFIDsForFileID` is still 0 —
// Clang asserts it.
void clang_SourceManager_setNumCreatedFIDsForFileID(CXSourceManager SM, CXFileID FID,
                                                    unsigned NumFIDs, bool Force);

// this allocates; call `clang_FileID_dispose` to release.
CXFileID clang_SourceManager_getFileID(CXSourceManager SM, CXSourceLocation_ Loc);

// borrowed; *Length is filled when non-null (an empty name yields nullptr data).
const char *clang_SourceManager_getFilename(CXSourceManager SM, CXSourceLocation_ Loc,
                                            size_t *Length);

CXSourceLocation_ clang_SourceManager_getIncludeLoc(CXSourceManager SM, CXFileID FID);

CXSourceLocation_ clang_SourceManager_getExpansionLoc(CXSourceManager SM,
                                                      CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceManager_getFileLoc(CXSourceManager SM, CXSourceLocation_ Loc);

// returns the import location of the module Loc lives in; *ModuleName (borrowed) and
// *NameLength are filled when non-null. The location is invalid and the name empty when
// Loc is in the current translation unit rather than in a loaded module.
CXSourceLocation_ clang_SourceManager_getModuleImportLoc(CXSourceManager SM,
                                                         CXSourceLocation_ Loc,
                                                         const char **ModuleName,
                                                         size_t *NameLength);

// Loc must be an expansion (macro) location; *IsTokenRange is filled when non-null.
CXSourceRange_ clang_SourceManager_getImmediateExpansionRange(CXSourceManager SM,
                                                              CXSourceLocation_ Loc,
                                                              bool *IsTokenRange);

// *IsTokenRange is filled when non-null.
CXSourceRange_ clang_SourceManager_getExpansionRange(CXSourceManager SM,
                                                     CXSourceLocation_ Loc,
                                                     bool *IsTokenRange);

CXSourceLocation_ clang_SourceManager_getSpellingLoc(CXSourceManager SM,
                                                     CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceManager_getImmediateSpellingLoc(CXSourceManager SM,
                                                              CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceManager_getComposedLoc(CXSourceManager SM, CXFileID FID,
                                                     unsigned Offset);

// this allocates (the returned FileID); call `clang_FileID_dispose` to release.
// *Offset is filled when non-null.
CXFileID clang_SourceManager_getDecomposedLoc(CXSourceManager SM, CXSourceLocation_ Loc,
                                              unsigned *Offset);

// this allocates (the returned FileID); call `clang_FileID_dispose` to release.
// *Offset is filled when non-null.
CXFileID clang_SourceManager_getDecomposedExpansionLoc(CXSourceManager SM,
                                                       CXSourceLocation_ Loc,
                                                       unsigned *Offset);

// this allocates (the returned FileID); call `clang_FileID_dispose` to release.
// *Offset is filled when non-null.
CXFileID clang_SourceManager_getDecomposedSpellingLoc(CXSourceManager SM,
                                                      CXSourceLocation_ Loc,
                                                      unsigned *Offset);

// this allocates (the returned FileID); call `clang_FileID_dispose` to release.
// *Offset is filled when non-null.
CXFileID clang_SourceManager_getDecomposedIncludedLoc(CXSourceManager SM, CXFileID FID,
                                                      unsigned *Offset);

unsigned clang_SourceManager_getFileOffset(CXSourceManager SM, CXSourceLocation_ Loc);

// *StartLoc (when non-null) receives the macro-argument start location, or an invalid
// location when the predicate is false.
bool clang_SourceManager_isMacroArgExpansion(CXSourceManager SM, CXSourceLocation_ Loc,
                                             CXSourceLocation_ *StartLoc);

bool clang_SourceManager_isMacroBodyExpansion(CXSourceManager SM, CXSourceLocation_ Loc);

// Loc must be a valid macro location; *MacroBegin as in isMacroArgExpansion's *StartLoc.
bool clang_SourceManager_isAtStartOfImmediateMacroExpansion(CXSourceManager SM,
                                                            CXSourceLocation_ Loc,
                                                            CXSourceLocation_ *MacroBegin);

// Loc must be a valid macro location; *MacroEnd as in isMacroArgExpansion's *StartLoc.
bool clang_SourceManager_isAtEndOfImmediateMacroExpansion(CXSourceManager SM,
                                                          CXSourceLocation_ Loc,
                                                          CXSourceLocation_ *MacroEnd);

// [Start, Start + Length) must be a valid chunk of one half of the SLoc address space —
// Clang asserts it. *RelativeOffset (when non-null) is written only when the function
// returns true.
bool clang_SourceManager_isInSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ Loc,
                                           CXSourceLocation_ Start, unsigned Length,
                                           uint32_t *RelativeOffset);

// *RelativeOffset (when non-null) receives the offset of RHS relative to LHS, and is
// written only when the function returns true.
bool clang_SourceManager_isInSameSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ LHS,
                                               CXSourceLocation_ RHS,
                                               int32_t *RelativeOffset);

// borrowed pointer into the spelling buffer (buffers are NUL-terminated at buffer end).
const char *clang_SourceManager_getCharacterData(CXSourceManager SM, CXSourceLocation_ Loc,
                                                 bool *Invalid);

unsigned clang_SourceManager_getColumnNumber(CXSourceManager SM, CXFileID FID,
                                             unsigned FilePos, bool *Invalid);

unsigned clang_SourceManager_getSpellingColumnNumber(CXSourceManager SM,
                                                     CXSourceLocation_ Loc, bool *Invalid);

unsigned clang_SourceManager_getExpansionColumnNumber(CXSourceManager SM,
                                                      CXSourceLocation_ Loc,
                                                      bool *Invalid);

unsigned clang_SourceManager_getPresumedColumnNumber(CXSourceManager SM,
                                                     CXSourceLocation_ Loc, bool *Invalid);

unsigned clang_SourceManager_getLineNumber(CXSourceManager SM, CXFileID FID,
                                           unsigned FilePos, bool *Invalid);

unsigned clang_SourceManager_getSpellingLineNumber(CXSourceManager SM,
                                                   CXSourceLocation_ Loc, bool *Invalid);

unsigned clang_SourceManager_getExpansionLineNumber(CXSourceManager SM,
                                                    CXSourceLocation_ Loc, bool *Invalid);

unsigned clang_SourceManager_getPresumedLineNumber(CXSourceManager SM,
                                                   CXSourceLocation_ Loc, bool *Invalid);

// borrowed; *Length and *Invalid are filled when non-null.
const char *clang_SourceManager_getBufferName(CXSourceManager SM, CXSourceLocation_ Loc,
                                              size_t *Length, bool *Invalid);

CXCharacteristicKind clang_SourceManager_getFileCharacteristic(CXSourceManager SM,
                                                               CXSourceLocation_ Loc);

// decomposed `clang::PresumedLoc`: returns false when the presumed location is invalid
// (out-params untouched); *Filename is borrowed line-table storage.
bool clang_SourceManager_getPresumedLoc(CXSourceManager SM, CXSourceLocation_ Loc,
                                        bool UseLineDirectives, const char **Filename,
                                        unsigned *Line, unsigned *Col,
                                        CXSourceLocation_ *IncludeLoc);

bool clang_SourceManager_isInMainFile(CXSourceManager SM, CXSourceLocation_ Loc);

bool clang_SourceManager_isWrittenInSameFile(CXSourceManager SM, CXSourceLocation_ Loc1,
                                             CXSourceLocation_ Loc2);

bool clang_SourceManager_isWrittenInMainFile(CXSourceManager SM, CXSourceLocation_ Loc);

bool clang_SourceManager_isWrittenInBuiltinFile(CXSourceManager SM, CXSourceLocation_ Loc);

bool clang_SourceManager_isWrittenInCommandLineFile(CXSourceManager SM,
                                                    CXSourceLocation_ Loc);

bool clang_SourceManager_isWrittenInScratchSpace(CXSourceManager SM,
                                                 CXSourceLocation_ Loc);

bool clang_SourceManager_isInSystemHeader(CXSourceManager SM, CXSourceLocation_ Loc);

bool clang_SourceManager_isInExternCSystemHeader(CXSourceManager SM,
                                                 CXSourceLocation_ Loc);

bool clang_SourceManager_isInSystemMacro(CXSourceManager SM, CXSourceLocation_ Loc);

unsigned clang_SourceManager_getFileIDSize(CXSourceManager SM, CXFileID FID);

// *RelativeOffset (when non-null) is filled only when the function returns true.
bool clang_SourceManager_isInFileID(CXSourceManager SM, CXSourceLocation_ Loc, CXFileID FID,
                                    unsigned *RelativeOffset);

unsigned clang_SourceManager_getLineTableFilenameID(CXSourceManager SM, const char *Str);

// FilenameID is -1 for "unspecified", otherwise it comes from
// `clang_SourceManager_getLineTableFilenameID`. Clang asserts that notes are added to one
// FileID in strictly increasing offset order; the call also flips that file's
// hasLineDirectives flag.
void clang_SourceManager_AddLineNote(CXSourceManager SM, CXSourceLocation_ Loc,
                                     unsigned LineNo, int FilenameID, bool IsFileEntry,
                                     bool IsFileExit, CXCharacteristicKind FileKind);

bool clang_SourceManager_hasLineTable(CXSourceManager SM);

size_t clang_SourceManager_getContentCacheSize(CXSourceManager SM);

// *MallocBytes and *MmapBytes are filled when non-null.
void clang_SourceManager_getMemoryBufferSizes(CXSourceManager SM, size_t *MallocBytes,
                                              size_t *MmapBytes);

size_t clang_SourceManager_getDataStructureSizes(CXSourceManager SM);

CXSourceLocation_ clang_SourceManager_translateFileLineCol(CXSourceManager SM,
                                                           CXFileEntry FE, unsigned Line,
                                                           unsigned Col);

// this allocates; call `clang_FileID_dispose` to release.
CXFileID clang_SourceManager_translateFile(CXSourceManager SM, CXFileEntry FE);

CXSourceLocation_ clang_SourceManager_translateLineCol(CXSourceManager SM, CXFileID FID,
                                                       unsigned Line, unsigned Col);

CXSourceLocation_ clang_SourceManager_getMacroArgExpandedLocation(CXSourceManager SM,
                                                                  CXSourceLocation_ Loc);

bool clang_SourceManager_isBeforeInTranslationUnit(CXSourceManager SM,
                                                   CXSourceLocation_ LHS,
                                                   CXSourceLocation_ RHS);

// Decides whether two decomposed (FileID, offset) locations live in the same translation
// unit and, as a byproduct, orders them. Both pairs are walked up to their common ancestor
// file and written back in place, so the two CXFileID boxes are mutated (they stay
// caller-owned and are still released with clang_FileID_dispose). LOffset and ROffset must
// be non-null; *IsLHSBeforeRHS receives the ordering when non-null and is meaningful only
// when the return value is true.
bool clang_SourceManager_isInTheSameTranslationUnit(CXSourceManager SM, CXFileID LFID,
                                                    unsigned *LOffset, CXFileID RFID,
                                                    unsigned *ROffset,
                                                    bool *IsLHSBeforeRHS);

// The same-translation-unit question alone; leaves both decomposed locations untouched.
bool clang_SourceManager_isInTheSameTranslationUnitImpl(CXSourceManager SM, CXFileID LFID,
                                                        unsigned LOffset, CXFileID RFID,
                                                        unsigned ROffset);

bool clang_SourceManager_isBeforeInSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ LHS,
                                                 CXSourceLocation_ RHS);

bool clang_SourceManager_isPointWithin(CXSourceManager SM, CXSourceLocation_ Location,
                                       CXSourceLocation_ Start, CXSourceLocation_ End);

// helper: how many (file, content cache) pairs the fileinfo iteration walks.
unsigned clang_SourceManager_getNumFileInfos(CXSourceManager SM);

// helper: the whole fileinfo map in one walk. `Files` and `Caches` each need
// `clang_SourceManager_getNumFileInfos` slots; either may be null to skip that half. Both
// halves are borrowed and die with the SourceManager, and the map is a DenseMap, so the
// order is unspecified and changes as files are added.
void clang_SourceManager_getFileInfos(CXSourceManager SM, CXFileEntry *Files,
                                      CXContentCache *Caches);

bool clang_SourceManager_hasFileInfo(CXSourceManager SM, CXFileEntry File);

// Reports through Diag how much of the source location address space each file occupies.
// `HasMaxNotes` is the engaged state of Clang's `std::optional<unsigned>` cap: when false
// the cap is absent and every file is named, otherwise at most `MaxNotes` files are.
void clang_SourceManager_noteSLocAddressSpaceUsage(CXSourceManager SM,
                                                   CXDiagnosticsEngine Diag,
                                                   bool HasMaxNotes, unsigned MaxNotes);

unsigned clang_SourceManager_local_sloc_entry_size(CXSourceManager SM);

// borrowed; `Index` must be < `clang_SourceManager_local_sloc_entry_size` (Clang asserts).
// The returned pointer dangles once the SLocEntry table grows.
CXSLocEntry clang_SourceManager_getLocalSLocEntry(CXSourceManager SM, unsigned Index);

unsigned clang_SourceManager_loaded_sloc_entry_size(CXSourceManager SM);

// borrowed, as `clang_SourceManager_getLocalSLocEntry`. `Index` must be <
// `clang_SourceManager_loaded_sloc_entry_size` (Clang asserts). *Invalid is filled when
// non-null.
CXSLocEntry clang_SourceManager_getLoadedSLocEntry(CXSourceManager SM, unsigned Index,
                                                   bool *Invalid);

// borrowed, as `clang_SourceManager_getLocalSLocEntry`. *Invalid is filled when non-null;
// it is set for the invalid/sentinel FileID, whose local entry 0 is returned instead.
CXSLocEntry clang_SourceManager_getSLocEntry(CXSourceManager SM, CXFileID FID,
                                             bool *Invalid);

uint32_t clang_SourceManager_getNextLocalOffset(CXSourceManager SM);

bool clang_SourceManager_isLoadedSourceLocation(CXSourceManager SM, CXSourceLocation_ Loc);

bool clang_SourceManager_isLocalSourceLocation(CXSourceManager SM, CXSourceLocation_ Loc);

// FID must not be the sentinel FileID (hash value 0xFFFFFFFF); Clang asserts it.
bool clang_SourceManager_isLoadedFileID(CXSourceManager SM, CXFileID FID);

// FID must not be the sentinel FileID (hash value 0xFFFFFFFF); Clang asserts it.
bool clang_SourceManager_isLocalFileID(CXSourceManager SM, CXFileID FID);

CXSourceLocation_ clang_SourceManager_getImmediateMacroCallerLoc(CXSourceManager SM,
                                                                 CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceManager_getTopMacroCallerLoc(CXSourceManager SM,
                                                           CXSourceLocation_ Loc);

// clang/Basic/SourceManager.h: SrcMgr::LineOffsetMapping — the byte offset at which each
// physical line of a buffer starts. The offsets live in a bump allocator the mapping does
// not own, so the box owns the allocator alongside the value: this create allocates,
// release it with `clang_LineOffsetMapping_dispose`. `Buffer` is read only during the call
// and need not outlive the mapping.
CXLineOffsetMapping clang_LineOffsetMapping_create(const char *Buffer, size_t Length,
                                                   const char *BufferName);

void clang_LineOffsetMapping_dispose(CXLineOffsetMapping M);

// the number of physical lines the mapped buffer holds.
unsigned clang_LineOffsetMapping_size(CXLineOffsetMapping M);

// borrowed view of the box's own storage, exactly `clang_LineOffsetMapping_size` entries;
// *Length is filled when non-null. `begin`/`end` are this pointer and this pointer plus
// *Length, so they get no wrappers of their own.
const unsigned *clang_LineOffsetMapping_getLines(CXLineOffsetMapping M, size_t *Length);

// clang/Basic/SourceManager.h: SrcMgr::ContentCache. A CXContentCache is a borrowed
// interior pointer into memory owned by the SourceManager's ContentCache allocator, so it
// dies with the SourceManager.

// llvm/Support/MemoryBuffer.h: enum llvm::MemoryBuffer::BufferKind, mirrored in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXBufferKind {
  CXBufferKind_MemoryBuffer_Malloc,
  CXBufferKind_MemoryBuffer_MMap
} CXBufferKind;

// getBufferOrNone

// borrowed; *Length is filled when non-null. Loads the buffer on first use, reporting a
// read error through Diag at Loc; returns nullptr when the buffer is invalid (the
// std::nullopt case).
const char *clang_ContentCache_getBufferDataOrNone(CXContentCache CC,
                                                   CXDiagnosticsEngine Diag,
                                                   CXFileManager FileMgr,
                                                   CXSourceLocation_ Loc, size_t *Length);

// `clang_ContentCache_isBufferLoaded` must hold — without a loaded buffer this reads
// through a disengaged OptionalFileEntryRef.
unsigned clang_ContentCache_getSize(CXContentCache CC);

unsigned clang_ContentCache_getSizeBytesMapped(CXContentCache CC);

// `clang_ContentCache_isBufferLoaded` must hold — Clang asserts it.
CXBufferKind clang_ContentCache_getMemoryBufferKind(CXContentCache CC);

// helper: `getBufferIfLoaded().has_value()`, the gate for `clang_ContentCache_getSize` and
// `clang_ContentCache_getMemoryBufferKind`, both of which read the buffer unconditionally.
bool clang_ContentCache_isBufferLoaded(CXContentCache CC);

// borrowed; *Length is filled when non-null. Returns nullptr when the buffer has not been
// loaded yet (the std::nullopt case).
const char *clang_ContentCache_getBufferDataIfLoaded(CXContentCache CC, size_t *Length);

// setBuffer
// setUnownedBuffer

// borrowed static storage; returns the name of the byte order mark Str starts with when
// Clang cannot handle it, and nullptr otherwise.
const char *clang_ContentCache_getInvalidBOM(const char *Str, size_t Length);

// clang/Basic/SourceManager.h: SrcMgr::FileInfo. A CXFileInfo is a borrowed interior
// pointer into the SLocEntry it came from, so it dangles once the SourceManager's
// SLocEntry table grows (i.e. once a new FileID is created) — re-fetch, don't cache.

CXSourceLocation_ clang_FileInfo_getIncludeLoc(CXFileInfo FI);

// borrowed, with the lifetime of the SourceManager's ContentCache allocator.
CXContentCache clang_FileInfo_getContentCache(CXFileInfo FI);

// getContentCache

CXCharacteristicKind clang_FileInfo_getFileCharacteristic(CXFileInfo FI);

bool clang_FileInfo_hasLineDirectives(CXFileInfo FI);

// one-way: Clang offers no way to clear the flag again.
void clang_FileInfo_setHasLineDirectives(CXFileInfo FI);

// setHasLineDirectives

// borrowed; *Length is filled when non-null. The StringRef is not NUL-terminated.
const char *clang_FileInfo_getName(CXFileInfo FI, size_t *Length);

// clang/Basic/SourceManager.h: SrcMgr::ExpansionInfo. Same borrowed-interior-pointer
// lifetime as CXFileInfo.

// getExpansionLocRange

CXSourceLocation_ clang_ExpansionInfo_getSpellingLoc(CXExpansionInfo EI);

CXSourceLocation_ clang_ExpansionInfo_getExpansionLocStart(CXExpansionInfo EI);

CXSourceLocation_ clang_ExpansionInfo_getExpansionLocEnd(CXExpansionInfo EI);

bool clang_ExpansionInfo_isExpansionTokenRange(CXExpansionInfo EI);

// the expansion's CharSourceRange, decomposed: the range is the return value and
// *IsTokenRange is filled when non-null.
CXSourceRange_ clang_ExpansionInfo_getExpansionLocRange(CXExpansionInfo EI,
                                                        bool *IsTokenRange);

bool clang_ExpansionInfo_isMacroArgExpansion(CXExpansionInfo EI);

bool clang_ExpansionInfo_isMacroBodyExpansion(CXExpansionInfo EI);

bool clang_ExpansionInfo_isFunctionMacroExpansion(CXExpansionInfo EI);

// create
// createForMacroArg
// createForTokenSplit

// clang/Basic/SourceManager.h: SrcMgr::SLocEntry. A CXSLocEntry is a borrowed interior
// pointer into the SourceManager's local/loaded SLocEntry table, invalidated when that
// table grows.

uint32_t clang_SLocEntry_getOffset(CXSLocEntry E);

bool clang_SLocEntry_isExpansion(CXSLocEntry E);

bool clang_SLocEntry_isFile(CXSLocEntry E);

// `clang_SLocEntry_isFile` must hold — Clang asserts it; borrowed.
CXFileInfo clang_SLocEntry_getFile(CXSLocEntry E);

// `clang_SLocEntry_isExpansion` must hold — Clang asserts it; borrowed.
CXExpansionInfo clang_SLocEntry_getExpansion(CXSLocEntry E);

// getOffsetOnly
// get

// clang/Basic/SourceManager.h: clang::SourceManagerForFile. Builds a SourceManager over a
// single in-memory file together with the FileManager and DiagnosticsEngine it needs. The
// C++ class keeps only a `StringRef` of the name and the content, so the box owns copies of
// both: this create allocates, release it with `clang_SourceManagerForFile_dispose`.
CXSourceManagerForFile clang_SourceManagerForFile_create(const char *FileName,
                                                         size_t FileNameLength,
                                                         const char *Content,
                                                         size_t ContentLength);

void clang_SourceManagerForFile_dispose(CXSourceManagerForFile SMF);

// borrowed — the manager belongs to the box and dies with it, so it must never be passed
// to `clang_SourceManager_dispose`.
CXSourceManager clang_SourceManagerForFile_get(CXSourceManagerForFile SMF);

LLVM_CLANG_C_EXTERN_C_END

#endif