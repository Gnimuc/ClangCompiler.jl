# TypeLoc — every TypeLoc handle is an owned heap box; `dispose` it after use.
function getTypeLoc(x::TypeSourceInfo)
    @check_ptrs x
    return TypeLoc(clang_TypeSourceInfo_getTypeLoc(x))
end

function getType(x::TypeLoc)
    @check_ptrs x
    return QualType(clang_TypeLoc_getType(x))
end

function getBeginLoc(x::TypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeLoc_getBeginLoc(x))
end

function getEndLoc(x::TypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeLoc_getEndLoc(x))
end

function getSourceRange(x::TypeLoc)
    @check_ptrs x
    r = clang_TypeLoc_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getLocalSourceRange(x::TypeLoc)
    @check_ptrs x
    r = clang_TypeLoc_getLocalSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# The next TypeLoc in the chain; an owned box (dispose it), null at the chain end.
function getNextTypeLoc(x::TypeLoc)
    @check_ptrs x
    return TypeLoc(clang_TypeLoc_getNextTypeLoc(x))
end

isNull(x::TypeLoc) = (@check_ptrs x; clang_TypeLoc_isNull(x))

dispose(x::TypeLoc) = clang_TypeLoc_dispose(x)
# The `clang::TypeLoc`-declared surface for the payload carriers: the
# `AbstractTypeLoc` methods mirror the `TypeLoc`-typed methods above, so every
# carrier reaches the base accessors, and `dispose` frees any member of the
# family.
function getType(x::AbstractTypeLoc)
    @check_ptrs x
    return QualType(clang_TypeLoc_getType(x))
end

function getBeginLoc(x::AbstractTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeLoc_getBeginLoc(x))
end

function getEndLoc(x::AbstractTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeLoc_getEndLoc(x))
end

function getSourceRange(x::AbstractTypeLoc)
    @check_ptrs x
    r = clang_TypeLoc_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getLocalSourceRange(x::AbstractTypeLoc)
    @check_ptrs x
    r = clang_TypeLoc_getLocalSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# The next TypeLoc in the chain; an owned box (dispose it), null at the chain end.
function getNextTypeLoc(x::AbstractTypeLoc)
    @check_ptrs x
    return TypeLoc(clang_TypeLoc_getNextTypeLoc(x))
end

isNull(x::AbstractTypeLoc) = (@check_ptrs x; clang_TypeLoc_isNull(x))

dispose(x::AbstractTypeLoc) = clang_TypeLoc_dispose(x)

"""
    getTypeLocClass(x::AnyTypeLoc) -> CXTypeLocClass
Return the classification of the pointed-to type location: `Qualified` when the
type carries local qualifiers, otherwise the value matching the Type class.
`x` must not be a null `TypeLoc`.
"""
function getTypeLocClass(x::AnyTypeLoc)
    @check_ptrs x
    @assert !isNull(x) "cannot classify a null TypeLoc"
    return clang_TypeLoc_getTypeLocClass(x)
end

"""
    getUnqualifiedLoc(x::AnyTypeLoc) -> TypeLoc
Skip past any local qualifiers. This function allocates and one should call
`dispose` to release the resources after using this object.
"""
function getUnqualifiedLoc(x::AnyTypeLoc)
    @check_ptrs x
    return TypeLoc(clang_TypeLoc_getUnqualifiedLoc(x))
end

"""
    IgnoreParens(x::AnyTypeLoc) -> TypeLoc
Skip past a paren location, if any. This function allocates and one should call
`dispose` to release the resources after using this object.
"""
function IgnoreParens(x::AnyTypeLoc)
    @check_ptrs x
    return TypeLoc(clang_TypeLoc_IgnoreParens(x))
end

# TypeLoc Cast — constructor-shaped checked downcasts. TypeLoc casting is
# value-based with exact-class semantics; the Qualified/TypeSpec/Function/Array
# targets accept their whole subfamily. The wrapped pointer is NULL when the
# location is not of that class; a non-NULL result is a NEW owned heap box,
# `dispose` it independently of its source.
for sym in [:QualifiedTypeLoc,
            :TypeSpecTypeLoc,
            :BuiltinTypeLoc,
            :AttributedTypeLoc,
            :ParenTypeLoc,
            :AdjustedTypeLoc,
            :PointerTypeLoc,
            :MemberPointerTypeLoc,
            :LValueReferenceTypeLoc,
            :RValueReferenceTypeLoc,
            :FunctionTypeLoc,
            :ArrayTypeLoc,
            :TemplateSpecializationTypeLoc,
            :ElaboratedTypeLoc]
    cast = Symbol("clang_TypeLoc_castTo", sym)
    @eval function $sym(x::AnyTypeLoc)
        @check_ptrs x
        @assert !isNull(x) "cannot cast a null TypeLoc"
        return $sym($cast(x))
    end
end

