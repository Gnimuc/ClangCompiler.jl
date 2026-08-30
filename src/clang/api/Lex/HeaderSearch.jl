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
    getAngledDirIdx(x::AbstractHeaderSearch) -> Cuint
Return the index of the first angled (`-I`) search directory, i.e. how many quoted-only
(`-iquote`) entries the search holds.

Together with [`getSystemDirIdx`](@ref) and [`search_dir_size`](@ref) this partitions the flat
search-path list into `[0, angled)` quoted-only, `[angled, system)` angled and `[system, size)`
system. That partition is the only observable consequence of [`AddSearchPath`](@ref)'s
`is_angled` flag, and it is what decides which entries a lookup starts from:
[`LookupFile`](@ref) with `is_angled=true` begins at `getAngledDirIdx(x)`, so a quoted-only
entry is invisible to it.
"""
function getAngledDirIdx(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_getAngledDirIdx(x)
end

"""
    getSystemDirIdx(x::AbstractHeaderSearch) -> Cuint
Return the index of the first system search directory. See [`getAngledDirIdx`](@ref) for the
partition these two indices define.
"""
function getSystemDirIdx(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_getSystemDirIdx(x)
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

LLVM 20 reads an existing `HeaderFileInfo` only; if none has been filled in it returns the
default `DirInfo` (`C_User`) without creating a record.
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
    isModular(role_bits) -> Bool
Return whether a header carrying `role_bits` counts as part of its module's interface, i.e.
whether it is neither textual nor excluded.

This is `clang::ModuleMap::isModular` restated over the mirrored enumerators rather than
crossed as a call, and it is the predicate [`MarkFileModuleHeader`](@ref) uses to decide
whether to set the module-header bit.
"""
isModular(role_bits::Union{Integer,CXModuleHeaderRole}) = (UInt32(role_bits) & (UInt32(CXModuleHeaderRole_TextualHeader) | UInt32(CXModuleHeaderRole_ExcludedHeader))) == 0

"""
    isPrivateHeaderRole(role_bits) -> Bool
Return whether `role_bits` has the private-header bit set.

A module header role is a *bitmask*, not a single enumerator: clang packs it into a 3-bit
`PointerIntPair` and tests it with `&`, so a value such as `PrivateHeader | TextualHeader` is
legal and matches no enumerator on its own. That is why every role crosses the boundary as a
`UInt32` and is read with these predicates. The normal role is the absence of all three bits,
i.e. `role_bits == 0`.
"""
isPrivateHeaderRole(role_bits::Union{Integer,CXModuleHeaderRole}) = (UInt32(role_bits) & UInt32(CXModuleHeaderRole_PrivateHeader)) != 0

"""
    isTextualHeaderRole(role_bits) -> Bool
Return whether `role_bits` has the textual-header bit set. See [`isPrivateHeaderRole`](@ref).
"""
isTextualHeaderRole(role_bits::Union{Integer,CXModuleHeaderRole}) = (UInt32(role_bits) & UInt32(CXModuleHeaderRole_TextualHeader)) != 0

"""
    isExcludedHeaderRole(role_bits) -> Bool
Return whether `role_bits` has the excluded-header bit set. See [`isPrivateHeaderRole`](@ref).
"""
isExcludedHeaderRole(role_bits::Union{Integer,CXModuleHeaderRole}) = (UInt32(role_bits) & UInt32(CXModuleHeaderRole_ExcludedHeader)) != 0

"""
    MarkFileModuleHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef, role_bits,
                         is_compiling_module_header::Bool)
Mark `file` as belonging to a module in the role `role_bits` — a bitmask of
`CXModuleHeaderRole` values, not a single enumerator (see [`isPrivateHeaderRole`](@ref)).

Two bits are written, both by OR: the module-header bit iff `isModular(role_bits)`, and the
compiling-module-header bit iff `is_compiling_module_header`. Neither can be cleared again
except by [`ClearFileInfo`](@ref), so a call can only ever add to what
[`getIsModuleHeader`](@ref) and [`getIsCompilingModuleHeader`](@ref) report.

When the call would change nothing — a non-modular role with `is_compiling_module_header`
false — clang returns before touching the record, so unlike the other `MarkFile*` functions
this one does *not* always create a `HeaderFileInfo` for `file`.
"""
function MarkFileModuleHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef, role_bits::Union{Integer,CXModuleHeaderRole}, is_compiling_module_header::Bool)
    @check_ptrs x file
    return clang_HeaderSearch_MarkFileModuleHeader(x, file, UInt32(role_bits), is_compiling_module_header)
