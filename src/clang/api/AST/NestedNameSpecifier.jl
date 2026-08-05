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


# NestedNameSpecifier (the static builders)
"""
    NestedNameSpecifier(ctx::ASTContext, prefix::NestedNameSpecifier, id::IdentifierInfo) -> NestedNameSpecifier
The specifier that appends the identifier `id` to `prefix`, interned in `ctx`'s arena (borrowed:
there is no `dispose`).

`prefix` may be a NULL-pointer carrier and must otherwise be dependent (`isDependent`) — an
identifier component is only well-formed where the prefix cannot be resolved.
"""
function NestedNameSpecifier(ctx::ASTContext, prefix::NestedNameSpecifier,
                             id::IdentifierInfo)
    @check_ptrs ctx id
    @assert prefix.ptr == C_NULL || isDependent(prefix) "the prefix must be dependent or absent"
    return NestedNameSpecifier(clang_NestedNameSpecifier_Create(ctx, prefix, id))
end

"""
    GlobalSpecifier(ctx::ASTContext) -> NestedNameSpecifier
The specifier naming the global scope (a leading `::`), interned in `ctx`'s arena.
"""
function GlobalSpecifier(ctx::ASTContext)
    @check_ptrs ctx
    return NestedNameSpecifier(clang_NestedNameSpecifier_GlobalSpecifier(ctx))
end

"""
    SuperSpecifier(ctx::ASTContext, rd::AbstractCXXRecordDecl) -> NestedNameSpecifier
The specifier naming the `__super` scope of `rd`, interned in `ctx`'s arena.
"""
function SuperSpecifier(ctx::ASTContext, rd::AbstractCXXRecordDecl)
    @check_ptrs ctx rd
    return NestedNameSpecifier(clang_NestedNameSpecifier_SuperSpecifier(ctx, rd))
end


# NestedNameSpecifierLoc
"""
    hasQualifier(x::AbstractNestedNameSpecifierLoc) -> Bool
Return whether this location describes a written nested-name-specifier at all. An empty
location — what a `getQualifierLoc` accessor hands back for an unqualified name — is a legal
value rather than a NULL handle, so this is the guard for the component accessors below.
"""
function hasQualifier(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    return clang_NestedNameSpecifierLoc_hasQualifier(x)
end

"""
    getNestedNameSpecifier(x::AbstractNestedNameSpecifierLoc) -> NestedNameSpecifier
Return the specifier this location describes, stripped of its source locations. The pointer
is NULL exactly when `hasQualifier(x)` is false.
"""
function getNestedNameSpecifier(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    return NestedNameSpecifier(clang_NestedNameSpecifierLoc_getNestedNameSpecifier(x))
end

"""
    getSourceRange(x::AbstractNestedNameSpecifierLoc) -> SourceRange
Return the extent of the whole specifier, prefix included — for `::std::vector<int>::`, from
the leading `::` to the last `::`. An empty location yields an invalid range.
"""
function getSourceRange(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    r = clang_NestedNameSpecifierLoc_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getLocalSourceRange(x::AbstractNestedNameSpecifierLoc) -> SourceRange
Return the extent of just the last component, prefix excluded — for `::std::vector<int>::`,
from `vector` to the last `::`. `x` must be non-empty: an empty location has no component.
"""
function getLocalSourceRange(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    @assert hasQualifier(x) "an empty nested-name-specifier location has no last component"
    r = clang_NestedNameSpecifierLoc_getLocalSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getBeginLoc(x::AbstractNestedNameSpecifierLoc) -> SourceLocation
Return the start of `getSourceRange(x)`; invalid for an empty location.
"""
function getBeginLoc(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    return SourceLocation(clang_NestedNameSpecifierLoc_getBeginLoc(x))
end

"""
    getEndLoc(x::AbstractNestedNameSpecifierLoc) -> SourceLocation
Return the end of `getSourceRange(x)`; invalid for an empty location.
"""
function getEndLoc(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    return SourceLocation(clang_NestedNameSpecifierLoc_getEndLoc(x))
end

"""
    getLocalBeginLoc(x::AbstractNestedNameSpecifierLoc) -> SourceLocation
Return the start of `getLocalSourceRange(x)`. `x` must be non-empty.
"""
function getLocalBeginLoc(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    @assert hasQualifier(x) "an empty nested-name-specifier location has no last component"
    return SourceLocation(clang_NestedNameSpecifierLoc_getLocalBeginLoc(x))
end

"""
    getLocalEndLoc(x::AbstractNestedNameSpecifierLoc) -> SourceLocation
Return the end of `getLocalSourceRange(x)`. `x` must be non-empty.
"""
function getLocalEndLoc(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    @assert hasQualifier(x) "an empty nested-name-specifier location has no last component"
    return SourceLocation(clang_NestedNameSpecifierLoc_getLocalEndLoc(x))
end

"""
    getPrefix(x::AbstractNestedNameSpecifierLoc) -> NestedNameSpecifierLoc
Return everything but the last component — for `::std::vector<int>::`, the `::std::` part.
An empty location's prefix is empty in turn, so a walk guarded by `hasQualifier` terminates.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getPrefix(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_NestedNameSpecifierLoc_getPrefix(x))
end

"""
    getTypeLoc(x::AbstractNestedNameSpecifierLoc) -> TypeLoc
Return the written type of the last component, with its own source locations. `x` must be
non-empty and its specifier must name a type (`getKind` is `TypeSpec` or
`TypeSpecWithTemplate`) — clang dereferences the specifier and reads the component's
trailing `TypeLoc` storage unchecked.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getTypeLoc(x::AbstractNestedNameSpecifierLoc)
    @check_ptrs x
    @assert hasQualifier(x) "an empty nested-name-specifier location names no type"
    k = getKind(getNestedNameSpecifier(x))
    names_type = k == CXNestedNameSpecifierKind_TypeSpec ||
                 k == CXNestedNameSpecifierKind_TypeSpecWithTemplate
    @assert names_type "the qualifier must name a type (TypeSpec or TypeSpecWithTemplate)"
    return TypeLoc(clang_NestedNameSpecifierLoc_getTypeLoc(x))
end

dispose(x::AbstractNestedNameSpecifierLoc) = clang_NestedNameSpecifierLoc_dispose(x)
