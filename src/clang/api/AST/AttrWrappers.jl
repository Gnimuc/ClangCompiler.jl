# Generated from deps/ClangExtra/include/clang-ex/AST/AttrList.inc by gen/attr_nodes.jl — do not edit.
# Per-attribute downcast: the `is<Name>Attr` predicate and the `<Name>Attr`
# constructor-shaped cast (NULL carrier when the attribute is another class).
function isAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAddressSpaceAttr(x)
end

function AddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return AddressSpaceAttr(clang_Attr_castToAddressSpaceAttr(x))
end

function isAnnotateTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnnotateTypeAttr(x)
end

function AnnotateTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return AnnotateTypeAttr(clang_Attr_castToAnnotateTypeAttr(x))
end

function isArmInAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmInAttr(x)
end

function ArmInAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmInAttr(clang_Attr_castToArmInAttr(x))
end

function isArmInOutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmInOutAttr(x)
end

function ArmInOutAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmInOutAttr(clang_Attr_castToArmInOutAttr(x))
end

function isArmMveStrictPolymorphismAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmMveStrictPolymorphismAttr(x)
end

function ArmMveStrictPolymorphismAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmMveStrictPolymorphismAttr(clang_Attr_castToArmMveStrictPolymorphismAttr(x))
end

function isArmOutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmOutAttr(x)
end

function ArmOutAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmOutAttr(clang_Attr_castToArmOutAttr(x))
end

function isArmPreservesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmPreservesAttr(x)
end

function ArmPreservesAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmPreservesAttr(clang_Attr_castToArmPreservesAttr(x))
end

function isArmStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmStreamingAttr(x)
end

function ArmStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmStreamingAttr(clang_Attr_castToArmStreamingAttr(x))
end

function isArmStreamingCompatibleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmStreamingCompatibleAttr(x)
end

function ArmStreamingCompatibleAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmStreamingCompatibleAttr(clang_Attr_castToArmStreamingCompatibleAttr(x))
end

function isBTFTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBTFTypeTagAttr(x)
end

function BTFTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    return BTFTypeTagAttr(clang_Attr_castToBTFTypeTagAttr(x))
end

function isCmseNSCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCmseNSCallAttr(x)
end

function CmseNSCallAttr(x::AbstractAttr)
    @check_ptrs x
    return CmseNSCallAttr(clang_Attr_castToCmseNSCallAttr(x))
end

function isHLSLGroupSharedAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLGroupSharedAddressSpaceAttr(x)
end

function HLSLGroupSharedAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLGroupSharedAddressSpaceAttr(clang_Attr_castToHLSLGroupSharedAddressSpaceAttr(x))
end

function isHLSLParamModifierAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLParamModifierAttr(x)
end

function HLSLParamModifierAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLParamModifierAttr(clang_Attr_castToHLSLParamModifierAttr(x))
end

function isNoDerefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDerefAttr(x)
end

function NoDerefAttr(x::AbstractAttr)
    @check_ptrs x
    return NoDerefAttr(clang_Attr_castToNoDerefAttr(x))
end

function isObjCGCAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCGCAttr(x)
end

function ObjCGCAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCGCAttr(clang_Attr_castToObjCGCAttr(x))
end

function isObjCInertUnsafeUnretainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCInertUnsafeUnretainedAttr(x)
end

function ObjCInertUnsafeUnretainedAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCInertUnsafeUnretainedAttr(clang_Attr_castToObjCInertUnsafeUnretainedAttr(x))
end

function isObjCKindOfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCKindOfAttr(x)
end

function ObjCKindOfAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCKindOfAttr(clang_Attr_castToObjCKindOfAttr(x))
end

function isOpenCLConstantAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLConstantAddressSpaceAttr(x)
end

function OpenCLConstantAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLConstantAddressSpaceAttr(clang_Attr_castToOpenCLConstantAddressSpaceAttr(x))
end

function isOpenCLGenericAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGenericAddressSpaceAttr(x)
end

function OpenCLGenericAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLGenericAddressSpaceAttr(clang_Attr_castToOpenCLGenericAddressSpaceAttr(x))
end

function isOpenCLGlobalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGlobalAddressSpaceAttr(x)
end

function OpenCLGlobalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLGlobalAddressSpaceAttr(clang_Attr_castToOpenCLGlobalAddressSpaceAttr(x))
end

function isOpenCLGlobalDeviceAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGlobalDeviceAddressSpaceAttr(x)
end

function OpenCLGlobalDeviceAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLGlobalDeviceAddressSpaceAttr(clang_Attr_castToOpenCLGlobalDeviceAddressSpaceAttr(x))
end

function isOpenCLGlobalHostAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLGlobalHostAddressSpaceAttr(x)
end

function OpenCLGlobalHostAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLGlobalHostAddressSpaceAttr(clang_Attr_castToOpenCLGlobalHostAddressSpaceAttr(x))
end

function isOpenCLLocalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLLocalAddressSpaceAttr(x)
end

function OpenCLLocalAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLLocalAddressSpaceAttr(clang_Attr_castToOpenCLLocalAddressSpaceAttr(x))
end

function isOpenCLPrivateAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLPrivateAddressSpaceAttr(x)
end

function OpenCLPrivateAddressSpaceAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLPrivateAddressSpaceAttr(clang_Attr_castToOpenCLPrivateAddressSpaceAttr(x))
end

function isPtr32Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtr32Attr(x)
end

function Ptr32Attr(x::AbstractAttr)
    @check_ptrs x
    return Ptr32Attr(clang_Attr_castToPtr32Attr(x))
end

function isPtr64Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtr64Attr(x)
end

function Ptr64Attr(x::AbstractAttr)
    @check_ptrs x
    return Ptr64Attr(clang_Attr_castToPtr64Attr(x))
end

function isSPtrAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSPtrAttr(x)
end

function SPtrAttr(x::AbstractAttr)
    @check_ptrs x
    return SPtrAttr(clang_Attr_castToSPtrAttr(x))
end

function isTypeNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNonNullAttr(x)
end

function TypeNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return TypeNonNullAttr(clang_Attr_castToTypeNonNullAttr(x))
end

function isTypeNullUnspecifiedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNullUnspecifiedAttr(x)
end

function TypeNullUnspecifiedAttr(x::AbstractAttr)
    @check_ptrs x
    return TypeNullUnspecifiedAttr(clang_Attr_castToTypeNullUnspecifiedAttr(x))
end

function isTypeNullableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNullableAttr(x)
end

function TypeNullableAttr(x::AbstractAttr)
    @check_ptrs x
    return TypeNullableAttr(clang_Attr_castToTypeNullableAttr(x))
end

function isTypeNullableResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeNullableResultAttr(x)
end

function TypeNullableResultAttr(x::AbstractAttr)
    @check_ptrs x
    return TypeNullableResultAttr(clang_Attr_castToTypeNullableResultAttr(x))
end

function isUPtrAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUPtrAttr(x)
end

function UPtrAttr(x::AbstractAttr)
    @check_ptrs x
    return UPtrAttr(clang_Attr_castToUPtrAttr(x))
end

function isWebAssemblyFuncrefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyFuncrefAttr(x)
end

function WebAssemblyFuncrefAttr(x::AbstractAttr)
    @check_ptrs x
    return WebAssemblyFuncrefAttr(clang_Attr_castToWebAssemblyFuncrefAttr(x))
end

function isCodeAlignAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCodeAlignAttr(x)
end

function CodeAlignAttr(x::AbstractAttr)
    @check_ptrs x
    return CodeAlignAttr(clang_Attr_castToCodeAlignAttr(x))
end

function isFallThroughAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFallThroughAttr(x)
end

function FallThroughAttr(x::AbstractAttr)
    @check_ptrs x
    return FallThroughAttr(clang_Attr_castToFallThroughAttr(x))
end

function isLikelyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLikelyAttr(x)
end

function LikelyAttr(x::AbstractAttr)
    @check_ptrs x
    return LikelyAttr(clang_Attr_castToLikelyAttr(x))
end

function isMustTailAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMustTailAttr(x)
end

function MustTailAttr(x::AbstractAttr)
    @check_ptrs x
    return MustTailAttr(clang_Attr_castToMustTailAttr(x))
end

function isOpenCLUnrollHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLUnrollHintAttr(x)
end

function OpenCLUnrollHintAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLUnrollHintAttr(clang_Attr_castToOpenCLUnrollHintAttr(x))
end

function isUnlikelyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnlikelyAttr(x)
end

function UnlikelyAttr(x::AbstractAttr)
    @check_ptrs x
    return UnlikelyAttr(clang_Attr_castToUnlikelyAttr(x))
end

function isAlwaysInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlwaysInlineAttr(x)
end

function AlwaysInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return AlwaysInlineAttr(clang_Attr_castToAlwaysInlineAttr(x))
end

function isNoInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoInlineAttr(x)
end

function NoInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return NoInlineAttr(clang_Attr_castToNoInlineAttr(x))
end

function isNoMergeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoMergeAttr(x)
end

function NoMergeAttr(x::AbstractAttr)
    @check_ptrs x
    return NoMergeAttr(clang_Attr_castToNoMergeAttr(x))
end

function isSuppressAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSuppressAttr(x)
end

function SuppressAttr(x::AbstractAttr)
    @check_ptrs x
    return SuppressAttr(clang_Attr_castToSuppressAttr(x))
end

function isAArch64SVEPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAArch64SVEPcsAttr(x)
end

function AArch64SVEPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return AArch64SVEPcsAttr(clang_Attr_castToAArch64SVEPcsAttr(x))
end

function isAArch64VectorPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAArch64VectorPcsAttr(x)
end

function AArch64VectorPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return AArch64VectorPcsAttr(clang_Attr_castToAArch64VectorPcsAttr(x))
end

function isAMDGPUKernelCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUKernelCallAttr(x)
end

function AMDGPUKernelCallAttr(x::AbstractAttr)
    @check_ptrs x
    return AMDGPUKernelCallAttr(clang_Attr_castToAMDGPUKernelCallAttr(x))
end

function isAcquireHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquireHandleAttr(x)
end

function AcquireHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return AcquireHandleAttr(clang_Attr_castToAcquireHandleAttr(x))
end

function isAnyX86NoCfCheckAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnyX86NoCfCheckAttr(x)
end

function AnyX86NoCfCheckAttr(x::AbstractAttr)
    @check_ptrs x
    return AnyX86NoCfCheckAttr(clang_Attr_castToAnyX86NoCfCheckAttr(x))
end

function isCDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCDeclAttr(x)
end

function CDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return CDeclAttr(clang_Attr_castToCDeclAttr(x))
end

function isFastCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFastCallAttr(x)
end

function FastCallAttr(x::AbstractAttr)
    @check_ptrs x
    return FastCallAttr(clang_Attr_castToFastCallAttr(x))
end

function isIntelOclBiccAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIntelOclBiccAttr(x)
end

