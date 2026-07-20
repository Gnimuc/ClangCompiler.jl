# Generated from deps/ClangExtra/include/clang-ex/AST/AttrList.inc by gen/attr_nodes.jl — do not edit.
# One carrier per concrete clang attribute, subtyping its own Abstract<Name>Attr
# (defined in AttrAbstracts.jl) which subtypes the attribute's category.
"""
    struct AddressSpaceAttr <: AbstractAddressSpaceAttr
Hold a pointer to a `clang::AddressSpaceAttr` object.
"""
struct AddressSpaceAttr <: AbstractAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AddressSpaceAttr) = x

"""
    struct AnnotateTypeAttr <: AbstractAnnotateTypeAttr
Hold a pointer to a `clang::AnnotateTypeAttr` object.
"""
struct AnnotateTypeAttr <: AbstractAnnotateTypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AnnotateTypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AnnotateTypeAttr) = x

"""
    struct ArmInAttr <: AbstractArmInAttr
Hold a pointer to a `clang::ArmInAttr` object.
"""
struct ArmInAttr <: AbstractArmInAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmInAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmInAttr) = x

"""
    struct ArmInOutAttr <: AbstractArmInOutAttr
Hold a pointer to a `clang::ArmInOutAttr` object.
"""
struct ArmInOutAttr <: AbstractArmInOutAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmInOutAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmInOutAttr) = x

"""
    struct ArmMveStrictPolymorphismAttr <: AbstractArmMveStrictPolymorphismAttr
Hold a pointer to a `clang::ArmMveStrictPolymorphismAttr` object.
"""
struct ArmMveStrictPolymorphismAttr <: AbstractArmMveStrictPolymorphismAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmMveStrictPolymorphismAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmMveStrictPolymorphismAttr) = x

"""
    struct ArmOutAttr <: AbstractArmOutAttr
Hold a pointer to a `clang::ArmOutAttr` object.
"""
struct ArmOutAttr <: AbstractArmOutAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmOutAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmOutAttr) = x

"""
    struct ArmPreservesAttr <: AbstractArmPreservesAttr
Hold a pointer to a `clang::ArmPreservesAttr` object.
"""
struct ArmPreservesAttr <: AbstractArmPreservesAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmPreservesAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmPreservesAttr) = x

"""
    struct ArmStreamingAttr <: AbstractArmStreamingAttr
Hold a pointer to a `clang::ArmStreamingAttr` object.
"""
struct ArmStreamingAttr <: AbstractArmStreamingAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmStreamingAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmStreamingAttr) = x

"""
    struct ArmStreamingCompatibleAttr <: AbstractArmStreamingCompatibleAttr
Hold a pointer to a `clang::ArmStreamingCompatibleAttr` object.
"""
struct ArmStreamingCompatibleAttr <: AbstractArmStreamingCompatibleAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmStreamingCompatibleAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmStreamingCompatibleAttr) = x

"""
    struct BTFTypeTagAttr <: AbstractBTFTypeTagAttr
Hold a pointer to a `clang::BTFTypeTagAttr` object.
"""
struct BTFTypeTagAttr <: AbstractBTFTypeTagAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BTFTypeTagAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BTFTypeTagAttr) = x

"""
    struct CmseNSCallAttr <: AbstractCmseNSCallAttr
Hold a pointer to a `clang::CmseNSCallAttr` object.
"""
struct CmseNSCallAttr <: AbstractCmseNSCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CmseNSCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CmseNSCallAttr) = x

"""
    struct HLSLGroupSharedAddressSpaceAttr <: AbstractHLSLGroupSharedAddressSpaceAttr
Hold a pointer to a `clang::HLSLGroupSharedAddressSpaceAttr` object.
"""
struct HLSLGroupSharedAddressSpaceAttr <: AbstractHLSLGroupSharedAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLGroupSharedAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLGroupSharedAddressSpaceAttr) = x

"""
    struct HLSLParamModifierAttr <: AbstractHLSLParamModifierAttr
Hold a pointer to a `clang::HLSLParamModifierAttr` object.
"""
struct HLSLParamModifierAttr <: AbstractHLSLParamModifierAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLParamModifierAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLParamModifierAttr) = x

"""
    struct NoDerefAttr <: AbstractNoDerefAttr
Hold a pointer to a `clang::NoDerefAttr` object.
"""
struct NoDerefAttr <: AbstractNoDerefAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoDerefAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoDerefAttr) = x

"""
    struct ObjCGCAttr <: AbstractObjCGCAttr
Hold a pointer to a `clang::ObjCGCAttr` object.
"""
struct ObjCGCAttr <: AbstractObjCGCAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCGCAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCGCAttr) = x

"""
    struct ObjCInertUnsafeUnretainedAttr <: AbstractObjCInertUnsafeUnretainedAttr
Hold a pointer to a `clang::ObjCInertUnsafeUnretainedAttr` object.
"""
struct ObjCInertUnsafeUnretainedAttr <: AbstractObjCInertUnsafeUnretainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCInertUnsafeUnretainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCInertUnsafeUnretainedAttr) = x

"""
    struct ObjCKindOfAttr <: AbstractObjCKindOfAttr
Hold a pointer to a `clang::ObjCKindOfAttr` object.
"""
struct ObjCKindOfAttr <: AbstractObjCKindOfAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCKindOfAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCKindOfAttr) = x

"""
    struct OpenCLConstantAddressSpaceAttr <: AbstractOpenCLConstantAddressSpaceAttr
Hold a pointer to a `clang::OpenCLConstantAddressSpaceAttr` object.
"""
struct OpenCLConstantAddressSpaceAttr <: AbstractOpenCLConstantAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLConstantAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLConstantAddressSpaceAttr) = x

"""
    struct OpenCLGenericAddressSpaceAttr <: AbstractOpenCLGenericAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGenericAddressSpaceAttr` object.
"""
struct OpenCLGenericAddressSpaceAttr <: AbstractOpenCLGenericAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLGenericAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLGenericAddressSpaceAttr) = x

"""
    struct OpenCLGlobalAddressSpaceAttr <: AbstractOpenCLGlobalAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGlobalAddressSpaceAttr` object.
"""
struct OpenCLGlobalAddressSpaceAttr <: AbstractOpenCLGlobalAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLGlobalAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLGlobalAddressSpaceAttr) = x

"""
    struct OpenCLGlobalDeviceAddressSpaceAttr <: AbstractOpenCLGlobalDeviceAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGlobalDeviceAddressSpaceAttr` object.
"""
struct OpenCLGlobalDeviceAddressSpaceAttr <: AbstractOpenCLGlobalDeviceAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLGlobalDeviceAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLGlobalDeviceAddressSpaceAttr) = x

"""
    struct OpenCLGlobalHostAddressSpaceAttr <: AbstractOpenCLGlobalHostAddressSpaceAttr
Hold a pointer to a `clang::OpenCLGlobalHostAddressSpaceAttr` object.
"""
struct OpenCLGlobalHostAddressSpaceAttr <: AbstractOpenCLGlobalHostAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLGlobalHostAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLGlobalHostAddressSpaceAttr) = x

"""
    struct OpenCLLocalAddressSpaceAttr <: AbstractOpenCLLocalAddressSpaceAttr
Hold a pointer to a `clang::OpenCLLocalAddressSpaceAttr` object.
"""
struct OpenCLLocalAddressSpaceAttr <: AbstractOpenCLLocalAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLLocalAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLLocalAddressSpaceAttr) = x

"""
    struct OpenCLPrivateAddressSpaceAttr <: AbstractOpenCLPrivateAddressSpaceAttr
Hold a pointer to a `clang::OpenCLPrivateAddressSpaceAttr` object.
"""
struct OpenCLPrivateAddressSpaceAttr <: AbstractOpenCLPrivateAddressSpaceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLPrivateAddressSpaceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLPrivateAddressSpaceAttr) = x

"""
    struct Ptr32Attr <: AbstractPtr32Attr
Hold a pointer to a `clang::Ptr32Attr` object.
"""
struct Ptr32Attr <: AbstractPtr32Attr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::Ptr32Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::Ptr32Attr) = x

"""
    struct Ptr64Attr <: AbstractPtr64Attr
Hold a pointer to a `clang::Ptr64Attr` object.
"""
struct Ptr64Attr <: AbstractPtr64Attr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::Ptr64Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::Ptr64Attr) = x

"""
    struct SPtrAttr <: AbstractSPtrAttr
Hold a pointer to a `clang::SPtrAttr` object.
"""
struct SPtrAttr <: AbstractSPtrAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SPtrAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SPtrAttr) = x

"""
    struct TypeNonNullAttr <: AbstractTypeNonNullAttr
Hold a pointer to a `clang::TypeNonNullAttr` object.
"""
struct TypeNonNullAttr <: AbstractTypeNonNullAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TypeNonNullAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TypeNonNullAttr) = x

"""
    struct TypeNullUnspecifiedAttr <: AbstractTypeNullUnspecifiedAttr
Hold a pointer to a `clang::TypeNullUnspecifiedAttr` object.
"""
struct TypeNullUnspecifiedAttr <: AbstractTypeNullUnspecifiedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TypeNullUnspecifiedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TypeNullUnspecifiedAttr) = x

"""
    struct TypeNullableAttr <: AbstractTypeNullableAttr
Hold a pointer to a `clang::TypeNullableAttr` object.
"""
struct TypeNullableAttr <: AbstractTypeNullableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TypeNullableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TypeNullableAttr) = x

"""
    struct TypeNullableResultAttr <: AbstractTypeNullableResultAttr
Hold a pointer to a `clang::TypeNullableResultAttr` object.
"""
struct TypeNullableResultAttr <: AbstractTypeNullableResultAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TypeNullableResultAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TypeNullableResultAttr) = x

"""
    struct UPtrAttr <: AbstractUPtrAttr
Hold a pointer to a `clang::UPtrAttr` object.
"""
struct UPtrAttr <: AbstractUPtrAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UPtrAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UPtrAttr) = x

"""
    struct WebAssemblyFuncrefAttr <: AbstractWebAssemblyFuncrefAttr
Hold a pointer to a `clang::WebAssemblyFuncrefAttr` object.
"""
struct WebAssemblyFuncrefAttr <: AbstractWebAssemblyFuncrefAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WebAssemblyFuncrefAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WebAssemblyFuncrefAttr) = x

"""
    struct CodeAlignAttr <: AbstractCodeAlignAttr
Hold a pointer to a `clang::CodeAlignAttr` object.
"""
struct CodeAlignAttr <: AbstractCodeAlignAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CodeAlignAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CodeAlignAttr) = x

"""
    struct FallThroughAttr <: AbstractFallThroughAttr
Hold a pointer to a `clang::FallThroughAttr` object.
"""
struct FallThroughAttr <: AbstractFallThroughAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FallThroughAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FallThroughAttr) = x

"""
    struct LikelyAttr <: AbstractLikelyAttr
Hold a pointer to a `clang::LikelyAttr` object.
"""
struct LikelyAttr <: AbstractLikelyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LikelyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LikelyAttr) = x

"""
    struct MustTailAttr <: AbstractMustTailAttr
Hold a pointer to a `clang::MustTailAttr` object.
"""
struct MustTailAttr <: AbstractMustTailAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MustTailAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MustTailAttr) = x

"""
    struct OpenCLUnrollHintAttr <: AbstractOpenCLUnrollHintAttr
Hold a pointer to a `clang::OpenCLUnrollHintAttr` object.
"""
struct OpenCLUnrollHintAttr <: AbstractOpenCLUnrollHintAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLUnrollHintAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLUnrollHintAttr) = x

"""
    struct UnlikelyAttr <: AbstractUnlikelyAttr
Hold a pointer to a `clang::UnlikelyAttr` object.
"""
struct UnlikelyAttr <: AbstractUnlikelyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UnlikelyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UnlikelyAttr) = x

"""
    struct AlwaysInlineAttr <: AbstractAlwaysInlineAttr
Hold a pointer to a `clang::AlwaysInlineAttr` object.
"""
struct AlwaysInlineAttr <: AbstractAlwaysInlineAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AlwaysInlineAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AlwaysInlineAttr) = x

"""
    struct NoInlineAttr <: AbstractNoInlineAttr
Hold a pointer to a `clang::NoInlineAttr` object.
"""
struct NoInlineAttr <: AbstractNoInlineAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoInlineAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoInlineAttr) = x

"""
    struct NoMergeAttr <: AbstractNoMergeAttr
Hold a pointer to a `clang::NoMergeAttr` object.
"""
struct NoMergeAttr <: AbstractNoMergeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoMergeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoMergeAttr) = x

"""
    struct SuppressAttr <: AbstractSuppressAttr
Hold a pointer to a `clang::SuppressAttr` object.
"""
struct SuppressAttr <: AbstractSuppressAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SuppressAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SuppressAttr) = x

"""
    struct AArch64SVEPcsAttr <: AbstractAArch64SVEPcsAttr
Hold a pointer to a `clang::AArch64SVEPcsAttr` object.
"""
struct AArch64SVEPcsAttr <: AbstractAArch64SVEPcsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AArch64SVEPcsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AArch64SVEPcsAttr) = x

"""
    struct AArch64VectorPcsAttr <: AbstractAArch64VectorPcsAttr
Hold a pointer to a `clang::AArch64VectorPcsAttr` object.
"""
struct AArch64VectorPcsAttr <: AbstractAArch64VectorPcsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AArch64VectorPcsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AArch64VectorPcsAttr) = x

"""
    struct AMDGPUKernelCallAttr <: AbstractAMDGPUKernelCallAttr
Hold a pointer to a `clang::AMDGPUKernelCallAttr` object.
"""
struct AMDGPUKernelCallAttr <: AbstractAMDGPUKernelCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AMDGPUKernelCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AMDGPUKernelCallAttr) = x

"""
    struct AcquireHandleAttr <: AbstractAcquireHandleAttr
Hold a pointer to a `clang::AcquireHandleAttr` object.
"""
struct AcquireHandleAttr <: AbstractAcquireHandleAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AcquireHandleAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AcquireHandleAttr) = x

"""
    struct AnyX86NoCfCheckAttr <: AbstractAnyX86NoCfCheckAttr
Hold a pointer to a `clang::AnyX86NoCfCheckAttr` object.
"""
struct AnyX86NoCfCheckAttr <: AbstractAnyX86NoCfCheckAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AnyX86NoCfCheckAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AnyX86NoCfCheckAttr) = x

