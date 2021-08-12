"""
    abstract type AbstractClangType <: Any
Supertype for `clang::Type`s.

1. `clang::Type` has no corresponding handle type in Julia.
2. `CXType_` is an opaque pointer for `clang::Type *`.
3. if certain Clang API needs a `clang::Type *`, use `get_type_ptr(x::QualType)` to get the pointer.
4. there is no wrapper for constructing a `QualType` from a `CXType_`, so Clang APIs that return a `clang::Type *` are intentially excluded.
"""
abstract type AbstractClangType end

"""
    abstract type AbstractQualType <: AbstractClangType
Supertype for `clang::QualType`s.

As we use `QualType` everywhere, it's useful to create a type hierarchy of different
`QualType`s on the Julia side for multiple dispatch.

For other types that are `<: AbstractClangType` but not `AbstractQualType`, e.g.
[`ComplexType`](@ref), one needs to use [`desugar`](@ref) to extract the underlying `QualType`.
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

add_const(x::AbstractQualType) = clang_QualType_addConst(x.ptr)
add_restrict(x::AbstractQualType) = clang_QualType_addRestrict(x.ptr)
add_volatile(x::AbstractQualType) = clang_QualType_addVolatile(x.ptr)

get_canonical_type(x::AbstractQualType) = QualType(clang_QualType_getCanonicalType(x.ptr))
get_canonical_unqualified_type(x::AbstractQualType) = QualType(clang_QualType_getLocalUnqualifiedType(x.ptr))
get_unqualified_type(x::AbstractQualType) = QualType(clang_QualType_getUnqualifiedType(x.ptr))

function get_string(x::AbstractQualType)
    str = clang_QualType_getAsString(x.ptr)
    s = unsafe_string(str)
    clang_QualType_disposeString(str)
    return s
end

dump(x::AbstractQualType) = clang_QualType_dump(x.ptr)

get_pointee_type(ty_ptr::CXType_) = clang_Type_getPointeeType(ty_ptr)
get_pointee_type(ty::AbstractQualType) = QualType(get_pointee_type(get_type_ptr(ty)))

get_canonical_type_internal(ty_ptr::CXType_) = clang_Type_getCanonicalTypeInternal(ty_ptr)
get_canonical_type_internal(ty::AbstractQualType) = QualType(get_canonical_type_internal(get_type_ptr(ty)))

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

"""
    BuiltinType <: AbstractBuiltinType
A builtin `QualType`.
"""
struct BuiltinType <: AbstractBuiltinType
    ptr::CXQualType
end

struct VoidTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct BoolTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct CharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct WCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct WideCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct WIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Char8Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct Char16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct Char32Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct SignedCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct ShortTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct IntTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Int128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedShortTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedLongLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedInt128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct FloatTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct DoubleTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongDoubleTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Float128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct HalfTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct BFloat16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct Float16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

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

"""
    abstract type AbstractComplexType <: AbstractClangType
Supertype for `ComplexType`s.
"""
abstract type AbstractComplexType <: AbstractClangType end

"""
    struct ComplexType <: AbstractComplexType
Hold a pointer to a `clang::ComplexType` object.
"""
struct ComplexType <: AbstractComplexType
    ptr::CXComplexType
end

"""
    struct PointerType <: AbstractClangType
Hold a pointer to a `clang::PointerType` object.
"""
struct PointerType <: AbstractClangType
    ptr::CXPointerType
end

"""
    abstract type AbstractReferenceType <: AbstractClangType
Supertype for `ReferenceType`s.
"""
abstract type AbstractReferenceType <: AbstractClangType end

"""
    struct ReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::ReferenceType` object.
"""
struct ReferenceType <: AbstractReferenceType
    ptr::CXReferenceType
end

"""
    struct LValueReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::LValueReferenceType` object.
