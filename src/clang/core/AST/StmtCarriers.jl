# Generated from deps/ClangExtra/include/clang-ex/AST/StmtNodes.inc by gen/stmt_nodes.jl — do not edit.
# Fill-in carriers for Stmt classes the hand-written files omit. Each holds the
# handle of its own class, so the stamped cast that produces it type-checks.
# What a carrier ACCEPTS is decided by clang/handles.jl, not here: a handle of
# another class does not convert, so no carrier needs a constructor of its own.
# Marshalling is the carrier's own entry in converts.jl, plus the `CXStmt`
# entry keyed on `AbstractStmt` that carries it to every base-class binding.
"""
    struct SYCLUniqueStableNameExpr <: AbstractSYCLUniqueStableNameExpr
Hold a pointer to a `clang::SYCLUniqueStableNameExpr` object.
"""
struct SYCLUniqueStableNameExpr <: AbstractSYCLUniqueStableNameExpr
    ptr::CXSYCLUniqueStableNameExpr
end

"""
    struct RequiresExpr <: AbstractRequiresExpr
Hold a pointer to a `clang::RequiresExpr` object.
"""
struct RequiresExpr <: AbstractRequiresExpr
    ptr::CXRequiresExpr
end

"""
    struct OffsetOfExpr <: AbstractOffsetOfExpr
Hold a pointer to a `clang::OffsetOfExpr` object.
"""
struct OffsetOfExpr <: AbstractOffsetOfExpr
    ptr::CXOffsetOfExpr
end

"""
    struct ObjCSubscriptRefExpr <: AbstractObjCSubscriptRefExpr
Hold a pointer to a `clang::ObjCSubscriptRefExpr` object.
"""
struct ObjCSubscriptRefExpr <: AbstractObjCSubscriptRefExpr
    ptr::CXObjCSubscriptRefExpr
end

"""
    struct ObjCStringLiteral <: AbstractObjCStringLiteral
Hold a pointer to a `clang::ObjCStringLiteral` object.
"""
struct ObjCStringLiteral <: AbstractObjCStringLiteral
    ptr::CXObjCStringLiteral
end

"""
    struct ObjCSelectorExpr <: AbstractObjCSelectorExpr
Hold a pointer to a `clang::ObjCSelectorExpr` object.
"""
struct ObjCSelectorExpr <: AbstractObjCSelectorExpr
    ptr::CXObjCSelectorExpr
end

"""
    struct ObjCProtocolExpr <: AbstractObjCProtocolExpr
Hold a pointer to a `clang::ObjCProtocolExpr` object.
"""
struct ObjCProtocolExpr <: AbstractObjCProtocolExpr
    ptr::CXObjCProtocolExpr
end

"""
    struct ObjCPropertyRefExpr <: AbstractObjCPropertyRefExpr
Hold a pointer to a `clang::ObjCPropertyRefExpr` object.
"""
struct ObjCPropertyRefExpr <: AbstractObjCPropertyRefExpr
    ptr::CXObjCPropertyRefExpr
end

"""
    struct ObjCMessageExpr <: AbstractObjCMessageExpr
Hold a pointer to a `clang::ObjCMessageExpr` object.
"""
struct ObjCMessageExpr <: AbstractObjCMessageExpr
    ptr::CXObjCMessageExpr
end

"""
    struct ObjCIvarRefExpr <: AbstractObjCIvarRefExpr
Hold a pointer to a `clang::ObjCIvarRefExpr` object.
"""
struct ObjCIvarRefExpr <: AbstractObjCIvarRefExpr
    ptr::CXObjCIvarRefExpr
end

"""
    struct ObjCIsaExpr <: AbstractObjCIsaExpr
Hold a pointer to a `clang::ObjCIsaExpr` object.
"""
struct ObjCIsaExpr <: AbstractObjCIsaExpr
    ptr::CXObjCIsaExpr
end

"""
    struct ObjCIndirectCopyRestoreExpr <: AbstractObjCIndirectCopyRestoreExpr
Hold a pointer to a `clang::ObjCIndirectCopyRestoreExpr` object.
"""
struct ObjCIndirectCopyRestoreExpr <: AbstractObjCIndirectCopyRestoreExpr
    ptr::CXObjCIndirectCopyRestoreExpr
end

"""
    struct ObjCEncodeExpr <: AbstractObjCEncodeExpr
Hold a pointer to a `clang::ObjCEncodeExpr` object.
"""
struct ObjCEncodeExpr <: AbstractObjCEncodeExpr
    ptr::CXObjCEncodeExpr
