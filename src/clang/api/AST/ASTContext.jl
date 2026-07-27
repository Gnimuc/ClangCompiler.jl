function PrintStats(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_PrintStats(x)
end

function getTypeSize(x::ASTContext, ty::QualType)
    @check_ptrs x
    return clang_ASTContext_getTypeSize(x, ty)
end
getTypeSize(x::ASTContext, ty::AbstractType) = getTypeSize(x, get_qual_type(ty))

function getSizeOf(x::ASTContext, ty::QualType)
    @check_ptrs x
    return clang_ASTContext_getSizeOf(x, ty)
end

function getTypeDeclType(x::ASTContext, decl::AbstractTypeDecl,
                         prev::AbstractTypeDecl=TypeDecl(C_NULL))
    @check_ptrs x decl
    return QualType(clang_ASTContext_getTypeDeclType(x, decl, prev))
end

function getRecordType(x::ASTContext, decl::AbstractRecordDecl)
    @check_ptrs x decl
    return QualType(clang_ASTContext_getRecordType(x, decl))
end

"""
    getASTRecordLayout(x::ASTContext, decl::AbstractRecordDecl) -> ASTRecordLayout
Return the record's memory layout. The layout is owned by the `ASTContext`
arena (no `dispose`). The record must have a complete definition.
"""
function getASTRecordLayout(x::ASTContext, decl::AbstractRecordDecl)
    @check_ptrs x decl
    @assert getDefinition(decl).ptr != C_NULL "cannot get the layout of a forward declaration"
    return ASTRecordLayout(clang_ASTContext_getASTRecordLayout(x, decl))
end

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

"""
    getFunctionType(x::ASTContext, ret::QualType, args::Vector{QualType};
                    variadic=false, cc=CXCallingConv_CC_C) -> QualType
Build a `FunctionProtoType` from a return type and parameter types. The
remaining `ExtProtoInfo` fields keep their defaults.
"""
function getFunctionType(x::ASTContext, ret::QualType, args::Vector{QualType}=QualType[];
                         variadic::Bool=false, cc::CXCallingConv_=CXCallingConv_CC_C)
    @check_ptrs x
    ptrs = CXQualType[a.ptr for a in args]
    return QualType(clang_ASTContext_getFunctionType(x, ret, ptrs, length(ptrs), variadic,
                                                     cc))
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

"""
    getConstantArrayType(x::ASTContext, elt::QualType, size::Integer) -> QualType
Build a `ConstantArrayType` of `size` elements of `elt`.
"""
function getConstantArrayType(x::ASTContext, elt::QualType, size::Integer,
                              asm::CXArraySizeModifier=CXArraySizeModifier_Normal,
                              index_type_quals::Integer=0)
    @check_ptrs x
    return QualType(clang_ASTContext_getConstantArrayType(x, elt, size, asm,
                                                          index_type_quals))
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

"""
    getTemplateSpecializationType(x::ASTContext, name::TemplateName,
                                  args::Vector{TemplateArgument},
                                  underlying::QualType=QualType(C_NULL)) -> QualType
Build a `TemplateSpecializationType` from a template name and arguments. The
arguments cross as a handle buffer (MARSHALLING.md §11); `underlying` is only
consulted for alias templates and may stay null otherwise.
"""
function getTemplateSpecializationType(x::ASTContext, name::TemplateName,
                                       args::Vector{TemplateArgument},
                                       underlying::QualType=QualType(C_NULL))
    @check_ptrs x name
    ptrs = CXTemplateArgument[a.ptr for a in args]
    return QualType(clang_ASTContext_getTemplateSpecializationType(x, name, ptrs,
                                                                   length(ptrs),
                                                                   underlying))
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


"""
    getTypeInfo(x::ASTContext, ty::QualType) -> (width, align, align_requirement)
Return the size and ABI alignment of `ty` **in bits**, plus why the alignment is
required (`CXAlignRequirementKind_None` when nothing forced it).

`ty` must be non-dependent and, for record/enum types, complete: Clang's
`getTypeInfoImpl` is `llvm_unreachable` on dependent types and lays records out eagerly.
"""
function getTypeInfo(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    width = Ref{UInt64}(0)
    align = Ref{Cuint}(0)
    req = Ref{CXAlignRequirementKind}(CXAlignRequirementKind_None)
    clang_ASTContext_getTypeInfo(x, ty, width, align, req)
    return (width[], align[], req[])
end

"""
    getTypeInfoInChars(x::ASTContext, ty::QualType) -> (width, align, align_requirement)
Same as [`getTypeInfo`](@ref) but with `width`/`align` in **bytes**. Carries the same
non-dependent/complete precondition on `ty`.
"""
function getTypeInfoInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    width = Ref{Int64}(0)
    align = Ref{Int64}(0)
    req = Ref{CXAlignRequirementKind}(CXAlignRequirementKind_None)
    clang_ASTContext_getTypeInfoInChars(x, ty, width, align, req)
    return (width[], align[], req[])
end

"""
    getTypeSizeInChars(x::ASTContext, ty::QualType) -> Int64
Return the size of `ty` in bytes. `ty` must be non-dependent and complete.
"""
function getTypeSizeInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    return clang_ASTContext_getTypeSizeInChars(x, ty)
end

"""
    getTypeAlignInChars(x::ASTContext, ty::QualType) -> Int64
Return the ABI alignment of `ty` in bytes. `ty` must be non-dependent and complete.
"""
function getTypeAlignInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    return clang_ASTContext_getTypeAlignInChars(x, ty)
end

"""
    getPreferredTypeAlignInChars(x::ASTContext, ty::QualType) -> Int64
Return the target's preferred alignment of `ty` in bytes. `ty` must be non-dependent
and complete.
"""
function getPreferredTypeAlignInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    return clang_ASTContext_getPreferredTypeAlignInChars(x, ty)
end

"""
    getTypeUnadjustedAlignInChars(x::ASTContext, ty::QualType) -> Int64
Return the ABI alignment of `ty` in bytes, ignoring alignment attributes applied to
the typedef. `ty` must be non-dependent and complete.
"""
function getTypeUnadjustedAlignInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    return clang_ASTContext_getTypeUnadjustedAlignInChars(x, ty)
end

"""
    toCharUnitsFromBits(x::ASTContext, bit_size::Integer) -> Int64
Convert a bit quantity to bytes using the target's char width.
"""
function toCharUnitsFromBits(x::ASTContext, bit_size::Integer)
    @check_ptrs x
    return clang_ASTContext_toCharUnitsFromBits(x, bit_size)
end

"""
    toBits(x::ASTContext, char_size::Integer) -> Int64
Convert a byte quantity to bits using the target's char width.
"""
function toBits(x::ASTContext, char_size::Integer)
    @check_ptrs x
    return clang_ASTContext_toBits(x, char_size)
end

"""
    getDeclAlign(x::ASTContext, decl::AbstractDecl, for_alignof::Bool=false) -> Int64
Return the alignment of `decl` in bytes; `for_alignof` selects `alignof()` semantics
over the ABI alignment. Routes through `getTypeInfo`, so the decl's type must be
non-dependent and complete.
"""
function getDeclAlign(x::ASTContext, decl::AbstractDecl, for_alignof::Bool=false)
    @check_ptrs x decl
    return clang_ASTContext_getDeclAlign(x, decl, for_alignof)
end

"""
    getAlignOfGlobalVarInChars(x::ASTContext, ty::QualType) -> Int64
Return the alignment in bytes a global variable of type `ty` gets. `ty` must be
non-dependent and complete.
"""
function getAlignOfGlobalVarInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    return clang_ASTContext_getAlignOfGlobalVarInChars(x, ty)
end

"""
    getExnObjectAlignment(x::ASTContext) -> Int64
Return the alignment in bytes the target's ABI gives to exception objects.
"""
function getExnObjectAlignment(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getExnObjectAlignment(x)
end

"""
    getQualifiedType(x::ASTContext, ty::QualType, quals::Integer) -> QualType
Return `ty` with the qualifiers encoded by `quals` added. `quals` uses the same opaque
encoding as [`getQualifiersAsOpaqueValue`](@ref) (bit 0 `const`, 1 `restrict`, 2 `volatile`).
"""
function getQualifiedType(x::ASTContext, ty::QualType, quals::Integer)
    @check_ptrs x
    return QualType(clang_ASTContext_getQualifiedType(x, ty, quals))
end

"""
    getUnqualifiedArrayType(x::ASTContext, ty::QualType) -> (QualType, UInt32)
Strip the qualifiers off `ty`'s (possibly nested) array element type, returning the
unqualified type together with the qualifiers removed, in the opaque encoding. For a
non-array `ty` this is just its unqualified type and its own qualifiers.
"""
function getUnqualifiedArrayType(x::ASTContext, ty::QualType)
    @check_ptrs x
    quals = Ref{Cuint}(0)
    unqualified = QualType(clang_ASTContext_getUnqualifiedArrayType(x, ty, quals))
    return unqualified, quals[]
end

"""
    getAttributedType(x::ASTContext, kind::CXAttrKind, modified::QualType,
                      equivalent::QualType) -> QualType
Build the `AttributedType` that sugars `equivalent` with the attribute `kind` written
on `modified`.
"""
function getAttributedType(x::ASTContext, kind::CXAttrKind, modified::QualType,
                           equivalent::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getAttributedType(x, kind, modified, equivalent))
end

"""
    getIncompleteArrayType(x::ASTContext, elt::QualType) -> QualType
Build an `IncompleteArrayType` (`elt[]`) with element type `elt`.
"""
function getIncompleteArrayType(x::ASTContext, elt::QualType,
                                asm::CXArraySizeModifier=CXArraySizeModifier_Normal,
                                index_type_quals::Integer=0)
    @check_ptrs x
    return QualType(clang_ASTContext_getIncompleteArrayType(x, elt, asm, index_type_quals))
end

"""
    isPromotableIntegerType(x::ASTContext, ty::QualType) -> Bool
Return whether `ty` undergoes the integer promotions (C99 6.3.1.1p2). Returns `false`
for every non-promotable type, including non-integral ones.
"""
function isPromotableIntegerType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return clang_ASTContext_isPromotableIntegerType(x, ty)
end

"""
    getRawCommentTextForAnyRedecl(x::ASTContext, decl::AbstractDecl) -> String
Return the raw text of the documentation comment attached to `decl` or to any of its
redeclarations, or `""` when none is attached.
"""
function getRawCommentTextForAnyRedecl(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return get_string(clang_ASTContext_getRawCommentTextForAnyRedecl(x, decl))
end

"""
    getRawCommentOriginalDeclForAnyRedecl(x::ASTContext, decl::AbstractDecl) -> Decl
Return the redeclaration that actually carried the documentation comment found for
`decl`, or a NULL-pointer `Decl` when no comment is attached.
"""
function getRawCommentOriginalDeclForAnyRedecl(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return Decl(clang_ASTContext_getRawCommentOriginalDeclForAnyRedecl(x, decl))
end


"""
    getRawCommentForAnyRedecl(x::ASTContext, decl::AbstractDecl) -> RawComment
Return the documentation comment attached to `decl` or to any of its
redeclarations, or a NULL-pointer `RawComment` when none is attached.

The pointee lives in the `ASTContext` arena — there is no `dispose`.
"""
function getRawCommentForAnyRedecl(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return RawComment(clang_ASTContext_getRawCommentForAnyRedecl(x, decl))
end

"""
    getCommentForDecl(x::ASTContext, decl::AbstractDecl, pp::Preprocessor) -> FullComment
Return the parsed documentation comment tree attached to `decl`, or a
NULL-pointer `FullComment` when none is attached.

`pp` should be the `Preprocessor` used with this translation unit.
"""
function getCommentForDecl(x::ASTContext, decl::AbstractDecl, pp::Preprocessor)
    @check_ptrs x decl pp
    return FullComment(clang_ASTContext_getCommentForDecl(x, decl, pp))
end


"""
    getCanonicalType(x::ASTContext, ty::QualType) -> QualType
Return the canonical (sugar-free) type of `ty`. Two canonical types can be
compared for exact equality by pointer identity.
"""
function getCanonicalType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getCanonicalType(x, ty))
end

"""
    getCanonicalParamType(x::ASTContext, ty::QualType) -> QualType
Return the canonical parameter type of `ty`: qualifiers are stripped, functions
become function pointers and arrays decay one level into pointers.
"""
function getCanonicalParamType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getCanonicalParamType(x, ty))
end

"""
    getCanonicalFunctionResultType(x::ASTContext, ty::QualType) -> QualType
Return the adjusted canonical form of the function result type `ty`.
"""
function getCanonicalFunctionResultType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getCanonicalFunctionResultType(x, ty))
end

"""
    getCommonSugaredType(x::ASTContext, a::QualType, b::QualType, unqualified::Bool=false) -> QualType
Return the type carrying the sugar common to `a` and `b`; qualifiers that do not
occur in both are dropped.

`a` and `b` must be the same type — the same unqualified type when `unqualified`
is `true`.
"""
function getCommonSugaredType(x::ASTContext, a::QualType, b::QualType, unqualified::Bool=false)
    @check_ptrs x
    same = unqualified ? hasSameUnqualifiedType(x, a, b) : hasSameType(x, a, b)
    @assert same "getCommonSugaredType requires two types that are the same type"
    return QualType(clang_ASTContext_getCommonSugaredType(x, a, b, unqualified))
end

"""
    getCorrespondingSignedType(x::ASTContext, ty::QualType) -> QualType
Return the signed counterpart of the unsigned type `ty` (C99 6.2.5p6, extended to
fixed-point types by ISO N1169).

`ty` must have an unsigned integer representation or be an unsigned fixed-point
type.
"""
function getCorrespondingSignedType(x::ASTContext, ty::QualType)
    @check_ptrs x
    ptr = getTypePtr(ty)
    @assert hasUnsignedIntegerRepresentation(ptr) || isUnsignedFixedPointType(ptr) "type must be unsigned"
    return QualType(clang_ASTContext_getCorrespondingSignedType(x, ty))
end

"""
    getAddrSpaceQualType(x::ASTContext, ty::QualType, addr_space::CXLangAS) -> QualType
Return `ty` requalified into `addr_space`. An address space already on `ty` is
silently replaced.
"""
function getAddrSpaceQualType(x::ASTContext, ty::QualType, addr_space::CXLangAS)
    @check_ptrs x
    return QualType(clang_ASTContext_getAddrSpaceQualType(x, ty, addr_space))
end

"""
    getLangASForBuiltinAddressSpace(x::ASTContext, addr_space::Integer) -> CXLangAS
Map a target builtin address-space number onto its language address space.
"""
function getLangASForBuiltinAddressSpace(x::ASTContext, addr_space::Integer)
    @check_ptrs x
    return clang_ASTContext_getLangASForBuiltinAddressSpace(x, addr_space)
end

"""
    addressSpaceMapManglingFor(x::ASTContext, addr_space::CXLangAS) -> Bool
Return whether `addr_space` takes part in name mangling on this target.
"""
function addressSpaceMapManglingFor(x::ASTContext, addr_space::CXLangAS)
    @check_ptrs x
    return clang_ASTContext_addressSpaceMapManglingFor(x, addr_space)
end

"""
    getIntMaxType(x::ASTContext) -> QualType
Return the type of `intmax_t` (C99 7.18.1.5).
"""
function getIntMaxType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getIntMaxType(x))
end

"""
    getBuiltinVaListType(x::ASTContext) -> QualType
Return the type of `__builtin_va_list`.
"""
function getBuiltinVaListType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getBuiltinVaListType(x))
end

"""
    getNSObjectName(x::ASTContext) -> IdentifierInfo
Return the `NSObject` identifier, creating it in the identifier table on first
use.
"""
function getNSObjectName(x::ASTContext)
    @check_ptrs x
    return IdentifierInfo(clang_ASTContext_getNSObjectName(x))
end

"""
    getDefaultCallingConvention(x::ASTContext, is_variadic::Bool, is_cxx_method::Bool,
                                is_builtin::Bool=false) -> CXCallingConv_
Return the target's default calling convention for a function of that shape.
"""
function getDefaultCallingConvention(x::ASTContext, is_variadic::Bool, is_cxx_method::Bool,
                                     is_builtin::Bool=false)
    @check_ptrs x
    return clang_ASTContext_getDefaultCallingConvention(x, is_variadic, is_cxx_method,
                                                        is_builtin)
end

"""
    getCurrentKeyFunction(x::ASTContext, decl::AbstractCXXRecordDecl) -> CXXMethodDecl
Return the class's current key function (Itanium C++ ABI 5.2.3), or a
NULL-pointer `CXXMethodDecl` when the class has none.

The class must have a complete definition.
"""
function getCurrentKeyFunction(x::ASTContext, decl::AbstractCXXRecordDecl)
    @check_ptrs x decl
    @assert getDefinition(decl).ptr != C_NULL "cannot get the key function of a forward declaration"
    return CXXMethodDecl(clang_ASTContext_getCurrentKeyFunction(x, decl))
end

"""
    getInstantiatedFromStaticDataMember(x::ASTContext, decl::AbstractVarDecl) -> MemberSpecializationInfo
Return the specialization info of an instantiated static data member, or a
NULL-pointer `MemberSpecializationInfo` when `decl` is not an instantiated one.

`decl` must be a static data member.
"""
function getInstantiatedFromStaticDataMember(x::ASTContext, decl::AbstractVarDecl)
    @check_ptrs x decl
    @assert isStaticDataMember(decl) "decl must be a static data member"
    msi = clang_ASTContext_getInstantiatedFromStaticDataMember(x, decl)
    return MemberSpecializationInfo(msi)
end

"""
    getLocalCommentForDeclUncached(x::ASTContext, decl::AbstractDecl) -> FullComment
Return the parsed documentation comment attached to `decl` itself — no
redeclaration lookup and no cache — or a NULL-pointer `FullComment` when none is
attached.
"""
function getLocalCommentForDeclUncached(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return FullComment(clang_ASTContext_getLocalCommentForDeclUncached(x, decl))
end

"""
    GetGVALinkageForFunction(x::ASTContext, decl::AbstractFunctionDecl) -> CXGVALinkage
Return the code-generation linkage of a function declaration. The result is only
meaningful for a function definition.
"""
function GetGVALinkageForFunction(x::ASTContext, decl::AbstractFunctionDecl)
    @check_ptrs x decl
    return clang_ASTContext_GetGVALinkageForFunction(x, decl)
end

"""
    GetGVALinkageForVariable(x::ASTContext, decl::AbstractVarDecl) -> CXGVALinkage
Return the code-generation linkage of a variable declaration. The result is only
meaningful for a file-scoped variable definition.
"""
function GetGVALinkageForVariable(x::ASTContext, decl::AbstractVarDecl)
    @check_ptrs x decl
    return clang_ASTContext_GetGVALinkageForVariable(x, decl)
end

"""
    DeclMustBeEmitted(x::ASTContext, decl::AbstractDecl) -> Bool
Return whether `decl` must be code-generated (or deserialized from a PCH) even
when it is never used. Only function and file-scoped variable definitions can
answer `true`.
"""
function DeclMustBeEmitted(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_ASTContext_DeclMustBeEmitted(x, decl)
end

"""
    getInlineVariableDefinitionKind(x::ASTContext, decl::AbstractVarDecl) -> CXInlineVariableDefinitionKind
Return whether a definition of the inline variable `decl` is to be treated as a
weak or a strong definition.
"""
function getInlineVariableDefinitionKind(x::ASTContext, decl::AbstractVarDecl)
    @check_ptrs x decl
    return clang_ASTContext_getInlineVariableDefinitionKind(x, decl)
end

"""
    getCUIDHash(x::ASTContext) -> String
Return the hash of the CUDA/HIP compilation-unit ID, or an empty string when
`-fcuid` was not given.
"""
function getCUIDHash(x::ASTContext)
    @check_ptrs x
    return get_string(clang_ASTContext_getCUIDHash(x))
end


"""
    getSizeType(x::ASTContext) -> QualType
Return the canonical type of `size_t` (C99 7.17) for the target.
"""
function getSizeType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getSizeType(x))
end

"""
    getSignedSizeType(x::ASTContext) -> QualType
Return the canonical signed counterpart of [`getSizeType`](@ref).
"""
function getSignedSizeType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getSignedSizeType(x))
end

"""
    getUIntMaxType(x::ASTContext) -> QualType
Return the canonical type of `uintmax_t` (C99 7.18.1.5) for the target.
"""
function getUIntMaxType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getUIntMaxType(x))
end

