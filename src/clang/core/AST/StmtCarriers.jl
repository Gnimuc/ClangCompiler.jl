# Generated from deps/ClangExtra/include/clang-ex/AST/StmtNodes.inc by gen/stmt_nodes.jl — do not edit.
# Fill-in carriers (ptr::CXStmt) for Stmt classes the hand-written files omit.
"""
    struct SYCLUniqueStableNameExpr <: AbstractSYCLUniqueStableNameExpr
Hold a pointer to a `clang::SYCLUniqueStableNameExpr` object.
"""
struct SYCLUniqueStableNameExpr <: AbstractSYCLUniqueStableNameExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::SYCLUniqueStableNameExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::SYCLUniqueStableNameExpr) = x

"""
    struct RequiresExpr <: AbstractRequiresExpr
Hold a pointer to a `clang::RequiresExpr` object.
"""
struct RequiresExpr <: AbstractRequiresExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::RequiresExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::RequiresExpr) = x

"""
    struct OffsetOfExpr <: AbstractOffsetOfExpr
Hold a pointer to a `clang::OffsetOfExpr` object.
"""
struct OffsetOfExpr <: AbstractOffsetOfExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OffsetOfExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OffsetOfExpr) = x

"""
    struct ObjCSubscriptRefExpr <: AbstractObjCSubscriptRefExpr
Hold a pointer to a `clang::ObjCSubscriptRefExpr` object.
"""
struct ObjCSubscriptRefExpr <: AbstractObjCSubscriptRefExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCSubscriptRefExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCSubscriptRefExpr) = x

"""
    struct ObjCStringLiteral <: AbstractObjCStringLiteral
Hold a pointer to a `clang::ObjCStringLiteral` object.
"""
struct ObjCStringLiteral <: AbstractObjCStringLiteral
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCStringLiteral) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCStringLiteral) = x

"""
    struct ObjCSelectorExpr <: AbstractObjCSelectorExpr
Hold a pointer to a `clang::ObjCSelectorExpr` object.
"""
struct ObjCSelectorExpr <: AbstractObjCSelectorExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCSelectorExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCSelectorExpr) = x

"""
    struct ObjCProtocolExpr <: AbstractObjCProtocolExpr
Hold a pointer to a `clang::ObjCProtocolExpr` object.
"""
struct ObjCProtocolExpr <: AbstractObjCProtocolExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCProtocolExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCProtocolExpr) = x

"""
    struct ObjCPropertyRefExpr <: AbstractObjCPropertyRefExpr
Hold a pointer to a `clang::ObjCPropertyRefExpr` object.
"""
struct ObjCPropertyRefExpr <: AbstractObjCPropertyRefExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCPropertyRefExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCPropertyRefExpr) = x

"""
    struct ObjCMessageExpr <: AbstractObjCMessageExpr
Hold a pointer to a `clang::ObjCMessageExpr` object.
"""
struct ObjCMessageExpr <: AbstractObjCMessageExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCMessageExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCMessageExpr) = x

"""
    struct ObjCIvarRefExpr <: AbstractObjCIvarRefExpr
Hold a pointer to a `clang::ObjCIvarRefExpr` object.
"""
struct ObjCIvarRefExpr <: AbstractObjCIvarRefExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCIvarRefExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCIvarRefExpr) = x

"""
    struct ObjCIsaExpr <: AbstractObjCIsaExpr
Hold a pointer to a `clang::ObjCIsaExpr` object.
"""
struct ObjCIsaExpr <: AbstractObjCIsaExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCIsaExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCIsaExpr) = x

"""
    struct ObjCIndirectCopyRestoreExpr <: AbstractObjCIndirectCopyRestoreExpr
Hold a pointer to a `clang::ObjCIndirectCopyRestoreExpr` object.
"""
struct ObjCIndirectCopyRestoreExpr <: AbstractObjCIndirectCopyRestoreExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCIndirectCopyRestoreExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCIndirectCopyRestoreExpr) = x

"""
    struct ObjCEncodeExpr <: AbstractObjCEncodeExpr
Hold a pointer to a `clang::ObjCEncodeExpr` object.
"""
struct ObjCEncodeExpr <: AbstractObjCEncodeExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCEncodeExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCEncodeExpr) = x

