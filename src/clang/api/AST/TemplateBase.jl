# TemplateArgument
function TemplateArgument(x::QualType, is_null::Bool=false)
    return TemplateArgument(clang_TemplateArgument_constructFromQualType(x, is_null))
end

dispose(x::TemplateArgument) = clang_TemplateArgument_dispose(x)

function getKind(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_getKind(x)
end

function isNull(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isNull(x)
end

function isDependent(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isDependent(x)
end

function isInstantiationDependent(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isInstantiationDependent(x)
end

function getAsType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getAsType(x))
end

function getParamTypeForDecl(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getParamTypeForDecl(x))
end

function getNullPtrType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getNullPtrType(x))
end

function getAsTemplate(x::TemplateArgument)
    @check_ptrs x
    return TemplateName(clang_TemplateArgument_getAsTemplate(x))
end

function getAsTemplateOrTemplatePattern(x::TemplateArgument)
    @check_ptrs x
    return TemplateName(clang_TemplateArgument_getAsTemplateOrTemplatePattern(x))
end

"""
    getNumTemplateExpansions(x::TemplateArgument) -> Union{UInt32,Nothing}
Return the number of expansions of a `TemplateExpansion` argument, or `nothing`
when the argument carries no expansion count (the C++ optional is disengaged).
"""
function getNumTemplateExpansions(x::TemplateArgument)
    @check_ptrs x
    n = Ref{Cuint}(0)
    return clang_TemplateArgument_getNumTemplateExpansions(x, n) ? n[] : nothing
end

function getAsIntegral(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_getAsIntegral(x)
end

function getIntegralType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getIntegralType(x))
end

function setIntegralType(x::TemplateArgument, ty::QualType)
    @check_ptrs x
    return clang_TemplateArgument_setIntegralType(x, ty)
end

function getNonTypeTemplateArgumentType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getNonTypeTemplateArgumentType(x))
end
function dump(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_dump(x)
end

function getAsDecl(x::TemplateArgument)
    @check_ptrs x
    return ValueDecl(clang_TemplateArgument_getAsDecl(x))
end

function TemplateArgument(decl::ValueDecl, ty::QualType)
    @check_ptrs decl
    return TemplateArgument(clang_TemplateArgument_constructFromValueDecl(decl, ty))
end

function TemplateArgument(ctx::ASTContext, v::LLVM.GenericValue, ty::QualType)
    @check_ptrs ctx
    return TemplateArgument(clang_TemplateArgument_constructFromIntegral(ctx, v, ty))
end

function containsUnexpandedParameterPack(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_containsUnexpandedParameterPack(x)
end

function isPackExpansion(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isPackExpansion(x)
end

function setIsDefaulted(x::TemplateArgument, v::Bool)
    @check_ptrs x
    return clang_TemplateArgument_setIsDefaulted(x, v)
end

function getIsDefaulted(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_getIsDefaulted(x)
end

"""
    getAsExpr(x::TemplateArgument) -> Expr_
Return the expression an `Expression` argument stores. The C++ accessor asserts on
the kind and then reinterprets the payload, so the argument must be an `Expression`.
"""
function getAsExpr(x::TemplateArgument)
    @check_ptrs x
    @assert getKind(x) == CXTemplateArgument_Expression "template argument must be an expression"
    return Expr_(clang_TemplateArgument_getAsExpr(x))
end

"""
    pack_size(x::TemplateArgument) -> UInt32
Return the number of elements of a `Pack` argument. The C++ accessor asserts on the
kind, so the argument must be a pack.
"""
function pack_size(x::TemplateArgument)
    @check_ptrs x
    @assert getKind(x) == CXTemplateArgument_Pack "template argument must be a pack"
    return clang_TemplateArgument_pack_size(x)
end

"""
    getPackElement(x::TemplateArgument, i::Integer) -> TemplateArgument
Return a borrowed carrier for the `i`-th (0-based) element of a `Pack` argument. The
element lives in AST-owned pack storage: unlike the heap-boxed `TemplateArgument` the
constructors return, it must never be `dispose`d.
"""
function getPackElement(x::TemplateArgument, i::Integer)
    @check_ptrs x
    @assert getKind(x) == CXTemplateArgument_Pack "template argument must be a pack"
    @assert 0 <= i < pack_size(x) "pack element index out of range"
    return TemplateArgument(clang_TemplateArgument_getPackElement(x, i))
end

function structurallyEquals(x::TemplateArgument, other::TemplateArgument)
    @check_ptrs x other
    return clang_TemplateArgument_structurallyEquals(x, other)
end

"""
    print(x::TemplateArgument, ctx::ASTContext, include_type::Bool=false) -> String
Render the argument as source text using `ctx`'s default printing policy.
`include_type` spells the type of a non-type argument alongside its value.
"""
function print(x::TemplateArgument, ctx::ASTContext, include_type::Bool=false)
    @check_ptrs x ctx
    return get_string(clang_TemplateArgument_print(x, ctx, include_type))
end

# TemplateArgumentLoc
"""
    getArgument(x::TemplateArgumentLoc) -> TemplateArgument
Return a borrowed carrier for the wrapped template argument. It points into AST-owned
storage: unlike the heap-boxed `TemplateArgument` the constructors return, it must
never be `dispose`d.
"""
function getArgument(x::TemplateArgumentLoc)
    @check_ptrs x
    return TemplateArgument(clang_TemplateArgumentLoc_getArgument(x))
end

function getLocation(x::TemplateArgumentLoc)
    @check_ptrs x
    return SourceLocation(clang_TemplateArgumentLoc_getLocation(x))
end

function getSourceRange(x::TemplateArgumentLoc)
    @check_ptrs x
    r = clang_TemplateArgumentLoc_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getTypeSourceInfo(x::TemplateArgumentLoc) -> TypeSourceInfo
Return the type as written for a `Type` argument. The carrier holds NULL for every
other argument kind.
"""
function getTypeSourceInfo(x::TemplateArgumentLoc)
    @check_ptrs x
    return TypeSourceInfo(clang_TemplateArgumentLoc_getTypeSourceInfo(x))
end

"""
    getSourceExpression(x::TemplateArgumentLoc) -> Expr_
Return the expression written for an `Expression` argument. The C++ accessor asserts
on the kind, so the wrapped argument must be an `Expression`.
"""
function getSourceExpression(x::TemplateArgumentLoc)
    @check_ptrs x
    arg = getArgument(x)
    @assert getKind(arg) == CXTemplateArgument_Expression "template argument must be an expression"
    return Expr_(clang_TemplateArgumentLoc_getSourceExpression(x))
end

"""
    getTemplateNameLoc(x::TemplateArgumentLoc) -> SourceLocation
Return the location of the template name of a `Template` or `TemplateExpansion`
argument, and an invalid location for every other kind.
"""
function getTemplateNameLoc(x::TemplateArgumentLoc)
    @check_ptrs x
    return SourceLocation(clang_TemplateArgumentLoc_getTemplateNameLoc(x))
end

"""
    getTemplateEllipsisLoc(x::TemplateArgumentLoc) -> SourceLocation
Return the location of the `...` of a `TemplateExpansion` argument, and an invalid
location for every other kind.
"""
function getTemplateEllipsisLoc(x::TemplateArgumentLoc)
    @check_ptrs x
    return SourceLocation(clang_TemplateArgumentLoc_getTemplateEllipsisLoc(x))
end

# ASTTemplateArgumentListInfo
function getLAngleLoc(x::ASTTemplateArgumentListInfo)
    @check_ptrs x
    return SourceLocation(clang_ASTTemplateArgumentListInfo_getLAngleLoc(x))
end

function getRAngleLoc(x::ASTTemplateArgumentListInfo)
    @check_ptrs x
    return SourceLocation(clang_ASTTemplateArgumentListInfo_getRAngleLoc(x))
end

function getNumTemplateArgs(x::ASTTemplateArgumentListInfo)
    @check_ptrs x
    return clang_ASTTemplateArgumentListInfo_getNumTemplateArgs(x)
end

"""
    getTemplateArg(x::ASTTemplateArgumentListInfo, i::Integer) -> TemplateArgumentLoc
Return a borrowed carrier for the `i`-th (0-based) argument as written. The entry
lives in the list's AST-owned trailing array and is never disposed.
"""
function getTemplateArg(x::ASTTemplateArgumentListInfo, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArgs(x) "template argument index out of range"
    return TemplateArgumentLoc(clang_ASTTemplateArgumentListInfo_getTemplateArg(x, i))
end

"""
    getEmptyPack() -> TemplateArgument
Return a freshly heap-boxed empty pack argument. The result is owned: release it with
`dispose`.
"""
getEmptyPack() = TemplateArgument(clang_TemplateArgument_getEmptyPack())

"""
    CreatePackCopy(ctx::ASTContext, args::Vector{TemplateArgument}) -> TemplateArgument
Return a freshly heap-boxed pack argument whose elements are copied into `ctx`'s arena.
The box is owned: release it with `dispose`. The element boxes stay the caller's and are
left untouched.
"""
function CreatePackCopy(ctx::ASTContext, args::Vector{CXTemplateArgument})
    @check_ptrs ctx
    return TemplateArgument(clang_TemplateArgument_CreatePackCopy(ctx, args, length(args)))
end

function CreatePackCopy(ctx::ASTContext, args::Vector{TemplateArgument})
    return CreatePackCopy(ctx, CXTemplateArgument[arg.ptr for arg in args])
end

"""
    getAsStructuralValue(x::TemplateArgument) -> APValue
Return a borrowed carrier for the value of a `StructuralValue` argument. It lives in
AST-owned storage, so it must never be `dispose`d. The C++ accessor dereferences a union
member without checking the kind, so the argument must be a structural value.
"""
function getAsStructuralValue(x::TemplateArgument)
    @check_ptrs x
    @assert getKind(x) == CXTemplateArgument_StructuralValue "template argument must be a structural value"
    return APValue(clang_TemplateArgument_getAsStructuralValue(x))
end

"""
    getStructuralValueType(x::TemplateArgument) -> QualType
Return the type of a `StructuralValue` argument. Like `getAsStructuralValue`, this reads
a union member without checking the kind, so the argument must be a structural value.
"""
function getStructuralValueType(x::TemplateArgument)
    @check_ptrs x
    @assert getKind(x) == CXTemplateArgument_StructuralValue "template argument must be a structural value"
    return QualType(clang_TemplateArgument_getStructuralValueType(x))
end

"""
    getPackExpansionPattern(x::TemplateArgument) -> TemplateArgument
Return the pattern of a pack-expansion argument. The result is a freshly heap-boxed,
owned carrier — release it with `dispose`. `TemplateArgument::getPackExpansionPattern`
asserts `isPackExpansion()`.
"""
function getPackExpansionPattern(x::TemplateArgument)
    @check_ptrs x
    @assert isPackExpansion(x) "template argument must be a pack expansion"
    return TemplateArgument(clang_TemplateArgument_getPackExpansionPattern(x))
end

"""
    getSourceDeclExpression(x::TemplateArgumentLoc) -> Expr_
Return the expression written for a `Declaration` argument. The C++ accessor asserts on
the kind, so the wrapped argument must be a declaration.
"""
function getSourceDeclExpression(x::TemplateArgumentLoc)
    @check_ptrs x
    arg = getArgument(x)
    @assert getKind(arg) == CXTemplateArgument_Declaration "template argument must be a declaration"
    return Expr_(clang_TemplateArgumentLoc_getSourceDeclExpression(x))
end

"""
    getSourceNullPtrExpression(x::TemplateArgumentLoc) -> Expr_
Return the expression written for a `NullPtr` argument. The C++ accessor asserts on the
kind, so the wrapped argument must be a null pointer.
"""
function getSourceNullPtrExpression(x::TemplateArgumentLoc)
    @check_ptrs x
    arg = getArgument(x)
    @assert getKind(arg) == CXTemplateArgument_NullPtr "template argument must be a null pointer"
    return Expr_(clang_TemplateArgumentLoc_getSourceNullPtrExpression(x))
end

"""
    getSourceIntegralExpression(x::TemplateArgumentLoc) -> Expr_
Return the expression written for an `Integral` argument. The C++ accessor asserts on
the kind, so the wrapped argument must be an integral value.
"""
function getSourceIntegralExpression(x::TemplateArgumentLoc)
    @check_ptrs x
    arg = getArgument(x)
    @assert getKind(arg) == CXTemplateArgument_Integral "template argument must be an integral value"
    return Expr_(clang_TemplateArgumentLoc_getSourceIntegralExpression(x))
end

"""
    getSourceStructuralValueExpression(x::TemplateArgumentLoc) -> Expr_
Return the expression written for a `StructuralValue` argument. The C++ accessor asserts
on the kind, so the wrapped argument must be a structural value.
"""
function getSourceStructuralValueExpression(x::TemplateArgumentLoc)
    @check_ptrs x
    arg = getArgument(x)
    @assert getKind(arg) == CXTemplateArgument_StructuralValue "template argument must be a structural value"
    return Expr_(clang_TemplateArgumentLoc_getSourceStructuralValueExpression(x))
end

"""
    getTemplateQualifier(x::TemplateArgumentLoc) -> NestedNameSpecifier
Return the nested-name-specifier written in front of a `Template`/`TemplateExpansion`
argument's name. The accessor is total: it yields a NULL specifier (check `.ptr`) for every
other argument kind, and for a template name written without a qualifier.
"""
function getTemplateQualifier(x::TemplateArgumentLoc)
    @check_ptrs x
    return NestedNameSpecifier(clang_TemplateArgumentLoc_getTemplateQualifier(x))
end

# TemplateArgumentListInfo
"""
    TemplateArgumentListInfo(langle::SourceLocation, rangle::SourceLocation)
Build an empty template-argument list delimited by `langle`/`rangle`. This is clang's
AST-*unsafe* builder form — it must never be stored in an AST node; copy it into an
arena-allocated `ASTTemplateArgumentListInfo(ctx, list)` for that. This function allocates
and one should call `dispose` to release the resources after using this object.
"""
function TemplateArgumentListInfo(langle::SourceLocation, rangle::SourceLocation)
    return TemplateArgumentListInfo(clang_TemplateArgumentListInfo_create(langle, rangle))
end

dispose(x::TemplateArgumentListInfo) = clang_TemplateArgumentListInfo_dispose(x)

function getLAngleLoc(x::TemplateArgumentListInfo)
    @check_ptrs x
    return SourceLocation(clang_TemplateArgumentListInfo_getLAngleLoc(x))
end

function getRAngleLoc(x::TemplateArgumentListInfo)
    @check_ptrs x
    return SourceLocation(clang_TemplateArgumentListInfo_getRAngleLoc(x))
end

function setLAngleLoc(x::TemplateArgumentListInfo, loc::SourceLocation)
    @check_ptrs x
    return clang_TemplateArgumentListInfo_setLAngleLoc(x, loc)
end

function setRAngleLoc(x::TemplateArgumentListInfo, loc::SourceLocation)
    @check_ptrs x
    return clang_TemplateArgumentListInfo_setRAngleLoc(x, loc)
end

# Number of arguments added to the list so far.
function Base.size(x::TemplateArgumentListInfo)
    @check_ptrs x
    return Int(clang_TemplateArgumentListInfo_size(x))
end

"""
    getArgument(x::TemplateArgumentListInfo, i::Integer) -> TemplateArgumentLoc
Return a borrowed carrier for the `i`-th (0-based) argument. The entry is interior to the
list's own vector and is invalidated by any later `addArgument`; it is never disposed.
"""
function getArgument(x::TemplateArgumentListInfo, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "template argument index out of range"
    return TemplateArgumentLoc(clang_TemplateArgumentListInfo_getArgument(x, i))
end

"""
    addArgument(x::TemplateArgumentListInfo, loc::TemplateArgumentLoc)
Append a copy of `loc` to the list. `loc` keeps whatever ownership it already had, and every
carrier previously returned by `getArgument` is invalidated.
"""
function addArgument(x::TemplateArgumentListInfo, loc::TemplateArgumentLoc)
    @check_ptrs x loc
    return clang_TemplateArgumentListInfo_addArgument(x, loc)
end

"""
    ASTTemplateArgumentListInfo(ctx::ASTContext, info::TemplateArgumentListInfo)
Copy `info` into `ctx`'s arena as the form that may be stored in an AST node. The arena owns
the result, so it is never disposed.
"""
function ASTTemplateArgumentListInfo(ctx::ASTContext, info::TemplateArgumentListInfo)
    @check_ptrs ctx info
    return ASTTemplateArgumentListInfo(clang_ASTTemplateArgumentListInfo_Create(ctx, info))
end

"""
    getTemplateQualifierLoc(x::TemplateArgumentLoc) -> NestedNameSpecifierLoc
Return the qualifier written before a template-name argument, with its component locations.

The accessor is kind-gated inside clang: an argument of any other kind yields an *empty*
specifier, which answers `hasQualifier` false. This function allocates and one should call
`dispose` to release the resources after using this object.
"""
function getTemplateQualifierLoc(x::TemplateArgumentLoc)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_TemplateArgumentLoc_getTemplateQualifierLoc(x))
end

"""
    getDependence(x::AbstractTemplateArgument) -> Cuint
Return the argument's dependence bits as a `CXTemplateArgumentDependence` bitmask — the
combined form of [`isDependent`](@ref), [`isInstantiationDependent`](@ref) and
[`containsUnexpandedParameterPack`](@ref).

`x` must not be the null argument: clang's `Null` case is unreachable-by-contract rather than
returning an empty mask.
"""
function getDependence(x::AbstractTemplateArgument)
    @check_ptrs x
    @assert !isNull(x) "a null template argument has no dependence"
    return clang_TemplateArgument_getDependence(x)
end
