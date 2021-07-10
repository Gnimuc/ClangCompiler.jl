"""
    mutable struct Sema <: Any
Holds a pointer to a `clang::Sema` object.
"""
mutable struct Sema
    ptr::CXSema
end

function status(x::Sema)
    @assert x.ptr != C_NULL "Sema has a NULL pointer."
    return clang_Sema_PrintStats(x.ptr)
end
