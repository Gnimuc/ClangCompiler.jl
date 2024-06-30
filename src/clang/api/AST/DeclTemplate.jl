# TemplateParameterList
function getNumTemplateParameterLists(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TypeDecl_getNumTemplateParameterLists(x)
end

function getTemplateParameterList(x::AbstractTagDecl, i::Integer)
    @check_ptrs x
    return TemplateParameterList(clang_TypeDecl_getTemplateParameterList(x, i))
end

function getParam(x::TemplateParameterList, i::Integer)
    @check_ptrs x
    return NamedDecl(clang_TemplateParameterList_getParam(x, i))
end

function Base.size(x::TemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_size(x)
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

function data(x::TemplateArgumentList)
    @check_ptrs x
    return clang_TemplateArgumentList_data(x)
end

function Base.get(x::TemplateArgumentList, i::Integer)
    @check_ptrs x
    return clang_TemplateArgumentList_get(x, i)
end

# TemplateDecl
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

function getTemplatedDecl(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_ClassTemplateDecl_getTemplatedDecl(x))
end

function isThisDeclarationADefinition(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return clang_ClassTemplateDecl_isThisDeclarationADefinition(x)
end

function findSpecialization(x::AbstractRedeclarableTemplateDecl, list::TemplateArgumentList,
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

function getTemplateArgs(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_ClassTemplateSpecializationDecl_getTemplateArgs(x))
end

function setTemplateArgs(x::AbstractClassTemplateDecl, list::TemplateArgumentList)
    @check_ptrs x list
    return clang_ClassTemplateSpecializationDecl_setTemplateArgs(x, list)
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

function AddSpecialization(x::AbstractRedeclarableTemplateDecl,
                           ctsd::ClassTemplateSpecializationDecl, insert_pos=C_NULL)
    @check_ptrs x ctsd
    return clang_ClassTemplateDecl_AddSpecialization(x, ctsd, insert_pos)
end
