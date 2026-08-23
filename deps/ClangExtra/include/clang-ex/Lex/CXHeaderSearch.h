#ifndef LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H
#define LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXSourceManager.h" // CXCharacteristicKind
#include "clang-ex/Lex/CXModuleMap.h"       // CXModuleHeaderRole

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

// SetSearchPaths
// SetSystemHeaderPrefixes
// SetExternalSource

// Inserts Dir at the boundary between the quoted/angled and the system search paths -- before
// the first system directory when isAngled is true, before the first angled one otherwise --
// so every SearchDirs index at or after that point shifts by one. The search's
// LookupFileCache, SearchDirHeaderMapIndex and SearchDirToHSEntry keep the old indices, and
// all three are private, so nothing on this side can observe or repair the staleness: add
// search paths before any #include has been resolved through this search. Dir is COPIED.
void clang_HeaderSearch_AddSearchPath(CXHeaderSearch HS, CXDirectoryLookup Dir,
                                      bool isAngled);

// Appends Dir after every existing search path and does not move SystemDirIdx, so the entry
// lands inside [SystemDirIdx, size) and is searched last, as a system directory. A pure
// push_back: no existing index moves, so AddSearchPath's staleness caveat does not apply.
// Dir is COPIED.
void clang_HeaderSearch_AddSystemSearchPath(CXHeaderSearch HS, CXDirectoryLookup Dir);

// Opens File as an Apple header map and registers it with the search, returning NULL when it
// is not a valid one. The result is BORROWED -- the map is owned by the search's HeaderMaps
// vector, which uniques by file, so a second call for the same file returns the same pointer.
// MARSHALLING.md §14 does not apply: reallocating that vector moves the pairs, not the
// heap-allocated HeaderMap behind each unique_ptr.
CXHeaderMap clang_HeaderSearch_CreateHeaderMap(CXHeaderSearch HS, CXFileEntryRef FE);

// The path the module cache would use for the module named ModuleName declared in
// ModuleMapPath. Empty when the module cache path is empty, and empty when ModuleMapPath's
// parent directory cannot be resolved. A relative cache path is made absolute against the
// process's working directory. This name claims the verbatim spelling for the
// (StringRef, StringRef) overload; the Module * overload needs a disambiguated symbol.
CXString clang_HeaderSearch_getCachedModuleFileName(CXHeaderSearch HS,
                                                    const char *ModuleName,
                                                    const char *ModuleMapPath);

// helper (MARSHALLING.md §10, narrow composite): resolve Filename against this search
// exactly as the preprocessor would, with no #include_next start directory, no includers
// and no module suggestion. Calls clang::HeaderSearch::LookupFile with IncludeLoc =
// SourceLocation(), FromDir = ConstSearchDirIterator(nullptr), an empty Includers list,
// CurDir = SearchPath = RelativePath = RequestingModule = SuggestedModule = nullptr,
// BuildSystemModule = false and OpenFile = true, forwarding only the four flags below. The
// full method stays unwrapped: its SearchPath / RelativePath / SuggestedModule / CurDir
// out-parameters have no marshalling scheme, and the Includers ArrayRef is a
// pair-of-optionals with no pointer form. With RequestingModule and SuggestedModule both
// null, HeaderSearch::needModuleLookup is false and no module machinery runs at all, which
// is what makes the narrowing total. Returns NULL when the file is not found; otherwise a
// heap-boxed FileEntryRef the caller releases with clang_FileEntryRef_dispose. *IsMapped /
// *IsFrameworkFound may be NULL. CacheFailures is forwarded to FileManager::getFileRef, so
// with it true a probe for a path that does not exist yet makes the file manager remember
// that -- and a later lookup still misses even once the file has been created. False is
// therefore the sane default for a query against a live interpreter. It does NOT control
// HeaderSearch's own LookupFileCache, and that cache DOES make a miss sticky: it records the
// position the next search for this filename resumes from, and a search that found nothing
// leaves that past the end of the list. So a name that missed once keeps missing even after a
// directory containing it joins the search path. SkipCache=true bypasses that and finds it; a
// different filename in the same new directory is found unaided, the cache being per-filename.
// Measured against a live interpreter, not inferred from the source.
CXFileEntryRef clang_HeaderSearch_LookupFile(CXHeaderSearch HS, const char *Filename,
                                             bool isAngled, bool SkipCache,
                                             bool CacheFailures, bool *IsMapped,
                                             bool *IsFrameworkFound);

