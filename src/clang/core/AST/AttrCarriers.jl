# Generated from deps/ClangExtra/include/clang-ex/AST/AttrList.inc by gen/attr_nodes.jl — do not edit.
# One carrier per concrete clang attribute, subtyping its own Abstract<Name>Attr
# (defined in AttrAbstracts.jl) which subtypes the attribute's category.
# Marshalling is the carrier's own entry in converts.jl, plus the `CXAttr`
# entry keyed on `AbstractAttr` that carries it to every base-class binding.
"""
    struct AddressSpaceAttr <: AbstractAddressSpaceAttr
Hold a pointer to a `clang::AddressSpaceAttr` object.
"""
struct AddressSpaceAttr <: AbstractAddressSpaceAttr
    ptr::CXAddressSpaceAttr
end

"""
    struct AnnotateTypeAttr <: AbstractAnnotateTypeAttr
Hold a pointer to a `clang::AnnotateTypeAttr` object.
"""
struct AnnotateTypeAttr <: AbstractAnnotateTypeAttr
    ptr::CXAnnotateTypeAttr
end

"""
    struct ArmInAttr <: AbstractArmInAttr
Hold a pointer to a `clang::ArmInAttr` object.
"""
struct ArmInAttr <: AbstractArmInAttr
    ptr::CXArmInAttr
end

"""
    struct ArmInOutAttr <: AbstractArmInOutAttr
Hold a pointer to a `clang::ArmInOutAttr` object.
"""
struct ArmInOutAttr <: AbstractArmInOutAttr
    ptr::CXArmInOutAttr
end

"""
    struct ArmMveStrictPolymorphismAttr <: AbstractArmMveStrictPolymorphismAttr
Hold a pointer to a `clang::ArmMveStrictPolymorphismAttr` object.
"""
struct ArmMveStrictPolymorphismAttr <: AbstractArmMveStrictPolymorphismAttr
    ptr::CXArmMveStrictPolymorphismAttr
end

"""
    struct ArmOutAttr <: AbstractArmOutAttr
Hold a pointer to a `clang::ArmOutAttr` object.
"""
struct ArmOutAttr <: AbstractArmOutAttr
    ptr::CXArmOutAttr
end

"""
    struct ArmPreservesAttr <: AbstractArmPreservesAttr
Hold a pointer to a `clang::ArmPreservesAttr` object.
"""
struct ArmPreservesAttr <: AbstractArmPreservesAttr
    ptr::CXArmPreservesAttr
end

"""
    struct ArmStreamingAttr <: AbstractArmStreamingAttr
Hold a pointer to a `clang::ArmStreamingAttr` object.
"""
struct ArmStreamingAttr <: AbstractArmStreamingAttr
    ptr::CXArmStreamingAttr
end

"""
    struct ArmStreamingCompatibleAttr <: AbstractArmStreamingCompatibleAttr
Hold a pointer to a `clang::ArmStreamingCompatibleAttr` object.
"""
struct ArmStreamingCompatibleAttr <: AbstractArmStreamingCompatibleAttr
    ptr::CXArmStreamingCompatibleAttr
end

"""
    struct BTFTypeTagAttr <: AbstractBTFTypeTagAttr
Hold a pointer to a `clang::BTFTypeTagAttr` object.
"""
struct BTFTypeTagAttr <: AbstractBTFTypeTagAttr
    ptr::CXBTFTypeTagAttr
end

"""
    struct CmseNSCallAttr <: AbstractCmseNSCallAttr
Hold a pointer to a `clang::CmseNSCallAttr` object.
"""
struct CmseNSCallAttr <: AbstractCmseNSCallAttr
    ptr::CXCmseNSCallAttr
end

"""
    struct HLSLGroupSharedAddressSpaceAttr <: AbstractHLSLGroupSharedAddressSpaceAttr
Hold a pointer to a `clang::HLSLGroupSharedAddressSpaceAttr` object.
"""
struct HLSLGroupSharedAddressSpaceAttr <: AbstractHLSLGroupSharedAddressSpaceAttr
    ptr::CXHLSLGroupSharedAddressSpaceAttr
end

"""
    struct HLSLParamModifierAttr <: AbstractHLSLParamModifierAttr
Hold a pointer to a `clang::HLSLParamModifierAttr` object.
"""
struct HLSLParamModifierAttr <: AbstractHLSLParamModifierAttr
    ptr::CXHLSLParamModifierAttr
end

"""
    struct NoDerefAttr <: AbstractNoDerefAttr
Hold a pointer to a `clang::NoDerefAttr` object.
"""
struct NoDerefAttr <: AbstractNoDerefAttr
    ptr::CXNoDerefAttr
end

"""
    struct ObjCGCAttr <: AbstractObjCGCAttr
Hold a pointer to a `clang::ObjCGCAttr` object.
"""
struct ObjCGCAttr <: AbstractObjCGCAttr
    ptr::CXObjCGCAttr
end

"""
    struct ObjCInertUnsafeUnretainedAttr <: AbstractObjCInertUnsafeUnretainedAttr
Hold a pointer to a `clang::ObjCInertUnsafeUnretainedAttr` object.
"""
struct ObjCInertUnsafeUnretainedAttr <: AbstractObjCInertUnsafeUnretainedAttr
    ptr::CXObjCInertUnsafeUnretainedAttr
end

"""
    struct ObjCKindOfAttr <: AbstractObjCKindOfAttr
Hold a pointer to a `clang::ObjCKindOfAttr` object.
"""
struct ObjCKindOfAttr <: AbstractObjCKindOfAttr
    ptr::CXObjCKindOfAttr
end

"""
    struct OpenCLConstantAddressSpaceAttr <: AbstractOpenCLConstantAddressSpaceAttr
Hold a pointer to a `clang::OpenCLConstantAddressSpaceAttr` object.
"""
struct OpenCLConstantAddressSpaceAttr <: AbstractOpenCLConstantAddressSpaceAttr
    ptr::CXOpenCLConstantAddressSpaceAttr
end

"""
    struct OpenCLGenericAddressSpaceAttr <: AbstractOpenCLGenericAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGenericAddressSpaceAttr` object.
"""
struct OpenCLGenericAddressSpaceAttr <: AbstractOpenCLGenericAddressSpaceAttr
    ptr::CXOpenCLGenericAddressSpaceAttr
end

"""
    struct OpenCLGlobalAddressSpaceAttr <: AbstractOpenCLGlobalAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGlobalAddressSpaceAttr` object.
"""
struct OpenCLGlobalAddressSpaceAttr <: AbstractOpenCLGlobalAddressSpaceAttr
    ptr::CXOpenCLGlobalAddressSpaceAttr
end

"""
    struct OpenCLGlobalDeviceAddressSpaceAttr <: AbstractOpenCLGlobalDeviceAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGlobalDeviceAddressSpaceAttr` object.
"""
struct OpenCLGlobalDeviceAddressSpaceAttr <: AbstractOpenCLGlobalDeviceAddressSpaceAttr
    ptr::CXOpenCLGlobalDeviceAddressSpaceAttr
end

"""
    struct OpenCLGlobalHostAddressSpaceAttr <: AbstractOpenCLGlobalHostAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGlobalHostAddressSpaceAttr` object.
"""
struct OpenCLGlobalHostAddressSpaceAttr <: AbstractOpenCLGlobalHostAddressSpaceAttr
    ptr::CXOpenCLGlobalHostAddressSpaceAttr
end

"""
    struct OpenCLLocalAddressSpaceAttr <: AbstractOpenCLLocalAddressSpaceAttr
Hold a pointer to a `clang::OpenCLLocalAddressSpaceAttr` object.
"""
struct OpenCLLocalAddressSpaceAttr <: AbstractOpenCLLocalAddressSpaceAttr
    ptr::CXOpenCLLocalAddressSpaceAttr
end

"""
    struct OpenCLPrivateAddressSpaceAttr <: AbstractOpenCLPrivateAddressSpaceAttr
Hold a pointer to a `clang::OpenCLPrivateAddressSpaceAttr` object.
"""
struct OpenCLPrivateAddressSpaceAttr <: AbstractOpenCLPrivateAddressSpaceAttr
    ptr::CXOpenCLPrivateAddressSpaceAttr
end

"""
    struct Ptr32Attr <: AbstractPtr32Attr
Hold a pointer to a `clang::Ptr32Attr` object.
"""
struct Ptr32Attr <: AbstractPtr32Attr
    ptr::CXPtr32Attr
end

"""
    struct Ptr64Attr <: AbstractPtr64Attr
Hold a pointer to a `clang::Ptr64Attr` object.
"""
struct Ptr64Attr <: AbstractPtr64Attr
    ptr::CXPtr64Attr
end

"""
    struct SPtrAttr <: AbstractSPtrAttr
Hold a pointer to a `clang::SPtrAttr` object.
"""
struct SPtrAttr <: AbstractSPtrAttr
    ptr::CXSPtrAttr
end

"""
    struct TypeNonNullAttr <: AbstractTypeNonNullAttr
Hold a pointer to a `clang::TypeNonNullAttr` object.
"""
struct TypeNonNullAttr <: AbstractTypeNonNullAttr
    ptr::CXTypeNonNullAttr
end

"""
    struct TypeNullUnspecifiedAttr <: AbstractTypeNullUnspecifiedAttr
Hold a pointer to a `clang::TypeNullUnspecifiedAttr` object.
"""
struct TypeNullUnspecifiedAttr <: AbstractTypeNullUnspecifiedAttr
    ptr::CXTypeNullUnspecifiedAttr
end

"""
    struct TypeNullableAttr <: AbstractTypeNullableAttr
Hold a pointer to a `clang::TypeNullableAttr` object.
"""
struct TypeNullableAttr <: AbstractTypeNullableAttr
    ptr::CXTypeNullableAttr
end

"""
    struct TypeNullableResultAttr <: AbstractTypeNullableResultAttr
Hold a pointer to a `clang::TypeNullableResultAttr` object.
"""
struct TypeNullableResultAttr <: AbstractTypeNullableResultAttr
    ptr::CXTypeNullableResultAttr
end

"""
    struct UPtrAttr <: AbstractUPtrAttr
Hold a pointer to a `clang::UPtrAttr` object.
"""
struct UPtrAttr <: AbstractUPtrAttr
    ptr::CXUPtrAttr
end

"""
    struct WebAssemblyFuncrefAttr <: AbstractWebAssemblyFuncrefAttr
Hold a pointer to a `clang::WebAssemblyFuncrefAttr` object.
"""
struct WebAssemblyFuncrefAttr <: AbstractWebAssemblyFuncrefAttr
    ptr::CXWebAssemblyFuncrefAttr
end

"""
    struct CodeAlignAttr <: AbstractCodeAlignAttr
Hold a pointer to a `clang::CodeAlignAttr` object.
"""
struct CodeAlignAttr <: AbstractCodeAlignAttr
    ptr::CXCodeAlignAttr
end

"""
    struct FallThroughAttr <: AbstractFallThroughAttr
Hold a pointer to a `clang::FallThroughAttr` object.
"""
struct FallThroughAttr <: AbstractFallThroughAttr
    ptr::CXFallThroughAttr
end

"""
    struct LikelyAttr <: AbstractLikelyAttr
Hold a pointer to a `clang::LikelyAttr` object.
"""
struct LikelyAttr <: AbstractLikelyAttr
    ptr::CXLikelyAttr
end

"""
    struct MustTailAttr <: AbstractMustTailAttr
Hold a pointer to a `clang::MustTailAttr` object.
"""
struct MustTailAttr <: AbstractMustTailAttr
    ptr::CXMustTailAttr
end

"""
    struct OpenCLUnrollHintAttr <: AbstractOpenCLUnrollHintAttr
Hold a pointer to a `clang::OpenCLUnrollHintAttr` object.
"""
struct OpenCLUnrollHintAttr <: AbstractOpenCLUnrollHintAttr
    ptr::CXOpenCLUnrollHintAttr
end

"""
    struct UnlikelyAttr <: AbstractUnlikelyAttr
Hold a pointer to a `clang::UnlikelyAttr` object.
"""
struct UnlikelyAttr <: AbstractUnlikelyAttr
    ptr::CXUnlikelyAttr
end

"""
    struct AlwaysInlineAttr <: AbstractAlwaysInlineAttr
Hold a pointer to a `clang::AlwaysInlineAttr` object.
"""
struct AlwaysInlineAttr <: AbstractAlwaysInlineAttr
    ptr::CXAlwaysInlineAttr
end

"""
    struct NoInlineAttr <: AbstractNoInlineAttr
Hold a pointer to a `clang::NoInlineAttr` object.
"""
struct NoInlineAttr <: AbstractNoInlineAttr
    ptr::CXNoInlineAttr
end

"""
    struct NoMergeAttr <: AbstractNoMergeAttr
Hold a pointer to a `clang::NoMergeAttr` object.
"""
struct NoMergeAttr <: AbstractNoMergeAttr
    ptr::CXNoMergeAttr
end

"""
    struct SuppressAttr <: AbstractSuppressAttr
Hold a pointer to a `clang::SuppressAttr` object.
"""
struct SuppressAttr <: AbstractSuppressAttr
    ptr::CXSuppressAttr
end

"""
    struct AArch64SVEPcsAttr <: AbstractAArch64SVEPcsAttr
Hold a pointer to a `clang::AArch64SVEPcsAttr` object.
"""
struct AArch64SVEPcsAttr <: AbstractAArch64SVEPcsAttr
    ptr::CXAArch64SVEPcsAttr
end

"""
    struct AArch64VectorPcsAttr <: AbstractAArch64VectorPcsAttr
Hold a pointer to a `clang::AArch64VectorPcsAttr` object.
"""
struct AArch64VectorPcsAttr <: AbstractAArch64VectorPcsAttr
    ptr::CXAArch64VectorPcsAttr
end

"""
    struct AMDGPUKernelCallAttr <: AbstractAMDGPUKernelCallAttr
Hold a pointer to a `clang::AMDGPUKernelCallAttr` object.
"""
struct AMDGPUKernelCallAttr <: AbstractAMDGPUKernelCallAttr
    ptr::CXAMDGPUKernelCallAttr
end

"""
    struct AcquireHandleAttr <: AbstractAcquireHandleAttr
Hold a pointer to a `clang::AcquireHandleAttr` object.
"""
struct AcquireHandleAttr <: AbstractAcquireHandleAttr
    ptr::CXAcquireHandleAttr
end