function IntelOclBiccAttr(x::AbstractAttr)
    @check_ptrs x
    return IntelOclBiccAttr(clang_Attr_castToIntelOclBiccAttr(x))
end

function isLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLifetimeBoundAttr(x)
end

function LifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return LifetimeBoundAttr(clang_Attr_castToLifetimeBoundAttr(x))
end

function isM68kRTDAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isM68kRTDAttr(x)
end

function M68kRTDAttr(x::AbstractAttr)
    @check_ptrs x
    return M68kRTDAttr(clang_Attr_castToM68kRTDAttr(x))
end

function isMSABIAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSABIAttr(x)
end

function MSABIAttr(x::AbstractAttr)
    @check_ptrs x
    return MSABIAttr(clang_Attr_castToMSABIAttr(x))
end

function isNSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSReturnsRetainedAttr(x)
end

function NSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return NSReturnsRetainedAttr(clang_Attr_castToNSReturnsRetainedAttr(x))
end

function isObjCOwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCOwnershipAttr(x)
end

function ObjCOwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCOwnershipAttr(clang_Attr_castToObjCOwnershipAttr(x))
end

function isPascalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPascalAttr(x)
end

function PascalAttr(x::AbstractAttr)
    @check_ptrs x
    return PascalAttr(clang_Attr_castToPascalAttr(x))
end

function isPcsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPcsAttr(x)
end

function PcsAttr(x::AbstractAttr)
    @check_ptrs x
    return PcsAttr(clang_Attr_castToPcsAttr(x))
end

function isPreserveAllAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreserveAllAttr(x)
end

function PreserveAllAttr(x::AbstractAttr)
    @check_ptrs x
    return PreserveAllAttr(clang_Attr_castToPreserveAllAttr(x))
end

function isPreserveMostAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreserveMostAttr(x)
end

function PreserveMostAttr(x::AbstractAttr)
    @check_ptrs x
    return PreserveMostAttr(clang_Attr_castToPreserveMostAttr(x))
end

function isRegCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRegCallAttr(x)
end

function RegCallAttr(x::AbstractAttr)
    @check_ptrs x
    return RegCallAttr(clang_Attr_castToRegCallAttr(x))
end

function isStdCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStdCallAttr(x)
end

function StdCallAttr(x::AbstractAttr)
    @check_ptrs x
    return StdCallAttr(clang_Attr_castToStdCallAttr(x))
end

function isSwiftAsyncCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncCallAttr(x)
end

function SwiftAsyncCallAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftAsyncCallAttr(clang_Attr_castToSwiftAsyncCallAttr(x))
end

function isSwiftCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftCallAttr(x)
end

function SwiftCallAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftCallAttr(clang_Attr_castToSwiftCallAttr(x))
end

function isSysVABIAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSysVABIAttr(x)
end

function SysVABIAttr(x::AbstractAttr)
    @check_ptrs x
    return SysVABIAttr(clang_Attr_castToSysVABIAttr(x))
end

function isThisCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isThisCallAttr(x)
end

function ThisCallAttr(x::AbstractAttr)
    @check_ptrs x
    return ThisCallAttr(clang_Attr_castToThisCallAttr(x))
end

function isVectorCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVectorCallAttr(x)
end

function VectorCallAttr(x::AbstractAttr)
    @check_ptrs x
    return VectorCallAttr(clang_Attr_castToVectorCallAttr(x))
end

function isSwiftAsyncContextAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncContextAttr(x)
end

function SwiftAsyncContextAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftAsyncContextAttr(clang_Attr_castToSwiftAsyncContextAttr(x))
end

function isSwiftContextAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftContextAttr(x)
end

function SwiftContextAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftContextAttr(clang_Attr_castToSwiftContextAttr(x))
end

function isSwiftErrorResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftErrorResultAttr(x)
end

function SwiftErrorResultAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftErrorResultAttr(clang_Attr_castToSwiftErrorResultAttr(x))
end

function isSwiftIndirectResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftIndirectResultAttr(x)
end

function SwiftIndirectResultAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftIndirectResultAttr(clang_Attr_castToSwiftIndirectResultAttr(x))
end

function isAnnotateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnnotateAttr(x)
end

function AnnotateAttr(x::AbstractAttr)
    @check_ptrs x
    return AnnotateAttr(clang_Attr_castToAnnotateAttr(x))
end

function isCFConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFConsumedAttr(x)
end

function CFConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return CFConsumedAttr(clang_Attr_castToCFConsumedAttr(x))
end

function isCarriesDependencyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCarriesDependencyAttr(x)
end

function CarriesDependencyAttr(x::AbstractAttr)
    @check_ptrs x
    return CarriesDependencyAttr(clang_Attr_castToCarriesDependencyAttr(x))
end

function isNSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSConsumedAttr(x)
end

function NSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return NSConsumedAttr(clang_Attr_castToNSConsumedAttr(x))
end

function isNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNonNullAttr(x)
end

function NonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return NonNullAttr(clang_Attr_castToNonNullAttr(x))
end

function isOSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSConsumedAttr(x)
end

function OSConsumedAttr(x::AbstractAttr)
    @check_ptrs x
    return OSConsumedAttr(clang_Attr_castToOSConsumedAttr(x))
end

function isPassObjectSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPassObjectSizeAttr(x)
end

function PassObjectSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return PassObjectSizeAttr(clang_Attr_castToPassObjectSizeAttr(x))
end

function isReleaseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReleaseHandleAttr(x)
end

function ReleaseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return ReleaseHandleAttr(clang_Attr_castToReleaseHandleAttr(x))
end

function isUseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUseHandleAttr(x)
end

function UseHandleAttr(x::AbstractAttr)
    @check_ptrs x
    return UseHandleAttr(clang_Attr_castToUseHandleAttr(x))
end

function isHLSLSV_DispatchThreadIDAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLSV_DispatchThreadIDAttr(x)
end

function HLSLSV_DispatchThreadIDAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLSV_DispatchThreadIDAttr(clang_Attr_castToHLSLSV_DispatchThreadIDAttr(x))
end

function isHLSLSV_GroupIndexAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLSV_GroupIndexAttr(x)
end

function HLSLSV_GroupIndexAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLSV_GroupIndexAttr(clang_Attr_castToHLSLSV_GroupIndexAttr(x))
end

function isAMDGPUFlatWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUFlatWorkGroupSizeAttr(x)
end

function AMDGPUFlatWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return AMDGPUFlatWorkGroupSizeAttr(clang_Attr_castToAMDGPUFlatWorkGroupSizeAttr(x))
end

function isAMDGPUNumSGPRAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUNumSGPRAttr(x)
end

function AMDGPUNumSGPRAttr(x::AbstractAttr)
    @check_ptrs x
    return AMDGPUNumSGPRAttr(clang_Attr_castToAMDGPUNumSGPRAttr(x))
end

function isAMDGPUNumVGPRAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUNumVGPRAttr(x)
end

function AMDGPUNumVGPRAttr(x::AbstractAttr)
    @check_ptrs x
    return AMDGPUNumVGPRAttr(clang_Attr_castToAMDGPUNumVGPRAttr(x))
end

function isAMDGPUWavesPerEUAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAMDGPUWavesPerEUAttr(x)
end

function AMDGPUWavesPerEUAttr(x::AbstractAttr)
    @check_ptrs x
    return AMDGPUWavesPerEUAttr(clang_Attr_castToAMDGPUWavesPerEUAttr(x))
end

function isARMInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isARMInterruptAttr(x)
end

function ARMInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return ARMInterruptAttr(clang_Attr_castToARMInterruptAttr(x))
end

function isAVRInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAVRInterruptAttr(x)
end

function AVRInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return AVRInterruptAttr(clang_Attr_castToAVRInterruptAttr(x))
end

function isAVRSignalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAVRSignalAttr(x)
end

function AVRSignalAttr(x::AbstractAttr)
    @check_ptrs x
    return AVRSignalAttr(clang_Attr_castToAVRSignalAttr(x))
end

function isAcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquireCapabilityAttr(x)
end

function AcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return AcquireCapabilityAttr(clang_Attr_castToAcquireCapabilityAttr(x))
end

function isAcquiredAfterAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquiredAfterAttr(x)
end

function AcquiredAfterAttr(x::AbstractAttr)
    @check_ptrs x
    return AcquiredAfterAttr(clang_Attr_castToAcquiredAfterAttr(x))
end

function isAcquiredBeforeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAcquiredBeforeAttr(x)
end

function AcquiredBeforeAttr(x::AbstractAttr)
    @check_ptrs x
    return AcquiredBeforeAttr(clang_Attr_castToAcquiredBeforeAttr(x))
end

function isAlignMac68kAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignMac68kAttr(x)
end

function AlignMac68kAttr(x::AbstractAttr)
    @check_ptrs x
    return AlignMac68kAttr(clang_Attr_castToAlignMac68kAttr(x))
end

function isAlignNaturalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignNaturalAttr(x)
end

function AlignNaturalAttr(x::AbstractAttr)
    @check_ptrs x
    return AlignNaturalAttr(clang_Attr_castToAlignNaturalAttr(x))
end

function isAlignedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignedAttr(x)
end

function AlignedAttr(x::AbstractAttr)
    @check_ptrs x
    return AlignedAttr(clang_Attr_castToAlignedAttr(x))
end

function isAllocAlignAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAllocAlignAttr(x)
end

function AllocAlignAttr(x::AbstractAttr)
    @check_ptrs x
    return AllocAlignAttr(clang_Attr_castToAllocAlignAttr(x))
end

function isAllocSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAllocSizeAttr(x)
end

function AllocSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return AllocSizeAttr(clang_Attr_castToAllocSizeAttr(x))
end

function isAlwaysDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlwaysDestroyAttr(x)
end

function AlwaysDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    return AlwaysDestroyAttr(clang_Attr_castToAlwaysDestroyAttr(x))
end

function isAnalyzerNoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnalyzerNoReturnAttr(x)
end

function AnalyzerNoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return AnalyzerNoReturnAttr(clang_Attr_castToAnalyzerNoReturnAttr(x))
end

function isAnyX86InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnyX86InterruptAttr(x)
end

function AnyX86InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return AnyX86InterruptAttr(clang_Attr_castToAnyX86InterruptAttr(x))
end

function isAnyX86NoCallerSavedRegistersAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAnyX86NoCallerSavedRegistersAttr(x)
end

function AnyX86NoCallerSavedRegistersAttr(x::AbstractAttr)
    @check_ptrs x
    return AnyX86NoCallerSavedRegistersAttr(clang_Attr_castToAnyX86NoCallerSavedRegistersAttr(x))
end

function isArcWeakrefUnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArcWeakrefUnavailableAttr(x)
end

function ArcWeakrefUnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    return ArcWeakrefUnavailableAttr(clang_Attr_castToArcWeakrefUnavailableAttr(x))
end

function isArgumentWithTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArgumentWithTypeTagAttr(x)
end