"""
    getTypeOfExprType(x::ASTContext, e::AbstractExpr, unqualified::Bool=false) -> QualType
Return the `typeof(e)` type. `unqualified` selects C23's `typeof_unqual` flavour.
"""
function getTypeOfExprType(x::ASTContext, e::AbstractExpr, unqualified::Bool=false)
    @check_ptrs x e
    return QualType(clang_ASTContext_getTypeOfExprType(x, e, unqualified))
end

"""
    getTypeOfType(x::ASTContext, ty::QualType, unqualified::Bool=false) -> QualType
Return the `typeof(ty)` type. `unqualified` selects C23's `typeof_unqual` flavour.
"""
function getTypeOfType(x::ASTContext, ty::QualType, unqualified::Bool=false)
    @check_ptrs x
    return QualType(clang_ASTContext_getTypeOfType(x, ty, unqualified))
end

"""
    getReferenceQualifiedType(x::ASTContext, e::AbstractExpr) -> QualType
Return the type of `e` with its value category folded in, the way `decltype` does it: an
lvalue yields `T&`, an xvalue `T&&`, a prvalue plain `T`.
"""
function getReferenceQualifiedType(x::ASTContext, e::AbstractExpr)
    @check_ptrs x e
    return QualType(clang_ASTContext_getReferenceQualifiedType(x, e))
end

"""
    getUnconstrainedType(x::ASTContext, ty::QualType) -> QualType
Return `ty` with any type-constraint stripped off a top-level `auto`/`decltype(auto)`, as
used when comparing template parameters for equivalence. Types without one come back
unchanged.
"""
function getUnconstrainedType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getUnconstrainedType(x, ty))
end

"""
    getTypeSizeInCharsIfKnown(x::ASTContext, ty::QualType) -> Union{Int64,Nothing}
Return the size of `ty` in bytes, or `nothing` when the size is not known because `ty` is
incomplete or dependent. Unlike [`getTypeSizeInChars`](@ref) this query is total.
"""
function getTypeSizeInCharsIfKnown(x::ASTContext, ty::QualType)
    @check_ptrs x
    size = Ref{Int64}(0)
    return clang_ASTContext_getTypeSizeInCharsIfKnown(x, ty, size) ? size[] : nothing
end

