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

bool clang_SourceManager_isMainFile(CXSourceManager SM, CXFileEntry FE);

// this allocates; call `clang_FileID_dispose` to release.
CXFileID clang_SourceManager_getOrCreateFileID(CXSourceManager SM, CXFileEntryRef FER,
                                               CXCharacteristicKind FileCharacter);

bool clang_SourceManager_isFileOverridden(CXSourceManager SM, CXFileEntry FE);

void clang_SourceManager_setFileIsTransient(CXSourceManager SM, CXFileEntryRef FER);

void clang_SourceManager_setAllFilesAreTransient(CXSourceManager SM, bool Transient);

// borrowed; returns nullptr when the FileID has no file entry (e.g. a memory-buffer
// FileID).
CXFileEntry clang_SourceManager_getFileEntryForID(CXSourceManager SM, CXFileID FID);

// heap-boxes the `clang::FileEntryRef` (call `clang_FileEntryRef_dispose` to release);
// returns nullptr when the FileID has no file entry.
CXFileEntryRef clang_SourceManager_getFileEntryRefForID(CXSourceManager SM, CXFileID FID);

// borrowed pointer into the buffer, exactly *Length bytes; *Length and *Invalid are
// filled when non-null.
const char *clang_SourceManager_getBufferData(CXSourceManager SM, CXFileID FID,
                                              size_t *Length, bool *Invalid);

unsigned clang_SourceManager_getNumCreatedFIDsForFileID(CXSourceManager SM, CXFileID FID);

// this allocates; call `clang_FileID_dispose` to release.
CXFileID clang_SourceManager_getFileID(CXSourceManager SM, CXSourceLocation_ Loc);

// borrowed; *Length is filled when non-null (an empty name yields nullptr data).
const char *clang_SourceManager_getFilename(CXSourceManager SM, CXSourceLocation_ Loc,
                                            size_t *Length);

CXSourceLocation_ clang_SourceManager_getIncludeLoc(CXSourceManager SM, CXFileID FID);

CXSourceLocation_ clang_SourceManager_getExpansionLoc(CXSourceManager SM,
                                                      CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceManager_getFileLoc(CXSourceManager SM, CXSourceLocation_ Loc);

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

bool clang_SourceManager_isBeforeInSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ LHS,
                                                 CXSourceLocation_ RHS);

bool clang_SourceManager_isPointWithin(CXSourceManager SM, CXSourceLocation_ Location,
                                       CXSourceLocation_ Start, CXSourceLocation_ End);

CXSourceLocation_ clang_SourceManager_getImmediateMacroCallerLoc(CXSourceManager SM,
                                                                 CXSourceLocation_ Loc);

CXSourceLocation_ clang_SourceManager_getTopMacroCallerLoc(CXSourceManager SM,
                                                           CXSourceLocation_ Loc);

LLVM_CLANG_C_EXTERN_C_END

#endif