#ifndef LLVM_CLANG_C_EXTRA_CXQUALTYPE_H
#define LLVM_CLANG_C_EXTRA_CXQUALTYPE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXQualType clang_QualType_constructFromTypePtr(CXType_ Ptr, unsigned Quals);

CXType_ clang_QualType_getTypePtr(CXQualType OpaquePtr);

CXType_ clang_QualType_getTypePtrOrNull(CXQualType OpaquePtr);

bool clang_QualType_isCanonical(CXQualType OpaquePtr);

bool clang_QualType_isNull(CXQualType OpaquePtr);

bool clang_QualType_isConstQualified(CXQualType OpaquePtr);
bool clang_QualType_isRestrictQualified(CXQualType OpaquePtr);
bool clang_QualType_isVolatileQualified(CXQualType OpaquePtr);

bool clang_QualType_hasQualifiers(CXQualType OpaquePtr);

CXQualType clang_QualType_withConst(CXQualType OpaquePtr);
CXQualType clang_QualType_withVolatile(CXQualType OpaquePtr);
CXQualType clang_QualType_withRestrict(CXQualType OpaquePtr);

CXQualType clang_QualType_addConst(CXQualType OpaquePtr);
CXQualType clang_QualType_addVolatile(CXQualType OpaquePtr);
CXQualType clang_QualType_addRestrict(CXQualType OpaquePtr);

bool clang_QualType_isLocalConstQualified(CXQualType OpaquePtr);
bool clang_QualType_isLocalRestrictQualified(CXQualType OpaquePtr);
bool clang_QualType_isLocalVolatileQualified(CXQualType OpaquePtr);

bool clang_QualType_hasLocalQualifiers(CXQualType OpaquePtr);

unsigned clang_QualType_getCVRQualifiers(CXQualType OpaquePtr);

CXString clang_QualType_getAsString(CXQualType OpaquePtr);

void clang_QualType_dump(CXQualType OpaquePtr);

CXQualType clang_QualType_getCanonicalType(CXQualType OpaquePtr);

CXQualType clang_QualType_getLocalUnqualifiedType(CXQualType OpaquePtr);

CXQualType clang_QualType_getUnqualifiedType(CXQualType OpaquePtr);

// Type
bool clang_Type_isFromAST(CXType_ T);

// containsUnexpandedParameterPack

bool clang_Type_isCanonicalUnqualified(CXType_ T);

// getLocallyUnqualifiedSingleStepDesugaredType

bool clang_Type_isSizelessType(CXType_ T);

bool clang_Type_isSizelessBuiltinType(CXType_ T);

// isSVESizelessBuiltinType

// isRVVSizelessBuiltinType

// isWebAssemblyExternrefType

// isWebAssemblyTableType

// isVLSTBuiltinType

// getSveEltType

// isRVVVLSBuiltinType

// getRVVEltType

// isIncompleteType

// isIncompleteOrObjectType

// isObjectType

// isLiteralType

// isStructuralType

// isStandardLayoutType

bool clang_Type_isBuiltinType(CXType_ T);

// isSpecificBuiltinType

// isPlaceholderType

// getAsPlaceholderType

// isSpecificPlaceholderType

// isNonOverloadPlaceholderType

bool clang_Type_isIntegerType(CXType_ T);

bool clang_Type_isEnumeralType(CXType_ T);

bool clang_Type_isScopedEnumeralType(CXType_ T);

bool clang_Type_isBooleanType(CXType_ T);

bool clang_Type_isCharType(CXType_ T);

bool clang_Type_isWideCharType(CXType_ T);

bool clang_Type_isChar8Type(CXType_ T);

bool clang_Type_isChar16Type(CXType_ T);

bool clang_Type_isChar32Type(CXType_ T);

bool clang_Type_isAnyCharacterType(CXType_ T);

// isIntegralType

bool clang_Type_isIntegralOrEnumerationType(CXType_ T);

bool clang_Type_isIntegralOrUnscopedEnumerationType(CXType_ T);

bool clang_Type_isUnscopedEnumerationType(CXType_ T);

bool clang_Type_isRealFloatingType(CXType_ T);

bool clang_Type_isComplexType(CXType_ T);

bool clang_Type_isAnyComplexType(CXType_ T);