function ArgumentWithTypeTagAttr(x::AbstractAttr)
    @check_ptrs x
    return ArgumentWithTypeTagAttr(clang_Attr_castToArgumentWithTypeTagAttr(x))
end

function isArmBuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmBuiltinAliasAttr(x)
end

function ArmBuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmBuiltinAliasAttr(clang_Attr_castToArmBuiltinAliasAttr(x))
end

function isArmLocallyStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmLocallyStreamingAttr(x)
end

function ArmLocallyStreamingAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmLocallyStreamingAttr(clang_Attr_castToArmLocallyStreamingAttr(x))
end

function isArmNewAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArmNewAttr(x)
end

function ArmNewAttr(x::AbstractAttr)
    @check_ptrs x
    return ArmNewAttr(clang_Attr_castToArmNewAttr(x))
end

function isArtificialAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isArtificialAttr(x)
end

function ArtificialAttr(x::AbstractAttr)
    @check_ptrs x
    return ArtificialAttr(clang_Attr_castToArtificialAttr(x))
end

function isAsmLabelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAsmLabelAttr(x)
end

function AsmLabelAttr(x::AbstractAttr)
    @check_ptrs x
    return AsmLabelAttr(clang_Attr_castToAsmLabelAttr(x))
end

function isAssertCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssertCapabilityAttr(x)
end

function AssertCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return AssertCapabilityAttr(clang_Attr_castToAssertCapabilityAttr(x))
end

function isAssertExclusiveLockAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssertExclusiveLockAttr(x)
end

function AssertExclusiveLockAttr(x::AbstractAttr)
    @check_ptrs x
    return AssertExclusiveLockAttr(clang_Attr_castToAssertExclusiveLockAttr(x))
end

function isAssertSharedLockAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssertSharedLockAttr(x)
end

function AssertSharedLockAttr(x::AbstractAttr)
    @check_ptrs x
    return AssertSharedLockAttr(clang_Attr_castToAssertSharedLockAttr(x))
end

function isAssumeAlignedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssumeAlignedAttr(x)
end

function AssumeAlignedAttr(x::AbstractAttr)
    @check_ptrs x
    return AssumeAlignedAttr(clang_Attr_castToAssumeAlignedAttr(x))
end

function isAssumptionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAssumptionAttr(x)
end

function AssumptionAttr(x::AbstractAttr)
    @check_ptrs x
    return AssumptionAttr(clang_Attr_castToAssumptionAttr(x))
end

function isAvailabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAvailabilityAttr(x)
end

function AvailabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return AvailabilityAttr(clang_Attr_castToAvailabilityAttr(x))
end

function isAvailableOnlyInDefaultEvalMethodAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAvailableOnlyInDefaultEvalMethodAttr(x)
end

function AvailableOnlyInDefaultEvalMethodAttr(x::AbstractAttr)
    @check_ptrs x
    return AvailableOnlyInDefaultEvalMethodAttr(clang_Attr_castToAvailableOnlyInDefaultEvalMethodAttr(x))
end

function isBPFPreserveAccessIndexAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBPFPreserveAccessIndexAttr(x)
end

function BPFPreserveAccessIndexAttr(x::AbstractAttr)
    @check_ptrs x
    return BPFPreserveAccessIndexAttr(clang_Attr_castToBPFPreserveAccessIndexAttr(x))
end

function isBPFPreserveStaticOffsetAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBPFPreserveStaticOffsetAttr(x)
end

function BPFPreserveStaticOffsetAttr(x::AbstractAttr)
    @check_ptrs x
    return BPFPreserveStaticOffsetAttr(clang_Attr_castToBPFPreserveStaticOffsetAttr(x))
end

function isBTFDeclTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBTFDeclTagAttr(x)
end

function BTFDeclTagAttr(x::AbstractAttr)
    @check_ptrs x
    return BTFDeclTagAttr(clang_Attr_castToBTFDeclTagAttr(x))
end

function isBlocksAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBlocksAttr(x)
end

function BlocksAttr(x::AbstractAttr)
    @check_ptrs x
    return BlocksAttr(clang_Attr_castToBlocksAttr(x))
end

function isBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBuiltinAttr(x)
end

function BuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return BuiltinAttr(clang_Attr_castToBuiltinAttr(x))
end

function isC11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isC11NoReturnAttr(x)
end

function C11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return C11NoReturnAttr(clang_Attr_castToC11NoReturnAttr(x))
end

function isCFAuditedTransferAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFAuditedTransferAttr(x)
end

function CFAuditedTransferAttr(x::AbstractAttr)
    @check_ptrs x
    return CFAuditedTransferAttr(clang_Attr_castToCFAuditedTransferAttr(x))
end

function isCFGuardAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFGuardAttr(x)
end

function CFGuardAttr(x::AbstractAttr)
    @check_ptrs x
    return CFGuardAttr(clang_Attr_castToCFGuardAttr(x))
end

function isCFICanonicalJumpTableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFICanonicalJumpTableAttr(x)
end

function CFICanonicalJumpTableAttr(x::AbstractAttr)
    @check_ptrs x
    return CFICanonicalJumpTableAttr(clang_Attr_castToCFICanonicalJumpTableAttr(x))
end

function isCFReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFReturnsNotRetainedAttr(x)
end

function CFReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return CFReturnsNotRetainedAttr(clang_Attr_castToCFReturnsNotRetainedAttr(x))
end

function isCFReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFReturnsRetainedAttr(x)
end

function CFReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return CFReturnsRetainedAttr(clang_Attr_castToCFReturnsRetainedAttr(x))
end

function isCFUnknownTransferAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCFUnknownTransferAttr(x)
end

function CFUnknownTransferAttr(x::AbstractAttr)
    @check_ptrs x
    return CFUnknownTransferAttr(clang_Attr_castToCFUnknownTransferAttr(x))
end

function isCPUDispatchAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCPUDispatchAttr(x)
end

function CPUDispatchAttr(x::AbstractAttr)
    @check_ptrs x
    return CPUDispatchAttr(clang_Attr_castToCPUDispatchAttr(x))
end

function isCPUSpecificAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCPUSpecificAttr(x)
end

function CPUSpecificAttr(x::AbstractAttr)
    @check_ptrs x
    return CPUSpecificAttr(clang_Attr_castToCPUSpecificAttr(x))
end

function isCUDAConstantAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAConstantAttr(x)
end

function CUDAConstantAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDAConstantAttr(clang_Attr_castToCUDAConstantAttr(x))
end

function isCUDADeviceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDADeviceAttr(x)
end

function CUDADeviceAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDADeviceAttr(clang_Attr_castToCUDADeviceAttr(x))
end

function isCUDADeviceBuiltinSurfaceTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDADeviceBuiltinSurfaceTypeAttr(x)
end

function CUDADeviceBuiltinSurfaceTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDADeviceBuiltinSurfaceTypeAttr(clang_Attr_castToCUDADeviceBuiltinSurfaceTypeAttr(x))
end

function isCUDADeviceBuiltinTextureTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDADeviceBuiltinTextureTypeAttr(x)
end

function CUDADeviceBuiltinTextureTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDADeviceBuiltinTextureTypeAttr(clang_Attr_castToCUDADeviceBuiltinTextureTypeAttr(x))
end

function isCUDAGlobalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAGlobalAttr(x)
end

function CUDAGlobalAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDAGlobalAttr(clang_Attr_castToCUDAGlobalAttr(x))
end

function isCUDAHostAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAHostAttr(x)
end

function CUDAHostAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDAHostAttr(clang_Attr_castToCUDAHostAttr(x))
end

function isCUDAInvalidTargetAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDAInvalidTargetAttr(x)
end

function CUDAInvalidTargetAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDAInvalidTargetAttr(clang_Attr_castToCUDAInvalidTargetAttr(x))
end

function isCUDALaunchBoundsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDALaunchBoundsAttr(x)
end

function CUDALaunchBoundsAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDALaunchBoundsAttr(clang_Attr_castToCUDALaunchBoundsAttr(x))
end

function isCUDASharedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCUDASharedAttr(x)
end

function CUDASharedAttr(x::AbstractAttr)
    @check_ptrs x
    return CUDASharedAttr(clang_Attr_castToCUDASharedAttr(x))
end

function isCXX11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCXX11NoReturnAttr(x)
end

function CXX11NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return CXX11NoReturnAttr(clang_Attr_castToCXX11NoReturnAttr(x))
end

function isCallableWhenAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCallableWhenAttr(x)
end

function CallableWhenAttr(x::AbstractAttr)
    @check_ptrs x
    return CallableWhenAttr(clang_Attr_castToCallableWhenAttr(x))
end

function isCallbackAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCallbackAttr(x)
end

function CallbackAttr(x::AbstractAttr)
    @check_ptrs x
    return CallbackAttr(clang_Attr_castToCallbackAttr(x))
end

function isCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCapabilityAttr(x)
end

function CapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return CapabilityAttr(clang_Attr_castToCapabilityAttr(x))
end

function isCapturedRecordAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCapturedRecordAttr(x)
end

function CapturedRecordAttr(x::AbstractAttr)
    @check_ptrs x
    return CapturedRecordAttr(clang_Attr_castToCapturedRecordAttr(x))
end

function isCleanupAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCleanupAttr(x)
end

function CleanupAttr(x::AbstractAttr)
    @check_ptrs x
    return CleanupAttr(clang_Attr_castToCleanupAttr(x))
end

function isCmseNSEntryAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCmseNSEntryAttr(x)
end

function CmseNSEntryAttr(x::AbstractAttr)
    @check_ptrs x
    return CmseNSEntryAttr(clang_Attr_castToCmseNSEntryAttr(x))
end

function isCodeModelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCodeModelAttr(x)
end

function CodeModelAttr(x::AbstractAttr)
    @check_ptrs x
    return CodeModelAttr(clang_Attr_castToCodeModelAttr(x))
end

function isCodeSegAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCodeSegAttr(x)
end

function CodeSegAttr(x::AbstractAttr)
    @check_ptrs x
    return CodeSegAttr(clang_Attr_castToCodeSegAttr(x))
end

function isColdAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isColdAttr(x)
end

function ColdAttr(x::AbstractAttr)
    @check_ptrs x
    return ColdAttr(clang_Attr_castToColdAttr(x))
end

function isCommonAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCommonAttr(x)
end

function CommonAttr(x::AbstractAttr)
    @check_ptrs x
    return CommonAttr(clang_Attr_castToCommonAttr(x))
end

function isConstAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConstAttr(x)
end

function ConstAttr(x::AbstractAttr)
    @check_ptrs x
    return ConstAttr(clang_Attr_castToConstAttr(x))
end

function isConstInitAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConstInitAttr(x)
end

function ConstInitAttr(x::AbstractAttr)
    @check_ptrs x
    return ConstInitAttr(clang_Attr_castToConstInitAttr(x))
end

function isConstructorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConstructorAttr(x)
end

