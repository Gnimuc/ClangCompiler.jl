"""
    struct CXXOperatorCallExpr <: AbstractCallExpr
Hold a pointer to a `clang::CXXOperatorCallExpr` object.
"""
struct CXXOperatorCallExpr <: AbstractCallExpr
    ptr::CXCXXOperatorCallExpr
end

Base.unsafe_convert(::Type{CXCXXOperatorCallExpr}, x::CXXOperatorCallExpr) = x.ptr
Base.cconvert(::Type{CXCXXOperatorCallExpr}, x::CXXOperatorCallExpr) = x

"""
    struct CXXMemberCallExpr <: AbstractCallExpr
Hold a pointer to a `clang::CXXMemberCallExpr` object.
"""
struct CXXMemberCallExpr <: AbstractCallExpr
    ptr::CXCXXMemberCallExpr
end

Base.unsafe_convert(::Type{CXCXXMemberCallExpr}, x::CXXMemberCallExpr) = x.ptr
Base.cconvert(::Type{CXCXXMemberCallExpr}, x::CXXMemberCallExpr) = x

"""
    struct CUDAKernelCallExpr <: AbstractCallExpr
Hold a pointer to a `clang::CUDAKernelCallExpr` object.
"""
struct CUDAKernelCallExpr <: AbstractCallExpr
    ptr::CXCUDAKernelCallExpr
end

Base.unsafe_convert(::Type{CXCUDAKernelCallExpr}, x::CUDAKernelCallExpr) = x.ptr
Base.cconvert(::Type{CXCUDAKernelCallExpr}, x::CUDAKernelCallExpr) = x

"""
    struct CXXRewrittenBinaryOperator <: AbstractExpr
Hold a pointer to a `clang::CXXRewrittenBinaryOperator` object.
"""
struct CXXRewrittenBinaryOperator <: AbstractExpr
    ptr::CXCXXRewrittenBinaryOperator
end

Base.unsafe_convert(::Type{CXCXXRewrittenBinaryOperator}, x::CXXRewrittenBinaryOperator) = x.ptr
Base.cconvert(::Type{CXCXXRewrittenBinaryOperator}, x::CXXRewrittenBinaryOperator) = x

"""
    struct CXXNamedCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXNamedCastExpr` object.
"""
struct CXXNamedCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXNamedCastExpr
end

Base.unsafe_convert(::Type{CXCXXNamedCastExpr}, x::CXXNamedCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXNamedCastExpr}, x::CXXNamedCastExpr) = x

"""
    struct CXXStaticCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXStaticCastExpr` object.
"""
struct CXXStaticCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXStaticCastExpr
end

Base.unsafe_convert(::Type{CXCXXStaticCastExpr}, x::CXXStaticCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXStaticCastExpr}, x::CXXStaticCastExpr) = x

"""
    struct CXXDynamicCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXDynamicCastExpr` object.
"""
struct CXXDynamicCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXDynamicCastExpr
end

Base.unsafe_convert(::Type{CXCXXDynamicCastExpr}, x::CXXDynamicCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXDynamicCastExpr}, x::CXXDynamicCastExpr) = x

"""
    struct CXXReinterpretCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXReinterpretCastExpr` object.
"""
struct CXXReinterpretCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXReinterpretCastExpr
end

Base.unsafe_convert(::Type{CXCXXReinterpretCastExpr}, x::CXXReinterpretCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXReinterpretCastExpr}, x::CXXReinterpretCastExpr) = x

"""
    struct CXXConstCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXConstCastExpr` object.
"""
struct CXXConstCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXConstCastExpr
end

Base.unsafe_convert(::Type{CXCXXConstCastExpr}, x::CXXConstCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXConstCastExpr}, x::CXXConstCastExpr) = x

"""
    struct CXXAddrspaceCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXAddrspaceCastExpr` object.
"""
struct CXXAddrspaceCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXAddrspaceCastExpr
end

Base.unsafe_convert(::Type{CXCXXAddrspaceCastExpr}, x::CXXAddrspaceCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXAddrspaceCastExpr}, x::CXXAddrspaceCastExpr) = x

"""
    struct UserDefinedLiteral <: AbstractCallExpr
Hold a pointer to a `clang::UserDefinedLiteral` object.
"""
struct UserDefinedLiteral <: AbstractCallExpr
    ptr::CXUserDefinedLiteral
end

