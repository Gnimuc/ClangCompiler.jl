"""
    struct PreprocessorOptions <: AbstractPreprocessorOptions
Hold a pointer to a `clang::PreprocessorOptions` object.
"""
struct PreprocessorOptions <: AbstractPreprocessorOptions
    ptr::CXPreprocessorOptions
end

