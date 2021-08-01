"""
    mutable struct Decl <: Any
Holds a pointer to a `clang::Decl` object.
"""
mutable struct Decl
    ptr::CXDecl
end

function dump(x::Decl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_dumpColor(x.ptr)
end