"""
    struct AnyX86NoCfCheckAttr <: AbstractAnyX86NoCfCheckAttr
Hold a pointer to a `clang::AnyX86NoCfCheckAttr` object.
"""
struct AnyX86NoCfCheckAttr <: AbstractAnyX86NoCfCheckAttr
    ptr::CXAnyX86NoCfCheckAttr
end

"""
    struct CDeclAttr <: AbstractCDeclAttr
Hold a pointer to a `clang::CDeclAttr` object.
"""
struct CDeclAttr <: AbstractCDeclAttr
    ptr::CXCDeclAttr
end

"""
    struct FastCallAttr <: AbstractFastCallAttr
Hold a pointer to a `clang::FastCallAttr` object.
"""
struct FastCallAttr <: AbstractFastCallAttr
    ptr::CXFastCallAttr
end

"""
    struct IntelOclBiccAttr <: AbstractIntelOclBiccAttr
Hold a pointer to a `clang::IntelOclBiccAttr` object.
"""
struct IntelOclBiccAttr <: AbstractIntelOclBiccAttr
    ptr::CXIntelOclBiccAttr
end

"""
    struct LifetimeBoundAttr <: AbstractLifetimeBoundAttr
Hold a pointer to a `clang::LifetimeBoundAttr` object.
"""
struct LifetimeBoundAttr <: AbstractLifetimeBoundAttr
    ptr::CXLifetimeBoundAttr
end

"""
    struct M68kRTDAttr <: AbstractM68kRTDAttr
Hold a pointer to a `clang::M68kRTDAttr` object.
"""
struct M68kRTDAttr <: AbstractM68kRTDAttr
    ptr::CXM68kRTDAttr
end

"""
    struct MSABIAttr <: AbstractMSABIAttr
Hold a pointer to a `clang::MSABIAttr` object.
"""
struct MSABIAttr <: AbstractMSABIAttr
    ptr::CXMSABIAttr
end

"""
    struct NSReturnsRetainedAttr <: AbstractNSReturnsRetainedAttr
Hold a pointer to a `clang::NSReturnsRetainedAttr` object.
"""
struct NSReturnsRetainedAttr <: AbstractNSReturnsRetainedAttr
    ptr::CXNSReturnsRetainedAttr
end

"""
    struct ObjCOwnershipAttr <: AbstractObjCOwnershipAttr
Hold a pointer to a `clang::ObjCOwnershipAttr` object.
"""
struct ObjCOwnershipAttr <: AbstractObjCOwnershipAttr
    ptr::CXObjCOwnershipAttr
end

"""
    struct PascalAttr <: AbstractPascalAttr
Hold a pointer to a `clang::PascalAttr` object.
"""
struct PascalAttr <: AbstractPascalAttr
    ptr::CXPascalAttr
end

"""
    struct PcsAttr <: AbstractPcsAttr
Hold a pointer to a `clang::PcsAttr` object.
"""
struct PcsAttr <: AbstractPcsAttr
    ptr::CXPcsAttr
end

"""
    struct PreserveAllAttr <: AbstractPreserveAllAttr
Hold a pointer to a `clang::PreserveAllAttr` object.
"""
struct PreserveAllAttr <: AbstractPreserveAllAttr
    ptr::CXPreserveAllAttr
end

"""
    struct PreserveMostAttr <: AbstractPreserveMostAttr
Hold a pointer to a `clang::PreserveMostAttr` object.
"""
struct PreserveMostAttr <: AbstractPreserveMostAttr
    ptr::CXPreserveMostAttr
end

"""
    struct RegCallAttr <: AbstractRegCallAttr
Hold a pointer to a `clang::RegCallAttr` object.
"""
struct RegCallAttr <: AbstractRegCallAttr
    ptr::CXRegCallAttr
end

"""
    struct StdCallAttr <: AbstractStdCallAttr
Hold a pointer to a `clang::StdCallAttr` object.
"""
struct StdCallAttr <: AbstractStdCallAttr
    ptr::CXStdCallAttr
end

"""
    struct SwiftAsyncCallAttr <: AbstractSwiftAsyncCallAttr
Hold a pointer to a `clang::SwiftAsyncCallAttr` object.
"""
struct SwiftAsyncCallAttr <: AbstractSwiftAsyncCallAttr
    ptr::CXSwiftAsyncCallAttr
end

"""
    struct SwiftCallAttr <: AbstractSwiftCallAttr
Hold a pointer to a `clang::SwiftCallAttr` object.
"""
struct SwiftCallAttr <: AbstractSwiftCallAttr
    ptr::CXSwiftCallAttr
end

"""
    struct SysVABIAttr <: AbstractSysVABIAttr
Hold a pointer to a `clang::SysVABIAttr` object.
"""
struct SysVABIAttr <: AbstractSysVABIAttr
    ptr::CXSysVABIAttr
end

"""
    struct ThisCallAttr <: AbstractThisCallAttr
Hold a pointer to a `clang::ThisCallAttr` object.
"""
struct ThisCallAttr <: AbstractThisCallAttr
    ptr::CXThisCallAttr
end

"""
    struct VectorCallAttr <: AbstractVectorCallAttr
Hold a pointer to a `clang::VectorCallAttr` object.
"""
struct VectorCallAttr <: AbstractVectorCallAttr
    ptr::CXVectorCallAttr
end

"""
    struct SwiftAsyncContextAttr <: AbstractSwiftAsyncContextAttr
Hold a pointer to a `clang::SwiftAsyncContextAttr` object.
"""
struct SwiftAsyncContextAttr <: AbstractSwiftAsyncContextAttr
    ptr::CXSwiftAsyncContextAttr
end

"""
    struct SwiftContextAttr <: AbstractSwiftContextAttr
Hold a pointer to a `clang::SwiftContextAttr` object.
"""
struct SwiftContextAttr <: AbstractSwiftContextAttr
    ptr::CXSwiftContextAttr
end

"""
    struct SwiftErrorResultAttr <: AbstractSwiftErrorResultAttr
Hold a pointer to a `clang::SwiftErrorResultAttr` object.
"""
struct SwiftErrorResultAttr <: AbstractSwiftErrorResultAttr
    ptr::CXSwiftErrorResultAttr
end

"""
    struct SwiftIndirectResultAttr <: AbstractSwiftIndirectResultAttr
Hold a pointer to a `clang::SwiftIndirectResultAttr` object.
"""
struct SwiftIndirectResultAttr <: AbstractSwiftIndirectResultAttr
    ptr::CXSwiftIndirectResultAttr
end

"""
    struct AnnotateAttr <: AbstractAnnotateAttr
Hold a pointer to a `clang::AnnotateAttr` object.
"""
struct AnnotateAttr <: AbstractAnnotateAttr
    ptr::CXAnnotateAttr
end

"""
    struct CFConsumedAttr <: AbstractCFConsumedAttr
Hold a pointer to a `clang::CFConsumedAttr` object.
"""
struct CFConsumedAttr <: AbstractCFConsumedAttr
    ptr::CXCFConsumedAttr
end

"""
    struct CarriesDependencyAttr <: AbstractCarriesDependencyAttr
Hold a pointer to a `clang::CarriesDependencyAttr` object.
"""
struct CarriesDependencyAttr <: AbstractCarriesDependencyAttr
    ptr::CXCarriesDependencyAttr
end

"""
    struct NSConsumedAttr <: AbstractNSConsumedAttr
Hold a pointer to a `clang::NSConsumedAttr` object.
"""
struct NSConsumedAttr <: AbstractNSConsumedAttr
    ptr::CXNSConsumedAttr
end

"""
    struct NonNullAttr <: AbstractNonNullAttr
Hold a pointer to a `clang::NonNullAttr` object.
"""
struct NonNullAttr <: AbstractNonNullAttr
    ptr::CXNonNullAttr
end

"""
    struct OSConsumedAttr <: AbstractOSConsumedAttr
Hold a pointer to a `clang::OSConsumedAttr` object.
"""
struct OSConsumedAttr <: AbstractOSConsumedAttr
    ptr::CXOSConsumedAttr
end

"""
    struct PassObjectSizeAttr <: AbstractPassObjectSizeAttr
Hold a pointer to a `clang::PassObjectSizeAttr` object.
"""
struct PassObjectSizeAttr <: AbstractPassObjectSizeAttr
    ptr::CXPassObjectSizeAttr
end

"""
    struct ReleaseHandleAttr <: AbstractReleaseHandleAttr
Hold a pointer to a `clang::ReleaseHandleAttr` object.
"""
struct ReleaseHandleAttr <: AbstractReleaseHandleAttr
    ptr::CXReleaseHandleAttr
end

"""
    struct UseHandleAttr <: AbstractUseHandleAttr
Hold a pointer to a `clang::UseHandleAttr` object.
"""
struct UseHandleAttr <: AbstractUseHandleAttr
    ptr::CXUseHandleAttr
end

"""
    struct HLSLSV_DispatchThreadIDAttr <: AbstractHLSLSV_DispatchThreadIDAttr
Hold a pointer to a `clang::HLSLSV_DispatchThreadIDAttr` object.
"""
struct HLSLSV_DispatchThreadIDAttr <: AbstractHLSLSV_DispatchThreadIDAttr
    ptr::CXHLSLSV_DispatchThreadIDAttr
end

"""
    struct HLSLSV_GroupIndexAttr <: AbstractHLSLSV_GroupIndexAttr
Hold a pointer to a `clang::HLSLSV_GroupIndexAttr` object.
"""
struct HLSLSV_GroupIndexAttr <: AbstractHLSLSV_GroupIndexAttr
    ptr::CXHLSLSV_GroupIndexAttr
end

"""
    struct AMDGPUFlatWorkGroupSizeAttr <: AbstractAMDGPUFlatWorkGroupSizeAttr
Hold a pointer to a `clang::AMDGPUFlatWorkGroupSizeAttr` object.
"""
struct AMDGPUFlatWorkGroupSizeAttr <: AbstractAMDGPUFlatWorkGroupSizeAttr
    ptr::CXAMDGPUFlatWorkGroupSizeAttr
end

"""
    struct AMDGPUNumSGPRAttr <: AbstractAMDGPUNumSGPRAttr
Hold a pointer to a `clang::AMDGPUNumSGPRAttr` object.
"""
struct AMDGPUNumSGPRAttr <: AbstractAMDGPUNumSGPRAttr
    ptr::CXAMDGPUNumSGPRAttr
end

"""
    struct AMDGPUNumVGPRAttr <: AbstractAMDGPUNumVGPRAttr
Hold a pointer to a `clang::AMDGPUNumVGPRAttr` object.
"""
struct AMDGPUNumVGPRAttr <: AbstractAMDGPUNumVGPRAttr
    ptr::CXAMDGPUNumVGPRAttr
end

"""
    struct AMDGPUWavesPerEUAttr <: AbstractAMDGPUWavesPerEUAttr
Hold a pointer to a `clang::AMDGPUWavesPerEUAttr` object.
"""
struct AMDGPUWavesPerEUAttr <: AbstractAMDGPUWavesPerEUAttr
    ptr::CXAMDGPUWavesPerEUAttr
end

"""
    struct ARMInterruptAttr <: AbstractARMInterruptAttr
Hold a pointer to a `clang::ARMInterruptAttr` object.
"""
struct ARMInterruptAttr <: AbstractARMInterruptAttr
    ptr::CXARMInterruptAttr
end

"""
    struct AVRInterruptAttr <: AbstractAVRInterruptAttr
Hold a pointer to a `clang::AVRInterruptAttr` object.
"""
struct AVRInterruptAttr <: AbstractAVRInterruptAttr
    ptr::CXAVRInterruptAttr
end

"""
    struct AVRSignalAttr <: AbstractAVRSignalAttr
Hold a pointer to a `clang::AVRSignalAttr` object.
"""
struct AVRSignalAttr <: AbstractAVRSignalAttr
    ptr::CXAVRSignalAttr
end

"""
    struct AcquireCapabilityAttr <: AbstractAcquireCapabilityAttr
Hold a pointer to a `clang::AcquireCapabilityAttr` object.
"""
struct AcquireCapabilityAttr <: AbstractAcquireCapabilityAttr
    ptr::CXAcquireCapabilityAttr
end

"""
    struct AcquiredAfterAttr <: AbstractAcquiredAfterAttr
Hold a pointer to a `clang::AcquiredAfterAttr` object.
"""
struct AcquiredAfterAttr <: AbstractAcquiredAfterAttr
    ptr::CXAcquiredAfterAttr
end

"""
    struct AcquiredBeforeAttr <: AbstractAcquiredBeforeAttr
Hold a pointer to a `clang::AcquiredBeforeAttr` object.
"""
struct AcquiredBeforeAttr <: AbstractAcquiredBeforeAttr
    ptr::CXAcquiredBeforeAttr
end

"""
    struct AlignMac68kAttr <: AbstractAlignMac68kAttr
Hold a pointer to a `clang::AlignMac68kAttr` object.
"""
struct AlignMac68kAttr <: AbstractAlignMac68kAttr
    ptr::CXAlignMac68kAttr
end

"""
    struct AlignNaturalAttr <: AbstractAlignNaturalAttr
Hold a pointer to a `clang::AlignNaturalAttr` object.
"""
struct AlignNaturalAttr <: AbstractAlignNaturalAttr
    ptr::CXAlignNaturalAttr
end

"""
    struct AlignedAttr <: AbstractAlignedAttr
Hold a pointer to a `clang::AlignedAttr` object.
"""
struct AlignedAttr <: AbstractAlignedAttr
    ptr::CXAlignedAttr
end

"""
    struct AllocAlignAttr <: AbstractAllocAlignAttr
Hold a pointer to a `clang::AllocAlignAttr` object.
"""
struct AllocAlignAttr <: AbstractAllocAlignAttr
    ptr::CXAllocAlignAttr
end

"""
    struct AllocSizeAttr <: AbstractAllocSizeAttr
Hold a pointer to a `clang::AllocSizeAttr` object.
"""
struct AllocSizeAttr <: AbstractAllocSizeAttr
    ptr::CXAllocSizeAttr
end

"""
    struct AlwaysDestroyAttr <: AbstractAlwaysDestroyAttr
Hold a pointer to a `clang::AlwaysDestroyAttr` object.
"""
struct AlwaysDestroyAttr <: AbstractAlwaysDestroyAttr
    ptr::CXAlwaysDestroyAttr
end