end

"""
    struct ObjCDictionaryLiteral <: AbstractObjCDictionaryLiteral
Hold a pointer to a `clang::ObjCDictionaryLiteral` object.
"""
struct ObjCDictionaryLiteral <: AbstractObjCDictionaryLiteral
    ptr::CXObjCDictionaryLiteral
end

"""
    struct ObjCBoxedExpr <: AbstractObjCBoxedExpr
Hold a pointer to a `clang::ObjCBoxedExpr` object.
"""
struct ObjCBoxedExpr <: AbstractObjCBoxedExpr
    ptr::CXObjCBoxedExpr
end

"""
    struct ObjCBoolLiteralExpr <: AbstractObjCBoolLiteralExpr
Hold a pointer to a `clang::ObjCBoolLiteralExpr` object.
"""
struct ObjCBoolLiteralExpr <: AbstractObjCBoolLiteralExpr
    ptr::CXObjCBoolLiteralExpr
end

"""
    struct ObjCAvailabilityCheckExpr <: AbstractObjCAvailabilityCheckExpr
Hold a pointer to a `clang::ObjCAvailabilityCheckExpr` object.
"""
struct ObjCAvailabilityCheckExpr <: AbstractObjCAvailabilityCheckExpr
    ptr::CXObjCAvailabilityCheckExpr
end

"""
    struct ObjCArrayLiteral <: AbstractObjCArrayLiteral
Hold a pointer to a `clang::ObjCArrayLiteral` object.
"""
struct ObjCArrayLiteral <: AbstractObjCArrayLiteral
    ptr::CXObjCArrayLiteral
end

"""
    struct OMPIteratorExpr <: AbstractOMPIteratorExpr
Hold a pointer to a `clang::OMPIteratorExpr` object.
"""
struct OMPIteratorExpr <: AbstractOMPIteratorExpr
    ptr::CXOMPIteratorExpr
end

"""
    struct OMPArrayShapingExpr <: AbstractOMPArrayShapingExpr
Hold a pointer to a `clang::OMPArrayShapingExpr` object.
"""
struct OMPArrayShapingExpr <: AbstractOMPArrayShapingExpr
    ptr::CXOMPArrayShapingExpr
end

"""
    struct OMPArraySectionExpr <: AbstractOMPArraySectionExpr
Hold a pointer to a `clang::OMPArraySectionExpr` object.
"""
struct OMPArraySectionExpr <: AbstractOMPArraySectionExpr
    ptr::CXOMPArraySectionExpr
end

"""
    struct ExprWithCleanups <: AbstractExprWithCleanups
Hold a pointer to a `clang::ExprWithCleanups` object.
"""
struct ExprWithCleanups <: AbstractExprWithCleanups
    ptr::CXExprWithCleanups
end

"""
    struct ConceptSpecializationExpr <: AbstractConceptSpecializationExpr
Hold a pointer to a `clang::ConceptSpecializationExpr` object.
"""
struct ConceptSpecializationExpr <: AbstractConceptSpecializationExpr
    ptr::CXConceptSpecializationExpr
end

"""
    struct ObjCBridgedCastExpr <: AbstractObjCBridgedCastExpr
Hold a pointer to a `clang::ObjCBridgedCastExpr` object.
"""
struct ObjCBridgedCastExpr <: AbstractObjCBridgedCastExpr
    ptr::CXObjCBridgedCastExpr
end

"""
    struct CStyleCastExpr <: AbstractCStyleCastExpr
Hold a pointer to a `clang::CStyleCastExpr` object.
"""
struct CStyleCastExpr <: AbstractCStyleCastExpr
    ptr::CXCStyleCastExpr
end

"""
    struct CXXParenListInitExpr <: AbstractCXXParenListInitExpr
Hold a pointer to a `clang::CXXParenListInitExpr` object.
"""
struct CXXParenListInitExpr <: AbstractCXXParenListInitExpr
    ptr::CXCXXParenListInitExpr
end

"""
    struct ObjCForCollectionStmt <: AbstractObjCForCollectionStmt
Hold a pointer to a `clang::ObjCForCollectionStmt` object.
"""
struct ObjCForCollectionStmt <: AbstractObjCForCollectionStmt
    ptr::CXObjCForCollectionStmt
end

