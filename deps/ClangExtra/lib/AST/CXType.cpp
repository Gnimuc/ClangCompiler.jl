#include "clang-ex/AST/CXType.h"
#include "utils.h"
#include "clang/AST/Decl.h"
#include "clang/AST/TemplateBase.h"
#include "clang/AST/Type.h"

// QualType
CXQualType clang_QualType_constructFromTypePtr(CXType_ Ptr, unsigned Quals) {
  return clang::QualType(static_cast<clang::Type *>(Ptr), Quals).getAsOpaquePtr();
}

CXType_ clang_QualType_getTypePtr(CXQualType OpaquePtr) {
  return const_cast<clang::Type *>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getTypePtr());
}

CXType_ clang_QualType_getTypePtrOrNull(CXQualType OpaquePtr) {
  return const_cast<clang::Type *>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getTypePtrOrNull());
}

bool clang_QualType_isCanonical(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isCanonical();
}

bool clang_QualType_isNull(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isNull();
}

bool clang_QualType_isConstQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isConstQualified();
}

bool clang_QualType_isRestrictQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isRestrictQualified();
}

bool clang_QualType_isVolatileQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isVolatileQualified();
}

bool clang_QualType_hasQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasQualifiers();
}

CXQualType clang_QualType_withConst(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).withConst().getAsOpaquePtr();
}

CXQualType clang_QualType_withVolatile(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).withVolatile().getAsOpaquePtr();
}

CXQualType clang_QualType_withRestrict(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).withRestrict().getAsOpaquePtr();
}

CXQualType clang_QualType_addConst(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.addConst();
  return T.getAsOpaquePtr();
}

CXQualType clang_QualType_addVolatile(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.addVolatile();
  return T.getAsOpaquePtr();
}

CXQualType clang_QualType_addRestrict(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.addRestrict();
  return T.getAsOpaquePtr();
}

bool clang_QualType_isLocalConstQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isLocalConstQualified();
}

bool clang_QualType_isLocalRestrictQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isLocalRestrictQualified();
}

bool clang_QualType_isLocalVolatileQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isLocalVolatileQualified();
}

bool clang_QualType_hasLocalQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasLocalQualifiers();
}

unsigned clang_QualType_getCVRQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getCVRQualifiers();
}

CXString clang_QualType_getAsString(CXQualType OpaquePtr) {
  return extra::makeCXString(clang::QualType::getFromOpaquePtr(OpaquePtr).getAsString());
}

void clang_QualType_dump(CXQualType OpaquePtr) {
  clang::QualType::getFromOpaquePtr(OpaquePtr).dump();
}

CXQualType clang_QualType_getCanonicalType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getCanonicalType().getAsOpaquePtr();
}

CXQualType clang_QualType_getLocalUnqualifiedType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getLocalUnqualifiedType()
      .getAsOpaquePtr();
}

CXQualType clang_QualType_getUnqualifiedType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getUnqualifiedType().getAsOpaquePtr();
}

// Type
bool clang_Type_isFromAST(CXType_ T) { return static_cast<clang::Type *>(T)->isFromAST(); }

bool clang_Type_isCanonicalUnqualified(CXType_ T) {
  return static_cast<clang::Type *>(T)->isCanonicalUnqualified();
}

bool clang_Type_isSizelessType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSizelessType();
}

bool clang_Type_isSizelessBuiltinType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSizelessBuiltinType();
}

bool clang_Type_isBuiltinType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isBuiltinType();
}

bool clang_Type_isIntegerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isIntegerType();
}

bool clang_Type_isEnumeralType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isEnumeralType();
}

bool clang_Type_isScopedEnumeralType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isScopedEnumeralType();
}

bool clang_Type_isBooleanType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isBooleanType();
}

bool clang_Type_isCharType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isCharType();
}

bool clang_Type_isWideCharType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isWideCharType();
}

bool clang_Type_isChar8Type(CXType_ T) {
  return static_cast<clang::Type *>(T)->isChar8Type();
}

bool clang_Type_isChar16Type(CXType_ T) {
  return static_cast<clang::Type *>(T)->isChar16Type();
}

bool clang_Type_isChar32Type(CXType_ T) {
  return static_cast<clang::Type *>(T)->isChar32Type();
}

bool clang_Type_isAnyCharacterType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isAnyCharacterType();
}

bool clang_Type_isIntegralOrEnumerationType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isIntegralOrEnumerationType();
}

bool clang_Type_isIntegralOrUnscopedEnumerationType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isIntegralOrUnscopedEnumerationType();
}

bool clang_Type_isUnscopedEnumerationType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUnscopedEnumerationType();
}

bool clang_Type_isRealFloatingType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isRealFloatingType();
}

bool clang_Type_isComplexType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isComplexType();
}

bool clang_Type_isAnyComplexType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isAnyComplexType();
}

bool clang_Type_isFloatingType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFloatingType();
}

bool clang_Type_isHalfType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isHalfType();
}

bool clang_Type_isFloat16Type(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFloat16Type();
}

bool clang_Type_isBFloat16Type(CXType_ T) {
  return static_cast<clang::Type *>(T)->isBFloat16Type();
}

bool clang_Type_isFloat128Type(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFloat128Type();
}

bool clang_Type_isRealType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isRealType();
}

bool clang_Type_isArithmeticType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isArithmeticType();
}

bool clang_Type_isVoidType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isVoidType();
}

bool clang_Type_isScalarType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isScalarType();
}

bool clang_Type_isAggregateType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isAggregateType();
}

bool clang_Type_isFundamentalType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFundamentalType();
}

bool clang_Type_isCompoundType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isCompoundType();
}

bool clang_Type_isFunctionType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFunctionType();
}

bool clang_Type_isFunctionNoProtoType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFunctionNoProtoType();
}

bool clang_Type_isFunctionProtoType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFunctionProtoType();
}

bool clang_Type_isPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isPointerType();
}

bool clang_Type_isAnyPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isAnyPointerType();
}

bool clang_Type_isBlockPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isBlockPointerType();
}

bool clang_Type_isVoidPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isVoidPointerType();
}

bool clang_Type_isReferenceType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isReferenceType();
}

bool clang_Type_isLValueReferenceType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isLValueReferenceType();
}

bool clang_Type_isRValueReferenceType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isRValueReferenceType();
}

bool clang_Type_isObjectPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isObjectPointerType();
}

bool clang_Type_isFunctionPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFunctionPointerType();
}

