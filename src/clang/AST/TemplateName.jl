"""
    TemplateName <: Any
Represent a template name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::TemplateName` object.
Instead, it's the opaque pointer representation of the `clang::TemplateName` itself.
"""
struct TemplateName
    ptr::CXTemplateName
end

is_null(x::TemplateName) = clang_TemplateName_isNull(x.ptr)

get_kind(x::TemplateName) = clang_TemplateName_getKind(x.ptr)

get_underlying(x::TemplateName) = TemplateName(clang_TemplateName_getUnderlying(x.ptr))

get_name_to_substitute(x::TemplateName) = TemplateName(clang_TemplateName_getNameToSubstitute(x.ptr))

is_dependent(x::TemplateName) = clang_TemplateName_isDependent(x.ptr)

is_instantiation_dependent(x::TemplateName) = clang_TemplateName_isInstantiationDependent(x.ptr)

contains_unexpanded_parameter_pack(x::TemplateName) = clang_TemplateName_containsUnexpandedParameterPack(x.ptr)

dump(x::TemplateName) = clang_TemplateName_dump(x.ptr)

function get_template_name(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return TemplateName(clang_TemplateSpecializationType_getTemplateName(x.ptr))
end