function ConstructorAttr(x::AbstractAttr)
    @check_ptrs x
    return ConstructorAttr(clang_Attr_castToConstructorAttr(x))
end

function isConsumableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConsumableAttr(x)
end

function ConsumableAttr(x::AbstractAttr)
    @check_ptrs x
    return ConsumableAttr(clang_Attr_castToConsumableAttr(x))
end

function isConsumableAutoCastAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConsumableAutoCastAttr(x)
end

function ConsumableAutoCastAttr(x::AbstractAttr)
    @check_ptrs x
    return ConsumableAutoCastAttr(clang_Attr_castToConsumableAutoCastAttr(x))
end

function isConsumableSetOnReadAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConsumableSetOnReadAttr(x)
end

function ConsumableSetOnReadAttr(x::AbstractAttr)
    @check_ptrs x
    return ConsumableSetOnReadAttr(clang_Attr_castToConsumableSetOnReadAttr(x))
end

function isConvergentAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isConvergentAttr(x)
end

function ConvergentAttr(x::AbstractAttr)
    @check_ptrs x
    return ConvergentAttr(clang_Attr_castToConvergentAttr(x))
end

function isCoroDisableLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroDisableLifetimeBoundAttr(x)
end

function CoroDisableLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return CoroDisableLifetimeBoundAttr(clang_Attr_castToCoroDisableLifetimeBoundAttr(x))
end

function isCoroLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroLifetimeBoundAttr(x)
end

function CoroLifetimeBoundAttr(x::AbstractAttr)
    @check_ptrs x
    return CoroLifetimeBoundAttr(clang_Attr_castToCoroLifetimeBoundAttr(x))
end

function isCoroOnlyDestroyWhenCompleteAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroOnlyDestroyWhenCompleteAttr(x)
end

function CoroOnlyDestroyWhenCompleteAttr(x::AbstractAttr)
    @check_ptrs x
    return CoroOnlyDestroyWhenCompleteAttr(clang_Attr_castToCoroOnlyDestroyWhenCompleteAttr(x))
end

function isCoroReturnTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroReturnTypeAttr(x)
end

function CoroReturnTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return CoroReturnTypeAttr(clang_Attr_castToCoroReturnTypeAttr(x))
end

function isCoroWrapperAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCoroWrapperAttr(x)
end

function CoroWrapperAttr(x::AbstractAttr)
    @check_ptrs x
    return CoroWrapperAttr(clang_Attr_castToCoroWrapperAttr(x))
end

function isCountedByAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCountedByAttr(x)
end

function CountedByAttr(x::AbstractAttr)
    @check_ptrs x
    return CountedByAttr(clang_Attr_castToCountedByAttr(x))
end

function isDLLExportAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLExportAttr(x)
end

function DLLExportAttr(x::AbstractAttr)
    @check_ptrs x
    return DLLExportAttr(clang_Attr_castToDLLExportAttr(x))
end

function isDLLExportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLExportStaticLocalAttr(x)
end

function DLLExportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    return DLLExportStaticLocalAttr(clang_Attr_castToDLLExportStaticLocalAttr(x))
end

function isDLLImportAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLImportAttr(x)
end

function DLLImportAttr(x::AbstractAttr)
    @check_ptrs x
    return DLLImportAttr(clang_Attr_castToDLLImportAttr(x))
end

function isDLLImportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDLLImportStaticLocalAttr(x)
end

function DLLImportStaticLocalAttr(x::AbstractAttr)
    @check_ptrs x
    return DLLImportStaticLocalAttr(clang_Attr_castToDLLImportStaticLocalAttr(x))
end

function isDeprecatedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDeprecatedAttr(x)
end

function DeprecatedAttr(x::AbstractAttr)
    @check_ptrs x
    return DeprecatedAttr(clang_Attr_castToDeprecatedAttr(x))
end

function isDestructorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDestructorAttr(x)
end

function DestructorAttr(x::AbstractAttr)
    @check_ptrs x
    return DestructorAttr(clang_Attr_castToDestructorAttr(x))
end

function isDiagnoseAsBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDiagnoseAsBuiltinAttr(x)
end

function DiagnoseAsBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return DiagnoseAsBuiltinAttr(clang_Attr_castToDiagnoseAsBuiltinAttr(x))
end

function isDiagnoseIfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDiagnoseIfAttr(x)
end

function DiagnoseIfAttr(x::AbstractAttr)
    @check_ptrs x
    return DiagnoseIfAttr(clang_Attr_castToDiagnoseIfAttr(x))
end

function isDisableSanitizerInstrumentationAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDisableSanitizerInstrumentationAttr(x)
end

function DisableSanitizerInstrumentationAttr(x::AbstractAttr)
    @check_ptrs x
    return DisableSanitizerInstrumentationAttr(clang_Attr_castToDisableSanitizerInstrumentationAttr(x))
end

function isDisableTailCallsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isDisableTailCallsAttr(x)
end

function DisableTailCallsAttr(x::AbstractAttr)
    @check_ptrs x
    return DisableTailCallsAttr(clang_Attr_castToDisableTailCallsAttr(x))
end

function isEmptyBasesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEmptyBasesAttr(x)
end

function EmptyBasesAttr(x::AbstractAttr)
    @check_ptrs x
    return EmptyBasesAttr(clang_Attr_castToEmptyBasesAttr(x))
end

function isEnableIfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnableIfAttr(x)
end

function EnableIfAttr(x::AbstractAttr)
    @check_ptrs x
    return EnableIfAttr(clang_Attr_castToEnableIfAttr(x))
end

function isEnforceTCBAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnforceTCBAttr(x)
end

function EnforceTCBAttr(x::AbstractAttr)
    @check_ptrs x
    return EnforceTCBAttr(clang_Attr_castToEnforceTCBAttr(x))
end

function isEnforceTCBLeafAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnforceTCBLeafAttr(x)
end

function EnforceTCBLeafAttr(x::AbstractAttr)
    @check_ptrs x
    return EnforceTCBLeafAttr(clang_Attr_castToEnforceTCBLeafAttr(x))
end

function isEnumExtensibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isEnumExtensibilityAttr(x)
end

function EnumExtensibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return EnumExtensibilityAttr(clang_Attr_castToEnumExtensibilityAttr(x))
end

function isErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isErrorAttr(x)
end

function ErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return ErrorAttr(clang_Attr_castToErrorAttr(x))
end

function isExcludeFromExplicitInstantiationAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isExcludeFromExplicitInstantiationAttr(x)
end

function ExcludeFromExplicitInstantiationAttr(x::AbstractAttr)
    @check_ptrs x
    return ExcludeFromExplicitInstantiationAttr(clang_Attr_castToExcludeFromExplicitInstantiationAttr(x))
end

function isExclusiveTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isExclusiveTrylockFunctionAttr(x)
end

function ExclusiveTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return ExclusiveTrylockFunctionAttr(clang_Attr_castToExclusiveTrylockFunctionAttr(x))
end

function isExternalSourceSymbolAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isExternalSourceSymbolAttr(x)
end

function ExternalSourceSymbolAttr(x::AbstractAttr)
    @check_ptrs x
    return ExternalSourceSymbolAttr(clang_Attr_castToExternalSourceSymbolAttr(x))
end

function isFinalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFinalAttr(x)
end

function FinalAttr(x::AbstractAttr)
    @check_ptrs x
    return FinalAttr(clang_Attr_castToFinalAttr(x))
end

function isFlagEnumAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFlagEnumAttr(x)
end

function FlagEnumAttr(x::AbstractAttr)
    @check_ptrs x
    return FlagEnumAttr(clang_Attr_castToFlagEnumAttr(x))
end

function isFlattenAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFlattenAttr(x)
end

function FlattenAttr(x::AbstractAttr)
    @check_ptrs x
    return FlattenAttr(clang_Attr_castToFlattenAttr(x))
end

function isFormatAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFormatAttr(x)
end

function FormatAttr(x::AbstractAttr)
    @check_ptrs x
    return FormatAttr(clang_Attr_castToFormatAttr(x))
end

function isFormatArgAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFormatArgAttr(x)
end

function FormatArgAttr(x::AbstractAttr)
    @check_ptrs x
    return FormatArgAttr(clang_Attr_castToFormatArgAttr(x))
end

function isFunctionReturnThunksAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isFunctionReturnThunksAttr(x)
end

function FunctionReturnThunksAttr(x::AbstractAttr)
    @check_ptrs x
    return FunctionReturnThunksAttr(clang_Attr_castToFunctionReturnThunksAttr(x))
end

function isGNUInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isGNUInlineAttr(x)
end

function GNUInlineAttr(x::AbstractAttr)
    @check_ptrs x
    return GNUInlineAttr(clang_Attr_castToGNUInlineAttr(x))
end

function isGuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isGuardedByAttr(x)
end

function GuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    return GuardedByAttr(clang_Attr_castToGuardedByAttr(x))
end

function isGuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isGuardedVarAttr(x)
end

function GuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return GuardedVarAttr(clang_Attr_castToGuardedVarAttr(x))
end

function isHIPManagedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHIPManagedAttr(x)
end

function HIPManagedAttr(x::AbstractAttr)
    @check_ptrs x
    return HIPManagedAttr(clang_Attr_castToHIPManagedAttr(x))
end

function isHLSLNumThreadsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLNumThreadsAttr(x)
end

function HLSLNumThreadsAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLNumThreadsAttr(clang_Attr_castToHLSLNumThreadsAttr(x))
end

function isHLSLResourceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLResourceAttr(x)
end

function HLSLResourceAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLResourceAttr(clang_Attr_castToHLSLResourceAttr(x))
end

function isHLSLResourceBindingAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLResourceBindingAttr(x)
end

function HLSLResourceBindingAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLResourceBindingAttr(clang_Attr_castToHLSLResourceBindingAttr(x))
end

function isHLSLShaderAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHLSLShaderAttr(x)
end

function HLSLShaderAttr(x::AbstractAttr)
    @check_ptrs x
    return HLSLShaderAttr(clang_Attr_castToHLSLShaderAttr(x))
end

function isHotAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isHotAttr(x)
end

function HotAttr(x::AbstractAttr)
    @check_ptrs x
    return HotAttr(clang_Attr_castToHotAttr(x))
end

function isIBActionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIBActionAttr(x)
end

function IBActionAttr(x::AbstractAttr)
    @check_ptrs x
    return IBActionAttr(clang_Attr_castToIBActionAttr(x))
end

function isIBOutletAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIBOutletAttr(x)
end

function IBOutletAttr(x::AbstractAttr)
    @check_ptrs x
    return IBOutletAttr(clang_Attr_castToIBOutletAttr(x))
end

function isIBOutletCollectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIBOutletCollectionAttr(x)
end

function IBOutletCollectionAttr(x::AbstractAttr)
    @check_ptrs x
    return IBOutletCollectionAttr(clang_Attr_castToIBOutletCollectionAttr(x))
end

function isInitPriorityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInitPriorityAttr(x)
end