bool clang_Type_isFunctionReferenceType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFunctionReferenceType();
}

bool clang_Type_isMemberPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isMemberPointerType();
}

bool clang_Type_isMemberFunctionPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isMemberFunctionPointerType();
}

bool clang_Type_isMemberDataPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isMemberDataPointerType();
}

bool clang_Type_isArrayType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isArrayType();
}

bool clang_Type_isConstantArrayType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isConstantArrayType();
}

bool clang_Type_isIncompleteArrayType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isIncompleteArrayType();
}

bool clang_Type_isVariableArrayType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isVariableArrayType();
}

bool clang_Type_isDependentSizedArrayType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isDependentSizedArrayType();
}

bool clang_Type_isRecordType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isRecordType();
}

bool clang_Type_isClassType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isClassType();
}

bool clang_Type_isStructureType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isStructureType();
}

bool clang_Type_isObjCBoxableRecordType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isObjCBoxableRecordType();
}

bool clang_Type_isInterfaceType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isInterfaceType();
}

bool clang_Type_isStructureOrClassType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isStructureOrClassType();
}

bool clang_Type_isUnionType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUnionType();
}

bool clang_Type_isComplexIntegerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isComplexIntegerType();
}

bool clang_Type_isVectorType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isVectorType();
}

bool clang_Type_isExtVectorType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isExtVectorType();
}

bool clang_Type_isMatrixType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isMatrixType();
}

bool clang_Type_isConstantMatrixType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isConstantMatrixType();
}

bool clang_Type_isDependentAddressSpaceType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isDependentAddressSpaceType();
}

bool clang_Type_isDecltypeType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isDecltypeType();
}

bool clang_Type_isTemplateTypeParmType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isTemplateTypeParmType();
}

bool clang_Type_isNullPtrType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isNullPtrType();
}

bool clang_Type_isNothrowT(CXType_ T) {
  return static_cast<clang::Type *>(T)->isNothrowT();
}

bool clang_Type_isAlignValT(CXType_ T) {
  return static_cast<clang::Type *>(T)->isAlignValT();
}

bool clang_Type_isStdByteType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isStdByteType();
}

bool clang_Type_isAtomicType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isAtomicType();
}

bool clang_Type_isUndeducedAutoType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUndeducedAutoType();
}

bool clang_Type_isTypedefNameType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isTypedefNameType();
}

bool clang_Type_isDependentType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isDependentType();
}

bool clang_Type_isInstantiationDependentType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isInstantiationDependentType();
}

bool clang_Type_isUndeducedType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUndeducedType();
}

bool clang_Type_isVariablyModifiedType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isVariablyModifiedType();
}

bool clang_Type_hasSizedVLAType(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasSizedVLAType();
}

bool clang_Type_hasUnnamedOrLocalType(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasUnnamedOrLocalType();
}

bool clang_Type_isOverloadableType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isOverloadableType();
}

bool clang_Type_isElaboratedTypeSpecifier(CXType_ T) {
  return static_cast<clang::Type *>(T)->isElaboratedTypeSpecifier();
}

bool clang_Type_canDecayToPointerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->canDecayToPointerType();
}

bool clang_Type_hasPointerRepresentation(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasPointerRepresentation();
}

bool clang_Type_hasObjCPointerRepresentation(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasObjCPointerRepresentation();
}

bool clang_Type_hasIntegerRepresentation(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasIntegerRepresentation();
}

bool clang_Type_hasSignedIntegerRepresentation(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasSignedIntegerRepresentation();
}

bool clang_Type_hasUnsignedIntegerRepresentation(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasUnsignedIntegerRepresentation();
}

bool clang_Type_hasFloatingRepresentation(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasFloatingRepresentation();
}

CXRecordType clang_Type_getAsStructureType(CXType_ T) {
  return const_cast<clang::RecordType *>(
      static_cast<clang::Type *>(T)->getAsStructureType());
}

CXRecordType clang_Type_getAsUnionType(CXType_ T) {
  return const_cast<clang::RecordType *>(static_cast<clang::Type *>(T)->getAsUnionType());
}

CXComplexType clang_Type_getAsComplexIntegerType(CXType_ T) {
  return const_cast<clang::ComplexType *>(
      static_cast<clang::Type *>(T)->getAsComplexIntegerType());
}

CXCXXRecordDecl clang_Type_getAsCXXRecordDecl(CXType_ T) {
  return static_cast<clang::Type *>(T)->getAsCXXRecordDecl();
}

CXRecordDecl clang_Type_getAsRecordDecl(CXType_ T) {
  return static_cast<clang::Type *>(T)->getAsRecordDecl();
}

CXTagDecl clang_Type_getAsTagDecl(CXType_ T) {
  return static_cast<clang::Type *>(T)->getAsTagDecl();
}

CXCXXRecordDecl clang_Type_getPointeeCXXRecordDecl(CXType_ T) {
  return const_cast<clang::CXXRecordDecl *>(
      static_cast<clang::Type *>(T)->getPointeeCXXRecordDecl());
}

CXDeducedType clang_Type_getContainedDeducedType(CXType_ T) {
  return static_cast<clang::Type *>(T)->getContainedDeducedType();
}

bool clang_Type_hasAutoForTrailingReturnType(CXType_ T) {
  return static_cast<clang::Type *>(T)->hasAutoForTrailingReturnType();
}

CXType_ clang_Type_getArrayElementTypeNoTypeQual(CXType_ T) {
  return const_cast<clang::Type *>(
      static_cast<clang::Type *>(T)->getArrayElementTypeNoTypeQual());
}

CXType_ clang_Type_getPointeeOrArrayElementType(CXType_ T) {
  return const_cast<clang::Type *>(
      static_cast<clang::Type *>(T)->getPointeeOrArrayElementType());
}

CXQualType clang_Type_getPointeeType(CXType_ T) {
  return static_cast<clang::Type *>(T)->getPointeeType().getAsOpaquePtr();
}

CXType_ clang_Type_getUnqualifiedDesugaredType(CXType_ T) {
  return const_cast<clang::Type *>(
      static_cast<clang::Type *>(T)->getUnqualifiedDesugaredType());
}

// bool clang_Type_isPromotableIntegerType(CXType_ T) {
//   return static_cast<clang::Type *>(T)->isPromotableIntegerType();
// }

bool clang_Type_isSignedIntegerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSignedIntegerType();
}

bool clang_Type_isUnsignedIntegerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUnsignedIntegerType();
}

bool clang_Type_isSignedIntegerOrEnumerationType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSignedIntegerOrEnumerationType();
}

