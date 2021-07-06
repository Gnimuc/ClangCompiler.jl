"""
    mutable struct HeaderSearchOptions <: Any
Holds a pointer to a `clang::HeaderSearchOptions` object.
"""
mutable struct HeaderSearchOptions
    ptr::CXHeaderSearchOptions
end

function get_resource_dir(x::HeaderSearchOptions)
    @assert x.ptr != C_NULL "header search options has a NULL pointer."
    n = clang_HeaderSearchOptions_GetResourceDirLength(x.ptr)
    dir = Vector{Cuchar}(undef, n)
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, n)
    return String(dir)
end

function set_resource_dir(x::HeaderSearchOptions, dir::String)
    @assert x.ptr != C_NULL "header search options has a NULL pointer."
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, length(dir))
    return nothing
end

function status(x::HeaderSearchOptions)
    @assert x.ptr != C_NULL "header search options has a NULL pointer."
    return clang_HeaderSearchOptions_PrintStats(x.ptr)
end

"""
    mutable struct PreprocessorOptions <: Any
Holds a pointer to a `clang::PreprocessorOptions` object.
"""
mutable struct PreprocessorOptions
    ptr::CXPreprocessorOptions
end

"""
    mutable struct HeaderSearch <: Any
Holds a pointer to a `clang::HeaderSearch` object.
"""
mutable struct HeaderSearch
    ptr::CXHeaderSearch
end

function status(x::HeaderSearch)
    @assert x.ptr != C_NULL "header search has a NULL pointer."
    return clang_HeaderSearch_PrintStats(x.ptr)
end

"""
    mutable struct Preprocessor <: Any
Holds a pointer to a `clang::Preprocessor` object.
"""
mutable struct Preprocessor
    ptr::CXPreprocessor
end

function get_header_search(pp::Preprocessor)
    @assert x.ptr != C_NULL "preprocessor has a NULL pointer."
    return HeaderSearch(clang_Preprocessor_getHeaderSearchInfo(pp.ptr))
end
