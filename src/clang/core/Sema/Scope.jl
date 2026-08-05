"""
    struct Scope <: AbstractScope
Hold a pointer to a `clang::Scope` object.
"""
struct Scope <: AbstractScope
    ptr::CXScope
end