"""
    struct CDeclAttr <: AbstractCDeclAttr
Hold a pointer to a `clang::CDeclAttr` object.
"""
struct CDeclAttr <: AbstractCDeclAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CDeclAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CDeclAttr) = x

"""
    struct FastCallAttr <: AbstractFastCallAttr
Hold a pointer to a `clang::FastCallAttr` object.
"""
struct FastCallAttr <: AbstractFastCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FastCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FastCallAttr) = x

"""
    struct IntelOclBiccAttr <: AbstractIntelOclBiccAttr
Hold a pointer to a `clang::IntelOclBiccAttr` object.
"""
struct IntelOclBiccAttr <: AbstractIntelOclBiccAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::IntelOclBiccAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::IntelOclBiccAttr) = x

"""
    struct LifetimeBoundAttr <: AbstractLifetimeBoundAttr
Hold a pointer to a `clang::LifetimeBoundAttr` object.
"""
struct LifetimeBoundAttr <: AbstractLifetimeBoundAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LifetimeBoundAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LifetimeBoundAttr) = x

"""
    struct M68kRTDAttr <: AbstractM68kRTDAttr
Hold a pointer to a `clang::M68kRTDAttr` object.
"""
struct M68kRTDAttr <: AbstractM68kRTDAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::M68kRTDAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::M68kRTDAttr) = x

"""
    struct MSABIAttr <: AbstractMSABIAttr
Hold a pointer to a `clang::MSABIAttr` object.
"""
struct MSABIAttr <: AbstractMSABIAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSABIAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSABIAttr) = x

"""
    struct NSReturnsRetainedAttr <: AbstractNSReturnsRetainedAttr
Hold a pointer to a `clang::NSReturnsRetainedAttr` object.
"""
struct NSReturnsRetainedAttr <: AbstractNSReturnsRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NSReturnsRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NSReturnsRetainedAttr) = x

"""
    struct ObjCOwnershipAttr <: AbstractObjCOwnershipAttr
Hold a pointer to a `clang::ObjCOwnershipAttr` object.
"""
struct ObjCOwnershipAttr <: AbstractObjCOwnershipAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCOwnershipAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCOwnershipAttr) = x

"""
    struct PascalAttr <: AbstractPascalAttr
Hold a pointer to a `clang::PascalAttr` object.
"""
struct PascalAttr <: AbstractPascalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PascalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PascalAttr) = x

"""
    struct PcsAttr <: AbstractPcsAttr
Hold a pointer to a `clang::PcsAttr` object.
"""
struct PcsAttr <: AbstractPcsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PcsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PcsAttr) = x

"""
    struct PreserveAllAttr <: AbstractPreserveAllAttr
Hold a pointer to a `clang::PreserveAllAttr` object.
"""
struct PreserveAllAttr <: AbstractPreserveAllAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PreserveAllAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PreserveAllAttr) = x

"""
    struct PreserveMostAttr <: AbstractPreserveMostAttr
Hold a pointer to a `clang::PreserveMostAttr` object.
"""
struct PreserveMostAttr <: AbstractPreserveMostAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PreserveMostAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PreserveMostAttr) = x

"""
    struct RegCallAttr <: AbstractRegCallAttr
Hold a pointer to a `clang::RegCallAttr` object.
"""
struct RegCallAttr <: AbstractRegCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RegCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RegCallAttr) = x

"""
    struct StdCallAttr <: AbstractStdCallAttr
Hold a pointer to a `clang::StdCallAttr` object.
"""
struct StdCallAttr <: AbstractStdCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::StdCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::StdCallAttr) = x

"""
    struct SwiftAsyncCallAttr <: AbstractSwiftAsyncCallAttr
Hold a pointer to a `clang::SwiftAsyncCallAttr` object.
"""
struct SwiftAsyncCallAttr <: AbstractSwiftAsyncCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftAsyncCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftAsyncCallAttr) = x

"""
    struct SwiftCallAttr <: AbstractSwiftCallAttr
Hold a pointer to a `clang::SwiftCallAttr` object.
"""
struct SwiftCallAttr <: AbstractSwiftCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftCallAttr) = x

"""
    struct SysVABIAttr <: AbstractSysVABIAttr
Hold a pointer to a `clang::SysVABIAttr` object.
"""
struct SysVABIAttr <: AbstractSysVABIAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SysVABIAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SysVABIAttr) = x

"""
    struct ThisCallAttr <: AbstractThisCallAttr
Hold a pointer to a `clang::ThisCallAttr` object.
"""
struct ThisCallAttr <: AbstractThisCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ThisCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ThisCallAttr) = x

"""
    struct VectorCallAttr <: AbstractVectorCallAttr
Hold a pointer to a `clang::VectorCallAttr` object.
"""
struct VectorCallAttr <: AbstractVectorCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::VectorCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::VectorCallAttr) = x

"""
    struct SwiftAsyncContextAttr <: AbstractSwiftAsyncContextAttr
Hold a pointer to a `clang::SwiftAsyncContextAttr` object.
"""
struct SwiftAsyncContextAttr <: AbstractSwiftAsyncContextAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftAsyncContextAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftAsyncContextAttr) = x

"""
    struct SwiftContextAttr <: AbstractSwiftContextAttr
Hold a pointer to a `clang::SwiftContextAttr` object.
"""
struct SwiftContextAttr <: AbstractSwiftContextAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftContextAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftContextAttr) = x

"""
    struct SwiftErrorResultAttr <: AbstractSwiftErrorResultAttr
Hold a pointer to a `clang::SwiftErrorResultAttr` object.
"""
struct SwiftErrorResultAttr <: AbstractSwiftErrorResultAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftErrorResultAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftErrorResultAttr) = x

"""
    struct SwiftIndirectResultAttr <: AbstractSwiftIndirectResultAttr
Hold a pointer to a `clang::SwiftIndirectResultAttr` object.
"""
struct SwiftIndirectResultAttr <: AbstractSwiftIndirectResultAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftIndirectResultAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftIndirectResultAttr) = x

"""
    struct AnnotateAttr <: AbstractAnnotateAttr
Hold a pointer to a `clang::AnnotateAttr` object.
"""
struct AnnotateAttr <: AbstractAnnotateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AnnotateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AnnotateAttr) = x

"""
    struct CFConsumedAttr <: AbstractCFConsumedAttr
Hold a pointer to a `clang::CFConsumedAttr` object.
"""
struct CFConsumedAttr <: AbstractCFConsumedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFConsumedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFConsumedAttr) = x

"""
    struct CarriesDependencyAttr <: AbstractCarriesDependencyAttr
Hold a pointer to a `clang::CarriesDependencyAttr` object.
"""
struct CarriesDependencyAttr <: AbstractCarriesDependencyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CarriesDependencyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CarriesDependencyAttr) = x

"""
    struct NSConsumedAttr <: AbstractNSConsumedAttr
Hold a pointer to a `clang::NSConsumedAttr` object.
"""
struct NSConsumedAttr <: AbstractNSConsumedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NSConsumedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NSConsumedAttr) = x

"""
    struct NonNullAttr <: AbstractNonNullAttr
Hold a pointer to a `clang::NonNullAttr` object.
"""
struct NonNullAttr <: AbstractNonNullAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NonNullAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NonNullAttr) = x

"""
    struct OSConsumedAttr <: AbstractOSConsumedAttr
Hold a pointer to a `clang::OSConsumedAttr` object.
"""
struct OSConsumedAttr <: AbstractOSConsumedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OSConsumedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OSConsumedAttr) = x

"""
    struct PassObjectSizeAttr <: AbstractPassObjectSizeAttr
Hold a pointer to a `clang::PassObjectSizeAttr` object.
"""
struct PassObjectSizeAttr <: AbstractPassObjectSizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PassObjectSizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PassObjectSizeAttr) = x

"""
    struct ReleaseHandleAttr <: AbstractReleaseHandleAttr
Hold a pointer to a `clang::ReleaseHandleAttr` object.
"""
struct ReleaseHandleAttr <: AbstractReleaseHandleAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReleaseHandleAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReleaseHandleAttr) = x

"""
    struct UseHandleAttr <: AbstractUseHandleAttr
Hold a pointer to a `clang::UseHandleAttr` object.
"""
struct UseHandleAttr <: AbstractUseHandleAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UseHandleAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UseHandleAttr) = x

"""
    struct HLSLSV_DispatchThreadIDAttr <: AbstractHLSLSV_DispatchThreadIDAttr
Hold a pointer to a `clang::HLSLSV_DispatchThreadIDAttr` object.
"""
struct HLSLSV_DispatchThreadIDAttr <: AbstractHLSLSV_DispatchThreadIDAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLSV_DispatchThreadIDAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLSV_DispatchThreadIDAttr) = x

"""
    struct HLSLSV_GroupIndexAttr <: AbstractHLSLSV_GroupIndexAttr
Hold a pointer to a `clang::HLSLSV_GroupIndexAttr` object.
"""
struct HLSLSV_GroupIndexAttr <: AbstractHLSLSV_GroupIndexAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLSV_GroupIndexAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLSV_GroupIndexAttr) = x

"""
    struct AMDGPUFlatWorkGroupSizeAttr <: AbstractAMDGPUFlatWorkGroupSizeAttr
Hold a pointer to a `clang::AMDGPUFlatWorkGroupSizeAttr` object.
"""
struct AMDGPUFlatWorkGroupSizeAttr <: AbstractAMDGPUFlatWorkGroupSizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AMDGPUFlatWorkGroupSizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AMDGPUFlatWorkGroupSizeAttr) = x

"""
    struct AMDGPUNumSGPRAttr <: AbstractAMDGPUNumSGPRAttr
Hold a pointer to a `clang::AMDGPUNumSGPRAttr` object.
"""
struct AMDGPUNumSGPRAttr <: AbstractAMDGPUNumSGPRAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AMDGPUNumSGPRAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AMDGPUNumSGPRAttr) = x

"""
    struct AMDGPUNumVGPRAttr <: AbstractAMDGPUNumVGPRAttr
Hold a pointer to a `clang::AMDGPUNumVGPRAttr` object.
"""
struct AMDGPUNumVGPRAttr <: AbstractAMDGPUNumVGPRAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AMDGPUNumVGPRAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AMDGPUNumVGPRAttr) = x

"""
    struct AMDGPUWavesPerEUAttr <: AbstractAMDGPUWavesPerEUAttr
Hold a pointer to a `clang::AMDGPUWavesPerEUAttr` object.
"""
struct AMDGPUWavesPerEUAttr <: AbstractAMDGPUWavesPerEUAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AMDGPUWavesPerEUAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AMDGPUWavesPerEUAttr) = x

"""
    struct ARMInterruptAttr <: AbstractARMInterruptAttr
Hold a pointer to a `clang::ARMInterruptAttr` object.
"""
struct ARMInterruptAttr <: AbstractARMInterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ARMInterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ARMInterruptAttr) = x

"""
    struct AVRInterruptAttr <: AbstractAVRInterruptAttr
Hold a pointer to a `clang::AVRInterruptAttr` object.
"""
struct AVRInterruptAttr <: AbstractAVRInterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AVRInterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AVRInterruptAttr) = x

"""
    struct AVRSignalAttr <: AbstractAVRSignalAttr
Hold a pointer to a `clang::AVRSignalAttr` object.
"""
struct AVRSignalAttr <: AbstractAVRSignalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AVRSignalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AVRSignalAttr) = x

"""
    struct AcquireCapabilityAttr <: AbstractAcquireCapabilityAttr
Hold a pointer to a `clang::AcquireCapabilityAttr` object.
"""
struct AcquireCapabilityAttr <: AbstractAcquireCapabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AcquireCapabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AcquireCapabilityAttr) = x

"""
    struct AcquiredAfterAttr <: AbstractAcquiredAfterAttr
Hold a pointer to a `clang::AcquiredAfterAttr` object.
"""
struct AcquiredAfterAttr <: AbstractAcquiredAfterAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AcquiredAfterAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AcquiredAfterAttr) = x

"""
    struct AcquiredBeforeAttr <: AbstractAcquiredBeforeAttr
Hold a pointer to a `clang::AcquiredBeforeAttr` object.
"""
struct AcquiredBeforeAttr <: AbstractAcquiredBeforeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AcquiredBeforeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AcquiredBeforeAttr) = x

"""
    struct AlignMac68kAttr <: AbstractAlignMac68kAttr
Hold a pointer to a `clang::AlignMac68kAttr` object.
"""
struct AlignMac68kAttr <: AbstractAlignMac68kAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AlignMac68kAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AlignMac68kAttr) = x

"""
    struct AlignNaturalAttr <: AbstractAlignNaturalAttr
Hold a pointer to a `clang::AlignNaturalAttr` object.
"""
struct AlignNaturalAttr <: AbstractAlignNaturalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AlignNaturalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AlignNaturalAttr) = x

"""
    struct AlignedAttr <: AbstractAlignedAttr
Hold a pointer to a `clang::AlignedAttr` object.
"""
struct AlignedAttr <: AbstractAlignedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AlignedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AlignedAttr) = x

"""
    struct AllocAlignAttr <: AbstractAllocAlignAttr
Hold a pointer to a `clang::AllocAlignAttr` object.
"""
struct AllocAlignAttr <: AbstractAllocAlignAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AllocAlignAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AllocAlignAttr) = x

"""
    struct AllocSizeAttr <: AbstractAllocSizeAttr
Hold a pointer to a `clang::AllocSizeAttr` object.
"""
struct AllocSizeAttr <: AbstractAllocSizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AllocSizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AllocSizeAttr) = x

"""
    struct AlwaysDestroyAttr <: AbstractAlwaysDestroyAttr
Hold a pointer to a `clang::AlwaysDestroyAttr` object.
"""
struct AlwaysDestroyAttr <: AbstractAlwaysDestroyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AlwaysDestroyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AlwaysDestroyAttr) = x

"""
    struct AnalyzerNoReturnAttr <: AbstractAnalyzerNoReturnAttr
Hold a pointer to a `clang::AnalyzerNoReturnAttr` object.
"""
struct AnalyzerNoReturnAttr <: AbstractAnalyzerNoReturnAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AnalyzerNoReturnAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AnalyzerNoReturnAttr) = x

"""
    struct AnyX86InterruptAttr <: AbstractAnyX86InterruptAttr
Hold a pointer to a `clang::AnyX86InterruptAttr` object.
"""
struct AnyX86InterruptAttr <: AbstractAnyX86InterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AnyX86InterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AnyX86InterruptAttr) = x

