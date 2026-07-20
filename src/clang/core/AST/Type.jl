"""
    struct ComplexType <: AbstractComplexType
Hold a pointer to a `clang::ComplexType` object.
"""
struct ComplexType <: AbstractComplexType
    ptr::CXComplexType
end

Base.unsafe_convert(::Type{CXComplexType}, x::ComplexType) = x.ptr
Base.cconvert(::Type{CXComplexType}, x::ComplexType) = x

"""
    struct PointerType <: AbstractPointerType
Hold a pointer to a `clang::PointerType` object.
"""
struct PointerType <: AbstractPointerType
    ptr::CXPointerType
end

Base.unsafe_convert(::Type{CXPointerType}, x::PointerType) = x.ptr
Base.cconvert(::Type{CXPointerType}, x::PointerType) = x

"""
    struct ReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::ReferenceType` object.
"""
struct ReferenceType <: AbstractReferenceType
    ptr::CXReferenceType
end

Base.unsafe_convert(::Type{CXReferenceType}, x::ReferenceType) = x.ptr
Base.cconvert(::Type{CXReferenceType}, x::ReferenceType) = x

"""
    struct LValueReferenceType <: AbstractLValueReferenceType
Hold a pointer to a `clang::LValueReferenceType` object.
"""
struct LValueReferenceType <: AbstractLValueReferenceType
    ptr::CXLValueReferenceType
end

Base.unsafe_convert(::Type{CXLValueReferenceType}, x::LValueReferenceType) = x.ptr
Base.cconvert(::Type{CXLValueReferenceType}, x::LValueReferenceType) = x

"""
    struct RValueReferenceType <: AbstractRValueReferenceType
Hold a pointer to a `clang::RValueReferenceType` object.
"""
struct RValueReferenceType <: AbstractRValueReferenceType
    ptr::CXRValueReferenceType
end

Base.unsafe_convert(::Type{CXRValueReferenceType}, x::RValueReferenceType) = x.ptr
Base.cconvert(::Type{CXRValueReferenceType}, x::RValueReferenceType) = x

"""
    struct MemberPointerType <: AbstractMemberPointerType
Hold a pointer to a `clang::MemberPointerType` object.
"""
struct MemberPointerType <: AbstractMemberPointerType
    ptr::CXMemberPointerType
end

Base.unsafe_convert(::Type{CXMemberPointerType}, x::MemberPointerType) = x.ptr
Base.cconvert(::Type{CXMemberPointerType}, x::MemberPointerType) = x

"""
    struct ArrayType <: AbstractArrayType
Hold a pointer to a `clang::ArrayType` object.
"""
struct ArrayType <: AbstractArrayType
    ptr::CXArrayType
end

Base.unsafe_convert(::Type{CXArrayType}, x::ArrayType) = x.ptr
Base.cconvert(::Type{CXArrayType}, x::ArrayType) = x

"""
    struct ConstantArrayType <: AbstractConstantArrayType
Hold a pointer to a `clang::ConstantArrayType` object.
"""
struct ConstantArrayType <: AbstractConstantArrayType
    ptr::CXConstantArrayType
end

Base.unsafe_convert(::Type{CXConstantArrayType}, x::ConstantArrayType) = x.ptr
Base.cconvert(::Type{CXConstantArrayType}, x::ConstantArrayType) = x

"""
    struct IncompleteArrayType <: AbstractIncompleteArrayType
Hold a pointer to a `clang::IncompleteArrayType` object.
"""
struct IncompleteArrayType <: AbstractIncompleteArrayType
    ptr::CXIncompleteArrayType
end

Base.unsafe_convert(::Type{CXIncompleteArrayType}, x::IncompleteArrayType) = x.ptr
Base.cconvert(::Type{CXIncompleteArrayType}, x::IncompleteArrayType) = x

"""
    struct VariableArrayType <: AbstractVariableArrayType
Hold a pointer to a `clang::VariableArrayType` object.
"""
struct VariableArrayType <: AbstractVariableArrayType
    ptr::CXVariableArrayType
end

Base.unsafe_convert(::Type{CXVariableArrayType}, x::VariableArrayType) = x.ptr
Base.cconvert(::Type{CXVariableArrayType}, x::VariableArrayType) = x

