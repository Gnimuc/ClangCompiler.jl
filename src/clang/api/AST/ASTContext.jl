function PrintStats(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_PrintStats(x)
end

function getTypeSize(x::ASTContext, ty::QualType)
    @check_ptrs x
    return clang_ASTContext_getTypeSize(x, ty)
end
getTypeSize(x::ASTContext, ty::CXType_) = getTypeSize(x, get_qual_type(ty))

function getSizeOf(x::ASTContext, ty::QualType)
    @check_ptrs x
    return clang_ASTContext_getSizeOf(x, ty)
end

function getTypeDeclType(x::ASTContext, decl::TypeDecl, prev::TypeDecl=TypeDecl(C_NULL))
    @check_ptrs x decl
    return QualType(clang_ASTContext_getTypeDeclType(x, decl, prev))
end

function getRecordType(x::ASTContext, decl::RecordDecl)
    @check_ptrs x decl
    return QualType(clang_ASTContext_getRecordType(x, decl))
end

getTypeDeclType(x::ASTContext, decl::NamedDecl) = getTypeDeclType(x, TypeDecl(decl.ptr))
getTypeDeclType(x::ASTContext, decl::AbstractTypeDecl) = getTypeDeclType(x, TypeDecl(decl.ptr))
getTypeDeclType(x::ASTContext, decl::AbstractRecordDecl) = getRecordType(x, RecordDecl(decl.ptr))

function getPointerType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getPointerType(x, ty))
end

function getLValueReferenceType(x::ASTContext, ty::QualType, spelled_as_lvalue=true)
    @check_ptrs x
    return QualType(clang_ASTContext_getLValueReferenceType(x, ty, spelled_as_lvalue))
end

function getRValueReferenceType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getRValueReferenceType(x, ty))
end

function getMemberPointerType(x::ASTContext, ty::QualType, class_ptr::CXType_)
    @check_ptrs x
    return QualType(clang_ASTContext_getMemberPointerType(x, ty, class_ptr))
end
function getMemberPointerType(x::ASTContext, ty::QualType, class::QualType)
    getMemberPointerType(x, ty, get_type_ptr(class).ptr)
end

function getIdents(x::ASTContext)
    @check_ptrs x
    return IdentifierTable(clang_ASTContext_getIdents(x))
end

