# Generated from deps/ClangExtra/include/clang-ex/AST/StmtNodes.inc by gen/stmt_nodes.jl — do not edit.
# Abstract-type skeleton for the Stmt hierarchy not already defined in abstract.jl.
"""
    abstract type AbstractWhileStmt <: AbstractStmt
Supertype for `WhileStmt`s.
"""
abstract type AbstractWhileStmt <: AbstractStmt end

"""
    abstract type AbstractLabelStmt <: AbstractValueStmt
Supertype for `LabelStmt`s.
"""
abstract type AbstractLabelStmt <: AbstractValueStmt end

"""
    abstract type AbstractVAArgExpr <: AbstractExpr
Supertype for `VAArgExpr`s.
"""
abstract type AbstractVAArgExpr <: AbstractExpr end

"""
    abstract type AbstractUnaryOperator <: AbstractExpr
Supertype for `UnaryOperator`s.
"""
abstract type AbstractUnaryOperator <: AbstractExpr end

"""
    abstract type AbstractUnaryExprOrTypeTraitExpr <: AbstractExpr
Supertype for `UnaryExprOrTypeTraitExpr`s.
"""
abstract type AbstractUnaryExprOrTypeTraitExpr <: AbstractExpr end

"""
    abstract type AbstractTypoExpr <: AbstractExpr
Supertype for `TypoExpr`s.
"""
abstract type AbstractTypoExpr <: AbstractExpr end

"""
    abstract type AbstractTypeTraitExpr <: AbstractExpr
Supertype for `TypeTraitExpr`s.
"""
abstract type AbstractTypeTraitExpr <: AbstractExpr end

"""
    abstract type AbstractSubstNonTypeTemplateParmPackExpr <: AbstractExpr
Supertype for `SubstNonTypeTemplateParmPackExpr`s.
"""
abstract type AbstractSubstNonTypeTemplateParmPackExpr <: AbstractExpr end

"""
    abstract type AbstractSubstNonTypeTemplateParmExpr <: AbstractExpr
Supertype for `SubstNonTypeTemplateParmExpr`s.
"""
abstract type AbstractSubstNonTypeTemplateParmExpr <: AbstractExpr end

"""
    abstract type AbstractStringLiteral <: AbstractExpr
Supertype for `StringLiteral`s.
"""
abstract type AbstractStringLiteral <: AbstractExpr end

"""
    abstract type AbstractStmtExpr <: AbstractExpr
Supertype for `StmtExpr`s.
"""
abstract type AbstractStmtExpr <: AbstractExpr end

"""
    abstract type AbstractSourceLocExpr <: AbstractExpr
Supertype for `SourceLocExpr`s.
"""
abstract type AbstractSourceLocExpr <: AbstractExpr end

"""
    abstract type AbstractSizeOfPackExpr <: AbstractExpr
Supertype for `SizeOfPackExpr`s.
"""
abstract type AbstractSizeOfPackExpr <: AbstractExpr end

"""
    abstract type AbstractShuffleVectorExpr <: AbstractExpr
Supertype for `ShuffleVectorExpr`s.
"""
abstract type AbstractShuffleVectorExpr <: AbstractExpr end

"""
    abstract type AbstractSYCLUniqueStableNameExpr <: AbstractExpr
Supertype for `SYCLUniqueStableNameExpr`s.
"""
abstract type AbstractSYCLUniqueStableNameExpr <: AbstractExpr end

"""
    abstract type AbstractRequiresExpr <: AbstractExpr
Supertype for `RequiresExpr`s.
"""
abstract type AbstractRequiresExpr <: AbstractExpr end

"""
    abstract type AbstractRecoveryExpr <: AbstractExpr
Supertype for `RecoveryExpr`s.
"""
abstract type AbstractRecoveryExpr <: AbstractExpr end

"""
    abstract type AbstractPseudoObjectExpr <: AbstractExpr
Supertype for `PseudoObjectExpr`s.
"""
abstract type AbstractPseudoObjectExpr <: AbstractExpr end

"""
    abstract type AbstractPredefinedExpr <: AbstractExpr
Supertype for `PredefinedExpr`s.
"""
abstract type AbstractPredefinedExpr <: AbstractExpr end

"""
    abstract type AbstractParenListExpr <: AbstractExpr
Supertype for `ParenListExpr`s.
"""
abstract type AbstractParenListExpr <: AbstractExpr end

"""
    abstract type AbstractParenExpr <: AbstractExpr
Supertype for `ParenExpr`s.
"""
abstract type AbstractParenExpr <: AbstractExpr end

"""
    abstract type AbstractPackExpansionExpr <: AbstractExpr
Supertype for `PackExpansionExpr`s.
"""
abstract type AbstractPackExpansionExpr <: AbstractExpr end

"""
    abstract type AbstractUnresolvedMemberExpr <: AbstractOverloadExpr
Supertype for `UnresolvedMemberExpr`s.
"""
abstract type AbstractUnresolvedMemberExpr <: AbstractOverloadExpr end

"""
    abstract type AbstractUnresolvedLookupExpr <: AbstractOverloadExpr
Supertype for `UnresolvedLookupExpr`s.
"""
abstract type AbstractUnresolvedLookupExpr <: AbstractOverloadExpr end

"""
    abstract type AbstractOpaqueValueExpr <: AbstractExpr
Supertype for `OpaqueValueExpr`s.
"""
abstract type AbstractOpaqueValueExpr <: AbstractExpr end

"""
    abstract type AbstractOffsetOfExpr <: AbstractExpr
Supertype for `OffsetOfExpr`s.
"""
abstract type AbstractOffsetOfExpr <: AbstractExpr end

