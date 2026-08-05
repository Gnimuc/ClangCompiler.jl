"""
    struct CXXOperatorCallExpr <: AbstractCXXOperatorCallExpr
Hold a pointer to a `clang::CXXOperatorCallExpr` object.
"""
struct CXXOperatorCallExpr <: AbstractCXXOperatorCallExpr
    ptr::CXCXXOperatorCallExpr
end

"""
    struct CXXMemberCallExpr <: AbstractCXXMemberCallExpr
Hold a pointer to a `clang::CXXMemberCallExpr` object.
"""
struct CXXMemberCallExpr <: AbstractCXXMemberCallExpr
    ptr::CXCXXMemberCallExpr
end

"""
    struct CUDAKernelCallExpr <: AbstractCUDAKernelCallExpr
Hold a pointer to a `clang::CUDAKernelCallExpr` object.
"""
struct CUDAKernelCallExpr <: AbstractCUDAKernelCallExpr
    ptr::CXCUDAKernelCallExpr
end

"""
    struct CXXRewrittenBinaryOperator <: AbstractCXXRewrittenBinaryOperator
Hold a pointer to a `clang::CXXRewrittenBinaryOperator` object.
"""
struct CXXRewrittenBinaryOperator <: AbstractCXXRewrittenBinaryOperator
    ptr::CXCXXRewrittenBinaryOperator
end

"""
    struct CXXNamedCastExpr <: AbstractCXXNamedCastExpr
Hold a pointer to a `clang::CXXNamedCastExpr` object.
"""
struct CXXNamedCastExpr <: AbstractCXXNamedCastExpr
    ptr::CXCXXNamedCastExpr
end

"""
    struct CXXStaticCastExpr <: AbstractCXXStaticCastExpr
Hold a pointer to a `clang::CXXStaticCastExpr` object.
"""
struct CXXStaticCastExpr <: AbstractCXXStaticCastExpr
    ptr::CXCXXStaticCastExpr
end

"""
    struct CXXDynamicCastExpr <: AbstractCXXDynamicCastExpr
Hold a pointer to a `clang::CXXDynamicCastExpr` object.
"""
struct CXXDynamicCastExpr <: AbstractCXXDynamicCastExpr
    ptr::CXCXXDynamicCastExpr
end

"""
    struct CXXReinterpretCastExpr <: AbstractCXXReinterpretCastExpr
Hold a pointer to a `clang::CXXReinterpretCastExpr` object.
"""
struct CXXReinterpretCastExpr <: AbstractCXXReinterpretCastExpr
    ptr::CXCXXReinterpretCastExpr
end

"""
    struct CXXConstCastExpr <: AbstractCXXConstCastExpr
Hold a pointer to a `clang::CXXConstCastExpr` object.
"""
struct CXXConstCastExpr <: AbstractCXXConstCastExpr
    ptr::CXCXXConstCastExpr
end

"""
    struct CXXAddrspaceCastExpr <: AbstractCXXAddrspaceCastExpr
Hold a pointer to a `clang::CXXAddrspaceCastExpr` object.
"""
struct CXXAddrspaceCastExpr <: AbstractCXXAddrspaceCastExpr
    ptr::CXCXXAddrspaceCastExpr
end

"""
    struct UserDefinedLiteral <: AbstractUserDefinedLiteral
Hold a pointer to a `clang::UserDefinedLiteral` object.
"""
struct UserDefinedLiteral <: AbstractUserDefinedLiteral
    ptr::CXUserDefinedLiteral
end

"""
    struct CXXBoolLiteralExpr <: AbstractCXXBoolLiteralExpr
Hold a pointer to a `clang::CXXBoolLiteralExpr` object.
"""
struct CXXBoolLiteralExpr <: AbstractCXXBoolLiteralExpr
    ptr::CXCXXBoolLiteralExpr
end

"""
    struct CXXNullPtrLiteralExpr <: AbstractCXXNullPtrLiteralExpr
Hold a pointer to a `clang::CXXNullPtrLiteralExpr` object.
"""
struct CXXNullPtrLiteralExpr <: AbstractCXXNullPtrLiteralExpr
    ptr::CXCXXNullPtrLiteralExpr
end