Base.unsafe_convert(::Type{CXUserDefinedLiteral}, x::UserDefinedLiteral) = x.ptr
Base.cconvert(::Type{CXUserDefinedLiteral}, x::UserDefinedLiteral) = x

"""
    struct CXXBoolLiteralExpr <: AbstractExpr
Hold a pointer to a `clang::CXXBoolLiteralExpr` object.
"""
struct CXXBoolLiteralExpr <: AbstractExpr
    ptr::CXCXXBoolLiteralExpr
end

Base.unsafe_convert(::Type{CXCXXBoolLiteralExpr}, x::CXXBoolLiteralExpr) = x.ptr
Base.cconvert(::Type{CXCXXBoolLiteralExpr}, x::CXXBoolLiteralExpr) = x

"""
    struct CXXNullPtrLiteralExpr <: AbstractExpr
Hold a pointer to a `clang::CXXNullPtrLiteralExpr` object.
"""
struct CXXNullPtrLiteralExpr <: AbstractExpr
    ptr::CXCXXNullPtrLiteralExpr
end

Base.unsafe_convert(::Type{CXCXXNullPtrLiteralExpr}, x::CXXNullPtrLiteralExpr) = x.ptr
Base.cconvert(::Type{CXCXXNullPtrLiteralExpr}, x::CXXNullPtrLiteralExpr) = x

"""
    struct CXXStdInitializerListExpr <: AbstractExpr
Hold a pointer to a `clang::CXXStdInitializerListExpr` object.
"""
struct CXXStdInitializerListExpr <: AbstractExpr
    ptr::CXCXXStdInitializerListExpr
end

Base.unsafe_convert(::Type{CXCXXStdInitializerListExpr}, x::CXXStdInitializerListExpr) = x.ptr
Base.cconvert(::Type{CXCXXStdInitializerListExpr}, x::CXXStdInitializerListExpr) = x

"""
    struct CXXTypeidExpr <: AbstractExpr
Hold a pointer to a `clang::CXXTypeidExpr` object.
"""
struct CXXTypeidExpr <: AbstractExpr
    ptr::CXCXXTypeidExpr
end

Base.unsafe_convert(::Type{CXCXXTypeidExpr}, x::CXXTypeidExpr) = x.ptr
Base.cconvert(::Type{CXCXXTypeidExpr}, x::CXXTypeidExpr) = x

"""
    struct MSPropertyRefExpr <: AbstractExpr
Hold a pointer to a `clang::MSPropertyRefExpr` object.
"""
struct MSPropertyRefExpr <: AbstractExpr
    ptr::CXMSPropertyRefExpr
end

Base.unsafe_convert(::Type{CXMSPropertyRefExpr}, x::MSPropertyRefExpr) = x.ptr
Base.cconvert(::Type{CXMSPropertyRefExpr}, x::MSPropertyRefExpr) = x

"""
    struct MSPropertySubscriptExpr <: AbstractExpr
Hold a pointer to a `clang::MSPropertySubscriptExpr` object.
"""
struct MSPropertySubscriptExpr <: AbstractExpr
    ptr::CXMSPropertySubscriptExpr
end

Base.unsafe_convert(::Type{CXMSPropertySubscriptExpr}, x::MSPropertySubscriptExpr) = x.ptr
Base.cconvert(::Type{CXMSPropertySubscriptExpr}, x::MSPropertySubscriptExpr) = x

"""
    struct CXXUuidofExpr <: AbstractExpr
Hold a pointer to a `clang::CXXUuidofExpr` object.
"""
struct CXXUuidofExpr <: AbstractExpr
    ptr::CXCXXUuidofExpr
end

Base.unsafe_convert(::Type{CXCXXUuidofExpr}, x::CXXUuidofExpr) = x.ptr
Base.cconvert(::Type{CXCXXUuidofExpr}, x::CXXUuidofExpr) = x

"""
    struct CXXThisExpr <: AbstractExpr
Hold a pointer to a `clang::CXXThisExpr` object.
"""
struct CXXThisExpr <: AbstractExpr
    ptr::CXCXXThisExpr
end

Base.unsafe_convert(::Type{CXCXXThisExpr}, x::CXXThisExpr) = x.ptr
Base.cconvert(::Type{CXCXXThisExpr}, x::CXXThisExpr) = x

"""
    struct CXXThrowExpr <: AbstractExpr
Hold a pointer to a `clang::CXXThrowExpr` object.
"""
struct CXXThrowExpr <: AbstractExpr
    ptr::CXCXXThrowExpr
end