"""
    struct ObjCAutoreleasePoolStmt <: AbstractObjCAutoreleasePoolStmt
Hold a pointer to a `clang::ObjCAutoreleasePoolStmt` object.
"""
struct ObjCAutoreleasePoolStmt <: AbstractObjCAutoreleasePoolStmt
    ptr::CXObjCAutoreleasePoolStmt
end

"""
    struct ObjCAtTryStmt <: AbstractObjCAtTryStmt
Hold a pointer to a `clang::ObjCAtTryStmt` object.
"""
struct ObjCAtTryStmt <: AbstractObjCAtTryStmt
    ptr::CXObjCAtTryStmt
end

"""
    struct ObjCAtThrowStmt <: AbstractObjCAtThrowStmt
Hold a pointer to a `clang::ObjCAtThrowStmt` object.
"""
struct ObjCAtThrowStmt <: AbstractObjCAtThrowStmt
    ptr::CXObjCAtThrowStmt
end

"""
    struct ObjCAtSynchronizedStmt <: AbstractObjCAtSynchronizedStmt
Hold a pointer to a `clang::ObjCAtSynchronizedStmt` object.
"""
struct ObjCAtSynchronizedStmt <: AbstractObjCAtSynchronizedStmt
    ptr::CXObjCAtSynchronizedStmt
end

"""
    struct ObjCAtFinallyStmt <: AbstractObjCAtFinallyStmt
Hold a pointer to a `clang::ObjCAtFinallyStmt` object.
"""
struct ObjCAtFinallyStmt <: AbstractObjCAtFinallyStmt
    ptr::CXObjCAtFinallyStmt
end

"""
    struct ObjCAtCatchStmt <: AbstractObjCAtCatchStmt
Hold a pointer to a `clang::ObjCAtCatchStmt` object.
"""
struct ObjCAtCatchStmt <: AbstractObjCAtCatchStmt
    ptr::CXObjCAtCatchStmt
end

"""
    struct OMPExecutableDirective <: AbstractOMPExecutableDirective
Hold a pointer to a `clang::OMPExecutableDirective` object.
"""
struct OMPExecutableDirective <: AbstractOMPExecutableDirective
    ptr::CXOMPExecutableDirective
end

"""
    struct OMPTeamsDirective <: AbstractOMPTeamsDirective
Hold a pointer to a `clang::OMPTeamsDirective` object.
"""
struct OMPTeamsDirective <: AbstractOMPTeamsDirective
    ptr::CXOMPTeamsDirective
end

"""
    struct OMPTaskyieldDirective <: AbstractOMPTaskyieldDirective
Hold a pointer to a `clang::OMPTaskyieldDirective` object.
"""
struct OMPTaskyieldDirective <: AbstractOMPTaskyieldDirective
    ptr::CXOMPTaskyieldDirective
end

"""
    struct OMPTaskwaitDirective <: AbstractOMPTaskwaitDirective
Hold a pointer to a `clang::OMPTaskwaitDirective` object.
"""
struct OMPTaskwaitDirective <: AbstractOMPTaskwaitDirective
    ptr::CXOMPTaskwaitDirective
end

"""
    struct OMPTaskgroupDirective <: AbstractOMPTaskgroupDirective
Hold a pointer to a `clang::OMPTaskgroupDirective` object.
"""
struct OMPTaskgroupDirective <: AbstractOMPTaskgroupDirective
    ptr::CXOMPTaskgroupDirective
end

"""
    struct OMPTaskDirective <: AbstractOMPTaskDirective
Hold a pointer to a `clang::OMPTaskDirective` object.
"""
struct OMPTaskDirective <: AbstractOMPTaskDirective
    ptr::CXOMPTaskDirective
end

"""
    struct OMPTargetUpdateDirective <: AbstractOMPTargetUpdateDirective
Hold a pointer to a `clang::OMPTargetUpdateDirective` object.
"""
struct OMPTargetUpdateDirective <: AbstractOMPTargetUpdateDirective
    ptr::CXOMPTargetUpdateDirective
end

"""
    struct OMPTargetTeamsDirective <: AbstractOMPTargetTeamsDirective
Hold a pointer to a `clang::OMPTargetTeamsDirective` object.
"""
struct OMPTargetTeamsDirective <: AbstractOMPTargetTeamsDirective
    ptr::CXOMPTargetTeamsDirective
end

"""
    struct OMPTargetParallelForDirective <: AbstractOMPTargetParallelForDirective
Hold a pointer to a `clang::OMPTargetParallelForDirective` object.
"""
struct OMPTargetParallelForDirective <: AbstractOMPTargetParallelForDirective
    ptr::CXOMPTargetParallelForDirective