"""
    struct ObjCDictionaryLiteral <: AbstractObjCDictionaryLiteral
Hold a pointer to a `clang::ObjCDictionaryLiteral` object.
"""
struct ObjCDictionaryLiteral <: AbstractObjCDictionaryLiteral
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCDictionaryLiteral) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCDictionaryLiteral) = x

"""
    struct ObjCBoxedExpr <: AbstractObjCBoxedExpr
Hold a pointer to a `clang::ObjCBoxedExpr` object.
"""
struct ObjCBoxedExpr <: AbstractObjCBoxedExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCBoxedExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCBoxedExpr) = x

"""
    struct ObjCBoolLiteralExpr <: AbstractObjCBoolLiteralExpr
Hold a pointer to a `clang::ObjCBoolLiteralExpr` object.
"""
struct ObjCBoolLiteralExpr <: AbstractObjCBoolLiteralExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCBoolLiteralExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCBoolLiteralExpr) = x

"""
    struct ObjCAvailabilityCheckExpr <: AbstractObjCAvailabilityCheckExpr
Hold a pointer to a `clang::ObjCAvailabilityCheckExpr` object.
"""
struct ObjCAvailabilityCheckExpr <: AbstractObjCAvailabilityCheckExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAvailabilityCheckExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAvailabilityCheckExpr) = x

"""
    struct ObjCArrayLiteral <: AbstractObjCArrayLiteral
Hold a pointer to a `clang::ObjCArrayLiteral` object.
"""
struct ObjCArrayLiteral <: AbstractObjCArrayLiteral
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCArrayLiteral) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCArrayLiteral) = x

"""
    struct OMPIteratorExpr <: AbstractOMPIteratorExpr
Hold a pointer to a `clang::OMPIteratorExpr` object.
"""
struct OMPIteratorExpr <: AbstractOMPIteratorExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPIteratorExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPIteratorExpr) = x

"""
    struct OMPArrayShapingExpr <: AbstractOMPArrayShapingExpr
Hold a pointer to a `clang::OMPArrayShapingExpr` object.
"""
struct OMPArrayShapingExpr <: AbstractOMPArrayShapingExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPArrayShapingExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPArrayShapingExpr) = x

"""
    struct OMPArraySectionExpr <: AbstractOMPArraySectionExpr
Hold a pointer to a `clang::OMPArraySectionExpr` object.
"""
struct OMPArraySectionExpr <: AbstractOMPArraySectionExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPArraySectionExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPArraySectionExpr) = x

"""
    struct ExprWithCleanups <: AbstractExprWithCleanups
Hold a pointer to a `clang::ExprWithCleanups` object.
"""
struct ExprWithCleanups <: AbstractExprWithCleanups
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ExprWithCleanups) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ExprWithCleanups) = x

"""
    struct ConceptSpecializationExpr <: AbstractConceptSpecializationExpr
Hold a pointer to a `clang::ConceptSpecializationExpr` object.
"""
struct ConceptSpecializationExpr <: AbstractConceptSpecializationExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ConceptSpecializationExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ConceptSpecializationExpr) = x

"""
    struct ObjCBridgedCastExpr <: AbstractObjCBridgedCastExpr
Hold a pointer to a `clang::ObjCBridgedCastExpr` object.
"""
struct ObjCBridgedCastExpr <: AbstractObjCBridgedCastExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCBridgedCastExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCBridgedCastExpr) = x

"""
    struct CStyleCastExpr <: AbstractCStyleCastExpr
Hold a pointer to a `clang::CStyleCastExpr` object.
"""
struct CStyleCastExpr <: AbstractCStyleCastExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::CStyleCastExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::CStyleCastExpr) = x

"""
    struct CXXParenListInitExpr <: AbstractCXXParenListInitExpr
Hold a pointer to a `clang::CXXParenListInitExpr` object.
"""
struct CXXParenListInitExpr <: AbstractCXXParenListInitExpr
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::CXXParenListInitExpr) = x.ptr
Base.cconvert(::Type{CXStmt}, x::CXXParenListInitExpr) = x

"""
    struct ObjCForCollectionStmt <: AbstractObjCForCollectionStmt
Hold a pointer to a `clang::ObjCForCollectionStmt` object.
"""
struct ObjCForCollectionStmt <: AbstractObjCForCollectionStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCForCollectionStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCForCollectionStmt) = x

