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
is_builtin_type(ty_ptr::CXType_) = clang_isa_BuiltinType(ty_ptr)
is_builtin_type(ty::AbstractQualType) = is_builtin_type(getTypePtr(ty))
is_builtin_type(ty::AbstractBuiltinType) = true

is_void_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Void(ty_ptr)
is_void_ty(ty::AbstractQualType) = is_void_ty(getTypePtr(ty))
is_void_ty(ty::VoidTy) = true

is_bool_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Bool(ty_ptr)
is_bool_ty(ty::AbstractQualType) = is_bool_ty(getTypePtr(ty))
is_bool_ty(ty::BoolTy) = true

is_char_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char_U(ty_ptr) || clang_isa_BuiltinType_Char_S(ty_ptr)
is_char_ty(ty::AbstractQualType) = is_char_ty(getTypePtr(ty))
is_char_ty(ty::CharTy) = true

is_wchar_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_WChar_U(ty_ptr) || clang_isa_BuiltinType_WChar_S(ty_ptr)
is_wchar_ty(ty::AbstractQualType) = is_wchar_ty(getTypePtr(ty))
is_wchar_ty(ty::WCharTy) = true

is_widechar_ty(ty::AbstractQualType) = is_wchar_ty(ty)
is_widechar_ty(ty::WideCharTy) = true

is_char8_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char8(ty_ptr)
is_char8_ty(ty::AbstractQualType) = is_char8_ty(getTypePtr(ty))
is_char8_ty(ty::Char8Ty) = true

is_char16_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char16(ty_ptr)
is_char16_ty(ty::AbstractQualType) = is_char16_ty(getTypePtr(ty))
is_char16_ty(ty::Char16Ty) = true

is_char32_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char32(ty_ptr)
is_char32_ty(ty::AbstractQualType) = is_char32_ty(getTypePtr(ty))
is_char32_ty(ty::Char32Ty) = true

is_signed_char_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_SChar(ty_ptr)
is_signed_char_ty(ty::AbstractQualType) = is_signed_char_ty(getTypePtr(ty))
is_signed_char_ty(ty::SignedCharTy) = true

is_short_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Short(ty_ptr)
is_short_ty(ty::AbstractQualType) = is_short_ty(getTypePtr(ty))
is_short_ty(ty::ShortTy) = true

is_int_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Int(ty_ptr)
is_int_ty(ty::AbstractQualType) = is_int_ty(getTypePtr(ty))
is_int_ty(ty::IntTy) = true

is_long_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Long(ty_ptr)
is_long_ty(ty::AbstractQualType) = is_long_ty(getTypePtr(ty))
is_long_ty(ty::LongTy) = true

is_longlong_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_LongLong(ty_ptr)
is_longlong_ty(ty::AbstractQualType) = is_longlong_ty(getTypePtr(ty))
is_longlong_ty(ty::LongLongTy) = true

is_int128_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Int128(ty_ptr)
is_int128_ty(ty::AbstractQualType) = is_int128_ty(getTypePtr(ty))
is_int128_ty(ty::Int128Ty) = true

is_unsigned_char_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UChar(ty_ptr)
is_unsigned_char_ty(ty::AbstractQualType) = is_unsigned_char_ty(getTypePtr(ty))
is_unsigned_char_ty(ty::UnsignedCharTy) = true

is_unsigned_short_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UShort(ty_ptr)
is_unsigned_short_ty(ty::AbstractQualType) = is_unsigned_short_ty(getTypePtr(ty))
is_unsigned_short_ty(ty::UnsignedShortTy) = true

is_unsigned_int_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UInt(ty_ptr)
is_unsigned_int_ty(ty::AbstractQualType) = is_unsigned_int_ty(getTypePtr(ty))
is_unsigned_int_ty(ty::UnsignedIntTy) = true

is_unsigned_long_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_ULong(ty_ptr)
is_unsigned_long_ty(ty::AbstractQualType) = is_unsigned_long_ty(getTypePtr(ty))
is_unsigned_long_ty(ty::UnsignedLongTy) = true

is_unsigned_longlong_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_ULongLong(ty_ptr)
is_unsigned_longlong_ty(ty::AbstractQualType) = is_unsigned_longlong_ty(getTypePtr(ty))
is_unsigned_longlong_ty(ty::UnsignedLongLongTy) = true

is_unsigned_int128_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UInt128(ty_ptr)
is_unsigned_int128_ty(ty::AbstractQualType) = is_unsigned_int128_ty(getTypePtr(ty))
is_unsigned_int128_ty(ty::UnsignedInt128Ty) = true