"""
    struct DependentSizedArrayType <: AbstractDependentSizedArrayType
Hold a pointer to a `clang::DependentSizedArrayType` object.
"""
struct DependentSizedArrayType <: AbstractDependentSizedArrayType
    ptr::CXDependentSizedArrayType
end

Base.unsafe_convert(::Type{CXDependentSizedArrayType}, x::DependentSizedArrayType) = x.ptr
Base.cconvert(::Type{CXDependentSizedArrayType}, x::DependentSizedArrayType) = x

"""
    struct FunctionType <: AbstractFunctionType
Hold a pointer to a `clang::FunctionType` object.
"""
struct FunctionType <: AbstractFunctionType
    ptr::CXFunctionType
end

Base.unsafe_convert(::Type{CXFunctionType}, x::FunctionType) = x.ptr
Base.cconvert(::Type{CXFunctionType}, x::FunctionType) = x

"""
    struct FunctionNoProtoType <: AbstractFunctionNoProtoType
Hold a pointer to a `clang::FunctionNoProtoType` object.
"""
struct FunctionNoProtoType <: AbstractFunctionNoProtoType
    ptr::CXFunctionNoProtoType
end

Base.unsafe_convert(::Type{CXFunctionNoProtoType}, x::FunctionNoProtoType) = x.ptr
Base.cconvert(::Type{CXFunctionNoProtoType}, x::FunctionNoProtoType) = x

"""
    struct FunctionProtoType <: AbstractFunctionProtoType
Hold a pointer to a `clang::FunctionProtoType` object.
"""
struct FunctionProtoType <: AbstractFunctionProtoType
    ptr::CXFunctionProtoType
end

Base.unsafe_convert(::Type{CXFunctionProtoType}, x::FunctionProtoType) = x.ptr
Base.cconvert(::Type{CXFunctionProtoType}, x::FunctionProtoType) = x

"""
    struct UnresolvedUsingType <: AbstractUnresolvedUsingType
Hold a pointer to a `clang::UnresolvedUsingType` object.
"""
struct UnresolvedUsingType <: AbstractUnresolvedUsingType
    ptr::CXUnresolvedUsingType
end

Base.unsafe_convert(::Type{CXUnresolvedUsingType}, x::UnresolvedUsingType) = x.ptr
Base.cconvert(::Type{CXUnresolvedUsingType}, x::UnresolvedUsingType) = x

"""
    struct UsingType <: AbstractUsingType
Hold a pointer to a `clang::UsingType` object.
"""
struct UsingType <: AbstractUsingType
    ptr::CXUsingType
end

Base.unsafe_convert(::Type{CXUsingType}, x::UsingType) = x.ptr
Base.cconvert(::Type{CXUsingType}, x::UsingType) = x

"""
    struct TypedefType <: AbstractTypedefType
Hold a pointer to a `clang::TypedefType` object.
"""
struct TypedefType <: AbstractTypedefType
    ptr::CXTypedefType
end

Base.unsafe_convert(::Type{CXTypedefType}, x::TypedefType) = x.ptr
Base.cconvert(::Type{CXTypedefType}, x::TypedefType) = x

"""
    struct TagType <: AbstractTagType
Hold a pointer to a `clang::TagType` object.
"""
struct TagType <: AbstractTagType
    ptr::CXTagType
end

Base.unsafe_convert(::Type{CXTagType}, x::TagType) = x.ptr
Base.cconvert(::Type{CXTagType}, x::TagType) = x

"""
    struct RecordType <: AbstractRecordType
Hold a pointer to a `clang::RecordType` object.
"""
struct RecordType <: AbstractRecordType
    ptr::CXRecordType
end

Base.unsafe_convert(::Type{CXRecordType}, x::RecordType) = x.ptr
Base.cconvert(::Type{CXRecordType}, x::RecordType) = x

"""
    struct EnumType <: AbstractEnumType
Hold a pointer to a `clang::EnumType` object.
"""
struct EnumType <: AbstractEnumType
    ptr::CXEnumType
end

Base.unsafe_convert(::Type{CXEnumType}, x::EnumType) = x.ptr
Base.cconvert(::Type{CXEnumType}, x::EnumType) = x

"""
    struct TemplateTypeParmType <: AbstractTemplateTypeParmType
Hold a pointer to a `clang::TemplateTypeParmType` object.
"""
struct TemplateTypeParmType <: AbstractTemplateTypeParmType
    ptr::CXTemplateTypeParmType