// LookupSubframeworkHeader
// LookupFrameworkCache

// The multiple-include optimization decision for File: whether the preprocessor should enter
// it. *IsFirstIncludeOfFile, when non-null, receives whether this is the first time PP has
// seen the file. M may be NULL and must be when modules are off -- the module-macro test is
// guarded by a null check on it. isImport records the #import bit on the file's record.
// PRECONDITION 1: HS must be PP's own header search (clang_Preprocessor_getHeaderSearchInfo)
//   -- the isImport path reaches back through PP to *its* HeaderSearch, so a mismatched pair
//   writes the import bit onto a different search's record.
// PRECONDITION 2: the file's controlling macro identifier must not be out of date unless an
//   external lookup source is installed -- the controlling-macro path calls
//   ExternalLookup->updateOutOfDateIdentifier through the vtable with no null check, and the
//   clang assert that would have caught it is compiled out of the release artifact.
// PRECONDITION 3: ModulesEnabled must match the invocation's -fmodules state
//   (clang_LangOptions_getModules).
bool clang_HeaderSearch_ShouldEnterIncludeFile(CXHeaderSearch HS, CXPreprocessor PP,
                                               CXFileEntryRef File, bool isImport,
                                               bool ModulesEnabled, CXModule_ M,
                                               bool *IsFirstIncludeOfFile);

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

// Marks FE as belonging to a module. RoleBits is a BITMASK of CXModuleHeaderRole values,
// not a single enumerator: clang tests it with ModuleMap::isModular(Role) == !(Role &
// (TextualHeader | ExcludedHeader)), so a textual or excluded role on its own records
// nothing unless isCompilingModuleHeader is true. The two bits it writes are OR-ed into the
// record and never cleared -- clang_HeaderSearch_ClearFileInfo is the only way back.
// Creates the HeaderFileInfo record for FE when there is none yet, and only then: the early
// return for a role that changes nothing leaves a header with no record still without one.
void clang_HeaderSearch_MarkFileModuleHeader(CXHeaderSearch HS, CXFileEntryRef FE,
                                             unsigned RoleBits,
                                             bool isCompilingModuleHeader);

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

// getCachedModuleFileName / getPrebuiltImplicitModuleFileName: the Module * overloads are
// not wrapped. Each only looks the module's name and module-map path up off the Module
// before delegating to the (StringRef, StringRef) / (StringRef, bool) form already bound
// above, so they add no capability a caller of those lacks.

// The module named ModuleName, or NULL when none is known. Consults the search's ModuleMap
// first, so a module registered by clang_HeaderSearch_loadModuleMapFile is found regardless
// of configuration; only the fallback directory search is gated on
// HeaderSearchOptions::ImplicitModuleMaps, and AllowSearch = false skips it entirely.
// ImportLoc is only used to locate diagnostics from that fallback search and may be an
// invalid location. The result is BORROWED -- it is owned by the search's ModuleMap, so it
// must never be passed to clang_Module_dispose, which would also delete every submodule.
CXModule_ clang_HeaderSearch_lookupModule(CXHeaderSearch HS, const char *ModuleName,
                                          CXSourceLocation_ ImportLoc, bool AllowSearch,
                                          bool AllowExtraModuleMapSearch);

// lookupModuleMapFile

// The upward walk from Filename's directory stops at Root. Always false when implicit
// module maps are disabled.
bool clang_HeaderSearch_hasModuleMap(CXHeaderSearch HS, const char *Filename,
                                     CXDirectoryEntry Root, bool IsSystem);

// The module that owns File, or NULL when no module map assigns it to one. MARSHALLING.md
// §7: the KnownHeader value aggregate is not marshalled -- its two components are.
// *RoleBits, when non-NULL, receives the header's role as a BITMASK of CXModuleHeaderRole
// values (see CXModuleMap.h), so it may hold a combination such as
// PrivateHeader|TextualHeader and must never be read as a single enumerator. When the
// result is NULL the role is clang's default-constructed 0 and carries no information. NOT
// a pure query, despite being declared const: HeaderSearch holds a `mutable ModuleMap`, and
// when no module map mentions File this INFERS ownership from any enclosing umbrella
// directory (ModuleMap::findOrCreateModuleForHeaderInUmbrellaDir), which can create modules
// and submodules as a side effect. clang_HeaderSearch_getNumResolvedModulesForHeader below
// is the inference-free enumerator. The module is BORROWED from the search's ModuleMap.
// KnownHeader::isAvailable() is deliberately not exposed: it dereferences getModule() with
// no null check, so the caller composes it from the module and the role instead.
CXModule_ clang_HeaderSearch_findModuleForHeader(CXHeaderSearch HS, CXFileEntryRef File,
                                                 bool AllowTextual, bool AllowExcluded,
                                                 unsigned *RoleBits);