# QualifiedTypeLoc
"""
    getUnqualifiedLoc(x::AbstractQualifiedTypeLoc) -> TypeLoc
Strip the local qualifiers off a qualified type location. This function
allocates and one should call `dispose` to release the resources after using
this object.
"""
function getUnqualifiedLoc(x::AbstractQualifiedTypeLoc)
    @check_ptrs x
    return TypeLoc(clang_QualifiedTypeLoc_getUnqualifiedLoc(x))
end

# TypeSpecTypeLoc
function getNameLoc(x::AbstractTypeSpecTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeSpecTypeLoc_getNameLoc(x))
end

# BuiltinTypeLoc
function getBuiltinLoc(x::AbstractBuiltinTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_BuiltinTypeLoc_getBuiltinLoc(x))
end

# AttributedTypeLoc
"""
    getModifiedLoc(x::AbstractAttributedTypeLoc) -> TypeLoc
Return the location of the modified type behind the attribute. This function
allocates and one should call `dispose` to release the resources after using
this object.
"""
function getModifiedLoc(x::AbstractAttributedTypeLoc)
    @check_ptrs x
    return TypeLoc(clang_AttributedTypeLoc_getModifiedLoc(x))
end

function getAttr(x::AbstractAttributedTypeLoc)
    @check_ptrs x
    return Attr(clang_AttributedTypeLoc_getAttr(x))
end

# ParenTypeLoc
function getLParenLoc(x::AbstractParenTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_ParenTypeLoc_getLParenLoc(x))
end

function getRParenLoc(x::AbstractParenTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_ParenTypeLoc_getRParenLoc(x))
end

# AdjustedTypeLoc
"""
    getOriginalLoc(x::AbstractAdjustedTypeLoc) -> TypeLoc
Return the location of the type before the adjustment. This function allocates
and one should call `dispose` to release the resources after using this object.
"""
function getOriginalLoc(x::AbstractAdjustedTypeLoc)
    @check_ptrs x
    return TypeLoc(clang_AdjustedTypeLoc_getOriginalLoc(x))
end

# PointerTypeLoc
function getStarLoc(x::AbstractPointerTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_PointerTypeLoc_getStarLoc(x))
end

# MemberPointerTypeLoc
function getStarLoc(x::AbstractMemberPointerTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_MemberPointerTypeLoc_getStarLoc(x))
end

# LValueReferenceTypeLoc
function getAmpLoc(x::AbstractLValueReferenceTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_LValueReferenceTypeLoc_getAmpLoc(x))
end

# RValueReferenceTypeLoc
function getAmpAmpLoc(x::AbstractRValueReferenceTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_RValueReferenceTypeLoc_getAmpAmpLoc(x))
end

# FunctionTypeLoc
function getLocalRangeBegin(x::AbstractFunctionTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_FunctionTypeLoc_getLocalRangeBegin(x))
end

function getLocalRangeEnd(x::AbstractFunctionTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_FunctionTypeLoc_getLocalRangeEnd(x))
end

function getLParenLoc(x::AbstractFunctionTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_FunctionTypeLoc_getLParenLoc(x))
end

function getRParenLoc(x::AbstractFunctionTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_FunctionTypeLoc_getRParenLoc(x))
end

function getNumParams(x::AbstractFunctionTypeLoc)
    @check_ptrs x
    return clang_FunctionTypeLoc_getNumParams(x)
end

"""
    getParam(x::AbstractFunctionTypeLoc, i::Integer) -> ParmVarDecl
Return the `i`-th parameter declaration (`i` is 0-based, mirroring the C++
index).
"""
function getParam(x::AbstractFunctionTypeLoc, i::Integer)
    @check_ptrs x
    return ParmVarDecl(clang_FunctionTypeLoc_getParam(x, i))
end

# ArrayTypeLoc
function getLBracketLoc(x::AbstractArrayTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_ArrayTypeLoc_getLBracketLoc(x))
end

function getRBracketLoc(x::AbstractArrayTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_ArrayTypeLoc_getRBracketLoc(x))
end

"""
    getSizeExpr(x::AbstractArrayTypeLoc) -> Expr_

Return the size expression as written; the wrapped pointer is NULL when the
array has no written size (e.g. an incomplete array).
"""
function getSizeExpr(x::AbstractArrayTypeLoc)
    @check_ptrs x
    return Expr_(clang_ArrayTypeLoc_getSizeExpr(x))
end

# TemplateSpecializationTypeLoc
function getTemplateNameLoc(x::AbstractTemplateSpecializationTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TemplateSpecializationTypeLoc_getTemplateNameLoc(x))
end

function getLAngleLoc(x::AbstractTemplateSpecializationTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TemplateSpecializationTypeLoc_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractTemplateSpecializationTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TemplateSpecializationTypeLoc_getRAngleLoc(x))
end

function getNumArgs(x::AbstractTemplateSpecializationTypeLoc)
    @check_ptrs x
    return clang_TemplateSpecializationTypeLoc_getNumArgs(x)
end

# ElaboratedTypeLoc
function getElaboratedKeywordLoc(x::AbstractElaboratedTypeLoc)
    @check_ptrs x
    return SourceLocation(clang_ElaboratedTypeLoc_getElaboratedKeywordLoc(x))
end