"""
    struct AnyX86NoCallerSavedRegistersAttr <: AbstractAnyX86NoCallerSavedRegistersAttr
Hold a pointer to a `clang::AnyX86NoCallerSavedRegistersAttr` object.
"""
struct AnyX86NoCallerSavedRegistersAttr <: AbstractAnyX86NoCallerSavedRegistersAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AnyX86NoCallerSavedRegistersAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AnyX86NoCallerSavedRegistersAttr) = x

"""
    struct ArcWeakrefUnavailableAttr <: AbstractArcWeakrefUnavailableAttr
Hold a pointer to a `clang::ArcWeakrefUnavailableAttr` object.
"""
struct ArcWeakrefUnavailableAttr <: AbstractArcWeakrefUnavailableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArcWeakrefUnavailableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArcWeakrefUnavailableAttr) = x

"""
    struct ArgumentWithTypeTagAttr <: AbstractArgumentWithTypeTagAttr
Hold a pointer to a `clang::ArgumentWithTypeTagAttr` object.
"""
struct ArgumentWithTypeTagAttr <: AbstractArgumentWithTypeTagAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArgumentWithTypeTagAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArgumentWithTypeTagAttr) = x

"""
    struct ArmBuiltinAliasAttr <: AbstractArmBuiltinAliasAttr
Hold a pointer to a `clang::ArmBuiltinAliasAttr` object.
"""
struct ArmBuiltinAliasAttr <: AbstractArmBuiltinAliasAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmBuiltinAliasAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmBuiltinAliasAttr) = x

"""
    struct ArmLocallyStreamingAttr <: AbstractArmLocallyStreamingAttr
Hold a pointer to a `clang::ArmLocallyStreamingAttr` object.
"""
struct ArmLocallyStreamingAttr <: AbstractArmLocallyStreamingAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmLocallyStreamingAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmLocallyStreamingAttr) = x

"""
    struct ArmNewAttr <: AbstractArmNewAttr
Hold a pointer to a `clang::ArmNewAttr` object.
"""
struct ArmNewAttr <: AbstractArmNewAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArmNewAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArmNewAttr) = x

"""
    struct ArtificialAttr <: AbstractArtificialAttr
Hold a pointer to a `clang::ArtificialAttr` object.
"""
struct ArtificialAttr <: AbstractArtificialAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ArtificialAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ArtificialAttr) = x

"""
    struct AsmLabelAttr <: AbstractAsmLabelAttr
Hold a pointer to a `clang::AsmLabelAttr` object.
"""
struct AsmLabelAttr <: AbstractAsmLabelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AsmLabelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AsmLabelAttr) = x

"""
    struct AssertCapabilityAttr <: AbstractAssertCapabilityAttr
Hold a pointer to a `clang::AssertCapabilityAttr` object.
"""
struct AssertCapabilityAttr <: AbstractAssertCapabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AssertCapabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AssertCapabilityAttr) = x

"""
    struct AssertExclusiveLockAttr <: AbstractAssertExclusiveLockAttr
Hold a pointer to a `clang::AssertExclusiveLockAttr` object.
"""
struct AssertExclusiveLockAttr <: AbstractAssertExclusiveLockAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AssertExclusiveLockAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AssertExclusiveLockAttr) = x

"""
    struct AssertSharedLockAttr <: AbstractAssertSharedLockAttr
Hold a pointer to a `clang::AssertSharedLockAttr` object.
"""
struct AssertSharedLockAttr <: AbstractAssertSharedLockAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AssertSharedLockAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AssertSharedLockAttr) = x

"""
    struct AssumeAlignedAttr <: AbstractAssumeAlignedAttr
Hold a pointer to a `clang::AssumeAlignedAttr` object.
"""
struct AssumeAlignedAttr <: AbstractAssumeAlignedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AssumeAlignedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AssumeAlignedAttr) = x

"""
    struct AssumptionAttr <: AbstractAssumptionAttr
Hold a pointer to a `clang::AssumptionAttr` object.
"""
struct AssumptionAttr <: AbstractAssumptionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AssumptionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AssumptionAttr) = x

"""
    struct AvailabilityAttr <: AbstractAvailabilityAttr
Hold a pointer to a `clang::AvailabilityAttr` object.
"""
struct AvailabilityAttr <: AbstractAvailabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AvailabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AvailabilityAttr) = x

"""
    struct AvailableOnlyInDefaultEvalMethodAttr <: AbstractAvailableOnlyInDefaultEvalMethodAttr
Hold a pointer to a `clang::AvailableOnlyInDefaultEvalMethodAttr` object.
"""
struct AvailableOnlyInDefaultEvalMethodAttr <: AbstractAvailableOnlyInDefaultEvalMethodAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AvailableOnlyInDefaultEvalMethodAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AvailableOnlyInDefaultEvalMethodAttr) = x

"""
    struct BPFPreserveAccessIndexAttr <: AbstractBPFPreserveAccessIndexAttr
Hold a pointer to a `clang::BPFPreserveAccessIndexAttr` object.
"""
struct BPFPreserveAccessIndexAttr <: AbstractBPFPreserveAccessIndexAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BPFPreserveAccessIndexAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BPFPreserveAccessIndexAttr) = x

"""
    struct BPFPreserveStaticOffsetAttr <: AbstractBPFPreserveStaticOffsetAttr
Hold a pointer to a `clang::BPFPreserveStaticOffsetAttr` object.
"""
struct BPFPreserveStaticOffsetAttr <: AbstractBPFPreserveStaticOffsetAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BPFPreserveStaticOffsetAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BPFPreserveStaticOffsetAttr) = x

"""
    struct BTFDeclTagAttr <: AbstractBTFDeclTagAttr
Hold a pointer to a `clang::BTFDeclTagAttr` object.
"""
struct BTFDeclTagAttr <: AbstractBTFDeclTagAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BTFDeclTagAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BTFDeclTagAttr) = x

"""
    struct BlocksAttr <: AbstractBlocksAttr
Hold a pointer to a `clang::BlocksAttr` object.
"""
struct BlocksAttr <: AbstractBlocksAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BlocksAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BlocksAttr) = x

"""
    struct BuiltinAttr <: AbstractBuiltinAttr
Hold a pointer to a `clang::BuiltinAttr` object.
"""
struct BuiltinAttr <: AbstractBuiltinAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BuiltinAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BuiltinAttr) = x

"""
    struct C11NoReturnAttr <: AbstractC11NoReturnAttr
Hold a pointer to a `clang::C11NoReturnAttr` object.
"""
struct C11NoReturnAttr <: AbstractC11NoReturnAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::C11NoReturnAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::C11NoReturnAttr) = x

"""
    struct CFAuditedTransferAttr <: AbstractCFAuditedTransferAttr
Hold a pointer to a `clang::CFAuditedTransferAttr` object.
"""
struct CFAuditedTransferAttr <: AbstractCFAuditedTransferAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFAuditedTransferAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFAuditedTransferAttr) = x

"""
    struct CFGuardAttr <: AbstractCFGuardAttr
Hold a pointer to a `clang::CFGuardAttr` object.
"""
struct CFGuardAttr <: AbstractCFGuardAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFGuardAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFGuardAttr) = x

"""
    struct CFICanonicalJumpTableAttr <: AbstractCFICanonicalJumpTableAttr
Hold a pointer to a `clang::CFICanonicalJumpTableAttr` object.
"""
struct CFICanonicalJumpTableAttr <: AbstractCFICanonicalJumpTableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFICanonicalJumpTableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFICanonicalJumpTableAttr) = x

"""
    struct CFReturnsNotRetainedAttr <: AbstractCFReturnsNotRetainedAttr
Hold a pointer to a `clang::CFReturnsNotRetainedAttr` object.
"""
struct CFReturnsNotRetainedAttr <: AbstractCFReturnsNotRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFReturnsNotRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFReturnsNotRetainedAttr) = x

"""
    struct CFReturnsRetainedAttr <: AbstractCFReturnsRetainedAttr
Hold a pointer to a `clang::CFReturnsRetainedAttr` object.
"""
struct CFReturnsRetainedAttr <: AbstractCFReturnsRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFReturnsRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFReturnsRetainedAttr) = x

"""
    struct CFUnknownTransferAttr <: AbstractCFUnknownTransferAttr
Hold a pointer to a `clang::CFUnknownTransferAttr` object.
"""
struct CFUnknownTransferAttr <: AbstractCFUnknownTransferAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CFUnknownTransferAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CFUnknownTransferAttr) = x

"""
    struct CPUDispatchAttr <: AbstractCPUDispatchAttr
Hold a pointer to a `clang::CPUDispatchAttr` object.
"""
struct CPUDispatchAttr <: AbstractCPUDispatchAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CPUDispatchAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CPUDispatchAttr) = x

"""
    struct CPUSpecificAttr <: AbstractCPUSpecificAttr
Hold a pointer to a `clang::CPUSpecificAttr` object.
"""
struct CPUSpecificAttr <: AbstractCPUSpecificAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CPUSpecificAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CPUSpecificAttr) = x

"""
    struct CUDAConstantAttr <: AbstractCUDAConstantAttr
Hold a pointer to a `clang::CUDAConstantAttr` object.
"""
struct CUDAConstantAttr <: AbstractCUDAConstantAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDAConstantAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDAConstantAttr) = x

"""
    struct CUDADeviceAttr <: AbstractCUDADeviceAttr
Hold a pointer to a `clang::CUDADeviceAttr` object.
"""
struct CUDADeviceAttr <: AbstractCUDADeviceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDADeviceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDADeviceAttr) = x

"""
    struct CUDADeviceBuiltinSurfaceTypeAttr <: AbstractCUDADeviceBuiltinSurfaceTypeAttr
Hold a pointer to a `clang::CUDADeviceBuiltinSurfaceTypeAttr` object.
"""
struct CUDADeviceBuiltinSurfaceTypeAttr <: AbstractCUDADeviceBuiltinSurfaceTypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDADeviceBuiltinSurfaceTypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDADeviceBuiltinSurfaceTypeAttr) = x

"""
    struct CUDADeviceBuiltinTextureTypeAttr <: AbstractCUDADeviceBuiltinTextureTypeAttr
Hold a pointer to a `clang::CUDADeviceBuiltinTextureTypeAttr` object.
"""
struct CUDADeviceBuiltinTextureTypeAttr <: AbstractCUDADeviceBuiltinTextureTypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDADeviceBuiltinTextureTypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDADeviceBuiltinTextureTypeAttr) = x

"""
    struct CUDAGlobalAttr <: AbstractCUDAGlobalAttr
Hold a pointer to a `clang::CUDAGlobalAttr` object.
"""
struct CUDAGlobalAttr <: AbstractCUDAGlobalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDAGlobalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDAGlobalAttr) = x

"""
    struct CUDAHostAttr <: AbstractCUDAHostAttr
Hold a pointer to a `clang::CUDAHostAttr` object.
"""
struct CUDAHostAttr <: AbstractCUDAHostAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDAHostAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDAHostAttr) = x

"""
    struct CUDAInvalidTargetAttr <: AbstractCUDAInvalidTargetAttr
Hold a pointer to a `clang::CUDAInvalidTargetAttr` object.
"""
struct CUDAInvalidTargetAttr <: AbstractCUDAInvalidTargetAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDAInvalidTargetAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDAInvalidTargetAttr) = x

"""
    struct CUDALaunchBoundsAttr <: AbstractCUDALaunchBoundsAttr
Hold a pointer to a `clang::CUDALaunchBoundsAttr` object.
"""
struct CUDALaunchBoundsAttr <: AbstractCUDALaunchBoundsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDALaunchBoundsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDALaunchBoundsAttr) = x

"""
    struct CUDASharedAttr <: AbstractCUDASharedAttr
Hold a pointer to a `clang::CUDASharedAttr` object.
"""
struct CUDASharedAttr <: AbstractCUDASharedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CUDASharedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CUDASharedAttr) = x

"""
    struct CXX11NoReturnAttr <: AbstractCXX11NoReturnAttr
Hold a pointer to a `clang::CXX11NoReturnAttr` object.
"""
struct CXX11NoReturnAttr <: AbstractCXX11NoReturnAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CXX11NoReturnAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CXX11NoReturnAttr) = x

"""
    struct CallableWhenAttr <: AbstractCallableWhenAttr
Hold a pointer to a `clang::CallableWhenAttr` object.
"""
struct CallableWhenAttr <: AbstractCallableWhenAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CallableWhenAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CallableWhenAttr) = x

"""
    struct CallbackAttr <: AbstractCallbackAttr
Hold a pointer to a `clang::CallbackAttr` object.
"""
struct CallbackAttr <: AbstractCallbackAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CallbackAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CallbackAttr) = x

"""
    struct CapabilityAttr <: AbstractCapabilityAttr
Hold a pointer to a `clang::CapabilityAttr` object.
"""
struct CapabilityAttr <: AbstractCapabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CapabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CapabilityAttr) = x

"""
    struct CapturedRecordAttr <: AbstractCapturedRecordAttr
Hold a pointer to a `clang::CapturedRecordAttr` object.
"""
struct CapturedRecordAttr <: AbstractCapturedRecordAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CapturedRecordAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CapturedRecordAttr) = x

"""
    struct CleanupAttr <: AbstractCleanupAttr
Hold a pointer to a `clang::CleanupAttr` object.
"""
struct CleanupAttr <: AbstractCleanupAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CleanupAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CleanupAttr) = x

"""
    struct CmseNSEntryAttr <: AbstractCmseNSEntryAttr
Hold a pointer to a `clang::CmseNSEntryAttr` object.
"""
struct CmseNSEntryAttr <: AbstractCmseNSEntryAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CmseNSEntryAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CmseNSEntryAttr) = x

"""
    struct CodeModelAttr <: AbstractCodeModelAttr
Hold a pointer to a `clang::CodeModelAttr` object.
"""
struct CodeModelAttr <: AbstractCodeModelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CodeModelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CodeModelAttr) = x

"""
    struct CodeSegAttr <: AbstractCodeSegAttr
Hold a pointer to a `clang::CodeSegAttr` object.
"""
struct CodeSegAttr <: AbstractCodeSegAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CodeSegAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CodeSegAttr) = x

"""
    struct ColdAttr <: AbstractColdAttr
Hold a pointer to a `clang::ColdAttr` object.
"""
struct ColdAttr <: AbstractColdAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ColdAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ColdAttr) = x