"""
    struct AnalyzerNoReturnAttr <: AbstractAnalyzerNoReturnAttr
Hold a pointer to a `clang::AnalyzerNoReturnAttr` object.
"""
struct AnalyzerNoReturnAttr <: AbstractAnalyzerNoReturnAttr
    ptr::CXAnalyzerNoReturnAttr
end

"""
    struct AnyX86InterruptAttr <: AbstractAnyX86InterruptAttr
Hold a pointer to a `clang::AnyX86InterruptAttr` object.
"""
struct AnyX86InterruptAttr <: AbstractAnyX86InterruptAttr
    ptr::CXAnyX86InterruptAttr
end

"""
    struct AnyX86NoCallerSavedRegistersAttr <: AbstractAnyX86NoCallerSavedRegistersAttr
Hold a pointer to a `clang::AnyX86NoCallerSavedRegistersAttr` object.
"""
struct AnyX86NoCallerSavedRegistersAttr <: AbstractAnyX86NoCallerSavedRegistersAttr
    ptr::CXAnyX86NoCallerSavedRegistersAttr
end

"""
    struct ArcWeakrefUnavailableAttr <: AbstractArcWeakrefUnavailableAttr
Hold a pointer to a `clang::ArcWeakrefUnavailableAttr` object.
"""
struct ArcWeakrefUnavailableAttr <: AbstractArcWeakrefUnavailableAttr
    ptr::CXArcWeakrefUnavailableAttr
end

"""
    struct ArgumentWithTypeTagAttr <: AbstractArgumentWithTypeTagAttr
Hold a pointer to a `clang::ArgumentWithTypeTagAttr` object.
"""
struct ArgumentWithTypeTagAttr <: AbstractArgumentWithTypeTagAttr
    ptr::CXArgumentWithTypeTagAttr
end

"""
    struct ArmBuiltinAliasAttr <: AbstractArmBuiltinAliasAttr
Hold a pointer to a `clang::ArmBuiltinAliasAttr` object.
"""
struct ArmBuiltinAliasAttr <: AbstractArmBuiltinAliasAttr
    ptr::CXArmBuiltinAliasAttr
end

"""
    struct ArmLocallyStreamingAttr <: AbstractArmLocallyStreamingAttr
Hold a pointer to a `clang::ArmLocallyStreamingAttr` object.
"""
struct ArmLocallyStreamingAttr <: AbstractArmLocallyStreamingAttr
    ptr::CXArmLocallyStreamingAttr
end

"""
    struct ArmNewAttr <: AbstractArmNewAttr
Hold a pointer to a `clang::ArmNewAttr` object.
"""
struct ArmNewAttr <: AbstractArmNewAttr
    ptr::CXArmNewAttr
end

"""
    struct ArtificialAttr <: AbstractArtificialAttr
Hold a pointer to a `clang::ArtificialAttr` object.
"""
struct ArtificialAttr <: AbstractArtificialAttr
    ptr::CXArtificialAttr
end

"""
    struct AsmLabelAttr <: AbstractAsmLabelAttr
Hold a pointer to a `clang::AsmLabelAttr` object.
"""
struct AsmLabelAttr <: AbstractAsmLabelAttr
    ptr::CXAsmLabelAttr
end

"""
    struct AssertCapabilityAttr <: AbstractAssertCapabilityAttr
Hold a pointer to a `clang::AssertCapabilityAttr` object.
"""
struct AssertCapabilityAttr <: AbstractAssertCapabilityAttr
    ptr::CXAssertCapabilityAttr
end

"""
    struct AssertExclusiveLockAttr <: AbstractAssertExclusiveLockAttr
Hold a pointer to a `clang::AssertExclusiveLockAttr` object.
"""
struct AssertExclusiveLockAttr <: AbstractAssertExclusiveLockAttr
    ptr::CXAssertExclusiveLockAttr
end

"""
    struct AssertSharedLockAttr <: AbstractAssertSharedLockAttr
Hold a pointer to a `clang::AssertSharedLockAttr` object.
"""
struct AssertSharedLockAttr <: AbstractAssertSharedLockAttr
    ptr::CXAssertSharedLockAttr
end

"""
    struct AssumeAlignedAttr <: AbstractAssumeAlignedAttr
Hold a pointer to a `clang::AssumeAlignedAttr` object.
"""
struct AssumeAlignedAttr <: AbstractAssumeAlignedAttr
    ptr::CXAssumeAlignedAttr
end

"""
    struct AssumptionAttr <: AbstractAssumptionAttr
Hold a pointer to a `clang::AssumptionAttr` object.
"""
struct AssumptionAttr <: AbstractAssumptionAttr
    ptr::CXAssumptionAttr
end

"""
    struct AvailabilityAttr <: AbstractAvailabilityAttr
Hold a pointer to a `clang::AvailabilityAttr` object.
"""
struct AvailabilityAttr <: AbstractAvailabilityAttr
    ptr::CXAvailabilityAttr
end

"""
    struct AvailableOnlyInDefaultEvalMethodAttr <: AbstractAvailableOnlyInDefaultEvalMethodAttr
Hold a pointer to a `clang::AvailableOnlyInDefaultEvalMethodAttr` object.
"""
struct AvailableOnlyInDefaultEvalMethodAttr <: AbstractAvailableOnlyInDefaultEvalMethodAttr
    ptr::CXAvailableOnlyInDefaultEvalMethodAttr
end

"""
    struct BPFPreserveAccessIndexAttr <: AbstractBPFPreserveAccessIndexAttr
Hold a pointer to a `clang::BPFPreserveAccessIndexAttr` object.
"""
struct BPFPreserveAccessIndexAttr <: AbstractBPFPreserveAccessIndexAttr
    ptr::CXBPFPreserveAccessIndexAttr
end

"""
    struct BPFPreserveStaticOffsetAttr <: AbstractBPFPreserveStaticOffsetAttr
Hold a pointer to a `clang::BPFPreserveStaticOffsetAttr` object.
"""
struct BPFPreserveStaticOffsetAttr <: AbstractBPFPreserveStaticOffsetAttr
    ptr::CXBPFPreserveStaticOffsetAttr
end

"""
    struct BTFDeclTagAttr <: AbstractBTFDeclTagAttr
Hold a pointer to a `clang::BTFDeclTagAttr` object.
"""
struct BTFDeclTagAttr <: AbstractBTFDeclTagAttr
    ptr::CXBTFDeclTagAttr
end

"""
    struct BlocksAttr <: AbstractBlocksAttr
Hold a pointer to a `clang::BlocksAttr` object.
"""
struct BlocksAttr <: AbstractBlocksAttr
    ptr::CXBlocksAttr
end

"""
    struct BuiltinAttr <: AbstractBuiltinAttr
Hold a pointer to a `clang::BuiltinAttr` object.
"""
struct BuiltinAttr <: AbstractBuiltinAttr
    ptr::CXBuiltinAttr
end

"""
    struct C11NoReturnAttr <: AbstractC11NoReturnAttr
Hold a pointer to a `clang::C11NoReturnAttr` object.
"""
struct C11NoReturnAttr <: AbstractC11NoReturnAttr
    ptr::CXC11NoReturnAttr
end

"""
    struct CFAuditedTransferAttr <: AbstractCFAuditedTransferAttr
Hold a pointer to a `clang::CFAuditedTransferAttr` object.
"""
struct CFAuditedTransferAttr <: AbstractCFAuditedTransferAttr
    ptr::CXCFAuditedTransferAttr
end

"""
    struct CFGuardAttr <: AbstractCFGuardAttr
Hold a pointer to a `clang::CFGuardAttr` object.
"""
struct CFGuardAttr <: AbstractCFGuardAttr
    ptr::CXCFGuardAttr
end

"""
    struct CFICanonicalJumpTableAttr <: AbstractCFICanonicalJumpTableAttr
Hold a pointer to a `clang::CFICanonicalJumpTableAttr` object.
"""
struct CFICanonicalJumpTableAttr <: AbstractCFICanonicalJumpTableAttr
    ptr::CXCFICanonicalJumpTableAttr
end

"""
    struct CFReturnsNotRetainedAttr <: AbstractCFReturnsNotRetainedAttr
Hold a pointer to a `clang::CFReturnsNotRetainedAttr` object.
"""
struct CFReturnsNotRetainedAttr <: AbstractCFReturnsNotRetainedAttr
    ptr::CXCFReturnsNotRetainedAttr
end

"""
    struct CFReturnsRetainedAttr <: AbstractCFReturnsRetainedAttr
Hold a pointer to a `clang::CFReturnsRetainedAttr` object.
"""
struct CFReturnsRetainedAttr <: AbstractCFReturnsRetainedAttr
    ptr::CXCFReturnsRetainedAttr
end

"""
    struct CFUnknownTransferAttr <: AbstractCFUnknownTransferAttr
Hold a pointer to a `clang::CFUnknownTransferAttr` object.
"""
struct CFUnknownTransferAttr <: AbstractCFUnknownTransferAttr
    ptr::CXCFUnknownTransferAttr
end

"""
    struct CPUDispatchAttr <: AbstractCPUDispatchAttr
Hold a pointer to a `clang::CPUDispatchAttr` object.
"""
struct CPUDispatchAttr <: AbstractCPUDispatchAttr
    ptr::CXCPUDispatchAttr
end

"""
    struct CPUSpecificAttr <: AbstractCPUSpecificAttr
Hold a pointer to a `clang::CPUSpecificAttr` object.
"""
struct CPUSpecificAttr <: AbstractCPUSpecificAttr
    ptr::CXCPUSpecificAttr
end

"""
    struct CUDAConstantAttr <: AbstractCUDAConstantAttr
Hold a pointer to a `clang::CUDAConstantAttr` object.
"""
struct CUDAConstantAttr <: AbstractCUDAConstantAttr
    ptr::CXCUDAConstantAttr
end

"""
    struct CUDADeviceAttr <: AbstractCUDADeviceAttr
Hold a pointer to a `clang::CUDADeviceAttr` object.
"""
struct CUDADeviceAttr <: AbstractCUDADeviceAttr
    ptr::CXCUDADeviceAttr
end

"""
    struct CUDADeviceBuiltinSurfaceTypeAttr <: AbstractCUDADeviceBuiltinSurfaceTypeAttr
Hold a pointer to a `clang::CUDADeviceBuiltinSurfaceTypeAttr` object.
"""
struct CUDADeviceBuiltinSurfaceTypeAttr <: AbstractCUDADeviceBuiltinSurfaceTypeAttr
    ptr::CXCUDADeviceBuiltinSurfaceTypeAttr
end

"""
    struct CUDADeviceBuiltinTextureTypeAttr <: AbstractCUDADeviceBuiltinTextureTypeAttr
Hold a pointer to a `clang::CUDADeviceBuiltinTextureTypeAttr` object.
"""
struct CUDADeviceBuiltinTextureTypeAttr <: AbstractCUDADeviceBuiltinTextureTypeAttr
    ptr::CXCUDADeviceBuiltinTextureTypeAttr
end

"""
    struct CUDAGlobalAttr <: AbstractCUDAGlobalAttr
Hold a pointer to a `clang::CUDAGlobalAttr` object.
"""
struct CUDAGlobalAttr <: AbstractCUDAGlobalAttr
    ptr::CXCUDAGlobalAttr
end

"""
    struct CUDAHostAttr <: AbstractCUDAHostAttr
Hold a pointer to a `clang::CUDAHostAttr` object.
"""
struct CUDAHostAttr <: AbstractCUDAHostAttr
    ptr::CXCUDAHostAttr
end

"""
    struct CUDAInvalidTargetAttr <: AbstractCUDAInvalidTargetAttr
Hold a pointer to a `clang::CUDAInvalidTargetAttr` object.
"""
struct CUDAInvalidTargetAttr <: AbstractCUDAInvalidTargetAttr
    ptr::CXCUDAInvalidTargetAttr
end

"""
    struct CUDALaunchBoundsAttr <: AbstractCUDALaunchBoundsAttr
Hold a pointer to a `clang::CUDALaunchBoundsAttr` object.
"""
struct CUDALaunchBoundsAttr <: AbstractCUDALaunchBoundsAttr
    ptr::CXCUDALaunchBoundsAttr
end

"""
    struct CUDASharedAttr <: AbstractCUDASharedAttr
Hold a pointer to a `clang::CUDASharedAttr` object.
"""
struct CUDASharedAttr <: AbstractCUDASharedAttr
    ptr::CXCUDASharedAttr
end

"""
    struct CXX11NoReturnAttr <: AbstractCXX11NoReturnAttr
Hold a pointer to a `clang::CXX11NoReturnAttr` object.
"""
struct CXX11NoReturnAttr <: AbstractCXX11NoReturnAttr
    ptr::CXCXX11NoReturnAttr
end

"""
    struct CallableWhenAttr <: AbstractCallableWhenAttr
Hold a pointer to a `clang::CallableWhenAttr` object.
"""
struct CallableWhenAttr <: AbstractCallableWhenAttr
    ptr::CXCallableWhenAttr
end

"""
    struct CallbackAttr <: AbstractCallbackAttr
Hold a pointer to a `clang::CallbackAttr` object.
"""
struct CallbackAttr <: AbstractCallbackAttr
    ptr::CXCallbackAttr
end

"""
    struct CapabilityAttr <: AbstractCapabilityAttr
Hold a pointer to a `clang::CapabilityAttr` object.
"""
struct CapabilityAttr <: AbstractCapabilityAttr
    ptr::CXCapabilityAttr
end

"""
    struct CapturedRecordAttr <: AbstractCapturedRecordAttr
Hold a pointer to a `clang::CapturedRecordAttr` object.
"""
struct CapturedRecordAttr <: AbstractCapturedRecordAttr
    ptr::CXCapturedRecordAttr
end

"""
    struct CleanupAttr <: AbstractCleanupAttr
Hold a pointer to a `clang::CleanupAttr` object.
"""
struct CleanupAttr <: AbstractCleanupAttr
    ptr::CXCleanupAttr
end

"""
    struct CmseNSEntryAttr <: AbstractCmseNSEntryAttr
Hold a pointer to a `clang::CmseNSEntryAttr` object.
"""
struct CmseNSEntryAttr <: AbstractCmseNSEntryAttr
    ptr::CXCmseNSEntryAttr
end

"""
    struct CodeModelAttr <: AbstractCodeModelAttr
Hold a pointer to a `clang::CodeModelAttr` object.
"""
struct CodeModelAttr <: AbstractCodeModelAttr
    ptr::CXCodeModelAttr
end