"""
    abstract type AbstractObjCSubscriptRefExpr <: AbstractExpr
Supertype for `ObjCSubscriptRefExpr`s.
"""
abstract type AbstractObjCSubscriptRefExpr <: AbstractExpr end

"""
    abstract type AbstractObjCStringLiteral <: AbstractExpr
Supertype for `ObjCStringLiteral`s.
"""
abstract type AbstractObjCStringLiteral <: AbstractExpr end

"""
    abstract type AbstractObjCSelectorExpr <: AbstractExpr
Supertype for `ObjCSelectorExpr`s.
"""
abstract type AbstractObjCSelectorExpr <: AbstractExpr end

"""
    abstract type AbstractObjCProtocolExpr <: AbstractExpr
Supertype for `ObjCProtocolExpr`s.
"""
abstract type AbstractObjCProtocolExpr <: AbstractExpr end

"""
    abstract type AbstractObjCPropertyRefExpr <: AbstractExpr
Supertype for `ObjCPropertyRefExpr`s.
"""
abstract type AbstractObjCPropertyRefExpr <: AbstractExpr end

"""
    abstract type AbstractObjCMessageExpr <: AbstractExpr
Supertype for `ObjCMessageExpr`s.
"""
abstract type AbstractObjCMessageExpr <: AbstractExpr end

"""
    abstract type AbstractObjCIvarRefExpr <: AbstractExpr
Supertype for `ObjCIvarRefExpr`s.
"""
abstract type AbstractObjCIvarRefExpr <: AbstractExpr end

"""
    abstract type AbstractObjCIsaExpr <: AbstractExpr
Supertype for `ObjCIsaExpr`s.
"""
abstract type AbstractObjCIsaExpr <: AbstractExpr end

"""
    abstract type AbstractObjCIndirectCopyRestoreExpr <: AbstractExpr
Supertype for `ObjCIndirectCopyRestoreExpr`s.
"""
abstract type AbstractObjCIndirectCopyRestoreExpr <: AbstractExpr end

"""
    abstract type AbstractObjCEncodeExpr <: AbstractExpr
Supertype for `ObjCEncodeExpr`s.
"""
abstract type AbstractObjCEncodeExpr <: AbstractExpr end

"""
    abstract type AbstractObjCDictionaryLiteral <: AbstractExpr
Supertype for `ObjCDictionaryLiteral`s.
"""
abstract type AbstractObjCDictionaryLiteral <: AbstractExpr end

"""
    abstract type AbstractObjCBoxedExpr <: AbstractExpr
Supertype for `ObjCBoxedExpr`s.
"""
abstract type AbstractObjCBoxedExpr <: AbstractExpr end

"""
    abstract type AbstractObjCBoolLiteralExpr <: AbstractExpr
Supertype for `ObjCBoolLiteralExpr`s.
"""
abstract type AbstractObjCBoolLiteralExpr <: AbstractExpr end

"""
    abstract type AbstractObjCAvailabilityCheckExpr <: AbstractExpr
Supertype for `ObjCAvailabilityCheckExpr`s.
"""
abstract type AbstractObjCAvailabilityCheckExpr <: AbstractExpr end

"""
    abstract type AbstractObjCArrayLiteral <: AbstractExpr
Supertype for `ObjCArrayLiteral`s.
"""
abstract type AbstractObjCArrayLiteral <: AbstractExpr end

"""
    abstract type AbstractOMPIteratorExpr <: AbstractExpr
Supertype for `OMPIteratorExpr`s.
"""
abstract type AbstractOMPIteratorExpr <: AbstractExpr end

"""
    abstract type AbstractOMPArrayShapingExpr <: AbstractExpr
Supertype for `OMPArrayShapingExpr`s.
"""
abstract type AbstractOMPArrayShapingExpr <: AbstractExpr end

"""
    abstract type AbstractOMPArraySectionExpr <: AbstractExpr
Supertype for `OMPArraySectionExpr`s.
"""
abstract type AbstractOMPArraySectionExpr <: AbstractExpr end

"""
    abstract type AbstractNoInitExpr <: AbstractExpr
Supertype for `NoInitExpr`s.
"""
abstract type AbstractNoInitExpr <: AbstractExpr end

"""
    abstract type AbstractMemberExpr <: AbstractExpr
Supertype for `MemberExpr`s.
"""
abstract type AbstractMemberExpr <: AbstractExpr end

"""
    abstract type AbstractMatrixSubscriptExpr <: AbstractExpr
Supertype for `MatrixSubscriptExpr`s.
"""
abstract type AbstractMatrixSubscriptExpr <: AbstractExpr end

"""
    abstract type AbstractMaterializeTemporaryExpr <: AbstractExpr
Supertype for `MaterializeTemporaryExpr`s.
"""
abstract type AbstractMaterializeTemporaryExpr <: AbstractExpr end

"""
    abstract type AbstractMSPropertySubscriptExpr <: AbstractExpr
Supertype for `MSPropertySubscriptExpr`s.
"""
abstract type AbstractMSPropertySubscriptExpr <: AbstractExpr end

"""
    abstract type AbstractMSPropertyRefExpr <: AbstractExpr
Supertype for `MSPropertyRefExpr`s.
"""
abstract type AbstractMSPropertyRefExpr <: AbstractExpr end

"""
    abstract type AbstractLambdaExpr <: AbstractExpr
Supertype for `LambdaExpr`s.
"""
abstract type AbstractLambdaExpr <: AbstractExpr end

"""
    abstract type AbstractIntegerLiteral <: AbstractExpr
Supertype for `IntegerLiteral`s.
"""
abstract type AbstractIntegerLiteral <: AbstractExpr end

"""
    abstract type AbstractInitListExpr <: AbstractExpr
Supertype for `InitListExpr`s.
"""
abstract type AbstractInitListExpr <: AbstractExpr end