VoidTy(ctx::ASTContext) = VoidTy(clang_ASTContext_VoidTy_getAsQualType(ctx))
BoolTy(ctx::ASTContext) = BoolTy(clang_ASTContext_BoolTy_getAsQualType(ctx))
CharTy(ctx::ASTContext) = CharTy(clang_ASTContext_CharTy_getAsQualType(ctx))
WCharTy(ctx::ASTContext) = WCharTy(clang_ASTContext_WCharTy_getAsQualType(ctx))  # [C++ 3.9.1p5].
WideCharTy(ctx::ASTContext) = WideCharTy(clang_ASTContext_WideCharTy_getAsQualType(ctx))
WIntTy(ctx::ASTContext) = WIntTy(clang_ASTContext_WIntTy_getAsQualType(ctx))  # [C99 7.24.1], integer type unchanged by default promotions.
Char8Ty(ctx::ASTContext) = Char8Ty(clang_ASTContext_Char8Ty_getAsQualType(ctx))  # [C++20 proposal]
Char16Ty(ctx::ASTContext) = Char16Ty(clang_ASTContext_Char16Ty_getAsQualType(ctx))  # [C++0x 3.9.1p5], integer type in C99.
Char32Ty(ctx::ASTContext) = Char32Ty(clang_ASTContext_Char32Ty_getAsQualType(ctx))  # [C++0x 3.9.1p5], integer type in C99.
SignedCharTy(ctx::ASTContext) = SignedCharTy(clang_ASTContext_SignedCharTy_getAsQualType(ctx))
ShortTy(ctx::ASTContext) = ShortTy(clang_ASTContext_ShortTy_getAsQualType(ctx))
IntTy(ctx::ASTContext) = IntTy(clang_ASTContext_IntTy_getAsQualType(ctx))
LongTy(ctx::ASTContext) = LongTy(clang_ASTContext_LongTy_getAsQualType(ctx))
LongLongTy(ctx::ASTContext) = LongLongTy(clang_ASTContext_LongLongTy_getAsQualType(ctx))
Int128Ty(ctx::ASTContext) = Int128Ty(clang_ASTContext_Int128Ty_getAsQualType(ctx))
UnsignedCharTy(ctx::ASTContext) = UnsignedCharTy(clang_ASTContext_UnsignedCharTy_getAsQualType(ctx))
UnsignedShortTy(ctx::ASTContext) = UnsignedShortTy(clang_ASTContext_UnsignedShortTy_getAsQualType(ctx))
UnsignedIntTy(ctx::ASTContext) = UnsignedIntTy(clang_ASTContext_UnsignedIntTy_getAsQualType(ctx))
UnsignedLongTy(ctx::ASTContext) = UnsignedLongTy(clang_ASTContext_UnsignedLongTy_getAsQualType(ctx))
UnsignedLongLongTy(ctx::ASTContext) = UnsignedLongLongTy(clang_ASTContext_UnsignedLongLongTy_getAsQualType(ctx))
UnsignedInt128Ty(ctx::ASTContext) = UnsignedInt128Ty(clang_ASTContext_UnsignedInt128Ty_getAsQualType(ctx))
FloatTy(ctx::ASTContext) = FloatTy(clang_ASTContext_FloatTy_getAsQualType(ctx))
DoubleTy(ctx::ASTContext) = DoubleTy(clang_ASTContext_DoubleTy_getAsQualType(ctx))
LongDoubleTy(ctx::ASTContext) = LongDoubleTy(clang_ASTContext_LongDoubleTy_getAsQualType(ctx))
Float128Ty(ctx::ASTContext) = Float128Ty(clang_ASTContext_Float128Ty_getAsQualType(ctx))
HalfTy(ctx::ASTContext) = HalfTy(clang_ASTContext_HalfTy_getAsQualType(ctx))  # [OpenCL 6.1.1.1], ARM NEON
BFloat16Ty(ctx::ASTContext) = BFloat16Ty(clang_ASTContext_BFloat16Ty_getAsQualType(ctx))
Float16Ty(ctx::ASTContext) = Float16Ty(clang_ASTContext_Float16Ty_getAsQualType(ctx))  # C11 extension ISO/IEC TS 18661-3
VoidPtrTy(ctx::ASTContext) = VoidPtrTy(clang_ASTContext_VoidPtrTy_getAsQualType(ctx))
NullPtrTy(ctx::ASTContext) = NullPtrTy(clang_ASTContext_NullPtrTy_getAsQualType(ctx))  # C++11 nullptr

# ASTContext
function CreateTypeSourceInfo(x::ASTContext, a2::QualType, a3::Integer)
    @check_ptrs x
    return TypeSourceInfo(clang_ASTContext_CreateTypeSourceInfo(x, a2, a3))
end

function adjustStringLiteralBaseType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_adjustStringLiteralBaseType(x, a2))
end

function areCompatibleSveTypes(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_areCompatibleSveTypes(x, a2, a3)
end

function areCompatibleVectorTypes(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_areCompatibleVectorTypes(x, a2, a3)
end

function areLaxCompatibleSveTypes(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_areLaxCompatibleSveTypes(x, a2, a3)
end

function getASTAllocatedMemory(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getASTAllocatedMemory(x)
end

function getAdjustedParameterType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getAdjustedParameterType(x, a2))
end

function getAdjustedType(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getAdjustedType(x, a2, a3))
end

function getAlignOfGlobalVar(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getAlignOfGlobalVar(x, a2)
end

function getArrayDecayedType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getArrayDecayedType(x, a2))
end

function getAsArrayType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return ArrayType(clang_ASTContext_getAsArrayType(x, a2))
end

function getAsConstantArrayType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return ConstantArrayType(clang_ASTContext_getAsConstantArrayType(x, a2))
end

function getAsDependentSizedArrayType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return DependentSizedArrayType(clang_ASTContext_getAsDependentSizedArrayType(x, a2))
end

function getAsIncompleteArrayType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return IncompleteArrayType(clang_ASTContext_getAsIncompleteArrayType(x, a2))
end

function getAsVariableArrayType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return VariableArrayType(clang_ASTContext_getAsVariableArrayType(x, a2))
end

function getAtomicType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getAtomicType(x, a2))
end

function getAutoDeductType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getAutoDeductType(x))
end

function getAutoRRefDeductType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getAutoRRefDeductType(x))
end

