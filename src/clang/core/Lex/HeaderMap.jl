abstract type AbstractHeaderMap end

"""
    struct HeaderMap <: AbstractHeaderMap
Hold a pointer to a `clang::HeaderMap` object.

The map is owned by the `HeaderSearch` that created it, so it is borrowed: there is no
`dispose`.
"""
struct HeaderMap <: AbstractHeaderMap
    ptr::CXHeaderMap
end

Base.unsafe_convert(::Type{CXHeaderMap}, x::HeaderMap) = x.ptr
Base.cconvert(::Type{CXHeaderMap}, x::HeaderMap) = x
