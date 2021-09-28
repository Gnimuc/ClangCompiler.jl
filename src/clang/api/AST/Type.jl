# QualType
QualType(ptr::CXType_, quals::Unsigned) = QualType(clang_QualType_constructFromTypePtr(ptr), quals)

getCanonicalTypeInternal(ptr::CXType_) = QualType(clang_Type_getCanonicalTypeInternal(ptr))
getTypePtr(x::AbstractQualType)::CXType_ = clang_QualType_getTypePtr(x)
getTypePtrOrNull(x::AbstractQualType)::CXType_ = clang_QualType_getTypePtrOrNull(x)

isCanonical(x::AbstractQualType) = clang_QualType_isCanonical(x)

isNull(x::AbstractQualType) = clang_QualType_isNull(x)

isConstQualified(x::AbstractQualType) = clang_QualType_isConstQualified(x)
isRestrictQualified(x::AbstractQualType) = clang_QualType_isRestrictQualified(x)
isVolatileQualified(x::AbstractQualType) = clang_QualType_isVolatileQualified(x)

hasQualifiers(x::AbstractQualType) = clang_QualType_hasQualifiers(x)

isLocalConstQualified(x::AbstractQualType) = clang_QualType_isLocalConstQualified(x)
isLocalRestrictQualified(x::AbstractQualType) = clang_QualType_isLocalRestrictQualified(x)
isLocalVolatileQualified(x::AbstractQualType) = clang_QualType_isLocalVolatileQualified(x)

hasLocalQualifiers(x::AbstractQualType) = clang_QualType_hasLocalQualifiers(x)

withConst(x::AbstractQualType) = QualType(clang_QualType_withConst(x))
withRestrict(x::AbstractQualType) = QualType(clang_QualType_withRestrict(x))
withVolatile(x::AbstractQualType) = QualType(clang_QualType_withVolatile(x))

addConst(x::AbstractQualType) = QualType(clang_QualType_addConst(x))
addRestrict(x::AbstractQualType) = QualType(clang_QualType_addRestrict(x))
addVolatile(x::AbstractQualType) = QualType(clang_QualType_addVolatile(x))

getCanonicalType(x::AbstractQualType) = QualType(clang_QualType_getCanonicalType(x))
getLocalUnqualifiedType(x::AbstractQualType) = QualType(clang_QualType_getLocalUnqualifiedType(x))
getUnqualifiedType(x::AbstractQualType) = QualType(clang_QualType_getUnqualifiedType(x))

dump(x::AbstractQualType) = clang_QualType_dump(x)

function getAsString(x::AbstractQualType)
    str = clang_QualType_getAsString(x.ptr)
    s = unsafe_string(str)
    clang_QualType_disposeString(str)
    return s
end

getPointeeType(ty_ptr::CXType_) = clang_Type_getPointeeType(ty_ptr)
getPointeeType(ty::AbstractQualType) = QualType(getPointeeType(getTypePtr(ty)))

isVoidType(ty_ptr::CXType_) = clang_Type_isVoidType(ty_ptr)
isVoidType(ty::AbstractQualType) = isVoidType(getTypePtr(ty))

isBooleanType(ty_ptr::CXType_) = clang_Type_isBooleanType(ty_ptr)
isBooleanType(ty::AbstractQualType) = isBooleanType(getTypePtr(ty))

isPointerType(ty_ptr::CXType_) = clang_Type_isPointerType(ty_ptr)
isPointerType(ty::AbstractQualType) = isPointerType(getTypePtr(ty))

isFunctionPointerType(ty_ptr::CXType_) = clang_Type_isFunctionPointerType(ty_ptr)
isFunctionPointerType(ty::AbstractQualType) = isFunctionPointerType(getTypePtr(ty))

isFunctionType(ty_ptr::CXType_) = clang_Type_isFunctionType(ty_ptr)
isFunctionType(ty::AbstractQualType) = isFunctionType(getTypePtr(ty))

isMemberFunctionPointerType(ty_ptr::CXType_) = clang_Type_isMemberFunctionPointerType(ty_ptr)
isMemberFunctionPointerType(ty::AbstractQualType) = isMemberFunctionPointerType(getTypePtr(ty))

