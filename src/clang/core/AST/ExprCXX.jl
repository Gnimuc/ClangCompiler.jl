"""
    struct CXXOperatorCallExpr <: AbstractCXXOperatorCallExpr
Hold a pointer to a `clang::CXXOperatorCallExpr` object.
"""
struct CXXOperatorCallExpr <: AbstractCXXOperatorCallExpr
    ptr::CXCXXOperatorCallExpr
end

Base.unsafe_convert(::Type{CXCXXOperatorCallExpr}, x::CXXOperatorCallExpr) = x.ptr
Base.cconvert(::Type{CXCXXOperatorCallExpr}, x::CXXOperatorCallExpr) = x

"""
    struct CXXMemberCallExpr <: AbstractCXXMemberCallExpr
Hold a pointer to a `clang::CXXMemberCallExpr` object.
"""
struct CXXMemberCallExpr <: AbstractCXXMemberCallExpr
    ptr::CXCXXMemberCallExpr
end

Base.unsafe_convert(::Type{CXCXXMemberCallExpr}, x::CXXMemberCallExpr) = x.ptr
Base.cconvert(::Type{CXCXXMemberCallExpr}, x::CXXMemberCallExpr) = x

"""
    struct CUDAKernelCallExpr <: AbstractCUDAKernelCallExpr
Hold a pointer to a `clang::CUDAKernelCallExpr` object.
"""
struct CUDAKernelCallExpr <: AbstractCUDAKernelCallExpr
    ptr::CXCUDAKernelCallExpr
end

Base.unsafe_convert(::Type{CXCUDAKernelCallExpr}, x::CUDAKernelCallExpr) = x.ptr
Base.cconvert(::Type{CXCUDAKernelCallExpr}, x::CUDAKernelCallExpr) = x

"""
    struct CXXRewrittenBinaryOperator <: AbstractCXXRewrittenBinaryOperator
Hold a pointer to a `clang::CXXRewrittenBinaryOperator` object.
"""
struct CXXRewrittenBinaryOperator <: AbstractCXXRewrittenBinaryOperator
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
    struct CXXStaticCastExpr <: AbstractCXXStaticCastExpr
Hold a pointer to a `clang::CXXStaticCastExpr` object.
"""
struct CXXStaticCastExpr <: AbstractCXXStaticCastExpr
    ptr::CXCXXStaticCastExpr
end

Base.unsafe_convert(::Type{CXCXXStaticCastExpr}, x::CXXStaticCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXStaticCastExpr}, x::CXXStaticCastExpr) = x

"""
    struct CXXDynamicCastExpr <: AbstractCXXDynamicCastExpr
Hold a pointer to a `clang::CXXDynamicCastExpr` object.
"""
struct CXXDynamicCastExpr <: AbstractCXXDynamicCastExpr
    ptr::CXCXXDynamicCastExpr
end

Base.unsafe_convert(::Type{CXCXXDynamicCastExpr}, x::CXXDynamicCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXDynamicCastExpr}, x::CXXDynamicCastExpr) = x

"""
    struct CXXReinterpretCastExpr <: AbstractCXXReinterpretCastExpr
Hold a pointer to a `clang::CXXReinterpretCastExpr` object.
"""
struct CXXReinterpretCastExpr <: AbstractCXXReinterpretCastExpr
    ptr::CXCXXReinterpretCastExpr
end

Base.unsafe_convert(::Type{CXCXXReinterpretCastExpr}, x::CXXReinterpretCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXReinterpretCastExpr}, x::CXXReinterpretCastExpr) = x

"""
    struct CXXConstCastExpr <: AbstractCXXConstCastExpr
Hold a pointer to a `clang::CXXConstCastExpr` object.
"""
struct CXXConstCastExpr <: AbstractCXXConstCastExpr
    ptr::CXCXXConstCastExpr
end

Base.unsafe_convert(::Type{CXCXXConstCastExpr}, x::CXXConstCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXConstCastExpr}, x::CXXConstCastExpr) = x

"""
    struct CXXAddrspaceCastExpr <: AbstractCXXAddrspaceCastExpr