"""
    abstract type AbstractImplicitValueInitExpr <: AbstractExpr
Supertype for `ImplicitValueInitExpr`s.
"""
abstract type AbstractImplicitValueInitExpr <: AbstractExpr end

"""
    abstract type AbstractImaginaryLiteral <: AbstractExpr
Supertype for `ImaginaryLiteral`s.
"""
abstract type AbstractImaginaryLiteral <: AbstractExpr end

"""
    abstract type AbstractGenericSelectionExpr <: AbstractExpr
Supertype for `GenericSelectionExpr`s.
"""
abstract type AbstractGenericSelectionExpr <: AbstractExpr end

"""
    abstract type AbstractGNUNullExpr <: AbstractExpr
Supertype for `GNUNullExpr`s.
"""
abstract type AbstractGNUNullExpr <: AbstractExpr end

"""
    abstract type AbstractFunctionParmPackExpr <: AbstractExpr
Supertype for `FunctionParmPackExpr`s.
"""
abstract type AbstractFunctionParmPackExpr <: AbstractExpr end

"""
    abstract type AbstractFullExpr <: AbstractExpr
Supertype for `FullExpr`s.
"""
abstract type AbstractFullExpr <: AbstractExpr end

"""
    abstract type AbstractExprWithCleanups <: AbstractFullExpr
Supertype for `ExprWithCleanups`s.
"""
abstract type AbstractExprWithCleanups <: AbstractFullExpr end

"""
    abstract type AbstractConstantExpr <: AbstractFullExpr
Supertype for `ConstantExpr`s.
"""
abstract type AbstractConstantExpr <: AbstractFullExpr end

"""
    abstract type AbstractFloatingLiteral <: AbstractExpr
Supertype for `FloatingLiteral`s.
"""
abstract type AbstractFloatingLiteral <: AbstractExpr end

"""
    abstract type AbstractFixedPointLiteral <: AbstractExpr
Supertype for `FixedPointLiteral`s.
"""
abstract type AbstractFixedPointLiteral <: AbstractExpr end

"""
    abstract type AbstractExtVectorElementExpr <: AbstractExpr
Supertype for `ExtVectorElementExpr`s.
"""
abstract type AbstractExtVectorElementExpr <: AbstractExpr end

"""
    abstract type AbstractExpressionTraitExpr <: AbstractExpr
Supertype for `ExpressionTraitExpr`s.
"""
abstract type AbstractExpressionTraitExpr <: AbstractExpr end

"""
    abstract type AbstractDesignatedInitUpdateExpr <: AbstractExpr
Supertype for `DesignatedInitUpdateExpr`s.
"""
abstract type AbstractDesignatedInitUpdateExpr <: AbstractExpr end

"""
    abstract type AbstractDesignatedInitExpr <: AbstractExpr
Supertype for `DesignatedInitExpr`s.
"""
abstract type AbstractDesignatedInitExpr <: AbstractExpr end

"""
    abstract type AbstractDependentScopeDeclRefExpr <: AbstractExpr
Supertype for `DependentScopeDeclRefExpr`s.
"""
abstract type AbstractDependentScopeDeclRefExpr <: AbstractExpr end

"""
    abstract type AbstractDependentCoawaitExpr <: AbstractExpr
Supertype for `DependentCoawaitExpr`s.
"""
abstract type AbstractDependentCoawaitExpr <: AbstractExpr end

"""
    abstract type AbstractDeclRefExpr <: AbstractExpr
Supertype for `DeclRefExpr`s.
"""
abstract type AbstractDeclRefExpr <: AbstractExpr end

"""
    abstract type AbstractCoyieldExpr <: AbstractCoroutineSuspendExpr
Supertype for `CoyieldExpr`s.
"""
abstract type AbstractCoyieldExpr <: AbstractCoroutineSuspendExpr end

"""
    abstract type AbstractCoawaitExpr <: AbstractCoroutineSuspendExpr
Supertype for `CoawaitExpr`s.
"""
abstract type AbstractCoawaitExpr <: AbstractCoroutineSuspendExpr end

"""
    abstract type AbstractConvertVectorExpr <: AbstractExpr
Supertype for `ConvertVectorExpr`s.
"""
abstract type AbstractConvertVectorExpr <: AbstractExpr end

"""
    abstract type AbstractConceptSpecializationExpr <: AbstractExpr
Supertype for `ConceptSpecializationExpr`s.
"""
abstract type AbstractConceptSpecializationExpr <: AbstractExpr end

"""
    abstract type AbstractCompoundLiteralExpr <: AbstractExpr
Supertype for `CompoundLiteralExpr`s.
"""
abstract type AbstractCompoundLiteralExpr <: AbstractExpr end

"""
    abstract type AbstractChooseExpr <: AbstractExpr
Supertype for `ChooseExpr`s.
"""
abstract type AbstractChooseExpr <: AbstractExpr end

"""
    abstract type AbstractCharacterLiteral <: AbstractExpr
Supertype for `CharacterLiteral`s.
"""
abstract type AbstractCharacterLiteral <: AbstractExpr end

"""
    abstract type AbstractImplicitCastExpr <: AbstractCastExpr
Supertype for `ImplicitCastExpr`s.
"""
abstract type AbstractImplicitCastExpr <: AbstractCastExpr end

"""
    abstract type AbstractObjCBridgedCastExpr <: AbstractExplicitCastExpr
Supertype for `ObjCBridgedCastExpr`s.
"""
abstract type AbstractObjCBridgedCastExpr <: AbstractExplicitCastExpr end

"""
    abstract type AbstractCXXStaticCastExpr <: AbstractCXXNamedCastExpr
Supertype for `CXXStaticCastExpr`s.
"""
abstract type AbstractCXXStaticCastExpr <: AbstractCXXNamedCastExpr end

