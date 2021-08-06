"""
    struct TemplateParameterList <: Any
Holds a pointer to a `clang::TemplateParameterList` object.
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

function size(x::TemplateParameterList)
    @assert x.ptr != C_NULL "TemplateParameterList has a NULL pointer."
    return clang_TemplateParameterList_size(x.ptr)
end

function get_described_template_params(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return TemplateParameterList(clang_Decl_getDescribedTemplateParams(x.ptr))
end

"""
    abstract type AbstractTemplateDecl <: AbstractNamedDecl
Supertype for `TemplateDecl`s.
"""
abstract type AbstractTemplateDecl <: AbstractNamedDecl end

"""
    struct TemplateDecl <: AbstractTypeDecl
Holds a pointer to a `clang::TypeDecl` object.
"""
struct TemplateDecl <: AbstractTypeDecl
    ptr::CXTemplateDecl
end

function init(x::TemplateDecl, nd::NamedDecl, tp::TemplateParameterList)
    @assert x.ptr != C_NULL "TemplateDecl has a NULL pointer."
    @assert nd.ptr != C_NULL "NamedDecl has a NULL pointer."
    @assert tp.ptr != C_NULL "TemplateParameterList has a NULL pointer."
    return clang_TemplateDecl_init(x.ptr, nd.ptr, tp.ptr)
end
