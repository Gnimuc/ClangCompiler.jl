"""
    TemplateName <: Any
Represent a template name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::TemplateName` object.
Instead, it's the opaque pointer representation of the `clang::TemplateName` itself.
"""
struct TemplateName <: AbstractTemplateName
    ptr::CXTemplateName
end

# The four arms of clang::UncommonTemplateNameStorage and the two FoldingSetNode name
# classes a TemplateName can point at. None of them is an AST node; each is a small
# ASTContext-owned record, so the carriers are borrowed and never disposed.
abstract type AbstractUncommonTemplateNameStorage end
abstract type AbstractOverloadedTemplateStorage <: AbstractUncommonTemplateNameStorage end
abstract type AbstractAssumedTemplateStorage <: AbstractUncommonTemplateNameStorage end
abstract type AbstractSubstTemplateTemplateParmStorage <: AbstractUncommonTemplateNameStorage end
abstract type AbstractSubstTemplateTemplateParmPackStorage <: AbstractUncommonTemplateNameStorage end
abstract type AbstractQualifiedTemplateName end
abstract type AbstractDependentTemplateName end

"""
    OverloadedTemplateStorage <: AbstractOverloadedTemplateStorage
Hold a pointer to a `clang::OverloadedTemplateStorage` object.
"""
struct OverloadedTemplateStorage <: AbstractOverloadedTemplateStorage
    ptr::CXOverloadedTemplateStorage
end

"""
    AssumedTemplateStorage <: AbstractAssumedTemplateStorage
Hold a pointer to a `clang::AssumedTemplateStorage` object.
"""
struct AssumedTemplateStorage <: AbstractAssumedTemplateStorage
    ptr::CXAssumedTemplateStorage
end

"""
    SubstTemplateTemplateParmStorage <: AbstractSubstTemplateTemplateParmStorage
Hold a pointer to a `clang::SubstTemplateTemplateParmStorage` object.
"""
struct SubstTemplateTemplateParmStorage <: AbstractSubstTemplateTemplateParmStorage
    ptr::CXSubstTemplateTemplateParmStorage
end

"""
    SubstTemplateTemplateParmPackStorage <: AbstractSubstTemplateTemplateParmPackStorage
Hold a pointer to a `clang::SubstTemplateTemplateParmPackStorage` object.
"""
struct SubstTemplateTemplateParmPackStorage <: AbstractSubstTemplateTemplateParmPackStorage
    ptr::CXSubstTemplateTemplateParmPackStorage
end

"""
    QualifiedTemplateName <: AbstractQualifiedTemplateName
Hold a pointer to a `clang::QualifiedTemplateName` object.
"""
struct QualifiedTemplateName <: AbstractQualifiedTemplateName
    ptr::CXQualifiedTemplateName
end

"""
    DependentTemplateName <: AbstractDependentTemplateName
Hold a pointer to a `clang::DependentTemplateName` object.
"""
struct DependentTemplateName <: AbstractDependentTemplateName
    ptr::CXDependentTemplateName
end