Base.unsafe_convert(::Type{CXCXXThrowExpr}, x::CXXThrowExpr) = x.ptr
Base.cconvert(::Type{CXCXXThrowExpr}, x::CXXThrowExpr) = x

"""
    struct CXXDefaultArgExpr <: AbstractExpr
Hold a pointer to a `clang::CXXDefaultArgExpr` object.
"""
struct CXXDefaultArgExpr <: AbstractExpr
    ptr::CXCXXDefaultArgExpr
end

Base.unsafe_convert(::Type{CXCXXDefaultArgExpr}, x::CXXDefaultArgExpr) = x.ptr
Base.cconvert(::Type{CXCXXDefaultArgExpr}, x::CXXDefaultArgExpr) = x

"""
    struct CXXDefaultInitExpr <: AbstractExpr
Hold a pointer to a `clang::CXXDefaultInitExpr` object.
"""
struct CXXDefaultInitExpr <: AbstractExpr
    ptr::CXCXXDefaultInitExpr
end

Base.unsafe_convert(::Type{CXCXXDefaultInitExpr}, x::CXXDefaultInitExpr) = x.ptr
Base.cconvert(::Type{CXCXXDefaultInitExpr}, x::CXXDefaultInitExpr) = x

"""
    struct CXXBindTemporaryExpr <: AbstractExpr
Hold a pointer to a `clang::CXXBindTemporaryExpr` object.
"""
struct CXXBindTemporaryExpr <: AbstractExpr
    ptr::CXCXXBindTemporaryExpr
end

Base.unsafe_convert(::Type{CXCXXBindTemporaryExpr}, x::CXXBindTemporaryExpr) = x.ptr
Base.cconvert(::Type{CXCXXBindTemporaryExpr}, x::CXXBindTemporaryExpr) = x

"""
    struct CXXConstructExpr <: AbstractCXXConstructExpr
Hold a pointer to a `clang::CXXConstructExpr` object.
"""
struct CXXConstructExpr <: AbstractCXXConstructExpr
    ptr::CXCXXConstructExpr
end

Base.unsafe_convert(::Type{CXCXXConstructExpr}, x::CXXConstructExpr) = x.ptr
Base.cconvert(::Type{CXCXXConstructExpr}, x::CXXConstructExpr) = x

"""
    struct CXXInheritedCtorInitExpr <: AbstractExpr
Hold a pointer to a `clang::CXXInheritedCtorInitExpr` object.
"""
struct CXXInheritedCtorInitExpr <: AbstractExpr
    ptr::CXCXXInheritedCtorInitExpr
end

Base.unsafe_convert(::Type{CXCXXInheritedCtorInitExpr}, x::CXXInheritedCtorInitExpr) = x.ptr
Base.cconvert(::Type{CXCXXInheritedCtorInitExpr}, x::CXXInheritedCtorInitExpr) = x

"""
    struct CXXFunctionalCastExpr <: AbstractExplicitCastExpr
Hold a pointer to a `clang::CXXFunctionalCastExpr` object.
"""
struct CXXFunctionalCastExpr <: AbstractExplicitCastExpr
    ptr::CXCXXFunctionalCastExpr
end

Base.unsafe_convert(::Type{CXCXXFunctionalCastExpr}, x::CXXFunctionalCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXFunctionalCastExpr}, x::CXXFunctionalCastExpr) = x

"""
    struct CXXTemporaryObjectExpr <: AbstractCXXConstructExpr
Hold a pointer to a `clang::CXXTemporaryObjectExpr` object.
"""
struct CXXTemporaryObjectExpr <: AbstractCXXConstructExpr
    ptr::CXCXXTemporaryObjectExpr
end

Base.unsafe_convert(::Type{CXCXXTemporaryObjectExpr}, x::CXXTemporaryObjectExpr) = x.ptr
Base.cconvert(::Type{CXCXXTemporaryObjectExpr}, x::CXXTemporaryObjectExpr) = x

"""
    struct LambdaExpr <: AbstractExpr
Hold a pointer to a `clang::LambdaExpr` object.
"""
struct LambdaExpr <: AbstractExpr
    ptr::CXLambdaExpr
end

Base.unsafe_convert(::Type{CXLambdaExpr}, x::LambdaExpr) = x.ptr
Base.cconvert(::Type{CXLambdaExpr}, x::LambdaExpr) = x