"""
    abstract type AbstractCXXReinterpretCastExpr <: AbstractCXXNamedCastExpr
Supertype for `CXXReinterpretCastExpr`s.
"""
abstract type AbstractCXXReinterpretCastExpr <: AbstractCXXNamedCastExpr end

"""
    abstract type AbstractCXXDynamicCastExpr <: AbstractCXXNamedCastExpr
Supertype for `CXXDynamicCastExpr`s.
"""
abstract type AbstractCXXDynamicCastExpr <: AbstractCXXNamedCastExpr end

"""
    abstract type AbstractCXXConstCastExpr <: AbstractCXXNamedCastExpr
Supertype for `CXXConstCastExpr`s.
"""
abstract type AbstractCXXConstCastExpr <: AbstractCXXNamedCastExpr end

"""
    abstract type AbstractCXXAddrspaceCastExpr <: AbstractCXXNamedCastExpr
Supertype for `CXXAddrspaceCastExpr`s.
"""
abstract type AbstractCXXAddrspaceCastExpr <: AbstractCXXNamedCastExpr end

"""
    abstract type AbstractCXXFunctionalCastExpr <: AbstractExplicitCastExpr
Supertype for `CXXFunctionalCastExpr`s.
"""
abstract type AbstractCXXFunctionalCastExpr <: AbstractExplicitCastExpr end

"""
    abstract type AbstractCStyleCastExpr <: AbstractExplicitCastExpr
Supertype for `CStyleCastExpr`s.
"""
abstract type AbstractCStyleCastExpr <: AbstractExplicitCastExpr end

"""
    abstract type AbstractBuiltinBitCastExpr <: AbstractExplicitCastExpr
Supertype for `BuiltinBitCastExpr`s.
"""
abstract type AbstractBuiltinBitCastExpr <: AbstractExplicitCastExpr end

"""
    abstract type AbstractUserDefinedLiteral <: AbstractCallExpr
Supertype for `UserDefinedLiteral`s.
"""
abstract type AbstractUserDefinedLiteral <: AbstractCallExpr end

"""
    abstract type AbstractCXXOperatorCallExpr <: AbstractCallExpr
Supertype for `CXXOperatorCallExpr`s.
"""
abstract type AbstractCXXOperatorCallExpr <: AbstractCallExpr end

"""
    abstract type AbstractCXXMemberCallExpr <: AbstractCallExpr
Supertype for `CXXMemberCallExpr`s.
"""
abstract type AbstractCXXMemberCallExpr <: AbstractCallExpr end

"""
    abstract type AbstractCUDAKernelCallExpr <: AbstractCallExpr
Supertype for `CUDAKernelCallExpr`s.
"""
abstract type AbstractCUDAKernelCallExpr <: AbstractCallExpr end

"""
    abstract type AbstractCXXUuidofExpr <: AbstractExpr
Supertype for `CXXUuidofExpr`s.
"""
abstract type AbstractCXXUuidofExpr <: AbstractExpr end

"""
    abstract type AbstractCXXUnresolvedConstructExpr <: AbstractExpr
Supertype for `CXXUnresolvedConstructExpr`s.
"""
abstract type AbstractCXXUnresolvedConstructExpr <: AbstractExpr end

"""
    abstract type AbstractCXXTypeidExpr <: AbstractExpr
Supertype for `CXXTypeidExpr`s.
"""
abstract type AbstractCXXTypeidExpr <: AbstractExpr end

"""
    abstract type AbstractCXXThrowExpr <: AbstractExpr
Supertype for `CXXThrowExpr`s.
"""
abstract type AbstractCXXThrowExpr <: AbstractExpr end

"""
    abstract type AbstractCXXThisExpr <: AbstractExpr
Supertype for `CXXThisExpr`s.
"""
abstract type AbstractCXXThisExpr <: AbstractExpr end

"""
    abstract type AbstractCXXStdInitializerListExpr <: AbstractExpr
Supertype for `CXXStdInitializerListExpr`s.
"""
abstract type AbstractCXXStdInitializerListExpr <: AbstractExpr end

"""
    abstract type AbstractCXXScalarValueInitExpr <: AbstractExpr
Supertype for `CXXScalarValueInitExpr`s.
"""
abstract type AbstractCXXScalarValueInitExpr <: AbstractExpr end

"""
    abstract type AbstractCXXRewrittenBinaryOperator <: AbstractExpr
Supertype for `CXXRewrittenBinaryOperator`s.
"""
abstract type AbstractCXXRewrittenBinaryOperator <: AbstractExpr end

"""
    abstract type AbstractCXXPseudoDestructorExpr <: AbstractExpr
Supertype for `CXXPseudoDestructorExpr`s.
"""
abstract type AbstractCXXPseudoDestructorExpr <: AbstractExpr end

"""
    abstract type AbstractCXXParenListInitExpr <: AbstractExpr
Supertype for `CXXParenListInitExpr`s.
"""
abstract type AbstractCXXParenListInitExpr <: AbstractExpr end

"""
    abstract type AbstractCXXNullPtrLiteralExpr <: AbstractExpr
Supertype for `CXXNullPtrLiteralExpr`s.
"""
abstract type AbstractCXXNullPtrLiteralExpr <: AbstractExpr end

"""
    abstract type AbstractCXXNoexceptExpr <: AbstractExpr
Supertype for `CXXNoexceptExpr`s.
"""
abstract type AbstractCXXNoexceptExpr <: AbstractExpr end

"""
    abstract type AbstractCXXNewExpr <: AbstractExpr
Supertype for `CXXNewExpr`s.
"""
abstract type AbstractCXXNewExpr <: AbstractExpr end

