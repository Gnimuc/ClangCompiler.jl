#ifndef LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H
#define LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

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

// helper: number of names `HeaderSearch::getHeaderMapFileNames` produces.
unsigned clang_HeaderSearch_getNumHeaderMapFileNames(CXHeaderSearch HS);

// helper: Idx-th name from `HeaderSearch::getHeaderMapFileNames`.
// PRECONDITION: Idx < clang_HeaderSearch_getNumHeaderMapFileNames(HS) — the shim
// indexes the vector unchecked.
CXString clang_HeaderSearch_getHeaderMapFileName(CXHeaderSearch HS, unsigned Idx);

unsigned clang_HeaderSearch_header_file_size(CXHeaderSearch HS);

unsigned clang_HeaderSearch_search_dir_size(CXHeaderSearch HS);

// helper: name of the Idx-th search directory, i.e. `(*HS->search_dir_nth(Idx)).getName()`.
// PRECONDITION: Idx < clang_HeaderSearch_search_dir_size(HS) — `search_dir_nth`
// only asserts this, so an out-of-range index is UB in a release build.
CXString clang_HeaderSearch_getSearchDirName(CXHeaderSearch HS, unsigned Idx);

// Uniques Framework into the search's framework-name set and returns the uniqued
// spelling; idempotent.
CXString clang_HeaderSearch_getUniqueFrameworkName(CXHeaderSearch HS,
                                                   const char *Framework);

// LookupFile / LookupSubframeworkHeader are not wrapped: they need out-parameters
// (SmallVectorImpl<char>*, ModuleMap::KnownHeader*, ConstSearchDirIterator*) that
// have no marshalling scheme yet.

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS);

size_t clang_HeaderSearch_getTotalMemory(CXHeaderSearch HS);

LLVM_CLANG_C_EXTERN_C_END

#endif