"""
    struct CXXScalarValueInitExpr <: AbstractExpr
Hold a pointer to a `clang::CXXScalarValueInitExpr` object.
"""
struct CXXScalarValueInitExpr <: AbstractExpr
    ptr::CXCXXScalarValueInitExpr
end

Base.unsafe_convert(::Type{CXCXXScalarValueInitExpr}, x::CXXScalarValueInitExpr) = x.ptr
Base.cconvert(::Type{CXCXXScalarValueInitExpr}, x::CXXScalarValueInitExpr) = x

"""
    struct CXXNewExpr <: AbstractExpr
Hold a pointer to a `clang::CXXNewExpr` object.
"""
struct CXXNewExpr <: AbstractExpr
    ptr::CXCXXNewExpr
end

Base.unsafe_convert(::Type{CXCXXNewExpr}, x::CXXNewExpr) = x.ptr
Base.cconvert(::Type{CXCXXNewExpr}, x::CXXNewExpr) = x

"""
    struct CXXDeleteExpr <: AbstractExpr
Hold a pointer to a `clang::CXXDeleteExpr` object.
"""
struct CXXDeleteExpr <: AbstractExpr
    ptr::CXCXXDeleteExpr
end

Base.unsafe_convert(::Type{CXCXXDeleteExpr}, x::CXXDeleteExpr) = x.ptr
Base.cconvert(::Type{CXCXXDeleteExpr}, x::CXXDeleteExpr) = x

"""
    struct CXXPseudoDestructorExpr <: AbstractExpr
Hold a pointer to a `clang::CXXPseudoDestructorExpr` object.
"""
struct CXXPseudoDestructorExpr <: AbstractExpr
    ptr::CXCXXPseudoDestructorExpr
end

Base.unsafe_convert(::Type{CXCXXPseudoDestructorExpr}, x::CXXPseudoDestructorExpr) = x.ptr
Base.cconvert(::Type{CXCXXPseudoDestructorExpr}, x::CXXPseudoDestructorExpr) = x

"""
    struct TypeTraitExpr <: AbstractExpr
Hold a pointer to a `clang::TypeTraitExpr` object.
"""
struct TypeTraitExpr <: AbstractExpr
    ptr::CXTypeTraitExpr
end

Base.unsafe_convert(::Type{CXTypeTraitExpr}, x::TypeTraitExpr) = x.ptr
Base.cconvert(::Type{CXTypeTraitExpr}, x::TypeTraitExpr) = x

"""
    struct ArrayTypeTraitExpr <: AbstractExpr
Hold a pointer to a `clang::ArrayTypeTraitExpr` object.
"""
struct ArrayTypeTraitExpr <: AbstractExpr
    ptr::CXArrayTypeTraitExpr
end

Base.unsafe_convert(::Type{CXArrayTypeTraitExpr}, x::ArrayTypeTraitExpr) = x.ptr
Base.cconvert(::Type{CXArrayTypeTraitExpr}, x::ArrayTypeTraitExpr) = x

"""
    struct ExpressionTraitExpr <: AbstractExpr
Hold a pointer to a `clang::ExpressionTraitExpr` object.
"""
struct ExpressionTraitExpr <: AbstractExpr
    ptr::CXExpressionTraitExpr
end

Base.unsafe_convert(::Type{CXExpressionTraitExpr}, x::ExpressionTraitExpr) = x.ptr
Base.cconvert(::Type{CXExpressionTraitExpr}, x::ExpressionTraitExpr) = x

"""
    struct OverloadExpr <: AbstractOverloadExpr
Hold a pointer to a `clang::OverloadExpr` object.
"""
struct OverloadExpr <: AbstractOverloadExpr
    ptr::CXOverloadExpr
end

Base.unsafe_convert(::Type{CXOverloadExpr}, x::OverloadExpr) = x.ptr
Base.cconvert(::Type{CXOverloadExpr}, x::OverloadExpr) = x

"""
    struct UnresolvedLookupExpr <: AbstractOverloadExpr
Hold a pointer to a `clang::UnresolvedLookupExpr` object.
"""
struct UnresolvedLookupExpr <: AbstractOverloadExpr
    ptr::CXUnresolvedLookupExpr
end

Base.unsafe_convert(::Type{CXUnresolvedLookupExpr}, x::UnresolvedLookupExpr) = x.ptr
Base.cconvert(::Type{CXUnresolvedLookupExpr}, x::UnresolvedLookupExpr) = x