"""
    struct CommonAttr <: AbstractCommonAttr
Hold a pointer to a `clang::CommonAttr` object.
"""
struct CommonAttr <: AbstractCommonAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CommonAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CommonAttr) = x

"""
    struct ConstAttr <: AbstractConstAttr
Hold a pointer to a `clang::ConstAttr` object.
"""
struct ConstAttr <: AbstractConstAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConstAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConstAttr) = x

"""
    struct ConstInitAttr <: AbstractConstInitAttr
Hold a pointer to a `clang::ConstInitAttr` object.
"""
struct ConstInitAttr <: AbstractConstInitAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConstInitAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConstInitAttr) = x

"""
    struct ConstructorAttr <: AbstractConstructorAttr
Hold a pointer to a `clang::ConstructorAttr` object.
"""
struct ConstructorAttr <: AbstractConstructorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConstructorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConstructorAttr) = x

"""
    struct ConsumableAttr <: AbstractConsumableAttr
Hold a pointer to a `clang::ConsumableAttr` object.
"""
struct ConsumableAttr <: AbstractConsumableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConsumableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConsumableAttr) = x

"""
    struct ConsumableAutoCastAttr <: AbstractConsumableAutoCastAttr
Hold a pointer to a `clang::ConsumableAutoCastAttr` object.
"""
struct ConsumableAutoCastAttr <: AbstractConsumableAutoCastAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConsumableAutoCastAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConsumableAutoCastAttr) = x

"""
    struct ConsumableSetOnReadAttr <: AbstractConsumableSetOnReadAttr
Hold a pointer to a `clang::ConsumableSetOnReadAttr` object.
"""
struct ConsumableSetOnReadAttr <: AbstractConsumableSetOnReadAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConsumableSetOnReadAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConsumableSetOnReadAttr) = x

"""
    struct ConvergentAttr <: AbstractConvergentAttr
Hold a pointer to a `clang::ConvergentAttr` object.
"""
struct ConvergentAttr <: AbstractConvergentAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ConvergentAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ConvergentAttr) = x

"""
    struct CoroDisableLifetimeBoundAttr <: AbstractCoroDisableLifetimeBoundAttr
Hold a pointer to a `clang::CoroDisableLifetimeBoundAttr` object.
"""
struct CoroDisableLifetimeBoundAttr <: AbstractCoroDisableLifetimeBoundAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CoroDisableLifetimeBoundAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CoroDisableLifetimeBoundAttr) = x

"""
    struct CoroLifetimeBoundAttr <: AbstractCoroLifetimeBoundAttr
Hold a pointer to a `clang::CoroLifetimeBoundAttr` object.
"""
struct CoroLifetimeBoundAttr <: AbstractCoroLifetimeBoundAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CoroLifetimeBoundAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CoroLifetimeBoundAttr) = x

"""
    struct CoroOnlyDestroyWhenCompleteAttr <: AbstractCoroOnlyDestroyWhenCompleteAttr
Hold a pointer to a `clang::CoroOnlyDestroyWhenCompleteAttr` object.
"""
struct CoroOnlyDestroyWhenCompleteAttr <: AbstractCoroOnlyDestroyWhenCompleteAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CoroOnlyDestroyWhenCompleteAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CoroOnlyDestroyWhenCompleteAttr) = x

"""
    struct CoroReturnTypeAttr <: AbstractCoroReturnTypeAttr
Hold a pointer to a `clang::CoroReturnTypeAttr` object.
"""
struct CoroReturnTypeAttr <: AbstractCoroReturnTypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CoroReturnTypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CoroReturnTypeAttr) = x

"""
    struct CoroWrapperAttr <: AbstractCoroWrapperAttr
Hold a pointer to a `clang::CoroWrapperAttr` object.
"""
struct CoroWrapperAttr <: AbstractCoroWrapperAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CoroWrapperAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CoroWrapperAttr) = x

"""
    struct CountedByAttr <: AbstractCountedByAttr
Hold a pointer to a `clang::CountedByAttr` object.
"""
struct CountedByAttr <: AbstractCountedByAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CountedByAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CountedByAttr) = x

"""
    struct DLLExportAttr <: AbstractDLLExportAttr
Hold a pointer to a `clang::DLLExportAttr` object.
"""
struct DLLExportAttr <: AbstractDLLExportAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DLLExportAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DLLExportAttr) = x

"""
    struct DLLExportStaticLocalAttr <: AbstractDLLExportStaticLocalAttr
Hold a pointer to a `clang::DLLExportStaticLocalAttr` object.
"""
struct DLLExportStaticLocalAttr <: AbstractDLLExportStaticLocalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DLLExportStaticLocalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DLLExportStaticLocalAttr) = x

"""
    struct DLLImportAttr <: AbstractDLLImportAttr
Hold a pointer to a `clang::DLLImportAttr` object.
"""
struct DLLImportAttr <: AbstractDLLImportAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DLLImportAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DLLImportAttr) = x

"""
    struct DLLImportStaticLocalAttr <: AbstractDLLImportStaticLocalAttr
Hold a pointer to a `clang::DLLImportStaticLocalAttr` object.
"""
struct DLLImportStaticLocalAttr <: AbstractDLLImportStaticLocalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DLLImportStaticLocalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DLLImportStaticLocalAttr) = x

"""
    struct DeprecatedAttr <: AbstractDeprecatedAttr
Hold a pointer to a `clang::DeprecatedAttr` object.
"""
struct DeprecatedAttr <: AbstractDeprecatedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DeprecatedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DeprecatedAttr) = x

"""
    struct DestructorAttr <: AbstractDestructorAttr
Hold a pointer to a `clang::DestructorAttr` object.
"""
struct DestructorAttr <: AbstractDestructorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DestructorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DestructorAttr) = x

"""
    struct DiagnoseAsBuiltinAttr <: AbstractDiagnoseAsBuiltinAttr
Hold a pointer to a `clang::DiagnoseAsBuiltinAttr` object.
"""
struct DiagnoseAsBuiltinAttr <: AbstractDiagnoseAsBuiltinAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DiagnoseAsBuiltinAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DiagnoseAsBuiltinAttr) = x

"""
    struct DiagnoseIfAttr <: AbstractDiagnoseIfAttr
Hold a pointer to a `clang::DiagnoseIfAttr` object.
"""
struct DiagnoseIfAttr <: AbstractDiagnoseIfAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DiagnoseIfAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DiagnoseIfAttr) = x

"""
    struct DisableSanitizerInstrumentationAttr <: AbstractDisableSanitizerInstrumentationAttr
Hold a pointer to a `clang::DisableSanitizerInstrumentationAttr` object.
"""
struct DisableSanitizerInstrumentationAttr <: AbstractDisableSanitizerInstrumentationAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DisableSanitizerInstrumentationAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DisableSanitizerInstrumentationAttr) = x

"""
    struct DisableTailCallsAttr <: AbstractDisableTailCallsAttr
Hold a pointer to a `clang::DisableTailCallsAttr` object.
"""
struct DisableTailCallsAttr <: AbstractDisableTailCallsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::DisableTailCallsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::DisableTailCallsAttr) = x

"""
    struct EmptyBasesAttr <: AbstractEmptyBasesAttr
Hold a pointer to a `clang::EmptyBasesAttr` object.
"""
struct EmptyBasesAttr <: AbstractEmptyBasesAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::EmptyBasesAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::EmptyBasesAttr) = x

"""
    struct EnableIfAttr <: AbstractEnableIfAttr
Hold a pointer to a `clang::EnableIfAttr` object.
"""
struct EnableIfAttr <: AbstractEnableIfAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::EnableIfAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::EnableIfAttr) = x

"""
    struct EnforceTCBAttr <: AbstractEnforceTCBAttr
Hold a pointer to a `clang::EnforceTCBAttr` object.
"""
struct EnforceTCBAttr <: AbstractEnforceTCBAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::EnforceTCBAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::EnforceTCBAttr) = x

"""
    struct EnforceTCBLeafAttr <: AbstractEnforceTCBLeafAttr
Hold a pointer to a `clang::EnforceTCBLeafAttr` object.
"""
struct EnforceTCBLeafAttr <: AbstractEnforceTCBLeafAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::EnforceTCBLeafAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::EnforceTCBLeafAttr) = x

"""
    struct EnumExtensibilityAttr <: AbstractEnumExtensibilityAttr
Hold a pointer to a `clang::EnumExtensibilityAttr` object.
"""
struct EnumExtensibilityAttr <: AbstractEnumExtensibilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::EnumExtensibilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::EnumExtensibilityAttr) = x

"""
    struct ErrorAttr <: AbstractErrorAttr
Hold a pointer to a `clang::ErrorAttr` object.
"""
struct ErrorAttr <: AbstractErrorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ErrorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ErrorAttr) = x

"""
    struct ExcludeFromExplicitInstantiationAttr <: AbstractExcludeFromExplicitInstantiationAttr
Hold a pointer to a `clang::ExcludeFromExplicitInstantiationAttr` object.
"""
struct ExcludeFromExplicitInstantiationAttr <: AbstractExcludeFromExplicitInstantiationAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ExcludeFromExplicitInstantiationAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ExcludeFromExplicitInstantiationAttr) = x

"""
    struct ExclusiveTrylockFunctionAttr <: AbstractExclusiveTrylockFunctionAttr
Hold a pointer to a `clang::ExclusiveTrylockFunctionAttr` object.
"""
struct ExclusiveTrylockFunctionAttr <: AbstractExclusiveTrylockFunctionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ExclusiveTrylockFunctionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ExclusiveTrylockFunctionAttr) = x

"""
    struct ExternalSourceSymbolAttr <: AbstractExternalSourceSymbolAttr
Hold a pointer to a `clang::ExternalSourceSymbolAttr` object.
"""
struct ExternalSourceSymbolAttr <: AbstractExternalSourceSymbolAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ExternalSourceSymbolAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ExternalSourceSymbolAttr) = x

"""
    struct FinalAttr <: AbstractFinalAttr
Hold a pointer to a `clang::FinalAttr` object.
"""
struct FinalAttr <: AbstractFinalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FinalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FinalAttr) = x

"""
    struct FlagEnumAttr <: AbstractFlagEnumAttr
Hold a pointer to a `clang::FlagEnumAttr` object.
"""
struct FlagEnumAttr <: AbstractFlagEnumAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FlagEnumAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FlagEnumAttr) = x

"""
    struct FlattenAttr <: AbstractFlattenAttr
Hold a pointer to a `clang::FlattenAttr` object.
"""
struct FlattenAttr <: AbstractFlattenAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FlattenAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FlattenAttr) = x

"""
    struct FormatAttr <: AbstractFormatAttr
Hold a pointer to a `clang::FormatAttr` object.
"""
struct FormatAttr <: AbstractFormatAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FormatAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FormatAttr) = x

"""
    struct FormatArgAttr <: AbstractFormatArgAttr
Hold a pointer to a `clang::FormatArgAttr` object.
"""
struct FormatArgAttr <: AbstractFormatArgAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FormatArgAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FormatArgAttr) = x

"""
    struct FunctionReturnThunksAttr <: AbstractFunctionReturnThunksAttr
Hold a pointer to a `clang::FunctionReturnThunksAttr` object.
"""
struct FunctionReturnThunksAttr <: AbstractFunctionReturnThunksAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::FunctionReturnThunksAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::FunctionReturnThunksAttr) = x

"""
    struct GNUInlineAttr <: AbstractGNUInlineAttr
Hold a pointer to a `clang::GNUInlineAttr` object.
"""
struct GNUInlineAttr <: AbstractGNUInlineAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::GNUInlineAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::GNUInlineAttr) = x

"""
    struct GuardedByAttr <: AbstractGuardedByAttr
Hold a pointer to a `clang::GuardedByAttr` object.
"""
struct GuardedByAttr <: AbstractGuardedByAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::GuardedByAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::GuardedByAttr) = x

"""
    struct GuardedVarAttr <: AbstractGuardedVarAttr
Hold a pointer to a `clang::GuardedVarAttr` object.
"""
struct GuardedVarAttr <: AbstractGuardedVarAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::GuardedVarAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::GuardedVarAttr) = x

"""
    struct HIPManagedAttr <: AbstractHIPManagedAttr
Hold a pointer to a `clang::HIPManagedAttr` object.
"""
struct HIPManagedAttr <: AbstractHIPManagedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HIPManagedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HIPManagedAttr) = x

"""
    struct HLSLNumThreadsAttr <: AbstractHLSLNumThreadsAttr
Hold a pointer to a `clang::HLSLNumThreadsAttr` object.
"""
struct HLSLNumThreadsAttr <: AbstractHLSLNumThreadsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLNumThreadsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLNumThreadsAttr) = x

"""
    struct HLSLResourceAttr <: AbstractHLSLResourceAttr
Hold a pointer to a `clang::HLSLResourceAttr` object.
"""
struct HLSLResourceAttr <: AbstractHLSLResourceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLResourceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLResourceAttr) = x

"""
    struct HLSLResourceBindingAttr <: AbstractHLSLResourceBindingAttr
Hold a pointer to a `clang::HLSLResourceBindingAttr` object.
"""
struct HLSLResourceBindingAttr <: AbstractHLSLResourceBindingAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLResourceBindingAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLResourceBindingAttr) = x

"""
    struct HLSLShaderAttr <: AbstractHLSLShaderAttr
Hold a pointer to a `clang::HLSLShaderAttr` object.
"""
struct HLSLShaderAttr <: AbstractHLSLShaderAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HLSLShaderAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HLSLShaderAttr) = x

"""
    struct HotAttr <: AbstractHotAttr
Hold a pointer to a `clang::HotAttr` object.
"""
struct HotAttr <: AbstractHotAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::HotAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::HotAttr) = x

"""
    struct IBActionAttr <: AbstractIBActionAttr
Hold a pointer to a `clang::IBActionAttr` object.
"""
struct IBActionAttr <: AbstractIBActionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::IBActionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::IBActionAttr) = x

"""
    struct IBOutletAttr <: AbstractIBOutletAttr
Hold a pointer to a `clang::IBOutletAttr` object.
"""
struct IBOutletAttr <: AbstractIBOutletAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::IBOutletAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::IBOutletAttr) = x

"""
    struct IBOutletCollectionAttr <: AbstractIBOutletCollectionAttr
Hold a pointer to a `clang::IBOutletCollectionAttr` object.
"""
struct IBOutletCollectionAttr <: AbstractIBOutletCollectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::IBOutletCollectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::IBOutletCollectionAttr) = x