"""
    getTypeInfoDataSizeInChars(x::ASTContext, ty::QualType) -> (width, align, align_requirement)
Like [`getTypeInfoInChars`](@ref), but for a record `width` is the **data size**: the tail
padding a derived class may reuse is excluded. Carries the same non-dependent/complete
precondition on `ty`.
"""
function getTypeInfoDataSizeInChars(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    width = Ref{Int64}(0)
    align = Ref{Int64}(0)
    req = Ref{CXAlignRequirementKind}(CXAlignRequirementKind_None)
    clang_ASTContext_getTypeInfoDataSizeInChars(x, ty, width, align, req)
    return (width[], align[], req[])
end

"""
    overridden_methods_size(x::ASTContext, method::AbstractCXXMethodDecl) -> Int
Return how many C++ methods `method` overrides.
"""
function overridden_methods_size(x::ASTContext, method::AbstractCXXMethodDecl)
    @check_ptrs x method
    return Int(clang_ASTContext_overridden_methods_size(x, method))
end

"""
    getNumOverriddenMethods(x::ASTContext, method::AbstractNamedDecl) -> Int
Return how many methods `method` overrides — the exact length of the vector
[`getOverriddenMethods`](@ref) returns.
"""
function getNumOverriddenMethods(x::ASTContext, method::AbstractNamedDecl)
    @check_ptrs x method
    return Int(clang_ASTContext_getNumOverriddenMethods(x, method))
end

"""
    getOverriddenMethods(x::ASTContext, method::AbstractNamedDecl) -> Vector{NamedDecl}
Return the methods `method` overrides. The decls live in the `ASTContext` arena — there is
no `dispose`.
"""
function getOverriddenMethods(x::ASTContext, method::AbstractNamedDecl)
    @check_ptrs x method
    n = clang_ASTContext_getNumOverriddenMethods(x, method)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_ASTContext_getOverriddenMethods(x, method, buf)
    return [NamedDecl(p) for p in buf]
end

"""
    hasSameExpr(x::ASTContext, a::AbstractExpr, b::AbstractExpr) -> Bool
Return whether the two expressions are equivalent (canonical profile comparison).
"""
function hasSameExpr(x::ASTContext, a::AbstractExpr, b::AbstractExpr)
    @check_ptrs x a b
    return clang_ASTContext_hasSameExpr(x, a, b)
end

"""
    isSameConstraintExpr(x::ASTContext, a::AbstractExpr, b::AbstractExpr) -> Bool
Return whether two constraint expressions are similar enough to appear in
re-declarations of the same template.
"""
function isSameConstraintExpr(x::ASTContext, a::AbstractExpr, b::AbstractExpr)
    @check_ptrs x a b
    return clang_ASTContext_isSameConstraintExpr(x, a, b)
end

"""
    isSameEntity(x::ASTContext, a::AbstractNamedDecl, b::AbstractNamedDecl) -> Bool
Return whether the two declarations refer to the same entity.
"""
function isSameEntity(x::ASTContext, a::AbstractNamedDecl, b::AbstractNamedDecl)
    @check_ptrs x a b
    return clang_ASTContext_isSameEntity(x, a, b)
end

"""
    isSameTemplateParameter(x::ASTContext, a::AbstractNamedDecl, b::AbstractNamedDecl) -> Bool
Return whether two template parameters are similar enough to appear in declarations of the
same template.
"""
function isSameTemplateParameter(x::ASTContext, a::AbstractNamedDecl, b::AbstractNamedDecl)
    @check_ptrs x a b
    return clang_ASTContext_isSameTemplateParameter(x, a, b)
end

"""
    isSameTemplateParameterList(x::ASTContext, a::TemplateParameterList, b::TemplateParameterList) -> Bool
Return whether two template parameter lists are similar enough to appear in declarations of
the same template.
"""
function isSameTemplateParameterList(x::ASTContext, a::TemplateParameterList, b::TemplateParameterList)
    @check_ptrs x a b
    return clang_ASTContext_isSameTemplateParameterList(x, a, b)
end

"""
    isSameDefaultTemplateArgument(x::ASTContext, a::AbstractNamedDecl, b::AbstractNamedDecl) -> Bool
Return whether the default arguments of two template parameters are similar enough to
appear in declarations of the same template.

`a` and `b` must have the same `Decl` kind — Clang asserts it, so the check is restated
here before the ccall.
"""
function isSameDefaultTemplateArgument(x::ASTContext, a::AbstractNamedDecl, b::AbstractNamedDecl)
    @check_ptrs x a b
    @assert getKind(a) == getKind(b) "default-argument comparison needs two decls of the same kind"
    return clang_ASTContext_isSameDefaultTemplateArgument(x, a, b)
end

"""
    getTargetAddressSpace(x::ASTContext, addr_space::CXLangAS=CXLangAS_Default) -> UInt32
Return the target's numeric address space for the language address space `addr_space`.
"""
function getTargetAddressSpace(x::ASTContext, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    return clang_ASTContext_getTargetAddressSpace(x, addr_space)
end

"""
    mayExternalize(x::ASTContext, decl::AbstractDecl) -> Bool
Return whether the C++ static variable or CUDA/HIP kernel `decl` may be externalized.
"""
function mayExternalize(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_ASTContext_mayExternalize(x, decl)
end

"""
    shouldExternalize(x::ASTContext, decl::AbstractDecl) -> Bool
Return whether the C++ static variable or CUDA/HIP kernel `decl` should be externalized.
"""
function shouldExternalize(x::ASTContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_ASTContext_shouldExternalize(x, decl)
end


"""
    getVectorType(x::ASTContext, elt::QualType, num_elts::Integer, kind::CXVectorKind) -> QualType
Build the GCC/target vector type of `num_elts` elements of built-in element type `elt`.
`elt` must be a built-in type (the C++ precondition, restated here as an `@assert`).
"""
function getVectorType(x::ASTContext, elt::QualType, num_elts::Integer, kind::CXVectorKind)
    @check_ptrs x elt
    @assert isBuiltinType(getTypePtr(elt)) "vector element type must be a built-in type"
    return QualType(clang_ASTContext_getVectorType(x, elt, num_elts, kind))
end

"""
    getElaboratedType(x::ASTContext, keyword::CXElaboratedTypeKeyword, nns::NestedNameSpecifier,
                      named::QualType, owned=C_NULL) -> QualType
Build the elaborated-type sugar `keyword nns named` wrapping `named`. `nns` (a
`NestedNameSpecifier`, may wrap `C_NULL`) and `owned` (the owning `TagDecl` of an inline tag
definition, may be `C_NULL`) are optional.
"""
function getElaboratedType(x::ASTContext, keyword::CXElaboratedTypeKeyword,
                           nns::NestedNameSpecifier, named::QualType, owned=C_NULL)
    @check_ptrs x named
    return QualType(clang_ASTContext_getElaboratedType(x, keyword, nns, named, owned))
end

"""
    getPackExpansionType(x::ASTContext, pattern::QualType; num_expansions=nothing,
                         expect_pack::Bool=true) -> QualType
Build the pack-expansion type `pattern...`. `num_expansions` is the fixed expansion count if
known (`nothing` leaves the `std::optional` disengaged, MARSHALLING.md section 8). When
`expect_pack` is `true`, `pattern` must contain an unexpanded parameter pack.
"""
function getPackExpansionType(x::ASTContext, pattern::QualType; num_expansions=nothing,
                              expect_pack::Bool=true)
    @check_ptrs x pattern
    has_num = num_expansions !== nothing
    num = has_num ? UInt32(num_expansions) : UInt32(0)
    return QualType(clang_ASTContext_getPackExpansionType(x, pattern, has_num, num, expect_pack))
end

"""
    getNSUIntegerType(x::ASTContext) -> QualType
Return the target's `NSUInteger` type (the unsigned word integer).
"""
function getNSUIntegerType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getNSUIntegerType(x))
end

"""
    getNSIntegerType(x::ASTContext) -> QualType
Return the target's `NSInteger` type (the signed word integer).
"""
function getNSIntegerType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getNSIntegerType(x))
end

"""
    areCompatibleRVVTypes(x::ASTContext, t1::QualType, t2::QualType) -> Bool
Return whether `t1` and `t2` are a RISC-V RVV sizeless builtin type and a compatible
fixed-length `VectorType` representation of it.
"""
function areCompatibleRVVTypes(x::ASTContext, t1::QualType, t2::QualType)
    @check_ptrs x t1 t2
    return clang_ASTContext_areCompatibleRVVTypes(x, t1, t2)
end

"""
    areLaxCompatibleRVVTypes(x::ASTContext, t1::QualType, t2::QualType) -> Bool
Return whether `t1` and `t2` are lax-compatible RISC-V RVV vector types under
`-flax-vector-conversions=`.
"""
function areLaxCompatibleRVVTypes(x::ASTContext, t1::QualType, t2::QualType)
    @check_ptrs x t1 t2
    return clang_ASTContext_areLaxCompatibleRVVTypes(x, t1, t2)
end


"""
    getTraversalScope(x::ASTContext) -> Vector{Decl}
Return the top-level declarations that bound the AST traversal scope. The scope is the
single translation-unit declaration until `setTraversalScope` narrows it.
"""
function getTraversalScope(x::ASTContext)
    @check_ptrs x
    n = clang_ASTContext_getNumTraversalScopeDecls(x)
    buf = Vector{CXDecl}(undef, n)
    n > 0 && clang_ASTContext_getTraversalScopeDecls(x, buf)
    return [Decl(p) for p in buf]
end

"""
    getCXXABIKind(x::ASTContext) -> CXTargetCXXABI_Kind
Return the C++ ABI that should be used: the one given with `-fc++-abi=` when present, the
target's default otherwise.
"""
function getCXXABIKind(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getCXXABIKind(x)
end

"""
    getDefaultOpenCLPointeeAddrSpace(x::ASTContext) -> CXLangAS
Return the address space an OpenCL pointee gets by default: `opencl_generic` when the
language options enable the generic address space, `opencl_private` otherwise.
"""
function getDefaultOpenCLPointeeAddrSpace(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getDefaultOpenCLPointeeAddrSpace(x)
end

"""
    getCurrentNamedModule(x::ASTContext) -> Module_
Return the C++20 named module under construction. The carrier holds a NULL pointer when
this translation unit is not a named module.
"""
function getCurrentNamedModule(x::ASTContext)
    @check_ptrs x
    return Module_(clang_ASTContext_getCurrentNamedModule(x))
end

"""
    getNumTypes(x::ASTContext) -> Integer
Return how many `clang::Type` nodes this context has created so far.
"""
function getNumTypes(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_getNumTypes(x)
end

"""
    getType(x::ASTContext, i::Integer) -> Type_
Return the `i`-th (0-based) type node this context has created. The result is a base
`Type_` carrier — `resolve` it to refine to the concrete class.
"""
function getType(x::ASTContext, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTypes(x) "type index out of range"
    return Type_(clang_ASTContext_getType(x, i))
end

"""
    getInjectedTemplateArg(x::ASTContext, param::AbstractNamedDecl) -> TemplateArgument
Return the template argument that a template's injected class name uses for `param`.
This function allocates and one should call `dispose` to release the resources after using
this object.

PRECONDITION: `param` must be a template parameter — clang `cast<>`s it to one of the
three template-parameter classes without checking.
"""
function getInjectedTemplateArg(x::ASTContext, param::AbstractNamedDecl)
    @check_ptrs x param
    @assert isTemplateParameter(param) "getInjectedTemplateArg requires a template parameter"
    return TemplateArgument(clang_ASTContext_getInjectedTemplateArg(x, param))
end

"""
    getjmp_bufType(x::ASTContext) -> QualType
Return the C `jmp_buf` type. The QualType is null until Sema has seen `<setjmp.h>` and set
the `jmp_buf` type declaration.
"""
function getjmp_bufType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getjmp_bufType(x))
end

"""
    getsigjmp_bufType(x::ASTContext) -> QualType
Return the C `sigjmp_buf` type. The QualType is null until the `sigjmp_buf` type
declaration has been set.
"""
function getsigjmp_bufType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getsigjmp_bufType(x))
end

"""
    getucontext_tType(x::ASTContext) -> QualType
Return the C `ucontext_t` type. The QualType is null until the `ucontext_t` type
declaration has been set.
"""
function getucontext_tType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getucontext_tType(x))
end

"""
    getNameForTemplate(x::ASTContext, name::TemplateName, loc::SourceLocation) -> DeclarationNameInfo
Return the declaration-name info that names `name` at `loc`.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getNameForTemplate(x::ASTContext, name::TemplateName, loc::SourceLocation)
    @check_ptrs x
    return DeclarationNameInfo(clang_ASTContext_getNameForTemplate(x, name, loc))
end

"""
    UnwrapSimilarTypes(x::ASTContext, t1::QualType, t2::QualType, allow_pi_mismatch::Bool=true)
        -> (Bool, QualType, QualType)
Peel one matching layer of pointer / member-pointer / array / object-pointer structure off
both types. The C++ method takes `T1` and `T2` by reference, so the rewritten types are
returned alongside the flag saying whether a layer was peeled.
"""
function UnwrapSimilarTypes(x::ASTContext, t1::QualType, t2::QualType,
                            allow_pi_mismatch::Bool=true)
    @check_ptrs x t1 t2
    r1 = Ref{CXQualType}(t1.ptr)
    r2 = Ref{CXQualType}(t2.ptr)
    unwrapped = clang_ASTContext_UnwrapSimilarTypes(x, r1, r2, allow_pi_mismatch)
    return unwrapped, QualType(r1[]), QualType(r2[])
end

"""
    UnwrapSimilarArrayTypes(x::ASTContext, t1::QualType, t2::QualType, allow_pi_mismatch::Bool=true)
        -> (QualType, QualType)
Peel matching array layers off both types and return the rewritten types (the C++ method
takes `T1` and `T2` by reference).
"""
function UnwrapSimilarArrayTypes(x::ASTContext, t1::QualType, t2::QualType,
                                 allow_pi_mismatch::Bool=true)
    @check_ptrs x t1 t2
    r1 = Ref{CXQualType}(t1.ptr)
    r2 = Ref{CXQualType}(t2.ptr)
    clang_ASTContext_UnwrapSimilarArrayTypes(x, r1, r2, allow_pi_mismatch)
    return QualType(r1[]), QualType(r2[])
end

"""
    getCanonicalTemplateArgument(x::ASTContext, arg::TemplateArgument) -> TemplateArgument
Return the canonical form of `arg` — the simplest argument expressing the same value.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getCanonicalTemplateArgument(x::ASTContext, arg::TemplateArgument)
    @check_ptrs x arg
    return TemplateArgument(clang_ASTContext_getCanonicalTemplateArgument(x, arg))
end

"""
    getInstantiatedFromUsingEnumDecl(x::ASTContext, inst::AbstractUsingEnumDecl) -> UsingEnumDecl
Return the using-enum declaration `inst` was instantiated from, or a NULL-pointer carrier
when `inst` is not an instantiation of one.
"""
function getInstantiatedFromUsingEnumDecl(x::ASTContext, inst::AbstractUsingEnumDecl)
    @check_ptrs x inst
    return UsingEnumDecl(clang_ASTContext_getInstantiatedFromUsingEnumDecl(x, inst))
 end

"""
    setInstantiatedFromUsingEnumDecl(x::ASTContext, inst::AbstractUsingEnumDecl,
                                     pattern::AbstractUsingEnumDecl)
Record that the using-enum declaration `inst` is an instantiation of `pattern`. `inst`
must not already carry a pattern — clang asserts it, so the getter is checked first.
"""
function setInstantiatedFromUsingEnumDecl(x::ASTContext, inst::AbstractUsingEnumDecl,
                                          pattern::AbstractUsingEnumDecl)
    @check_ptrs x inst pattern
    @assert getInstantiatedFromUsingEnumDecl(x, inst).ptr == C_NULL "`inst` already has an instantiation pattern"
    return clang_ASTContext_setInstantiatedFromUsingEnumDecl(x, inst, pattern)
end

"""
    getNextLocalImport(x::AbstractImportDecl) -> ImportDecl
Return the next import in the translation unit's local import chain, or a NULL-pointer
carrier at the end of the chain. `ImportDecl`'s own accessor is private in clang 18; this
static `ASTContext` entry point is the only path to it.
"""
function getNextLocalImport(x::AbstractImportDecl)
    @check_ptrs x
    return ImportDecl(clang_ASTContext_getNextLocalImport(x))
end

"""
    getOpenCLTypeKind(x::ASTContext, ty::AbstractType) -> CXOpenCLTypeKind
Return the OpenCL type family `ty` belongs to. Every type that is not one of OpenCL's
opaque builtins — so every ordinary C/C++ type — maps to `CXOpenCLTypeKind_OCLTK_Default`.
"""
function getOpenCLTypeKind(x::ASTContext, ty::AbstractType)
    @check_ptrs x ty
    return clang_ASTContext_getOpenCLTypeKind(x, ty)
end

"""
    getOpenCLTypeAddrSpace(x::ASTContext, ty::AbstractType) -> CXLangAS
Return the address space the target assigns to `ty`'s OpenCL type family.
"""
function getOpenCLTypeAddrSpace(x::ASTContext, ty::AbstractType)
    @check_ptrs x ty
    return clang_ASTContext_getOpenCLTypeAddrSpace(x, ty)
end

"""
    getVariableArrayType(x::ASTContext, elt::QualType, num_elts::AbstractExpr,
                         brackets::SourceRange) -> QualType
Build a `VariableArrayType` of `elt` sized by `num_elts`. The size expression is stored on
the type, never evaluated, and the result is deliberately non-unique — one fresh type node
per call, matching the C++ API.
"""
function getVariableArrayType(x::ASTContext, elt::QualType, num_elts::AbstractExpr,
                              brackets::SourceRange,
                              asm::CXArraySizeModifier=CXArraySizeModifier_Normal,
                              index_type_quals::Integer=0)
    @check_ptrs x num_elts
    r = CXSourceRange_(brackets.begin_loc.ptr, brackets.end_loc.ptr)
    return QualType(clang_ASTContext_getVariableArrayType(x, elt, num_elts, asm,
                                                          index_type_quals, r))
end

"""
    getDependentSizedArrayType(x::ASTContext, elt::QualType, num_elts::AbstractExpr,
                               brackets::SourceRange) -> QualType
Build a `DependentSizedArrayType` of `elt` sized by the dependent expression `num_elts`.
Also non-unique — one fresh type node per call.
"""
function getDependentSizedArrayType(x::ASTContext, elt::QualType, num_elts::AbstractExpr,
                                    brackets::SourceRange,
                                    asm::CXArraySizeModifier=CXArraySizeModifier_Normal,
                                    index_type_quals::Integer=0)
    @check_ptrs x num_elts
    r = CXSourceRange_(brackets.begin_loc.ptr, brackets.end_loc.ptr)
    return QualType(clang_ASTContext_getDependentSizedArrayType(x, elt, num_elts, asm,
                                                                index_type_quals, r))
end

"""
    getDependentVectorType(x::ASTContext, vec::QualType, size_expr::AbstractExpr,
                           attr_loc::SourceLocation) -> QualType
Build a `DependentVectorType`: a vector of `vec` whose element count is the dependent
expression `size_expr`, spelled at `attr_loc`.
"""
function getDependentVectorType(x::ASTContext, vec::QualType, size_expr::AbstractExpr,
                                attr_loc::SourceLocation,
                                kind::CXVectorKind=CXVectorKind_Generic)
    @check_ptrs x size_expr
    return QualType(clang_ASTContext_getDependentVectorType(x, vec, size_expr, attr_loc,
                                                            kind))
end

"""
    getUsingType(x::ASTContext, found::AbstractUsingShadowDecl,
                 underlying::QualType) -> QualType
Build the `UsingType` sugar that names `underlying` through the using-declaration shadow
`found`.

PRECONDITION, documented but not asserted — the C API exposes no cheap proxy for it:
`found`'s target declaration must be a `TypeDecl` (clang casts it unchecked) and
`underlying` must be unqualified and canonically identical to that declaration's type
(clang asserts both). Calling this with any other pair is undefined behaviour.
"""
function getUsingType(x::ASTContext, found::AbstractUsingShadowDecl, underlying::QualType)
    @check_ptrs x found
    return QualType(clang_ASTContext_getUsingType(x, found, underlying))
end

"""
    getUnresolvedUsingType(x::ASTContext, decl::AbstractUnresolvedUsingTypenameDecl) -> QualType
Build — and cache on `decl` — the `UnresolvedUsingType` of a dependent
`using typename T::x;` declaration.
"""
function getUnresolvedUsingType(x::ASTContext, decl::AbstractUnresolvedUsingTypenameDecl)
    @check_ptrs x decl
    return QualType(clang_ASTContext_getUnresolvedUsingType(x, decl))
end

"""
    getUnaryTransformType(x::ASTContext, base::QualType, underlying::QualType,
                          kind::CXUTTKind) -> QualType
Build the type of a unary type transform (`__underlying_type` and the
`__add_*`/`__remove_*` family): `base` is the operand, `underlying` the transformed
result. A dependent `base` yields a `DependentUnaryTransformType` instead.
"""
function getUnaryTransformType(x::ASTContext, base::QualType, underlying::QualType,
                               kind::CXUTTKind)
    @check_ptrs x
    return QualType(clang_ASTContext_getUnaryTransformType(x, base, underlying, kind))
end

"""
    getQualifiedTemplateName(x::ASTContext, nns::NestedNameSpecifier, template_keyword::Bool,
                             name::TemplateName) -> TemplateName
Build the qualified spelling `nns::[template] name`. `template_keyword` records whether
the `template` keyword was written.
"""
function getQualifiedTemplateName(x::ASTContext, nns::NestedNameSpecifier,
                                  template_keyword::Bool, name::TemplateName)
    @check_ptrs x nns
    return TemplateName(clang_ASTContext_getQualifiedTemplateName(x, nns, template_keyword,
                                                                  name))
end

"""
    DumpRecordLayout(x::ASTContext, decl::AbstractRecordDecl, simple=false) -> String
Return clang's record-layout dump for `decl` — the text `-fdump-record-layouts` prints.
`simple` selects the one-line form. The record must have a complete definition.
"""
function DumpRecordLayout(x::ASTContext, decl::AbstractRecordDecl, simple::Bool=false)
    @check_ptrs x decl
    @assert getDefinition(decl).ptr != C_NULL "cannot dump the layout of a forward declaration"
    return get_string(clang_ASTContext_DumpRecordLayout(x, decl, simple))
end

"""
    getMemberPointerPathAdjustment(x::ASTContext, mp::APValue) -> Integer
Return, in bytes, the `this` adjustment implied by the inheritance path of the member
pointer `mp`. `mp` must hold a member pointer.
"""
function getMemberPointerPathAdjustment(x::ASTContext, mp::APValue)
    @check_ptrs x mp
    @assert getKind(mp) == CXAPValueKind_MemberPointer "the value must be a member pointer"
    return clang_ASTContext_getMemberPointerPathAdjustment(x, mp)
end

"""
    getArrayInitLoopExprElementCount(x::ASTContext, e::AbstractArrayInitLoopExpr) -> Integer
Return the number of elements the implicit initialization loop `e` covers — the loop clang
synthesizes for array copy-initialization and for array captures of a lambda.
"""
function getArrayInitLoopExprElementCount(x::ASTContext, e::AbstractArrayInitLoopExpr)
    @check_ptrs x e
    return clang_ASTContext_getArrayInitLoopExprElementCount(x, e)
end

"""
    MakeIntValue(x::ASTContext, value::Integer, ty::QualType) -> LLVMGenericValueRef
Return `value` as an `APSInt` of `ty`'s width and signedness, boxed in a caller-owned
`LLVMGenericValueRef` (release via LLVM-C's `LLVMDisposeGenericValue`; no Julia `dispose`
method exists for it). `ty` must be a complete integral or enumeration type.
"""
function MakeIntValue(x::ASTContext, value::Integer, ty::QualType)
    @check_ptrs x
    tp = get_type_ptr(ty)
    @assert isIntegerType(tp) || isEnumeralType(tp) "an integral or enumeration type is required"
    return clang_ASTContext_MakeIntValue(x, value, ty)
end


"""
    setTraversalScope(x::ASTContext, decls::AbstractVector{<:AbstractDecl})
Narrow the AST traversal scope to `decls` — the top-level declarations `getTraversalScope`
reports and the parent map is computed over. The handles are copied into the context and the
cached parent map is cleared. Passing `[getTranslationUnitDecl(x)]` restores the default.
"""
function setTraversalScope(x::ASTContext, decls::AbstractVector{<:AbstractDecl})
    @check_ptrs x
    @assert all(d -> d.ptr != C_NULL, decls) "every declaration in the scope must be non-NULL"
    buf = CXDecl[d.ptr for d in decls]
    return clang_ASTContext_setTraversalScope(x, buf, length(buf))
end

"""
    getRealTypeForBitwidth(x::ASTContext, width::Integer, kind::CXFloatModeKind) -> QualType
Return the target's floating-point type that is `width` bits wide in the `kind` mode, or a
null `QualType` when the target has no such type (the documented "none" answer, not an
error).
"""
function getRealTypeForBitwidth(x::ASTContext, width::Integer, kind::CXFloatModeKind)
    @check_ptrs x
    return QualType(clang_ASTContext_getRealTypeForBitwidth(x, width, kind))
end

"""
    getFirstLocalImport(x::ASTContext) -> ImportDecl
Return the head of this translation unit's local import chain, or an `ImportDecl` wrapping
`C_NULL` when nothing has been imported. Walk the rest of the chain with
`getNextLocalImport`.
"""
function getFirstLocalImport(x::ASTContext)
    @check_ptrs x
    return ImportDecl(clang_ASTContext_getFirstLocalImport(x))
end

"""
    getCanonicalTemplateSpecializationType(x::ASTContext, name::TemplateName,
                                          args::Vector{TemplateArgument}) -> QualType
Build the canonical `name<args...>` specialization type. `name` must already be canonical
(restated here as an `@assert` against `getCanonicalTemplateName`) and so must every element
of `args` — canonicalise them with `getCanonicalTemplateArgument` first, since this entry
point builds the canonical node directly and does not canonicalise its inputs.
"""
function getCanonicalTemplateSpecializationType(x::ASTContext, name::TemplateName,
                                                args::Vector{TemplateArgument})
    @check_ptrs x name
    @assert getCanonicalTemplateName(x, name).ptr == name.ptr "the template name must be canonical"
    ptrs = CXTemplateArgument[a.ptr for a in args]
    return QualType(clang_ASTContext_getCanonicalTemplateSpecializationType(x, name, ptrs,
                                                                           length(ptrs)))
end

"""
    getDependentNameType(x::ASTContext, keyword::CXElaboratedTypeKeyword,
                         nns::NestedNameSpecifier, name::IdentifierInfo,
                         canon::QualType=QualType(C_NULL)) -> QualType
Build the dependent type `keyword nns::name` — the node behind `typename T::type` and its
relatives. `canon` is the canonical type when it is already known; leave it null to let clang
compute it.
"""
function getDependentNameType(x::ASTContext, keyword::CXElaboratedTypeKeyword,
                              nns::NestedNameSpecifier, name::IdentifierInfo,
                              canon::QualType=QualType(C_NULL))
    @check_ptrs x nns name
    return QualType(clang_ASTContext_getDependentNameType(x, keyword, nns, name, canon))
end

"""
    getObjCConstantStringInterface(x::ASTContext) -> QualType
Return the type recorded for Objective-C's `NSConstantString` interface, or a null `QualType`
when none was recorded — which is always the case for a C++ translation unit.
"""
function getObjCConstantStringInterface(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCConstantStringInterface(x))
end

"""
    getObjCNSStringType(x::ASTContext) -> QualType
Return the type recorded for Objective-C's `NSString`, or a null `QualType` when
`setObjCNSStringType` has not been called.
"""
function getObjCNSStringType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCNSStringType(x))
end

"""
    setObjCNSStringType(x::ASTContext, T::QualType)
Record `T` as this context's Objective-C `NSString` type. A null `QualType` clears it.
"""
function setObjCNSStringType(x::ASTContext, T::QualType)
    @check_ptrs x
    return clang_ASTContext_setObjCNSStringType(x, T)
end

"""
    getObjCSelRedefinitionType(x::ASTContext) -> QualType
Return the user-written type that redefines `SEL`, falling back to the built-in `SEL` type
when none was recorded. The fallback materialises the implicit `SEL` typedef in the
translation unit.
"""
function getObjCSelRedefinitionType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCSelRedefinitionType(x))
end

"""
    setObjCSelRedefinitionType(x::ASTContext, T::QualType)
Record `T` as the user-written redefinition of `SEL`.
"""
function setObjCSelRedefinitionType(x::ASTContext, T::QualType)
    @check_ptrs x
    return clang_ASTContext_setObjCSelRedefinitionType(x, T)
end

"""
    getObjCIdDecl(x::ASTContext) -> TypedefDecl
Return the predefined Objective-C `id` typedef. The first call builds the implicit typedef
into the translation unit, so this getter mutates the AST; it never returns NULL.
"""
function getObjCIdDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getObjCIdDecl(x))
end

