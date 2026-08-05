# DeclarationName
DeclarationName() = DeclarationName(clang_DeclarationName_create())

function DeclarationName(x::IdentifierInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationName_createFromIdentifierInfo(x))
end

dump(x::DeclarationName) = clang_DeclarationName_dump(x)

isEmpty(x::DeclarationName) = clang_DeclarationName_isEmpty(x)

getAsString(x::DeclarationName) = get_string(clang_DeclarationName_getAsString(x))

# DeclarationNameInfo
function DeclarationNameInfo(name::DeclarationName, loc::SourceLocation)
    return DeclarationNameInfo(clang_DeclarationNameInfo_create(name, loc))
end

dispose(x::DeclarationNameInfo) = clang_DeclarationNameInfo_dispose(x)

function getName(x::DeclarationNameInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameInfo_getName(x))
end

function getLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getLoc(x))
end

function getBeginLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getBeginLoc(x))
end

function getEndLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getEndLoc(x))
end

function getAsString(x::DeclarationNameInfo)
    @check_ptrs x
    return get_string(clang_DeclarationNameInfo_getAsString(x))
end

# DeclarationName (identity surface)
#
# A `DeclarationName` is a value encoding, not a pointer to an object: the empty
# name encodes as NULL, so these wrappers deliberately do not `@check_ptrs` it.
getNameKind(x::DeclarationName) = clang_DeclarationName_getNameKind(x)

isIdentifier(x::DeclarationName) = clang_DeclarationName_isIdentifier(x)

isDependentName(x::DeclarationName) = clang_DeclarationName_isDependentName(x)

"""
    getAsIdentifierInfo(x::DeclarationName) -> IdentifierInfo
The identifier `x` stores, or a NULL-pointer `IdentifierInfo` when `x` is not a
plain identifier.
"""
function getAsIdentifierInfo(x::DeclarationName)
    return IdentifierInfo(clang_DeclarationName_getAsIdentifierInfo(x))
end

"""
    getCXXNameType(x::DeclarationName) -> QualType
The type a constructor, destructor or conversion-function name names; a null
`QualType` for every other kind of name.
"""
getCXXNameType(x::DeclarationName) = QualType(clang_DeclarationName_getCXXNameType(x))

function getCXXDeductionGuideTemplate(x::DeclarationName)
    return TemplateDecl(clang_DeclarationName_getCXXDeductionGuideTemplate(x))
end

"""
    getCXXOverloadedOperator(x::DeclarationName) -> CXOverloadedOperatorKind
`CXOverloadedOperatorKind_OO_None` unless `x` names an overloaded operator.
"""
function getCXXOverloadedOperator(x::DeclarationName)
    return clang_DeclarationName_getCXXOverloadedOperator(x)
end

function getCXXLiteralIdentifier(x::DeclarationName)
    return IdentifierInfo(clang_DeclarationName_getCXXLiteralIdentifier(x))
end

"""
    getUsingDirectiveName() -> DeclarationName
The single name shared by every C++ using-directive.
"""
getUsingDirectiveName() = DeclarationName(clang_DeclarationName_getUsingDirectiveName())

"""
    compare(x::DeclarationName, y::DeclarationName) -> Int
A total order over declaration names; lexicographic when both are identifiers.
"""
compare(x::DeclarationName, y::DeclarationName) = clang_DeclarationName_compare(x, y)

# DeclarationNameTable
"""
    getDeclarationNames(x::ASTContext) -> DeclarationNameTable
The uniquing table for C++ special declaration names owned by `x`. The names it
returns are the keys `lookup` expects, which is how a constructor, destructor,
conversion function or operator is found by name. The table is borrowed from the
context — there is nothing to dispose.
"""
function getDeclarationNames(x::ASTContext)
    @check_ptrs x
    return DeclarationNameTable(clang_DeclarationNameTable_getFromASTContext(x))
end

function getIdentifier(x::AbstractDeclarationNameTable, id::IdentifierInfo)
    @check_ptrs x id
    return DeclarationName(clang_DeclarationNameTable_getIdentifier(x, id))
end

"""
    getCXXConstructorName(x::AbstractDeclarationNameTable, ty::QualType) -> DeclarationName
The name of the constructors of `ty`. `ty` must be canonical
(`getCanonicalType`) — the C shim does not re-canonicalise it.
"""
function getCXXConstructorName(x::AbstractDeclarationNameTable, ty::QualType)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameTable_getCXXConstructorName(x, ty))
end

"""
    getCXXDestructorName(x::AbstractDeclarationNameTable, ty::QualType) -> DeclarationName
The name of the destructor of `ty`. `ty` must be canonical.
"""
function getCXXDestructorName(x::AbstractDeclarationNameTable, ty::QualType)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameTable_getCXXDestructorName(x, ty))
end

function getCXXDeductionGuideName(x::AbstractDeclarationNameTable, td::AbstractTemplateDecl)
    @check_ptrs x td
    return DeclarationName(clang_DeclarationNameTable_getCXXDeductionGuideName(x, td))
end

"""
    getCXXConversionFunctionName(x::AbstractDeclarationNameTable, ty::QualType) -> DeclarationName
The name of the conversion function to `ty`. `ty` must be canonical.
"""
function getCXXConversionFunctionName(x::AbstractDeclarationNameTable, ty::QualType)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameTable_getCXXConversionFunctionName(x, ty))
end