"""
    struct ObjCAutoreleasePoolStmt <: AbstractObjCAutoreleasePoolStmt
Hold a pointer to a `clang::ObjCAutoreleasePoolStmt` object.
"""
struct ObjCAutoreleasePoolStmt <: AbstractObjCAutoreleasePoolStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAutoreleasePoolStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAutoreleasePoolStmt) = x

"""
    struct ObjCAtTryStmt <: AbstractObjCAtTryStmt
Hold a pointer to a `clang::ObjCAtTryStmt` object.
"""
struct ObjCAtTryStmt <: AbstractObjCAtTryStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAtTryStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAtTryStmt) = x

"""
    struct ObjCAtThrowStmt <: AbstractObjCAtThrowStmt
Hold a pointer to a `clang::ObjCAtThrowStmt` object.
"""
struct ObjCAtThrowStmt <: AbstractObjCAtThrowStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAtThrowStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAtThrowStmt) = x

"""
    struct ObjCAtSynchronizedStmt <: AbstractObjCAtSynchronizedStmt
Hold a pointer to a `clang::ObjCAtSynchronizedStmt` object.
"""
struct ObjCAtSynchronizedStmt <: AbstractObjCAtSynchronizedStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAtSynchronizedStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAtSynchronizedStmt) = x

"""
    struct ObjCAtFinallyStmt <: AbstractObjCAtFinallyStmt
Hold a pointer to a `clang::ObjCAtFinallyStmt` object.
"""
struct ObjCAtFinallyStmt <: AbstractObjCAtFinallyStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAtFinallyStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAtFinallyStmt) = x

"""
    struct ObjCAtCatchStmt <: AbstractObjCAtCatchStmt
Hold a pointer to a `clang::ObjCAtCatchStmt` object.
"""
struct ObjCAtCatchStmt <: AbstractObjCAtCatchStmt
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::ObjCAtCatchStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::ObjCAtCatchStmt) = x

"""
    struct OMPExecutableDirective <: AbstractOMPExecutableDirective
Hold a pointer to a `clang::OMPExecutableDirective` object.
"""
struct OMPExecutableDirective <: AbstractOMPExecutableDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPExecutableDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPExecutableDirective) = x

"""
    struct OMPTeamsDirective <: AbstractOMPTeamsDirective
Hold a pointer to a `clang::OMPTeamsDirective` object.
"""
struct OMPTeamsDirective <: AbstractOMPTeamsDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTeamsDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTeamsDirective) = x

"""
    struct OMPTaskyieldDirective <: AbstractOMPTaskyieldDirective
Hold a pointer to a `clang::OMPTaskyieldDirective` object.
"""
struct OMPTaskyieldDirective <: AbstractOMPTaskyieldDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTaskyieldDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTaskyieldDirective) = x

"""
    struct OMPTaskwaitDirective <: AbstractOMPTaskwaitDirective
Hold a pointer to a `clang::OMPTaskwaitDirective` object.
"""
struct OMPTaskwaitDirective <: AbstractOMPTaskwaitDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTaskwaitDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTaskwaitDirective) = x

"""
    struct OMPTaskgroupDirective <: AbstractOMPTaskgroupDirective
Hold a pointer to a `clang::OMPTaskgroupDirective` object.
"""
struct OMPTaskgroupDirective <: AbstractOMPTaskgroupDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTaskgroupDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTaskgroupDirective) = x

"""
    struct OMPTaskDirective <: AbstractOMPTaskDirective
Hold a pointer to a `clang::OMPTaskDirective` object.
"""
struct OMPTaskDirective <: AbstractOMPTaskDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTaskDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTaskDirective) = x

"""
    struct OMPTargetUpdateDirective <: AbstractOMPTargetUpdateDirective
Hold a pointer to a `clang::OMPTargetUpdateDirective` object.
"""
struct OMPTargetUpdateDirective <: AbstractOMPTargetUpdateDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetUpdateDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetUpdateDirective) = x

"""
    struct OMPTargetTeamsDirective <: AbstractOMPTargetTeamsDirective
Hold a pointer to a `clang::OMPTargetTeamsDirective` object.
"""
struct OMPTargetTeamsDirective <: AbstractOMPTargetTeamsDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetTeamsDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetTeamsDirective) = x

