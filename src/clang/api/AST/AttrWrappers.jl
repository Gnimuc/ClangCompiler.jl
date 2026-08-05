# Generated from deps/ClangExtra/include/clang-ex/AST/AttrList.inc by gen/attr_nodes.jl — do not edit.
# Per-attribute checked cast: the `<Name>Attr` constructor is C++'s `cast<T>` and
# the `is<Name>Attr` predicate beside it is `isa<T>`. Clang's own `classof` decides,
# so an attribute can never become a carrier that names another class.
function isAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAddressSpaceAttr(x)
end

function AddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(AddressSpaceAttr, x)
    return AddressSpaceAttr(p)
end

function isAnnotateTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnnotateTypeAttr(x)
end

function AnnotateTypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAnnotateTypeAttr(x)
    p == C_NULL && _cast_failed(AnnotateTypeAttr, x)
    return AnnotateTypeAttr(p)
end

function isArmInAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmInAttr(x)
end

function ArmInAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmInAttr(x)
    p == C_NULL && _cast_failed(ArmInAttr, x)
    return ArmInAttr(p)
end

function isArmInOutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmInOutAttr(x)
end

function ArmInOutAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmInOutAttr(x)
    p == C_NULL && _cast_failed(ArmInOutAttr, x)
    return ArmInOutAttr(p)
end

function isArmMveStrictPolymorphismAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmMveStrictPolymorphismAttr(x)
end

function ArmMveStrictPolymorphismAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmMveStrictPolymorphismAttr(x)
    p == C_NULL && _cast_failed(ArmMveStrictPolymorphismAttr, x)
    return ArmMveStrictPolymorphismAttr(p)
end

function isArmOutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmOutAttr(x)
end

function ArmOutAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmOutAttr(x)
    p == C_NULL && _cast_failed(ArmOutAttr, x)
    return ArmOutAttr(p)
end

function isArmPreservesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmPreservesAttr(x)
end

function ArmPreservesAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmPreservesAttr(x)
    p == C_NULL && _cast_failed(ArmPreservesAttr, x)
    return ArmPreservesAttr(p)
end

function isArmStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmStreamingAttr(x)
end

function ArmStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmStreamingAttr(x)
    p == C_NULL && _cast_failed(ArmStreamingAttr, x)
    return ArmStreamingAttr(p)
end

function isArmStreamingCompatibleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmStreamingCompatibleAttr(x)
end

function ArmStreamingCompatibleAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmStreamingCompatibleAttr(x)
    p == C_NULL && _cast_failed(ArmStreamingCompatibleAttr, x)
    return ArmStreamingCompatibleAttr(p)
end

function isBTFTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBTFTypeTagAttr(x)
end

function BTFTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBTFTypeTagAttr(x)
    p == C_NULL && _cast_failed(BTFTypeTagAttr, x)
    return BTFTypeTagAttr(p)
end

function isCmseNSCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCmseNSCallAttr(x)
end

function CmseNSCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCmseNSCallAttr(x)
    p == C_NULL && _cast_failed(CmseNSCallAttr, x)
    return CmseNSCallAttr(p)
end

function isHLSLGroupSharedAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLGroupSharedAddressSpaceAttr(x)
end

function HLSLGroupSharedAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLGroupSharedAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(HLSLGroupSharedAddressSpaceAttr, x)
    return HLSLGroupSharedAddressSpaceAttr(p)
end

function isHLSLParamModifierAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLParamModifierAttr(x)
end

function HLSLParamModifierAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLParamModifierAttr(x)
    p == C_NULL && _cast_failed(HLSLParamModifierAttr, x)
    return HLSLParamModifierAttr(p)
end

function isNoDerefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDerefAttr(x)
end

function NoDerefAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoDerefAttr(x)
    p == C_NULL && _cast_failed(NoDerefAttr, x)
    return NoDerefAttr(p)
end

function isObjCGCAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCGCAttr(x)
end

function ObjCGCAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCGCAttr(x)
    p == C_NULL && _cast_failed(ObjCGCAttr, x)
    return ObjCGCAttr(p)
end

function isObjCInertUnsafeUnretainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCInertUnsafeUnretainedAttr(x)
end

function ObjCInertUnsafeUnretainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCInertUnsafeUnretainedAttr(x)
    p == C_NULL && _cast_failed(ObjCInertUnsafeUnretainedAttr, x)
    return ObjCInertUnsafeUnretainedAttr(p)
end

function isObjCKindOfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCKindOfAttr(x)
end

function ObjCKindOfAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCKindOfAttr(x)
    p == C_NULL && _cast_failed(ObjCKindOfAttr, x)
    return ObjCKindOfAttr(p)
end

function isOpenCLConstantAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLConstantAddressSpaceAttr(x)
end

function OpenCLConstantAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLConstantAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLConstantAddressSpaceAttr, x)
    return OpenCLConstantAddressSpaceAttr(p)
end

function isOpenCLGenericAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGenericAddressSpaceAttr(x)
end

function OpenCLGenericAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLGenericAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLGenericAddressSpaceAttr, x)
    return OpenCLGenericAddressSpaceAttr(p)
end

function isOpenCLGlobalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGlobalAddressSpaceAttr(x)
end

function OpenCLGlobalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLGlobalAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLGlobalAddressSpaceAttr, x)
    return OpenCLGlobalAddressSpaceAttr(p)
end

function isOpenCLGlobalDeviceAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGlobalDeviceAddressSpaceAttr(x)
end

function OpenCLGlobalDeviceAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLGlobalDeviceAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLGlobalDeviceAddressSpaceAttr, x)
    return OpenCLGlobalDeviceAddressSpaceAttr(p)
end

function isOpenCLGlobalHostAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGlobalHostAddressSpaceAttr(x)
end

function OpenCLGlobalHostAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLGlobalHostAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLGlobalHostAddressSpaceAttr, x)
    return OpenCLGlobalHostAddressSpaceAttr(p)
end

function isOpenCLLocalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLLocalAddressSpaceAttr(x)
end

function OpenCLLocalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLLocalAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLLocalAddressSpaceAttr, x)
    return OpenCLLocalAddressSpaceAttr(p)
end

function isOpenCLPrivateAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLPrivateAddressSpaceAttr(x)
end

function OpenCLPrivateAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLPrivateAddressSpaceAttr(x)
    p == C_NULL && _cast_failed(OpenCLPrivateAddressSpaceAttr, x)
    return OpenCLPrivateAddressSpaceAttr(p)
end

function isPtr32Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtr32Attr(x)
end

function Ptr32Attr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPtr32Attr(x)
    p == C_NULL && _cast_failed(Ptr32Attr, x)
    return Ptr32Attr(p)
end

function isPtr64Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtr64Attr(x)
end

function Ptr64Attr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPtr64Attr(x)
    p == C_NULL && _cast_failed(Ptr64Attr, x)
    return Ptr64Attr(p)
end

function isSPtrAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSPtrAttr(x)
end

function SPtrAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSPtrAttr(x)
    p == C_NULL && _cast_failed(SPtrAttr, x)
    return SPtrAttr(p)
end

function isTypeNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNonNullAttr(x)
end

function TypeNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTypeNonNullAttr(x)
    p == C_NULL && _cast_failed(TypeNonNullAttr, x)
    return TypeNonNullAttr(p)
end

function isTypeNullUnspecifiedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNullUnspecifiedAttr(x)
end

function TypeNullUnspecifiedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTypeNullUnspecifiedAttr(x)
    p == C_NULL && _cast_failed(TypeNullUnspecifiedAttr, x)
    return TypeNullUnspecifiedAttr(p)
end

function isTypeNullableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNullableAttr(x)
end

function TypeNullableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTypeNullableAttr(x)
    p == C_NULL && _cast_failed(TypeNullableAttr, x)
    return TypeNullableAttr(p)
end

function isTypeNullableResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNullableResultAttr(x)
end

function TypeNullableResultAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTypeNullableResultAttr(x)
    p == C_NULL && _cast_failed(TypeNullableResultAttr, x)
    return TypeNullableResultAttr(p)
end

function isUPtrAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUPtrAttr(x)
end

function UPtrAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUPtrAttr(x)
    p == C_NULL && _cast_failed(UPtrAttr, x)
    return UPtrAttr(p)
end

function isWebAssemblyFuncrefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyFuncrefAttr(x)
end

function WebAssemblyFuncrefAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWebAssemblyFuncrefAttr(x)
    p == C_NULL && _cast_failed(WebAssemblyFuncrefAttr, x)
    return WebAssemblyFuncrefAttr(p)
end

function isCodeAlignAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCodeAlignAttr(x)
end

function CodeAlignAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCodeAlignAttr(x)
    p == C_NULL && _cast_failed(CodeAlignAttr, x)
    return CodeAlignAttr(p)
end

function isFallThroughAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFallThroughAttr(x)
end

function FallThroughAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFallThroughAttr(x)
    p == C_NULL && _cast_failed(FallThroughAttr, x)
    return FallThroughAttr(p)
end

function isLikelyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLikelyAttr(x)
end

function LikelyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLikelyAttr(x)
    p == C_NULL && _cast_failed(LikelyAttr, x)
    return LikelyAttr(p)
end

function isMustTailAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMustTailAttr(x)
end

function MustTailAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMustTailAttr(x)
    p == C_NULL && _cast_failed(MustTailAttr, x)
    return MustTailAttr(p)
end

function isOpenCLUnrollHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLUnrollHintAttr(x)
end

function OpenCLUnrollHintAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLUnrollHintAttr(x)
    p == C_NULL && _cast_failed(OpenCLUnrollHintAttr, x)
    return OpenCLUnrollHintAttr(p)
end

function isUnlikelyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnlikelyAttr(x)
end

function UnlikelyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUnlikelyAttr(x)
    p == C_NULL && _cast_failed(UnlikelyAttr, x)
    return UnlikelyAttr(p)
end

function isAlwaysInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlwaysInlineAttr(x)
end

function AlwaysInlineAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAlwaysInlineAttr(x)
    p == C_NULL && _cast_failed(AlwaysInlineAttr, x)
    return AlwaysInlineAttr(p)
end

function isNoInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoInlineAttr(x)
end

function NoInlineAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoInlineAttr(x)
    p == C_NULL && _cast_failed(NoInlineAttr, x)
    return NoInlineAttr(p)
end

function isNoMergeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoMergeAttr(x)
end

function NoMergeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoMergeAttr(x)
    p == C_NULL && _cast_failed(NoMergeAttr, x)
    return NoMergeAttr(p)
end

function isSuppressAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSuppressAttr(x)
end

function SuppressAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSuppressAttr(x)
    p == C_NULL && _cast_failed(SuppressAttr, x)
    return SuppressAttr(p)
end

function isAArch64SVEPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAArch64SVEPcsAttr(x)
end

function AArch64SVEPcsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAArch64SVEPcsAttr(x)
    p == C_NULL && _cast_failed(AArch64SVEPcsAttr, x)
    return AArch64SVEPcsAttr(p)
end

function isAArch64VectorPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAArch64VectorPcsAttr(x)
end

function AArch64VectorPcsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAArch64VectorPcsAttr(x)
    p == C_NULL && _cast_failed(AArch64VectorPcsAttr, x)
    return AArch64VectorPcsAttr(p)
end

function isAMDGPUKernelCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUKernelCallAttr(x)
end

function AMDGPUKernelCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAMDGPUKernelCallAttr(x)
    p == C_NULL && _cast_failed(AMDGPUKernelCallAttr, x)
    return AMDGPUKernelCallAttr(p)
end

function isAcquireHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquireHandleAttr(x)
end

function AcquireHandleAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAcquireHandleAttr(x)
    p == C_NULL && _cast_failed(AcquireHandleAttr, x)
    return AcquireHandleAttr(p)
end

function isAnyX86NoCfCheckAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnyX86NoCfCheckAttr(x)
end

function AnyX86NoCfCheckAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAnyX86NoCfCheckAttr(x)
    p == C_NULL && _cast_failed(AnyX86NoCfCheckAttr, x)
    return AnyX86NoCfCheckAttr(p)
end

function isCDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCDeclAttr(x)
end

function CDeclAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCDeclAttr(x)
    p == C_NULL && _cast_failed(CDeclAttr, x)
    return CDeclAttr(p)
end

function isFastCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFastCallAttr(x)
end

function FastCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFastCallAttr(x)
    p == C_NULL && _cast_failed(FastCallAttr, x)
    return FastCallAttr(p)
end

function isIntelOclBiccAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIntelOclBiccAttr(x)
end

function IntelOclBiccAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToIntelOclBiccAttr(x)
    p == C_NULL && _cast_failed(IntelOclBiccAttr, x)
    return IntelOclBiccAttr(p)
end

function isLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLifetimeBoundAttr(x)
end

function LifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLifetimeBoundAttr(x)
    p == C_NULL && _cast_failed(LifetimeBoundAttr, x)
    return LifetimeBoundAttr(p)
end

function isM68kRTDAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isM68kRTDAttr(x)
end

function M68kRTDAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToM68kRTDAttr(x)
    p == C_NULL && _cast_failed(M68kRTDAttr, x)
    return M68kRTDAttr(p)
end

function isMSABIAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSABIAttr(x)
end

function MSABIAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSABIAttr(x)
    p == C_NULL && _cast_failed(MSABIAttr, x)
    return MSABIAttr(p)
end

function isNSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSReturnsRetainedAttr(x)
end

function NSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNSReturnsRetainedAttr(x)
    p == C_NULL && _cast_failed(NSReturnsRetainedAttr, x)
    return NSReturnsRetainedAttr(p)
end

function isObjCOwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCOwnershipAttr(x)
end

function ObjCOwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCOwnershipAttr(x)
    p == C_NULL && _cast_failed(ObjCOwnershipAttr, x)
    return ObjCOwnershipAttr(p)
end

function isPascalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPascalAttr(x)
end

function PascalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPascalAttr(x)
    p == C_NULL && _cast_failed(PascalAttr, x)
    return PascalAttr(p)
end

function isPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPcsAttr(x)
end

function PcsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPcsAttr(x)
    p == C_NULL && _cast_failed(PcsAttr, x)
    return PcsAttr(p)
end

function isPreserveAllAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreserveAllAttr(x)
end

function PreserveAllAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPreserveAllAttr(x)
    p == C_NULL && _cast_failed(PreserveAllAttr, x)
    return PreserveAllAttr(p)
end

function isPreserveMostAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreserveMostAttr(x)
end

function PreserveMostAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPreserveMostAttr(x)
    p == C_NULL && _cast_failed(PreserveMostAttr, x)
    return PreserveMostAttr(p)
end

function isRegCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRegCallAttr(x)
end

function RegCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRegCallAttr(x)
    p == C_NULL && _cast_failed(RegCallAttr, x)
    return RegCallAttr(p)
end

function isStdCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStdCallAttr(x)
end

function StdCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToStdCallAttr(x)
    p == C_NULL && _cast_failed(StdCallAttr, x)
    return StdCallAttr(p)
end

function isSwiftAsyncCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncCallAttr(x)
end

function SwiftAsyncCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftAsyncCallAttr(x)
    p == C_NULL && _cast_failed(SwiftAsyncCallAttr, x)
    return SwiftAsyncCallAttr(p)
end

function isSwiftCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftCallAttr(x)
end

function SwiftCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftCallAttr(x)
    p == C_NULL && _cast_failed(SwiftCallAttr, x)
    return SwiftCallAttr(p)
end

function isSysVABIAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSysVABIAttr(x)
end

function SysVABIAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSysVABIAttr(x)
    p == C_NULL && _cast_failed(SysVABIAttr, x)
    return SysVABIAttr(p)
end

function isThisCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isThisCallAttr(x)
end

function ThisCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToThisCallAttr(x)
    p == C_NULL && _cast_failed(ThisCallAttr, x)
    return ThisCallAttr(p)
end

function isVectorCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVectorCallAttr(x)
end

function VectorCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToVectorCallAttr(x)
    p == C_NULL && _cast_failed(VectorCallAttr, x)
    return VectorCallAttr(p)
end

function isSwiftAsyncContextAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncContextAttr(x)
end

function SwiftAsyncContextAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftAsyncContextAttr(x)
    p == C_NULL && _cast_failed(SwiftAsyncContextAttr, x)
    return SwiftAsyncContextAttr(p)
end

function isSwiftContextAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftContextAttr(x)
end

function SwiftContextAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftContextAttr(x)
    p == C_NULL && _cast_failed(SwiftContextAttr, x)
    return SwiftContextAttr(p)
end

function isSwiftErrorResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftErrorResultAttr(x)
end

function SwiftErrorResultAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftErrorResultAttr(x)
    p == C_NULL && _cast_failed(SwiftErrorResultAttr, x)
    return SwiftErrorResultAttr(p)
end

function isSwiftIndirectResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftIndirectResultAttr(x)
end

function SwiftIndirectResultAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftIndirectResultAttr(x)
    p == C_NULL && _cast_failed(SwiftIndirectResultAttr, x)
    return SwiftIndirectResultAttr(p)
end

function isAnnotateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnnotateAttr(x)
end

function AnnotateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAnnotateAttr(x)
    p == C_NULL && _cast_failed(AnnotateAttr, x)
    return AnnotateAttr(p)
end

function isCFConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFConsumedAttr(x)
end

function CFConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFConsumedAttr(x)
    p == C_NULL && _cast_failed(CFConsumedAttr, x)
    return CFConsumedAttr(p)
end

function isCarriesDependencyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCarriesDependencyAttr(x)
end

function CarriesDependencyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCarriesDependencyAttr(x)
    p == C_NULL && _cast_failed(CarriesDependencyAttr, x)
    return CarriesDependencyAttr(p)
end

function isNSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSConsumedAttr(x)
end

function NSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNSConsumedAttr(x)
    p == C_NULL && _cast_failed(NSConsumedAttr, x)
    return NSConsumedAttr(p)
end

function isNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNonNullAttr(x)
end

function NonNullAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNonNullAttr(x)
    p == C_NULL && _cast_failed(NonNullAttr, x)
    return NonNullAttr(p)
end

function isOSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSConsumedAttr(x)
end

function OSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOSConsumedAttr(x)
    p == C_NULL && _cast_failed(OSConsumedAttr, x)
    return OSConsumedAttr(p)
end

function isPassObjectSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPassObjectSizeAttr(x)
end

function PassObjectSizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPassObjectSizeAttr(x)
    p == C_NULL && _cast_failed(PassObjectSizeAttr, x)
    return PassObjectSizeAttr(p)
end

function isReleaseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReleaseHandleAttr(x)
end

function ReleaseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReleaseHandleAttr(x)
    p == C_NULL && _cast_failed(ReleaseHandleAttr, x)
    return ReleaseHandleAttr(p)
end

function isUseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUseHandleAttr(x)
end

function UseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUseHandleAttr(x)
    p == C_NULL && _cast_failed(UseHandleAttr, x)
    return UseHandleAttr(p)
end

function isHLSLSV_DispatchThreadIDAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLSV_DispatchThreadIDAttr(x)
end

function HLSLSV_DispatchThreadIDAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLSV_DispatchThreadIDAttr(x)
    p == C_NULL && _cast_failed(HLSLSV_DispatchThreadIDAttr, x)
    return HLSLSV_DispatchThreadIDAttr(p)
end

function isHLSLSV_GroupIndexAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLSV_GroupIndexAttr(x)
end

function HLSLSV_GroupIndexAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLSV_GroupIndexAttr(x)
    p == C_NULL && _cast_failed(HLSLSV_GroupIndexAttr, x)
    return HLSLSV_GroupIndexAttr(p)
end

function isAMDGPUFlatWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUFlatWorkGroupSizeAttr(x)
end

function AMDGPUFlatWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAMDGPUFlatWorkGroupSizeAttr(x)
    p == C_NULL && _cast_failed(AMDGPUFlatWorkGroupSizeAttr, x)
    return AMDGPUFlatWorkGroupSizeAttr(p)
end

function isAMDGPUNumSGPRAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUNumSGPRAttr(x)
end

function AMDGPUNumSGPRAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAMDGPUNumSGPRAttr(x)
    p == C_NULL && _cast_failed(AMDGPUNumSGPRAttr, x)
    return AMDGPUNumSGPRAttr(p)
end

function isAMDGPUNumVGPRAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUNumVGPRAttr(x)
end

function AMDGPUNumVGPRAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAMDGPUNumVGPRAttr(x)
    p == C_NULL && _cast_failed(AMDGPUNumVGPRAttr, x)
    return AMDGPUNumVGPRAttr(p)
end

function isAMDGPUWavesPerEUAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUWavesPerEUAttr(x)
end

function AMDGPUWavesPerEUAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAMDGPUWavesPerEUAttr(x)
    p == C_NULL && _cast_failed(AMDGPUWavesPerEUAttr, x)
    return AMDGPUWavesPerEUAttr(p)
end

function isARMInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isARMInterruptAttr(x)
end

function ARMInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToARMInterruptAttr(x)
    p == C_NULL && _cast_failed(ARMInterruptAttr, x)
    return ARMInterruptAttr(p)
end

function isAVRInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAVRInterruptAttr(x)
end

function AVRInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAVRInterruptAttr(x)
    p == C_NULL && _cast_failed(AVRInterruptAttr, x)
    return AVRInterruptAttr(p)
end

function isAVRSignalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAVRSignalAttr(x)
end

function AVRSignalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAVRSignalAttr(x)
    p == C_NULL && _cast_failed(AVRSignalAttr, x)
    return AVRSignalAttr(p)
end

function isAcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquireCapabilityAttr(x)
end

function AcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAcquireCapabilityAttr(x)
    p == C_NULL && _cast_failed(AcquireCapabilityAttr, x)
    return AcquireCapabilityAttr(p)
end

function isAcquiredAfterAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquiredAfterAttr(x)
end

function AcquiredAfterAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAcquiredAfterAttr(x)
    p == C_NULL && _cast_failed(AcquiredAfterAttr, x)
    return AcquiredAfterAttr(p)
end

function isAcquiredBeforeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquiredBeforeAttr(x)
end

function AcquiredBeforeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAcquiredBeforeAttr(x)
    p == C_NULL && _cast_failed(AcquiredBeforeAttr, x)
    return AcquiredBeforeAttr(p)
end

function isAlignMac68kAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignMac68kAttr(x)
end

function AlignMac68kAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAlignMac68kAttr(x)
    p == C_NULL && _cast_failed(AlignMac68kAttr, x)
    return AlignMac68kAttr(p)
end

function isAlignNaturalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignNaturalAttr(x)
end

function AlignNaturalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAlignNaturalAttr(x)
    p == C_NULL && _cast_failed(AlignNaturalAttr, x)
    return AlignNaturalAttr(p)
end

function isAlignedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignedAttr(x)
end

function AlignedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAlignedAttr(x)
    p == C_NULL && _cast_failed(AlignedAttr, x)
    return AlignedAttr(p)
end

function isAllocAlignAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAllocAlignAttr(x)
end

function AllocAlignAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAllocAlignAttr(x)
    p == C_NULL && _cast_failed(AllocAlignAttr, x)
    return AllocAlignAttr(p)
end

function isAllocSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAllocSizeAttr(x)
end

function AllocSizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAllocSizeAttr(x)
    p == C_NULL && _cast_failed(AllocSizeAttr, x)
    return AllocSizeAttr(p)
end

function isAlwaysDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlwaysDestroyAttr(x)
end

function AlwaysDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAlwaysDestroyAttr(x)
    p == C_NULL && _cast_failed(AlwaysDestroyAttr, x)
    return AlwaysDestroyAttr(p)
end

function isAnalyzerNoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnalyzerNoReturnAttr(x)
end

function AnalyzerNoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAnalyzerNoReturnAttr(x)
    p == C_NULL && _cast_failed(AnalyzerNoReturnAttr, x)
    return AnalyzerNoReturnAttr(p)
end

function isAnyX86InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnyX86InterruptAttr(x)
end

function AnyX86InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAnyX86InterruptAttr(x)
    p == C_NULL && _cast_failed(AnyX86InterruptAttr, x)
    return AnyX86InterruptAttr(p)
end

function isAnyX86NoCallerSavedRegistersAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnyX86NoCallerSavedRegistersAttr(x)
end

function AnyX86NoCallerSavedRegistersAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAnyX86NoCallerSavedRegistersAttr(x)
    p == C_NULL && _cast_failed(AnyX86NoCallerSavedRegistersAttr, x)
    return AnyX86NoCallerSavedRegistersAttr(p)
end

function isArcWeakrefUnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArcWeakrefUnavailableAttr(x)
end

function ArcWeakrefUnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArcWeakrefUnavailableAttr(x)
    p == C_NULL && _cast_failed(ArcWeakrefUnavailableAttr, x)
    return ArcWeakrefUnavailableAttr(p)
end

function isArgumentWithTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArgumentWithTypeTagAttr(x)
end

function ArgumentWithTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArgumentWithTypeTagAttr(x)
    p == C_NULL && _cast_failed(ArgumentWithTypeTagAttr, x)
    return ArgumentWithTypeTagAttr(p)
end

function isArmBuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmBuiltinAliasAttr(x)
end

function ArmBuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmBuiltinAliasAttr(x)
    p == C_NULL && _cast_failed(ArmBuiltinAliasAttr, x)
    return ArmBuiltinAliasAttr(p)
end

function isArmLocallyStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmLocallyStreamingAttr(x)
end

function ArmLocallyStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmLocallyStreamingAttr(x)
    p == C_NULL && _cast_failed(ArmLocallyStreamingAttr, x)
    return ArmLocallyStreamingAttr(p)
end

function isArmNewAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmNewAttr(x)
end

function ArmNewAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArmNewAttr(x)
    p == C_NULL && _cast_failed(ArmNewAttr, x)
    return ArmNewAttr(p)
end

function isArtificialAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArtificialAttr(x)
end

function ArtificialAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToArtificialAttr(x)
    p == C_NULL && _cast_failed(ArtificialAttr, x)
    return ArtificialAttr(p)
end

function isAsmLabelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAsmLabelAttr(x)
end

function AsmLabelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAsmLabelAttr(x)
    p == C_NULL && _cast_failed(AsmLabelAttr, x)
    return AsmLabelAttr(p)
end

function isAssertCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssertCapabilityAttr(x)
end

function AssertCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAssertCapabilityAttr(x)
    p == C_NULL && _cast_failed(AssertCapabilityAttr, x)
    return AssertCapabilityAttr(p)
end

function isAssertExclusiveLockAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssertExclusiveLockAttr(x)
end

function AssertExclusiveLockAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAssertExclusiveLockAttr(x)
    p == C_NULL && _cast_failed(AssertExclusiveLockAttr, x)
    return AssertExclusiveLockAttr(p)
end

function isAssertSharedLockAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssertSharedLockAttr(x)
end

function AssertSharedLockAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAssertSharedLockAttr(x)
    p == C_NULL && _cast_failed(AssertSharedLockAttr, x)
    return AssertSharedLockAttr(p)
end

function isAssumeAlignedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssumeAlignedAttr(x)
end

function AssumeAlignedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAssumeAlignedAttr(x)
    p == C_NULL && _cast_failed(AssumeAlignedAttr, x)
    return AssumeAlignedAttr(p)
end

function isAssumptionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssumptionAttr(x)
end

function AssumptionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAssumptionAttr(x)
    p == C_NULL && _cast_failed(AssumptionAttr, x)
    return AssumptionAttr(p)
end

function isAvailabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAvailabilityAttr(x)
end

function AvailabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAvailabilityAttr(x)
    p == C_NULL && _cast_failed(AvailabilityAttr, x)
    return AvailabilityAttr(p)
end

function isAvailableOnlyInDefaultEvalMethodAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAvailableOnlyInDefaultEvalMethodAttr(x)
end

function AvailableOnlyInDefaultEvalMethodAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAvailableOnlyInDefaultEvalMethodAttr(x)
    p == C_NULL && _cast_failed(AvailableOnlyInDefaultEvalMethodAttr, x)
    return AvailableOnlyInDefaultEvalMethodAttr(p)
end

function isBPFPreserveAccessIndexAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBPFPreserveAccessIndexAttr(x)
end

function BPFPreserveAccessIndexAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBPFPreserveAccessIndexAttr(x)
    p == C_NULL && _cast_failed(BPFPreserveAccessIndexAttr, x)
    return BPFPreserveAccessIndexAttr(p)
end

function isBPFPreserveStaticOffsetAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBPFPreserveStaticOffsetAttr(x)
end

function BPFPreserveStaticOffsetAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBPFPreserveStaticOffsetAttr(x)
    p == C_NULL && _cast_failed(BPFPreserveStaticOffsetAttr, x)
    return BPFPreserveStaticOffsetAttr(p)
end

function isBTFDeclTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBTFDeclTagAttr(x)
end

function BTFDeclTagAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBTFDeclTagAttr(x)
    p == C_NULL && _cast_failed(BTFDeclTagAttr, x)
    return BTFDeclTagAttr(p)
end

function isBlocksAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBlocksAttr(x)
end

function BlocksAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBlocksAttr(x)
    p == C_NULL && _cast_failed(BlocksAttr, x)
    return BlocksAttr(p)
end

function isBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBuiltinAttr(x)
end

function BuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBuiltinAttr(x)
    p == C_NULL && _cast_failed(BuiltinAttr, x)
    return BuiltinAttr(p)
end

function isC11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isC11NoReturnAttr(x)
end

function C11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToC11NoReturnAttr(x)
    p == C_NULL && _cast_failed(C11NoReturnAttr, x)
    return C11NoReturnAttr(p)
end

function isCFAuditedTransferAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFAuditedTransferAttr(x)
end

function CFAuditedTransferAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFAuditedTransferAttr(x)
    p == C_NULL && _cast_failed(CFAuditedTransferAttr, x)
    return CFAuditedTransferAttr(p)
end

function isCFGuardAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFGuardAttr(x)
end

function CFGuardAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFGuardAttr(x)
    p == C_NULL && _cast_failed(CFGuardAttr, x)
    return CFGuardAttr(p)
end

function isCFICanonicalJumpTableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFICanonicalJumpTableAttr(x)
end

function CFICanonicalJumpTableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFICanonicalJumpTableAttr(x)
    p == C_NULL && _cast_failed(CFICanonicalJumpTableAttr, x)
    return CFICanonicalJumpTableAttr(p)
end

function isCFReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFReturnsNotRetainedAttr(x)
end

function CFReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFReturnsNotRetainedAttr(x)
    p == C_NULL && _cast_failed(CFReturnsNotRetainedAttr, x)
    return CFReturnsNotRetainedAttr(p)
end

function isCFReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFReturnsRetainedAttr(x)
end

function CFReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFReturnsRetainedAttr(x)
    p == C_NULL && _cast_failed(CFReturnsRetainedAttr, x)
    return CFReturnsRetainedAttr(p)
end

function isCFUnknownTransferAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFUnknownTransferAttr(x)
end

function CFUnknownTransferAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCFUnknownTransferAttr(x)
    p == C_NULL && _cast_failed(CFUnknownTransferAttr, x)
    return CFUnknownTransferAttr(p)
end

function isCPUDispatchAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCPUDispatchAttr(x)
end

function CPUDispatchAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCPUDispatchAttr(x)
    p == C_NULL && _cast_failed(CPUDispatchAttr, x)
    return CPUDispatchAttr(p)
end

function isCPUSpecificAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCPUSpecificAttr(x)
end

function CPUSpecificAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCPUSpecificAttr(x)
    p == C_NULL && _cast_failed(CPUSpecificAttr, x)
    return CPUSpecificAttr(p)
end

function isCUDAConstantAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAConstantAttr(x)
end

function CUDAConstantAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDAConstantAttr(x)
    p == C_NULL && _cast_failed(CUDAConstantAttr, x)
    return CUDAConstantAttr(p)
end

function isCUDADeviceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDADeviceAttr(x)
end

function CUDADeviceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDADeviceAttr(x)
    p == C_NULL && _cast_failed(CUDADeviceAttr, x)
    return CUDADeviceAttr(p)
end

function isCUDADeviceBuiltinSurfaceTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDADeviceBuiltinSurfaceTypeAttr(x)
end

function CUDADeviceBuiltinSurfaceTypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDADeviceBuiltinSurfaceTypeAttr(x)
    p == C_NULL && _cast_failed(CUDADeviceBuiltinSurfaceTypeAttr, x)
    return CUDADeviceBuiltinSurfaceTypeAttr(p)
end

function isCUDADeviceBuiltinTextureTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDADeviceBuiltinTextureTypeAttr(x)
end

function CUDADeviceBuiltinTextureTypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDADeviceBuiltinTextureTypeAttr(x)
    p == C_NULL && _cast_failed(CUDADeviceBuiltinTextureTypeAttr, x)
    return CUDADeviceBuiltinTextureTypeAttr(p)
end

function isCUDAGlobalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAGlobalAttr(x)
end

function CUDAGlobalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDAGlobalAttr(x)
    p == C_NULL && _cast_failed(CUDAGlobalAttr, x)
    return CUDAGlobalAttr(p)
end

function isCUDAHostAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAHostAttr(x)
end

function CUDAHostAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDAHostAttr(x)
    p == C_NULL && _cast_failed(CUDAHostAttr, x)
    return CUDAHostAttr(p)
end

function isCUDAInvalidTargetAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAInvalidTargetAttr(x)
end

function CUDAInvalidTargetAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDAInvalidTargetAttr(x)
    p == C_NULL && _cast_failed(CUDAInvalidTargetAttr, x)
    return CUDAInvalidTargetAttr(p)
end

function isCUDALaunchBoundsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDALaunchBoundsAttr(x)
end

function CUDALaunchBoundsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDALaunchBoundsAttr(x)
    p == C_NULL && _cast_failed(CUDALaunchBoundsAttr, x)
    return CUDALaunchBoundsAttr(p)
end

function isCUDASharedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDASharedAttr(x)
end

function CUDASharedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCUDASharedAttr(x)
    p == C_NULL && _cast_failed(CUDASharedAttr, x)
    return CUDASharedAttr(p)
end

function isCXX11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCXX11NoReturnAttr(x)
end

function CXX11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCXX11NoReturnAttr(x)
    p == C_NULL && _cast_failed(CXX11NoReturnAttr, x)
    return CXX11NoReturnAttr(p)
end

function isCallableWhenAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCallableWhenAttr(x)
end

function CallableWhenAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCallableWhenAttr(x)
    p == C_NULL && _cast_failed(CallableWhenAttr, x)
    return CallableWhenAttr(p)
end

function isCallbackAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCallbackAttr(x)
end

function CallbackAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCallbackAttr(x)
    p == C_NULL && _cast_failed(CallbackAttr, x)
    return CallbackAttr(p)
end

function isCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCapabilityAttr(x)
end

function CapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCapabilityAttr(x)
    p == C_NULL && _cast_failed(CapabilityAttr, x)
    return CapabilityAttr(p)
end

function isCapturedRecordAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCapturedRecordAttr(x)
end

function CapturedRecordAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCapturedRecordAttr(x)
    p == C_NULL && _cast_failed(CapturedRecordAttr, x)
    return CapturedRecordAttr(p)
end

function isCleanupAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCleanupAttr(x)
end

function CleanupAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCleanupAttr(x)
    p == C_NULL && _cast_failed(CleanupAttr, x)
    return CleanupAttr(p)
end

function isCmseNSEntryAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCmseNSEntryAttr(x)
end

function CmseNSEntryAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCmseNSEntryAttr(x)
    p == C_NULL && _cast_failed(CmseNSEntryAttr, x)
    return CmseNSEntryAttr(p)
end

function isCodeModelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCodeModelAttr(x)
end

function CodeModelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCodeModelAttr(x)
    p == C_NULL && _cast_failed(CodeModelAttr, x)
    return CodeModelAttr(p)
end

function isCodeSegAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCodeSegAttr(x)
end

function CodeSegAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCodeSegAttr(x)
    p == C_NULL && _cast_failed(CodeSegAttr, x)
    return CodeSegAttr(p)
end

function isColdAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isColdAttr(x)
end

function ColdAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToColdAttr(x)
    p == C_NULL && _cast_failed(ColdAttr, x)
    return ColdAttr(p)
end

function isCommonAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCommonAttr(x)
end

function CommonAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCommonAttr(x)
    p == C_NULL && _cast_failed(CommonAttr, x)
    return CommonAttr(p)
