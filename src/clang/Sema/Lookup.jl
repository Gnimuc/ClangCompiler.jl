"""
    struct LookupResult <: Any
Hold a pointer to a `clang::LookupResult` object.
"""
struct LookupResult
    ptr::CXLookupResult
end

dispose(x::LookupResult) = clang_LookupResult_dispose(x.ptr)

function clear(x::LookupResult, kind::CXLookupNameKind)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return clang_LookupResult_clear(x.ptr, kind)
end

function dump(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return clang_LookupResult_dump(x.ptr)
end

function is_empty(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return clang_LookupResult_empty(x.ptr)
end

function get_name(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return DeclarationName(clang_LookupResult_getLookupName(x.ptr))
end

function set_name(x::LookupResult, dn::DeclarationName)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return clang_LookupResult_setLookupName(x.ptr, dn.ptr)
end

function get_representative_decl(x::LookupResult)
    @assert x.ptr != C_NULL "LookupResult has a NULL pointer."
    return NamedDecl(clang_LookupResult_getRepresentativeDecl(x.ptr))
end
