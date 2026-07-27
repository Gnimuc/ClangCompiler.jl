#ifndef LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H
#define LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXSourceManager.h" // CXCharacteristicKind

LLVM_CLANG_C_EXTERN_C_BEGIN

CXHeaderSearchOptions clang_HeaderSearch_getHeaderSearchOpts(CXHeaderSearch HS);

CXFileManager clang_HeaderSearch_getFileMgr(CXHeaderSearch HS);

CXDiagnosticsEngine clang_HeaderSearch_getDiags(CXHeaderSearch HS);

bool clang_HeaderSearch_HasIncludeAliasMap(CXHeaderSearch HS);

// Source must carry its angle brackets or quotes, Dest must not. Creates the
// alias map on first use.
void clang_HeaderSearch_AddIncludeAlias(CXHeaderSearch HS, const char *Source,
                                        const char *Dest);

// PRECONDITION: clang_HeaderSearch_HasIncludeAliasMap(HS) — the Clang method only
// asserts the map exists and then dereferences it, so calling this without an alias
// map is a null dereference in a release build. Returns the empty string when
// Source has no alias.
CXString clang_HeaderSearch_MapHeaderToIncludeAlias(CXHeaderSearch HS, const char *Source);

void clang_HeaderSearch_setModuleHash(CXHeaderSearch HS, const char *Hash);

void clang_HeaderSearch_setModuleCachePath(CXHeaderSearch HS, const char *CachePath);

CXString clang_HeaderSearch_getModuleHash(CXHeaderSearch HS);

CXString clang_HeaderSearch_getModuleCachePath(CXHeaderSearch HS);

void clang_HeaderSearch_setDirectoryHasModuleMap(CXHeaderSearch HS, CXDirectoryEntry Dir);

// Drops every HeaderFileInfo recorded so far, including the #pragma once / controlling
// macro state a still-running preprocessor relies on.
void clang_HeaderSearch_ClearFileInfo(CXHeaderSearch HS);

// EPS is borrowed, not adopted; NULL detaches the current source.
void clang_HeaderSearch_SetExternalLookup(CXHeaderSearch HS,
                                          CXExternalPreprocessorSource EPS);

CXExternalPreprocessorSource clang_HeaderSearch_getExternalLookup(CXHeaderSearch HS);

// PRECONDITION: the module map owned by HS either has no target yet or already holds
// exactly this TargetInfo object — clang::ModuleMap::setTarget asserts that a target is
// never replaced by a different one, and nothing in this API can observe the stored one.
void clang_HeaderSearch_setTarget(CXHeaderSearch HS, CXTargetInfo_ Target);

// Goes through HeaderSearch::getFileInfo, so it creates the HeaderFileInfo record for
// File when there is none yet.
CXCharacteristicKind clang_HeaderSearch_getFileDirFlavor(CXHeaderSearch HS,
                                                         CXFileEntryRef File);

void clang_HeaderSearch_MarkFileIncludeOnce(CXHeaderSearch HS, CXFileEntryRef File);

void clang_HeaderSearch_MarkFileSystemHeader(CXHeaderSearch HS, CXFileEntryRef File);

void clang_HeaderSearch_SetFileControllingMacro(CXHeaderSearch HS, CXFileEntryRef File,
                                                CXIdentifierInfo ControllingMacro);

bool clang_HeaderSearch_isFileMultipleIncludeGuarded(CXHeaderSearch HS,
                                                     CXFileEntryRef File);

bool clang_HeaderSearch_hasFileBeenImported(CXHeaderSearch HS, CXFileEntryRef File);

// helper: number of flags `HeaderSearch::computeUserEntryUsage` produces, i.e. the number
// of HeaderSearchOptions user entries.
unsigned clang_HeaderSearch_getNumUserEntryUsage(CXHeaderSearch HS);

// Fills Out with one flag per HeaderSearchOptions user entry, true when a lookup has used
// that entry so far. Out must hold clang_HeaderSearch_getNumUserEntryUsage(HS) elements;
// the count is exact and every slot is written.
void clang_HeaderSearch_computeUserEntryUsage(CXHeaderSearch HS, bool *Out);

CXString clang_HeaderSearch_getPrebuiltModuleFileName(CXHeaderSearch HS,
                                                      const char *ModuleName,
                                                      bool FileMapOnly);