"""
    struct CodeSegAttr <: AbstractCodeSegAttr
Hold a pointer to a `clang::CodeSegAttr` object.
"""
struct CodeSegAttr <: AbstractCodeSegAttr
    ptr::CXCodeSegAttr
end

"""
    struct ColdAttr <: AbstractColdAttr
Hold a pointer to a `clang::ColdAttr` object.
"""
struct ColdAttr <: AbstractColdAttr
    ptr::CXColdAttr
end

"""
    struct CommonAttr <: AbstractCommonAttr
Hold a pointer to a `clang::CommonAttr` object.
"""
struct CommonAttr <: AbstractCommonAttr
    ptr::CXCommonAttr
end

"""
    struct ConstAttr <: AbstractConstAttr
Hold a pointer to a `clang::ConstAttr` object.
"""
struct ConstAttr <: AbstractConstAttr
    ptr::CXConstAttr
end

"""
    struct ConstInitAttr <: AbstractConstInitAttr
Hold a pointer to a `clang::ConstInitAttr` object.
"""
struct ConstInitAttr <: AbstractConstInitAttr
    ptr::CXConstInitAttr
end

"""
    struct ConstructorAttr <: AbstractConstructorAttr
Hold a pointer to a `clang::ConstructorAttr` object.
"""
struct ConstructorAttr <: AbstractConstructorAttr
    ptr::CXConstructorAttr
end

"""
    struct ConsumableAttr <: AbstractConsumableAttr
Hold a pointer to a `clang::ConsumableAttr` object.
"""
struct ConsumableAttr <: AbstractConsumableAttr
    ptr::CXConsumableAttr
end

"""
    struct ConsumableAutoCastAttr <: AbstractConsumableAutoCastAttr
Hold a pointer to a `clang::ConsumableAutoCastAttr` object.
"""
struct ConsumableAutoCastAttr <: AbstractConsumableAutoCastAttr
    ptr::CXConsumableAutoCastAttr
end

"""
    struct ConsumableSetOnReadAttr <: AbstractConsumableSetOnReadAttr
Hold a pointer to a `clang::ConsumableSetOnReadAttr` object.
"""
struct ConsumableSetOnReadAttr <: AbstractConsumableSetOnReadAttr
    ptr::CXConsumableSetOnReadAttr
end

"""
    struct ConvergentAttr <: AbstractConvergentAttr
Hold a pointer to a `clang::ConvergentAttr` object.
"""
struct ConvergentAttr <: AbstractConvergentAttr
    ptr::CXConvergentAttr
end

"""
    struct CoroDisableLifetimeBoundAttr <: AbstractCoroDisableLifetimeBoundAttr
Hold a pointer to a `clang::CoroDisableLifetimeBoundAttr` object.
"""
struct CoroDisableLifetimeBoundAttr <: AbstractCoroDisableLifetimeBoundAttr
    ptr::CXCoroDisableLifetimeBoundAttr
end

"""
    struct CoroLifetimeBoundAttr <: AbstractCoroLifetimeBoundAttr
Hold a pointer to a `clang::CoroLifetimeBoundAttr` object.
"""
struct CoroLifetimeBoundAttr <: AbstractCoroLifetimeBoundAttr
    ptr::CXCoroLifetimeBoundAttr
end

"""
    struct CoroOnlyDestroyWhenCompleteAttr <: AbstractCoroOnlyDestroyWhenCompleteAttr
Hold a pointer to a `clang::CoroOnlyDestroyWhenCompleteAttr` object.
"""
struct CoroOnlyDestroyWhenCompleteAttr <: AbstractCoroOnlyDestroyWhenCompleteAttr
    ptr::CXCoroOnlyDestroyWhenCompleteAttr
end

"""
    struct CoroReturnTypeAttr <: AbstractCoroReturnTypeAttr
Hold a pointer to a `clang::CoroReturnTypeAttr` object.
"""
struct CoroReturnTypeAttr <: AbstractCoroReturnTypeAttr
    ptr::CXCoroReturnTypeAttr
end

"""
    struct CoroWrapperAttr <: AbstractCoroWrapperAttr
Hold a pointer to a `clang::CoroWrapperAttr` object.
"""
struct CoroWrapperAttr <: AbstractCoroWrapperAttr
    ptr::CXCoroWrapperAttr
end

"""
    struct CountedByAttr <: AbstractCountedByAttr
Hold a pointer to a `clang::CountedByAttr` object.
"""
struct CountedByAttr <: AbstractCountedByAttr
    ptr::CXCountedByAttr
end

"""
    struct DLLExportAttr <: AbstractDLLExportAttr
Hold a pointer to a `clang::DLLExportAttr` object.
"""
struct DLLExportAttr <: AbstractDLLExportAttr
    ptr::CXDLLExportAttr
end

"""
    struct DLLExportStaticLocalAttr <: AbstractDLLExportStaticLocalAttr
Hold a pointer to a `clang::DLLExportStaticLocalAttr` object.
"""
struct DLLExportStaticLocalAttr <: AbstractDLLExportStaticLocalAttr
    ptr::CXDLLExportStaticLocalAttr
end

"""
    struct DLLImportAttr <: AbstractDLLImportAttr
Hold a pointer to a `clang::DLLImportAttr` object.
"""
struct DLLImportAttr <: AbstractDLLImportAttr
    ptr::CXDLLImportAttr
end

"""
    struct DLLImportStaticLocalAttr <: AbstractDLLImportStaticLocalAttr
Hold a pointer to a `clang::DLLImportStaticLocalAttr` object.
"""
struct DLLImportStaticLocalAttr <: AbstractDLLImportStaticLocalAttr
    ptr::CXDLLImportStaticLocalAttr
end

"""
    struct DeprecatedAttr <: AbstractDeprecatedAttr
Hold a pointer to a `clang::DeprecatedAttr` object.
"""
struct DeprecatedAttr <: AbstractDeprecatedAttr
    ptr::CXDeprecatedAttr
end

"""
    struct DestructorAttr <: AbstractDestructorAttr
Hold a pointer to a `clang::DestructorAttr` object.
"""
struct DestructorAttr <: AbstractDestructorAttr
    ptr::CXDestructorAttr
end

"""
    struct DiagnoseAsBuiltinAttr <: AbstractDiagnoseAsBuiltinAttr
Hold a pointer to a `clang::DiagnoseAsBuiltinAttr` object.
"""
struct DiagnoseAsBuiltinAttr <: AbstractDiagnoseAsBuiltinAttr
    ptr::CXDiagnoseAsBuiltinAttr
end

"""
    struct DiagnoseIfAttr <: AbstractDiagnoseIfAttr
Hold a pointer to a `clang::DiagnoseIfAttr` object.
"""
struct DiagnoseIfAttr <: AbstractDiagnoseIfAttr
    ptr::CXDiagnoseIfAttr
end

"""
    struct DisableSanitizerInstrumentationAttr <: AbstractDisableSanitizerInstrumentationAttr
Hold a pointer to a `clang::DisableSanitizerInstrumentationAttr` object.
"""
struct DisableSanitizerInstrumentationAttr <: AbstractDisableSanitizerInstrumentationAttr
    ptr::CXDisableSanitizerInstrumentationAttr
end

"""
    struct DisableTailCallsAttr <: AbstractDisableTailCallsAttr
Hold a pointer to a `clang::DisableTailCallsAttr` object.
"""
struct DisableTailCallsAttr <: AbstractDisableTailCallsAttr
    ptr::CXDisableTailCallsAttr
end

"""
    struct EmptyBasesAttr <: AbstractEmptyBasesAttr
Hold a pointer to a `clang::EmptyBasesAttr` object.
"""
struct EmptyBasesAttr <: AbstractEmptyBasesAttr
    ptr::CXEmptyBasesAttr
end

"""
    struct EnableIfAttr <: AbstractEnableIfAttr
Hold a pointer to a `clang::EnableIfAttr` object.
"""
struct EnableIfAttr <: AbstractEnableIfAttr
    ptr::CXEnableIfAttr
end

"""
    struct EnforceTCBAttr <: AbstractEnforceTCBAttr
Hold a pointer to a `clang::EnforceTCBAttr` object.
"""
struct EnforceTCBAttr <: AbstractEnforceTCBAttr
    ptr::CXEnforceTCBAttr
end

"""
    struct EnforceTCBLeafAttr <: AbstractEnforceTCBLeafAttr
Hold a pointer to a `clang::EnforceTCBLeafAttr` object.
"""
struct EnforceTCBLeafAttr <: AbstractEnforceTCBLeafAttr
    ptr::CXEnforceTCBLeafAttr
end

"""
    struct EnumExtensibilityAttr <: AbstractEnumExtensibilityAttr
Hold a pointer to a `clang::EnumExtensibilityAttr` object.
"""
struct EnumExtensibilityAttr <: AbstractEnumExtensibilityAttr
    ptr::CXEnumExtensibilityAttr
end

"""
    struct ErrorAttr <: AbstractErrorAttr
Hold a pointer to a `clang::ErrorAttr` object.
"""
struct ErrorAttr <: AbstractErrorAttr
    ptr::CXErrorAttr
end

"""
    struct ExcludeFromExplicitInstantiationAttr <: AbstractExcludeFromExplicitInstantiationAttr
Hold a pointer to a `clang::ExcludeFromExplicitInstantiationAttr` object.
"""
struct ExcludeFromExplicitInstantiationAttr <: AbstractExcludeFromExplicitInstantiationAttr
    ptr::CXExcludeFromExplicitInstantiationAttr
end

"""
    struct ExclusiveTrylockFunctionAttr <: AbstractExclusiveTrylockFunctionAttr
Hold a pointer to a `clang::ExclusiveTrylockFunctionAttr` object.
"""
struct ExclusiveTrylockFunctionAttr <: AbstractExclusiveTrylockFunctionAttr
    ptr::CXExclusiveTrylockFunctionAttr
end

"""
    struct ExternalSourceSymbolAttr <: AbstractExternalSourceSymbolAttr
Hold a pointer to a `clang::ExternalSourceSymbolAttr` object.
"""
struct ExternalSourceSymbolAttr <: AbstractExternalSourceSymbolAttr
    ptr::CXExternalSourceSymbolAttr
end

"""
    struct FinalAttr <: AbstractFinalAttr
Hold a pointer to a `clang::FinalAttr` object.
"""
struct FinalAttr <: AbstractFinalAttr
    ptr::CXFinalAttr
end

"""
    struct FlagEnumAttr <: AbstractFlagEnumAttr
Hold a pointer to a `clang::FlagEnumAttr` object.
"""
struct FlagEnumAttr <: AbstractFlagEnumAttr
    ptr::CXFlagEnumAttr
end

"""
    struct FlattenAttr <: AbstractFlattenAttr
Hold a pointer to a `clang::FlattenAttr` object.
"""
struct FlattenAttr <: AbstractFlattenAttr
    ptr::CXFlattenAttr
end

"""
    struct FormatAttr <: AbstractFormatAttr
Hold a pointer to a `clang::FormatAttr` object.
"""
struct FormatAttr <: AbstractFormatAttr
    ptr::CXFormatAttr
end

"""
    struct FormatArgAttr <: AbstractFormatArgAttr
Hold a pointer to a `clang::FormatArgAttr` object.
"""
struct FormatArgAttr <: AbstractFormatArgAttr
    ptr::CXFormatArgAttr
end

"""
    struct FunctionReturnThunksAttr <: AbstractFunctionReturnThunksAttr
Hold a pointer to a `clang::FunctionReturnThunksAttr` object.
"""
struct FunctionReturnThunksAttr <: AbstractFunctionReturnThunksAttr
    ptr::CXFunctionReturnThunksAttr
end

"""
    struct GNUInlineAttr <: AbstractGNUInlineAttr
Hold a pointer to a `clang::GNUInlineAttr` object.
"""
struct GNUInlineAttr <: AbstractGNUInlineAttr
    ptr::CXGNUInlineAttr
end

"""
    struct GuardedByAttr <: AbstractGuardedByAttr
Hold a pointer to a `clang::GuardedByAttr` object.
"""
struct GuardedByAttr <: AbstractGuardedByAttr
    ptr::CXGuardedByAttr
end

"""
    struct GuardedVarAttr <: AbstractGuardedVarAttr
Hold a pointer to a `clang::GuardedVarAttr` object.
"""
struct GuardedVarAttr <: AbstractGuardedVarAttr
    ptr::CXGuardedVarAttr
end

"""
    struct HIPManagedAttr <: AbstractHIPManagedAttr
Hold a pointer to a `clang::HIPManagedAttr` object.
"""
struct HIPManagedAttr <: AbstractHIPManagedAttr
    ptr::CXHIPManagedAttr
end

"""
    struct HLSLNumThreadsAttr <: AbstractHLSLNumThreadsAttr
Hold a pointer to a `clang::HLSLNumThreadsAttr` object.
"""
struct HLSLNumThreadsAttr <: AbstractHLSLNumThreadsAttr
    ptr::CXHLSLNumThreadsAttr
end

"""
    struct HLSLResourceAttr <: AbstractHLSLResourceAttr
Hold a pointer to a `clang::HLSLResourceAttr` object.
"""
struct HLSLResourceAttr <: AbstractHLSLResourceAttr
    ptr::CXHLSLResourceAttr
end

"""
    struct HLSLResourceBindingAttr <: AbstractHLSLResourceBindingAttr
Hold a pointer to a `clang::HLSLResourceBindingAttr` object.
"""
struct HLSLResourceBindingAttr <: AbstractHLSLResourceBindingAttr
    ptr::CXHLSLResourceBindingAttr
end

"""
    struct HLSLShaderAttr <: AbstractHLSLShaderAttr
Hold a pointer to a `clang::HLSLShaderAttr` object.
"""
struct HLSLShaderAttr <: AbstractHLSLShaderAttr
    ptr::CXHLSLShaderAttr
end

"""
    struct HotAttr <: AbstractHotAttr
Hold a pointer to a `clang::HotAttr` object.
"""
struct HotAttr <: AbstractHotAttr
    ptr::CXHotAttr
end

"""
    struct IBActionAttr <: AbstractIBActionAttr
Hold a pointer to a `clang::IBActionAttr` object.
"""
struct IBActionAttr <: AbstractIBActionAttr
    ptr::CXIBActionAttr
end

"""
    struct IBOutletAttr <: AbstractIBOutletAttr
Hold a pointer to a `clang::IBOutletAttr` object.
"""
struct IBOutletAttr <: AbstractIBOutletAttr
    ptr::CXIBOutletAttr
end

