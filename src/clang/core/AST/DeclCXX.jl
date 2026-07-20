"""
    struct AccessSpecDecl <: AbstractAccessSpecDecl
Hold a pointer to a `clang::AccessSpecDecl` object.
"""
struct AccessSpecDecl <: AbstractAccessSpecDecl
    ptr::CXAccessSpecDecl
end

Base.unsafe_convert(::Type{CXAccessSpecDecl}, x::AccessSpecDecl) = x.ptr
Base.cconvert(::Type{CXAccessSpecDecl}, x::AccessSpecDecl) = x

"""
    struct CXXRecordDecl <: AbstractCXXRecordDecl
Hold a pointer to a `clang::CXXRecordDecl` object.
"""
struct CXXRecordDecl <: AbstractCXXRecordDecl
    ptr::CXCXXRecordDecl
end

Base.unsafe_convert(::Type{CXCXXRecordDecl}, x::CXXRecordDecl) = x.ptr
Base.cconvert(::Type{CXCXXRecordDecl}, x::CXXRecordDecl) = x

"""
    struct CXXDeductionGuideDecl <: AbstractCXXDeductionGuideDecl
Hold a pointer to a `clang::CXXDeductionGuideDecl` object.
"""
struct CXXDeductionGuideDecl <: AbstractCXXDeductionGuideDecl
    ptr::CXCXXDeductionGuideDecl
end

Base.unsafe_convert(::Type{CXCXXDeductionGuideDecl}, x::CXXDeductionGuideDecl) = x.ptr
Base.cconvert(::Type{CXCXXDeductionGuideDecl}, x::CXXDeductionGuideDecl) = x

"""
    struct RequiresExprBodyDecl <: AbstractRequiresExprBodyDecl
Hold a pointer to a `clang::RequiresExprBodyDecl` object.
"""
struct RequiresExprBodyDecl <: AbstractRequiresExprBodyDecl
    ptr::CXRequiresExprBodyDecl
end

Base.unsafe_convert(::Type{CXRequiresExprBodyDecl}, x::RequiresExprBodyDecl) = x.ptr
Base.cconvert(::Type{CXRequiresExprBodyDecl}, x::RequiresExprBodyDecl) = x

"""
    struct CXXMethodDecl <: AbstractCXXMethodDecl
Hold a pointer to a `clang::CXXMethodDecl` object.
"""
struct CXXMethodDecl <: AbstractCXXMethodDecl
    ptr::CXCXXMethodDecl
end

Base.unsafe_convert(::Type{CXCXXMethodDecl}, x::CXXMethodDecl) = x.ptr
Base.cconvert(::Type{CXCXXMethodDecl}, x::CXXMethodDecl) = x

"""
    struct CXXConstructorDecl <: AbstractCXXConstructorDecl
Hold a pointer to a `clang::CXXConstructorDecl` object.
"""
struct CXXConstructorDecl <: AbstractCXXConstructorDecl
    ptr::CXCXXConstructorDecl
end

Base.unsafe_convert(::Type{CXCXXConstructorDecl}, x::CXXConstructorDecl) = x.ptr
Base.cconvert(::Type{CXCXXConstructorDecl}, x::CXXConstructorDecl) = x

"""
    struct CXXDestructorDecl <: AbstractCXXDestructorDecl
Hold a pointer to a `clang::CXXDestructorDecl` object.
"""
struct CXXDestructorDecl <: AbstractCXXDestructorDecl
    ptr::CXCXXDestructorDecl
end

Base.unsafe_convert(::Type{CXCXXDestructorDecl}, x::CXXDestructorDecl) = x.ptr
Base.cconvert(::Type{CXCXXDestructorDecl}, x::CXXDestructorDecl) = x

"""
    struct CXXConversionDecl <: AbstractCXXConversionDecl
Hold a pointer to a `clang::CXXConversionDecl` object.
"""
struct CXXConversionDecl <: AbstractCXXConversionDecl
    ptr::CXCXXConversionDecl
end

Base.unsafe_convert(::Type{CXCXXConversionDecl}, x::CXXConversionDecl) = x.ptr
Base.cconvert(::Type{CXCXXConversionDecl}, x::CXXConversionDecl) = x

"""
    struct LinkageSpecDecl <: AbstractLinkageSpecDecl
Hold a pointer to a `clang::LinkageSpecDecl` object.
"""
struct LinkageSpecDecl <: AbstractLinkageSpecDecl
    ptr::CXLinkageSpecDecl
end

