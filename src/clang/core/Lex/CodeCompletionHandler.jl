abstract type AbstractCodeCompletionHandler end

"""
    struct CodeCompletionHandler <: AbstractCodeCompletionHandler
Hold a pointer to a `clang::CodeCompletionHandler` object.
"""
struct CodeCompletionHandler <: AbstractCodeCompletionHandler
    ptr::CXCodeCompletionHandler
end

Base.unsafe_convert(::Type{CXCodeCompletionHandler}, x::CodeCompletionHandler) = x.ptr
Base.cconvert(::Type{CXCodeCompletionHandler}, x::CodeCompletionHandler) = x
