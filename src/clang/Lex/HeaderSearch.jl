"""
    mutable struct HeaderSearch <: Any
Holds a pointer to a `clang::HeaderSearch` object.
"""
mutable struct HeaderSearch
    ptr::CXHeaderSearch
end

function status(x::HeaderSearch)
    @assert x.ptr != C_NULL "HeaderSearch has a NULL pointer."
    return clang_HeaderSearch_PrintStats(x.ptr)
end