end

function isConstAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConstAttr(x)
end

function ConstAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConstAttr(x)
    p == C_NULL && _cast_failed(ConstAttr, x)
    return ConstAttr(p)
end

function isConstInitAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConstInitAttr(x)
end

function ConstInitAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConstInitAttr(x)
    p == C_NULL && _cast_failed(ConstInitAttr, x)
    return ConstInitAttr(p)
end

function isConstructorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConstructorAttr(x)
end

function ConstructorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConstructorAttr(x)
    p == C_NULL && _cast_failed(ConstructorAttr, x)
    return ConstructorAttr(p)
end

function isConsumableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConsumableAttr(x)
end

function ConsumableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConsumableAttr(x)
    p == C_NULL && _cast_failed(ConsumableAttr, x)
    return ConsumableAttr(p)
end

function isConsumableAutoCastAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConsumableAutoCastAttr(x)
end

function ConsumableAutoCastAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConsumableAutoCastAttr(x)
    p == C_NULL && _cast_failed(ConsumableAutoCastAttr, x)
    return ConsumableAutoCastAttr(p)
end

function isConsumableSetOnReadAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConsumableSetOnReadAttr(x)
end

function ConsumableSetOnReadAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConsumableSetOnReadAttr(x)
    p == C_NULL && _cast_failed(ConsumableSetOnReadAttr, x)
    return ConsumableSetOnReadAttr(p)
end

function isConvergentAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConvergentAttr(x)
end

function ConvergentAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToConvergentAttr(x)
    p == C_NULL && _cast_failed(ConvergentAttr, x)
    return ConvergentAttr(p)
end

function isCoroDisableLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroDisableLifetimeBoundAttr(x)
end

function CoroDisableLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCoroDisableLifetimeBoundAttr(x)
    p == C_NULL && _cast_failed(CoroDisableLifetimeBoundAttr, x)
    return CoroDisableLifetimeBoundAttr(p)
end

function isCoroLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroLifetimeBoundAttr(x)
end

function CoroLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCoroLifetimeBoundAttr(x)
    p == C_NULL && _cast_failed(CoroLifetimeBoundAttr, x)
    return CoroLifetimeBoundAttr(p)
end

function isCoroOnlyDestroyWhenCompleteAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroOnlyDestroyWhenCompleteAttr(x)
end

function CoroOnlyDestroyWhenCompleteAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCoroOnlyDestroyWhenCompleteAttr(x)
    p == C_NULL && _cast_failed(CoroOnlyDestroyWhenCompleteAttr, x)
    return CoroOnlyDestroyWhenCompleteAttr(p)
end

function isCoroReturnTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroReturnTypeAttr(x)
end

function CoroReturnTypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCoroReturnTypeAttr(x)
    p == C_NULL && _cast_failed(CoroReturnTypeAttr, x)
    return CoroReturnTypeAttr(p)
end

function isCoroWrapperAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroWrapperAttr(x)
end

function CoroWrapperAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCoroWrapperAttr(x)
    p == C_NULL && _cast_failed(CoroWrapperAttr, x)
    return CoroWrapperAttr(p)
end

function isCountedByAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCountedByAttr(x)
end

function CountedByAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCountedByAttr(x)
    p == C_NULL && _cast_failed(CountedByAttr, x)
    return CountedByAttr(p)
end

function isDLLExportAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLExportAttr(x)
end

function DLLExportAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDLLExportAttr(x)
    p == C_NULL && _cast_failed(DLLExportAttr, x)
    return DLLExportAttr(p)
end

function isDLLExportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLExportStaticLocalAttr(x)
end

function DLLExportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDLLExportStaticLocalAttr(x)
    p == C_NULL && _cast_failed(DLLExportStaticLocalAttr, x)
    return DLLExportStaticLocalAttr(p)
end

function isDLLImportAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLImportAttr(x)
end

function DLLImportAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDLLImportAttr(x)
    p == C_NULL && _cast_failed(DLLImportAttr, x)
    return DLLImportAttr(p)
end

function isDLLImportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLImportStaticLocalAttr(x)
end

function DLLImportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDLLImportStaticLocalAttr(x)
    p == C_NULL && _cast_failed(DLLImportStaticLocalAttr, x)
    return DLLImportStaticLocalAttr(p)
end

function isDeprecatedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDeprecatedAttr(x)
end

function DeprecatedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDeprecatedAttr(x)
    p == C_NULL && _cast_failed(DeprecatedAttr, x)
    return DeprecatedAttr(p)
end

function isDestructorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDestructorAttr(x)
end

function DestructorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDestructorAttr(x)
    p == C_NULL && _cast_failed(DestructorAttr, x)
    return DestructorAttr(p)
end

function isDiagnoseAsBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDiagnoseAsBuiltinAttr(x)
end

function DiagnoseAsBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDiagnoseAsBuiltinAttr(x)
    p == C_NULL && _cast_failed(DiagnoseAsBuiltinAttr, x)
    return DiagnoseAsBuiltinAttr(p)
end

function isDiagnoseIfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDiagnoseIfAttr(x)
end

function DiagnoseIfAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDiagnoseIfAttr(x)
    p == C_NULL && _cast_failed(DiagnoseIfAttr, x)
    return DiagnoseIfAttr(p)
end

function isDisableSanitizerInstrumentationAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDisableSanitizerInstrumentationAttr(x)
end

function DisableSanitizerInstrumentationAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDisableSanitizerInstrumentationAttr(x)
    p == C_NULL && _cast_failed(DisableSanitizerInstrumentationAttr, x)
    return DisableSanitizerInstrumentationAttr(p)
end

function isDisableTailCallsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDisableTailCallsAttr(x)
end

function DisableTailCallsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToDisableTailCallsAttr(x)
    p == C_NULL && _cast_failed(DisableTailCallsAttr, x)
    return DisableTailCallsAttr(p)
end

function isEmptyBasesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEmptyBasesAttr(x)
end

function EmptyBasesAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToEmptyBasesAttr(x)
    p == C_NULL && _cast_failed(EmptyBasesAttr, x)
    return EmptyBasesAttr(p)
end

function isEnableIfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnableIfAttr(x)
end

function EnableIfAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToEnableIfAttr(x)
    p == C_NULL && _cast_failed(EnableIfAttr, x)
    return EnableIfAttr(p)
end

function isEnforceTCBAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnforceTCBAttr(x)
end

function EnforceTCBAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToEnforceTCBAttr(x)
    p == C_NULL && _cast_failed(EnforceTCBAttr, x)
    return EnforceTCBAttr(p)
end

function isEnforceTCBLeafAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnforceTCBLeafAttr(x)
end

function EnforceTCBLeafAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToEnforceTCBLeafAttr(x)
    p == C_NULL && _cast_failed(EnforceTCBLeafAttr, x)
    return EnforceTCBLeafAttr(p)
end

function isEnumExtensibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnumExtensibilityAttr(x)
end

function EnumExtensibilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToEnumExtensibilityAttr(x)
    p == C_NULL && _cast_failed(EnumExtensibilityAttr, x)
    return EnumExtensibilityAttr(p)
end

function isErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isErrorAttr(x)
end

function ErrorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToErrorAttr(x)
    p == C_NULL && _cast_failed(ErrorAttr, x)
    return ErrorAttr(p)
end

function isExcludeFromExplicitInstantiationAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isExcludeFromExplicitInstantiationAttr(x)
end

function ExcludeFromExplicitInstantiationAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToExcludeFromExplicitInstantiationAttr(x)
    p == C_NULL && _cast_failed(ExcludeFromExplicitInstantiationAttr, x)
    return ExcludeFromExplicitInstantiationAttr(p)
end

function isExclusiveTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isExclusiveTrylockFunctionAttr(x)
end

function ExclusiveTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToExclusiveTrylockFunctionAttr(x)
    p == C_NULL && _cast_failed(ExclusiveTrylockFunctionAttr, x)
    return ExclusiveTrylockFunctionAttr(p)
end

function isExternalSourceSymbolAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isExternalSourceSymbolAttr(x)
end

function ExternalSourceSymbolAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToExternalSourceSymbolAttr(x)
    p == C_NULL && _cast_failed(ExternalSourceSymbolAttr, x)
    return ExternalSourceSymbolAttr(p)
end

function isFinalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFinalAttr(x)
end

function FinalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFinalAttr(x)
    p == C_NULL && _cast_failed(FinalAttr, x)
    return FinalAttr(p)
end

function isFlagEnumAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFlagEnumAttr(x)
end

function FlagEnumAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFlagEnumAttr(x)
    p == C_NULL && _cast_failed(FlagEnumAttr, x)
    return FlagEnumAttr(p)
end

function isFlattenAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFlattenAttr(x)
end

function FlattenAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFlattenAttr(x)
    p == C_NULL && _cast_failed(FlattenAttr, x)
    return FlattenAttr(p)
end

function isFormatAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFormatAttr(x)
end

function FormatAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFormatAttr(x)
    p == C_NULL && _cast_failed(FormatAttr, x)
    return FormatAttr(p)
end

function isFormatArgAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFormatArgAttr(x)
end

function FormatArgAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFormatArgAttr(x)
    p == C_NULL && _cast_failed(FormatArgAttr, x)
    return FormatArgAttr(p)
end

function isFunctionReturnThunksAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFunctionReturnThunksAttr(x)
end

function FunctionReturnThunksAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToFunctionReturnThunksAttr(x)
    p == C_NULL && _cast_failed(FunctionReturnThunksAttr, x)
    return FunctionReturnThunksAttr(p)
end

function isGNUInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isGNUInlineAttr(x)
end

function GNUInlineAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToGNUInlineAttr(x)
    p == C_NULL && _cast_failed(GNUInlineAttr, x)
    return GNUInlineAttr(p)
end

function isGuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isGuardedByAttr(x)
end

function GuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToGuardedByAttr(x)
    p == C_NULL && _cast_failed(GuardedByAttr, x)
    return GuardedByAttr(p)
end

function isGuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isGuardedVarAttr(x)
end

function GuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToGuardedVarAttr(x)
    p == C_NULL && _cast_failed(GuardedVarAttr, x)
    return GuardedVarAttr(p)
end

function isHIPManagedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHIPManagedAttr(x)
end

function HIPManagedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHIPManagedAttr(x)
    p == C_NULL && _cast_failed(HIPManagedAttr, x)
    return HIPManagedAttr(p)
end

function isHLSLNumThreadsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLNumThreadsAttr(x)
end

function HLSLNumThreadsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLNumThreadsAttr(x)
    p == C_NULL && _cast_failed(HLSLNumThreadsAttr, x)
    return HLSLNumThreadsAttr(p)
end

function isHLSLResourceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLResourceAttr(x)
end

function HLSLResourceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLResourceAttr(x)
    p == C_NULL && _cast_failed(HLSLResourceAttr, x)
    return HLSLResourceAttr(p)
end

function isHLSLResourceBindingAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLResourceBindingAttr(x)
end

function HLSLResourceBindingAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLResourceBindingAttr(x)
    p == C_NULL && _cast_failed(HLSLResourceBindingAttr, x)
    return HLSLResourceBindingAttr(p)
end

function isHLSLShaderAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLShaderAttr(x)
end

function HLSLShaderAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHLSLShaderAttr(x)
    p == C_NULL && _cast_failed(HLSLShaderAttr, x)
    return HLSLShaderAttr(p)
end

function isHotAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHotAttr(x)
end

function HotAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToHotAttr(x)
    p == C_NULL && _cast_failed(HotAttr, x)
    return HotAttr(p)
end

function isIBActionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIBActionAttr(x)
end

function IBActionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToIBActionAttr(x)
    p == C_NULL && _cast_failed(IBActionAttr, x)
    return IBActionAttr(p)
end

function isIBOutletAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIBOutletAttr(x)
end

function IBOutletAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToIBOutletAttr(x)
    p == C_NULL && _cast_failed(IBOutletAttr, x)
    return IBOutletAttr(p)
end

function isIBOutletCollectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIBOutletCollectionAttr(x)
end

function IBOutletCollectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToIBOutletCollectionAttr(x)
    p == C_NULL && _cast_failed(IBOutletCollectionAttr, x)
    return IBOutletCollectionAttr(p)
