# BuiltinTypes
is_builtin_type(x::AbstractType) = isBuiltinType(x)
is_builtin_type(x::AbstractBuiltinType) = true

is_void_ty(x::AbstractType) = isa_BuiltinType_Void(x)
is_void_ty(x::VoidTy) = true

is_bool_ty(x::AbstractType) = isa_BuiltinType_Bool(x)
is_bool_ty(x::BoolTy) = true

is_char_ty(x::AbstractType) = isa_BuiltinType_Char_U(x) || isa_BuiltinType_Char_S(x)
is_char_ty(x::CharTy) = true

is_wchar_ty(x::AbstractType) = isa_BuiltinType_WChar_U(x) || isa_BuiltinType_WChar_S(x)
is_wchar_ty(x::WCharTy) = true

is_widechar_ty(x::AbstractType) = is_wchar_ty(x)
is_widechar_ty(x::WideCharTy) = true

is_char8_ty(x::AbstractType) = isa_BuiltinType_Char8(x)
is_char8_ty(x::Char8Ty) = true

is_char16_ty(x::AbstractType) = isa_BuiltinType_Char16(x)
is_char16_ty(x::Char16Ty) = true

is_char32_ty(x::AbstractType) = isa_BuiltinType_Char32(x)
is_char32_ty(x::Char32Ty) = true

is_signed_char_ty(x::AbstractType) = isa_BuiltinType_SChar(x)
is_signed_char_ty(x::SignedCharTy) = true

is_short_ty(x::AbstractType) = isa_BuiltinType_Short(x)
is_short_ty(x::ShortTy) = true

is_int_ty(x::AbstractType) = isa_BuiltinType_Int(x)
is_int_ty(x::IntTy) = true

is_long_ty(x::AbstractType) = isa_BuiltinType_Long(x)
is_long_ty(x::LongTy) = true

is_longlong_ty(x::AbstractType) = isa_BuiltinType_LongLong(x)
is_longlong_ty(x::LongLongTy) = true

is_int128_ty(x::AbstractType) = isa_BuiltinType_Int128(x)
is_int128_ty(x::Int128Ty) = true

is_unsigned_char_ty(x::AbstractType) = isa_BuiltinType_UChar(x)
is_unsigned_char_ty(x::UnsignedCharTy) = true

is_unsigned_short_ty(x::AbstractType) = isa_BuiltinType_UShort(x)
is_unsigned_short_ty(x::UnsignedShortTy) = true

is_unsigned_int_ty(x::AbstractType) = isa_BuiltinType_UInt(x)
is_unsigned_int_ty(x::UnsignedIntTy) = true

is_unsigned_long_ty(x::AbstractType) = isa_BuiltinType_ULong(x)
is_unsigned_long_ty(x::UnsignedLongTy) = true

is_unsigned_longlong_ty(x::AbstractType) = isa_BuiltinType_ULongLong(x)
is_unsigned_longlong_ty(x::UnsignedLongLongTy) = true

is_unsigned_int128_ty(x::AbstractType) = isa_BuiltinType_UInt128(x)
is_unsigned_int128_ty(x::UnsignedInt128Ty) = true

is_float_ty(x::AbstractType) = isa_BuiltinType_Float(x)
is_float_ty(x::FloatTy) = true

is_double_ty(x::AbstractType) = isa_BuiltinType_Double(x)
is_double_ty(x::DoubleTy) = true

is_long_double_ty(x::AbstractType) = isa_BuiltinType_LongDouble(x)
is_long_double_ty(x::LongDoubleTy) = true

is_float128_ty(x::AbstractType) = isa_BuiltinType_Float128(x)
is_float128_ty(x::Float128Ty) = true

is_half_ty(x::AbstractType) = isa_BuiltinType_Half(x)
is_half_ty(x::HalfTy) = true

is_bfloat_ty(x::AbstractType) = isa_BuiltinType_BFloat16(x)
is_bfloat_ty(x::BFloat16Ty) = true

is_float16_ty(x::AbstractType) = isa_BuiltinType_Float16(x)
is_float16_ty(x::Float16Ty) = true

is_nullptr_ty(x::AbstractType) = isa_BuiltinType_NullPtr(x)
is_nullptr_ty(x::NullPtrTy) = true

# ComplexType
is_complex_type(x::AbstractType) = isComplexType(x)
is_complex_type(x::AbstractComplexType) = true

# PointerType
is_pointer_type(x::AbstractType) = isPointerType(x)
is_pointer_type(x::PointerType) = true

get_pointee_type(x::PointerType) = getPointeeType(x)

# ReferenceType
is_reference_type(x::AbstractType) = isReferenceType(x)
is_reference_type(x::AbstractReferenceType) = true

