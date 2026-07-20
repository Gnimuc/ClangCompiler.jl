"""
    struct Token <: AbstractToken
Hold a pointer to a `clang::Token` object.
"""
struct Token <: AbstractToken
    ptr::CXToken_
end

Base.unsafe_convert(::Type{CXToken_}, x::Token) = x.ptr
Base.cconvert(::Type{CXToken_}, x::Token) = x

"""
    struct AnnotationValue <: AbstractAnnotationValue
Hold a pointer to an "AnnotationValue".
"""
struct AnnotationValue <: AbstractAnnotationValue
    ptr::CXAnnotationValue
end

Base.unsafe_convert(::Type{CXAnnotationValue}, x::AnnotationValue) = x.ptr
Base.cconvert(::Type{CXAnnotationValue}, x::AnnotationValue) = x
