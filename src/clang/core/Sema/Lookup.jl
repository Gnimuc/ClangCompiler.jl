"""
    struct LookupResult <: AbstractLookupResult
Hold a pointer to a `clang::LookupResult` object.
"""
struct LookupResult <: AbstractLookupResult
    ptr::CXLookupResult
end

Base.unsafe_convert(::Type{CXLookupResult}, x::LookupResult) = x.ptr
Base.cconvert(::Type{CXLookupResult}, x::LookupResult) = x
