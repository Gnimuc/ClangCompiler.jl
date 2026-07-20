"""
    struct Scope <: AbstractScope
Hold a pointer to a `clang::Scope` object.
"""
struct Scope <: AbstractScope
    ptr::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::Scope) = x.ptr
Base.cconvert(::Type{CXScope}, x::Scope) = x