function InitPriorityAttr(x::AbstractAttr)
    @check_ptrs x
    return InitPriorityAttr(clang_Attr_castToInitPriorityAttr(x))
end

function isInternalLinkageAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInternalLinkageAttr(x)
end

function InternalLinkageAttr(x::AbstractAttr)
    @check_ptrs x
    return InternalLinkageAttr(clang_Attr_castToInternalLinkageAttr(x))
end

function isLTOVisibilityPublicAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLTOVisibilityPublicAttr(x)
end

function LTOVisibilityPublicAttr(x::AbstractAttr)
    @check_ptrs x
    return LTOVisibilityPublicAttr(clang_Attr_castToLTOVisibilityPublicAttr(x))
end

function isLayoutVersionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLayoutVersionAttr(x)
end

function LayoutVersionAttr(x::AbstractAttr)
    @check_ptrs x
    return LayoutVersionAttr(clang_Attr_castToLayoutVersionAttr(x))
end

function isLeafAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLeafAttr(x)
end

function LeafAttr(x::AbstractAttr)
    @check_ptrs x
    return LeafAttr(clang_Attr_castToLeafAttr(x))
end

function isLockReturnedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLockReturnedAttr(x)
end

function LockReturnedAttr(x::AbstractAttr)
    @check_ptrs x
    return LockReturnedAttr(clang_Attr_castToLockReturnedAttr(x))
end

function isLocksExcludedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLocksExcludedAttr(x)
end

function LocksExcludedAttr(x::AbstractAttr)
    @check_ptrs x
    return LocksExcludedAttr(clang_Attr_castToLocksExcludedAttr(x))
end

function isM68kInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isM68kInterruptAttr(x)
end

function M68kInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return M68kInterruptAttr(clang_Attr_castToM68kInterruptAttr(x))
end

function isMIGServerRoutineAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMIGServerRoutineAttr(x)
end

function MIGServerRoutineAttr(x::AbstractAttr)
    @check_ptrs x
    return MIGServerRoutineAttr(clang_Attr_castToMIGServerRoutineAttr(x))
end

function isMSAllocatorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSAllocatorAttr(x)
end

function MSAllocatorAttr(x::AbstractAttr)
    @check_ptrs x
    return MSAllocatorAttr(clang_Attr_castToMSAllocatorAttr(x))
end

function isMSConstexprAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSConstexprAttr(x)
end

function MSConstexprAttr(x::AbstractAttr)
    @check_ptrs x
    return MSConstexprAttr(clang_Attr_castToMSConstexprAttr(x))
end

function isMSInheritanceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSInheritanceAttr(x)
end

function MSInheritanceAttr(x::AbstractAttr)
    @check_ptrs x
    return MSInheritanceAttr(clang_Attr_castToMSInheritanceAttr(x))
end

function isMSNoVTableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSNoVTableAttr(x)
end

function MSNoVTableAttr(x::AbstractAttr)
    @check_ptrs x
    return MSNoVTableAttr(clang_Attr_castToMSNoVTableAttr(x))
end

function isMSP430InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSP430InterruptAttr(x)
end

function MSP430InterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return MSP430InterruptAttr(clang_Attr_castToMSP430InterruptAttr(x))
end

function isMSStructAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSStructAttr(x)
end

function MSStructAttr(x::AbstractAttr)
    @check_ptrs x
    return MSStructAttr(clang_Attr_castToMSStructAttr(x))
end

function isMSVtorDispAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMSVtorDispAttr(x)
end

function MSVtorDispAttr(x::AbstractAttr)
    @check_ptrs x
    return MSVtorDispAttr(clang_Attr_castToMSVtorDispAttr(x))
end

function isMaxFieldAlignmentAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMaxFieldAlignmentAttr(x)
end

function MaxFieldAlignmentAttr(x::AbstractAttr)
    @check_ptrs x
    return MaxFieldAlignmentAttr(clang_Attr_castToMaxFieldAlignmentAttr(x))
end

function isMayAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMayAliasAttr(x)
end

function MayAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return MayAliasAttr(clang_Attr_castToMayAliasAttr(x))
end

function isMaybeUndefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMaybeUndefAttr(x)
end

function MaybeUndefAttr(x::AbstractAttr)
    @check_ptrs x
    return MaybeUndefAttr(clang_Attr_castToMaybeUndefAttr(x))
end

function isMicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMicroMipsAttr(x)
end

function MicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    return MicroMipsAttr(clang_Attr_castToMicroMipsAttr(x))
end

function isMinSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMinSizeAttr(x)
end

function MinSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return MinSizeAttr(clang_Attr_castToMinSizeAttr(x))
end

function isMinVectorWidthAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMinVectorWidthAttr(x)
end

function MinVectorWidthAttr(x::AbstractAttr)
    @check_ptrs x
    return MinVectorWidthAttr(clang_Attr_castToMinVectorWidthAttr(x))
end

function isMips16Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMips16Attr(x)
end

function Mips16Attr(x::AbstractAttr)
    @check_ptrs x
    return Mips16Attr(clang_Attr_castToMips16Attr(x))
end

function isMipsInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMipsInterruptAttr(x)
end

function MipsInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return MipsInterruptAttr(clang_Attr_castToMipsInterruptAttr(x))
end

function isMipsLongCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMipsLongCallAttr(x)
end

function MipsLongCallAttr(x::AbstractAttr)
    @check_ptrs x
    return MipsLongCallAttr(clang_Attr_castToMipsLongCallAttr(x))
end

function isMipsShortCallAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isMipsShortCallAttr(x)
end

function MipsShortCallAttr(x::AbstractAttr)
    @check_ptrs x
    return MipsShortCallAttr(clang_Attr_castToMipsShortCallAttr(x))
end

function isNSConsumesSelfAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSConsumesSelfAttr(x)
end

function NSConsumesSelfAttr(x::AbstractAttr)
    @check_ptrs x
    return NSConsumesSelfAttr(clang_Attr_castToNSConsumesSelfAttr(x))
end

function isNSErrorDomainAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSErrorDomainAttr(x)
end

function NSErrorDomainAttr(x::AbstractAttr)
    @check_ptrs x
    return NSErrorDomainAttr(clang_Attr_castToNSErrorDomainAttr(x))
end

function isNSReturnsAutoreleasedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSReturnsAutoreleasedAttr(x)
end

function NSReturnsAutoreleasedAttr(x::AbstractAttr)
    @check_ptrs x
    return NSReturnsAutoreleasedAttr(clang_Attr_castToNSReturnsAutoreleasedAttr(x))
end

function isNSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNSReturnsNotRetainedAttr(x)
end

function NSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return NSReturnsNotRetainedAttr(clang_Attr_castToNSReturnsNotRetainedAttr(x))
end

function isNVPTXKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNVPTXKernelAttr(x)
end

function NVPTXKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return NVPTXKernelAttr(clang_Attr_castToNVPTXKernelAttr(x))
end

function isNakedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNakedAttr(x)
end

function NakedAttr(x::AbstractAttr)
    @check_ptrs x
    return NakedAttr(clang_Attr_castToNakedAttr(x))
end

function isNoAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoAliasAttr(x)
end

function NoAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return NoAliasAttr(clang_Attr_castToNoAliasAttr(x))
end

function isNoCommonAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoCommonAttr(x)
end

function NoCommonAttr(x::AbstractAttr)
    @check_ptrs x
    return NoCommonAttr(clang_Attr_castToNoCommonAttr(x))
end

function isNoDebugAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDebugAttr(x)
end

function NoDebugAttr(x::AbstractAttr)
    @check_ptrs x
    return NoDebugAttr(clang_Attr_castToNoDebugAttr(x))
end

function isNoDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDestroyAttr(x)
end

function NoDestroyAttr(x::AbstractAttr)
    @check_ptrs x
    return NoDestroyAttr(clang_Attr_castToNoDestroyAttr(x))
end

function isNoDuplicateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoDuplicateAttr(x)
end

function NoDuplicateAttr(x::AbstractAttr)
    @check_ptrs x
    return NoDuplicateAttr(clang_Attr_castToNoDuplicateAttr(x))
end

function isNoInstrumentFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoInstrumentFunctionAttr(x)
end

function NoInstrumentFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return NoInstrumentFunctionAttr(clang_Attr_castToNoInstrumentFunctionAttr(x))
end

function isNoMicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoMicroMipsAttr(x)
end

function NoMicroMipsAttr(x::AbstractAttr)
    @check_ptrs x
    return NoMicroMipsAttr(clang_Attr_castToNoMicroMipsAttr(x))
end

function isNoMips16Attr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoMips16Attr(x)
end

function NoMips16Attr(x::AbstractAttr)
    @check_ptrs x
    return NoMips16Attr(clang_Attr_castToNoMips16Attr(x))
end

function isNoProfileFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoProfileFunctionAttr(x)
end

function NoProfileFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return NoProfileFunctionAttr(clang_Attr_castToNoProfileFunctionAttr(x))
end

function isNoRandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoRandomizeLayoutAttr(x)
end

function NoRandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    return NoRandomizeLayoutAttr(clang_Attr_castToNoRandomizeLayoutAttr(x))
end

function isNoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoReturnAttr(x)
end

function NoReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return NoReturnAttr(clang_Attr_castToNoReturnAttr(x))
end

function isNoSanitizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoSanitizeAttr(x)
end

function NoSanitizeAttr(x::AbstractAttr)
    @check_ptrs x
    return NoSanitizeAttr(clang_Attr_castToNoSanitizeAttr(x))
end

function isNoSpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoSpeculativeLoadHardeningAttr(x)
end

function NoSpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    return NoSpeculativeLoadHardeningAttr(clang_Attr_castToNoSpeculativeLoadHardeningAttr(x))
end

function isNoSplitStackAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoSplitStackAttr(x)
end

function NoSplitStackAttr(x::AbstractAttr)
    @check_ptrs x
    return NoSplitStackAttr(clang_Attr_castToNoSplitStackAttr(x))
end

function isNoStackProtectorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoStackProtectorAttr(x)
end

function NoStackProtectorAttr(x::AbstractAttr)
    @check_ptrs x
    return NoStackProtectorAttr(clang_Attr_castToNoStackProtectorAttr(x))
end

function isNoThreadSafetyAnalysisAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoThreadSafetyAnalysisAttr(x)
end

function NoThreadSafetyAnalysisAttr(x::AbstractAttr)
    @check_ptrs x
    return NoThreadSafetyAnalysisAttr(clang_Attr_castToNoThreadSafetyAnalysisAttr(x))
end

function isNoThrowAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoThrowAttr(x)
end

function NoThrowAttr(x::AbstractAttr)
    @check_ptrs x
    return NoThrowAttr(clang_Attr_castToNoThrowAttr(x))
end

function isNoUniqueAddressAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoUniqueAddressAttr(x)
end

function NoUniqueAddressAttr(x::AbstractAttr)
    @check_ptrs x
    return NoUniqueAddressAttr(clang_Attr_castToNoUniqueAddressAttr(x))
