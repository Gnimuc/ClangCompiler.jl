"""
    struct Token <: Any
Hold a pointer to a `clang::Token` object.
"""
struct Token
    ptr::CXToken_
end

Base.unsafe_convert(::Type{CXToken_}, x::Token) = x.ptr
Base.cconvert(::Type{CXToken_}, x::Token) = x

"""
    struct AnnotationValue <: Any
Hold a pointer to an "AnnotationValue".
"""
struct AnnotationValue
    ptr::CXAnnotationValue
end

Base.unsafe_convert(::Type{CXAnnotationValue}, x::AnnotationValue) = x.ptr
Base.cconvert(::Type{CXAnnotationValue}, x::AnnotationValue) = x