"""
    struct DependentScopeDeclRefExpr <: AbstractExpr
Hold a pointer to a `clang::DependentScopeDeclRefExpr` object.
"""
struct DependentScopeDeclRefExpr <: AbstractExpr
    ptr::CXDependentScopeDeclRefExpr
end

Base.unsafe_convert(::Type{CXDependentScopeDeclRefExpr}, x::DependentScopeDeclRefExpr) = x.ptr
Base.cconvert(::Type{CXDependentScopeDeclRefExpr}, x::DependentScopeDeclRefExpr) = x

"""
    struct CXXUnresolvedConstructExpr <: AbstractExpr
Hold a pointer to a `clang::CXXUnresolvedConstructExpr` object.
"""
struct CXXUnresolvedConstructExpr <: AbstractExpr
    ptr::CXCXXUnresolvedConstructExpr
end

Base.unsafe_convert(::Type{CXCXXUnresolvedConstructExpr}, x::CXXUnresolvedConstructExpr) = x.ptr
Base.cconvert(::Type{CXCXXUnresolvedConstructExpr}, x::CXXUnresolvedConstructExpr) = x

"""
    struct CXXDependentScopeMemberExpr <: AbstractExpr
Hold a pointer to a `clang::CXXDependentScopeMemberExpr` object.
"""
struct CXXDependentScopeMemberExpr <: AbstractExpr
    ptr::CXCXXDependentScopeMemberExpr
end

Base.unsafe_convert(::Type{CXCXXDependentScopeMemberExpr}, x::CXXDependentScopeMemberExpr) = x.ptr
Base.cconvert(::Type{CXCXXDependentScopeMemberExpr}, x::CXXDependentScopeMemberExpr) = x

"""
    struct UnresolvedMemberExpr <: AbstractOverloadExpr
Hold a pointer to a `clang::UnresolvedMemberExpr` object.
"""
struct UnresolvedMemberExpr <: AbstractOverloadExpr
    ptr::CXUnresolvedMemberExpr
end

Base.unsafe_convert(::Type{CXUnresolvedMemberExpr}, x::UnresolvedMemberExpr) = x.ptr
Base.cconvert(::Type{CXUnresolvedMemberExpr}, x::UnresolvedMemberExpr) = x

"""
    struct CXXNoexceptExpr <: AbstractExpr
Hold a pointer to a `clang::CXXNoexceptExpr` object.
"""
struct CXXNoexceptExpr <: AbstractExpr
    ptr::CXCXXNoexceptExpr
end

Base.unsafe_convert(::Type{CXCXXNoexceptExpr}, x::CXXNoexceptExpr) = x.ptr
Base.cconvert(::Type{CXCXXNoexceptExpr}, x::CXXNoexceptExpr) = x

"""
    struct PackExpansionExpr <: AbstractExpr
Hold a pointer to a `clang::PackExpansionExpr` object.
"""
struct PackExpansionExpr <: AbstractExpr
    ptr::CXPackExpansionExpr
end

Base.unsafe_convert(::Type{CXPackExpansionExpr}, x::PackExpansionExpr) = x.ptr
Base.cconvert(::Type{CXPackExpansionExpr}, x::PackExpansionExpr) = x

"""
    struct SizeOfPackExpr <: AbstractExpr
Hold a pointer to a `clang::SizeOfPackExpr` object.
"""
struct SizeOfPackExpr <: AbstractExpr
    ptr::CXSizeOfPackExpr
end

Base.unsafe_convert(::Type{CXSizeOfPackExpr}, x::SizeOfPackExpr) = x.ptr
Base.cconvert(::Type{CXSizeOfPackExpr}, x::SizeOfPackExpr) = x

"""
    struct SubstNonTypeTemplateParmExpr <: AbstractExpr
Hold a pointer to a `clang::SubstNonTypeTemplateParmExpr` object.
"""
struct SubstNonTypeTemplateParmExpr <: AbstractExpr
    ptr::CXSubstNonTypeTemplateParmExpr
end

Base.unsafe_convert(::Type{CXSubstNonTypeTemplateParmExpr}, x::SubstNonTypeTemplateParmExpr) = x.ptr
Base.cconvert(::Type{CXSubstNonTypeTemplateParmExpr}, x::SubstNonTypeTemplateParmExpr) = x

"""
    struct SubstNonTypeTemplateParmPackExpr <: AbstractExpr
Hold a pointer to a `clang::SubstNonTypeTemplateParmPackExpr` object.
"""
struct SubstNonTypeTemplateParmPackExpr <: AbstractExpr
    ptr::CXSubstNonTypeTemplateParmPackExpr