Base.unsafe_convert(::Type{CXLinkageSpecDecl}, x::LinkageSpecDecl) = x.ptr
Base.cconvert(::Type{CXLinkageSpecDecl}, x::LinkageSpecDecl) = x

"""
    struct UsingDirectiveDecl <: AbstractUsingDirectiveDecl
Hold a pointer to a `clang::UsingDirectiveDecl` object.
"""
struct UsingDirectiveDecl <: AbstractUsingDirectiveDecl
    ptr::CXUsingDirectiveDecl
end

Base.unsafe_convert(::Type{CXUsingDirectiveDecl}, x::UsingDirectiveDecl) = x.ptr
Base.cconvert(::Type{CXUsingDirectiveDecl}, x::UsingDirectiveDecl) = x

"""
    struct NamespaceAliasDecl <: AbstractNamespaceAliasDecl
Hold a pointer to a `clang::NamespaceAliasDecl` object.
"""
struct NamespaceAliasDecl <: AbstractNamespaceAliasDecl
    ptr::CXNamespaceAliasDecl
end

Base.unsafe_convert(::Type{CXNamespaceAliasDecl}, x::NamespaceAliasDecl) = x.ptr
Base.cconvert(::Type{CXNamespaceAliasDecl}, x::NamespaceAliasDecl) = x

"""
    struct LifetimeExtendedTemporaryDecl <: AbstractLifetimeExtendedTemporaryDecl
Hold a pointer to a `clang::LifetimeExtendedTemporaryDecl` object.
"""
struct LifetimeExtendedTemporaryDecl <: AbstractLifetimeExtendedTemporaryDecl
    ptr::CXLifetimeExtendedTemporaryDecl
end

Base.unsafe_convert(::Type{CXLifetimeExtendedTemporaryDecl}, x::LifetimeExtendedTemporaryDecl) = x.ptr
Base.cconvert(::Type{CXLifetimeExtendedTemporaryDecl}, x::LifetimeExtendedTemporaryDecl) = x

"""
    struct UsingShadowDecl <: AbstractUsingShadowDecl
Hold a pointer to a `clang::UsingShadowDecl` object.
"""
struct UsingShadowDecl <: AbstractUsingShadowDecl
    ptr::CXUsingShadowDecl
end

Base.unsafe_convert(::Type{CXUsingShadowDecl}, x::UsingShadowDecl) = x.ptr
Base.cconvert(::Type{CXUsingShadowDecl}, x::UsingShadowDecl) = x

"""
    struct ConstructorUsingShadowDecl <: AbstractConstructorUsingShadowDecl
Hold a pointer to a `clang::ConstructorUsingShadowDecl` object.
"""
struct ConstructorUsingShadowDecl <: AbstractConstructorUsingShadowDecl
    ptr::CXConstructorUsingShadowDecl
end

Base.unsafe_convert(::Type{CXConstructorUsingShadowDecl}, x::ConstructorUsingShadowDecl) = x.ptr
Base.cconvert(::Type{CXConstructorUsingShadowDecl}, x::ConstructorUsingShadowDecl) = x

"""
    struct UsingDecl <: AbstractUsingDecl
Hold a pointer to a `clang::UsingDecl` object.
"""
struct UsingDecl <: AbstractUsingDecl
    ptr::CXUsingDecl
end

Base.unsafe_convert(::Type{CXUsingDecl}, x::UsingDecl) = x.ptr
Base.cconvert(::Type{CXUsingDecl}, x::UsingDecl) = x

"""
    struct UsingPackDecl <: AbstractUsingPackDecl
Hold a pointer to a `clang::UsingPackDecl` object.
"""
struct UsingPackDecl <: AbstractUsingPackDecl
    ptr::CXUsingPackDecl
end

Base.unsafe_convert(::Type{CXUsingPackDecl}, x::UsingPackDecl) = x.ptr
Base.cconvert(::Type{CXUsingPackDecl}, x::UsingPackDecl) = x

"""
    struct UnresolvedUsingValueDecl <: AbstractUnresolvedUsingValueDecl
Hold a pointer to a `clang::UnresolvedUsingValueDecl` object.
"""
struct UnresolvedUsingValueDecl <: AbstractUnresolvedUsingValueDecl
    ptr::CXUnresolvedUsingValueDecl
end

Base.unsafe_convert(::Type{CXUnresolvedUsingValueDecl}, x::UnresolvedUsingValueDecl) = x.ptr
Base.cconvert(::Type{CXUnresolvedUsingValueDecl}, x::UnresolvedUsingValueDecl) = x

