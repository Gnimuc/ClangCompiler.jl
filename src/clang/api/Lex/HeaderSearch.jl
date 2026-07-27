# HeaderSearch
function PrintStats(x::HeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_PrintStats(x)
end


function getHeaderSearchOpts(x::AbstractHeaderSearch)
    @check_ptrs x
    return HeaderSearchOptions(clang_HeaderSearch_getHeaderSearchOpts(x))
end

function getFileMgr(x::AbstractHeaderSearch)
    @check_ptrs x
    return FileManager(clang_HeaderSearch_getFileMgr(x))
end

function HasIncludeAliasMap(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_HasIncludeAliasMap(x)
end

function getModuleHash(x::AbstractHeaderSearch)
    @check_ptrs x
    return get_string(clang_HeaderSearch_getModuleHash(x))
end

function getModuleCachePath(x::AbstractHeaderSearch)
    @check_ptrs x
    return get_string(clang_HeaderSearch_getModuleCachePath(x))
end

"""
    getNumHeaderMapFileNames(x::AbstractHeaderSearch) -> Cuint
Return the number of header-map file names known to this search state.
"""
function getNumHeaderMapFileNames(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_getNumHeaderMapFileNames(x)
end

"""
    getHeaderMapFileName(x::AbstractHeaderSearch, idx::Integer) -> String
Return the `idx`-th header-map file name (0-based). `idx` must be less than
`getNumHeaderMapFileNames(x)`; the C shim indexes the name vector unchecked.
"""
function getHeaderMapFileName(x::AbstractHeaderSearch, idx::Integer)
    @check_ptrs x
    @assert 0 <= idx < getNumHeaderMapFileNames(x) "header map file name index out of range"
    return get_string(clang_HeaderSearch_getHeaderMapFileName(x, idx))
end

function search_dir_size(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_search_dir_size(x)
end

"""
    getSearchDirName(x::AbstractHeaderSearch, idx::Integer) -> String
Return the directory or filename of the `idx`-th search path (0-based). `idx` must be less
than `search_dir_size(x)`: `HeaderSearch::search_dir_nth` only asserts this, so an
out-of-range index is undefined behaviour in a release build.
"""
function getSearchDirName(x::AbstractHeaderSearch, idx::Integer)
    @check_ptrs x
    @assert 0 <= idx < search_dir_size(x) "search directory index out of range"
    return get_string(clang_HeaderSearch_getSearchDirName(x, idx))
end


function getDiags(x::AbstractHeaderSearch)
    @check_ptrs x
    return DiagnosticsEngine(clang_HeaderSearch_getDiags(x))
end

"""
    AddIncludeAlias(x::AbstractHeaderSearch, source::AbstractString, dest::AbstractString)
Map the include name `source` to `dest`, for use with the `include_alias` pragma. `source`
must carry its angle brackets or quotes, `dest` must not. The alias map is created on first
use, so this call makes `HasIncludeAliasMap(x)` true.
"""
function AddIncludeAlias(x::AbstractHeaderSearch, source::AbstractString, dest::AbstractString)
    @check_ptrs x
    return clang_HeaderSearch_AddIncludeAlias(x, source, dest)
end

"""
    MapHeaderToIncludeAlias(x::AbstractHeaderSearch, source::AbstractString) -> String
Return the header file name `source` is aliased to, or an empty string if it is not
aliased. `source` must include its angle brackets or quotes.

`HeaderSearch::MapHeaderToIncludeAlias` only asserts the alias map exists and then
dereferences it, so `HasIncludeAliasMap(x)` must hold — call `AddIncludeAlias` first.
"""
function MapHeaderToIncludeAlias(x::AbstractHeaderSearch, source::AbstractString)
    @check_ptrs x
    @assert HasIncludeAliasMap(x) "the include alias map must exist; call AddIncludeAlias first"
    return get_string(clang_HeaderSearch_MapHeaderToIncludeAlias(x, source))
end

"""
    setModuleHash(x::AbstractHeaderSearch, hash::AbstractString)
Set the hash to use for module cache paths.
"""
function setModuleHash(x::AbstractHeaderSearch, hash::AbstractString)
    @check_ptrs x
    return clang_HeaderSearch_setModuleHash(x, hash)
end

"""
    setModuleCachePath(x::AbstractHeaderSearch, cache_path::AbstractString)
Set the path to the module cache.
"""
function setModuleCachePath(x::AbstractHeaderSearch, cache_path::AbstractString)
    @check_ptrs x
    return clang_HeaderSearch_setModuleCachePath(x, cache_path)
end

"""
    header_file_size(x::AbstractHeaderSearch) -> Cuint
Return the number of headers this search state holds `HeaderFileInfo` for.
"""
function header_file_size(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_header_file_size(x)
end

"""
    getUniqueFrameworkName(x::AbstractHeaderSearch, framework::AbstractString) -> String
Unique `framework` into this search state's framework-name set and return the uniqued
spelling. Idempotent: repeated calls with the same name return the same string.
"""
function getUniqueFrameworkName(x::AbstractHeaderSearch, framework::AbstractString)
    @check_ptrs x
    return get_string(clang_HeaderSearch_getUniqueFrameworkName(x, framework))
end

"""
    getTotalMemory(x::AbstractHeaderSearch) -> Csize_t
Return the number of bytes this header search state has allocated.
"""
function getTotalMemory(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_getTotalMemory(x)
end


"""
    setDirectoryHasModuleMap(x::AbstractHeaderSearch, dir::AbstractDirectoryEntry)
Record that `dir` has a module map, so modules are considered when including files from it.
"""
function setDirectoryHasModuleMap(x::AbstractHeaderSearch, dir::AbstractDirectoryEntry)
    @check_ptrs x dir
    return clang_HeaderSearch_setDirectoryHasModuleMap(x, dir)
end

"""
    ClearFileInfo(x::AbstractHeaderSearch)
Forget every `HeaderFileInfo` recorded so far, so `header_file_size(x)` drops to zero.

This also discards the multiple-include state of every header already seen (`#pragma once`
marks, controlling macros, system-header marks), so a preprocessor still running against
`x` will re-enter headers it had finished with.
"""
function ClearFileInfo(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_ClearFileInfo(x)
end

"""
    SetExternalLookup(x::AbstractHeaderSearch, eps::AbstractExternalPreprocessorSource)
Install `eps` as the source consulted when a controlling macro has to be loaded from
external storage. The source is borrowed, not adopted, so it must outlive `x`.

`eps` is deliberately not null-checked: a carrier holding `NULL` detaches the current
source, which is how Clang itself clears it.
"""
function SetExternalLookup(x::AbstractHeaderSearch, eps::AbstractExternalPreprocessorSource)
    @check_ptrs x
    return clang_HeaderSearch_SetExternalLookup(x, eps)
end

"""
    getExternalLookup(x::AbstractHeaderSearch) -> ExternalPreprocessorSource
Return the external preprocessor source installed by `SetExternalLookup`. The carrier holds
`NULL` when no source is installed, which is the usual state outside PCH/module loading.
"""
function getExternalLookup(x::AbstractHeaderSearch)
    @check_ptrs x
    return ExternalPreprocessorSource(clang_HeaderSearch_getExternalLookup(x))
end

"""
    setTarget(x::AbstractHeaderSearch, target::AbstractTargetInfo)
Give the header search — and the module map it owns — its target information.

`ModuleMap::setTarget` asserts that a target is never *replaced*: it accepts the call only
while no target is set yet, or when `target` is the very object already stored. That state
is not observable through this API and nothing here is heap-boxed to hang a flag on, so the
precondition is documented rather than asserted — pass the `TargetInfo` of the
`CompilerInstance` this header search belongs to.
"""
function setTarget(x::AbstractHeaderSearch, target::AbstractTargetInfo)
    @check_ptrs x target
    return clang_HeaderSearch_setTarget(x, target)
end

"""
    getFileDirFlavor(x::AbstractHeaderSearch, file::AbstractFileEntryRef) -> CXCharacteristicKind
Return whether `file` is a normal header, a system header, or a C++-friendly system header.

This goes through `HeaderSearch::getFileInfo`, so it *creates* the `HeaderFileInfo` record
for `file` when there is none yet.
"""
function getFileDirFlavor(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return clang_HeaderSearch_getFileDirFlavor(x, file)
end

"""
    MarkFileIncludeOnce(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
Mark `file` as a "once only" header, as `#pragma once` does. Creates the `HeaderFileInfo`
record for `file` when there is none yet.
"""
function MarkFileIncludeOnce(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return clang_HeaderSearch_MarkFileIncludeOnce(x, file)
end

"""
    MarkFileSystemHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
Mark `file` as a system header, as `#pragma GCC system_header` does. Creates the
`HeaderFileInfo` record for `file` when there is none yet.
"""
function MarkFileSystemHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return clang_HeaderSearch_MarkFileSystemHeader(x, file)
end

"""
    SetFileControllingMacro(x::AbstractHeaderSearch, file::AbstractFileEntryRef,
                            controlling_macro::AbstractIdentifierInfo)
Record `controlling_macro` as the include guard protecting the whole of `file`, which is
what lets the multiple-include optimization skip a repeated `#include`. Creates the
`HeaderFileInfo` record for `file` when there is none yet.
"""
function SetFileControllingMacro(x::AbstractHeaderSearch, file::AbstractFileEntryRef,
                                 controlling_macro::AbstractIdentifierInfo)
    @check_ptrs x file controlling_macro
    return clang_HeaderSearch_SetFileControllingMacro(x, file, controlling_macro)
end

"""
    isFileMultipleIncludeGuarded(x::AbstractHeaderSearch, file::AbstractFileEntryRef) -> Bool
Return whether `file` is known to be safe from multiple inclusion, i.e. it carries
`#pragma once` or a controlling macro. `#import` does not count.
"""
function isFileMultipleIncludeGuarded(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return clang_HeaderSearch_isFileMultipleIncludeGuarded(x, file)
end

"""
    hasFileBeenImported(x::AbstractHeaderSearch, file::AbstractFileEntryRef) -> Bool
Return whether `file` is known to have ever been `#import`ed. False for a header no record
exists for; unlike the mark/flavor accessors this never creates one.
"""
function hasFileBeenImported(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return clang_HeaderSearch_hasFileBeenImported(x, file)
end

"""
    getNumUserEntryUsage(x::AbstractHeaderSearch) -> Cuint
Return how many `HeaderSearchOptions` user entries `computeUserEntryUsage` reports on.
"""
function getNumUserEntryUsage(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_getNumUserEntryUsage(x)
end

"""
    computeUserEntryUsage(x::AbstractHeaderSearch) -> Vector{Bool}
Return one flag per `HeaderSearchOptions` user entry, true when a lookup has used that
entry so far. Implicit module maps do not contribute to entry usage.
"""
function computeUserEntryUsage(x::AbstractHeaderSearch)
    @check_ptrs x
    n = Int(getNumUserEntryUsage(x))
    buf = Vector{Bool}(undef, n)
    n > 0 && clang_HeaderSearch_computeUserEntryUsage(x, buf)
    return buf
end

"""
    getPrebuiltModuleFileName(x::AbstractHeaderSearch, module_name::AbstractString;
                              file_map_only::Bool=false) -> String
Return the prebuilt module file that would be used to load the module named `module_name`,
or an empty string when no prebuilt module file corresponds to it. With
`file_map_only=true` only the explicit module-name-to-file map is consulted and the
prebuilt-module-path search is skipped.
"""
function getPrebuiltModuleFileName(x::AbstractHeaderSearch, module_name::AbstractString;
                                   file_map_only::Bool=false)
    @check_ptrs x
    return get_string(clang_HeaderSearch_getPrebuiltModuleFileName(x, module_name,
                                                                   file_map_only))
end

"""
    hasModuleMap(x::AbstractHeaderSearch, filename::AbstractString,
                 root::AbstractDirectoryEntry, is_system::Bool) -> Bool
Return whether a module map may map `filename` to a (sub)module. The search walks upward
from `filename`'s directory and stops at `root`. Always false when implicit module maps are
disabled, which is the default for an interpreter built without `-fimplicit-module-maps`.
"""
function hasModuleMap(x::AbstractHeaderSearch, filename::AbstractString,
                      root::AbstractDirectoryEntry, is_system::Bool)
    @check_ptrs x root
    return clang_HeaderSearch_hasModuleMap(x, filename, root, is_system)
end

"""
    getFileInfo(x::AbstractHeaderSearch, file::AbstractFileEntryRef) -> HeaderFileInfo
Return the `HeaderFileInfo` record for `file`, creating an empty one when the header has
never been looked up.

The record is a snapshot copied out of the search, so later changes clang makes to the real
record are not reflected in it. That is the price of not handing back an interior pointer
into the search's private `HeaderFileInfo` vector, which a later `getFileInfo` reallocates
and `ClearFileInfo` empties -- and which nothing on this side of the boundary can check,
because the vector is private. Its `ControllingMacro` and `Framework` stay valid either way:
reallocation moves the records, not what they point at.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getFileInfo(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return HeaderFileInfo(clang_HeaderSearch_copyFileInfo(x, file))
end

dispose(x::HeaderFileInfo) = clang_HeaderFileInfo_dispose(x)

"""
    getExistingFileInfo(x::AbstractHeaderSearch, file::AbstractFileEntryRef;
                        want_external::Bool=true) -> HeaderFileInfo
Return the `HeaderFileInfo` record for `file` if one has ever been filled in, or a carrier
holding `NULL` when the header has not been seen. Unlike `getFileInfo` this never creates a
record. With `want_external=false` a record supplied by an external source is reported as
absent.

Like `getFileInfo` this hands back an owned snapshot rather than a view into the search.

This function allocates and one should call `dispose` to release the resources after using
this object -- but only when the returned carrier is non-NULL.
"""
function getExistingFileInfo(x::AbstractHeaderSearch, file::AbstractFileEntryRef;
                             want_external::Bool=true)
    @check_ptrs x file
    return HeaderFileInfo(clang_HeaderSearch_copyExistingFileInfo(x, file, want_external))
end

"""
    getIncludeNameForHeader(x::AbstractHeaderSearch, file::AbstractFileEntry) -> String
Return the spelling by which `file` was included when its location was resolved, or an
empty string when the header search never recorded one.
"""
function getIncludeNameForHeader(x::AbstractHeaderSearch, file::AbstractFileEntry)
    @check_ptrs x file
    return get_string(clang_HeaderSearch_getIncludeNameForHeader(x, file))
end

"""
    suggestPathToFileForDiagnostics(x::AbstractHeaderSearch, file::AbstractFileEntryRef,
                                    main_file::AbstractString) -> (String, Bool)
Suggest a path by which `file` could be `#include`d in a diagnostic, together with whether
it should be spelled `<Header.h>` rather than `"Header.h"`. `main_file` is the absolute path
of the file the diagnostic is generated for; it is used to shorten the suggestion when no
search directory is a prefix of `file`. The returned path uses forward slashes on every
platform.
"""
function suggestPathToFileForDiagnostics(x::AbstractHeaderSearch,
                                         file::AbstractFileEntryRef,
                                         main_file::AbstractString)
    @check_ptrs x file
    is_angled = Ref{Bool}(false)
    path = get_string(clang_HeaderSearch_suggestPathToFileForDiagnostics(x, file, main_file,
                                                                         is_angled))
    return path, is_angled[]
end

# HeaderFileInfo
#
# Every carrier below reads a record obtained from `getFileInfo` or `getExistingFileInfo`,
# which are owned snapshots the caller disposes -- not views into the search.

"""
    getIsImport(x::AbstractHeaderFileInfo) -> Bool
Return whether the header was `#import`ed.
"""
function getIsImport(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getIsImport(x)
end

"""
    getIsPragmaOnce(x::AbstractHeaderFileInfo) -> Bool
Return whether the header carries `#pragma once`, or was marked as such by
`MarkFileIncludeOnce`.
"""
function getIsPragmaOnce(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getIsPragmaOnce(x)
end

"""
    getDirInfo(x::AbstractHeaderFileInfo) -> CXCharacteristicKind
Return whether the header is a normal header, a system header, or a C++-friendly system
header — the field `getFileDirFlavor` reads.
"""
function getDirInfo(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getDirInfo(x)
end

"""
    getIsModuleHeader(x::AbstractHeaderFileInfo) -> Bool
Return whether the header is part of a module.
"""
function getIsModuleHeader(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getIsModuleHeader(x)
end

"""
    getIsValid(x::AbstractHeaderFileInfo) -> Bool
Return whether this record has been filled in, i.e. whether the file has ever been looked up
as a header.
"""
function getIsValid(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getIsValid(x)
end

"""
    getControllingMacroRaw(x::AbstractHeaderFileInfo) -> IdentifierInfo
Return the controlling macro exactly as stored on the record, with no external-source
resolution; the carrier holds `NULL` when the header has no controlling macro or the macro
is known only by ID.

`HeaderFileInfo::getControllingMacro` itself is not bound: it asserts that an
`ExternalPreprocessorSource` was supplied whenever the stored identifier is out of date, and
no entry point in this package can produce one.
"""
function getControllingMacroRaw(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return IdentifierInfo(clang_HeaderFileInfo_getControllingMacroRaw(x))
end

"""
    getFramework(x::AbstractHeaderFileInfo) -> String
Return the name of the framework the header came from, or an empty string when it did not
come from a framework include.
"""
function getFramework(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return get_string(clang_HeaderFileInfo_getFramework(x))
end