Hold a pointer to a `clang::CXXAddrspaceCastExpr` object.
"""
struct CXXAddrspaceCastExpr <: AbstractCXXAddrspaceCastExpr
    ptr::CXCXXAddrspaceCastExpr
end

Base.unsafe_convert(::Type{CXCXXAddrspaceCastExpr}, x::CXXAddrspaceCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXAddrspaceCastExpr}, x::CXXAddrspaceCastExpr) = x

"""
    struct UserDefinedLiteral <: AbstractUserDefinedLiteral
Hold a pointer to a `clang::UserDefinedLiteral` object.
"""
struct UserDefinedLiteral <: AbstractUserDefinedLiteral
    ptr::CXUserDefinedLiteral
end

Base.unsafe_convert(::Type{CXUserDefinedLiteral}, x::UserDefinedLiteral) = x.ptr
Base.cconvert(::Type{CXUserDefinedLiteral}, x::UserDefinedLiteral) = x

"""
    struct CXXBoolLiteralExpr <: AbstractCXXBoolLiteralExpr
Hold a pointer to a `clang::CXXBoolLiteralExpr` object.
"""
struct CXXBoolLiteralExpr <: AbstractCXXBoolLiteralExpr
    ptr::CXCXXBoolLiteralExpr
end

Base.unsafe_convert(::Type{CXCXXBoolLiteralExpr}, x::CXXBoolLiteralExpr) = x.ptr
Base.cconvert(::Type{CXCXXBoolLiteralExpr}, x::CXXBoolLiteralExpr) = x

"""
    struct CXXNullPtrLiteralExpr <: AbstractCXXNullPtrLiteralExpr
Hold a pointer to a `clang::CXXNullPtrLiteralExpr` object.
"""
struct CXXNullPtrLiteralExpr <: AbstractCXXNullPtrLiteralExpr
    ptr::CXCXXNullPtrLiteralExpr
end

Base.unsafe_convert(::Type{CXCXXNullPtrLiteralExpr}, x::CXXNullPtrLiteralExpr) = x.ptr
Base.cconvert(::Type{CXCXXNullPtrLiteralExpr}, x::CXXNullPtrLiteralExpr) = x

"""
    struct CXXStdInitializerListExpr <: AbstractCXXStdInitializerListExpr
Hold a pointer to a `clang::CXXStdInitializerListExpr` object.
"""
struct CXXStdInitializerListExpr <: AbstractCXXStdInitializerListExpr
    ptr::CXCXXStdInitializerListExpr
end

Base.unsafe_convert(::Type{CXCXXStdInitializerListExpr}, x::CXXStdInitializerListExpr) = x.ptr
Base.cconvert(::Type{CXCXXStdInitializerListExpr}, x::CXXStdInitializerListExpr) = x

"""
    struct CXXTypeidExpr <: AbstractCXXTypeidExpr
Hold a pointer to a `clang::CXXTypeidExpr` object.
"""
struct CXXTypeidExpr <: AbstractCXXTypeidExpr
    ptr::CXCXXTypeidExpr
end

Base.unsafe_convert(::Type{CXCXXTypeidExpr}, x::CXXTypeidExpr) = x.ptr
Base.cconvert(::Type{CXCXXTypeidExpr}, x::CXXTypeidExpr) = x

"""
    struct MSPropertyRefExpr <: AbstractMSPropertyRefExpr
Hold a pointer to a `clang::MSPropertyRefExpr` object.
"""
struct MSPropertyRefExpr <: AbstractMSPropertyRefExpr
    ptr::CXMSPropertyRefExpr
end

Base.unsafe_convert(::Type{CXMSPropertyRefExpr}, x::MSPropertyRefExpr) = x.ptr
Base.cconvert(::Type{CXMSPropertyRefExpr}, x::MSPropertyRefExpr) = x

"""
    struct MSPropertySubscriptExpr <: AbstractMSPropertySubscriptExpr