end

Base.unsafe_convert(::Type{CXTemplateTypeParmType}, x::TemplateTypeParmType) = x.ptr
Base.cconvert(::Type{CXTemplateTypeParmType}, x::TemplateTypeParmType) = x

"""
    struct SubstTemplateTypeParmType <: AbstractSubstTemplateTypeParmType
Hold a pointer to a `clang::SubstTemplateTypeParmType` object.
"""
struct SubstTemplateTypeParmType <: AbstractSubstTemplateTypeParmType
    ptr::CXSubstTemplateTypeParmType
end

Base.unsafe_convert(::Type{CXSubstTemplateTypeParmType}, x::SubstTemplateTypeParmType) = x.ptr
Base.cconvert(::Type{CXSubstTemplateTypeParmType}, x::SubstTemplateTypeParmType) = x

"""
    struct SubstTemplateTypeParmPackType <: AbstractSubstTemplateTypeParmPackType
Hold a pointer to a `clang::SubstTemplateTypeParmPackType` object.
"""
struct SubstTemplateTypeParmPackType <: AbstractSubstTemplateTypeParmPackType
    ptr::CXSubstTemplateTypeParmPackType
end

Base.unsafe_convert(::Type{CXSubstTemplateTypeParmPackType}, x::SubstTemplateTypeParmPackType) = x.ptr
Base.cconvert(::Type{CXSubstTemplateTypeParmPackType}, x::SubstTemplateTypeParmPackType) = x

"""
    struct TemplateSpecializationType <: AbstractTemplateSpecializationType
Hold a pointer to a `clang::TemplateSpecializationType` object.
"""
struct TemplateSpecializationType <: AbstractTemplateSpecializationType
    ptr::CXTemplateSpecializationType
end

Base.unsafe_convert(::Type{CXTemplateSpecializationType}, x::TemplateSpecializationType) = x.ptr
Base.cconvert(::Type{CXTemplateSpecializationType}, x::TemplateSpecializationType) = x

"""
    struct TypeWithKeyword <: AbstractTypeWithKeyword
Hold a pointer to a `clang::TypeWithKeyword` object.
"""
struct TypeWithKeyword <: AbstractTypeWithKeyword
    ptr::CXTypeWithKeyword
end

Base.unsafe_convert(::Type{CXTypeWithKeyword}, x::TypeWithKeyword) = x.ptr
Base.cconvert(::Type{CXTypeWithKeyword}, x::TypeWithKeyword) = x

"""
    struct ElaboratedType <: AbstractElaboratedType
Hold a pointer to a `clang::ElaboratedType` object.
"""
struct ElaboratedType <: AbstractElaboratedType
    ptr::CXElaboratedType
end

Base.unsafe_convert(::Type{CXElaboratedType}, x::ElaboratedType) = x.ptr
Base.cconvert(::Type{CXElaboratedType}, x::ElaboratedType) = x

"""
    struct DependentNameType <: AbstractDependentNameType
Hold a pointer to a `clang::DependentNameType` object.
"""
struct DependentNameType <: AbstractDependentNameType
    ptr::CXDependentNameType
end

Base.unsafe_convert(::Type{CXDependentNameType}, x::DependentNameType) = x.ptr
Base.cconvert(::Type{CXDependentNameType}, x::DependentNameType) = x

"""
    struct DependentTemplateSpecializationType <: AbstractDependentTemplateSpecializationType
Hold a pointer to a `clang::DependentTemplateSpecializationType` object.
"""
struct DependentTemplateSpecializationType <: AbstractDependentTemplateSpecializationType
    ptr::CXDependentTemplateSpecializationType
end

Base.unsafe_convert(::Type{CXDependentTemplateSpecializationType}, x::DependentTemplateSpecializationType) = x.ptr
Base.cconvert(::Type{CXDependentTemplateSpecializationType}, x::DependentTemplateSpecializationType) = x

"""
    struct AtomicType <: AbstractAtomicType
Hold a pointer to a `clang::AtomicType` object.
"""
struct AtomicType <: AbstractAtomicType
    ptr::CXAtomicType
end

Base.unsafe_convert(::Type{CXAtomicType}, x::AtomicType) = x.ptr
Base.cconvert(::Type{CXAtomicType}, x::AtomicType) = x