"""
    struct OMPTargetParallelForDirective <: AbstractOMPTargetParallelForDirective
Hold a pointer to a `clang::OMPTargetParallelForDirective` object.
"""
struct OMPTargetParallelForDirective <: AbstractOMPTargetParallelForDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetParallelForDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetParallelForDirective) = x

"""
    struct OMPTargetParallelDirective <: AbstractOMPTargetParallelDirective
Hold a pointer to a `clang::OMPTargetParallelDirective` object.
"""
struct OMPTargetParallelDirective <: AbstractOMPTargetParallelDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetParallelDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetParallelDirective) = x

"""
    struct OMPTargetExitDataDirective <: AbstractOMPTargetExitDataDirective
Hold a pointer to a `clang::OMPTargetExitDataDirective` object.
"""
struct OMPTargetExitDataDirective <: AbstractOMPTargetExitDataDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetExitDataDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetExitDataDirective) = x

"""
    struct OMPTargetEnterDataDirective <: AbstractOMPTargetEnterDataDirective
Hold a pointer to a `clang::OMPTargetEnterDataDirective` object.
"""
struct OMPTargetEnterDataDirective <: AbstractOMPTargetEnterDataDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetEnterDataDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetEnterDataDirective) = x

"""
    struct OMPTargetDirective <: AbstractOMPTargetDirective
Hold a pointer to a `clang::OMPTargetDirective` object.
"""
struct OMPTargetDirective <: AbstractOMPTargetDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetDirective) = x

"""
    struct OMPTargetDataDirective <: AbstractOMPTargetDataDirective
Hold a pointer to a `clang::OMPTargetDataDirective` object.
"""
struct OMPTargetDataDirective <: AbstractOMPTargetDataDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetDataDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetDataDirective) = x

"""
    struct OMPSingleDirective <: AbstractOMPSingleDirective
Hold a pointer to a `clang::OMPSingleDirective` object.
"""
struct OMPSingleDirective <: AbstractOMPSingleDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPSingleDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPSingleDirective) = x

"""
    struct OMPSectionsDirective <: AbstractOMPSectionsDirective
Hold a pointer to a `clang::OMPSectionsDirective` object.
"""
struct OMPSectionsDirective <: AbstractOMPSectionsDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPSectionsDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPSectionsDirective) = x

"""
    struct OMPSectionDirective <: AbstractOMPSectionDirective
Hold a pointer to a `clang::OMPSectionDirective` object.
"""
struct OMPSectionDirective <: AbstractOMPSectionDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPSectionDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPSectionDirective) = x

"""
    struct OMPScopeDirective <: AbstractOMPScopeDirective
Hold a pointer to a `clang::OMPScopeDirective` object.
"""
struct OMPScopeDirective <: AbstractOMPScopeDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPScopeDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPScopeDirective) = x

"""
    struct OMPScanDirective <: AbstractOMPScanDirective
Hold a pointer to a `clang::OMPScanDirective` object.
"""
struct OMPScanDirective <: AbstractOMPScanDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPScanDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPScanDirective) = x

"""
    struct OMPParallelSectionsDirective <: AbstractOMPParallelSectionsDirective
Hold a pointer to a `clang::OMPParallelSectionsDirective` object.
"""
struct OMPParallelSectionsDirective <: AbstractOMPParallelSectionsDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelSectionsDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelSectionsDirective) = x

"""
    struct OMPParallelMasterDirective <: AbstractOMPParallelMasterDirective
Hold a pointer to a `clang::OMPParallelMasterDirective` object.
"""
struct OMPParallelMasterDirective <: AbstractOMPParallelMasterDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelMasterDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelMasterDirective) = x

"""
    struct OMPParallelMaskedDirective <: AbstractOMPParallelMaskedDirective
Hold a pointer to a `clang::OMPParallelMaskedDirective` object.
"""
struct OMPParallelMaskedDirective <: AbstractOMPParallelMaskedDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelMaskedDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelMaskedDirective) = x

"""
    struct OMPParallelDirective <: AbstractOMPParallelDirective
Hold a pointer to a `clang::OMPParallelDirective` object.
"""
struct OMPParallelDirective <: AbstractOMPParallelDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelDirective) = x

"""
    struct OMPOrderedDirective <: AbstractOMPOrderedDirective
Hold a pointer to a `clang::OMPOrderedDirective` object.
"""
struct OMPOrderedDirective <: AbstractOMPOrderedDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPOrderedDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPOrderedDirective) = x