end

"""
    SetFileControllingMacro(x::AbstractHeaderSearch, file::AbstractFileEntryRef,
                            controlling_macro::AbstractIdentifierInfo)
Record `controlling_macro` as the include guard protecting the whole of `file`, which is
what lets the multiple-include optimization skip a repeated `#include`. Creates the
`HeaderFileInfo` record for `file` when there is none yet.
"""
function SetFileControllingMacro(x::AbstractHeaderSearch, file::AbstractFileEntryRef, controlling_macro::AbstractIdentifierInfo)
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
function getPrebuiltModuleFileName(x::AbstractHeaderSearch, module_name::AbstractString; file_map_only::Bool=false)
    @check_ptrs x
    return get_string(clang_HeaderSearch_getPrebuiltModuleFileName(x, module_name, file_map_only))
end

"""
    hasModuleMap(x::AbstractHeaderSearch, filename::AbstractString,
                 root::AbstractDirectoryEntry, is_system::Bool) -> Bool
Return whether a module map may map `filename` to a (sub)module. The search walks upward
from `filename`'s directory and stops at `root`. Always false when implicit module maps are
disabled, which is the default for an interpreter built without `-fimplicit-module-maps`.
"""
function hasModuleMap(x::AbstractHeaderSearch, filename::AbstractString, root::AbstractDirectoryEntry, is_system::Bool)
    @check_ptrs x root
    return clang_HeaderSearch_hasModuleMap(x, filename, root, is_system)
end

"""
    loadModuleMapFile(x::AbstractHeaderSearch, file::AbstractFileEntryRef,
                      is_system::Bool) -> Bool
Parse `file` as a module map and register its modules with `x`'s module map. **Returns `true`
on FAILURE**, mirroring clang's own inverted polarity: `false` means the map was parsed now or
had already been parsed.

This is what makes the rest of the module surface reachable — after it,
[`lookupModule`](@ref), [`collectAllModules`](@ref) and [`findModuleForHeader`](@ref) report
modules clang itself built, rather than nothing. It is not gated on `-fmodules` or
`-fimplicit-module-maps`: `ModuleMap::parseModuleMapFile` consults neither.

Clang does assert that the module map has target information, but every `HeaderSearch`
reachable from this package already has it — `Preprocessor::Initialize` calls `setTarget`
unconditionally and `CompilerInstance::createPreprocessor` always calls `Initialize` — so
there is nothing to assert here. That is also why the `HeaderSearch` constructor stays
unwrapped: a standalone one would have no target and no search paths.

The map is entered into the interpreter's `SourceManager` as a new `FileID`, and any parse
error is reported through `x`'s `DiagnosticsEngine`, so this mutates a running interpreter.
"""
function loadModuleMapFile(x::AbstractHeaderSearch, file::AbstractFileEntryRef, is_system::Bool)
    @check_ptrs x file
    return clang_HeaderSearch_loadModuleMapFile(x, file, is_system)
end

"""
    lookupModule(x::AbstractHeaderSearch, module_name::AbstractString;
                 import_loc::SourceLocation=SourceLocation(), allow_search::Bool=true,
                 allow_extra_module_map_search::Bool=false) -> Module_
Return the module named `module_name`, or a carrier holding `NULL` when none is known.

The search consults `x`'s module map first, so a module registered by
[`loadModuleMapFile`](@ref) is found whatever the configuration; only the fallback directory
search is gated on implicit module maps, and `allow_search=false` skips it entirely.
`import_loc` only locates diagnostics from that fallback and may stay invalid.

!!! warning
    The result is **borrowed** from `x`'s module map. Never `dispose` it: `dispose` exists for
    modules built by `Module_(name, ...)`, and calling it here is a double free that also
    deletes every submodule.
"""
function lookupModule(x::AbstractHeaderSearch, module_name::AbstractString; import_loc::SourceLocation=SourceLocation(), allow_search::Bool=true, allow_extra_module_map_search::Bool=false)
    @check_ptrs x
    return Module_(clang_HeaderSearch_lookupModule(x, module_name, import_loc, allow_search, allow_extra_module_map_search))
end