end

function isInitPriorityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInitPriorityAttr(x)
end

function InitPriorityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToInitPriorityAttr(x)
    p == C_NULL && _cast_failed(InitPriorityAttr, x)
    return InitPriorityAttr(p)
end

function isInternalLinkageAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInternalLinkageAttr(x)
end

function InternalLinkageAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToInternalLinkageAttr(x)
    p == C_NULL && _cast_failed(InternalLinkageAttr, x)
    return InternalLinkageAttr(p)
end

function isLTOVisibilityPublicAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLTOVisibilityPublicAttr(x)
end

function LTOVisibilityPublicAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLTOVisibilityPublicAttr(x)
    p == C_NULL && _cast_failed(LTOVisibilityPublicAttr, x)
    return LTOVisibilityPublicAttr(p)
end

function isLayoutVersionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLayoutVersionAttr(x)
end

function LayoutVersionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLayoutVersionAttr(x)
    p == C_NULL && _cast_failed(LayoutVersionAttr, x)
    return LayoutVersionAttr(p)
end

function isLeafAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLeafAttr(x)
end

function LeafAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLeafAttr(x)
    p == C_NULL && _cast_failed(LeafAttr, x)
    return LeafAttr(p)
end

function isLockReturnedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLockReturnedAttr(x)
end

function LockReturnedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLockReturnedAttr(x)
    p == C_NULL && _cast_failed(LockReturnedAttr, x)
    return LockReturnedAttr(p)
end

function isLocksExcludedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLocksExcludedAttr(x)
end

function LocksExcludedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLocksExcludedAttr(x)
    p == C_NULL && _cast_failed(LocksExcludedAttr, x)
    return LocksExcludedAttr(p)
end

function isM68kInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isM68kInterruptAttr(x)
end

function M68kInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToM68kInterruptAttr(x)
    p == C_NULL && _cast_failed(M68kInterruptAttr, x)
    return M68kInterruptAttr(p)
end

function isMIGServerRoutineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMIGServerRoutineAttr(x)
end

function MIGServerRoutineAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMIGServerRoutineAttr(x)
    p == C_NULL && _cast_failed(MIGServerRoutineAttr, x)
    return MIGServerRoutineAttr(p)
end

function isMSAllocatorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSAllocatorAttr(x)
end

function MSAllocatorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSAllocatorAttr(x)
    p == C_NULL && _cast_failed(MSAllocatorAttr, x)
    return MSAllocatorAttr(p)
end

function isMSConstexprAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSConstexprAttr(x)
end

function MSConstexprAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSConstexprAttr(x)
    p == C_NULL && _cast_failed(MSConstexprAttr, x)
    return MSConstexprAttr(p)
end

function isMSInheritanceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSInheritanceAttr(x)
end

function MSInheritanceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSInheritanceAttr(x)
    p == C_NULL && _cast_failed(MSInheritanceAttr, x)
    return MSInheritanceAttr(p)
end

function isMSNoVTableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSNoVTableAttr(x)
end

function MSNoVTableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSNoVTableAttr(x)
    p == C_NULL && _cast_failed(MSNoVTableAttr, x)
    return MSNoVTableAttr(p)
end

function isMSP430InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSP430InterruptAttr(x)
end

function MSP430InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSP430InterruptAttr(x)
    p == C_NULL && _cast_failed(MSP430InterruptAttr, x)
    return MSP430InterruptAttr(p)
end

function isMSStructAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSStructAttr(x)
end

function MSStructAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSStructAttr(x)
    p == C_NULL && _cast_failed(MSStructAttr, x)
    return MSStructAttr(p)
end

function isMSVtorDispAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSVtorDispAttr(x)
end

function MSVtorDispAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMSVtorDispAttr(x)
    p == C_NULL && _cast_failed(MSVtorDispAttr, x)
    return MSVtorDispAttr(p)
end

function isMaxFieldAlignmentAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMaxFieldAlignmentAttr(x)
end

function MaxFieldAlignmentAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMaxFieldAlignmentAttr(x)
    p == C_NULL && _cast_failed(MaxFieldAlignmentAttr, x)
    return MaxFieldAlignmentAttr(p)
end

function isMayAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMayAliasAttr(x)
end

function MayAliasAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMayAliasAttr(x)
    p == C_NULL && _cast_failed(MayAliasAttr, x)
    return MayAliasAttr(p)
end

function isMaybeUndefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMaybeUndefAttr(x)
end

function MaybeUndefAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMaybeUndefAttr(x)
    p == C_NULL && _cast_failed(MaybeUndefAttr, x)
    return MaybeUndefAttr(p)
end

function isMicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMicroMipsAttr(x)
end

function MicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMicroMipsAttr(x)
    p == C_NULL && _cast_failed(MicroMipsAttr, x)
    return MicroMipsAttr(p)
end

function isMinSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMinSizeAttr(x)
end

function MinSizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMinSizeAttr(x)
    p == C_NULL && _cast_failed(MinSizeAttr, x)
    return MinSizeAttr(p)
end

function isMinVectorWidthAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMinVectorWidthAttr(x)
end

function MinVectorWidthAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMinVectorWidthAttr(x)
    p == C_NULL && _cast_failed(MinVectorWidthAttr, x)
    return MinVectorWidthAttr(p)
end

function isMips16Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMips16Attr(x)
end

function Mips16Attr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMips16Attr(x)
    p == C_NULL && _cast_failed(Mips16Attr, x)
    return Mips16Attr(p)
end

function isMipsInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMipsInterruptAttr(x)
end

function MipsInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMipsInterruptAttr(x)
    p == C_NULL && _cast_failed(MipsInterruptAttr, x)
    return MipsInterruptAttr(p)
end

function isMipsLongCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMipsLongCallAttr(x)
end

function MipsLongCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMipsLongCallAttr(x)
    p == C_NULL && _cast_failed(MipsLongCallAttr, x)
    return MipsLongCallAttr(p)
end

function isMipsShortCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMipsShortCallAttr(x)
end

function MipsShortCallAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToMipsShortCallAttr(x)
    p == C_NULL && _cast_failed(MipsShortCallAttr, x)
    return MipsShortCallAttr(p)
end

function isNSConsumesSelfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSConsumesSelfAttr(x)
end

function NSConsumesSelfAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNSConsumesSelfAttr(x)
    p == C_NULL && _cast_failed(NSConsumesSelfAttr, x)
    return NSConsumesSelfAttr(p)
end

function isNSErrorDomainAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSErrorDomainAttr(x)
end

function NSErrorDomainAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNSErrorDomainAttr(x)
    p == C_NULL && _cast_failed(NSErrorDomainAttr, x)
    return NSErrorDomainAttr(p)
end

function isNSReturnsAutoreleasedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSReturnsAutoreleasedAttr(x)
end

function NSReturnsAutoreleasedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNSReturnsAutoreleasedAttr(x)
    p == C_NULL && _cast_failed(NSReturnsAutoreleasedAttr, x)
    return NSReturnsAutoreleasedAttr(p)
end

function isNSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSReturnsNotRetainedAttr(x)
end

function NSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNSReturnsNotRetainedAttr(x)
    p == C_NULL && _cast_failed(NSReturnsNotRetainedAttr, x)
    return NSReturnsNotRetainedAttr(p)
end

function isNVPTXKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNVPTXKernelAttr(x)
end

function NVPTXKernelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNVPTXKernelAttr(x)
    p == C_NULL && _cast_failed(NVPTXKernelAttr, x)
    return NVPTXKernelAttr(p)
end

function isNakedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNakedAttr(x)
end

function NakedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNakedAttr(x)
    p == C_NULL && _cast_failed(NakedAttr, x)
    return NakedAttr(p)
end

function isNoAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoAliasAttr(x)
end

function NoAliasAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoAliasAttr(x)
    p == C_NULL && _cast_failed(NoAliasAttr, x)
    return NoAliasAttr(p)
end

function isNoCommonAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoCommonAttr(x)
end

function NoCommonAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoCommonAttr(x)
    p == C_NULL && _cast_failed(NoCommonAttr, x)
    return NoCommonAttr(p)
end

function isNoDebugAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDebugAttr(x)
end

function NoDebugAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoDebugAttr(x)
    p == C_NULL && _cast_failed(NoDebugAttr, x)
    return NoDebugAttr(p)
end

function isNoDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDestroyAttr(x)
end

function NoDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoDestroyAttr(x)
    p == C_NULL && _cast_failed(NoDestroyAttr, x)
    return NoDestroyAttr(p)
end

function isNoDuplicateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDuplicateAttr(x)
end

function NoDuplicateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoDuplicateAttr(x)
    p == C_NULL && _cast_failed(NoDuplicateAttr, x)
    return NoDuplicateAttr(p)
end

function isNoInstrumentFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoInstrumentFunctionAttr(x)
end

function NoInstrumentFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoInstrumentFunctionAttr(x)
    p == C_NULL && _cast_failed(NoInstrumentFunctionAttr, x)
    return NoInstrumentFunctionAttr(p)
end

function isNoMicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoMicroMipsAttr(x)
end

function NoMicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoMicroMipsAttr(x)
    p == C_NULL && _cast_failed(NoMicroMipsAttr, x)
    return NoMicroMipsAttr(p)
end

function isNoMips16Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoMips16Attr(x)
end

function NoMips16Attr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoMips16Attr(x)
    p == C_NULL && _cast_failed(NoMips16Attr, x)
    return NoMips16Attr(p)
end

function isNoProfileFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoProfileFunctionAttr(x)
end

function NoProfileFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoProfileFunctionAttr(x)
    p == C_NULL && _cast_failed(NoProfileFunctionAttr, x)
    return NoProfileFunctionAttr(p)
end

function isNoRandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoRandomizeLayoutAttr(x)
end

function NoRandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoRandomizeLayoutAttr(x)
    p == C_NULL && _cast_failed(NoRandomizeLayoutAttr, x)
    return NoRandomizeLayoutAttr(p)
end

function isNoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoReturnAttr(x)
end

function NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoReturnAttr(x)
    p == C_NULL && _cast_failed(NoReturnAttr, x)
    return NoReturnAttr(p)
end

function isNoSanitizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoSanitizeAttr(x)
end

function NoSanitizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoSanitizeAttr(x)
    p == C_NULL && _cast_failed(NoSanitizeAttr, x)
    return NoSanitizeAttr(p)
end

function isNoSpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoSpeculativeLoadHardeningAttr(x)
end

function NoSpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoSpeculativeLoadHardeningAttr(x)
    p == C_NULL && _cast_failed(NoSpeculativeLoadHardeningAttr, x)
    return NoSpeculativeLoadHardeningAttr(p)
end

function isNoSplitStackAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoSplitStackAttr(x)
end

function NoSplitStackAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoSplitStackAttr(x)
    p == C_NULL && _cast_failed(NoSplitStackAttr, x)
    return NoSplitStackAttr(p)
end

function isNoStackProtectorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoStackProtectorAttr(x)
end

function NoStackProtectorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoStackProtectorAttr(x)
    p == C_NULL && _cast_failed(NoStackProtectorAttr, x)
    return NoStackProtectorAttr(p)
end

function isNoThreadSafetyAnalysisAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoThreadSafetyAnalysisAttr(x)
end

function NoThreadSafetyAnalysisAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoThreadSafetyAnalysisAttr(x)
    p == C_NULL && _cast_failed(NoThreadSafetyAnalysisAttr, x)
    return NoThreadSafetyAnalysisAttr(p)
end

function isNoThrowAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoThrowAttr(x)
end

function NoThrowAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoThrowAttr(x)
    p == C_NULL && _cast_failed(NoThrowAttr, x)
    return NoThrowAttr(p)
end

function isNoUniqueAddressAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoUniqueAddressAttr(x)
end

function NoUniqueAddressAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoUniqueAddressAttr(x)
    p == C_NULL && _cast_failed(NoUniqueAddressAttr, x)
    return NoUniqueAddressAttr(p)
end

function isNoUwtableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoUwtableAttr(x)
end

function NoUwtableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoUwtableAttr(x)
    p == C_NULL && _cast_failed(NoUwtableAttr, x)
    return NoUwtableAttr(p)
end

function isNotTailCalledAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNotTailCalledAttr(x)
end

function NotTailCalledAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNotTailCalledAttr(x)
    p == C_NULL && _cast_failed(NotTailCalledAttr, x)
    return NotTailCalledAttr(p)
end

function isOMPAllocateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPAllocateDeclAttr(x)
end

function OMPAllocateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPAllocateDeclAttr(x)
    p == C_NULL && _cast_failed(OMPAllocateDeclAttr, x)
    return OMPAllocateDeclAttr(p)
end

function isOMPCaptureNoInitAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPCaptureNoInitAttr(x)
end

function OMPCaptureNoInitAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPCaptureNoInitAttr(x)
    p == C_NULL && _cast_failed(OMPCaptureNoInitAttr, x)
    return OMPCaptureNoInitAttr(p)
end

function isOMPDeclareTargetDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPDeclareTargetDeclAttr(x)
end

function OMPDeclareTargetDeclAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPDeclareTargetDeclAttr(x)
    p == C_NULL && _cast_failed(OMPDeclareTargetDeclAttr, x)
    return OMPDeclareTargetDeclAttr(p)
end

function isOMPDeclareVariantAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPDeclareVariantAttr(x)
end

function OMPDeclareVariantAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPDeclareVariantAttr(x)
    p == C_NULL && _cast_failed(OMPDeclareVariantAttr, x)
    return OMPDeclareVariantAttr(p)
end

function isOMPThreadPrivateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPThreadPrivateDeclAttr(x)
end

function OMPThreadPrivateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPThreadPrivateDeclAttr(x)
    p == C_NULL && _cast_failed(OMPThreadPrivateDeclAttr, x)
    return OMPThreadPrivateDeclAttr(p)
end

function isOSConsumesThisAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSConsumesThisAttr(x)
end

function OSConsumesThisAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOSConsumesThisAttr(x)
    p == C_NULL && _cast_failed(OSConsumesThisAttr, x)
    return OSConsumesThisAttr(p)
end

function isOSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsNotRetainedAttr(x)
end

function OSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOSReturnsNotRetainedAttr(x)
    p == C_NULL && _cast_failed(OSReturnsNotRetainedAttr, x)
    return OSReturnsNotRetainedAttr(p)
end

function isOSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsRetainedAttr(x)
end

function OSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOSReturnsRetainedAttr(x)
    p == C_NULL && _cast_failed(OSReturnsRetainedAttr, x)
    return OSReturnsRetainedAttr(p)
end

function isOSReturnsRetainedOnNonZeroAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsRetainedOnNonZeroAttr(x)
end

function OSReturnsRetainedOnNonZeroAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOSReturnsRetainedOnNonZeroAttr(x)
    p == C_NULL && _cast_failed(OSReturnsRetainedOnNonZeroAttr, x)
    return OSReturnsRetainedOnNonZeroAttr(p)
end

function isOSReturnsRetainedOnZeroAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsRetainedOnZeroAttr(x)
end

function OSReturnsRetainedOnZeroAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOSReturnsRetainedOnZeroAttr(x)
    p == C_NULL && _cast_failed(OSReturnsRetainedOnZeroAttr, x)
    return OSReturnsRetainedOnZeroAttr(p)
end

function isObjCBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBridgeAttr(x)
end

function ObjCBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCBridgeAttr(x)
    p == C_NULL && _cast_failed(ObjCBridgeAttr, x)
    return ObjCBridgeAttr(p)
end

function isObjCBridgeMutableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBridgeMutableAttr(x)
end

function ObjCBridgeMutableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCBridgeMutableAttr(x)
    p == C_NULL && _cast_failed(ObjCBridgeMutableAttr, x)
    return ObjCBridgeMutableAttr(p)
end

function isObjCBridgeRelatedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBridgeRelatedAttr(x)
end

function ObjCBridgeRelatedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCBridgeRelatedAttr(x)
    p == C_NULL && _cast_failed(ObjCBridgeRelatedAttr, x)
    return ObjCBridgeRelatedAttr(p)
end

function isObjCExceptionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCExceptionAttr(x)
end

function ObjCExceptionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCExceptionAttr(x)
    p == C_NULL && _cast_failed(ObjCExceptionAttr, x)
    return ObjCExceptionAttr(p)
end

function isObjCExplicitProtocolImplAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCExplicitProtocolImplAttr(x)
end

function ObjCExplicitProtocolImplAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCExplicitProtocolImplAttr(x)
    p == C_NULL && _cast_failed(ObjCExplicitProtocolImplAttr, x)
    return ObjCExplicitProtocolImplAttr(p)
end

function isObjCExternallyRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCExternallyRetainedAttr(x)
end

function ObjCExternallyRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCExternallyRetainedAttr(x)
    p == C_NULL && _cast_failed(ObjCExternallyRetainedAttr, x)
    return ObjCExternallyRetainedAttr(p)
end

function isObjCIndependentClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCIndependentClassAttr(x)
end

function ObjCIndependentClassAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCIndependentClassAttr(x)
    p == C_NULL && _cast_failed(ObjCIndependentClassAttr, x)
    return ObjCIndependentClassAttr(p)
end

function isObjCMethodFamilyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCMethodFamilyAttr(x)
end

function ObjCMethodFamilyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCMethodFamilyAttr(x)
    p == C_NULL && _cast_failed(ObjCMethodFamilyAttr, x)
    return ObjCMethodFamilyAttr(p)
end

function isObjCNSObjectAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCNSObjectAttr(x)
end

function ObjCNSObjectAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCNSObjectAttr(x)
    p == C_NULL && _cast_failed(ObjCNSObjectAttr, x)
    return ObjCNSObjectAttr(p)
end

function isObjCPreciseLifetimeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCPreciseLifetimeAttr(x)
end

function ObjCPreciseLifetimeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCPreciseLifetimeAttr(x)
    p == C_NULL && _cast_failed(ObjCPreciseLifetimeAttr, x)
    return ObjCPreciseLifetimeAttr(p)
end

function isObjCRequiresPropertyDefsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRequiresPropertyDefsAttr(x)
end

function ObjCRequiresPropertyDefsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCRequiresPropertyDefsAttr(x)
    p == C_NULL && _cast_failed(ObjCRequiresPropertyDefsAttr, x)
    return ObjCRequiresPropertyDefsAttr(p)
end

function isObjCRequiresSuperAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRequiresSuperAttr(x)
end

function ObjCRequiresSuperAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCRequiresSuperAttr(x)
    p == C_NULL && _cast_failed(ObjCRequiresSuperAttr, x)
    return ObjCRequiresSuperAttr(p)
end

function isObjCReturnsInnerPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCReturnsInnerPointerAttr(x)
end

function ObjCReturnsInnerPointerAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCReturnsInnerPointerAttr(x)
    p == C_NULL && _cast_failed(ObjCReturnsInnerPointerAttr, x)
    return ObjCReturnsInnerPointerAttr(p)
end

function isObjCRootClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRootClassAttr(x)
end

function ObjCRootClassAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCRootClassAttr(x)
    p == C_NULL && _cast_failed(ObjCRootClassAttr, x)
    return ObjCRootClassAttr(p)
end

function isObjCSubclassingRestrictedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCSubclassingRestrictedAttr(x)
end

function ObjCSubclassingRestrictedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCSubclassingRestrictedAttr(x)
    p == C_NULL && _cast_failed(ObjCSubclassingRestrictedAttr, x)
    return ObjCSubclassingRestrictedAttr(p)
end

function isOpenCLIntelReqdSubGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLIntelReqdSubGroupSizeAttr(x)
end

function OpenCLIntelReqdSubGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLIntelReqdSubGroupSizeAttr(x)
    p == C_NULL && _cast_failed(OpenCLIntelReqdSubGroupSizeAttr, x)
    return OpenCLIntelReqdSubGroupSizeAttr(p)
end

function isOpenCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLKernelAttr(x)
end

function OpenCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLKernelAttr(x)
    p == C_NULL && _cast_failed(OpenCLKernelAttr, x)
    return OpenCLKernelAttr(p)
end

function isOptimizeNoneAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOptimizeNoneAttr(x)
end

function OptimizeNoneAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOptimizeNoneAttr(x)
    p == C_NULL && _cast_failed(OptimizeNoneAttr, x)
    return OptimizeNoneAttr(p)
end

function isOverrideAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOverrideAttr(x)
end

function OverrideAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOverrideAttr(x)
    p == C_NULL && _cast_failed(OverrideAttr, x)
    return OverrideAttr(p)
end

function isOwnerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOwnerAttr(x)
end

function OwnerAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOwnerAttr(x)
    p == C_NULL && _cast_failed(OwnerAttr, x)
    return OwnerAttr(p)
end

function isOwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOwnershipAttr(x)
end

function OwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOwnershipAttr(x)
    p == C_NULL && _cast_failed(OwnershipAttr, x)
    return OwnershipAttr(p)
end

function isPackedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPackedAttr(x)
end

function PackedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPackedAttr(x)
    p == C_NULL && _cast_failed(PackedAttr, x)
    return PackedAttr(p)
end

function isParamTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isParamTypestateAttr(x)
end

function ParamTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToParamTypestateAttr(x)
    p == C_NULL && _cast_failed(ParamTypestateAttr, x)
    return ParamTypestateAttr(p)
end

function isPatchableFunctionEntryAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPatchableFunctionEntryAttr(x)
end

function PatchableFunctionEntryAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPatchableFunctionEntryAttr(x)
    p == C_NULL && _cast_failed(PatchableFunctionEntryAttr, x)
    return PatchableFunctionEntryAttr(p)
end

function isPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPointerAttr(x)
end

function PointerAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPointerAttr(x)
    p == C_NULL && _cast_failed(PointerAttr, x)
    return PointerAttr(p)
end

function isPragmaClangBSSSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangBSSSectionAttr(x)
end

function PragmaClangBSSSectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPragmaClangBSSSectionAttr(x)
    p == C_NULL && _cast_failed(PragmaClangBSSSectionAttr, x)
    return PragmaClangBSSSectionAttr(p)
end

function isPragmaClangDataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangDataSectionAttr(x)
end

function PragmaClangDataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPragmaClangDataSectionAttr(x)
    p == C_NULL && _cast_failed(PragmaClangDataSectionAttr, x)
    return PragmaClangDataSectionAttr(p)
end

function isPragmaClangRelroSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangRelroSectionAttr(x)
end

function PragmaClangRelroSectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPragmaClangRelroSectionAttr(x)
    p == C_NULL && _cast_failed(PragmaClangRelroSectionAttr, x)
    return PragmaClangRelroSectionAttr(p)
end

function isPragmaClangRodataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangRodataSectionAttr(x)
end

function PragmaClangRodataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPragmaClangRodataSectionAttr(x)
    p == C_NULL && _cast_failed(PragmaClangRodataSectionAttr, x)
    return PragmaClangRodataSectionAttr(p)
end

function isPragmaClangTextSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangTextSectionAttr(x)
end

function PragmaClangTextSectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPragmaClangTextSectionAttr(x)
    p == C_NULL && _cast_failed(PragmaClangTextSectionAttr, x)
    return PragmaClangTextSectionAttr(p)
end

function isPreferredNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreferredNameAttr(x)
end

function PreferredNameAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPreferredNameAttr(x)
    p == C_NULL && _cast_failed(PreferredNameAttr, x)
    return PreferredNameAttr(p)
end

function isPreferredTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreferredTypeAttr(x)
end

function PreferredTypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPreferredTypeAttr(x)
    p == C_NULL && _cast_failed(PreferredTypeAttr, x)
    return PreferredTypeAttr(p)
end

function isPtGuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtGuardedByAttr(x)
end

function PtGuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPtGuardedByAttr(x)
    p == C_NULL && _cast_failed(PtGuardedByAttr, x)
    return PtGuardedByAttr(p)
end

function isPtGuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtGuardedVarAttr(x)
end

function PtGuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPtGuardedVarAttr(x)
    p == C_NULL && _cast_failed(PtGuardedVarAttr, x)
    return PtGuardedVarAttr(p)
end

function isPureAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPureAttr(x)
end

function PureAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToPureAttr(x)
    p == C_NULL && _cast_failed(PureAttr, x)
    return PureAttr(p)
end

function isRISCVInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRISCVInterruptAttr(x)
end

function RISCVInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRISCVInterruptAttr(x)
    p == C_NULL && _cast_failed(RISCVInterruptAttr, x)
    return RISCVInterruptAttr(p)