bool clang_Type_isFloatingType(CXType_ T);

bool clang_Type_isHalfType(CXType_ T);

bool clang_Type_isFloat16Type(CXType_ T);

bool clang_Type_isBFloat16Type(CXType_ T);

bool clang_Type_isFloat128Type(CXType_ T);

// isIbm128Type

bool clang_Type_isRealType(CXType_ T);

bool clang_Type_isArithmeticType(CXType_ T);

bool clang_Type_isVoidType(CXType_ T);

bool clang_Type_isScalarType(CXType_ T);

bool clang_Type_isAggregateType(CXType_ T);

bool clang_Type_isFundamentalType(CXType_ T);

bool clang_Type_isCompoundType(CXType_ T);

bool clang_Type_isFunctionType(CXType_ T);

bool clang_Type_isFunctionNoProtoType(CXType_ T);

bool clang_Type_isFunctionProtoType(CXType_ T);

bool clang_Type_isPointerType(CXType_ T);

bool clang_Type_isAnyPointerType(CXType_ T);

bool clang_Type_isBlockPointerType(CXType_ T);

bool clang_Type_isVoidPointerType(CXType_ T);

bool clang_Type_isReferenceType(CXType_ T);

bool clang_Type_isLValueReferenceType(CXType_ T);

bool clang_Type_isRValueReferenceType(CXType_ T);

bool clang_Type_isObjectPointerType(CXType_ T);

bool clang_Type_isFunctionPointerType(CXType_ T);

bool clang_Type_isFunctionReferenceType(CXType_ T);

bool clang_Type_isMemberPointerType(CXType_ T);

bool clang_Type_isMemberFunctionPointerType(CXType_ T);

bool clang_Type_isMemberDataPointerType(CXType_ T);

bool clang_Type_isArrayType(CXType_ T);

bool clang_Type_isConstantArrayType(CXType_ T);

bool clang_Type_isIncompleteArrayType(CXType_ T);

bool clang_Type_isVariableArrayType(CXType_ T);

bool clang_Type_isDependentSizedArrayType(CXType_ T);

bool clang_Type_isRecordType(CXType_ T);

bool clang_Type_isClassType(CXType_ T);

bool clang_Type_isStructureType(CXType_ T);

bool clang_Type_isObjCBoxableRecordType(CXType_ T);

bool clang_Type_isInterfaceType(CXType_ T);

bool clang_Type_isStructureOrClassType(CXType_ T);

bool clang_Type_isUnionType(CXType_ T);

bool clang_Type_isComplexIntegerType(CXType_ T);

bool clang_Type_isVectorType(CXType_ T);

bool clang_Type_isExtVectorType(CXType_ T);

// isExtVectorBoolType

bool clang_Type_isMatrixType(CXType_ T);

bool clang_Type_isConstantMatrixType(CXType_ T);

bool clang_Type_isDependentAddressSpaceType(CXType_ T);

// isObjCObjectPointerType

// isObjCRetainableType

// isObjCLifetimeType

// isObjCIndirectLifetimeType

// isObjCNSObjectType

// isObjCIndependentClassType

// isObjCObjectType

// isObjCQualifiedInterfaceType

// isObjCQualifiedIdType

// isObjCQualifiedClassType

// isObjCObjectOrInterfaceType

// isObjCIdType

bool clang_Type_isDecltypeType(CXType_ T);

// isObjCInertUnsafeUnretainedType

// isObjCIdOrObjectKindOfType

// isObjCClassType

// isObjCClassOrClassKindOfType

// isBlockCompatibleObjCPointerType

// isObjCSelType

// isObjCBuiltinType

// isObjCARCBridgableType

// isCARCBridgableType

bool clang_Type_isTemplateTypeParmType(CXType_ T);

bool clang_Type_isNullPtrType(CXType_ T);

bool clang_Type_isNothrowT(CXType_ T);

bool clang_Type_isAlignValT(CXType_ T);

bool clang_Type_isStdByteType(CXType_ T);

bool clang_Type_isAtomicType(CXType_ T);

bool clang_Type_isUndeducedAutoType(CXType_ T);

bool clang_Type_isTypedefNameType(CXType_ T);

