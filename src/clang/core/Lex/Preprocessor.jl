"""
    struct Preprocessor <: AbstractPreprocessor
Hold a pointer to a `clang::Preprocessor` object.
"""
struct Preprocessor <: AbstractPreprocessor
    ptr::CXPreprocessor
end

Base.unsafe_convert(::Type{CXPreprocessor}, x::Preprocessor) = x.ptr
Base.cconvert(::Type{CXPreprocessor}, x::Preprocessor) = x


abstract type AbstractEmptylineHandler end

"""
    struct EmptylineHandler <: AbstractEmptylineHandler
Hold a pointer to a `clang::EmptylineHandler` object.
"""
struct EmptylineHandler <: AbstractEmptylineHandler
    ptr::CXEmptylineHandler
end

Base.unsafe_convert(::Type{CXEmptylineHandler}, x::EmptylineHandler) = x.ptr
Base.cconvert(::Type{CXEmptylineHandler}, x::EmptylineHandler) = x