// The upward walk from Filename's directory stops at Root. Always false when implicit
// module maps are disabled.
bool clang_HeaderSearch_hasModuleMap(CXHeaderSearch HS, const char *Filename,
                                     CXDirectoryEntry Root, bool IsSystem);

// helper: number of names `HeaderSearch::getHeaderMapFileNames` produces.
unsigned clang_HeaderSearch_getNumHeaderMapFileNames(CXHeaderSearch HS);

// helper: Idx-th name from `HeaderSearch::getHeaderMapFileNames`.
// PRECONDITION: Idx < clang_HeaderSearch_getNumHeaderMapFileNames(HS) — the shim
// indexes the vector unchecked.
CXString clang_HeaderSearch_getHeaderMapFileName(CXHeaderSearch HS, unsigned Idx);

unsigned clang_HeaderSearch_header_file_size(CXHeaderSearch HS);

// The returned CXHeaderFileInfo is a borrowed interior pointer into the search's
// HeaderFileInfo vector: a later clang_HeaderSearch_getFileInfo can reallocate that
// vector and clang_HeaderSearch_ClearFileInfo empties it, so read the fields out before
// making either call. This form creates an empty record when the header is unknown.
CXHeaderFileInfo clang_HeaderSearch_getFileInfo(CXHeaderSearch HS, CXFileEntryRef FE);

// Same borrowing rules, but never creates: NULL when no record has ever been filled in
// for FE, or when the record came from an external source and WantExternal is false.
CXHeaderFileInfo clang_HeaderSearch_getExistingFileInfo(CXHeaderSearch HS,
                                                        CXFileEntryRef FE,
                                                        bool WantExternal);

unsigned clang_HeaderSearch_search_dir_size(CXHeaderSearch HS);

// helper: name of the Idx-th search directory, i.e. `(*HS->search_dir_nth(Idx)).getName()`.
// PRECONDITION: Idx < clang_HeaderSearch_search_dir_size(HS) — `search_dir_nth`
// only asserts this, so an out-of-range index is UB in a release build.
CXString clang_HeaderSearch_getSearchDirName(CXHeaderSearch HS, unsigned Idx);

// Uniques Framework into the search's framework-name set and returns the uniqued
// spelling; idempotent.
CXString clang_HeaderSearch_getUniqueFrameworkName(CXHeaderSearch HS,
                                                   const char *Framework);

// Empty when the search never recorded an include spelling for File.
CXString clang_HeaderSearch_getIncludeNameForHeader(CXHeaderSearch HS, CXFileEntry File);

// IsAngled, when non-NULL, is filled in with whether the suggestion should be spelled
// <Header.h> rather than "Header.h".
CXString clang_HeaderSearch_suggestPathToFileForDiagnostics(CXHeaderSearch HS,
                                                            CXFileEntryRef File,
                                                            const char *MainFile,
                                                            bool *IsAngled);

// LookupFile / LookupSubframeworkHeader are not wrapped: they need out-parameters
// (SmallVectorImpl<char>*, ModuleMap::KnownHeader*, ConstSearchDirIterator*) that
// have no marshalling scheme yet.

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS);

size_t clang_HeaderSearch_getTotalMemory(CXHeaderSearch HS);

// HeaderFileInfo
//
// Field exposure for the aggregate clang_HeaderSearch_getFileInfo and
// clang_HeaderSearch_getExistingFileInfo hand back. Every CXHeaderFileInfo is borrowed
// and is invalidated by the calls named on those two functions.

bool clang_HeaderFileInfo_getIsImport(CXHeaderFileInfo HFI);

bool clang_HeaderFileInfo_getIsPragmaOnce(CXHeaderFileInfo HFI);

CXCharacteristicKind clang_HeaderFileInfo_getDirInfo(CXHeaderFileInfo HFI);

bool clang_HeaderFileInfo_getIsModuleHeader(CXHeaderFileInfo HFI);

bool clang_HeaderFileInfo_getIsValid(CXHeaderFileInfo HFI);

// helper: the ControllingMacro member exactly as stored, with no external-source
// resolution. HeaderFileInfo::getControllingMacro itself is not wrapped: it asserts that
// an ExternalPreprocessorSource was supplied whenever the stored identifier is out of
// date, and no entry point in this API can produce one.
CXIdentifierInfo clang_HeaderFileInfo_getControllingMacroRaw(CXHeaderFileInfo HFI);

CXString clang_HeaderFileInfo_getFramework(CXHeaderFileInfo HFI);

LLVM_CLANG_C_EXTERN_C_END

#endif