"""
    struct Preprocessor <: Any
Hold a pointer to a `clang::Preprocessor` object.
"""
struct Preprocessor
    ptr::CXPreprocessor
end

Base.unsafe_convert(::Type{CXPreprocessor}, x::Preprocessor) = x.ptr
Base.cconvert(::Type{CXPreprocessor}, x::Preprocessor) = x