"""
    struct OMPMetaDirective <: AbstractOMPMetaDirective
Hold a pointer to a `clang::OMPMetaDirective` object.
"""
struct OMPMetaDirective <: AbstractOMPMetaDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMetaDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMetaDirective) = x

"""
    struct OMPMasterDirective <: AbstractOMPMasterDirective
Hold a pointer to a `clang::OMPMasterDirective` object.
"""
struct OMPMasterDirective <: AbstractOMPMasterDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMasterDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMasterDirective) = x

"""
    struct OMPMaskedDirective <: AbstractOMPMaskedDirective
Hold a pointer to a `clang::OMPMaskedDirective` object.
"""
struct OMPMaskedDirective <: AbstractOMPMaskedDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMaskedDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMaskedDirective) = x

"""
    struct OMPLoopBasedDirective <: AbstractOMPLoopBasedDirective
Hold a pointer to a `clang::OMPLoopBasedDirective` object.
"""
struct OMPLoopBasedDirective <: AbstractOMPLoopBasedDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPLoopBasedDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPLoopBasedDirective) = x

"""
    struct OMPLoopTransformationDirective <: AbstractOMPLoopTransformationDirective
Hold a pointer to a `clang::OMPLoopTransformationDirective` object.
"""
struct OMPLoopTransformationDirective <: AbstractOMPLoopTransformationDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPLoopTransformationDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPLoopTransformationDirective) = x

"""
    struct OMPUnrollDirective <: AbstractOMPUnrollDirective
Hold a pointer to a `clang::OMPUnrollDirective` object.
"""
struct OMPUnrollDirective <: AbstractOMPUnrollDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPUnrollDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPUnrollDirective) = x

"""
    struct OMPTileDirective <: AbstractOMPTileDirective
Hold a pointer to a `clang::OMPTileDirective` object.
"""
struct OMPTileDirective <: AbstractOMPTileDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTileDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTileDirective) = x

"""
    struct OMPLoopDirective <: AbstractOMPLoopDirective
Hold a pointer to a `clang::OMPLoopDirective` object.
"""
struct OMPLoopDirective <: AbstractOMPLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPLoopDirective) = x

"""
    struct OMPTeamsGenericLoopDirective <: AbstractOMPTeamsGenericLoopDirective
Hold a pointer to a `clang::OMPTeamsGenericLoopDirective` object.
"""
struct OMPTeamsGenericLoopDirective <: AbstractOMPTeamsGenericLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTeamsGenericLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTeamsGenericLoopDirective) = x

"""
    struct OMPTeamsDistributeSimdDirective <: AbstractOMPTeamsDistributeSimdDirective
Hold a pointer to a `clang::OMPTeamsDistributeSimdDirective` object.
"""
struct OMPTeamsDistributeSimdDirective <: AbstractOMPTeamsDistributeSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTeamsDistributeSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTeamsDistributeSimdDirective) = x

"""
    struct OMPTeamsDistributeParallelForSimdDirective <: AbstractOMPTeamsDistributeParallelForSimdDirective
Hold a pointer to a `clang::OMPTeamsDistributeParallelForSimdDirective` object.
"""
struct OMPTeamsDistributeParallelForSimdDirective <: AbstractOMPTeamsDistributeParallelForSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTeamsDistributeParallelForSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTeamsDistributeParallelForSimdDirective) = x

"""
    struct OMPTeamsDistributeParallelForDirective <: AbstractOMPTeamsDistributeParallelForDirective
Hold a pointer to a `clang::OMPTeamsDistributeParallelForDirective` object.
"""
struct OMPTeamsDistributeParallelForDirective <: AbstractOMPTeamsDistributeParallelForDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTeamsDistributeParallelForDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTeamsDistributeParallelForDirective) = x

"""
    struct OMPTeamsDistributeDirective <: AbstractOMPTeamsDistributeDirective
Hold a pointer to a `clang::OMPTeamsDistributeDirective` object.
"""
struct OMPTeamsDistributeDirective <: AbstractOMPTeamsDistributeDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTeamsDistributeDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTeamsDistributeDirective) = x

"""
    struct OMPTaskLoopSimdDirective <: AbstractOMPTaskLoopSimdDirective
Hold a pointer to a `clang::OMPTaskLoopSimdDirective` object.
"""
struct OMPTaskLoopSimdDirective <: AbstractOMPTaskLoopSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTaskLoopSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTaskLoopSimdDirective) = x