"""
    findModuleForHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef;
                        allow_textual::Bool=false,
                        allow_excluded::Bool=false) -> Tuple{Module_,UInt32}
Return the module that owns `file` together with the role it holds there. The module carrier
holds `NULL` when no module map assigns `file` to one, and the role is then clang's
default-constructed `0`, which carries no information.

The role is a *bitmask*, so read it with [`isPrivateHeaderRole`](@ref) and friends rather than
comparing it to a single `CXModuleHeaderRole`.

!!! warning
    Despite being declared `const`, this is not a pure query. `HeaderSearch` holds a `mutable`
    module map, and when no module map mentions `file` clang *infers* ownership from any
    enclosing umbrella directory, creating modules and submodules as it goes.
    [`getNumResolvedModulesForHeader`](@ref) is the inference-free enumerator.

`clang::ModuleMap::KnownHeader::isAvailable` is deliberately not wrapped — it dereferences the
module with no null check, so the not-found result it is most often handed is a segfault.
Compose it here instead: a non-NULL module, a role without the excluded bit, and
`isAvailable(mod)`.

The module is **borrowed** from `x`'s module map; never `dispose` it.
"""
function findModuleForHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef; allow_textual::Bool=false, allow_excluded::Bool=false)
    @check_ptrs x file
    role = Ref{UInt32}(0)
    mod = clang_HeaderSearch_findModuleForHeader(x, file, allow_textual, allow_excluded, role)
    return Module_(mod), role[]
end

"""
    getNumResolvedModulesForHeader(x::AbstractHeaderSearch,
                                   file::AbstractFileEntryRef) -> Cuint
Return how many `(module, role)` pairs already-resolved module maps report for `file`; zero
when none claims it.

A header can belong to several modules at once — a private one and a public one, or a textual
header shared by two — which is what this enumerates and [`findModuleForHeader`](@ref)
collapses to a single best answer. Unlike that function this one infers nothing, so it neither
creates modules nor changes its own answer between calls.
"""
function getNumResolvedModulesForHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return clang_HeaderSearch_getNumResolvedModulesForHeader(x, file)
end

"""
    getResolvedModuleForHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef,
                               idx::Integer) -> Tuple{Module_,UInt32}
Return the `idx`-th `(module, role)` pair (0-based) reported by
[`getNumResolvedModulesForHeader`](@ref) for `file`. `idx` must be less than that count; the C
shim indexes the array unchecked.

The role is a bitmask — see [`isPrivateHeaderRole`](@ref). The module is **borrowed** from
`x`'s module map; never `dispose` it.
"""
function getResolvedModuleForHeader(x::AbstractHeaderSearch, file::AbstractFileEntryRef, idx::Integer)
    @check_ptrs x file
    @assert 0 <= idx < getNumResolvedModulesForHeader(x, file) "resolved module index out of range"
    role = Ref{UInt32}(0)
    mod = clang_HeaderSearch_getResolvedModuleForHeader(x, file, idx, role)
    return Module_(mod), role[]
end