isReferenceType(ty_ptr::CXType_) = clang_Type_isReferenceType(ty_ptr)
isReferenceType(ty::AbstractQualType) = isReferenceType(getTypePtr(ty))

isCharType(ty_ptr::CXType_) = clang_Type_isCharType(ty_ptr)
isCharType(ty::AbstractQualType) = isCharType(getTypePtr(ty))

isEnumeralType(ty_ptr::CXType_) = clang_Type_isEnumeralType(ty_ptr)
isEnumeralType(ty::AbstractQualType) = isEnumeralType(getTypePtr(ty))

isArrayType(ty_ptr::CXType_) = clang_Type_isArrayType(ty_ptr)
isArrayType(ty::AbstractQualType) = isArrayType(getTypePtr(ty))

# BuiltinTypes
isa_BuiltinType(ty_ptr::CXType_) = clang_isa_BuiltinType(ty_ptr)
isa_BuiltinType(ty::AbstractQualType) = isa_BuiltinType(getTypePtr(ty))

isa_BuiltinType_Void(ty_ptr::CXType_) = clang_isa_BuiltinType_Void(ty_ptr)
isa_BuiltinType_Void(ty::AbstractQualType) = isa_BuiltinType_Void(getTypePtr(ty))

isa_BuiltinType_Bool(ty_ptr::CXType_) = clang_isa_BuiltinType_Bool(ty_ptr)
isa_BuiltinType_Bool(ty::AbstractQualType) = isa_BuiltinType_Bool(getTypePtr(ty))

isa_BuiltinType_Char_U(ty_ptr::CXType_) = clang_isa_BuiltinType_Char_U(ty_ptr)
isa_BuiltinType_Char_U(ty::AbstractQualType) = isa_BuiltinType_Char_U(getTypePtr(ty))

isa_BuiltinType_Char_S(ty_ptr::CXType_) = clang_isa_BuiltinType_Char_S(ty_ptr)
isa_BuiltinType_Char_S(ty::AbstractQualType) = isa_BuiltinType_Char_S(getTypePtr(ty))

isa_BuiltinType_WChar_U(ty_ptr::CXType_) = clang_isa_BuiltinType_WChar_U(ty_ptr)
isa_BuiltinType_WChar_U(ty::AbstractQualType) = isa_BuiltinType_WChar_U(getTypePtr(ty))

isa_BuiltinType_WChar_S(ty_ptr::CXType_) = clang_isa_BuiltinType_WChar_S(ty_ptr)
isa_BuiltinType_WChar_S(ty::AbstractQualType) = isa_BuiltinType_WChar_S(getTypePtr(ty))

isa_BuiltinType_Char8(ty_ptr::CXType_) = clang_isa_BuiltinType_Char8(ty_ptr)
isa_BuiltinType_Char8(ty::AbstractQualType) = isa_BuiltinType_Char8(getTypePtr(ty))

isa_BuiltinType_Char16(ty_ptr::CXType_) = clang_isa_BuiltinType_Char16(ty_ptr)
isa_BuiltinType_Char16(ty::AbstractQualType) = isa_BuiltinType_Char16(getTypePtr(ty))

isa_BuiltinType_Char32(ty_ptr::CXType_) = clang_isa_BuiltinType_Char32(ty_ptr)
isa_BuiltinType_Char32(ty::AbstractQualType) = isa_BuiltinType_Char32(getTypePtr(ty))

isa_BuiltinType_SChar(ty_ptr::CXType_) = clang_isa_BuiltinType_SChar(ty_ptr)
isa_BuiltinType_SChar(ty::AbstractQualType) = isa_BuiltinType_SChar(getTypePtr(ty))

isa_BuiltinType_Short(ty_ptr::CXType_) = clang_isa_BuiltinType_Short(ty_ptr)
isa_BuiltinType_Short(ty::AbstractQualType) = isa_BuiltinType_Short(getTypePtr(ty))

