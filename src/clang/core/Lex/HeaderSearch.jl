"""
    struct HeaderSearch <: Any
Hold a pointer to a `clang::HeaderSearch` object.
"""
struct HeaderSearch
    ptr::CXHeaderSearch
end

Base.unsafe_convert(::Type{CXHeaderSearch}, x::HeaderSearch) = x.ptr
Base.cconvert(::Type{CXHeaderSearch}, x::HeaderSearch) = x
