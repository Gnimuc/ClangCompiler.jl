"""
    mutable struct LookupResult <: Any
Holds a pointer to a `clang::LookupResult` object.
"""
mutable struct LookupResult
    ptr::CXLookupResult
end

function dump(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return clang_LookupResult_dump(x.ptr)
end

function is_empty(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return clang_LookupResult_empty(x.ptr)
end

function get_representative_decl(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return NamedDecl(clang_LookupResult_getRepresentativeDecl(x.ptr))
end
