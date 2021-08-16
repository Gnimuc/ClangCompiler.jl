"""
    abstract type AbstractClangType <: Any
Supertype for `clang::Type`s.

1. `clang::Type` has no corresponding handle type in Julia.
2. `CXType_` is an opaque pointer for `clang::Type *`.
3. `get_type_ptr(x::AbstractQualType)` is for converting a `QualType` to a `CXType_`.
4. `get_qual_type(x::CXType_)` is for converting a `CXType_` to a `QualType`.
"""
abstract type AbstractClangType end

struct UnexposedType{T<:AbstractClangType} <: AbstractClangType
    ty::T
end

"""
    abstract type AbstractQualType <: AbstractClangType
Supertype for `clang::QualType`s.

As we use `QualType` everywhere, it's useful to create a type hierarchy of different
`QualType`s on the Julia side for multiple dispatch.
"""
abstract type AbstractQualType <: AbstractClangType end

"""
    QualType <: AbstractQualType
Represent a qualified type.

Note that, the underlying pointer is NOT a *pointer* to a `clang::QualType` object. Instead,
it's the opaque pointer representation of the `clang::QualType` itself.
"""
struct QualType <: AbstractQualType
    ptr::CXQualType
end

QualType(x::T) where {T<:AbstractQualType} = QualType(x.ptr)
QualType(ptr::CXType_, quals::Unsigned) = QualType(clang_QualType_constructFromTypePtr(ptr), quals)

get_canonical_type_internal(ptr::CXType_) = QualType(clang_Type_getCanonicalTypeInternal(ptr))
get_qual_type(ptr::CXType_) = get_canonical_type_internal(ptr)
get_qual_type(x::AbstractQualType) = x

get_type_ptr(x::AbstractQualType)::CXType_ = clang_QualType_getTypePtr(x.ptr)
get_type_ptr_or_null(x::AbstractQualType)::CXType_ = clang_QualType_getTypePtrOrNull(x.ptr)

is_canonical(x::AbstractQualType) = clang_QualType_isCanonical(x.ptr)

is_null(x::AbstractQualType) = clang_QualType_isNull(x.ptr)

is_const_qualified(x::AbstractQualType) = clang_QualType_isConstQualified(x.ptr)
is_restrict_qualified(x::AbstractQualType) = clang_QualType_isRestrictQualified(x.ptr)
is_volatile_qualified(x::AbstractQualType) = clang_QualType_isVolatileQualified(x.ptr)

is_const(x::AbstractQualType) = is_const_qualified(x)
is_restrict(x::AbstractQualType) = is_restrict_qualified(x)
is_volatile(x::AbstractQualType) = is_volatile_qualified(x)

has_qualifiers(x::AbstractQualType) = clang_QualType_hasQualifiers(x.ptr)

is_local_const_qualified(x::AbstractQualType) = clang_QualType_isLocalConstQualified(x.ptr)
is_local_restrict_qualified(x::AbstractQualType) = clang_QualType_isLocalRestrictQualified(x.ptr)
is_local_volatile_qualified(x::AbstractQualType) = clang_QualType_isLocalVolatileQualified(x.ptr)

is_local_const(x::AbstractQualType) = is_local_const_qualified(x)
is_local_restrict(x::AbstractQualType) = is_local_restrict_qualified(x)
is_local_volatile(x::AbstractQualType) = is_local_volatile_qualified(x)

has_local_qualifiers(x::AbstractQualType) = clang_QualType_hasLocalQualifiers(x.ptr)

with_const(x::AbstractQualType) = QualType(clang_QualType_withConst(x.ptr))
with_restrict(x::AbstractQualType) = QualType(clang_QualType_withRestrict(x.ptr))
with_volatile(x::AbstractQualType) = QualType(clang_QualType_withVolatile(x.ptr))

add_const(x::AbstractQualType) = QualType(clang_QualType_addConst(x.ptr))
add_restrict(x::AbstractQualType) = QualType(clang_QualType_addRestrict(x.ptr))
add_volatile(x::AbstractQualType) = QualType(clang_QualType_addVolatile(x.ptr))

