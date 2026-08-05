# TemplateParameterList
function getNumTemplateParameterLists(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_getNumTemplateParameterLists(x)
end

function getTemplateParameterList(x::AbstractTagDecl, i::Integer)
    @check_ptrs x
    return TemplateParameterList(clang_TagDecl_getTemplateParameterList(x, i))
end

function getParam(x::TemplateParameterList, i::Integer)
    @check_ptrs x
    return NamedDecl(clang_TemplateParameterList_getParam(x, i))
end

function Base.size(x::TemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_size(x)
end

function getDepth(x::TemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_getDepth(x)
end

function getMinRequiredArguments(x::TemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_getMinRequiredArguments(x)
end

function hasParameterPack(x::TemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_hasParameterPack(x)
end

# TemplateArgumentList
function TemplateArgumentList(ctx::ASTContext, args::Vector{CXTemplateArgument})
    @check_ptrs ctx
    list = clang_TemplateArgumentList_CreateCopy(ctx, args, length(args))
    return TemplateArgumentList(list)
end

function TemplateArgumentList(ctx::ASTContext, args::Vector{TemplateArgument})
    return TemplateArgumentList(ctx, CXTemplateArgument[Base.unsafe_convert(CXTemplateArgument, a) for a in args])
end

function Base.size(x::TemplateArgumentList)
    @check_ptrs x
    return clang_TemplateArgumentList_size(x)
end

"""
    data(x::TemplateArgumentList) -> TemplateArgument
Return a borrowed carrier of the list's first element. Julia cannot stride the
underlying value array (`sizeof(clang::TemplateArgument)` is unknown here); use
`get(x, i)` for indexed access.
"""
function data(x::TemplateArgumentList)
    @check_ptrs x
    return TemplateArgument(clang_TemplateArgumentList_data(x))
end

function Base.get(x::TemplateArgumentList, i::Integer)
    @check_ptrs x
    return TemplateArgument(clang_TemplateArgumentList_get(x, i))
end

# TemplateDecl

function getTemplateParameters(x::AbstractTemplateDecl)
    @check_ptrs x
    return TemplateParameterList(clang_TemplateDecl_getTemplateParameters(x))
end

function getTemplatedDecl(x::AbstractTemplateDecl)
    @check_ptrs x
    return NamedDecl(clang_TemplateDecl_getTemplatedDecl(x))
end

# function init(x::AbstractTemplateDecl, nd::NamedDecl, tp::TemplateParameterList)
#     @check_ptrs x nd tp
#     return clang_TemplateDecl_init(x, nd, tp)
# end

getAsTemplateDecl(x::TemplateName) = TemplateDecl(clang_TemplateName_getAsTemplateDecl(x))

# RedeclarableTemplateDecl
function getCanonicalDecl(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return RedeclarableTemplateDecl(clang_RedeclarableTemplateDecl_getCanonicalDecl(x))
end

function isMemberSpecialization(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return clang_RedeclarableTemplateDecl_isMemberSpecialization(x)
end

function setMemberSpecialization(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return clang_RedeclarableTemplateDecl_setMemberSpecialization(x)
end

function getTemplatedDecl(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_ClassTemplateDecl_getTemplatedDecl(x))
end

function isThisDeclarationADefinition(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return clang_ClassTemplateDecl_isThisDeclarationADefinition(x)
end

function findSpecialization(x::AbstractClassTemplateDecl, list::TemplateArgumentList, insert_pos=C_NULL)
    @check_ptrs x list
    ctsd = clang_ClassTemplateDecl_findSpecialization(x, list, insert_pos)
    return ClassTemplateSpecializationDecl(ctsd)
end

# ClassTemplateDecl
function getCanonicalDecl(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_ClassTemplateDecl_getCanonicalDecl(x))
end

function getMostRecentDecl(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_ClassTemplateDecl_getMostRecentDecl(x))
end

function getPreviousDecl(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_ClassTemplateDecl_getPreviousDecl(x))
end

# ClassTemplateSpecializationDecl
function ClassTemplateSpecializationDecl(ctx::ASTContext, tk::CXTagTypeKind, dc::AnyDeclContext, start_loc::SourceLocation, id_loc::SourceLocation, template::ClassTemplateDecl, args::TemplateArgumentList, prev_decl::ClassTemplateSpecializationDecl)
    @check_ptrs ctx dc template args
    ctsd = clang_ClassTemplateSpecializationDecl_Create(ctx, tk, dc, start_loc, id_loc, template, args, prev_decl)
    return ClassTemplateSpecializationDecl(ctsd)
end

function ClassTemplateSpecializationDecl(ctx::ASTContext, template::ClassTemplateDecl, args::TemplateArgumentList, prev_decl::ClassTemplateSpecializationDecl=ClassTemplateSpecializationDecl(C_NULL))
    tdecl = getTemplatedDecl(template)
    tk = getTagKind(tdecl)
    dc_ctx = getDeclContext(template)
    start_loc = getBeginLoc(tdecl)
    id_loc = getLocation(template)
    return ClassTemplateSpecializationDecl(ctx, tk, dc_ctx, start_loc, id_loc, template, args, prev_decl)
end

function AddSpecialization(x::AbstractClassTemplateDecl, ctsd::ClassTemplateSpecializationDecl, insert_pos=C_NULL)
    @check_ptrs x ctsd
    return clang_ClassTemplateDecl_AddSpecialization(x, ctsd, insert_pos)
end

function getTemplateArgs(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_ClassTemplateSpecializationDecl_getTemplateArgs(x))
end

function setTemplateArgs(x::AbstractClassTemplateSpecializationDecl, list::TemplateArgumentList)
    @check_ptrs x list
    return clang_ClassTemplateSpecializationDecl_setTemplateArgs(x, list)
end

function getSpecializationKind(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_getSpecializationKind(x)
end

function getSpecializedTemplate(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_ClassTemplateSpecializationDecl_getSpecializedTemplate(x))
end

function specializedOnPartial(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_specializedOnPartial(x)
end

"""
    getSpecializedTemplateOrPartial(x::AbstractClassTemplateSpecializationDecl)
Return the template this specialization was instantiated from, without
collapsing the `PointerUnion`: a `ClassTemplatePartialSpecializationDecl` when
`specializedOnPartial(x)` holds, a `ClassTemplateDecl` otherwise.
"""
function getSpecializedTemplateOrPartial(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    ptr = clang_ClassTemplateSpecializationDecl_getSpecializedTemplateOrPartial(x)
    return specializedOnPartial(x) ? unchecked_cast(ClassTemplatePartialSpecializationDecl, ptr) : unchecked_cast(ClassTemplateDecl, ptr)
end

# VarTemplateSpecializationDecl
function getTemplateArgs(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_VarTemplateSpecializationDecl_getTemplateArgs(x))
end

# NonTypeTemplateParmDecl
function getDepth(x::NonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_getDepth(x)
end

function getIndex(x::NonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_getIndex(x)
end

function isParameterPack(x::NonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_isParameterPack(x)
end

# TemplateTypeParmDecl
function getDepth(x::TemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_getDepth(x)
end

function getIndex(x::TemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_getIndex(x)
end

function isParameterPack(x::TemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_isParameterPack(x)
end

# TemplateParameterList
function getSourceRange(x::AbstractTemplateParameterList)
    @check_ptrs x
    r = clang_TemplateParameterList_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getRequiresClause(x::AbstractTemplateParameterList) -> Expr_
Return the constraint-expression of the list's associated requires-clause. The
carrier holds NULL when the parameter list has no requires-clause.
"""
function getRequiresClause(x::AbstractTemplateParameterList)
    @check_ptrs x
    return Expr_(clang_TemplateParameterList_getRequiresClause(x))
end

function hasAssociatedConstraints(x::AbstractTemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_hasAssociatedConstraints(x)
end

# TemplateTypeParmDecl
function wasDeclaredWithTypename(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_wasDeclaredWithTypename(x)
end

function hasDefaultArgument(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_hasDefaultArgument(x)
end

"""
    getDefaultArgument(x::AbstractTemplateTypeParmDecl) -> QualType
Return the parameter's default argument type. Only valid when
`hasDefaultArgument(x)` holds — Clang dereferences the stored `TypeSourceInfo`
unconditionally.
"""
function getDefaultArgument(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    @assert hasDefaultArgument(x) "template type parameter has no default argument"
    return QualType(clang_TemplateTypeParmDecl_getDefaultArgument(x))
end

function defaultArgumentWasInherited(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_defaultArgumentWasInherited(x)
end

function isExpandedParameterPack(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_isExpandedParameterPack(x)
end

"""
    getNumExpansionParameters(x::AbstractTemplateTypeParmDecl) -> Integer
Return the number of parameters in an expanded parameter pack. Only valid when
`isExpandedParameterPack(x)` holds.
"""
function getNumExpansionParameters(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    @assert isExpandedParameterPack(x) "not an expanded parameter pack"
    return clang_TemplateTypeParmDecl_getNumExpansionParameters(x)
end

function hasTypeConstraint(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_hasTypeConstraint(x)
end

# NonTypeTemplateParmDecl
function hasDefaultArgument(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_hasDefaultArgument(x)
end

"""
    getDefaultArgument(x::AbstractNonTypeTemplateParmDecl) -> Expr_
Return the parameter's default argument expression. The carrier holds NULL when
`hasDefaultArgument(x)` is false.
"""
function getDefaultArgument(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return Expr_(clang_NonTypeTemplateParmDecl_getDefaultArgument(x))
end

function isExpandedParameterPack(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_isExpandedParameterPack(x)
end

"""
    getNumExpansionTypes(x::AbstractNonTypeTemplateParmDecl) -> Integer
Return the number of expansion types in an expanded parameter pack. Only valid
when `isExpandedParameterPack(x)` holds.
"""
function getNumExpansionTypes(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    @assert isExpandedParameterPack(x) "not an expanded parameter pack"
    return clang_NonTypeTemplateParmDecl_getNumExpansionTypes(x)
end

"""
    getExpansionType(x::AbstractNonTypeTemplateParmDecl, i::Integer) -> QualType
Return the `i`-th (0-based) expansion type of an expanded parameter pack. Only
valid when `isExpandedParameterPack(x)` holds and `i < getNumExpansionTypes(x)`.
"""
function getExpansionType(x::AbstractNonTypeTemplateParmDecl, i::Integer)
    @check_ptrs x
    @assert isExpandedParameterPack(x) "not an expanded parameter pack"
    @assert 0 <= i < getNumExpansionTypes(x) "expansion type index out of range"
    return QualType(clang_NonTypeTemplateParmDecl_getExpansionType(x, i))
end

function hasPlaceholderTypeConstraint(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_hasPlaceholderTypeConstraint(x)
end

# TemplateTemplateParmDecl
function getDepth(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_getDepth(x)
end

function getIndex(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_getIndex(x)
end

function isParameterPack(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_isParameterPack(x)
end

function hasDefaultArgument(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_hasDefaultArgument(x)
end

# RedeclarableTemplateDecl
function getInstantiatedFromMemberTemplate(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return RedeclarableTemplateDecl(clang_RedeclarableTemplateDecl_getInstantiatedFromMemberTemplate(x))
end

# FunctionTemplateDecl
function getTemplatedDecl(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionTemplateDecl_getTemplatedDecl(x))
end

function isThisDeclarationADefinition(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return clang_FunctionTemplateDecl_isThisDeclarationADefinition(x)
end

function isAbbreviated(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return clang_FunctionTemplateDecl_isAbbreviated(x)
end

# TypeAliasTemplateDecl
function getTemplatedDecl(x::AbstractTypeAliasTemplateDecl)
    @check_ptrs x
    return TypeAliasDecl(clang_TypeAliasTemplateDecl_getTemplatedDecl(x))
end

# VarTemplateDecl
function getTemplatedDecl(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return VarDecl(clang_VarTemplateDecl_getTemplatedDecl(x))
end

function isThisDeclarationADefinition(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return clang_VarTemplateDecl_isThisDeclarationADefinition(x)
end

# ClassTemplatePartialSpecializationDecl
function getTemplateParameters(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    return TemplateParameterList(clang_ClassTemplatePartialSpecializationDecl_getTemplateParameters(x))
end

function hasAssociatedConstraints(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplatePartialSpecializationDecl_hasAssociatedConstraints(x)
end

function getInstantiatedFromMember(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    return ClassTemplatePartialSpecializationDecl(clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMember(x))
end

function isMemberSpecialization(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplatePartialSpecializationDecl_isMemberSpecialization(x)
end

# TemplateParameterList
function getTemplateLoc(x::AbstractTemplateParameterList)
    @check_ptrs x
    return SourceLocation(clang_TemplateParameterList_getTemplateLoc(x))
end

function getLAngleLoc(x::AbstractTemplateParameterList)
    @check_ptrs x
    return SourceLocation(clang_TemplateParameterList_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractTemplateParameterList)
    @check_ptrs x
    return SourceLocation(clang_TemplateParameterList_getRAngleLoc(x))
end

# ClassTemplateSpecializationDecl
function getMostRecentDecl(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return ClassTemplateSpecializationDecl(clang_ClassTemplateSpecializationDecl_getMostRecentDecl(x))
end

function getPointOfInstantiation(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return SourceLocation(clang_ClassTemplateSpecializationDecl_getPointOfInstantiation(x))
end

function isExplicitSpecialization(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_isExplicitSpecialization(x)
end

function isExplicitInstantiationOrSpecialization(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_isExplicitInstantiationOrSpecialization(x)
end

# VarTemplateSpecializationDecl
function getMostRecentDecl(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return VarTemplateSpecializationDecl(clang_VarTemplateSpecializationDecl_getMostRecentDecl(x))
end

function getSpecializedTemplate(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarTemplateSpecializationDecl_getSpecializedTemplate(x))
end

function getSpecializationKind(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_getSpecializationKind(x)
end

function isExplicitSpecialization(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_isExplicitSpecialization(x)
end

function isExplicitInstantiationOrSpecialization(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_isExplicitInstantiationOrSpecialization(x)
end

function getPointOfInstantiation(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return SourceLocation(clang_VarTemplateSpecializationDecl_getPointOfInstantiation(x))
end

function specializedOnPartial(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_specializedOnPartial(x)
end

"""
    getSpecializedTemplateOrPartial(x::AbstractVarTemplateSpecializationDecl)
Return the template this specialization was instantiated from, without
collapsing the `PointerUnion`: a `VarTemplatePartialSpecializationDecl` when
`specializedOnPartial(x)` holds, a `VarTemplateDecl` otherwise.
"""
function getSpecializedTemplateOrPartial(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    ptr = clang_VarTemplateSpecializationDecl_getSpecializedTemplateOrPartial(x)
    return specializedOnPartial(x) ? unchecked_cast(VarTemplatePartialSpecializationDecl, ptr) : unchecked_cast(VarTemplateDecl, ptr)
end

function getExternLoc(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return SourceLocation(clang_VarTemplateSpecializationDecl_getExternLoc(x))
end

function getTemplateKeywordLoc(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return SourceLocation(clang_VarTemplateSpecializationDecl_getTemplateKeywordLoc(x))
end

# ConceptDecl
"""
    getConstraintExpr(x::AbstractConceptDecl) -> Expr_
Return the concept's constraint-expression. The carrier holds NULL only in
error-recovery ASTs; a well-formed concept always has one.
"""
function getConstraintExpr(x::AbstractConceptDecl)
    @check_ptrs x
    return Expr_(clang_ConceptDecl_getConstraintExpr(x))
end

function isTypeConcept(x::AbstractConceptDecl)
    @check_ptrs x
    return clang_ConceptDecl_isTypeConcept(x)
end

function getCanonicalDecl(x::AbstractConceptDecl)
    @check_ptrs x
    return ConceptDecl(clang_ConceptDecl_getCanonicalDecl(x))
end

function getSourceRange(x::AbstractConceptDecl)
    @check_ptrs x
    r = clang_ConceptDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# TemplateDecl
function hasAssociatedConstraints(x::AbstractTemplateDecl)
    @check_ptrs x
    return clang_TemplateDecl_hasAssociatedConstraints(x)
end

function isTypeAlias(x::AbstractTemplateDecl)
    @check_ptrs x
    return clang_TemplateDecl_isTypeAlias(x)
end

# ClassTemplateSpecializationDecl
function isClassScopeExplicitSpecialization(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_isClassScopeExplicitSpecialization(x)
end

"""
    getTemplateInstantiationArgs(x::AbstractClassTemplateSpecializationDecl) -> TemplateArgumentList
Return a borrowed carrier of the deduced instantiation arguments. When this
specialization was instantiated from a partial specialization, these are the
partial specialization's deduced arguments; otherwise they equal
`getTemplateArgs(x)`.
"""
function getTemplateInstantiationArgs(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_ClassTemplateSpecializationDecl_getTemplateInstantiationArgs(x))
end

"""
    getTypeAsWritten(x::AbstractClassTemplateSpecializationDecl) -> TypeSourceInfo
Return the specialization type as written by the user. The carrier holds NULL
when the type was not so written (e.g. an implicit instantiation).
"""
function getTypeAsWritten(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_ClassTemplateSpecializationDecl_getTypeAsWritten(x))
end

function getExternLoc(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return SourceLocation(clang_ClassTemplateSpecializationDecl_getExternLoc(x))
end

function getTemplateKeywordLoc(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    return SourceLocation(clang_ClassTemplateSpecializationDecl_getTemplateKeywordLoc(x))
end

function getSourceRange(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    r = clang_ClassTemplateSpecializationDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# VarTemplateSpecializationDecl
function isClassScopeExplicitSpecialization(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_isClassScopeExplicitSpecialization(x)
end

"""
    getTemplateInstantiationArgs(x::AbstractVarTemplateSpecializationDecl) -> TemplateArgumentList
Return a borrowed carrier of the deduced instantiation arguments (see the
`ClassTemplateSpecializationDecl` overload for the partial-specialization case).
"""
function getTemplateInstantiationArgs(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_VarTemplateSpecializationDecl_getTemplateInstantiationArgs(x))
end

"""
    getTypeAsWritten(x::AbstractVarTemplateSpecializationDecl) -> TypeSourceInfo
Return the specialization type as written by the user. The carrier holds NULL
when the type was not so written.
"""
function getTypeAsWritten(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_VarTemplateSpecializationDecl_getTypeAsWritten(x))
end

function getSourceRange(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    r = clang_VarTemplateSpecializationDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# VarTemplatePartialSpecializationDecl
function getTemplateParameters(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    return TemplateParameterList(clang_VarTemplatePartialSpecializationDecl_getTemplateParameters(x))
end

function hasAssociatedConstraints(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplatePartialSpecializationDecl_hasAssociatedConstraints(x)
end

function getInstantiatedFromMember(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    p = clang_VarTemplatePartialSpecializationDecl_getInstantiatedFromMember(x)
    return VarTemplatePartialSpecializationDecl(p)
end

function isMemberSpecialization(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    return clang_VarTemplatePartialSpecializationDecl_isMemberSpecialization(x)
end

# MemberSpecializationInfo
"""
    getInstantiatedFrom(x::AbstractMemberSpecializationInfo) -> NamedDecl
Return the member declaration this member was instantiated from.
"""
function getInstantiatedFrom(x::AbstractMemberSpecializationInfo)
    @check_ptrs x
    return NamedDecl(clang_MemberSpecializationInfo_getInstantiatedFrom(x))
end

function getTemplateSpecializationKind(x::AbstractMemberSpecializationInfo)
    @check_ptrs x
    return clang_MemberSpecializationInfo_getTemplateSpecializationKind(x)
end

function isExplicitSpecialization(x::AbstractMemberSpecializationInfo)
    @check_ptrs x
    return clang_MemberSpecializationInfo_isExplicitSpecialization(x)
end

"""
    getPointOfInstantiation(x::AbstractMemberSpecializationInfo) -> SourceLocation
Return the first point of instantiation of this member. An invalid location
means the member has not been instantiated yet.
"""
function getPointOfInstantiation(x::AbstractMemberSpecializationInfo)
    @check_ptrs x
    return SourceLocation(clang_MemberSpecializationInfo_getPointOfInstantiation(x))
end

# FunctionTemplateSpecializationInfo
"""
    getFunction(x::AbstractFunctionTemplateSpecializationInfo) -> FunctionDecl
Return the function template specialization this information describes.
"""
function getFunction(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    return FunctionDecl(clang_FunctionTemplateSpecializationInfo_getFunction(x))
end

"""
    getTemplate(x::AbstractFunctionTemplateSpecializationInfo) -> FunctionTemplateDecl
Return the function template this specialization was generated from.
"""
function getTemplate(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionTemplateSpecializationInfo_getTemplate(x))
end

function getTemplateSpecializationKind(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    return clang_FunctionTemplateSpecializationInfo_getTemplateSpecializationKind(x)
end

function isExplicitSpecialization(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    return clang_FunctionTemplateSpecializationInfo_isExplicitSpecialization(x)
end

function isExplicitInstantiationOrSpecialization(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    return clang_FunctionTemplateSpecializationInfo_isExplicitInstantiationOrSpecialization(x)
end

"""
    getPointOfInstantiation(x::AbstractFunctionTemplateSpecializationInfo) -> SourceLocation
Return the first point of instantiation of this function template
specialization. An invalid location means it has not been instantiated yet.
"""
function getPointOfInstantiation(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    return SourceLocation(clang_FunctionTemplateSpecializationInfo_getPointOfInstantiation(x))
end

"""
    getMemberSpecializationInfo(x::AbstractFunctionTemplateSpecializationInfo) -> MemberSpecializationInfo
Return the member-specialization information carried when this function
template specialization is also a member specialization of a class-template
member. The carrier holds NULL otherwise.
"""
function getMemberSpecializationInfo(x::AbstractFunctionTemplateSpecializationInfo)
    @check_ptrs x
    p = clang_FunctionTemplateSpecializationInfo_getMemberSpecializationInfo(x)
    return MemberSpecializationInfo(p)
end

# TemplateTemplateParmDecl
function isPackExpansion(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_isPackExpansion(x)
end

function isExpandedParameterPack(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_isExpandedParameterPack(x)
end

"""
    getNumExpansionTemplateParameters(x::AbstractTemplateTemplateParmDecl) -> Integer
Return the number of expansion template parameter lists in an expanded
parameter pack. Only valid when `isExpandedParameterPack(x)` holds.
"""
function getNumExpansionTemplateParameters(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    @assert isExpandedParameterPack(x) "not an expanded parameter pack"
    return clang_TemplateTemplateParmDecl_getNumExpansionTemplateParameters(x)
end

"""
    getExpansionTemplateParameters(x::AbstractTemplateTemplateParmDecl, i::Integer) -> TemplateParameterList
Return the `i`-th (0-based) expansion template parameter list of an expanded
parameter pack. Only valid when `isExpandedParameterPack(x)` holds and
`i < getNumExpansionTemplateParameters(x)`.
"""
function getExpansionTemplateParameters(x::AbstractTemplateTemplateParmDecl, i::Integer)
    @check_ptrs x
    @assert isExpandedParameterPack(x) "not an expanded parameter pack"
    @assert 0 <= i < getNumExpansionTemplateParameters(x) "expansion parameter index out of range"
    return TemplateParameterList(clang_TemplateTemplateParmDecl_getExpansionTemplateParameters(x, i))
end

"""
    getDefaultArgumentLoc(x::AbstractTemplateTemplateParmDecl) -> SourceLocation
Return the location of the default template argument. The location is invalid
when the parameter has no default argument.
"""
function getDefaultArgumentLoc(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return SourceLocation(clang_TemplateTemplateParmDecl_getDefaultArgumentLoc(x))
end

function defaultArgumentWasInherited(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_defaultArgumentWasInherited(x)
end

# NonTypeTemplateParmDecl
function defaultArgumentWasInherited(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_defaultArgumentWasInherited(x)
end

function isPackExpansion(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_isPackExpansion(x)
end

"""
    getPlaceholderTypeConstraint(x::AbstractNonTypeTemplateParmDecl) -> Expr_
Return the constraint introduced by the parameter's placeholder type. The
carrier holds NULL when the parameter's type has no constrained placeholder.
"""
function getPlaceholderTypeConstraint(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return Expr_(clang_NonTypeTemplateParmDecl_getPlaceholderTypeConstraint(x))
end

# FunctionTemplateDecl
function getCanonicalDecl(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionTemplateDecl_getCanonicalDecl(x))
end

"""
    getPreviousDecl(x::AbstractFunctionTemplateDecl) -> FunctionTemplateDecl
Return the previous declaration of this function template. The carrier holds
NULL when this is the first declaration.
"""
function getPreviousDecl(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionTemplateDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionTemplateDecl_getMostRecentDecl(x))
end

# ClassTemplatePartialSpecializationDecl
function getMostRecentDecl(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    p = clang_ClassTemplatePartialSpecializationDecl_getMostRecentDecl(x)
    return ClassTemplatePartialSpecializationDecl(p)
end

"""
    getTemplateArgsAsWritten(x::AbstractClassTemplatePartialSpecializationDecl) -> ASTTemplateArgumentListInfo
Return the template argument list as written in the partial specialization. The
carrier holds NULL when no as-written argument list was recorded.
"""
function getTemplateArgsAsWritten(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    p = clang_ClassTemplatePartialSpecializationDecl_getTemplateArgsAsWritten(x)
    return ASTTemplateArgumentListInfo(p)
end

"""
    getInjectedSpecializationType(x::AbstractClassTemplatePartialSpecializationDecl) -> QualType
Return the injected specialization type of the partial specialization — the type
`X<partial-args>`, not the declaration's own `InjectedClassNameType`. Only valid
when the declaration's type-decl-type is set and is an `InjectedClassNameType`:
the C++ body asserts the former and reaches the latter through an unchecked cast.
"""
function getInjectedSpecializationType(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    ty = getTypeForDecl(x)
    @assert !is_null_handle(ty) "the partial specialization has no type set"
    @assert is_injected_class_name_type(ty) "type-decl-type must be an InjectedClassNameType"
    return QualType(clang_ClassTemplatePartialSpecializationDecl_getInjectedSpecializationType(x))
end

# ClassTemplateDecl
function getNumPartialSpecializations(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return Int(clang_ClassTemplateDecl_getNumPartialSpecializations(x))
end

"""
    getPartialSpecializations(x::AbstractClassTemplateDecl) -> Vector{ClassTemplatePartialSpecializationDecl}
Return the class template's partial specializations as an ordered list. The
count is exact and no slot is NULL.
"""
function getPartialSpecializations(x::AbstractClassTemplateDecl)
    @check_ptrs x
    n = clang_ClassTemplateDecl_getNumPartialSpecializations(x)
    buf = Vector{CXClassTemplatePartialSpecializationDecl}(undef, n)
    n > 0 && clang_ClassTemplateDecl_getPartialSpecializations(x, buf)
    return [ClassTemplatePartialSpecializationDecl(p) for p in buf]
end

"""
    findPartialSpecialization(x::AbstractClassTemplateDecl, ty::QualType) -> ClassTemplatePartialSpecializationDecl
Return the partial specialization whose injected specialization type is exactly
`ty`. The carrier holds NULL when no partial specialization matches.
"""
function findPartialSpecialization(x::AbstractClassTemplateDecl, ty::QualType)
    @check_ptrs x
    return ClassTemplatePartialSpecializationDecl(clang_ClassTemplateDecl_findPartialSpecialization(x, ty))
end

"""
    getInjectedClassNameSpecialization(x::AbstractClassTemplateDecl) -> QualType
Return the template specialization type of the injected-class-name of this class
template — `X<template-args>` formed from the template's own parameters.
"""
function getInjectedClassNameSpecialization(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return QualType(clang_ClassTemplateDecl_getInjectedClassNameSpecialization(x))
end

# TypeAliasTemplateDecl
function getCanonicalDecl(x::AbstractTypeAliasTemplateDecl)
    @check_ptrs x
    return TypeAliasTemplateDecl(clang_TypeAliasTemplateDecl_getCanonicalDecl(x))
end

"""
    getPreviousDecl(x::AbstractTypeAliasTemplateDecl) -> TypeAliasTemplateDecl
Return the previous declaration of this alias template. The carrier holds NULL
when this is the first declaration.
"""
function getPreviousDecl(x::AbstractTypeAliasTemplateDecl)
    @check_ptrs x
    return TypeAliasTemplateDecl(clang_TypeAliasTemplateDecl_getPreviousDecl(x))
end

# VarTemplateSpecializationDecl
"""
    getTemplateArgsInfo(x::AbstractVarTemplateSpecializationDecl) -> ASTTemplateArgumentListInfo
Return the template argument list as written for this variable template
specialization. The carrier holds NULL when no as-written argument list was
recorded.
"""
function getTemplateArgsInfo(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    return ASTTemplateArgumentListInfo(clang_VarTemplateSpecializationDecl_getTemplateArgsInfo(x))
end

# VarTemplatePartialSpecializationDecl
"""
    getTemplateArgsAsWritten(x::AbstractVarTemplatePartialSpecializationDecl) -> ASTTemplateArgumentListInfo
Return the template argument list as written in the partial specialization. The
carrier holds NULL when no as-written argument list was recorded.
"""
function getTemplateArgsAsWritten(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    p = clang_VarTemplatePartialSpecializationDecl_getTemplateArgsAsWritten(x)
    return ASTTemplateArgumentListInfo(p)
end

# VarTemplateDecl
"""
    getDefinition(x::AbstractVarTemplateDecl) -> VarTemplateDecl
Return the declaration in the redeclaration chain that defines the variable
template. The carrier holds NULL when no declaration is a definition.
"""
function getDefinition(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarTemplateDecl_getDefinition(x))
end

function getCanonicalDecl(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarTemplateDecl_getCanonicalDecl(x))
end

"""
    getPreviousDecl(x::AbstractVarTemplateDecl) -> VarTemplateDecl
Return the previous declaration of this variable template. The carrier holds
NULL when this is the first declaration.
"""
function getPreviousDecl(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarTemplateDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarTemplateDecl_getMostRecentDecl(x))
end

function getNumPartialSpecializations(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return Int(clang_VarTemplateDecl_getNumPartialSpecializations(x))
end

"""
    getPartialSpecializations(x::AbstractVarTemplateDecl) -> Vector{VarTemplatePartialSpecializationDecl}
Return the variable template's partial specializations as an ordered list. The
count is exact and no slot is NULL.
"""
function getPartialSpecializations(x::AbstractVarTemplateDecl)
    @check_ptrs x
    n = clang_VarTemplateDecl_getNumPartialSpecializations(x)
    buf = Vector{CXVarTemplatePartialSpecializationDecl}(undef, n)
    n > 0 && clang_VarTemplateDecl_getPartialSpecializations(x, buf)
    return [VarTemplatePartialSpecializationDecl(p) for p in buf]
end

# TemplateParameterList
function containsUnexpandedParameterPack(x::AbstractTemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_containsUnexpandedParameterPack(x)
end

"""
    getAssociatedConstraints(x::AbstractTemplateParameterList) -> Vector{Expr_}
Return every constraint expression associated with the parameter list -- its
requires-clause plus the constraints implied by its constrained parameters -- in
declaration order. Empty for an unconstrained parameter list. The expressions are
AST-owned; the constraints are to be read as a conjunction.
"""
function getAssociatedConstraints(x::AbstractTemplateParameterList)
    @check_ptrs x
    n = clang_TemplateParameterList_getNumAssociatedConstraints(x)
    buf = Vector{CXExpr}(undef, n)
    n > 0 && clang_TemplateParameterList_getAssociatedConstraints(x, buf)
    return [Expr_(p) for p in buf]
end

# TemplateDecl
"""
    getAssociatedConstraints(x::AbstractTemplateDecl) -> Vector{Expr_}
Return the total constraint-expression set of the template: the constraints of
its template parameter list plus any trailing requires-clause on the templated
declaration, in declaration order. Empty for an unconstrained template.
"""
function getAssociatedConstraints(x::AbstractTemplateDecl)
    @check_ptrs x
    n = clang_TemplateDecl_getNumAssociatedConstraints(x)
    buf = Vector{CXExpr}(undef, n)
    n > 0 && clang_TemplateDecl_getAssociatedConstraints(x, buf)
    return [Expr_(p) for p in buf]
end

# RedeclarableTemplateDecl
"""
    getInjectedTemplateArgs(x::AbstractRedeclarableTemplateDecl) -> Vector{TemplateArgument}
Return the "injected" template arguments that correspond one-for-one to this
template's own parameters -- the arguments used when substituting inside the
template's definition. The carriers borrow the array Clang caches on the
template's shared common state, so they must never be `dispose`d (unlike the
heap-boxed `TemplateArgument`s returned by the constructors).
"""
function getInjectedTemplateArgs(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    n = clang_RedeclarableTemplateDecl_getNumInjectedTemplateArgs(x)
    return [TemplateArgument(clang_RedeclarableTemplateDecl_getInjectedTemplateArg(x, i)) for i = 0:(n - 1)]
end

# TemplateTypeParmDecl
function isPackExpansion(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_isPackExpansion(x)
end

"""
    getDefaultArgumentLoc(x::AbstractTemplateTypeParmDecl) -> SourceLocation
Return the start of the default argument as written. An invalid location when the
parameter has no default argument.
"""
function getDefaultArgumentLoc(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return SourceLocation(clang_TemplateTypeParmDecl_getDefaultArgumentLoc(x))
end

# NonTypeTemplateParmDecl
"""
    getDefaultArgumentLoc(x::AbstractNonTypeTemplateParmDecl) -> SourceLocation
Return the start of the default argument expression as written. An invalid
location when the parameter has no default argument.
"""
function getDefaultArgumentLoc(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return SourceLocation(clang_NonTypeTemplateParmDecl_getDefaultArgumentLoc(x))
end

# TemplateTemplateParmDecl
"""
    getDefaultArgument(x::AbstractTemplateTemplateParmDecl) -> TemplateArgumentLoc
Return the default template argument as written. When `hasDefaultArgument(x)` is
false the carrier points at a shared empty `TemplateArgumentLoc` rather than NULL,
so check `hasDefaultArgument` before reading it. The storage is borrowed -- never
`dispose` it.
"""
function getDefaultArgument(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return TemplateArgumentLoc(clang_TemplateTemplateParmDecl_getDefaultArgument(x))
end

# BuiltinTemplateDecl
"""
    getBuiltinTemplateKind(x::AbstractBuiltinTemplateDecl) -> CXBuiltinTemplateKind
Return which compiler builtin template this declaration is
(`__make_integer_seq` or `__type_pack_element`).
"""
function getBuiltinTemplateKind(x::AbstractBuiltinTemplateDecl)
    @check_ptrs x
    return clang_BuiltinTemplateDecl_getBuiltinTemplateKind(x)
end

# TemplateParamObjectDecl
"""
    getValue(x::AbstractTemplateParamObjectDecl) -> APValue
Return the compile-time value this template parameter object holds. The carrier
borrows storage owned by the declaration -- never `dispose` it.
"""
function getValue(x::AbstractTemplateParamObjectDecl)
    @check_ptrs x
    return APValue(clang_TemplateParamObjectDecl_getValue(x))
end

"""
    printAsExpr(x::AbstractTemplateParamObjectDecl) -> String
Render the parameter object as an equivalent expression, using the ASTContext's
default printing policy.
"""
function printAsExpr(x::AbstractTemplateParamObjectDecl)
    @check_ptrs x
    return get_string(clang_TemplateParamObjectDecl_printAsExpr(x))
end

"""
    printAsInit(x::AbstractTemplateParamObjectDecl) -> String
Render the parameter object as an initializer suitable for a variable of the
object's type, using the ASTContext's default printing policy.
"""
function printAsInit(x::AbstractTemplateParamObjectDecl)
    @check_ptrs x
    return get_string(clang_TemplateParamObjectDecl_printAsInit(x))
end

function getCanonicalDecl(x::AbstractTemplateParamObjectDecl)
    @check_ptrs x
    return TemplateParamObjectDecl(clang_TemplateParamObjectDecl_getCanonicalDecl(x))
end

# ClassTemplateDecl
"""
    getInstantiatedFromMemberTemplate(x::AbstractClassTemplateDecl) -> ClassTemplateDecl
Return the member class template this one was instantiated from. The carrier
holds NULL when this template is not an instantiated member template.
"""
function getInstantiatedFromMemberTemplate(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_ClassTemplateDecl_getInstantiatedFromMemberTemplate(x))
end

# ClassTemplatePartialSpecializationDecl
"""
    getInstantiatedFromMemberTemplate(x::AbstractClassTemplatePartialSpecializationDecl)
        -> ClassTemplatePartialSpecializationDecl
Return the member partial specialization this one was instantiated from. The
carrier holds NULL when this partial specialization is not an instantiated
member.
"""
function getInstantiatedFromMemberTemplate(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    p = clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMemberTemplate(x)
    return ClassTemplatePartialSpecializationDecl(p)
end

# FunctionTemplateDecl
"""
    getInstantiatedFromMemberTemplate(x::AbstractFunctionTemplateDecl) -> FunctionTemplateDecl
Return the member function template this one was instantiated from. The carrier
holds NULL when this template is not an instantiated member template.
"""
function getInstantiatedFromMemberTemplate(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    p = clang_FunctionTemplateDecl_getInstantiatedFromMemberTemplate(x)
    return FunctionTemplateDecl(p)
end

# TypeAliasTemplateDecl
"""
    getInstantiatedFromMemberTemplate(x::AbstractTypeAliasTemplateDecl) -> TypeAliasTemplateDecl
Return the member alias template this one was instantiated from. The carrier
holds NULL when this template is not an instantiated member template.
"""
function getInstantiatedFromMemberTemplate(x::AbstractTypeAliasTemplateDecl)
    @check_ptrs x
    p = clang_TypeAliasTemplateDecl_getInstantiatedFromMemberTemplate(x)
    return TypeAliasTemplateDecl(p)
end

# VarTemplateDecl
"""
    getInstantiatedFromMemberTemplate(x::AbstractVarTemplateDecl) -> VarTemplateDecl
Return the member variable template this one was instantiated from. The carrier
holds NULL when this template is not an instantiated member template.
"""
function getInstantiatedFromMemberTemplate(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarTemplateDecl_getInstantiatedFromMemberTemplate(x))
end

# VarTemplatePartialSpecializationDecl
function getMostRecentDecl(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    p = clang_VarTemplatePartialSpecializationDecl_getMostRecentDecl(x)
    return VarTemplatePartialSpecializationDecl(p)
end

# TemplateParameterList
"""
    print(x::AbstractTemplateParameterList, ctx::ASTContext, omit_template_kw::Bool=false) -> String
Render the parameter list as source text — `template <typename T, int N = 3>` —
using `ctx`'s default printing policy. `omit_template_kw` drops the leading
`template` keyword and keeps the angle-bracketed parameters.
"""
function print(x::AbstractTemplateParameterList, ctx::ASTContext, omit_template_kw::Bool=false)
    @check_ptrs x ctx
    return get_string(clang_TemplateParameterList_print(x, ctx, omit_template_kw))
end

# FunctionTemplateDecl
"""
    LoadLazySpecializations(x::AbstractFunctionTemplateDecl)
Pull in any specializations an external AST source (a PCH or module file) is
still holding lazily. A no-op when the translation unit has no external source.
"""
function LoadLazySpecializations(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return clang_FunctionTemplateDecl_LoadLazySpecializations(x)
end

function getNumSpecializations(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    return Int(clang_FunctionTemplateDecl_getNumSpecializations(x))
end

"""
    getSpecializations(x::AbstractFunctionTemplateDecl) -> Vector{FunctionDecl}
Return the function template's specializations as an ordered list. The count is
exact, no slot is NULL, and each entry is the most recent redeclaration of that
specialization.
"""
function getSpecializations(x::AbstractFunctionTemplateDecl)
    @check_ptrs x
    n = clang_FunctionTemplateDecl_getNumSpecializations(x)
    buf = Vector{CXFunctionDecl}(undef, n)
    n > 0 && clang_FunctionTemplateDecl_getSpecializations(x, buf)
    return [FunctionDecl(p) for p in buf]
end

# TemplateTypeParmDecl
"""
    getDefaultArgumentInfo(x::AbstractTemplateTypeParmDecl) -> TypeSourceInfo
Return the as-written source information of the parameter's default argument.
The carrier holds NULL when the parameter has no default argument — unlike
`getDefaultArgument`, this accessor never dereferences the stored pointer.
"""
function getDefaultArgumentInfo(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_TemplateTypeParmDecl_getDefaultArgumentInfo(x))
end

"""
    setDeclaredWithTypename(x::AbstractTemplateTypeParmDecl, with_typename::Bool)
Record whether the parameter was spelled with `typename` rather than `class`.
`wasDeclaredWithTypename` additionally requires the parameter to carry no type
constraint, so on a constrained parameter it keeps reading back `false`.
"""
function setDeclaredWithTypename(x::AbstractTemplateTypeParmDecl, with_typename::Bool)
    @check_ptrs x
    clang_TemplateTypeParmDecl_setDeclaredWithTypename(x, with_typename)
    return nothing
end

# NonTypeTemplateParmDecl
"""
    getPosition(x::AbstractNonTypeTemplateParmDecl) -> Integer
Return the parameter's position within its template parameter list. This is the
same stored field `getIndex` reports — `TemplateParmPosition::Position`.
"""
function getPosition(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_getPosition(x)
end

"""
    getExpansionTypeSourceInfo(x::AbstractNonTypeTemplateParmDecl, i::Integer) -> TypeSourceInfo
Return the as-written type of the `i`-th expansion of an expanded parameter pack.
Upstream indexes a trailing-object array only expanded packs carry and asserts
the index is in range; both preconditions are restated here.
"""
function getExpansionTypeSourceInfo(x::AbstractNonTypeTemplateParmDecl, i::Integer)
    @check_ptrs x
    @assert isExpandedParameterPack(x) "not an expanded parameter pack"
    @assert 0 <= i < getNumExpansionTypes(x) "expansion type index out of range"
    return TypeSourceInfo(clang_NonTypeTemplateParmDecl_getExpansionTypeSourceInfo(x, i))
end

# TemplateTemplateParmDecl
"""
    getPosition(x::AbstractTemplateTemplateParmDecl) -> Integer
Return the parameter's position within its template parameter list. This is the
same stored field `getIndex` reports — `TemplateParmPosition::Position`.
"""
function getPosition(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_getPosition(x)
end

# ClassTemplateDecl
"""
    LoadLazySpecializations(x::AbstractClassTemplateDecl)
Pull in any specializations an external AST source (a PCH or module file) is
still holding lazily. A no-op when the translation unit has no external source.
"""
function LoadLazySpecializations(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return clang_ClassTemplateDecl_LoadLazySpecializations(x)
end

function getNumSpecializations(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return Int(clang_ClassTemplateDecl_getNumSpecializations(x))
end

"""
    getSpecializations(x::AbstractClassTemplateDecl) -> Vector{ClassTemplateSpecializationDecl}
Return the class template's specializations as an ordered list. The count is
exact, no slot is NULL, and each entry is the most recent redeclaration of that
specialization.
"""
function getSpecializations(x::AbstractClassTemplateDecl)
    @check_ptrs x
    n = clang_ClassTemplateDecl_getNumSpecializations(x)
    buf = Vector{CXClassTemplateSpecializationDecl}(undef, n)
    n > 0 && clang_ClassTemplateDecl_getSpecializations(x, buf)
    return [ClassTemplateSpecializationDecl(p) for p in buf]
end

# VarTemplateDecl
"""
    LoadLazySpecializations(x::AbstractVarTemplateDecl)
Pull in any specializations an external AST source (a PCH or module file) is
still holding lazily. A no-op when the translation unit has no external source.
"""
function LoadLazySpecializations(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return clang_VarTemplateDecl_LoadLazySpecializations(x)
end

function getNumSpecializations(x::AbstractVarTemplateDecl)
    @check_ptrs x
    return Int(clang_VarTemplateDecl_getNumSpecializations(x))
end

"""
    getSpecializations(x::AbstractVarTemplateDecl) -> Vector{VarTemplateSpecializationDecl}
Return the variable template's specializations as an ordered list. The count is
exact, no slot is NULL, and each entry is the most recent redeclaration of that
specialization.
"""
function getSpecializations(x::AbstractVarTemplateDecl)
    @check_ptrs x
    n = clang_VarTemplateDecl_getNumSpecializations(x)
    buf = Vector{CXVarTemplateSpecializationDecl}(undef, n)
    n > 0 && clang_VarTemplateDecl_getSpecializations(x, buf)
    return [VarTemplateSpecializationDecl(p) for p in buf]
end

# TemplateDecl
"""
    setTemplateParameters(x::AbstractTemplateDecl, tpl::AbstractTemplateParameterList)
Re-seat the template's parameter list. The list is borrowed — Clang stores the
pointer as-is and neither copies nor frees it, so `tpl` must outlive `x`.
"""
function setTemplateParameters(x::AbstractTemplateDecl, tpl::AbstractTemplateParameterList)
    @check_ptrs x tpl
    return clang_TemplateDecl_setTemplateParameters(x, tpl)
end

# FunctionTemplateSpecializationInfo
"""
    setTemplateSpecializationKind(x::AbstractFunctionTemplateSpecializationInfo, tsk::CXTemplateSpecializationKind)
Record how this function template specialization came about. `TSK_Undeclared` is
rejected: the info object encodes `tsk - 1` in a two-bit field and Clang asserts
on the undeclared value.
"""
function setTemplateSpecializationKind(x::AbstractFunctionTemplateSpecializationInfo, tsk::CXTemplateSpecializationKind)
    @check_ptrs x
    @assert tsk != CXTemplateSpecializationKind_TSK_Undeclared "TSK_Undeclared has no encoding here"
    return clang_FunctionTemplateSpecializationInfo_setTemplateSpecializationKind(x, tsk)
end

"""
    setPointOfInstantiation(x::AbstractFunctionTemplateSpecializationInfo, loc::SourceLocation)
Record the first point of instantiation. An invalid location is accepted and reads
back as "not yet instantiated".
"""
function setPointOfInstantiation(x::AbstractFunctionTemplateSpecializationInfo, loc::SourceLocation)
    @check_ptrs x
    return clang_FunctionTemplateSpecializationInfo_setPointOfInstantiation(x, loc)
end

# MemberSpecializationInfo
"""
    setTemplateSpecializationKind(x::AbstractMemberSpecializationInfo, tsk::CXTemplateSpecializationKind)
Record how this member specialization came about. `TSK_Undeclared` is rejected: the
info object encodes `tsk - 1` in a two-bit field and Clang asserts on it.
"""
function setTemplateSpecializationKind(x::AbstractMemberSpecializationInfo, tsk::CXTemplateSpecializationKind)
    @check_ptrs x
    @assert tsk != CXTemplateSpecializationKind_TSK_Undeclared "TSK_Undeclared has no encoding here"
    return clang_MemberSpecializationInfo_setTemplateSpecializationKind(x, tsk)
end

"""
    setPointOfInstantiation(x::AbstractMemberSpecializationInfo, loc::SourceLocation)
Record the first point of instantiation of this member. An invalid location is
accepted and reads back as "not yet instantiated".
"""
function setPointOfInstantiation(x::AbstractMemberSpecializationInfo, loc::SourceLocation)
    @check_ptrs x
    return clang_MemberSpecializationInfo_setPointOfInstantiation(x, loc)
end

# TemplateTypeParmDecl
"""
    setDefaultArgument(x::AbstractTemplateTypeParmDecl, arg::AbstractTypeSourceInfo)
Install `arg` as the parameter's default argument. Only valid while the slot is
empty — Clang's `DefaultArgStorage::set` asserts it is still unset, so call
`removeDefaultArgument` first to replace an existing default.
"""
function setDefaultArgument(x::AbstractTemplateTypeParmDecl, arg::AbstractTypeSourceInfo)
    @check_ptrs x arg
    @assert !hasDefaultArgument(x) "template type parameter already has a default argument"
    return clang_TemplateTypeParmDecl_setDefaultArgument(x, arg)
end

"""
    removeDefaultArgument(x::AbstractTemplateTypeParmDecl)
Clear the parameter's default argument, inherited or not. The cleared
`TypeSourceInfo` stays alive in the ASTContext arena and can be re-installed.
"""
function removeDefaultArgument(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_removeDefaultArgument(x)
end

# NonTypeTemplateParmDecl
"""
    setDefaultArgument(x::AbstractNonTypeTemplateParmDecl, arg::AbstractExpr)
Install `arg` as the parameter's default argument expression. Only valid while the
slot is empty — Clang's `DefaultArgStorage::set` asserts it is still unset.
"""
function setDefaultArgument(x::AbstractNonTypeTemplateParmDecl, arg::AbstractExpr)
    @check_ptrs x arg
    @assert !hasDefaultArgument(x) "non-type template parameter already has a default argument"
    return clang_NonTypeTemplateParmDecl_setDefaultArgument(x, arg)
end

"""
    removeDefaultArgument(x::AbstractNonTypeTemplateParmDecl)
Clear the parameter's default argument, inherited or not. The cleared expression
stays alive in the ASTContext arena and can be re-installed.
"""
function removeDefaultArgument(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    return clang_NonTypeTemplateParmDecl_removeDefaultArgument(x)
end

# TemplateTemplateParmDecl
"""
    setDefaultArgument(x::AbstractTemplateTemplateParmDecl, ctx::ASTContext, arg::AbstractTemplateArgumentLoc)
Install `arg` as the parameter's default argument. Clang copies it into `ctx`-owned
storage, so the carrier passed in stays the caller's and the value read back
afterwards is a different object. Only valid while the slot is empty — Clang's
`DefaultArgStorage::set` asserts it is still unset.
"""
function setDefaultArgument(x::AbstractTemplateTemplateParmDecl, ctx::ASTContext, arg::AbstractTemplateArgumentLoc)
    @check_ptrs x ctx arg
    @assert !hasDefaultArgument(x) "template template parameter already has a default argument"
    return clang_TemplateTemplateParmDecl_setDefaultArgument(x, ctx, arg)
end

"""
    removeDefaultArgument(x::AbstractTemplateTemplateParmDecl)
Clear the parameter's default argument, inherited or not. Afterwards
`getDefaultArgument` returns the shared empty `TemplateArgumentLoc`.
"""
function removeDefaultArgument(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    return clang_TemplateTemplateParmDecl_removeDefaultArgument(x)
end

# ClassTemplateSpecializationDecl
"""
    setSpecializedTemplate(x::AbstractClassTemplateSpecializationDecl, ctd::AbstractClassTemplateDecl)
Point the specialization at `ctd`. The slot is a `PointerUnion`, so writing a plain
`ClassTemplateDecl` into it would discard a stored partial-specialization and its
deduced argument list — only valid when `specializedOnPartial(x)` is `false`.
"""
function setSpecializedTemplate(x::AbstractClassTemplateSpecializationDecl, ctd::AbstractClassTemplateDecl)
    @check_ptrs x ctd
    @assert !specializedOnPartial(x) "specialization was deduced from a partial specialization"
    return clang_ClassTemplateSpecializationDecl_setSpecializedTemplate(x, ctd)
end

function setSpecializationKind(x::AbstractClassTemplateSpecializationDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_setSpecializationKind(x, tsk)
end

"""
    setPointOfInstantiation(x::AbstractClassTemplateSpecializationDecl, loc::SourceLocation)
Record the point of instantiation. `loc` must be valid — Clang asserts on an
invalid point of instantiation here (unlike the specialization-info setters).
"""
function setPointOfInstantiation(x::AbstractClassTemplateSpecializationDecl, loc::SourceLocation)
    @check_ptrs x
    @assert isValid(loc) "point of instantiation must be a valid source location"
    return clang_ClassTemplateSpecializationDecl_setPointOfInstantiation(x, loc)
end

"""
    setExternLoc(x::AbstractClassTemplateSpecializationDecl, loc::SourceLocation)
Record the location of the `extern` keyword. The explicit-specialization info block
is allocated in the ASTContext on first use; any location, valid or not, is accepted.
"""
function setExternLoc(x::AbstractClassTemplateSpecializationDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_setExternLoc(x, loc)
end

"""
    setTemplateKeywordLoc(x::AbstractClassTemplateSpecializationDecl, loc::SourceLocation)
Record the location of the `template` keyword. The explicit-specialization info block
is allocated in the ASTContext on first use; any location, valid or not, is accepted.
"""
function setTemplateKeywordLoc(x::AbstractClassTemplateSpecializationDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_ClassTemplateSpecializationDecl_setTemplateKeywordLoc(x, loc)
end

# VarTemplateSpecializationDecl
function setSpecializationKind(x::AbstractVarTemplateSpecializationDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_setSpecializationKind(x, tsk)
end

"""
    setPointOfInstantiation(x::AbstractVarTemplateSpecializationDecl, loc::SourceLocation)
Record the point of instantiation. `loc` must be valid — Clang asserts on an
invalid point of instantiation here (unlike the specialization-info setters).
"""
function setPointOfInstantiation(x::AbstractVarTemplateSpecializationDecl, loc::SourceLocation)
    @check_ptrs x
    @assert isValid(loc) "point of instantiation must be a valid source location"
    return clang_VarTemplateSpecializationDecl_setPointOfInstantiation(x, loc)
end

"""
    setExternLoc(x::AbstractVarTemplateSpecializationDecl, loc::SourceLocation)
Record the location of the `extern` keyword. The explicit-specialization info block
is allocated in the ASTContext on first use; any location, valid or not, is accepted.
"""
function setExternLoc(x::AbstractVarTemplateSpecializationDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_setExternLoc(x, loc)
end

"""
    setTemplateKeywordLoc(x::AbstractVarTemplateSpecializationDecl, loc::SourceLocation)
Record the location of the `template` keyword. The explicit-specialization info block
is allocated in the ASTContext on first use; any location, valid or not, is accepted.
"""
function setTemplateKeywordLoc(x::AbstractVarTemplateSpecializationDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_VarTemplateSpecializationDecl_setTemplateKeywordLoc(x, loc)
end

# TemplateParameterList
"""
    shouldIncludeTypeForArgument(x::AbstractTemplateParameterList, ctx::ASTContext, i::Integer) -> Bool
Whether a printer has to spell out the parameter's type when rendering the template
argument at zero-based index `i` of `x`, judged with `ctx`'s default printing policy.
Total: an `i` past the end of the list answers `true`, which is Clang's own guard.
"""
function shouldIncludeTypeForArgument(x::AbstractTemplateParameterList, ctx::ASTContext, i::Integer)
    @check_ptrs x ctx
    return clang_TemplateParameterList_shouldIncludeTypeForArgument(x, ctx, i)
end

# TemplateDecl
"""
    getSourceRange(x::AbstractTemplateDecl) -> SourceRange
Return the range spanning the `template` keyword of the parameter list through the end
of the templated declaration.
"""
function getSourceRange(x::AbstractTemplateDecl)
    @check_ptrs x
    r = clang_TemplateDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# RedeclarableTemplateDecl
"""
    setInstantiatedFromMemberTemplate(x::AbstractRedeclarableTemplateDecl, td::AbstractRedeclarableTemplateDecl)
Record that `x` was instantiated from the member template `td`. The slot must still be
unset — Clang asserts on a second call — so this asserts that
`getInstantiatedFromMemberTemplate(x)` is currently NULL.
"""
function setInstantiatedFromMemberTemplate(x::AbstractRedeclarableTemplateDecl, td::AbstractRedeclarableTemplateDecl)
    @check_ptrs x td
    cur = clang_RedeclarableTemplateDecl_getInstantiatedFromMemberTemplate(x)
    @assert cur == C_NULL "the instantiated-from-member-template slot is already set"
    return clang_RedeclarableTemplateDecl_setInstantiatedFromMemberTemplate(x, td)
end

# TemplateTypeParmDecl
"""
    getAssociatedConstraints(x::AbstractTemplateTypeParmDecl) -> Vector{Expr_}
Return the immediately-declared constraint introduced by the parameter's
type-constraint, as a one-element vector. Empty when the parameter is unconstrained.
"""
function getAssociatedConstraints(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    n = clang_TemplateTypeParmDecl_getNumAssociatedConstraints(x)
    buf = Vector{CXExpr}(undef, n)
    n > 0 && clang_TemplateTypeParmDecl_getAssociatedConstraints(x, buf)
    return [Expr_(p) for p in buf]
end

"""
    getSourceRange(x::AbstractTemplateTypeParmDecl) -> SourceRange
Return the range covering the parameter, including its default argument when one was
written.
"""
function getSourceRange(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    r = clang_TemplateTypeParmDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# NonTypeTemplateParmDecl
"""
    getAssociatedConstraints(x::AbstractNonTypeTemplateParmDecl) -> Vector{Expr_}
Return the immediately-declared constraint introduced by the parameter's constrained
placeholder type, as a one-element vector. Empty when the parameter's type carries no
placeholder constraint.
"""
function getAssociatedConstraints(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    n = clang_NonTypeTemplateParmDecl_getNumAssociatedConstraints(x)
    buf = Vector{CXExpr}(undef, n)
    n > 0 && clang_NonTypeTemplateParmDecl_getAssociatedConstraints(x, buf)
    return [Expr_(p) for p in buf]
end

"""
    getSourceRange(x::AbstractNonTypeTemplateParmDecl) -> SourceRange
Return the range covering the parameter, including its default argument when one was
written.
"""
function getSourceRange(x::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x
    r = clang_NonTypeTemplateParmDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# TemplateTemplateParmDecl
"""
    getSourceRange(x::AbstractTemplateTemplateParmDecl) -> SourceRange
Return the range from the `template` keyword of the parameter's own parameter list to
the end of its default argument, or to the parameter's location when no default
argument was written (or the default was inherited).
"""
function getSourceRange(x::AbstractTemplateTemplateParmDecl)
    @check_ptrs x
    r = clang_TemplateTemplateParmDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# BuiltinTemplateDecl
"""
    getSourceRange(x::AbstractBuiltinTemplateDecl) -> SourceRange
Always an invalid range: a builtin template declaration such as `__make_integer_seq`
has no written source.
"""
function getSourceRange(x::AbstractBuiltinTemplateDecl)
    @check_ptrs x
    r = clang_BuiltinTemplateDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# ClassTemplateSpecializationDecl
"""
    setTypeAsWritten(x::AbstractClassTemplateSpecializationDecl, tsi::TypeSourceInfo)
Record the specialization type as it was written by the user. The
explicit-specialization info block is allocated in the ASTContext on first use.
"""
function setTypeAsWritten(x::AbstractClassTemplateSpecializationDecl, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_ClassTemplateSpecializationDecl_setTypeAsWritten(x, tsi)
end

# ClassTemplatePartialSpecializationDecl
"""
    getAssociatedConstraints(x::AbstractClassTemplatePartialSpecializationDecl) -> Vector{Expr_}
Return every constraint expression associated with the partial specialization's own
template parameter list, in declaration order. Empty when it is unconstrained.
"""
function getAssociatedConstraints(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    n = clang_ClassTemplatePartialSpecializationDecl_getNumAssociatedConstraints(x)
    buf = Vector{CXExpr}(undef, n)
    n > 0 && clang_ClassTemplatePartialSpecializationDecl_getAssociatedConstraints(x, buf)
    return [Expr_(p) for p in buf]
end

"""
    setInstantiatedFromMember(x::AbstractClassTemplatePartialSpecializationDecl,
                              ps::AbstractClassTemplatePartialSpecializationDecl)
Record, on the first declaration of `x`'s redeclaration chain, the member partial
specialization `x` was instantiated from. Any previously recorded link is overwritten.
"""
function setInstantiatedFromMember(x::AbstractClassTemplatePartialSpecializationDecl, ps::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x ps
    return clang_ClassTemplatePartialSpecializationDecl_setInstantiatedFromMember(x, ps)
end

"""
    setMemberSpecialization(x::AbstractClassTemplatePartialSpecializationDecl)
Mark `x` as a specialization of a member partial specialization. Only a partial
specialization that already records the member it was instantiated from may be marked —
Clang asserts otherwise — so this asserts `getInstantiatedFromMember(x)` is non-NULL.
"""
function setMemberSpecialization(x::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x
    @assert getInstantiatedFromMember(x).ptr != C_NULL "only member templates can be member template specializations"
    return clang_ClassTemplatePartialSpecializationDecl_setMemberSpecialization(x)
end

# ClassTemplateDecl
"""
    findPartialSpecInstantiatedFromMember(x::AbstractClassTemplateDecl,
                                          d::AbstractClassTemplatePartialSpecializationDecl)
        -> ClassTemplatePartialSpecializationDecl
Return the partial specialization of `x` that was instantiated from the member partial
specialization `d`; the carrier holds NULL when there is none. Clang's scan
dereferences each candidate's `getInstantiatedFromMember()` unconditionally, so this
asserts every partial specialization of `x` records one.
"""
function findPartialSpecInstantiatedFromMember(x::AbstractClassTemplateDecl, d::AbstractClassTemplatePartialSpecializationDecl)
    @check_ptrs x d
    msg = "every partial specialization must record the member it was instantiated from"
    @assert all(p -> getInstantiatedFromMember(p).ptr != C_NULL, getPartialSpecializations(x)) msg
    p = clang_ClassTemplateDecl_findPartialSpecInstantiatedFromMember(x, d)
    return ClassTemplatePartialSpecializationDecl(p)
end

# VarTemplateSpecializationDecl
"""
    setTypeAsWritten(x::AbstractVarTemplateSpecializationDecl, tsi::TypeSourceInfo)
Record the specialization type as it was written by the user. The
explicit-specialization info block is allocated in the ASTContext on first use.
"""
function setTypeAsWritten(x::AbstractVarTemplateSpecializationDecl, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_VarTemplateSpecializationDecl_setTypeAsWritten(x, tsi)
end

# VarTemplatePartialSpecializationDecl
"""
    getAssociatedConstraints(x::AbstractVarTemplatePartialSpecializationDecl) -> Vector{Expr_}
Return every constraint expression associated with the partial specialization's own
template parameter list, in declaration order. Empty when it is unconstrained.
"""
function getAssociatedConstraints(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    n = clang_VarTemplatePartialSpecializationDecl_getNumAssociatedConstraints(x)
    buf = Vector{CXExpr}(undef, n)
    n > 0 && clang_VarTemplatePartialSpecializationDecl_getAssociatedConstraints(x, buf)
    return [Expr_(p) for p in buf]
end

"""
    setInstantiatedFromMember(x::AbstractVarTemplatePartialSpecializationDecl,
                              ps::AbstractVarTemplatePartialSpecializationDecl)
Record, on the first declaration of `x`'s redeclaration chain, the member partial
specialization `x` was instantiated from. Any previously recorded link is overwritten.
"""
function setInstantiatedFromMember(x::AbstractVarTemplatePartialSpecializationDecl, ps::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x ps
    return clang_VarTemplatePartialSpecializationDecl_setInstantiatedFromMember(x, ps)
end

"""
    setMemberSpecialization(x::AbstractVarTemplatePartialSpecializationDecl)
Mark `x` as a specialization of a member partial specialization. Only a partial
specialization that already records the member it was instantiated from may be marked —
Clang asserts otherwise — so this asserts `getInstantiatedFromMember(x)` is non-NULL.
"""
function setMemberSpecialization(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    @assert getInstantiatedFromMember(x).ptr != C_NULL "only member templates can be member template specializations"
    return clang_VarTemplatePartialSpecializationDecl_setMemberSpecialization(x)
end

"""
    getSourceRange(x::AbstractVarTemplatePartialSpecializationDecl) -> SourceRange
Return the range covering the partial specialization, from its own `template` keyword
through the end of its initializer.
"""
function getSourceRange(x::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x
    r = clang_VarTemplatePartialSpecializationDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# VarTemplateDecl
"""
    findPartialSpecInstantiatedFromMember(x::AbstractVarTemplateDecl,
                                          d::AbstractVarTemplatePartialSpecializationDecl)
        -> VarTemplatePartialSpecializationDecl
Return the partial specialization of `x` that was instantiated from the member partial
specialization `d`; the carrier holds NULL when there is none. Clang's scan
dereferences each candidate's `getInstantiatedFromMember()` unconditionally, so this
asserts every partial specialization of `x` records one.
"""
function findPartialSpecInstantiatedFromMember(x::AbstractVarTemplateDecl, d::AbstractVarTemplatePartialSpecializationDecl)
    @check_ptrs x d
    msg = "every partial specialization must record the member it was instantiated from"
    @assert all(p -> getInstantiatedFromMember(p).ptr != C_NULL, getPartialSpecializations(x)) msg
    p = clang_VarTemplateDecl_findPartialSpecInstantiatedFromMember(x, d)
    return VarTemplatePartialSpecializationDecl(p)
end

"""
    classofKind(T, k::CXDeclKind) -> Bool
Whether a declaration of kind `k` is a `T`, for the template hierarchy of
`clang/AST/DeclTemplate.h` — the range test `isa<T>` performs, evaluated on the kind alone.
Reach for it when no declaration handle is available to run the `castTo*`/`is*` family
against: `getDeclKind(::DeclContext)` and the kinds `decls` hands back are kinds, not
declarations. The test covers subclasses, so `classofKind(TemplateDecl, k)` also holds for
every class/function/variable/alias template kind and for `Concept`, and
`classofKind(ClassTemplateSpecializationDecl, k)` also holds for the partial specialization
kind. `T` is one of `TemplateDecl`, `RedeclarableTemplateDecl`, `FunctionTemplateDecl`,
`TemplateTypeParmDecl`, `NonTypeTemplateParmDecl`, `TemplateTemplateParmDecl`,
`BuiltinTemplateDecl`, `ClassTemplateSpecializationDecl`,
`ClassTemplatePartialSpecializationDecl`, `ClassTemplateDecl`, `FriendTemplateDecl`,
`TypeAliasTemplateDecl`, `VarTemplateSpecializationDecl`,
`VarTemplatePartialSpecializationDecl`, `VarTemplateDecl`, `ConceptDecl`,
`TemplateParamObjectDecl`.
"""
classofKind(::Type{TemplateDecl}, k::CXDeclKind) = clang_TemplateDecl_classofKind(k)

classofKind(::Type{RedeclarableTemplateDecl}, k::CXDeclKind) = clang_RedeclarableTemplateDecl_classofKind(k)

classofKind(::Type{FunctionTemplateDecl}, k::CXDeclKind) = clang_FunctionTemplateDecl_classofKind(k)

classofKind(::Type{TemplateTypeParmDecl}, k::CXDeclKind) = clang_TemplateTypeParmDecl_classofKind(k)

classofKind(::Type{NonTypeTemplateParmDecl}, k::CXDeclKind) = clang_NonTypeTemplateParmDecl_classofKind(k)

classofKind(::Type{TemplateTemplateParmDecl}, k::CXDeclKind) = clang_TemplateTemplateParmDecl_classofKind(k)

classofKind(::Type{BuiltinTemplateDecl}, k::CXDeclKind) = clang_BuiltinTemplateDecl_classofKind(k)

function classofKind(::Type{ClassTemplateSpecializationDecl}, k::CXDeclKind)
    return clang_ClassTemplateSpecializationDecl_classofKind(k)
end

function classofKind(::Type{ClassTemplatePartialSpecializationDecl}, k::CXDeclKind)
    return clang_ClassTemplatePartialSpecializationDecl_classofKind(k)
end

classofKind(::Type{ClassTemplateDecl}, k::CXDeclKind) = clang_ClassTemplateDecl_classofKind(k)

classofKind(::Type{FriendTemplateDecl}, k::CXDeclKind) = clang_FriendTemplateDecl_classofKind(k)

classofKind(::Type{TypeAliasTemplateDecl}, k::CXDeclKind) = clang_TypeAliasTemplateDecl_classofKind(k)

classofKind(::Type{VarTemplateSpecializationDecl}, k::CXDeclKind) = clang_VarTemplateSpecializationDecl_classofKind(k)

function classofKind(::Type{VarTemplatePartialSpecializationDecl}, k::CXDeclKind)
    return clang_VarTemplatePartialSpecializationDecl_classofKind(k)
end

classofKind(::Type{VarTemplateDecl}, k::CXDeclKind) = clang_VarTemplateDecl_classofKind(k)

classofKind(::Type{ConceptDecl}, k::CXDeclKind) = clang_ConceptDecl_classofKind(k)

classofKind(::Type{TemplateParamObjectDecl}, k::CXDeclKind) = clang_TemplateParamObjectDecl_classofKind(k)

# FunctionTemplateDecl
"""
    findSpecialization(x::AbstractFunctionTemplateDecl, list::TemplateArgumentList,
                       insert_pos=C_NULL) -> FunctionDecl
Return the specialization of `x` whose canonical template arguments are the ones in `list`;
the carrier holds NULL when the specialization set has no such entry. The hit is the most
recent redeclaration of that specialization, so it matches what `getSpecializations`
yields. `insert_pos` is Clang's FoldingSet insertion hint: it crosses by value, so the
position Clang writes back is not visible here.
"""
function findSpecialization(x::AbstractFunctionTemplateDecl, list::TemplateArgumentList, insert_pos=C_NULL)
    @check_ptrs x list
    fd = clang_FunctionTemplateDecl_findSpecialization(x, list, insert_pos)
    return FunctionDecl(fd)
end

# VarTemplateDecl
"""
    findSpecialization(x::AbstractVarTemplateDecl, list::TemplateArgumentList,
                       insert_pos=C_NULL) -> VarTemplateSpecializationDecl
Return the specialization of `x` whose canonical template arguments are the ones in `list`;
the carrier holds NULL when the specialization set has no such entry. The hit is the most
recent redeclaration of that specialization, and `insert_pos` is the same by-value
FoldingSet hint as above.
"""
function findSpecialization(x::AbstractVarTemplateDecl, list::TemplateArgumentList, insert_pos=C_NULL)
    @check_ptrs x list
    vtsd = clang_VarTemplateDecl_findSpecialization(x, list, insert_pos)
    return VarTemplateSpecializationDecl(vtsd)
end

"""
    findPartialSpecialization(x::AbstractVarTemplateDecl, list::TemplateArgumentList,
                              params::TemplateParameterList, insert_pos=C_NULL)
        -> VarTemplatePartialSpecializationDecl
Return the partial specialization of `x` profiled by `list` together with `params`; the
carrier holds NULL when the partial-specialization set has no such entry. Clang profiles
the argument list and the parameter list as a pair, so both must come from the same partial
specialization for the lookup to hit — passing the arguments alone cannot identify one.
`insert_pos` is the same by-value FoldingSet hint as above.
"""
function findPartialSpecialization(x::AbstractVarTemplateDecl, list::TemplateArgumentList, params::TemplateParameterList, insert_pos=C_NULL)
    @check_ptrs x list params
    vps = clang_VarTemplateDecl_findPartialSpecialization(x, list, params, insert_pos)
    return VarTemplatePartialSpecializationDecl(vps)
end

# --- Template declaration factories and the inherited-default-argument links ---

# FunctionTemplateDecl
"""
    FunctionTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName,
                         params::TemplateParameterList, decl::AbstractNamedDecl) -> FunctionTemplateDecl
Build a function template declaration for the templated function `decl` over `params`. Clang adopts
`params` — the parameters' owning context is re-seated when the template is built, so `decl` must be a
`DeclContext` itself and `params` should already belong there. The node is allocated in `ctx` and is
*not* added to `dc`; adding it is the caller's job.
"""
function FunctionTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, params::TemplateParameterList, decl::AbstractNamedDecl)
    @check_ptrs ctx dc params decl
    @assert classof(decl) "the templated declaration of a function template must be a DeclContext"
    return FunctionTemplateDecl(clang_FunctionTemplateDecl_Create(ctx, dc, loc, name, params, decl))
end

# TemplateTypeParmDecl
"""
    setInheritedDefaultArgument(x::AbstractTemplateTypeParmDecl, ctx::ASTContext,
                                prev::AbstractTemplateTypeParmDecl)
Record that `x`'s default argument is the one written on `prev` rather than on `x` itself; afterwards
`defaultArgumentWasInherited(x)` holds and `getDefaultArgumentInfo(x)` reads through to `prev`. `prev`
must carry a default argument, and `x` must not already inherit one — re-inheriting makes Clang assert
that the old and the new default are the same template argument, which this layer cannot establish.
"""
function setInheritedDefaultArgument(x::AbstractTemplateTypeParmDecl, ctx::ASTContext, prev::AbstractTemplateTypeParmDecl)
    @check_ptrs x ctx prev
    @assert hasDefaultArgument(prev) "the parameter inherited from has no default argument"
    @assert !defaultArgumentWasInherited(x) "default argument is already inherited"
    return clang_TemplateTypeParmDecl_setInheritedDefaultArgument(x, ctx, prev)
end

# NonTypeTemplateParmDecl
"""
    setInheritedDefaultArgument(x::AbstractNonTypeTemplateParmDecl, ctx::ASTContext,
                                prev::AbstractNonTypeTemplateParmDecl)
Record that `x`'s default argument expression is the one written on `prev`. Same preconditions as the
template type parameter form.
"""
function setInheritedDefaultArgument(x::AbstractNonTypeTemplateParmDecl, ctx::ASTContext, prev::AbstractNonTypeTemplateParmDecl)
    @check_ptrs x ctx prev
    @assert hasDefaultArgument(prev) "the parameter inherited from has no default argument"
    @assert !defaultArgumentWasInherited(x) "default argument is already inherited"
    return clang_NonTypeTemplateParmDecl_setInheritedDefaultArgument(x, ctx, prev)
end

# TemplateTemplateParmDecl
"""
    setInheritedDefaultArgument(x::AbstractTemplateTemplateParmDecl, ctx::ASTContext,
                                prev::AbstractTemplateTemplateParmDecl)
Record that `x`'s default argument is the one written on `prev`. Same preconditions as the template
type parameter form.
"""
function setInheritedDefaultArgument(x::AbstractTemplateTemplateParmDecl, ctx::ASTContext, prev::AbstractTemplateTemplateParmDecl)
    @check_ptrs x ctx prev
    @assert hasDefaultArgument(prev) "the parameter inherited from has no default argument"
    @assert !defaultArgumentWasInherited(x) "default argument is already inherited"
    return clang_TemplateTemplateParmDecl_setInheritedDefaultArgument(x, ctx, prev)
end

# BuiltinTemplateDecl
"""
    BuiltinTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, name::DeclarationName,
                        btk::CXBuiltinTemplateKind) -> BuiltinTemplateDecl
Build the declaration that holds the parameters of a builtin template (`__make_integer_seq`,
`__type_pack_element`). Clang derives the parameter list from `btk`, so there is none to pass. The
node is allocated in `ctx` and is *not* added to `dc`.
"""
function BuiltinTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, name::DeclarationName, btk::CXBuiltinTemplateKind)
    @check_ptrs ctx dc
    return BuiltinTemplateDecl(clang_BuiltinTemplateDecl_Create(ctx, dc, name, btk))
end

# ClassTemplateDecl
"""
    ClassTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName,
                      params::TemplateParameterList, decl::AbstractNamedDecl) -> ClassTemplateDecl
Build a class template declaration for the templated record `decl` over `params`. Adopts `params` and
leaves the node out of `dc` exactly like the function template form, so `decl` must be a `DeclContext`
here too.
"""
function ClassTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, params::TemplateParameterList, decl::AbstractNamedDecl)
    @check_ptrs ctx dc params decl
    @assert classof(decl) "the templated declaration of a class template must be a DeclContext"
    return ClassTemplateDecl(clang_ClassTemplateDecl_Create(ctx, dc, loc, name, params, decl))
end

# FriendTemplateDecl
"""
    FriendTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation,
                       params::Vector{TemplateParameterList}, friend::AbstractNamedDecl,
                       friend_loc::SourceLocation) -> FriendTemplateDecl
Build a friend template declaration whose friend is a declaration; `getFriendType` is NULL on the
result. `params` crosses as a handle buffer and is copied into `ctx`-owned storage, so the vector
stays the caller's. Clang's own parser never builds this node — a friend template written in source
yields a `FriendDecl` — so construction is the only way to obtain one.
"""
function FriendTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, params::Vector{TemplateParameterList}, friend::AbstractNamedDecl, friend_loc::SourceLocation)
    @check_ptrs ctx dc friend
    ptrs = CXTemplateParameterList[Base.unsafe_convert(CXTemplateParameterList, p) for p in params]
    ftd = clang_FriendTemplateDecl_CreateWithFriendDecl(ctx, dc, loc, ptrs, length(ptrs), friend, friend_loc)
    return FriendTemplateDecl(ftd)
end

"""
    FriendTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation,
                       params::Vector{TemplateParameterList}, friend::AbstractTypeSourceInfo,
                       friend_loc::SourceLocation) -> FriendTemplateDecl
Build a friend template declaration whose friend is a type; `getFriendDecl` is NULL on the result.
`params` is copied into `ctx`-owned storage as in the declaration form.
"""
function FriendTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, params::Vector{TemplateParameterList}, friend::AbstractTypeSourceInfo, friend_loc::SourceLocation)
    @check_ptrs ctx dc friend
    ptrs = CXTemplateParameterList[Base.unsafe_convert(CXTemplateParameterList, p) for p in params]
    ftd = clang_FriendTemplateDecl_CreateWithFriendType(ctx, dc, loc, ptrs, length(ptrs), friend, friend_loc)
    return FriendTemplateDecl(ftd)
end

"""
    getFriendType(x::AbstractFriendTemplateDecl) -> TypeSourceInfo
The type this friend declaration names; the carrier holds NULL when the friend is a declaration.
"""
function getFriendType(x::AbstractFriendTemplateDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_FriendTemplateDecl_getFriendType(x))
end

"""
    getFriendDecl(x::AbstractFriendTemplateDecl) -> NamedDecl
The declaration this friend declaration names; the carrier holds NULL when the friend is a type.
"""
function getFriendDecl(x::AbstractFriendTemplateDecl)
    @check_ptrs x
    return NamedDecl(clang_FriendTemplateDecl_getFriendDecl(x))
end

"""
    getFriendLoc(x::AbstractFriendTemplateDecl) -> SourceLocation
The location of the `friend` keyword.
"""
function getFriendLoc(x::AbstractFriendTemplateDecl)
    @check_ptrs x
    return SourceLocation(clang_FriendTemplateDecl_getFriendLoc(x))
end

"""
    getTemplateParameterList(x::AbstractFriendTemplateDecl, i::Integer) -> TemplateParameterList
The `i`-th (0-based) parameter list of the friend template. Clang's own bound check admits
`i == getNumTemplateParameters(x)`, which reads one slot past the array, so the bound is restated
here.
"""
function getTemplateParameterList(x::AbstractFriendTemplateDecl, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateParameters(x) "template parameter list index out of range"
    return TemplateParameterList(clang_FriendTemplateDecl_getTemplateParameterList(x, i))
end

"""
    getNumTemplateParameters(x::AbstractFriendTemplateDecl) -> Integer
How many parameter lists the friend template carries.
"""
function getNumTemplateParameters(x::AbstractFriendTemplateDecl)
    @check_ptrs x
    return clang_FriendTemplateDecl_getNumTemplateParameters(x)
end

# TypeAliasTemplateDecl
"""
    TypeAliasTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation,
                          name::DeclarationName, params::TemplateParameterList,
                          decl::AbstractNamedDecl) -> TypeAliasTemplateDecl
Build an alias template declaration for the templated `TypeAliasDecl` `decl`. A `TypeAliasDecl` is not
a `DeclContext`, so `params` is adopted into `dc` instead; pass the context the parameters already
live in. The node is *not* added to `dc`.
"""
function TypeAliasTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, params::TemplateParameterList, decl::AbstractNamedDecl)
    @check_ptrs ctx dc params decl
    return TypeAliasTemplateDecl(clang_TypeAliasTemplateDecl_Create(ctx, dc, loc, name, params, decl))
end

# VarTemplateDecl
"""
    VarTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName,
                    params::TemplateParameterList, decl::AbstractVarDecl) -> VarTemplateDecl
Build a variable template declaration for the templated variable `decl`. `params` is adopted into `dc`
(a `VarDecl` is not a `DeclContext`), and the node is *not* added to `dc`.
"""
function VarTemplateDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, params::TemplateParameterList, decl::AbstractVarDecl)
    @check_ptrs ctx dc params decl
    return VarTemplateDecl(clang_VarTemplateDecl_Create(ctx, dc, loc, name, params, decl))
end

# ConceptDecl
"""
    ConceptDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName,
                params::TemplateParameterList, constraint::AbstractExpr) -> ConceptDecl
Build a concept declaration constrained by `constraint` over `params`. `params` is adopted into `dc`,
and the node is *not* added to `dc`.
"""
function ConceptDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, name::DeclarationName, params::TemplateParameterList, constraint::AbstractExpr)
    @check_ptrs ctx dc params constraint
    return ConceptDecl(clang_ConceptDecl_Create(ctx, dc, loc, name, params, constraint))
end

# TemplateParameterList
"""
    TemplateParameterList(ctx::ASTContext, template_loc::SourceLocation, langle_loc::SourceLocation,
                          params::AbstractVector{<:AbstractNamedDecl}, rangle_loc::SourceLocation,
                          requires_clause::Union{Nothing,AbstractExpr}=nothing) -> TemplateParameterList
Build a template parameter list holding `params`, allocated in `ctx`'s arena (borrowed -- there is
no `dispose`). Every entry of `params` must be a `TemplateTypeParmDecl`, a `NonTypeTemplateParmDecl`
or a `TemplateTemplateParmDecl`; the list stores the declarations themselves, so they have to
outlive it. `requires_clause` carries the `requires` constraint, if the list has one.
"""
function TemplateParameterList(ctx::ASTContext, template_loc::SourceLocation, langle_loc::SourceLocation, params::AbstractVector{<:AbstractNamedDecl}, rangle_loc::SourceLocation, requires_clause::Union{Nothing,AbstractExpr}=nothing)
    @check_ptrs ctx
    @assert all(p -> p.ptr != C_NULL, params) "every template parameter must be non-NULL"
    ptrs = CXNamedDecl[Base.unsafe_convert(CXNamedDecl, p) for p in params]
    rc = requires_clause === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, requires_clause)
    ptr = clang_TemplateParameterList_Create(ctx, template_loc, langle_loc, ptrs, length(ptrs), rangle_loc, rc)
    return TemplateParameterList(ptr)
end

# DependentFunctionTemplateSpecializationInfo
"""
    getCandidates(x::AbstractDependentFunctionTemplateSpecializationInfo) -> Vector{FunctionTemplateDecl}
The primary function templates a dependent explicit specialization could still resolve to once its
enclosing context is instantiated. The carriers borrow the array trailing the info object, so they
must never be `dispose`d.
"""
function getCandidates(x::AbstractDependentFunctionTemplateSpecializationInfo)
    @check_ptrs x
    n = clang_DependentFunctionTemplateSpecializationInfo_getNumCandidates(x)
    return [FunctionTemplateDecl(clang_DependentFunctionTemplateSpecializationInfo_getCandidate(x, i)) for i = 0:(n - 1)]
end

# TemplateTypeParmDecl
"""
    TemplateTypeParmDecl(ctx::ASTContext, dc::AnyDeclContext, key_loc::SourceLocation,
                         name_loc::SourceLocation, depth::Integer, index::Integer,
                         id::Union{Nothing,AbstractIdentifierInfo}, typename::Bool,
                         parameter_pack::Bool, has_type_constraint::Bool=false,
                         num_expanded::Union{Nothing,Integer}=nothing) -> TemplateTypeParmDecl
Build a template *type* parameter (`typename T` / `class T`) at `depth`/`index`. The node is *not*
added to `dc`; `id` may be `nothing` for an unnamed parameter. `num_expanded` mirrors Clang's
`std::optional`: pass a size to mark the parameter an already-expanded pack, `nothing` otherwise.
`has_type_constraint` only reserves the trailing constraint slot -- the constraint itself stays
uninitialized, so `hasInitializedTypeConstraint` keeps reporting `false` until Sema fills it in.
"""
function TemplateTypeParmDecl(ctx::ASTContext, dc::AnyDeclContext, key_loc::SourceLocation, name_loc::SourceLocation, depth::Integer, index::Integer, id::Union{Nothing,AbstractIdentifierInfo}, typename::Bool, parameter_pack::Bool, has_type_constraint::Bool=false, num_expanded::Union{Nothing,Integer}=nothing)
    @check_ptrs ctx dc
    id_ptr = id === nothing ? CXIdentifierInfo(C_NULL) : Base.unsafe_convert(CXIdentifierInfo, id)
    ptr = clang_TemplateTypeParmDecl_Create(ctx, dc, key_loc, name_loc, depth, index, id_ptr, typename, parameter_pack, has_type_constraint, num_expanded !== nothing, num_expanded === nothing ? 0 : num_expanded)
    return TemplateTypeParmDecl(ptr)
end

"""
    hasInitializedTypeConstraint(x::AbstractTemplateTypeParmDecl) -> Bool
Whether the parameter's trailing `TypeConstraint` slot has actually been filled in. This is *not*
`hasTypeConstraint`, which reports the flag chosen when the parameter was created: a parameter built
with the flag set but not yet visited by Sema has the storage and no constraint in it, and reading
that slot is undefined behaviour. Every `getTypeConstraint*` accessor asserts on this.
"""
function hasInitializedTypeConstraint(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    return clang_TemplateTypeParmDecl_hasInitializedTypeConstraint(x)
end

"""
    getTypeConstraintConcept(x::AbstractTemplateTypeParmDecl) -> ConceptDecl
The concept constraining this type parameter, reached through its `TypeConstraint`.
"""
function getTypeConstraintConcept(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    @assert hasInitializedTypeConstraint(x) "parameter has no initialized type-constraint"
    return ConceptDecl(clang_TemplateTypeParmDecl_getTypeConstraintConcept(x))
end

"""
    getTypeConstraintImmediatelyDeclaredConstraint(x::AbstractTemplateTypeParmDecl) -> Expr_
The constraint expression the type-constraint contributes to the enclosing declaration's associated
constraints.
"""
function getTypeConstraintImmediatelyDeclaredConstraint(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    @assert hasInitializedTypeConstraint(x) "parameter has no initialized type-constraint"
    return Expr_(clang_TemplateTypeParmDecl_getTypeConstraintImmediatelyDeclaredConstraint(x))
end

"""
    getTypeConstraintConceptNameLoc(x::AbstractTemplateTypeParmDecl) -> SourceLocation
Where the concept name of the type-constraint was written.
"""
function getTypeConstraintConceptNameLoc(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    @assert hasInitializedTypeConstraint(x) "parameter has no initialized type-constraint"
    return SourceLocation(clang_TemplateTypeParmDecl_getTypeConstraintConceptNameLoc(x))
end

"""
    getTypeConstraintTemplateArgsAsWritten(x::AbstractTemplateTypeParmDecl) -> ASTTemplateArgumentListInfo
The as-written argument list of the type-constraint. The carrier wraps `C_NULL` (check `.ptr`) when
the constraint was written without explicit template arguments.
"""
function getTypeConstraintTemplateArgsAsWritten(x::AbstractTemplateTypeParmDecl)
    @check_ptrs x
    @assert hasInitializedTypeConstraint(x) "parameter has no initialized type-constraint"
    return ASTTemplateArgumentListInfo(clang_TemplateTypeParmDecl_getTypeConstraintTemplateArgsAsWritten(x))
end

# NonTypeTemplateParmDecl
"""
    NonTypeTemplateParmDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation,
                            id_loc::SourceLocation, depth::Integer, position::Integer,
                            id::Union{Nothing,AbstractIdentifierInfo}, ty::QualType,
                            parameter_pack::Bool,
                            tinfo::Union{Nothing,AbstractTypeSourceInfo}=nothing) -> NonTypeTemplateParmDecl
Build a non-type template parameter (`int N`) of type `ty` at `depth`/`position`. The node is *not*
added to `dc`; `id` and `tinfo` may be `nothing`. Clang packs the position into 20-bit and 12-bit
fields and asserts on overflow, so both bounds are restated here.
"""
function NonTypeTemplateParmDecl(ctx::ASTContext, dc::AnyDeclContext, start_loc::SourceLocation, id_loc::SourceLocation, depth::Integer, position::Integer, id::Union{Nothing,AbstractIdentifierInfo}, ty::QualType, parameter_pack::Bool, tinfo::Union{Nothing,AbstractTypeSourceInfo}=nothing)
    @check_ptrs ctx dc
    @assert 0 <= depth <= 0xFFFFE "template parameter depth must fit clang's 20-bit field"
    @assert 0 <= position <= 0xFFE "template parameter position must fit clang's 12-bit field"
    id_ptr = id === nothing ? CXIdentifierInfo(C_NULL) : Base.unsafe_convert(CXIdentifierInfo, id)
    ti_ptr = tinfo === nothing ? CXTypeSourceInfo(C_NULL) : Base.unsafe_convert(CXTypeSourceInfo, tinfo)
    ptr = clang_NonTypeTemplateParmDecl_Create(ctx, dc, start_loc, id_loc, depth, position, id_ptr, ty, parameter_pack, ti_ptr)
    return NonTypeTemplateParmDecl(ptr)
end

"""
    setDepth(x::AbstractNonTypeTemplateParmDecl, depth::Integer)
Re-seat the parameter's nesting depth. Clang stores it in a 20-bit field and asserts on overflow.
"""
function setDepth(x::AbstractNonTypeTemplateParmDecl, depth::Integer)
    @check_ptrs x
    @assert 0 <= depth <= 0xFFFFE "template parameter depth must fit clang's 20-bit field"
    return clang_NonTypeTemplateParmDecl_setDepth(x, depth)
end

"""
    setPosition(x::AbstractNonTypeTemplateParmDecl, position::Integer)
Re-seat the parameter's position in its parameter list. Position and index are the same 12-bit
field, so this also moves `getIndex`; clang asserts on overflow.
"""
function setPosition(x::AbstractNonTypeTemplateParmDecl, position::Integer)
    @check_ptrs x
    @assert 0 <= position <= 0xFFE "template parameter position must fit clang's 12-bit field"
    return clang_NonTypeTemplateParmDecl_setPosition(x, position)
end

# TemplateTemplateParmDecl
"""
    TemplateTemplateParmDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, depth::Integer,
                             position::Integer, parameter_pack::Bool,
                             id::Union{Nothing,AbstractIdentifierInfo},
                             params::TemplateParameterList) -> TemplateTemplateParmDecl
Build a template template parameter (`template <typename> class P`) whose own parameter list is
`params`. The node is *not* added to `dc`; `id` may be `nothing`. Same 20-bit depth / 12-bit
position bounds as `NonTypeTemplateParmDecl`.
"""
function TemplateTemplateParmDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, depth::Integer, position::Integer, parameter_pack::Bool, id::Union{Nothing,AbstractIdentifierInfo}, params::TemplateParameterList)
    @check_ptrs ctx dc params
    @assert 0 <= depth <= 0xFFFFE "template parameter depth must fit clang's 20-bit field"
    @assert 0 <= position <= 0xFFE "template parameter position must fit clang's 12-bit field"
    id_ptr = id === nothing ? CXIdentifierInfo(C_NULL) : Base.unsafe_convert(CXIdentifierInfo, id)
    ptr = clang_TemplateTemplateParmDecl_Create(ctx, dc, loc, depth, position, parameter_pack, id_ptr, params)
    return TemplateTemplateParmDecl(ptr)
end

"""
    setDepth(x::AbstractTemplateTemplateParmDecl, depth::Integer)
Re-seat the parameter's nesting depth. Clang stores it in a 20-bit field and asserts on overflow.
"""
function setDepth(x::AbstractTemplateTemplateParmDecl, depth::Integer)
    @check_ptrs x
    @assert 0 <= depth <= 0xFFFFE "template parameter depth must fit clang's 20-bit field"
    return clang_TemplateTemplateParmDecl_setDepth(x, depth)
end

"""
    setPosition(x::AbstractTemplateTemplateParmDecl, position::Integer)
Re-seat the parameter's position in its parameter list. Position and index are the same 12-bit
field, so this also moves `getIndex`; clang asserts on overflow.
"""
function setPosition(x::AbstractTemplateTemplateParmDecl, position::Integer)
    @check_ptrs x
    @assert 0 <= position <= 0xFFE "template parameter position must fit clang's 12-bit field"
    return clang_TemplateTemplateParmDecl_setPosition(x, position)
end

# ClassTemplateSpecializationDecl
"""
    getInstantiatedFrom(x::AbstractClassTemplateSpecializationDecl)
The class template or class template partial specialization this specialization was *instantiated*
from -- the same union `getSpecializedTemplateOrPartial` reports, narrowed to instantiations. An
explicit specialization is instantiated from nothing, and yields a `Decl` wrapping `C_NULL`.
"""
function getInstantiatedFrom(x::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x
    ptr = clang_ClassTemplateSpecializationDecl_getInstantiatedFrom(x)
    ptr == C_NULL && return Decl(ptr)
    return specializedOnPartial(x) ? unchecked_cast(ClassTemplatePartialSpecializationDecl, ptr) : unchecked_cast(ClassTemplateDecl, ptr)
end

# VarTemplateSpecializationDecl
"""
    getInstantiatedFrom(x::AbstractVarTemplateSpecializationDecl)
The variable template or variable template partial specialization this specialization was
*instantiated* from -- the same union `getSpecializedTemplateOrPartial` reports, narrowed to
instantiations. An explicit specialization yields a `Decl` wrapping `C_NULL`.
"""
function getInstantiatedFrom(x::AbstractVarTemplateSpecializationDecl)
    @check_ptrs x
    ptr = clang_VarTemplateSpecializationDecl_getInstantiatedFrom(x)
    ptr == C_NULL && return Decl(ptr)
    return specializedOnPartial(x) ? unchecked_cast(VarTemplatePartialSpecializationDecl, ptr) : unchecked_cast(VarTemplateDecl, ptr)
end

# ImplicitConceptSpecializationDecl
"""
    ImplicitConceptSpecializationDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation,
                                      args::AbstractVector{<:AbstractTemplateArgument})
Build the node that records a concept's converted template arguments. The argument values are copied
into `ctx`'s arena, so the caller keeps ownership of the handles it passed and still has to `dispose`
them. The node is *not* added to `dc`, and the argument array is sized once here -- see
`setTemplateArguments`.
"""
function ImplicitConceptSpecializationDecl(ctx::ASTContext, dc::AnyDeclContext, loc::SourceLocation, args::AbstractVector{<:AbstractTemplateArgument})
    @check_ptrs ctx dc
    @assert all(a -> a.ptr != C_NULL, args) "every template argument must be non-NULL"
    ptrs = CXTemplateArgument[Base.unsafe_convert(CXTemplateArgument, a) for a in args]
    ptr = clang_ImplicitConceptSpecializationDecl_Create(ctx, dc, loc, ptrs, length(ptrs))
    return ImplicitConceptSpecializationDecl(ptr)
end

"""
    getTemplateArguments(x::AbstractImplicitConceptSpecializationDecl) -> Vector{TemplateArgument}
The converted arguments the concept was checked against. The carriers borrow the declaration's own
trailing array, so they must never be `dispose`d.
"""
function getTemplateArguments(x::AbstractImplicitConceptSpecializationDecl)
    @check_ptrs x
    n = clang_ImplicitConceptSpecializationDecl_getNumTemplateArguments(x)
    return [TemplateArgument(clang_ImplicitConceptSpecializationDecl_getTemplateArgument(x, i)) for i = 0:(n - 1)]
end

"""
    setTemplateArguments(x::AbstractImplicitConceptSpecializationDecl,
                         args::AbstractVector{<:AbstractTemplateArgument})
Overwrite the converted arguments in place. The trailing array was sized once, when the node was
built, so `args` must hold exactly as many entries as `getTemplateArguments(x)` does -- a longer
list writes past the allocation, which is why the length is asserted here.
"""
function setTemplateArguments(x::AbstractImplicitConceptSpecializationDecl, args::AbstractVector{<:AbstractTemplateArgument})
    @check_ptrs x
    @assert all(a -> a.ptr != C_NULL, args) "every template argument must be non-NULL"
    n = clang_ImplicitConceptSpecializationDecl_getNumTemplateArguments(x)
    @assert length(args) == n "the trailing argument array holds exactly $n entries"
    ptrs = CXTemplateArgument[Base.unsafe_convert(CXTemplateArgument, a) for a in args]
    return clang_ImplicitConceptSpecializationDecl_setTemplateArguments(x, ptrs, length(ptrs))
end

function classofKind(::Type{ImplicitConceptSpecializationDecl}, k::CXDeclKind)
    return clang_ImplicitConceptSpecializationDecl_classofKind(k)
end
