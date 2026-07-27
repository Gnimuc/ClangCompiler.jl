# TemplateName
isNull(x::TemplateName) = clang_TemplateName_isNull(x)

getKind(x::TemplateName) = clang_TemplateName_getKind(x)

getUnderlying(x::TemplateName) = TemplateName(clang_TemplateName_getUnderlying(x))

getNameToSubstitute(x::TemplateName) = TemplateName(clang_TemplateName_getNameToSubstitute(x))

isDependent(x::TemplateName) = clang_TemplateName_isDependent(x)

isInstantiationDependent(x::TemplateName) = clang_TemplateName_isInstantiationDependent(x)

containsUnexpandedParameterPack(x::TemplateName) = clang_TemplateName_containsUnexpandedParameterPack(x)

dump(x::TemplateName) = clang_TemplateName_dump(x)

function getTemplateName(x::TemplateSpecializationType)
    @check_ptrs x
    return TemplateName(clang_TemplateSpecializationType_getTemplateName(x))
end

"""
    getAsOverloadedTemplate(x::TemplateName) -> OverloadedTemplateStorage
Return the set of overloaded function templates `x` refers to. `TemplateName` stores its
arms in a tagged union and tests the tag itself, so the carrier holds `C_NULL` whenever `x`
is of another kind rather than being undefined.
"""
function getAsOverloadedTemplate(x::TemplateName)
    return OverloadedTemplateStorage(clang_TemplateName_getAsOverloadedTemplate(x))
end

"""
    getAsAssumedTemplateName(x::TemplateName) -> AssumedTemplateStorage
Return the storage of a name Sema assumed to be a template so that a call could go through
ADL, or a `C_NULL` carrier when `x` is of another kind.
"""
function getAsAssumedTemplateName(x::TemplateName)
    return AssumedTemplateStorage(clang_TemplateName_getAsAssumedTemplateName(x))
end

"""
    getAsSubstTemplateTemplateParm(x::TemplateName) -> SubstTemplateTemplateParmStorage
Return the storage of a substituted template template parameter, or a `C_NULL` carrier when
`x` is of another kind.
"""
function getAsSubstTemplateTemplateParm(x::TemplateName)
    return SubstTemplateTemplateParmStorage(clang_TemplateName_getAsSubstTemplateTemplateParm(x))
end

"""
    getAsSubstTemplateTemplateParmPack(x::TemplateName) -> SubstTemplateTemplateParmPackStorage
Return the storage of a substituted template template parameter pack, or a `C_NULL` carrier
when `x` is of another kind.
"""
function getAsSubstTemplateTemplateParmPack(x::TemplateName)
    p = clang_TemplateName_getAsSubstTemplateTemplateParmPack(x)
    return SubstTemplateTemplateParmPackStorage(p)
end

"""
    getAsQualifiedTemplateName(x::TemplateName) -> QualifiedTemplateName
Return the qualified-name storage behind `x` — the `N::` written in front of a template
name — or a `C_NULL` carrier when `x` is of another kind.
"""
function getAsQualifiedTemplateName(x::TemplateName)
    return QualifiedTemplateName(clang_TemplateName_getAsQualifiedTemplateName(x))
end

"""
    getAsDependentTemplateName(x::TemplateName) -> DependentTemplateName
Return the dependent-name storage behind `x`, or a `C_NULL` carrier when `x` is of another
kind.
"""
function getAsDependentTemplateName(x::TemplateName)
    return DependentTemplateName(clang_TemplateName_getAsDependentTemplateName(x))
end

"""
    getAsUsingShadowDecl(x::TemplateName) -> UsingShadowDecl
Return the using-shadow declaration that introduced the underlying template, or a `C_NULL`
carrier when `x` was not introduced by a using declaration.
"""
function getAsUsingShadowDecl(x::TemplateName)
    return UsingShadowDecl(clang_TemplateName_getAsUsingShadowDecl(x))
end

"""
    getDependence(x::TemplateName) -> UInt32
Return the whole `clang::TemplateNameDependence` bitmask of `x` in one call: bit 1
UnexpandedPack, 2 Instantiation, 4 Dependent, 8 Error. It is an LLVM bitmask enum whose
combined enumerators duplicate values, so it crosses as a plain integer rather than a
mirrored `@enum`; the single-bit answers are
[`containsUnexpandedParameterPack`](@ref), [`isInstantiationDependent`](@ref) and
[`isDependent`](@ref).
"""
getDependence(x::TemplateName) = clang_TemplateName_getDependence(x)