"""
    struct InitPriorityAttr <: AbstractInitPriorityAttr
Hold a pointer to a `clang::InitPriorityAttr` object.
"""
struct InitPriorityAttr <: AbstractInitPriorityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::InitPriorityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::InitPriorityAttr) = x

"""
    struct InternalLinkageAttr <: AbstractInternalLinkageAttr
Hold a pointer to a `clang::InternalLinkageAttr` object.
"""
struct InternalLinkageAttr <: AbstractInternalLinkageAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::InternalLinkageAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::InternalLinkageAttr) = x

"""
    struct LTOVisibilityPublicAttr <: AbstractLTOVisibilityPublicAttr
Hold a pointer to a `clang::LTOVisibilityPublicAttr` object.
"""
struct LTOVisibilityPublicAttr <: AbstractLTOVisibilityPublicAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LTOVisibilityPublicAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LTOVisibilityPublicAttr) = x

"""
    struct LayoutVersionAttr <: AbstractLayoutVersionAttr
Hold a pointer to a `clang::LayoutVersionAttr` object.
"""
struct LayoutVersionAttr <: AbstractLayoutVersionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LayoutVersionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LayoutVersionAttr) = x

"""
    struct LeafAttr <: AbstractLeafAttr
Hold a pointer to a `clang::LeafAttr` object.
"""
struct LeafAttr <: AbstractLeafAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LeafAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LeafAttr) = x

"""
    struct LockReturnedAttr <: AbstractLockReturnedAttr
Hold a pointer to a `clang::LockReturnedAttr` object.
"""
struct LockReturnedAttr <: AbstractLockReturnedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LockReturnedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LockReturnedAttr) = x

"""
    struct LocksExcludedAttr <: AbstractLocksExcludedAttr
Hold a pointer to a `clang::LocksExcludedAttr` object.
"""
struct LocksExcludedAttr <: AbstractLocksExcludedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LocksExcludedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LocksExcludedAttr) = x

"""
    struct M68kInterruptAttr <: AbstractM68kInterruptAttr
Hold a pointer to a `clang::M68kInterruptAttr` object.
"""
struct M68kInterruptAttr <: AbstractM68kInterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::M68kInterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::M68kInterruptAttr) = x

"""
    struct MIGServerRoutineAttr <: AbstractMIGServerRoutineAttr
Hold a pointer to a `clang::MIGServerRoutineAttr` object.
"""
struct MIGServerRoutineAttr <: AbstractMIGServerRoutineAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MIGServerRoutineAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MIGServerRoutineAttr) = x

"""
    struct MSAllocatorAttr <: AbstractMSAllocatorAttr
Hold a pointer to a `clang::MSAllocatorAttr` object.
"""
struct MSAllocatorAttr <: AbstractMSAllocatorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSAllocatorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSAllocatorAttr) = x

"""
    struct MSConstexprAttr <: AbstractMSConstexprAttr
Hold a pointer to a `clang::MSConstexprAttr` object.
"""
struct MSConstexprAttr <: AbstractMSConstexprAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSConstexprAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSConstexprAttr) = x

"""
    struct MSInheritanceAttr <: AbstractMSInheritanceAttr
Hold a pointer to a `clang::MSInheritanceAttr` object.
"""
struct MSInheritanceAttr <: AbstractMSInheritanceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSInheritanceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSInheritanceAttr) = x

"""
    struct MSNoVTableAttr <: AbstractMSNoVTableAttr
Hold a pointer to a `clang::MSNoVTableAttr` object.
"""
struct MSNoVTableAttr <: AbstractMSNoVTableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSNoVTableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSNoVTableAttr) = x

"""
    struct MSP430InterruptAttr <: AbstractMSP430InterruptAttr
Hold a pointer to a `clang::MSP430InterruptAttr` object.
"""
struct MSP430InterruptAttr <: AbstractMSP430InterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSP430InterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSP430InterruptAttr) = x

"""
    struct MSStructAttr <: AbstractMSStructAttr
Hold a pointer to a `clang::MSStructAttr` object.
"""
struct MSStructAttr <: AbstractMSStructAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSStructAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSStructAttr) = x

"""
    struct MSVtorDispAttr <: AbstractMSVtorDispAttr
Hold a pointer to a `clang::MSVtorDispAttr` object.
"""
struct MSVtorDispAttr <: AbstractMSVtorDispAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MSVtorDispAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MSVtorDispAttr) = x

"""
    struct MaxFieldAlignmentAttr <: AbstractMaxFieldAlignmentAttr
Hold a pointer to a `clang::MaxFieldAlignmentAttr` object.
"""
struct MaxFieldAlignmentAttr <: AbstractMaxFieldAlignmentAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MaxFieldAlignmentAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MaxFieldAlignmentAttr) = x

"""
    struct MayAliasAttr <: AbstractMayAliasAttr
Hold a pointer to a `clang::MayAliasAttr` object.
"""
struct MayAliasAttr <: AbstractMayAliasAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MayAliasAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MayAliasAttr) = x

"""
    struct MaybeUndefAttr <: AbstractMaybeUndefAttr
Hold a pointer to a `clang::MaybeUndefAttr` object.
"""
struct MaybeUndefAttr <: AbstractMaybeUndefAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MaybeUndefAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MaybeUndefAttr) = x

"""
    struct MicroMipsAttr <: AbstractMicroMipsAttr
Hold a pointer to a `clang::MicroMipsAttr` object.
"""
struct MicroMipsAttr <: AbstractMicroMipsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MicroMipsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MicroMipsAttr) = x

"""
    struct MinSizeAttr <: AbstractMinSizeAttr
Hold a pointer to a `clang::MinSizeAttr` object.
"""
struct MinSizeAttr <: AbstractMinSizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MinSizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MinSizeAttr) = x

"""
    struct MinVectorWidthAttr <: AbstractMinVectorWidthAttr
Hold a pointer to a `clang::MinVectorWidthAttr` object.
"""
struct MinVectorWidthAttr <: AbstractMinVectorWidthAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MinVectorWidthAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MinVectorWidthAttr) = x

"""
    struct Mips16Attr <: AbstractMips16Attr
Hold a pointer to a `clang::Mips16Attr` object.
"""
struct Mips16Attr <: AbstractMips16Attr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::Mips16Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::Mips16Attr) = x

"""
    struct MipsInterruptAttr <: AbstractMipsInterruptAttr
Hold a pointer to a `clang::MipsInterruptAttr` object.
"""
struct MipsInterruptAttr <: AbstractMipsInterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MipsInterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MipsInterruptAttr) = x

"""
    struct MipsLongCallAttr <: AbstractMipsLongCallAttr
Hold a pointer to a `clang::MipsLongCallAttr` object.
"""
struct MipsLongCallAttr <: AbstractMipsLongCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MipsLongCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MipsLongCallAttr) = x

"""
    struct MipsShortCallAttr <: AbstractMipsShortCallAttr
Hold a pointer to a `clang::MipsShortCallAttr` object.
"""
struct MipsShortCallAttr <: AbstractMipsShortCallAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::MipsShortCallAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::MipsShortCallAttr) = x

"""
    struct NSConsumesSelfAttr <: AbstractNSConsumesSelfAttr
Hold a pointer to a `clang::NSConsumesSelfAttr` object.
"""
struct NSConsumesSelfAttr <: AbstractNSConsumesSelfAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NSConsumesSelfAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NSConsumesSelfAttr) = x

"""
    struct NSErrorDomainAttr <: AbstractNSErrorDomainAttr
Hold a pointer to a `clang::NSErrorDomainAttr` object.
"""
struct NSErrorDomainAttr <: AbstractNSErrorDomainAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NSErrorDomainAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NSErrorDomainAttr) = x

"""
    struct NSReturnsAutoreleasedAttr <: AbstractNSReturnsAutoreleasedAttr
Hold a pointer to a `clang::NSReturnsAutoreleasedAttr` object.
"""
struct NSReturnsAutoreleasedAttr <: AbstractNSReturnsAutoreleasedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NSReturnsAutoreleasedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NSReturnsAutoreleasedAttr) = x

"""
    struct NSReturnsNotRetainedAttr <: AbstractNSReturnsNotRetainedAttr
Hold a pointer to a `clang::NSReturnsNotRetainedAttr` object.
"""
struct NSReturnsNotRetainedAttr <: AbstractNSReturnsNotRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NSReturnsNotRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NSReturnsNotRetainedAttr) = x

"""
    struct NVPTXKernelAttr <: AbstractNVPTXKernelAttr
Hold a pointer to a `clang::NVPTXKernelAttr` object.
"""
struct NVPTXKernelAttr <: AbstractNVPTXKernelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NVPTXKernelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NVPTXKernelAttr) = x

"""
    struct NakedAttr <: AbstractNakedAttr
Hold a pointer to a `clang::NakedAttr` object.
"""
struct NakedAttr <: AbstractNakedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NakedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NakedAttr) = x

"""
    struct NoAliasAttr <: AbstractNoAliasAttr
Hold a pointer to a `clang::NoAliasAttr` object.
"""
struct NoAliasAttr <: AbstractNoAliasAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoAliasAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoAliasAttr) = x

"""
    struct NoCommonAttr <: AbstractNoCommonAttr
Hold a pointer to a `clang::NoCommonAttr` object.
"""
struct NoCommonAttr <: AbstractNoCommonAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoCommonAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoCommonAttr) = x

"""
    struct NoDebugAttr <: AbstractNoDebugAttr
Hold a pointer to a `clang::NoDebugAttr` object.
"""
struct NoDebugAttr <: AbstractNoDebugAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoDebugAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoDebugAttr) = x

"""
    struct NoDestroyAttr <: AbstractNoDestroyAttr
Hold a pointer to a `clang::NoDestroyAttr` object.
"""
struct NoDestroyAttr <: AbstractNoDestroyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoDestroyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoDestroyAttr) = x

"""
    struct NoDuplicateAttr <: AbstractNoDuplicateAttr
Hold a pointer to a `clang::NoDuplicateAttr` object.
"""
struct NoDuplicateAttr <: AbstractNoDuplicateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoDuplicateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoDuplicateAttr) = x

"""
    struct NoInstrumentFunctionAttr <: AbstractNoInstrumentFunctionAttr
Hold a pointer to a `clang::NoInstrumentFunctionAttr` object.
"""
struct NoInstrumentFunctionAttr <: AbstractNoInstrumentFunctionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoInstrumentFunctionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoInstrumentFunctionAttr) = x

"""
    struct NoMicroMipsAttr <: AbstractNoMicroMipsAttr
Hold a pointer to a `clang::NoMicroMipsAttr` object.
"""
struct NoMicroMipsAttr <: AbstractNoMicroMipsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoMicroMipsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoMicroMipsAttr) = x

"""
    struct NoMips16Attr <: AbstractNoMips16Attr
Hold a pointer to a `clang::NoMips16Attr` object.
"""
struct NoMips16Attr <: AbstractNoMips16Attr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoMips16Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoMips16Attr) = x

"""
    struct NoProfileFunctionAttr <: AbstractNoProfileFunctionAttr
Hold a pointer to a `clang::NoProfileFunctionAttr` object.
"""
struct NoProfileFunctionAttr <: AbstractNoProfileFunctionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoProfileFunctionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoProfileFunctionAttr) = x

"""
    struct NoRandomizeLayoutAttr <: AbstractNoRandomizeLayoutAttr
Hold a pointer to a `clang::NoRandomizeLayoutAttr` object.
"""
struct NoRandomizeLayoutAttr <: AbstractNoRandomizeLayoutAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoRandomizeLayoutAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoRandomizeLayoutAttr) = x

"""
    struct NoReturnAttr <: AbstractNoReturnAttr
Hold a pointer to a `clang::NoReturnAttr` object.
"""
struct NoReturnAttr <: AbstractNoReturnAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoReturnAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoReturnAttr) = x

"""
    struct NoSanitizeAttr <: AbstractNoSanitizeAttr
Hold a pointer to a `clang::NoSanitizeAttr` object.
"""
struct NoSanitizeAttr <: AbstractNoSanitizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoSanitizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoSanitizeAttr) = x

"""
    struct NoSpeculativeLoadHardeningAttr <: AbstractNoSpeculativeLoadHardeningAttr
Hold a pointer to a `clang::NoSpeculativeLoadHardeningAttr` object.
"""
struct NoSpeculativeLoadHardeningAttr <: AbstractNoSpeculativeLoadHardeningAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoSpeculativeLoadHardeningAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoSpeculativeLoadHardeningAttr) = x

"""
    struct NoSplitStackAttr <: AbstractNoSplitStackAttr
Hold a pointer to a `clang::NoSplitStackAttr` object.
"""
struct NoSplitStackAttr <: AbstractNoSplitStackAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoSplitStackAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoSplitStackAttr) = x

"""
    struct NoStackProtectorAttr <: AbstractNoStackProtectorAttr
Hold a pointer to a `clang::NoStackProtectorAttr` object.
"""
struct NoStackProtectorAttr <: AbstractNoStackProtectorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoStackProtectorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoStackProtectorAttr) = x

"""
    struct NoThreadSafetyAnalysisAttr <: AbstractNoThreadSafetyAnalysisAttr
Hold a pointer to a `clang::NoThreadSafetyAnalysisAttr` object.
"""
struct NoThreadSafetyAnalysisAttr <: AbstractNoThreadSafetyAnalysisAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoThreadSafetyAnalysisAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoThreadSafetyAnalysisAttr) = x

"""
    struct NoThrowAttr <: AbstractNoThrowAttr
Hold a pointer to a `clang::NoThrowAttr` object.
"""
struct NoThrowAttr <: AbstractNoThrowAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoThrowAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoThrowAttr) = x

"""
    struct NoUniqueAddressAttr <: AbstractNoUniqueAddressAttr
Hold a pointer to a `clang::NoUniqueAddressAttr` object.
"""
struct NoUniqueAddressAttr <: AbstractNoUniqueAddressAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoUniqueAddressAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoUniqueAddressAttr) = x

"""
    struct NoUwtableAttr <: AbstractNoUwtableAttr
Hold a pointer to a `clang::NoUwtableAttr` object.
"""
struct NoUwtableAttr <: AbstractNoUwtableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoUwtableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoUwtableAttr) = x

"""
    struct NotTailCalledAttr <: AbstractNotTailCalledAttr
Hold a pointer to a `clang::NotTailCalledAttr` object.
"""
struct NotTailCalledAttr <: AbstractNotTailCalledAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NotTailCalledAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NotTailCalledAttr) = x