Hold a pointer to a `clang::MSPropertySubscriptExpr` object.
"""
struct MSPropertySubscriptExpr <: AbstractMSPropertySubscriptExpr
    ptr::CXMSPropertySubscriptExpr
end

Base.unsafe_convert(::Type{CXMSPropertySubscriptExpr}, x::MSPropertySubscriptExpr) = x.ptr
Base.cconvert(::Type{CXMSPropertySubscriptExpr}, x::MSPropertySubscriptExpr) = x

"""
    struct CXXUuidofExpr <: AbstractCXXUuidofExpr
Hold a pointer to a `clang::CXXUuidofExpr` object.
"""
struct CXXUuidofExpr <: AbstractCXXUuidofExpr
    ptr::CXCXXUuidofExpr
end

Base.unsafe_convert(::Type{CXCXXUuidofExpr}, x::CXXUuidofExpr) = x.ptr
Base.cconvert(::Type{CXCXXUuidofExpr}, x::CXXUuidofExpr) = x

"""
    struct CXXThisExpr <: AbstractCXXThisExpr
Hold a pointer to a `clang::CXXThisExpr` object.
"""
struct CXXThisExpr <: AbstractCXXThisExpr
    ptr::CXCXXThisExpr
end

Base.unsafe_convert(::Type{CXCXXThisExpr}, x::CXXThisExpr) = x.ptr
Base.cconvert(::Type{CXCXXThisExpr}, x::CXXThisExpr) = x

"""
    struct CXXThrowExpr <: AbstractCXXThrowExpr
Hold a pointer to a `clang::CXXThrowExpr` object.
"""
struct CXXThrowExpr <: AbstractCXXThrowExpr
    ptr::CXCXXThrowExpr
end

Base.unsafe_convert(::Type{CXCXXThrowExpr}, x::CXXThrowExpr) = x.ptr
Base.cconvert(::Type{CXCXXThrowExpr}, x::CXXThrowExpr) = x

"""
    struct CXXDefaultArgExpr <: AbstractCXXDefaultArgExpr
Hold a pointer to a `clang::CXXDefaultArgExpr` object.
"""
struct CXXDefaultArgExpr <: AbstractCXXDefaultArgExpr
    ptr::CXCXXDefaultArgExpr
end

Base.unsafe_convert(::Type{CXCXXDefaultArgExpr}, x::CXXDefaultArgExpr) = x.ptr
Base.cconvert(::Type{CXCXXDefaultArgExpr}, x::CXXDefaultArgExpr) = x

"""
    struct CXXDefaultInitExpr <: AbstractCXXDefaultInitExpr
Hold a pointer to a `clang::CXXDefaultInitExpr` object.
"""
struct CXXDefaultInitExpr <: AbstractCXXDefaultInitExpr
    ptr::CXCXXDefaultInitExpr
end

Base.unsafe_convert(::Type{CXCXXDefaultInitExpr}, x::CXXDefaultInitExpr) = x.ptr
Base.cconvert(::Type{CXCXXDefaultInitExpr}, x::CXXDefaultInitExpr) = x

"""
    struct CXXBindTemporaryExpr <: AbstractCXXBindTemporaryExpr
Hold a pointer to a `clang::CXXBindTemporaryExpr` object.
"""
struct CXXBindTemporaryExpr <: AbstractCXXBindTemporaryExpr
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
    struct CXXInheritedCtorInitExpr <: AbstractCXXInheritedCtorInitExpr
Hold a pointer to a `clang::CXXInheritedCtorInitExpr` object.
"""
struct CXXInheritedCtorInitExpr <: AbstractCXXInheritedCtorInitExpr
    ptr::CXCXXInheritedCtorInitExpr