"""
    getAsString(x::TemplateName, ctx::ASTContext, qual=CXTemplateName_Qualified_AsWritten) -> String
Return the printed spelling of `x` under `ctx`'s own printing policy. `qual` picks the bare
name (`CXTemplateName_Qualified_None`), the qualifier as written
(`CXTemplateName_Qualified_AsWritten`) or the fully qualified name
(`CXTemplateName_Qualified_Fully`).
"""
function getAsString(x::TemplateName, ctx::ASTContext,
                     qual::CXTemplateName_Qualified=CXTemplateName_Qualified_AsWritten)
    @check_ptrs ctx
    return get_string(clang_TemplateName_getAsString(x, ctx, qual))
end

"""
    getAssociatedDecl(x::AbstractSubstTemplateTemplateParmStorage) -> Decl
Return the template-like entity that owns the whole pattern being substituted.
"""
function getAssociatedDecl(x::AbstractSubstTemplateTemplateParmStorage)
    @check_ptrs x
    return Decl(clang_SubstTemplateTemplateParmStorage_getAssociatedDecl(x))
end

"""
    getIndex(x::AbstractSubstTemplateTemplateParmStorage) -> UInt32
Return the index of the replaced parameter inside [`getAssociatedDecl`](@ref)'s parameter
list.
"""
function getIndex(x::AbstractSubstTemplateTemplateParmStorage)
    @check_ptrs x
    return clang_SubstTemplateTemplateParmStorage_getIndex(x)
end

"""
    getReplacement(x::AbstractSubstTemplateTemplateParmStorage) -> TemplateName
Return the template name that was substituted for the parameter.
"""
function getReplacement(x::AbstractSubstTemplateTemplateParmStorage)
    @check_ptrs x
    return TemplateName(clang_SubstTemplateTemplateParmStorage_getReplacement(x))
end

"""
    getQualifier(x::AbstractQualifiedTemplateName) -> NestedNameSpecifier
Return the nested-name-specifier that qualifies this template name.
"""
function getQualifier(x::AbstractQualifiedTemplateName)
    @check_ptrs x
    return NestedNameSpecifier(clang_QualifiedTemplateName_getQualifier(x))
end

"""
    hasTemplateKeyword(x::AbstractQualifiedTemplateName) -> Bool
Return whether the name was written with a redundant `template` keyword in front of it.
"""
function hasTemplateKeyword(x::AbstractQualifiedTemplateName)
    @check_ptrs x
    return clang_QualifiedTemplateName_hasTemplateKeyword(x)
end

"""
    getUnderlyingTemplate(x::AbstractQualifiedTemplateName) -> TemplateName
Return the unqualified template name underneath the qualifier. It is always either a plain
template or a using-introduced template.
"""
function getUnderlyingTemplate(x::AbstractQualifiedTemplateName)
    @check_ptrs x
    return TemplateName(clang_QualifiedTemplateName_getUnderlyingTemplate(x))
end

"""
    getQualifier(x::AbstractDependentTemplateName) -> NestedNameSpecifier
Return the nested-name-specifier that qualifies this dependent template name.
"""
function getQualifier(x::AbstractDependentTemplateName)
    @check_ptrs x
    return NestedNameSpecifier(clang_DependentTemplateName_getQualifier(x))
end

"""
    isIdentifier(x::AbstractDependentTemplateName) -> Bool
Return whether the name payload is an identifier rather than an overloaded operator. This
is the discriminator of the union [`getIdentifier`](@ref) and [`getOperator`](@ref) read.
"""
function isIdentifier(x::AbstractDependentTemplateName)
    @check_ptrs x
    return clang_DependentTemplateName_isIdentifier(x)
end

"""
    getIdentifier(x::AbstractDependentTemplateName) -> IdentifierInfo
Return the identifier this dependent template name refers to.

`x` must be an identifier name: `DependentTemplateName::getIdentifier` asserts
`isIdentifier()` and otherwise reads the overloaded-operator arm of the same union.
"""
function getIdentifier(x::AbstractDependentTemplateName)
    @check_ptrs x
    @assert isIdentifier(x) "dependent template name must refer to an identifier"
    return IdentifierInfo(clang_DependentTemplateName_getIdentifier(x))
end

"""
    isOverloadedOperator(x::AbstractDependentTemplateName) -> Bool
Return whether the name payload is an overloaded operator rather than an identifier.
"""
function isOverloadedOperator(x::AbstractDependentTemplateName)
    @check_ptrs x
    return clang_DependentTemplateName_isOverloadedOperator(x)
end

"""
    getOperator(x::AbstractDependentTemplateName) -> CXOverloadedOperatorKind
Return the overloaded operator this dependent template name refers to.

`x` must be an overloaded-operator name: `DependentTemplateName::getOperator` asserts
`isOverloadedOperator()` and otherwise reads the identifier arm of the same union.
"""
function getOperator(x::AbstractDependentTemplateName)
    @check_ptrs x
    @assert isOverloadedOperator(x) "dependent template name must refer to an overloaded operator"
    return clang_DependentTemplateName_getOperator(x)
end