end

"""
    struct OMPTargetParallelDirective <: AbstractOMPTargetParallelDirective
Hold a pointer to a `clang::OMPTargetParallelDirective` object.
"""
struct OMPTargetParallelDirective <: AbstractOMPTargetParallelDirective
    ptr::CXOMPTargetParallelDirective
end

"""
    struct OMPTargetExitDataDirective <: AbstractOMPTargetExitDataDirective
Hold a pointer to a `clang::OMPTargetExitDataDirective` object.
"""
struct OMPTargetExitDataDirective <: AbstractOMPTargetExitDataDirective
    ptr::CXOMPTargetExitDataDirective
end

"""
    struct OMPTargetEnterDataDirective <: AbstractOMPTargetEnterDataDirective
Hold a pointer to a `clang::OMPTargetEnterDataDirective` object.
"""
struct OMPTargetEnterDataDirective <: AbstractOMPTargetEnterDataDirective
    ptr::CXOMPTargetEnterDataDirective
end

"""
    struct OMPTargetDirective <: AbstractOMPTargetDirective
Hold a pointer to a `clang::OMPTargetDirective` object.
"""
struct OMPTargetDirective <: AbstractOMPTargetDirective
    ptr::CXOMPTargetDirective
end

"""
    struct OMPTargetDataDirective <: AbstractOMPTargetDataDirective
Hold a pointer to a `clang::OMPTargetDataDirective` object.
"""
struct OMPTargetDataDirective <: AbstractOMPTargetDataDirective
    ptr::CXOMPTargetDataDirective
end

"""
    struct OMPSingleDirective <: AbstractOMPSingleDirective
Hold a pointer to a `clang::OMPSingleDirective` object.
"""
struct OMPSingleDirective <: AbstractOMPSingleDirective
    ptr::CXOMPSingleDirective
end

"""
    struct OMPSectionsDirective <: AbstractOMPSectionsDirective
Hold a pointer to a `clang::OMPSectionsDirective` object.
"""
struct OMPSectionsDirective <: AbstractOMPSectionsDirective
    ptr::CXOMPSectionsDirective
end

"""
    struct OMPSectionDirective <: AbstractOMPSectionDirective
Hold a pointer to a `clang::OMPSectionDirective` object.
"""
struct OMPSectionDirective <: AbstractOMPSectionDirective
    ptr::CXOMPSectionDirective
end

"""
    struct OMPScopeDirective <: AbstractOMPScopeDirective
Hold a pointer to a `clang::OMPScopeDirective` object.
"""
struct OMPScopeDirective <: AbstractOMPScopeDirective
    ptr::CXOMPScopeDirective
end

"""
    struct OMPScanDirective <: AbstractOMPScanDirective
Hold a pointer to a `clang::OMPScanDirective` object.
"""
struct OMPScanDirective <: AbstractOMPScanDirective
    ptr::CXOMPScanDirective
end

"""
    struct OMPParallelSectionsDirective <: AbstractOMPParallelSectionsDirective
Hold a pointer to a `clang::OMPParallelSectionsDirective` object.
"""
struct OMPParallelSectionsDirective <: AbstractOMPParallelSectionsDirective
    ptr::CXOMPParallelSectionsDirective
end

"""
    struct OMPParallelMasterDirective <: AbstractOMPParallelMasterDirective
Hold a pointer to a `clang::OMPParallelMasterDirective` object.
"""
struct OMPParallelMasterDirective <: AbstractOMPParallelMasterDirective
    ptr::CXOMPParallelMasterDirective
end

"""
    struct OMPParallelMaskedDirective <: AbstractOMPParallelMaskedDirective
Hold a pointer to a `clang::OMPParallelMaskedDirective` object.
"""
struct OMPParallelMaskedDirective <: AbstractOMPParallelMaskedDirective
    ptr::CXOMPParallelMaskedDirective
end

"""
    struct OMPParallelDirective <: AbstractOMPParallelDirective
Hold a pointer to a `clang::OMPParallelDirective` object.
"""
struct OMPParallelDirective <: AbstractOMPParallelDirective
    ptr::CXOMPParallelDirective
end

"""
    struct OMPOrderedDirective <: AbstractOMPOrderedDirective
Hold a pointer to a `clang::OMPOrderedDirective` object.
"""
struct OMPOrderedDirective <: AbstractOMPOrderedDirective
    ptr::CXOMPOrderedDirective