bool clang_Type_isUnsignedIntegerOrEnumerationType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUnsignedIntegerOrEnumerationType();
}

bool clang_Type_isFixedPointType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFixedPointType();
}

bool clang_Type_isFixedPointOrIntegerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isFixedPointOrIntegerType();
}

bool clang_Type_isSaturatedFixedPointType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSaturatedFixedPointType();
}

bool clang_Type_isUnsaturatedFixedPointType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUnsaturatedFixedPointType();
}

bool clang_Type_isSignedFixedPointType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSignedFixedPointType();
}

bool clang_Type_isUnsignedFixedPointType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isUnsignedFixedPointType();
}

bool clang_Type_isConstantSizeType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isConstantSizeType();
}

bool clang_Type_isSpecifierType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isSpecifierType();
}

bool clang_Type_isVisibilityExplicit(CXType_ T) {
  return static_cast<clang::Type *>(T)->isVisibilityExplicit();
}

bool clang_Type_isLinkageValid(CXType_ T) {
  return static_cast<clang::Type *>(T)->isLinkageValid();
}

CXQualType clang_Type_getCanonicalTypeInternal(CXType_ T) {
  return static_cast<clang::Type *>(T)->getCanonicalTypeInternal().getAsOpaquePtr();
}

void clang_Type_dump(CXType_ T) { return static_cast<clang::Type *>(T)->dump(); }

// isa
bool clang_isa_ComplexType(CXType_ T) {
  return llvm::isa<clang::ComplexType>(static_cast<clang::Type *>(T));
}

bool clang_isa_PointerType(CXType_ T) {
  return llvm::isa<clang::PointerType>(static_cast<clang::Type *>(T));
}

bool clang_isa_ReferenceType(CXType_ T) {
  return llvm::isa<clang::ReferenceType>(static_cast<clang::Type *>(T));
}

bool clang_isa_LValueReferenceType(CXType_ T) {
  return llvm::isa<clang::LValueReferenceType>(static_cast<clang::Type *>(T));
}

bool clang_isa_RValueReferenceType(CXType_ T) {
  return llvm::isa<clang::RValueReferenceType>(static_cast<clang::Type *>(T));
}

bool clang_isa_MemberPointerType(CXType_ T) {
  return llvm::isa<clang::MemberPointerType>(static_cast<clang::Type *>(T));
}

bool clang_isa_ArrayType(CXType_ T) {
  return llvm::isa<clang::ArrayType>(static_cast<clang::Type *>(T));
}

bool clang_isa_ConstantArrayType(CXType_ T) {
  return llvm::isa<clang::ConstantArrayType>(static_cast<clang::Type *>(T));
}

bool clang_isa_IncompleteArrayType(CXType_ T) {
  return llvm::isa<clang::IncompleteArrayType>(static_cast<clang::Type *>(T));
}

