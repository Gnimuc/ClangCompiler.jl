abstract type AbstractExternalPreprocessorSource end

"""
    struct ExternalPreprocessorSource <: AbstractExternalPreprocessorSource
Hold a pointer to a `clang::ExternalPreprocessorSource` object.
"""
struct ExternalPreprocessorSource <: AbstractExternalPreprocessorSource
    ptr::CXExternalPreprocessorSource
end

function Base.unsafe_convert(::Type{CXExternalPreprocessorSource},
                             x::ExternalPreprocessorSource)
    return x.ptr
end
Base.cconvert(::Type{CXExternalPreprocessorSource}, x::ExternalPreprocessorSource) = x