get_canonical_type(x::AbstractQualType) = QualType(clang_QualType_getCanonicalType(x.ptr))
get_canonical_unqualified_type(x::AbstractQualType) = QualType(clang_QualType_getLocalUnqualifiedType(x.ptr))
get_unqualified_type(x::AbstractQualType) = QualType(clang_QualType_getUnqualifiedType(x.ptr))

function get_as_string(x::AbstractQualType)
    str = clang_QualType_getAsString(x.ptr)
    s = unsafe_string(str)
    clang_QualType_disposeString(str)
    return s
end

name(x::AbstractQualType) = get_as_string(x)

dump(x::AbstractQualType) = clang_QualType_dump(x.ptr)

get_pointee_type(ty_ptr::CXType_) = clang_Type_getPointeeType(ty_ptr)
get_pointee_type(ty::AbstractQualType) = QualType(get_pointee_type(get_type_ptr(ty)))

is_void_type(ty_ptr::CXType_) = clang_Type_isVoidType(ty_ptr)
is_void_type(ty::AbstractQualType) = is_void_type(get_type_ptr(ty))

is_boolean_type(ty_ptr::CXType_) = clang_Type_isBooleanType(ty_ptr)
is_boolean_type(ty::AbstractQualType) = is_boolean_type(get_type_ptr(ty))

is_pointer_type(ty_ptr::CXType_) = clang_Type_isPointerType(ty_ptr)
is_pointer_type(ty::AbstractQualType) = is_pointer_type(get_type_ptr(ty))

is_function_pointer_type(ty_ptr::CXType_) = clang_Type_isFunctionPointerType(ty_ptr)
is_function_pointer_type(ty::AbstractQualType) = is_function_pointer_type(get_type_ptr(ty))

is_function_type(ty_ptr::CXType_) = clang_Type_isFunctionType(ty_ptr)
is_function_type(ty::AbstractQualType) = is_function_type(get_type_ptr(ty))

is_member_function_pointer_type(ty_ptr::CXType_) = clang_Type_isMemberFunctionPointerType(ty_ptr)
is_member_function_pointer_type(ty::AbstractQualType) = is_member_function_pointer_type(get_type_ptr(ty))

is_reference_type(ty_ptr::CXType_) = clang_Type_isReferenceType(ty_ptr)
is_reference_type(ty::AbstractQualType) = is_reference_type(get_type_ptr(ty))

is_char_type(ty_ptr::CXType_) = clang_Type_isCharType(ty_ptr)
is_char_type(ty::AbstractQualType) = is_char_type(get_type_ptr(ty))

is_enumeral_type(ty_ptr::CXType_) = clang_Type_isEnumeralType(ty_ptr)
is_enumeral_type(ty::AbstractQualType) = is_enumeral_type(get_type_ptr(ty))

is_array_type(ty_ptr::CXType_) = clang_Type_isArrayType(ty_ptr)
is_array_type(ty::AbstractQualType) = is_array_type(get_type_ptr(ty))

"""
    CanQualType <: AbstractClangType
Represent a canonical, qualified type.
"""
struct CanQualType <: AbstractClangType
    ty::QualType
end
CanQualType(x::AbstractQualType) = CanQualType(QualType(x))

"""
    abstract type AbstractBuiltinType <: AbstractQualType
Supertype for Clang builtin types.
"""
abstract type AbstractBuiltinType <: AbstractQualType end

is_builtin_type(ty_ptr::CXType_) = clang_isa_BuiltinType(ty_ptr)
is_builtin_type(ty::AbstractQualType) = is_builtin_type(get_type_ptr(ty))
is_builtin_type(ty::AbstractBuiltinType) = true

"""
    BuiltinType <: AbstractBuiltinType
A builtin `QualType`.

Note that, we treat `BuiltinType` as a `QualType`, not a `CXType_` in Clang.
"""
struct BuiltinType <: AbstractBuiltinType
    ptr::CXQualType
