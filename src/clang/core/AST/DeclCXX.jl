"""
    struct AccessSpecDecl <: AbstractDecl
Hold a pointer to a `clang::AccessSpecDecl` object.
"""
struct AccessSpecDecl <: AbstractDecl
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
    struct CXXDeductionGuideDecl <: AbstractFunctionDecl
Hold a pointer to a `clang::CXXDeductionGuideDecl` object.
"""
struct CXXDeductionGuideDecl <: AbstractFunctionDecl
    ptr::CXCXXDeductionGuideDecl
end

Base.unsafe_convert(::Type{CXCXXDeductionGuideDecl}, x::CXXDeductionGuideDecl) = x.ptr
Base.cconvert(::Type{CXCXXDeductionGuideDecl}, x::CXXDeductionGuideDecl) = x

"""
    struct RequiresExprBodyDecl <: AbstractDecl
Hold a pointer to a `clang::RequiresExprBodyDecl` object.
"""
struct RequiresExprBodyDecl <: AbstractDecl
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
    struct CXXConstructorDecl <: AbstractCXXMethodDecl
Hold a pointer to a `clang::CXXConstructorDecl` object.
"""
struct CXXConstructorDecl <: AbstractCXXMethodDecl
    ptr::CXCXXConstructorDecl
end

Base.unsafe_convert(::Type{CXCXXConstructorDecl}, x::CXXConstructorDecl) = x.ptr
Base.cconvert(::Type{CXCXXConstructorDecl}, x::CXXConstructorDecl) = x

"""
    struct CXXDestructorDecl <: AbstractCXXMethodDecl
Hold a pointer to a `clang::CXXDestructorDecl` object.
"""
struct CXXDestructorDecl <: AbstractCXXMethodDecl
    ptr::CXCXXDestructorDecl
end

Base.unsafe_convert(::Type{CXCXXDestructorDecl}, x::CXXDestructorDecl) = x.ptr
Base.cconvert(::Type{CXCXXDestructorDecl}, x::CXXDestructorDecl) = x

"""
    struct CXXConversionDecl <: AbstractCXXMethodDecl
Hold a pointer to a `clang::CXXConversionDecl` object.
"""
struct CXXConversionDecl <: AbstractCXXMethodDecl
    ptr::CXCXXConversionDecl
end

Base.unsafe_convert(::Type{CXCXXConversionDecl}, x::CXXConversionDecl) = x.ptr
Base.cconvert(::Type{CXCXXConversionDecl}, x::CXXConversionDecl) = x

"""
    struct LinkageSpecDecl <: AbstractDecl
Hold a pointer to a `clang::LinkageSpecDecl` object.
"""
struct LinkageSpecDecl <: AbstractDecl
    ptr::CXLinkageSpecDecl
end

Base.unsafe_convert(::Type{CXLinkageSpecDecl}, x::LinkageSpecDecl) = x.ptr
Base.cconvert(::Type{CXLinkageSpecDecl}, x::LinkageSpecDecl) = x

"""
    struct UsingDirectiveDecl <: AbstractNamedDecl
Hold a pointer to a `clang::UsingDirectiveDecl` object.
"""
struct UsingDirectiveDecl <: AbstractNamedDecl
    ptr::CXUsingDirectiveDecl
end

Base.unsafe_convert(::Type{CXUsingDirectiveDecl}, x::UsingDirectiveDecl) = x.ptr
Base.cconvert(::Type{CXUsingDirectiveDecl}, x::UsingDirectiveDecl) = x

"""
    struct NamespaceAliasDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamespaceAliasDecl` object.
"""
struct NamespaceAliasDecl <: AbstractNamedDecl
    ptr::CXNamespaceAliasDecl
end

Base.unsafe_convert(::Type{CXNamespaceAliasDecl}, x::NamespaceAliasDecl) = x.ptr
Base.cconvert(::Type{CXNamespaceAliasDecl}, x::NamespaceAliasDecl) = x

"""
    struct LifetimeExtendedTemporaryDecl <: AbstractDecl
Hold a pointer to a `clang::LifetimeExtendedTemporaryDecl` object.
"""
struct LifetimeExtendedTemporaryDecl <: AbstractDecl
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
    struct ConstructorUsingShadowDecl <: AbstractUsingShadowDecl
