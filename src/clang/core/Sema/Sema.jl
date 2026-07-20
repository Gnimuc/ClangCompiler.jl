"""
    struct Sema <: AbstractSema
Hold a pointer to a `clang::Sema` object.
"""
struct Sema <: AbstractSema
    ptr::CXSema
end

Base.unsafe_convert(::Type{CXSema}, x::Sema) = x.ptr
Base.cconvert(::Type{CXSema}, x::Sema) = x
