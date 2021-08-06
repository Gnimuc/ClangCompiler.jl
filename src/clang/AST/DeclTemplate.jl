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