// clang/Basic/OpenCLImageTypes.def

// isImageType

// isSamplerT

// isEventT

// isClkEventT

// isQueueT

// isReserveIDT

// clang/Basic/OpenCLExtensionTypes.def

// isOCLIntelSubgroupAVCType

// isOCLExtOpaqueType

// isPipeType

// isBitIntType

// isOpenCLSpecificType

// isObjCARCImplicitlyUnretainedType

// isCUDADeviceBuiltinSurfaceType

// isCUDADeviceBuiltinTextureType

// isRVVType

// containsErrors

bool clang_Type_isDependentType(CXType_ T);

bool clang_Type_isInstantiationDependentType(CXType_ T);

bool clang_Type_isUndeducedType(CXType_ T);

bool clang_Type_isVariablyModifiedType(CXType_ T);

bool clang_Type_hasSizedVLAType(CXType_ T);

bool clang_Type_hasUnnamedOrLocalType(CXType_ T);

bool clang_Type_isOverloadableType(CXType_ T);

bool clang_Type_isElaboratedTypeSpecifier(CXType_ T);

bool clang_Type_canDecayToPointerType(CXType_ T);

bool clang_Type_hasPointerRepresentation(CXType_ T);

bool clang_Type_hasObjCPointerRepresentation(CXType_ T);

bool clang_Type_hasIntegerRepresentation(CXType_ T);

bool clang_Type_hasSignedIntegerRepresentation(CXType_ T);

bool clang_Type_hasUnsignedIntegerRepresentation(CXType_ T);

bool clang_Type_hasFloatingRepresentation(CXType_ T);

CXRecordType clang_Type_getAsStructureType(CXType_ T);

CXRecordType clang_Type_getAsUnionType(CXType_ T);

CXComplexType clang_Type_getAsComplexIntegerType(CXType_ T);

// getAsObjCInterfaceType

// getAsObjCInterfacePointerType

// getAsObjCQualifiedIdType

// getAsObjCQualifiedClassType

// getAsObjCQualifiedInterfaceType

CXCXXRecordDecl clang_Type_getAsCXXRecordDecl(CXType_ T);

CXRecordDecl clang_Type_getAsRecordDecl(CXType_ T);

CXTagDecl clang_Type_getAsTagDecl(CXType_ T);

CXCXXRecordDecl clang_Type_getPointeeCXXRecordDecl(CXType_ T);

CXDeducedType clang_Type_getContainedDeducedType(CXType_ T);

// getContainedAutoType

bool clang_Type_hasAutoForTrailingReturnType(CXType_ T);

// getAsArrayTypeUnsafe

// castAsArrayTypeUnsafe

// hasAttr

// getBaseElementTypeUnsafe

CXType_ clang_Type_getArrayElementTypeNoTypeQual(CXType_ T);

CXType_ clang_Type_getPointeeOrArrayElementType(CXType_ T);

CXQualType clang_Type_getPointeeType(CXType_ T);

CXType_ clang_Type_getUnqualifiedDesugaredType(CXType_ T);

bool clang_Type_isSignedIntegerType(CXType_ T);

bool clang_Type_isUnsignedIntegerType(CXType_ T);

bool clang_Type_isSignedIntegerOrEnumerationType(CXType_ T);

bool clang_Type_isUnsignedIntegerOrEnumerationType(CXType_ T);

bool clang_Type_isFixedPointType(CXType_ T);

bool clang_Type_isFixedPointOrIntegerType(CXType_ T);

bool clang_Type_isSaturatedFixedPointType(CXType_ T);

bool clang_Type_isUnsaturatedFixedPointType(CXType_ T);

bool clang_Type_isSignedFixedPointType(CXType_ T);

bool clang_Type_isUnsignedFixedPointType(CXType_ T);

bool clang_Type_isConstantSizeType(CXType_ T);

bool clang_Type_isSpecifierType(CXType_ T);

// getLinkage

// getVisibility

bool clang_Type_isVisibilityExplicit(CXType_ T);

// getLinkageAndVisibility

bool clang_Type_isLinkageValid(CXType_ T);

// getNullability

// canHaveNullability

// acceptsObjCTypeParams

// getresolveName

CXQualType clang_Type_getCanonicalTypeInternal(CXType_ T);