"""
    struct AdjustedType <: AbstractAdjustedType
Hold a pointer to a `clang::AdjustedType` object.
"""
struct AdjustedType <: AbstractAdjustedType
    ptr::CXAdjustedType
end

Base.unsafe_convert(::Type{CXAdjustedType}, x::AdjustedType) = x.ptr
Base.cconvert(::Type{CXAdjustedType}, x::AdjustedType) = x

"""
    struct DecayedType <: AbstractDecayedType
Hold a pointer to a `clang::DecayedType` object.
"""
struct DecayedType <: AbstractDecayedType
    ptr::CXDecayedType
end

Base.unsafe_convert(::Type{CXDecayedType}, x::DecayedType) = x.ptr
Base.cconvert(::Type{CXDecayedType}, x::DecayedType) = x

"""
    struct InjectedClassNameType <: AbstractInjectedClassNameType
Hold a pointer to a `clang::InjectedClassNameType` object.
"""
struct InjectedClassNameType <: AbstractInjectedClassNameType
    ptr::CXInjectedClassNameType
end

Base.unsafe_convert(::Type{CXInjectedClassNameType}, x::InjectedClassNameType) = x.ptr
Base.cconvert(::Type{CXInjectedClassNameType}, x::InjectedClassNameType) = x

"""
    struct MacroQualifiedType <: AbstractMacroQualifiedType
Hold a pointer to a `clang::MacroQualifiedType` object.
"""
struct MacroQualifiedType <: AbstractMacroQualifiedType
    ptr::CXMacroQualifiedType
end

Base.unsafe_convert(::Type{CXMacroQualifiedType}, x::MacroQualifiedType) = x.ptr
Base.cconvert(::Type{CXMacroQualifiedType}, x::MacroQualifiedType) = x

"""
    struct UnaryTransformType <: AbstractUnaryTransformType
Hold a pointer to a `clang::UnaryTransformType` object.
"""
struct UnaryTransformType <: AbstractUnaryTransformType
    ptr::CXUnaryTransformType
end

Base.unsafe_convert(::Type{CXUnaryTransformType}, x::UnaryTransformType) = x.ptr
Base.cconvert(::Type{CXUnaryTransformType}, x::UnaryTransformType) = x

"""
    struct ParenType <: AbstractParenType
Hold a pointer to a `clang::ParenType` object.
"""
struct ParenType <: AbstractParenType
    ptr::CXParenType
end

Base.unsafe_convert(::Type{CXParenType}, x::ParenType) = x.ptr
Base.cconvert(::Type{CXParenType}, x::ParenType) = x

"""
    struct DependentAddressSpaceType <: AbstractDependentAddressSpaceType
Hold a pointer to a `clang::DependentAddressSpaceType` object.
"""
struct DependentAddressSpaceType <: AbstractDependentAddressSpaceType
    ptr::CXDependentAddressSpaceType
end

Base.unsafe_convert(::Type{CXDependentAddressSpaceType}, x::DependentAddressSpaceType) = x.ptr
Base.cconvert(::Type{CXDependentAddressSpaceType}, x::DependentAddressSpaceType) = x

"""
    struct DependentSizedExtVectorType <: AbstractDependentSizedExtVectorType
Hold a pointer to a `clang::DependentSizedExtVectorType` object.
"""
struct DependentSizedExtVectorType <: AbstractDependentSizedExtVectorType
    ptr::CXDependentSizedExtVectorType
end

Base.unsafe_convert(::Type{CXDependentSizedExtVectorType}, x::DependentSizedExtVectorType) = x.ptr
Base.cconvert(::Type{CXDependentSizedExtVectorType}, x::DependentSizedExtVectorType) = x

"""
    struct DecltypeType <: AbstractDecltypeType
Hold a pointer to a `clang::DecltypeType` object.
"""
struct DecltypeType <: AbstractDecltypeType
    ptr::CXDecltypeType
end

Base.unsafe_convert(::Type{CXDecltypeType}, x::DecltypeType) = x.ptr
Base.cconvert(::Type{CXDecltypeType}, x::DecltypeType) = x

"""
    struct DeducedType <: AbstractDeducedType
Hold a pointer to a `clang::DeducedType` object.
"""
struct DeducedType <: AbstractDeducedType
    ptr::CXDeducedType
end

Base.unsafe_convert(::Type{CXDeducedType}, x::DeducedType) = x.ptr
Base.cconvert(::Type{CXDeducedType}, x::DeducedType) = x