"""
struct LValueReferenceType <: AbstractReferenceType
    ptr::CXLValueReferenceType
end

"""
    struct RValueReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::RValueReferenceType` object.
"""
struct RValueReferenceType <: AbstractReferenceType
    ptr::CXRValueReferenceType
end

"""
    struct MemberPointerType <: AbstractClangType
Hold a pointer to a `clang::MemberPointerType` object.
"""
struct MemberPointerType <: AbstractClangType
    ptr::CXMemberPointerType
end

"""
    abstract type AbstractArrayType <: AbstractClangType
Supertype for `ArrayType`s.
"""
abstract type AbstractArrayType <: AbstractClangType end

"""
    struct ArrayType <: AbstractArrayType
Hold a pointer to a `clang::ArrayType` object.
"""
struct ArrayType <: AbstractArrayType
    ptr::CXArrayType
end

"""
    struct ConstantArrayType <: AbstractArrayType
Hold a pointer to a `clang::ConstantArrayType` object.
"""
struct ConstantArrayType <: AbstractArrayType
    ptr::CXConstantArrayType
end

"""
    struct IncompleteArrayType <: AbstractArrayType
Hold a pointer to a `clang::IncompleteArrayType` object.
"""
struct IncompleteArrayType <: AbstractArrayType
    ptr::CXIncompleteArrayType
end

"""
    struct VariableArrayType <: AbstractArrayType
Hold a pointer to a `clang::VariableArrayType` object.
"""
struct VariableArrayType <: AbstractArrayType
    ptr::CXVariableArrayType
end

"""
    struct DependentSizedArrayType <: AbstractArrayType
Hold a pointer to a `clang::DependentSizedArrayType` object.
"""
struct DependentSizedArrayType <: AbstractArrayType
    ptr::CXDependentSizedArrayType
end

"""
    abstract type AbstractFunctionType <: AbstractClangType
Supertype for `FunctionType`s.
"""
abstract type AbstractFunctionType <: AbstractClangType end

"""
    struct FunctionType <: AbstractFunctionType
Hold a pointer to a `clang::FunctionType` object.
"""
struct FunctionType <: AbstractFunctionType
    ptr::CXFunctionType
end

"""
    struct FunctionNoProtoType <: AbstractFunctionType
Hold a pointer to a `clang::FunctionNoProtoType` object.
"""
struct FunctionNoProtoType <: AbstractFunctionType
    ptr::CXFunctionNoProtoType
end

"""
    struct FunctionProtoType <: AbstractFunctionType
Hold a pointer to a `clang::FunctionProtoType` object.
"""
struct FunctionProtoType <: AbstractFunctionType
    ptr::CXFunctionProtoType
end

"""
    struct TypedefType <: AbstractClangType
Hold a pointer to a `clang::TypedefType` object.
"""
struct TypedefType <: AbstractClangType
    ptr::CXTypedefType
end

"""
    abstract type AbstractTagType <: AbstractClangType
Supertype for `TagType`s.
"""
abstract type AbstractTagType <: AbstractClangType end

"""
    struct TagType <: AbstractTagType
Hold a pointer to a `clang::TagType` object.
"""
struct TagType <: AbstractTagType
    ptr::CXTagType
end

"""
    struct RecordType <: AbstractTagType
Hold a pointer to a `clang::RecordType` object.
"""
struct RecordType <: AbstractTagType
    ptr::CXRecordType
end

"""
    struct EnumType <: AbstractTagType
Hold a pointer to a `clang::EnumType` object.
"""
struct EnumType <: AbstractTagType
    ptr::CXEnumType
end

"""
    struct TemplateTypeParmType <: AbstractClangType
Hold a pointer to a `clang::TemplateTypeParmType` object.
"""
struct TemplateTypeParmType <: AbstractClangType
    ptr::CXTemplateTypeParmType
end

"""
    struct SubstTemplateTypeParmType <: AbstractClangType
Hold a pointer to a `clang::SubstTemplateTypeParmType` object.
"""
struct SubstTemplateTypeParmType <: AbstractClangType
    ptr::CXSubstTemplateTypeParmType
end

"""
    struct SubstTemplateTypeParmPackType <: AbstractClangType
Hold a pointer to a `clang::SubstTemplateTypeParmPackType` object.
"""
struct SubstTemplateTypeParmPackType <: AbstractClangType
    ptr::CXSubstTemplateTypeParmPackType
end

"""
    struct TemplateSpecializationType <: AbstractClangType
Hold a pointer to a `clang::TemplateSpecializationType` object.
"""
struct TemplateSpecializationType <: AbstractClangType
    ptr::CXTemplateSpecializationType
end

"""
    abstract type AbstractTypeWithKeyword <: AbstractClangType
Supertype for `TypeWithKeyword`s.
"""
abstract type AbstractTypeWithKeyword <: AbstractClangType end

"""
    struct TypeWithKeyword <: AbstractTypeWithKeyword
Hold a pointer to a `clang::TypeWithKeyword` object.
"""
struct TypeWithKeyword <: AbstractTypeWithKeyword
    ptr::CXTypeWithKeyword
end

"""
    struct ElaboratedType <: AbstractTypeWithKeyword
Hold a pointer to a `clang::ElaboratedType` object.
"""
struct ElaboratedType <: AbstractTypeWithKeyword
    ptr::CXElaboratedType
end

"""
    struct DependentNameType <: AbstractTypeWithKeyword
Hold a pointer to a `clang::DependentNameType` object.
"""
struct DependentNameType <: AbstractTypeWithKeyword
    ptr::CXDependentNameType
end

"""
    struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
Hold a pointer to a `clang::DependentTemplateSpecializationType` object.
"""
struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
    ptr::CXDependentTemplateSpecializationType
end
