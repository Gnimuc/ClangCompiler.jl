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
    return TemplateArgumentList(ctx, [arg.ptr for arg in args])
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

function findSpecialization(x::AbstractClassTemplateDecl, list::TemplateArgumentList,
                            insert_pos=C_NULL)
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
function ClassTemplateSpecializationDecl(ctx::ASTContext, tk::CXTagTypeKind,
                                         dc::DeclContext, start_loc::SourceLocation,
                                         id_loc::SourceLocation,
                                         template::ClassTemplateDecl,
                                         args::TemplateArgumentList,
                                         prev_decl::ClassTemplateSpecializationDecl)
    @check_ptrs ctx dc template args
    ctsd = clang_ClassTemplateSpecializationDecl_Create(ctx, tk, dc, start_loc, id_loc,
                                                        template, args, prev_decl)
    return ClassTemplateSpecializationDecl(ctsd)
end

function ClassTemplateSpecializationDecl(ctx::ASTContext, template::ClassTemplateDecl,
                                         args::TemplateArgumentList,
                                         prev_decl::ClassTemplateSpecializationDecl=ClassTemplateSpecializationDecl(C_NULL))
    tdecl = getTemplatedDecl(template)
    tk = getTagKind(tdecl)
    dc_ctx = getDeclContext(template)
    start_loc = getBeginLoc(tdecl)
    id_loc = getLocation(template)
    return ClassTemplateSpecializationDecl(ctx, tk, dc_ctx, start_loc, id_loc, template,
                                           args, prev_decl)
end

function AddSpecialization(x::AbstractClassTemplateDecl,
                           ctsd::ClassTemplateSpecializationDecl, insert_pos=C_NULL)
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
    return specializedOnPartial(x) ? ClassTemplatePartialSpecializationDecl(ptr) :
           ClassTemplateDecl(ptr)
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
    return ClassTemplatePartialSpecializationDecl(
        clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMember(x))
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
    return specializedOnPartial(x) ? VarTemplatePartialSpecializationDecl(ptr) :
           VarTemplateDecl(ptr)
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
    @assert ty != C_NULL "the partial specialization has no type set"
    @assert is_injected_class_name_type(Type_(ty)) "type-decl-type must be an InjectedClassNameType"
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
    return [TemplateArgument(clang_RedeclarableTemplateDecl_getInjectedTemplateArg(x, i))
            for i = 0:(n - 1)]
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