Hold a pointer to a `clang::ConstructorUsingShadowDecl` object.
"""
struct ConstructorUsingShadowDecl <: AbstractUsingShadowDecl
    ptr::CXConstructorUsingShadowDecl
end

Base.unsafe_convert(::Type{CXConstructorUsingShadowDecl}, x::ConstructorUsingShadowDecl) = x.ptr
Base.cconvert(::Type{CXConstructorUsingShadowDecl}, x::ConstructorUsingShadowDecl) = x

"""
    struct UsingDecl <: AbstractNamedDecl
Hold a pointer to a `clang::UsingDecl` object.
"""
struct UsingDecl <: AbstractNamedDecl
    ptr::CXUsingDecl
end

Base.unsafe_convert(::Type{CXUsingDecl}, x::UsingDecl) = x.ptr
Base.cconvert(::Type{CXUsingDecl}, x::UsingDecl) = x

"""
    struct UsingPackDecl <: AbstractNamedDecl
Hold a pointer to a `clang::UsingPackDecl` object.
"""
struct UsingPackDecl <: AbstractNamedDecl
    ptr::CXUsingPackDecl
end

Base.unsafe_convert(::Type{CXUsingPackDecl}, x::UsingPackDecl) = x.ptr
Base.cconvert(::Type{CXUsingPackDecl}, x::UsingPackDecl) = x

"""
    struct UnresolvedUsingValueDecl <: AbstractValueDecl
Hold a pointer to a `clang::UnresolvedUsingValueDecl` object.
"""
struct UnresolvedUsingValueDecl <: AbstractValueDecl
    ptr::CXUnresolvedUsingValueDecl
end

Base.unsafe_convert(::Type{CXUnresolvedUsingValueDecl}, x::UnresolvedUsingValueDecl) = x.ptr
Base.cconvert(::Type{CXUnresolvedUsingValueDecl}, x::UnresolvedUsingValueDecl) = x

"""
    struct UnresolvedUsingTypenameDecl <: AbstractTypeDecl
Hold a pointer to a `clang::UnresolvedUsingTypenameDecl` object.
"""
struct UnresolvedUsingTypenameDecl <: AbstractTypeDecl
    ptr::CXUnresolvedUsingTypenameDecl
end

Base.unsafe_convert(::Type{CXUnresolvedUsingTypenameDecl}, x::UnresolvedUsingTypenameDecl) = x.ptr
Base.cconvert(::Type{CXUnresolvedUsingTypenameDecl}, x::UnresolvedUsingTypenameDecl) = x

"""
    struct StaticAssertDecl <: AbstractDecl
Hold a pointer to a `clang::StaticAssertDecl` object.
"""
struct StaticAssertDecl <: AbstractDecl
    ptr::CXStaticAssertDecl
end

Base.unsafe_convert(::Type{CXStaticAssertDecl}, x::StaticAssertDecl) = x.ptr
Base.cconvert(::Type{CXStaticAssertDecl}, x::StaticAssertDecl) = x

"""
    struct BindingDecl <: AbstractValueDecl
Hold a pointer to a `clang::BindingDecl` object.
"""
struct BindingDecl <: AbstractValueDecl
    ptr::CXBindingDecl
end

Base.unsafe_convert(::Type{CXBindingDecl}, x::BindingDecl) = x.ptr
Base.cconvert(::Type{CXBindingDecl}, x::BindingDecl) = x

"""
    struct DecompositionDecl <: AbstractVarDecl
Hold a pointer to a `clang::DecompositionDecl` object.
"""
struct DecompositionDecl <: AbstractVarDecl
    ptr::CXDecompositionDecl
end

Base.unsafe_convert(::Type{CXDecompositionDecl}, x::DecompositionDecl) = x.ptr
Base.cconvert(::Type{CXDecompositionDecl}, x::DecompositionDecl) = x

"""
    struct MSPropertyDecl <: AbstractDeclaratorDecl
Hold a pointer to a `clang::MSPropertyDecl` object.
"""
struct MSPropertyDecl <: AbstractDeclaratorDecl
    ptr::CXMSPropertyDecl
end

Base.unsafe_convert(::Type{CXMSPropertyDecl}, x::MSPropertyDecl) = x.ptr
Base.cconvert(::Type{CXMSPropertyDecl}, x::MSPropertyDecl) = x

"""
    struct MSGuidDecl <: AbstractValueDecl
Hold a pointer to a `clang::MSGuidDecl` object.
"""
struct MSGuidDecl <: AbstractValueDecl
    ptr::CXMSGuidDecl
end

Base.unsafe_convert(::Type{CXMSGuidDecl}, x::MSGuidDecl) = x.ptr
Base.cconvert(::Type{CXMSGuidDecl}, x::MSGuidDecl) = x
