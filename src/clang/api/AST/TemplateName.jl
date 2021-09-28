# TemplateName
isNull(x::TemplateName) = clang_TemplateName_isNull(x)

getKind(x::TemplateName) = clang_TemplateName_getKind(x)

getUnderlying(x::TemplateName) = TemplateName(clang_TemplateName_getUnderlying(x))

getNameToSubstitute(x::TemplateName) = TemplateName(clang_TemplateName_getNameToSubstitute(x))

isDependent(x::TemplateName) = clang_TemplateName_isDependent(x)

isInstantiationDependent(x::TemplateName) = clang_TemplateName_isInstantiationDependent(x)

containsUnexpandedParameterPack(x::TemplateName) = clang_TemplateName_containsUnexpandedParameterPack(x)

dump(x::TemplateName) = clang_TemplateName_dump(x)

function getTemplateName(x::TemplateSpecializationType)
    return TemplateName(clang_TemplateSpecializationType_getTemplateName(get_type_ptr(x)))
end