is_float_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Float(ty_ptr)
is_float_ty(ty::AbstractQualType) = is_float_ty(getTypePtr(ty))
is_float_ty(ty::FloatTy) = true

is_double_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Double(ty_ptr)
is_double_ty(ty::AbstractQualType) = is_double_ty(getTypePtr(ty))
is_double_ty(ty::DoubleTy) = true

is_long_double_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_LongDouble(ty_ptr)
is_long_double_ty(ty::AbstractQualType) = is_long_double_ty(getTypePtr(ty))
is_long_double_ty(ty::LongDoubleTy) = true

is_float128_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Float128(ty_ptr)
is_float128_ty(ty::AbstractQualType) = is_float128_ty(getTypePtr(ty))
is_float128_ty(ty::Float128Ty) = true

is_half_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Half(ty_ptr)
is_half_ty(ty::AbstractQualType) = is_half_ty(getTypePtr(ty))
is_half_ty(ty::HalfTy) = true

is_bfloat_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_BFloat16(ty_ptr)
is_bfloat_ty(ty::AbstractQualType) = is_bfloat_ty(getTypePtr(ty))
is_bfloat_ty(ty::BFloat16Ty) = true

is_float16_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Float16(ty_ptr)
is_float16_ty(ty::AbstractQualType) = is_float16_ty(getTypePtr(ty))
is_float16_ty(ty::Float16Ty) = true

is_nullptr_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_NullPtr(ty_ptr)
is_nullptr_ty(ty::AbstractQualType) = is_nullptr_ty(getTypePtr(ty))
is_nullptr_ty(ty::NullPtrTy) = true

# ComplexType
is_complex_type(ty_ptr::CXType_) = clang_isa_ComplexType(ty_ptr)
is_complex_type(ty::AbstractQualType) = is_complex_type(getTypePtr(ty))
is_complex_type(ty::AbstractComplexType) = true

# PointerType
getPointeeType(x::PointerType) = QualType(clang_PointerType_getPointeeType(getTypePtr(x)))

# ReferenceType
getPointeeType(x::ReferenceType) = QualType(clang_ReferenceType_getPointeeType(getTypePtr(x)))

# LValueReferenceType
is_lvalue_reference_type(ty_ptr::CXType_) = clang_isa_LValueReferenceType(ty_ptr)
is_lvalue_reference_type(ty::AbstractQualType) = is_lvalue_reference_type(getTypePtr(ty))
is_lvalue_reference_type(ty::LValueReferenceType) = true

# RValueReferenceType
is_rvalue_reference_type(ty_ptr::CXType_) = clang_isa_RValueReferenceType(ty_ptr)
is_rvalue_reference_type(ty::AbstractQualType) = is_rvalue_reference_type(getTypePtr(ty))
is_rvalue_reference_type(ty::RValueReferenceType) = true

# MemberPointerType
is_member_pointer_type(ty_ptr::CXType_) = clang_isa_MemberPointerType(ty_ptr)
is_member_pointer_type(ty::AbstractQualType) = is_member_pointer_type(getTypePtr(ty))
is_member_pointer_type(ty::MemberPointerType) = true

getPointeeType(x::MemberPointerType) = QualType(clang_MemberPointerType_getPointeeType(getTypePtr(x)))

getClass(x::MemberPointerType)::CXType_ = clang_MemberPointerType_getClass(getTypePtr(x))

# ConstantArrayType
is_constant_array_type(ty_ptr::CXType_) = clang_isa_ConstantArrayType(ty_ptr)
is_constant_array_type(ty::AbstractQualType) = is_constant_array_type(getTypePtr(ty))
is_constant_array_type(ty::ConstantArrayType) = true

# IncompleteArrayType
is_incomplete_array_type(ty_ptr::CXType_) = clang_isa_IncompleteArrayType(ty_ptr)
is_incomplete_array_type(ty::AbstractQualType) = is_incomplete_array_type(getTypePtr(ty))
is_incomplete_array_type(ty::IncompleteArrayType) = true

# VariableArrayType
is_variable_array_type(ty_ptr::CXType_) = clang_isa_VariableArrayType(ty_ptr)
is_variable_array_type(ty::AbstractQualType) = is_variable_array_type(getTypePtr(ty))
is_variable_array_type(ty::VariableArrayType) = true

# DependentSizedArrayType
is_dependent_size_array_type(ty_ptr::CXType_) = clang_isa_DependentSizedArrayType(ty_ptr)
is_dependent_size_array_type(ty::AbstractQualType) = is_dependent_size_array_type(getTypePtr(ty))
is_dependent_size_array_type(ty::DependentSizedArrayType) = true

# FunctionType
getReturnType(x::AbstractFunctionType) = QualType(clang_FunctionType_getReturnType(getTypePtr(x)))