end

function isRandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRandomizeLayoutAttr(x)
end

function RandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRandomizeLayoutAttr(x)
    p == C_NULL && _cast_failed(RandomizeLayoutAttr, x)
    return RandomizeLayoutAttr(p)
end

function isReadOnlyPlacementAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReadOnlyPlacementAttr(x)
end

function ReadOnlyPlacementAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReadOnlyPlacementAttr(x)
    p == C_NULL && _cast_failed(ReadOnlyPlacementAttr, x)
    return ReadOnlyPlacementAttr(p)
end

function isReinitializesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReinitializesAttr(x)
end

function ReinitializesAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReinitializesAttr(x)
    p == C_NULL && _cast_failed(ReinitializesAttr, x)
    return ReinitializesAttr(p)
end

function isReleaseCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReleaseCapabilityAttr(x)
end

function ReleaseCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReleaseCapabilityAttr(x)
    p == C_NULL && _cast_failed(ReleaseCapabilityAttr, x)
    return ReleaseCapabilityAttr(p)
end

function isReqdWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReqdWorkGroupSizeAttr(x)
end

function ReqdWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReqdWorkGroupSizeAttr(x)
    p == C_NULL && _cast_failed(ReqdWorkGroupSizeAttr, x)
    return ReqdWorkGroupSizeAttr(p)
end

function isRequiresCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRequiresCapabilityAttr(x)
end

function RequiresCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRequiresCapabilityAttr(x)
    p == C_NULL && _cast_failed(RequiresCapabilityAttr, x)
    return RequiresCapabilityAttr(p)
end

function isRestrictAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRestrictAttr(x)
end

function RestrictAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRestrictAttr(x)
    p == C_NULL && _cast_failed(RestrictAttr, x)
    return RestrictAttr(p)
end

function isRetainAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRetainAttr(x)
end

function RetainAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRetainAttr(x)
    p == C_NULL && _cast_failed(RetainAttr, x)
    return RetainAttr(p)
end

function isReturnTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReturnTypestateAttr(x)
end

function ReturnTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReturnTypestateAttr(x)
    p == C_NULL && _cast_failed(ReturnTypestateAttr, x)
    return ReturnTypestateAttr(p)
end

function isReturnsNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReturnsNonNullAttr(x)
end

function ReturnsNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReturnsNonNullAttr(x)
    p == C_NULL && _cast_failed(ReturnsNonNullAttr, x)
    return ReturnsNonNullAttr(p)
end

function isReturnsTwiceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReturnsTwiceAttr(x)
end

function ReturnsTwiceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToReturnsTwiceAttr(x)
    p == C_NULL && _cast_failed(ReturnsTwiceAttr, x)
    return ReturnsTwiceAttr(p)
end

function isSYCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSYCLKernelAttr(x)
end

function SYCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSYCLKernelAttr(x)
    p == C_NULL && _cast_failed(SYCLKernelAttr, x)
    return SYCLKernelAttr(p)
end

function isSYCLSpecialClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSYCLSpecialClassAttr(x)
end

function SYCLSpecialClassAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSYCLSpecialClassAttr(x)
    p == C_NULL && _cast_failed(SYCLSpecialClassAttr, x)
    return SYCLSpecialClassAttr(p)
end

function isScopedLockableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isScopedLockableAttr(x)
end

function ScopedLockableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToScopedLockableAttr(x)
    p == C_NULL && _cast_failed(ScopedLockableAttr, x)
    return ScopedLockableAttr(p)
end

function isSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSectionAttr(x)
end

function SectionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSectionAttr(x)
    p == C_NULL && _cast_failed(SectionAttr, x)
    return SectionAttr(p)
end

function isSelectAnyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSelectAnyAttr(x)
end

function SelectAnyAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSelectAnyAttr(x)
    p == C_NULL && _cast_failed(SelectAnyAttr, x)
    return SelectAnyAttr(p)
end

function isSentinelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSentinelAttr(x)
end

function SentinelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSentinelAttr(x)
    p == C_NULL && _cast_failed(SentinelAttr, x)
    return SentinelAttr(p)
end

function isSetTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSetTypestateAttr(x)
end

function SetTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSetTypestateAttr(x)
    p == C_NULL && _cast_failed(SetTypestateAttr, x)
    return SetTypestateAttr(p)
end

function isSharedTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSharedTrylockFunctionAttr(x)
end

function SharedTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSharedTrylockFunctionAttr(x)
    p == C_NULL && _cast_failed(SharedTrylockFunctionAttr, x)
    return SharedTrylockFunctionAttr(p)
end

function isSpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSpeculativeLoadHardeningAttr(x)
end

function SpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSpeculativeLoadHardeningAttr(x)
    p == C_NULL && _cast_failed(SpeculativeLoadHardeningAttr, x)
    return SpeculativeLoadHardeningAttr(p)
end

function isStandaloneDebugAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStandaloneDebugAttr(x)
end

function StandaloneDebugAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToStandaloneDebugAttr(x)
    p == C_NULL && _cast_failed(StandaloneDebugAttr, x)
    return StandaloneDebugAttr(p)
end

function isStrictFPAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStrictFPAttr(x)
end

function StrictFPAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToStrictFPAttr(x)
    p == C_NULL && _cast_failed(StrictFPAttr, x)
    return StrictFPAttr(p)
end

function isStrictGuardStackCheckAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStrictGuardStackCheckAttr(x)
end

function StrictGuardStackCheckAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToStrictGuardStackCheckAttr(x)
    p == C_NULL && _cast_failed(StrictGuardStackCheckAttr, x)
    return StrictGuardStackCheckAttr(p)
end

function isSwiftAsyncAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncAttr(x)
end

function SwiftAsyncAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftAsyncAttr(x)
    p == C_NULL && _cast_failed(SwiftAsyncAttr, x)
    return SwiftAsyncAttr(p)
end

function isSwiftAsyncErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncErrorAttr(x)
end

function SwiftAsyncErrorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftAsyncErrorAttr(x)
    p == C_NULL && _cast_failed(SwiftAsyncErrorAttr, x)
    return SwiftAsyncErrorAttr(p)
end

function isSwiftAsyncNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncNameAttr(x)
end

function SwiftAsyncNameAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftAsyncNameAttr(x)
    p == C_NULL && _cast_failed(SwiftAsyncNameAttr, x)
    return SwiftAsyncNameAttr(p)
end

function isSwiftAttrAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAttrAttr(x)
end

function SwiftAttrAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftAttrAttr(x)
    p == C_NULL && _cast_failed(SwiftAttrAttr, x)
    return SwiftAttrAttr(p)
end

function isSwiftBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftBridgeAttr(x)
end

function SwiftBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftBridgeAttr(x)
    p == C_NULL && _cast_failed(SwiftBridgeAttr, x)
    return SwiftBridgeAttr(p)
end

function isSwiftBridgedTypedefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftBridgedTypedefAttr(x)
end

function SwiftBridgedTypedefAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftBridgedTypedefAttr(x)
    p == C_NULL && _cast_failed(SwiftBridgedTypedefAttr, x)
    return SwiftBridgedTypedefAttr(p)
end

function isSwiftErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftErrorAttr(x)
end

function SwiftErrorAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftErrorAttr(x)
    p == C_NULL && _cast_failed(SwiftErrorAttr, x)
    return SwiftErrorAttr(p)
end

function isSwiftImportAsNonGenericAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftImportAsNonGenericAttr(x)
end

function SwiftImportAsNonGenericAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftImportAsNonGenericAttr(x)
    p == C_NULL && _cast_failed(SwiftImportAsNonGenericAttr, x)
    return SwiftImportAsNonGenericAttr(p)
end

function isSwiftImportPropertyAsAccessorsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftImportPropertyAsAccessorsAttr(x)
end

function SwiftImportPropertyAsAccessorsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftImportPropertyAsAccessorsAttr(x)
    p == C_NULL && _cast_failed(SwiftImportPropertyAsAccessorsAttr, x)
    return SwiftImportPropertyAsAccessorsAttr(p)
end

function isSwiftNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftNameAttr(x)
end

function SwiftNameAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftNameAttr(x)
    p == C_NULL && _cast_failed(SwiftNameAttr, x)
    return SwiftNameAttr(p)
end

function isSwiftNewTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftNewTypeAttr(x)
end

function SwiftNewTypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftNewTypeAttr(x)
    p == C_NULL && _cast_failed(SwiftNewTypeAttr, x)
    return SwiftNewTypeAttr(p)
end

function isSwiftPrivateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftPrivateAttr(x)
end

function SwiftPrivateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftPrivateAttr(x)
    p == C_NULL && _cast_failed(SwiftPrivateAttr, x)
    return SwiftPrivateAttr(p)
end

function isTLSModelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTLSModelAttr(x)
end

function TLSModelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTLSModelAttr(x)
    p == C_NULL && _cast_failed(TLSModelAttr, x)
    return TLSModelAttr(p)
end

function isTargetAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTargetAttr(x)
end

function TargetAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTargetAttr(x)
    p == C_NULL && _cast_failed(TargetAttr, x)
    return TargetAttr(p)
end

function isTargetClonesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTargetClonesAttr(x)
end

function TargetClonesAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTargetClonesAttr(x)
    p == C_NULL && _cast_failed(TargetClonesAttr, x)
    return TargetClonesAttr(p)
end

function isTargetVersionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTargetVersionAttr(x)
end

function TargetVersionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTargetVersionAttr(x)
    p == C_NULL && _cast_failed(TargetVersionAttr, x)
    return TargetVersionAttr(p)
end

function isTestTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTestTypestateAttr(x)
end

function TestTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTestTypestateAttr(x)
    p == C_NULL && _cast_failed(TestTypestateAttr, x)
    return TestTypestateAttr(p)
end

function isTransparentUnionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTransparentUnionAttr(x)
end

function TransparentUnionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTransparentUnionAttr(x)
    p == C_NULL && _cast_failed(TransparentUnionAttr, x)
    return TransparentUnionAttr(p)
end

function isTrivialABIAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTrivialABIAttr(x)
end

function TrivialABIAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTrivialABIAttr(x)
    p == C_NULL && _cast_failed(TrivialABIAttr, x)
    return TrivialABIAttr(p)
end

function isTryAcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTryAcquireCapabilityAttr(x)
end

function TryAcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTryAcquireCapabilityAttr(x)
    p == C_NULL && _cast_failed(TryAcquireCapabilityAttr, x)
    return TryAcquireCapabilityAttr(p)
end

function isTypeTagForDatatypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeTagForDatatypeAttr(x)
end

function TypeTagForDatatypeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTypeTagForDatatypeAttr(x)
    p == C_NULL && _cast_failed(TypeTagForDatatypeAttr, x)
    return TypeTagForDatatypeAttr(p)
end

function isTypeVisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeVisibilityAttr(x)
end

function TypeVisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToTypeVisibilityAttr(x)
    p == C_NULL && _cast_failed(TypeVisibilityAttr, x)
    return TypeVisibilityAttr(p)
end

function isUnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnavailableAttr(x)
end

function UnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUnavailableAttr(x)
    p == C_NULL && _cast_failed(UnavailableAttr, x)
    return UnavailableAttr(p)
end

function isUninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUninitializedAttr(x)
end

function UninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUninitializedAttr(x)
    p == C_NULL && _cast_failed(UninitializedAttr, x)
    return UninitializedAttr(p)
end

function isUnsafeBufferUsageAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnsafeBufferUsageAttr(x)
end

function UnsafeBufferUsageAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUnsafeBufferUsageAttr(x)
    p == C_NULL && _cast_failed(UnsafeBufferUsageAttr, x)
    return UnsafeBufferUsageAttr(p)
end

function isUnusedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnusedAttr(x)
end

function UnusedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUnusedAttr(x)
    p == C_NULL && _cast_failed(UnusedAttr, x)
    return UnusedAttr(p)
end

function isUsedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUsedAttr(x)
end

function UsedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUsedAttr(x)
    p == C_NULL && _cast_failed(UsedAttr, x)
    return UsedAttr(p)
end

function isUsingIfExistsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUsingIfExistsAttr(x)
end

function UsingIfExistsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUsingIfExistsAttr(x)
    p == C_NULL && _cast_failed(UsingIfExistsAttr, x)
    return UsingIfExistsAttr(p)
end

function isUuidAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUuidAttr(x)
end

function UuidAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToUuidAttr(x)
    p == C_NULL && _cast_failed(UuidAttr, x)
    return UuidAttr(p)
end

function isVecReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVecReturnAttr(x)
end

function VecReturnAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToVecReturnAttr(x)
    p == C_NULL && _cast_failed(VecReturnAttr, x)
    return VecReturnAttr(p)
end

function isVecTypeHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVecTypeHintAttr(x)
end

function VecTypeHintAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToVecTypeHintAttr(x)
    p == C_NULL && _cast_failed(VecTypeHintAttr, x)
    return VecTypeHintAttr(p)
end

function isVisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVisibilityAttr(x)
end

function VisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToVisibilityAttr(x)
    p == C_NULL && _cast_failed(VisibilityAttr, x)
    return VisibilityAttr(p)
end

function isWarnUnusedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWarnUnusedAttr(x)
end

function WarnUnusedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWarnUnusedAttr(x)
    p == C_NULL && _cast_failed(WarnUnusedAttr, x)
    return WarnUnusedAttr(p)
end

function isWarnUnusedResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWarnUnusedResultAttr(x)
end

function WarnUnusedResultAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWarnUnusedResultAttr(x)
    p == C_NULL && _cast_failed(WarnUnusedResultAttr, x)
    return WarnUnusedResultAttr(p)
end

function isWeakAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWeakAttr(x)
end

function WeakAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWeakAttr(x)
    p == C_NULL && _cast_failed(WeakAttr, x)
    return WeakAttr(p)
end

function isWeakImportAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWeakImportAttr(x)
end

function WeakImportAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWeakImportAttr(x)
    p == C_NULL && _cast_failed(WeakImportAttr, x)
    return WeakImportAttr(p)
end

function isWeakRefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWeakRefAttr(x)
end

function WeakRefAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWeakRefAttr(x)
    p == C_NULL && _cast_failed(WeakRefAttr, x)
    return WeakRefAttr(p)
end

function isWebAssemblyExportNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyExportNameAttr(x)
end

function WebAssemblyExportNameAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWebAssemblyExportNameAttr(x)
    p == C_NULL && _cast_failed(WebAssemblyExportNameAttr, x)
    return WebAssemblyExportNameAttr(p)
end

function isWebAssemblyImportModuleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyImportModuleAttr(x)
end

function WebAssemblyImportModuleAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWebAssemblyImportModuleAttr(x)
    p == C_NULL && _cast_failed(WebAssemblyImportModuleAttr, x)
    return WebAssemblyImportModuleAttr(p)
end

function isWebAssemblyImportNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyImportNameAttr(x)
end

function WebAssemblyImportNameAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWebAssemblyImportNameAttr(x)
    p == C_NULL && _cast_failed(WebAssemblyImportNameAttr, x)
    return WebAssemblyImportNameAttr(p)
end

function isWorkGroupSizeHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWorkGroupSizeHintAttr(x)
end

function WorkGroupSizeHintAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToWorkGroupSizeHintAttr(x)
    p == C_NULL && _cast_failed(WorkGroupSizeHintAttr, x)
    return WorkGroupSizeHintAttr(p)
end

function isX86ForceAlignArgPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isX86ForceAlignArgPointerAttr(x)
end

function X86ForceAlignArgPointerAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToX86ForceAlignArgPointerAttr(x)
    p == C_NULL && _cast_failed(X86ForceAlignArgPointerAttr, x)
    return X86ForceAlignArgPointerAttr(p)
end

function isXRayInstrumentAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isXRayInstrumentAttr(x)
end

function XRayInstrumentAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToXRayInstrumentAttr(x)
    p == C_NULL && _cast_failed(XRayInstrumentAttr, x)
    return XRayInstrumentAttr(p)
end

function isXRayLogArgsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isXRayLogArgsAttr(x)
end

function XRayLogArgsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToXRayLogArgsAttr(x)
    p == C_NULL && _cast_failed(XRayLogArgsAttr, x)
    return XRayLogArgsAttr(p)
end

function isZeroCallUsedRegsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isZeroCallUsedRegsAttr(x)
end

function ZeroCallUsedRegsAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToZeroCallUsedRegsAttr(x)
    p == C_NULL && _cast_failed(ZeroCallUsedRegsAttr, x)
    return ZeroCallUsedRegsAttr(p)
end

function isAbiTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAbiTagAttr(x)
end

function AbiTagAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAbiTagAttr(x)
    p == C_NULL && _cast_failed(AbiTagAttr, x)
    return AbiTagAttr(p)
end

function isAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAliasAttr(x)
end

function AliasAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAliasAttr(x)
    p == C_NULL && _cast_failed(AliasAttr, x)
    return AliasAttr(p)
end

function isAlignValueAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignValueAttr(x)
end

function AlignValueAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToAlignValueAttr(x)
    p == C_NULL && _cast_failed(AlignValueAttr, x)
    return AlignValueAttr(p)
end

function isBuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBuiltinAliasAttr(x)
end

function BuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToBuiltinAliasAttr(x)
    p == C_NULL && _cast_failed(BuiltinAliasAttr, x)
    return BuiltinAliasAttr(p)
end

function isCalledOnceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCalledOnceAttr(x)
end

function CalledOnceAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToCalledOnceAttr(x)
    p == C_NULL && _cast_failed(CalledOnceAttr, x)
    return CalledOnceAttr(p)
end

function isIFuncAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIFuncAttr(x)
end

function IFuncAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToIFuncAttr(x)
    p == C_NULL && _cast_failed(IFuncAttr, x)
    return IFuncAttr(p)
end

function isInitSegAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInitSegAttr(x)
end

function InitSegAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToInitSegAttr(x)
    p == C_NULL && _cast_failed(InitSegAttr, x)
    return InitSegAttr(p)
end

function isLoaderUninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLoaderUninitializedAttr(x)
end

function LoaderUninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLoaderUninitializedAttr(x)
    p == C_NULL && _cast_failed(LoaderUninitializedAttr, x)
    return LoaderUninitializedAttr(p)
end

function isLoopHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLoopHintAttr(x)
end

function LoopHintAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToLoopHintAttr(x)
    p == C_NULL && _cast_failed(LoopHintAttr, x)
    return LoopHintAttr(p)
end

function isModeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isModeAttr(x)
end

function ModeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToModeAttr(x)
    p == C_NULL && _cast_failed(ModeAttr, x)
    return ModeAttr(p)
end

function isNoBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoBuiltinAttr(x)
end

function NoBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoBuiltinAttr(x)
    p == C_NULL && _cast_failed(NoBuiltinAttr, x)
    return NoBuiltinAttr(p)
end

function isNoEscapeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoEscapeAttr(x)
end

function NoEscapeAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToNoEscapeAttr(x)
    p == C_NULL && _cast_failed(NoEscapeAttr, x)
    return NoEscapeAttr(p)
end

function isOMPCaptureKindAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPCaptureKindAttr(x)
end

function OMPCaptureKindAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPCaptureKindAttr(x)
    p == C_NULL && _cast_failed(OMPCaptureKindAttr, x)
    return OMPCaptureKindAttr(p)
end

function isOMPDeclareSimdDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPDeclareSimdDeclAttr(x)
end

function OMPDeclareSimdDeclAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPDeclareSimdDeclAttr(x)
    p == C_NULL && _cast_failed(OMPDeclareSimdDeclAttr, x)
    return OMPDeclareSimdDeclAttr(p)
end

function isOMPReferencedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPReferencedVarAttr(x)
end

function OMPReferencedVarAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOMPReferencedVarAttr(x)
    p == C_NULL && _cast_failed(OMPReferencedVarAttr, x)
    return OMPReferencedVarAttr(p)
end

function isObjCBoxableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBoxableAttr(x)
end

function ObjCBoxableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCBoxableAttr(x)
    p == C_NULL && _cast_failed(ObjCBoxableAttr, x)
    return ObjCBoxableAttr(p)
end

function isObjCClassStubAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCClassStubAttr(x)
end

function ObjCClassStubAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCClassStubAttr(x)
    p == C_NULL && _cast_failed(ObjCClassStubAttr, x)
    return ObjCClassStubAttr(p)
end

function isObjCDesignatedInitializerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCDesignatedInitializerAttr(x)
end

function ObjCDesignatedInitializerAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCDesignatedInitializerAttr(x)
    p == C_NULL && _cast_failed(ObjCDesignatedInitializerAttr, x)
    return ObjCDesignatedInitializerAttr(p)
end

function isObjCDirectAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCDirectAttr(x)
end

function ObjCDirectAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCDirectAttr(x)
    p == C_NULL && _cast_failed(ObjCDirectAttr, x)
    return ObjCDirectAttr(p)
end

function isObjCDirectMembersAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCDirectMembersAttr(x)
end

function ObjCDirectMembersAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCDirectMembersAttr(x)
    p == C_NULL && _cast_failed(ObjCDirectMembersAttr, x)
    return ObjCDirectMembersAttr(p)
end

function isObjCNonLazyClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCNonLazyClassAttr(x)
end

function ObjCNonLazyClassAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCNonLazyClassAttr(x)
    p == C_NULL && _cast_failed(ObjCNonLazyClassAttr, x)
    return ObjCNonLazyClassAttr(p)
end

function isObjCNonRuntimeProtocolAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCNonRuntimeProtocolAttr(x)
end

function ObjCNonRuntimeProtocolAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCNonRuntimeProtocolAttr(x)
    p == C_NULL && _cast_failed(ObjCNonRuntimeProtocolAttr, x)
    return ObjCNonRuntimeProtocolAttr(p)
end

function isObjCRuntimeNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRuntimeNameAttr(x)
end

function ObjCRuntimeNameAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCRuntimeNameAttr(x)
    p == C_NULL && _cast_failed(ObjCRuntimeNameAttr, x)
    return ObjCRuntimeNameAttr(p)
end

function isObjCRuntimeVisibleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRuntimeVisibleAttr(x)
end

function ObjCRuntimeVisibleAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToObjCRuntimeVisibleAttr(x)
    p == C_NULL && _cast_failed(ObjCRuntimeVisibleAttr, x)
    return ObjCRuntimeVisibleAttr(p)
end

function isOpenCLAccessAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLAccessAttr(x)
end

function OpenCLAccessAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOpenCLAccessAttr(x)
    p == C_NULL && _cast_failed(OpenCLAccessAttr, x)
    return OpenCLAccessAttr(p)
end

function isOverloadableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOverloadableAttr(x)
end

function OverloadableAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToOverloadableAttr(x)
    p == C_NULL && _cast_failed(OverloadableAttr, x)
    return OverloadableAttr(p)
end

function isRenderScriptKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRenderScriptKernelAttr(x)
end

function RenderScriptKernelAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToRenderScriptKernelAttr(x)
    p == C_NULL && _cast_failed(RenderScriptKernelAttr, x)
    return RenderScriptKernelAttr(p)
end

function isSwiftObjCMembersAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftObjCMembersAttr(x)
end

function SwiftObjCMembersAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftObjCMembersAttr(x)
    p == C_NULL && _cast_failed(SwiftObjCMembersAttr, x)
    return SwiftObjCMembersAttr(p)
end

function isSwiftVersionedAdditionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftVersionedAdditionAttr(x)
end

function SwiftVersionedAdditionAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftVersionedAdditionAttr(x)
    p == C_NULL && _cast_failed(SwiftVersionedAdditionAttr, x)
    return SwiftVersionedAdditionAttr(p)
end

function isSwiftVersionedRemovalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftVersionedRemovalAttr(x)
end

function SwiftVersionedRemovalAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToSwiftVersionedRemovalAttr(x)
    p == C_NULL && _cast_failed(SwiftVersionedRemovalAttr, x)
    return SwiftVersionedRemovalAttr(p)
end

function isThreadAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isThreadAttr(x)
end

function ThreadAttr(x::AbstractAttr)
    @check_ptrs x
    p = clang_Attr_castToThreadAttr(x)
    p == C_NULL && _cast_failed(ThreadAttr, x)
    return ThreadAttr(p)
end

