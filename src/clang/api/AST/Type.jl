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
getCanonicalTypeInternal(x::AbstractType) = QualType(clang_Type_getCanonicalTypeInternal(x))

# getPointeeType(x::AbstractType) = getTypePtr(QualType(clang_Type_getPointeeType(x)))

isVoidType(x::AbstractType) = clang_Type_isVoidType(x)

isBooleanType(x::AbstractType) = clang_Type_isBooleanType(x)

isPointerType(x::AbstractType) = clang_Type_isPointerType(x)

isFunctionPointerType(x::AbstractType) = clang_Type_isFunctionPointerType(x)

isFunctionType(x::AbstractType) = clang_Type_isFunctionType(x)

isMemberFunctionPointerType(x::AbstractType) = clang_Type_isMemberFunctionPointerType(x)

isReferenceType(x::AbstractType) = clang_Type_isReferenceType(x)

isCharType(x::AbstractType) = clang_Type_isCharType(x)

isEnumeralType(x::AbstractType) = clang_Type_isEnumeralType(x)

isBuiltinType(x::AbstractType) = clang_Type_isBuiltinType(x)

isComplexType(x::AbstractType) = clang_Type_isComplexType(x)

isArrayType(x::AbstractType) = clang_Type_isArrayType(x)

isLValueReferenceType(x::AbstractType) = clang_Type_isLValueReferenceType(x)

isRValueReferenceType(x::AbstractType) = clang_Type_isRValueReferenceType(x)

isMemberPointerType(x::AbstractType) = clang_Type_isMemberPointerType(x)

isConstantArrayType(x::AbstractType) = clang_Type_isConstantArrayType(x)

isIncompleteArrayType(x::AbstractType) = clang_Type_isIncompleteArrayType(x)

isVariableArrayType(x::AbstractType) = clang_Type_isVariableArrayType(x)

isDependentSizedArrayType(x::AbstractType) = clang_Type_isDependentSizedArrayType(x)

isFunctionNoProtoType(x::AbstractType) = clang_Type_isFunctionNoProtoType(x)

isFunctionProtoType(x::AbstractType) = clang_Type_isFunctionProtoType(x)

isRecordType(x::AbstractType) = clang_Type_isRecordType(x)

isTemplateTypeParmType(x::AbstractType) = clang_Type_isTemplateTypeParmType(x)

# extra
isa_TypedefType(x::AbstractType) = clang_isa_TypedefType(x)
isa_TagType(x::AbstractType) = clang_isa_TagType(x)
isa_EnumType(x::AbstractType) = clang_isa_EnumType(x)
isa_SubstTemplateTypeParmType(x::AbstractType) = clang_isa_SubstTemplateTypeParmType(x)
isa_SubstTemplateTypeParmPackType(x::AbstractType) = clang_isa_SubstTemplateTypeParmPackType(x)
isa_TemplateSpecializationType(x::AbstractType) = clang_isa_TemplateSpecializationType(x)
isa_ElaboratedType(x::AbstractType) = clang_isa_ElaboratedType(x)
isa_DependentNameType(x::AbstractType) = clang_isa_DependentNameType(x)
isa_DependentTemplateSpecializationType(x::AbstractType) = clang_isa_DependentTemplateSpecializationType(x)

# BuiltinTypes
isa_BuiltinType_Void(x::AbstractBuiltinType) = clang_isa_BuiltinType_Void(x)

isa_BuiltinType_Bool(x::AbstractBuiltinType) = clang_isa_BuiltinType_Bool(x)

isa_BuiltinType_Char_U(x::AbstractBuiltinType) = clang_isa_BuiltinType_Char_U(x)

isa_BuiltinType_Char_S(x::AbstractBuiltinType) = clang_isa_BuiltinType_Char_S(x)

isa_BuiltinType_WChar_U(x::AbstractBuiltinType) = clang_isa_BuiltinType_WChar_U(x)

isa_BuiltinType_WChar_S(x::AbstractBuiltinType) = clang_isa_BuiltinType_WChar_S(x)

isa_BuiltinType_Char8(x::AbstractBuiltinType) = clang_isa_BuiltinType_Char8(x)

isa_BuiltinType_Char16(x::AbstractBuiltinType) = clang_isa_BuiltinType_Char16(x)

isa_BuiltinType_Char32(x::AbstractBuiltinType) = clang_isa_BuiltinType_Char32(x)

isa_BuiltinType_SChar(x::AbstractBuiltinType) = clang_isa_BuiltinType_SChar(x)

isa_BuiltinType_Short(x::AbstractBuiltinType) = clang_isa_BuiltinType_Short(x)

isa_BuiltinType_Int(x::AbstractBuiltinType) = clang_isa_BuiltinType_Int(x)

