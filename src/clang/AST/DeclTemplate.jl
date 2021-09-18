"""
    struct TemplateParameterList <: Any
Hold a pointer to a `clang::TemplateParameterList` object.
"""
struct TemplateParameterList
    ptr::CXTemplateParameterList
end

function get_num_template_parameter_lists(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TypeDecl_getNumTemplateParameterLists(x.ptr)
end

function get_template_parameter_list(x::AbstractTagDecl, i::Integer)
    @check_ptrs x
    return TemplateParameterList(clang_TypeDecl_getTemplateParameterList(x.ptr, i))
end

function get_param(x::TemplateParameterList, i::Integer)
    @check_ptrs x
    return NamedDecl(clang_TemplateParameterList_getParam(x.ptr, i))
end

function Base.size(x::TemplateParameterList)
    @check_ptrs x
    return clang_TemplateParameterList_size(x.ptr)
end

function get_described_template_params(x::AbstractDecl)
    @check_ptrs x
    return TemplateParameterList(clang_Decl_getDescribedTemplateParams(x.ptr))
end

"""
    struct TemplateArgumentList <: Any
Hold a pointer to a `clang::TemplateArgumentList` object.
"""
struct TemplateArgumentList
    ptr::CXTemplateArgumentList
end

function Base.size(x::TemplateArgumentList)
    @check_ptrs x
    return clang_TemplateArgumentList_size(x.ptr)
end

function data(x::TemplateArgumentList)
    @check_ptrs x
    return clang_TemplateArgumentList_data(x.ptr)
end

function get(x::TemplateArgumentList, i::Integer)
    @check_ptrs x
    return clang_TemplateArgumentList_get(x.ptr, i)
end

"""
    abstract type AbstractTemplateDecl <: AbstractNamedDecl
Supertype for `TemplateDecl`s.
"""
abstract type AbstractTemplateDecl <: AbstractNamedDecl end

"""
    struct TemplateDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::TemplateDecl` object.
"""
struct TemplateDecl <: AbstractTemplateDecl
    ptr::CXTemplateDecl
end

function init(x::AbstractTemplateDecl, nd::NamedDecl, tp::TemplateParameterList)
    @check_ptrs x nd tp
    return clang_TemplateDecl_init(x.ptr, nd.ptr, tp.ptr)
end

get_as_template_decl(x::TemplateName) = TemplateDecl(clang_TemplateName_getAsTemplateDecl(x.ptr))

"""
    abstract type AbstractRedeclarableTemplateDecl <: AbstractTemplateDecl
Supertype for `RedeclarableTemplateDecl`s.
"""
abstract type AbstractRedeclarableTemplateDecl <: AbstractTemplateDecl end

"""
    struct RedeclarableTemplateDecl <: AbstractRedeclarableTemplateDecl
Hold a pointer to a `clang::RedeclarableTemplateDecl` object.
"""
struct RedeclarableTemplateDecl <: AbstractRedeclarableTemplateDecl
    ptr::CXRedeclarableTemplateDecl
end

function get_canonical_decl(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return RedeclarableTemplateDecl(clang_RedeclarableTemplateDecl_getCanonicalDecl(x.ptr))
end

function is_member_specialization(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return clang_RedeclarableTemplateDecl_isMemberSpecialization(x.ptr)
end

function set_member_specialization(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return clang_RedeclarableTemplateDecl_setMemberSpecialization(x.ptr)
end

function get_template_decl(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return CXXRecordDecl(clang_ClassTemplateDecl_getTemplatedDecl(x.ptr))
end

function is_definition(x::AbstractRedeclarableTemplateDecl)
    @check_ptrs x
    return clang_ClassTemplateDecl_isThisDeclarationADefinition(x.ptr)
end

function find_specialization(x::AbstractRedeclarableTemplateDecl,
                             list::TemplateArgumentList, insert_pos=C_NULL)
    @check_ptrs x list
    return ClassTemplateSpecializationDecl(clang_ClassTemplateDecl_findSpecialization(x.ptr,
                                                                                      list.ptr,
                                                                                      insert_pos))
end

"""
    abstract type AbstractClassTemplateDecl <: AbstractRedeclarableTemplateDecl
Supertype for `ClassTemplateDecl`s.
"""
abstract type AbstractClassTemplateDecl <: AbstractRedeclarableTemplateDecl end

"""
    struct ClassTemplateDecl <: AbstractClassTemplateDecl
Hold a pointer to a `clang::ClassTemplateDecl` object.
"""
struct ClassTemplateDecl <: AbstractClassTemplateDecl
    ptr::CXClassTemplateDecl
end

function get_canonical_decl(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_ClassTemplateDecl_getCanonicalDecl(x.ptr))
end

function get_template_args(x::AbstractClassTemplateDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_ClassTemplateSpecializationDecl_getTemplateArgs(x.ptr))
end

function set_template_args(x::AbstractClassTemplateDecl, list::TemplateArgumentList)
    @check_ptrs x list
    return clang_ClassTemplateSpecializationDecl_setTemplateArgs(x.ptr, list.ptr)
end

"""
    struct ClassTemplateSpecializationDecl <: AbstractCXXRecordDecl
Hold a pointer to a `clang::ClassTemplateSpecializationDecl` object.
"""
struct ClassTemplateSpecializationDecl <: AbstractCXXRecordDecl
    ptr::CXClassTemplateSpecializationDecl
end

function add_specialization(x::AbstractRedeclarableTemplateDecl,
                            ctsd::ClassTemplateSpecializationDecl, insert_pos=C_NULL)
    @check_ptrs x ctsd
    return clang_ClassTemplateDecl_AddSpecialization(x.ptr, ctsd.ptr, insert_pos)
end