// findAllModulesForHeader

// helper: number of (module, role) pairs clang::HeaderSearch::findResolvedModulesForHeader
// reports for File. Zero when no module map claims it.
unsigned clang_HeaderSearch_getNumResolvedModulesForHeader(CXHeaderSearch HS,
                                                           CXFileEntryRef File);

// helper: the Idx-th pair. *RoleBits, when non-NULL, receives the role BITMASK (see
// clang_HeaderSearch_findModuleForHeader). The module is BORROWED. PRECONDITION: Idx <
// clang_HeaderSearch_getNumResolvedModulesForHeader(HS, File) -- the shim indexes the
// ArrayRef unchecked. Both calls redo the query (MARSHALLING.md §6 count+index, §10
// rebuild-per-call). Unlike findModuleForHeader this one infers nothing, so it is
// idempotent and the count and the indices agree.
CXModule_ clang_HeaderSearch_getResolvedModuleForHeader(CXHeaderSearch HS,
                                                        CXFileEntryRef File, unsigned Idx,
                                                        unsigned *RoleBits);

// Parses File as a module map and registers its modules with the search's ModuleMap.
// Returns TRUE on FAILURE -- clang's own inverted polarity: false means the map was parsed
// now or had already been parsed. The ID / Offset / OriginalModuleMapFile parameters are
// left at their clang defaults; they exist only for preprocessed module maps, which nothing
// here produces. Not gated on -fmodules or -fimplicit-module-maps:
// ModuleMap::parseModuleMapFile consults neither. It does assert(Target) on the ModuleMap's
// TargetInfo, which holds for every HeaderSearch reachable from here, because
// Preprocessor::Initialize calls setTarget unconditionally and
// CompilerInstance::createPreprocessor always calls it -- which is also why the
// HeaderSearch constructor stays unwrapped. Side effects: the map is entered into the
// SourceManager as a new FileID, and parse errors are reported through the search's
// DiagnosticsEngine.
bool clang_HeaderSearch_loadModuleMapFile(CXHeaderSearch HS, CXFileEntryRef File,
                                          bool IsSystem);

// helper: number of top-level modules clang::HeaderSearch::collectAllModules reports.
unsigned clang_HeaderSearch_getNumAllModules(CXHeaderSearch HS);

// Fills Buf with those modules. Buf must hold clang_HeaderSearch_getNumAllModules(HS)
// elements; the count is exact and no slot is NULL. Every module is BORROWED from the
// search's ModuleMap. Both calls redo the whole walk (MARSHALLING.md §10,
// rebuild-per-call): the order is the ModuleMap's llvm::StringMap iteration order, a pure
// function of its insertion sequence, so index I names the same module on both calls. Side
// effect: when HeaderSearchOptions::ImplicitModuleMaps is on, the walk loads module maps
// off disk for every search directory and its immediate subdirectories, so the FIRST call
// may register modules that were not there before. It is idempotent from then on, which is
// what makes count+fill sound here.
void clang_HeaderSearch_collectAllModules(CXHeaderSearch HS, CXModule_ *Buf);

// loadTopLevelSystemModules

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

// helper: index of the first angled (-I) search directory, i.e. the number of quoted-only
// entries. Walks from quoted_dir_begin() to angled_dir_begin() on the const overloads. That
// walk never dereferences an iterator, so it is defined even when the range is empty --
// unlike searchDirIdx(*angled_dir_begin()), which would.
unsigned clang_HeaderSearch_getAngledDirIdx(CXHeaderSearch HS);

// helper: index of the first system search directory, the same way. Together with
// clang_HeaderSearch_search_dir_size these partition the flat search-path list into [0,
// angled) quoted-only, [angled, system) angled and [system, size) system -- the same
// boundary clang_HeaderSearch_AddSearchPath's isAngled flag inserts at, and the only
// observable consequence of that flag.
unsigned clang_HeaderSearch_getSystemDirIdx(CXHeaderSearch HS);