# FunctionNoProtoType
is_function_no_proto_type(ty_ptr::CXType_) = clang_isa_FunctionNoProtoType(ty_ptr)
is_function_no_proto_type(ty::AbstractQualType) = is_function_no_proto_type(getTypePtr(ty))
is_function_no_proto_type(ty::FunctionNoProtoType) = true

# FunctionProtoType
is_function_proto_type(ty_ptr::CXType_) = clang_isa_FunctionProtoType(ty_ptr)
is_function_proto_type(ty::AbstractQualType) = is_function_proto_type(getTypePtr(ty))
is_function_proto_type(ty::FunctionProtoType) = true

getNumParams(x::FunctionProtoType) = clang_FunctionProtoType_getNumParams(getTypePtr(x))
getParamType(x::FunctionProtoType, i::Integer) = QualType(clang_FunctionProtoType_getParamType(getTypePtr(x), i))

# TypedefType
is_typedef_type(ty_ptr::CXType_) = clang_isa_TypedefType(ty_ptr)
is_typedef_type(ty::AbstractQualType) = is_typedef_type(getTypePtr(ty))
is_typedef_type(ty::TypedefType) = true

desugar(x::TypedefType) = QualType(clang_TypedefType_desugar(getTypePtr(x)))

# TagType
is_tag_type(ty_ptr::CXType_) = clang_isa_TagType(ty_ptr)
is_tag_type(ty::AbstractQualType) = is_tag_type(getTypePtr(ty))
is_tag_type(ty::AbstractTagType) = true

# RecordType
is_record_type(ty_ptr::CXType_) = clang_isa_RecordType(ty_ptr)
is_record_type(ty::AbstractQualType) = is_record_type(getTypePtr(ty))
is_record_type(ty::RecordType) = true

# EnumType
is_enum_type(ty_ptr::CXType_) = clang_isa_EnumType(ty_ptr)
is_enum_type(ty::AbstractQualType) = is_enum_type(getTypePtr(ty))
is_enum_type(ty::EnumType) = true

getDecl(x::EnumType) = EnumDecl(clang_EnumType_getDecl(x))
getIntegerType(x::EnumType) = getIntegerType(getDecl(x))
getName(x::EnumType) = getName(getDecl(x))

# TemplateTypeParmType
is_template_type_parm_type(ty_ptr::CXType_) = clang_isa_TemplateTypeParmType(ty_ptr)
is_template_type_parm_type(ty::AbstractQualType) = is_template_type_parm_type(getTypePtr(ty))
is_template_type_parm_type(ty::TemplateTypeParmType) = true

# SubstTemplateTypeParmType
is_subst_template_type_parm_type(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmType(ty_ptr)
is_subst_template_type_parm_type(ty::AbstractQualType) = is_subst_template_type_parm_type(getTypePtr(ty))
is_subst_template_type_parm_type(ty::SubstTemplateTypeParmType) = true

# SubstTemplateTypeParmPackType
is_subst_template_type_parm_pack_type(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmPackType(ty_ptr)
is_subst_template_type_parm_pack_type(ty::AbstractQualType) = is_subst_template_type_parm_pack_type(getTypePtr(ty))
is_subst_template_type_parm_pack_type(ty::SubstTemplateTypeParmPackType) = true

# TemplateSpecializationType
is_template_specialization_type(ty_ptr::CXType_) = clang_isa_TemplateSpecializationType(ty_ptr)
is_template_specialization_type(ty::AbstractQualType) = is_template_specialization_type(getTypePtr(ty))
is_template_specialization_type(ty::TemplateSpecializationType) = true

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
is_elaborated_type(ty_ptr::CXType_) = clang_isa_ElaboratedType(ty_ptr)
is_elaborated_type(ty::AbstractQualType) = is_elaborated_type(getTypePtr(ty))
is_elaborated_type(ty::ElaboratedType) = true

desugar(x::ElaboratedType) = clang_ElaboratedType_desugar(getTypePtr(x))

# DependentNameType
is_dependent_name_type(ty_ptr::CXType_) = clang_isa_DependentNameType(ty_ptr)
is_dependent_name_type(ty::AbstractQualType) = is_dependent_name_type(getTypePtr(ty))
is_dependent_name_type(ty::DependentNameType) = true

# DependentTemplateSpecializationType
is_dependent_template_specilization_type(ty_ptr::CXType_) = clang_isa_DependentTemplateSpecializationType(ty_ptr)
is_dependent_template_specilization_type(ty::AbstractQualType) = is_dependent_template_specilization_type(getTypePtr(ty))
is_dependent_template_specilization_type(ty::DependentTemplateSpecializationType) = true
