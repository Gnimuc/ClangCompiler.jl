"""
    struct NestedNameSpecifier <: Any
Hold a `clang::NestedNameSpecifier` opaque pointer.
"""
struct NestedNameSpecifier
    ptr::CXNestedNameSpecifier
end

Base.unsafe_convert(::Type{CXNestedNameSpecifier}, x::NestedNameSpecifier) = x.ptr
Base.cconvert(::Type{CXNestedNameSpecifier}, x::NestedNameSpecifier) = x