"""
    getNumAllModules(x::AbstractHeaderSearch) -> Cuint
Return how many top-level modules [`collectAllModules`](@ref) reports.

With implicit module maps enabled this call performs the same disk walk `collectAllModules`
does, so it may register modules that were not there before; it is idempotent from then on,
which is what makes the count-then-fill pair agree.
"""
function getNumAllModules(x::AbstractHeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_getNumAllModules(x)
end

"""
    collectAllModules(x::AbstractHeaderSearch) -> Vector{Module_}
Return every top-level module `x` knows about — the only way to discover modules without
already knowing their names, and the natural companion to [`loadModuleMapFile`](@ref).

The order is the module map's string-map iteration order, a pure function of its insertion
sequence, so the count walk and the fill walk agree on which module each index names. No slot
is `NULL`.

!!! warning
    Every carrier is **borrowed** from `x`'s module map. Never `dispose` one.
"""
function collectAllModules(x::AbstractHeaderSearch)
    @check_ptrs x
    n = clang_HeaderSearch_getNumAllModules(x)
    buf = Vector{CXModule_}(undef, n)
    n > 0 && clang_HeaderSearch_collectAllModules(x, buf)
    return [Module_(p) for p in buf]
end

"""
    LookupFile(x::AbstractHeaderSearch, filename::AbstractString; is_angled::Bool=false,
               skip_cache::Bool=false,
               cache_failures::Bool=false) -> Tuple{FileEntryRef,Bool,Bool}
Resolve `filename` against `x`'s search paths exactly as the preprocessor would, and return
the file it found together with whether a header map was involved and whether a framework was
found. The first carrier holds `NULL` when the file is not found.

`is_angled` picks the starting point: an angled lookup begins at [`getAngledDirIdx`](@ref), so
it cannot see a quoted-only entry, while a quoted one starts at index zero and searches
everything. There is no `#include_next` start directory and no includer list, so a quoted
lookup does *not* first try the including file's own directory.

`cache_failures` defaults to `false`, unlike clang. It is forwarded to the *file manager*, so
with it true a probe for a path that does not exist yet is remembered as missing, and a later
lookup keeps missing even once the file has been created.

It does not control the header search's own `LookupFileCache`, and that cache **does** make a
miss sticky, which is the surprising part: the cache records where the next search for this
filename should resume, and a search that found nothing leaves that position past the end of the
list. So a name that has missed once keeps missing even after a directory containing it is added
to the search path — measured, not inferred. `skip_cache=true` bypasses the cache and finds it;
a *different* filename in that same new directory is found without any help, because the cache is
keyed per filename.

This is a narrowed form of `HeaderSearch::LookupFile`. Its `SearchPath` / `RelativePath` /
`SuggestedModule` / `CurDir` out-parameters have no marshalling scheme, and passing no
requesting module and no suggestion slot is also what keeps the call total — clang then runs
no module machinery at all.

A non-`NULL` result allocates and one should call `dispose` to release it.
"""
function LookupFile(x::AbstractHeaderSearch, filename::AbstractString; is_angled::Bool=false, skip_cache::Bool=false, cache_failures::Bool=false)
    @check_ptrs x
    is_mapped = Ref{Bool}(false)
    is_framework_found = Ref{Bool}(false)
    fer = clang_HeaderSearch_LookupFile(x, filename, is_angled, skip_cache, cache_failures, is_mapped, is_framework_found)
    return FileEntryRef(fer), is_mapped[], is_framework_found[]
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
record. With `want_external=false` this is `getExistingLocalFileInfo`: a record supplied
only by an external source is reported as absent.

Like `getFileInfo` this hands back an owned snapshot rather than a view into the search.

This function allocates and one should call `dispose` to release the resources after using
this object -- but only when the returned carrier is non-NULL.
"""
function getExistingFileInfo(x::AbstractHeaderSearch, file::AbstractFileEntryRef; want_external::Bool=true)
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
function suggestPathToFileForDiagnostics(x::AbstractHeaderSearch, file::AbstractFileEntryRef, main_file::AbstractString)
    @check_ptrs x file
    is_angled = Ref{Bool}(false)
    path = get_string(clang_HeaderSearch_suggestPathToFileForDiagnostics(x, file, main_file, is_angled))
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
    getExternal(x::AbstractHeaderFileInfo) -> Bool
Return whether the record was supplied by an external source and has not changed since.

This is the bit [`getExistingFileInfo`](@ref)'s `want_external` keyword filters on: with
`want_external=false` clang reports a record whose `External` bit is set as absent. Nothing in
this package installs an external header-info source, so a record built here always reads
`false` and both spellings of `getExistingFileInfo` see it.
"""
function getExternal(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getExternal(x)
end

"""
    getIsModuleHeader(x::AbstractHeaderFileInfo) -> Bool
Return whether the header is part of a module — the bit
[`MarkFileModuleHeader`](@ref) sets for a modular role.
"""
function getIsModuleHeader(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getIsModuleHeader(x)
end

"""
    getIsCompilingModuleHeader(x::AbstractHeaderFileInfo) -> Bool
Return whether the header is part of the module currently being built, as set by
[`MarkFileModuleHeader`](@ref)'s `is_compiling_module_header` argument.
"""
function getIsCompilingModuleHeader(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return clang_HeaderFileInfo_getIsCompilingModuleHeader(x)
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
Always `""`. LLVM 20 dropped the `HeaderFileInfo::Framework` field, so the shim has no member
to read; the C name is kept so the binding still resolves.
"""
function getFramework(x::AbstractHeaderFileInfo)
    @check_ptrs x
    return get_string(clang_HeaderFileInfo_getFramework(x))
end

"""
    AddSearchPath(x::AbstractHeaderSearch, dir::AbstractDirectoryLookup, is_angled::Bool)
Insert `dir` into `x`'s search-path list at the boundary between the quoted/angled paths and
the system paths: before the first system directory when `is_angled` is true, before the first
angled one otherwise. `dir` is copied, so it may be disposed right after this call.

Add search paths before any `#include` has been resolved through this search. The insertion
shifts every existing index at or after the insertion point, while the search's private lookup
caches keep the old ones; those caches are unreachable from here, so the staleness can be
avoided but not repaired. [`AddSystemSearchPath`](@ref) appends instead and has no such
ordering rule.
"""
function AddSearchPath(x::AbstractHeaderSearch, dir::AbstractDirectoryLookup, is_angled::Bool)
    @check_ptrs x dir
    return clang_HeaderSearch_AddSearchPath(x, dir, is_angled)
end

"""
    AddSystemSearchPath(x::AbstractHeaderSearch, dir::AbstractDirectoryLookup)
Append `dir` after every existing search path of `x`, as a system directory searched last.

`dir` is copied, so it may be disposed right after this call. No existing search-path index
moves, which is what makes this the safe half of the pair.
"""
function AddSystemSearchPath(x::AbstractHeaderSearch, dir::AbstractDirectoryLookup)
    @check_ptrs x dir
    return clang_HeaderSearch_AddSystemSearchPath(x, dir)
end

"""
    CreateHeaderMap(x::AbstractHeaderSearch, file::AbstractFileEntryRef) -> HeaderMap
Open `file` as an Apple header map and register it with `x`, returning a carrier holding
`NULL` when `file` is not a valid header map.

The search uniques its maps by file, so a second call for the same file returns the same
pointer rather than a second map, and the registration shows up in
[`getNumHeaderMapFileNames`](@ref). The result is borrowed from the search — there is no
`dispose`.
"""
function CreateHeaderMap(x::AbstractHeaderSearch, file::AbstractFileEntryRef)
    @check_ptrs x file
    return HeaderMap(clang_HeaderSearch_CreateHeaderMap(x, file))
end

"""
    getCachedModuleFileName(x::AbstractHeaderSearch, module_name::AbstractString,
                            module_map_path::AbstractString) -> String
Return the path the module cache would use for the module named `module_name` declared in
`module_map_path`, or `""` when there is none.

The result is empty in two cases: the search has no module cache path
([`setModuleCachePath`](@ref) sets it, and a relative one is made absolute against the
process's working directory), or `module_map_path`'s parent directory cannot be resolved.
Nothing here requires modules to be enabled.
"""
function getCachedModuleFileName(x::AbstractHeaderSearch, module_name::AbstractString, module_map_path::AbstractString)
    @check_ptrs x
    return get_string(clang_HeaderSearch_getCachedModuleFileName(x, module_name, module_map_path))
end

"""
    ShouldEnterIncludeFile(x::AbstractHeaderSearch, pp::Preprocessor,
                           file::AbstractFileEntryRef, is_import::Bool=false;
                           modules_enabled::Bool=false, mod=nothing) -> Tuple{Bool,Bool}
Return clang's multiple-include decision for `file` — whether the preprocessor should enter it
— together with whether this is the first time `pp` has seen it.

`is_import` records the `#import` bit on the file's record, so this call mutates the search's
state as well as reading it. `mod` names the module being built and stays `nothing` unless
modules are on; `modules_enabled` must agree with the invocation, which is why it is checked
against `getModules(getLangOpts(pp))`.

`x` must be `pp`'s own header search: the `#import` path reaches back through `pp` to the
search *it* holds, so a mismatched pair records the bit on the wrong one. The file's
controlling-macro identifier must also not be out of date unless an external lookup source is
installed, because clang resolves it through that source's vtable without checking for null.
"""
function ShouldEnterIncludeFile(x::AbstractHeaderSearch, pp::Preprocessor, file::AbstractFileEntryRef, is_import::Bool=false; modules_enabled::Bool=false, mod::Union{AbstractModule,Nothing}=nothing)
    @check_ptrs x pp file
    @assert getHeaderSearchInfo(pp).ptr == x.ptr "x must be pp's own header search"
    @assert modules_enabled == getModules(getLangOpts(pp)) "modules_enabled must match the invocation"
    if is_null_handle(getExternalLookup(x))
        hfi = getExistingFileInfo(x, file)
        if !is_null_handle(hfi)
            ii = getControllingMacroRaw(hfi)
            stale = !is_null_handle(ii) && isOutOfDate(ii)
            dispose(hfi)
            @assert !stale "the file's controlling macro is out of date and no external lookup source is installed"
        end
    end
    first = Ref{Bool}(false)
    enter = clang_HeaderSearch_ShouldEnterIncludeFile(x, pp, file, is_import, modules_enabled, mod === nothing ? C_NULL : mod, first)
    return enter, first[]
end
