"""
    struct LookupResult <: AbstractLookupResult
Hold a pointer to a `clang::LookupResult` object.
"""
struct LookupResult <: AbstractLookupResult
    ptr::CXLookupResult
end

Base.unsafe_convert(::Type{CXLookupResult}, x::LookupResult) = x.ptr
Base.cconvert(::Type{CXLookupResult}, x::LookupResult) = x


"""
    abstract type AbstractLookupResultFilter end
Supertype for `LookupResultFilter`s.
"""
abstract type AbstractLookupResultFilter end

"""
    struct LookupResultFilter <: AbstractLookupResultFilter
Hold a pointer to a `clang::LookupResult::Filter` object.
"""
struct LookupResultFilter <: AbstractLookupResultFilter
    ptr::CXLookupResult_Filter
end

Base.unsafe_convert(::Type{CXLookupResult_Filter}, x::LookupResultFilter) = x.ptr
Base.cconvert(::Type{CXLookupResult_Filter}, x::LookupResultFilter) = x