"""
    abstract type AbstractCXXInheritedCtorInitExpr <: AbstractExpr
Supertype for `CXXInheritedCtorInitExpr`s.
"""
abstract type AbstractCXXInheritedCtorInitExpr <: AbstractExpr end

"""
    abstract type AbstractCXXFoldExpr <: AbstractExpr
Supertype for `CXXFoldExpr`s.
"""
abstract type AbstractCXXFoldExpr <: AbstractExpr end

"""
    abstract type AbstractCXXDependentScopeMemberExpr <: AbstractExpr
Supertype for `CXXDependentScopeMemberExpr`s.
"""
abstract type AbstractCXXDependentScopeMemberExpr <: AbstractExpr end

"""
    abstract type AbstractCXXDeleteExpr <: AbstractExpr
Supertype for `CXXDeleteExpr`s.
"""
abstract type AbstractCXXDeleteExpr <: AbstractExpr end

"""
    abstract type AbstractCXXDefaultInitExpr <: AbstractExpr
Supertype for `CXXDefaultInitExpr`s.
"""
abstract type AbstractCXXDefaultInitExpr <: AbstractExpr end

"""
    abstract type AbstractCXXDefaultArgExpr <: AbstractExpr
Supertype for `CXXDefaultArgExpr`s.
"""
abstract type AbstractCXXDefaultArgExpr <: AbstractExpr end

"""
    abstract type AbstractCXXTemporaryObjectExpr <: AbstractCXXConstructExpr
Supertype for `CXXTemporaryObjectExpr`s.
"""
abstract type AbstractCXXTemporaryObjectExpr <: AbstractCXXConstructExpr end

"""
    abstract type AbstractCXXBoolLiteralExpr <: AbstractExpr
Supertype for `CXXBoolLiteralExpr`s.
"""
abstract type AbstractCXXBoolLiteralExpr <: AbstractExpr end

"""
    abstract type AbstractCXXBindTemporaryExpr <: AbstractExpr
Supertype for `CXXBindTemporaryExpr`s.
"""
abstract type AbstractCXXBindTemporaryExpr <: AbstractExpr end

"""
    abstract type AbstractBlockExpr <: AbstractExpr
Supertype for `BlockExpr`s.
"""
abstract type AbstractBlockExpr <: AbstractExpr end

"""
    abstract type AbstractCompoundAssignOperator <: AbstractBinaryOperator
Supertype for `CompoundAssignOperator`s.
"""
abstract type AbstractCompoundAssignOperator <: AbstractBinaryOperator end

"""
    abstract type AbstractAtomicExpr <: AbstractExpr
Supertype for `AtomicExpr`s.
"""
abstract type AbstractAtomicExpr <: AbstractExpr end

"""
    abstract type AbstractAsTypeExpr <: AbstractExpr
Supertype for `AsTypeExpr`s.
"""
abstract type AbstractAsTypeExpr <: AbstractExpr end

"""
    abstract type AbstractArrayTypeTraitExpr <: AbstractExpr
Supertype for `ArrayTypeTraitExpr`s.
"""
abstract type AbstractArrayTypeTraitExpr <: AbstractExpr end

"""
    abstract type AbstractArraySubscriptExpr <: AbstractExpr
Supertype for `ArraySubscriptExpr`s.
"""
abstract type AbstractArraySubscriptExpr <: AbstractExpr end

"""
    abstract type AbstractArrayInitLoopExpr <: AbstractExpr
Supertype for `ArrayInitLoopExpr`s.
"""
abstract type AbstractArrayInitLoopExpr <: AbstractExpr end

"""
    abstract type AbstractArrayInitIndexExpr <: AbstractExpr
Supertype for `ArrayInitIndexExpr`s.
"""
abstract type AbstractArrayInitIndexExpr <: AbstractExpr end

"""
    abstract type AbstractAddrLabelExpr <: AbstractExpr
Supertype for `AddrLabelExpr`s.
"""
abstract type AbstractAddrLabelExpr <: AbstractExpr end

"""
    abstract type AbstractBinaryConditionalOperator <: AbstractConditionalOperator
Supertype for `BinaryConditionalOperator`s.
"""
abstract type AbstractBinaryConditionalOperator <: AbstractConditionalOperator end

"""
    abstract type AbstractAttributedStmt <: AbstractValueStmt
Supertype for `AttributedStmt`s.
"""
abstract type AbstractAttributedStmt <: AbstractValueStmt end

"""
    abstract type AbstractSwitchStmt <: AbstractStmt
Supertype for `SwitchStmt`s.
"""
abstract type AbstractSwitchStmt <: AbstractStmt end

"""
    abstract type AbstractDefaultStmt <: AbstractSwitchCase
Supertype for `DefaultStmt`s.
"""
abstract type AbstractDefaultStmt <: AbstractSwitchCase end

"""
    abstract type AbstractCaseStmt <: AbstractSwitchCase
Supertype for `CaseStmt`s.
"""
abstract type AbstractCaseStmt <: AbstractSwitchCase end

"""
    abstract type AbstractSEHTryStmt <: AbstractStmt
Supertype for `SEHTryStmt`s.
"""
abstract type AbstractSEHTryStmt <: AbstractStmt end

"""
    abstract type AbstractSEHLeaveStmt <: AbstractStmt
Supertype for `SEHLeaveStmt`s.
"""
abstract type AbstractSEHLeaveStmt <: AbstractStmt end

"""
    abstract type AbstractSEHFinallyStmt <: AbstractStmt
Supertype for `SEHFinallyStmt`s.
"""
abstract type AbstractSEHFinallyStmt <: AbstractStmt end

