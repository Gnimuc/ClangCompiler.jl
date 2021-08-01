"""
mutable struct PreprocessorOptions <: Any
Holds a pointer to a `clang::PreprocessorOptions` object.
"""
mutable struct PreprocessorOptions
    ptr::CXPreprocessorOptions
end

function status(x::PreprocessorOptions)
    @assert x.ptr != C_NULL "PreprocessorOptions has a NULL pointer."
    return clang_PreprocessorOptions_PrintStats(x.ptr)
end
