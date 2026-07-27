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

function getResult(x::LookupResult)
    @check_ptrs x
    return NamedDecl(clang_LookupResult_getResult(x))
end


function getResultKind(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_getResultKind(x)
end

"""
    getAmbiguityKind(x::AbstractLookupResult) -> CXAmbiguityKind
Precondition: the lookup is ambiguous -- `clang::LookupResult::getAmbiguityKind` asserts it.
"""
function getAmbiguityKind(x::AbstractLookupResult)
    @check_ptrs x
    @assert isAmbiguous(x) "the lookup result is not ambiguous"
    return clang_LookupResult_getAmbiguityKind(x)
end

"""
    getFoundDecl(x::AbstractLookupResult) -> NamedDecl
Precondition: `getResultKind(x) == CXLookupResultKind_Found` --
`clang::LookupResult::getFoundDecl` asserts the result is unique before dereferencing it.
"""
function getFoundDecl(x::AbstractLookupResult)
    @check_ptrs x
    @assert getResultKind(x) == CXLookupResultKind_Found "the lookup result is not a unique decl"
    return NamedDecl(clang_LookupResult_getFoundDecl(x))
end

function getNamingClass(x::AbstractLookupResult)
    @check_ptrs x
    return CXXRecordDecl(clang_LookupResult_getNamingClass(x))
end

function getLookupKind(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_getLookupKind(x)
end

function getNameLoc(x::AbstractLookupResult)
    @check_ptrs x
    return SourceLocation(clang_LookupResult_getNameLoc(x))
end

function getIdentifierNamespace(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_getIdentifierNamespace(x)
end

function suppressDiagnostics(x::AbstractLookupResult)
    @check_ptrs x
    clang_LookupResult_suppressDiagnostics(x)
    return nothing
end
