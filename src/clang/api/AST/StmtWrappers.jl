# Generated from deps/ClangExtra/include/clang-ex/AST/StmtNodes.inc by gen/stmt_nodes.jl — do not edit.
# Per-node downcast: `is<Name>` predicate and `<carrier>` constructor-shaped
# cast for every class, abstract bases included — the C shim stamps both from
# the same table, and clang's own `classof` makes the dyn_cast sound.
function isWhileStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isWhileStmt(x)
end

function WhileStmt(x::AbstractStmt)
    @check_ptrs x
    return WhileStmt(clang_Stmt_castToWhileStmt(x))
end

function isValueStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isValueStmt(x)
end

function ValueStmt(x::AbstractStmt)
    @check_ptrs x
    return ValueStmt(clang_Stmt_castToValueStmt(x))
end

function isLabelStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isLabelStmt(x)
end

function LabelStmt(x::AbstractStmt)
    @check_ptrs x
    return LabelStmt(clang_Stmt_castToLabelStmt(x))
end

function isExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isExpr(x)
end

function Expr_(x::AbstractStmt)
    @check_ptrs x
    return Expr_(clang_Stmt_castToExpr(x))
end

function isVAArgExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isVAArgExpr(x)
end

function VAArgExpr(x::AbstractStmt)
    @check_ptrs x
    return VAArgExpr(clang_Stmt_castToVAArgExpr(x))
end

function isUnaryOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isUnaryOperator(x)
end

function UnaryOperator(x::AbstractStmt)
    @check_ptrs x
    return UnaryOperator(clang_Stmt_castToUnaryOperator(x))
end

function isUnaryExprOrTypeTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isUnaryExprOrTypeTraitExpr(x)
end

function UnaryExprOrTypeTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return UnaryExprOrTypeTraitExpr(clang_Stmt_castToUnaryExprOrTypeTraitExpr(x))
end

function isTypoExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isTypoExpr(x)
end

function TypoExpr(x::AbstractStmt)
    @check_ptrs x
    return TypoExpr(clang_Stmt_castToTypoExpr(x))
end

function isTypeTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isTypeTraitExpr(x)
end

function TypeTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return TypeTraitExpr(clang_Stmt_castToTypeTraitExpr(x))
end

function isSubstNonTypeTemplateParmPackExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSubstNonTypeTemplateParmPackExpr(x)
end

function SubstNonTypeTemplateParmPackExpr(x::AbstractStmt)
    @check_ptrs x
    return SubstNonTypeTemplateParmPackExpr(clang_Stmt_castToSubstNonTypeTemplateParmPackExpr(x))
end

function isSubstNonTypeTemplateParmExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSubstNonTypeTemplateParmExpr(x)
end

function SubstNonTypeTemplateParmExpr(x::AbstractStmt)
    @check_ptrs x
    return SubstNonTypeTemplateParmExpr(clang_Stmt_castToSubstNonTypeTemplateParmExpr(x))
end

function isStringLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isStringLiteral(x)
end

function StringLiteral(x::AbstractStmt)
    @check_ptrs x
    return StringLiteral(clang_Stmt_castToStringLiteral(x))
end

function isStmtExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isStmtExpr(x)
end

function StmtExpr(x::AbstractStmt)
    @check_ptrs x
    return StmtExpr(clang_Stmt_castToStmtExpr(x))
end

function isSourceLocExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSourceLocExpr(x)
end

function SourceLocExpr(x::AbstractStmt)
    @check_ptrs x
    return SourceLocExpr(clang_Stmt_castToSourceLocExpr(x))
end

function isSizeOfPackExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSizeOfPackExpr(x)
end

function SizeOfPackExpr(x::AbstractStmt)
    @check_ptrs x
    return SizeOfPackExpr(clang_Stmt_castToSizeOfPackExpr(x))
end

function isShuffleVectorExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isShuffleVectorExpr(x)
end

function ShuffleVectorExpr(x::AbstractStmt)
    @check_ptrs x
    return ShuffleVectorExpr(clang_Stmt_castToShuffleVectorExpr(x))
end

function isSYCLUniqueStableNameExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSYCLUniqueStableNameExpr(x)
end

function SYCLUniqueStableNameExpr(x::AbstractStmt)
    @check_ptrs x
    return SYCLUniqueStableNameExpr(clang_Stmt_castToSYCLUniqueStableNameExpr(x))
end

function isRequiresExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isRequiresExpr(x)
end

function RequiresExpr(x::AbstractStmt)
    @check_ptrs x
    return RequiresExpr(clang_Stmt_castToRequiresExpr(x))
end

function isRecoveryExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isRecoveryExpr(x)
end

function RecoveryExpr(x::AbstractStmt)
    @check_ptrs x
    return RecoveryExpr(clang_Stmt_castToRecoveryExpr(x))
end

function isPseudoObjectExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isPseudoObjectExpr(x)
end

function PseudoObjectExpr(x::AbstractStmt)
    @check_ptrs x
    return PseudoObjectExpr(clang_Stmt_castToPseudoObjectExpr(x))
end

function isPredefinedExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isPredefinedExpr(x)
end

function PredefinedExpr(x::AbstractStmt)
    @check_ptrs x
    return PredefinedExpr(clang_Stmt_castToPredefinedExpr(x))
end

function isParenListExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isParenListExpr(x)
end

function ParenListExpr(x::AbstractStmt)
    @check_ptrs x
    return ParenListExpr(clang_Stmt_castToParenListExpr(x))
end

function isParenExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isParenExpr(x)
end

function ParenExpr(x::AbstractStmt)
    @check_ptrs x
    return ParenExpr(clang_Stmt_castToParenExpr(x))
end

function isPackExpansionExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isPackExpansionExpr(x)
end

function PackExpansionExpr(x::AbstractStmt)
    @check_ptrs x
    return PackExpansionExpr(clang_Stmt_castToPackExpansionExpr(x))
end

function isOverloadExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOverloadExpr(x)
end

function OverloadExpr(x::AbstractStmt)
    @check_ptrs x
    return OverloadExpr(clang_Stmt_castToOverloadExpr(x))
end

function isUnresolvedMemberExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isUnresolvedMemberExpr(x)
end

function UnresolvedMemberExpr(x::AbstractStmt)
    @check_ptrs x
    return UnresolvedMemberExpr(clang_Stmt_castToUnresolvedMemberExpr(x))
end

function isUnresolvedLookupExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isUnresolvedLookupExpr(x)
end

function UnresolvedLookupExpr(x::AbstractStmt)
    @check_ptrs x
    return UnresolvedLookupExpr(clang_Stmt_castToUnresolvedLookupExpr(x))
end

function isOpaqueValueExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOpaqueValueExpr(x)
end

