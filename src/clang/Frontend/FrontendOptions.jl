"""
    mutable struct FrontendOptions <: Any
Holds a pointer to a `clang::FrontendOptions` object.
"""
mutable struct FrontendOptions
    ptr::CXFrontendOptions
end

function get_modules_embed_files(x::FrontendOptions)
    @assert x.ptr != C_NULL "FrontendOptions has a NULL pointer."
    n = clang_FrontendOptions_getModulesEmbedFilesNum(x.ptr)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_FrontendOptions_getModulesEmbedFiles(x.ptr, files, n)
    return unsafe_string.(files)
end

function print_stats(x::FrontendOptions)
    @assert x.ptr != C_NULL "FrontendOptions has a NULL pointer."
    return clang_FrontendOptions_PrintStats(x.ptr)
end