"""
    struct OMPAllocateDeclAttr <: AbstractOMPAllocateDeclAttr
Hold a pointer to a `clang::OMPAllocateDeclAttr` object.
"""
struct OMPAllocateDeclAttr <: AbstractOMPAllocateDeclAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPAllocateDeclAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPAllocateDeclAttr) = x

"""
    struct OMPCaptureNoInitAttr <: AbstractOMPCaptureNoInitAttr
Hold a pointer to a `clang::OMPCaptureNoInitAttr` object.
"""
struct OMPCaptureNoInitAttr <: AbstractOMPCaptureNoInitAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPCaptureNoInitAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPCaptureNoInitAttr) = x

"""
    struct OMPDeclareTargetDeclAttr <: AbstractOMPDeclareTargetDeclAttr
Hold a pointer to a `clang::OMPDeclareTargetDeclAttr` object.
"""
struct OMPDeclareTargetDeclAttr <: AbstractOMPDeclareTargetDeclAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPDeclareTargetDeclAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPDeclareTargetDeclAttr) = x

"""
    struct OMPDeclareVariantAttr <: AbstractOMPDeclareVariantAttr
Hold a pointer to a `clang::OMPDeclareVariantAttr` object.
"""
struct OMPDeclareVariantAttr <: AbstractOMPDeclareVariantAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPDeclareVariantAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPDeclareVariantAttr) = x

"""
    struct OMPThreadPrivateDeclAttr <: AbstractOMPThreadPrivateDeclAttr
Hold a pointer to a `clang::OMPThreadPrivateDeclAttr` object.
"""
struct OMPThreadPrivateDeclAttr <: AbstractOMPThreadPrivateDeclAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPThreadPrivateDeclAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPThreadPrivateDeclAttr) = x

"""
    struct OSConsumesThisAttr <: AbstractOSConsumesThisAttr
Hold a pointer to a `clang::OSConsumesThisAttr` object.
"""
struct OSConsumesThisAttr <: AbstractOSConsumesThisAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OSConsumesThisAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OSConsumesThisAttr) = x

"""
    struct OSReturnsNotRetainedAttr <: AbstractOSReturnsNotRetainedAttr
Hold a pointer to a `clang::OSReturnsNotRetainedAttr` object.
"""
struct OSReturnsNotRetainedAttr <: AbstractOSReturnsNotRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OSReturnsNotRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OSReturnsNotRetainedAttr) = x

"""
    struct OSReturnsRetainedAttr <: AbstractOSReturnsRetainedAttr
Hold a pointer to a `clang::OSReturnsRetainedAttr` object.
"""
struct OSReturnsRetainedAttr <: AbstractOSReturnsRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OSReturnsRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OSReturnsRetainedAttr) = x

"""
    struct OSReturnsRetainedOnNonZeroAttr <: AbstractOSReturnsRetainedOnNonZeroAttr
Hold a pointer to a `clang::OSReturnsRetainedOnNonZeroAttr` object.
"""
struct OSReturnsRetainedOnNonZeroAttr <: AbstractOSReturnsRetainedOnNonZeroAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OSReturnsRetainedOnNonZeroAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OSReturnsRetainedOnNonZeroAttr) = x

"""
    struct OSReturnsRetainedOnZeroAttr <: AbstractOSReturnsRetainedOnZeroAttr
Hold a pointer to a `clang::OSReturnsRetainedOnZeroAttr` object.
"""
struct OSReturnsRetainedOnZeroAttr <: AbstractOSReturnsRetainedOnZeroAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OSReturnsRetainedOnZeroAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OSReturnsRetainedOnZeroAttr) = x

"""
    struct ObjCBridgeAttr <: AbstractObjCBridgeAttr
Hold a pointer to a `clang::ObjCBridgeAttr` object.
"""
struct ObjCBridgeAttr <: AbstractObjCBridgeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCBridgeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCBridgeAttr) = x

"""
    struct ObjCBridgeMutableAttr <: AbstractObjCBridgeMutableAttr
Hold a pointer to a `clang::ObjCBridgeMutableAttr` object.
"""
struct ObjCBridgeMutableAttr <: AbstractObjCBridgeMutableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCBridgeMutableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCBridgeMutableAttr) = x

"""
    struct ObjCBridgeRelatedAttr <: AbstractObjCBridgeRelatedAttr
Hold a pointer to a `clang::ObjCBridgeRelatedAttr` object.
"""
struct ObjCBridgeRelatedAttr <: AbstractObjCBridgeRelatedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCBridgeRelatedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCBridgeRelatedAttr) = x

"""
    struct ObjCExceptionAttr <: AbstractObjCExceptionAttr
Hold a pointer to a `clang::ObjCExceptionAttr` object.
"""
struct ObjCExceptionAttr <: AbstractObjCExceptionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCExceptionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCExceptionAttr) = x

"""
    struct ObjCExplicitProtocolImplAttr <: AbstractObjCExplicitProtocolImplAttr
Hold a pointer to a `clang::ObjCExplicitProtocolImplAttr` object.
"""
struct ObjCExplicitProtocolImplAttr <: AbstractObjCExplicitProtocolImplAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCExplicitProtocolImplAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCExplicitProtocolImplAttr) = x

"""
    struct ObjCExternallyRetainedAttr <: AbstractObjCExternallyRetainedAttr
Hold a pointer to a `clang::ObjCExternallyRetainedAttr` object.
"""
struct ObjCExternallyRetainedAttr <: AbstractObjCExternallyRetainedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCExternallyRetainedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCExternallyRetainedAttr) = x

"""
    struct ObjCIndependentClassAttr <: AbstractObjCIndependentClassAttr
Hold a pointer to a `clang::ObjCIndependentClassAttr` object.
"""
struct ObjCIndependentClassAttr <: AbstractObjCIndependentClassAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCIndependentClassAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCIndependentClassAttr) = x

"""
    struct ObjCMethodFamilyAttr <: AbstractObjCMethodFamilyAttr
Hold a pointer to a `clang::ObjCMethodFamilyAttr` object.
"""
struct ObjCMethodFamilyAttr <: AbstractObjCMethodFamilyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCMethodFamilyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCMethodFamilyAttr) = x

"""
    struct ObjCNSObjectAttr <: AbstractObjCNSObjectAttr
Hold a pointer to a `clang::ObjCNSObjectAttr` object.
"""
struct ObjCNSObjectAttr <: AbstractObjCNSObjectAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCNSObjectAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCNSObjectAttr) = x

"""
    struct ObjCPreciseLifetimeAttr <: AbstractObjCPreciseLifetimeAttr
Hold a pointer to a `clang::ObjCPreciseLifetimeAttr` object.
"""
struct ObjCPreciseLifetimeAttr <: AbstractObjCPreciseLifetimeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCPreciseLifetimeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCPreciseLifetimeAttr) = x

"""
    struct ObjCRequiresPropertyDefsAttr <: AbstractObjCRequiresPropertyDefsAttr
Hold a pointer to a `clang::ObjCRequiresPropertyDefsAttr` object.
"""
struct ObjCRequiresPropertyDefsAttr <: AbstractObjCRequiresPropertyDefsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCRequiresPropertyDefsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCRequiresPropertyDefsAttr) = x

"""
    struct ObjCRequiresSuperAttr <: AbstractObjCRequiresSuperAttr
Hold a pointer to a `clang::ObjCRequiresSuperAttr` object.
"""
struct ObjCRequiresSuperAttr <: AbstractObjCRequiresSuperAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCRequiresSuperAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCRequiresSuperAttr) = x

"""
    struct ObjCReturnsInnerPointerAttr <: AbstractObjCReturnsInnerPointerAttr
Hold a pointer to a `clang::ObjCReturnsInnerPointerAttr` object.
"""
struct ObjCReturnsInnerPointerAttr <: AbstractObjCReturnsInnerPointerAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCReturnsInnerPointerAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCReturnsInnerPointerAttr) = x

"""
    struct ObjCRootClassAttr <: AbstractObjCRootClassAttr
Hold a pointer to a `clang::ObjCRootClassAttr` object.
"""
struct ObjCRootClassAttr <: AbstractObjCRootClassAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCRootClassAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCRootClassAttr) = x

"""
    struct ObjCSubclassingRestrictedAttr <: AbstractObjCSubclassingRestrictedAttr
Hold a pointer to a `clang::ObjCSubclassingRestrictedAttr` object.
"""
struct ObjCSubclassingRestrictedAttr <: AbstractObjCSubclassingRestrictedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCSubclassingRestrictedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCSubclassingRestrictedAttr) = x

"""
    struct OpenCLIntelReqdSubGroupSizeAttr <: AbstractOpenCLIntelReqdSubGroupSizeAttr
Hold a pointer to a `clang::OpenCLIntelReqdSubGroupSizeAttr` object.
"""
struct OpenCLIntelReqdSubGroupSizeAttr <: AbstractOpenCLIntelReqdSubGroupSizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLIntelReqdSubGroupSizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLIntelReqdSubGroupSizeAttr) = x

"""
    struct OpenCLKernelAttr <: AbstractOpenCLKernelAttr
Hold a pointer to a `clang::OpenCLKernelAttr` object.
"""
struct OpenCLKernelAttr <: AbstractOpenCLKernelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLKernelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLKernelAttr) = x

"""
    struct OptimizeNoneAttr <: AbstractOptimizeNoneAttr
Hold a pointer to a `clang::OptimizeNoneAttr` object.
"""
struct OptimizeNoneAttr <: AbstractOptimizeNoneAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OptimizeNoneAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OptimizeNoneAttr) = x

"""
    struct OverrideAttr <: AbstractOverrideAttr
Hold a pointer to a `clang::OverrideAttr` object.
"""
struct OverrideAttr <: AbstractOverrideAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OverrideAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OverrideAttr) = x

"""
    struct OwnerAttr <: AbstractOwnerAttr
Hold a pointer to a `clang::OwnerAttr` object.
"""
struct OwnerAttr <: AbstractOwnerAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OwnerAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OwnerAttr) = x

"""
    struct OwnershipAttr <: AbstractOwnershipAttr
Hold a pointer to a `clang::OwnershipAttr` object.
"""
struct OwnershipAttr <: AbstractOwnershipAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OwnershipAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OwnershipAttr) = x

"""
    struct PackedAttr <: AbstractPackedAttr
Hold a pointer to a `clang::PackedAttr` object.
"""
struct PackedAttr <: AbstractPackedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PackedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PackedAttr) = x

"""
    struct ParamTypestateAttr <: AbstractParamTypestateAttr
Hold a pointer to a `clang::ParamTypestateAttr` object.
"""
struct ParamTypestateAttr <: AbstractParamTypestateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ParamTypestateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ParamTypestateAttr) = x

"""
    struct PatchableFunctionEntryAttr <: AbstractPatchableFunctionEntryAttr
Hold a pointer to a `clang::PatchableFunctionEntryAttr` object.
"""
struct PatchableFunctionEntryAttr <: AbstractPatchableFunctionEntryAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PatchableFunctionEntryAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PatchableFunctionEntryAttr) = x

"""
    struct PointerAttr <: AbstractPointerAttr
Hold a pointer to a `clang::PointerAttr` object.
"""
struct PointerAttr <: AbstractPointerAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PointerAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PointerAttr) = x

"""
    struct PragmaClangBSSSectionAttr <: AbstractPragmaClangBSSSectionAttr
Hold a pointer to a `clang::PragmaClangBSSSectionAttr` object.
"""
struct PragmaClangBSSSectionAttr <: AbstractPragmaClangBSSSectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PragmaClangBSSSectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PragmaClangBSSSectionAttr) = x

"""
    struct PragmaClangDataSectionAttr <: AbstractPragmaClangDataSectionAttr
Hold a pointer to a `clang::PragmaClangDataSectionAttr` object.
"""
struct PragmaClangDataSectionAttr <: AbstractPragmaClangDataSectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PragmaClangDataSectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PragmaClangDataSectionAttr) = x

"""
    struct PragmaClangRelroSectionAttr <: AbstractPragmaClangRelroSectionAttr
Hold a pointer to a `clang::PragmaClangRelroSectionAttr` object.
"""
struct PragmaClangRelroSectionAttr <: AbstractPragmaClangRelroSectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PragmaClangRelroSectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PragmaClangRelroSectionAttr) = x

"""
    struct PragmaClangRodataSectionAttr <: AbstractPragmaClangRodataSectionAttr
Hold a pointer to a `clang::PragmaClangRodataSectionAttr` object.
"""
struct PragmaClangRodataSectionAttr <: AbstractPragmaClangRodataSectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PragmaClangRodataSectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PragmaClangRodataSectionAttr) = x

"""
    struct PragmaClangTextSectionAttr <: AbstractPragmaClangTextSectionAttr
Hold a pointer to a `clang::PragmaClangTextSectionAttr` object.
"""
struct PragmaClangTextSectionAttr <: AbstractPragmaClangTextSectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PragmaClangTextSectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PragmaClangTextSectionAttr) = x

"""
    struct PreferredNameAttr <: AbstractPreferredNameAttr
Hold a pointer to a `clang::PreferredNameAttr` object.
"""
struct PreferredNameAttr <: AbstractPreferredNameAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PreferredNameAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PreferredNameAttr) = x

"""
    struct PreferredTypeAttr <: AbstractPreferredTypeAttr
Hold a pointer to a `clang::PreferredTypeAttr` object.
"""
struct PreferredTypeAttr <: AbstractPreferredTypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PreferredTypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PreferredTypeAttr) = x

"""
    struct PtGuardedByAttr <: AbstractPtGuardedByAttr
Hold a pointer to a `clang::PtGuardedByAttr` object.
"""
struct PtGuardedByAttr <: AbstractPtGuardedByAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PtGuardedByAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PtGuardedByAttr) = x

"""
    struct PtGuardedVarAttr <: AbstractPtGuardedVarAttr
Hold a pointer to a `clang::PtGuardedVarAttr` object.
"""
struct PtGuardedVarAttr <: AbstractPtGuardedVarAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PtGuardedVarAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PtGuardedVarAttr) = x

"""
    struct PureAttr <: AbstractPureAttr
Hold a pointer to a `clang::PureAttr` object.
"""
struct PureAttr <: AbstractPureAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::PureAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::PureAttr) = x

