abstract type AbstractExternalPreprocessorSource end

"""
    struct ExternalPreprocessorSource <: AbstractExternalPreprocessorSource
Hold a pointer to a `clang::ExternalPreprocessorSource` object.
"""
struct ExternalPreprocessorSource <: AbstractExternalPreprocessorSource
    ptr::CXExternalPreprocessorSource
end