isa_BuiltinType_Int(ty_ptr::CXType_) = clang_isa_BuiltinType_Int(ty_ptr)
isa_BuiltinType_Int(ty::AbstractQualType) = isa_BuiltinType_Int(getTypePtr(ty))

isa_BuiltinType_Long(ty_ptr::CXType_) = clang_isa_BuiltinType_Long(ty_ptr)
isa_BuiltinType_Long(ty::AbstractQualType) = isa_BuiltinType_Long(getTypePtr(ty))

isa_BuiltinType_LongLong(ty_ptr::CXType_) = clang_isa_BuiltinType_LongLong(ty_ptr)
isa_BuiltinType_LongLong(ty::AbstractQualType) = isa_BuiltinType_LongLong(getTypePtr(ty))

isa_BuiltinType_Int128(ty_ptr::CXType_) = clang_isa_BuiltinType_Int128(ty_ptr)
isa_BuiltinType_Int128(ty::AbstractQualType) = isa_BuiltinType_Int128(getTypePtr(ty))

isa_BuiltinType_UChar(ty_ptr::CXType_) = clang_isa_BuiltinType_UChar(ty_ptr)
isa_BuiltinType_UChar(ty::AbstractQualType) = isa_BuiltinType_UChar(getTypePtr(ty))

isa_BuiltinType_UShort(ty_ptr::CXType_) = clang_isa_BuiltinType_UShort(ty_ptr)
isa_BuiltinType_UShort(ty::AbstractQualType) = isa_BuiltinType_UShort(getTypePtr(ty))

isa_BuiltinType_UInt(ty_ptr::CXType_) = clang_isa_BuiltinType_UInt(ty_ptr)
isa_BuiltinType_UInt(ty::AbstractQualType) = isa_BuiltinType_UInt(getTypePtr(ty))

isa_BuiltinType_ULong(ty_ptr::CXType_) = clang_isa_BuiltinType_ULong(ty_ptr)
isa_BuiltinType_ULong(ty::AbstractQualType) = isa_BuiltinType_ULong(getTypePtr(ty))

isa_BuiltinType_ULongLong(ty_ptr::CXType_) = clang_isa_BuiltinType_ULongLong(ty_ptr)
isa_BuiltinType_ULongLong(ty::AbstractQualType) = isa_BuiltinType_ULongLong(getTypePtr(ty))

isa_BuiltinType_UInt128(ty_ptr::CXType_) = clang_isa_BuiltinType_UInt128(ty_ptr)
isa_BuiltinType_UInt128(ty::AbstractQualType) = isa_BuiltinType_UInt128(getTypePtr(ty))

isa_BuiltinType_Float(ty_ptr::CXType_) = clang_isa_BuiltinType_Float(ty_ptr)
isa_BuiltinType_Float(ty::AbstractQualType) = isa_BuiltinType_Float(getTypePtr(ty))

isa_BuiltinType_Double(ty_ptr::CXType_) = clang_isa_BuiltinType_Double(ty_ptr)
isa_BuiltinType_Double(ty::AbstractQualType) = isa_BuiltinType_Double(getTypePtr(ty))

isa_BuiltinType_LongDouble(ty_ptr::CXType_) = clang_isa_BuiltinType_LongDouble(ty_ptr)
isa_BuiltinType_LongDouble(ty::AbstractQualType) = isa_BuiltinType_LongDouble(getTypePtr(ty))

isa_BuiltinType_Float128(ty_ptr::CXType_) = clang_isa_BuiltinType_Float128(ty_ptr)
isa_BuiltinType_Float128(ty::AbstractQualType) = isa_BuiltinType_Float128(getTypePtr(ty))

isa_BuiltinType_Half(ty_ptr::CXType_) = clang_isa_BuiltinType_Half(ty_ptr)
isa_BuiltinType_Half(ty::AbstractQualType) = isa_BuiltinType_Half(getTypePtr(ty))

isa_BuiltinType_BFloat16(ty_ptr::CXType_) = clang_isa_BuiltinType_BFloat16(ty_ptr)
isa_BuiltinType_BFloat16(ty::AbstractQualType) = isa_BuiltinType_BFloat16(getTypePtr(ty))