end

struct VoidTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_void_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Void(ty_ptr)
is_void_ty(ty::AbstractQualType) = is_void_ty(get_type_ptr(ty))
is_void_ty(ty::VoidTy) = true

struct BoolTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_bool_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Bool(ty_ptr)
is_bool_ty(ty::AbstractQualType) = is_bool_ty(get_type_ptr(ty))
is_bool_ty(ty::BoolTy) = true

struct CharTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_char_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char_U(ty_ptr) || clang_isa_BuiltinType_Char_S(ty_ptr)
is_char_ty(ty::AbstractQualType) = is_char_ty(get_type_ptr(ty))
is_char_ty(ty::CharTy) = true

# [C++ 3.9.1p5].
struct WCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_wchar_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_WChar_U(ty_ptr) || clang_isa_BuiltinType_WChar_S(ty_ptr)
is_wchar_ty(ty::AbstractQualType) = is_wchar_ty(get_type_ptr(ty))
is_wchar_ty(ty::WCharTy) = true

# Same as WCharTy in C++, integer type in C99.
struct WideCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_widechar_ty(ty::AbstractQualType) = is_wchar_ty(ty)
is_widechar_ty(ty::WideCharTy) = true

# [C99 7.24.1], integer type unchanged by default promotions.
struct WIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

# [C++20 proposal]
struct Char8Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_char8_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char8(ty_ptr)
is_char8_ty(ty::AbstractQualType) = is_char8_ty(get_type_ptr(ty))
is_char8_ty(ty::Char8Ty) = true

# [C++0x 3.9.1p5], integer type in C99.
struct Char16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_char16_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char16(ty_ptr)
is_char16_ty(ty::AbstractQualType) = is_char16_ty(get_type_ptr(ty))
is_char16_ty(ty::Char16Ty) = true

# [C++0x 3.9.1p5], integer type in C99.
struct Char32Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_char32_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Char32(ty_ptr)
is_char32_ty(ty::AbstractQualType) = is_char32_ty(get_type_ptr(ty))
is_char32_ty(ty::Char32Ty) = true

struct SignedCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_signed_char_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_SChar(ty_ptr)
is_signed_char_ty(ty::AbstractQualType) = is_signed_char_ty(get_type_ptr(ty))
is_signed_char_ty(ty::SignedCharTy) = true

struct ShortTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_short_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Short(ty_ptr)
is_short_ty(ty::AbstractQualType) = is_short_ty(get_type_ptr(ty))
is_short_ty(ty::ShortTy) = true

struct IntTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_int_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Int(ty_ptr)
is_int_ty(ty::AbstractQualType) = is_int_ty(get_type_ptr(ty))
is_int_ty(ty::IntTy) = true

struct LongTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_long_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Long(ty_ptr)
is_long_ty(ty::AbstractQualType) = is_long_ty(get_type_ptr(ty))
is_long_ty(ty::LongTy) = true

struct LongLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_longlong_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_LongLong(ty_ptr)
is_longlong_ty(ty::AbstractQualType) = is_longlong_ty(get_type_ptr(ty))
is_longlong_ty(ty::LongLongTy) = true

struct Int128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_int128_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Int128(ty_ptr)
is_int128_ty(ty::AbstractQualType) = is_int128_ty(get_type_ptr(ty))
is_int128_ty(ty::Int128Ty) = true

struct UnsignedCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_unsigned_char_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UChar(ty_ptr)
is_unsigned_char_ty(ty::AbstractQualType) = is_unsigned_char_ty(get_type_ptr(ty))
is_unsigned_char_ty(ty::UnsignedCharTy) = true

struct UnsignedShortTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_unsigned_short_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UShort(ty_ptr)
is_unsigned_short_ty(ty::AbstractQualType) = is_unsigned_short_ty(get_type_ptr(ty))
is_unsigned_short_ty(ty::UnsignedShortTy) = true

