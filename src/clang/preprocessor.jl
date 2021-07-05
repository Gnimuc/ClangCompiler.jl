"""
    mutable struct Preprocessor <: Any
Holds a pointer to a `clang::Preprocessor` object.
"""
mutable struct Preprocessor
    ptr::CXPreprocessor
end
