# TemplateArgument
function TemplateArgument(x::QualType, is_null::Bool=false)
    return TemplateArgument(clang_TemplateArgument_constructFromQualType(x, is_null))
end

dispose(x::TemplateArgument) = clang_TemplateArgument_dispose(x)

function getKind(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_getKind(x)
end

function isNull(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isNull(x)
end

function isDependent(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isDependent(x)
end

function isInstantiationDependent(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_isInstantiationDependent(x)
end

function getAsType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getAsType(x))
end

function getParamTypeForDecl(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getParamTypeForDecl(x))
end

function getNullPtrType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getNullPtrType(x))
end

function getAsTemplate(x::TemplateArgument)
    @check_ptrs x
    return TemplateName(clang_TemplateArgument_getAsTemplate(x))
end

function getAsTemplateOrTemplatePattern(x::TemplateArgument)
    @check_ptrs x
    return TemplateName(clang_TemplateArgument_getAsTemplateOrTemplatePattern(x))
end

function getNumTemplateExpansions(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_getNumTemplateExpansions(x)
end

function getAsIntegral(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_getAsIntegral(x)
end

function getIntegralType(x::TemplateArgument)
    @check_ptrs x
    return QualType(clang_TemplateArgument_getIntegralType(x))
end

function setIntegralType(x::TemplateArgument, ty::QualType)
    @check_ptrs x
    return clang_TemplateArgument_setIntegralType(x, ty)
end

function dump(x::TemplateArgument)
    @check_ptrs x
    return clang_TemplateArgument_dump(x)
end

function getAsDecl(x::TemplateArgument)
    @check_ptrs x
    return ValueDecl(clang_TemplateArgument_getAsDecl(x))
end

function TemplateArgument(decl::ValueDecl, ty::QualType)
    @check_ptrs decl
    return TemplateArgument(clang_TemplateArgument_constructFromValueDecl(decl, ty))
end

function TemplateArgument(ctx::ASTContext, v::LLVM.GenericValue, ty::QualType)
    @check_ptrs ctx
    return TemplateArgument(clang_TemplateArgument_constructFromIntegral(ctx, v, ty))
end