function OpaqueValueExpr(x::AbstractStmt)
    @check_ptrs x
    return OpaqueValueExpr(clang_Stmt_castToOpaqueValueExpr(x))
end

function isOffsetOfExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOffsetOfExpr(x)
end

function OffsetOfExpr(x::AbstractStmt)
    @check_ptrs x
    return OffsetOfExpr(clang_Stmt_castToOffsetOfExpr(x))
end

function isObjCSubscriptRefExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCSubscriptRefExpr(x)
end

function ObjCSubscriptRefExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCSubscriptRefExpr(clang_Stmt_castToObjCSubscriptRefExpr(x))
end

function isObjCStringLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCStringLiteral(x)
end

function ObjCStringLiteral(x::AbstractStmt)
    @check_ptrs x
    return ObjCStringLiteral(clang_Stmt_castToObjCStringLiteral(x))
end

function isObjCSelectorExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCSelectorExpr(x)
end

function ObjCSelectorExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCSelectorExpr(clang_Stmt_castToObjCSelectorExpr(x))
end

function isObjCProtocolExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCProtocolExpr(x)
end

function ObjCProtocolExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCProtocolExpr(clang_Stmt_castToObjCProtocolExpr(x))
end

function isObjCPropertyRefExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCPropertyRefExpr(x)
end

function ObjCPropertyRefExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCPropertyRefExpr(clang_Stmt_castToObjCPropertyRefExpr(x))
end

function isObjCMessageExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCMessageExpr(x)
end

function ObjCMessageExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCMessageExpr(clang_Stmt_castToObjCMessageExpr(x))
end

function isObjCIvarRefExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCIvarRefExpr(x)
end

function ObjCIvarRefExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCIvarRefExpr(clang_Stmt_castToObjCIvarRefExpr(x))
end

function isObjCIsaExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCIsaExpr(x)
end

function ObjCIsaExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCIsaExpr(clang_Stmt_castToObjCIsaExpr(x))
end

function isObjCIndirectCopyRestoreExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCIndirectCopyRestoreExpr(x)
end

function ObjCIndirectCopyRestoreExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCIndirectCopyRestoreExpr(clang_Stmt_castToObjCIndirectCopyRestoreExpr(x))
end

function isObjCEncodeExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCEncodeExpr(x)
end

function ObjCEncodeExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCEncodeExpr(clang_Stmt_castToObjCEncodeExpr(x))
end

function isObjCDictionaryLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCDictionaryLiteral(x)
end

function ObjCDictionaryLiteral(x::AbstractStmt)
    @check_ptrs x
    return ObjCDictionaryLiteral(clang_Stmt_castToObjCDictionaryLiteral(x))
end

function isObjCBoxedExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCBoxedExpr(x)
end

function ObjCBoxedExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCBoxedExpr(clang_Stmt_castToObjCBoxedExpr(x))
end

function isObjCBoolLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCBoolLiteralExpr(x)
end

function ObjCBoolLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCBoolLiteralExpr(clang_Stmt_castToObjCBoolLiteralExpr(x))
end

function isObjCAvailabilityCheckExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAvailabilityCheckExpr(x)
end

function ObjCAvailabilityCheckExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCAvailabilityCheckExpr(clang_Stmt_castToObjCAvailabilityCheckExpr(x))
end

function isObjCArrayLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCArrayLiteral(x)
end

function ObjCArrayLiteral(x::AbstractStmt)
    @check_ptrs x
    return ObjCArrayLiteral(clang_Stmt_castToObjCArrayLiteral(x))
end

function isOMPIteratorExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPIteratorExpr(x)
end

function OMPIteratorExpr(x::AbstractStmt)
    @check_ptrs x
    return OMPIteratorExpr(clang_Stmt_castToOMPIteratorExpr(x))
end

function isOMPArrayShapingExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPArrayShapingExpr(x)
end

function OMPArrayShapingExpr(x::AbstractStmt)
    @check_ptrs x
    return OMPArrayShapingExpr(clang_Stmt_castToOMPArrayShapingExpr(x))
end

function isOMPArraySectionExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPArraySectionExpr(x)
end

function OMPArraySectionExpr(x::AbstractStmt)
    @check_ptrs x
    return OMPArraySectionExpr(clang_Stmt_castToOMPArraySectionExpr(x))
end

function isNoInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isNoInitExpr(x)
end

function NoInitExpr(x::AbstractStmt)
    @check_ptrs x
    return NoInitExpr(clang_Stmt_castToNoInitExpr(x))
end

function isMemberExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMemberExpr(x)
end

function MemberExpr(x::AbstractStmt)
    @check_ptrs x
    return MemberExpr(clang_Stmt_castToMemberExpr(x))
end

function isMatrixSubscriptExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMatrixSubscriptExpr(x)
end

function MatrixSubscriptExpr(x::AbstractStmt)
    @check_ptrs x
    return MatrixSubscriptExpr(clang_Stmt_castToMatrixSubscriptExpr(x))
end

function isMaterializeTemporaryExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMaterializeTemporaryExpr(x)
end

function MaterializeTemporaryExpr(x::AbstractStmt)
    @check_ptrs x
    return MaterializeTemporaryExpr(clang_Stmt_castToMaterializeTemporaryExpr(x))
end

function isMSPropertySubscriptExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMSPropertySubscriptExpr(x)
end

function MSPropertySubscriptExpr(x::AbstractStmt)
    @check_ptrs x
    return MSPropertySubscriptExpr(clang_Stmt_castToMSPropertySubscriptExpr(x))
end

function isMSPropertyRefExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMSPropertyRefExpr(x)
end

function MSPropertyRefExpr(x::AbstractStmt)
    @check_ptrs x
    return MSPropertyRefExpr(clang_Stmt_castToMSPropertyRefExpr(x))
end

function isLambdaExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isLambdaExpr(x)
end

function LambdaExpr(x::AbstractStmt)
    @check_ptrs x
    return LambdaExpr(clang_Stmt_castToLambdaExpr(x))
end

function isIntegerLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isIntegerLiteral(x)
end

function IntegerLiteral(x::AbstractStmt)
    @check_ptrs x
    return IntegerLiteral(clang_Stmt_castToIntegerLiteral(x))
end

function isInitListExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isInitListExpr(x)
end

function InitListExpr(x::AbstractStmt)
    @check_ptrs x
    return InitListExpr(clang_Stmt_castToInitListExpr(x))
end

function isImplicitValueInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isImplicitValueInitExpr(x)
end

function ImplicitValueInitExpr(x::AbstractStmt)
    @check_ptrs x
    return ImplicitValueInitExpr(clang_Stmt_castToImplicitValueInitExpr(x))
end

function isImaginaryLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isImaginaryLiteral(x)
end

function ImaginaryLiteral(x::AbstractStmt)
    @check_ptrs x
    return ImaginaryLiteral(clang_Stmt_castToImaginaryLiteral(x))
end

function isGenericSelectionExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isGenericSelectionExpr(x)
end

function GenericSelectionExpr(x::AbstractStmt)
    @check_ptrs x
    return GenericSelectionExpr(clang_Stmt_castToGenericSelectionExpr(x))
end

function isGNUNullExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isGNUNullExpr(x)
end

function GNUNullExpr(x::AbstractStmt)
    @check_ptrs x
    return GNUNullExpr(clang_Stmt_castToGNUNullExpr(x))
end

function isFunctionParmPackExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isFunctionParmPackExpr(x)
end

function FunctionParmPackExpr(x::AbstractStmt)
    @check_ptrs x
    return FunctionParmPackExpr(clang_Stmt_castToFunctionParmPackExpr(x))
end

function isFullExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isFullExpr(x)
end

function FullExpr(x::AbstractStmt)
    @check_ptrs x
    return FullExpr(clang_Stmt_castToFullExpr(x))
end

function isExprWithCleanups(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isExprWithCleanups(x)
end

function ExprWithCleanups(x::AbstractStmt)
    @check_ptrs x
    return ExprWithCleanups(clang_Stmt_castToExprWithCleanups(x))
end

function isConstantExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isConstantExpr(x)
end

function ConstantExpr(x::AbstractStmt)
    @check_ptrs x
    return ConstantExpr(clang_Stmt_castToConstantExpr(x))
end

function isFloatingLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isFloatingLiteral(x)
end

function FloatingLiteral(x::AbstractStmt)
    @check_ptrs x
    return FloatingLiteral(clang_Stmt_castToFloatingLiteral(x))
end

function isFixedPointLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isFixedPointLiteral(x)
end

function FixedPointLiteral(x::AbstractStmt)
    @check_ptrs x
    return FixedPointLiteral(clang_Stmt_castToFixedPointLiteral(x))
end

function isExtVectorElementExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isExtVectorElementExpr(x)
end

function ExtVectorElementExpr(x::AbstractStmt)
    @check_ptrs x
    return ExtVectorElementExpr(clang_Stmt_castToExtVectorElementExpr(x))
end

function isExpressionTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isExpressionTraitExpr(x)
end

function ExpressionTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return ExpressionTraitExpr(clang_Stmt_castToExpressionTraitExpr(x))
end

function isDesignatedInitUpdateExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDesignatedInitUpdateExpr(x)
end

function DesignatedInitUpdateExpr(x::AbstractStmt)
    @check_ptrs x
    return DesignatedInitUpdateExpr(clang_Stmt_castToDesignatedInitUpdateExpr(x))
end

function isDesignatedInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDesignatedInitExpr(x)
end

function DesignatedInitExpr(x::AbstractStmt)
    @check_ptrs x
    return DesignatedInitExpr(clang_Stmt_castToDesignatedInitExpr(x))
end

function isDependentScopeDeclRefExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDependentScopeDeclRefExpr(x)
end

function DependentScopeDeclRefExpr(x::AbstractStmt)
    @check_ptrs x
    return DependentScopeDeclRefExpr(clang_Stmt_castToDependentScopeDeclRefExpr(x))
end

function isDependentCoawaitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDependentCoawaitExpr(x)
end

function DependentCoawaitExpr(x::AbstractStmt)
    @check_ptrs x
    return DependentCoawaitExpr(clang_Stmt_castToDependentCoawaitExpr(x))
end

function isDeclRefExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDeclRefExpr(x)
end

function DeclRefExpr(x::AbstractStmt)
    @check_ptrs x
    return DeclRefExpr(clang_Stmt_castToDeclRefExpr(x))
end

function isCoroutineSuspendExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCoroutineSuspendExpr(x)
end

function CoroutineSuspendExpr(x::AbstractStmt)
    @check_ptrs x
    return CoroutineSuspendExpr(clang_Stmt_castToCoroutineSuspendExpr(x))
end

function isCoyieldExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCoyieldExpr(x)
end

function CoyieldExpr(x::AbstractStmt)
    @check_ptrs x
    return CoyieldExpr(clang_Stmt_castToCoyieldExpr(x))
end

function isCoawaitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCoawaitExpr(x)
end

function CoawaitExpr(x::AbstractStmt)
    @check_ptrs x
    return CoawaitExpr(clang_Stmt_castToCoawaitExpr(x))
end

function isConvertVectorExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isConvertVectorExpr(x)
end

function ConvertVectorExpr(x::AbstractStmt)
    @check_ptrs x
    return ConvertVectorExpr(clang_Stmt_castToConvertVectorExpr(x))
end

function isConceptSpecializationExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isConceptSpecializationExpr(x)
end

function ConceptSpecializationExpr(x::AbstractStmt)
    @check_ptrs x
    return ConceptSpecializationExpr(clang_Stmt_castToConceptSpecializationExpr(x))
end

function isCompoundLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCompoundLiteralExpr(x)
end

function CompoundLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return CompoundLiteralExpr(clang_Stmt_castToCompoundLiteralExpr(x))
end

function isChooseExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isChooseExpr(x)
end

function ChooseExpr(x::AbstractStmt)
    @check_ptrs x
    return ChooseExpr(clang_Stmt_castToChooseExpr(x))
end

function isCharacterLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCharacterLiteral(x)
end

function CharacterLiteral(x::AbstractStmt)
    @check_ptrs x
    return CharacterLiteral(clang_Stmt_castToCharacterLiteral(x))
end

function isCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCastExpr(x)
end

function CastExpr(x::AbstractStmt)
    @check_ptrs x
    return CastExpr(clang_Stmt_castToCastExpr(x))
end

function isImplicitCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isImplicitCastExpr(x)
end

function ImplicitCastExpr(x::AbstractStmt)
    @check_ptrs x
    return ImplicitCastExpr(clang_Stmt_castToImplicitCastExpr(x))
end

function isExplicitCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isExplicitCastExpr(x)
end

function ExplicitCastExpr(x::AbstractStmt)
    @check_ptrs x
    return ExplicitCastExpr(clang_Stmt_castToExplicitCastExpr(x))
end

function isObjCBridgedCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCBridgedCastExpr(x)
end

function ObjCBridgedCastExpr(x::AbstractStmt)
    @check_ptrs x
    return ObjCBridgedCastExpr(clang_Stmt_castToObjCBridgedCastExpr(x))
end

function isCXXNamedCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXNamedCastExpr(x)
end

function CXXNamedCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXNamedCastExpr(clang_Stmt_castToCXXNamedCastExpr(x))
end

function isCXXStaticCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXStaticCastExpr(x)
end

function CXXStaticCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXStaticCastExpr(clang_Stmt_castToCXXStaticCastExpr(x))
end

function isCXXReinterpretCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXReinterpretCastExpr(x)
end

function CXXReinterpretCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXReinterpretCastExpr(clang_Stmt_castToCXXReinterpretCastExpr(x))
end

function isCXXDynamicCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXDynamicCastExpr(x)
end

function CXXDynamicCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXDynamicCastExpr(clang_Stmt_castToCXXDynamicCastExpr(x))
end

function isCXXConstCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXConstCastExpr(x)
end

function CXXConstCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXConstCastExpr(clang_Stmt_castToCXXConstCastExpr(x))
end

function isCXXAddrspaceCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXAddrspaceCastExpr(x)
end

function CXXAddrspaceCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXAddrspaceCastExpr(clang_Stmt_castToCXXAddrspaceCastExpr(x))
end

function isCXXFunctionalCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXFunctionalCastExpr(x)
end

function CXXFunctionalCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXFunctionalCastExpr(clang_Stmt_castToCXXFunctionalCastExpr(x))
end

function isCStyleCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCStyleCastExpr(x)
end

function CStyleCastExpr(x::AbstractStmt)
    @check_ptrs x
    return CStyleCastExpr(clang_Stmt_castToCStyleCastExpr(x))
end

function isBuiltinBitCastExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isBuiltinBitCastExpr(x)
end

function BuiltinBitCastExpr(x::AbstractStmt)
    @check_ptrs x
    return BuiltinBitCastExpr(clang_Stmt_castToBuiltinBitCastExpr(x))
end

function isCallExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCallExpr(x)
end

function CallExpr(x::AbstractStmt)
    @check_ptrs x
    return CallExpr(clang_Stmt_castToCallExpr(x))
end

function isUserDefinedLiteral(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isUserDefinedLiteral(x)
end

function UserDefinedLiteral(x::AbstractStmt)
    @check_ptrs x
    return UserDefinedLiteral(clang_Stmt_castToUserDefinedLiteral(x))
end

function isCXXOperatorCallExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXOperatorCallExpr(x)
end

function CXXOperatorCallExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXOperatorCallExpr(clang_Stmt_castToCXXOperatorCallExpr(x))
end

function isCXXMemberCallExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXMemberCallExpr(x)
end

function CXXMemberCallExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXMemberCallExpr(clang_Stmt_castToCXXMemberCallExpr(x))
end

function isCUDAKernelCallExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCUDAKernelCallExpr(x)
end

function CUDAKernelCallExpr(x::AbstractStmt)
    @check_ptrs x
    return CUDAKernelCallExpr(clang_Stmt_castToCUDAKernelCallExpr(x))
end

function isCXXUuidofExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXUuidofExpr(x)
end

function CXXUuidofExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXUuidofExpr(clang_Stmt_castToCXXUuidofExpr(x))
end

function isCXXUnresolvedConstructExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXUnresolvedConstructExpr(x)
end

function CXXUnresolvedConstructExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXUnresolvedConstructExpr(clang_Stmt_castToCXXUnresolvedConstructExpr(x))
end

function isCXXTypeidExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXTypeidExpr(x)
end

function CXXTypeidExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXTypeidExpr(clang_Stmt_castToCXXTypeidExpr(x))
end

function isCXXThrowExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXThrowExpr(x)
end

function CXXThrowExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXThrowExpr(clang_Stmt_castToCXXThrowExpr(x))
end

function isCXXThisExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXThisExpr(x)
end

function CXXThisExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXThisExpr(clang_Stmt_castToCXXThisExpr(x))
end

function isCXXStdInitializerListExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXStdInitializerListExpr(x)
end

function CXXStdInitializerListExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXStdInitializerListExpr(clang_Stmt_castToCXXStdInitializerListExpr(x))
end

function isCXXScalarValueInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXScalarValueInitExpr(x)
end

function CXXScalarValueInitExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXScalarValueInitExpr(clang_Stmt_castToCXXScalarValueInitExpr(x))
end

function isCXXRewrittenBinaryOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXRewrittenBinaryOperator(x)
end

function CXXRewrittenBinaryOperator(x::AbstractStmt)
    @check_ptrs x
    return CXXRewrittenBinaryOperator(clang_Stmt_castToCXXRewrittenBinaryOperator(x))
end

function isCXXPseudoDestructorExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXPseudoDestructorExpr(x)
end

function CXXPseudoDestructorExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXPseudoDestructorExpr(clang_Stmt_castToCXXPseudoDestructorExpr(x))
end

function isCXXParenListInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXParenListInitExpr(x)
end

function CXXParenListInitExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXParenListInitExpr(clang_Stmt_castToCXXParenListInitExpr(x))
end

function isCXXNullPtrLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXNullPtrLiteralExpr(x)
end

function CXXNullPtrLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXNullPtrLiteralExpr(clang_Stmt_castToCXXNullPtrLiteralExpr(x))
end

function isCXXNoexceptExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXNoexceptExpr(x)
end

function CXXNoexceptExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXNoexceptExpr(clang_Stmt_castToCXXNoexceptExpr(x))
end

function isCXXNewExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXNewExpr(x)
end

function CXXNewExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXNewExpr(clang_Stmt_castToCXXNewExpr(x))
end

function isCXXInheritedCtorInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXInheritedCtorInitExpr(x)
end

function CXXInheritedCtorInitExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXInheritedCtorInitExpr(clang_Stmt_castToCXXInheritedCtorInitExpr(x))
end

function isCXXFoldExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXFoldExpr(x)
end

function CXXFoldExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXFoldExpr(clang_Stmt_castToCXXFoldExpr(x))
end

function isCXXDependentScopeMemberExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXDependentScopeMemberExpr(x)
end

function CXXDependentScopeMemberExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXDependentScopeMemberExpr(clang_Stmt_castToCXXDependentScopeMemberExpr(x))
end

function isCXXDeleteExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXDeleteExpr(x)
end

function CXXDeleteExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXDeleteExpr(clang_Stmt_castToCXXDeleteExpr(x))
end

function isCXXDefaultInitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXDefaultInitExpr(x)
end

function CXXDefaultInitExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXDefaultInitExpr(clang_Stmt_castToCXXDefaultInitExpr(x))
end

function isCXXDefaultArgExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXDefaultArgExpr(x)
end

function CXXDefaultArgExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXDefaultArgExpr(clang_Stmt_castToCXXDefaultArgExpr(x))
end

function isCXXConstructExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXConstructExpr(x)
end

function CXXConstructExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXConstructExpr(clang_Stmt_castToCXXConstructExpr(x))
end

function isCXXTemporaryObjectExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXTemporaryObjectExpr(x)
end

function CXXTemporaryObjectExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXTemporaryObjectExpr(clang_Stmt_castToCXXTemporaryObjectExpr(x))
end

function isCXXBoolLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXBoolLiteralExpr(x)
end

function CXXBoolLiteralExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXBoolLiteralExpr(clang_Stmt_castToCXXBoolLiteralExpr(x))
end

function isCXXBindTemporaryExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXBindTemporaryExpr(x)
end

function CXXBindTemporaryExpr(x::AbstractStmt)
    @check_ptrs x
    return CXXBindTemporaryExpr(clang_Stmt_castToCXXBindTemporaryExpr(x))
end

function isBlockExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isBlockExpr(x)
end

function BlockExpr(x::AbstractStmt)
    @check_ptrs x
    return BlockExpr(clang_Stmt_castToBlockExpr(x))
end

function isBinaryOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isBinaryOperator(x)
end

function BinaryOperator(x::AbstractStmt)
    @check_ptrs x
    return BinaryOperator(clang_Stmt_castToBinaryOperator(x))
end

function isCompoundAssignOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCompoundAssignOperator(x)
end

function CompoundAssignOperator(x::AbstractStmt)
    @check_ptrs x
    return CompoundAssignOperator(clang_Stmt_castToCompoundAssignOperator(x))
end

function isAtomicExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isAtomicExpr(x)
end

function AtomicExpr(x::AbstractStmt)
    @check_ptrs x
    return AtomicExpr(clang_Stmt_castToAtomicExpr(x))
end

function isAsTypeExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isAsTypeExpr(x)
end

function AsTypeExpr(x::AbstractStmt)
    @check_ptrs x
    return AsTypeExpr(clang_Stmt_castToAsTypeExpr(x))
end

function isArrayTypeTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isArrayTypeTraitExpr(x)
end

function ArrayTypeTraitExpr(x::AbstractStmt)
    @check_ptrs x
    return ArrayTypeTraitExpr(clang_Stmt_castToArrayTypeTraitExpr(x))
end

function isArraySubscriptExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isArraySubscriptExpr(x)
end

function ArraySubscriptExpr(x::AbstractStmt)
    @check_ptrs x
    return ArraySubscriptExpr(clang_Stmt_castToArraySubscriptExpr(x))
end

function isArrayInitLoopExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isArrayInitLoopExpr(x)
end

function ArrayInitLoopExpr(x::AbstractStmt)
    @check_ptrs x
    return ArrayInitLoopExpr(clang_Stmt_castToArrayInitLoopExpr(x))
end

function isArrayInitIndexExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isArrayInitIndexExpr(x)
end

function ArrayInitIndexExpr(x::AbstractStmt)
    @check_ptrs x
    return ArrayInitIndexExpr(clang_Stmt_castToArrayInitIndexExpr(x))
end

function isAddrLabelExpr(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isAddrLabelExpr(x)
end

function AddrLabelExpr(x::AbstractStmt)
    @check_ptrs x
    return AddrLabelExpr(clang_Stmt_castToAddrLabelExpr(x))
end

function isAbstractConditionalOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isAbstractConditionalOperator(x)
end

function AbstractConditionalOperator(x::AbstractStmt)
    @check_ptrs x
    return AbstractConditionalOperator(clang_Stmt_castToAbstractConditionalOperator(x))
end

function isConditionalOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isConditionalOperator(x)
end

function ConditionalOperator(x::AbstractStmt)
    @check_ptrs x
    return ConditionalOperator(clang_Stmt_castToConditionalOperator(x))
end

function isBinaryConditionalOperator(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isBinaryConditionalOperator(x)
end

function BinaryConditionalOperator(x::AbstractStmt)
    @check_ptrs x
    return BinaryConditionalOperator(clang_Stmt_castToBinaryConditionalOperator(x))
end

function isAttributedStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isAttributedStmt(x)
end

function AttributedStmt(x::AbstractStmt)
    @check_ptrs x
    return AttributedStmt(clang_Stmt_castToAttributedStmt(x))
end

function isSwitchStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSwitchStmt(x)
end

function SwitchStmt(x::AbstractStmt)
    @check_ptrs x
    return SwitchStmt(clang_Stmt_castToSwitchStmt(x))
end

function isSwitchCase(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSwitchCase(x)
end

function SwitchCase(x::AbstractStmt)
    @check_ptrs x
    return SwitchCase(clang_Stmt_castToSwitchCase(x))
end

function isDefaultStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDefaultStmt(x)
end

function DefaultStmt(x::AbstractStmt)
    @check_ptrs x
    return DefaultStmt(clang_Stmt_castToDefaultStmt(x))
end

function isCaseStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCaseStmt(x)
end

function CaseStmt(x::AbstractStmt)
    @check_ptrs x
    return CaseStmt(clang_Stmt_castToCaseStmt(x))
end

function isSEHTryStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSEHTryStmt(x)
end

function SEHTryStmt(x::AbstractStmt)
    @check_ptrs x
    return SEHTryStmt(clang_Stmt_castToSEHTryStmt(x))
end

function isSEHLeaveStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSEHLeaveStmt(x)
end

function SEHLeaveStmt(x::AbstractStmt)
    @check_ptrs x
    return SEHLeaveStmt(clang_Stmt_castToSEHLeaveStmt(x))
end

function isSEHFinallyStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSEHFinallyStmt(x)
end

function SEHFinallyStmt(x::AbstractStmt)
    @check_ptrs x
    return SEHFinallyStmt(clang_Stmt_castToSEHFinallyStmt(x))
end

function isSEHExceptStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isSEHExceptStmt(x)
end

function SEHExceptStmt(x::AbstractStmt)
    @check_ptrs x
    return SEHExceptStmt(clang_Stmt_castToSEHExceptStmt(x))
end

function isReturnStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isReturnStmt(x)
end

function ReturnStmt(x::AbstractStmt)
    @check_ptrs x
    return ReturnStmt(clang_Stmt_castToReturnStmt(x))
end

function isObjCForCollectionStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCForCollectionStmt(x)
end

function ObjCForCollectionStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCForCollectionStmt(clang_Stmt_castToObjCForCollectionStmt(x))
end

function isObjCAutoreleasePoolStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAutoreleasePoolStmt(x)
end

function ObjCAutoreleasePoolStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCAutoreleasePoolStmt(clang_Stmt_castToObjCAutoreleasePoolStmt(x))
end

function isObjCAtTryStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAtTryStmt(x)
end

function ObjCAtTryStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCAtTryStmt(clang_Stmt_castToObjCAtTryStmt(x))
end

function isObjCAtThrowStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAtThrowStmt(x)
end

function ObjCAtThrowStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCAtThrowStmt(clang_Stmt_castToObjCAtThrowStmt(x))
end

function isObjCAtSynchronizedStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAtSynchronizedStmt(x)
end

function ObjCAtSynchronizedStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCAtSynchronizedStmt(clang_Stmt_castToObjCAtSynchronizedStmt(x))
end

function isObjCAtFinallyStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAtFinallyStmt(x)
end

function ObjCAtFinallyStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCAtFinallyStmt(clang_Stmt_castToObjCAtFinallyStmt(x))
end

function isObjCAtCatchStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isObjCAtCatchStmt(x)
end

function ObjCAtCatchStmt(x::AbstractStmt)
    @check_ptrs x
    return ObjCAtCatchStmt(clang_Stmt_castToObjCAtCatchStmt(x))
end

function isOMPExecutableDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPExecutableDirective(x)
end

function OMPExecutableDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPExecutableDirective(clang_Stmt_castToOMPExecutableDirective(x))
end

function isOMPTeamsDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTeamsDirective(x)
end

function OMPTeamsDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTeamsDirective(clang_Stmt_castToOMPTeamsDirective(x))
end

function isOMPTaskyieldDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTaskyieldDirective(x)
end

function OMPTaskyieldDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTaskyieldDirective(clang_Stmt_castToOMPTaskyieldDirective(x))
end

function isOMPTaskwaitDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTaskwaitDirective(x)
end

function OMPTaskwaitDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTaskwaitDirective(clang_Stmt_castToOMPTaskwaitDirective(x))
end

function isOMPTaskgroupDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTaskgroupDirective(x)
end

function OMPTaskgroupDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTaskgroupDirective(clang_Stmt_castToOMPTaskgroupDirective(x))
end

function isOMPTaskDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTaskDirective(x)
end

function OMPTaskDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTaskDirective(clang_Stmt_castToOMPTaskDirective(x))
end

function isOMPTargetUpdateDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetUpdateDirective(x)
end

function OMPTargetUpdateDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetUpdateDirective(clang_Stmt_castToOMPTargetUpdateDirective(x))
end

function isOMPTargetTeamsDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetTeamsDirective(x)
end

function OMPTargetTeamsDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetTeamsDirective(clang_Stmt_castToOMPTargetTeamsDirective(x))
end

function isOMPTargetParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetParallelForDirective(x)
end

function OMPTargetParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetParallelForDirective(clang_Stmt_castToOMPTargetParallelForDirective(x))
end

function isOMPTargetParallelDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetParallelDirective(x)
end

function OMPTargetParallelDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetParallelDirective(clang_Stmt_castToOMPTargetParallelDirective(x))
end

function isOMPTargetExitDataDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetExitDataDirective(x)
end

function OMPTargetExitDataDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetExitDataDirective(clang_Stmt_castToOMPTargetExitDataDirective(x))
end

function isOMPTargetEnterDataDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetEnterDataDirective(x)
end

function OMPTargetEnterDataDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetEnterDataDirective(clang_Stmt_castToOMPTargetEnterDataDirective(x))
end

function isOMPTargetDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetDirective(x)
end

function OMPTargetDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetDirective(clang_Stmt_castToOMPTargetDirective(x))
end

function isOMPTargetDataDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetDataDirective(x)
end

function OMPTargetDataDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetDataDirective(clang_Stmt_castToOMPTargetDataDirective(x))
end

function isOMPSingleDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPSingleDirective(x)
end

function OMPSingleDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPSingleDirective(clang_Stmt_castToOMPSingleDirective(x))
end

function isOMPSectionsDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPSectionsDirective(x)
end

function OMPSectionsDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPSectionsDirective(clang_Stmt_castToOMPSectionsDirective(x))
end

function isOMPSectionDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPSectionDirective(x)
end

function OMPSectionDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPSectionDirective(clang_Stmt_castToOMPSectionDirective(x))
end

function isOMPScopeDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPScopeDirective(x)
end

function OMPScopeDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPScopeDirective(clang_Stmt_castToOMPScopeDirective(x))
end

function isOMPScanDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPScanDirective(x)
end

function OMPScanDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPScanDirective(clang_Stmt_castToOMPScanDirective(x))
end

function isOMPParallelSectionsDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelSectionsDirective(x)
end

function OMPParallelSectionsDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelSectionsDirective(clang_Stmt_castToOMPParallelSectionsDirective(x))
end

function isOMPParallelMasterDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelMasterDirective(x)
end

function OMPParallelMasterDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelMasterDirective(clang_Stmt_castToOMPParallelMasterDirective(x))
end

function isOMPParallelMaskedDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelMaskedDirective(x)
end

function OMPParallelMaskedDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelMaskedDirective(clang_Stmt_castToOMPParallelMaskedDirective(x))
end

function isOMPParallelDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelDirective(x)
end

function OMPParallelDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelDirective(clang_Stmt_castToOMPParallelDirective(x))
end

function isOMPOrderedDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPOrderedDirective(x)
end

function OMPOrderedDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPOrderedDirective(clang_Stmt_castToOMPOrderedDirective(x))
end

function isOMPMetaDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMetaDirective(x)
end

function OMPMetaDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMetaDirective(clang_Stmt_castToOMPMetaDirective(x))
end

function isOMPMasterDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMasterDirective(x)
end

function OMPMasterDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMasterDirective(clang_Stmt_castToOMPMasterDirective(x))
end

function isOMPMaskedDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMaskedDirective(x)
end

function OMPMaskedDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMaskedDirective(clang_Stmt_castToOMPMaskedDirective(x))
end

function isOMPLoopBasedDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPLoopBasedDirective(x)
end

function OMPLoopBasedDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPLoopBasedDirective(clang_Stmt_castToOMPLoopBasedDirective(x))
end

function isOMPLoopTransformationDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPLoopTransformationDirective(x)
end

function OMPLoopTransformationDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPLoopTransformationDirective(clang_Stmt_castToOMPLoopTransformationDirective(x))
end

function isOMPUnrollDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPUnrollDirective(x)
end

function OMPUnrollDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPUnrollDirective(clang_Stmt_castToOMPUnrollDirective(x))
end

function isOMPTileDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTileDirective(x)
end

function OMPTileDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTileDirective(clang_Stmt_castToOMPTileDirective(x))
end

function isOMPLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPLoopDirective(x)
end

function OMPLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPLoopDirective(clang_Stmt_castToOMPLoopDirective(x))
end

function isOMPTeamsGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTeamsGenericLoopDirective(x)
end

function OMPTeamsGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTeamsGenericLoopDirective(clang_Stmt_castToOMPTeamsGenericLoopDirective(x))
end

function isOMPTeamsDistributeSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTeamsDistributeSimdDirective(x)
end

function OMPTeamsDistributeSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTeamsDistributeSimdDirective(clang_Stmt_castToOMPTeamsDistributeSimdDirective(x))
end

function isOMPTeamsDistributeParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTeamsDistributeParallelForSimdDirective(x)
end

function OMPTeamsDistributeParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTeamsDistributeParallelForSimdDirective(clang_Stmt_castToOMPTeamsDistributeParallelForSimdDirective(x))
end

function isOMPTeamsDistributeParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTeamsDistributeParallelForDirective(x)
end

function OMPTeamsDistributeParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTeamsDistributeParallelForDirective(clang_Stmt_castToOMPTeamsDistributeParallelForDirective(x))
end

function isOMPTeamsDistributeDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTeamsDistributeDirective(x)
end

function OMPTeamsDistributeDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTeamsDistributeDirective(clang_Stmt_castToOMPTeamsDistributeDirective(x))
end

function isOMPTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTaskLoopSimdDirective(x)
end

function OMPTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTaskLoopSimdDirective(clang_Stmt_castToOMPTaskLoopSimdDirective(x))
end

function isOMPTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTaskLoopDirective(x)
end

function OMPTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTaskLoopDirective(clang_Stmt_castToOMPTaskLoopDirective(x))
end

function isOMPTargetTeamsGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetTeamsGenericLoopDirective(x)
end

function OMPTargetTeamsGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetTeamsGenericLoopDirective(clang_Stmt_castToOMPTargetTeamsGenericLoopDirective(x))
end

function isOMPTargetTeamsDistributeSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetTeamsDistributeSimdDirective(x)
end

function OMPTargetTeamsDistributeSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetTeamsDistributeSimdDirective(clang_Stmt_castToOMPTargetTeamsDistributeSimdDirective(x))
end

function isOMPTargetTeamsDistributeParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetTeamsDistributeParallelForSimdDirective(x)
end

function OMPTargetTeamsDistributeParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetTeamsDistributeParallelForSimdDirective(clang_Stmt_castToOMPTargetTeamsDistributeParallelForSimdDirective(x))
end

function isOMPTargetTeamsDistributeParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetTeamsDistributeParallelForDirective(x)
end

function OMPTargetTeamsDistributeParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetTeamsDistributeParallelForDirective(clang_Stmt_castToOMPTargetTeamsDistributeParallelForDirective(x))
end

function isOMPTargetTeamsDistributeDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetTeamsDistributeDirective(x)
end

function OMPTargetTeamsDistributeDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetTeamsDistributeDirective(clang_Stmt_castToOMPTargetTeamsDistributeDirective(x))
end

function isOMPTargetSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetSimdDirective(x)
end

function OMPTargetSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetSimdDirective(clang_Stmt_castToOMPTargetSimdDirective(x))
end

function isOMPTargetParallelGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetParallelGenericLoopDirective(x)
end

function OMPTargetParallelGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetParallelGenericLoopDirective(clang_Stmt_castToOMPTargetParallelGenericLoopDirective(x))
end

function isOMPTargetParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPTargetParallelForSimdDirective(x)
end

function OMPTargetParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPTargetParallelForSimdDirective(clang_Stmt_castToOMPTargetParallelForSimdDirective(x))
end

function isOMPSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPSimdDirective(x)
end

function OMPSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPSimdDirective(clang_Stmt_castToOMPSimdDirective(x))
end

function isOMPParallelMasterTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelMasterTaskLoopSimdDirective(x)
end

function OMPParallelMasterTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelMasterTaskLoopSimdDirective(clang_Stmt_castToOMPParallelMasterTaskLoopSimdDirective(x))
end

function isOMPParallelMasterTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelMasterTaskLoopDirective(x)
end

function OMPParallelMasterTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelMasterTaskLoopDirective(clang_Stmt_castToOMPParallelMasterTaskLoopDirective(x))
end

function isOMPParallelMaskedTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelMaskedTaskLoopSimdDirective(x)
end

function OMPParallelMaskedTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelMaskedTaskLoopSimdDirective(clang_Stmt_castToOMPParallelMaskedTaskLoopSimdDirective(x))
end

function isOMPParallelMaskedTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelMaskedTaskLoopDirective(x)
end

function OMPParallelMaskedTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelMaskedTaskLoopDirective(clang_Stmt_castToOMPParallelMaskedTaskLoopDirective(x))
end

function isOMPParallelGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelGenericLoopDirective(x)
end

function OMPParallelGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelGenericLoopDirective(clang_Stmt_castToOMPParallelGenericLoopDirective(x))
end

function isOMPParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelForSimdDirective(x)
end

function OMPParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelForSimdDirective(clang_Stmt_castToOMPParallelForSimdDirective(x))
end

function isOMPParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPParallelForDirective(x)
end

function OMPParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPParallelForDirective(clang_Stmt_castToOMPParallelForDirective(x))
end

function isOMPMasterTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMasterTaskLoopSimdDirective(x)
end

function OMPMasterTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMasterTaskLoopSimdDirective(clang_Stmt_castToOMPMasterTaskLoopSimdDirective(x))
end

function isOMPMasterTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMasterTaskLoopDirective(x)
end

function OMPMasterTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMasterTaskLoopDirective(clang_Stmt_castToOMPMasterTaskLoopDirective(x))
end

function isOMPMaskedTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMaskedTaskLoopSimdDirective(x)
end

function OMPMaskedTaskLoopSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMaskedTaskLoopSimdDirective(clang_Stmt_castToOMPMaskedTaskLoopSimdDirective(x))
end

function isOMPMaskedTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPMaskedTaskLoopDirective(x)
end

function OMPMaskedTaskLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPMaskedTaskLoopDirective(clang_Stmt_castToOMPMaskedTaskLoopDirective(x))
end

function isOMPGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPGenericLoopDirective(x)
end

function OMPGenericLoopDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPGenericLoopDirective(clang_Stmt_castToOMPGenericLoopDirective(x))
end

function isOMPForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPForSimdDirective(x)
end

function OMPForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPForSimdDirective(clang_Stmt_castToOMPForSimdDirective(x))
end

function isOMPForDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPForDirective(x)
end

function OMPForDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPForDirective(clang_Stmt_castToOMPForDirective(x))
end

function isOMPDistributeSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPDistributeSimdDirective(x)
end

function OMPDistributeSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPDistributeSimdDirective(clang_Stmt_castToOMPDistributeSimdDirective(x))
end

function isOMPDistributeParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPDistributeParallelForSimdDirective(x)
end

function OMPDistributeParallelForSimdDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPDistributeParallelForSimdDirective(clang_Stmt_castToOMPDistributeParallelForSimdDirective(x))
end

function isOMPDistributeParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPDistributeParallelForDirective(x)
end

function OMPDistributeParallelForDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPDistributeParallelForDirective(clang_Stmt_castToOMPDistributeParallelForDirective(x))
end

function isOMPDistributeDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPDistributeDirective(x)
end

function OMPDistributeDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPDistributeDirective(clang_Stmt_castToOMPDistributeDirective(x))
end

function isOMPInteropDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPInteropDirective(x)
end

function OMPInteropDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPInteropDirective(clang_Stmt_castToOMPInteropDirective(x))
end

function isOMPFlushDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPFlushDirective(x)
end

function OMPFlushDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPFlushDirective(clang_Stmt_castToOMPFlushDirective(x))
end

function isOMPErrorDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPErrorDirective(x)
end

function OMPErrorDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPErrorDirective(clang_Stmt_castToOMPErrorDirective(x))
end

function isOMPDispatchDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPDispatchDirective(x)
end

function OMPDispatchDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPDispatchDirective(clang_Stmt_castToOMPDispatchDirective(x))
end

function isOMPDepobjDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPDepobjDirective(x)
end

function OMPDepobjDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPDepobjDirective(clang_Stmt_castToOMPDepobjDirective(x))
end

function isOMPCriticalDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPCriticalDirective(x)
end

function OMPCriticalDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPCriticalDirective(clang_Stmt_castToOMPCriticalDirective(x))
end

function isOMPCancellationPointDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPCancellationPointDirective(x)
end

function OMPCancellationPointDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPCancellationPointDirective(clang_Stmt_castToOMPCancellationPointDirective(x))
end

function isOMPCancelDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPCancelDirective(x)
end

function OMPCancelDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPCancelDirective(clang_Stmt_castToOMPCancelDirective(x))
end

function isOMPBarrierDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPBarrierDirective(x)
end

function OMPBarrierDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPBarrierDirective(clang_Stmt_castToOMPBarrierDirective(x))
end

function isOMPAtomicDirective(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPAtomicDirective(x)
end

function OMPAtomicDirective(x::AbstractStmt)
    @check_ptrs x
    return OMPAtomicDirective(clang_Stmt_castToOMPAtomicDirective(x))
end

function isOMPCanonicalLoop(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isOMPCanonicalLoop(x)
end

function OMPCanonicalLoop(x::AbstractStmt)
    @check_ptrs x
    return OMPCanonicalLoop(clang_Stmt_castToOMPCanonicalLoop(x))
end

function isNullStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isNullStmt(x)
end

function NullStmt(x::AbstractStmt)
    @check_ptrs x
    return NullStmt(clang_Stmt_castToNullStmt(x))
end

function isMSDependentExistsStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMSDependentExistsStmt(x)
end

function MSDependentExistsStmt(x::AbstractStmt)
    @check_ptrs x
    return MSDependentExistsStmt(clang_Stmt_castToMSDependentExistsStmt(x))
end

function isIndirectGotoStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isIndirectGotoStmt(x)
end

function IndirectGotoStmt(x::AbstractStmt)
    @check_ptrs x
    return IndirectGotoStmt(clang_Stmt_castToIndirectGotoStmt(x))
end

function isIfStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isIfStmt(x)
end

function IfStmt(x::AbstractStmt)
    @check_ptrs x
    return IfStmt(clang_Stmt_castToIfStmt(x))
end

function isGotoStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isGotoStmt(x)
end

function GotoStmt(x::AbstractStmt)
    @check_ptrs x
    return GotoStmt(clang_Stmt_castToGotoStmt(x))
end

function isForStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isForStmt(x)
end

function ForStmt(x::AbstractStmt)
    @check_ptrs x
    return ForStmt(clang_Stmt_castToForStmt(x))
end

function isDoStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDoStmt(x)
end

function DoStmt(x::AbstractStmt)
    @check_ptrs x
    return DoStmt(clang_Stmt_castToDoStmt(x))
end

function isDeclStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isDeclStmt(x)
end

function DeclStmt(x::AbstractStmt)
    @check_ptrs x
    return DeclStmt(clang_Stmt_castToDeclStmt(x))
end

function isCoroutineBodyStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCoroutineBodyStmt(x)
end

function CoroutineBodyStmt(x::AbstractStmt)
    @check_ptrs x
    return CoroutineBodyStmt(clang_Stmt_castToCoroutineBodyStmt(x))
end

function isCoreturnStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCoreturnStmt(x)
end

function CoreturnStmt(x::AbstractStmt)
    @check_ptrs x
    return CoreturnStmt(clang_Stmt_castToCoreturnStmt(x))
end

function isContinueStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isContinueStmt(x)
end

function ContinueStmt(x::AbstractStmt)
    @check_ptrs x
    return ContinueStmt(clang_Stmt_castToContinueStmt(x))
end

function isCompoundStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCompoundStmt(x)
end

function CompoundStmt(x::AbstractStmt)
    @check_ptrs x
    return CompoundStmt(clang_Stmt_castToCompoundStmt(x))
end

function isCapturedStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCapturedStmt(x)
end

function CapturedStmt(x::AbstractStmt)
    @check_ptrs x
    return CapturedStmt(clang_Stmt_castToCapturedStmt(x))
end

function isCXXTryStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXTryStmt(x)
end

function CXXTryStmt(x::AbstractStmt)
    @check_ptrs x
    return CXXTryStmt(clang_Stmt_castToCXXTryStmt(x))
end

function isCXXForRangeStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXForRangeStmt(x)
end

function CXXForRangeStmt(x::AbstractStmt)
    @check_ptrs x
    return CXXForRangeStmt(clang_Stmt_castToCXXForRangeStmt(x))
end

function isCXXCatchStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isCXXCatchStmt(x)
end

function CXXCatchStmt(x::AbstractStmt)
    @check_ptrs x
    return CXXCatchStmt(clang_Stmt_castToCXXCatchStmt(x))
end

function isBreakStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isBreakStmt(x)
end

function BreakStmt(x::AbstractStmt)
    @check_ptrs x
    return BreakStmt(clang_Stmt_castToBreakStmt(x))
end

function isAsmStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isAsmStmt(x)
end

function AsmStmt(x::AbstractStmt)
    @check_ptrs x
    return AsmStmt(clang_Stmt_castToAsmStmt(x))
end

function isMSAsmStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isMSAsmStmt(x)
end

function MSAsmStmt(x::AbstractStmt)
    @check_ptrs x
    return MSAsmStmt(clang_Stmt_castToMSAsmStmt(x))
end

function isGCCAsmStmt(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_isGCCAsmStmt(x)
end

function GCCAsmStmt(x::AbstractStmt)
    @check_ptrs x
    return GCCAsmStmt(clang_Stmt_castToGCCAsmStmt(x))
end