"""
    struct OMPTaskLoopDirective <: AbstractOMPTaskLoopDirective
Hold a pointer to a `clang::OMPTaskLoopDirective` object.
"""
struct OMPTaskLoopDirective <: AbstractOMPTaskLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTaskLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTaskLoopDirective) = x

"""
    struct OMPTargetTeamsGenericLoopDirective <: AbstractOMPTargetTeamsGenericLoopDirective
Hold a pointer to a `clang::OMPTargetTeamsGenericLoopDirective` object.
"""
struct OMPTargetTeamsGenericLoopDirective <: AbstractOMPTargetTeamsGenericLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetTeamsGenericLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetTeamsGenericLoopDirective) = x

"""
    struct OMPTargetTeamsDistributeSimdDirective <: AbstractOMPTargetTeamsDistributeSimdDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeSimdDirective` object.
"""
struct OMPTargetTeamsDistributeSimdDirective <: AbstractOMPTargetTeamsDistributeSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetTeamsDistributeSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetTeamsDistributeSimdDirective) = x

"""
    struct OMPTargetTeamsDistributeParallelForSimdDirective <: AbstractOMPTargetTeamsDistributeParallelForSimdDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeParallelForSimdDirective` object.
"""
struct OMPTargetTeamsDistributeParallelForSimdDirective <: AbstractOMPTargetTeamsDistributeParallelForSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetTeamsDistributeParallelForSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetTeamsDistributeParallelForSimdDirective) = x

"""
    struct OMPTargetTeamsDistributeParallelForDirective <: AbstractOMPTargetTeamsDistributeParallelForDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeParallelForDirective` object.
"""
struct OMPTargetTeamsDistributeParallelForDirective <: AbstractOMPTargetTeamsDistributeParallelForDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetTeamsDistributeParallelForDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetTeamsDistributeParallelForDirective) = x

"""
    struct OMPTargetTeamsDistributeDirective <: AbstractOMPTargetTeamsDistributeDirective
Hold a pointer to a `clang::OMPTargetTeamsDistributeDirective` object.
"""
struct OMPTargetTeamsDistributeDirective <: AbstractOMPTargetTeamsDistributeDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetTeamsDistributeDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetTeamsDistributeDirective) = x

"""
    struct OMPTargetSimdDirective <: AbstractOMPTargetSimdDirective
Hold a pointer to a `clang::OMPTargetSimdDirective` object.
"""
struct OMPTargetSimdDirective <: AbstractOMPTargetSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetSimdDirective) = x

"""
    struct OMPTargetParallelGenericLoopDirective <: AbstractOMPTargetParallelGenericLoopDirective
Hold a pointer to a `clang::OMPTargetParallelGenericLoopDirective` object.
"""
struct OMPTargetParallelGenericLoopDirective <: AbstractOMPTargetParallelGenericLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetParallelGenericLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetParallelGenericLoopDirective) = x

"""
    struct OMPTargetParallelForSimdDirective <: AbstractOMPTargetParallelForSimdDirective
Hold a pointer to a `clang::OMPTargetParallelForSimdDirective` object.
"""
struct OMPTargetParallelForSimdDirective <: AbstractOMPTargetParallelForSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPTargetParallelForSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPTargetParallelForSimdDirective) = x

"""
    struct OMPSimdDirective <: AbstractOMPSimdDirective
Hold a pointer to a `clang::OMPSimdDirective` object.
"""
struct OMPSimdDirective <: AbstractOMPSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPSimdDirective) = x

"""
    struct OMPParallelMasterTaskLoopSimdDirective <: AbstractOMPParallelMasterTaskLoopSimdDirective
Hold a pointer to a `clang::OMPParallelMasterTaskLoopSimdDirective` object.
"""
struct OMPParallelMasterTaskLoopSimdDirective <: AbstractOMPParallelMasterTaskLoopSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelMasterTaskLoopSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelMasterTaskLoopSimdDirective) = x

"""
    struct OMPParallelMasterTaskLoopDirective <: AbstractOMPParallelMasterTaskLoopDirective
Hold a pointer to a `clang::OMPParallelMasterTaskLoopDirective` object.
"""
struct OMPParallelMasterTaskLoopDirective <: AbstractOMPParallelMasterTaskLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelMasterTaskLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelMasterTaskLoopDirective) = x

"""
    struct OMPParallelMaskedTaskLoopSimdDirective <: AbstractOMPParallelMaskedTaskLoopSimdDirective
Hold a pointer to a `clang::OMPParallelMaskedTaskLoopSimdDirective` object.
"""
struct OMPParallelMaskedTaskLoopSimdDirective <: AbstractOMPParallelMaskedTaskLoopSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelMaskedTaskLoopSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelMaskedTaskLoopSimdDirective) = x

"""
    struct OMPParallelMaskedTaskLoopDirective <: AbstractOMPParallelMaskedTaskLoopDirective
Hold a pointer to a `clang::OMPParallelMaskedTaskLoopDirective` object.
"""
struct OMPParallelMaskedTaskLoopDirective <: AbstractOMPParallelMaskedTaskLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelMaskedTaskLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelMaskedTaskLoopDirective) = x

"""
    struct OMPParallelGenericLoopDirective <: AbstractOMPParallelGenericLoopDirective
Hold a pointer to a `clang::OMPParallelGenericLoopDirective` object.
"""
struct OMPParallelGenericLoopDirective <: AbstractOMPParallelGenericLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelGenericLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelGenericLoopDirective) = x

"""
    struct OMPParallelForSimdDirective <: AbstractOMPParallelForSimdDirective
Hold a pointer to a `clang::OMPParallelForSimdDirective` object.
"""
struct OMPParallelForSimdDirective <: AbstractOMPParallelForSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelForSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelForSimdDirective) = x

"""
    struct OMPParallelForDirective <: AbstractOMPParallelForDirective
Hold a pointer to a `clang::OMPParallelForDirective` object.
"""
struct OMPParallelForDirective <: AbstractOMPParallelForDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPParallelForDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPParallelForDirective) = x

"""
    struct OMPMasterTaskLoopSimdDirective <: AbstractOMPMasterTaskLoopSimdDirective
Hold a pointer to a `clang::OMPMasterTaskLoopSimdDirective` object.
"""
struct OMPMasterTaskLoopSimdDirective <: AbstractOMPMasterTaskLoopSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMasterTaskLoopSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMasterTaskLoopSimdDirective) = x

"""
    struct OMPMasterTaskLoopDirective <: AbstractOMPMasterTaskLoopDirective
Hold a pointer to a `clang::OMPMasterTaskLoopDirective` object.
"""
struct OMPMasterTaskLoopDirective <: AbstractOMPMasterTaskLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMasterTaskLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMasterTaskLoopDirective) = x

"""
    struct OMPMaskedTaskLoopSimdDirective <: AbstractOMPMaskedTaskLoopSimdDirective
Hold a pointer to a `clang::OMPMaskedTaskLoopSimdDirective` object.
"""
struct OMPMaskedTaskLoopSimdDirective <: AbstractOMPMaskedTaskLoopSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMaskedTaskLoopSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMaskedTaskLoopSimdDirective) = x

"""
    struct OMPMaskedTaskLoopDirective <: AbstractOMPMaskedTaskLoopDirective
Hold a pointer to a `clang::OMPMaskedTaskLoopDirective` object.
"""
struct OMPMaskedTaskLoopDirective <: AbstractOMPMaskedTaskLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPMaskedTaskLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPMaskedTaskLoopDirective) = x

"""
    struct OMPGenericLoopDirective <: AbstractOMPGenericLoopDirective
Hold a pointer to a `clang::OMPGenericLoopDirective` object.
"""
struct OMPGenericLoopDirective <: AbstractOMPGenericLoopDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPGenericLoopDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPGenericLoopDirective) = x

"""
    struct OMPForSimdDirective <: AbstractOMPForSimdDirective
Hold a pointer to a `clang::OMPForSimdDirective` object.
"""
struct OMPForSimdDirective <: AbstractOMPForSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPForSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPForSimdDirective) = x

"""
    struct OMPForDirective <: AbstractOMPForDirective
Hold a pointer to a `clang::OMPForDirective` object.
"""
struct OMPForDirective <: AbstractOMPForDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPForDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPForDirective) = x

"""
    struct OMPDistributeSimdDirective <: AbstractOMPDistributeSimdDirective
Hold a pointer to a `clang::OMPDistributeSimdDirective` object.
"""
struct OMPDistributeSimdDirective <: AbstractOMPDistributeSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPDistributeSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPDistributeSimdDirective) = x

