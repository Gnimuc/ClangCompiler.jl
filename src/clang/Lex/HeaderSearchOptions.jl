"""
    struct HeaderSearchOptions <: Any
Hold a pointer to a `clang::HeaderSearchOptions` object.
"""
struct HeaderSearchOptions
    ptr::CXHeaderSearchOptions
end

function get_resource_dir(x::HeaderSearchOptions)
    @check_ptrs x
    n = clang_HeaderSearchOptions_GetResourceDirLength(x.ptr)
    dir = Vector{Cuchar}(undef, n)
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, n)
    return String(dir)
end

function set_resource_dir(x::HeaderSearchOptions, dir::String)
    @check_ptrs x
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, length(dir))
    return nothing
end

function PrintStats(x::HeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_PrintStats(x.ptr)
end