get_pointee_type(x::AbstractReferenceType) = getPointeeType(x)

# LValueReferenceType
is_lvalue_reference_type(x::AbstractType) = isLValueReferenceType(x)
is_lvalue_reference_type(x::LValueReferenceType) = true

# RValueReferenceType
is_rvalue_reference_type(x::AbstractType) = isRValueReferenceType(x)
is_rvalue_reference_type(x::RValueReferenceType) = true

# MemberPointerType
is_member_pointer_type(x::AbstractType) = isMemberPointerType(x)
is_member_pointer_type(x::MemberPointerType) = true

get_pointee_type(x::MemberPointerType) = getPointeeType(x)

get_class(x::MemberPointerType) = getClass(x)  # TODO: convert result to a QualType?

# ArrayType
is_array_type(x::AbstractType) = isArrayType(x)
is_array_type(x::AbstractArrayType) = true

# ConstantArrayType
is_constant_array_type(x::AbstractType) = isConstantArrayType(x)
is_constant_array_type(x::ConstantArrayType) = true

# IncompleteArrayType
is_incomplete_array_type(x::AbstractType) = isIncompleteArrayType(x)
is_incomplete_array_type(x::IncompleteArrayType) = true

# VariableArrayType
is_variable_array_type(x::AbstractType) = isVariableArrayType(x)
is_variable_array_type(x::VariableArrayType) = true

# DependentSizedArrayType
is_dependent_size_array_type(x::AbstractType) = isDependentSizedArrayType(x)
is_dependent_size_array_type(x::DependentSizedArrayType) = true

# FunctionType
is_function_type(x::AbstractType) = isFunctionType(x)
is_function_type(x::AbstractFunctionType) = true

# FunctionNoProtoType
is_function_no_proto_type(x::AbstractType) = isFunctionNoProtoType(x)
is_function_no_proto_type(x::FunctionNoProtoType) = true

# FunctionProtoType
is_function_proto_type(x::AbstractType) = isFunctionProtoType(x)
is_function_proto_type(x::FunctionProtoType) = true

get_return_type(x::FunctionProtoType) = getReturnType(x)

get_params(x::FunctionProtoType) = [getParamType(x, i) for i = 0:(getNumParams(x) - 1)]

# TypedefType
is_typedef_type(x::AbstractType) = isa_TypedefType(x)
is_typedef_type(x::TypedefType) = true

#= desugar(x::TypedefType) =#

# TagType
is_tag_type(x::AbstractType) = isa_TagType(x)
is_tag_type(x::AbstractTagType) = true

# RecordType
is_record_type(x::AbstractType) = isRecordType(x)
is_record_type(x::RecordType) = true

# EnumType
is_enum_type(x::AbstractType) = isa_EnumType(x)
is_enum_type(x::EnumType) = true

get_integer_type(x::EnumType) = getIntegerType(x)

get_name(x::EnumType) = getName(x)

# TemplateTypeParmType
is_template_type_parm_type(x::AbstractType) = isTemplateTypeParmType(x)
is_template_type_parm_type(x::TemplateTypeParmType) = true

# SubstTemplateTypeParmType
is_subst_template_type_parm_type(x::AbstractType) = isa_SubstTemplateTypeParmType(x)
is_subst_template_type_parm_type(x::SubstTemplateTypeParmType) = true

# SubstTemplateTypeParmPackType
is_subst_template_type_parm_pack_type(x::AbstractType) = isa_SubstTemplateTypeParmPackType(x)
is_subst_template_type_parm_pack_type(x::SubstTemplateTypeParmPackType) = true

# TemplateSpecializationType
is_template_specialization_type(x::AbstractType) = isa_TemplateSpecializationType(x)
is_template_specialization_type(x::TemplateSpecializationType) = true

is_sugared(x::TemplateSpecializationType) = isSugared(x)

#= desugar(x::TemplateSpecializationType) =#

get_name(x::TemplateSpecializationType) = getName(x)

get_template_args(x::TemplateSpecializationType) = [getArg(x, i) for i = 0:(getNumArgs(x) - 1)]

# ElaboratedType
is_elaborated_type(x::AbstractType) = isa_ElaboratedType(x)
is_elaborated_type(x::ElaboratedType) = true

#= desugar(x::ElaboratedType) =#

# DependentNameType
is_dependent_name_type(x::AbstractType) = isa_DependentNameType(x)
is_dependent_name_type(x::DependentNameType) = true

# DependentTemplateSpecializationType
is_dependent_template_specilization_type(x::AbstractType) = isa_DependentTemplateSpecializationType(x)
is_dependent_template_specilization_type(x::DependentTemplateSpecializationType) = true