struct UnsignedIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_unsigned_int_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UInt(ty_ptr)
is_unsigned_int_ty(ty::AbstractQualType) = is_unsigned_int_ty(get_type_ptr(ty))
is_unsigned_int_ty(ty::UnsignedIntTy) = true

struct UnsignedLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_unsigned_long_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_ULong(ty_ptr)
is_unsigned_long_ty(ty::AbstractQualType) = is_unsigned_long_ty(get_type_ptr(ty))
is_unsigned_long_ty(ty::UnsignedLongTy) = true

struct UnsignedLongLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_unsigned_longlong_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_ULongLong(ty_ptr)
is_unsigned_longlong_ty(ty::AbstractQualType) = is_unsigned_longlong_ty(get_type_ptr(ty))
is_unsigned_longlong_ty(ty::UnsignedLongLongTy) = true

struct UnsignedInt128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_unsigned_int128_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_UInt128(ty_ptr)
is_unsigned_int128_ty(ty::AbstractQualType) = is_unsigned_int128_ty(get_type_ptr(ty))
is_unsigned_int128_ty(ty::UnsignedInt128Ty) = true

struct FloatTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_float_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Float(ty_ptr)
is_float_ty(ty::AbstractQualType) = is_float_ty(get_type_ptr(ty))
is_float_ty(ty::FloatTy) = true

struct DoubleTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_double_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Double(ty_ptr)
is_double_ty(ty::AbstractQualType) = is_double_ty(get_type_ptr(ty))
is_double_ty(ty::DoubleTy) = true

struct LongDoubleTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_long_double_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_LongDouble(ty_ptr)
is_long_double_ty(ty::AbstractQualType) = is_long_double_ty(get_type_ptr(ty))
is_long_double_ty(ty::LongDoubleTy) = true

struct Float128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_float128_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Float128(ty_ptr)
is_float128_ty(ty::AbstractQualType) = is_float128_ty(get_type_ptr(ty))
is_float128_ty(ty::Float128Ty) = true

# [OpenCL 6.1.1.1], ARM NEON
struct HalfTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_half_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Half(ty_ptr)
is_half_ty(ty::AbstractQualType) = is_half_ty(get_type_ptr(ty))
is_half_ty(ty::HalfTy) = true

struct BFloat16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_bfloat_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_BFloat16(ty_ptr)
is_bfloat_ty(ty::AbstractQualType) = is_bfloat_ty(get_type_ptr(ty))
is_bfloat_ty(ty::BFloat16Ty) = true

# C11 extension ISO/IEC TS 18661-3
struct Float16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

is_float16_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_Float16(ty_ptr)
is_float16_ty(ty::AbstractQualType) = is_float16_ty(get_type_ptr(ty))
is_float16_ty(ty::Float16Ty) = true

struct FloatComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct DoubleComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongDoubleComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Float128ComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct VoidPtrTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct NullPtrTy <: AbstractBuiltinType
    ptr::CXQualType
end

is_nullptr_ty(ty_ptr::CXType_) = clang_isa_BuiltinType_NullPtr(ty_ptr)
is_nullptr_ty(ty::AbstractQualType) = is_nullptr_ty(get_type_ptr(ty))
is_nullptr_ty(ty::NullPtrTy) = true

"""
    abstract type AbstractComplexType <: AbstractQualType
Supertype for `ComplexType`s.
"""
abstract type AbstractComplexType <: AbstractQualType end

is_complex_type(ty_ptr::CXType_) = clang_isa_ComplexType(ty_ptr)
is_complex_type(ty::AbstractQualType) = is_complex_type(get_type_ptr(ty))
is_complex_type(ty::AbstractComplexType) = true

"""
    struct ComplexType <: AbstractComplexType
A `ComplexType`.

Note that, we treat `ComplexType` as a `QualType`, not a `CXType_` in Clang.
"""
struct ComplexType <: AbstractComplexType
    ptr::CXQualType
end

"""
    struct PointerType <: AbstractQualType
A `PointerType`.

Note that, we treat `PointerType` as a `QualType`, not a `CXType_` in Clang.
"""
struct PointerType <: AbstractQualType
    ptr::CXQualType
