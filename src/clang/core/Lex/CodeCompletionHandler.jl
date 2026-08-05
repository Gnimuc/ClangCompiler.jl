abstract type AbstractCodeCompletionHandler end

"""
    struct CodeCompletionHandler <: AbstractCodeCompletionHandler
Hold a pointer to a `clang::CodeCompletionHandler` object.
"""
struct CodeCompletionHandler <: AbstractCodeCompletionHandler
    ptr::CXCodeCompletionHandler
end