function getAuxTargetInfo(x::ASTContext)
    @check_ptrs x
    return TargetInfo(clang_ASTContext_getAuxTargetInfo(x))
end

function getBOOLDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getBOOLDecl(x))
end

function getBOOLType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getBOOLType(x))
end

function getBaseElementType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getBaseElementType(x, a2))
end

function getBitIntType(x::ASTContext, a2::Integer, a3::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getBitIntType(x, a2, a3))
end

function getBlockDescriptorExtendedType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getBlockDescriptorExtendedType(x))
end

function getBlockDescriptorType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getBlockDescriptorType(x))
end

function getBlockPointerType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getBlockPointerType(x, a2))
end

function getBoolName(x::ASTContext)
    @check_ptrs x
    return IdentifierInfo(clang_ASTContext_getBoolName(x))
end

function getBuiltinMSVaListDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getBuiltinMSVaListDecl(x))
end

function getBuiltinMSVaListType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getBuiltinMSVaListType(x))
end

function getBuiltinVaListDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getBuiltinVaListDecl(x))
end

function getCFConstantStringTagDecl(x::ASTContext)
    @check_ptrs x
    return RecordDecl(clang_ASTContext_getCFConstantStringTagDecl(x))
end

function getCFConstantStringType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getCFConstantStringType(x))
end

function getCFContantStringDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getCFContantStringDecl(x))
end

function getCVRQualifiedType(x::ASTContext, a2::QualType, a3::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getCVRQualifiedType(x, a2, a3))
end

function getCharWidth(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getCharWidth(x)
end

function getComplexType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getComplexType(x, a2))
end

function getConstType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getConstType(x, a2))
end

function getConstantMatrixType(x::ASTContext, a2::QualType, a3::Integer, a4::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getConstantMatrixType(x, a2, a3, a4))
end

function getCorrespondingSaturatedType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getCorrespondingSaturatedType(x, a2))
end

function getCorrespondingSignedFixedPointType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getCorrespondingSignedFixedPointType(x, a2))
end

function getCorrespondingUnsignedType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getCorrespondingUnsignedType(x, a2))
end

function getDecayedType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getDecayedType(x, a2))
end

function getDiagnostics(x::ASTContext)
    @check_ptrs x
    return DiagnosticsEngine(clang_ASTContext_getDiagnostics(x))
end

function getExceptionObjectType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getExceptionObjectType(x, a2))
end

function getExtVectorType(x::ASTContext, a2::QualType, a3::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getExtVectorType(x, a2, a3))
end

function getExternCContextDecl(x::ASTContext)
    @check_ptrs x
    return ExternCContextDecl(clang_ASTContext_getExternCContextDecl(x))
end

function getFILEType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getFILEType(x))
end

function getFixedPointIBits(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getFixedPointIBits(x, a2)
end

function getFixedPointScale(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getFixedPointScale(x, a2)
end

function getFloatingTypeOrder(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_getFloatingTypeOrder(x, a2, a3)
end

function getFloatingTypeSemanticOrder(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_getFloatingTypeSemanticOrder(x, a2, a3)
end

function getFunctionNoProtoType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getFunctionNoProtoType(x, a2))
end

function getFunctionTypeWithoutPtrSizes(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getFunctionTypeWithoutPtrSizes(x, a2))
end

function getInt128Decl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getInt128Decl(x))
end

function getIntPtrType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getIntPtrType(x))
end

function getIntTypeForBitwidth(x::ASTContext, a2::Integer, a3::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getIntTypeForBitwidth(x, a2, a3))
end

function getIntWidth(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getIntWidth(x, a2)
end

function getIntegerTypeOrder(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_getIntegerTypeOrder(x, a2, a3)
end

function getLangOpts(x::ASTContext)
    @check_ptrs x
    return LangOptions(clang_ASTContext_getLangOpts(x))
end

function getLogicalOperationType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getLogicalOperationType(x))
end

function getMSGuidTagDecl(x::ASTContext)
    @check_ptrs x
    return TagDecl(clang_ASTContext_getMSGuidTagDecl(x))
end

function getMSGuidType(x::ASTContext)
    @check_ptrs x
    return TagType(clang_ASTContext_getMSGuidType(x))
end

function getMakeIntegerSeqDecl(x::ASTContext)
    @check_ptrs x
    return BuiltinTemplateDecl(clang_ASTContext_getMakeIntegerSeqDecl(x))
end

function getMakeIntegerSeqName(x::ASTContext)
    @check_ptrs x
    return IdentifierInfo(clang_ASTContext_getMakeIntegerSeqName(x))
end

function getNSCopyingName(x::ASTContext)
    @check_ptrs x
    return IdentifierInfo(clang_ASTContext_getNSCopyingName(x))
end

function getObjCClassRedefinitionType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCClassRedefinitionType(x))
end

function getObjCIdRedefinitionType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCIdRedefinitionType(x))
end