end

Base.unsafe_convert(::Type{CXCXXInheritedCtorInitExpr}, x::CXXInheritedCtorInitExpr) = x.ptr
Base.cconvert(::Type{CXCXXInheritedCtorInitExpr}, x::CXXInheritedCtorInitExpr) = x

"""
    struct CXXFunctionalCastExpr <: AbstractCXXFunctionalCastExpr
Hold a pointer to a `clang::CXXFunctionalCastExpr` object.
"""
struct CXXFunctionalCastExpr <: AbstractCXXFunctionalCastExpr
    ptr::CXCXXFunctionalCastExpr
end

Base.unsafe_convert(::Type{CXCXXFunctionalCastExpr}, x::CXXFunctionalCastExpr) = x.ptr
Base.cconvert(::Type{CXCXXFunctionalCastExpr}, x::CXXFunctionalCastExpr) = x

"""
    struct CXXTemporaryObjectExpr <: AbstractCXXTemporaryObjectExpr
Hold a pointer to a `clang::CXXTemporaryObjectExpr` object.
"""
struct CXXTemporaryObjectExpr <: AbstractCXXTemporaryObjectExpr
    ptr::CXCXXTemporaryObjectExpr
end

Base.unsafe_convert(::Type{CXCXXTemporaryObjectExpr}, x::CXXTemporaryObjectExpr) = x.ptr
Base.cconvert(::Type{CXCXXTemporaryObjectExpr}, x::CXXTemporaryObjectExpr) = x

"""
    struct LambdaExpr <: AbstractLambdaExpr
Hold a pointer to a `clang::LambdaExpr` object.
"""
struct LambdaExpr <: AbstractLambdaExpr
    ptr::CXLambdaExpr
end

Base.unsafe_convert(::Type{CXLambdaExpr}, x::LambdaExpr) = x.ptr
Base.cconvert(::Type{CXLambdaExpr}, x::LambdaExpr) = x

"""
    struct CXXScalarValueInitExpr <: AbstractCXXScalarValueInitExpr
Hold a pointer to a `clang::CXXScalarValueInitExpr` object.
"""
struct CXXScalarValueInitExpr <: AbstractCXXScalarValueInitExpr
    ptr::CXCXXScalarValueInitExpr
end

Base.unsafe_convert(::Type{CXCXXScalarValueInitExpr}, x::CXXScalarValueInitExpr) = x.ptr
Base.cconvert(::Type{CXCXXScalarValueInitExpr}, x::CXXScalarValueInitExpr) = x

"""
    struct CXXNewExpr <: AbstractCXXNewExpr
Hold a pointer to a `clang::CXXNewExpr` object.
"""
struct CXXNewExpr <: AbstractCXXNewExpr
    ptr::CXCXXNewExpr
end

Base.unsafe_convert(::Type{CXCXXNewExpr}, x::CXXNewExpr) = x.ptr
Base.cconvert(::Type{CXCXXNewExpr}, x::CXXNewExpr) = x

"""
    struct CXXDeleteExpr <: AbstractCXXDeleteExpr
Hold a pointer to a `clang::CXXDeleteExpr` object.
"""
struct CXXDeleteExpr <: AbstractCXXDeleteExpr
    ptr::CXCXXDeleteExpr
end

Base.unsafe_convert(::Type{CXCXXDeleteExpr}, x::CXXDeleteExpr) = x.ptr
Base.cconvert(::Type{CXCXXDeleteExpr}, x::CXXDeleteExpr) = x

"""
    struct CXXPseudoDestructorExpr <: AbstractCXXPseudoDestructorExpr
Hold a pointer to a `clang::CXXPseudoDestructorExpr` object.
"""
struct CXXPseudoDestructorExpr <: AbstractCXXPseudoDestructorExpr
    ptr::CXCXXPseudoDestructorExpr
end