void clang_Type_dump(CXType_ T);

// isa
bool clang_isa_PointerType(CXType_ T);

bool clang_isa_ReferenceType(CXType_ T);

bool clang_isa_ArrayType(CXType_ T);

bool clang_isa_UnresolvedUsingType(CXType_ T);

bool clang_isa_UsingType(CXType_ T);

bool clang_isa_TypedefType(CXType_ T);

bool clang_isa_DecltypeType(CXType_ T);

bool clang_isa_DependentDecltypeType(CXType_ T);

bool clang_isa_TagType(CXType_ T);

bool clang_isa_RecordType(CXType_ T);

bool clang_isa_EnumType(CXType_ T);

bool clang_isa_TemplateTypeParmType(CXType_ T);

bool clang_isa_SubstTemplateTypeParmType(CXType_ T);

bool clang_isa_SubstTemplateTypeParmPackType(CXType_ T);

bool clang_isa_DeducedType(CXType_ T);

bool clang_isa_AutoType(CXType_ T);

bool clang_isa_DeducedTemplateSpecializationType(CXType_ T);

bool clang_isa_TemplateSpecializationType(CXType_ T);

bool clang_isa_ElaboratedType(CXType_ T);

bool clang_isa_DependentNameType(CXType_ T);

bool clang_isa_DependentTemplateSpecializationType(CXType_ T);

// BuiltinTypes
bool clang_isa_BuiltinType_Void(CXType_ T);

bool clang_isa_BuiltinType_Bool(CXType_ T);

bool clang_isa_BuiltinType_Char_U(CXType_ T);

bool clang_isa_BuiltinType_UChar(CXType_ T);

bool clang_isa_BuiltinType_WChar_U(CXType_ T);

bool clang_isa_BuiltinType_Char8(CXType_ T);

bool clang_isa_BuiltinType_Char16(CXType_ T);

bool clang_isa_BuiltinType_Char32(CXType_ T);

bool clang_isa_BuiltinType_UShort(CXType_ T);

bool clang_isa_BuiltinType_UInt(CXType_ T);

bool clang_isa_BuiltinType_ULong(CXType_ T);

bool clang_isa_BuiltinType_ULongLong(CXType_ T);

bool clang_isa_BuiltinType_UInt128(CXType_ T);

bool clang_isa_BuiltinType_Char_S(CXType_ T);

bool clang_isa_BuiltinType_SChar(CXType_ T);

bool clang_isa_BuiltinType_WChar_S(CXType_ T);

bool clang_isa_BuiltinType_Short(CXType_ T);

bool clang_isa_BuiltinType_Int(CXType_ T);

bool clang_isa_BuiltinType_Long(CXType_ T);

bool clang_isa_BuiltinType_LongLong(CXType_ T);

bool clang_isa_BuiltinType_Int128(CXType_ T);

bool clang_isa_BuiltinType_Half(CXType_ T);

bool clang_isa_BuiltinType_Float(CXType_ T);

bool clang_isa_BuiltinType_Double(CXType_ T);

bool clang_isa_BuiltinType_LongDouble(CXType_ T);

bool clang_isa_BuiltinType_Float16(CXType_ T);

bool clang_isa_BuiltinType_BFloat16(CXType_ T);

bool clang_isa_BuiltinType_Float128(CXType_ T);

bool clang_isa_BuiltinType_NullPtr(CXType_ T);

// ComplexType
CXQualType clang_ComplexType_getElementType(CXComplexType T);

bool clang_ComplexType_isSugared(CXComplexType T);

CXQualType clang_ComplexType_desugar(CXComplexType T);

// ParenType
CXQualType clang_ParenType_getInnerType(CXParenType T);

bool clang_ParenType_isSugared(CXParenType T);

CXQualType clang_ParenType_desugar(CXParenType T);

// PointerType
CXQualType clang_PointerType_getPointeeType(CXPointerType T);

bool clang_PointerType_isSugared(CXPointerType T);

CXQualType clang_PointerType_desugar(CXPointerType T);

// AdjustedType
CXQualType clang_AdjustedType_getOriginalType(CXAdjustedType T);

CXQualType clang_AdjustedType_getAdjustedType(CXAdjustedType T);