"""
    getObjCIdType(x::ASTContext) -> QualType
Return the type named by the predefined Objective-C `id` typedef, materialising that typedef
on first use.
"""
function getObjCIdType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCIdType(x))
end

"""
    getObjCSelDecl(x::ASTContext) -> TypedefDecl
Return the predefined Objective-C `SEL` typedef. The first call builds the implicit typedef
into the translation unit, so this getter mutates the AST; it never returns NULL.
"""
function getObjCSelDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getObjCSelDecl(x))
end

"""
    getObjCSelType(x::ASTContext) -> QualType
Return the type named by the predefined Objective-C `SEL` typedef, materialising that typedef
on first use.
"""
function getObjCSelType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCSelType(x))
end

"""
    getObjCClassDecl(x::ASTContext) -> TypedefDecl
Return the predefined Objective-C `Class` typedef. The first call builds the implicit typedef
into the translation unit, so this getter mutates the AST; it never returns NULL.
"""
function getObjCClassDecl(x::ASTContext)
    @check_ptrs x
    return TypedefDecl(clang_ASTContext_getObjCClassDecl(x))
end

"""
    getObjCClassType(x::ASTContext) -> QualType
Return the type named by the predefined Objective-C `Class` typedef, materialising that
typedef on first use.
"""
function getObjCClassType(x::ASTContext)
    @check_ptrs x
    return QualType(clang_ASTContext_getObjCClassType(x))
