"""
    struct TemplateParameterList <: Any
Hold a pointer to a `clang::TemplateParameterList` object.
"""
struct TemplateParameterList
    ptr::CXTemplateParameterList
end

function get_num_template_parameter_lists(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_getNumTemplateParameterLists(x.ptr)
end

function get_template_parameter_list(x::AbstractTagDecl, i::Integer)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TemplateParameterList(clang_TypeDecl_getTemplateParameterList(x.ptr, i))
end

function get_param(x::TemplateParameterList, i::Integer)
    @assert x.ptr != C_NULL "TemplateParameterList has a NULL pointer."
    return NamedDecl(clang_TemplateParameterList_getParam(x.ptr, i))
end

function Base.size(x::TemplateParameterList)
    @assert x.ptr != C_NULL "TemplateParameterList has a NULL pointer."
    return clang_TemplateParameterList_size(x.ptr)
end

function get_described_template_params(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
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
    @assert x.ptr != C_NULL "TemplateArgumentList has a NULL pointer."
    return clang_TemplateArgumentList_size(x.ptr)
end

function data(x::TemplateArgumentList)
    @assert x.ptr != C_NULL "TemplateArgumentList has a NULL pointer."
    return clang_TemplateArgumentList_data(x.ptr)
end

function get(x::TemplateArgumentList, i::Integer)
    @assert x.ptr != C_NULL "TemplateArgumentList has a NULL pointer."
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
    @assert x.ptr != C_NULL "TemplateDecl has a NULL pointer."
    @assert nd.ptr != C_NULL "NamedDecl has a NULL pointer."
    @assert tp.ptr != C_NULL "TemplateParameterList has a NULL pointer."
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
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    return RedeclarableTemplateDecl(clang_RedeclarableTemplateDecl_getCanonicalDecl(x.ptr))
end

function is_member_specialization(x::AbstractRedeclarableTemplateDecl)
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    return clang_RedeclarableTemplateDecl_isMemberSpecialization(x.ptr)
end

function set_member_specialization(x::AbstractRedeclarableTemplateDecl)
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    return clang_RedeclarableTemplateDecl_setMemberSpecialization(x.ptr)
end

function get_template_decl(x::AbstractRedeclarableTemplateDecl)
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    return CXXRecordDecl(clang_ClassTemplateDecl_getTemplatedDecl(x.ptr))
end

function is_definition(x::AbstractRedeclarableTemplateDecl)
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    return clang_ClassTemplateDecl_isThisDeclarationADefinition(x.ptr)
end

function find_specialization(x::AbstractRedeclarableTemplateDecl,
                             list::TemplateArgumentList, insert_pos=C_NULL)
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    @assert list.ptr != C_NULL "TemplateArgumentList has a NULL pointer."
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
    @assert x.ptr != C_NULL "ClassTemplateDecl has a NULL pointer."
    return ClassTemplateDecl(clang_ClassTemplateDecl_getCanonicalDecl(x.ptr))
end

function get_template_args(x::AbstractClassTemplateDecl)
    @assert x.ptr != C_NULL "ClassTemplateDecl has a NULL pointer."
    return TemplateArgumentList(clang_ClassTemplateSpecializationDecl_getTemplateArgs(x.ptr))
end

function set_template_args(x::AbstractClassTemplateDecl, list::TemplateArgumentList)
    @assert x.ptr != C_NULL "ClassTemplateDecl has a NULL pointer."
    @assert list.ptr != C_NULL "TemplateArgumentList has a NULL pointer."
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
    @assert x.ptr != C_NULL "RedeclarableTemplateDecl has a NULL pointer."
    @assert ctsd.ptr != C_NULL "ClassTemplateSpecializationDecl has a NULL pointer."
    return clang_ClassTemplateDecl_AddSpecialization(x.ptr, ctsd.ptr, insert_pos)
end