end

Base.unsafe_convert(::Type{CXSubstNonTypeTemplateParmPackExpr}, x::SubstNonTypeTemplateParmPackExpr) = x.ptr
Base.cconvert(::Type{CXSubstNonTypeTemplateParmPackExpr}, x::SubstNonTypeTemplateParmPackExpr) = x

"""
    struct FunctionParmPackExpr <: AbstractExpr
Hold a pointer to a `clang::FunctionParmPackExpr` object.
"""
struct FunctionParmPackExpr <: AbstractExpr
    ptr::CXFunctionParmPackExpr
end

Base.unsafe_convert(::Type{CXFunctionParmPackExpr}, x::FunctionParmPackExpr) = x.ptr
Base.cconvert(::Type{CXFunctionParmPackExpr}, x::FunctionParmPackExpr) = x

"""
    struct MaterializeTemporaryExpr <: AbstractExpr
Hold a pointer to a `clang::MaterializeTemporaryExpr` object.
"""
struct MaterializeTemporaryExpr <: AbstractExpr
    ptr::CXMaterializeTemporaryExpr
end

Base.unsafe_convert(::Type{CXMaterializeTemporaryExpr}, x::MaterializeTemporaryExpr) = x.ptr
Base.cconvert(::Type{CXMaterializeTemporaryExpr}, x::MaterializeTemporaryExpr) = x

"""
    struct CXXFoldExpr <: AbstractExpr
Hold a pointer to a `clang::CXXFoldExpr` object.
"""
struct CXXFoldExpr <: AbstractExpr
    ptr::CXCXXFoldExpr
end

Base.unsafe_convert(::Type{CXCXXFoldExpr}, x::CXXFoldExpr) = x.ptr
Base.cconvert(::Type{CXCXXFoldExpr}, x::CXXFoldExpr) = x

"""
    struct CoroutineSuspendExpr <: AbstractCoroutineSuspendExpr
Hold a pointer to a `clang::CoroutineSuspendExpr` object.
"""
struct CoroutineSuspendExpr <: AbstractCoroutineSuspendExpr
    ptr::CXCoroutineSuspendExpr
end

Base.unsafe_convert(::Type{CXCoroutineSuspendExpr}, x::CoroutineSuspendExpr) = x.ptr
Base.cconvert(::Type{CXCoroutineSuspendExpr}, x::CoroutineSuspendExpr) = x

"""
    struct CoawaitExpr <: AbstractCoroutineSuspendExpr
Hold a pointer to a `clang::CoawaitExpr` object.
"""
struct CoawaitExpr <: AbstractCoroutineSuspendExpr
    ptr::CXCoawaitExpr
end

Base.unsafe_convert(::Type{CXCoawaitExpr}, x::CoawaitExpr) = x.ptr
Base.cconvert(::Type{CXCoawaitExpr}, x::CoawaitExpr) = x

"""
    struct DependentCoawaitExpr <: AbstractExpr
Hold a pointer to a `clang::DependentCoawaitExpr` object.
"""
struct DependentCoawaitExpr <: AbstractExpr
    ptr::CXDependentCoawaitExpr
end

Base.unsafe_convert(::Type{CXDependentCoawaitExpr}, x::DependentCoawaitExpr) = x.ptr
Base.cconvert(::Type{CXDependentCoawaitExpr}, x::DependentCoawaitExpr) = x

"""
    struct CoyieldExpr <: AbstractCoroutineSuspendExpr
Hold a pointer to a `clang::CoyieldExpr` object.
"""
struct CoyieldExpr <: AbstractCoroutineSuspendExpr
    ptr::CXCoyieldExpr
end

Base.unsafe_convert(::Type{CXCoyieldExpr}, x::CoyieldExpr) = x.ptr
Base.cconvert(::Type{CXCoyieldExpr}, x::CoyieldExpr) = x

"""
    struct BuiltinBitCastExpr <: AbstractExplicitCastExpr
Hold a pointer to a `clang::BuiltinBitCastExpr` object.
"""
struct BuiltinBitCastExpr <: AbstractExplicitCastExpr
    ptr::CXBuiltinBitCastExpr
end

Base.unsafe_convert(::Type{CXBuiltinBitCastExpr}, x::BuiltinBitCastExpr) = x.ptr
Base.cconvert(::Type{CXBuiltinBitCastExpr}, x::BuiltinBitCastExpr) = x