bool clang_isa_VariableArrayType(CXType_ T) {
  return llvm::isa<clang::VariableArrayType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DependentSizedArrayType(CXType_ T) {
  return llvm::isa<clang::DependentSizedArrayType>(static_cast<clang::Type *>(T));
}

bool clang_isa_FunctionType(CXType_ T) {
  return llvm::isa<clang::FunctionType>(static_cast<clang::Type *>(T));
}

bool clang_isa_FunctionNoProtoType(CXType_ T) {
  return llvm::isa<clang::FunctionNoProtoType>(static_cast<clang::Type *>(T));
}

bool clang_isa_FunctionProtoType(CXType_ T) {
  return llvm::isa<clang::FunctionProtoType>(static_cast<clang::Type *>(T));
}

bool clang_isa_UnresolvedUsingType(CXType_ T) {
  return llvm::isa<clang::UnresolvedUsingType>(static_cast<clang::Type *>(T));
}

bool clang_isa_UsingType(CXType_ T) {
  return llvm::isa<clang::UsingType>(static_cast<clang::Type *>(T));
}

bool clang_isa_TypedefType(CXType_ T) {
  return llvm::isa<clang::TypedefType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DecltypeType(CXType_ T) {
  return llvm::isa<clang::DecltypeType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DependentDecltypeType(CXType_ T) {
  return llvm::isa<clang::DependentDecltypeType>(static_cast<clang::Type *>(T));
}

bool clang_isa_TagType(CXType_ T) {
  return llvm::isa<clang::TagType>(static_cast<clang::Type *>(T));
}

bool clang_isa_RecordType(CXType_ T) {
  return llvm::isa<clang::RecordType>(static_cast<clang::Type *>(T));
}

bool clang_isa_EnumType(CXType_ T) {
  return llvm::isa<clang::EnumType>(static_cast<clang::Type *>(T));
}

bool clang_isa_TemplateTypeParmType(CXType_ T) {
  return llvm::isa<clang::TemplateTypeParmType>(static_cast<clang::Type *>(T));
}

bool clang_isa_SubstTemplateTypeParmType(CXType_ T) {
  return llvm::isa<clang::SubstTemplateTypeParmType>(static_cast<clang::Type *>(T));
}

bool clang_isa_SubstTemplateTypeParmPackType(CXType_ T) {
  return llvm::isa<clang::SubstTemplateTypeParmPackType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DeducedType(CXType_ T) {
  return llvm::isa<clang::DeducedType>(static_cast<clang::Type *>(T));
}

bool clang_isa_AutoType(CXType_ T) {
  return llvm::isa<clang::AutoType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DeducedTemplateSpecializationType(CXType_ T) {
  return llvm::isa<clang::DeducedTemplateSpecializationType>(static_cast<clang::Type *>(T));
}

bool clang_isa_TemplateSpecializationType(CXType_ T) {
  return llvm::isa<clang::TemplateSpecializationType>(static_cast<clang::Type *>(T));
}

bool clang_isa_ElaboratedType(CXType_ T) {
  return llvm::isa<clang::ElaboratedType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DependentNameType(CXType_ T) {
  return llvm::isa<clang::DependentNameType>(static_cast<clang::Type *>(T));
}

bool clang_isa_DependentTemplateSpecializationType(CXType_ T) {
  return llvm::isa<clang::DependentTemplateSpecializationType>(
      static_cast<clang::Type *>(T));
}

// BuiltinTypes
bool clang_isa_BuiltinType_Void(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Void;
}

bool clang_isa_BuiltinType_Bool(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Bool;
}

bool clang_isa_BuiltinType_Char_U(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char_U;
}

bool clang_isa_BuiltinType_UChar(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UChar;
}

bool clang_isa_BuiltinType_WChar_U(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::WChar_U;
}

bool clang_isa_BuiltinType_Char8(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char8;
}

bool clang_isa_BuiltinType_Char16(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char16;
}

bool clang_isa_BuiltinType_Char32(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char32;
}

bool clang_isa_BuiltinType_UShort(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UShort;
}

bool clang_isa_BuiltinType_UInt(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UInt;
}

bool clang_isa_BuiltinType_ULong(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::ULong;
}

bool clang_isa_BuiltinType_ULongLong(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::ULongLong;
}

bool clang_isa_BuiltinType_UInt128(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UInt128;
}

bool clang_isa_BuiltinType_Char_S(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char_S;
}

bool clang_isa_BuiltinType_SChar(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::SChar;
}

bool clang_isa_BuiltinType_WChar_S(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::WChar_S;
}

bool clang_isa_BuiltinType_Short(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Short;
}

bool clang_isa_BuiltinType_Int(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Int;
}

bool clang_isa_BuiltinType_Long(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Long;
}

bool clang_isa_BuiltinType_LongLong(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::LongLong;
}

bool clang_isa_BuiltinType_Int128(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Int128;
}

bool clang_isa_BuiltinType_Half(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Half;
}

bool clang_isa_BuiltinType_Float(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Float;
}

bool clang_isa_BuiltinType_Double(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Double;
}

bool clang_isa_BuiltinType_LongDouble(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::LongDouble;
}

bool clang_isa_BuiltinType_Float16(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Float16;
}

bool clang_isa_BuiltinType_BFloat16(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::BFloat16;
}

bool clang_isa_BuiltinType_Float128(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Float128;
}

bool clang_isa_BuiltinType_NullPtr(CXType_ T) {
  return static_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::NullPtr;
}

// ComplexType
CXQualType clang_ComplexType_getElementType(CXComplexType T) {
  return static_cast<clang::ComplexType *>(T)->getElementType().getAsOpaquePtr();
}

bool clang_ComplexType_isSugared(CXComplexType T) {
  return static_cast<clang::ComplexType *>(T)->isSugared();
}

CXQualType clang_ComplexType_desugar(CXComplexType T) {
  return static_cast<clang::ComplexType *>(T)->desugar().getAsOpaquePtr();
}

// ParenType
CXQualType clang_ParenType_getInnerType(CXParenType T) {
  return static_cast<clang::ParenType *>(T)->getInnerType().getAsOpaquePtr();
}

bool clang_ParenType_isSugared(CXParenType T) {
  return static_cast<clang::ParenType *>(T)->isSugared();
}

CXQualType clang_ParenType_desugar(CXParenType T) {
  return static_cast<clang::ParenType *>(T)->desugar().getAsOpaquePtr();
}

// PointerType
CXQualType clang_PointerType_getPointeeType(CXPointerType T) {
  return static_cast<clang::PointerType *>(T)->getPointeeType().getAsOpaquePtr();
}

bool clang_PointerType_isSugared(CXPointerType T) {
  return static_cast<clang::PointerType *>(T)->isSugared();
}

CXQualType clang_PointerType_desugar(CXPointerType T) {
  return static_cast<clang::PointerType *>(T)->desugar().getAsOpaquePtr();
}

// AdjustedType
CXQualType clang_AdjustedType_getOriginalType(CXAdjustedType T) {
  return static_cast<clang::AdjustedType *>(T)->getOriginalType().getAsOpaquePtr();
}

CXQualType clang_AdjustedType_getAdjustedType(CXAdjustedType T) {
  return static_cast<clang::AdjustedType *>(T)->getAdjustedType().getAsOpaquePtr();
}

bool clang_AdjustedType_isSugared(CXAdjustedType T) {
  return static_cast<clang::AdjustedType *>(T)->isSugared();
}

CXQualType clang_AdjustedType_desugar(CXAdjustedType T) {
  return static_cast<clang::AdjustedType *>(T)->desugar().getAsOpaquePtr();
}

// DecayedType
CXQualType clang_DecayedType_getDecayedType(CXDecayedType T) {
  return static_cast<clang::DecayedType *>(T)->getDecayedType().getAsOpaquePtr();
}

CXQualType clang_DecayedType_getPointeeType(CXDecayedType T) {
  return static_cast<clang::DecayedType *>(T)->getPointeeType().getAsOpaquePtr();
}

// ReferenceType
bool clang_ReferenceType_isSpelledAsLValue(CXReferenceType T) {
  return static_cast<clang::ReferenceType *>(T)->isSpelledAsLValue();
}

bool clang_ReferenceType_isInnerRef(CXReferenceType T) {
  return static_cast<clang::ReferenceType *>(T)->isInnerRef();
}

CXQualType clang_ReferenceType_getPointeeTypeAsWritten(CXReferenceType T) {
  return static_cast<clang::ReferenceType *>(T)->getPointeeTypeAsWritten().getAsOpaquePtr();
}

CXQualType clang_ReferenceType_getPointeeType(CXReferenceType T) {
  return static_cast<clang::ReferenceType *>(T)->getPointeeType().getAsOpaquePtr();
}

// LValueReferenceType
bool clang_LValueReferenceType_isSugared(CXLValueReferenceType T) {
  return static_cast<clang::LValueReferenceType *>(T)->isSugared();
}

CXQualType clang_LValueReferenceType_desugar(CXLValueReferenceType T) {
  return static_cast<clang::LValueReferenceType *>(T)->desugar().getAsOpaquePtr();
}

// RValueReferenceType
bool clang_RValueReferenceType_isSugared(CXRValueReferenceType T) {
  return static_cast<clang::RValueReferenceType *>(T)->isSugared();
}

CXQualType clang_RValueReferenceType_desugar(CXRValueReferenceType T) {
  return static_cast<clang::RValueReferenceType *>(T)->desugar().getAsOpaquePtr();
}

// MemberPointerType
CXQualType clang_MemberPointerType_getPointeeType(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->getPointeeType().getAsOpaquePtr();
}

bool clang_MemberPointerType_isMemberFunctionPointerType(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->isMemberFunctionPointerType();
}

bool clang_MemberPointerType_isMemberDataPointerType(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->isMemberDataPointerType();
}

CXType_ clang_MemberPointerType_getClass(CXMemberPointerType T) {
  return const_cast<clang::Type *>(static_cast<clang::MemberPointerType *>(T)->getClass());
}

CXCXXRecordDecl clang_MemberPointerType_getMostRecentCXXRecordDecl(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->getMostRecentCXXRecordDecl();
}

bool clang_MemberPointerType_isSugared(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->isSugared();
}

CXQualType clang_MemberPointerType_desugar(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->desugar().getAsOpaquePtr();
}

// ArrayType
CXQualType clang_ArrayType_getElementType(CXArrayType T) {
  return static_cast<clang::ArrayType *>(T)->getElementType().getAsOpaquePtr();
}

CXArraySizeModifier clang_ArrayType_getSizeModifier(CXArrayType T) {
  return static_cast<CXArraySizeModifier>(
      static_cast<clang::ArrayType *>(T)->getSizeModifier());
}

unsigned clang_ArrayType_getIndexTypeCVRQualifiers(CXArrayType T) {
  return static_cast<clang::ArrayType *>(T)->getIndexTypeCVRQualifiers();
}

// ConstantArrayType
CXExpr clang_ConstantArrayType_getSizeExpr(CXConstantArrayType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::ConstantArrayType *>(T)->getSizeExpr());
}

bool clang_ConstantArrayType_isSugared(CXConstantArrayType T) {
  return static_cast<clang::ConstantArrayType *>(T)->isSugared();
}

CXQualType clang_ConstantArrayType_desugar(CXConstantArrayType T) {
  return static_cast<clang::ConstantArrayType *>(T)->desugar().getAsOpaquePtr();
}

unsigned clang_ConstantArrayType_getNumAddressingBits(CXConstantArrayType T,
                                                      CXASTContext C) {
  return static_cast<clang::ConstantArrayType *>(T)->getNumAddressingBits(
      *static_cast<clang::ASTContext *>(C));
}

// IncompleteArrayType
bool clang_IncompleteArrayType_isSugared(CXIncompleteArrayType T) {
  return static_cast<clang::IncompleteArrayType *>(T)->isSugared();
}

CXQualType clang_IncompleteArrayType_desugar(CXIncompleteArrayType T) {
  return static_cast<clang::IncompleteArrayType *>(T)->desugar().getAsOpaquePtr();
}

// VariableArrayType
CXExpr clang_VariableArrayType_getSizeExpr(CXVariableArrayType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::VariableArrayType *>(T)->getSizeExpr());
}

bool clang_VariableArrayType_isSugared(CXVariableArrayType T) {
  return static_cast<clang::VariableArrayType *>(T)->isSugared();
}

CXQualType clang_VariableArrayType_desugar(CXVariableArrayType T) {
  return static_cast<clang::VariableArrayType *>(T)->desugar().getAsOpaquePtr();
}

// DependentSizedArrayType
CXExpr clang_DependentSizedArrayType_getSizeExpr(CXDependentSizedArrayType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::DependentSizedArrayType *>(T)->getSizeExpr());
}

bool clang_DependentSizedArrayType_isSugared(CXDependentSizedArrayType T) {
  return static_cast<clang::DependentSizedArrayType *>(T)->isSugared();
}

CXQualType clang_DependentSizedArrayType_desugar(CXDependentSizedArrayType T) {
  return static_cast<clang::DependentSizedArrayType *>(T)->desugar().getAsOpaquePtr();
}

// DepedentAddressSpaceType
CXExpr clang_DependentAddressSpaceType_getAddrSpaceExpr(CXDependentAddressSpaceType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::DependentAddressSpaceType *>(T)->getAddrSpaceExpr());
}

CXQualType clang_DependentAddressSpaceType_getPointeeType(CXDependentAddressSpaceType T) {
  return static_cast<clang::DependentAddressSpaceType *>(T)
      ->getPointeeType()
      .getAsOpaquePtr();
}

bool clang_DependentAddressSpaceType_isSugared(CXDependentAddressSpaceType T) {
  return static_cast<clang::DependentAddressSpaceType *>(T)->isSugared();
}

CXQualType clang_DependentAddressSpaceType_desugar(CXDependentAddressSpaceType T) {
  return static_cast<clang::DependentAddressSpaceType *>(T)->desugar().getAsOpaquePtr();
}

// DependentSizedExtVectorType
CXExpr clang_DependentSizedExtVectorType_getSizeExpr(CXDependentSizedExtVectorType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::DependentSizedExtVectorType *>(T)->getSizeExpr());
}

CXQualType
clang_DependentSizedExtVectorType_getElementType(CXDependentSizedExtVectorType T) {
  return static_cast<clang::DependentSizedExtVectorType *>(T)
      ->getElementType()
      .getAsOpaquePtr();
}

bool clang_DependentSizedExtVectorType_isSugared(CXDependentSizedExtVectorType T) {
  return static_cast<clang::DependentSizedExtVectorType *>(T)->isSugared();
}

CXQualType clang_DependentSizedExtVectorType_desugar(CXDependentSizedExtVectorType T) {
  return static_cast<clang::DependentSizedExtVectorType *>(T)->desugar().getAsOpaquePtr();
}

// FunctionType
CXQualType clang_FunctionType_getReturnType(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->getReturnType().getAsOpaquePtr();
}

bool clang_FunctionType_getHasRegParm(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->getHasRegParm();
}

unsigned clang_FunctionType_getRegParmType(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->getRegParmType();
}

bool clang_FunctionType_getNoReturnAttr(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->getNoReturnAttr();
}

bool clang_FunctionType_getCmseNSCallAttr(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->getCmseNSCallAttr();
}

bool clang_FunctionType_isConst(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->isConst();
}

bool clang_FunctionType_isVolatile(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->isVolatile();
}

bool clang_FunctionType_isRestrict(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->isRestrict();
}

// FunctionNoProtoType
bool clang_FunctionNoProtoType_isSugared(CXFunctionNoProtoType T) {
  return static_cast<clang::FunctionNoProtoType *>(T)->isSugared();
}

CXQualType clang_FunctionNoProtoType_desugar(CXFunctionNoProtoType T) {
  return static_cast<clang::FunctionNoProtoType *>(T)->desugar().getAsOpaquePtr();
}

// FunctionProtoType
unsigned clang_FunctionProtoType_getNumParams(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->getNumParams();
}

CXQualType clang_FunctionProtoType_getParamType(CXFunctionProtoType T, unsigned i) {
  return static_cast<clang::FunctionProtoType *>(T)->getParamType(i).getAsOpaquePtr();
}

CXArrayRef clang_FunctionProtoType_getParamTypes(CXFunctionProtoType T) {
  auto arr = static_cast<clang::FunctionProtoType *>(T)->getParamTypes();
  return {arr.data(), arr.size()};
}

bool clang_FunctionProtoType_hasExceptionSpec(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->hasExceptionSpec();
}

bool clang_FunctionProtoType_hasDynamicExceptionSpec(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->hasDynamicExceptionSpec();
}

bool clang_FunctionProtoType_hasNoexceptExceptionSpec(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->hasNoexceptExceptionSpec();
}

bool clang_FunctionProtoType_hasDependentExceptionSpec(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->hasDependentExceptionSpec();
}

bool clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)
      ->hasInstantiationDependentExceptionSpec();
}