Base.unsafe_convert(::Type{CXCXXPseudoDestructorExpr}, x::CXXPseudoDestructorExpr) = x.ptr
Base.cconvert(::Type{CXCXXPseudoDestructorExpr}, x::CXXPseudoDestructorExpr) = x

"""
    struct TypeTraitExpr <: AbstractTypeTraitExpr
Hold a pointer to a `clang::TypeTraitExpr` object.
"""
struct TypeTraitExpr <: AbstractTypeTraitExpr
    ptr::CXTypeTraitExpr
end

Base.unsafe_convert(::Type{CXTypeTraitExpr}, x::TypeTraitExpr) = x.ptr
Base.cconvert(::Type{CXTypeTraitExpr}, x::TypeTraitExpr) = x

"""
    struct ArrayTypeTraitExpr <: AbstractArrayTypeTraitExpr
Hold a pointer to a `clang::ArrayTypeTraitExpr` object.
"""
struct ArrayTypeTraitExpr <: AbstractArrayTypeTraitExpr
    ptr::CXArrayTypeTraitExpr
end

Base.unsafe_convert(::Type{CXArrayTypeTraitExpr}, x::ArrayTypeTraitExpr) = x.ptr
Base.cconvert(::Type{CXArrayTypeTraitExpr}, x::ArrayTypeTraitExpr) = x

"""
    struct ExpressionTraitExpr <: AbstractExpressionTraitExpr
Hold a pointer to a `clang::ExpressionTraitExpr` object.
"""
struct ExpressionTraitExpr <: AbstractExpressionTraitExpr
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
    struct UnresolvedLookupExpr <: AbstractUnresolvedLookupExpr
Hold a pointer to a `clang::UnresolvedLookupExpr` object.
"""
struct UnresolvedLookupExpr <: AbstractUnresolvedLookupExpr
    ptr::CXUnresolvedLookupExpr
end

Base.unsafe_convert(::Type{CXUnresolvedLookupExpr}, x::UnresolvedLookupExpr) = x.ptr
Base.cconvert(::Type{CXUnresolvedLookupExpr}, x::UnresolvedLookupExpr) = x

"""
    struct DependentScopeDeclRefExpr <: AbstractDependentScopeDeclRefExpr
Hold a pointer to a `clang::DependentScopeDeclRefExpr` object.
"""
struct DependentScopeDeclRefExpr <: AbstractDependentScopeDeclRefExpr
    ptr::CXDependentScopeDeclRefExpr
end

Base.unsafe_convert(::Type{CXDependentScopeDeclRefExpr}, x::DependentScopeDeclRefExpr) = x.ptr
Base.cconvert(::Type{CXDependentScopeDeclRefExpr}, x::DependentScopeDeclRefExpr) = x

"""
    struct CXXUnresolvedConstructExpr <: AbstractCXXUnresolvedConstructExpr
Hold a pointer to a `clang::CXXUnresolvedConstructExpr` object.
"""
struct CXXUnresolvedConstructExpr <: AbstractCXXUnresolvedConstructExpr
    ptr::CXCXXUnresolvedConstructExpr
end

Base.unsafe_convert(::Type{CXCXXUnresolvedConstructExpr}, x::CXXUnresolvedConstructExpr) = x.ptr
Base.cconvert(::Type{CXCXXUnresolvedConstructExpr}, x::CXXUnresolvedConstructExpr) = x

"""
    struct CXXDependentScopeMemberExpr <: AbstractCXXDependentScopeMemberExpr
Hold a pointer to a `clang::CXXDependentScopeMemberExpr` object.
"""
struct CXXDependentScopeMemberExpr <: AbstractCXXDependentScopeMemberExpr
    ptr::CXCXXDependentScopeMemberExpr
end

Base.unsafe_convert(::Type{CXCXXDependentScopeMemberExpr}, x::CXXDependentScopeMemberExpr) = x.ptr
Base.cconvert(::Type{CXCXXDependentScopeMemberExpr}, x::CXXDependentScopeMemberExpr) = x

"""
    struct UnresolvedMemberExpr <: AbstractUnresolvedMemberExpr
