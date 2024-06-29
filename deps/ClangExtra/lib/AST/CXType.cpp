#include "clang-ex/AST/CXType.h"
#include "libclang/CXString.h"
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
  return clang::cxstring::createDup(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getAsString());
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

bool clang_Type_isPromotableIntegerType(CXType_ T) {
  return static_cast<clang::Type *>(T)->isPromotableIntegerType();
}

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
bool clang_isa_BuiltinType(CXType_ T) {
  return llvm::isa<clang::BuiltinType>(static_cast<clang::Type *>(T));
}

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

// PointerType
CXQualType clang_PointerType_getPointeeType(CXPointerType T) {
  return static_cast<clang::PointerType *>(T)->getPointeeType().getAsOpaquePtr();
}

// MemberPointerType
CXQualType clang_MemberPointerType_getPointeeType(CXMemberPointerType T) {
  return static_cast<clang::MemberPointerType *>(T)->getPointeeType().getAsOpaquePtr();
}

CXType_ clang_MemberPointerType_getClass(CXMemberPointerType T) {
  return const_cast<clang::Type *>(static_cast<clang::MemberPointerType *>(T)->getClass());
}

// TypedefType
CXQualType clang_TypedefType_desugar(CXTypedefType T) {
  return static_cast<clang::TypedefType *>(T)->desugar().getAsOpaquePtr();
}

// EnumType
CXEnumDecl clang_EnumType_getDecl(CXEnumType T) {
  return static_cast<clang::EnumType *>(T)->getDecl();
}

// FunctionType
CXQualType clang_FunctionType_getReturnType(CXFunctionType T) {
  return static_cast<clang::FunctionType *>(T)->getReturnType().getAsOpaquePtr();
}

// FunctionProtoType
unsigned clang_FunctionProtoType_getNumParams(CXFunctionProtoType T) {
  return static_cast<clang::FunctionProtoType *>(T)->getNumParams();
}

CXQualType clang_FunctionProtoType_getParamType(CXFunctionProtoType T, unsigned i) {
  return static_cast<clang::FunctionProtoType *>(T)->getParamType(i).getAsOpaquePtr();
}

// ReferenceType
CXQualType clang_ReferenceType_getPointeeType(CXReferenceType T) {
  return static_cast<clang::ReferenceType *>(T)->getPointeeType().getAsOpaquePtr();
}

// ElaboratedType
CXQualType clang_ElaboratedType_desugar(CXElaboratedType T) {
  return static_cast<clang::ElaboratedType *>(T)->desugar().getAsOpaquePtr();
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

unsigned clang_TemplateSpecializationType_getNumArgs(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->getNumArgs();
}

CXTemplateArgument clang_TemplateSpecializationType_getArg(CXTemplateSpecializationType T,
                                                           unsigned Idx) {
  return const_cast<clang::TemplateArgument *>(
      &static_cast<clang::TemplateSpecializationType *>(T)->getArg(Idx));
}

bool clang_TemplateSpecializationType_isSugared(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->isSugared();
}

CXQualType clang_TemplateSpecializationType_desugar(CXTemplateSpecializationType T) {
  return static_cast<clang::TemplateSpecializationType *>(T)->desugar().getAsOpaquePtr();
}