end

is_pointer_type(ty::PointerType) = true

get_pointee_type(x::PointerType) = QualType(clang_PointerType_getPointeeType(get_type_ptr(x)))

"""
    abstract type AbstractReferenceType <: AbstractQualType
Supertype for `ReferenceType`s.
"""
abstract type AbstractReferenceType <: AbstractQualType end

is_reference_type(ty::AbstractReferenceType) = true

"""
    struct ReferenceType <: AbstractReferenceType
A `ReferenceType`.

Note that, we treat `ReferenceType` as a `QualType`, not a `CXType_` in Clang.
"""
struct ReferenceType <: AbstractReferenceType
    ptr::CXQualType
end

get_pointee_type(x::ReferenceType) = QualType(clang_ReferenceType_getPointeeType(get_type_ptr(x)))

"""
    struct LValueReferenceType <: AbstractReferenceType
A `LValueReferenceType`.

Note that, we treat `LValueReferenceType` as a `QualType`, not a `CXType_` in Clang.
"""
struct LValueReferenceType <: AbstractReferenceType
    ptr::CXQualType
end

is_lvalue_reference_type(ty_ptr::CXType_) = clang_isa_LValueReferenceType(ty_ptr)
is_lvalue_reference_type(ty::AbstractQualType) = is_lvalue_reference_type(get_type_ptr(ty))
is_lvalue_reference_type(ty::LValueReferenceType) = true

"""
    struct RValueReferenceType <: AbstractReferenceType
A `RValueReferenceType`.

Note that, we treat `RValueReferenceType` as a `QualType`, not a `CXType_` in Clang.
"""
struct RValueReferenceType <: AbstractReferenceType
    ptr::CXQualType
end

is_rvalue_reference_type(ty_ptr::CXType_) = clang_isa_RValueReferenceType(ty_ptr)
is_rvalue_reference_type(ty::AbstractQualType) = is_rvalue_reference_type(get_type_ptr(ty))
is_rvalue_reference_type(ty::RValueReferenceType) = true

"""
    struct MemberPointerType <: AbstractQualType
A `MemberPointerType`.

Note that, we treat `MemberPointerType` as a `QualType`, not a `CXType_` in Clang.
"""
struct MemberPointerType <: AbstractQualType
    ptr::CXQualType
end

is_member_pointer_type(ty_ptr::CXType_) = clang_isa_MemberPointerType(ty_ptr)
is_member_pointer_type(ty::AbstractQualType) = is_member_pointer_type(get_type_ptr(ty))
is_member_pointer_type(ty::MemberPointerType) = true

get_pointee_type(x::MemberPointerType) = QualType(clang_MemberPointerType_getPointeeType(get_type_ptr(x)))

get_class(x::MemberPointerType)::CXType_ = clang_MemberPointerType_getClass(get_type_ptr(x))

"""
    abstract type AbstractArrayType <: AbstractQualType
Supertype for `ArrayType`s.
"""
abstract type AbstractArrayType <: AbstractQualType end

is_array_type(ty::AbstractArrayType) = true

"""
    struct ArrayType <: AbstractArrayType
A `ArrayType`.

Note that, we treat `ArrayType` as a `QualType`, not a `CXType_` in Clang.
"""
struct ArrayType <: AbstractArrayType
    ptr::CXQualType
end

"""
    struct ConstantArrayType <: AbstractArrayType
A `ConstantArrayType`.

Note that, we treat `ConstantArrayType` as a `QualType`, not a `CXType_` in Clang.
"""
struct ConstantArrayType <: AbstractArrayType
    ptr::CXQualType
end

is_constant_array_type(ty_ptr::CXType_) = clang_isa_ConstantArrayType(ty_ptr)
is_constant_array_type(ty::AbstractQualType) = is_constant_array_type(get_type_ptr(ty))
is_constant_array_type(ty::ConstantArrayType) = true