end

"""
    struct OMPMetaDirective <: AbstractOMPMetaDirective
Hold a pointer to a `clang::OMPMetaDirective` object.
"""
struct OMPMetaDirective <: AbstractOMPMetaDirective
    ptr::CXOMPMetaDirective
end

"""
    struct OMPMasterDirective <: AbstractOMPMasterDirective
Hold a pointer to a `clang::OMPMasterDirective` object.
"""
struct OMPMasterDirective <: AbstractOMPMasterDirective
    ptr::CXOMPMasterDirective
end

"""
    struct OMPMaskedDirective <: AbstractOMPMaskedDirective
Hold a pointer to a `clang::OMPMaskedDirective` object.
"""
struct OMPMaskedDirective <: AbstractOMPMaskedDirective
    ptr::CXOMPMaskedDirective
end

"""
    struct OMPLoopBasedDirective <: AbstractOMPLoopBasedDirective
Hold a pointer to a `clang::OMPLoopBasedDirective` object.
"""
struct OMPLoopBasedDirective <: AbstractOMPLoopBasedDirective
    ptr::CXOMPLoopBasedDirective
end

"""
    struct OMPLoopTransformationDirective <: AbstractOMPLoopTransformationDirective
Hold a pointer to a `clang::OMPLoopTransformationDirective` object.
"""
struct OMPLoopTransformationDirective <: AbstractOMPLoopTransformationDirective
    ptr::CXOMPLoopTransformationDirective
end

"""
    struct OMPUnrollDirective <: AbstractOMPUnrollDirective
Hold a pointer to a `clang::OMPUnrollDirective` object.
"""
struct OMPUnrollDirective <: AbstractOMPUnrollDirective
    ptr::CXOMPUnrollDirective
end

"""
    struct OMPTileDirective <: AbstractOMPTileDirective
Hold a pointer to a `clang::OMPTileDirective` object.
"""
struct OMPTileDirective <: AbstractOMPTileDirective
    ptr::CXOMPTileDirective
end

"""
    struct OMPLoopDirective <: AbstractOMPLoopDirective
Hold a pointer to a `clang::OMPLoopDirective` object.
"""
struct OMPLoopDirective <: AbstractOMPLoopDirective
    ptr::CXOMPLoopDirective
end

"""
    struct OMPTeamsGenericLoopDirective <: AbstractOMPTeamsGenericLoopDirective
Hold a pointer to a `clang::OMPTeamsGenericLoopDirective` object.
"""
struct OMPTeamsGenericLoopDirective <: AbstractOMPTeamsGenericLoopDirective
    ptr::CXOMPTeamsGenericLoopDirective
end

"""
    struct OMPTeamsDistributeSimdDirective <: AbstractOMPTeamsDistributeSimdDirective
Hold a pointer to a `clang::OMPTeamsDistributeSimdDirective` object.
"""
struct OMPTeamsDistributeSimdDirective <: AbstractOMPTeamsDistributeSimdDirective
    ptr::CXOMPTeamsDistributeSimdDirective
end

"""
    struct OMPTeamsDistributeParallelForSimdDirective <: AbstractOMPTeamsDistributeParallelForSimdDirective
Hold a pointer to a `clang::OMPTeamsDistributeParallelForSimdDirective` object.
"""
struct OMPTeamsDistributeParallelForSimdDirective <: AbstractOMPTeamsDistributeParallelForSimdDirective
    ptr::CXOMPTeamsDistributeParallelForSimdDirective
end

"""
    struct OMPTeamsDistributeParallelForDirective <: AbstractOMPTeamsDistributeParallelForDirective
Hold a pointer to a `clang::OMPTeamsDistributeParallelForDirective` object.
"""
struct OMPTeamsDistributeParallelForDirective <: AbstractOMPTeamsDistributeParallelForDirective
    ptr::CXOMPTeamsDistributeParallelForDirective
end

"""
    struct OMPTeamsDistributeDirective <: AbstractOMPTeamsDistributeDirective
Hold a pointer to a `clang::OMPTeamsDistributeDirective` object.
"""
struct OMPTeamsDistributeDirective <: AbstractOMPTeamsDistributeDirective
    ptr::CXOMPTeamsDistributeDirective
end