bool clang_AdjustedType_isSugared(CXAdjustedType T);

CXQualType clang_AdjustedType_desugar(CXAdjustedType T);

// DecayedType
CXQualType clang_DecayedType_getDecayedType(CXDecayedType T);

CXQualType clang_DecayedType_getPointeeType(CXDecayedType T);

// ReferenceType
bool clang_ReferenceType_isSpelledAsLValue(CXReferenceType T);

bool clang_ReferenceType_isInnerRef(CXReferenceType T);

CXQualType clang_ReferenceType_getPointeeTypeAsWritten(CXReferenceType T);

CXQualType clang_ReferenceType_getPointeeType(CXReferenceType T);

// LValueReferenceType
bool clang_LValueReferenceType_isSugared(CXLValueReferenceType T);

CXQualType clang_LValueReferenceType_desugar(CXLValueReferenceType T);

// RValueReferenceType
bool clang_RValueReferenceType_isSugared(CXRValueReferenceType T);

CXQualType clang_RValueReferenceType_desugar(CXRValueReferenceType T);

// MemberPointerType
CXQualType clang_MemberPointerType_getPointeeType(CXMemberPointerType T);

bool clang_MemberPointerType_isMemberFunctionPointer(CXMemberPointerType T);

bool clang_MemberPointerType_isMemberDataPointer(CXMemberPointerType T);

CXType_ clang_MemberPointerType_getClass(CXMemberPointerType T);

CXCXXRecordDecl clang_MemberPointerType_getMostRecentCXXRecordDecl(CXMemberPointerType T);

bool clang_MemberPointerType_isSugared(CXMemberPointerType T);

CXQualType clang_MemberPointerType_desugar(CXMemberPointerType T);

// ArrayType
typedef enum CXArraySizeModifier {
  CXArraySizeModifier_Normal,
  CXArraySizeModifier_Static,
  CXArraySizeModifier_Star
} CXArraySizeModifier;

CXQualType clang_ArrayType_getElementType(CXArrayType T);

CXArraySizeModifier clang_ArrayType_getSizeModifier(CXArrayType T);

// CXQualifiers clang_ArrayType_getIndexTypeQualifiers(CXArrayType T);

unsigned clang_ArrayType_getIndexTypeCVRQualifiers(CXArrayType T);

// ConstantArrayType
// getSize
CXExpr clang_ConstantArrayType_getSizeExpr(CXConstantArrayType T);

bool clang_ConstantArrayType_isSugared(CXConstantArrayType T);

CXQualType clang_ConstantArrayType_desugar(CXConstantArrayType T);

unsigned clang_ConstantArrayType_getNumAddressingBits(CXConstantArrayType T,
                                                      CXASTContext C);

// IncompleteArrayType
bool clang_IncompleteArrayType_isSugared(CXIncompleteArrayType T);

CXQualType clang_IncompleteArrayType_desugar(CXIncompleteArrayType T);

// VariableArrayType
CXExpr clang_VariableArrayType_getSizeExpr(CXVariableArrayType T);

bool clang_VariableArrayType_isSugared(CXVariableArrayType T);

CXQualType clang_VariableArrayType_desugar(CXVariableArrayType T);

// DependentSizedArrayType
CXExpr clang_DependentSizedArrayType_getSizeExpr(CXDependentSizedArrayType T);

bool clang_DependentSizedArrayType_isSugared(CXDependentSizedArrayType T);

CXQualType clang_DependentSizedArrayType_desugar(CXDependentSizedArrayType T);

// DependentAddressSpaceType
CXExpr clang_DependentAddressSpaceType_getAddrSpaceExpr(CXDependentAddressSpaceType T);

CXQualType clang_DependentAddressSpaceType_getPointeeType(CXDependentAddressSpaceType T);

bool clang_DependentAddressSpaceType_isSugared(CXDependentAddressSpaceType T);

CXQualType clang_DependentAddressSpaceType_desugar(CXDependentAddressSpaceType T);

// DependentSizedExtVectorType
CXExpr clang_DependentSizedExtVectorType_getSizeExpr(CXDependentSizedExtVectorType T);

CXQualType
clang_DependentSizedExtVectorType_getElementType(CXDependentSizedExtVectorType T);

