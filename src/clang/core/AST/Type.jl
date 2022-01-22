"""
    abstract type AbstractClangType <: Any
Supertype for `clang::Type`s.

1. `clang::Type` has no corresponding handle type in Julia.
2. `CXType_` is an opaque pointer for `clang::Type *`.
3. `get_type_ptr`/`getTypePtr` is for converting a `QualType` to a `CXType_`.
4. `get_qual_type`/`getCanonicalTypeInternal` is for converting a `CXType_` to a `QualType`.
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

Base.unsafe_convert(::Type{CXQualType}, x::T) where {T<:AbstractQualType} = x.ptr
Base.cconvert(::Type{CXQualType}, x::T) where {T<:AbstractQualType} = x

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

# FIXME: find a use case
# """
#     CanQualType <: AbstractClangType
# Represent a canonical, qualified type.
# """
# struct CanQualType <: AbstractClangType
#     ty::QualType
# end
# CanQualType(x::AbstractQualType) = CanQualType(QualType(x))

"""
    abstract type AbstractBuiltinType <: AbstractQualType
Supertype for Clang builtin types.
"""
abstract type AbstractBuiltinType <: AbstractQualType end

"""
    BuiltinType <: AbstractBuiltinType
A builtin `QualType`.

Note that, we treat `BuiltinType` as a `QualType`, not a `CXType_`.
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

# [C++ 3.9.1p5].
struct WCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

# Same as WCharTy in C++, integer type in C99.
struct WideCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

# [C99 7.24.1], integer type unchanged by default promotions.
struct WIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

# [C++20 proposal]
struct Char8Ty <: AbstractBuiltinType
    ptr::CXQualType
end

# [C++0x 3.9.1p5], integer type in C99.
struct Char16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

# [C++0x 3.9.1p5], integer type in C99.
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

# [OpenCL 6.1.1.1], ARM NEON
struct HalfTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct BFloat16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

# C11 extension ISO/IEC TS 18661-3
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
    abstract type AbstractComplexType <: AbstractQualType
Supertype for `ComplexType`s.
"""
abstract type AbstractComplexType <: AbstractQualType end

"""
    struct ComplexType <: AbstractComplexType
A `ComplexType`.

Note that, we treat `ComplexType` as a `QualType`, not a `CXType_`.
"""
struct ComplexType <: AbstractComplexType
    ptr::CXQualType
end

"""
    struct PointerType <: AbstractQualType
A `PointerType`.

Note that, we treat `PointerType` as a `QualType`, not a `CXType_`.
"""
struct PointerType <: AbstractQualType
    ptr::CXQualType
end

"""
    abstract type AbstractReferenceType <: AbstractQualType
Supertype for `ReferenceType`s.
"""
abstract type AbstractReferenceType <: AbstractQualType end

"""
    struct ReferenceType <: AbstractReferenceType
A `ReferenceType`.

Note that, we treat `ReferenceType` as a `QualType`, not a `CXType_`.
"""
struct ReferenceType <: AbstractReferenceType
    ptr::CXQualType
end

"""
    struct LValueReferenceType <: AbstractReferenceType
A `LValueReferenceType`.

Note that, we treat `LValueReferenceType` as a `QualType`, not a `CXType_`.
"""
struct LValueReferenceType <: AbstractReferenceType
    ptr::CXQualType
end

"""
    struct RValueReferenceType <: AbstractReferenceType
A `RValueReferenceType`.

Note that, we treat `RValueReferenceType` as a `QualType`, not a `CXType_`.
"""
struct RValueReferenceType <: AbstractReferenceType
    ptr::CXQualType
end

"""
    struct MemberPointerType <: AbstractQualType
A `MemberPointerType`.

Note that, we treat `MemberPointerType` as a `QualType`, not a `CXType_`.
"""
struct MemberPointerType <: AbstractQualType
    ptr::CXQualType
end

"""
    abstract type AbstractArrayType <: AbstractQualType
Supertype for `ArrayType`s.
"""
abstract type AbstractArrayType <: AbstractQualType end

"""
    struct ArrayType <: AbstractArrayType
A `ArrayType`.

Note that, we treat `ArrayType` as a `QualType`, not a `CXType_`.
"""
struct ArrayType <: AbstractArrayType
    ptr::CXQualType
end

"""
    struct ConstantArrayType <: AbstractArrayType
A `ConstantArrayType`.

Note that, we treat `ConstantArrayType` as a `QualType`, not a `CXType_`.
"""
struct ConstantArrayType <: AbstractArrayType
    ptr::CXQualType
end

"""
    struct IncompleteArrayType <: AbstractArrayType
A `IncompleteArrayType`.

Note that, we treat `IncompleteArrayType` as a `QualType`, not a `CXType_`.
"""
struct IncompleteArrayType <: AbstractArrayType
    ptr::CXQualType
end

"""
    struct VariableArrayType <: AbstractArrayType
A `VariableArrayType`.

Note that, we treat `VariableArrayType` as a `QualType`, not a `CXType_`.
"""
struct VariableArrayType <: AbstractArrayType
    ptr::CXQualType
end

"""
    struct DependentSizedArrayType <: AbstractArrayType
A `DependentSizedArrayType`.

Note that, we treat `DependentSizedArrayType` as a `QualType`, not a `CXType_`.
"""
struct DependentSizedArrayType <: AbstractArrayType
    ptr::CXQualType
