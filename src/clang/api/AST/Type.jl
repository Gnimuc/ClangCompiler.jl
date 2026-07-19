# QualType
QualType(ptr::CXType_, quals::Unsigned) = QualType(clang_QualType_constructFromTypePtr(ptr), quals)

getTypePtr(x::QualType) = Type_(clang_QualType_getTypePtr(x))
getTypePtrOrNull(x::QualType) = Type_(clang_QualType_getTypePtrOrNull(x))

isCanonical(x::QualType) = clang_QualType_isCanonical(x)

isNull(x::QualType) = clang_QualType_isNull(x)

isConstQualified(x::QualType) = clang_QualType_isConstQualified(x)
isRestrictQualified(x::QualType) = clang_QualType_isRestrictQualified(x)
isVolatileQualified(x::QualType) = clang_QualType_isVolatileQualified(x)

hasQualifiers(x::QualType) = clang_QualType_hasQualifiers(x)

withConst(x::QualType) = QualType(clang_QualType_withConst(x))
withRestrict(x::QualType) = QualType(clang_QualType_withRestrict(x))
withVolatile(x::QualType) = QualType(clang_QualType_withVolatile(x))

addConst(x::QualType) = QualType(clang_QualType_addConst(x))
addRestrict(x::QualType) = QualType(clang_QualType_addRestrict(x))
addVolatile(x::QualType) = QualType(clang_QualType_addVolatile(x))

isLocalConstQualified(x::QualType) = clang_QualType_isLocalConstQualified(x)
isLocalRestrictQualified(x::QualType) = clang_QualType_isLocalRestrictQualified(x)
isLocalVolatileQualified(x::QualType) = clang_QualType_isLocalVolatileQualified(x)

hasLocalQualifiers(x::QualType) = clang_QualType_hasLocalQualifiers(x)

getCVRQualifiers(x::QualType) = clang_QualType_getCVRQualifiers(x)

getAsString(x::QualType) = get_string(clang_QualType_getAsString(x))

dump(x::QualType) = clang_QualType_dump(x)

getCanonicalType(x::QualType) = QualType(clang_QualType_getCanonicalType(x))

getLocalUnqualifiedType(x::QualType) = QualType(clang_QualType_getLocalUnqualifiedType(x))

getUnqualifiedType(x::QualType) = QualType(clang_QualType_getUnqualifiedType(x))

# Type
function getCanonicalTypeInternal(x::AbstractType)
    @check_ptrs x
    return QualType(clang_Type_getCanonicalTypeInternal(x))
end

function canDecayToPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_canDecayToPointerType(x)
end

function dump(x::AbstractType)
    @check_ptrs x
    return clang_Type_dump(x)
end

function getArrayElementTypeNoTypeQual(x::AbstractType)
    @check_ptrs x
    return Type_(clang_Type_getArrayElementTypeNoTypeQual(x))
end

function getAsCXXRecordDecl(x::AbstractType)
    @check_ptrs x
    return CXXRecordDecl(clang_Type_getAsCXXRecordDecl(x))
end

function getAsComplexIntegerType(x::AbstractType)
    @check_ptrs x
    return ComplexType(clang_Type_getAsComplexIntegerType(x))
end

function getAsRecordDecl(x::AbstractType)
    @check_ptrs x
    return RecordDecl(clang_Type_getAsRecordDecl(x))
end

function getAsStructureType(x::AbstractType)
    @check_ptrs x
    return RecordType(clang_Type_getAsStructureType(x))
end

function getAsTagDecl(x::AbstractType)
    @check_ptrs x
    return TagDecl(clang_Type_getAsTagDecl(x))
end

function getAsUnionType(x::AbstractType)
    @check_ptrs x
    return RecordType(clang_Type_getAsUnionType(x))
end

function getPointeeCXXRecordDecl(x::AbstractType)
    @check_ptrs x
    return CXXRecordDecl(clang_Type_getPointeeCXXRecordDecl(x))