Hold a pointer to a `clang::UnresolvedMemberExpr` object.
"""
struct UnresolvedMemberExpr <: AbstractUnresolvedMemberExpr
    ptr::CXUnresolvedMemberExpr
end

Base.unsafe_convert(::Type{CXUnresolvedMemberExpr}, x::UnresolvedMemberExpr) = x.ptr
Base.cconvert(::Type{CXUnresolvedMemberExpr}, x::UnresolvedMemberExpr) = x

"""
    struct CXXNoexceptExpr <: AbstractCXXNoexceptExpr
Hold a pointer to a `clang::CXXNoexceptExpr` object.
"""
struct CXXNoexceptExpr <: AbstractCXXNoexceptExpr
    ptr::CXCXXNoexceptExpr
end

Base.unsafe_convert(::Type{CXCXXNoexceptExpr}, x::CXXNoexceptExpr) = x.ptr
Base.cconvert(::Type{CXCXXNoexceptExpr}, x::CXXNoexceptExpr) = x

"""
    struct PackExpansionExpr <: AbstractPackExpansionExpr
Hold a pointer to a `clang::PackExpansionExpr` object.
"""
struct PackExpansionExpr <: AbstractPackExpansionExpr
    ptr::CXPackExpansionExpr
end

Base.unsafe_convert(::Type{CXPackExpansionExpr}, x::PackExpansionExpr) = x.ptr
Base.cconvert(::Type{CXPackExpansionExpr}, x::PackExpansionExpr) = x

"""
    struct SizeOfPackExpr <: AbstractSizeOfPackExpr
Hold a pointer to a `clang::SizeOfPackExpr` object.
"""
struct SizeOfPackExpr <: AbstractSizeOfPackExpr
    ptr::CXSizeOfPackExpr
end

Base.unsafe_convert(::Type{CXSizeOfPackExpr}, x::SizeOfPackExpr) = x.ptr
Base.cconvert(::Type{CXSizeOfPackExpr}, x::SizeOfPackExpr) = x

"""
    struct SubstNonTypeTemplateParmExpr <: AbstractSubstNonTypeTemplateParmExpr
Hold a pointer to a `clang::SubstNonTypeTemplateParmExpr` object.
"""
struct SubstNonTypeTemplateParmExpr <: AbstractSubstNonTypeTemplateParmExpr
    ptr::CXSubstNonTypeTemplateParmExpr
end

Base.unsafe_convert(::Type{CXSubstNonTypeTemplateParmExpr}, x::SubstNonTypeTemplateParmExpr) = x.ptr
Base.cconvert(::Type{CXSubstNonTypeTemplateParmExpr}, x::SubstNonTypeTemplateParmExpr) = x

"""
    struct SubstNonTypeTemplateParmPackExpr <: AbstractSubstNonTypeTemplateParmPackExpr
Hold a pointer to a `clang::SubstNonTypeTemplateParmPackExpr` object.
"""
struct SubstNonTypeTemplateParmPackExpr <: AbstractSubstNonTypeTemplateParmPackExpr
    ptr::CXSubstNonTypeTemplateParmPackExpr
end

Base.unsafe_convert(::Type{CXSubstNonTypeTemplateParmPackExpr}, x::SubstNonTypeTemplateParmPackExpr) = x.ptr
Base.cconvert(::Type{CXSubstNonTypeTemplateParmPackExpr}, x::SubstNonTypeTemplateParmPackExpr) = x

"""
    struct FunctionParmPackExpr <: AbstractFunctionParmPackExpr