function getObjCInstanceType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCInstanceType(x))
end

function getObjCInstanceTypeDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getObjCInstanceTypeDecl(x))
end

function getObjCProtoType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCProtoType(x))
end

function getObjCSuperType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCSuperType(x))
end

function getOpenMPDefaultSimdAlign(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getOpenMPDefaultSimdAlign(x, a2)
end

function getParenType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getParenType(x, a2))
end

function getPointerDiffType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getPointerDiffType(x))
end

function getPreferredTypeAlign(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getPreferredTypeAlign(x, a2)
end

function getProcessIDType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getProcessIDType(x))
end

function getPromotedIntegerType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getPromotedIntegerType(x, a2))
end

function getRawCFConstantStringType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getRawCFConstantStringType(x))
end

function getReadPipeType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getReadPipeType(x, a2))
end

function getRestrictType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getRestrictType(x, a2))
end

function getScalableVectorType(x::ASTContext, a2::QualType, a3::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getScalableVectorType(x, a2, a3))
end

function getSideTableAllocatedMemory(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getSideTableAllocatedMemory(x)
end

function getSignatureParameterType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getSignatureParameterType(x, a2))
end

function getSignedWCharType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getSignedWCharType(x))
end

function getSourceManager(x::ASTContext)
    @check_ptrs x
    return SourceManager(clang_ASTContext_getSourceManager(x))
end

function getStringLiteralArrayType(x::ASTContext, a2::QualType, a3::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getStringLiteralArrayType(x, a2, a3))
end

function getTargetDefaultAlignForAttributeAligned(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getTargetDefaultAlignForAttributeAligned(x)
end

function getTargetInfo(x::ASTContext)
    @check_ptrs x
    return TargetInfo(clang_ASTContext_getTargetInfo(x))
end

function getTargetNullPointerValue(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getTargetNullPointerValue(x, a2)
end

function getTranslationUnitDecl(x::ASTContext)
    @check_ptrs x
    return TranslationUnitDecl(clang_ASTContext_getTranslationUnitDecl(x))
end

function getTypeAlign(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getTypeAlign(x, a2)
end

function getTypeAlignIfKnown(x::ASTContext, a2::QualType, a3::Integer)
    @check_ptrs x
    return clang_ASTContext_getTypeAlignIfKnown(x, a2, a3)
end

function getTypePackElementDecl(x::ASTContext)
    @check_ptrs x
    return BuiltinTemplateDecl(clang_ASTContext_getTypePackElementDecl(x))
end

function getTypePackElementName(x::ASTContext)
    @check_ptrs x
    return IdentifierInfo(clang_ASTContext_getTypePackElementName(x))
end

function getTypeUnadjustedAlign(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_getTypeUnadjustedAlign(x, a2)
end

function getUInt128Decl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getUInt128Decl(x))
end

function getUIntPtrType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getUIntPtrType(x))
end

function getUnsignedPointerDiffType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getUnsignedPointerDiffType(x))
end

function getUnsignedWCharType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getUnsignedWCharType(x))
end

function getVaListTagDecl(x::ASTContext)
    @check_ptrs x
    return Decl(clang_ASTContext_getVaListTagDecl(x))
end

function getVariableArrayDecayedType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getVariableArrayDecayedType(x, a2))
end