"""
    struct OMPTaskLoopSimdDirective <: AbstractOMPTaskLoopSimdDirective
Hold a pointer to a `clang::OMPTaskLoopSimdDirective` object.
"""
struct OMPTaskLoopSimdDirective <: AbstractOMPTaskLoopSimdDirective
    ptr::CXOMPTaskLoopSimdDirective
end

"""
    struct OMPTaskLoopDirective <: AbstractOMPTaskLoopDirective
Hold a pointer to a `clang::OMPTaskLoopDirective` object.
"""
struct OMPTaskLoopDirective <: AbstractOMPTaskLoopDirective
    ptr::CXOMPTaskLoopDirective
end

"""
    struct OMPTargetTeamsGenericLoopDirective <: AbstractOMPTargetTeamsGenericLoopDirective
Hold a pointer to a `clang::OMPTargetTeamsGenericLoopDirective` object.
"""
struct OMPTargetTeamsGenericLoopDirective <: AbstractOMPTargetTeamsGenericLoopDirective
    ptr::CXOMPTargetTeamsGenericLoopDirective
end

"""
    struct OMPTargetTeamsDistributeSimdDirective <: AbstractOMPTargetTeamsDistributeSimdDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeSimdDirective` object.
"""
struct OMPTargetTeamsDistributeSimdDirective <: AbstractOMPTargetTeamsDistributeSimdDirective
    ptr::CXOMPTargetTeamsDistributeSimdDirective
end

"""
    struct OMPTargetTeamsDistributeParallelForSimdDirective <: AbstractOMPTargetTeamsDistributeParallelForSimdDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeParallelForSimdDirective` object.
"""
struct OMPTargetTeamsDistributeParallelForSimdDirective <: AbstractOMPTargetTeamsDistributeParallelForSimdDirective
    ptr::CXOMPTargetTeamsDistributeParallelForSimdDirective
end

"""
    struct OMPTargetTeamsDistributeParallelForDirective <: AbstractOMPTargetTeamsDistributeParallelForDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeParallelForDirective` object.
"""
struct OMPTargetTeamsDistributeParallelForDirective <: AbstractOMPTargetTeamsDistributeParallelForDirective
    ptr::CXOMPTargetTeamsDistributeParallelForDirective
end

"""
    struct OMPTargetTeamsDistributeDirective <: AbstractOMPTargetTeamsDistributeDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeDirective` object.
"""
struct OMPTargetTeamsDistributeDirective <: AbstractOMPTargetTeamsDistributeDirective
    ptr::CXOMPTargetTeamsDistributeDirective
end

"""
    struct OMPTargetSimdDirective <: AbstractOMPTargetSimdDirective
Hold a pointer to a `clang::OMPTargetSimdDirective` object.
"""
struct OMPTargetSimdDirective <: AbstractOMPTargetSimdDirective
    ptr::CXOMPTargetSimdDirective
end

"""
    struct OMPTargetParallelGenericLoopDirective <: AbstractOMPTargetParallelGenericLoopDirective
Hold a pointer to a `clang::OMPTargetParallelGenericLoopDirective` object.
"""
struct OMPTargetParallelGenericLoopDirective <: AbstractOMPTargetParallelGenericLoopDirective
    ptr::CXOMPTargetParallelGenericLoopDirective
end

"""
    struct OMPTargetParallelForSimdDirective <: AbstractOMPTargetParallelForSimdDirective
Hold a pointer to a `clang::OMPTargetParallelForSimdDirective` object.
"""
struct OMPTargetParallelForSimdDirective <: AbstractOMPTargetParallelForSimdDirective
    ptr::CXOMPTargetParallelForSimdDirective
end

"""
    struct OMPSimdDirective <: AbstractOMPSimdDirective
Hold a pointer to a `clang::OMPSimdDirective` object.
"""
struct OMPSimdDirective <: AbstractOMPSimdDirective
    ptr::CXOMPSimdDirective
end

"""
    struct OMPParallelMasterTaskLoopSimdDirective <: AbstractOMPParallelMasterTaskLoopSimdDirective
Hold a pointer to a `clang::OMPParallelMasterTaskLoopSimdDirective` object.
"""
struct OMPParallelMasterTaskLoopSimdDirective <: AbstractOMPParallelMasterTaskLoopSimdDirective
    ptr::CXOMPParallelMasterTaskLoopSimdDirective
end

