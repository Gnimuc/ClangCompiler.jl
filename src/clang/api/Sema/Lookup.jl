# LookupResult
dispose(x::LookupResult) = clang_LookupResult_dispose(x)

function clear(x::LookupResult, kind::CXLookupNameKind)
    @check_ptrs x
    return clang_LookupResult_clear(x, kind)
end

function dump(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_dump(x)
end

function empty(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_empty(x)
end

function getLookupName(x::LookupResult)
    @check_ptrs x
    return DeclarationName(clang_LookupResult_getLookupName(x))
end

function setLookupName(x::LookupResult, dn::DeclarationName)
    @check_ptrs x
    return clang_LookupResult_setLookupName(x, dn)
end

function getRepresentativeDecl(x::LookupResult)
    @check_ptrs x
    return NamedDecl(clang_LookupResult_getRepresentativeDecl(x))
end
