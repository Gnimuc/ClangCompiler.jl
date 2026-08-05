"""
    abstract type AbstractPreprocessorOutputOptions <: Any
Supertype for `clang::PreprocessorOutputOptions`.
"""
abstract type AbstractPreprocessorOutputOptions end

"""
    struct PreprocessorOutputOptions <: AbstractPreprocessorOutputOptions
Hold a pointer to a `clang::PreprocessorOutputOptions` object.
"""
struct PreprocessorOutputOptions <: AbstractPreprocessorOutputOptions
    ptr::CXPreprocessorOutputOptions
end
