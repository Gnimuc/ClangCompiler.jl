# QualType
QualType(ty::Type_, quals::Integer=0) = QualType(clang_QualType_constructFromTypePtr(ty, quals))

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

"""
    getQualifiersAsOpaqueValue(x::QualType) -> UInt32
Return the type's full `clang::Qualifiers` set as its opaque encoding — the
qualifier bits plus address space and lifetime, where `getCVRQualifiers`
carries only const/volatile/restrict.
"""
getQualifiersAsOpaqueValue(x::QualType) = clang_QualType_getQualifiersAsOpaqueValue(x)

getLocalFastQualifiers(x::QualType) = clang_QualType_getLocalFastQualifiers(x)

hasAddressSpace(x::QualType) = clang_QualType_hasAddressSpace(x)
getAddressSpace(x::QualType) = clang_QualType_getAddressSpace(x)

"""
    isDestructedType(x::QualType) -> CXDestructionKind
Return the kind of cleanup objects of this type require, or
`CXDestructionKind_DK_none` when they are trivially destructible.
"""
isDestructedType(x::QualType) = clang_QualType_isDestructedType(x)

isMoreQualifiedThan(x::QualType, other::QualType) = clang_QualType_isMoreQualifiedThan(x, other)
isAtLeastAsQualifiedAs(x::QualType, other::QualType) = clang_QualType_isAtLeastAsQualifiedAs(x,
                                                                                             other)

getNonReferenceType(x::QualType) = QualType(clang_QualType_getNonReferenceType(x))
IgnoreParens(x::QualType) = QualType(clang_QualType_IgnoreParens(x))

# The ASTContext-taking cluster: sugar removal and the POD/trivial family.
function getDesugaredType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return QualType(clang_QualType_getDesugaredType(x, ctx))
end

function getSingleStepDesugaredType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return QualType(clang_QualType_getSingleStepDesugaredType(x, ctx))
end

