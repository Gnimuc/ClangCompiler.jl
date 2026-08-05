"""
    struct NestedNameSpecifier <: AbstractNestedNameSpecifier
Hold a `clang::NestedNameSpecifier` opaque pointer.
"""
struct NestedNameSpecifier <: AbstractNestedNameSpecifier
    ptr::CXNestedNameSpecifier
end

Base.unsafe_convert(::Type{CXNestedNameSpecifier}, x::NestedNameSpecifier) = x.ptr
Base.cconvert(::Type{CXNestedNameSpecifier}, x::NestedNameSpecifier) = x


abstract type AbstractNestedNameSpecifierLoc end

"""
    struct NestedNameSpecifierLoc <: AbstractNestedNameSpecifierLoc
Hold a pointer to a heap-boxed `clang::NestedNameSpecifierLoc` object.
"""
struct NestedNameSpecifierLoc <: AbstractNestedNameSpecifierLoc
    ptr::CXNestedNameSpecifierLoc
end

Base.unsafe_convert(::Type{CXNestedNameSpecifierLoc}, x::NestedNameSpecifierLoc) = x.ptr
Base.cconvert(::Type{CXNestedNameSpecifierLoc}, x::NestedNameSpecifierLoc) = x