"""
    abstract type AbstractSEHExceptStmt <: AbstractStmt
Supertype for `SEHExceptStmt`s.
"""
abstract type AbstractSEHExceptStmt <: AbstractStmt end

"""
    abstract type AbstractReturnStmt <: AbstractStmt
Supertype for `ReturnStmt`s.
"""
abstract type AbstractReturnStmt <: AbstractStmt end

"""
    abstract type AbstractObjCForCollectionStmt <: AbstractStmt
Supertype for `ObjCForCollectionStmt`s.
"""
abstract type AbstractObjCForCollectionStmt <: AbstractStmt end

"""
    abstract type AbstractObjCAutoreleasePoolStmt <: AbstractStmt
Supertype for `ObjCAutoreleasePoolStmt`s.
"""
abstract type AbstractObjCAutoreleasePoolStmt <: AbstractStmt end

"""
    abstract type AbstractObjCAtTryStmt <: AbstractStmt
Supertype for `ObjCAtTryStmt`s.
"""
abstract type AbstractObjCAtTryStmt <: AbstractStmt end

"""
    abstract type AbstractObjCAtThrowStmt <: AbstractStmt
Supertype for `ObjCAtThrowStmt`s.
"""
abstract type AbstractObjCAtThrowStmt <: AbstractStmt end

"""
    abstract type AbstractObjCAtSynchronizedStmt <: AbstractStmt
Supertype for `ObjCAtSynchronizedStmt`s.
"""
abstract type AbstractObjCAtSynchronizedStmt <: AbstractStmt end

"""
    abstract type AbstractObjCAtFinallyStmt <: AbstractStmt
Supertype for `ObjCAtFinallyStmt`s.
"""
abstract type AbstractObjCAtFinallyStmt <: AbstractStmt end

"""
    abstract type AbstractObjCAtCatchStmt <: AbstractStmt
Supertype for `ObjCAtCatchStmt`s.
"""
abstract type AbstractObjCAtCatchStmt <: AbstractStmt end

"""
    abstract type AbstractOMPExecutableDirective <: AbstractStmt
Supertype for `OMPExecutableDirective`s.
"""
abstract type AbstractOMPExecutableDirective <: AbstractStmt end

"""
    abstract type AbstractOMPTeamsDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTeamsDirective`s.
"""
abstract type AbstractOMPTeamsDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTaskyieldDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTaskyieldDirective`s.
"""
abstract type AbstractOMPTaskyieldDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTaskwaitDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTaskwaitDirective`s.
"""
abstract type AbstractOMPTaskwaitDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTaskgroupDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTaskgroupDirective`s.
"""
abstract type AbstractOMPTaskgroupDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTaskDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTaskDirective`s.
"""
abstract type AbstractOMPTaskDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetUpdateDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetUpdateDirective`s.
"""
abstract type AbstractOMPTargetUpdateDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetTeamsDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetTeamsDirective`s.
"""
abstract type AbstractOMPTargetTeamsDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetParallelForDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetParallelForDirective`s.
"""
abstract type AbstractOMPTargetParallelForDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetParallelDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetParallelDirective`s.
"""
abstract type AbstractOMPTargetParallelDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetExitDataDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetExitDataDirective`s.
"""
abstract type AbstractOMPTargetExitDataDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetEnterDataDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetEnterDataDirective`s.
"""
abstract type AbstractOMPTargetEnterDataDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetDirective`s.
"""
abstract type AbstractOMPTargetDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPTargetDataDirective <: AbstractOMPExecutableDirective
Supertype for `OMPTargetDataDirective`s.
"""
abstract type AbstractOMPTargetDataDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPSingleDirective <: AbstractOMPExecutableDirective
Supertype for `OMPSingleDirective`s.
"""
abstract type AbstractOMPSingleDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPSectionsDirective <: AbstractOMPExecutableDirective
Supertype for `OMPSectionsDirective`s.
"""
abstract type AbstractOMPSectionsDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPSectionDirective <: AbstractOMPExecutableDirective
Supertype for `OMPSectionDirective`s.
"""
abstract type AbstractOMPSectionDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPScopeDirective <: AbstractOMPExecutableDirective
Supertype for `OMPScopeDirective`s.
"""
abstract type AbstractOMPScopeDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPScanDirective <: AbstractOMPExecutableDirective
Supertype for `OMPScanDirective`s.
"""
abstract type AbstractOMPScanDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPParallelSectionsDirective <: AbstractOMPExecutableDirective
Supertype for `OMPParallelSectionsDirective`s.
"""
abstract type AbstractOMPParallelSectionsDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPParallelMasterDirective <: AbstractOMPExecutableDirective
Supertype for `OMPParallelMasterDirective`s.
"""
abstract type AbstractOMPParallelMasterDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPParallelMaskedDirective <: AbstractOMPExecutableDirective
Supertype for `OMPParallelMaskedDirective`s.
"""
abstract type AbstractOMPParallelMaskedDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPParallelDirective <: AbstractOMPExecutableDirective
Supertype for `OMPParallelDirective`s.
"""
abstract type AbstractOMPParallelDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPOrderedDirective <: AbstractOMPExecutableDirective
Supertype for `OMPOrderedDirective`s.
"""
abstract type AbstractOMPOrderedDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPMetaDirective <: AbstractOMPExecutableDirective
Supertype for `OMPMetaDirective`s.
"""
abstract type AbstractOMPMetaDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPMasterDirective <: AbstractOMPExecutableDirective
Supertype for `OMPMasterDirective`s.
"""
abstract type AbstractOMPMasterDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPMaskedDirective <: AbstractOMPExecutableDirective
Supertype for `OMPMaskedDirective`s.
"""
abstract type AbstractOMPMaskedDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPLoopBasedDirective <: AbstractOMPExecutableDirective
Supertype for `OMPLoopBasedDirective`s.
"""
abstract type AbstractOMPLoopBasedDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPLoopTransformationDirective <: AbstractOMPLoopBasedDirective
Supertype for `OMPLoopTransformationDirective`s.
"""
abstract type AbstractOMPLoopTransformationDirective <: AbstractOMPLoopBasedDirective end

"""
    abstract type AbstractOMPUnrollDirective <: AbstractOMPLoopTransformationDirective
