"""
    mutable struct Sema <: Any
Holds a pointer to a `clang::Sema` object.
"""
mutable struct Sema
    ptr::CXSema
end