unsigned clang_FunctionProtoType_getNumExceptions(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->getNumExceptions();
}

CXQualType clang_FunctionProtoType_getExceptionType(CXFunctionProtoType T, unsigned i) {
  return static_cast<clang::FunctionProtoType *>(T)->getExceptionType(i).getAsOpaquePtr();
}

CXExpr clang_FunctionProtoType_getNoexceptExpr(CXFunctionProtoType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::FunctionProtoType *>(T)->getNoexceptExpr());
}

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecDecl(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->getExceptionSpecDecl();
}

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecTemplate(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->getExceptionSpecTemplate();
}

bool clang_FunctionProtoType_isNothrow(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->isNothrow();
}

bool clang_FunctionProtoType_isVariadic(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->isVariadic();
}

bool clang_FunctionProtoType_isTemplateVariadic(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->isTemplateVariadic();
}

bool clang_FunctionProtoType_hasTrailingReturn(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->hasTrailingReturn();
}

CXArrayRef clang_FunctionProtoType_param_types(CXFunctionProtoType T) {
  auto arr = static_cast<clang::FunctionProtoType *>(T)->param_types();
  return {arr.data(), arr.size()};
}

CXArrayRef clang_FunctionProtoType_exceptions(CXFunctionProtoType T) {
  auto arr = static_cast<clang::FunctionProtoType *>(T)->exceptions();
  return {arr.data(), arr.size()};
}

