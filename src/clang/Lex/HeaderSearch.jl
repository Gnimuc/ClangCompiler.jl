"""
    struct HeaderSearch <: Any
Hold a pointer to a `clang::HeaderSearch` object.
"""
struct HeaderSearch
    ptr::CXHeaderSearch
end

function PrintStats(x::HeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_PrintStats(x.ptr)
end
