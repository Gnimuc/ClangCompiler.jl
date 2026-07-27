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