"""
    struct IBOutletCollectionAttr <: AbstractIBOutletCollectionAttr
Hold a pointer to a `clang::IBOutletCollectionAttr` object.
"""
struct IBOutletCollectionAttr <: AbstractIBOutletCollectionAttr
    ptr::CXIBOutletCollectionAttr
end

"""
    struct InitPriorityAttr <: AbstractInitPriorityAttr
Hold a pointer to a `clang::InitPriorityAttr` object.
"""
struct InitPriorityAttr <: AbstractInitPriorityAttr
    ptr::CXInitPriorityAttr
end

"""
    struct InternalLinkageAttr <: AbstractInternalLinkageAttr
Hold a pointer to a `clang::InternalLinkageAttr` object.
"""
struct InternalLinkageAttr <: AbstractInternalLinkageAttr
    ptr::CXInternalLinkageAttr
end

"""
    struct LTOVisibilityPublicAttr <: AbstractLTOVisibilityPublicAttr
Hold a pointer to a `clang::LTOVisibilityPublicAttr` object.
"""
struct LTOVisibilityPublicAttr <: AbstractLTOVisibilityPublicAttr
    ptr::CXLTOVisibilityPublicAttr
end

"""
    struct LayoutVersionAttr <: AbstractLayoutVersionAttr
Hold a pointer to a `clang::LayoutVersionAttr` object.
"""
struct LayoutVersionAttr <: AbstractLayoutVersionAttr
    ptr::CXLayoutVersionAttr
end

"""
    struct LeafAttr <: AbstractLeafAttr
Hold a pointer to a `clang::LeafAttr` object.
"""
struct LeafAttr <: AbstractLeafAttr
    ptr::CXLeafAttr
end

"""
    struct LockReturnedAttr <: AbstractLockReturnedAttr
Hold a pointer to a `clang::LockReturnedAttr` object.
"""
struct LockReturnedAttr <: AbstractLockReturnedAttr
    ptr::CXLockReturnedAttr
end

"""
    struct LocksExcludedAttr <: AbstractLocksExcludedAttr
Hold a pointer to a `clang::LocksExcludedAttr` object.
"""
struct LocksExcludedAttr <: AbstractLocksExcludedAttr
    ptr::CXLocksExcludedAttr
end

"""
    struct M68kInterruptAttr <: AbstractM68kInterruptAttr
Hold a pointer to a `clang::M68kInterruptAttr` object.
"""
struct M68kInterruptAttr <: AbstractM68kInterruptAttr
    ptr::CXM68kInterruptAttr
end

"""
    struct MIGServerRoutineAttr <: AbstractMIGServerRoutineAttr
Hold a pointer to a `clang::MIGServerRoutineAttr` object.
"""
struct MIGServerRoutineAttr <: AbstractMIGServerRoutineAttr
    ptr::CXMIGServerRoutineAttr
end

"""
    struct MSAllocatorAttr <: AbstractMSAllocatorAttr
Hold a pointer to a `clang::MSAllocatorAttr` object.
"""
struct MSAllocatorAttr <: AbstractMSAllocatorAttr
    ptr::CXMSAllocatorAttr
end

"""
    struct MSConstexprAttr <: AbstractMSConstexprAttr
Hold a pointer to a `clang::MSConstexprAttr` object.
"""
struct MSConstexprAttr <: AbstractMSConstexprAttr
    ptr::CXMSConstexprAttr
end

"""
    struct MSInheritanceAttr <: AbstractMSInheritanceAttr
Hold a pointer to a `clang::MSInheritanceAttr` object.
"""
struct MSInheritanceAttr <: AbstractMSInheritanceAttr
    ptr::CXMSInheritanceAttr
end

"""
    struct MSNoVTableAttr <: AbstractMSNoVTableAttr
Hold a pointer to a `clang::MSNoVTableAttr` object.
"""
struct MSNoVTableAttr <: AbstractMSNoVTableAttr
    ptr::CXMSNoVTableAttr
end

"""
    struct MSP430InterruptAttr <: AbstractMSP430InterruptAttr
Hold a pointer to a `clang::MSP430InterruptAttr` object.
"""
struct MSP430InterruptAttr <: AbstractMSP430InterruptAttr
    ptr::CXMSP430InterruptAttr
end

"""
    struct MSStructAttr <: AbstractMSStructAttr
Hold a pointer to a `clang::MSStructAttr` object.
"""
struct MSStructAttr <: AbstractMSStructAttr
    ptr::CXMSStructAttr
end

"""
    struct MSVtorDispAttr <: AbstractMSVtorDispAttr
Hold a pointer to a `clang::MSVtorDispAttr` object.
"""
struct MSVtorDispAttr <: AbstractMSVtorDispAttr
    ptr::CXMSVtorDispAttr
end

"""
    struct MaxFieldAlignmentAttr <: AbstractMaxFieldAlignmentAttr
Hold a pointer to a `clang::MaxFieldAlignmentAttr` object.
"""
struct MaxFieldAlignmentAttr <: AbstractMaxFieldAlignmentAttr
    ptr::CXMaxFieldAlignmentAttr
end

"""
    struct MayAliasAttr <: AbstractMayAliasAttr
Hold a pointer to a `clang::MayAliasAttr` object.
"""
struct MayAliasAttr <: AbstractMayAliasAttr
    ptr::CXMayAliasAttr
end

"""
    struct MaybeUndefAttr <: AbstractMaybeUndefAttr
Hold a pointer to a `clang::MaybeUndefAttr` object.
"""
struct MaybeUndefAttr <: AbstractMaybeUndefAttr
    ptr::CXMaybeUndefAttr
end

"""
    struct MicroMipsAttr <: AbstractMicroMipsAttr
Hold a pointer to a `clang::MicroMipsAttr` object.
"""
struct MicroMipsAttr <: AbstractMicroMipsAttr
    ptr::CXMicroMipsAttr
end

"""
    struct MinSizeAttr <: AbstractMinSizeAttr
Hold a pointer to a `clang::MinSizeAttr` object.
"""
struct MinSizeAttr <: AbstractMinSizeAttr
    ptr::CXMinSizeAttr
end

"""
    struct MinVectorWidthAttr <: AbstractMinVectorWidthAttr
Hold a pointer to a `clang::MinVectorWidthAttr` object.
"""
struct MinVectorWidthAttr <: AbstractMinVectorWidthAttr
    ptr::CXMinVectorWidthAttr
end

"""
    struct Mips16Attr <: AbstractMips16Attr
Hold a pointer to a `clang::Mips16Attr` object.
"""
struct Mips16Attr <: AbstractMips16Attr
    ptr::CXMips16Attr
end

"""
    struct MipsInterruptAttr <: AbstractMipsInterruptAttr
Hold a pointer to a `clang::MipsInterruptAttr` object.
"""
struct MipsInterruptAttr <: AbstractMipsInterruptAttr
    ptr::CXMipsInterruptAttr
end

"""
    struct MipsLongCallAttr <: AbstractMipsLongCallAttr
Hold a pointer to a `clang::MipsLongCallAttr` object.
"""
struct MipsLongCallAttr <: AbstractMipsLongCallAttr
    ptr::CXMipsLongCallAttr
end

"""
    struct MipsShortCallAttr <: AbstractMipsShortCallAttr
Hold a pointer to a `clang::MipsShortCallAttr` object.
"""
struct MipsShortCallAttr <: AbstractMipsShortCallAttr
    ptr::CXMipsShortCallAttr
end

"""
    struct NSConsumesSelfAttr <: AbstractNSConsumesSelfAttr
Hold a pointer to a `clang::NSConsumesSelfAttr` object.
"""
struct NSConsumesSelfAttr <: AbstractNSConsumesSelfAttr
    ptr::CXNSConsumesSelfAttr
end

"""
    struct NSErrorDomainAttr <: AbstractNSErrorDomainAttr
Hold a pointer to a `clang::NSErrorDomainAttr` object.
"""
struct NSErrorDomainAttr <: AbstractNSErrorDomainAttr
    ptr::CXNSErrorDomainAttr
end

"""
    struct NSReturnsAutoreleasedAttr <: AbstractNSReturnsAutoreleasedAttr
Hold a pointer to a `clang::NSReturnsAutoreleasedAttr` object.
"""
struct NSReturnsAutoreleasedAttr <: AbstractNSReturnsAutoreleasedAttr
    ptr::CXNSReturnsAutoreleasedAttr
end

"""
    struct NSReturnsNotRetainedAttr <: AbstractNSReturnsNotRetainedAttr
Hold a pointer to a `clang::NSReturnsNotRetainedAttr` object.
"""
struct NSReturnsNotRetainedAttr <: AbstractNSReturnsNotRetainedAttr
    ptr::CXNSReturnsNotRetainedAttr
end

"""
    struct NVPTXKernelAttr <: AbstractNVPTXKernelAttr
Hold a pointer to a `clang::NVPTXKernelAttr` object.
"""
struct NVPTXKernelAttr <: AbstractNVPTXKernelAttr
    ptr::CXNVPTXKernelAttr
end

"""
    struct NakedAttr <: AbstractNakedAttr
Hold a pointer to a `clang::NakedAttr` object.
"""
struct NakedAttr <: AbstractNakedAttr
    ptr::CXNakedAttr
end

"""
    struct NoAliasAttr <: AbstractNoAliasAttr
Hold a pointer to a `clang::NoAliasAttr` object.
"""
struct NoAliasAttr <: AbstractNoAliasAttr
    ptr::CXNoAliasAttr
end

"""
    struct NoCommonAttr <: AbstractNoCommonAttr
Hold a pointer to a `clang::NoCommonAttr` object.
"""
struct NoCommonAttr <: AbstractNoCommonAttr
    ptr::CXNoCommonAttr
end

"""
    struct NoDebugAttr <: AbstractNoDebugAttr
Hold a pointer to a `clang::NoDebugAttr` object.
"""
struct NoDebugAttr <: AbstractNoDebugAttr
    ptr::CXNoDebugAttr
end

"""
    struct NoDestroyAttr <: AbstractNoDestroyAttr
Hold a pointer to a `clang::NoDestroyAttr` object.
"""
struct NoDestroyAttr <: AbstractNoDestroyAttr
    ptr::CXNoDestroyAttr
end

"""
    struct NoDuplicateAttr <: AbstractNoDuplicateAttr
Hold a pointer to a `clang::NoDuplicateAttr` object.
"""
struct NoDuplicateAttr <: AbstractNoDuplicateAttr
    ptr::CXNoDuplicateAttr
end

"""
    struct NoInstrumentFunctionAttr <: AbstractNoInstrumentFunctionAttr
Hold a pointer to a `clang::NoInstrumentFunctionAttr` object.
"""
struct NoInstrumentFunctionAttr <: AbstractNoInstrumentFunctionAttr
    ptr::CXNoInstrumentFunctionAttr
end

"""
    struct NoMicroMipsAttr <: AbstractNoMicroMipsAttr
Hold a pointer to a `clang::NoMicroMipsAttr` object.
"""
struct NoMicroMipsAttr <: AbstractNoMicroMipsAttr
    ptr::CXNoMicroMipsAttr
end

"""
    struct NoMips16Attr <: AbstractNoMips16Attr
Hold a pointer to a `clang::NoMips16Attr` object.
"""
struct NoMips16Attr <: AbstractNoMips16Attr
    ptr::CXNoMips16Attr
end

"""
    struct NoProfileFunctionAttr <: AbstractNoProfileFunctionAttr
Hold a pointer to a `clang::NoProfileFunctionAttr` object.
"""
struct NoProfileFunctionAttr <: AbstractNoProfileFunctionAttr
    ptr::CXNoProfileFunctionAttr
end

"""
    struct NoRandomizeLayoutAttr <: AbstractNoRandomizeLayoutAttr
Hold a pointer to a `clang::NoRandomizeLayoutAttr` object.
"""
struct NoRandomizeLayoutAttr <: AbstractNoRandomizeLayoutAttr
    ptr::CXNoRandomizeLayoutAttr
end

"""
    struct NoReturnAttr <: AbstractNoReturnAttr
Hold a pointer to a `clang::NoReturnAttr` object.
"""
struct NoReturnAttr <: AbstractNoReturnAttr
    ptr::CXNoReturnAttr
end

"""
    struct NoSanitizeAttr <: AbstractNoSanitizeAttr
Hold a pointer to a `clang::NoSanitizeAttr` object.
"""
struct NoSanitizeAttr <: AbstractNoSanitizeAttr
    ptr::CXNoSanitizeAttr
end

"""
    struct NoSpeculativeLoadHardeningAttr <: AbstractNoSpeculativeLoadHardeningAttr
Hold a pointer to a `clang::NoSpeculativeLoadHardeningAttr` object.
"""
struct NoSpeculativeLoadHardeningAttr <: AbstractNoSpeculativeLoadHardeningAttr
    ptr::CXNoSpeculativeLoadHardeningAttr
end

"""
    struct NoSplitStackAttr <: AbstractNoSplitStackAttr
Hold a pointer to a `clang::NoSplitStackAttr` object.
"""
struct NoSplitStackAttr <: AbstractNoSplitStackAttr
    ptr::CXNoSplitStackAttr
end

"""
    struct NoStackProtectorAttr <: AbstractNoStackProtectorAttr
Hold a pointer to a `clang::NoStackProtectorAttr` object.
"""
struct NoStackProtectorAttr <: AbstractNoStackProtectorAttr
    ptr::CXNoStackProtectorAttr
end

"""
    struct NoThreadSafetyAnalysisAttr <: AbstractNoThreadSafetyAnalysisAttr
Hold a pointer to a `clang::NoThreadSafetyAnalysisAttr` object.
"""
struct NoThreadSafetyAnalysisAttr <: AbstractNoThreadSafetyAnalysisAttr
    ptr::CXNoThreadSafetyAnalysisAttr
end

"""
    struct NoThrowAttr <: AbstractNoThrowAttr
Hold a pointer to a `clang::NoThrowAttr` object.
"""
struct NoThrowAttr <: AbstractNoThrowAttr
    ptr::CXNoThrowAttr
end

"""
    struct NoUniqueAddressAttr <: AbstractNoUniqueAddressAttr
Hold a pointer to a `clang::NoUniqueAddressAttr` object.
"""
struct NoUniqueAddressAttr <: AbstractNoUniqueAddressAttr
    ptr::CXNoUniqueAddressAttr
end

"""
    struct NoUwtableAttr <: AbstractNoUwtableAttr
Hold a pointer to a `clang::NoUwtableAttr` object.
"""
struct NoUwtableAttr <: AbstractNoUwtableAttr
    ptr::CXNoUwtableAttr