end

"""
    getUnqualifiedObjCPointerType(x::ASTContext, T::QualType) -> QualType
Return `T` with its Objective-C lifetime qualifier removed. Anything that is not a
lifetime-qualified Objective-C pointer comes back unchanged.
"""
function getUnqualifiedObjCPointerType(x::ASTContext, T::QualType)
    @check_ptrs x T
    return QualType(clang_ASTContext_getUnqualifiedObjCPointerType(x, T))
end

"""
    isObjCIdType(x::ASTContext, T::QualType) -> Bool
Return whether `T` — looked through one layer of elaborated-type sugar — is this context's
predefined Objective-C `id` type. Distinct from `isObjCIdType(::AbstractType)`, which asks
the `Type` node itself.
"""
function isObjCIdType(x::ASTContext, T::QualType)
    @check_ptrs x T
    return clang_ASTContext_isObjCIdType(x, T)
end

"""
    isObjCClassType(x::ASTContext, T::QualType) -> Bool
Return whether `T` — looked through one layer of elaborated-type sugar — is this context's
predefined Objective-C `Class` type.
"""
function isObjCClassType(x::ASTContext, T::QualType)
    @check_ptrs x T
    return clang_ASTContext_isObjCClassType(x, T)
end

"""
    isObjCSelType(x::ASTContext, T::QualType) -> Bool
Return whether `T` — looked through one layer of elaborated-type sugar — is this context's
predefined Objective-C `SEL` type.
"""
function isObjCSelType(x::ASTContext, T::QualType)
    @check_ptrs x T
    return clang_ASTContext_isObjCSelType(x, T)
end


"""
    getNumModulesWithMergedDefinition(x::ASTContext, def::AbstractNamedDecl) -> Integer
Return how many additional modules the definition `def` has been merged into. Always 0
outside a modules build.
"""
function getNumModulesWithMergedDefinition(x::ASTContext, def::AbstractNamedDecl)
    @check_ptrs x def
    return clang_ASTContext_getNumModulesWithMergedDefinition(x, def)
end

"""
    getModulesWithMergedDefinition(x::ASTContext, def::AbstractNamedDecl) -> Vector{Module_}
Return the additional modules the definition `def` has been merged into -- empty outside a
modules build. The carriers borrow `clang::Module` objects owned by the module map, so they
are never `dispose`d.
"""
function getModulesWithMergedDefinition(x::ASTContext, def::AbstractNamedDecl)
    @check_ptrs x def
    n = clang_ASTContext_getNumModulesWithMergedDefinition(x, def)
    return [Module_(clang_ASTContext_getModuleWithMergedDefinition(x, def, i)) for i = 0:(n - 1)]
end

"""
    getAutoType(x::ASTContext, deduced::QualType, keyword::CXAutoTypeKeyword,
                is_dependent::Bool, is_pack::Bool=false,
                concept_decl::ConceptDecl=ConceptDecl(C_NULL),
                args::Vector{TemplateArgument}=TemplateArgument[]) -> QualType
Build the C++11 deduced `auto` type. A null `deduced` builds the undeduced `auto`
placeholder; `concept_decl` may wrap `C_NULL` for an unconstrained `auto`, and `args`
carries the type constraint's template arguments as a handle buffer (MARSHALLING.md §11).
AutoTypes are uniqued, so the same arguments always hand back the same node.
"""
function getAutoType(x::ASTContext, deduced::QualType, keyword::CXAutoTypeKeyword,
                     is_dependent::Bool, is_pack::Bool=false,
                     concept_decl::ConceptDecl=ConceptDecl(C_NULL),
                     args::Vector{TemplateArgument}=TemplateArgument[])
    @check_ptrs x
    @assert !is_pack || is_dependent "a pack `auto` is inherently dependent"
    ptrs = CXTemplateArgument[a.ptr for a in args]
    return QualType(clang_ASTContext_getAutoType(x, deduced, keyword, is_dependent, is_pack,
                                                 concept_decl, ptrs, length(ptrs)))
end

