# NestedNameSpecifier
function getPrefix(x::NestedNameSpecifier)
    @check_ptrs x
    return NestedNameSpecifier(clang_NestedNameSpecifier_getPrefix(x))
end

function getKind(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_getKind(x)
end

function getAsIdentifier(x::NestedNameSpecifier)
    @check_ptrs x
    return IdentifierInfo(clang_NestedNameSpecifier_getAsIdentifier(x))
end

function getAsNamespace(x::NestedNameSpecifier)
    @check_ptrs x
    return NamespaceDecl(clang_NestedNameSpecifier_getAsNamespace(x))
end

function getAsNamespaceAlias(x::NestedNameSpecifier)
    @check_ptrs x
    return NamespaceAliasDecl(clang_NestedNameSpecifier_getAsNamespaceAlias(x))
end

function getAsRecordDecl(x::NestedNameSpecifier)
    @check_ptrs x
    return CXXRecordDecl(clang_NestedNameSpecifier_getAsRecordDecl(x))
end

function getAsType(x::NestedNameSpecifier)
    @check_ptrs x
    return Type_(clang_NestedNameSpecifier_getAsType(x))
end

function isDependent(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_isDependent(x)
end

function isInstantiationDependent(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_isInstantiationDependent(x)
end

function containsUnexpandedParameterPack(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_containsUnexpandedParameterPack(x)
end

function containsErrors(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_containsErrors(x)
end

function dump(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_dump(x)
end

function getName(x::NestedNameSpecifier)
    @check_ptrs x
    return get_string(clang_NestedNameSpecifier_getName(x))
end