end

"""
    struct NotTailCalledAttr <: AbstractNotTailCalledAttr
Hold a pointer to a `clang::NotTailCalledAttr` object.
"""
struct NotTailCalledAttr <: AbstractNotTailCalledAttr
    ptr::CXNotTailCalledAttr
end

"""
    struct OMPAllocateDeclAttr <: AbstractOMPAllocateDeclAttr
Hold a pointer to a `clang::OMPAllocateDeclAttr` object.
"""
struct OMPAllocateDeclAttr <: AbstractOMPAllocateDeclAttr
    ptr::CXOMPAllocateDeclAttr
end

"""
    struct OMPCaptureNoInitAttr <: AbstractOMPCaptureNoInitAttr
Hold a pointer to a `clang::OMPCaptureNoInitAttr` object.
"""
struct OMPCaptureNoInitAttr <: AbstractOMPCaptureNoInitAttr
    ptr::CXOMPCaptureNoInitAttr
end

"""
    struct OMPDeclareTargetDeclAttr <: AbstractOMPDeclareTargetDeclAttr
Hold a pointer to a `clang::OMPDeclareTargetDeclAttr` object.
"""
struct OMPDeclareTargetDeclAttr <: AbstractOMPDeclareTargetDeclAttr
    ptr::CXOMPDeclareTargetDeclAttr
end

"""
    struct OMPDeclareVariantAttr <: AbstractOMPDeclareVariantAttr
Hold a pointer to a `clang::OMPDeclareVariantAttr` object.
"""
struct OMPDeclareVariantAttr <: AbstractOMPDeclareVariantAttr
    ptr::CXOMPDeclareVariantAttr
end

"""
    struct OMPThreadPrivateDeclAttr <: AbstractOMPThreadPrivateDeclAttr
Hold a pointer to a `clang::OMPThreadPrivateDeclAttr` object.
"""
struct OMPThreadPrivateDeclAttr <: AbstractOMPThreadPrivateDeclAttr
    ptr::CXOMPThreadPrivateDeclAttr
end

"""
    struct OSConsumesThisAttr <: AbstractOSConsumesThisAttr
Hold a pointer to a `clang::OSConsumesThisAttr` object.
"""
struct OSConsumesThisAttr <: AbstractOSConsumesThisAttr
    ptr::CXOSConsumesThisAttr
end

"""
    struct OSReturnsNotRetainedAttr <: AbstractOSReturnsNotRetainedAttr
Hold a pointer to a `clang::OSReturnsNotRetainedAttr` object.
"""
struct OSReturnsNotRetainedAttr <: AbstractOSReturnsNotRetainedAttr
    ptr::CXOSReturnsNotRetainedAttr
end

"""
    struct OSReturnsRetainedAttr <: AbstractOSReturnsRetainedAttr
Hold a pointer to a `clang::OSReturnsRetainedAttr` object.
"""
struct OSReturnsRetainedAttr <: AbstractOSReturnsRetainedAttr
    ptr::CXOSReturnsRetainedAttr
end

"""
    struct OSReturnsRetainedOnNonZeroAttr <: AbstractOSReturnsRetainedOnNonZeroAttr
Hold a pointer to a `clang::OSReturnsRetainedOnNonZeroAttr` object.
"""
struct OSReturnsRetainedOnNonZeroAttr <: AbstractOSReturnsRetainedOnNonZeroAttr
    ptr::CXOSReturnsRetainedOnNonZeroAttr
end

"""
    struct OSReturnsRetainedOnZeroAttr <: AbstractOSReturnsRetainedOnZeroAttr
Hold a pointer to a `clang::OSReturnsRetainedOnZeroAttr` object.
"""
struct OSReturnsRetainedOnZeroAttr <: AbstractOSReturnsRetainedOnZeroAttr
    ptr::CXOSReturnsRetainedOnZeroAttr
end

"""
    struct ObjCBridgeAttr <: AbstractObjCBridgeAttr
Hold a pointer to a `clang::ObjCBridgeAttr` object.
"""
struct ObjCBridgeAttr <: AbstractObjCBridgeAttr
    ptr::CXObjCBridgeAttr
end

"""
    struct ObjCBridgeMutableAttr <: AbstractObjCBridgeMutableAttr
Hold a pointer to a `clang::ObjCBridgeMutableAttr` object.
"""
struct ObjCBridgeMutableAttr <: AbstractObjCBridgeMutableAttr
    ptr::CXObjCBridgeMutableAttr
end

"""
    struct ObjCBridgeRelatedAttr <: AbstractObjCBridgeRelatedAttr
Hold a pointer to a `clang::ObjCBridgeRelatedAttr` object.
"""
struct ObjCBridgeRelatedAttr <: AbstractObjCBridgeRelatedAttr
    ptr::CXObjCBridgeRelatedAttr
end

"""
    struct ObjCExceptionAttr <: AbstractObjCExceptionAttr
Hold a pointer to a `clang::ObjCExceptionAttr` object.
"""
struct ObjCExceptionAttr <: AbstractObjCExceptionAttr
    ptr::CXObjCExceptionAttr
end

"""
    struct ObjCExplicitProtocolImplAttr <: AbstractObjCExplicitProtocolImplAttr
Hold a pointer to a `clang::ObjCExplicitProtocolImplAttr` object.
"""
struct ObjCExplicitProtocolImplAttr <: AbstractObjCExplicitProtocolImplAttr
    ptr::CXObjCExplicitProtocolImplAttr
end

"""
    struct ObjCExternallyRetainedAttr <: AbstractObjCExternallyRetainedAttr
Hold a pointer to a `clang::ObjCExternallyRetainedAttr` object.
"""
struct ObjCExternallyRetainedAttr <: AbstractObjCExternallyRetainedAttr
    ptr::CXObjCExternallyRetainedAttr
end

"""
    struct ObjCIndependentClassAttr <: AbstractObjCIndependentClassAttr
Hold a pointer to a `clang::ObjCIndependentClassAttr` object.
"""
struct ObjCIndependentClassAttr <: AbstractObjCIndependentClassAttr
    ptr::CXObjCIndependentClassAttr
end

"""
    struct ObjCMethodFamilyAttr <: AbstractObjCMethodFamilyAttr
Hold a pointer to a `clang::ObjCMethodFamilyAttr` object.
"""
struct ObjCMethodFamilyAttr <: AbstractObjCMethodFamilyAttr
    ptr::CXObjCMethodFamilyAttr
end

"""
    struct ObjCNSObjectAttr <: AbstractObjCNSObjectAttr
Hold a pointer to a `clang::ObjCNSObjectAttr` object.
"""
struct ObjCNSObjectAttr <: AbstractObjCNSObjectAttr
    ptr::CXObjCNSObjectAttr
end

"""
    struct ObjCPreciseLifetimeAttr <: AbstractObjCPreciseLifetimeAttr
Hold a pointer to a `clang::ObjCPreciseLifetimeAttr` object.
"""
struct ObjCPreciseLifetimeAttr <: AbstractObjCPreciseLifetimeAttr
    ptr::CXObjCPreciseLifetimeAttr
end

"""
    struct ObjCRequiresPropertyDefsAttr <: AbstractObjCRequiresPropertyDefsAttr
Hold a pointer to a `clang::ObjCRequiresPropertyDefsAttr` object.
"""
struct ObjCRequiresPropertyDefsAttr <: AbstractObjCRequiresPropertyDefsAttr
    ptr::CXObjCRequiresPropertyDefsAttr
end

"""
    struct ObjCRequiresSuperAttr <: AbstractObjCRequiresSuperAttr
Hold a pointer to a `clang::ObjCRequiresSuperAttr` object.
"""
struct ObjCRequiresSuperAttr <: AbstractObjCRequiresSuperAttr
    ptr::CXObjCRequiresSuperAttr
end

"""
    struct ObjCReturnsInnerPointerAttr <: AbstractObjCReturnsInnerPointerAttr
Hold a pointer to a `clang::ObjCReturnsInnerPointerAttr` object.
"""
struct ObjCReturnsInnerPointerAttr <: AbstractObjCReturnsInnerPointerAttr
    ptr::CXObjCReturnsInnerPointerAttr
end

"""
    struct ObjCRootClassAttr <: AbstractObjCRootClassAttr
Hold a pointer to a `clang::ObjCRootClassAttr` object.
"""
struct ObjCRootClassAttr <: AbstractObjCRootClassAttr
    ptr::CXObjCRootClassAttr
end

"""
    struct ObjCSubclassingRestrictedAttr <: AbstractObjCSubclassingRestrictedAttr
Hold a pointer to a `clang::ObjCSubclassingRestrictedAttr` object.
"""
struct ObjCSubclassingRestrictedAttr <: AbstractObjCSubclassingRestrictedAttr
    ptr::CXObjCSubclassingRestrictedAttr
end

"""
    struct OpenCLIntelReqdSubGroupSizeAttr <: AbstractOpenCLIntelReqdSubGroupSizeAttr
Hold a pointer to a `clang::OpenCLIntelReqdSubGroupSizeAttr` object.
"""
struct OpenCLIntelReqdSubGroupSizeAttr <: AbstractOpenCLIntelReqdSubGroupSizeAttr
    ptr::CXOpenCLIntelReqdSubGroupSizeAttr
end

"""
    struct OpenCLKernelAttr <: AbstractOpenCLKernelAttr
Hold a pointer to a `clang::OpenCLKernelAttr` object.
"""
struct OpenCLKernelAttr <: AbstractOpenCLKernelAttr
    ptr::CXOpenCLKernelAttr
end

"""
    struct OptimizeNoneAttr <: AbstractOptimizeNoneAttr
Hold a pointer to a `clang::OptimizeNoneAttr` object.
"""
struct OptimizeNoneAttr <: AbstractOptimizeNoneAttr
    ptr::CXOptimizeNoneAttr
end

"""
    struct OverrideAttr <: AbstractOverrideAttr
Hold a pointer to a `clang::OverrideAttr` object.
"""
struct OverrideAttr <: AbstractOverrideAttr
    ptr::CXOverrideAttr
end

"""
    struct OwnerAttr <: AbstractOwnerAttr
Hold a pointer to a `clang::OwnerAttr` object.
"""
struct OwnerAttr <: AbstractOwnerAttr
    ptr::CXOwnerAttr
end

"""
    struct OwnershipAttr <: AbstractOwnershipAttr
Hold a pointer to a `clang::OwnershipAttr` object.
"""
struct OwnershipAttr <: AbstractOwnershipAttr
    ptr::CXOwnershipAttr
end

"""
    struct PackedAttr <: AbstractPackedAttr
Hold a pointer to a `clang::PackedAttr` object.
"""
struct PackedAttr <: AbstractPackedAttr
    ptr::CXPackedAttr
end

"""
    struct ParamTypestateAttr <: AbstractParamTypestateAttr
Hold a pointer to a `clang::ParamTypestateAttr` object.
"""
struct ParamTypestateAttr <: AbstractParamTypestateAttr
    ptr::CXParamTypestateAttr
end

"""
    struct PatchableFunctionEntryAttr <: AbstractPatchableFunctionEntryAttr
Hold a pointer to a `clang::PatchableFunctionEntryAttr` object.
"""
struct PatchableFunctionEntryAttr <: AbstractPatchableFunctionEntryAttr
    ptr::CXPatchableFunctionEntryAttr
end

"""
    struct PointerAttr <: AbstractPointerAttr
Hold a pointer to a `clang::PointerAttr` object.
"""
struct PointerAttr <: AbstractPointerAttr
    ptr::CXPointerAttr
end

"""
    struct PragmaClangBSSSectionAttr <: AbstractPragmaClangBSSSectionAttr
Hold a pointer to a `clang::PragmaClangBSSSectionAttr` object.
"""
struct PragmaClangBSSSectionAttr <: AbstractPragmaClangBSSSectionAttr
    ptr::CXPragmaClangBSSSectionAttr
end

"""
    struct PragmaClangDataSectionAttr <: AbstractPragmaClangDataSectionAttr
Hold a pointer to a `clang::PragmaClangDataSectionAttr` object.
"""
struct PragmaClangDataSectionAttr <: AbstractPragmaClangDataSectionAttr
    ptr::CXPragmaClangDataSectionAttr
end

"""
    struct PragmaClangRelroSectionAttr <: AbstractPragmaClangRelroSectionAttr
Hold a pointer to a `clang::PragmaClangRelroSectionAttr` object.
"""
struct PragmaClangRelroSectionAttr <: AbstractPragmaClangRelroSectionAttr
    ptr::CXPragmaClangRelroSectionAttr
end

"""
    struct PragmaClangRodataSectionAttr <: AbstractPragmaClangRodataSectionAttr
Hold a pointer to a `clang::PragmaClangRodataSectionAttr` object.
"""
struct PragmaClangRodataSectionAttr <: AbstractPragmaClangRodataSectionAttr
    ptr::CXPragmaClangRodataSectionAttr
end

"""
    struct PragmaClangTextSectionAttr <: AbstractPragmaClangTextSectionAttr
Hold a pointer to a `clang::PragmaClangTextSectionAttr` object.
"""
struct PragmaClangTextSectionAttr <: AbstractPragmaClangTextSectionAttr
    ptr::CXPragmaClangTextSectionAttr
end

"""
    struct PreferredNameAttr <: AbstractPreferredNameAttr
Hold a pointer to a `clang::PreferredNameAttr` object.
"""
struct PreferredNameAttr <: AbstractPreferredNameAttr
    ptr::CXPreferredNameAttr
end

"""
    struct PreferredTypeAttr <: AbstractPreferredTypeAttr
Hold a pointer to a `clang::PreferredTypeAttr` object.
"""
struct PreferredTypeAttr <: AbstractPreferredTypeAttr
    ptr::CXPreferredTypeAttr
end

"""
    struct PtGuardedByAttr <: AbstractPtGuardedByAttr
Hold a pointer to a `clang::PtGuardedByAttr` object.
"""
struct PtGuardedByAttr <: AbstractPtGuardedByAttr
    ptr::CXPtGuardedByAttr
end

"""
    struct PtGuardedVarAttr <: AbstractPtGuardedVarAttr
Hold a pointer to a `clang::PtGuardedVarAttr` object.
"""
struct PtGuardedVarAttr <: AbstractPtGuardedVarAttr
    ptr::CXPtGuardedVarAttr
end

