"""
    struct LookupResult <: AbstractLookupResult
Hold a pointer to a `clang::LookupResult` object.
"""
struct LookupResult <: AbstractLookupResult
    ptr::CXLookupResult
end

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

