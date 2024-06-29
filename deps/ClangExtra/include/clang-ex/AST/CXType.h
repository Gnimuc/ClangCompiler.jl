#ifndef LIBCLANGEX_CXQUALTYPE_H
#define LIBCLANGEX_CXQUALTYPE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXQualType clang_QualType_constructFromTypePtr(CXType_ Ptr, unsigned Quals);

CINDEX_LINKAGE CXType_ clang_QualType_getTypePtr(CXQualType OpaquePtr);

CINDEX_LINKAGE CXType_ clang_QualType_getTypePtrOrNull(CXQualType OpaquePtr);

CINDEX_LINKAGE bool clang_QualType_isCanonical(CXQualType OpaquePtr);

CINDEX_LINKAGE bool clang_QualType_isNull(CXQualType OpaquePtr);

CINDEX_LINKAGE bool clang_QualType_isConstQualified(CXQualType OpaquePtr);
CINDEX_LINKAGE bool clang_QualType_isRestrictQualified(CXQualType OpaquePtr);
CINDEX_LINKAGE bool clang_QualType_isVolatileQualified(CXQualType OpaquePtr);
CINDEX_LINKAGE bool clang_QualType_hasQualifiers(CXQualType OpaquePtr);

CINDEX_LINKAGE CXQualType clang_QualType_withConst(CXQualType OpaquePtr);
CINDEX_LINKAGE CXQualType clang_QualType_withVolatile(CXQualType OpaquePtr);
CINDEX_LINKAGE CXQualType clang_QualType_withRestrict(CXQualType OpaquePtr);

CINDEX_LINKAGE CXQualType clang_QualType_addConst(CXQualType OpaquePtr);
CINDEX_LINKAGE CXQualType clang_QualType_addVolatile(CXQualType OpaquePtr);
CINDEX_LINKAGE CXQualType clang_QualType_addRestrict(CXQualType OpaquePtr);

CINDEX_LINKAGE bool clang_QualType_isLocalConstQualified(CXQualType OpaquePtr);
CINDEX_LINKAGE bool clang_QualType_isLocalRestrictQualified(CXQualType OpaquePtr);
CINDEX_LINKAGE bool clang_QualType_isLocalVolatileQualified(CXQualType OpaquePtr);
CINDEX_LINKAGE bool clang_QualType_hasLocalQualifiers(CXQualType OpaquePtr);

CINDEX_LINKAGE unsigned clang_QualType_getCVRQualifiers(CXQualType OpaquePtr);

CINDEX_LINKAGE CXString clang_QualType_getAsString(CXQualType OpaquePtr);

CINDEX_LINKAGE void clang_QualType_dump(CXQualType OpaquePtr);

CINDEX_LINKAGE CXQualType clang_QualType_getCanonicalType(CXQualType OpaquePtr);

CINDEX_LINKAGE CXQualType clang_QualType_getLocalUnqualifiedType(CXQualType OpaquePtr);

CINDEX_LINKAGE CXQualType clang_QualType_getUnqualifiedType(CXQualType OpaquePtr);