"""
    struct OMPParallelMasterTaskLoopDirective <: AbstractOMPParallelMasterTaskLoopDirective
Hold a pointer to a `clang::OMPParallelMasterTaskLoopDirective` object.
"""
struct OMPParallelMasterTaskLoopDirective <: AbstractOMPParallelMasterTaskLoopDirective
    ptr::CXOMPParallelMasterTaskLoopDirective
end

"""
    struct OMPParallelMaskedTaskLoopSimdDirective <: AbstractOMPParallelMaskedTaskLoopSimdDirective
Hold a pointer to a `clang::OMPParallelMaskedTaskLoopSimdDirective` object.
"""
struct OMPParallelMaskedTaskLoopSimdDirective <: AbstractOMPParallelMaskedTaskLoopSimdDirective
    ptr::CXOMPParallelMaskedTaskLoopSimdDirective
end

"""
    struct OMPParallelMaskedTaskLoopDirective <: AbstractOMPParallelMaskedTaskLoopDirective
Hold a pointer to a `clang::OMPParallelMaskedTaskLoopDirective` object.
"""
struct OMPParallelMaskedTaskLoopDirective <: AbstractOMPParallelMaskedTaskLoopDirective
    ptr::CXOMPParallelMaskedTaskLoopDirective
end

"""
    struct OMPParallelGenericLoopDirective <: AbstractOMPParallelGenericLoopDirective
Hold a pointer to a `clang::OMPParallelGenericLoopDirective` object.
"""
struct OMPParallelGenericLoopDirective <: AbstractOMPParallelGenericLoopDirective
    ptr::CXOMPParallelGenericLoopDirective
end

"""
    struct OMPParallelForSimdDirective <: AbstractOMPParallelForSimdDirective
Hold a pointer to a `clang::OMPParallelForSimdDirective` object.
"""
struct OMPParallelForSimdDirective <: AbstractOMPParallelForSimdDirective
    ptr::CXOMPParallelForSimdDirective
end

"""
    struct OMPParallelForDirective <: AbstractOMPParallelForDirective
Hold a pointer to a `clang::OMPParallelForDirective` object.
"""
struct OMPParallelForDirective <: AbstractOMPParallelForDirective
    ptr::CXOMPParallelForDirective
end

"""
    struct OMPMasterTaskLoopSimdDirective <: AbstractOMPMasterTaskLoopSimdDirective
Hold a pointer to a `clang::OMPMasterTaskLoopSimdDirective` object.
"""
struct OMPMasterTaskLoopSimdDirective <: AbstractOMPMasterTaskLoopSimdDirective
    ptr::CXOMPMasterTaskLoopSimdDirective
end

"""
    struct OMPMasterTaskLoopDirective <: AbstractOMPMasterTaskLoopDirective
Hold a pointer to a `clang::OMPMasterTaskLoopDirective` object.
"""
struct OMPMasterTaskLoopDirective <: AbstractOMPMasterTaskLoopDirective
    ptr::CXOMPMasterTaskLoopDirective
end

"""
    struct OMPMaskedTaskLoopSimdDirective <: AbstractOMPMaskedTaskLoopSimdDirective
Hold a pointer to a `clang::OMPMaskedTaskLoopSimdDirective` object.
"""
struct OMPMaskedTaskLoopSimdDirective <: AbstractOMPMaskedTaskLoopSimdDirective
    ptr::CXOMPMaskedTaskLoopSimdDirective
end

"""
    struct OMPMaskedTaskLoopDirective <: AbstractOMPMaskedTaskLoopDirective
Hold a pointer to a `clang::OMPMaskedTaskLoopDirective` object.
"""
struct OMPMaskedTaskLoopDirective <: AbstractOMPMaskedTaskLoopDirective
    ptr::CXOMPMaskedTaskLoopDirective
end

"""
    struct OMPGenericLoopDirective <: AbstractOMPGenericLoopDirective
Hold a pointer to a `clang::OMPGenericLoopDirective` object.
"""
struct OMPGenericLoopDirective <: AbstractOMPGenericLoopDirective
    ptr::CXOMPGenericLoopDirective
end

"""
    struct OMPForSimdDirective <: AbstractOMPForSimdDirective
Hold a pointer to a `clang::OMPForSimdDirective` object.
"""
struct OMPForSimdDirective <: AbstractOMPForSimdDirective
    ptr::CXOMPForSimdDirective
end

"""
    struct OMPForDirective <: AbstractOMPForDirective
Hold a pointer to a `clang::OMPForDirective` object.
"""
struct OMPForDirective <: AbstractOMPForDirective
    ptr::CXOMPForDirective
