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