Hold a pointer to a `clang::FunctionParmPackExpr` object.
"""
struct FunctionParmPackExpr <: AbstractFunctionParmPackExpr
    ptr::CXFunctionParmPackExpr
end

Base.unsafe_convert(::Type{CXFunctionParmPackExpr}, x::FunctionParmPackExpr) = x.ptr
Base.cconvert(::Type{CXFunctionParmPackExpr}, x::FunctionParmPackExpr) = x

"""
    struct MaterializeTemporaryExpr <: AbstractMaterializeTemporaryExpr
Hold a pointer to a `clang::MaterializeTemporaryExpr` object.
"""
struct MaterializeTemporaryExpr <: AbstractMaterializeTemporaryExpr
    ptr::CXMaterializeTemporaryExpr
end

Base.unsafe_convert(::Type{CXMaterializeTemporaryExpr}, x::MaterializeTemporaryExpr) = x.ptr
Base.cconvert(::Type{CXMaterializeTemporaryExpr}, x::MaterializeTemporaryExpr) = x

"""
    struct CXXFoldExpr <: AbstractCXXFoldExpr
Hold a pointer to a `clang::CXXFoldExpr` object.
"""
struct CXXFoldExpr <: AbstractCXXFoldExpr
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
    struct CoawaitExpr <: AbstractCoawaitExpr
Hold a pointer to a `clang::CoawaitExpr` object.
"""
struct CoawaitExpr <: AbstractCoawaitExpr
    ptr::CXCoawaitExpr
end

Base.unsafe_convert(::Type{CXCoawaitExpr}, x::CoawaitExpr) = x.ptr
Base.cconvert(::Type{CXCoawaitExpr}, x::CoawaitExpr) = x

"""
    struct DependentCoawaitExpr <: AbstractDependentCoawaitExpr
Hold a pointer to a `clang::DependentCoawaitExpr` object.
"""
struct DependentCoawaitExpr <: AbstractDependentCoawaitExpr
    ptr::CXDependentCoawaitExpr
end

Base.unsafe_convert(::Type{CXDependentCoawaitExpr}, x::DependentCoawaitExpr) = x.ptr
Base.cconvert(::Type{CXDependentCoawaitExpr}, x::DependentCoawaitExpr) = x

"""
    struct CoyieldExpr <: AbstractCoyieldExpr
Hold a pointer to a `clang::CoyieldExpr` object.
"""
struct CoyieldExpr <: AbstractCoyieldExpr
    ptr::CXCoyieldExpr
end

Base.unsafe_convert(::Type{CXCoyieldExpr}, x::CoyieldExpr) = x.ptr
Base.cconvert(::Type{CXCoyieldExpr}, x::CoyieldExpr) = x

"""
    struct BuiltinBitCastExpr <: AbstractBuiltinBitCastExpr
Hold a pointer to a `clang::BuiltinBitCastExpr` object.
"""
struct BuiltinBitCastExpr <: AbstractBuiltinBitCastExpr
    ptr::CXBuiltinBitCastExpr
end

Base.unsafe_convert(::Type{CXBuiltinBitCastExpr}, x::BuiltinBitCastExpr) = x.ptr
Base.cconvert(::Type{CXBuiltinBitCastExpr}, x::BuiltinBitCastExpr) = x

"""
    struct LambdaCapture <: AbstractLambdaCapture
Hold a pointer to a `clang::LambdaCapture` object.
"""
struct LambdaCapture <: AbstractLambdaCapture
    ptr::CXLambdaCapture
end

Base.unsafe_convert(::Type{CXLambdaCapture}, x::LambdaCapture) = x.ptr
Base.cconvert(::Type{CXLambdaCapture}, x::LambdaCapture) = x

"""
    struct CXXTemporary <: AbstractCXXTemporary
Hold a pointer to a `clang::CXXTemporary` object.
"""
struct CXXTemporary <: AbstractCXXTemporary
    ptr::CXCXXTemporary
end

Base.unsafe_convert(::Type{CXCXXTemporary}, x::CXXTemporary) = x.ptr
Base.cconvert(::Type{CXCXXTemporary}, x::CXXTemporary) = x