bool clang_DependentSizedExtVectorType_isSugared(CXDependentSizedExtVectorType T);

CXQualType clang_DependentSizedExtVectorType_desugar(CXDependentSizedExtVectorType T);

// VectorType
// getElementType
// getNumElements

// DependentVectorType
// getElementType

// ExtVectorType

// MatrixType
// getElementType

// ConstantMatrixType
// getNumRows
// getNumColumns
// getNumElementsFlattened

// DependentSizedMatrixType

// FunctionType
CXQualType clang_FunctionType_getReturnType(CXFunctionType T);

bool clang_FunctionType_getHasRegParm(CXFunctionType T);

unsigned clang_FunctionType_getRegParmType(CXFunctionType T);

bool clang_FunctionType_getNoReturnAttr(CXFunctionType T);

bool clang_FunctionType_getCmseNSCallAttr(CXFunctionType T);

bool clang_FunctionType_isConst(CXFunctionType T);

bool clang_FunctionType_isRestrict(CXFunctionType T);

bool clang_FunctionType_isVolatile(CXFunctionType T);

// getCallConv
// getCallResultType
// getNameForCallConv

// FunctionNoProtoType
bool clang_FunctionNoProtoType_isSugared(CXFunctionNoProtoType T);

CXQualType clang_FunctionNoProtoType_desugar(CXFunctionNoProtoType T);

// FunctionProtoType
unsigned clang_FunctionProtoType_getNumParams(CXFunctionProtoType T);

CXQualType clang_FunctionProtoType_getParamType(CXFunctionProtoType T, unsigned i);

