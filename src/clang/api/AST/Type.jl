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

# PointerType
function getPointeeType(x::PointerType)
    @check_ptrs x
    return QualType(clang_PointerType_getPointeeType(x))
end

# ReferenceType
function getPointeeType(x::AbstractReferenceType)
    @check_ptrs x
    return QualType(clang_ReferenceType_getPointeeType(x))
end

# LValueReferenceType

# RValueReferenceType

# MemberPointerType
function getPointeeType(x::AbstractMemberPointerType)
    @check_ptrs x
    return QualType(clang_MemberPointerType_getPointeeType(x))
end

function getClass(x::AbstractMemberPointerType)
    @check_ptrs x
    return Type_(clang_MemberPointerType_getClass(x))
end

# ConstantArrayType

# IncompleteArrayType

# VariableArrayType

# DependentSizedArrayType

# FunctionType
function getReturnType(x::AbstractFunctionType)
    @check_ptrs x
    return QualType(clang_FunctionType_getReturnType(get_qual_type(x)))
end

# FunctionNoProtoType

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

# UsingType
function desugar(x::UsingType)
    @check_ptrs x
    return QualType(clang_UsingType_desugar(x))
end

# TypedefType
function desugar(x::TypedefType)
    @check_ptrs x
    return QualType(clang_TypedefType_desugar(x))
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

# TemplateTypeParmType

# SubstTemplateTypeParmType
function getReplacementType(x::SubstTemplateTypeParmType)
    @check_ptrs x
    return QualType(clang_SubstTemplateTypeParmType_getReplacementType(x))
end

function desugar(x::SubstTemplateTypeParmType)
    @check_ptrs x
    return QualType(clang_SubstTemplateTypeParmType_desugar(x))
end

# SubstTemplateTypeParmPackType

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

# DependentNameType

# DependentTemplateSpecializationType