bool clang_FunctionProtoType_isSugared(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->isSugared();
}

CXQualType clang_FunctionProtoType_desugar(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->desugar().getAsOpaquePtr();
}

// UnresolvedUsingType
CXUnresolvedUsingTypenameDecl clang_UnresolvedUsingType_getDecl(CXUnresolvedUsingType T) {
  return static_cast<clang::UnresolvedUsingType *>(T)->getDecl();
}

bool clang_UnresolvedUsingType_isSugared(CXUnresolvedUsingType T) {
  return static_cast<clang::UnresolvedUsingType *>(T)->isSugared();
}

CXQualType clang_UnresolvedUsingType_desugar(CXUnresolvedUsingType T) {
  return static_cast<clang::UnresolvedUsingType *>(T)->desugar().getAsOpaquePtr();
}

// UsingType
CXUsingShadowDecl clang_UsingType_getFoundDecl(CXUsingType T) {
  return static_cast<clang::UsingType *>(T)->getFoundDecl();
}

CXQualType clang_UsingType_getUnderlyingType(CXUsingType T) {
  return static_cast<clang::UsingType *>(T)->getUnderlyingType().getAsOpaquePtr();
}

bool clang_UsingType_isSugared(CXUsingType T) {
  return static_cast<clang::UsingType *>(T)->isSugared();
}

CXQualType clang_UsingType_desugar(CXUsingType T) {
  return static_cast<clang::UsingType *>(T)->desugar().getAsOpaquePtr();
}

// TypedefType
CXTypedefNameDecl clang_TypedefType_getDecl(CXTypedefType T) {
  return static_cast<clang::TypedefType *>(T)->getDecl();
}

bool clang_TypedefType_isSugared(CXTypedefType T) {
  return static_cast<clang::TypedefType *>(T)->isSugared();
}

CXQualType clang_TypedefType_desugar(CXTypedefType T) {
  return static_cast<clang::TypedefType *>(T)->desugar().getAsOpaquePtr();
}

// MacroQualifiedType
CXIdentifierInfo clang_MacroQualifiedType_getMacroIdentifier(CXMacroQualifiedType T) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::MacroQualifiedType *>(T)->getMacroIdentifier());
}

CXQualType clang_MacroQualifiedType_getUnderlyingType(CXMacroQualifiedType T) {
  return static_cast<clang::MacroQualifiedType *>(T)->getUnderlyingType().getAsOpaquePtr();
}

CXQualType clang_MacroQualifiedType_getModifiedType(CXMacroQualifiedType T) {
  return static_cast<clang::MacroQualifiedType *>(T)->getModifiedType().getAsOpaquePtr();
}

bool clang_MacroQualifiedType_isSugared(CXMacroQualifiedType T) {
  return static_cast<clang::MacroQualifiedType *>(T)->isSugared();
}

CXQualType clang_MacroQualifiedType_desugar(CXMacroQualifiedType T) {
  return static_cast<clang::MacroQualifiedType *>(T)->desugar().getAsOpaquePtr();
}

// TypeOfExprType

// DependentTypeOfExprType

// TypeOfType

// DecltypeType
CXExpr clang_DecltypeType_getUnderlyingExpr(CXDecltypeType T) {
  return const_cast<clang::Expr *>(
      static_cast<clang::DecltypeType *>(T)->getUnderlyingExpr());
}

CXQualType clang_DecltypeType_getUnderlyingType(CXDecltypeType T) {
  return static_cast<clang::DecltypeType *>(T)->getUnderlyingType().getAsOpaquePtr();
}

bool clang_DecltypeType_isSugared(CXDecltypeType T) {
  return static_cast<clang::DecltypeType *>(T)->isSugared();
}

CXQualType clang_DecltypeType_desugar(CXDecltypeType T) {
  return static_cast<clang::DecltypeType *>(T)->desugar().getAsOpaquePtr();
}

// DependentDecltypeType

// UnaryTransformType
bool clang_UnaryTransformType_isSugared(CXUnaryTransformType T) {
  return static_cast<clang::UnaryTransformType *>(T)->isSugared();
}

CXQualType clang_UnaryTransformType_desugar(CXUnaryTransformType T) {
  return static_cast<clang::UnaryTransformType *>(T)->desugar().getAsOpaquePtr();
}

CXQualType clang_UnaryTransformType_getUnderlyingType(CXUnaryTransformType T) {
  return static_cast<clang::UnaryTransformType *>(T)->getUnderlyingType().getAsOpaquePtr();
}

