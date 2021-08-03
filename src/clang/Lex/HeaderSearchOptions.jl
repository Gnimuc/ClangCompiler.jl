"""
    mutable struct HeaderSearchOptions <: Any
Holds a pointer to a `clang::HeaderSearchOptions` object.
"""
mutable struct HeaderSearchOptions
    ptr::CXHeaderSearchOptions
end

function get_resource_dir(x::HeaderSearchOptions)
    @assert x.ptr != C_NULL "HeaderSearchOptions has a NULL pointer."
    n = clang_HeaderSearchOptions_GetResourceDirLength(x.ptr)
    dir = Vector{Cuchar}(undef, n)
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, n)
    return String(dir)
end

function set_resource_dir(x::HeaderSearchOptions, dir::String)
    @assert x.ptr != C_NULL "HeaderSearchOptions has a NULL pointer."
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, length(dir))
    return nothing
end

function print_stats(x::HeaderSearchOptions)
    @assert x.ptr != C_NULL "HeaderSearchOptions has a NULL pointer."
    return clang_HeaderSearchOptions_PrintStats(x.ptr)
end