"""
    struct OMPDistributeParallelForSimdDirective <: AbstractOMPDistributeParallelForSimdDirective
Hold a pointer to a `clang::OMPDistributeParallelForSimdDirective` object.
"""
struct OMPDistributeParallelForSimdDirective <: AbstractOMPDistributeParallelForSimdDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPDistributeParallelForSimdDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPDistributeParallelForSimdDirective) = x

"""
    struct OMPDistributeParallelForDirective <: AbstractOMPDistributeParallelForDirective
Hold a pointer to a `clang::OMPDistributeParallelForDirective` object.
"""
struct OMPDistributeParallelForDirective <: AbstractOMPDistributeParallelForDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPDistributeParallelForDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPDistributeParallelForDirective) = x

"""
    struct OMPDistributeDirective <: AbstractOMPDistributeDirective
Hold a pointer to a `clang::OMPDistributeDirective` object.
"""
struct OMPDistributeDirective <: AbstractOMPDistributeDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPDistributeDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPDistributeDirective) = x

"""
    struct OMPInteropDirective <: AbstractOMPInteropDirective
Hold a pointer to a `clang::OMPInteropDirective` object.
"""
struct OMPInteropDirective <: AbstractOMPInteropDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPInteropDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPInteropDirective) = x

"""
    struct OMPFlushDirective <: AbstractOMPFlushDirective
Hold a pointer to a `clang::OMPFlushDirective` object.
"""
struct OMPFlushDirective <: AbstractOMPFlushDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPFlushDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPFlushDirective) = x

"""
    struct OMPErrorDirective <: AbstractOMPErrorDirective
Hold a pointer to a `clang::OMPErrorDirective` object.
"""
struct OMPErrorDirective <: AbstractOMPErrorDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPErrorDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPErrorDirective) = x

"""
    struct OMPDispatchDirective <: AbstractOMPDispatchDirective
Hold a pointer to a `clang::OMPDispatchDirective` object.
"""
struct OMPDispatchDirective <: AbstractOMPDispatchDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPDispatchDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPDispatchDirective) = x

"""
    struct OMPDepobjDirective <: AbstractOMPDepobjDirective
Hold a pointer to a `clang::OMPDepobjDirective` object.
"""
struct OMPDepobjDirective <: AbstractOMPDepobjDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPDepobjDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPDepobjDirective) = x

"""
    struct OMPCriticalDirective <: AbstractOMPCriticalDirective
Hold a pointer to a `clang::OMPCriticalDirective` object.
"""
struct OMPCriticalDirective <: AbstractOMPCriticalDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPCriticalDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPCriticalDirective) = x

"""
    struct OMPCancellationPointDirective <: AbstractOMPCancellationPointDirective
Hold a pointer to a `clang::OMPCancellationPointDirective` object.
"""
struct OMPCancellationPointDirective <: AbstractOMPCancellationPointDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPCancellationPointDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPCancellationPointDirective) = x

"""
    struct OMPCancelDirective <: AbstractOMPCancelDirective
Hold a pointer to a `clang::OMPCancelDirective` object.
"""
struct OMPCancelDirective <: AbstractOMPCancelDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPCancelDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPCancelDirective) = x

"""
    struct OMPBarrierDirective <: AbstractOMPBarrierDirective
Hold a pointer to a `clang::OMPBarrierDirective` object.
"""
struct OMPBarrierDirective <: AbstractOMPBarrierDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPBarrierDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPBarrierDirective) = x

"""
    struct OMPAtomicDirective <: AbstractOMPAtomicDirective
Hold a pointer to a `clang::OMPAtomicDirective` object.
"""
struct OMPAtomicDirective <: AbstractOMPAtomicDirective
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPAtomicDirective) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPAtomicDirective) = x

"""
    struct OMPCanonicalLoop <: AbstractOMPCanonicalLoop
Hold a pointer to a `clang::OMPCanonicalLoop` object.
"""
struct OMPCanonicalLoop <: AbstractOMPCanonicalLoop
    ptr::CXStmt
end

Base.unsafe_convert(::Type{CXStmt}, x::OMPCanonicalLoop) = x.ptr
Base.cconvert(::Type{CXStmt}, x::OMPCanonicalLoop) = x