end

function getPointeeOrArrayElementType(x::AbstractType)
    @check_ptrs x
    return Type_(clang_Type_getPointeeOrArrayElementType(x))
end

function getUnqualifiedDesugaredType(x::AbstractType)
    @check_ptrs x
    return Type_(clang_Type_getUnqualifiedDesugaredType(x))
end

function hasAutoForTrailingReturnType(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasAutoForTrailingReturnType(x)
end

function hasFloatingRepresentation(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasFloatingRepresentation(x)
end

function hasIntegerRepresentation(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasIntegerRepresentation(x)
end

function hasObjCPointerRepresentation(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasObjCPointerRepresentation(x)
end

function hasPointerRepresentation(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasPointerRepresentation(x)
end

function hasSignedIntegerRepresentation(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasSignedIntegerRepresentation(x)
end

function hasSizedVLAType(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasSizedVLAType(x)
end

function hasUnnamedOrLocalType(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasUnnamedOrLocalType(x)
end

function hasUnsignedIntegerRepresentation(x::AbstractType)
    @check_ptrs x
    return clang_Type_hasUnsignedIntegerRepresentation(x)
end

function isAggregateType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isAggregateType(x)
end

function isAlignValT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isAlignValT(x)
end

function isAnyCharacterType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isAnyCharacterType(x)
end

function isAnyComplexType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isAnyComplexType(x)
end

function isAnyPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isAnyPointerType(x)
end

function isArithmeticType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isArithmeticType(x)
end

function isAtomicType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isAtomicType(x)
end

function isBFloat16Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isBFloat16Type(x)
end

function isBlockPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isBlockPointerType(x)
end

function isCanonicalUnqualified(x::AbstractType)
    @check_ptrs x
    return clang_Type_isCanonicalUnqualified(x)
end

function isChar16Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isChar16Type(x)
end

function isChar32Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isChar32Type(x)
end

function isChar8Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isChar8Type(x)
end

function isClassType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isClassType(x)
end

function isComplexIntegerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isComplexIntegerType(x)
end

function isCompoundType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isCompoundType(x)
end

function isConstantMatrixType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isConstantMatrixType(x)
end

function isConstantSizeType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isConstantSizeType(x)
end

function isDecltypeType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isDecltypeType(x)
end

function isDependentAddressSpaceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isDependentAddressSpaceType(x)
end

function isDependentType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isDependentType(x)
end

function isElaboratedTypeSpecifier(x::AbstractType)
    @check_ptrs x
    return clang_Type_isElaboratedTypeSpecifier(x)
end

function isExtVectorType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isExtVectorType(x)
end

function isFixedPointOrIntegerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFixedPointOrIntegerType(x)
end

function isFixedPointType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFixedPointType(x)
end

function isFloat128Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFloat128Type(x)
end

function isFloat16Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFloat16Type(x)
end

function isFloatingType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFloatingType(x)
end

function isFromAST(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFromAST(x)
end

function isFunctionReferenceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFunctionReferenceType(x)
end

function isFundamentalType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFundamentalType(x)
end

function isHalfType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isHalfType(x)
end

function isInstantiationDependentType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isInstantiationDependentType(x)
end

function isIntegerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIntegerType(x)
end

function isIntegralOrEnumerationType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIntegralOrEnumerationType(x)
end

function isIntegralOrUnscopedEnumerationType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIntegralOrUnscopedEnumerationType(x)
end

function isInterfaceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isInterfaceType(x)
end

function isLinkageValid(x::AbstractType)
    @check_ptrs x
    return clang_Type_isLinkageValid(x)
end

function isMatrixType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isMatrixType(x)
end

function isMemberDataPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isMemberDataPointerType(x)
end

function isNothrowT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isNothrowT(x)
end

function isNullPtrType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isNullPtrType(x)
end

function isObjCBoxableRecordType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCBoxableRecordType(x)
end

function isObjectPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjectPointerType(x)
end

function isOverloadableType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isOverloadableType(x)
end

function isRealFloatingType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isRealFloatingType(x)
end

function isRealType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isRealType(x)
end

function isSaturatedFixedPointType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSaturatedFixedPointType(x)
end

function isScalarType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isScalarType(x)
end

function isScopedEnumeralType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isScopedEnumeralType(x)
end

function isSignedFixedPointType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSignedFixedPointType(x)
end

function isSignedIntegerOrEnumerationType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSignedIntegerOrEnumerationType(x)
end

function isSignedIntegerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSignedIntegerType(x)
end

function isSizelessBuiltinType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSizelessBuiltinType(x)
end

function isSizelessType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSizelessType(x)
end

function isSpecifierType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSpecifierType(x)
end

function isStdByteType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isStdByteType(x)
end

function isStructureOrClassType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isStructureOrClassType(x)
end

function isStructureType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isStructureType(x)
end

function isTypedefNameType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isTypedefNameType(x)
end

function isUndeducedAutoType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUndeducedAutoType(x)
end

function isUndeducedType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUndeducedType(x)
end

function isUnionType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUnionType(x)
end

function isUnsaturatedFixedPointType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUnsaturatedFixedPointType(x)
end

function isUnscopedEnumerationType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUnscopedEnumerationType(x)
end

function isUnsignedFixedPointType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUnsignedFixedPointType(x)
end

function isUnsignedIntegerOrEnumerationType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUnsignedIntegerOrEnumerationType(x)
end

function isUnsignedIntegerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isUnsignedIntegerType(x)
end

function isVariablyModifiedType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isVariablyModifiedType(x)
end

function isVectorType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isVectorType(x)
end

function isVisibilityExplicit(x::AbstractType)
    @check_ptrs x
    return clang_Type_isVisibilityExplicit(x)
end

function isVoidPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isVoidPointerType(x)
end

function isWideCharType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isWideCharType(x)
end

# getPointeeType(x::AbstractType) = getTypePtr(QualType(clang_Type_getPointeeType(x)))

function isVoidType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isVoidType(x)
end

function isBooleanType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isBooleanType(x)
end

function isPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isPointerType(x)
end

function isFunctionPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFunctionPointerType(x)
end

function isFunctionType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFunctionType(x)
end

function isMemberFunctionPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isMemberFunctionPointerType(x)
end

function isReferenceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isReferenceType(x)
end

function isCharType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isCharType(x)
end

function isEnumeralType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isEnumeralType(x)
end

function isBuiltinType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isBuiltinType(x)
end

function isComplexType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isComplexType(x)
end

function isArrayType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isArrayType(x)
end

function isLValueReferenceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isLValueReferenceType(x)
end

function isRValueReferenceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isRValueReferenceType(x)
end

function isMemberPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isMemberPointerType(x)
end

function isConstantArrayType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isConstantArrayType(x)
end

function isIncompleteArrayType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIncompleteArrayType(x)
end

function isVariableArrayType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isVariableArrayType(x)
end

function isDependentSizedArrayType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isDependentSizedArrayType(x)
end

function isFunctionNoProtoType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFunctionNoProtoType(x)
end

function isFunctionProtoType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isFunctionProtoType(x)
end

function isRecordType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isRecordType(x)
end

function isTemplateTypeParmType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isTemplateTypeParmType(x)
end

# extra
function isa_TypedefType(x::AbstractType)
    @check_ptrs x
    return clang_isa_TypedefType(x)
end

function isa_TagType(x::AbstractType)
    @check_ptrs x
    return clang_isa_TagType(x)
end

function isa_EnumType(x::AbstractType)
    @check_ptrs x
    return clang_isa_EnumType(x)
end

function isa_SubstTemplateTypeParmType(x::AbstractType)
    @check_ptrs x
    return clang_isa_SubstTemplateTypeParmType(x)
end

function isa_SubstTemplateTypeParmPackType(x::AbstractType)
    @check_ptrs x
    return clang_isa_SubstTemplateTypeParmPackType(x)
end

function isa_TemplateSpecializationType(x::AbstractType)
    @check_ptrs x
    return clang_isa_TemplateSpecializationType(x)
end

function isa_ElaboratedType(x::AbstractType)
    @check_ptrs x
    return clang_isa_ElaboratedType(x)
end

function isa_DependentNameType(x::AbstractType)
    @check_ptrs x
    return clang_isa_DependentNameType(x)
end

function isa_DependentTemplateSpecializationType(x::AbstractType)
    @check_ptrs x
    return clang_isa_DependentTemplateSpecializationType(x)
end

function clang_isa_UnresolvedUsingType(x::AbstractType)
    @check_ptrs x
    return clang_isa_UnresolvedUsingType(x)
end

function isa_UsingType(x::AbstractType)
    @check_ptrs x
    return clang_isa_UsingType(x)
end

# BuiltinTypes
function isa_BuiltinType_Void(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Void(x)
end

function isa_BuiltinType_Bool(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Bool(x)
end

function isa_BuiltinType_Char_U(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Char_U(x)
end

function isa_BuiltinType_Char_S(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Char_S(x)
end

function isa_BuiltinType_WChar_U(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_WChar_U(x)
end

function isa_BuiltinType_WChar_S(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_WChar_S(x)
end

function isa_BuiltinType_Char8(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Char8(x)
end

function isa_BuiltinType_Char16(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Char16(x)
end

function isa_BuiltinType_Char32(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Char32(x)
end

function isa_BuiltinType_SChar(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_SChar(x)
end

function isa_BuiltinType_Short(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Short(x)
end

function isa_BuiltinType_Int(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Int(x)
end

function isa_BuiltinType_Long(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Long(x)
end

function isa_BuiltinType_LongLong(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_LongLong(x)
end

function isa_BuiltinType_Int128(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Int128(x)
end

function isa_BuiltinType_UChar(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_UChar(x)
end

function isa_BuiltinType_UShort(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_UShort(x)
end

function isa_BuiltinType_UInt(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_UInt(x)
end

function isa_BuiltinType_ULong(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_ULong(x)
end

function isa_BuiltinType_ULongLong(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_ULongLong(x)
end

function isa_BuiltinType_UInt128(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_UInt128(x)
end

function isa_BuiltinType_Float(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Float(x)
end

function isa_BuiltinType_Double(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Double(x)
end

function isa_BuiltinType_LongDouble(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_LongDouble(x)
end

function isa_BuiltinType_Float128(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Float128(x)
end

function isa_BuiltinType_Half(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Half(x)
end

function isa_BuiltinType_BFloat16(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_BFloat16(x)
end

function isa_BuiltinType_Float16(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_Float16(x)
end

function isa_BuiltinType_NullPtr(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_isa_BuiltinType_NullPtr(x)
end

# ComplexType

function desugar(x::AbstractComplexType)
    @check_ptrs x
    return QualType(clang_ComplexType_desugar(x))
end

function getElementType(x::AbstractComplexType)
    @check_ptrs x
    return QualType(clang_ComplexType_getElementType(x))
end

function isSugared(x::AbstractComplexType)
    @check_ptrs x
    return clang_ComplexType_isSugared(x)
end

# PointerType
function getPointeeType(x::PointerType)
    @check_ptrs x
    return QualType(clang_PointerType_getPointeeType(x))
end

function desugar(x::AbstractPointerType)
    @check_ptrs x
    return QualType(clang_PointerType_desugar(x))
end

function isSugared(x::AbstractPointerType)
    @check_ptrs x
    return clang_PointerType_isSugared(x)
end

# ReferenceType
function getPointeeType(x::AbstractReferenceType)
    @check_ptrs x
    return QualType(clang_ReferenceType_getPointeeType(x))
end

function getPointeeTypeAsWritten(x::AbstractReferenceType)
    @check_ptrs x
    return QualType(clang_ReferenceType_getPointeeTypeAsWritten(x))
end

function isInnerRef(x::AbstractReferenceType)
    @check_ptrs x
    return clang_ReferenceType_isInnerRef(x)
end

function isSpelledAsLValue(x::AbstractReferenceType)
    @check_ptrs x
    return clang_ReferenceType_isSpelledAsLValue(x)
end

# LValueReferenceType

function desugar(x::AbstractLValueReferenceType)
    @check_ptrs x
    return QualType(clang_LValueReferenceType_desugar(x))
end

function isSugared(x::AbstractLValueReferenceType)
    @check_ptrs x
    return clang_LValueReferenceType_isSugared(x)
end

# RValueReferenceType

function desugar(x::AbstractRValueReferenceType)
    @check_ptrs x
    return QualType(clang_RValueReferenceType_desugar(x))
end

function isSugared(x::AbstractRValueReferenceType)
    @check_ptrs x
    return clang_RValueReferenceType_isSugared(x)
end

# MemberPointerType
function getPointeeType(x::AbstractMemberPointerType)
    @check_ptrs x
    return QualType(clang_MemberPointerType_getPointeeType(x))
end

function getClass(x::AbstractMemberPointerType)
    @check_ptrs x
    return Type_(clang_MemberPointerType_getClass(x))
end

function desugar(x::AbstractMemberPointerType)
    @check_ptrs x
    return QualType(clang_MemberPointerType_desugar(x))
end

function getMostRecentCXXRecordDecl(x::AbstractMemberPointerType)
    @check_ptrs x
    return CXXRecordDecl(clang_MemberPointerType_getMostRecentCXXRecordDecl(x))
end

function isMemberDataPointer(x::AbstractMemberPointerType)
    @check_ptrs x
    return clang_MemberPointerType_isMemberDataPointer(x)
end

function isMemberFunctionPointer(x::AbstractMemberPointerType)
    @check_ptrs x
    return clang_MemberPointerType_isMemberFunctionPointer(x)
end

function isSugared(x::AbstractMemberPointerType)
    @check_ptrs x
    return clang_MemberPointerType_isSugared(x)
end

# ConstantArrayType

function desugar(x::AbstractConstantArrayType)
    @check_ptrs x
    return QualType(clang_ConstantArrayType_desugar(x))
end

function getSizeExpr(x::AbstractConstantArrayType)
    @check_ptrs x
    return Expr_(clang_ConstantArrayType_getSizeExpr(x))
end

function isSugared(x::AbstractConstantArrayType)
    @check_ptrs x
    return clang_ConstantArrayType_isSugared(x)
end

# IncompleteArrayType

function desugar(x::AbstractIncompleteArrayType)
    @check_ptrs x
    return QualType(clang_IncompleteArrayType_desugar(x))
end

function isSugared(x::AbstractIncompleteArrayType)
    @check_ptrs x
    return clang_IncompleteArrayType_isSugared(x)
end

# VariableArrayType

function desugar(x::AbstractVariableArrayType)
    @check_ptrs x
    return QualType(clang_VariableArrayType_desugar(x))
end

function getSizeExpr(x::AbstractVariableArrayType)
    @check_ptrs x
    return Expr_(clang_VariableArrayType_getSizeExpr(x))
end

function isSugared(x::AbstractVariableArrayType)
    @check_ptrs x
    return clang_VariableArrayType_isSugared(x)
end

# DependentSizedArrayType

function desugar(x::AbstractDependentSizedArrayType)
    @check_ptrs x
    return QualType(clang_DependentSizedArrayType_desugar(x))
end

function getSizeExpr(x::AbstractDependentSizedArrayType)
    @check_ptrs x
    return Expr_(clang_DependentSizedArrayType_getSizeExpr(x))
end

function isSugared(x::AbstractDependentSizedArrayType)
    @check_ptrs x
    return clang_DependentSizedArrayType_isSugared(x)
end

# FunctionType
function getReturnType(x::AbstractFunctionType)
    @check_ptrs x
    return QualType(clang_FunctionType_getReturnType(get_qual_type(x)))
end

function getCmseNSCallAttr(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_getCmseNSCallAttr(x)
end

function getHasRegParm(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_getHasRegParm(x)
end

function getNoReturnAttr(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_getNoReturnAttr(x)
end

function getRegParmType(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_getRegParmType(x)
end

function isConst(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_isConst(x)
end

function isRestrict(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_isRestrict(x)
end

function isVolatile(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_isVolatile(x)
end

# FunctionNoProtoType

function desugar(x::AbstractFunctionNoProtoType)
    @check_ptrs x
    return QualType(clang_FunctionNoProtoType_desugar(x))
end

function isSugared(x::AbstractFunctionNoProtoType)
    @check_ptrs x
    return clang_FunctionNoProtoType_isSugared(x)
end

# FunctionProtoType
function getNumParams(x::FunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getNumParams(x)
end

function getParamType(x::FunctionProtoType, i::Integer)
    @check_ptrs x
    return QualType(clang_FunctionProtoType_getParamType(x, i))
end

function isNoThrow(x::FunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_isNothrow(x)
end

function desugar(x::AbstractFunctionProtoType)
    @check_ptrs x
    return QualType(clang_FunctionProtoType_desugar(x))
end

function getExceptionSpecDecl(x::AbstractFunctionProtoType)
    @check_ptrs x
    return FunctionDecl(clang_FunctionProtoType_getExceptionSpecDecl(x))
end

function getExceptionSpecTemplate(x::AbstractFunctionProtoType)
    @check_ptrs x
    return FunctionDecl(clang_FunctionProtoType_getExceptionSpecTemplate(x))
end

function getNoexceptExpr(x::AbstractFunctionProtoType)
    @check_ptrs x
    return Expr_(clang_FunctionProtoType_getNoexceptExpr(x))
end

function getNumExceptions(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getNumExceptions(x)
end

function hasDependentExceptionSpec(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasDependentExceptionSpec(x)
end

function hasDynamicExceptionSpec(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasDynamicExceptionSpec(x)
end

function hasExceptionSpec(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasExceptionSpec(x)
end

function hasInstantiationDependentExceptionSpec(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(x)
end

function hasNoexceptExceptionSpec(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasNoexceptExceptionSpec(x)
end

function hasTrailingReturn(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasTrailingReturn(x)
end

function isSugared(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_isSugared(x)
end

function isTemplateVariadic(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_isTemplateVariadic(x)
end

function isVariadic(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_isVariadic(x)
end

# UsingType
function desugar(x::UsingType)
    @check_ptrs x
    return QualType(clang_UsingType_desugar(x))
end

function getFoundDecl(x::AbstractUsingType)
    @check_ptrs x
    return UsingShadowDecl(clang_UsingType_getFoundDecl(x))
end

function getUnderlyingType(x::AbstractUsingType)
    @check_ptrs x
    return QualType(clang_UsingType_getUnderlyingType(x))
end

function isSugared(x::AbstractUsingType)
    @check_ptrs x
    return clang_UsingType_isSugared(x)
end

# TypedefType
function desugar(x::TypedefType)
    @check_ptrs x
    return QualType(clang_TypedefType_desugar(x))
end

function getDecl(x::AbstractTypedefType)
    @check_ptrs x
    return TypedefNameDecl(clang_TypedefType_getDecl(x))
end

function isSugared(x::AbstractTypedefType)
    @check_ptrs x
    return clang_TypedefType_isSugared(x)
end

# TagType
function getDecl(x::TagType)
    @check_ptrs x
    return TagDecl(clang_TagType_getDecl(x))
end

# RecordType
function getDecl(x::RecordType)
    @check_ptrs x
    return RecordDecl(clang_RecordType_getDecl(x))
end

function desugar(x::AbstractRecordType)
    @check_ptrs x
    return QualType(clang_RecordType_desugar(x))
end

function hasConstFields(x::AbstractRecordType)
    @check_ptrs x
    return clang_RecordType_hasConstFields(x)
end

function isSugared(x::AbstractRecordType)
    @check_ptrs x
    return clang_RecordType_isSugared(x)
end

# EnumType
function getDecl(x::EnumType)
    @check_ptrs x
    return EnumDecl(clang_EnumType_getDecl(x))
end

function getIntegerType(x::EnumType)
    @check_ptrs x
    return getIntegerType(getDecl(x))
end

function getName(x::EnumType)
    @check_ptrs x
    return getName(getDecl(x))
end

function desugar(x::AbstractEnumType)
    @check_ptrs x
    return QualType(clang_EnumType_desugar(x))
end

function isSugared(x::AbstractEnumType)
    @check_ptrs x
    return clang_EnumType_isSugared(x)
end

# TemplateTypeParmType

function desugar(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return QualType(clang_TemplateTypeParmType_desugar(x))
end

function getDecl(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return TemplateTypeParmDecl(clang_TemplateTypeParmType_getDecl(x))
end

function getDepth(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return clang_TemplateTypeParmType_getDepth(x)
end

function getIndex(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return clang_TemplateTypeParmType_getIndex(x)
end

function isParameterPack(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return clang_TemplateTypeParmType_isParameterPack(x)
end

function isSugared(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return clang_TemplateTypeParmType_isSugared(x)
end

# SubstTemplateTypeParmType
function getReplacementType(x::SubstTemplateTypeParmType)
    @check_ptrs x
    return QualType(clang_SubstTemplateTypeParmType_getReplacementType(x))
end

function desugar(x::SubstTemplateTypeParmType)
    @check_ptrs x
    return QualType(clang_SubstTemplateTypeParmType_desugar(x))
end

function getAssociatedDecl(x::AbstractSubstTemplateTypeParmType)
    @check_ptrs x
    return Decl(clang_SubstTemplateTypeParmType_getAssociatedDecl(x))
end

function getIndex(x::AbstractSubstTemplateTypeParmType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmType_getIndex(x)
end

function getReplacedParameter(x::AbstractSubstTemplateTypeParmType)
    @check_ptrs x
    return TemplateTypeParmDecl(clang_SubstTemplateTypeParmType_getReplacedParameter(x))
end

function isSugared(x::AbstractSubstTemplateTypeParmType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmType_isSugared(x)
end

# SubstTemplateTypeParmPackType

function desugar(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return QualType(clang_SubstTemplateTypeParmPackType_desugar(x))
end

function getAssociatedDecl(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return Decl(clang_SubstTemplateTypeParmPackType_getAssociatedDecl(x))
end

function getFinal(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmPackType_getFinal(x)
end

function getIndex(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmPackType_getIndex(x)
end

function getNumArgs(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmPackType_getNumArgs(x)
end

function getReplacedParameter(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return TemplateTypeParmDecl(clang_SubstTemplateTypeParmPackType_getReplacedParameter(x))
end

function isSugared(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmPackType_isSugared(x)
end

# TemplateSpecializationType
function isCurrentInstantiation(x::TemplateSpecializationType)
    @check_ptrs x
    return clang_TemplateSpecializationType_isCurrentInstantiation(x)
end

function isTypeAlias(x::TemplateSpecializationType)
    @check_ptrs x
    return clang_TemplateSpecializationType_isTypeAlias(x)
end

function getAliasedType(x::TemplateSpecializationType)
    @check_ptrs x
    return QualType(clang_TemplateSpecializationType_getAliasedType(x))
end

function getTemplateArguments(x::TemplateSpecializationType)
    @check_ptrs x
    return clang_TemplateSpecializationType_template_arguments(x)
end

function isSugared(x::TemplateSpecializationType)
    @check_ptrs x
    return clang_TemplateSpecializationType_isSugared(x)
end

function desugar(x::TemplateSpecializationType)
    @check_ptrs x
    return QualType(clang_TemplateSpecializationType_desugar(x))
end

function getName(x::TemplateSpecializationType)
    @check_ptrs x
    return getName(getAsTemplateDecl(getTemplateName(x)))
end

# ElaboratedType
function desugar(x::ElaboratedType)
    @check_ptrs x
    return QualType(clang_ElaboratedType_desugar(x))
end

function getNamedType(x::AbstractElaboratedType)
    @check_ptrs x
    return QualType(clang_ElaboratedType_getNamedType(x))
end

function getOwnedTagDecl(x::AbstractElaboratedType)
    @check_ptrs x
    return TagDecl(clang_ElaboratedType_getOwnedTagDecl(x))
end

function getQualifier(x::AbstractElaboratedType)
    @check_ptrs x
    return NestedNameSpecifier(clang_ElaboratedType_getQualifier(x))
end

function isSugared(x::AbstractElaboratedType)
    @check_ptrs x
    return clang_ElaboratedType_isSugared(x)
end

# DependentNameType

function desugar(x::AbstractDependentNameType)
    @check_ptrs x
    return QualType(clang_DependentNameType_desugar(x))
end

function getIdentifier(x::AbstractDependentNameType)
    @check_ptrs x
    return IdentifierInfo(clang_DependentNameType_getIdentifier(x))
end

function getQualifier(x::AbstractDependentNameType)
    @check_ptrs x
    return NestedNameSpecifier(clang_DependentNameType_getQualifier(x))
end

function isSugared(x::AbstractDependentNameType)
    @check_ptrs x
    return clang_DependentNameType_isSugared(x)
end

# DependentTemplateSpecializationType

function desugar(x::AbstractDependentTemplateSpecializationType)
    @check_ptrs x
    return QualType(clang_DependentTemplateSpecializationType_desugar(x))
end

function getIdentifier(x::AbstractDependentTemplateSpecializationType)
    @check_ptrs x
    return IdentifierInfo(clang_DependentTemplateSpecializationType_getIdentifier(x))
end

function getQualifier(x::AbstractDependentTemplateSpecializationType)
    @check_ptrs x
    return NestedNameSpecifier(clang_DependentTemplateSpecializationType_getQualifier(x))
end

function isSugared(x::AbstractDependentTemplateSpecializationType)
    @check_ptrs x
    return clang_DependentTemplateSpecializationType_isSugared(x)
end


# ArrayType
# ---- Increment 1a: generated accessors for existing-carrier type classes ----

function getElementType(x::AbstractArrayType)
    @check_ptrs x
    return QualType(clang_ArrayType_getElementType(x))
end

function getIndexTypeCVRQualifiers(x::AbstractArrayType)
    @check_ptrs x
    return clang_ArrayType_getIndexTypeCVRQualifiers(x)
end

function getSizeModifier(x::AbstractArrayType)
    @check_ptrs x
    return clang_ArrayType_getSizeModifier(x)
end

# UnresolvedUsingType
function desugar(x::AbstractUnresolvedUsingType)
    @check_ptrs x
    return QualType(clang_UnresolvedUsingType_desugar(x))
end

function getDecl(x::AbstractUnresolvedUsingType)
    @check_ptrs x
    return UnresolvedUsingTypenameDecl(clang_UnresolvedUsingType_getDecl(x))
end

function isSugared(x::AbstractUnresolvedUsingType)
    @check_ptrs x
    return clang_UnresolvedUsingType_isSugared(x)
end

