"""
    struct Preprocessor <: AbstractPreprocessor
Hold a pointer to a `clang::Preprocessor` object.
"""
struct Preprocessor <: AbstractPreprocessor
    ptr::CXPreprocessor
end

abstract type AbstractEmptylineHandler end

"""
    struct EmptylineHandler <: AbstractEmptylineHandler
Hold a pointer to a `clang::EmptylineHandler` object.
"""
struct EmptylineHandler <: AbstractEmptylineHandler
    ptr::CXEmptylineHandler
end