// Type
CINDEX_LINKAGE bool clang_Type_isFromAST(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isCanonicalUnqualified(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSizelessType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSizelessBuiltinType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isBuiltinType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isIntegerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isEnumeralType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isScopedEnumeralType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isBooleanType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isCharType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isWideCharType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isChar8Type(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isChar16Type(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isChar32Type(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isAnyCharacterType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isIntegralOrEnumerationType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isIntegralOrUnscopedEnumerationType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUnscopedEnumerationType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isRealFloatingType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isComplexType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isAnyComplexType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFloatingType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isHalfType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFloat16Type(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isBFloat16Type(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFloat128Type(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isRealType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isArithmeticType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isVoidType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isScalarType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isAggregateType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFundamentalType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isCompoundType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFunctionType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFunctionNoProtoType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFunctionProtoType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isAnyPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isBlockPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isVoidPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isLValueReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isRValueReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isObjectPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFunctionPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFunctionReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isMemberPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isMemberFunctionPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isMemberDataPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isConstantArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isIncompleteArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isVariableArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isDependentSizedArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isRecordType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isClassType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isStructureType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isObjCBoxableRecordType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isInterfaceType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isStructureOrClassType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUnionType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isComplexIntegerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isVectorType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isExtVectorType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isMatrixType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isConstantMatrixType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isDependentAddressSpaceType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isDecltypeType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isTemplateTypeParmType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isNullPtrType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isNothrowT(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isAlignValT(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isStdByteType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isAtomicType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUndeducedAutoType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isTypedefNameType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isDependentType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isInstantiationDependentType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUndeducedType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isVariablyModifiedType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasSizedVLAType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasUnnamedOrLocalType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isOverloadableType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isElaboratedTypeSpecifier(CXType_ T);

CINDEX_LINKAGE bool clang_Type_canDecayToPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasPointerRepresentation(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasObjCPointerRepresentation(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasIntegerRepresentation(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasSignedIntegerRepresentation(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasUnsignedIntegerRepresentation(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasFloatingRepresentation(CXType_ T);

CINDEX_LINKAGE CXRecordType clang_Type_getAsStructureType(CXType_ T);

CINDEX_LINKAGE CXRecordType clang_Type_getAsUnionType(CXType_ T);

CINDEX_LINKAGE CXComplexType clang_Type_getAsComplexIntegerType(CXType_ T);

CINDEX_LINKAGE CXCXXRecordDecl clang_Type_getAsCXXRecordDecl(CXType_ T);

CINDEX_LINKAGE CXRecordDecl clang_Type_getAsRecordDecl(CXType_ T);

CINDEX_LINKAGE CXTagDecl clang_Type_getAsTagDecl(CXType_ T);

CINDEX_LINKAGE CXCXXRecordDecl clang_Type_getPointeeCXXRecordDecl(CXType_ T);

CINDEX_LINKAGE CXDeducedType clang_Type_getContainedDeducedType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_hasAutoForTrailingReturnType(CXType_ T);

CINDEX_LINKAGE CXType_ clang_Type_getArrayElementTypeNoTypeQual(CXType_ T);

CINDEX_LINKAGE CXType_ clang_Type_getPointeeOrArrayElementType(CXType_ T);

CINDEX_LINKAGE CXQualType clang_Type_getPointeeType(CXType_ T);

CINDEX_LINKAGE CXType_ clang_Type_getUnqualifiedDesugaredType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isPromotableIntegerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSignedIntegerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUnsignedIntegerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSignedIntegerOrEnumerationType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUnsignedIntegerOrEnumerationType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFixedPointType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isFixedPointOrIntegerType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSaturatedFixedPointType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUnsaturatedFixedPointType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSignedFixedPointType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isUnsignedFixedPointType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isConstantSizeType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isSpecifierType(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isVisibilityExplicit(CXType_ T);

CINDEX_LINKAGE bool clang_Type_isLinkageValid(CXType_ T);

CINDEX_LINKAGE CXQualType clang_Type_getCanonicalTypeInternal(CXType_ T);

CINDEX_LINKAGE void clang_Type_dump(CXType_ T);

// isa
CINDEX_LINKAGE bool clang_isa_BuiltinType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_ComplexType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_PointerType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_ReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_LValueReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_RValueReferenceType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_MemberPointerType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_ArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_ConstantArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_IncompleteArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_VariableArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DependentSizedArrayType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_FunctionType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_FunctionNoProtoType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_FunctionProtoType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_UnresolvedUsingType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_TypedefType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DecltypeType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DependentDecltypeType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_TagType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_RecordType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_EnumType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_TemplateTypeParmType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_SubstTemplateTypeParmType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_SubstTemplateTypeParmPackType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DeducedType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_AutoType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DeducedTemplateSpecializationType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_TemplateSpecializationType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_ElaboratedType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DependentNameType(CXType_ T);

CINDEX_LINKAGE bool clang_isa_DependentTemplateSpecializationType(CXType_ T);

// BuiltinTypes
CINDEX_LINKAGE bool clang_isa_BuiltinType_Void(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Bool(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Char_U(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_UChar(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_WChar_U(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Char8(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Char16(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Char32(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_UShort(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_UInt(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_ULong(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_ULongLong(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_UInt128(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Char_S(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_SChar(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_WChar_S(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Short(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Int(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Long(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_LongLong(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Int128(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Half(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Float(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Double(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_LongDouble(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Float16(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_BFloat16(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_Float128(CXType_ T);

CINDEX_LINKAGE bool clang_isa_BuiltinType_NullPtr(CXType_ T);

// PointerType
CINDEX_LINKAGE CXQualType clang_PointerType_getPointeeType(CXPointerType T);

// MemberPointerType
CINDEX_LINKAGE CXQualType clang_MemberPointerType_getPointeeType(CXMemberPointerType T);

CINDEX_LINKAGE CXType_ clang_MemberPointerType_getClass(CXMemberPointerType T);

// TypedefType
CINDEX_LINKAGE CXQualType clang_TypedefType_desugar(CXTypedefType T);

// EnumType
CINDEX_LINKAGE CXEnumDecl clang_EnumType_getDecl(CXEnumType T);

// FunctionType
CINDEX_LINKAGE CXQualType clang_FunctionType_getReturnType(CXFunctionType T);

// FunctionProtoType
CINDEX_LINKAGE unsigned clang_FunctionProtoType_getNumParams(CXFunctionProtoType T);

CINDEX_LINKAGE CXQualType clang_FunctionProtoType_getParamType(CXFunctionProtoType T,
                                                               unsigned i);

// ReferenceType
CINDEX_LINKAGE CXQualType clang_ReferenceType_getPointeeType(CXReferenceType T);

// ElaboratedType
CINDEX_LINKAGE CXQualType clang_ElaboratedType_desugar(CXElaboratedType T);

// TemplateSpecializationType
CINDEX_LINKAGE bool
clang_TemplateSpecializationType_isCurrentInstantiation(CXTemplateSpecializationType T);

CINDEX_LINKAGE bool
clang_TemplateSpecializationType_isTypeAlias(CXTemplateSpecializationType T);

CINDEX_LINKAGE CXQualType
clang_TemplateSpecializationType_getAliasedType(CXTemplateSpecializationType T);

CINDEX_LINKAGE CXTemplateName
clang_TemplateSpecializationType_getTemplateName(CXTemplateSpecializationType T);

CINDEX_LINKAGE unsigned
clang_TemplateSpecializationType_getNumArgs(CXTemplateSpecializationType T);

CINDEX_LINKAGE CXTemplateArgument
clang_TemplateSpecializationType_getArg(CXTemplateSpecializationType T, unsigned Idx);

CINDEX_LINKAGE bool
clang_TemplateSpecializationType_isSugared(CXTemplateSpecializationType T);

CINDEX_LINKAGE CXQualType
clang_TemplateSpecializationType_desugar(CXTemplateSpecializationType T);

// TagTypeKind
typedef enum CXTagTypeKind {
  CXTagTypeKind_TTK_Struct,
  CXTagTypeKind_TTK_Interface,
  CXTagTypeKind_TTK_Union,
  CXTagTypeKind_TTK_Class,
  CXTagTypeKind_TTK_Enum
} CXTagTypeKind;

// ElaboratedTypeKeyword
typedef enum CXElaboratedTypeKeyword {
  CXElaboratedTypeKeyword_ETK_Struct,
  CXElaboratedTypeKeyword_ETK_Interface,
  CXElaboratedTypeKeyword_ETK_Union,
  CXElaboratedTypeKeyword_ETK_Class,
  CXElaboratedTypeKeyword_ETK_Enum,
  CXElaboratedTypeKeyword_ETK_Typename,
  CXElaboratedTypeKeyword_ETK_None
} CXElaboratedTypeKeyword;

#ifdef __cplusplus
}
#endif
#endif