end

"""
    abstract type AbstractFunctionType <: AbstractQualType
Supertype for `FunctionType`s.
"""
abstract type AbstractFunctionType <: AbstractQualType end

"""
    struct FunctionType <: AbstractFunctionType
A `FunctionType`.

Note that, we treat `FunctionType` as a `QualType`, not a `CXType_`.
"""
struct FunctionType <: AbstractFunctionType
    ptr::CXQualType
end

"""
    struct FunctionNoProtoType <: AbstractFunctionType
A `FunctionNoProtoType`.

Note that, we treat `FunctionNoProtoType` as a `QualType`, not a `CXType_`.
"""
struct FunctionNoProtoType <: AbstractFunctionType
    ptr::CXQualType
end

"""
    struct FunctionProtoType <: AbstractFunctionType
A `FunctionProtoType`.

Note that, we treat `FunctionProtoType` as a `QualType`, not a `CXType_`.
"""
struct FunctionProtoType <: AbstractFunctionType
    ptr::CXQualType
end

"""
    struct TypedefType <: AbstractQualType
A `TypedefType`.

Note that, we treat `TypedefType` as a `QualType`, not a `CXType_`.
"""
struct TypedefType <: AbstractQualType
    ptr::CXQualType
end

"""
    abstract type AbstractTagType <: AbstractQualType
Supertype for `TagType`s.
"""
abstract type AbstractTagType <: AbstractQualType end

"""
    struct TagType <: AbstractTagType
A `TagType`.

Note that, we treat `TagType` as a `QualType`, not a `CXType_`.
"""
struct TagType <: AbstractTagType
    ptr::CXQualType
end

"""
    struct RecordType <: AbstractTagType
A `RecordType`.

Note that, we treat `RecordType` as a `QualType`, not a `CXType_`.
"""
struct RecordType <: AbstractTagType
    ptr::CXQualType
end

"""
    struct EnumType <: AbstractTagType
A `EnumType`.

Note that, we treat `EnumType` as a `QualType`, not a `CXType_`.
"""
struct EnumType <: AbstractTagType
    ptr::CXQualType
end

"""
    struct TemplateTypeParmType <: AbstractQualType
A `TemplateTypeParmType`.

Note that, we treat `TemplateTypeParmType` as a `QualType`, not a `CXType_`.
"""
struct TemplateTypeParmType <: AbstractQualType
    ptr::CXQualType
end

"""
    struct SubstTemplateTypeParmType <: AbstractQualType
A `SubstTemplateTypeParmType`.

Note that, we treat `SubstTemplateTypeParmType` as a `QualType`, not a `CXType_`.
"""
struct SubstTemplateTypeParmType <: AbstractQualType
    ptr::CXQualType
end

"""
    struct SubstTemplateTypeParmPackType <: AbstractQualType
A `SubstTemplateTypeParmPackType`.

Note that, we treat `SubstTemplateTypeParmPackType` as a `QualType`, not a `CXType_`.
"""
struct SubstTemplateTypeParmPackType <: AbstractQualType
    ptr::CXQualType
end

"""
    struct TemplateSpecializationType <: AbstractQualType
A `TemplateSpecializationType`.

Note that, we treat `TemplateSpecializationType` as a `QualType`, not a `CXType_`.
"""
struct TemplateSpecializationType <: AbstractQualType
    ptr::CXQualType
end

"""
    abstract type AbstractTypeWithKeyword <: AbstractQualType
Supertype for `TypeWithKeyword`s.
"""
abstract type AbstractTypeWithKeyword <: AbstractQualType end

"""
    struct TypeWithKeyword <: AbstractTypeWithKeyword
A `TypeWithKeyword`.

Note that, we treat `TypeWithKeyword` as a `QualType`, not a `CXType_`.
"""
struct TypeWithKeyword <: AbstractTypeWithKeyword
    ptr::CXQualType
end

"""
    struct ElaboratedType <: AbstractTypeWithKeyword
A `ElaboratedType`.

Note that, we treat `ElaboratedType` as a `QualType`, not a `CXType_`.
"""
struct ElaboratedType <: AbstractTypeWithKeyword
    ptr::CXQualType
end

"""
    struct DependentNameType <: AbstractTypeWithKeyword
A `DependentNameType`.

Note that, we treat `DependentNameType` as a `QualType`, not a `CXType_`.
"""
struct DependentNameType <: AbstractTypeWithKeyword
    ptr::CXQualType
end

"""
    struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
A `DependentTemplateSpecializationType`.

Note that, we treat `DependentTemplateSpecializationType` as a `QualType`, not a `CXType_`.
"""
struct DependentTemplateSpecializationType <: AbstractTypeWithKeyword
    ptr::CXQualType
end

"""
    struct TypeSourceInfo
Hold a pointer to a `clang::TypeSourceInfo` object.
"""
struct TypeSourceInfo
    ptr::CXTypeSourceInfo
end

Base.unsafe_convert(::Type{CXTypeSourceInfo}, x::TypeSourceInfo) = x.ptr
Base.cconvert(::Type{CXTypeSourceInfo}, x::TypeSourceInfo) = x