CXQualType clang_UnaryTransformType_getBaseType(CXUnaryTransformType T) {
  return static_cast<clang::UnaryTransformType *>(T)->getBaseType().getAsOpaquePtr();
}

// DependentUnaryTransformType

// TagType
CXTagDecl clang_TagType_getDecl(CXTagType T) {
  return static_cast<clang::TagType *>(T)->getDecl();
}

// RecordType
CXRecordDecl clang_RecordType_getDecl(CXRecordType T) {
  return static_cast<clang::RecordType *>(T)->getDecl();
}

bool clang_RecordType_hasConstFields(CXRecordType T) {
  return static_cast<clang::RecordType *>(T)->hasConstFields();
}

bool clang_RecordType_isSugared(CXRecordType T) {
  return static_cast<clang::RecordType *>(T)->isSugared();
}

CXQualType clang_RecordType_desugar(CXRecordType T) {
  return static_cast<clang::RecordType *>(T)->desugar().getAsOpaquePtr();
}

// EnumType
CXEnumDecl clang_EnumType_getDecl(CXEnumType T) {
  return static_cast<clang::EnumType *>(T)->getDecl();
}

bool clang_EnumType_isSugared(CXEnumType T) {
  return static_cast<clang::EnumType *>(T)->isSugared();
}

CXQualType clang_EnumType_desugar(CXEnumType T) {
  return static_cast<clang::EnumType *>(T)->desugar().getAsOpaquePtr();
}

// AttributedType

// BTFTagAttributedType

// TemplateTypeParmType
unsigned clang_TemplateTypeParmType_getDepth(CXTemplateTypeParmType T) {
  return static_cast<clang::TemplateTypeParmType *>(T)->getDepth();
}

unsigned clang_TemplateTypeParmType_getIndex(CXTemplateTypeParmType T) {
  return static_cast<clang::TemplateTypeParmType *>(T)->getIndex();
}

bool clang_TemplateTypeParmType_isParameterPack(CXTemplateTypeParmType T) {
  return static_cast<clang::TemplateTypeParmType *>(T)->isParameterPack();
}

CXTemplateTypeParmDecl clang_TemplateTypeParmType_getDecl(CXTemplateTypeParmType T) {
  return static_cast<clang::TemplateTypeParmType *>(T)->getDecl();
}

bool clang_TemplateTypeParmType_isSugared(CXTemplateTypeParmType T) {
  return static_cast<clang::TemplateTypeParmType *>(T)->isSugared();
}

CXQualType clang_TemplateTypeParmType_desugar(CXTemplateTypeParmType T) {
  return static_cast<clang::TemplateTypeParmType *>(T)->desugar().getAsOpaquePtr();
}

// SubstTemplateTypeParmType
CXQualType
clang_SubstTemplateTypeParmType_getReplacementType(CXSubstTemplateTypeParmType T) {
  return static_cast<clang::SubstTemplateTypeParmType *>(T)
      ->getReplacementType()
      .getAsOpaquePtr();
}

CXDecl clang_SubstTemplateTypeParmType_getAssociatedDecl(CXSubstTemplateTypeParmType T) {
  return static_cast<clang::SubstTemplateTypeParmType *>(T)->getAssociatedDecl();
}

CXTemplateTypeParmDecl
clang_SubstTemplateTypeParmType_getReplacedParameter(CXSubstTemplateTypeParmType T) {
  return const_cast<clang::TemplateTypeParmDecl *>(
      static_cast<clang::SubstTemplateTypeParmType *>(T)->getReplacedParameter());
}

unsigned clang_SubstTemplateTypeParmType_getIndex(CXSubstTemplateTypeParmType T) {
  return static_cast<clang::SubstTemplateTypeParmType *>(T)->getIndex();
}

bool clang_SubstTemplateTypeParmType_isSugared(CXSubstTemplateTypeParmType T) {
  return static_cast<clang::SubstTemplateTypeParmType *>(T)->isSugared();
}

CXQualType clang_SubstTemplateTypeParmType_desugar(CXSubstTemplateTypeParmType T) {
  return static_cast<clang::SubstTemplateTypeParmType *>(T)->desugar().getAsOpaquePtr();
}

// SubstTemplateTypeParmPackType
CXDecl
clang_SubstTemplateTypeParmPackType_getAssociatedDecl(CXSubstTemplateTypeParmPackType T) {
  return static_cast<clang::SubstTemplateTypeParmPackType *>(T)->getAssociatedDecl();
}

CXTemplateTypeParmDecl clang_SubstTemplateTypeParmPackType_getReplacedParameter(
    CXSubstTemplateTypeParmPackType T) {
  return const_cast<clang::TemplateTypeParmDecl *>(
      static_cast<clang::SubstTemplateTypeParmPackType *>(T)->getReplacedParameter());
}

unsigned clang_SubstTemplateTypeParmPackType_getIndex(CXSubstTemplateTypeParmPackType T) {
  return static_cast<clang::SubstTemplateTypeParmPackType *>(T)->getIndex();
}

bool clang_SubstTemplateTypeParmPackType_getFinal(CXSubstTemplateTypeParmPackType T) {
  return static_cast<clang::SubstTemplateTypeParmPackType *>(T)->getFinal();
}

unsigned clang_SubstTemplateTypeParmPackType_getNumArgs(CXSubstTemplateTypeParmPackType T) {
  return static_cast<clang::SubstTemplateTypeParmPackType *>(T)->getNumArgs();
}

bool clang_SubstTemplateTypeParmPackType_isSugared(CXSubstTemplateTypeParmPackType T) {
  return static_cast<clang::SubstTemplateTypeParmPackType *>(T)->isSugared();
}

CXQualType clang_SubstTemplateTypeParmPackType_desugar(CXSubstTemplateTypeParmPackType T) {
  return static_cast<clang::SubstTemplateTypeParmPackType *>(T)->desugar().getAsOpaquePtr();
}

CXArrayRef
clang_SubstTemplateTypeParmPackType_getArgumentPack(CXSubstTemplateTypeParmPackType T) {
  auto arr = static_cast<clang::SubstTemplateTypeParmPackType *>(T)
                 ->getArgumentPack()
                 .getPackAsArray();
  return {arr.data(), arr.size()};
}

// DeducedType
bool clang_DeducedType_isSugared(CXDeducedType T) {
  return static_cast<clang::DeducedType *>(T)->isSugared();
}

