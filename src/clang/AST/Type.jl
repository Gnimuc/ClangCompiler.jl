"""
    abstract type AbstractClangType <: Any
Supertype for `clang::Type`s.

1. `clang::Type` has no corresponding handle type in Julia.
2. `CXType_` is an opaque pointer for `clang::Type *`.
3. `get_type_ptr(x::QualType)` is for converting a `QualType` to a `CXType_`.
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
QualType(ptr::CXType_, quals::Unsigned) = QualType(clang_QualType_constructFromTypePtr(ptr), quals)

get_canonical_type_internal(ptr::CXType_) = QualType(clang_Type_getCanonicalTypeInternal(ptr))
get_qual_type(ptr::CXType_) = get_canonical_type_internal(ptr)
get_qual_type(x::AbstractClangType) = get_qual_type(x.ptr)
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

is_complex_type(ty_ptr::CXType_) = clang_isa_ComplexType(ty_ptr)
is_complex_type(ty::AbstractQualType) = is_complex_type(get_type_ptr(ty))
is_complex_type(ty::AbstractComplexType) = true

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

is_pointer_type(ty::PointerType) = true

function get_pointee_type(x::PointerType)
    @assert x.ptr != C_NULL "PointerType has a NULL pointer."
    return QualType(clang_PointerType_getPointeeType(x.ptr))
end

"""
    abstract type AbstractReferenceType <: AbstractClangType
Supertype for `ReferenceType`s.
"""
abstract type AbstractReferenceType <: AbstractClangType end

is_reference_type(ty::AbstractReferenceType) = true

"""
    struct ReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::ReferenceType` object.
"""
struct ReferenceType <: AbstractReferenceType
    ptr::CXReferenceType
end

function get_pointee_type(x::ReferenceType)
    @assert x.ptr != C_NULL "ReferenceType has a NULL pointer."
    return QualType(clang_ReferenceType_getPointeeType(x.ptr))
end

"""
    struct LValueReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::LValueReferenceType` object.
