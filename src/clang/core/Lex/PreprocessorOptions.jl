"""
    struct PreprocessorOptions <: AbstractPreprocessorOptions
Hold a pointer to a `clang::PreprocessorOptions` object.
"""
struct PreprocessorOptions <: AbstractPreprocessorOptions
    ptr::CXPreprocessorOptions
end

Base.unsafe_convert(::Type{CXPreprocessorOptions}, x::PreprocessorOptions) = x.ptr
Base.cconvert(::Type{CXPreprocessorOptions}, x::PreprocessorOptions) = x
