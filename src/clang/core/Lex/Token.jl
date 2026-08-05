"""
    struct Token <: AbstractToken
Hold a pointer to a `clang::Token` object.
"""
struct Token <: AbstractToken
    ptr::CXToken_
end

"""
    struct AnnotationValue <: AbstractAnnotationValue
Hold a pointer to an "AnnotationValue".
"""
struct AnnotationValue <: AbstractAnnotationValue
    ptr::CXAnnotationValue
end