"""
    struct IncompleteArrayType <: AbstractArrayType
A `IncompleteArrayType`.

Note that, we treat `IncompleteArrayType` as a `QualType`, not a `CXType_` in Clang.
"""
struct IncompleteArrayType <: AbstractArrayType
    ptr::CXQualType
end

is_incomplete_array_type(ty_ptr::CXType_) = clang_isa_IncompleteArrayType(ty_ptr)
is_incomplete_array_type(ty::AbstractQualType) = is_incomplete_array_type(get_type_ptr(ty))
is_incomplete_array_type(ty::IncompleteArrayType) = true

"""
    struct VariableArrayType <: AbstractArrayType
A `VariableArrayType`.

Note that, we treat `VariableArrayType` as a `QualType`, not a `CXType_` in Clang.
"""
struct VariableArrayType <: AbstractArrayType
    ptr::CXQualType
end

is_variable_array_type(ty_ptr::CXType_) = clang_isa_VariableArrayType(ty_ptr)
is_variable_array_type(ty::AbstractQualType) = is_variable_array_type(get_type_ptr(ty))
is_variable_array_type(ty::VariableArrayType) = true

"""
    struct DependentSizedArrayType <: AbstractArrayType
A `DependentSizedArrayType`.

Note that, we treat `DependentSizedArrayType` as a `QualType`, not a `CXType_` in Clang.
"""
struct DependentSizedArrayType <: AbstractArrayType
    ptr::CXQualType
end

is_dependent_size_array_type(ty_ptr::CXType_) = clang_isa_DependentSizedArrayType(ty_ptr)
is_dependent_size_array_type(ty::AbstractQualType) = is_dependent_size_array_type(get_type_ptr(ty))
is_dependent_size_array_type(ty::DependentSizedArrayType) = true

"""
    abstract type AbstractFunctionType <: AbstractQualType
Supertype for `FunctionType`s.
"""
abstract type AbstractFunctionType <: AbstractQualType end

is_function_type(ty::AbstractFunctionType) = true

get_return_type(x::AbstractFunctionType) = QualType(clang_FunctionType_getReturnType(get_type_ptr(x)))

"""
    struct FunctionType <: AbstractFunctionType
A `FunctionType`.

Note that, we treat `FunctionType` as a `QualType`, not a `CXType_` in Clang.
"""
struct FunctionType <: AbstractFunctionType
    ptr::CXQualType
end

"""
    struct FunctionNoProtoType <: AbstractFunctionType
A `FunctionNoProtoType`.

Note that, we treat `FunctionNoProtoType` as a `QualType`, not a `CXType_` in Clang.
"""
struct FunctionNoProtoType <: AbstractFunctionType
    ptr::CXQualType
end

is_function_no_proto_type(ty_ptr::CXType_) = clang_isa_FunctionNoProtoType(ty_ptr)
is_function_no_proto_type(ty::AbstractQualType) = is_function_no_proto_type(get_type_ptr(ty))
is_function_no_proto_type(ty::FunctionNoProtoType) = true

"""
    struct FunctionProtoType <: AbstractFunctionType
A `FunctionProtoType`.

Note that, we treat `FunctionProtoType` as a `QualType`, not a `CXType_` in Clang.
"""
struct FunctionProtoType <: AbstractFunctionType
    ptr::CXQualType
end

is_function_proto_type(ty_ptr::CXType_) = clang_isa_FunctionProtoType(ty_ptr)
is_function_proto_type(ty::AbstractQualType) = is_function_proto_type(get_type_ptr(ty))
is_function_proto_type(ty::FunctionProtoType) = true

get_num_params(x::FunctionProtoType) = clang_FunctionProtoType_getNumParams(get_type_ptr(x))

get_param_type(x::FunctionProtoType, i::Integer) = QualType(clang_FunctionProtoType_getParamType(get_type_ptr(x), i))

get_params(x::FunctionProtoType) = [get_param_type(x, i) for i = 0:get_num_params(x)-1]