isa_BuiltinType_Float16(ty_ptr::CXType_) = clang_isa_BuiltinType_Float16(ty_ptr)
isa_BuiltinType_Float16(ty::AbstractQualType) = isa_BuiltinType_Float16(getTypePtr(ty))

isa_BuiltinType_NullPtr(ty_ptr::CXType_) = clang_isa_BuiltinType_NullPtr(ty_ptr)
isa_BuiltinType_NullPtr(ty::AbstractQualType) = isa_BuiltinType_NullPtr(getTypePtr(ty))

# ComplexType
isa_ComplexType(ty_ptr::CXType_) = clang_isa_ComplexType(ty_ptr)
isa_ComplexType(ty::AbstractQualType) = isa_ComplexType(getTypePtr(ty))

# PointerType
getPointeeType(x::PointerType) = QualType(clang_PointerType_getPointeeType(getTypePtr(x)))

# ReferenceType
getPointeeType(x::ReferenceType) = QualType(clang_ReferenceType_getPointeeType(getTypePtr(x)))

# LValueReferenceType
isa_LValueReferenceType(ty_ptr::CXType_) = clang_isa_LValueReferenceType(ty_ptr)
isa_LValueReferenceType(ty::AbstractQualType) = isa_LValueReferenceType(getTypePtr(ty))

# RValueReferenceType
isa_RValueReferenceType(ty_ptr::CXType_) = clang_isa_RValueReferenceType(ty_ptr)
isa_RValueReferenceType(ty::AbstractQualType) = isa_RValueReferenceType(getTypePtr(ty))

# MemberPointerType
isa_MemberPointerType(ty_ptr::CXType_) = clang_isa_MemberPointerType(ty_ptr)
isa_MemberPointerType(ty::AbstractQualType) = isa_MemberPointerType(getTypePtr(ty))

getPointeeType(x::MemberPointerType) = QualType(clang_MemberPointerType_getPointeeType(getTypePtr(x)))

getClass(x::MemberPointerType)::CXType_ = clang_MemberPointerType_getClass(getTypePtr(x))

# ConstantArrayType
isa_ConstantArrayType(ty_ptr::CXType_) = clang_isa_ConstantArrayType(ty_ptr)
isa_ConstantArrayType(ty::AbstractQualType) = isa_ConstantArrayType(getTypePtr(ty))

# IncompleteArrayType
isa_IncompleteArrayType(ty_ptr::CXType_) = clang_isa_IncompleteArrayType(ty_ptr)
isa_IncompleteArrayType(ty::AbstractQualType) = isa_IncompleteArrayType(getTypePtr(ty))

# VariableArrayType
isa_VariableArrayType(ty_ptr::CXType_) = clang_isa_VariableArrayType(ty_ptr)
isa_VariableArrayType(ty::AbstractQualType) = isa_VariableArrayType(getTypePtr(ty))

# DependentSizedArrayType
isa_DependentSizedArrayType(ty_ptr::CXType_) = clang_isa_DependentSizedArrayType(ty_ptr)
isa_DependentSizedArrayType(ty::AbstractQualType) = isa_DependentSizedArrayType(getTypePtr(ty))

# FunctionType
getReturnType(x::AbstractFunctionType) = QualType(clang_FunctionType_getReturnType(getTypePtr(x)))

# FunctionNoProtoType
isa_FunctionNoProtoType(ty_ptr::CXType_) = clang_isa_FunctionNoProtoType(ty_ptr)
isa_FunctionNoProtoType(ty::AbstractQualType) = isa_FunctionNoProtoType(getTypePtr(ty))

# FunctionProtoType
isa_FunctionProtoType(ty_ptr::CXType_) = clang_isa_FunctionProtoType(ty_ptr)
isa_FunctionProtoType(ty::AbstractQualType) = isa_FunctionProtoType(getTypePtr(ty))

