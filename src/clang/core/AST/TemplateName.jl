"""
    TemplateName <: Any
Represent a template name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::TemplateName` object.
Instead, it's the opaque pointer representation of the `clang::TemplateName` itself.
"""
struct TemplateName <: AbstractTemplateName
    ptr::CXTemplateName
end

Base.unsafe_convert(::Type{CXTemplateName}, x::TemplateName) = x.ptr
Base.cconvert(::Type{CXTemplateName}, x::TemplateName) = x

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

Base.unsafe_convert(::Type{CXOverloadedTemplateStorage}, x::OverloadedTemplateStorage) = x.ptr
Base.cconvert(::Type{CXOverloadedTemplateStorage}, x::OverloadedTemplateStorage) = x

"""
    AssumedTemplateStorage <: AbstractAssumedTemplateStorage
Hold a pointer to a `clang::AssumedTemplateStorage` object.
"""
struct AssumedTemplateStorage <: AbstractAssumedTemplateStorage
    ptr::CXAssumedTemplateStorage
end

Base.unsafe_convert(::Type{CXAssumedTemplateStorage}, x::AssumedTemplateStorage) = x.ptr
Base.cconvert(::Type{CXAssumedTemplateStorage}, x::AssumedTemplateStorage) = x

"""
    SubstTemplateTemplateParmStorage <: AbstractSubstTemplateTemplateParmStorage
Hold a pointer to a `clang::SubstTemplateTemplateParmStorage` object.
"""
struct SubstTemplateTemplateParmStorage <: AbstractSubstTemplateTemplateParmStorage
    ptr::CXSubstTemplateTemplateParmStorage
end

function Base.unsafe_convert(::Type{CXSubstTemplateTemplateParmStorage},
                             x::SubstTemplateTemplateParmStorage)
    return x.ptr
end
Base.cconvert(::Type{CXSubstTemplateTemplateParmStorage}, x::SubstTemplateTemplateParmStorage) = x

"""
    SubstTemplateTemplateParmPackStorage <: AbstractSubstTemplateTemplateParmPackStorage
Hold a pointer to a `clang::SubstTemplateTemplateParmPackStorage` object.
"""
struct SubstTemplateTemplateParmPackStorage <: AbstractSubstTemplateTemplateParmPackStorage
    ptr::CXSubstTemplateTemplateParmPackStorage
end

function Base.unsafe_convert(::Type{CXSubstTemplateTemplateParmPackStorage},
                             x::SubstTemplateTemplateParmPackStorage)
    return x.ptr
end
function Base.cconvert(::Type{CXSubstTemplateTemplateParmPackStorage},
                       x::SubstTemplateTemplateParmPackStorage)
    return x
end

"""
    QualifiedTemplateName <: AbstractQualifiedTemplateName
Hold a pointer to a `clang::QualifiedTemplateName` object.
"""
struct QualifiedTemplateName <: AbstractQualifiedTemplateName
    ptr::CXQualifiedTemplateName
end

Base.unsafe_convert(::Type{CXQualifiedTemplateName}, x::QualifiedTemplateName) = x.ptr
Base.cconvert(::Type{CXQualifiedTemplateName}, x::QualifiedTemplateName) = x

"""
    DependentTemplateName <: AbstractDependentTemplateName
Hold a pointer to a `clang::DependentTemplateName` object.
"""
struct DependentTemplateName <: AbstractDependentTemplateName
    ptr::CXDependentTemplateName
end

Base.unsafe_convert(::Type{CXDependentTemplateName}, x::DependentTemplateName) = x.ptr
Base.cconvert(::Type{CXDependentTemplateName}, x::DependentTemplateName) = x