end

function isNoUwtableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoUwtableAttr(x)
end

function NoUwtableAttr(x::AbstractAttr)
    @check_ptrs x
    return NoUwtableAttr(clang_Attr_castToNoUwtableAttr(x))
end

function isNotTailCalledAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNotTailCalledAttr(x)
end

function NotTailCalledAttr(x::AbstractAttr)
    @check_ptrs x
    return NotTailCalledAttr(clang_Attr_castToNotTailCalledAttr(x))
end

function isOMPAllocateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPAllocateDeclAttr(x)
end

function OMPAllocateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPAllocateDeclAttr(clang_Attr_castToOMPAllocateDeclAttr(x))
end

function isOMPCaptureNoInitAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPCaptureNoInitAttr(x)
end

function OMPCaptureNoInitAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPCaptureNoInitAttr(clang_Attr_castToOMPCaptureNoInitAttr(x))
end

function isOMPDeclareTargetDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPDeclareTargetDeclAttr(x)
end

function OMPDeclareTargetDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPDeclareTargetDeclAttr(clang_Attr_castToOMPDeclareTargetDeclAttr(x))
end

function isOMPDeclareVariantAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPDeclareVariantAttr(x)
end

function OMPDeclareVariantAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPDeclareVariantAttr(clang_Attr_castToOMPDeclareVariantAttr(x))
end

function isOMPThreadPrivateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPThreadPrivateDeclAttr(x)
end

function OMPThreadPrivateDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPThreadPrivateDeclAttr(clang_Attr_castToOMPThreadPrivateDeclAttr(x))
end

function isOSConsumesThisAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSConsumesThisAttr(x)
end

function OSConsumesThisAttr(x::AbstractAttr)
    @check_ptrs x
    return OSConsumesThisAttr(clang_Attr_castToOSConsumesThisAttr(x))
end

function isOSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsNotRetainedAttr(x)
end

function OSReturnsNotRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return OSReturnsNotRetainedAttr(clang_Attr_castToOSReturnsNotRetainedAttr(x))
end

function isOSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsRetainedAttr(x)
end

function OSReturnsRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return OSReturnsRetainedAttr(clang_Attr_castToOSReturnsRetainedAttr(x))
end

function isOSReturnsRetainedOnNonZeroAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsRetainedOnNonZeroAttr(x)
end

function OSReturnsRetainedOnNonZeroAttr(x::AbstractAttr)
    @check_ptrs x
    return OSReturnsRetainedOnNonZeroAttr(clang_Attr_castToOSReturnsRetainedOnNonZeroAttr(x))
end

function isOSReturnsRetainedOnZeroAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOSReturnsRetainedOnZeroAttr(x)
end

function OSReturnsRetainedOnZeroAttr(x::AbstractAttr)
    @check_ptrs x
    return OSReturnsRetainedOnZeroAttr(clang_Attr_castToOSReturnsRetainedOnZeroAttr(x))
end

function isObjCBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBridgeAttr(x)
end

function ObjCBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCBridgeAttr(clang_Attr_castToObjCBridgeAttr(x))
end

function isObjCBridgeMutableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBridgeMutableAttr(x)
end

function ObjCBridgeMutableAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCBridgeMutableAttr(clang_Attr_castToObjCBridgeMutableAttr(x))
end

function isObjCBridgeRelatedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBridgeRelatedAttr(x)
end

function ObjCBridgeRelatedAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCBridgeRelatedAttr(clang_Attr_castToObjCBridgeRelatedAttr(x))
end

function isObjCExceptionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCExceptionAttr(x)
end

function ObjCExceptionAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCExceptionAttr(clang_Attr_castToObjCExceptionAttr(x))
end

function isObjCExplicitProtocolImplAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCExplicitProtocolImplAttr(x)
end

function ObjCExplicitProtocolImplAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCExplicitProtocolImplAttr(clang_Attr_castToObjCExplicitProtocolImplAttr(x))
end

function isObjCExternallyRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCExternallyRetainedAttr(x)
end

function ObjCExternallyRetainedAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCExternallyRetainedAttr(clang_Attr_castToObjCExternallyRetainedAttr(x))
end

function isObjCIndependentClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCIndependentClassAttr(x)
end

function ObjCIndependentClassAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCIndependentClassAttr(clang_Attr_castToObjCIndependentClassAttr(x))
end

function isObjCMethodFamilyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCMethodFamilyAttr(x)
end

function ObjCMethodFamilyAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCMethodFamilyAttr(clang_Attr_castToObjCMethodFamilyAttr(x))
end

function isObjCNSObjectAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCNSObjectAttr(x)
end

function ObjCNSObjectAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCNSObjectAttr(clang_Attr_castToObjCNSObjectAttr(x))
end

function isObjCPreciseLifetimeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCPreciseLifetimeAttr(x)
end

function ObjCPreciseLifetimeAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCPreciseLifetimeAttr(clang_Attr_castToObjCPreciseLifetimeAttr(x))
end

function isObjCRequiresPropertyDefsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRequiresPropertyDefsAttr(x)
end

function ObjCRequiresPropertyDefsAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCRequiresPropertyDefsAttr(clang_Attr_castToObjCRequiresPropertyDefsAttr(x))
end

function isObjCRequiresSuperAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRequiresSuperAttr(x)
end

function ObjCRequiresSuperAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCRequiresSuperAttr(clang_Attr_castToObjCRequiresSuperAttr(x))
end

function isObjCReturnsInnerPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCReturnsInnerPointerAttr(x)
end

function ObjCReturnsInnerPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCReturnsInnerPointerAttr(clang_Attr_castToObjCReturnsInnerPointerAttr(x))
end

function isObjCRootClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRootClassAttr(x)
end

function ObjCRootClassAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCRootClassAttr(clang_Attr_castToObjCRootClassAttr(x))
end

function isObjCSubclassingRestrictedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCSubclassingRestrictedAttr(x)
end

function ObjCSubclassingRestrictedAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCSubclassingRestrictedAttr(clang_Attr_castToObjCSubclassingRestrictedAttr(x))
end

function isOpenCLIntelReqdSubGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLIntelReqdSubGroupSizeAttr(x)
end

function OpenCLIntelReqdSubGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLIntelReqdSubGroupSizeAttr(clang_Attr_castToOpenCLIntelReqdSubGroupSizeAttr(x))
end

function isOpenCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLKernelAttr(x)
end

function OpenCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLKernelAttr(clang_Attr_castToOpenCLKernelAttr(x))
end

function isOptimizeNoneAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOptimizeNoneAttr(x)
end

function OptimizeNoneAttr(x::AbstractAttr)
    @check_ptrs x
    return OptimizeNoneAttr(clang_Attr_castToOptimizeNoneAttr(x))
end

function isOverrideAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOverrideAttr(x)
end

function OverrideAttr(x::AbstractAttr)
    @check_ptrs x
    return OverrideAttr(clang_Attr_castToOverrideAttr(x))
end

function isOwnerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOwnerAttr(x)
end

function OwnerAttr(x::AbstractAttr)
    @check_ptrs x
    return OwnerAttr(clang_Attr_castToOwnerAttr(x))
end

function isOwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOwnershipAttr(x)
end

function OwnershipAttr(x::AbstractAttr)
    @check_ptrs x
    return OwnershipAttr(clang_Attr_castToOwnershipAttr(x))
end

function isPackedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPackedAttr(x)
end

function PackedAttr(x::AbstractAttr)
    @check_ptrs x
    return PackedAttr(clang_Attr_castToPackedAttr(x))
end

function isParamTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isParamTypestateAttr(x)
end

function ParamTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return ParamTypestateAttr(clang_Attr_castToParamTypestateAttr(x))
end

function isPatchableFunctionEntryAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPatchableFunctionEntryAttr(x)
end

function PatchableFunctionEntryAttr(x::AbstractAttr)
    @check_ptrs x
    return PatchableFunctionEntryAttr(clang_Attr_castToPatchableFunctionEntryAttr(x))
end

function isPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPointerAttr(x)
end

function PointerAttr(x::AbstractAttr)
    @check_ptrs x
    return PointerAttr(clang_Attr_castToPointerAttr(x))
end

function isPragmaClangBSSSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangBSSSectionAttr(x)
end

function PragmaClangBSSSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return PragmaClangBSSSectionAttr(clang_Attr_castToPragmaClangBSSSectionAttr(x))
end

function isPragmaClangDataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangDataSectionAttr(x)
end

function PragmaClangDataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return PragmaClangDataSectionAttr(clang_Attr_castToPragmaClangDataSectionAttr(x))
end

function isPragmaClangRelroSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangRelroSectionAttr(x)
end

function PragmaClangRelroSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return PragmaClangRelroSectionAttr(clang_Attr_castToPragmaClangRelroSectionAttr(x))
end

function isPragmaClangRodataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangRodataSectionAttr(x)
end

function PragmaClangRodataSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return PragmaClangRodataSectionAttr(clang_Attr_castToPragmaClangRodataSectionAttr(x))
end

function isPragmaClangTextSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPragmaClangTextSectionAttr(x)
end

function PragmaClangTextSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return PragmaClangTextSectionAttr(clang_Attr_castToPragmaClangTextSectionAttr(x))
end

function isPreferredNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreferredNameAttr(x)
end

function PreferredNameAttr(x::AbstractAttr)
    @check_ptrs x
    return PreferredNameAttr(clang_Attr_castToPreferredNameAttr(x))
end

function isPreferredTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPreferredTypeAttr(x)
end

function PreferredTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return PreferredTypeAttr(clang_Attr_castToPreferredTypeAttr(x))
end

function isPtGuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtGuardedByAttr(x)
end

function PtGuardedByAttr(x::AbstractAttr)
    @check_ptrs x
    return PtGuardedByAttr(clang_Attr_castToPtGuardedByAttr(x))
end

function isPtGuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPtGuardedVarAttr(x)
end

function PtGuardedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return PtGuardedVarAttr(clang_Attr_castToPtGuardedVarAttr(x))
end

function isPureAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isPureAttr(x)
end

function PureAttr(x::AbstractAttr)
    @check_ptrs x
    return PureAttr(clang_Attr_castToPureAttr(x))
end

function isRISCVInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRISCVInterruptAttr(x)
end

function RISCVInterruptAttr(x::AbstractAttr)
    @check_ptrs x
    return RISCVInterruptAttr(clang_Attr_castToRISCVInterruptAttr(x))
end

function isRandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRandomizeLayoutAttr(x)
end

function RandomizeLayoutAttr(x::AbstractAttr)
    @check_ptrs x
    return RandomizeLayoutAttr(clang_Attr_castToRandomizeLayoutAttr(x))
end

function isReadOnlyPlacementAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReadOnlyPlacementAttr(x)
end

function ReadOnlyPlacementAttr(x::AbstractAttr)
    @check_ptrs x
    return ReadOnlyPlacementAttr(clang_Attr_castToReadOnlyPlacementAttr(x))
end

function isReinitializesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReinitializesAttr(x)
end

function ReinitializesAttr(x::AbstractAttr)
    @check_ptrs x
    return ReinitializesAttr(clang_Attr_castToReinitializesAttr(x))
end

function isReleaseCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReleaseCapabilityAttr(x)
end

function ReleaseCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return ReleaseCapabilityAttr(clang_Attr_castToReleaseCapabilityAttr(x))
end

function isReqdWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReqdWorkGroupSizeAttr(x)
end

function ReqdWorkGroupSizeAttr(x::AbstractAttr)
    @check_ptrs x
    return ReqdWorkGroupSizeAttr(clang_Attr_castToReqdWorkGroupSizeAttr(x))
end

function isRequiresCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRequiresCapabilityAttr(x)
end

function RequiresCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return RequiresCapabilityAttr(clang_Attr_castToRequiresCapabilityAttr(x))
end

function isRestrictAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRestrictAttr(x)
end

function RestrictAttr(x::AbstractAttr)
    @check_ptrs x
    return RestrictAttr(clang_Attr_castToRestrictAttr(x))
end

function isRetainAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRetainAttr(x)
end

function RetainAttr(x::AbstractAttr)
    @check_ptrs x
    return RetainAttr(clang_Attr_castToRetainAttr(x))
end

function isReturnTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReturnTypestateAttr(x)
end

function ReturnTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return ReturnTypestateAttr(clang_Attr_castToReturnTypestateAttr(x))
end

function isReturnsNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReturnsNonNullAttr(x)
end

function ReturnsNonNullAttr(x::AbstractAttr)
    @check_ptrs x
    return ReturnsNonNullAttr(clang_Attr_castToReturnsNonNullAttr(x))
end

function isReturnsTwiceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isReturnsTwiceAttr(x)
end

function ReturnsTwiceAttr(x::AbstractAttr)
    @check_ptrs x
    return ReturnsTwiceAttr(clang_Attr_castToReturnsTwiceAttr(x))
end

function isSYCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSYCLKernelAttr(x)
end

function SYCLKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return SYCLKernelAttr(clang_Attr_castToSYCLKernelAttr(x))
end

function isSYCLSpecialClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSYCLSpecialClassAttr(x)
end

function SYCLSpecialClassAttr(x::AbstractAttr)
    @check_ptrs x
    return SYCLSpecialClassAttr(clang_Attr_castToSYCLSpecialClassAttr(x))
end

function isScopedLockableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isScopedLockableAttr(x)
end

function ScopedLockableAttr(x::AbstractAttr)
    @check_ptrs x
    return ScopedLockableAttr(clang_Attr_castToScopedLockableAttr(x))
end

function isSectionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSectionAttr(x)
end

function SectionAttr(x::AbstractAttr)
    @check_ptrs x
    return SectionAttr(clang_Attr_castToSectionAttr(x))
end

function isSelectAnyAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSelectAnyAttr(x)
end

function SelectAnyAttr(x::AbstractAttr)
    @check_ptrs x
    return SelectAnyAttr(clang_Attr_castToSelectAnyAttr(x))
end

function isSentinelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSentinelAttr(x)
end

function SentinelAttr(x::AbstractAttr)
    @check_ptrs x
    return SentinelAttr(clang_Attr_castToSentinelAttr(x))
end

function isSetTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSetTypestateAttr(x)
end

function SetTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return SetTypestateAttr(clang_Attr_castToSetTypestateAttr(x))
end

function isSharedTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSharedTrylockFunctionAttr(x)
end

function SharedTrylockFunctionAttr(x::AbstractAttr)
    @check_ptrs x
    return SharedTrylockFunctionAttr(clang_Attr_castToSharedTrylockFunctionAttr(x))
end

function isSpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSpeculativeLoadHardeningAttr(x)
end

function SpeculativeLoadHardeningAttr(x::AbstractAttr)
    @check_ptrs x
    return SpeculativeLoadHardeningAttr(clang_Attr_castToSpeculativeLoadHardeningAttr(x))
end

function isStandaloneDebugAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStandaloneDebugAttr(x)
end

function StandaloneDebugAttr(x::AbstractAttr)
    @check_ptrs x
    return StandaloneDebugAttr(clang_Attr_castToStandaloneDebugAttr(x))
end

function isStrictFPAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStrictFPAttr(x)
end

function StrictFPAttr(x::AbstractAttr)
    @check_ptrs x
    return StrictFPAttr(clang_Attr_castToStrictFPAttr(x))
end

function isStrictGuardStackCheckAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isStrictGuardStackCheckAttr(x)
end

function StrictGuardStackCheckAttr(x::AbstractAttr)
    @check_ptrs x
    return StrictGuardStackCheckAttr(clang_Attr_castToStrictGuardStackCheckAttr(x))
end

function isSwiftAsyncAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncAttr(x)
end

function SwiftAsyncAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftAsyncAttr(clang_Attr_castToSwiftAsyncAttr(x))
end

function isSwiftAsyncErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncErrorAttr(x)
end

function SwiftAsyncErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftAsyncErrorAttr(clang_Attr_castToSwiftAsyncErrorAttr(x))
end

function isSwiftAsyncNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAsyncNameAttr(x)
end

function SwiftAsyncNameAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftAsyncNameAttr(clang_Attr_castToSwiftAsyncNameAttr(x))
end

function isSwiftAttrAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftAttrAttr(x)
end

function SwiftAttrAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftAttrAttr(clang_Attr_castToSwiftAttrAttr(x))
end

function isSwiftBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftBridgeAttr(x)
end

function SwiftBridgeAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftBridgeAttr(clang_Attr_castToSwiftBridgeAttr(x))
end

function isSwiftBridgedTypedefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftBridgedTypedefAttr(x)
end

function SwiftBridgedTypedefAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftBridgedTypedefAttr(clang_Attr_castToSwiftBridgedTypedefAttr(x))
end

function isSwiftErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftErrorAttr(x)
end

function SwiftErrorAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftErrorAttr(clang_Attr_castToSwiftErrorAttr(x))
end

function isSwiftImportAsNonGenericAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftImportAsNonGenericAttr(x)
end

function SwiftImportAsNonGenericAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftImportAsNonGenericAttr(clang_Attr_castToSwiftImportAsNonGenericAttr(x))
end

function isSwiftImportPropertyAsAccessorsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftImportPropertyAsAccessorsAttr(x)
end

function SwiftImportPropertyAsAccessorsAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftImportPropertyAsAccessorsAttr(clang_Attr_castToSwiftImportPropertyAsAccessorsAttr(x))
end

function isSwiftNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftNameAttr(x)
end

function SwiftNameAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftNameAttr(clang_Attr_castToSwiftNameAttr(x))
end

function isSwiftNewTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftNewTypeAttr(x)
end

function SwiftNewTypeAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftNewTypeAttr(clang_Attr_castToSwiftNewTypeAttr(x))
end

function isSwiftPrivateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftPrivateAttr(x)
end

function SwiftPrivateAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftPrivateAttr(clang_Attr_castToSwiftPrivateAttr(x))
end

function isTLSModelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTLSModelAttr(x)
end

function TLSModelAttr(x::AbstractAttr)
    @check_ptrs x
    return TLSModelAttr(clang_Attr_castToTLSModelAttr(x))
end

function isTargetAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTargetAttr(x)
end

function TargetAttr(x::AbstractAttr)
    @check_ptrs x
    return TargetAttr(clang_Attr_castToTargetAttr(x))
end

function isTargetClonesAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTargetClonesAttr(x)
end

function TargetClonesAttr(x::AbstractAttr)
    @check_ptrs x
    return TargetClonesAttr(clang_Attr_castToTargetClonesAttr(x))
end

function isTargetVersionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTargetVersionAttr(x)
end

function TargetVersionAttr(x::AbstractAttr)
    @check_ptrs x
    return TargetVersionAttr(clang_Attr_castToTargetVersionAttr(x))
end

function isTestTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTestTypestateAttr(x)
end

function TestTypestateAttr(x::AbstractAttr)
    @check_ptrs x
    return TestTypestateAttr(clang_Attr_castToTestTypestateAttr(x))
end

function isTransparentUnionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTransparentUnionAttr(x)
end

function TransparentUnionAttr(x::AbstractAttr)
    @check_ptrs x
    return TransparentUnionAttr(clang_Attr_castToTransparentUnionAttr(x))
end

function isTrivialABIAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTrivialABIAttr(x)
end

function TrivialABIAttr(x::AbstractAttr)
    @check_ptrs x
    return TrivialABIAttr(clang_Attr_castToTrivialABIAttr(x))
end

function isTryAcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTryAcquireCapabilityAttr(x)
end

function TryAcquireCapabilityAttr(x::AbstractAttr)
    @check_ptrs x
    return TryAcquireCapabilityAttr(clang_Attr_castToTryAcquireCapabilityAttr(x))
end

function isTypeTagForDatatypeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeTagForDatatypeAttr(x)
end

function TypeTagForDatatypeAttr(x::AbstractAttr)
    @check_ptrs x
    return TypeTagForDatatypeAttr(clang_Attr_castToTypeTagForDatatypeAttr(x))
end

function isTypeVisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isTypeVisibilityAttr(x)
end

function TypeVisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return TypeVisibilityAttr(clang_Attr_castToTypeVisibilityAttr(x))
end

function isUnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnavailableAttr(x)
end

function UnavailableAttr(x::AbstractAttr)
    @check_ptrs x
    return UnavailableAttr(clang_Attr_castToUnavailableAttr(x))
end

function isUninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUninitializedAttr(x)
end

function UninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    return UninitializedAttr(clang_Attr_castToUninitializedAttr(x))
end

function isUnsafeBufferUsageAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnsafeBufferUsageAttr(x)
end

function UnsafeBufferUsageAttr(x::AbstractAttr)
    @check_ptrs x
    return UnsafeBufferUsageAttr(clang_Attr_castToUnsafeBufferUsageAttr(x))
end

function isUnusedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUnusedAttr(x)
end

function UnusedAttr(x::AbstractAttr)
    @check_ptrs x
    return UnusedAttr(clang_Attr_castToUnusedAttr(x))
end

function isUsedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUsedAttr(x)
end

function UsedAttr(x::AbstractAttr)
    @check_ptrs x
    return UsedAttr(clang_Attr_castToUsedAttr(x))
end

function isUsingIfExistsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUsingIfExistsAttr(x)
end

function UsingIfExistsAttr(x::AbstractAttr)
    @check_ptrs x
    return UsingIfExistsAttr(clang_Attr_castToUsingIfExistsAttr(x))
end

function isUuidAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isUuidAttr(x)
end

function UuidAttr(x::AbstractAttr)
    @check_ptrs x
    return UuidAttr(clang_Attr_castToUuidAttr(x))
end

function isVecReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVecReturnAttr(x)
end

