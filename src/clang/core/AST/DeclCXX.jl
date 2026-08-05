"""
    struct AccessSpecDecl <: AbstractAccessSpecDecl
Hold a pointer to a `clang::AccessSpecDecl` object.
"""
struct AccessSpecDecl <: AbstractAccessSpecDecl
    ptr::CXAccessSpecDecl
end

"""
    struct CXXRecordDecl <: AbstractCXXRecordDecl
Hold a pointer to a `clang::CXXRecordDecl` object.
"""
struct CXXRecordDecl <: AbstractCXXRecordDecl
    ptr::CXCXXRecordDecl
end

"""
    struct CXXDeductionGuideDecl <: AbstractCXXDeductionGuideDecl
Hold a pointer to a `clang::CXXDeductionGuideDecl` object.
"""
struct CXXDeductionGuideDecl <: AbstractCXXDeductionGuideDecl
    ptr::CXCXXDeductionGuideDecl
end

"""
    struct RequiresExprBodyDecl <: AbstractRequiresExprBodyDecl
Hold a pointer to a `clang::RequiresExprBodyDecl` object.
"""
struct RequiresExprBodyDecl <: AbstractRequiresExprBodyDecl
    ptr::CXRequiresExprBodyDecl
end

"""
    struct CXXMethodDecl <: AbstractCXXMethodDecl
Hold a pointer to a `clang::CXXMethodDecl` object.
"""
struct CXXMethodDecl <: AbstractCXXMethodDecl
    ptr::CXCXXMethodDecl
end

"""
    struct CXXConstructorDecl <: AbstractCXXConstructorDecl
Hold a pointer to a `clang::CXXConstructorDecl` object.
"""
struct CXXConstructorDecl <: AbstractCXXConstructorDecl
    ptr::CXCXXConstructorDecl
end

"""
    struct CXXDestructorDecl <: AbstractCXXDestructorDecl
Hold a pointer to a `clang::CXXDestructorDecl` object.
"""
struct CXXDestructorDecl <: AbstractCXXDestructorDecl
    ptr::CXCXXDestructorDecl
end

"""
    struct CXXConversionDecl <: AbstractCXXConversionDecl
Hold a pointer to a `clang::CXXConversionDecl` object.
"""
struct CXXConversionDecl <: AbstractCXXConversionDecl
    ptr::CXCXXConversionDecl
end

"""
    struct LinkageSpecDecl <: AbstractLinkageSpecDecl
Hold a pointer to a `clang::LinkageSpecDecl` object.
"""
struct LinkageSpecDecl <: AbstractLinkageSpecDecl
    ptr::CXLinkageSpecDecl
end

"""
    struct UsingDirectiveDecl <: AbstractUsingDirectiveDecl
Hold a pointer to a `clang::UsingDirectiveDecl` object.
"""
struct UsingDirectiveDecl <: AbstractUsingDirectiveDecl
    ptr::CXUsingDirectiveDecl
end

"""
    struct NamespaceAliasDecl <: AbstractNamespaceAliasDecl
Hold a pointer to a `clang::NamespaceAliasDecl` object.
"""
struct NamespaceAliasDecl <: AbstractNamespaceAliasDecl
    ptr::CXNamespaceAliasDecl
end

"""
    struct LifetimeExtendedTemporaryDecl <: AbstractLifetimeExtendedTemporaryDecl
Hold a pointer to a `clang::LifetimeExtendedTemporaryDecl` object.
"""
struct LifetimeExtendedTemporaryDecl <: AbstractLifetimeExtendedTemporaryDecl
    ptr::CXLifetimeExtendedTemporaryDecl
end

"""
    struct UsingShadowDecl <: AbstractUsingShadowDecl
Hold a pointer to a `clang::UsingShadowDecl` object.
"""
struct UsingShadowDecl <: AbstractUsingShadowDecl
    ptr::CXUsingShadowDecl
end

"""
    struct ConstructorUsingShadowDecl <: AbstractConstructorUsingShadowDecl
Hold a pointer to a `clang::ConstructorUsingShadowDecl` object.
"""
struct ConstructorUsingShadowDecl <: AbstractConstructorUsingShadowDecl
    ptr::CXConstructorUsingShadowDecl
end

"""
    struct UsingDecl <: AbstractUsingDecl
Hold a pointer to a `clang::UsingDecl` object.
"""
struct UsingDecl <: AbstractUsingDecl
    ptr::CXUsingDecl
end