Supertype for `OMPUnrollDirective`s.
"""
abstract type AbstractOMPUnrollDirective <: AbstractOMPLoopTransformationDirective end

"""
    abstract type AbstractOMPTileDirective <: AbstractOMPLoopTransformationDirective
Supertype for `OMPTileDirective`s.
"""
abstract type AbstractOMPTileDirective <: AbstractOMPLoopTransformationDirective end

"""
    abstract type AbstractOMPLoopDirective <: AbstractOMPLoopBasedDirective
Supertype for `OMPLoopDirective`s.
"""
abstract type AbstractOMPLoopDirective <: AbstractOMPLoopBasedDirective end

"""
    abstract type AbstractOMPTeamsGenericLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPTeamsGenericLoopDirective`s.
"""
abstract type AbstractOMPTeamsGenericLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTeamsDistributeSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTeamsDistributeSimdDirective`s.
"""
abstract type AbstractOMPTeamsDistributeSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTeamsDistributeParallelForSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTeamsDistributeParallelForSimdDirective`s.
"""
abstract type AbstractOMPTeamsDistributeParallelForSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTeamsDistributeParallelForDirective <: AbstractOMPLoopDirective
Supertype for `OMPTeamsDistributeParallelForDirective`s.
"""
abstract type AbstractOMPTeamsDistributeParallelForDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTeamsDistributeDirective <: AbstractOMPLoopDirective
Supertype for `OMPTeamsDistributeDirective`s.
"""
abstract type AbstractOMPTeamsDistributeDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTaskLoopSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTaskLoopSimdDirective`s.
"""
abstract type AbstractOMPTaskLoopSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTaskLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPTaskLoopDirective`s.
"""
abstract type AbstractOMPTaskLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetTeamsGenericLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetTeamsGenericLoopDirective`s.
"""
abstract type AbstractOMPTargetTeamsGenericLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetTeamsDistributeSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetTeamsDistributeSimdDirective`s.
"""
abstract type AbstractOMPTargetTeamsDistributeSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetTeamsDistributeParallelForSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetTeamsDistributeParallelForSimdDirective`s.
"""
abstract type AbstractOMPTargetTeamsDistributeParallelForSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetTeamsDistributeParallelForDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetTeamsDistributeParallelForDirective`s.
"""
abstract type AbstractOMPTargetTeamsDistributeParallelForDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetTeamsDistributeDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetTeamsDistributeDirective`s.
"""
abstract type AbstractOMPTargetTeamsDistributeDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetSimdDirective`s.
"""
abstract type AbstractOMPTargetSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetParallelGenericLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetParallelGenericLoopDirective`s.
"""
abstract type AbstractOMPTargetParallelGenericLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPTargetParallelForSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPTargetParallelForSimdDirective`s.
"""
abstract type AbstractOMPTargetParallelForSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPSimdDirective`s.
"""
abstract type AbstractOMPSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelMasterTaskLoopSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelMasterTaskLoopSimdDirective`s.
"""
abstract type AbstractOMPParallelMasterTaskLoopSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelMasterTaskLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelMasterTaskLoopDirective`s.
"""
abstract type AbstractOMPParallelMasterTaskLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelMaskedTaskLoopSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelMaskedTaskLoopSimdDirective`s.
"""
abstract type AbstractOMPParallelMaskedTaskLoopSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelMaskedTaskLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelMaskedTaskLoopDirective`s.
"""
abstract type AbstractOMPParallelMaskedTaskLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelGenericLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelGenericLoopDirective`s.
"""
abstract type AbstractOMPParallelGenericLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelForSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelForSimdDirective`s.
"""
abstract type AbstractOMPParallelForSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPParallelForDirective <: AbstractOMPLoopDirective
Supertype for `OMPParallelForDirective`s.
"""
abstract type AbstractOMPParallelForDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPMasterTaskLoopSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPMasterTaskLoopSimdDirective`s.
"""
abstract type AbstractOMPMasterTaskLoopSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPMasterTaskLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPMasterTaskLoopDirective`s.
"""
abstract type AbstractOMPMasterTaskLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPMaskedTaskLoopSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPMaskedTaskLoopSimdDirective`s.
"""
abstract type AbstractOMPMaskedTaskLoopSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPMaskedTaskLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPMaskedTaskLoopDirective`s.
"""
abstract type AbstractOMPMaskedTaskLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPGenericLoopDirective <: AbstractOMPLoopDirective
Supertype for `OMPGenericLoopDirective`s.
"""
abstract type AbstractOMPGenericLoopDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPForSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPForSimdDirective`s.
"""
abstract type AbstractOMPForSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPForDirective <: AbstractOMPLoopDirective
Supertype for `OMPForDirective`s.
"""
abstract type AbstractOMPForDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPDistributeSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPDistributeSimdDirective`s.
"""
abstract type AbstractOMPDistributeSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPDistributeParallelForSimdDirective <: AbstractOMPLoopDirective
Supertype for `OMPDistributeParallelForSimdDirective`s.
"""
abstract type AbstractOMPDistributeParallelForSimdDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPDistributeParallelForDirective <: AbstractOMPLoopDirective
Supertype for `OMPDistributeParallelForDirective`s.
"""
abstract type AbstractOMPDistributeParallelForDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPDistributeDirective <: AbstractOMPLoopDirective
Supertype for `OMPDistributeDirective`s.
"""
abstract type AbstractOMPDistributeDirective <: AbstractOMPLoopDirective end

"""
    abstract type AbstractOMPInteropDirective <: AbstractOMPExecutableDirective
Supertype for `OMPInteropDirective`s.
"""
abstract type AbstractOMPInteropDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPFlushDirective <: AbstractOMPExecutableDirective
Supertype for `OMPFlushDirective`s.
"""
abstract type AbstractOMPFlushDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPErrorDirective <: AbstractOMPExecutableDirective
Supertype for `OMPErrorDirective`s.
"""
abstract type AbstractOMPErrorDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPDispatchDirective <: AbstractOMPExecutableDirective
Supertype for `OMPDispatchDirective`s.
"""
abstract type AbstractOMPDispatchDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPDepobjDirective <: AbstractOMPExecutableDirective
Supertype for `OMPDepobjDirective`s.
"""
abstract type AbstractOMPDepobjDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPCriticalDirective <: AbstractOMPExecutableDirective
Supertype for `OMPCriticalDirective`s.
"""
abstract type AbstractOMPCriticalDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPCancellationPointDirective <: AbstractOMPExecutableDirective
Supertype for `OMPCancellationPointDirective`s.
"""
abstract type AbstractOMPCancellationPointDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPCancelDirective <: AbstractOMPExecutableDirective
Supertype for `OMPCancelDirective`s.
"""
abstract type AbstractOMPCancelDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPBarrierDirective <: AbstractOMPExecutableDirective
Supertype for `OMPBarrierDirective`s.
"""
abstract type AbstractOMPBarrierDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPAtomicDirective <: AbstractOMPExecutableDirective
Supertype for `OMPAtomicDirective`s.
"""
abstract type AbstractOMPAtomicDirective <: AbstractOMPExecutableDirective end

"""
    abstract type AbstractOMPCanonicalLoop <: AbstractStmt
Supertype for `OMPCanonicalLoop`s.
"""
abstract type AbstractOMPCanonicalLoop <: AbstractStmt end

"""
    abstract type AbstractNullStmt <: AbstractStmt
Supertype for `NullStmt`s.
"""
abstract type AbstractNullStmt <: AbstractStmt end

"""
    abstract type AbstractMSDependentExistsStmt <: AbstractStmt
Supertype for `MSDependentExistsStmt`s.
"""
abstract type AbstractMSDependentExistsStmt <: AbstractStmt end

"""
    abstract type AbstractIndirectGotoStmt <: AbstractStmt
Supertype for `IndirectGotoStmt`s.
"""
abstract type AbstractIndirectGotoStmt <: AbstractStmt end

"""
    abstract type AbstractIfStmt <: AbstractStmt
Supertype for `IfStmt`s.
"""
abstract type AbstractIfStmt <: AbstractStmt end

"""
    abstract type AbstractGotoStmt <: AbstractStmt
Supertype for `GotoStmt`s.
"""
abstract type AbstractGotoStmt <: AbstractStmt end

"""
    abstract type AbstractForStmt <: AbstractStmt
Supertype for `ForStmt`s.
"""
abstract type AbstractForStmt <: AbstractStmt end

"""
    abstract type AbstractDoStmt <: AbstractStmt
Supertype for `DoStmt`s.
"""
abstract type AbstractDoStmt <: AbstractStmt end

"""
    abstract type AbstractDeclStmt <: AbstractStmt
Supertype for `DeclStmt`s.
"""
abstract type AbstractDeclStmt <: AbstractStmt end

"""
    abstract type AbstractCoroutineBodyStmt <: AbstractStmt
Supertype for `CoroutineBodyStmt`s.
"""
abstract type AbstractCoroutineBodyStmt <: AbstractStmt end

"""
    abstract type AbstractCoreturnStmt <: AbstractStmt
Supertype for `CoreturnStmt`s.
"""
abstract type AbstractCoreturnStmt <: AbstractStmt end

"""
    abstract type AbstractContinueStmt <: AbstractStmt
Supertype for `ContinueStmt`s.
"""
abstract type AbstractContinueStmt <: AbstractStmt end

"""
    abstract type AbstractCompoundStmt <: AbstractStmt
Supertype for `CompoundStmt`s.
"""
abstract type AbstractCompoundStmt <: AbstractStmt end

"""
    abstract type AbstractCapturedStmt <: AbstractStmt
Supertype for `CapturedStmt`s.
"""
abstract type AbstractCapturedStmt <: AbstractStmt end

"""
    abstract type AbstractCXXTryStmt <: AbstractStmt
Supertype for `CXXTryStmt`s.
"""
abstract type AbstractCXXTryStmt <: AbstractStmt end

"""
    abstract type AbstractCXXForRangeStmt <: AbstractStmt
Supertype for `CXXForRangeStmt`s.
"""
abstract type AbstractCXXForRangeStmt <: AbstractStmt end

"""
    abstract type AbstractCXXCatchStmt <: AbstractStmt
Supertype for `CXXCatchStmt`s.
"""
abstract type AbstractCXXCatchStmt <: AbstractStmt end

"""
    abstract type AbstractBreakStmt <: AbstractStmt
Supertype for `BreakStmt`s.
"""
abstract type AbstractBreakStmt <: AbstractStmt end

"""
    abstract type AbstractMSAsmStmt <: AbstractAsmStmt
Supertype for `MSAsmStmt`s.
"""
abstract type AbstractMSAsmStmt <: AbstractAsmStmt end

"""
    abstract type AbstractGCCAsmStmt <: AbstractAsmStmt
Supertype for `GCCAsmStmt`s.
"""
abstract type AbstractGCCAsmStmt <: AbstractAsmStmt end