"""
    struct DeducedTemplateSpecializationType <: AbstractDeducedTemplateSpecializationType
Hold a pointer to a `clang::DeducedTemplateSpecializationType` object.
"""
struct DeducedTemplateSpecializationType <: AbstractDeducedTemplateSpecializationType
    ptr::CXDeducedTemplateSpecializationType
end

Base.unsafe_convert(::Type{CXDeducedTemplateSpecializationType}, x::DeducedTemplateSpecializationType) = x.ptr
Base.cconvert(::Type{CXDeducedTemplateSpecializationType}, x::DeducedTemplateSpecializationType) = x

"""
    QualType <: AbstractQualType
Represent a qualified type.

Note that, the underlying pointer is NOT a *pointer* to a `clang::QualType` object. Instead,
it's the opaque pointer representation of the `clang::QualType` itself.
"""
struct QualType <: AbstractQualType
    ptr::CXQualType
end

Base.unsafe_convert(::Type{CXQualType}, x::QualType) = x.ptr
Base.cconvert(::Type{CXQualType}, x::QualType) = x

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
    Type_ <: AbstractType
A builtin `clang::Type`.
"""
struct Type_ <: AbstractType_
    ptr::CXType_
end

Base.unsafe_convert(::Type{CXQualType}, x::Type_) = x.ptr
Base.cconvert(::Type{CXQualType}, x::Type_) = x

"""
    BuiltinType <: AbstractBuiltinType