// searchDirIdx: not wrapped. Its body is `&DL - &*SearchDirs.begin()`, pointer arithmetic
// against the search's private vector, and the only DirectoryLookup this API can produce is
// clang_DirectoryLookup_create's heap-boxed copy, which is not in that vector -- so every
// reachable call would be undefined behaviour returning a garbage index.

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

// getModuleMap: not wrapped. It would need a CXModuleMap handle for a class with a
// ~60-method surface of its own, and yields no capability on its own -- the three queries a
// caller actually wants from it (findModule, findModuleForHeader,
// findResolvedModulesForHeader) are all reachable through the HeaderSearch forwarders
// above.

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS);

size_t clang_HeaderSearch_getTotalMemory(CXHeaderSearch HS);

// HeaderFileInfo
//
// Field exposure for the aggregate clang_HeaderSearch_copyFileInfo and
// clang_HeaderSearch_copyExistingFileInfo hand back. Every CXHeaderFileInfo is an owned
// copy the caller releases with clang_HeaderFileInfo_dispose.

bool clang_HeaderFileInfo_getIsImport(CXHeaderFileInfo HFI);

bool clang_HeaderFileInfo_getIsPragmaOnce(CXHeaderFileInfo HFI);

CXCharacteristicKind clang_HeaderFileInfo_getDirInfo(CXHeaderFileInfo HFI);

// Whether this record was supplied by an external source and has not changed since.
// copyExistingFileInfo(WantExternal=false) uses getExistingLocalFileInfo and skips these.
bool clang_HeaderFileInfo_getExternal(CXHeaderFileInfo HFI);

bool clang_HeaderFileInfo_getIsModuleHeader(CXHeaderFileInfo HFI);

// Whether the header is part of the module currently being built, as set by
// clang_HeaderSearch_MarkFileModuleHeader's isCompilingModuleHeader argument.
bool clang_HeaderFileInfo_getIsCompilingModuleHeader(CXHeaderFileInfo HFI);

bool clang_HeaderFileInfo_getIsValid(CXHeaderFileInfo HFI);

// helper: the ControllingMacro member exactly as stored, with no external-source
// resolution. HeaderFileInfo::getControllingMacro itself is not wrapped: it asserts that
// an ExternalPreprocessorSource was supplied whenever the stored identifier is out of
// date, and no entry point in this API can produce one.
CXIdentifierInfo clang_HeaderFileInfo_getControllingMacroRaw(CXHeaderFileInfo HFI);

// LLVM 20 dropped HeaderFileInfo::Framework. Always an empty string.
CXString clang_HeaderFileInfo_getFramework(CXHeaderFileInfo HFI);

// --- Owned snapshots of a HeaderFileInfo record ---------------------------------------
//
// clang::HeaderSearch::getFileInfo returns a reference into the search's private
// `std::vector<HeaderFileInfo>`, and getExistingFileInfo a pointer into it. A later
// getFileInfo for a different header reallocates that vector and ClearFileInfo empties it,
// after which the earlier pointer dangles -- and because the vector is private, nothing on
// this side of the boundary can observe that it moved, so the borrow cannot be checked.
// Only the copying forms below are exposed; the borrowing ones are deliberately absent.
//
// The copy is a snapshot: later changes clang makes to the real record are not reflected.
// Its pointer members stay valid regardless, because the reallocation moves the structs and
// not what they point at -- ControllingMacro belongs to the identifier table and Framework
// to the search's own string allocator, both of which outlive the vector.

// The record for File, creating an empty one when the header has never been looked up (the
// same side effect the borrowing form has). Release with clang_HeaderFileInfo_dispose.
CXHeaderFileInfo clang_HeaderSearch_copyFileInfo(CXHeaderSearch HS, CXFileEntryRef FE);

// The record for File if one has ever been filled in, or NULL when none has. WantExternal
// selects getExistingFileInfo (true) vs getExistingLocalFileInfo (false). Release a
// non-NULL result with clang_HeaderFileInfo_dispose.
CXHeaderFileInfo clang_HeaderSearch_copyExistingFileInfo(CXHeaderSearch HS,
                                                         CXFileEntryRef FE,
                                                         bool WantExternal);

// Release a record obtained from either copy function. This is a plain delete, so it must
// only ever see a pointer one of those two returned.
void clang_HeaderFileInfo_dispose(CXHeaderFileInfo HFI);

LLVM_CLANG_C_EXTERN_C_END

#endif