"""
    struct UsingPackDecl <: AbstractUsingPackDecl
Hold a pointer to a `clang::UsingPackDecl` object.
"""
struct UsingPackDecl <: AbstractUsingPackDecl
    ptr::CXUsingPackDecl
end

"""
    struct UnresolvedUsingValueDecl <: AbstractUnresolvedUsingValueDecl
Hold a pointer to a `clang::UnresolvedUsingValueDecl` object.
"""
struct UnresolvedUsingValueDecl <: AbstractUnresolvedUsingValueDecl
    ptr::CXUnresolvedUsingValueDecl
end

"""
    struct UnresolvedUsingTypenameDecl <: AbstractUnresolvedUsingTypenameDecl
Hold a pointer to a `clang::UnresolvedUsingTypenameDecl` object.
"""
struct UnresolvedUsingTypenameDecl <: AbstractUnresolvedUsingTypenameDecl
    ptr::CXUnresolvedUsingTypenameDecl
end

"""
    struct StaticAssertDecl <: AbstractStaticAssertDecl
Hold a pointer to a `clang::StaticAssertDecl` object.
"""
struct StaticAssertDecl <: AbstractStaticAssertDecl
    ptr::CXStaticAssertDecl
end

"""
    struct BindingDecl <: AbstractBindingDecl
Hold a pointer to a `clang::BindingDecl` object.
"""
struct BindingDecl <: AbstractBindingDecl
    ptr::CXBindingDecl
end

"""
    struct DecompositionDecl <: AbstractDecompositionDecl
Hold a pointer to a `clang::DecompositionDecl` object.
"""
struct DecompositionDecl <: AbstractDecompositionDecl
    ptr::CXDecompositionDecl
end

"""
    struct MSPropertyDecl <: AbstractMSPropertyDecl
Hold a pointer to a `clang::MSPropertyDecl` object.
"""
struct MSPropertyDecl <: AbstractMSPropertyDecl
    ptr::CXMSPropertyDecl
end

"""
    struct MSGuidDecl <: AbstractMSGuidDecl
Hold a pointer to a `clang::MSGuidDecl` object.
"""
struct MSGuidDecl <: AbstractMSGuidDecl
    ptr::CXMSGuidDecl
end

# Standalone value classes (no AST-node hierarchy): a base-class edge in a
# CXXRecordDecl, and the explicit(...) specifier on a constructor/conversion.
"""
    struct CXXBaseSpecifier <: AbstractCXXBaseSpecifier
Hold a pointer to a `clang::CXXBaseSpecifier` object.
"""
struct CXXBaseSpecifier <: AbstractCXXBaseSpecifier
    ptr::CXCXXBaseSpecifier
end

"""
    struct CXXCtorInitializer <: AbstractCXXCtorInitializer
Hold a pointer to a `clang::CXXCtorInitializer` object.
"""
struct CXXCtorInitializer <: AbstractCXXCtorInitializer
    ptr::CXCXXCtorInitializer
end

"""
    struct ExplicitSpecifier <: AbstractExplicitSpecifier
Hold a pointer to a `clang::ExplicitSpecifier` object.
"""
struct ExplicitSpecifier <: AbstractExplicitSpecifier
    ptr::CXExplicitSpecifier
end

"""
    struct BaseUsingDecl <: AbstractBaseUsingDecl
Hold a pointer to a `clang::BaseUsingDecl` object.
"""
struct BaseUsingDecl <: AbstractBaseUsingDecl
    ptr::CXBaseUsingDecl
end

"""
    struct UsingEnumDecl <: AbstractUsingEnumDecl
Hold a pointer to a `clang::UsingEnumDecl` object.
"""
struct UsingEnumDecl <: AbstractUsingEnumDecl
    ptr::CXUsingEnumDecl
end

"""
    struct UnresolvedUsingIfExistsDecl <: AbstractUnresolvedUsingIfExistsDecl
Hold a pointer to a `clang::UnresolvedUsingIfExistsDecl` object.
"""
struct UnresolvedUsingIfExistsDecl <: AbstractUnresolvedUsingIfExistsDecl
    ptr::CXUnresolvedUsingIfExistsDecl
end

"""
    struct UnnamedGlobalConstantDecl <: AbstractUnnamedGlobalConstantDecl
Hold a pointer to a `clang::UnnamedGlobalConstantDecl` object.
"""
struct UnnamedGlobalConstantDecl <: AbstractUnnamedGlobalConstantDecl
    ptr::CXUnnamedGlobalConstantDecl
end

