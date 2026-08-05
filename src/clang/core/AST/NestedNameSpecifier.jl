"""
    struct NestedNameSpecifier <: AbstractNestedNameSpecifier
Hold a `clang::NestedNameSpecifier` opaque pointer.
"""
struct NestedNameSpecifier <: AbstractNestedNameSpecifier
    ptr::CXNestedNameSpecifier
end

abstract type AbstractNestedNameSpecifierLoc end

"""
    struct NestedNameSpecifierLoc <: AbstractNestedNameSpecifierLoc
Hold a pointer to a heap-boxed `clang::NestedNameSpecifierLoc` object.
"""
struct NestedNameSpecifierLoc <: AbstractNestedNameSpecifierLoc
    ptr::CXNestedNameSpecifierLoc
end

