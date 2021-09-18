"""
struct PreprocessorOptions <: Any
Hold a pointer to a `clang::PreprocessorOptions` object.
"""
struct PreprocessorOptions
    ptr::CXPreprocessorOptions
end

function PrintStats(x::PreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_PrintStats(x.ptr)
end