A builtin `QualType`.
"""
struct BuiltinType <: AbstractBuiltinType
    ptr::CXType_
end

BuiltinType(x::QualType) = BuiltinType(get_type_ptr(x))

Base.unsafe_convert(::Type{CXType_}, x::T) where {T<:AbstractBuiltinType} = x.ptr
Base.cconvert(::Type{CXType_}, x::T) where {T<:AbstractBuiltinType} = x

struct VoidTy <: AbstractVoidTy
    ptr::CXType_
end

VoidTy(x::QualType) = VoidTy(get_type_ptr(x))

struct BoolTy <: AbstractBoolTy
    ptr::CXType_
end

BoolTy(x::QualType) = BoolTy(get_type_ptr(x))

struct CharTy <: AbstractCharTy
    ptr::CXType_
end

CharTy(x::QualType) = CharTy(get_type_ptr(x))

# [C++ 3.9.1p5].
struct WCharTy <: AbstractWCharTy
    ptr::CXType_
end

WCharTy(x::QualType) = WCharTy(get_type_ptr(x))

# Same as WCharTy in C++, integer type in C99.
struct WideCharTy <: AbstractWideCharTy
    ptr::CXType_
end

WideCharTy(x::QualType) = WideCharTy(get_type_ptr(x))

# [C99 7.24.1], integer type unchanged by default promotions.
struct WIntTy <: AbstractWIntTy
    ptr::CXType_
end

WIntTy(x::QualType) = WIntTy(get_type_ptr(x))

# [C++20 proposal]
struct Char8Ty <: AbstractChar8Ty
    ptr::CXType_
end

Char8Ty(x::QualType) = Char8Ty(get_type_ptr(x))

# [C++0x 3.9.1p5], integer type in C99.
struct Char16Ty <: AbstractChar16Ty
    ptr::CXType_
end

Char16Ty(x::QualType) = Char16Ty(get_type_ptr(x))

# [C++0x 3.9.1p5], integer type in C99.
struct Char32Ty <: AbstractChar32Ty
    ptr::CXType_
end

Char32Ty(x::QualType) = Char32Ty(get_type_ptr(x))

struct SignedCharTy <: AbstractSignedCharTy
    ptr::CXType_
end

SignedCharTy(x::QualType) = SignedCharTy(get_type_ptr(x))

struct ShortTy <: AbstractShortTy
    ptr::CXType_
end

ShortTy(x::QualType) = ShortTy(get_type_ptr(x))

struct IntTy <: AbstractIntTy
    ptr::CXType_
end

IntTy(x::QualType) = IntTy(get_type_ptr(x))

struct LongTy <: AbstractLongTy
    ptr::CXType_
end

LongTy(x::QualType) = LongTy(get_type_ptr(x))

struct LongLongTy <: AbstractLongLongTy
    ptr::CXType_
end

LongLongTy(x::QualType) = LongLongTy(get_type_ptr(x))

struct Int128Ty <: AbstractInt128Ty
    ptr::CXType_
end

Int128Ty(x::QualType) = Int128Ty(get_type_ptr(x))

struct UnsignedCharTy <: AbstractUnsignedCharTy
    ptr::CXType_
end

UnsignedCharTy(x::QualType) = UnsignedCharTy(get_type_ptr(x))

struct UnsignedShortTy <: AbstractUnsignedShortTy
    ptr::CXType_
end

UnsignedShortTy(x::QualType) = UnsignedShortTy(get_type_ptr(x))

struct UnsignedIntTy <: AbstractUnsignedIntTy
    ptr::CXType_
end

UnsignedIntTy(x::QualType) = UnsignedIntTy(get_type_ptr(x))

struct UnsignedLongTy <: AbstractUnsignedLongTy
    ptr::CXType_
end

UnsignedLongTy(x::QualType) = UnsignedLongTy(get_type_ptr(x))

struct UnsignedLongLongTy <: AbstractUnsignedLongLongTy
    ptr::CXType_
end

UnsignedLongLongTy(x::QualType) = UnsignedLongLongTy(get_type_ptr(x))

struct UnsignedInt128Ty <: AbstractUnsignedInt128Ty
    ptr::CXType_
end

UnsignedInt128Ty(x::QualType) = UnsignedInt128Ty(get_type_ptr(x))

struct FloatTy <: AbstractFloatTy
    ptr::CXType_
end

FloatTy(x::QualType) = FloatTy(get_type_ptr(x))

struct DoubleTy <: AbstractDoubleTy
    ptr::CXType_
end

DoubleTy(x::QualType) = DoubleTy(get_type_ptr(x))

struct LongDoubleTy <: AbstractLongDoubleTy
    ptr::CXType_
end

LongDoubleTy(x::QualType) = LongDoubleTy(get_type_ptr(x))

struct Float128Ty <: AbstractFloat128Ty
    ptr::CXType_
end

Float128Ty(x::QualType) = Float128Ty(get_type_ptr(x))

# [OpenCL 6.1.1.1], ARM NEON
struct HalfTy <: AbstractHalfTy
    ptr::CXType_
end

HalfTy(x::QualType) = HalfTy(get_type_ptr(x))

struct BFloat16Ty <: AbstractBFloat16Ty
    ptr::CXType_
end

BFloat16Ty(x::QualType) = BFloat16Ty(get_type_ptr(x))

# C11 extension ISO/IEC TS 18661-3
struct Float16Ty <: AbstractFloat16Ty
    ptr::CXType_
end

Float16Ty(x::QualType) = Float16Ty(get_type_ptr(x))

struct FloatComplexTy <: AbstractFloatComplexTy
    ptr::CXType_
end

FloatComplexTy(x::QualType) = FloatComplexTy(get_type_ptr(x))

struct DoubleComplexTy <: AbstractDoubleComplexTy
    ptr::CXType_
end

DoubleComplexTy(x::QualType) = DoubleComplexTy(get_type_ptr(x))

struct LongDoubleComplexTy <: AbstractLongDoubleComplexTy
    ptr::CXType_
end

LongDoubleComplexTy(x::QualType) = LongDoubleComplexTy(get_type_ptr(x))

struct Float128ComplexTy <: AbstractFloat128ComplexTy
    ptr::CXType_
end

Float128ComplexTy(x::QualType) = Float128ComplexTy(get_type_ptr(x))

struct VoidPtrTy <: AbstractVoidPtrTy
    ptr::CXType_
end

VoidPtrTy(x::QualType) = VoidPtrTy(get_type_ptr(x))

struct NullPtrTy <: AbstractNullPtrTy
    ptr::CXType_
end

NullPtrTy(x::QualType) = NullPtrTy(get_type_ptr(x))

"""
    struct TypeSourceInfo <: AbstractTypeSourceInfo
Hold a pointer to a `clang::TypeSourceInfo` object.
"""
struct TypeSourceInfo <: AbstractTypeSourceInfo
    ptr::CXTypeSourceInfo
end

Base.unsafe_convert(::Type{CXTypeSourceInfo}, x::TypeSourceInfo) = x.ptr
Base.cconvert(::Type{CXTypeSourceInfo}, x::TypeSourceInfo) = x