getNumParams(x::FunctionProtoType) = clang_FunctionProtoType_getNumParams(getTypePtr(x))
getParamType(x::FunctionProtoType, i::Integer) = QualType(clang_FunctionProtoType_getParamType(getTypePtr(x), i))

# TypedefType
isa_TypedefType(ty_ptr::CXType_) = clang_isa_TypedefType(ty_ptr)
isa_TypedefType(ty::AbstractQualType) = isa_TypedefType(getTypePtr(ty))

desugar(x::TypedefType) = QualType(clang_TypedefType_desugar(getTypePtr(x)))

# TagType
isa_TagType(ty_ptr::CXType_) = clang_isa_TagType(ty_ptr)
isa_TagType(ty::AbstractQualType) = isa_TagType(getTypePtr(ty))

# RecordType
isa_RecordType(ty_ptr::CXType_) = clang_isa_RecordType(ty_ptr)
isa_RecordType(ty::AbstractQualType) = isa_RecordType(getTypePtr(ty))

# EnumType
isa_EnumType(ty_ptr::CXType_) = clang_isa_EnumType(ty_ptr)
isa_EnumType(ty::AbstractQualType) = isa_EnumType(getTypePtr(ty))

getDecl(x::EnumType) = EnumDecl(clang_EnumType_getDecl(x))
getIntegerType(x::EnumType) = getIntegerType(getDecl(x))
getName(x::EnumType) = getName(getDecl(x))

# TemplateTypeParmType
isa_TemplateTypeParmType(ty_ptr::CXType_) = clang_isa_TemplateTypeParmType(ty_ptr)
isa_TemplateTypeParmType(ty::AbstractQualType) = isa_TemplateTypeParmType(getTypePtr(ty))

# SubstTemplateTypeParmType
isa_SubstTemplateTypeParmType(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmType(ty_ptr)
isa_SubstTemplateTypeParmType(ty::AbstractQualType) = isa_SubstTemplateTypeParmType(getTypePtr(ty))

# SubstTemplateTypeParmPackType
isa_SubstTemplateTypeParmPackType(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmPackType(ty_ptr)
isa_SubstTemplateTypeParmPackType(ty::AbstractQualType) = isa_SubstTemplateTypeParmPackType(getTypePtr(ty))

# TemplateSpecializationType
isa_TemplateSpecializationType(ty_ptr::CXType_) = clang_isa_TemplateSpecializationType(ty_ptr)
isa_TemplateSpecializationType(ty::AbstractQualType) = isa_TemplateSpecializationType(getTypePtr(ty))

function isCurrentInstantiation(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isCurrentInstantiation(getTypePtr(ty))
end

function isTypeAlias(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isTypeAlias(getTypePtr(ty))
end

function getAliasedType(x::TemplateSpecializationType)
    return QualType(clang_TemplateSpecializationType_getAliasedType(getTypePtr(ty)))
end

function getNumArgs(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_getNumArgs(getTypePtr(ty))
end

function isSugared(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isSugared(getTypePtr(ty))
end

function desugar(x::TemplateSpecializationType)
    return QualType(clang_TemplateSpecializationType_desugar(getTypePtr(ty)))
end

getName(x::TemplateSpecializationType) = getName(getAsTemplateDecl(getTemplateName(x)))

# ElaboratedType
isa_ElaboratedType(ty_ptr::CXType_) = clang_isa_ElaboratedType(ty_ptr)
isa_ElaboratedType(ty::AbstractQualType) = isa_ElaboratedType(getTypePtr(ty))

desugar(x::ElaboratedType) = clang_ElaboratedType_desugar(getTypePtr(x))

# DependentNameType
isa_DependentNameType(ty_ptr::CXType_) = clang_isa_DependentNameType(ty_ptr)
isa_DependentNameType(ty::AbstractQualType) = isa_DependentNameType(getTypePtr(ty))

# DependentTemplateSpecializationType
isa_DependentTemplateSpecializationType(ty_ptr::CXType_) = clang_isa_DependentTemplateSpecializationType(ty_ptr)
isa_DependentTemplateSpecializationType(ty::AbstractQualType) = isa_DependentTemplateSpecializationType(getTypePtr(ty))