"""
    struct CXXStdInitializerListExpr <: AbstractCXXStdInitializerListExpr
Hold a pointer to a `clang::CXXStdInitializerListExpr` object.
"""
struct CXXStdInitializerListExpr <: AbstractCXXStdInitializerListExpr
    ptr::CXCXXStdInitializerListExpr
end

"""
    struct CXXTypeidExpr <: AbstractCXXTypeidExpr
Hold a pointer to a `clang::CXXTypeidExpr` object.
"""
struct CXXTypeidExpr <: AbstractCXXTypeidExpr
    ptr::CXCXXTypeidExpr
end

"""
    struct MSPropertyRefExpr <: AbstractMSPropertyRefExpr
Hold a pointer to a `clang::MSPropertyRefExpr` object.
"""
struct MSPropertyRefExpr <: AbstractMSPropertyRefExpr
    ptr::CXMSPropertyRefExpr
end

"""
    struct MSPropertySubscriptExpr <: AbstractMSPropertySubscriptExpr
Hold a pointer to a `clang::MSPropertySubscriptExpr` object.
"""
struct MSPropertySubscriptExpr <: AbstractMSPropertySubscriptExpr
    ptr::CXMSPropertySubscriptExpr
end

"""
    struct CXXUuidofExpr <: AbstractCXXUuidofExpr
Hold a pointer to a `clang::CXXUuidofExpr` object.
"""
struct CXXUuidofExpr <: AbstractCXXUuidofExpr
    ptr::CXCXXUuidofExpr
end

"""
    struct CXXThisExpr <: AbstractCXXThisExpr
Hold a pointer to a `clang::CXXThisExpr` object.
"""
struct CXXThisExpr <: AbstractCXXThisExpr
    ptr::CXCXXThisExpr
end

"""
    struct CXXThrowExpr <: AbstractCXXThrowExpr
Hold a pointer to a `clang::CXXThrowExpr` object.
"""
struct CXXThrowExpr <: AbstractCXXThrowExpr
    ptr::CXCXXThrowExpr
end

"""
    struct CXXDefaultArgExpr <: AbstractCXXDefaultArgExpr
Hold a pointer to a `clang::CXXDefaultArgExpr` object.
"""
struct CXXDefaultArgExpr <: AbstractCXXDefaultArgExpr
    ptr::CXCXXDefaultArgExpr
end

"""
    struct CXXDefaultInitExpr <: AbstractCXXDefaultInitExpr
Hold a pointer to a `clang::CXXDefaultInitExpr` object.
"""
struct CXXDefaultInitExpr <: AbstractCXXDefaultInitExpr
    ptr::CXCXXDefaultInitExpr
end

"""
    struct CXXBindTemporaryExpr <: AbstractCXXBindTemporaryExpr
Hold a pointer to a `clang::CXXBindTemporaryExpr` object.
"""
struct CXXBindTemporaryExpr <: AbstractCXXBindTemporaryExpr
    ptr::CXCXXBindTemporaryExpr
end

"""
    struct CXXConstructExpr <: AbstractCXXConstructExpr
Hold a pointer to a `clang::CXXConstructExpr` object.
"""
struct CXXConstructExpr <: AbstractCXXConstructExpr
    ptr::CXCXXConstructExpr
end

"""
    struct CXXInheritedCtorInitExpr <: AbstractCXXInheritedCtorInitExpr
Hold a pointer to a `clang::CXXInheritedCtorInitExpr` object.
"""
struct CXXInheritedCtorInitExpr <: AbstractCXXInheritedCtorInitExpr
    ptr::CXCXXInheritedCtorInitExpr
end

"""
    struct CXXFunctionalCastExpr <: AbstractCXXFunctionalCastExpr
Hold a pointer to a `clang::CXXFunctionalCastExpr` object.
"""
struct CXXFunctionalCastExpr <: AbstractCXXFunctionalCastExpr
    ptr::CXCXXFunctionalCastExpr
end

"""
    struct CXXTemporaryObjectExpr <: AbstractCXXTemporaryObjectExpr
Hold a pointer to a `clang::CXXTemporaryObjectExpr` object.
"""
struct CXXTemporaryObjectExpr <: AbstractCXXTemporaryObjectExpr
    ptr::CXCXXTemporaryObjectExpr
end