"""
    struct RISCVInterruptAttr <: AbstractRISCVInterruptAttr
Hold a pointer to a `clang::RISCVInterruptAttr` object.
"""
struct RISCVInterruptAttr <: AbstractRISCVInterruptAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RISCVInterruptAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RISCVInterruptAttr) = x

"""
    struct RandomizeLayoutAttr <: AbstractRandomizeLayoutAttr
Hold a pointer to a `clang::RandomizeLayoutAttr` object.
"""
struct RandomizeLayoutAttr <: AbstractRandomizeLayoutAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RandomizeLayoutAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RandomizeLayoutAttr) = x

"""
    struct ReadOnlyPlacementAttr <: AbstractReadOnlyPlacementAttr
Hold a pointer to a `clang::ReadOnlyPlacementAttr` object.
"""
struct ReadOnlyPlacementAttr <: AbstractReadOnlyPlacementAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReadOnlyPlacementAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReadOnlyPlacementAttr) = x

"""
    struct ReinitializesAttr <: AbstractReinitializesAttr
Hold a pointer to a `clang::ReinitializesAttr` object.
"""
struct ReinitializesAttr <: AbstractReinitializesAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReinitializesAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReinitializesAttr) = x

"""
    struct ReleaseCapabilityAttr <: AbstractReleaseCapabilityAttr
Hold a pointer to a `clang::ReleaseCapabilityAttr` object.
"""
struct ReleaseCapabilityAttr <: AbstractReleaseCapabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReleaseCapabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReleaseCapabilityAttr) = x

"""
    struct ReqdWorkGroupSizeAttr <: AbstractReqdWorkGroupSizeAttr
Hold a pointer to a `clang::ReqdWorkGroupSizeAttr` object.
"""
struct ReqdWorkGroupSizeAttr <: AbstractReqdWorkGroupSizeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReqdWorkGroupSizeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReqdWorkGroupSizeAttr) = x

"""
    struct RequiresCapabilityAttr <: AbstractRequiresCapabilityAttr
Hold a pointer to a `clang::RequiresCapabilityAttr` object.
"""
struct RequiresCapabilityAttr <: AbstractRequiresCapabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RequiresCapabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RequiresCapabilityAttr) = x

"""
    struct RestrictAttr <: AbstractRestrictAttr
Hold a pointer to a `clang::RestrictAttr` object.
"""
struct RestrictAttr <: AbstractRestrictAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RestrictAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RestrictAttr) = x

"""
    struct RetainAttr <: AbstractRetainAttr
Hold a pointer to a `clang::RetainAttr` object.
"""
struct RetainAttr <: AbstractRetainAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RetainAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RetainAttr) = x

"""
    struct ReturnTypestateAttr <: AbstractReturnTypestateAttr
Hold a pointer to a `clang::ReturnTypestateAttr` object.
"""
struct ReturnTypestateAttr <: AbstractReturnTypestateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReturnTypestateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReturnTypestateAttr) = x

"""
    struct ReturnsNonNullAttr <: AbstractReturnsNonNullAttr
Hold a pointer to a `clang::ReturnsNonNullAttr` object.
"""
struct ReturnsNonNullAttr <: AbstractReturnsNonNullAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReturnsNonNullAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReturnsNonNullAttr) = x

"""
    struct ReturnsTwiceAttr <: AbstractReturnsTwiceAttr
Hold a pointer to a `clang::ReturnsTwiceAttr` object.
"""
struct ReturnsTwiceAttr <: AbstractReturnsTwiceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ReturnsTwiceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ReturnsTwiceAttr) = x

"""
    struct SYCLKernelAttr <: AbstractSYCLKernelAttr
Hold a pointer to a `clang::SYCLKernelAttr` object.
"""
struct SYCLKernelAttr <: AbstractSYCLKernelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SYCLKernelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SYCLKernelAttr) = x

"""
    struct SYCLSpecialClassAttr <: AbstractSYCLSpecialClassAttr
Hold a pointer to a `clang::SYCLSpecialClassAttr` object.
"""
struct SYCLSpecialClassAttr <: AbstractSYCLSpecialClassAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SYCLSpecialClassAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SYCLSpecialClassAttr) = x

"""
    struct ScopedLockableAttr <: AbstractScopedLockableAttr
Hold a pointer to a `clang::ScopedLockableAttr` object.
"""
struct ScopedLockableAttr <: AbstractScopedLockableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ScopedLockableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ScopedLockableAttr) = x

"""
    struct SectionAttr <: AbstractSectionAttr
Hold a pointer to a `clang::SectionAttr` object.
"""
struct SectionAttr <: AbstractSectionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SectionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SectionAttr) = x

"""
    struct SelectAnyAttr <: AbstractSelectAnyAttr
Hold a pointer to a `clang::SelectAnyAttr` object.
"""
struct SelectAnyAttr <: AbstractSelectAnyAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SelectAnyAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SelectAnyAttr) = x

"""
    struct SentinelAttr <: AbstractSentinelAttr
Hold a pointer to a `clang::SentinelAttr` object.
"""
struct SentinelAttr <: AbstractSentinelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SentinelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SentinelAttr) = x

"""
    struct SetTypestateAttr <: AbstractSetTypestateAttr
Hold a pointer to a `clang::SetTypestateAttr` object.
"""
struct SetTypestateAttr <: AbstractSetTypestateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SetTypestateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SetTypestateAttr) = x

"""
    struct SharedTrylockFunctionAttr <: AbstractSharedTrylockFunctionAttr
Hold a pointer to a `clang::SharedTrylockFunctionAttr` object.
"""
struct SharedTrylockFunctionAttr <: AbstractSharedTrylockFunctionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SharedTrylockFunctionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SharedTrylockFunctionAttr) = x

"""
    struct SpeculativeLoadHardeningAttr <: AbstractSpeculativeLoadHardeningAttr
Hold a pointer to a `clang::SpeculativeLoadHardeningAttr` object.
"""
struct SpeculativeLoadHardeningAttr <: AbstractSpeculativeLoadHardeningAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SpeculativeLoadHardeningAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SpeculativeLoadHardeningAttr) = x

"""
    struct StandaloneDebugAttr <: AbstractStandaloneDebugAttr
Hold a pointer to a `clang::StandaloneDebugAttr` object.
"""
struct StandaloneDebugAttr <: AbstractStandaloneDebugAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::StandaloneDebugAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::StandaloneDebugAttr) = x

"""
    struct StrictFPAttr <: AbstractStrictFPAttr
Hold a pointer to a `clang::StrictFPAttr` object.
"""
struct StrictFPAttr <: AbstractStrictFPAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::StrictFPAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::StrictFPAttr) = x

"""
    struct StrictGuardStackCheckAttr <: AbstractStrictGuardStackCheckAttr
Hold a pointer to a `clang::StrictGuardStackCheckAttr` object.
"""
struct StrictGuardStackCheckAttr <: AbstractStrictGuardStackCheckAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::StrictGuardStackCheckAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::StrictGuardStackCheckAttr) = x

"""
    struct SwiftAsyncAttr <: AbstractSwiftAsyncAttr
Hold a pointer to a `clang::SwiftAsyncAttr` object.
"""
struct SwiftAsyncAttr <: AbstractSwiftAsyncAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftAsyncAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftAsyncAttr) = x

"""
    struct SwiftAsyncErrorAttr <: AbstractSwiftAsyncErrorAttr
Hold a pointer to a `clang::SwiftAsyncErrorAttr` object.
"""
struct SwiftAsyncErrorAttr <: AbstractSwiftAsyncErrorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftAsyncErrorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftAsyncErrorAttr) = x

"""
    struct SwiftAsyncNameAttr <: AbstractSwiftAsyncNameAttr
Hold a pointer to a `clang::SwiftAsyncNameAttr` object.
"""
struct SwiftAsyncNameAttr <: AbstractSwiftAsyncNameAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftAsyncNameAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftAsyncNameAttr) = x

"""
    struct SwiftAttrAttr <: AbstractSwiftAttrAttr
Hold a pointer to a `clang::SwiftAttrAttr` object.
"""
struct SwiftAttrAttr <: AbstractSwiftAttrAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftAttrAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftAttrAttr) = x

"""
    struct SwiftBridgeAttr <: AbstractSwiftBridgeAttr
Hold a pointer to a `clang::SwiftBridgeAttr` object.
"""
struct SwiftBridgeAttr <: AbstractSwiftBridgeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftBridgeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftBridgeAttr) = x

"""
    struct SwiftBridgedTypedefAttr <: AbstractSwiftBridgedTypedefAttr
Hold a pointer to a `clang::SwiftBridgedTypedefAttr` object.
"""
struct SwiftBridgedTypedefAttr <: AbstractSwiftBridgedTypedefAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftBridgedTypedefAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftBridgedTypedefAttr) = x

"""
    struct SwiftErrorAttr <: AbstractSwiftErrorAttr
Hold a pointer to a `clang::SwiftErrorAttr` object.
"""
struct SwiftErrorAttr <: AbstractSwiftErrorAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftErrorAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftErrorAttr) = x

"""
    struct SwiftImportAsNonGenericAttr <: AbstractSwiftImportAsNonGenericAttr
Hold a pointer to a `clang::SwiftImportAsNonGenericAttr` object.
"""
struct SwiftImportAsNonGenericAttr <: AbstractSwiftImportAsNonGenericAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftImportAsNonGenericAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftImportAsNonGenericAttr) = x

"""
    struct SwiftImportPropertyAsAccessorsAttr <: AbstractSwiftImportPropertyAsAccessorsAttr
Hold a pointer to a `clang::SwiftImportPropertyAsAccessorsAttr` object.
"""
struct SwiftImportPropertyAsAccessorsAttr <: AbstractSwiftImportPropertyAsAccessorsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftImportPropertyAsAccessorsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftImportPropertyAsAccessorsAttr) = x

"""
    struct SwiftNameAttr <: AbstractSwiftNameAttr
Hold a pointer to a `clang::SwiftNameAttr` object.
"""
struct SwiftNameAttr <: AbstractSwiftNameAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftNameAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftNameAttr) = x

"""
    struct SwiftNewTypeAttr <: AbstractSwiftNewTypeAttr
Hold a pointer to a `clang::SwiftNewTypeAttr` object.
"""
struct SwiftNewTypeAttr <: AbstractSwiftNewTypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftNewTypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftNewTypeAttr) = x

"""
    struct SwiftPrivateAttr <: AbstractSwiftPrivateAttr
Hold a pointer to a `clang::SwiftPrivateAttr` object.
"""
struct SwiftPrivateAttr <: AbstractSwiftPrivateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftPrivateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftPrivateAttr) = x

"""
    struct TLSModelAttr <: AbstractTLSModelAttr
Hold a pointer to a `clang::TLSModelAttr` object.
"""
struct TLSModelAttr <: AbstractTLSModelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TLSModelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TLSModelAttr) = x

"""
    struct TargetAttr <: AbstractTargetAttr
Hold a pointer to a `clang::TargetAttr` object.
"""
struct TargetAttr <: AbstractTargetAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TargetAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TargetAttr) = x

"""
    struct TargetClonesAttr <: AbstractTargetClonesAttr
Hold a pointer to a `clang::TargetClonesAttr` object.
"""
struct TargetClonesAttr <: AbstractTargetClonesAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TargetClonesAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TargetClonesAttr) = x

"""
    struct TargetVersionAttr <: AbstractTargetVersionAttr
Hold a pointer to a `clang::TargetVersionAttr` object.
"""
struct TargetVersionAttr <: AbstractTargetVersionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TargetVersionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TargetVersionAttr) = x

"""
    struct TestTypestateAttr <: AbstractTestTypestateAttr
Hold a pointer to a `clang::TestTypestateAttr` object.
"""
struct TestTypestateAttr <: AbstractTestTypestateAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TestTypestateAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TestTypestateAttr) = x

"""
    struct TransparentUnionAttr <: AbstractTransparentUnionAttr
Hold a pointer to a `clang::TransparentUnionAttr` object.
"""
struct TransparentUnionAttr <: AbstractTransparentUnionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TransparentUnionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TransparentUnionAttr) = x

"""
    struct TrivialABIAttr <: AbstractTrivialABIAttr
Hold a pointer to a `clang::TrivialABIAttr` object.
"""
struct TrivialABIAttr <: AbstractTrivialABIAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TrivialABIAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TrivialABIAttr) = x

"""
    struct TryAcquireCapabilityAttr <: AbstractTryAcquireCapabilityAttr
Hold a pointer to a `clang::TryAcquireCapabilityAttr` object.
"""
struct TryAcquireCapabilityAttr <: AbstractTryAcquireCapabilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TryAcquireCapabilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TryAcquireCapabilityAttr) = x

"""
    struct TypeTagForDatatypeAttr <: AbstractTypeTagForDatatypeAttr
Hold a pointer to a `clang::TypeTagForDatatypeAttr` object.
"""
struct TypeTagForDatatypeAttr <: AbstractTypeTagForDatatypeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TypeTagForDatatypeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TypeTagForDatatypeAttr) = x

"""
    struct TypeVisibilityAttr <: AbstractTypeVisibilityAttr
Hold a pointer to a `clang::TypeVisibilityAttr` object.
"""
struct TypeVisibilityAttr <: AbstractTypeVisibilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::TypeVisibilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::TypeVisibilityAttr) = x

"""
    struct UnavailableAttr <: AbstractUnavailableAttr
Hold a pointer to a `clang::UnavailableAttr` object.
"""
struct UnavailableAttr <: AbstractUnavailableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UnavailableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UnavailableAttr) = x

"""
    struct UninitializedAttr <: AbstractUninitializedAttr
Hold a pointer to a `clang::UninitializedAttr` object.
"""
struct UninitializedAttr <: AbstractUninitializedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UninitializedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UninitializedAttr) = x

"""
    struct UnsafeBufferUsageAttr <: AbstractUnsafeBufferUsageAttr
Hold a pointer to a `clang::UnsafeBufferUsageAttr` object.
"""
struct UnsafeBufferUsageAttr <: AbstractUnsafeBufferUsageAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UnsafeBufferUsageAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UnsafeBufferUsageAttr) = x

"""
    struct UnusedAttr <: AbstractUnusedAttr
Hold a pointer to a `clang::UnusedAttr` object.
"""
struct UnusedAttr <: AbstractUnusedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UnusedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UnusedAttr) = x

"""
    struct UsedAttr <: AbstractUsedAttr
Hold a pointer to a `clang::UsedAttr` object.
"""
struct UsedAttr <: AbstractUsedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UsedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UsedAttr) = x

