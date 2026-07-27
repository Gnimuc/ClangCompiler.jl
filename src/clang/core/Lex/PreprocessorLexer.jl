abstract type AbstractPreprocessorLexer end

"""
    struct PreprocessorLexer <: AbstractPreprocessorLexer
Hold a pointer to a `clang::PreprocessorLexer` object.
"""
struct PreprocessorLexer <: AbstractPreprocessorLexer
    ptr::CXPreprocessorLexer
end

Base.unsafe_convert(::Type{CXPreprocessorLexer}, x::PreprocessorLexer) = x.ptr
Base.cconvert(::Type{CXPreprocessorLexer}, x::PreprocessorLexer) = x
