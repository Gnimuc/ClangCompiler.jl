# HeaderSearchOptions
function GetResourceDir(x::HeaderSearchOptions)
    @check_ptrs x
    n = clang_HeaderSearchOptions_GetResourceDirLength(x)
    dir = Vector{Cuchar}(undef, n)
    clang_HeaderSearchOptions_GetResourceDir(x, dir, n)
    return String(dir)
end

function GetResourceDir(x::HeaderSearchOptions, dir::String)
    @check_ptrs x
    clang_HeaderSearchOptions_GetResourceDir(x, dir, length(dir))
    return nothing
end

"""
    SetResourceDir(x::HeaderSearchOptions, dir::AbstractString)
Set the directory which holds the compiler resource files.
"""
function SetResourceDir(x::HeaderSearchOptions, dir::AbstractString)
    @check_ptrs x
    clang_HeaderSearchOptions_SetResourceDir(x, dir, ncodeunits(dir))
    return nothing
end
"""
    getSysroot(x::AbstractHeaderSearchOptions) -> String
Return the path prefixed to system include paths; `"/"` unless it was set.
"""
function getSysroot(x::AbstractHeaderSearchOptions)
    @check_ptrs x
    return get_string(clang_HeaderSearchOptions_getSysroot(x))
end

"""
    setSysroot(x::AbstractHeaderSearchOptions, sysroot::AbstractString)
Set the sysroot the system include paths are resolved against.
"""
function setSysroot(x::AbstractHeaderSearchOptions, sysroot::AbstractString)
    @check_ptrs x
    clang_HeaderSearchOptions_setSysroot(x, sysroot)
    return nothing
end

"""
    getModuleCachePath(x::AbstractHeaderSearchOptions) -> String
Return where implicitly built module files are cached, or `""` when implicit module builds
are off.
"""
function getModuleCachePath(x::AbstractHeaderSearchOptions)
    @check_ptrs x
    return get_string(clang_HeaderSearchOptions_getModuleCachePath(x))
end

"""
    setModuleCachePath(x::AbstractHeaderSearchOptions, path::AbstractString)
Set the directory implicitly built module files are cached in.
"""
function setModuleCachePath(x::AbstractHeaderSearchOptions, path::AbstractString)
    @check_ptrs x
    clang_HeaderSearchOptions_setModuleCachePath(x, path)
    return nothing
end

"""
    getUseBuiltinIncludes(x::AbstractHeaderSearchOptions) -> Bool
Return whether the compiler's own builtin headers, under the resource directory, are on the
search path.
"""
function getUseBuiltinIncludes(x::AbstractHeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_getUseBuiltinIncludes(x)
end

function setUseBuiltinIncludes(x::AbstractHeaderSearchOptions, value::Bool)
    @check_ptrs x
    clang_HeaderSearchOptions_setUseBuiltinIncludes(x, value)
    return nothing
end

"""
    getUseStandardSystemIncludes(x::AbstractHeaderSearchOptions) -> Bool
Return whether the standard system include paths are on the search path.
"""
function getUseStandardSystemIncludes(x::AbstractHeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_getUseStandardSystemIncludes(x)
end

function setUseStandardSystemIncludes(x::AbstractHeaderSearchOptions, value::Bool)
    @check_ptrs x
    clang_HeaderSearchOptions_setUseStandardSystemIncludes(x, value)
    return nothing
end

"""
    getUseStandardCXXIncludes(x::AbstractHeaderSearchOptions) -> Bool
Return whether the standard C++ standard-library include paths are on the search path.
"""
function getUseStandardCXXIncludes(x::AbstractHeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_getUseStandardCXXIncludes(x)
end

function setUseStandardCXXIncludes(x::AbstractHeaderSearchOptions, value::Bool)
    @check_ptrs x
    clang_HeaderSearchOptions_setUseStandardCXXIncludes(x, value)
    return nothing
end

"""
    getVerbose(x::AbstractHeaderSearchOptions) -> Bool
Return whether each header search attempt is printed to stderr, as `-v` does.
"""
function getVerbose(x::AbstractHeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_getVerbose(x)
end

function setVerbose(x::AbstractHeaderSearchOptions, value::Bool)
    @check_ptrs x
    clang_HeaderSearchOptions_setVerbose(x, value)
    return nothing
end

function PrintStats(x::HeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_PrintStats(x)
end