function VecReturnAttr(x::AbstractAttr)
    @check_ptrs x
    return VecReturnAttr(clang_Attr_castToVecReturnAttr(x))
end

function isVecTypeHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVecTypeHintAttr(x)
end

function VecTypeHintAttr(x::AbstractAttr)
    @check_ptrs x
    return VecTypeHintAttr(clang_Attr_castToVecTypeHintAttr(x))
end

function isVisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isVisibilityAttr(x)
end

function VisibilityAttr(x::AbstractAttr)
    @check_ptrs x
    return VisibilityAttr(clang_Attr_castToVisibilityAttr(x))
end

function isWarnUnusedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWarnUnusedAttr(x)
end

function WarnUnusedAttr(x::AbstractAttr)
    @check_ptrs x
    return WarnUnusedAttr(clang_Attr_castToWarnUnusedAttr(x))
end

function isWarnUnusedResultAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWarnUnusedResultAttr(x)
end

function WarnUnusedResultAttr(x::AbstractAttr)
    @check_ptrs x
    return WarnUnusedResultAttr(clang_Attr_castToWarnUnusedResultAttr(x))
end

function isWeakAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWeakAttr(x)
end

function WeakAttr(x::AbstractAttr)
    @check_ptrs x
    return WeakAttr(clang_Attr_castToWeakAttr(x))
end

function isWeakImportAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWeakImportAttr(x)
end

function WeakImportAttr(x::AbstractAttr)
    @check_ptrs x
    return WeakImportAttr(clang_Attr_castToWeakImportAttr(x))
end

function isWeakRefAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWeakRefAttr(x)
end

function WeakRefAttr(x::AbstractAttr)
    @check_ptrs x
    return WeakRefAttr(clang_Attr_castToWeakRefAttr(x))
end

function isWebAssemblyExportNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyExportNameAttr(x)
end

function WebAssemblyExportNameAttr(x::AbstractAttr)
    @check_ptrs x
    return WebAssemblyExportNameAttr(clang_Attr_castToWebAssemblyExportNameAttr(x))
end

function isWebAssemblyImportModuleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyImportModuleAttr(x)
end

function WebAssemblyImportModuleAttr(x::AbstractAttr)
    @check_ptrs x
    return WebAssemblyImportModuleAttr(clang_Attr_castToWebAssemblyImportModuleAttr(x))
end

function isWebAssemblyImportNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWebAssemblyImportNameAttr(x)
end

function WebAssemblyImportNameAttr(x::AbstractAttr)
    @check_ptrs x
    return WebAssemblyImportNameAttr(clang_Attr_castToWebAssemblyImportNameAttr(x))
end

function isWorkGroupSizeHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isWorkGroupSizeHintAttr(x)
end

function WorkGroupSizeHintAttr(x::AbstractAttr)
    @check_ptrs x
    return WorkGroupSizeHintAttr(clang_Attr_castToWorkGroupSizeHintAttr(x))
end

function isX86ForceAlignArgPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isX86ForceAlignArgPointerAttr(x)
end

function X86ForceAlignArgPointerAttr(x::AbstractAttr)
    @check_ptrs x
    return X86ForceAlignArgPointerAttr(clang_Attr_castToX86ForceAlignArgPointerAttr(x))
end

function isXRayInstrumentAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isXRayInstrumentAttr(x)
end

function XRayInstrumentAttr(x::AbstractAttr)
    @check_ptrs x
    return XRayInstrumentAttr(clang_Attr_castToXRayInstrumentAttr(x))
end

function isXRayLogArgsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isXRayLogArgsAttr(x)
end

function XRayLogArgsAttr(x::AbstractAttr)
    @check_ptrs x
    return XRayLogArgsAttr(clang_Attr_castToXRayLogArgsAttr(x))
end

function isZeroCallUsedRegsAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isZeroCallUsedRegsAttr(x)
end

function ZeroCallUsedRegsAttr(x::AbstractAttr)
    @check_ptrs x
    return ZeroCallUsedRegsAttr(clang_Attr_castToZeroCallUsedRegsAttr(x))
end

function isAbiTagAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAbiTagAttr(x)
end

function AbiTagAttr(x::AbstractAttr)
    @check_ptrs x
    return AbiTagAttr(clang_Attr_castToAbiTagAttr(x))
end

function isAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAliasAttr(x)
end

function AliasAttr(x::AbstractAttr)
    @check_ptrs x
    return AliasAttr(clang_Attr_castToAliasAttr(x))
end

function isAlignValueAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isAlignValueAttr(x)
end

function AlignValueAttr(x::AbstractAttr)
    @check_ptrs x
    return AlignValueAttr(clang_Attr_castToAlignValueAttr(x))
end

function isBuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isBuiltinAliasAttr(x)
end

function BuiltinAliasAttr(x::AbstractAttr)
    @check_ptrs x
    return BuiltinAliasAttr(clang_Attr_castToBuiltinAliasAttr(x))
end

function isCalledOnceAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isCalledOnceAttr(x)
end

function CalledOnceAttr(x::AbstractAttr)
    @check_ptrs x
    return CalledOnceAttr(clang_Attr_castToCalledOnceAttr(x))
end

function isIFuncAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isIFuncAttr(x)
end

function IFuncAttr(x::AbstractAttr)
    @check_ptrs x
    return IFuncAttr(clang_Attr_castToIFuncAttr(x))
end

function isInitSegAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isInitSegAttr(x)
end

function InitSegAttr(x::AbstractAttr)
    @check_ptrs x
    return InitSegAttr(clang_Attr_castToInitSegAttr(x))
end

function isLoaderUninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLoaderUninitializedAttr(x)
end

function LoaderUninitializedAttr(x::AbstractAttr)
    @check_ptrs x
    return LoaderUninitializedAttr(clang_Attr_castToLoaderUninitializedAttr(x))
end

function isLoopHintAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isLoopHintAttr(x)
end

function LoopHintAttr(x::AbstractAttr)
    @check_ptrs x
    return LoopHintAttr(clang_Attr_castToLoopHintAttr(x))
end

function isModeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isModeAttr(x)
end

function ModeAttr(x::AbstractAttr)
    @check_ptrs x
    return ModeAttr(clang_Attr_castToModeAttr(x))
end

function isNoBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoBuiltinAttr(x)
end

function NoBuiltinAttr(x::AbstractAttr)
    @check_ptrs x
    return NoBuiltinAttr(clang_Attr_castToNoBuiltinAttr(x))
end

function isNoEscapeAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isNoEscapeAttr(x)
end

function NoEscapeAttr(x::AbstractAttr)
    @check_ptrs x
    return NoEscapeAttr(clang_Attr_castToNoEscapeAttr(x))
end

function isOMPCaptureKindAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPCaptureKindAttr(x)
end

function OMPCaptureKindAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPCaptureKindAttr(clang_Attr_castToOMPCaptureKindAttr(x))
end

function isOMPDeclareSimdDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPDeclareSimdDeclAttr(x)
end

function OMPDeclareSimdDeclAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPDeclareSimdDeclAttr(clang_Attr_castToOMPDeclareSimdDeclAttr(x))
end

function isOMPReferencedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOMPReferencedVarAttr(x)
end

function OMPReferencedVarAttr(x::AbstractAttr)
    @check_ptrs x
    return OMPReferencedVarAttr(clang_Attr_castToOMPReferencedVarAttr(x))
end

function isObjCBoxableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCBoxableAttr(x)
end

function ObjCBoxableAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCBoxableAttr(clang_Attr_castToObjCBoxableAttr(x))
end

function isObjCClassStubAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCClassStubAttr(x)
end

function ObjCClassStubAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCClassStubAttr(clang_Attr_castToObjCClassStubAttr(x))
end

function isObjCDesignatedInitializerAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCDesignatedInitializerAttr(x)
end

function ObjCDesignatedInitializerAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCDesignatedInitializerAttr(clang_Attr_castToObjCDesignatedInitializerAttr(x))
end

function isObjCDirectAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCDirectAttr(x)
end

function ObjCDirectAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCDirectAttr(clang_Attr_castToObjCDirectAttr(x))
end

function isObjCDirectMembersAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCDirectMembersAttr(x)
end

function ObjCDirectMembersAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCDirectMembersAttr(clang_Attr_castToObjCDirectMembersAttr(x))
end

function isObjCNonLazyClassAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCNonLazyClassAttr(x)
end

function ObjCNonLazyClassAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCNonLazyClassAttr(clang_Attr_castToObjCNonLazyClassAttr(x))
end

function isObjCNonRuntimeProtocolAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCNonRuntimeProtocolAttr(x)
end

function ObjCNonRuntimeProtocolAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCNonRuntimeProtocolAttr(clang_Attr_castToObjCNonRuntimeProtocolAttr(x))
end

function isObjCRuntimeNameAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRuntimeNameAttr(x)
end

function ObjCRuntimeNameAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCRuntimeNameAttr(clang_Attr_castToObjCRuntimeNameAttr(x))
end

function isObjCRuntimeVisibleAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isObjCRuntimeVisibleAttr(x)
end

function ObjCRuntimeVisibleAttr(x::AbstractAttr)
    @check_ptrs x
    return ObjCRuntimeVisibleAttr(clang_Attr_castToObjCRuntimeVisibleAttr(x))
end

function isOpenCLAccessAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOpenCLAccessAttr(x)
end

function OpenCLAccessAttr(x::AbstractAttr)
    @check_ptrs x
    return OpenCLAccessAttr(clang_Attr_castToOpenCLAccessAttr(x))
end

function isOverloadableAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isOverloadableAttr(x)
end

function OverloadableAttr(x::AbstractAttr)
    @check_ptrs x
    return OverloadableAttr(clang_Attr_castToOverloadableAttr(x))
end

function isRenderScriptKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isRenderScriptKernelAttr(x)
end

function RenderScriptKernelAttr(x::AbstractAttr)
    @check_ptrs x
    return RenderScriptKernelAttr(clang_Attr_castToRenderScriptKernelAttr(x))
end

function isSwiftObjCMembersAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftObjCMembersAttr(x)
end

function SwiftObjCMembersAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftObjCMembersAttr(clang_Attr_castToSwiftObjCMembersAttr(x))
end

function isSwiftVersionedAdditionAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftVersionedAdditionAttr(x)
end

function SwiftVersionedAdditionAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftVersionedAdditionAttr(clang_Attr_castToSwiftVersionedAdditionAttr(x))
end

function isSwiftVersionedRemovalAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isSwiftVersionedRemovalAttr(x)
end

function SwiftVersionedRemovalAttr(x::AbstractAttr)
    @check_ptrs x
    return SwiftVersionedRemovalAttr(clang_Attr_castToSwiftVersionedRemovalAttr(x))
end

function isThreadAttr(x::AbstractAttr)
    @check_ptrs x
    return clang_Attr_isThreadAttr(x)
end

function ThreadAttr(x::AbstractAttr)
    @check_ptrs x
    return ThreadAttr(clang_Attr_castToThreadAttr(x))
end

