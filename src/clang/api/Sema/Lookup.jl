# LookupResult
dispose(x::LookupResult) = clang_LookupResult_dispose(x)

function isForRedeclaration(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isForRedeclaration(x)
end

function isTemplateNameLookup(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isTemplateNameLookup(x)
end

function isAmbiguous(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isAmbiguous(x)
end

function isSingleResult(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isSingleResult(x)
end

function isOverloadedResult(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isOverloadedResult(x)
end

function isUnresolvableResult(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isUnresolvableResult(x)
end

function isClassLookup(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isClassLookup(x)
end

function resolveKind(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_resolveKind(x)
end

function isSingleTagDecl(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isSingleTagDecl(x)
end

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

function setLookupName(x::LookupResult, dn::DeclarationName)
    @check_ptrs x
    return clang_LookupResult_setLookupName(x, dn)
end

function getRepresentativeDecl(x::LookupResult)
    @check_ptrs x
    return NamedDecl(clang_LookupResult_getRepresentativeDecl(x))
end

function getLookupName(x::LookupResult)
    @check_ptrs x
    return DeclarationName(clang_LookupResult_getLookupName(x))
end

function getNum(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_getNum(x)
end

function getResults(x::LookupResult)
    @check_ptrs x
    n = getNum(x)
    v = Vector{CXNamedDecl}(undef, n)
    clang_LookupResult_getResults(x, v, n)
    return NamedDecl.(v)
end
