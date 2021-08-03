"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

"""
    mutable struct Decl <: AbstractDecl
Holds a pointer to a `clang::Decl` object.
"""
mutable struct Decl <: AbstractDecl
    ptr::CXDecl
end

function dump(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_dumpColor(x.ptr)
end

"""
    mutable struct NamedDecl <: AbstractDecl
Holds a pointer to a `clang::NamedDecl` object.
"""
mutable struct NamedDecl <: AbstractDecl
    ptr::CXNamedDecl
end