function isConstant(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isConstant(x, ctx)
end

function isPODType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isPODType(x, ctx)
end

function isCXX98PODType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isCXX98PODType(x, ctx)
end

function isCXX11PODType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isCXX11PODType(x, ctx)
end

function isTrivialType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isTrivialType(x, ctx)
end

function isTriviallyCopyableType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isTriviallyCopyableType(x, ctx)
end

function isTriviallyCopyConstructibleType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isTriviallyCopyConstructibleType(x, ctx)
end

function isTriviallyRelocatableType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isTriviallyRelocatableType(x, ctx)
end

getAsString(x::QualType) = get_string(clang_QualType_getAsString(x))

dump(x::QualType) = clang_QualType_dump(x)

getCanonicalType(x::QualType) = QualType(clang_QualType_getCanonicalType(x))

getLocalUnqualifiedType(x::QualType) = QualType(clang_QualType_getLocalUnqualifiedType(x))

getUnqualifiedType(x::QualType) = QualType(clang_QualType_getUnqualifiedType(x))

# Type
function getTypeClass(x::AbstractType)
    @check_ptrs x
    return clang_Type_getTypeClass(x)
end

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

function getContainedDeducedType(x::AbstractType)
    @check_ptrs x
    return DeducedType(clang_Type_getContainedDeducedType(x))
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

# `Type::getPointeeType` handles every pointer-like class (pointers,
# references, member pointers, ObjC pointers, blocks) and returns a null
# QualType otherwise; the per-class methods below shadow it where they exist.
function getPointeeType(x::AbstractType)
    @check_ptrs x
    return QualType(clang_Type_getPointeeType(x))
end

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

function isa_UnresolvedUsingType(x::AbstractType)
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

function getNumAddressingBits(x::AbstractConstantArrayType, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_ConstantArrayType_getNumAddressingBits(x, ctx)
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
    return QualType(clang_FunctionType_getReturnType(x))
end

function getCallConv(x::AbstractFunctionType)
    @check_ptrs x
    return clang_FunctionType_getCallConv(x)
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

# Borrowed CXArrayRef views into the prototype's AST-owned parameter/exception
# arrays; elements are CXQualType encodings.
function getParamTypes(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getParamTypes(x)
end

function param_types(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_param_types(x)
end

function exceptions(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_exceptions(x)
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

function getExceptionType(x::AbstractFunctionProtoType, i::Integer)
    @check_ptrs x
    return QualType(clang_FunctionProtoType_getExceptionType(x, i))
end

function getExceptionSpecType(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getExceptionSpecType(x)
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

# Borrowed CXArrayRef view of the pack's TemplateArgument array.
function getArgumentPack(x::AbstractSubstTemplateTypeParmPackType)
    @check_ptrs x
    return clang_SubstTemplateTypeParmPackType_getArgumentPack(x)
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

function getNumArgs(x::TemplateSpecializationType)
    @check_ptrs x
    return clang_TemplateSpecializationType_getNumArgs(x)
end

function getArg(x::TemplateSpecializationType, i::Integer)
    @check_ptrs x
    return TemplateArgument(clang_TemplateSpecializationType_getArg(x, i))
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

function getTemplateArguments(x::AbstractDependentTemplateSpecializationType)
    @check_ptrs x
    return clang_DependentTemplateSpecializationType_template_arguments(x)
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


# Sugar-type classification predicates (dyn_cast-based isa over clang::Type).
isa_AtomicType(x::AbstractType) = (@check_ptrs x; clang_isa_AtomicType(x))
isa_AdjustedType(x::AbstractType) = (@check_ptrs x; clang_isa_AdjustedType(x))
isa_DecayedType(x::AbstractType) = (@check_ptrs x; clang_isa_DecayedType(x))
isa_InjectedClassNameType(x::AbstractType) = (@check_ptrs x; clang_isa_InjectedClassNameType(x))
isa_MacroQualifiedType(x::AbstractType) = (@check_ptrs x; clang_isa_MacroQualifiedType(x))
isa_UnaryTransformType(x::AbstractType) = (@check_ptrs x; clang_isa_UnaryTransformType(x))
isa_ParenType(x::AbstractType) = (@check_ptrs x; clang_isa_ParenType(x))
isa_DependentAddressSpaceType(x::AbstractType) = (@check_ptrs x; clang_isa_DependentAddressSpaceType(x))
isa_DependentSizedExtVectorType(x::AbstractType) = (@check_ptrs x; clang_isa_DependentSizedExtVectorType(x))
isa_DecltypeType(x::AbstractType) = (@check_ptrs x; clang_isa_DecltypeType(x))
isa_DeducedType(x::AbstractType) = (@check_ptrs x; clang_isa_DeducedType(x))
isa_DeducedTemplateSpecializationType(x::AbstractType) = (@check_ptrs x; clang_isa_DeducedTemplateSpecializationType(x))
isa_ComplexType(x::AbstractType) = (@check_ptrs x; clang_isa_ComplexType(x))
isa_PointerType(x::AbstractType) = (@check_ptrs x; clang_isa_PointerType(x))
isa_ReferenceType(x::AbstractType) = (@check_ptrs x; clang_isa_ReferenceType(x))
isa_LValueReferenceType(x::AbstractType) = (@check_ptrs x; clang_isa_LValueReferenceType(x))
isa_RValueReferenceType(x::AbstractType) = (@check_ptrs x; clang_isa_RValueReferenceType(x))
isa_MemberPointerType(x::AbstractType) = (@check_ptrs x; clang_isa_MemberPointerType(x))
isa_ArrayType(x::AbstractType) = (@check_ptrs x; clang_isa_ArrayType(x))
isa_ConstantArrayType(x::AbstractType) = (@check_ptrs x; clang_isa_ConstantArrayType(x))
isa_IncompleteArrayType(x::AbstractType) = (@check_ptrs x; clang_isa_IncompleteArrayType(x))
isa_VariableArrayType(x::AbstractType) = (@check_ptrs x; clang_isa_VariableArrayType(x))
isa_DependentSizedArrayType(x::AbstractType) = (@check_ptrs x; clang_isa_DependentSizedArrayType(x))
isa_FunctionType(x::AbstractType) = (@check_ptrs x; clang_isa_FunctionType(x))
isa_FunctionNoProtoType(x::AbstractType) = (@check_ptrs x; clang_isa_FunctionNoProtoType(x))
isa_FunctionProtoType(x::AbstractType) = (@check_ptrs x; clang_isa_FunctionProtoType(x))
isa_DependentDecltypeType(x::AbstractType) = (@check_ptrs x; clang_isa_DependentDecltypeType(x))
isa_RecordType(x::AbstractType) = (@check_ptrs x; clang_isa_RecordType(x))
isa_TemplateTypeParmType(x::AbstractType) = (@check_ptrs x; clang_isa_TemplateTypeParmType(x))
isa_AutoType(x::AbstractType) = (@check_ptrs x; clang_isa_AutoType(x))

# AdjustedType
function desugar(x::AbstractAdjustedType)
    @check_ptrs x
    return QualType(clang_AdjustedType_desugar(x))
end

function getAdjustedType(x::AbstractAdjustedType)
    @check_ptrs x
    return QualType(clang_AdjustedType_getAdjustedType(x))
end

function getOriginalType(x::AbstractAdjustedType)
    @check_ptrs x
    return QualType(clang_AdjustedType_getOriginalType(x))
end

function isSugared(x::AbstractAdjustedType)
    @check_ptrs x
    return clang_AdjustedType_isSugared(x)
end

# AtomicType
function desugar(x::AbstractAtomicType)
    @check_ptrs x
    return QualType(clang_AtomicType_desugar(x))
end

function getValueType(x::AbstractAtomicType)
    @check_ptrs x
    return QualType(clang_AtomicType_getValueType(x))
end

function isSugared(x::AbstractAtomicType)
    @check_ptrs x
    return clang_AtomicType_isSugared(x)
end

# DecayedType
function getDecayedType(x::AbstractDecayedType)
    @check_ptrs x
    return QualType(clang_DecayedType_getDecayedType(x))
end

function getPointeeType(x::AbstractDecayedType)
    @check_ptrs x
    return QualType(clang_DecayedType_getPointeeType(x))
end

# DecltypeType
function desugar(x::AbstractDecltypeType)
    @check_ptrs x
    return QualType(clang_DecltypeType_desugar(x))
end

function getUnderlyingExpr(x::AbstractDecltypeType)
    @check_ptrs x
    return Expr_(clang_DecltypeType_getUnderlyingExpr(x))
end

function getUnderlyingType(x::AbstractDecltypeType)
    @check_ptrs x
    return QualType(clang_DecltypeType_getUnderlyingType(x))
end

function isSugared(x::AbstractDecltypeType)
    @check_ptrs x
    return clang_DecltypeType_isSugared(x)
end

# DeducedTemplateSpecializationType
function getTemplateName(x::AbstractDeducedTemplateSpecializationType)
    @check_ptrs x
    return TemplateName(clang_DeducedTemplateSpecializationType_getTemplateName(x))
end

# DeducedType
function desugar(x::AbstractDeducedType)
    @check_ptrs x
    return QualType(clang_DeducedType_desugar(x))
end

function getDeducedType(x::AbstractDeducedType)
    @check_ptrs x
    return QualType(clang_DeducedType_getDeducedType(x))
end

function isDeduced(x::AbstractDeducedType)
    @check_ptrs x
    return clang_DeducedType_isDeduced(x)
end

function isSugared(x::AbstractDeducedType)
    @check_ptrs x
    return clang_DeducedType_isSugared(x)
end

# DependentAddressSpaceType
function desugar(x::AbstractDependentAddressSpaceType)
    @check_ptrs x
    return QualType(clang_DependentAddressSpaceType_desugar(x))
end

function getAddrSpaceExpr(x::AbstractDependentAddressSpaceType)
    @check_ptrs x
    return Expr_(clang_DependentAddressSpaceType_getAddrSpaceExpr(x))
end

function getPointeeType(x::AbstractDependentAddressSpaceType)
    @check_ptrs x
    return QualType(clang_DependentAddressSpaceType_getPointeeType(x))
end

function isSugared(x::AbstractDependentAddressSpaceType)
    @check_ptrs x
    return clang_DependentAddressSpaceType_isSugared(x)
end

# DependentSizedExtVectorType
function desugar(x::AbstractDependentSizedExtVectorType)
    @check_ptrs x
    return QualType(clang_DependentSizedExtVectorType_desugar(x))
end

function getElementType(x::AbstractDependentSizedExtVectorType)
    @check_ptrs x
    return QualType(clang_DependentSizedExtVectorType_getElementType(x))
end

function getSizeExpr(x::AbstractDependentSizedExtVectorType)
    @check_ptrs x
    return Expr_(clang_DependentSizedExtVectorType_getSizeExpr(x))
end

function isSugared(x::AbstractDependentSizedExtVectorType)
    @check_ptrs x
    return clang_DependentSizedExtVectorType_isSugared(x)
end

# InjectedClassNameType
function desugar(x::AbstractInjectedClassNameType)
    @check_ptrs x
    return QualType(clang_InjectedClassNameType_desugar(x))
end

function getDecl(x::AbstractInjectedClassNameType)
    @check_ptrs x
    return CXXRecordDecl(clang_InjectedClassNameType_getDecl(x))
end

function getInjectedSpecializationType(x::AbstractInjectedClassNameType)
    @check_ptrs x
    return QualType(clang_InjectedClassNameType_getInjectedSpecializationType(x))
end

function getInjectedTST(x::AbstractInjectedClassNameType)
    @check_ptrs x
    return TemplateSpecializationType(clang_InjectedClassNameType_getInjectedTST(x))
end

function getTemplateName(x::AbstractInjectedClassNameType)
    @check_ptrs x
    return TemplateName(clang_InjectedClassNameType_getTemplateName(x))
end

function isSugared(x::AbstractInjectedClassNameType)
    @check_ptrs x
    return clang_InjectedClassNameType_isSugared(x)
end

# MacroQualifiedType
function desugar(x::AbstractMacroQualifiedType)
    @check_ptrs x
    return QualType(clang_MacroQualifiedType_desugar(x))
end

function getMacroIdentifier(x::AbstractMacroQualifiedType)
    @check_ptrs x
    return IdentifierInfo(clang_MacroQualifiedType_getMacroIdentifier(x))
end

function getModifiedType(x::AbstractMacroQualifiedType)
    @check_ptrs x
    return QualType(clang_MacroQualifiedType_getModifiedType(x))
end

function getUnderlyingType(x::AbstractMacroQualifiedType)
    @check_ptrs x
    return QualType(clang_MacroQualifiedType_getUnderlyingType(x))
end

function isSugared(x::AbstractMacroQualifiedType)
    @check_ptrs x
    return clang_MacroQualifiedType_isSugared(x)
end

# ParenType
function desugar(x::AbstractParenType)
    @check_ptrs x
    return QualType(clang_ParenType_desugar(x))
end

function getInnerType(x::AbstractParenType)
    @check_ptrs x
    return QualType(clang_ParenType_getInnerType(x))
end

function isSugared(x::AbstractParenType)
    @check_ptrs x
    return clang_ParenType_isSugared(x)
end

# UnaryTransformType
function desugar(x::AbstractUnaryTransformType)
    @check_ptrs x
    return QualType(clang_UnaryTransformType_desugar(x))
end

function getBaseType(x::AbstractUnaryTransformType)
    @check_ptrs x
    return QualType(clang_UnaryTransformType_getBaseType(x))
end

function getUnderlyingType(x::AbstractUnaryTransformType)
    @check_ptrs x
    return QualType(clang_UnaryTransformType_getUnderlyingType(x))
end

function isSugared(x::AbstractUnaryTransformType)
    @check_ptrs x
    return clang_UnaryTransformType_isSugared(x)
end



# Type -- parameterised / ASTContext-taking queries and navigation helpers
function containsUnexpandedParameterPack(x::AbstractType)
    @check_ptrs x
    return clang_Type_containsUnexpandedParameterPack(x)
end

function containsErrors(x::AbstractType)
    @check_ptrs x
    return clang_Type_containsErrors(x)
end

function getLocallyUnqualifiedSingleStepDesugaredType(x::AbstractType)
    @check_ptrs x
    return QualType(clang_Type_getLocallyUnqualifiedSingleStepDesugaredType(x))
end

"""
    isIncompleteType(x::AbstractType)
    isIncompleteType(x::AbstractType, def::Ref{CXNamedDecl})
Return whether `x` is an incomplete type. The two-argument form fills `def` with the
declaration that would complete `x` (NULL when there is none); prefer the snake_case
helper `get_definition_if_incomplete` in `src/clang/type.jl` over handling the ref by hand.
"""
function isIncompleteType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIncompleteType(x, C_NULL)
end

function isIncompleteType(x::AbstractType, def::Ref{CXNamedDecl})
    @check_ptrs x
    return clang_Type_isIncompleteType(x, def)
end

function isIncompleteOrObjectType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIncompleteOrObjectType(x)
end

function isObjectType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjectType(x)
end

function isPlaceholderType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isPlaceholderType(x)
end

function getAsPlaceholderType(x::AbstractType)
    @check_ptrs x
    return BuiltinType(clang_Type_getAsPlaceholderType(x))
end

function isIntegralType(x::AbstractType, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Type_isIntegralType(x, ctx)
end

function isBitIntType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isBitIntType(x)
end

"""
    getScalarTypeKind(x::AbstractType)
Classify a scalar type. `Type::getScalarTypeKind` asserts `isScalarType()` on entry and
falls through to `llvm_unreachable` otherwise, so the precondition is restated here.
"""
function getScalarTypeKind(x::AbstractType)
    @check_ptrs x
    @assert isScalarType(x) "getScalarTypeKind requires a scalar type"
    return clang_Type_getScalarTypeKind(x)
end

function getAsArrayTypeUnsafe(x::AbstractType)
    @check_ptrs x
    return ArrayType(clang_Type_getAsArrayTypeUnsafe(x))
end

"""
    castAsArrayTypeUnsafe(x::AbstractType)
The `castAs<>` form of [`getAsArrayTypeUnsafe`](@ref): it never returns NULL and performs
no check, so the canonical type must already be an array type.
"""
function castAsArrayTypeUnsafe(x::AbstractType)
    @check_ptrs x
    @assert isArrayType(x) "castAsArrayTypeUnsafe requires an array type"
    return ArrayType(clang_Type_castAsArrayTypeUnsafe(x))
end

function getBaseElementTypeUnsafe(x::AbstractType)
    @check_ptrs x
    return Type_(clang_Type_getBaseElementTypeUnsafe(x))
end

function getTypeClassName(x::AbstractType)
    @check_ptrs x
    return unsafe_string(clang_Type_getTypeClassName(x))
end


# VectorType
function getElementType(x::AbstractVectorType)
    @check_ptrs x
    return QualType(clang_VectorType_getElementType(x))
end

function getNumElements(x::AbstractVectorType)
    @check_ptrs x
    return clang_VectorType_getNumElements(x)
end

function isSugared(x::AbstractVectorType)
    @check_ptrs x
    return clang_VectorType_isSugared(x)
end

function desugar(x::AbstractVectorType)
    @check_ptrs x
    return QualType(clang_VectorType_desugar(x))
end

# ConstantArrayType
"""
    getSize(x::AbstractConstantArrayType) -> LLVMGenericValueRef
Return the array's element count as a caller-owned `LLVMGenericValueRef`
(release via LLVM-C's `LLVMDisposeGenericValue`; no Julia `dispose` method
exists for it), matching `getValue(::AbstractIntegerLiteral)`.
"""
function getSize(x::AbstractConstantArrayType)
    @check_ptrs x
    return clang_ConstantArrayType_getSize(x)
end

# VariableArrayType
function getBracketsRange(x::AbstractVariableArrayType)
    @check_ptrs x
    r = clang_VariableArrayType_getBracketsRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# DependentSizedArrayType
function getBracketsRange(x::AbstractDependentSizedArrayType)
    @check_ptrs x
    r = clang_DependentSizedArrayType_getBracketsRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# FunctionProtoType
"""
    getMethodQuals(x::AbstractFunctionProtoType) -> UInt32
Return the member-function qualifiers of the prototype as the opaque
`clang::Qualifiers` encoding (rebuilt C++-side with `Qualifiers::fromOpaqueValue`),
the same encoding `getQualifiersAsOpaqueValue(::QualType)` returns.
"""
function getMethodQuals(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getMethodQuals(x)
end

"""
    isParamConsumed(x::AbstractFunctionProtoType, i::Integer)
Return whether the 0-based `i`-th parameter is ARC-consumed.

`clang::FunctionProtoType::isParamConsumed` asserts `i < getNumParams()` and
indexes trailing objects unchecked, so an out-of-range index is undefined
behaviour in the shim; the precondition is restated here.
"""
function isParamConsumed(x::AbstractFunctionProtoType, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_FunctionProtoType_getNumParams(x) "parameter index out of range"
    return clang_FunctionProtoType_isParamConsumed(x, i)
end

# TagType
function isBeingDefined(x::AbstractTagType)
    @check_ptrs x
    return clang_TagType_isBeingDefined(x)
end

# AttributedType
function getModifiedType(x::AbstractAttributedType)
    @check_ptrs x
    return QualType(clang_AttributedType_getModifiedType(x))
end

function getEquivalentType(x::AbstractAttributedType)
    @check_ptrs x
    return QualType(clang_AttributedType_getEquivalentType(x))
end

function isSugared(x::AbstractAttributedType)
    @check_ptrs x
    return clang_AttributedType_isSugared(x)
end

function desugar(x::AbstractAttributedType)
    @check_ptrs x
    return QualType(clang_AttributedType_desugar(x))
end

# AutoType
function getTypeConstraintConcept(x::AbstractAutoType)
    @check_ptrs x
    return ConceptDecl(clang_AutoType_getTypeConstraintConcept(x))
end

function isConstrained(x::AbstractAutoType)
    @check_ptrs x
    return clang_AutoType_isConstrained(x)
end

function isDecltypeAuto(x::AbstractAutoType)
    @check_ptrs x
    return clang_AutoType_isDecltypeAuto(x)
end

function isGNUAutoType(x::AbstractAutoType)
    @check_ptrs x
    return clang_AutoType_isGNUAutoType(x)
end

# PackExpansionType
function getPattern(x::AbstractPackExpansionType)
    @check_ptrs x
    return QualType(clang_PackExpansionType_getPattern(x))
end

"""
    getNumExpansions(x::AbstractPackExpansionType) -> Union{UInt32,Nothing}
Return the number of expansions this pack expansion generates, or `nothing`
when the count is not known yet (the C++ optional is disengaged).
"""
function getNumExpansions(x::AbstractPackExpansionType)
    @check_ptrs x
    n = Ref{Cuint}(0)
    return clang_PackExpansionType_getNumExpansions(x, n) ? n[] : nothing
end


# Qualifiers
# The Qualifiers value type has no carrier struct: it crosses as its opaque
# unsigned encoding (MARSHALLING.md §7), the same encoding
# `getQualifiersAsOpaqueValue(::QualType)` and `getMethodQuals` return. These
# wrappers therefore dispatch on `Integer` — there is no pointer to check.
"""
    fromCVRMask(cvr::Integer) -> UInt32
Build a `clang::Qualifiers` set from a const/volatile/restrict bit mask and
return its opaque encoding.

`clang::Qualifiers::addCVRQualifiers` asserts the mask carries no bits outside
const/volatile/restrict, so a wider mask is undefined behaviour in the shim; the
precondition is restated here. Prefer composing masks with `withConst`,
`withVolatile` and `withRestrict` over hard-coding the bit values.
"""
function fromCVRMask(cvr::Integer)
    @assert 0 <= cvr <= 7 "CVR mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_fromCVRMask(cvr)
end

hasConst(quals::Integer) = clang_Qualifiers_hasConst(quals)
withConst(quals::Integer) = clang_Qualifiers_withConst(quals)

hasVolatile(quals::Integer) = clang_Qualifiers_hasVolatile(quals)
withVolatile(quals::Integer) = clang_Qualifiers_withVolatile(quals)

hasRestrict(quals::Integer) = clang_Qualifiers_hasRestrict(quals)
withRestrict(quals::Integer) = clang_Qualifiers_withRestrict(quals)

getCVRQualifiers(quals::Integer) = clang_Qualifiers_getCVRQualifiers(quals)

hasAddressSpace(quals::Integer) = clang_Qualifiers_hasAddressSpace(quals)
getAddressSpace(quals::Integer) = clang_Qualifiers_getAddressSpace(quals)

empty(quals::Integer) = clang_Qualifiers_empty(quals)

"""
    hasQualifiers(quals::Integer) -> Bool
Whether the qualifier set carries anything at all — the negation of
[`empty`](@ref). The `QualType` method of the same name asks the same question of
a type's own qualifiers.
"""
hasQualifiers(quals::Integer) = clang_Qualifiers_hasQualifiers(quals)

"""
    compatiblyIncludes(quals::Integer, other::Integer) -> Bool
Return whether an object qualified with `other` can be used safely where `quals`
is expected: CVR qualifiers may subset, ObjC lifetime must match exactly.
"""
compatiblyIncludes(quals::Integer, other::Integer) = clang_Qualifiers_compatiblyIncludes(quals, other)

"""
    isStrictSupersetOf(quals::Integer, other::Integer) -> Bool
Return whether `quals` is a strict superset of `other`, ignoring the qualifier
compatibility rules `compatiblyIncludes` applies.
"""
isStrictSupersetOf(quals::Integer, other::Integer) = clang_Qualifiers_isStrictSupersetOf(quals, other)

getAsString(quals::Integer) = get_string(clang_Qualifiers_getAsString(quals))

# QualType -- qualifier accessors and the class/reference classification tail
"""
    getBaseTypeIdentifier(x::QualType) -> IdentifierInfo
Return the `IdentifierInfo` naming the type at the base of `x`, or a NULL
carrier when that base type has no name.

`clang::QualType::getBaseTypeIdentifier` reaches the type through `getTypePtr`,
which asserts the `QualType` is non-null, so a null receiver is undefined
behaviour in the shim; the precondition is restated here.
"""
function getBaseTypeIdentifier(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return IdentifierInfo(clang_QualType_getBaseTypeIdentifier(x))
end

"""
    isReferenceable(x::QualType) -> Bool
Return whether `T&` can be formed from this type.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function isReferenceable(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_isReferenceable(x)
end

"""
    getLocalQualifiers(x::QualType) -> UInt32
Return the qualifiers written on this `QualType` instance alone — not those
acquired through typedefs or other sugar — as the opaque `clang::Qualifiers`
encoding the `Qualifiers` wrappers above consume.
"""
getLocalQualifiers(x::QualType) = clang_QualType_getLocalQualifiers(x)

"""
    mayBeDynamicClass(x::QualType) -> Bool
Return whether this type's **pointee** is a class that might be dynamic
(polymorphic). The question is asked of `getPointeeCXXRecordDecl`, so it is false
for a class type named directly — only a pointer or reference to a class can
answer true. An incomplete class answers true conservatively.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function mayBeDynamicClass(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_mayBeDynamicClass(x)
end

"""
    mayBeNotDynamicClass(x::QualType) -> Bool
Return whether this type's **pointee** is not a class, or is a class that might
not be dynamic. Same pointee-only reach as [`mayBeDynamicClass`](@ref): true for
a class type named directly, and true for both if the class is incomplete.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function mayBeNotDynamicClass(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_mayBeNotDynamicClass(x)
end

"""
    getAtomicUnqualifiedType(x::QualType) -> QualType
Return the type with every qualifier removed, `_Atomic` included, where
`getUnqualifiedType` leaves `_Atomic` in place.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function getAtomicUnqualifiedType(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return QualType(clang_QualType_getAtomicUnqualifiedType(x))
end


# Qualifiers -- the fast/non-fast split over the opaque encoding (MARSHALLING.md §7)
"""
    fromFastMask(mask::Integer) -> UInt32
Build a `clang::Qualifiers` set from a fast-qualifier bit mask and return its opaque encoding.

`clang::Qualifiers::addFastQualifiers` asserts the mask carries no bits outside the fast set
(const/volatile/restrict, mask `0x7`), so a wider mask is undefined behaviour in the shim; the
precondition is restated here.
"""
function fromFastMask(mask::Integer)
    @assert 0 <= mask <= 7 "fast-qualifier mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_fromFastMask(mask)
end

hasFastQualifiers(quals::Integer) = clang_Qualifiers_hasFastQualifiers(quals)
getFastQualifiers(quals::Integer) = clang_Qualifiers_getFastQualifiers(quals)

hasNonFastQualifiers(quals::Integer) = clang_Qualifiers_hasNonFastQualifiers(quals)
getNonFastQualifiers(quals::Integer) = clang_Qualifiers_getNonFastQualifiers(quals)

# QualType -- canonical-as-param, storage constness and the local fast-qualifier tail
"""
    isCanonicalAsParam(x::QualType) -> Bool
Return whether `x` is already in the form a function parameter type is adjusted to: canonical,
free of local qualifiers, and neither a function nor an array type.

`clang::QualType::isCanonicalAsParam` reaches the type through `getCommonPtr`/`getTypePtr`, both of
which assert the `QualType` is non-null, so a null receiver is undefined behaviour in the shim; the
precondition is restated here.
"""
function isCanonicalAsParam(x::QualType)
    @assert !isNull(x) "QualType must be non-null"
    return clang_QualType_isCanonicalAsParam(x)
end

hasLocalNonFastQualifiers(x::QualType) = clang_QualType_hasLocalNonFastQualifiers(x)

getLocalCVRQualifiers(x::QualType) = clang_QualType_getLocalCVRQualifiers(x)

"""
    withCVRQualifiers(x::QualType, cvr::Integer) -> QualType
Return `x` with the const/volatile/restrict bits of `cvr` added.

`clang::QualType::addFastQualifiers` asserts the mask carries no bits outside
const/volatile/restrict, so a wider mask is undefined behaviour in the shim; the precondition is
restated here.
"""
function withCVRQualifiers(x::QualType, cvr::Integer)
    @assert 0 <= cvr <= 7 "CVR mask carries bits outside const/volatile/restrict"
    return QualType(clang_QualType_withCVRQualifiers(x, cvr))
end

"""
    getNonPackExpansionType(x::QualType) -> QualType
Return `x` with an outer pack expansion stripped, or `x` unchanged when there is none.

`clang::QualType::getNonPackExpansionType` reaches the type through `getTypePtr`, which asserts the
`QualType` is non-null, so a null receiver is undefined behaviour in the shim; the precondition is
restated here.
"""
function getNonPackExpansionType(x::QualType)
    @assert !isNull(x) "QualType must be non-null"
    return QualType(clang_QualType_getNonPackExpansionType(x))
end

"""
    isConstantStorage(x::QualType, ctx::ASTContext, exclude_ctor::Bool, exclude_dtor::Bool) -> Bool
Return whether objects of this type can be placed in immutable storage. `exclude_ctor` and
`exclude_dtor` drop the construction and destruction windows from consideration; the caller is then
responsible for proving the object is not written to during them.

This is the negation of `clang::QualType::isNonConstantStorage`, whose `std::optional` reason code
is not carried across the boundary.
"""
function isConstantStorage(x::QualType, ctx::ASTContext, exclude_ctor::Bool, exclude_dtor::Bool)
    @check_ptrs ctx
    return clang_QualType_isConstantStorage(x, ctx, exclude_ctor, exclude_dtor)
end

function isTriviallyEqualityComparableType(x::QualType, ctx::ASTContext)
    @check_ptrs ctx
    return clang_QualType_isTriviallyEqualityComparableType(x, ctx)
end

# Type -- literal/layout classification, the builtin-kind probe and the contained-auto probe
function isSizelessVectorType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSizelessVectorType(x)
end

function isLiteralType(x::AbstractType, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Type_isLiteralType(x, ctx)
end

function isStructuralType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isStructuralType(x)
end

function isStandardLayoutType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isStandardLayoutType(x)
end

"""
    isSpecificBuiltinType(x::AbstractType, k::Integer) -> Bool
Return whether `x` desugars to the builtin type whose `clang::BuiltinType::Kind` value is `k`. The
comparison is total, so a `k` outside the enumeration simply never matches.
"""
function isSpecificBuiltinType(x::AbstractType, k::Integer)
    @check_ptrs x
    return clang_Type_isSpecificBuiltinType(x, k)
end

function isNonOverloadPlaceholderType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isNonOverloadPlaceholderType(x)
end

function isIbm128Type(x::AbstractType)
    @check_ptrs x
    return clang_Type_isIbm128Type(x)
end

"""
    getContainedAutoType(x::AbstractType) -> AutoType
Return the `AutoType` whose type will be deduced for a variable initialised with an expression of
this type, or a NULL carrier when the contained deduced type is not an `auto` type.
"""
function getContainedAutoType(x::AbstractType)
    @check_ptrs x
    return AutoType(clang_Type_getContainedAutoType(x))
end


# BuiltinType
function isSugared(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isSugared(x)
end

function desugar(x::AbstractBuiltinType)
    @check_ptrs x
    return QualType(clang_BuiltinType_desugar(x))
end

function isInteger(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isInteger(x)
end

function isSignedInteger(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isSignedInteger(x)
end

function isUnsignedInteger(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isUnsignedInteger(x)
end

function isFloatingPoint(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isFloatingPoint(x)
end

function isSVEBool(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isSVEBool(x)
end

function isSVECount(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isSVECount(x)
end

# VectorType
function getVectorKind(x::AbstractVectorType)
    @check_ptrs x
    return clang_VectorType_getVectorKind(x)
end

# FunctionType
function getCallResultType(x::AbstractFunctionType, ctx::ASTContext)
    @check_ptrs x ctx
    return QualType(clang_FunctionType_getCallResultType(x, ctx))
end

# AttributedType
function isQualifier(x::AbstractAttributedType)
    @check_ptrs x
    return clang_AttributedType_isQualifier(x)
end

function isMSTypeSpec(x::AbstractAttributedType)
    @check_ptrs x
    return clang_AttributedType_isMSTypeSpec(x)
end

function isWebAssemblyFuncrefSpec(x::AbstractAttributedType)
    @check_ptrs x
    return clang_AttributedType_isWebAssemblyFuncrefSpec(x)
end

function isCallingConv(x::AbstractAttributedType)
    @check_ptrs x
    return clang_AttributedType_isCallingConv(x)
end

# TypedefType
function typeMatchesDecl(x::AbstractTypedefType)
    @check_ptrs x
    return clang_TypedefType_typeMatchesDecl(x)
end

# UsingType
function typeMatchesDecl(x::AbstractUsingType)
    @check_ptrs x
    return clang_UsingType_typeMatchesDecl(x)
end

# AutoType
function getKeyword(x::AbstractAutoType)
    @check_ptrs x
    return clang_AutoType_getKeyword(x)
end



# --- type-d: payload accessors on already-wrapped Type carriers ---

# Type
function getLinkage(x::AbstractType)
    @check_ptrs x
    return clang_Type_getLinkage(x)
end

function getVisibility(x::AbstractType)
    @check_ptrs x
    return clang_Type_getVisibility(x)
end

# ArrayType
"""
    getIndexTypeQualifiers(x::AbstractArrayType) -> UInt32

Return the qualifiers on the array's index type as the opaque `Qualifiers`
encoding (MARSHALLING.md §7); `0` when there are none.
"""
function getIndexTypeQualifiers(x::AbstractArrayType)
    @check_ptrs x
    return clang_ArrayType_getIndexTypeQualifiers(x)
end

# VariableArrayType
function getLBracketLoc(x::AbstractVariableArrayType)
    @check_ptrs x
    return SourceLocation(clang_VariableArrayType_getLBracketLoc(x))
end

function getRBracketLoc(x::AbstractVariableArrayType)
    @check_ptrs x
    return SourceLocation(clang_VariableArrayType_getRBracketLoc(x))
end

# DependentSizedArrayType
function getLBracketLoc(x::AbstractDependentSizedArrayType)
    @check_ptrs x
    return SourceLocation(clang_DependentSizedArrayType_getLBracketLoc(x))
end

function getRBracketLoc(x::AbstractDependentSizedArrayType)
    @check_ptrs x
    return SourceLocation(clang_DependentSizedArrayType_getRBracketLoc(x))
end

# FunctionProtoType
function getEllipsisLoc(x::AbstractFunctionProtoType)
    @check_ptrs x
    return SourceLocation(clang_FunctionProtoType_getEllipsisLoc(x))
end

function hasExtParameterInfos(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_hasExtParameterInfos(x)
end

# PackExpansionType
function isSugared(x::AbstractPackExpansionType)
    @check_ptrs x
    return clang_PackExpansionType_isSugared(x)
end

function desugar(x::AbstractPackExpansionType)
    @check_ptrs x
    return QualType(clang_PackExpansionType_desugar(x))
end

# TemplateTypeParmType
function getIdentifier(x::AbstractTemplateTypeParmType)
    @check_ptrs x
    return IdentifierInfo(clang_TemplateTypeParmType_getIdentifier(x))
end

# TypeWithKeyword
function getKeyword(x::AbstractTypeWithKeyword)
    @check_ptrs x
    return clang_TypeWithKeyword_getKeyword(x)
end


# Type -- the sizeless-builtin, WebAssembly and OpenCL/ext-vector probes
function isSVESizelessBuiltinType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSVESizelessBuiltinType(x)
end

function isRVVSizelessBuiltinType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isRVVSizelessBuiltinType(x)
end

function isWebAssemblyExternrefType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isWebAssemblyExternrefType(x)
end

"""
    isWebAssemblyTableType(x::AbstractType) -> Bool
Return whether this is a WebAssembly table type: an array of reference types, or a pointer
to a reference type, which only array-to-pointer decay can produce.
"""
function isWebAssemblyTableType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isWebAssemblyTableType(x)
end

function isExtVectorBoolType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isExtVectorBoolType(x)
end

function isPipeType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isPipeType(x)
end

# QualType -- the non-trivial-C-struct family, the C lvalue rule and the expression-type
# projection. Each of these reaches the type through `getTypePtr`, which asserts on a null
# QualType, so the precondition is restated here.
"""
    isNonTrivialToPrimitiveDefaultInitialize(x::QualType) -> CXPrimitiveDefaultInitializeKind
Return the kind that would make a C struct transitively containing this type non-trivial to
default-initialize, or `PDIK_Trivial` when it would not.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function isNonTrivialToPrimitiveDefaultInitialize(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_isNonTrivialToPrimitiveDefaultInitialize(x)
end

"""
    isNonTrivialToPrimitiveCopy(x::QualType) -> CXPrimitiveCopyKind
Return the kind that would make a C struct transitively containing this type non-trivial to
copy. A volatile-qualified but otherwise trivial type reports `PCK_VolatileTrivial`.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function isNonTrivialToPrimitiveCopy(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_isNonTrivialToPrimitiveCopy(x)
end

"""
    isNonTrivialToPrimitiveDestructiveMove(x::QualType) -> CXPrimitiveCopyKind
Return the kind that would make a C struct transitively containing this type non-trivial to
destructively move, in the C++ sense where the source is left valid but unspecified.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function isNonTrivialToPrimitiveDestructiveMove(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_isNonTrivialToPrimitiveDestructiveMove(x)
end

"""
    hasNonTrivialToPrimitiveDefaultInitializeCUnion(x::QualType) -> Bool
Return whether this is or contains a C union with a member that is non-trivial to
default-initialize. When true, [`isNonTrivialToPrimitiveDefaultInitialize`](@ref) returns
`PDIK_Struct`.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function hasNonTrivialToPrimitiveDefaultInitializeCUnion(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_hasNonTrivialToPrimitiveDefaultInitializeCUnion(x)
end

"""
    hasNonTrivialToPrimitiveDestructCUnion(x::QualType) -> Bool
Return whether this is or contains a C union with a member that is non-trivial to destruct.
When true, `isDestructedType` returns `DK_nontrivial_c_struct`.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function hasNonTrivialToPrimitiveDestructCUnion(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_hasNonTrivialToPrimitiveDestructCUnion(x)
end

"""
    hasNonTrivialToPrimitiveCopyCUnion(x::QualType) -> Bool
Return whether this is or contains a C union with a member that is non-trivial to copy. When
true, [`isNonTrivialToPrimitiveCopy`](@ref) returns `PCK_Struct`.

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function hasNonTrivialToPrimitiveCopyCUnion(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_hasNonTrivialToPrimitiveCopyCUnion(x)
end

"""
    isCForbiddenLValueType(x::QualType) -> Bool
Return whether C forbids expressions of this type from being lvalues: unqualified `void` and
function types (C99 6.3.2.1).

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function isCForbiddenLValueType(x::QualType)
    @assert !isNull(x) "QualType must not be null"
    return clang_QualType_isCForbiddenLValueType(x)
end

"""
    getNonLValueExprType(x::QualType, ctx::ASTContext) -> QualType
Return the type of a typically non-lvalue expression whose result type is this type: the
top-level reference is stripped, and top-level cvr-qualifiers are dropped from non-class
types in C++ (from all types in C).

Reaches the type through `getTypePtr`, so the `QualType` must not be null.
"""
function getNonLValueExprType(x::QualType, ctx::ASTContext)
    @assert !isNull(x) "QualType must not be null"
    @check_ptrs ctx
    return QualType(clang_QualType_getNonLValueExprType(x, ctx))
end

# FunctionType
"""
    getNameForCallConv(cc::CXCallingConv_) -> String
Return clang's spelling of a calling convention, e.g. `"cdecl"` for `CC_C`.
"""
getNameForCallConv(cc::CXCallingConv_) = get_string(clang_FunctionType_getNameForCallConv(cc))

# FunctionProtoType
"""
    getRefQualifier(x::AbstractFunctionProtoType) -> CXRefQualifierKind
Return the C++11 ref-qualifier written on this function prototype: `RQ_None`, `RQ_LValue`
for `&`, or `RQ_RValue` for `&&`.
"""
function getRefQualifier(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getRefQualifier(x)
end

"""
    canThrow(x::AbstractFunctionProtoType) -> CXCanThrowResult
Return whether this function type can throw: `CT_Cannot`, `CT_Can`, or `CT_Dependent` when
the exception specification depends on template arguments.
"""
function canThrow(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_canThrow(x)
end

"""
    getAArch64SMEAttributes(x::AbstractFunctionProtoType) -> UInt32
Return the bitmask of `clang::FunctionType::AArch64SMETypeAttributes` bits on this function
type; a function type carrying no SME attributes reads back 0 (`SME_NormalFunction`).
"""
function getAArch64SMEAttributes(x::AbstractFunctionProtoType)
    @check_ptrs x
    return clang_FunctionProtoType_getAArch64SMEAttributes(x)
end

# TypeSourceInfo
function getType(x::AbstractTypeSourceInfo)
    @check_ptrs x
    return QualType(clang_TypeSourceInfo_getType(x))
end

"""
    overrideType(x::AbstractTypeSourceInfo, ty::QualType)
Replace the type stored in this `TypeSourceInfo`, leaving its written source information
(the `TypeLoc` data) untouched — after this the two can disagree, so clang marks the method
"use with caution".
"""
function overrideType(x::AbstractTypeSourceInfo, ty::QualType)
    @check_ptrs x
    return clang_TypeSourceInfo_overrideType(x, ty)
end


# Qualifiers -- the exact-set / unaligned / address-space tail over the opaque encoding
# (MARSHALLING.md §7). These dispatch on `Integer` like the rest of the family: the value
# type has no carrier struct and there is no pointer to check.
"""
    hasOnlyConst(quals::Integer) -> Bool
Return whether the qualifier set is exactly `const` and nothing else, where `hasConst` is
true for any set that merely includes `const`.
"""
hasOnlyConst(quals::Integer) = clang_Qualifiers_hasOnlyConst(quals)

"""
    hasOnlyVolatile(quals::Integer) -> Bool
Return whether the qualifier set is exactly `volatile` and nothing else.
"""
hasOnlyVolatile(quals::Integer) = clang_Qualifiers_hasOnlyVolatile(quals)

"""
    hasOnlyRestrict(quals::Integer) -> Bool
Return whether the qualifier set is exactly `restrict` and nothing else.
"""
hasOnlyRestrict(quals::Integer) = clang_Qualifiers_hasOnlyRestrict(quals)

hasCVRQualifiers(quals::Integer) = clang_Qualifiers_hasCVRQualifiers(quals)

"""
    getCVRUQualifiers(quals::Integer) -> UInt32
Return the const/volatile/restrict bits widened with the unaligned bit, where
`getCVRQualifiers` drops the latter.
"""
getCVRUQualifiers(quals::Integer) = clang_Qualifiers_getCVRUQualifiers(quals)

hasUnaligned(quals::Integer) = clang_Qualifiers_hasUnaligned(quals)

"""
    withoutAddressSpace(quals::Integer) -> UInt32
Return the same qualifier set with its address space reset to `CXLangAS_Default`.
"""
withoutAddressSpace(quals::Integer) = clang_Qualifiers_withoutAddressSpace(quals)

"""
    hasTargetSpecificAddressSpace(quals::Integer) -> Bool
Return whether the set carries a target-specific address space, as opposed to none or one
of the language-specific (OpenCL/CUDA/SYCL) spaces.
"""
hasTargetSpecificAddressSpace(quals::Integer) = clang_Qualifiers_hasTargetSpecificAddressSpace(quals)

"""
    getAddressSpaceAttributePrintValue(quals::Integer) -> UInt32
Return the address-space value clang prints in diagnostics: the target address space, or
`0` for the default one.

`clang::Qualifiers::getAddressSpaceAttributePrintValue` asserts the address space is either
the default or target-specific, so a language-specific one is undefined behaviour in the
shim; the precondition is restated here.
"""
function getAddressSpaceAttributePrintValue(quals::Integer)
    @assert getAddressSpace(quals) == CXLangAS_Default || hasTargetSpecificAddressSpace(quals) \
            "address space must be the default or a target-specific one"
    return clang_Qualifiers_getAddressSpaceAttributePrintValue(quals)
end

"""
    isAddressSpaceSupersetOf(a::CXLangAS, b::CXLangAS) -> Bool
Return whether address space `a` is equal to or a superset of `b` — every space is a
superset of itself, `opencl_generic` covers all but `opencl_constant`, and the pointer-size
spaces are equivalent to the default one.

This is the static two-`LangAS` form; it takes no `Qualifiers` receiver.
"""
function isAddressSpaceSupersetOf(a::CXLangAS, b::CXLangAS)
    return clang_Qualifiers_isAddressSpaceSupersetOf(a, b)
end

"""
    getAddrSpaceAsString(as::CXLangAS) -> String
Return the name clang prints for one address space value. Static: it takes no `Qualifiers`
receiver.
"""
getAddrSpaceAsString(as::CXLangAS) = get_string(clang_Qualifiers_getAddrSpaceAsString(as))

# QualType -- the fast-qualifier constructors
"""
    withFastQualifiers(x::QualType, tqs::Integer) -> QualType
Return `x` with the given fast qualifiers added to whatever it already carries.

`clang::QualType::addFastQualifiers` asserts the mask carries no bits outside the fast set
(const/volatile/restrict, mask `0x7`), so a wider mask is undefined behaviour in the shim;
the precondition is restated here.
"""
function withFastQualifiers(x::QualType, tqs::Integer)
    @assert 0 <= tqs <= 7 "fast-qualifier mask carries bits outside const/volatile/restrict"
    return QualType(clang_QualType_withFastQualifiers(x, tqs))
end

"""
    withExactLocalFastQualifiers(x::QualType, tqs::Integer) -> QualType
Return `x` carrying exactly the given fast qualifiers, dropping any it already had.

`clang::QualType::addFastQualifiers` asserts the mask carries no bits outside the fast set
(const/volatile/restrict, mask `0x7`), so a wider mask is undefined behaviour in the shim;
the precondition is restated here.
"""
function withExactLocalFastQualifiers(x::QualType, tqs::Integer)
    @assert 0 <= tqs <= 7 "fast-qualifier mask carries bits outside const/volatile/restrict"
    return QualType(clang_QualType_withExactLocalFastQualifiers(x, tqs))
end

"""
    withoutLocalFastQualifiers(x::QualType) -> QualType
Return `x` with its local fast qualifiers removed, leaving any extended qualifiers in place.
"""
withoutLocalFastQualifiers(x::QualType) = QualType(clang_QualType_withoutLocalFastQualifiers(x))

# TypeWithKeyword -- the static keyword <-> tag-kind conversions, all receiver-free
"""
    getKeywordForTagTypeKind(tag::CXTagTypeKind) -> CXElaboratedTypeKeyword
Return the elaborated-type keyword spelling a tag kind, e.g. `Struct` for
`CXTagTypeKind_Struct`.
"""
getKeywordForTagTypeKind(tag::CXTagTypeKind) = clang_TypeWithKeyword_getKeywordForTagTypeKind(tag)

"""
    getTagTypeKindForKeyword(kw::CXElaboratedTypeKeyword) -> CXTagTypeKind
Return the tag kind an elaborated-type keyword names.

`clang::TypeWithKeyword::getTagTypeKindForKeyword` documents that it is an error to pass a
keyword that is not a tag kind and falls off into `llvm_unreachable` for `Typename` and
`None`, so the precondition is restated here with `KeywordIsTagTypeKind`.
"""
function getTagTypeKindForKeyword(kw::CXElaboratedTypeKeyword)
    @assert KeywordIsTagTypeKind(kw) "elaborated-type keyword must name a tag kind"
    return clang_TypeWithKeyword_getTagTypeKindForKeyword(kw)
end

"""
    KeywordIsTagTypeKind(kw::CXElaboratedTypeKeyword) -> Bool
Return whether an elaborated-type keyword names a tag kind — false exactly for `Typename`
and `None`. This is the gate `getTagTypeKindForKeyword` asserts on.
"""
KeywordIsTagTypeKind(kw::CXElaboratedTypeKeyword) = clang_TypeWithKeyword_KeywordIsTagTypeKind(kw)

"""
    getKeywordName(kw::CXElaboratedTypeKeyword) -> String
Return the source spelling of an elaborated-type keyword, e.g. `"struct"`. `None` has no
spelling and yields an empty string.
"""
getKeywordName(kw::CXElaboratedTypeKeyword) = get_string(clang_TypeWithKeyword_getKeywordName(kw))

"""
    getTagTypeKindName(tag::CXTagTypeKind) -> String
Return the source spelling of a tag kind, e.g. `"class"` for `CXTagTypeKind_Class`.
"""
getTagTypeKindName(tag::CXTagTypeKind) = get_string(clang_TypeWithKeyword_getTagTypeKindName(tag))


# Type -- the ObjC classification family. Each of these is declared on clang::Type, is
# total (the ones that reach a subobject do it through a guarded `getAs`), and answers
# false for every non-ObjC type, so they are safe on any type carrier.
function isObjCObjectPointerType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCObjectPointerType(x)
end

function isObjCRetainableType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCRetainableType(x)
end

function isObjCObjectType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCObjectType(x)
end

function isObjCObjectOrInterfaceType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCObjectOrInterfaceType(x)
end

function isObjCIdType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCIdType(x)
end

function isObjCClassType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCClassType(x)
end

function isObjCSelType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCSelType(x)
end

"""
    isObjCBuiltinType(x::AbstractType) -> Bool
Return whether `x` is one of the three ObjC builtin types — the disjunction of
`isObjCIdType`, `isObjCClassType` and `isObjCSelType`.
"""
function isObjCBuiltinType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isObjCBuiltinType(x)
end

# Type -- the OpenCL opaque-type family. All false outside an OpenCL translation unit.
function isImageType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isImageType(x)
end

function isSamplerT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isSamplerT(x)
end

function isEventT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isEventT(x)
end

function isClkEventT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isClkEventT(x)
end

function isQueueT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isQueueT(x)
end

function isReserveIDT(x::AbstractType)
    @check_ptrs x
    return clang_Type_isReserveIDT(x)
end

function isOCLIntelSubgroupAVCType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isOCLIntelSubgroupAVCType(x)
end

function isOCLExtOpaqueType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isOCLExtOpaqueType(x)
end

"""
    isOpenCLSpecificType(x::AbstractType) -> Bool
Return whether `x` is any OpenCL-specific opaque type — the union of `isSamplerT`,
`isEventT`, `isImageType`, `isClkEventT`, `isQueueT`, `isReserveIDT`, `isPipeType` and
`isOCLExtOpaqueType`.
"""
function isOpenCLSpecificType(x::AbstractType)
    @check_ptrs x
    return clang_Type_isOpenCLSpecificType(x)
end

# QualType -- the local-qualifier removers. A QualType crosses as its opaque encoding, so
# clang's void mutators surface here as value returns that leave `x` untouched, matching
# `addConst`/`addVolatile`/`addRestrict`.
"""
    removeLocalConst(x::QualType) -> QualType
Return `x` with its local `const` fast qualifier cleared. Only the qualifier written on
this `QualType` instance is removed; one acquired through a typedef or other sugar is not
local and stays in place.
"""
removeLocalConst(x::QualType) = QualType(clang_QualType_removeLocalConst(x))

"""
    removeLocalVolatile(x::QualType) -> QualType
Return `x` with its local `volatile` fast qualifier cleared; sugar-acquired qualifiers are
not local and stay in place.
"""
removeLocalVolatile(x::QualType) = QualType(clang_QualType_removeLocalVolatile(x))

"""
    removeLocalRestrict(x::QualType) -> QualType
Return `x` with its local `restrict` fast qualifier cleared; sugar-acquired qualifiers are
not local and stay in place.
"""
removeLocalRestrict(x::QualType) = QualType(clang_QualType_removeLocalRestrict(x))


# Qualifiers -- the mutator tail over the opaque encoding (MARSHALLING.md §7). A
# `Qualifiers` value has no carrier struct and crosses as an `Integer`, so clang's in-place
# void mutators surface here as value returns that leave their argument untouched, matching
# the `withConst`/`withVolatile`/`withRestrict` trio.
"""
    fromCVRUMask(cvru::Integer) -> UInt32
Build a `clang::Qualifiers` set from a const/volatile/restrict/unaligned bit mask and return
its opaque encoding — [`fromCVRMask`](@ref) widened with the `__unaligned` bit.

`clang::Qualifiers::addCVRUQualifiers` asserts the mask carries no bits outside that set, so
a wider mask is undefined behaviour in the shim; the precondition is restated here.
"""
function fromCVRUMask(cvru::Integer)
    @assert 0 <= cvru <= 15 "CVRU mask carries bits outside const/volatile/restrict/unaligned"
    return clang_Qualifiers_fromCVRUMask(cvru)
end

"""
    removeConst(quals::Integer) -> UInt32
Return the qualifier set with `const` cleared — the inverse of [`withConst`](@ref). Clearing
a qualifier the set does not carry is a no-op.
"""
removeConst(quals::Integer) = clang_Qualifiers_removeConst(quals)

"""
    removeVolatile(quals::Integer) -> UInt32
Return the qualifier set with `volatile` cleared — the inverse of [`withVolatile`](@ref).
"""
removeVolatile(quals::Integer) = clang_Qualifiers_removeVolatile(quals)

"""
    removeRestrict(quals::Integer) -> UInt32
Return the qualifier set with `restrict` cleared — the inverse of [`withRestrict`](@ref).
"""
removeRestrict(quals::Integer) = clang_Qualifiers_removeRestrict(quals)

"""
    setCVRQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set with its const/volatile/restrict bits replaced by `mask`; the
address space and the ObjC GC/lifetime fields are left untouched.

`clang::Qualifiers::setCVRQualifiers` asserts the mask carries no bits outside
const/volatile/restrict, so a wider mask is undefined behaviour in the shim; the
precondition is restated here.
"""
function setCVRQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 7 "CVR mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_setCVRQualifiers(quals, mask)
end

"""
    addCVRQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set widened with the const/volatile/restrict bits in `mask`.

`clang::Qualifiers::addCVRQualifiers` asserts the mask carries no bits outside
const/volatile/restrict, so a wider mask is undefined behaviour in the shim; the
precondition is restated here.
"""
function addCVRQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 7 "CVR mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_addCVRQualifiers(quals, mask)
end

"""
    removeCVRQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set with the const/volatile/restrict bits in `mask` cleared.

`clang::Qualifiers::removeCVRQualifiers` asserts the mask carries no bits outside
const/volatile/restrict, so a wider mask is undefined behaviour in the shim; the
precondition is restated here.
"""
function removeCVRQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 7 "CVR mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_removeCVRQualifiers(quals, mask)
end

"""
    addCVRUQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set widened with the const/volatile/restrict/unaligned bits in `mask` —
the form of [`addCVRQualifiers`](@ref) that also accepts the `__unaligned` bit.

`clang::Qualifiers::addCVRUQualifiers` asserts the mask carries no bits outside that set, so
a wider mask is undefined behaviour in the shim; the precondition is restated here.
"""
function addCVRUQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 15 "CVRU mask carries bits outside const/volatile/restrict/unaligned"
    return clang_Qualifiers_addCVRUQualifiers(quals, mask)
end

"""
    setUnaligned(quals::Integer, flag::Bool) -> UInt32
Return the qualifier set with its `__unaligned` bit set to `flag`. Clang's `addUnaligned`
and `removeUnaligned` are the two settings of this one mutator, so only this form is bound.
"""
setUnaligned(quals::Integer, flag::Bool) = clang_Qualifiers_setUnaligned(quals, flag)

"""
    setAddressSpace(quals::Integer, as::CXLangAS) -> UInt32
Return the qualifier set with its address space replaced by `as`; `CXLangAS_Default` clears
it, which is what [`withoutAddressSpace`](@ref) does.
"""
setAddressSpace(quals::Integer, as::CXLangAS) = clang_Qualifiers_setAddressSpace(quals, as)

"""
    addAddressSpace(quals::Integer, as::CXLangAS) -> UInt32
Return the qualifier set with `as` installed as its address space.

`clang::Qualifiers::addAddressSpace` asserts `as` is not `CXLangAS_Default`, so clearing the
address space through this entry point is undefined behaviour in the shim; the precondition
is restated here. Use [`setAddressSpace`](@ref) for the unrestricted form.
"""
function addAddressSpace(quals::Integer, as::CXLangAS)
    @assert as != CXLangAS_Default "address space must not be the default one"
    return clang_Qualifiers_addAddressSpace(quals, as)
end

"""
    setFastQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set with its fast-qualifier bits replaced by `mask` — the
const/volatile/restrict subset that fits inline in a `QualType`.

`clang::Qualifiers::setFastQualifiers` asserts the mask carries no bits outside the fast set
(mask `0x7`), so a wider mask is undefined behaviour in the shim; the precondition is
restated here.
"""
function setFastQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 7 "fast-qualifier mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_setFastQualifiers(quals, mask)
end

"""
    addFastQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set widened with the fast-qualifier bits in `mask`.

`clang::Qualifiers::addFastQualifiers` asserts the mask carries no bits outside the fast set
(mask `0x7`), so a wider mask is undefined behaviour in the shim; the precondition is
restated here.
"""
function addFastQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 7 "fast-qualifier mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_addFastQualifiers(quals, mask)
end

"""
    removeFastQualifiers(quals::Integer, mask::Integer) -> UInt32
Return the qualifier set with the fast-qualifier bits in `mask` cleared.

`clang::Qualifiers::removeFastQualifiers` asserts the mask carries no bits outside the fast
set (mask `0x7`), so a wider mask is undefined behaviour in the shim; the precondition is
restated here.
"""
function removeFastQualifiers(quals::Integer, mask::Integer)
    @assert 0 <= mask <= 7 "fast-qualifier mask carries bits outside const/volatile/restrict"
    return clang_Qualifiers_removeFastQualifiers(quals, mask)
end

"""
    addQualifiers(quals::Integer, other::Integer) -> UInt32
Return `quals` widened with every qualifier in `other`. This is qualifier-aware rather than
a plain bit-or: the address space and the ObjC GC/lifetime fields are carried over as units.
"""
addQualifiers(quals::Integer, other::Integer) = clang_Qualifiers_addQualifiers(quals, other)

"""
    removeQualifiers(quals::Integer, other::Integer) -> UInt32
Return `quals` with every qualifier in `other` dropped. The address space and the ObjC
GC/lifetime fields are cleared only when the two sets agree on them.
"""
removeQualifiers(quals::Integer, other::Integer) = clang_Qualifiers_removeQualifiers(quals, other)

"""
    removeCommonQualifiers(l::Integer, r::Integer) -> Tuple{UInt32,UInt32,UInt32}
Return `(common, l_rest, r_rest)`: the qualifiers `l` and `r` share, then each input set with
those common qualifiers stripped. Clang mutates its two reference arguments in place; a
`Qualifiers` value crosses here as an immutable `Integer`, so the updated sets come back in
the tuple instead. Static: it takes no `Qualifiers` receiver.
"""
function removeCommonQualifiers(l::Integer, r::Integer)
    lref, rref = Ref{Cuint}(l), Ref{Cuint}(r)
    common = clang_Qualifiers_removeCommonQualifiers(lref, rref)
    return (common, lref[], rref[])
end

# BuiltinType/Type -- the placeholder-kind gate and the kind-specific placeholder probe.
"""
    isPlaceholderTypeKind(k::Integer) -> Bool
Return whether the `clang::BuiltinType::Kind` value `k` names a placeholder type — one that
cannot appear in an arbitrary position of a fully-formed expression. Static: it takes no
`BuiltinType` receiver, and it is the gate [`isSpecificPlaceholderType`](@ref) asserts on.
"""
isPlaceholderTypeKind(k::Integer) = clang_BuiltinType_isPlaceholderTypeKind(k)

"""
    isSpecificPlaceholderType(x::AbstractType, k::Integer) -> Bool
Return whether `x` is the placeholder type of `clang::BuiltinType::Kind` `k` — the
kind-specific form of [`isPlaceholderType`](@ref).

`clang::Type::isSpecificPlaceholderType` asserts `k` names a placeholder kind, so any other
kind is undefined behaviour in the shim; the precondition is restated here through
[`isPlaceholderTypeKind`](@ref).
"""
function isSpecificPlaceholderType(x::AbstractType, k::Integer)
    @check_ptrs x
    @assert isPlaceholderTypeKind(k) "k must name a placeholder BuiltinType kind"
    return clang_Type_isSpecificPlaceholderType(x, k)
end


# type-i -- the attribute/nullability probes on Type, the SplitQualType pair, the
# BuiltinType kind surface, the matrix-type statics, the AArch64 SME state decoders and the
# remaining sugar-class payload accessors.

"""
    hasAttr(x::AbstractType, k::CXAttrKind) -> Bool
Return whether `x` carries the type attribute `k`, looking through top-level type sugar.

`clang::Type::hasAttr` walks the chain of `AttributedType` sugar nodes, so a type with no
attribute sugar at all is simply `false` rather than an error.
"""
function hasAttr(x::AbstractType, k::CXAttrKind)
    @check_ptrs x
    return clang_Type_hasAttr(x, k)
end

"""
    canHaveNullability(x::AbstractType, result_if_unknown::Bool=true) -> Bool
Return whether a nullability specifier (`_Nonnull`, `_Nullable`, ...) may be applied to `x`,
which is to say whether it is some kind of pointer type. `result_if_unknown` is what clang
answers for a dependent type whose admissibility is not yet decidable; the default mirrors
clang's own.
"""
function canHaveNullability(x::AbstractType, result_if_unknown::Bool=true)
    @check_ptrs x
    return clang_Type_canHaveNullability(x, result_if_unknown)
end

"""
    getSplitUnqualifiedType(x::QualType) -> Tuple{Type_,UInt32}
Return `x` split into its unqualified type and the opaque `clang::Qualifiers` encoding that
was stripped off it -- the [`getUnqualifiedType`](@ref) counterpart that keeps the
qualifiers. Feed the second element to the `Qualifiers` wrappers (`hasConst`,
`getAddressSpace`, ...), which all take that encoding as an `Integer`.

`clang::QualType::getSplitUnqualifiedType` reaches the type through `getTypePtr`, which
asserts the `QualType` is non-null, so a null receiver is undefined behaviour in the shim;
the precondition is restated here.
"""
function getSplitUnqualifiedType(x::QualType)
    @assert !isNull(x) "QualType must be non-null"
    ty, quals = Ref{CXType_}(C_NULL), Ref{Cuint}(0)
    clang_QualType_getSplitUnqualifiedType(x, ty, quals)
    return (Type_(ty[]), quals[])
end

"""
    getSplitDesugaredType(x::QualType) -> Tuple{Type_,UInt32}
Return `x` fully desugared and split: the sugar-free type, plus the opaque
`clang::Qualifiers` encoding collected from every level of sugar peeled off along the way
(so a `volatile` typedef of `const int` yields `int` together with const+volatile).

`clang::QualType::getSplitDesugaredType` walks the type through `QualifierCollector::strip`,
which dereferences the type pointer, so a null receiver is undefined behaviour in the shim;
the precondition is restated here.
"""
function getSplitDesugaredType(x::QualType)
    @assert !isNull(x) "QualType must be non-null"
    ty, quals = Ref{CXType_}(C_NULL), Ref{Cuint}(0)
    clang_QualType_getSplitDesugaredType(x, ty, quals)
    return (Type_(ty[]), quals[])
end

"""
    isAddressSpaceOverlapping(x::QualType, other::QualType) -> Bool
Return whether the address spaces of `x` and `other` overlap in the OpenCL sense: identical
spaces always overlap, and `__generic` overlaps every space but `__constant`.

`clang::QualType::isAddressSpaceOverlapping` reads `getQualifiers()` on both operands, each
of which reaches its type through `getCommonPtr` and asserts it is non-null; the
precondition is restated here.
"""
function isAddressSpaceOverlapping(x::QualType, other::QualType)
    @assert !isNull(x) "QualType must be non-null"
    @assert !isNull(other) "QualType must be non-null"
    return clang_QualType_isAddressSpaceOverlapping(x, other)
end

"""
    getKind(x::AbstractBuiltinType) -> UInt32
Return the `clang::BuiltinType::Kind` of `x` as a plain integer -- the same numbering
[`isSpecificBuiltinType`](@ref) and [`isPlaceholderTypeKind`](@ref) take. clang stamps the
OpenCL/SVE/RVV builtins into `Kind` first, so the ordinary C/C++ builtins carry large
values; compare against another query's result, never against a literal.
"""
function getKind(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_getKind(x)
end

"""
    isPlaceholderType(x::AbstractBuiltinType) -> Bool
Return whether `x` is a placeholder builtin -- one that cannot appear in an arbitrary
position of a fully-formed expression. This is the `BuiltinType` receiver of the same query
`Type` also answers.
"""
function isPlaceholderType(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isPlaceholderType(x)
end

"""
    isNonOverloadPlaceholderType(x::AbstractBuiltinType) -> Bool
Return whether `x` is a placeholder builtin other than `Overload`. This is the `BuiltinType`
receiver of the same query `Type` also answers.
"""
function isNonOverloadPlaceholderType(x::AbstractBuiltinType)
    @check_ptrs x
    return clang_BuiltinType_isNonOverloadPlaceholderType(x)
end

"""
    getMaxSizeBits(ctx::ASTContext) -> UInt32
Return the maximum number of active bits an array's size may require on `ctx`'s target,
which caps the size of a `ConstantArrayType`. Static: it takes no array-type receiver.
"""
function getMaxSizeBits(ctx::ASTContext)
    @check_ptrs ctx
    return clang_ConstantArrayType_getMaxSizeBits(ctx)
end

"""
    isValidElementType(t::QualType) -> Bool
Return whether `t` may be the element type of a matrix type: a dependent type, an integer
type that is neither `bool` nor an enumeration, or a real floating type. Static: it takes no
matrix-type receiver.

`clang::MatrixType::isValidElementType` reaches the type with `operator->`, so a null
`QualType` is undefined behaviour in the shim; the precondition is restated here.
"""
function isValidElementType(t::QualType)
    @assert !isNull(t) "QualType must be non-null"
    return clang_MatrixType_isValidElementType(t)
end

"""
    getMaxElementsPerDimension() -> UInt32
Return the per-dimension element cap of a `clang::ConstantMatrixType`. Static: it takes no
receiver.
"""
getMaxElementsPerDimension() = clang_ConstantMatrixType_getMaxElementsPerDimension()

"""
    isDimensionValid(n::Integer) -> Bool
Return whether `n` is a valid matrix dimension: non-zero and no larger than
[`getMaxElementsPerDimension`](@ref). Static: it takes no receiver.
"""
isDimensionValid(n::Integer) = clang_ConstantMatrixType_isDimensionValid(n)

"""
    getArmZAState(attr_bits::Integer) -> CXArmStateValue
Decode the ZA state field (bits 2-4) of the AArch64 SME attribute word `attr_bits` -- the
word [`getAArch64SMEAttributes`](@ref) returns. Static: it takes no function-type receiver.

The field is three bits wide but only `0..4` name a `clang::FunctionType::ArmStateValue`, so
a hand-built word can carry a value clang never stores and the returned enum would then be
out of range; the wrapper rejects it up front.
"""
function getArmZAState(attr_bits::Integer)
    @assert ((attr_bits >> 2) & 7) <= 4 "the ZA field of attr_bits must hold an ArmStateValue (0..4)"
    return clang_FunctionType_getArmZAState(attr_bits)
end

"""
    getArmZT0State(attr_bits::Integer) -> CXArmStateValue
Decode the ZT0 state field (bits 5-7) of the AArch64 SME attribute word `attr_bits` -- the
word [`getAArch64SMEAttributes`](@ref) returns. Static: it takes no function-type receiver.

The field is three bits wide but only `0..4` name a `clang::FunctionType::ArmStateValue`, so
a hand-built word can carry a value clang never stores and the returned enum would then be
out of range; the wrapper rejects it up front.
"""
function getArmZT0State(attr_bits::Integer)
    @assert ((attr_bits >> 5) & 7) <= 4 "the ZT0 field of attr_bits must hold an ArmStateValue (0..4)"
    return clang_FunctionType_getArmZT0State(attr_bits)
end

"""
    getUTTKind(x::AbstractUnaryTransformType) -> CXUTTKind
Return which type transformation `x` applies -- `__underlying_type` is
`CXUTTKind_EnumUnderlyingType`, `__remove_const` is `CXUTTKind_RemoveConst`, and so on.
"""
function getUTTKind(x::AbstractUnaryTransformType)
    @check_ptrs x
    return clang_UnaryTransformType_getUTTKind(x)
end

"""
    getAttrKind(x::AbstractAttributedType) -> CXAttrKind
Return the `clang::attr::Kind` of the type attribute `x` records -- the value
[`hasAttr`](@ref) matches against.
"""
function getAttrKind(x::AbstractAttributedType)
    @check_ptrs x
    return clang_AttributedType_getAttrKind(x)
end

"""
    getPackIndex(x::AbstractSubstTemplateTypeParmType) -> Union{UInt32,Nothing}
Return the position of this substitution inside the substituted argument pack, or `nothing`
when the replaced parameter was not a pack (the C++ optional is disengaged).
"""
function getPackIndex(x::AbstractSubstTemplateTypeParmType)
    @check_ptrs x
    i = Ref{Cuint}(0)
    return clang_SubstTemplateTypeParmType_getPackIndex(x, i) ? i[] : nothing
end

"""
    getTypeConstraintArguments(x::AbstractAutoType) -> CXArrayRef
Return the explicit template arguments of `x`'s type constraint as a borrowed `CXArrayRef`
view into AST-owned `clang::TemplateArgument` storage -- empty for an unconstrained `auto`,
and never freed.
"""
function getTypeConstraintArguments(x::AbstractAutoType)
    @check_ptrs x
    return clang_AutoType_getTypeConstraintArguments(x)
end
