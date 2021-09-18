"""
    struct FrontendOptions <: Any
Hold a pointer to a `clang::FrontendOptions` object.
"""
struct FrontendOptions
    ptr::CXFrontendOptions
end

function get_modules_embed_files(x::FrontendOptions)
    @check_ptrs x
    n = clang_FrontendOptions_getModulesEmbedFilesNum(x.ptr)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_FrontendOptions_getModulesEmbedFiles(x.ptr, files, n)
    return unsafe_string.(files)
end

function PrintStats(x::FrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_PrintStats(x.ptr)
end