"""
    struct TypedefType <: AbstractQualType
A `TypedefType`.

Note that, we treat `TypedefType` as a `QualType`, not a `CXType_` in Clang.
"""
struct TypedefType <: AbstractQualType
    ptr::CXQualType
end

is_typedef_type(ty_ptr::CXType_) = clang_isa_TypedefType(ty_ptr)
is_typedef_type(ty::AbstractQualType) = is_typedef_type(get_type_ptr(ty))
is_typedef_type(ty::TypedefType) = true

desugar(x::TypedefType) = QualType(clang_TypedefType_desugar(get_type_ptr(x)))

"""
    abstract type AbstractTagType <: AbstractQualType
Supertype for `TagType`s.
"""
abstract type AbstractTagType <: AbstractQualType end

is_tag_type(ty_ptr::CXType_) = clang_isa_TagType(ty_ptr)
is_tag_type(ty::AbstractQualType) = is_tag_type(get_type_ptr(ty))
is_tag_type(ty::AbstractTagType) = true

"""
    struct TagType <: AbstractTagType
A `TagType`.

Note that, we treat `TagType` as a `QualType`, not a `CXType_` in Clang.
"""
struct TagType <: AbstractTagType
    ptr::CXQualType
end

"""
    struct RecordType <: AbstractTagType
A `RecordType`.

Note that, we treat `RecordType` as a `QualType`, not a `CXType_` in Clang.
"""
struct RecordType <: AbstractTagType
    ptr::CXQualType
end

is_record_type(ty_ptr::CXType_) = clang_isa_RecordType(ty_ptr)
is_record_type(ty::AbstractQualType) = is_record_type(get_type_ptr(ty))
is_record_type(ty::RecordType) = true

"""
    struct EnumType <: AbstractTagType
A `EnumType`.

Note that, we treat `EnumType` as a `QualType`, not a `CXType_` in Clang.
"""
struct EnumType <: AbstractTagType
    ptr::CXQualType
end

is_enum_type(ty_ptr::CXType_) = clang_isa_EnumType(ty_ptr)
is_enum_type(ty::AbstractQualType) = is_enum_type(get_type_ptr(ty))
is_enum_type(ty::EnumType) = true

get_integer_type(x::EnumType) = get_integer_type(get_decl(x))

get_name(x::EnumType) = get_name(get_decl(x))

name(x::EnumType) = get_name(x)

"""
    struct TemplateTypeParmType <: AbstractQualType
A `TemplateTypeParmType`.

Note that, we treat `TemplateTypeParmType` as a `QualType`, not a `CXType_` in Clang.
"""
struct TemplateTypeParmType <: AbstractQualType
    ptr::CXQualType
end

is_template_type_parm_type(ty_ptr::CXType_) = clang_isa_TemplateTypeParmType(ty_ptr)
is_template_type_parm_type(ty::AbstractQualType) = is_template_type_parm_type(get_type_ptr(ty))
is_template_type_parm_type(ty::TemplateTypeParmType) = true

"""
    struct SubstTemplateTypeParmType <: AbstractQualType
A `SubstTemplateTypeParmType`.

Note that, we treat `SubstTemplateTypeParmType` as a `QualType`, not a `CXType_` in Clang.
"""
struct SubstTemplateTypeParmType <: AbstractQualType
    ptr::CXQualType
end