"""
    getCXXSpecialName(x::AbstractDeclarationNameTable, kind::CXDeclarationName_NameKind, ty::QualType) -> DeclarationName
`kind` must be one of `CXDeclarationName_CXXConstructorName`,
`CXDeclarationName_CXXDestructorName` or
`CXDeclarationName_CXXConversionFunctionName`; `ty` must be canonical.
"""
function getCXXSpecialName(x::AbstractDeclarationNameTable, kind::CXDeclarationName_NameKind, ty::QualType)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameTable_getCXXSpecialName(x, kind, ty))
end

function getCXXOperatorName(x::AbstractDeclarationNameTable, op::CXOverloadedOperatorKind)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameTable_getCXXOperatorName(x, op))
end

function getCXXLiteralOperatorName(x::AbstractDeclarationNameTable, id::IdentifierInfo)
    @check_ptrs x id
    return DeclarationName(clang_DeclarationNameTable_getCXXLiteralOperatorName(x, id))
end

# DeclarationNameInfo (mutation and location surface)
function setName(x::DeclarationNameInfo, name::DeclarationName)
    @check_ptrs x
    return clang_DeclarationNameInfo_setName(x, name)
end

function setLoc(x::DeclarationNameInfo, loc::SourceLocation)
    @check_ptrs x
    return clang_DeclarationNameInfo_setLoc(x, loc)
end

"""
    getNamedTypeInfo(x::DeclarationNameInfo) -> TypeSourceInfo
The written type of a constructor, destructor or conversion-function name; a
NULL-pointer `TypeSourceInfo` for every other kind of name.
"""
function getNamedTypeInfo(x::DeclarationNameInfo)
    @check_ptrs x
    return TypeSourceInfo(clang_DeclarationNameInfo_getNamedTypeInfo(x))
end

"""
    getCXXOperatorNameRange(x::DeclarationNameInfo) -> SourceRange
The range of the operator name without the `operator` keyword; an invalid range
unless the name is a (non-literal) overloaded operator.
"""
function getCXXOperatorNameRange(x::DeclarationNameInfo)
    @check_ptrs x
    r = clang_DeclarationNameInfo_getCXXOperatorNameRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getCXXLiteralOperatorNameLoc(x::DeclarationNameInfo) -> SourceLocation
The location of the literal-operator name without the `operator` keyword; an
invalid location unless the name is a literal-operator name.
"""
function getCXXLiteralOperatorNameLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getCXXLiteralOperatorNameLoc(x))
end

function isInstantiationDependent(x::DeclarationNameInfo)
    @check_ptrs x
    return clang_DeclarationNameInfo_isInstantiationDependent(x)
end

function containsUnexpandedParameterPack(x::DeclarationNameInfo)
    @check_ptrs x
    return clang_DeclarationNameInfo_containsUnexpandedParameterPack(x)
end

function getSourceRange(x::DeclarationNameInfo)
    @check_ptrs x
    r = clang_DeclarationNameInfo_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# DeclarationName (Objective-C selector shapes)
isObjCZeroArgSelector(x::DeclarationName) = clang_DeclarationName_isObjCZeroArgSelector(x)

isObjCOneArgSelector(x::DeclarationName) = clang_DeclarationName_isObjCOneArgSelector(x)

# DeclarationNameInfo (location-union mutators)
"""
    setNamedTypeInfo(x::DeclarationNameInfo, tinfo::TypeSourceInfo)
Set the written type of the constructor, destructor or conversion-function name `x` holds.

`x`'s current name must be one of those three kinds; clang asserts on any other.
"""
function setNamedTypeInfo(x::DeclarationNameInfo, tinfo::TypeSourceInfo)
    @check_ptrs x tinfo
    named = (CXDeclarationName_CXXConstructorName, CXDeclarationName_CXXDestructorName, CXDeclarationName_CXXConversionFunctionName)
    @assert getNameKind(getName(x)) in named "the name must be a constructor, destructor or conversion"
    return clang_DeclarationNameInfo_setNamedTypeInfo(x, tinfo)
end

"""
    setCXXOperatorNameRange(x::DeclarationNameInfo, r::SourceRange)
Set the range of the operator name `x` holds, without the `operator` keyword.

`x`'s current name must be a (non-literal) overloaded operator; clang asserts on any other.
"""
function setCXXOperatorNameRange(x::DeclarationNameInfo, r::SourceRange)
    @check_ptrs x
    @assert getNameKind(getName(x)) == CXDeclarationName_CXXOperatorName "the name must be an operator"
    rng = CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr)
    return clang_DeclarationNameInfo_setCXXOperatorNameRange(x, rng)
end

"""
    setCXXLiteralOperatorNameLoc(x::DeclarationNameInfo, loc::SourceLocation)
Set the location of the literal-operator name `x` holds, without the `operator` keyword.

`x`'s current name must be a literal-operator name; clang asserts on any other.
"""
function setCXXLiteralOperatorNameLoc(x::DeclarationNameInfo, loc::SourceLocation)
    @check_ptrs x
    k = getNameKind(getName(x))
    @assert k == CXDeclarationName_CXXLiteralOperatorName "the name must be a literal-operator name"
    return clang_DeclarationNameInfo_setCXXLiteralOperatorNameLoc(x, loc)
end