"""
    struct UnresolvedUsingTypenameDecl <: AbstractUnresolvedUsingTypenameDecl
Hold a pointer to a `clang::UnresolvedUsingTypenameDecl` object.
"""
struct UnresolvedUsingTypenameDecl <: AbstractUnresolvedUsingTypenameDecl
    ptr::CXUnresolvedUsingTypenameDecl
end

Base.unsafe_convert(::Type{CXUnresolvedUsingTypenameDecl}, x::UnresolvedUsingTypenameDecl) = x.ptr
Base.cconvert(::Type{CXUnresolvedUsingTypenameDecl}, x::UnresolvedUsingTypenameDecl) = x

"""
    struct StaticAssertDecl <: AbstractStaticAssertDecl
Hold a pointer to a `clang::StaticAssertDecl` object.
"""
struct StaticAssertDecl <: AbstractStaticAssertDecl
    ptr::CXStaticAssertDecl
end

Base.unsafe_convert(::Type{CXStaticAssertDecl}, x::StaticAssertDecl) = x.ptr
Base.cconvert(::Type{CXStaticAssertDecl}, x::StaticAssertDecl) = x

"""
    struct BindingDecl <: AbstractBindingDecl
Hold a pointer to a `clang::BindingDecl` object.
"""
struct BindingDecl <: AbstractBindingDecl
    ptr::CXBindingDecl
end

Base.unsafe_convert(::Type{CXBindingDecl}, x::BindingDecl) = x.ptr
Base.cconvert(::Type{CXBindingDecl}, x::BindingDecl) = x

"""
    struct DecompositionDecl <: AbstractDecompositionDecl
Hold a pointer to a `clang::DecompositionDecl` object.
"""
struct DecompositionDecl <: AbstractDecompositionDecl
    ptr::CXDecompositionDecl
end

Base.unsafe_convert(::Type{CXDecompositionDecl}, x::DecompositionDecl) = x.ptr
Base.cconvert(::Type{CXDecompositionDecl}, x::DecompositionDecl) = x

"""
    struct MSPropertyDecl <: AbstractMSPropertyDecl
Hold a pointer to a `clang::MSPropertyDecl` object.
"""
struct MSPropertyDecl <: AbstractMSPropertyDecl
    ptr::CXMSPropertyDecl
end

Base.unsafe_convert(::Type{CXMSPropertyDecl}, x::MSPropertyDecl) = x.ptr
Base.cconvert(::Type{CXMSPropertyDecl}, x::MSPropertyDecl) = x

"""
    struct MSGuidDecl <: AbstractMSGuidDecl
Hold a pointer to a `clang::MSGuidDecl` object.
"""
struct MSGuidDecl <: AbstractMSGuidDecl
    ptr::CXMSGuidDecl
end

Base.unsafe_convert(::Type{CXMSGuidDecl}, x::MSGuidDecl) = x.ptr
Base.cconvert(::Type{CXMSGuidDecl}, x::MSGuidDecl) = x

# Standalone value classes (no AST-node hierarchy): a base-class edge in a
# CXXRecordDecl, and the explicit(...) specifier on a constructor/conversion.
"""
    struct CXXBaseSpecifier <: AbstractCXXBaseSpecifier
Hold a pointer to a `clang::CXXBaseSpecifier` object.
"""
struct CXXBaseSpecifier <: AbstractCXXBaseSpecifier
    ptr::CXCXXBaseSpecifier
end

Base.unsafe_convert(::Type{CXCXXBaseSpecifier}, x::CXXBaseSpecifier) = x.ptr
Base.cconvert(::Type{CXCXXBaseSpecifier}, x::CXXBaseSpecifier) = x

"""
    struct CXXCtorInitializer <: AbstractCXXCtorInitializer
Hold a pointer to a `clang::CXXCtorInitializer` object.
"""
struct CXXCtorInitializer <: AbstractCXXCtorInitializer
    ptr::CXCXXCtorInitializer
end

Base.unsafe_convert(::Type{CXCXXCtorInitializer}, x::CXXCtorInitializer) = x.ptr
Base.cconvert(::Type{CXCXXCtorInitializer}, x::CXXCtorInitializer) = x

"""
    struct ExplicitSpecifier <: AbstractExplicitSpecifier
Hold a pointer to a `clang::ExplicitSpecifier` object.
"""
struct ExplicitSpecifier <: AbstractExplicitSpecifier
    ptr::CXExplicitSpecifier
end

Base.unsafe_convert(::Type{CXExplicitSpecifier}, x::ExplicitSpecifier) = x.ptr
Base.cconvert(::Type{CXExplicitSpecifier}, x::ExplicitSpecifier) = x