function getVolatileType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getVolatileType(x, a2))
end

function getWCharType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getWCharType(x))
end

function getWIntType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getWIntType(x))
end

function getWideCharType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getWideCharType(x))
end

function getWritePipeType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getWritePipeType(x, a2))
end

function getcudaConfigureCallDecl(x::ASTContext)
    @check_ptrs x
    return FunctionDecl(clang_ASTContext_getcudaConfigureCallDecl(x))
end

function hasCvrSimilarType(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_hasCvrSimilarType(x, a2, a3)
end

function hasDirectOwnershipQualifier(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_hasDirectOwnershipQualifier(x, a2)
end

function hasSameFunctionTypeIgnoringExceptionSpec(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(x, a2, a3)
end

function hasSameFunctionTypeIgnoringPtrSizes(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(x, a2, a3)
end

function hasSameNullabilityTypeQualifier(x::ASTContext, a2::QualType, a3::QualType, a4::Integer)
    @check_ptrs x
    return clang_ASTContext_hasSameNullabilityTypeQualifier(x, a2, a3, a4)
end

function hasSameType(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_hasSameType(x, a2, a3)
end

function hasSameUnqualifiedType(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_hasSameUnqualifiedType(x, a2, a3)
end

function hasSimilarType(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_hasSimilarType(x, a2, a3)
end

function hasUniqueObjectRepresentations(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_hasUniqueObjectRepresentations(x, a2)
end

function isAlignmentRequired(x::ASTContext, a2::QualType)
    @check_ptrs x
    return clang_ASTContext_isAlignmentRequired(x, a2)
end

function isDependceAllowed(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_isDependceAllowed(x)
end

function mergeFunctionParameterTypes(x::ASTContext, a2::QualType, a3::QualType, a4::Integer, a5::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_mergeFunctionParameterTypes(x, a2, a3, a4, a5))
end

function mergeFunctionTypes(x::ASTContext, a2::QualType, a3::QualType, a4::Integer, a5::Integer, a6::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_mergeFunctionTypes(x, a2, a3, a4, a5, a6))
end

function mergeObjCGCQualifiers(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_mergeObjCGCQualifiers(x, a2, a3))
end

function mergeTransparentUnionType(x::ASTContext, a2::QualType, a3::QualType, a4::Integer, a5::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_mergeTransparentUnionType(x, a2, a3, a4, a5))
end

function mergeTypes(x::ASTContext, a2::QualType, a3::QualType, a4::Integer, a5::Integer, a6::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_mergeTypes(x, a2, a3, a4, a5, a6))
end

function propertyTypesAreCompatible(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_propertyTypesAreCompatible(x, a2, a3)
end

function removeAddrSpaceQualType(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_removeAddrSpaceQualType(x, a2))
end

function removePtrSizeAddrSpace(x::ASTContext, a2::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_removePtrSizeAddrSpace(x, a2))
end

function typesAreBlockPointerCompatible(x::ASTContext, a2::QualType, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_typesAreBlockPointerCompatible(x, a2, a3)
end

function typesAreCompatible(x::ASTContext, a2::QualType, a3::QualType, a4::Integer)
    @check_ptrs x
    return clang_ASTContext_typesAreCompatible(x, a2, a3, a4)
end

function AtomicUsesUnsupportedLibcall(x::ASTContext, a2::AbstractAtomicExpr)
    @check_ptrs x
    return clang_ASTContext_AtomicUsesUnsupportedLibcall(x, a2)
end

function BlockRequiresCopying(x::ASTContext, a2::QualType, a3::AbstractVarDecl)
    @check_ptrs x
    return clang_ASTContext_BlockRequiresCopying(x, a2, a3)
end

function InitBuiltinTypes(x::ASTContext, a2::TargetInfo, a3::TargetInfo)
    @check_ptrs x
    return clang_ASTContext_InitBuiltinTypes(x, a2, a3)
end

function addCopyConstructorForExceptionObject(x::ASTContext, a2::AbstractCXXRecordDecl, a3::AbstractCXXConstructorDecl)
    @check_ptrs x
    return clang_ASTContext_addCopyConstructorForExceptionObject(x, a2, a3)
end

function addDeclaratorForUnnamedTagDecl(x::ASTContext, a2::AbstractTagDecl, a3::AbstractDeclaratorDecl)
    @check_ptrs x
    return clang_ASTContext_addDeclaratorForUnnamedTagDecl(x, a2, a3)
end

function addOverriddenMethod(x::ASTContext, a2::AbstractCXXMethodDecl, a3::AbstractCXXMethodDecl)
    @check_ptrs x
    return clang_ASTContext_addOverriddenMethod(x, a2, a3)
end

function addTypedefNameForUnnamedTagDecl(x::ASTContext, a2::AbstractTagDecl, a3::AbstractTypedefNameDecl)
    @check_ptrs x
    return clang_ASTContext_addTypedefNameForUnnamedTagDecl(x, a2, a3)
end

function addedLocalImportDecl(x::ASTContext, a2::AbstractImportDecl)
    @check_ptrs x
    return clang_ASTContext_addedLocalImportDecl(x, a2)
end

function adjustDeducedFunctionResultType(x::ASTContext, a2::AbstractFunctionDecl, a3::QualType)
    @check_ptrs x
    return clang_ASTContext_adjustDeducedFunctionResultType(x, a2, a3)
end

function canBuiltinBeRedeclared(x::ASTContext, a2::AbstractFunctionDecl)
    @check_ptrs x
    return clang_ASTContext_canBuiltinBeRedeclared(x, a2)
end

function deduplicateMergedDefinitonsFor(x::ASTContext, a2::AbstractNamedDecl)
    @check_ptrs x
    return clang_ASTContext_deduplicateMergedDefinitonsFor(x, a2)
end

function eraseDeclAttrs(x::ASTContext, a2::AbstractDecl)
    @check_ptrs x
    return clang_ASTContext_eraseDeclAttrs(x, a2)
end

function getAssumedTemplateName(x::ASTContext, a2::AbstractDeclarationName)
    @check_ptrs x
    return TemplateName(clang_ASTContext_getAssumedTemplateName(x, a2))
end

function getCanonicalNestedNameSpecifier(x::ASTContext, a2::NestedNameSpecifier)
    @check_ptrs x
    return NestedNameSpecifier(clang_ASTContext_getCanonicalNestedNameSpecifier(x, a2))
end

function getCanonicalTemplateName(x::ASTContext, a2::TemplateName)
    @check_ptrs x
    return TemplateName(clang_ASTContext_getCanonicalTemplateName(x, a2))
end

function getConstantArrayElementCount(x::ASTContext, a2::AbstractConstantArrayType)
    @check_ptrs x
    return clang_ASTContext_getConstantArrayElementCount(x, a2)
end

function getCopyConstructorForExceptionObject(x::ASTContext, a2::AbstractCXXRecordDecl)
    @check_ptrs x
    return CXXConstructorDecl(clang_ASTContext_getCopyConstructorForExceptionObject(x, a2))
end

function getDeclaratorForUnnamedTagDecl(x::ASTContext, a2::AbstractTagDecl)
    @check_ptrs x
    return DeclaratorDecl(clang_ASTContext_getDeclaratorForUnnamedTagDecl(x, a2))
end

function getDecltypeType(x::ASTContext, a2::AbstractExpr, a3::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getDecltypeType(x, a2, a3))
end

function getDeducedTemplateSpecializationType(x::ASTContext, a2::TemplateName, a3::QualType, a4::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getDeducedTemplateSpecializationType(x, a2, a3, a4))
end

function getDependentAddressSpaceType(x::ASTContext, a2::QualType, a3::AbstractExpr, a4::SourceLocation)
    @check_ptrs x
    return QualType(clang_ASTContext_getDependentAddressSpaceType(x, a2, a3, a4))
end

function getDependentBitIntType(x::ASTContext, a2::Integer, a3::AbstractExpr)
    @check_ptrs x
    return QualType(clang_ASTContext_getDependentBitIntType(x, a2, a3))
end

function getDependentSizedExtVectorType(x::ASTContext, a2::QualType, a3::AbstractExpr, a4::SourceLocation)
    @check_ptrs x
    return QualType(clang_ASTContext_getDependentSizedExtVectorType(x, a2, a3, a4))
end

function getDependentSizedMatrixType(x::ASTContext, a2::QualType, a3::AbstractExpr, a4::AbstractExpr, a5::SourceLocation)
    @check_ptrs x
    return QualType(clang_ASTContext_getDependentSizedMatrixType(x, a2, a3, a4, a5))
end

function getDependentTemplateName(x::ASTContext, a2::NestedNameSpecifier, a3::IdentifierInfo)
    @check_ptrs x
    return TemplateName(clang_ASTContext_getDependentTemplateName(x, a2, a3))
end

function getEnumType(x::ASTContext, a2::AbstractEnumDecl)
    @check_ptrs x
    return QualType(clang_ASTContext_getEnumType(x, a2))
end

function getFieldOffset(x::ASTContext, a2::AbstractValueDecl)
    @check_ptrs x
    return clang_ASTContext_getFieldOffset(x, a2)
end

function getInjectedClassNameType(x::ASTContext, a2::AbstractCXXRecordDecl, a3::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getInjectedClassNameType(x, a2, a3))
end

function getInstantiatedFromUnnamedFieldDecl(x::ASTContext, a2::AbstractFieldDecl)
    @check_ptrs x
    return FieldDecl(clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(x, a2))
end

function getInstantiatedFromUsingDecl(x::ASTContext, a2::AbstractNamedDecl)
    @check_ptrs x
    return NamedDecl(clang_ASTContext_getInstantiatedFromUsingDecl(x, a2))
end

function getInstantiatedFromUsingShadowDecl(x::ASTContext, a2::AbstractUsingShadowDecl)
    @check_ptrs x
    return UsingShadowDecl(clang_ASTContext_getInstantiatedFromUsingShadowDecl(x, a2))
end

function getMacroQualifiedType(x::ASTContext, a2::QualType, a3::IdentifierInfo)
    @check_ptrs x
    return QualType(clang_ASTContext_getMacroQualifiedType(x, a2, a3))
end

function getManglingNumber(x::ASTContext, a2::AbstractNamedDecl)
    @check_ptrs x
    return clang_ASTContext_getManglingNumber(x, a2)
end

function getParameterIndex(x::ASTContext, a2::AbstractParmVarDecl)
    @check_ptrs x
    return clang_ASTContext_getParameterIndex(x, a2)
end

function getPrimaryMergedDecl(x::ASTContext, a2::AbstractDecl)
    @check_ptrs x
    return Decl(clang_ASTContext_getPrimaryMergedDecl(x, a2))
end

function getStaticLocalNumber(x::ASTContext, a2::AbstractVarDecl)
    @check_ptrs x
    return clang_ASTContext_getStaticLocalNumber(x, a2)
end

function getTagDeclType(x::ASTContext, a2::AbstractTagDecl)
    @check_ptrs x
    return QualType(clang_ASTContext_getTagDeclType(x, a2))
end

function getTemplateTypeParmType(x::ASTContext, a2::Integer, a3::Integer, a4::Integer, a5::TemplateTypeParmDecl)
    @check_ptrs x a5
    return QualType(clang_ASTContext_getTemplateTypeParmType(x, a2, a3, a4, a5))
end

function getTrivialTypeSourceInfo(x::ASTContext, a2::QualType, a3::SourceLocation)
    @check_ptrs x
    return TypeSourceInfo(clang_ASTContext_getTrivialTypeSourceInfo(x, a2, a3))
end

function getTypedefNameForUnnamedTagDecl(x::ASTContext, a2::AbstractTagDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_ASTContext_getTypedefNameForUnnamedTagDecl(x, a2))
end

function getTypedefType(x::ASTContext, a2::AbstractTypedefNameDecl, a3::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getTypedefType(x, a2, a3))
end

function hasSameTempalteName(x::ASTContext, a2::TemplateName, a3::TemplateName)
    @check_ptrs x
    return clang_ASTContext_hasSameTempalteName(x, a2, a3)
end

function isMSStaticDataMemberInlineDefinition(x::ASTContext, a2::AbstractVarDecl)
    @check_ptrs x
    return clang_ASTContext_isMSStaticDataMemberInlineDefinition(x, a2)
end

function isNearlyEmpty(x::ASTContext, a2::AbstractCXXRecordDecl)
    @check_ptrs x
    return clang_ASTContext_isNearlyEmpty(x, a2)
end

function isPromotableBitField(x::ASTContext, a2::AbstractExpr)
    @check_ptrs x
    return QualType(clang_ASTContext_isPromotableBitField(x, a2))
end

function isSentinelNullExpr(x::ASTContext, a2::AbstractExpr)
    @check_ptrs x
    return clang_ASTContext_isSentinelNullExpr(x, a2)
end

function mergeDefinitionIntoModule(x::ASTContext, a2::AbstractNamedDecl, a3::Module, a4::Integer)
    @check_ptrs x
    return clang_ASTContext_mergeDefinitionIntoModule(x, a2, a3, a4)
end


function setInstantiatedFromUsingDecl(x::ASTContext, Inst::AbstractNamedDecl, Pattern::AbstractNamedDecl)
    @check_ptrs x Inst Pattern
    return clang_ASTContext_setInstantiatedFromUsingDecl(x, Inst, Pattern)
end

function setInstantiatedFromUsingShadowDecl(x::ASTContext, Inst::AbstractUsingShadowDecl, Pattern::AbstractUsingShadowDecl)
    @check_ptrs x Inst Pattern
    return clang_ASTContext_setInstantiatedFromUsingShadowDecl(x, Inst, Pattern)
end

function setInstantiatedFromUnnamedFieldDecl(x::ASTContext, Inst::AbstractFieldDecl, Tmpl::AbstractFieldDecl)
    @check_ptrs x Inst Tmpl
    return clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(x, Inst, Tmpl)
end

function setPrimaryMergedDecl(x::ASTContext, D::AbstractDecl, Primary::AbstractDecl)
    @check_ptrs x D Primary
    return clang_ASTContext_setPrimaryMergedDecl(x, D, Primary)
end

function buildImplicitRecord(x::ASTContext, name::AbstractString, TK::CXTagTypeKind=CXTagTypeKind_Struct)
    @check_ptrs x
    return RecordDecl(clang_ASTContext_buildImplicitRecord(x, name, TK))
end

function buildImplicitTypedef(x::ASTContext, T::QualType, name::AbstractString)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_buildImplicitTypedef(x, T, name))
end

function setcudaConfigureCallDecl(x::ASTContext, FD::AbstractFunctionDecl)
    @check_ptrs x FD
    return clang_ASTContext_setcudaConfigureCallDecl(x, FD)
end

function setCFConstantStringType(x::ASTContext, T::QualType)
    @check_ptrs x
    return clang_ASTContext_setCFConstantStringType(x, T)
end

function setObjCIdRedefinitionType(x::ASTContext, T::QualType)
    @check_ptrs x
    return clang_ASTContext_setObjCIdRedefinitionType(x, T)
end

function setObjCClassRedefinitionType(x::ASTContext, T::QualType)
    @check_ptrs x
    return clang_ASTContext_setObjCClassRedefinitionType(x, T)
end

function setFILEDecl(x::ASTContext, FILEDecl::AbstractTypeDecl)
    @check_ptrs x FILEDecl
    return clang_ASTContext_setFILEDecl(x, FILEDecl)
end

function setBOOLDecl(x::ASTContext, TD::AbstractTypedefDecl)
    @check_ptrs x TD
    return clang_ASTContext_setBOOLDecl(x, TD)
end

function setManglingNumber(x::ASTContext, ND::AbstractNamedDecl, Number::Integer)
    @check_ptrs x ND
    return clang_ASTContext_setManglingNumber(x, ND, Number)
end

function setStaticLocalNumber(x::ASTContext, ND::AbstractVarDecl, Number::Integer)
    @check_ptrs x ND
    return clang_ASTContext_setStaticLocalNumber(x, ND, Number)
end

function setParameterIndex(x::ASTContext, D::AbstractParmVarDecl, index::Integer)
    @check_ptrs x D
    return clang_ASTContext_setParameterIndex(x, D, index)
end

function getPredefinedStringLiteralFromCache(x::ASTContext, key::AbstractString)
    @check_ptrs x
    return StringLiteral(clang_ASTContext_getPredefinedStringLiteralFromCache(x, key))
end