"""
    struct LambdaExpr <: AbstractLambdaExpr
Hold a pointer to a `clang::LambdaExpr` object.
"""
struct LambdaExpr <: AbstractLambdaExpr
    ptr::CXLambdaExpr
end

"""
    struct CXXScalarValueInitExpr <: AbstractCXXScalarValueInitExpr
Hold a pointer to a `clang::CXXScalarValueInitExpr` object.
"""
struct CXXScalarValueInitExpr <: AbstractCXXScalarValueInitExpr
    ptr::CXCXXScalarValueInitExpr
end

"""
    struct CXXNewExpr <: AbstractCXXNewExpr
Hold a pointer to a `clang::CXXNewExpr` object.
"""
struct CXXNewExpr <: AbstractCXXNewExpr
    ptr::CXCXXNewExpr
end

"""
    struct CXXDeleteExpr <: AbstractCXXDeleteExpr
Hold a pointer to a `clang::CXXDeleteExpr` object.
"""
struct CXXDeleteExpr <: AbstractCXXDeleteExpr
    ptr::CXCXXDeleteExpr
end

"""
    struct CXXPseudoDestructorExpr <: AbstractCXXPseudoDestructorExpr
Hold a pointer to a `clang::CXXPseudoDestructorExpr` object.
"""
struct CXXPseudoDestructorExpr <: AbstractCXXPseudoDestructorExpr
    ptr::CXCXXPseudoDestructorExpr
end

"""
    struct TypeTraitExpr <: AbstractTypeTraitExpr
Hold a pointer to a `clang::TypeTraitExpr` object.
"""
struct TypeTraitExpr <: AbstractTypeTraitExpr
    ptr::CXTypeTraitExpr
end

"""
    struct ArrayTypeTraitExpr <: AbstractArrayTypeTraitExpr
Hold a pointer to a `clang::ArrayTypeTraitExpr` object.
"""
struct ArrayTypeTraitExpr <: AbstractArrayTypeTraitExpr
    ptr::CXArrayTypeTraitExpr
end

"""
    struct ExpressionTraitExpr <: AbstractExpressionTraitExpr
Hold a pointer to a `clang::ExpressionTraitExpr` object.
"""
struct ExpressionTraitExpr <: AbstractExpressionTraitExpr
    ptr::CXExpressionTraitExpr
end

"""
    struct OverloadExpr <: AbstractOverloadExpr
Hold a pointer to a `clang::OverloadExpr` object.
"""
struct OverloadExpr <: AbstractOverloadExpr
    ptr::CXOverloadExpr
end

"""
    struct UnresolvedLookupExpr <: AbstractUnresolvedLookupExpr
Hold a pointer to a `clang::UnresolvedLookupExpr` object.
"""
struct UnresolvedLookupExpr <: AbstractUnresolvedLookupExpr
    ptr::CXUnresolvedLookupExpr
end

"""
    struct DependentScopeDeclRefExpr <: AbstractDependentScopeDeclRefExpr
Hold a pointer to a `clang::DependentScopeDeclRefExpr` object.
"""
struct DependentScopeDeclRefExpr <: AbstractDependentScopeDeclRefExpr
    ptr::CXDependentScopeDeclRefExpr
end

"""
    struct CXXUnresolvedConstructExpr <: AbstractCXXUnresolvedConstructExpr
Hold a pointer to a `clang::CXXUnresolvedConstructExpr` object.
"""
struct CXXUnresolvedConstructExpr <: AbstractCXXUnresolvedConstructExpr
    ptr::CXCXXUnresolvedConstructExpr
end

"""
    struct CXXDependentScopeMemberExpr <: AbstractCXXDependentScopeMemberExpr
Hold a pointer to a `clang::CXXDependentScopeMemberExpr` object.
"""
struct CXXDependentScopeMemberExpr <: AbstractCXXDependentScopeMemberExpr
    ptr::CXCXXDependentScopeMemberExpr
end

"""
    struct UnresolvedMemberExpr <: AbstractUnresolvedMemberExpr
Hold a pointer to a `clang::UnresolvedMemberExpr` object.
"""
struct UnresolvedMemberExpr <: AbstractUnresolvedMemberExpr
    ptr::CXUnresolvedMemberExpr
end

"""
    struct CXXNoexceptExpr <: AbstractCXXNoexceptExpr
Hold a pointer to a `clang::CXXNoexceptExpr` object.
"""
struct CXXNoexceptExpr <: AbstractCXXNoexceptExpr
    ptr::CXCXXNoexceptExpr
