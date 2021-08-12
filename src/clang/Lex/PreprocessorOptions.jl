"""
struct PreprocessorOptions <: Any
Hold a pointer to a `clang::PreprocessorOptions` object.
"""
struct PreprocessorOptions
    ptr::CXPreprocessorOptions
end

function print_stats(x::PreprocessorOptions)
    @assert x.ptr != C_NULL "PreprocessorOptions has a NULL pointer."
    return clang_PreprocessorOptions_PrintStats(x.ptr)
end