is_subst_template_type_parm_type(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmType(ty_ptr)
is_subst_template_type_parm_type(ty::AbstractQualType) = is_subst_template_type_parm_type(get_type_ptr(ty))
is_subst_template_type_parm_type(ty::SubstTemplateTypeParmType) = true

"""
    struct SubstTemplateTypeParmPackType <: AbstractQualType
A `SubstTemplateTypeParmPackType`.

Note that, we treat `SubstTemplateTypeParmPackType` as a `QualType`, not a `CXType_` in Clang.
"""
struct SubstTemplateTypeParmPackType <: AbstractQualType
    ptr::CXQualType
end

is_subst_template_type_parm_pack_type(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmPackType(ty_ptr)
is_subst_template_type_parm_pack_type(ty::AbstractQualType) = is_subst_template_type_parm_pack_type(get_type_ptr(ty))
is_subst_template_type_parm_pack_type(ty::SubstTemplateTypeParmPackType) = true

"""
    struct TemplateSpecializationType <: AbstractQualType
A `TemplateSpecializationType`.

Note that, we treat `TemplateSpecializationType` as a `QualType`, not a `CXType_` in Clang.
"""
struct TemplateSpecializationType <: AbstractQualType
    ptr::CXQualType
end

is_template_specialization_type(ty_ptr::CXType_) = clang_isa_TemplateSpecializationType(ty_ptr)
is_template_specialization_type(ty::AbstractQualType) = is_template_specialization_type(get_type_ptr(ty))
is_template_specialization_type(ty::TemplateSpecializationType) = true

function is_current_instantiation(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isCurrentInstantiation(get_type_ptr(ty))
end

function is_type_alias(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isTypeAlias(get_type_ptr(ty))
end

function get_aliased_type(x::TemplateSpecializationType)
    return QualType(clang_TemplateSpecializationType_getAliasedType(get_type_ptr(ty)))
end

function get_num_args(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_getNumArgs(get_type_ptr(ty))
end

function is_sugared(x::TemplateSpecializationType)
    return clang_TemplateSpecializationType_isSugared(get_type_ptr(ty))
end

function desugar(x::TemplateSpecializationType)
    return QualType(clang_TemplateSpecializationType_desugar(get_type_ptr(ty)))
end

get_name(x::TemplateSpecializationType) = get_name(get_as_template_decl(get_template_name(x)))

name(x::TemplateSpecializationType) = get_name(x)

"""
    abstract type AbstractTypeWithKeyword <: AbstractQualType
Supertype for `TypeWithKeyword`s.
"""
abstract type AbstractTypeWithKeyword <: AbstractQualType end

"""
    struct TypeWithKeyword <: AbstractTypeWithKeyword
A `TypeWithKeyword`.

Note that, we treat `TypeWithKeyword` as a `QualType`, not a `CXType_` in Clang.
"""
struct TypeWithKeyword <: AbstractTypeWithKeyword
    ptr::CXQualType
end

"""
    struct ElaboratedType <: AbstractTypeWithKeyword
A `ElaboratedType`.

Note that, we treat `ElaboratedType` as a `QualType`, not a `CXType_` in Clang.
"""
struct ElaboratedType <: AbstractTypeWithKeyword
    ptr::CXQualType
end

is_elaborated_type(ty_ptr::CXType_) = clang_isa_ElaboratedType(ty_ptr)
is_elaborated_type(ty::AbstractQualType) = is_elaborated_type(get_type_ptr(ty))
is_elaborated_type(ty::ElaboratedType) = true

desugar(x::ElaboratedType) = clang_ElaboratedType_desugar(get_type_ptr(x))

"""
    struct DependentNameType <: AbstractTypeWithKeyword
A `DependentNameType`.

Note that, we treat `DependentNameType` as a `QualType`, not a `CXType_` in Clang.
"""
struct DependentNameType <: AbstractTypeWithKeyword
    ptr::CXQualType
end

is_dependent_name_type(ty_ptr::CXType_) = clang_isa_DependentNameType(ty_ptr)
is_dependent_name_type(ty::AbstractQualType) = is_dependent_name_type(get_type_ptr(ty))
is_dependent_name_type(ty::DependentNameType) = true

"""
    struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
A `DependentTemplateSpecializationType`.

Note that, we treat `DependentTemplateSpecializationType` as a `QualType`, not a `CXType_` in Clang.
"""
struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
    ptr::CXQualType
end

is_dependent_template_specilization_type(ty_ptr::CXType_) = clang_isa_DependentTemplateSpecializationType(ty_ptr)
is_dependent_template_specilization_type(ty::AbstractQualType) = is_dependent_template_specilization_type(get_type_ptr(ty))
is_dependent_template_specilization_type(ty::DependentTemplateSpecializationType) = true