"""
    struct PureAttr <: AbstractPureAttr
Hold a pointer to a `clang::PureAttr` object.
"""
struct PureAttr <: AbstractPureAttr
    ptr::CXPureAttr
end

"""
    struct RISCVInterruptAttr <: AbstractRISCVInterruptAttr
Hold a pointer to a `clang::RISCVInterruptAttr` object.
"""
struct RISCVInterruptAttr <: AbstractRISCVInterruptAttr
    ptr::CXRISCVInterruptAttr
end

"""
    struct RandomizeLayoutAttr <: AbstractRandomizeLayoutAttr
Hold a pointer to a `clang::RandomizeLayoutAttr` object.
"""
struct RandomizeLayoutAttr <: AbstractRandomizeLayoutAttr
    ptr::CXRandomizeLayoutAttr
end

"""
    struct ReadOnlyPlacementAttr <: AbstractReadOnlyPlacementAttr
Hold a pointer to a `clang::ReadOnlyPlacementAttr` object.
"""
struct ReadOnlyPlacementAttr <: AbstractReadOnlyPlacementAttr
    ptr::CXReadOnlyPlacementAttr
end

"""
    struct ReinitializesAttr <: AbstractReinitializesAttr
Hold a pointer to a `clang::ReinitializesAttr` object.
"""
struct ReinitializesAttr <: AbstractReinitializesAttr
    ptr::CXReinitializesAttr
end

"""
    struct ReleaseCapabilityAttr <: AbstractReleaseCapabilityAttr
Hold a pointer to a `clang::ReleaseCapabilityAttr` object.
"""
struct ReleaseCapabilityAttr <: AbstractReleaseCapabilityAttr
    ptr::CXReleaseCapabilityAttr
end

"""
    struct ReqdWorkGroupSizeAttr <: AbstractReqdWorkGroupSizeAttr
Hold a pointer to a `clang::ReqdWorkGroupSizeAttr` object.
"""
struct ReqdWorkGroupSizeAttr <: AbstractReqdWorkGroupSizeAttr
    ptr::CXReqdWorkGroupSizeAttr
end

"""
    struct RequiresCapabilityAttr <: AbstractRequiresCapabilityAttr
Hold a pointer to a `clang::RequiresCapabilityAttr` object.
"""
struct RequiresCapabilityAttr <: AbstractRequiresCapabilityAttr
    ptr::CXRequiresCapabilityAttr
end

"""
    struct RestrictAttr <: AbstractRestrictAttr
Hold a pointer to a `clang::RestrictAttr` object.
"""
struct RestrictAttr <: AbstractRestrictAttr
    ptr::CXRestrictAttr
end

"""
    struct RetainAttr <: AbstractRetainAttr
Hold a pointer to a `clang::RetainAttr` object.
"""
struct RetainAttr <: AbstractRetainAttr
    ptr::CXRetainAttr
end

"""
    struct ReturnTypestateAttr <: AbstractReturnTypestateAttr
Hold a pointer to a `clang::ReturnTypestateAttr` object.
"""
struct ReturnTypestateAttr <: AbstractReturnTypestateAttr
    ptr::CXReturnTypestateAttr
end

"""
    struct ReturnsNonNullAttr <: AbstractReturnsNonNullAttr
Hold a pointer to a `clang::ReturnsNonNullAttr` object.
"""
struct ReturnsNonNullAttr <: AbstractReturnsNonNullAttr
    ptr::CXReturnsNonNullAttr
end

"""
    struct ReturnsTwiceAttr <: AbstractReturnsTwiceAttr
Hold a pointer to a `clang::ReturnsTwiceAttr` object.
"""
struct ReturnsTwiceAttr <: AbstractReturnsTwiceAttr
    ptr::CXReturnsTwiceAttr
end

"""
    struct SYCLKernelAttr <: AbstractSYCLKernelAttr
Hold a pointer to a `clang::SYCLKernelAttr` object.
"""
struct SYCLKernelAttr <: AbstractSYCLKernelAttr
    ptr::CXSYCLKernelAttr
end

"""
    struct SYCLSpecialClassAttr <: AbstractSYCLSpecialClassAttr
Hold a pointer to a `clang::SYCLSpecialClassAttr` object.
"""
struct SYCLSpecialClassAttr <: AbstractSYCLSpecialClassAttr
    ptr::CXSYCLSpecialClassAttr
end

"""
    struct ScopedLockableAttr <: AbstractScopedLockableAttr
Hold a pointer to a `clang::ScopedLockableAttr` object.
"""
struct ScopedLockableAttr <: AbstractScopedLockableAttr
    ptr::CXScopedLockableAttr
end

"""
    struct SectionAttr <: AbstractSectionAttr
Hold a pointer to a `clang::SectionAttr` object.
"""
struct SectionAttr <: AbstractSectionAttr
    ptr::CXSectionAttr
end

"""
    struct SelectAnyAttr <: AbstractSelectAnyAttr
Hold a pointer to a `clang::SelectAnyAttr` object.
"""
struct SelectAnyAttr <: AbstractSelectAnyAttr
    ptr::CXSelectAnyAttr
end

"""
    struct SentinelAttr <: AbstractSentinelAttr
Hold a pointer to a `clang::SentinelAttr` object.
"""
struct SentinelAttr <: AbstractSentinelAttr
    ptr::CXSentinelAttr
end

"""
    struct SetTypestateAttr <: AbstractSetTypestateAttr
Hold a pointer to a `clang::SetTypestateAttr` object.
"""
struct SetTypestateAttr <: AbstractSetTypestateAttr
    ptr::CXSetTypestateAttr
end

"""
    struct SharedTrylockFunctionAttr <: AbstractSharedTrylockFunctionAttr
Hold a pointer to a `clang::SharedTrylockFunctionAttr` object.
"""
struct SharedTrylockFunctionAttr <: AbstractSharedTrylockFunctionAttr
    ptr::CXSharedTrylockFunctionAttr
end

"""
    struct SpeculativeLoadHardeningAttr <: AbstractSpeculativeLoadHardeningAttr
Hold a pointer to a `clang::SpeculativeLoadHardeningAttr` object.
"""
struct SpeculativeLoadHardeningAttr <: AbstractSpeculativeLoadHardeningAttr
    ptr::CXSpeculativeLoadHardeningAttr
end

"""
    struct StandaloneDebugAttr <: AbstractStandaloneDebugAttr
Hold a pointer to a `clang::StandaloneDebugAttr` object.
"""
struct StandaloneDebugAttr <: AbstractStandaloneDebugAttr
    ptr::CXStandaloneDebugAttr
end

"""
    struct StrictFPAttr <: AbstractStrictFPAttr
Hold a pointer to a `clang::StrictFPAttr` object.
"""
struct StrictFPAttr <: AbstractStrictFPAttr
    ptr::CXStrictFPAttr
end

"""
    struct StrictGuardStackCheckAttr <: AbstractStrictGuardStackCheckAttr
Hold a pointer to a `clang::StrictGuardStackCheckAttr` object.
"""
struct StrictGuardStackCheckAttr <: AbstractStrictGuardStackCheckAttr
    ptr::CXStrictGuardStackCheckAttr
end

"""
    struct SwiftAsyncAttr <: AbstractSwiftAsyncAttr
Hold a pointer to a `clang::SwiftAsyncAttr` object.
"""
struct SwiftAsyncAttr <: AbstractSwiftAsyncAttr
    ptr::CXSwiftAsyncAttr
end

"""
    struct SwiftAsyncErrorAttr <: AbstractSwiftAsyncErrorAttr
Hold a pointer to a `clang::SwiftAsyncErrorAttr` object.
"""
struct SwiftAsyncErrorAttr <: AbstractSwiftAsyncErrorAttr
    ptr::CXSwiftAsyncErrorAttr
end

"""
    struct SwiftAsyncNameAttr <: AbstractSwiftAsyncNameAttr
Hold a pointer to a `clang::SwiftAsyncNameAttr` object.
"""
struct SwiftAsyncNameAttr <: AbstractSwiftAsyncNameAttr
    ptr::CXSwiftAsyncNameAttr
end

"""
    struct SwiftAttrAttr <: AbstractSwiftAttrAttr
Hold a pointer to a `clang::SwiftAttrAttr` object.
"""
struct SwiftAttrAttr <: AbstractSwiftAttrAttr
    ptr::CXSwiftAttrAttr
end

"""
    struct SwiftBridgeAttr <: AbstractSwiftBridgeAttr
Hold a pointer to a `clang::SwiftBridgeAttr` object.
"""
struct SwiftBridgeAttr <: AbstractSwiftBridgeAttr
    ptr::CXSwiftBridgeAttr
end

"""
    struct SwiftBridgedTypedefAttr <: AbstractSwiftBridgedTypedefAttr
Hold a pointer to a `clang::SwiftBridgedTypedefAttr` object.
"""
struct SwiftBridgedTypedefAttr <: AbstractSwiftBridgedTypedefAttr
    ptr::CXSwiftBridgedTypedefAttr
end

"""
    struct SwiftErrorAttr <: AbstractSwiftErrorAttr
Hold a pointer to a `clang::SwiftErrorAttr` object.
"""
struct SwiftErrorAttr <: AbstractSwiftErrorAttr
    ptr::CXSwiftErrorAttr
end

"""
    struct SwiftImportAsNonGenericAttr <: AbstractSwiftImportAsNonGenericAttr
Hold a pointer to a `clang::SwiftImportAsNonGenericAttr` object.
"""
struct SwiftImportAsNonGenericAttr <: AbstractSwiftImportAsNonGenericAttr
    ptr::CXSwiftImportAsNonGenericAttr
end

"""
    struct SwiftImportPropertyAsAccessorsAttr <: AbstractSwiftImportPropertyAsAccessorsAttr
Hold a pointer to a `clang::SwiftImportPropertyAsAccessorsAttr` object.
"""
struct SwiftImportPropertyAsAccessorsAttr <: AbstractSwiftImportPropertyAsAccessorsAttr
    ptr::CXSwiftImportPropertyAsAccessorsAttr
end

"""
    struct SwiftNameAttr <: AbstractSwiftNameAttr
Hold a pointer to a `clang::SwiftNameAttr` object.
"""
struct SwiftNameAttr <: AbstractSwiftNameAttr
    ptr::CXSwiftNameAttr
end

"""
    struct SwiftNewTypeAttr <: AbstractSwiftNewTypeAttr
Hold a pointer to a `clang::SwiftNewTypeAttr` object.
"""
struct SwiftNewTypeAttr <: AbstractSwiftNewTypeAttr
    ptr::CXSwiftNewTypeAttr
end

"""
    struct SwiftPrivateAttr <: AbstractSwiftPrivateAttr
Hold a pointer to a `clang::SwiftPrivateAttr` object.
"""
struct SwiftPrivateAttr <: AbstractSwiftPrivateAttr
    ptr::CXSwiftPrivateAttr
end

"""
    struct TLSModelAttr <: AbstractTLSModelAttr
Hold a pointer to a `clang::TLSModelAttr` object.
"""
struct TLSModelAttr <: AbstractTLSModelAttr
    ptr::CXTLSModelAttr
end

"""
    struct TargetAttr <: AbstractTargetAttr
Hold a pointer to a `clang::TargetAttr` object.
"""
struct TargetAttr <: AbstractTargetAttr
    ptr::CXTargetAttr
end

"""
    struct TargetClonesAttr <: AbstractTargetClonesAttr
Hold a pointer to a `clang::TargetClonesAttr` object.
"""
struct TargetClonesAttr <: AbstractTargetClonesAttr
    ptr::CXTargetClonesAttr
end

"""
    struct TargetVersionAttr <: AbstractTargetVersionAttr
Hold a pointer to a `clang::TargetVersionAttr` object.
"""
struct TargetVersionAttr <: AbstractTargetVersionAttr
    ptr::CXTargetVersionAttr
end

"""
    struct TestTypestateAttr <: AbstractTestTypestateAttr
Hold a pointer to a `clang::TestTypestateAttr` object.
"""
struct TestTypestateAttr <: AbstractTestTypestateAttr
    ptr::CXTestTypestateAttr
end

"""
    struct TransparentUnionAttr <: AbstractTransparentUnionAttr
Hold a pointer to a `clang::TransparentUnionAttr` object.
"""
struct TransparentUnionAttr <: AbstractTransparentUnionAttr
    ptr::CXTransparentUnionAttr
end

"""
    struct TrivialABIAttr <: AbstractTrivialABIAttr
Hold a pointer to a `clang::TrivialABIAttr` object.
"""
struct TrivialABIAttr <: AbstractTrivialABIAttr
    ptr::CXTrivialABIAttr
end

"""
    struct TryAcquireCapabilityAttr <: AbstractTryAcquireCapabilityAttr
Hold a pointer to a `clang::TryAcquireCapabilityAttr` object.
"""
struct TryAcquireCapabilityAttr <: AbstractTryAcquireCapabilityAttr
    ptr::CXTryAcquireCapabilityAttr
end

"""
    struct TypeTagForDatatypeAttr <: AbstractTypeTagForDatatypeAttr
Hold a pointer to a `clang::TypeTagForDatatypeAttr` object.
"""
struct TypeTagForDatatypeAttr <: AbstractTypeTagForDatatypeAttr
    ptr::CXTypeTagForDatatypeAttr
end

"""
    struct TypeVisibilityAttr <: AbstractTypeVisibilityAttr
Hold a pointer to a `clang::TypeVisibilityAttr` object.
"""
struct TypeVisibilityAttr <: AbstractTypeVisibilityAttr
    ptr::CXTypeVisibilityAttr
end

"""
    struct UnavailableAttr <: AbstractUnavailableAttr
Hold a pointer to a `clang::UnavailableAttr` object.
"""
struct UnavailableAttr <: AbstractUnavailableAttr
    ptr::CXUnavailableAttr
end

"""
    struct UninitializedAttr <: AbstractUninitializedAttr
Hold a pointer to a `clang::UninitializedAttr` object.
"""
struct UninitializedAttr <: AbstractUninitializedAttr
    ptr::CXUninitializedAttr
end

"""
    struct UnsafeBufferUsageAttr <: AbstractUnsafeBufferUsageAttr
Hold a pointer to a `clang::UnsafeBufferUsageAttr` object.
"""
struct UnsafeBufferUsageAttr <: AbstractUnsafeBufferUsageAttr
    ptr::CXUnsafeBufferUsageAttr
end

"""
    struct UnusedAttr <: AbstractUnusedAttr
Hold a pointer to a `clang::UnusedAttr` object.
"""
struct UnusedAttr <: AbstractUnusedAttr
    ptr::CXUnusedAttr