end

"""
    struct PackExpansionExpr <: AbstractPackExpansionExpr
Hold a pointer to a `clang::PackExpansionExpr` object.
"""
struct PackExpansionExpr <: AbstractPackExpansionExpr
    ptr::CXPackExpansionExpr
end

"""
    struct SizeOfPackExpr <: AbstractSizeOfPackExpr
Hold a pointer to a `clang::SizeOfPackExpr` object.
"""
struct SizeOfPackExpr <: AbstractSizeOfPackExpr
    ptr::CXSizeOfPackExpr
end

"""
    struct SubstNonTypeTemplateParmExpr <: AbstractSubstNonTypeTemplateParmExpr
Hold a pointer to a `clang::SubstNonTypeTemplateParmExpr` object.
"""
struct SubstNonTypeTemplateParmExpr <: AbstractSubstNonTypeTemplateParmExpr
    ptr::CXSubstNonTypeTemplateParmExpr
end

"""
    struct SubstNonTypeTemplateParmPackExpr <: AbstractSubstNonTypeTemplateParmPackExpr
Hold a pointer to a `clang::SubstNonTypeTemplateParmPackExpr` object.
"""
struct SubstNonTypeTemplateParmPackExpr <: AbstractSubstNonTypeTemplateParmPackExpr
    ptr::CXSubstNonTypeTemplateParmPackExpr
end

"""
    struct FunctionParmPackExpr <: AbstractFunctionParmPackExpr
Hold a pointer to a `clang::FunctionParmPackExpr` object.
"""
struct FunctionParmPackExpr <: AbstractFunctionParmPackExpr
    ptr::CXFunctionParmPackExpr
end

"""
    struct MaterializeTemporaryExpr <: AbstractMaterializeTemporaryExpr
Hold a pointer to a `clang::MaterializeTemporaryExpr` object.
"""
struct MaterializeTemporaryExpr <: AbstractMaterializeTemporaryExpr
    ptr::CXMaterializeTemporaryExpr
end

"""
    struct CXXFoldExpr <: AbstractCXXFoldExpr
Hold a pointer to a `clang::CXXFoldExpr` object.
"""
struct CXXFoldExpr <: AbstractCXXFoldExpr
    ptr::CXCXXFoldExpr
end

"""
    struct CoroutineSuspendExpr <: AbstractCoroutineSuspendExpr
Hold a pointer to a `clang::CoroutineSuspendExpr` object.
"""
struct CoroutineSuspendExpr <: AbstractCoroutineSuspendExpr
    ptr::CXCoroutineSuspendExpr
end

"""
    struct CoawaitExpr <: AbstractCoawaitExpr
Hold a pointer to a `clang::CoawaitExpr` object.
"""
struct CoawaitExpr <: AbstractCoawaitExpr
    ptr::CXCoawaitExpr
end

"""
    struct DependentCoawaitExpr <: AbstractDependentCoawaitExpr
Hold a pointer to a `clang::DependentCoawaitExpr` object.
"""
struct DependentCoawaitExpr <: AbstractDependentCoawaitExpr
    ptr::CXDependentCoawaitExpr
end

"""
    struct CoyieldExpr <: AbstractCoyieldExpr
Hold a pointer to a `clang::CoyieldExpr` object.
"""
struct CoyieldExpr <: AbstractCoyieldExpr
    ptr::CXCoyieldExpr
end

"""
    struct BuiltinBitCastExpr <: AbstractBuiltinBitCastExpr
Hold a pointer to a `clang::BuiltinBitCastExpr` object.
"""
struct BuiltinBitCastExpr <: AbstractBuiltinBitCastExpr
    ptr::CXBuiltinBitCastExpr
end

"""
    struct LambdaCapture <: AbstractLambdaCapture
Hold a pointer to a `clang::LambdaCapture` object.
"""
struct LambdaCapture <: AbstractLambdaCapture
    ptr::CXLambdaCapture
end

"""
    struct CXXTemporary <: AbstractCXXTemporary
Hold a pointer to a `clang::CXXTemporary` object.
"""
struct CXXTemporary <: AbstractCXXTemporary
    ptr::CXCXXTemporary
end