isa_BuiltinType_Long(x::AbstractBuiltinType) = clang_isa_BuiltinType_Long(x)

isa_BuiltinType_LongLong(x::AbstractBuiltinType) = clang_isa_BuiltinType_LongLong(x)

isa_BuiltinType_Int128(x::AbstractBuiltinType) = clang_isa_BuiltinType_Int128(x)

isa_BuiltinType_UChar(x::AbstractBuiltinType) = clang_isa_BuiltinType_UChar(x)

isa_BuiltinType_UShort(x::AbstractBuiltinType) = clang_isa_BuiltinType_UShort(x)

isa_BuiltinType_UInt(x::AbstractBuiltinType) = clang_isa_BuiltinType_UInt(x)

isa_BuiltinType_ULong(x::AbstractBuiltinType) = clang_isa_BuiltinType_ULong(x)

isa_BuiltinType_ULongLong(x::AbstractBuiltinType) = clang_isa_BuiltinType_ULongLong(x)

isa_BuiltinType_UInt128(x::AbstractBuiltinType) = clang_isa_BuiltinType_UInt128(x)

isa_BuiltinType_Float(x::AbstractBuiltinType) = clang_isa_BuiltinType_Float(x)

isa_BuiltinType_Double(x::AbstractBuiltinType) = clang_isa_BuiltinType_Double(x)

isa_BuiltinType_LongDouble(x::AbstractBuiltinType) = clang_isa_BuiltinType_LongDouble(x)

isa_BuiltinType_Float128(x::AbstractBuiltinType) = clang_isa_BuiltinType_Float128(x)

isa_BuiltinType_Half(x::AbstractBuiltinType) = clang_isa_BuiltinType_Half(x)

isa_BuiltinType_BFloat16(x::AbstractBuiltinType) = clang_isa_BuiltinType_BFloat16(x)

isa_BuiltinType_Float16(x::AbstractBuiltinType) = clang_isa_BuiltinType_Float16(x)

isa_BuiltinType_NullPtr(x::AbstractBuiltinType) = clang_isa_BuiltinType_NullPtr(x)

# ComplexType

# PointerType
getPointeeType(x::PointerType) = QualType(clang_PointerType_getPointeeType(x))

# ReferenceType
getPointeeType(x::AbstractReferenceType) = QualType(clang_ReferenceType_getPointeeType(x))

# LValueReferenceType

# RValueReferenceType

# MemberPointerType
getPointeeType(x::AbstractMemberPointerType) = QualType(clang_MemberPointerType_getPointeeType(x))

getClass(x::AbstractMemberPointerType) = Type_(clang_MemberPointerType_getClass(x))

# ConstantArrayType

# IncompleteArrayType

# VariableArrayType

# DependentSizedArrayType

# FunctionType
getReturnType(x::AbstractFunctionType) = QualType(clang_FunctionType_getReturnType(getTypePtr(x)))

# FunctionNoProtoType

# FunctionProtoType
getNumParams(x::FunctionProtoType) = clang_FunctionProtoType_getNumParams(x)
getParamType(x::FunctionProtoType, i::Integer) = QualType(clang_FunctionProtoType_getParamType(x, i))

# TypedefType
desugar(x::TypedefType) = QualType(clang_TypedefType_desugar(x))

# TagType

# RecordType

# EnumType
getDecl(x::EnumType) = EnumDecl(clang_EnumType_getDecl(x))
getIntegerType(x::EnumType) = getIntegerType(getDecl(x))
getName(x::EnumType) = getName(getDecl(x))

# TemplateTypeParmType

# SubstTemplateTypeParmType

# SubstTemplateTypeParmPackType

# TemplateSpecializationType
function isCurrentInstantiation(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isCurrentInstantiation(x)
end

function isTypeAlias(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isTypeAlias(x)
end

function getAliasedType(x::TemplateSpecializationType)
    return QualType(clang_TemplateSpecializationType_getAliasedType(x))
end

# function getNumArgs(x::TemplateSpecializationType)
#     return clang_TemplateSpecializationType_getNumArgs(x)
# end

# function getArg(x::TemplateSpecializationType, i::Integer)
#     @check_ptrs x
#     return TemplateArgument(clang_TemplateSpecializationType_getArg(x, i))
# end

function isSugared(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isSugared(x)
end

function desugar(x::TemplateSpecializationType)
    return QualType(clang_TemplateSpecializationType_desugar(x))
end

getName(x::TemplateSpecializationType) = getName(getAsTemplateDecl(getTemplateName(x)))

# ElaboratedType
desugar(x::ElaboratedType) = QualType(clang_ElaboratedType_desugar(x))

# DependentNameType

# DependentTemplateSpecializationType
