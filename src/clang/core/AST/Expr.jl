"""
    abstract type AbstractExpr
Supertype for `Expr`s.
"""
abstract type AbstractExpr end

"""
    struct Expr_ <: AbstractExpr
Hold a pointer to a `clang::Expr` object.
"""
struct Expr_ <: AbstractExpr
    ptr::CXExpr
end

Base.unsafe_convert(::Type{CXExpr}, x::Expr_) = x.ptr
Base.cconvert(::Type{CXExpr}, x::Expr_) = x