CXArrayRef clang_FunctionProtoType_getParamTypes(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasDynamicExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasNoexceptExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasDependentExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(CXFunctionProtoType T);

unsigned clang_FunctionProtoType_getNumExceptions(CXFunctionProtoType T);

CXQualType clang_FunctionProtoType_getExceptionType(CXFunctionProtoType T, unsigned i);

CXExpr clang_FunctionProtoType_getNoexceptExpr(CXFunctionProtoType T);

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecDecl(CXFunctionProtoType T);

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecTemplate(CXFunctionProtoType T);

bool clang_FunctionProtoType_isNothrow(CXFunctionProtoType T);

bool clang_FunctionProtoType_isVariadic(CXFunctionProtoType T);

bool clang_FunctionProtoType_isTemplateVariadic(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasTrailingReturn(CXFunctionProtoType T);

CXArrayRef clang_FunctionProtoType_param_types(CXFunctionProtoType T);

CXArrayRef clang_FunctionProtoType_exceptions(CXFunctionProtoType T);

bool clang_FunctionProtoType_isSugared(CXFunctionProtoType T);

// UnresolvedUsingType
CXUnresolvedUsingTypenameDecl clang_UnresolvedUsingType_getDecl(CXUnresolvedUsingType T);

bool clang_UnresolvedUsingType_isSugared(CXUnresolvedUsingType T);

CXQualType clang_UnresolvedUsingType_desugar(CXUnresolvedUsingType T);

// UsingType
CXUsingShadowDecl clang_UsingType_getFoundDecl(CXUsingType T);

CXQualType clang_UsingType_getUnderlyingType(CXUsingType T);

bool clang_UsingType_isSugared(CXUsingType T);

CXQualType clang_UsingType_desugar(CXUsingType T);

// TypedefType
CXTypedefNameDecl clang_TypedefType_getDecl(CXTypedefType T);

bool clang_TypedefType_isSugared(CXTypedefType T);

CXQualType clang_TypedefType_desugar(CXTypedefType T);

// MacroQualifiedType
CXIdentifierInfo clang_MacroQualifiedType_getMacroIdentifier(CXMacroQualifiedType T);

CXQualType clang_MacroQualifiedType_getUnderlyingType(CXMacroQualifiedType T);

CXQualType clang_MacroQualifiedType_getModifiedType(CXMacroQualifiedType T);

bool clang_MacroQualifiedType_isSugared(CXMacroQualifiedType T);

CXQualType clang_MacroQualifiedType_desugar(CXMacroQualifiedType T);

// TypeOfExprType

// DependentTypeOfExprType

// TypeOfType
// getUnmodifiedType

// DecltypeType
CXExpr clang_DecltypeType_getUnderlyingExpr(CXDecltypeType T);

CXQualType clang_DecltypeType_getUnderlyingType(CXDecltypeType T);

bool clang_DecltypeType_isSugared(CXDecltypeType T);

CXQualType clang_DecltypeType_desugar(CXDecltypeType T);

// DependentDecltypeType

// UnaryTransformType
bool clang_UnaryTransformType_isSugared(CXUnaryTransformType T);

CXQualType clang_UnaryTransformType_desugar(CXUnaryTransformType T);

CXQualType clang_UnaryTransformType_getUnderlyingType(CXUnaryTransformType T);

CXQualType clang_UnaryTransformType_getBaseType(CXUnaryTransformType T);

// DependentUnaryTransformType

// TagType
CXTagDecl clang_TagType_getDecl(CXTagType T);

// isBeingDefined

// RecordType
CXRecordDecl clang_RecordType_getDecl(CXRecordType T);

bool clang_RecordType_hasConstFields(CXRecordType T);

bool clang_RecordType_isSugared(CXRecordType T);

CXQualType clang_RecordType_desugar(CXRecordType T);

// EnumType
CXEnumDecl clang_EnumType_getDecl(CXEnumType T);

bool clang_EnumType_isSugared(CXEnumType T);

CXQualType clang_EnumType_desugar(CXEnumType T);

// AttributedType

// BTFTagAttributedType

// TemplateTypeParmType
unsigned clang_TemplateTypeParmType_getDepth(CXTemplateTypeParmType T);

unsigned clang_TemplateTypeParmType_getIndex(CXTemplateTypeParmType T);

bool clang_TemplateTypeParmType_isParameterPack(CXTemplateTypeParmType T);

CXTemplateTypeParmDecl clang_TemplateTypeParmType_getDecl(CXTemplateTypeParmType T);

bool clang_TemplateTypeParmType_isSugared(CXTemplateTypeParmType T);

CXQualType clang_TemplateTypeParmType_desugar(CXTemplateTypeParmType T);

// SubstTemplateTypeParmType
CXQualType
clang_SubstTemplateTypeParmType_getReplacementType(CXSubstTemplateTypeParmType T);

CXDecl clang_SubstTemplateTypeParmType_getAssociatedDecl(CXSubstTemplateTypeParmType T);

CXTemplateTypeParmDecl
clang_SubstTemplateTypeParmType_getReplacedParameter(CXSubstTemplateTypeParmType T);

unsigned clang_SubstTemplateTypeParmType_getIndex(CXSubstTemplateTypeParmType T);

bool clang_SubstTemplateTypeParmType_isSugared(CXSubstTemplateTypeParmType T);

CXQualType clang_SubstTemplateTypeParmType_desugar(CXSubstTemplateTypeParmType T);

// SubstTemplateTypeParmPackType
CXDecl
clang_SubstTemplateTypeParmPackType_getAssociatedDecl(CXSubstTemplateTypeParmPackType T);

CXTemplateTypeParmDecl
clang_SubstTemplateTypeParmPackType_getReplacedParameter(CXSubstTemplateTypeParmPackType T);

unsigned clang_SubstTemplateTypeParmPackType_getIndex(CXSubstTemplateTypeParmPackType T);

bool clang_SubstTemplateTypeParmPackType_getFinal(CXSubstTemplateTypeParmPackType T);

unsigned clang_SubstTemplateTypeParmPackType_getNumArgs(CXSubstTemplateTypeParmPackType T);

bool clang_SubstTemplateTypeParmPackType_isSugared(CXSubstTemplateTypeParmPackType T);

CXQualType clang_SubstTemplateTypeParmPackType_desugar(CXSubstTemplateTypeParmPackType T);

CXArrayRef
clang_SubstTemplateTypeParmPackType_getArgumentPack(CXSubstTemplateTypeParmPackType T);

// DeducedType
bool clang_DeducedType_isSugared(CXDeducedType T);

CXQualType clang_DeducedType_desugar(CXDeducedType T);

CXQualType clang_DeducedType_getDeducedType(CXDeducedType T);

bool clang_DeducedType_isDeduced(CXDeducedType T);

// AutoType

// DeducedTemplateSpecializationType
CXTemplateName clang_DeducedTemplateSpecializationType_getTemplateName(
    CXDeducedTemplateSpecializationType T);

// TemplateSpecializationType
bool clang_TemplateSpecializationType_isCurrentInstantiation(
    CXTemplateSpecializationType T);

bool clang_TemplateSpecializationType_isTypeAlias(CXTemplateSpecializationType T);

CXQualType clang_TemplateSpecializationType_getAliasedType(CXTemplateSpecializationType T);

CXTemplateName
clang_TemplateSpecializationType_getTemplateName(CXTemplateSpecializationType T);

CXArrayRef
clang_TemplateSpecializationType_template_arguments(CXTemplateSpecializationType T);

bool clang_TemplateSpecializationType_isSugared(CXTemplateSpecializationType T);

CXQualType clang_TemplateSpecializationType_desugar(CXTemplateSpecializationType T);

// InjectedClassNameType
CXQualType
clang_InjectedClassNameType_getInjectedSpecializationType(CXInjectedClassNameType T);

CXTemplateSpecializationType
clang_InjectedClassNameType_getInjectedTST(CXInjectedClassNameType T);

CXTemplateName clang_InjectedClassNameType_getTemplateName(CXInjectedClassNameType T);

CXCXXRecordDecl clang_InjectedClassNameType_getDecl(CXInjectedClassNameType T);

bool clang_InjectedClassNameType_isSugared(CXInjectedClassNameType T);

CXQualType clang_InjectedClassNameType_desugar(CXInjectedClassNameType T);

// TypeWithKeyword

// ElaboratedType
CXNestedNameSpecifier clang_ElaboratedType_getQualifier(CXElaboratedType T);

CXQualType clang_ElaboratedType_getNamedType(CXElaboratedType T);

CXQualType clang_ElaboratedType_desugar(CXElaboratedType T);

bool clang_ElaboratedType_isSugared(CXElaboratedType T);

CXTagDecl clang_ElaboratedType_getOwnedTagDecl(CXElaboratedType T);

// DependentNameType
CXNestedNameSpecifier clang_DependentNameType_getQualifier(CXDependentNameType T);

CXIdentifierInfo clang_DependentNameType_getIdentifier(CXDependentNameType T);

bool clang_DependentNameType_isSugared(CXDependentNameType T);

CXQualType clang_DependentNameType_desugar(CXDependentNameType T);

// DependentTemplateSpecializationType
CXNestedNameSpecifier clang_DependentTemplateSpecializationType_getQualifier(
    CXDependentTemplateSpecializationType T);

CXIdentifierInfo clang_DependentTemplateSpecializationType_getIdentifier(
    CXDependentTemplateSpecializationType T);

CXArrayRef clang_DependentTemplateSpecializationType_template_arguments(
    CXDependentTemplateSpecializationType T);

bool clang_DependentTemplateSpecializationType_isSugared(
    CXDependentTemplateSpecializationType T);

CXQualType
clang_DependentTemplateSpecializationType_desugar(CXDependentTemplateSpecializationType T);

// PackExpansionType

// AtomicType
CXQualType clang_AtomicType_getValueType(CXAtomicType T);

bool clang_AtomicType_isSugared(CXAtomicType T);

CXQualType clang_AtomicType_desugar(CXAtomicType T);

// BitIntType

// DependentBitIntType

// TagTypeKind
typedef enum CXTagTypeKind {
  CXTagTypeKind_Struct,
  CXTagTypeKind_Interface,
  CXTagTypeKind_Union,
  CXTagTypeKind_Class,
  CXTagTypeKind_Enum
} CXTagTypeKind;

// ElaboratedTypeKeyword
typedef enum CXElaboratedTypeKeyword {
  CXElaboratedTypeKeyword_Struct,
  CXElaboratedTypeKeyword_Interface,
  CXElaboratedTypeKeyword_Union,
  CXElaboratedTypeKeyword_Class,
  CXElaboratedTypeKeyword_Enum,
  CXElaboratedTypeKeyword_Typename,
  CXElaboratedTypeKeyword_None
} CXElaboratedTypeKeyword;

LLVM_CLANG_C_EXTERN_C_END

#endif