"""
    setObjCSuperType(x::ASTContext, ty::QualType)
Set this context's cached type for Objective-C's `struct objc_super`. Plain field
assignment; [`getObjCSuperType`](@ref) builds the implicit record on first use only while
the field is still null.
"""
function setObjCSuperType(x::ASTContext, ty::QualType)
    @check_ptrs x
    return clang_ASTContext_setObjCSuperType(x, ty)
end

"""
    getObjCEncodingForType(x::ASTContext, ty::QualType) -> String
Return the Objective-C `@encode` string of `ty`. The encoder is not Objective-C specific --
`int` encodes as `"i"` in a C++ translation unit too.

`ty` must be non-dependent and every record or enum type it reaches must be complete: the
encoder lays records out eagerly.
"""
function getObjCEncodingForType(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    @assert !isDependentType(getTypePtr(ty)) "@encode requires a non-dependent type"
    return get_string(clang_ASTContext_getObjCEncodingForType(x, ty))
end

"""
    getObjCEncodingForPropertyType(x::ASTContext, ty::QualType) -> String
Return the `@encode` string Clang uses for an Objective-C property of type `ty`. Differs
from [`getObjCEncodingForType`](@ref) only in the encoder options, and carries the same
non-dependent/complete precondition on `ty`.
"""
function getObjCEncodingForPropertyType(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    @assert !isDependentType(getTypePtr(ty)) "@encode requires a non-dependent type"
    return get_string(clang_ASTContext_getObjCEncodingForPropertyType(x, ty))
end

"""
    getLegacyIntegralTypeEncoding(x::ASTContext, ty::QualType) -> QualType
Apply the legacy encoder's GCC-compatibility rewrite to `ty`: a typedef of a 32-bit `long`
or `unsigned long` comes back as `int`/`unsigned int`. Every other type is returned
unchanged.
"""
function getLegacyIntegralTypeEncoding(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    return QualType(clang_ASTContext_getLegacyIntegralTypeEncoding(x, ty))
end

"""
    getObjCEncodingForFunctionDecl(x::ASTContext, fd::AbstractFunctionDecl) -> String
Return the `@encode` string of `fd`'s signature: the return type, then the parameters with
their byte offsets. The offsets are target-decided.

Every type in the signature must be non-dependent and complete, as for
[`getObjCEncodingForType`](@ref).
"""
function getObjCEncodingForFunctionDecl(x::ASTContext, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return get_string(clang_ASTContext_getObjCEncodingForFunctionDecl(x, fd))
end

"""
    getObjCEncodingTypeSize(x::ASTContext, ty::QualType) -> Int64
Return the size of `ty` in bytes for `@encode` purposes: `sizeof`, except that integral and
enumeration types are widened to at least the width of `int`. `ty` must be non-dependent
and complete.
"""
function getObjCEncodingTypeSize(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    @assert !isDependentType(getTypePtr(ty)) "type layout queries require a non-dependent type"
    return clang_ASTContext_getObjCEncodingTypeSize(x, ty)
end

"""
    isObjCNSObjectType(ty::QualType) -> Bool
Return whether `ty` is a typedef of an Objective-C object pointer (`NSObject` and friends).
This is `ASTContext`'s static forwarder -- it takes no context. Distinct from
`isObjCNSObjectType(::AbstractType)`, which asks the `Type` node itself.
"""
function isObjCNSObjectType(ty::QualType)
    @check_ptrs ty
    return clang_ASTContext_isObjCNSObjectType(ty)
end

"""
    areComparableObjCPointerTypes(x::ASTContext, lhs::QualType, rhs::QualType) -> Bool
Return whether `lhs` and `rhs` are Objective-C object pointer types assignable in either
direction. Total: a non-Objective-C operand simply yields `false`.
"""
function areComparableObjCPointerTypes(x::ASTContext, lhs::QualType, rhs::QualType)
    @check_ptrs x lhs rhs
    return clang_ASTContext_areComparableObjCPointerTypes(x, lhs, rhs)
end

"""
    AnyObjCImplementation(x::ASTContext) -> Bool
Return whether the translation unit contains at least one Objective-C `@implementation`.
"""
function AnyObjCImplementation(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_AnyObjCImplementation(x)
end


"""
    cloneFullComment(x::ASTContext, fc::AbstractFullComment, d::AbstractDecl) -> FullComment
Return a copy of `fc`'s comment blocks attached to `d`, carrying `d`'s own `DeclInfo`. The
clone lives in the `ASTContext` arena — there is no `dispose`.

`fc` must be non-null: clang dereferences it to reach the blocks it copies.
"""
function cloneFullComment(x::ASTContext, fc::AbstractFullComment, d::AbstractDecl)
    @check_ptrs x fc d
    return FullComment(clang_ASTContext_cloneFullComment(x, fc, d))
end

"""
    setInstantiatedFromStaticDataMember(x::ASTContext, inst::AbstractVarDecl, tmpl::AbstractVarDecl,
                                        tsk::CXTemplateSpecializationKind,
                                        point_of_instantiation::SourceLocation=SourceLocation(C_NULL))
Note that the static data member `inst` is an instantiation of the static data member
template `tmpl`, instantiated in the manner `tsk` at `point_of_instantiation`.

Clang asserts four preconditions, all restated here: both decls must be static data
members, `inst` must not already carry a recorded pattern (neither arm of the union — a
`MemberSpecializationInfo` nor a described `VarTemplateDecl`), and `tsk` must not be
`CXTemplateSpecializationKind_TSK_Undeclared`, which `MemberSpecializationInfo` cannot
encode.
"""
function setInstantiatedFromStaticDataMember(x::ASTContext, inst::AbstractVarDecl,
                                             tmpl::AbstractVarDecl,
                                             tsk::CXTemplateSpecializationKind,
                                             point_of_instantiation::SourceLocation=SourceLocation(C_NULL))
    @check_ptrs x inst tmpl
    @assert isStaticDataMember(inst) "inst must be a static data member"
    @assert isStaticDataMember(tmpl) "tmpl must be a static data member"
    @assert tsk != CXTemplateSpecializationKind_TSK_Undeclared "tsk must name a specialization kind, not TSK_Undeclared"
    @assert getInstantiatedFromStaticDataMember(x, inst).ptr == C_NULL "inst already has a recorded instantiation pattern"
    @assert getDescribedVarTemplate(inst).ptr == C_NULL "inst already describes a variable template"
    return clang_ASTContext_setInstantiatedFromStaticDataMember(x, inst, tmpl, tsk,
                                                                point_of_instantiation)
end

"""
    buildBuiltinTemplateDecl(x::ASTContext, btk::CXBuiltinTemplateKind,
                             ii::AbstractIdentifierInfo) -> BuiltinTemplateDecl
Build the `BuiltinTemplateDecl` for `btk` under the name `ii` and add it to the translation
unit — the same construction `getMakeIntegerSeqDecl` and `getTypePackElementDecl` use for
theirs. The decl is `ASTContext` arena memory, so there is no `dispose`.
"""
function buildBuiltinTemplateDecl(x::ASTContext, btk::CXBuiltinTemplateKind,
                                  ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return BuiltinTemplateDecl(clang_ASTContext_buildBuiltinTemplateDecl(x, btk, ii))
end

"""
    getObjCGCQualType(x::ASTContext, ty::QualType, gc::CXQualifiers_GC) -> QualType
Return the uniqued type carrying the union of `ty`'s qualifiers and the Objective-C
garbage-collection attribute `gc`.

`gc` must not be `CXQualifiers_GCNone` (`Qualifiers::addObjCGCAttr` asserts it names an
attribute) and `ty` must not already carry a GC attribute ("Type cannot have multiple
ObjCGCQualifiers"); both are restated as assertions here.
"""
function getObjCGCQualType(x::ASTContext, ty::QualType, gc::CXQualifiers_GC)
    @check_ptrs x
    @assert !isNull(ty) "QualType must not be null"
    @assert gc != CXQualifiers_GCNone "gc must name an attribute to add, not CXQualifiers_GCNone"
    @assert getObjCGCAttr(ty) == CXQualifiers_GCNone "type already carries a GC attribute"
    return QualType(clang_ASTContext_getObjCGCQualType(x, ty, gc))
end

"""
    getLifetimeQualifiedType(x::ASTContext, ty::QualType,
                             lifetime::CXQualifiers_ObjCLifetime) -> QualType
Return `ty` with the ARC lifetime qualifier `lifetime` added.

`lifetime` must not be `CXQualifiers_OCL_None` and `ty` must not already carry a lifetime —
clang asserts both, and both are restated as assertions here.
"""
function getLifetimeQualifiedType(x::ASTContext, ty::QualType,
                                  lifetime::CXQualifiers_ObjCLifetime)
    @check_ptrs x
    @assert !isNull(ty) "QualType must not be null"
    @assert lifetime != CXQualifiers_OCL_None "lifetime must name a lifetime to add, not CXQualifiers_OCL_None"
    @assert getObjCLifetime(ty) == CXQualifiers_OCL_None "type already carries an ARC lifetime"
    return QualType(clang_ASTContext_getLifetimeQualifiedType(x, ty, lifetime))
end

"""
    GetBuiltinType(x::ASTContext, id::Integer) -> (type, error, integer_constant_args)
Return the type of the builtin `id`, why it could not be built, and the bitmask of the
builtin's arguments that must be integer constant expressions.

`type` is a null `QualType` whenever `error` is not `CXGetBuiltinTypeError_GE_None` — that
is how clang reports a builtin whose signature names a type this translation unit has not
declared (`FILE`, `jmp_buf`, `ucontext_t`).

`id` must be a builtin ID obtained from [`getBuiltinID`](@ref) (on an `IdentifierInfo` or a
`FunctionDecl`); clang indexes its builtin table with it unchecked, so only the `0` case —
"not a builtin" — can be rejected here.
"""
function GetBuiltinType(x::ASTContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "id must be a builtin ID from getBuiltinID; 0 means the entity is not a builtin"
    err = Ref{CXGetBuiltinTypeError}(CXGetBuiltinTypeError_GE_None)
    integer_constant_args = Ref{Cuint}(0)
    ty = clang_ASTContext_GetBuiltinType(x, Cuint(id), err, integer_constant_args)
    return (QualType(ty), err[], integer_constant_args[])
end

"""
    getObjCGCAttrKind(x::ASTContext, ty::QualType) -> CXQualifiers_GC
Return the Objective-C garbage-collection attribute `ty` behaves as having. Outside an
Objective-C garbage-collected translation unit — every C and C++ one — the method returns
`CXQualifiers_GCNone` through its own early return.
"""
function getObjCGCAttrKind(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isNull(ty) "QualType must not be null"
    return clang_ASTContext_getObjCGCAttrKind(x, ty)
end

"""
    getInnerObjCOwnership(x::ASTContext, ty::QualType) -> CXQualifiers_ObjCLifetime
Recurse through `ty`'s pointer, array and reference layers until a retainable type is found
and return its ARC lifetime; `CXQualifiers_OCL_None` when there is none.
"""
function getInnerObjCOwnership(x::ASTContext, ty::QualType)
    @check_ptrs x
    @assert !isNull(ty) "QualType must not be null"
    return clang_ASTContext_getInnerObjCOwnership(x, ty)
end


"""
    addModuleInitializer(x::ASTContext, m::AbstractModule, init::AbstractDecl)
Record `init` as a declaration to run when module `m` is initialized -- typically a
module-scope variable whose initializer must run on import, or an `ImportDecl` nominating
another module. The context keys the list on the module pointer and owns neither handle.
"""
function addModuleInitializer(x::ASTContext, m::AbstractModule, init::AbstractDecl)
    @check_ptrs x m init
    return clang_ASTContext_addModuleInitializer(x, m, init)
end

"""
    getNumModuleInitializers(x::ASTContext, m::AbstractModule) -> Integer
Return how many initializers have been recorded for module `m` -- 0 for a module nothing was
recorded against.
"""
function getNumModuleInitializers(x::ASTContext, m::AbstractModule)
    @check_ptrs x m
    return clang_ASTContext_getNumModuleInitializers(x, m)
end

"""
    getModuleInitializers(x::ASTContext, m::AbstractModule) -> Vector{Decl}
Return the declarations to run when module `m` is imported, in registration order -- empty
for a module that has none. The carriers are base `Decl`s borrowed from the context arena;
`castTo*` them to refine.
"""
function getModuleInitializers(x::ASTContext, m::AbstractModule)
    @check_ptrs x m
    n = clang_ASTContext_getNumModuleInitializers(x, m)
    return [Decl(clang_ASTContext_getModuleInitializer(x, m, i)) for i in 0:(n - 1)]
end

"""
    getByrefLifetime(x::ASTContext, ty::QualType) -> Union{Nothing,Tuple}
Return `(lifetime, has_byref_extended_layout)` when `ty` has a known ARC lifetime for a
`__block` capture, and `nothing` when it has none -- the answer for every translation unit
that is not Objective-C under ARC, so always `nothing` for C++.
"""
function getByrefLifetime(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    lifetime = Ref{CXQualifiers_ObjCLifetime}(CXQualifiers_OCL_None)
    extended = Ref{Bool}(false)
    return clang_ASTContext_getByrefLifetime(x, ty, lifetime, extended) ?
           (lifetime[], extended[]) : nothing
end

"""
    getDependentTemplateSpecializationType(x::ASTContext, keyword::CXElaboratedTypeKeyword,
                                           nns::NestedNameSpecifier, name::IdentifierInfo,
                                           args::Vector{TemplateArgument}) -> QualType
Build the dependent type `keyword nns::name<args...>` -- the node behind
`typename T::template X<int>` and its relatives. The node is uniqued on the whole quadruple,
so rebuilding it from the same pieces hands back the same type.
"""
function getDependentTemplateSpecializationType(x::ASTContext,
                                                keyword::CXElaboratedTypeKeyword,
                                                nns::NestedNameSpecifier,
                                                name::IdentifierInfo,
                                                args::Vector{TemplateArgument})
    @check_ptrs x nns name
    ptrs = CXTemplateArgument[a.ptr for a in args]
    return QualType(clang_ASTContext_getDependentTemplateSpecializationType(x, keyword, nns,
                                                                            name, ptrs,
                                                                            length(ptrs)))
end

"""
    getFloatTypeSemanticsPrecision(x::ASTContext, ty::QualType) -> Integer
Return the mantissa precision, in bits, of the `llvm::fltSemantics` clang uses for the
floating-point type `ty` (24 for IEEE single, 53 for IEEE double).

PRECONDITION: `ty` must be a real (non-complex) floating builtin type -- clang `castAs`es it
to a `BuiltinType` and `llvm_unreachable`s on every other kind.
"""
function getFloatTypeSemanticsPrecision(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    @assert isRealFloatingType(getTypePtr(ty)) "float semantics need a real floating-point type"
    return clang_ASTContext_getFloatTypeSemanticsPrecision(x, ty)
end

"""
    getFloatTypeSemanticsSizeInBits(x::ASTContext, ty::QualType) -> Integer
Return the total width, in bits, of the `llvm::fltSemantics` clang uses for the
floating-point type `ty` -- the size of the format itself, which for `long double` on x86 is
the 80 bits of the format rather than the 128 bits the ABI allocates for it.

PRECONDITION: `ty` must be a real (non-complex) floating builtin type -- clang `castAs`es it
to a `BuiltinType` and `llvm_unreachable`s on every other kind.
"""
function getFloatTypeSemanticsSizeInBits(x::ASTContext, ty::QualType)
    @check_ptrs x ty
    @assert isRealFloatingType(getTypePtr(ty)) "float semantics need a real floating-point type"
    return clang_ASTContext_getFloatTypeSemanticsSizeInBits(x, ty)
end

"""
    setjmp_bufDecl(x::ASTContext, D::AbstractTypeDecl)
Record `D` as the declaration of the C `jmp_buf` type, which is what [`getjmp_bufType`](@ref)
reads. Sema calls this when it declares a typedef literally named `jmp_buf`.
"""
function setjmp_bufDecl(x::ASTContext, D::AbstractTypeDecl)
    @check_ptrs x D
    return clang_ASTContext_setjmp_bufDecl(x, D)
end

"""
    setsigjmp_bufDecl(x::ASTContext, D::AbstractTypeDecl)
Record `D` as the declaration of the C `sigjmp_buf` type, which is what
[`getsigjmp_bufType`](@ref) reads.
"""
function setsigjmp_bufDecl(x::ASTContext, D::AbstractTypeDecl)
    @check_ptrs x D
    return clang_ASTContext_setsigjmp_bufDecl(x, D)
end

"""
    setucontext_tDecl(x::ASTContext, D::AbstractTypeDecl)
Record `D` as the declaration of the C `ucontext_t` type, which is what
[`getucontext_tType`](@ref) reads.
"""
function setucontext_tDecl(x::ASTContext, D::AbstractTypeDecl)
    @check_ptrs x D
    return clang_ASTContext_setucontext_tDecl(x, D)
end


"""
    getTemplateOrSpecializationInfoAsVarTemplate(x::ASTContext, var::AbstractVarDecl) -> VarTemplateDecl
Return the variable template `var` is the pattern of, or a NULL-pointer `VarTemplateDecl`
when the context records no such link.

This is one arm of the `PointerUnion` `ASTContext::getTemplateOrSpecializationInfo` returns;
[`getTemplateOrSpecializationInfoAsMemberSpecialization`](@ref) is the other. Unlike
[`getInstantiatedFromStaticDataMember`](@ref) it is total — `var` need not be a static data
member.
"""
function getTemplateOrSpecializationInfoAsVarTemplate(x::ASTContext, var::AbstractVarDecl)
    @check_ptrs x var
    return VarTemplateDecl(clang_ASTContext_getTemplateOrSpecializationInfoAsVarTemplate(x, var))
end

"""
    getTemplateOrSpecializationInfoAsMemberSpecialization(x::ASTContext, var::AbstractVarDecl) -> MemberSpecializationInfo
Return the specialization info recorded for the instantiated static data member `var`, or a
NULL-pointer `MemberSpecializationInfo` when the context records no such link.

This is the other arm of the `PointerUnion`
[`getTemplateOrSpecializationInfoAsVarTemplate`](@ref) reads; it is total, where
[`getInstantiatedFromStaticDataMember`](@ref) requires `var` to be a static data member.
"""
function getTemplateOrSpecializationInfoAsMemberSpecialization(x::ASTContext,
                                                               var::AbstractVarDecl)
    @check_ptrs x var
    msi = clang_ASTContext_getTemplateOrSpecializationInfoAsMemberSpecialization(x, var)
    return MemberSpecializationInfo(msi)
end

"""
    getInjectedTemplateArgs(x::ASTContext, params::TemplateParameterList) -> Vector{TemplateArgument}
Return one injected template argument per parameter of `params`, in order — the arguments
that stand for the parameters inside the template's own definition, as in an injected class
name.

Every element is an **owned** heap box: `dispose` each one. That is the opposite of the
same-named method on a `RedeclarableTemplateDecl`, whose carriers borrow the array Clang
caches on the template's shared common state and must never be disposed.
"""
function getInjectedTemplateArgs(x::ASTContext, params::TemplateParameterList)
    @check_ptrs x params
    n = size(params)
    buf = Vector{CXTemplateArgument}(undef, n)
    n > 0 && clang_ASTContext_getInjectedTemplateArgs(x, params, buf)
    return [TemplateArgument(p) for p in buf]
end

"""
    getMSGuidDecl(x::ASTContext, part1::Integer, part2::Integer, part3::Integer,
                  part4and5::AbstractVector{UInt8}) -> MSGuidDecl
Return the uniqued global GUID object for `{part1-part2-part3-part4and5}` — the declaration
a `__uuidof` expression designates. `part4and5` must supply exactly 8 bytes.

The translation unit must carry the implicit `_GUID` record, which clang builds only under
Microsoft extensions; the assertion below is what keeps this off a null tag declaration.
"""
function getMSGuidDecl(x::ASTContext, part1::Integer, part2::Integer, part3::Integer,
                       part4and5::AbstractVector{UInt8})
    @check_ptrs x
    @assert length(part4and5) == 8 "a GUID's fourth and fifth parts are eight bytes"
    @assert getMSGuidTagDecl(x).ptr != C_NULL "the translation unit has no `_GUID` record"
    buf = collect(UInt8, part4and5)
    return MSGuidDecl(clang_ASTContext_getMSGuidDecl(x, UInt32(part1), UInt16(part2),
                                                     UInt16(part3), buf))
end

"""
    getUnnamedGlobalConstantDecl(x::ASTContext, ty::QualType, value::APValue) -> UnnamedGlobalConstantDecl
Return the uniqued anonymous global constant of type `ty` holding `value`. The declaration
is ASTContext-arena memory (no `dispose`) and joins no `DeclContext`'s lookup table, so
building one does not perturb name lookup.
"""
function getUnnamedGlobalConstantDecl(x::ASTContext, ty::QualType, value::APValue)
    @check_ptrs x ty value
    ugc = clang_ASTContext_getUnnamedGlobalConstantDecl(x, ty, value)
    return UnnamedGlobalConstantDecl(ugc)
end

"""
    getTemplateParamObjectDecl(x::ASTContext, ty::QualType, value::APValue) -> TemplateParamObjectDecl
Return the template parameter object of type `ty` holding `value` — the static storage
duration object a class-type non-type template argument denotes. Uniqued on the
`(type, value)` pair.

`ty` must be a record type.
"""
function getTemplateParamObjectDecl(x::ASTContext, ty::QualType, value::APValue)
    @check_ptrs x ty value
    @assert isRecordType(getTypePtr(ty)) "a template parameter object needs a class type"
    return TemplateParamObjectDecl(clang_ASTContext_getTemplateParamObjectDecl(x, ty, value))
end

"""
    isAlignRequired(kind::CXAlignRequirementKind) -> Bool
Report whether an alignment reported by [`getTypeInfo`](@ref) and its `InChars` siblings was
required by an `alignas`/`__attribute__((aligned))` or by a typedef, rather than being the
type's natural ABI alignment.

This is the accessor `clang::TypeInfo` and `clang::TypeInfoChars` both spell
`isAlignRequired`. Both structs cross the boundary as the out-param triples those getters
return, so one method over the shared enum covers the pair.
"""
isAlignRequired(kind::CXAlignRequirementKind) = kind != CXAlignRequirementKind_None


"""
    setTemplateOrSpecializationInfoAsVarTemplate(x::ASTContext, inst::AbstractVarDecl,
                                                 tmpl::AbstractVarTemplateDecl)
Record that `inst` is the pattern of the variable template `tmpl`. This is the
`VarTemplateDecl` arm of the union [`getTemplateOrSpecializationInfoAsVarTemplate`](@ref)
reads; the `MemberSpecializationInfo` arm is written by
[`setInstantiatedFromStaticDataMember`](@ref), which builds the info object itself.

`inst` must not already carry either arm — clang asserts it, so both getters are checked
here first.
"""
function setTemplateOrSpecializationInfoAsVarTemplate(x::ASTContext, inst::AbstractVarDecl,
                                                      tmpl::AbstractVarTemplateDecl)
    @check_ptrs x inst tmpl
    @assert getTemplateOrSpecializationInfoAsVarTemplate(x, inst).ptr == C_NULL "inst already describes a variable template"
    @assert getTemplateOrSpecializationInfoAsMemberSpecialization(x, inst).ptr == C_NULL "inst already has a recorded instantiation pattern"
    return clang_ASTContext_setTemplateOrSpecializationInfoAsVarTemplate(x, inst, tmpl)
end

"""
    adjustFunctionType(x::ASTContext, fn::AbstractFunctionType, cc::CXCallingConv_,
                       noreturn::Bool, produces_result::Bool) -> Type_
Rebuild `fn` with a different `FunctionType::ExtInfo`. Only the calling convention and the
`noreturn` / `ns_returns_retained` bits cross; every other `ExtInfo` field is carried over
from `fn` itself. Asking for the `ExtInfo` `fn` already has hands `fn` back unchanged.

The result is a `FunctionProtoType` or a `FunctionNoProtoType` mirroring `fn`'s own class,
so it comes back at the `Type_` base — `resolve` it to refine the carrier.
"""
function adjustFunctionType(x::ASTContext, fn::AbstractFunctionType, cc::CXCallingConv_,
                            noreturn::Bool, produces_result::Bool)
    @check_ptrs x fn
    return Type_(clang_ASTContext_adjustFunctionType(x, fn, cc, noreturn, produces_result))
end

"""
    getFunctionTypeWithExceptionSpec(x::ASTContext, orig::QualType,
                                     est::CXExceptionSpecificationType) -> QualType
Return `orig` rewritten with the exception specification `est`, preserving the type sugar a
function declaration may carry.

Only the specifications that need no further payload can be requested — `EST_None`,
`EST_DynamicNone`, `EST_MSAny`, `EST_NoThrow` and `EST_BasicNoexcept`; the others need an
exception type list, a noexcept expression or a source declaration that this entry point
cannot carry. `orig` must also be a function prototype type: clang reaches its
`FunctionProtoType` through an unchecked `castAs` once the "already matches" fast path
misses.
"""
function getFunctionTypeWithExceptionSpec(x::ASTContext, orig::QualType,
                                          est::CXExceptionSpecificationType)
    @check_ptrs x orig
    @assert est in (CXExceptionSpecificationType_EST_None,
                    CXExceptionSpecificationType_EST_DynamicNone,
                    CXExceptionSpecificationType_EST_MSAny,
                    CXExceptionSpecificationType_EST_NoThrow,
                    CXExceptionSpecificationType_EST_BasicNoexcept) "est must be an exception specification that carries no expression, type list or source declaration"
    @assert isFunctionProtoType(getTypePtr(orig)) "orig must be a function prototype type"
    return QualType(clang_ASTContext_getFunctionTypeWithExceptionSpec(x, orig, est))
end

"""
    adjustExceptionSpec(x::ASTContext, fd::AbstractFunctionDecl,
                        est::CXExceptionSpecificationType, as_written::Bool=false)
Rewrite `fd`'s type with the exception specification `est`, and its written type source info
too when `as_written` is true. Same restriction on `est` as
[`getFunctionTypeWithExceptionSpec`](@ref), which this runs on `fd`'s own type — so `fd`
must have a function prototype type.
"""
function adjustExceptionSpec(x::ASTContext, fd::AbstractFunctionDecl,
                             est::CXExceptionSpecificationType, as_written::Bool=false)
    @check_ptrs x fd
    @assert est in (CXExceptionSpecificationType_EST_None,
                    CXExceptionSpecificationType_EST_DynamicNone,
                    CXExceptionSpecificationType_EST_MSAny,
                    CXExceptionSpecificationType_EST_NoThrow,
                    CXExceptionSpecificationType_EST_BasicNoexcept) "est must be an exception specification that carries no expression, type list or source declaration"
    @assert isFunctionProtoType(getTypePtr(getType(fd))) "fd must have a function prototype type"
    return clang_ASTContext_adjustExceptionSpec(x, fd, est, as_written)
end

"""
    getSubstTemplateTypeParmType(x::ASTContext, replacement::QualType,
                                 associated::AbstractDecl, index::Integer,
                                 pack_index::Union{Nothing,Integer}=nothing) -> QualType
Build the `SubstTemplateTypeParmType` standing for "parameter `index` of `associated`,
substituted by `replacement`". `pack_index` is the `std::optional<unsigned>` clang takes:
`nothing` leaves it disengaged. The node is uniqued on the whole tuple.

`associated` must own a template parameter list with more than `index` entries — the
replaced parameter is fetched from it unchecked by later accessors. The C API exposes no
cheap proxy for that, so it is documented rather than asserted.
"""
function getSubstTemplateTypeParmType(x::ASTContext, replacement::QualType,
                                      associated::AbstractDecl, index::Integer,
                                      pack_index::Union{Nothing,Integer}=nothing)
    @check_ptrs x replacement associated
    has_pack_index = pack_index !== nothing
    return QualType(clang_ASTContext_getSubstTemplateTypeParmType(x, replacement, associated,
                                                                  index, has_pack_index,
                                                                  has_pack_index ? pack_index : 0))
end

"""
    getSubstTemplateTypeParmPackType(x::ASTContext, associated::AbstractDecl,
                                     index::Integer, final::Bool,
                                     argpack::TemplateArgument) -> QualType
Build the `SubstTemplateTypeParmPackType` standing for "pack parameter `index` of
`associated`, substituted by `argpack`". `argpack` must be a pack argument whose elements
are all type arguments; the resulting type borrows the pack's element array, which lives in
the context's own memory. `associated` carries the same documented precondition as
[`getSubstTemplateTypeParmType`](@ref).
"""
function getSubstTemplateTypeParmPackType(x::ASTContext, associated::AbstractDecl,
                                          index::Integer, final::Bool,
                                          argpack::TemplateArgument)
    @check_ptrs x associated argpack
    @assert getKind(argpack) == CXTemplateArgument_Pack "argpack must be a pack argument"
    n = Int(pack_size(argpack))
    @assert all(i -> getKind(getPackElement(argpack, i)) == CXTemplateArgument_Type, 0:(n - 1)) "every element of argpack must be a type argument"
    return QualType(clang_ASTContext_getSubstTemplateTypeParmPackType(x, associated, index,
                                                                      final, argpack))
end

"""
    getTemplateSpecializationTypeInfo(x::ASTContext, name::TemplateName,
                                      loc::SourceLocation,
                                      args::TemplateArgumentListInfo,
                                      canon::QualType=QualType(C_NULL)) -> TypeSourceInfo
Build the `TypeSourceInfo` for `name<args...>` — the specialization type together with the
written locations, taking the angle brackets and the per-argument location info from `args`.
`canon` may stay null, in which case clang computes the canonical type itself, but it must
be given for a type alias template.

`name` must resolve to a single template: a dependent or unresolved (overloaded / assumed)
template name cannot be canonicalised here.
"""
function getTemplateSpecializationTypeInfo(x::ASTContext, name::TemplateName,
                                           loc::SourceLocation,
                                           args::TemplateArgumentListInfo,
                                           canon::QualType=QualType(C_NULL))
    @check_ptrs x name args
    @assert getAsDependentTemplateName(name).ptr == C_NULL "name must not be a dependent template name"
    td = getAsTemplateDecl(name)
    @assert td.ptr != C_NULL "name must resolve to a single template declaration"
    @assert canon.ptr != C_NULL || getDeclKindName(td) != "TypeAliasTemplate" "an alias template needs its underlying type as canon"
    return TypeSourceInfo(clang_ASTContext_getTemplateSpecializationTypeInfo(x, name, loc,
                                                                             args, canon))
end

"""
    getOverloadedTemplateName(x::ASTContext, decls::Vector{<:AbstractNamedDecl}) -> TemplateName
Build the `TemplateName` standing for an unresolved set of overloaded template candidates.
At least two candidates are required — clang asserts the set is overloaded. The candidates
are copied into the context's own memory, so `decls` need not outlive the call.
"""
function getOverloadedTemplateName(x::ASTContext, decls::Vector{<:AbstractNamedDecl})
    @check_ptrs x
    @assert length(decls) > 1 "an overloaded template name needs at least two candidates"
    @assert all(d -> d.ptr != C_NULL, decls) "every candidate must be non-NULL"
    ptrs = CXNamedDecl[d.ptr for d in decls]
    return TemplateName(clang_ASTContext_getOverloadedTemplateName(x, ptrs, length(ptrs)))
end

"""
    getSubstTemplateTemplateParm(x::ASTContext, replacement::TemplateName,
                                 associated::AbstractDecl, index::Integer,
                                 pack_index::Union{Nothing,Integer}=nothing) -> TemplateName
The template-name counterpart of [`getSubstTemplateTypeParmType`](@ref): the name standing
for "template template parameter `index` of `associated`, substituted by `replacement`".
`pack_index` is the optional pack index, `nothing` leaving it disengaged, and `associated`
carries the same documented precondition.
"""
function getSubstTemplateTemplateParm(x::ASTContext, replacement::TemplateName,
                                      associated::AbstractDecl, index::Integer,
                                      pack_index::Union{Nothing,Integer}=nothing)
    @check_ptrs x replacement associated
    has_pack_index = pack_index !== nothing
    return TemplateName(clang_ASTContext_getSubstTemplateTemplateParm(x, replacement,
                                                                      associated, index,
                                                                      has_pack_index,
                                                                      has_pack_index ? pack_index : 0))
end

"""
    getSubstTemplateTemplateParmPack(x::ASTContext, argpack::TemplateArgument,
                                     associated::AbstractDecl, index::Integer,
                                     final::Bool) -> TemplateName
The template-name counterpart of [`getSubstTemplateTypeParmPackType`](@ref). `argpack` must
be a pack argument — its size and element pointer are read unchecked — and the resulting
name borrows that element array.
"""
function getSubstTemplateTemplateParmPack(x::ASTContext, argpack::TemplateArgument,
                                          associated::AbstractDecl, index::Integer,
                                          final::Bool)
    @check_ptrs x argpack associated
    @assert getKind(argpack) == CXTemplateArgument_Pack "argpack must be a pack argument"
    return TemplateName(clang_ASTContext_getSubstTemplateTemplateParmPack(x, argpack,
                                                                          associated, index,
                                                                          final))
end

"""
    getNumFunctionFeatures(x::ASTContext, fd::AbstractFunctionDecl) -> UInt32
Return the size of the target feature map clang computes for `fd` — the target's baseline
features adjusted by `fd`'s own `target` / `target_clones` attributes. The map is rebuilt on
every call, so index `i` names the same feature in [`getFunctionFeature`](@ref).
"""
function getNumFunctionFeatures(x::ASTContext, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_ASTContext_getNumFunctionFeatures(x, fd)
end

"""
    getFunctionFeature(x::ASTContext, fd::AbstractFunctionDecl, i::Integer) -> (String, Bool)
Return the `i`-th entry of `fd`'s target feature map as a `(name, enabled)` pair. `i` must be
less than [`getNumFunctionFeatures`](@ref) — the index is unchecked on the C side.
"""
function getFunctionFeature(x::ASTContext, fd::AbstractFunctionDecl, i::Integer)
    @check_ptrs x fd
    @assert 0 <= i < getNumFunctionFeatures(x, fd) "feature index out of range"
    enabled = Ref{Bool}(false)
    name = get_string(clang_ASTContext_getFunctionFeature(x, fd, i, enabled))
    return name, enabled[]
end
