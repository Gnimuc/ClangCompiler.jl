"""
    struct Scope <: Any
Hold a pointer to a `clang::Scope` object.
"""
struct Scope
    ptr::CXScope
end

Base.unsafe_convert(::Type{CXScope}, x::Scope) = x.ptr
Base.cconvert(::Type{CXScope}, x::Scope) = x