"""
struct LValueReferenceType <: AbstractReferenceType
    ptr::CXLValueReferenceType
end

is_lvalue_reference_type(ty_ptr::CXType_) = clang_isa_LValueReferenceType(ty_ptr)
is_lvalue_reference_type(ty::AbstractQualType) = is_lvalue_reference_type(get_type_ptr(ty))
is_lvalue_reference_type(ty::LValueReferenceType) = true

"""
    struct RValueReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::RValueReferenceType` object.
"""
struct RValueReferenceType <: AbstractReferenceType
    ptr::CXRValueReferenceType
end

is_rvalue_reference_type(ty_ptr::CXType_) = clang_isa_RValueReferenceType(ty_ptr)
is_rvalue_reference_type(ty::AbstractQualType) = is_rvalue_reference_type(get_type_ptr(ty))
is_rvalue_reference_type(ty::RValueReferenceType) = true

"""
    struct MemberPointerType <: AbstractClangType
Hold a pointer to a `clang::MemberPointerType` object.
"""
struct MemberPointerType <: AbstractClangType
    ptr::CXMemberPointerType
end

is_member_pointer_type(ty_ptr::CXType_) = clang_isa_MemberPointerType(ty_ptr)
is_member_pointer_type(ty::AbstractQualType) = is_member_pointer_type(get_type_ptr(ty))
is_member_pointer_type(ty::MemberPointerType) = true

function get_pointee_type(x::MemberPointerType)
    @assert x.ptr != C_NULL "MemberPointerType has a NULL pointer."
    return QualType(clang_MemberPointerType_getPointeeType(x.ptr))
end

function get_class(x::MemberPointerType)::CXType_
    @assert x.ptr != C_NULL "MemberPointerType has a NULL pointer."
    return clang_MemberPointerType_getClass(x.ptr)
end

"""
    abstract type AbstractArrayType <: AbstractClangType
Supertype for `ArrayType`s.
"""
abstract type AbstractArrayType <: AbstractClangType end

is_array_type(ty::AbstractArrayType) = true

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

is_constant_array_type(ty_ptr::CXType_) = clang_isa_ConstantArrayType(ty_ptr)
is_constant_array_type(ty::AbstractQualType) = is_constant_array_type(get_type_ptr(ty))
is_constant_array_type(ty::ConstantArrayType) = true

"""
    struct IncompleteArrayType <: AbstractArrayType
Hold a pointer to a `clang::IncompleteArrayType` object.
"""
struct IncompleteArrayType <: AbstractArrayType
    ptr::CXIncompleteArrayType
end

is_incomplete_array_type(ty_ptr::CXType_) = clang_isa_IncompleteArrayType(ty_ptr)
is_incomplete_array_type(ty::AbstractQualType) = is_incomplete_array_type(get_type_ptr(ty))
is_incomplete_array_type(ty::IncompleteArrayType) = true

"""
    struct VariableArrayType <: AbstractArrayType
Hold a pointer to a `clang::VariableArrayType` object.
"""
struct VariableArrayType <: AbstractArrayType
    ptr::CXVariableArrayType
end

is_variable_array_type(ty_ptr::CXType_) = clang_isa_VariableArrayType(ty_ptr)
is_variable_array_type(ty::AbstractQualType) = is_variable_array_type(get_type_ptr(ty))
is_variable_array_type(ty::VariableArrayType) = true

"""
    struct DependentSizedArrayType <: AbstractArrayType
Hold a pointer to a `clang::DependentSizedArrayType` object.
"""
struct DependentSizedArrayType <: AbstractArrayType
    ptr::CXDependentSizedArrayType
end

is_dependent_size_array_type(ty_ptr::CXType_) = clang_isa_DependentSizedArrayType(ty_ptr)
is_dependent_size_array_type(ty::AbstractQualType) = is_dependent_size_array_type(get_type_ptr(ty))
is_dependent_size_array_type(ty::DependentSizedArrayType) = true

"""
    abstract type AbstractFunctionType <: AbstractClangType
Supertype for `FunctionType`s.
"""
abstract type AbstractFunctionType <: AbstractClangType end

is_function_type(ty::AbstractFunctionType) = true

function get_return_type(x::AbstractFunctionType)
    @assert x.ptr != C_NULL "FunctionType has a NULL pointer."
    return clang_FunctionType_getReturnType(x.ptr)
end

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

is_function_no_proto_type(ty_ptr::CXType_) = clang_isa_FunctionNoProtoType(ty_ptr)
is_function_no_proto_type(ty::AbstractQualType) = is_function_no_proto_type(get_type_ptr(ty))
is_function_no_proto_type(ty::FunctionNoProtoType) = true

"""
    struct FunctionProtoType <: AbstractFunctionType
Hold a pointer to a `clang::FunctionProtoType` object.
"""
struct FunctionProtoType <: AbstractFunctionType
    ptr::CXFunctionProtoType
end

is_function_proto_type(ty_ptr::CXType_) = clang_isa_FunctionProtoType(ty_ptr)
is_function_proto_type(ty::AbstractQualType) = is_function_proto_type(get_type_ptr(ty))
is_function_proto_type(ty::FunctionProtoType) = true

function get_num_params(x::FunctionProtoType)
    @assert x.ptr != C_NULL "FunctionProtoType has a NULL pointer."
    return clang_FunctionProtoType_getNumParams(x.ptr)
end

function get_param_type(x::FunctionProtoType, i::Integer)
    @assert x.ptr != C_NULL "FunctionProtoType has a NULL pointer."
    return QualType(clang_FunctionProtoType_getParamType(x.ptr, i))
end

get_params(x::FunctionProtoType) = [get_param_type(x, i) for i = 0:get_num_params(x)-1]

"""
    struct TypedefType <: AbstractClangType
Hold a pointer to a `clang::TypedefType` object.
"""
struct TypedefType <: AbstractClangType
    ptr::CXTypedefType
end

is_typedef_type(ty_ptr::CXType_) = clang_isa_TypedefType(ty_ptr)
is_typedef_type(ty::AbstractQualType) = is_typedef_type(get_type_ptr(ty))
is_typedef_type(ty::TypedefType) = true

"""
    abstract type AbstractTagType <: AbstractClangType
Supertype for `TagType`s.
"""
abstract type AbstractTagType <: AbstractClangType end

is_tag_type(ty_ptr::CXType_) = clang_isa_TagType(ty_ptr)
is_tag_type(ty::AbstractQualType) = is_tag_type(get_type_ptr(ty))
is_tag_type(ty::AbstractTagType) = true

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

is_record_type(ty_ptr::CXType_) = clang_isa_RecordType(ty_ptr)
is_record_type(ty::AbstractQualType) = is_record_type(get_type_ptr(ty))
is_record_type(ty::RecordType) = true

"""
    struct EnumType <: AbstractTagType
Hold a pointer to a `clang::EnumType` object.
"""
struct EnumType <: AbstractTagType
    ptr::CXEnumType
end

is_enum_type(ty_ptr::CXType_) = clang_isa_EnumType(ty_ptr)
is_enum_type(ty::AbstractQualType) = is_enum_type(get_type_ptr(ty))
is_enum_type(ty::EnumType) = true

get_integer_type(x::EnumType) = get_integer_type(get_decl(x))

get_name(x::EnumType) = get_name(get_decl(x))

name(x::EnumType) = get_name(x)

"""
    struct TemplateTypeParmType <: AbstractClangType
Hold a pointer to a `clang::TemplateTypeParmType` object.
"""
struct TemplateTypeParmType <: AbstractClangType
    ptr::CXTemplateTypeParmType
end

is_template_type_parm_type(ty_ptr::CXType_) = clang_isa_TemplateTypeParmType(ty_ptr)
is_template_type_parm_type(ty::AbstractQualType) = is_template_type_parm_type(get_type_ptr(ty))
is_template_type_parm_type(ty::TemplateTypeParmType) = true

"""
    struct SubstTemplateTypeParmType <: AbstractClangType
Hold a pointer to a `clang::SubstTemplateTypeParmType` object.
"""
struct SubstTemplateTypeParmType <: AbstractClangType
    ptr::CXSubstTemplateTypeParmType
end

is_subst_template_type_parm_type(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmType(ty_ptr)
is_subst_template_type_parm_type(ty::AbstractQualType) = is_subst_template_type_parm_type(get_type_ptr(ty))
is_subst_template_type_parm_type(ty::SubstTemplateTypeParmType) = true

"""
    struct SubstTemplateTypeParmPackType <: AbstractClangType
Hold a pointer to a `clang::SubstTemplateTypeParmPackType` object.
"""
struct SubstTemplateTypeParmPackType <: AbstractClangType
    ptr::CXSubstTemplateTypeParmPackType
end

is_subst_template_type_parm_pack_type(ty_ptr::CXType_) = clang_isa_SubstTemplateTypeParmPackType(ty_ptr)
is_subst_template_type_parm_pack_type(ty::AbstractQualType) = is_subst_template_type_parm_pack_type(get_type_ptr(ty))
is_subst_template_type_parm_pack_type(ty::SubstTemplateTypeParmPackType) = true

"""
    struct TemplateSpecializationType <: AbstractClangType
Hold a pointer to a `clang::TemplateSpecializationType` object.
"""
struct TemplateSpecializationType <: AbstractClangType
    ptr::CXTemplateSpecializationType
end

is_template_specialization_type(ty_ptr::CXType_) = clang_isa_TemplateSpecializationType(ty_ptr)
is_template_specialization_type(ty::AbstractQualType) = is_template_specialization_type(get_type_ptr(ty))
is_template_specialization_type(ty::TemplateSpecializationType) = true

function is_current_instantiation(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return clang_TemplateSpecializationType_isCurrentInstantiation(x.ptr)
end

function is_type_alias(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return clang_TemplateSpecializationType_isTypeAlias(x.ptr)
end

function get_aliased_type(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return QualType(clang_TemplateSpecializationType_getAliasedType(x.ptr))
end

function get_num_args(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return clang_TemplateSpecializationType_getNumArgs(x.ptr)
end

function is_sugared(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return clang_TemplateSpecializationType_isSugared(x.ptr)
end

function desugar(x::TemplateSpecializationType)
    @assert x.ptr != C_NULL "TemplateSpecializationType has a NULL pointer."
    return QualType(clang_TemplateSpecializationType_desugar(x.ptr))
end

get_name(x::TemplateSpecializationType) = get_name(get_as_template_decl(get_template_name(x)))

name(x::TemplateSpecializationType) = get_name(x)

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

is_elaborated_type(ty_ptr::CXType_) = clang_isa_ElaboratedType(ty_ptr)
is_elaborated_type(ty::AbstractQualType) = is_elaborated_type(get_type_ptr(ty))
is_elaborated_type(ty::ElaboratedType) = true

function desugar(x::ElaboratedType)
    @assert x.ptr != C_NULL "ElaboratedType has a NULL pointer."
    return clang_ElaboratedType_desugar(x.ptr)
end

"""
    struct DependentNameType <: AbstractTypeWithKeyword
Hold a pointer to a `clang::DependentNameType` object.
"""
struct DependentNameType <: AbstractTypeWithKeyword
    ptr::CXDependentNameType
end

is_dependent_name_type(ty_ptr::CXType_) = clang_isa_DependentNameType(ty_ptr)
is_dependent_name_type(ty::AbstractQualType) = is_dependent_name_type(get_type_ptr(ty))
is_dependent_name_type(ty::DependentNameType) = true

"""
    struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
Hold a pointer to a `clang::DependentTemplateSpecializationType` object.
"""
struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
    ptr::CXDependentTemplateSpecializationType
end

is_dependent_template_specilization_type(ty_ptr::CXType_) = clang_isa_DependentTemplateSpecializationType(ty_ptr)
is_dependent_template_specilization_type(ty::AbstractQualType) = is_dependent_template_specilization_type(get_type_ptr(ty))
is_dependent_template_specilization_type(ty::DependentTemplateSpecializationType) = true