"""
    struct UsingIfExistsAttr <: AbstractUsingIfExistsAttr
Hold a pointer to a `clang::UsingIfExistsAttr` object.
"""
struct UsingIfExistsAttr <: AbstractUsingIfExistsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UsingIfExistsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UsingIfExistsAttr) = x

"""
    struct UuidAttr <: AbstractUuidAttr
Hold a pointer to a `clang::UuidAttr` object.
"""
struct UuidAttr <: AbstractUuidAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::UuidAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::UuidAttr) = x

"""
    struct VecReturnAttr <: AbstractVecReturnAttr
Hold a pointer to a `clang::VecReturnAttr` object.
"""
struct VecReturnAttr <: AbstractVecReturnAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::VecReturnAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::VecReturnAttr) = x

"""
    struct VecTypeHintAttr <: AbstractVecTypeHintAttr
Hold a pointer to a `clang::VecTypeHintAttr` object.
"""
struct VecTypeHintAttr <: AbstractVecTypeHintAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::VecTypeHintAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::VecTypeHintAttr) = x

"""
    struct VisibilityAttr <: AbstractVisibilityAttr
Hold a pointer to a `clang::VisibilityAttr` object.
"""
struct VisibilityAttr <: AbstractVisibilityAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::VisibilityAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::VisibilityAttr) = x

"""
    struct WarnUnusedAttr <: AbstractWarnUnusedAttr
Hold a pointer to a `clang::WarnUnusedAttr` object.
"""
struct WarnUnusedAttr <: AbstractWarnUnusedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WarnUnusedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WarnUnusedAttr) = x

"""
    struct WarnUnusedResultAttr <: AbstractWarnUnusedResultAttr
Hold a pointer to a `clang::WarnUnusedResultAttr` object.
"""
struct WarnUnusedResultAttr <: AbstractWarnUnusedResultAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WarnUnusedResultAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WarnUnusedResultAttr) = x

"""
    struct WeakAttr <: AbstractWeakAttr
Hold a pointer to a `clang::WeakAttr` object.
"""
struct WeakAttr <: AbstractWeakAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WeakAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WeakAttr) = x

"""
    struct WeakImportAttr <: AbstractWeakImportAttr
Hold a pointer to a `clang::WeakImportAttr` object.
"""
struct WeakImportAttr <: AbstractWeakImportAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WeakImportAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WeakImportAttr) = x

"""
    struct WeakRefAttr <: AbstractWeakRefAttr
Hold a pointer to a `clang::WeakRefAttr` object.
"""
struct WeakRefAttr <: AbstractWeakRefAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WeakRefAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WeakRefAttr) = x

"""
    struct WebAssemblyExportNameAttr <: AbstractWebAssemblyExportNameAttr
Hold a pointer to a `clang::WebAssemblyExportNameAttr` object.
"""
struct WebAssemblyExportNameAttr <: AbstractWebAssemblyExportNameAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WebAssemblyExportNameAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WebAssemblyExportNameAttr) = x

"""
    struct WebAssemblyImportModuleAttr <: AbstractWebAssemblyImportModuleAttr
Hold a pointer to a `clang::WebAssemblyImportModuleAttr` object.
"""
struct WebAssemblyImportModuleAttr <: AbstractWebAssemblyImportModuleAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WebAssemblyImportModuleAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WebAssemblyImportModuleAttr) = x

"""
    struct WebAssemblyImportNameAttr <: AbstractWebAssemblyImportNameAttr
Hold a pointer to a `clang::WebAssemblyImportNameAttr` object.
"""
struct WebAssemblyImportNameAttr <: AbstractWebAssemblyImportNameAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WebAssemblyImportNameAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WebAssemblyImportNameAttr) = x

"""
    struct WorkGroupSizeHintAttr <: AbstractWorkGroupSizeHintAttr
Hold a pointer to a `clang::WorkGroupSizeHintAttr` object.
"""
struct WorkGroupSizeHintAttr <: AbstractWorkGroupSizeHintAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::WorkGroupSizeHintAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::WorkGroupSizeHintAttr) = x

"""
    struct X86ForceAlignArgPointerAttr <: AbstractX86ForceAlignArgPointerAttr
Hold a pointer to a `clang::X86ForceAlignArgPointerAttr` object.
"""
struct X86ForceAlignArgPointerAttr <: AbstractX86ForceAlignArgPointerAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::X86ForceAlignArgPointerAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::X86ForceAlignArgPointerAttr) = x

"""
    struct XRayInstrumentAttr <: AbstractXRayInstrumentAttr
Hold a pointer to a `clang::XRayInstrumentAttr` object.
"""
struct XRayInstrumentAttr <: AbstractXRayInstrumentAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::XRayInstrumentAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::XRayInstrumentAttr) = x

"""
    struct XRayLogArgsAttr <: AbstractXRayLogArgsAttr
Hold a pointer to a `clang::XRayLogArgsAttr` object.
"""
struct XRayLogArgsAttr <: AbstractXRayLogArgsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::XRayLogArgsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::XRayLogArgsAttr) = x

"""
    struct ZeroCallUsedRegsAttr <: AbstractZeroCallUsedRegsAttr
Hold a pointer to a `clang::ZeroCallUsedRegsAttr` object.
"""
struct ZeroCallUsedRegsAttr <: AbstractZeroCallUsedRegsAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ZeroCallUsedRegsAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ZeroCallUsedRegsAttr) = x

"""
    struct AbiTagAttr <: AbstractAbiTagAttr
Hold a pointer to a `clang::AbiTagAttr` object.
"""
struct AbiTagAttr <: AbstractAbiTagAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AbiTagAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AbiTagAttr) = x

"""
    struct AliasAttr <: AbstractAliasAttr
Hold a pointer to a `clang::AliasAttr` object.
"""
struct AliasAttr <: AbstractAliasAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AliasAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AliasAttr) = x

"""
    struct AlignValueAttr <: AbstractAlignValueAttr
Hold a pointer to a `clang::AlignValueAttr` object.
"""
struct AlignValueAttr <: AbstractAlignValueAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::AlignValueAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::AlignValueAttr) = x

"""
    struct BuiltinAliasAttr <: AbstractBuiltinAliasAttr
Hold a pointer to a `clang::BuiltinAliasAttr` object.
"""
struct BuiltinAliasAttr <: AbstractBuiltinAliasAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::BuiltinAliasAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::BuiltinAliasAttr) = x

"""
    struct CalledOnceAttr <: AbstractCalledOnceAttr
Hold a pointer to a `clang::CalledOnceAttr` object.
"""
struct CalledOnceAttr <: AbstractCalledOnceAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::CalledOnceAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::CalledOnceAttr) = x

"""
    struct IFuncAttr <: AbstractIFuncAttr
Hold a pointer to a `clang::IFuncAttr` object.
"""
struct IFuncAttr <: AbstractIFuncAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::IFuncAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::IFuncAttr) = x

"""
    struct InitSegAttr <: AbstractInitSegAttr
Hold a pointer to a `clang::InitSegAttr` object.
"""
struct InitSegAttr <: AbstractInitSegAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::InitSegAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::InitSegAttr) = x

"""
    struct LoaderUninitializedAttr <: AbstractLoaderUninitializedAttr
Hold a pointer to a `clang::LoaderUninitializedAttr` object.
"""
struct LoaderUninitializedAttr <: AbstractLoaderUninitializedAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LoaderUninitializedAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LoaderUninitializedAttr) = x

"""
    struct LoopHintAttr <: AbstractLoopHintAttr
Hold a pointer to a `clang::LoopHintAttr` object.
"""
struct LoopHintAttr <: AbstractLoopHintAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::LoopHintAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::LoopHintAttr) = x

"""
    struct ModeAttr <: AbstractModeAttr
Hold a pointer to a `clang::ModeAttr` object.
"""
struct ModeAttr <: AbstractModeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ModeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ModeAttr) = x

"""
    struct NoBuiltinAttr <: AbstractNoBuiltinAttr
Hold a pointer to a `clang::NoBuiltinAttr` object.
"""
struct NoBuiltinAttr <: AbstractNoBuiltinAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoBuiltinAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoBuiltinAttr) = x

"""
    struct NoEscapeAttr <: AbstractNoEscapeAttr
Hold a pointer to a `clang::NoEscapeAttr` object.
"""
struct NoEscapeAttr <: AbstractNoEscapeAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::NoEscapeAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::NoEscapeAttr) = x

"""
    struct OMPCaptureKindAttr <: AbstractOMPCaptureKindAttr
Hold a pointer to a `clang::OMPCaptureKindAttr` object.
"""
struct OMPCaptureKindAttr <: AbstractOMPCaptureKindAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPCaptureKindAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPCaptureKindAttr) = x

"""
    struct OMPDeclareSimdDeclAttr <: AbstractOMPDeclareSimdDeclAttr
Hold a pointer to a `clang::OMPDeclareSimdDeclAttr` object.
"""
struct OMPDeclareSimdDeclAttr <: AbstractOMPDeclareSimdDeclAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPDeclareSimdDeclAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPDeclareSimdDeclAttr) = x

"""
    struct OMPReferencedVarAttr <: AbstractOMPReferencedVarAttr
Hold a pointer to a `clang::OMPReferencedVarAttr` object.
"""
struct OMPReferencedVarAttr <: AbstractOMPReferencedVarAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OMPReferencedVarAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OMPReferencedVarAttr) = x

"""
    struct ObjCBoxableAttr <: AbstractObjCBoxableAttr
Hold a pointer to a `clang::ObjCBoxableAttr` object.
"""
struct ObjCBoxableAttr <: AbstractObjCBoxableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCBoxableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCBoxableAttr) = x

"""
    struct ObjCClassStubAttr <: AbstractObjCClassStubAttr
Hold a pointer to a `clang::ObjCClassStubAttr` object.
"""
struct ObjCClassStubAttr <: AbstractObjCClassStubAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCClassStubAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCClassStubAttr) = x

"""
    struct ObjCDesignatedInitializerAttr <: AbstractObjCDesignatedInitializerAttr
Hold a pointer to a `clang::ObjCDesignatedInitializerAttr` object.
"""
struct ObjCDesignatedInitializerAttr <: AbstractObjCDesignatedInitializerAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCDesignatedInitializerAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCDesignatedInitializerAttr) = x

"""
    struct ObjCDirectAttr <: AbstractObjCDirectAttr
Hold a pointer to a `clang::ObjCDirectAttr` object.
"""
struct ObjCDirectAttr <: AbstractObjCDirectAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCDirectAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCDirectAttr) = x

"""
    struct ObjCDirectMembersAttr <: AbstractObjCDirectMembersAttr
Hold a pointer to a `clang::ObjCDirectMembersAttr` object.
"""
struct ObjCDirectMembersAttr <: AbstractObjCDirectMembersAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCDirectMembersAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCDirectMembersAttr) = x

"""
    struct ObjCNonLazyClassAttr <: AbstractObjCNonLazyClassAttr
Hold a pointer to a `clang::ObjCNonLazyClassAttr` object.
"""
struct ObjCNonLazyClassAttr <: AbstractObjCNonLazyClassAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCNonLazyClassAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCNonLazyClassAttr) = x

"""
    struct ObjCNonRuntimeProtocolAttr <: AbstractObjCNonRuntimeProtocolAttr
Hold a pointer to a `clang::ObjCNonRuntimeProtocolAttr` object.
"""
struct ObjCNonRuntimeProtocolAttr <: AbstractObjCNonRuntimeProtocolAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCNonRuntimeProtocolAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCNonRuntimeProtocolAttr) = x

"""
    struct ObjCRuntimeNameAttr <: AbstractObjCRuntimeNameAttr
Hold a pointer to a `clang::ObjCRuntimeNameAttr` object.
"""
struct ObjCRuntimeNameAttr <: AbstractObjCRuntimeNameAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCRuntimeNameAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCRuntimeNameAttr) = x

"""
    struct ObjCRuntimeVisibleAttr <: AbstractObjCRuntimeVisibleAttr
Hold a pointer to a `clang::ObjCRuntimeVisibleAttr` object.
"""
struct ObjCRuntimeVisibleAttr <: AbstractObjCRuntimeVisibleAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ObjCRuntimeVisibleAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ObjCRuntimeVisibleAttr) = x

"""
    struct OpenCLAccessAttr <: AbstractOpenCLAccessAttr
Hold a pointer to a `clang::OpenCLAccessAttr` object.
"""
struct OpenCLAccessAttr <: AbstractOpenCLAccessAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OpenCLAccessAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OpenCLAccessAttr) = x

"""
    struct OverloadableAttr <: AbstractOverloadableAttr
Hold a pointer to a `clang::OverloadableAttr` object.
"""
struct OverloadableAttr <: AbstractOverloadableAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::OverloadableAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::OverloadableAttr) = x

"""
    struct RenderScriptKernelAttr <: AbstractRenderScriptKernelAttr
Hold a pointer to a `clang::RenderScriptKernelAttr` object.
"""
struct RenderScriptKernelAttr <: AbstractRenderScriptKernelAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::RenderScriptKernelAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::RenderScriptKernelAttr) = x

"""
    struct SwiftObjCMembersAttr <: AbstractSwiftObjCMembersAttr
Hold a pointer to a `clang::SwiftObjCMembersAttr` object.
"""
struct SwiftObjCMembersAttr <: AbstractSwiftObjCMembersAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftObjCMembersAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftObjCMembersAttr) = x

"""
    struct SwiftVersionedAdditionAttr <: AbstractSwiftVersionedAdditionAttr
Hold a pointer to a `clang::SwiftVersionedAdditionAttr` object.
"""
struct SwiftVersionedAdditionAttr <: AbstractSwiftVersionedAdditionAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftVersionedAdditionAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftVersionedAdditionAttr) = x

"""
    struct SwiftVersionedRemovalAttr <: AbstractSwiftVersionedRemovalAttr
Hold a pointer to a `clang::SwiftVersionedRemovalAttr` object.
"""
struct SwiftVersionedRemovalAttr <: AbstractSwiftVersionedRemovalAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::SwiftVersionedRemovalAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::SwiftVersionedRemovalAttr) = x

"""
    struct ThreadAttr <: AbstractThreadAttr
Hold a pointer to a `clang::ThreadAttr` object.
"""
struct ThreadAttr <: AbstractThreadAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::ThreadAttr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::ThreadAttr) = x

