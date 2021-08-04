"""
    struct HeaderSearch <: Any
Holds a pointer to a `clang::HeaderSearch` object.
"""
struct HeaderSearch
    ptr::CXHeaderSearch
end

function print_stats(x::HeaderSearch)
    @assert x.ptr != C_NULL "HeaderSearch has a NULL pointer."
    return clang_HeaderSearch_PrintStats(x.ptr)
end