end

"""
    struct UsedAttr <: AbstractUsedAttr
Hold a pointer to a `clang::UsedAttr` object.
"""
struct UsedAttr <: AbstractUsedAttr
    ptr::CXUsedAttr
end

"""
    struct UsingIfExistsAttr <: AbstractUsingIfExistsAttr
Hold a pointer to a `clang::UsingIfExistsAttr` object.
"""
struct UsingIfExistsAttr <: AbstractUsingIfExistsAttr
    ptr::CXUsingIfExistsAttr
end

"""
    struct UuidAttr <: AbstractUuidAttr
Hold a pointer to a `clang::UuidAttr` object.
"""
struct UuidAttr <: AbstractUuidAttr
    ptr::CXUuidAttr
end

"""
    struct VecReturnAttr <: AbstractVecReturnAttr
Hold a pointer to a `clang::VecReturnAttr` object.
"""
struct VecReturnAttr <: AbstractVecReturnAttr
    ptr::CXVecReturnAttr
end

"""
    struct VecTypeHintAttr <: AbstractVecTypeHintAttr
Hold a pointer to a `clang::VecTypeHintAttr` object.
"""
struct VecTypeHintAttr <: AbstractVecTypeHintAttr
    ptr::CXVecTypeHintAttr
end

"""
    struct VisibilityAttr <: AbstractVisibilityAttr
Hold a pointer to a `clang::VisibilityAttr` object.
"""
struct VisibilityAttr <: AbstractVisibilityAttr
    ptr::CXVisibilityAttr
end

"""
    struct WarnUnusedAttr <: AbstractWarnUnusedAttr
Hold a pointer to a `clang::WarnUnusedAttr` object.
"""
struct WarnUnusedAttr <: AbstractWarnUnusedAttr
    ptr::CXWarnUnusedAttr
end

"""
    struct WarnUnusedResultAttr <: AbstractWarnUnusedResultAttr
Hold a pointer to a `clang::WarnUnusedResultAttr` object.
"""
struct WarnUnusedResultAttr <: AbstractWarnUnusedResultAttr
    ptr::CXWarnUnusedResultAttr
end

"""
    struct WeakAttr <: AbstractWeakAttr
Hold a pointer to a `clang::WeakAttr` object.
"""
struct WeakAttr <: AbstractWeakAttr
    ptr::CXWeakAttr
end

"""
    struct WeakImportAttr <: AbstractWeakImportAttr
Hold a pointer to a `clang::WeakImportAttr` object.
"""
struct WeakImportAttr <: AbstractWeakImportAttr
    ptr::CXWeakImportAttr
end

"""
    struct WeakRefAttr <: AbstractWeakRefAttr
Hold a pointer to a `clang::WeakRefAttr` object.
"""
struct WeakRefAttr <: AbstractWeakRefAttr
    ptr::CXWeakRefAttr
end

"""
    struct WebAssemblyExportNameAttr <: AbstractWebAssemblyExportNameAttr
Hold a pointer to a `clang::WebAssemblyExportNameAttr` object.
"""
struct WebAssemblyExportNameAttr <: AbstractWebAssemblyExportNameAttr
    ptr::CXWebAssemblyExportNameAttr
end

"""
    struct WebAssemblyImportModuleAttr <: AbstractWebAssemblyImportModuleAttr
Hold a pointer to a `clang::WebAssemblyImportModuleAttr` object.
"""
struct WebAssemblyImportModuleAttr <: AbstractWebAssemblyImportModuleAttr
    ptr::CXWebAssemblyImportModuleAttr
end

"""
    struct WebAssemblyImportNameAttr <: AbstractWebAssemblyImportNameAttr
Hold a pointer to a `clang::WebAssemblyImportNameAttr` object.
"""
struct WebAssemblyImportNameAttr <: AbstractWebAssemblyImportNameAttr
    ptr::CXWebAssemblyImportNameAttr
end

"""
    struct WorkGroupSizeHintAttr <: AbstractWorkGroupSizeHintAttr
Hold a pointer to a `clang::WorkGroupSizeHintAttr` object.
"""
struct WorkGroupSizeHintAttr <: AbstractWorkGroupSizeHintAttr
    ptr::CXWorkGroupSizeHintAttr
end

"""
    struct X86ForceAlignArgPointerAttr <: AbstractX86ForceAlignArgPointerAttr
Hold a pointer to a `clang::X86ForceAlignArgPointerAttr` object.
"""
struct X86ForceAlignArgPointerAttr <: AbstractX86ForceAlignArgPointerAttr
    ptr::CXX86ForceAlignArgPointerAttr
end

"""
    struct XRayInstrumentAttr <: AbstractXRayInstrumentAttr
Hold a pointer to a `clang::XRayInstrumentAttr` object.
"""
struct XRayInstrumentAttr <: AbstractXRayInstrumentAttr
    ptr::CXXRayInstrumentAttr
end

"""
    struct XRayLogArgsAttr <: AbstractXRayLogArgsAttr
Hold a pointer to a `clang::XRayLogArgsAttr` object.
"""
struct XRayLogArgsAttr <: AbstractXRayLogArgsAttr
    ptr::CXXRayLogArgsAttr
end

"""
    struct ZeroCallUsedRegsAttr <: AbstractZeroCallUsedRegsAttr
Hold a pointer to a `clang::ZeroCallUsedRegsAttr` object.
"""
struct ZeroCallUsedRegsAttr <: AbstractZeroCallUsedRegsAttr
    ptr::CXZeroCallUsedRegsAttr
end

"""
    struct AbiTagAttr <: AbstractAbiTagAttr
Hold a pointer to a `clang::AbiTagAttr` object.
"""
struct AbiTagAttr <: AbstractAbiTagAttr
    ptr::CXAbiTagAttr
end

"""
    struct AliasAttr <: AbstractAliasAttr
Hold a pointer to a `clang::AliasAttr` object.
"""
struct AliasAttr <: AbstractAliasAttr
    ptr::CXAliasAttr
end

"""
    struct AlignValueAttr <: AbstractAlignValueAttr
Hold a pointer to a `clang::AlignValueAttr` object.
"""
struct AlignValueAttr <: AbstractAlignValueAttr
    ptr::CXAlignValueAttr
end

"""
    struct BuiltinAliasAttr <: AbstractBuiltinAliasAttr
Hold a pointer to a `clang::BuiltinAliasAttr` object.
"""
struct BuiltinAliasAttr <: AbstractBuiltinAliasAttr
    ptr::CXBuiltinAliasAttr
end

"""
    struct CalledOnceAttr <: AbstractCalledOnceAttr
Hold a pointer to a `clang::CalledOnceAttr` object.
"""
struct CalledOnceAttr <: AbstractCalledOnceAttr
    ptr::CXCalledOnceAttr
end

"""
    struct IFuncAttr <: AbstractIFuncAttr
Hold a pointer to a `clang::IFuncAttr` object.
"""
struct IFuncAttr <: AbstractIFuncAttr
    ptr::CXIFuncAttr
end

"""
    struct InitSegAttr <: AbstractInitSegAttr
Hold a pointer to a `clang::InitSegAttr` object.
"""
struct InitSegAttr <: AbstractInitSegAttr
    ptr::CXInitSegAttr
end

"""
    struct LoaderUninitializedAttr <: AbstractLoaderUninitializedAttr
Hold a pointer to a `clang::LoaderUninitializedAttr` object.
"""
struct LoaderUninitializedAttr <: AbstractLoaderUninitializedAttr
    ptr::CXLoaderUninitializedAttr
end

"""
    struct LoopHintAttr <: AbstractLoopHintAttr
Hold a pointer to a `clang::LoopHintAttr` object.
"""
struct LoopHintAttr <: AbstractLoopHintAttr
    ptr::CXLoopHintAttr
end

"""
    struct ModeAttr <: AbstractModeAttr
Hold a pointer to a `clang::ModeAttr` object.
"""
struct ModeAttr <: AbstractModeAttr
    ptr::CXModeAttr
end

"""
    struct NoBuiltinAttr <: AbstractNoBuiltinAttr
Hold a pointer to a `clang::NoBuiltinAttr` object.
"""
struct NoBuiltinAttr <: AbstractNoBuiltinAttr
    ptr::CXNoBuiltinAttr
end

"""
    struct NoEscapeAttr <: AbstractNoEscapeAttr
Hold a pointer to a `clang::NoEscapeAttr` object.
"""
struct NoEscapeAttr <: AbstractNoEscapeAttr
    ptr::CXNoEscapeAttr
end

"""
    struct OMPCaptureKindAttr <: AbstractOMPCaptureKindAttr
Hold a pointer to a `clang::OMPCaptureKindAttr` object.
"""
struct OMPCaptureKindAttr <: AbstractOMPCaptureKindAttr
    ptr::CXOMPCaptureKindAttr
end

"""
    struct OMPDeclareSimdDeclAttr <: AbstractOMPDeclareSimdDeclAttr
Hold a pointer to a `clang::OMPDeclareSimdDeclAttr` object.
"""
struct OMPDeclareSimdDeclAttr <: AbstractOMPDeclareSimdDeclAttr
    ptr::CXOMPDeclareSimdDeclAttr
end

"""
    struct OMPReferencedVarAttr <: AbstractOMPReferencedVarAttr
Hold a pointer to a `clang::OMPReferencedVarAttr` object.
"""
struct OMPReferencedVarAttr <: AbstractOMPReferencedVarAttr
    ptr::CXOMPReferencedVarAttr
end

"""
    struct ObjCBoxableAttr <: AbstractObjCBoxableAttr
Hold a pointer to a `clang::ObjCBoxableAttr` object.
"""
struct ObjCBoxableAttr <: AbstractObjCBoxableAttr
    ptr::CXObjCBoxableAttr
end

"""
    struct ObjCClassStubAttr <: AbstractObjCClassStubAttr
Hold a pointer to a `clang::ObjCClassStubAttr` object.
"""
struct ObjCClassStubAttr <: AbstractObjCClassStubAttr
    ptr::CXObjCClassStubAttr
end

"""
    struct ObjCDesignatedInitializerAttr <: AbstractObjCDesignatedInitializerAttr
Hold a pointer to a `clang::ObjCDesignatedInitializerAttr` object.
"""
struct ObjCDesignatedInitializerAttr <: AbstractObjCDesignatedInitializerAttr
    ptr::CXObjCDesignatedInitializerAttr
end

"""
    struct ObjCDirectAttr <: AbstractObjCDirectAttr
Hold a pointer to a `clang::ObjCDirectAttr` object.
"""
struct ObjCDirectAttr <: AbstractObjCDirectAttr
    ptr::CXObjCDirectAttr
end

"""
    struct ObjCDirectMembersAttr <: AbstractObjCDirectMembersAttr
Hold a pointer to a `clang::ObjCDirectMembersAttr` object.
"""
struct ObjCDirectMembersAttr <: AbstractObjCDirectMembersAttr
    ptr::CXObjCDirectMembersAttr
end

"""
    struct ObjCNonLazyClassAttr <: AbstractObjCNonLazyClassAttr
Hold a pointer to a `clang::ObjCNonLazyClassAttr` object.
"""
struct ObjCNonLazyClassAttr <: AbstractObjCNonLazyClassAttr
    ptr::CXObjCNonLazyClassAttr
end

"""
    struct ObjCNonRuntimeProtocolAttr <: AbstractObjCNonRuntimeProtocolAttr
Hold a pointer to a `clang::ObjCNonRuntimeProtocolAttr` object.
"""
struct ObjCNonRuntimeProtocolAttr <: AbstractObjCNonRuntimeProtocolAttr
    ptr::CXObjCNonRuntimeProtocolAttr
end

"""
    struct ObjCRuntimeNameAttr <: AbstractObjCRuntimeNameAttr
Hold a pointer to a `clang::ObjCRuntimeNameAttr` object.
"""
struct ObjCRuntimeNameAttr <: AbstractObjCRuntimeNameAttr
    ptr::CXObjCRuntimeNameAttr
end

"""
    struct ObjCRuntimeVisibleAttr <: AbstractObjCRuntimeVisibleAttr
Hold a pointer to a `clang::ObjCRuntimeVisibleAttr` object.
"""
struct ObjCRuntimeVisibleAttr <: AbstractObjCRuntimeVisibleAttr
    ptr::CXObjCRuntimeVisibleAttr
end

"""
    struct OpenCLAccessAttr <: AbstractOpenCLAccessAttr
Hold a pointer to a `clang::OpenCLAccessAttr` object.
"""
struct OpenCLAccessAttr <: AbstractOpenCLAccessAttr
    ptr::CXOpenCLAccessAttr
end

"""
    struct OverloadableAttr <: AbstractOverloadableAttr
Hold a pointer to a `clang::OverloadableAttr` object.
"""
struct OverloadableAttr <: AbstractOverloadableAttr
    ptr::CXOverloadableAttr
end

"""
    struct RenderScriptKernelAttr <: AbstractRenderScriptKernelAttr
Hold a pointer to a `clang::RenderScriptKernelAttr` object.
"""
struct RenderScriptKernelAttr <: AbstractRenderScriptKernelAttr
    ptr::CXRenderScriptKernelAttr
end

"""
    struct SwiftObjCMembersAttr <: AbstractSwiftObjCMembersAttr
Hold a pointer to a `clang::SwiftObjCMembersAttr` object.
"""
struct SwiftObjCMembersAttr <: AbstractSwiftObjCMembersAttr
    ptr::CXSwiftObjCMembersAttr
end

"""
    struct SwiftVersionedAdditionAttr <: AbstractSwiftVersionedAdditionAttr
Hold a pointer to a `clang::SwiftVersionedAdditionAttr` object.
"""
struct SwiftVersionedAdditionAttr <: AbstractSwiftVersionedAdditionAttr
    ptr::CXSwiftVersionedAdditionAttr
end

"""
    struct SwiftVersionedRemovalAttr <: AbstractSwiftVersionedRemovalAttr
Hold a pointer to a `clang::SwiftVersionedRemovalAttr` object.
"""
struct SwiftVersionedRemovalAttr <: AbstractSwiftVersionedRemovalAttr
    ptr::CXSwiftVersionedRemovalAttr
end

"""
    struct ThreadAttr <: AbstractThreadAttr
Hold a pointer to a `clang::ThreadAttr` object.
"""
struct ThreadAttr <: AbstractThreadAttr
    ptr::CXThreadAttr
end

