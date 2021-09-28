"""
    struct HeaderSearchOptions <: Any
Hold a pointer to a `clang::HeaderSearchOptions` object.
"""
struct HeaderSearchOptions
    ptr::CXHeaderSearchOptions
end

Base.unsafe_convert(::Type{CXHeaderSearchOptions}, x::HeaderSearchOptions) = x.ptr
Base.cconvert(::Type{CXHeaderSearchOptions}, x::HeaderSearchOptions) = x
