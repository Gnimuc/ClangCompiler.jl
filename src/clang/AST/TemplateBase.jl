"""
    struct TemplateArgument <: Any
Hold a pointer to a `clang::TemplateArgument` object.
"""
struct TemplateArgument
    ptr::CXTemplateArgument
end

function TemplateArgument(x::AbstractQualType, is_null::Bool=false)
    return TemplateArgument(clang_TemplateArgument_constructFromQualType(x.ptr, is_null))
end

dispose(x::TemplateArgument) = clang_TemplateArgument_dispose(x.ptr)

function get_kind(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_getKind(x.ptr)
end

function is_null(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_isNull(x.ptr)
end

function is_dependent(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_isDependent(x.ptr)
end

function is_instantiation_dependent(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_isInstantiationDependent(x.ptr)
end

function get_as_type(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return QualType(clang_TemplateArgument_getAsType(x.ptr))
end

function get_parameter_type_for_decl(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return QualType(clang_TemplateArgument_getParamTypeForDecl(x.ptr))
end

function get_null_ptr_type(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return QualType(clang_TemplateArgument_getNullPtrType(x.ptr))
end

function get_as_template(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return TemplateName(clang_TemplateArgument_getAsTemplate(x.ptr))
end

function get_as_template_or_template_pattern(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return TemplateName(clang_TemplateArgument_getAsTemplateOrTemplatePattern(x.ptr))
end

function get_num_template_expansions(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_getNumTemplateExpansions(x.ptr)
end

function get_as_integral(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_getAsIntegral(x.ptr)
end

function get_integral_type(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return QualType(clang_TemplateArgument_getIntegralType(x.ptr))
end

function set_integral_type(x::TemplateArgument, ty::AbstractQualType)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_setIntegralType(x.ptr, ty.ptr)
end

function dump(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return clang_TemplateArgument_dump(x.ptr)
end

function get_arg(x::TemplateSpecializationType, i::Integer)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return TemplateArgument(clang_TemplateSpecializationType_getArg(x.ptr, i))
end

get_template_args(x::TemplateSpecializationType) = [get_arg(x, i) for i = 0:get_num_args(x)-1]