CXQualType clang_DeducedType_desugar(CXDeducedType T) {
  return static_cast<clang::DeducedType *>(T)->desugar().getAsOpaquePtr();
}

CXQualType clang_DeducedType_getDeducedType(CXDeducedType T) {
  return static_cast<clang::DeducedType *>(T)->getDeducedType().getAsOpaquePtr();
}

bool clang_DeducedType_isDeduced(CXDeducedType T) {
  return static_cast<clang::DeducedType *>(T)->isDeduced();
}

// AutoType

// DeducedTemplateSpecializationType
CXTemplateName clang_DeducedTemplateSpecializationType_getTemplateName(
    CXDeducedTemplateSpecializationType T) {
  return static_cast<clang::DeducedTemplateSpecializationType *>(T)
      ->getTemplateName()
      .getAsVoidPointer();
}

// TemplateSpecializationType
bool clang_TemplateSpecializationType_isCurrentInstantiation(
    CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->isCurrentInstantiation();
}

bool clang_TemplateSpecializationType_isTypeAlias(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->isTypeAlias();
}

CXQualType clang_TemplateSpecializationType_getAliasedType(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)
      ->getAliasedType()
      .getAsOpaquePtr();
}

CXTemplateName
clang_TemplateSpecializationType_getTemplateName(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)
      ->getTemplateName()
      .getAsVoidPointer();
}

CXArrayRef
clang_TemplateSpecializationType_template_arguments(CXTemplateSpecializationType T) {
  auto arr = static_cast<clang::TemplateSpecializationType *>(T)->template_arguments();
  return {arr.data(), arr.size()};
}

bool clang_TemplateSpecializationType_isSugared(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->isSugared();
}

CXQualType clang_TemplateSpecializationType_desugar(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->desugar().getAsOpaquePtr();
}

// InjectedClassNameType
CXQualType
clang_InjectedClassNameType_getInjectedSpecializationType(CXInjectedClassNameType T) {
  return static_cast<clang::InjectedClassNameType *>(T)
      ->getInjectedSpecializationType()
      .getAsOpaquePtr();
}

CXTemplateSpecializationType
clang_InjectedClassNameType_getInjectedTST(CXInjectedClassNameType T) {
  return const_cast<clang::TemplateSpecializationType *>(
      static_cast<clang::InjectedClassNameType *>(T)->getInjectedTST());
}

CXTemplateName clang_InjectedClassNameType_getTemplateName(CXInjectedClassNameType T) {
  return static_cast<clang::InjectedClassNameType *>(T)
      ->getTemplateName()
      .getAsVoidPointer();
}

CXCXXRecordDecl clang_InjectedClassNameType_getDecl(CXInjectedClassNameType T) {
  return static_cast<clang::InjectedClassNameType *>(T)->getDecl();
}

bool clang_InjectedClassNameType_isSugared(CXInjectedClassNameType T) {
  return static_cast<clang::InjectedClassNameType *>(T)->isSugared();
}

CXQualType clang_InjectedClassNameType_desugar(CXInjectedClassNameType T) {
  return static_cast<clang::InjectedClassNameType *>(T)->desugar().getAsOpaquePtr();
}

// TypeWithKeyword

// ElaboratedType
CXNestedNameSpecifier clang_ElaboratedType_getQualifier(CXElaboratedType T) {
  return static_cast<clang::ElaboratedType *>(T)->getQualifier();
}

CXQualType clang_ElaboratedType_getNamedType(CXElaboratedType T) {
  return static_cast<clang::ElaboratedType *>(T)->getNamedType().getAsOpaquePtr();
}

CXQualType clang_ElaboratedType_desugar(CXElaboratedType T) {
  return static_cast<clang::ElaboratedType *>(T)->desugar().getAsOpaquePtr();
}

bool clang_ElaboratedType_isSugared(CXElaboratedType T) {
  return static_cast<clang::ElaboratedType *>(T)->isSugared();
}

CXTagDecl clang_ElaboratedType_getOwnedTagDecl(CXElaboratedType T) {
  return static_cast<clang::ElaboratedType *>(T)->getOwnedTagDecl();
}

// DependentNameType
CXNestedNameSpecifier clang_DependentNameType_getQualifier(CXDependentNameType T) {
  return static_cast<clang::DependentNameType *>(T)->getQualifier();
}

CXIdentifierInfo clang_DependentNameType_getIdentifier(CXDependentNameType T) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::DependentNameType *>(T)->getIdentifier());
}

bool clang_DependentNameType_isSugared(CXDependentNameType T) {
  return static_cast<clang::DependentNameType *>(T)->isSugared();
}

CXQualType clang_DependentNameType_desugar(CXDependentNameType T) {
  return static_cast<clang::DependentNameType *>(T)->desugar().getAsOpaquePtr();
}

// DependentTemplateSpecializationType
CXNestedNameSpecifier clang_DependentTemplateSpecializationType_getQualifier(
    CXDependentTemplateSpecializationType T) {
  return static_cast<clang::DependentTemplateSpecializationType *>(T)->getQualifier();
}

CXIdentifierInfo clang_DependentTemplateSpecializationType_getIdentifier(
    CXDependentTemplateSpecializationType T) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::DependentTemplateSpecializationType *>(T)->getIdentifier());
}

CXArrayRef clang_DependentTemplateSpecializationType_template_arguments(
    CXDependentTemplateSpecializationType T) {
  auto arr =
      static_cast<clang::DependentTemplateSpecializationType *>(T)->template_arguments();
  return {arr.data(), arr.size()};
}

bool clang_DependentTemplateSpecializationType_isSugared(
    CXDependentTemplateSpecializationType T) {
  return static_cast<clang::DependentTemplateSpecializationType *>(T)->isSugared();
}

CXQualType
clang_DependentTemplateSpecializationType_desugar(CXDependentTemplateSpecializationType T) {
  return static_cast<clang::DependentTemplateSpecializationType *>(T)
      ->desugar()
      .getAsOpaquePtr();
}

// PackExpansionType

// AtomicType
CXQualType clang_AtomicType_getValueType(CXAtomicType T) {
  return static_cast<clang::AtomicType *>(T)->getValueType().getAsOpaquePtr();
}

bool clang_AtomicType_isSugared(CXAtomicType T) {
  return static_cast<clang::AtomicType *>(T)->isSugared();
}

CXQualType clang_AtomicType_desugar(CXAtomicType T) {
  return static_cast<clang::AtomicType *>(T)->desugar().getAsOpaquePtr();
}

// PipeType

// BitIntType

// DependentBitIntType