end

"""
    struct OMPDistributeSimdDirective <: AbstractOMPDistributeSimdDirective
Hold a pointer to a `clang::OMPDistributeSimdDirective` object.
"""
struct OMPDistributeSimdDirective <: AbstractOMPDistributeSimdDirective
    ptr::CXOMPDistributeSimdDirective
end

"""
    struct OMPDistributeParallelForSimdDirective <: AbstractOMPDistributeParallelForSimdDirective
Hold a pointer to a `clang::OMPDistributeParallelForSimdDirective` object.
"""
struct OMPDistributeParallelForSimdDirective <: AbstractOMPDistributeParallelForSimdDirective
    ptr::CXOMPDistributeParallelForSimdDirective
end

"""
    struct OMPDistributeParallelForDirective <: AbstractOMPDistributeParallelForDirective
Hold a pointer to a `clang::OMPDistributeParallelForDirective` object.
"""
struct OMPDistributeParallelForDirective <: AbstractOMPDistributeParallelForDirective
    ptr::CXOMPDistributeParallelForDirective
end

"""
    struct OMPDistributeDirective <: AbstractOMPDistributeDirective
Hold a pointer to a `clang::OMPDistributeDirective` object.
"""
struct OMPDistributeDirective <: AbstractOMPDistributeDirective
    ptr::CXOMPDistributeDirective
end

"""
    struct OMPInteropDirective <: AbstractOMPInteropDirective
Hold a pointer to a `clang::OMPInteropDirective` object.
"""
struct OMPInteropDirective <: AbstractOMPInteropDirective
    ptr::CXOMPInteropDirective
end

"""
    struct OMPFlushDirective <: AbstractOMPFlushDirective
Hold a pointer to a `clang::OMPFlushDirective` object.
"""
struct OMPFlushDirective <: AbstractOMPFlushDirective
    ptr::CXOMPFlushDirective
end

"""
    struct OMPErrorDirective <: AbstractOMPErrorDirective
Hold a pointer to a `clang::OMPErrorDirective` object.
"""
struct OMPErrorDirective <: AbstractOMPErrorDirective
    ptr::CXOMPErrorDirective
end

"""
    struct OMPDispatchDirective <: AbstractOMPDispatchDirective
Hold a pointer to a `clang::OMPDispatchDirective` object.
"""
struct OMPDispatchDirective <: AbstractOMPDispatchDirective
    ptr::CXOMPDispatchDirective
end

"""
    struct OMPDepobjDirective <: AbstractOMPDepobjDirective
Hold a pointer to a `clang::OMPDepobjDirective` object.
"""
struct OMPDepobjDirective <: AbstractOMPDepobjDirective
    ptr::CXOMPDepobjDirective
end

"""
    struct OMPCriticalDirective <: AbstractOMPCriticalDirective
Hold a pointer to a `clang::OMPCriticalDirective` object.
"""
struct OMPCriticalDirective <: AbstractOMPCriticalDirective
    ptr::CXOMPCriticalDirective
end

"""
    struct OMPCancellationPointDirective <: AbstractOMPCancellationPointDirective
Hold a pointer to a `clang::OMPCancellationPointDirective` object.
"""
struct OMPCancellationPointDirective <: AbstractOMPCancellationPointDirective
    ptr::CXOMPCancellationPointDirective
end

"""
    struct OMPCancelDirective <: AbstractOMPCancelDirective
Hold a pointer to a `clang::OMPCancelDirective` object.
"""
struct OMPCancelDirective <: AbstractOMPCancelDirective
    ptr::CXOMPCancelDirective
end

"""
    struct OMPBarrierDirective <: AbstractOMPBarrierDirective
Hold a pointer to a `clang::OMPBarrierDirective` object.
"""
struct OMPBarrierDirective <: AbstractOMPBarrierDirective
    ptr::CXOMPBarrierDirective
end

"""
    struct OMPAtomicDirective <: AbstractOMPAtomicDirective
Hold a pointer to a `clang::OMPAtomicDirective` object.
"""
struct OMPAtomicDirective <: AbstractOMPAtomicDirective
    ptr::CXOMPAtomicDirective
end

"""
    struct OMPCanonicalLoop <: AbstractOMPCanonicalLoop
Hold a pointer to a `clang::OMPCanonicalLoop` object.
"""
struct OMPCanonicalLoop <: AbstractOMPCanonicalLoop
    ptr::CXOMPCanonicalLoop
end

