"""
    struct ComplexType <: AbstractComplexType
Hold a pointer to a `clang::ComplexType` object.
"""
struct ComplexType <: AbstractComplexType
    ptr::CXComplexType
end

"""
    struct PointerType <: AbstractPointerType
Hold a pointer to a `clang::PointerType` object.
"""
struct PointerType <: AbstractPointerType
    ptr::CXPointerType
end

"""
    struct ReferenceType <: AbstractReferenceType
Hold a pointer to a `clang::ReferenceType` object.
"""
struct ReferenceType <: AbstractReferenceType
    ptr::CXReferenceType
end

"""
    struct LValueReferenceType <: AbstractLValueReferenceType
Hold a pointer to a `clang::LValueReferenceType` object.
"""
struct LValueReferenceType <: AbstractLValueReferenceType
    ptr::CXLValueReferenceType
end

"""
    struct RValueReferenceType <: AbstractRValueReferenceType
Hold a pointer to a `clang::RValueReferenceType` object.
"""
struct RValueReferenceType <: AbstractRValueReferenceType
    ptr::CXRValueReferenceType
end

"""
    struct MemberPointerType <: AbstractMemberPointerType
Hold a pointer to a `clang::MemberPointerType` object.
"""
struct MemberPointerType <: AbstractMemberPointerType
    ptr::CXMemberPointerType
end

"""
    struct ArrayType <: AbstractArrayType
Hold a pointer to a `clang::ArrayType` object.
"""
struct ArrayType <: AbstractArrayType
    ptr::CXArrayType
end

"""
    struct ConstantArrayType <: AbstractConstantArrayType
Hold a pointer to a `clang::ConstantArrayType` object.
"""
struct ConstantArrayType <: AbstractConstantArrayType
    ptr::CXConstantArrayType
end

"""
    struct IncompleteArrayType <: AbstractIncompleteArrayType
Hold a pointer to a `clang::IncompleteArrayType` object.
"""
struct IncompleteArrayType <: AbstractIncompleteArrayType
    ptr::CXIncompleteArrayType
end

"""
    struct VariableArrayType <: AbstractVariableArrayType
Hold a pointer to a `clang::VariableArrayType` object.
"""
struct VariableArrayType <: AbstractVariableArrayType
    ptr::CXVariableArrayType
end

"""
    struct DependentSizedArrayType <: AbstractDependentSizedArrayType
Hold a pointer to a `clang::DependentSizedArrayType` object.
"""
struct DependentSizedArrayType <: AbstractDependentSizedArrayType
    ptr::CXDependentSizedArrayType
end

"""
    struct FunctionType <: AbstractFunctionType
Hold a pointer to a `clang::FunctionType` object.
"""
struct FunctionType <: AbstractFunctionType
    ptr::CXFunctionType
end

"""
    struct FunctionNoProtoType <: AbstractFunctionNoProtoType
Hold a pointer to a `clang::FunctionNoProtoType` object.
"""
struct FunctionNoProtoType <: AbstractFunctionNoProtoType
    ptr::CXFunctionNoProtoType
end

"""
    struct FunctionProtoType <: AbstractFunctionProtoType
Hold a pointer to a `clang::FunctionProtoType` object.
"""
struct FunctionProtoType <: AbstractFunctionProtoType
    ptr::CXFunctionProtoType
end

"""
    struct UnresolvedUsingType <: AbstractUnresolvedUsingType
Hold a pointer to a `clang::UnresolvedUsingType` object.
"""
struct UnresolvedUsingType <: AbstractUnresolvedUsingType
    ptr::CXUnresolvedUsingType
end

"""
    struct UsingType <: AbstractUsingType
Hold a pointer to a `clang::UsingType` object.
"""
struct UsingType <: AbstractUsingType
    ptr::CXUsingType
end

"""
    struct TypedefType <: AbstractTypedefType
Hold a pointer to a `clang::TypedefType` object.
"""
struct TypedefType <: AbstractTypedefType
    ptr::CXTypedefType
end

"""
    struct TagType <: AbstractTagType
Hold a pointer to a `clang::TagType` object.
"""
struct TagType <: AbstractTagType
    ptr::CXTagType
end

"""
    struct RecordType <: AbstractRecordType
Hold a pointer to a `clang::RecordType` object.
"""
struct RecordType <: AbstractRecordType
    ptr::CXRecordType
end

"""
    struct EnumType <: AbstractEnumType
Hold a pointer to a `clang::EnumType` object.
"""
struct EnumType <: AbstractEnumType
    ptr::CXEnumType
end

"""
    struct TemplateTypeParmType <: AbstractTemplateTypeParmType
Hold a pointer to a `clang::TemplateTypeParmType` object.
"""
struct TemplateTypeParmType <: AbstractTemplateTypeParmType
    ptr::CXTemplateTypeParmType
end

"""
    struct SubstTemplateTypeParmType <: AbstractSubstTemplateTypeParmType
Hold a pointer to a `clang::SubstTemplateTypeParmType` object.
"""
struct SubstTemplateTypeParmType <: AbstractSubstTemplateTypeParmType
    ptr::CXSubstTemplateTypeParmType
end

"""
    struct SubstTemplateTypeParmPackType <: AbstractSubstTemplateTypeParmPackType
Hold a pointer to a `clang::SubstTemplateTypeParmPackType` object.
"""
struct SubstTemplateTypeParmPackType <: AbstractSubstTemplateTypeParmPackType
    ptr::CXSubstTemplateTypeParmPackType
end

"""
    struct TemplateSpecializationType <: AbstractTemplateSpecializationType
Hold a pointer to a `clang::TemplateSpecializationType` object.
"""
struct TemplateSpecializationType <: AbstractTemplateSpecializationType
    ptr::CXTemplateSpecializationType
end

"""
    struct TypeWithKeyword <: AbstractTypeWithKeyword
Hold a pointer to a `clang::TypeWithKeyword` object.
"""
struct TypeWithKeyword <: AbstractTypeWithKeyword
    ptr::CXTypeWithKeyword
end

"""
    struct ElaboratedType <: AbstractElaboratedType
Hold a pointer to a `clang::ElaboratedType` object.
"""
struct ElaboratedType <: AbstractElaboratedType
    ptr::CXElaboratedType
end

"""
    struct DependentNameType <: AbstractDependentNameType
Hold a pointer to a `clang::DependentNameType` object.
"""
struct DependentNameType <: AbstractDependentNameType
    ptr::CXDependentNameType
end

"""
    struct DependentTemplateSpecializationType <: AbstractDependentTemplateSpecializationType
Hold a pointer to a `clang::DependentTemplateSpecializationType` object.
"""
struct DependentTemplateSpecializationType <: AbstractDependentTemplateSpecializationType
    ptr::CXDependentTemplateSpecializationType
end

"""
    struct AtomicType <: AbstractAtomicType
Hold a pointer to a `clang::AtomicType` object.
"""
struct AtomicType <: AbstractAtomicType
    ptr::CXAtomicType
end

"""
    struct AdjustedType <: AbstractAdjustedType
Hold a pointer to a `clang::AdjustedType` object.
"""
struct AdjustedType <: AbstractAdjustedType
    ptr::CXAdjustedType
end

"""
    struct DecayedType <: AbstractDecayedType
Hold a pointer to a `clang::DecayedType` object.
"""
struct DecayedType <: AbstractDecayedType
    ptr::CXDecayedType
end

"""
    struct InjectedClassNameType <: AbstractInjectedClassNameType
Hold a pointer to a `clang::InjectedClassNameType` object.
"""
struct InjectedClassNameType <: AbstractInjectedClassNameType
    ptr::CXInjectedClassNameType
end

"""
    struct MacroQualifiedType <: AbstractMacroQualifiedType
Hold a pointer to a `clang::MacroQualifiedType` object.
"""
struct MacroQualifiedType <: AbstractMacroQualifiedType
    ptr::CXMacroQualifiedType
end

"""
    struct UnaryTransformType <: AbstractUnaryTransformType
Hold a pointer to a `clang::UnaryTransformType` object.
"""
struct UnaryTransformType <: AbstractUnaryTransformType
    ptr::CXUnaryTransformType
end

"""
    struct ParenType <: AbstractParenType
Hold a pointer to a `clang::ParenType` object.
"""
struct ParenType <: AbstractParenType
    ptr::CXParenType
end

"""
    struct DependentAddressSpaceType <: AbstractDependentAddressSpaceType
Hold a pointer to a `clang::DependentAddressSpaceType` object.
"""
struct DependentAddressSpaceType <: AbstractDependentAddressSpaceType
    ptr::CXDependentAddressSpaceType
end

"""
    struct DependentSizedExtVectorType <: AbstractDependentSizedExtVectorType
Hold a pointer to a `clang::DependentSizedExtVectorType` object.
"""
struct DependentSizedExtVectorType <: AbstractDependentSizedExtVectorType
    ptr::CXDependentSizedExtVectorType
end

"""
    struct DecltypeType <: AbstractDecltypeType
Hold a pointer to a `clang::DecltypeType` object.
"""
struct DecltypeType <: AbstractDecltypeType
    ptr::CXDecltypeType
end

"""
    struct DeducedType <: AbstractDeducedType
Hold a pointer to a `clang::DeducedType` object.
"""
struct DeducedType <: AbstractDeducedType
    ptr::CXDeducedType
end

"""
    struct DeducedTemplateSpecializationType <: AbstractDeducedTemplateSpecializationType
Hold a pointer to a `clang::DeducedTemplateSpecializationType` object.
"""
struct DeducedTemplateSpecializationType <: AbstractDeducedTemplateSpecializationType
    ptr::CXDeducedTemplateSpecializationType
end

"""
    QualType <: AbstractQualType
Represent a qualified type.

Note that, the underlying pointer is NOT a *pointer* to a `clang::QualType` object. Instead,
it's the opaque pointer representation of the `clang::QualType` itself.
"""
struct QualType <: AbstractQualType
    ptr::CXQualType
end

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

"""
    BuiltinType <: AbstractBuiltinType
A builtin `QualType`.
"""
struct BuiltinType <: AbstractBuiltinType
    ptr::CXType_
end

BuiltinType(x::QualType) = BuiltinType(get_type_ptr(x).ptr)

struct VoidTy <: AbstractVoidTy
    ptr::CXType_
end

VoidTy(x::QualType) = VoidTy(get_type_ptr(x).ptr)

struct BoolTy <: AbstractBoolTy
    ptr::CXType_
end

BoolTy(x::QualType) = BoolTy(get_type_ptr(x).ptr)

struct CharTy <: AbstractCharTy
    ptr::CXType_
end

CharTy(x::QualType) = CharTy(get_type_ptr(x).ptr)

# [C++ 3.9.1p5].
struct WCharTy <: AbstractWCharTy
    ptr::CXType_
end

WCharTy(x::QualType) = WCharTy(get_type_ptr(x).ptr)

# Same as WCharTy in C++, integer type in C99.
struct WideCharTy <: AbstractWideCharTy
    ptr::CXType_
end

WideCharTy(x::QualType) = WideCharTy(get_type_ptr(x).ptr)

# [C99 7.24.1], integer type unchanged by default promotions.
struct WIntTy <: AbstractWIntTy
    ptr::CXType_
end

WIntTy(x::QualType) = WIntTy(get_type_ptr(x).ptr)

# [C++20 proposal]
struct Char8Ty <: AbstractChar8Ty
    ptr::CXType_
end

Char8Ty(x::QualType) = Char8Ty(get_type_ptr(x).ptr)

# [C++0x 3.9.1p5], integer type in C99.
struct Char16Ty <: AbstractChar16Ty
    ptr::CXType_
end

Char16Ty(x::QualType) = Char16Ty(get_type_ptr(x).ptr)

# [C++0x 3.9.1p5], integer type in C99.
struct Char32Ty <: AbstractChar32Ty
    ptr::CXType_
end

Char32Ty(x::QualType) = Char32Ty(get_type_ptr(x).ptr)

struct SignedCharTy <: AbstractSignedCharTy
    ptr::CXType_
end

SignedCharTy(x::QualType) = SignedCharTy(get_type_ptr(x).ptr)

struct ShortTy <: AbstractShortTy
    ptr::CXType_
end

ShortTy(x::QualType) = ShortTy(get_type_ptr(x).ptr)

struct IntTy <: AbstractIntTy
    ptr::CXType_
end

IntTy(x::QualType) = IntTy(get_type_ptr(x).ptr)

struct LongTy <: AbstractLongTy
    ptr::CXType_
end

LongTy(x::QualType) = LongTy(get_type_ptr(x).ptr)

struct LongLongTy <: AbstractLongLongTy
    ptr::CXType_
end

LongLongTy(x::QualType) = LongLongTy(get_type_ptr(x).ptr)

struct Int128Ty <: AbstractInt128Ty
    ptr::CXType_
end

Int128Ty(x::QualType) = Int128Ty(get_type_ptr(x).ptr)

struct UnsignedCharTy <: AbstractUnsignedCharTy
    ptr::CXType_
end

UnsignedCharTy(x::QualType) = UnsignedCharTy(get_type_ptr(x).ptr)

struct UnsignedShortTy <: AbstractUnsignedShortTy
    ptr::CXType_
end

UnsignedShortTy(x::QualType) = UnsignedShortTy(get_type_ptr(x).ptr)

struct UnsignedIntTy <: AbstractUnsignedIntTy
    ptr::CXType_
end

UnsignedIntTy(x::QualType) = UnsignedIntTy(get_type_ptr(x).ptr)

struct UnsignedLongTy <: AbstractUnsignedLongTy
    ptr::CXType_
end

UnsignedLongTy(x::QualType) = UnsignedLongTy(get_type_ptr(x).ptr)

struct UnsignedLongLongTy <: AbstractUnsignedLongLongTy
    ptr::CXType_
end

UnsignedLongLongTy(x::QualType) = UnsignedLongLongTy(get_type_ptr(x).ptr)

struct UnsignedInt128Ty <: AbstractUnsignedInt128Ty
    ptr::CXType_
end

UnsignedInt128Ty(x::QualType) = UnsignedInt128Ty(get_type_ptr(x).ptr)

struct FloatTy <: AbstractFloatTy
    ptr::CXType_
end

FloatTy(x::QualType) = FloatTy(get_type_ptr(x).ptr)

struct DoubleTy <: AbstractDoubleTy
    ptr::CXType_
end

DoubleTy(x::QualType) = DoubleTy(get_type_ptr(x).ptr)

struct LongDoubleTy <: AbstractLongDoubleTy
    ptr::CXType_
end

LongDoubleTy(x::QualType) = LongDoubleTy(get_type_ptr(x).ptr)

struct Float128Ty <: AbstractFloat128Ty
    ptr::CXType_
end

Float128Ty(x::QualType) = Float128Ty(get_type_ptr(x).ptr)

# [OpenCL 6.1.1.1], ARM NEON
struct HalfTy <: AbstractHalfTy
    ptr::CXType_
end

HalfTy(x::QualType) = HalfTy(get_type_ptr(x).ptr)

struct BFloat16Ty <: AbstractBFloat16Ty
    ptr::CXType_
end

BFloat16Ty(x::QualType) = BFloat16Ty(get_type_ptr(x).ptr)

# C11 extension ISO/IEC TS 18661-3
struct Float16Ty <: AbstractFloat16Ty
    ptr::CXType_
end

Float16Ty(x::QualType) = Float16Ty(get_type_ptr(x).ptr)

struct FloatComplexTy <: AbstractFloatComplexTy
    ptr::CXType_
end

FloatComplexTy(x::QualType) = FloatComplexTy(get_type_ptr(x).ptr)

struct DoubleComplexTy <: AbstractDoubleComplexTy
    ptr::CXType_
end

DoubleComplexTy(x::QualType) = DoubleComplexTy(get_type_ptr(x).ptr)

struct LongDoubleComplexTy <: AbstractLongDoubleComplexTy
    ptr::CXType_
end

LongDoubleComplexTy(x::QualType) = LongDoubleComplexTy(get_type_ptr(x).ptr)

struct Float128ComplexTy <: AbstractFloat128ComplexTy
    ptr::CXType_
end

Float128ComplexTy(x::QualType) = Float128ComplexTy(get_type_ptr(x).ptr)

struct VoidPtrTy <: AbstractVoidPtrTy
    ptr::CXType_
end

VoidPtrTy(x::QualType) = VoidPtrTy(get_type_ptr(x).ptr)

struct NullPtrTy <: AbstractNullPtrTy
    ptr::CXType_
end

NullPtrTy(x::QualType) = NullPtrTy(get_type_ptr(x).ptr)

"""
    struct TypeSourceInfo <: AbstractTypeSourceInfo
Hold a pointer to a `clang::TypeSourceInfo` object.
"""
struct TypeSourceInfo <: AbstractTypeSourceInfo
    ptr::CXTypeSourceInfo
end

"""
    struct VectorType <: AbstractVectorType
Hold a pointer to a `clang::VectorType` object.
"""
struct VectorType <: AbstractVectorType
    ptr::CXVectorType
end

"""
    struct AttributedType <: AbstractAttributedType
Hold a pointer to a `clang::AttributedType` object.
"""
struct AttributedType <: AbstractAttributedType
    ptr::CXAttributedType
end

"""
    struct PackExpansionType <: AbstractPackExpansionType
Hold a pointer to a `clang::PackExpansionType` object.
"""
struct PackExpansionType <: AbstractPackExpansionType
    ptr::CXPackExpansionType
end

"""
    struct AutoType <: AbstractAutoType
Hold a pointer to a `clang::AutoType` object.
"""
struct AutoType <: AbstractAutoType
    ptr::CXAutoType
end

"""
    struct TypeOfExprType <: AbstractTypeOfExprType
Hold a pointer to a `clang::TypeOfExprType` object.
"""
struct TypeOfExprType <: AbstractTypeOfExprType
    ptr::CXTypeOfExprType
end

"""
    struct TypeOfType <: AbstractTypeOfType
Hold a pointer to a `clang::TypeOfType` object.
"""
struct TypeOfType <: AbstractTypeOfType
    ptr::CXTypeOfType
end

"""
    struct BitIntType <: AbstractBitIntType
Hold a pointer to a `clang::BitIntType` object.
"""
struct BitIntType <: AbstractBitIntType
    ptr::CXBitIntType
end

"""
    struct BlockPointerType <: AbstractBlockPointerType
Hold a pointer to a `clang::BlockPointerType` object.
"""
struct BlockPointerType <: AbstractBlockPointerType
    ptr::CXBlockPointerType
end

"""
    struct DependentVectorType <: AbstractDependentVectorType
Hold a pointer to a `clang::DependentVectorType` object.
"""
struct DependentVectorType <: AbstractDependentVectorType
    ptr::CXDependentVectorType
end

"""
    struct MatrixType <: AbstractMatrixType
Hold a pointer to a `clang::MatrixType` object.
"""
struct MatrixType <: AbstractMatrixType
    ptr::CXMatrixType
end

"""
    struct ConstantMatrixType <: AbstractConstantMatrixType
Hold a pointer to a `clang::ConstantMatrixType` object.
"""
struct ConstantMatrixType <: AbstractConstantMatrixType
    ptr::CXConstantMatrixType
end

"""
    struct DependentSizedMatrixType <: AbstractDependentSizedMatrixType
Hold a pointer to a `clang::DependentSizedMatrixType` object.
"""
struct DependentSizedMatrixType <: AbstractDependentSizedMatrixType
    ptr::CXDependentSizedMatrixType
end

"""
    struct DependentBitIntType <: AbstractDependentBitIntType
Hold a pointer to a `clang::DependentBitIntType` object.
"""
struct DependentBitIntType <: AbstractDependentBitIntType
    ptr::CXDependentBitIntType
end

"""
    struct ExtVectorType <: AbstractExtVectorType
Hold a pointer to a `clang::ExtVectorType` object.
"""
struct ExtVectorType <: AbstractExtVectorType
    ptr::CXExtVectorType
end

"""
    struct ObjCObjectType <: AbstractObjCObjectType
Hold a pointer to a `clang::ObjCObjectType` object.
"""
struct ObjCObjectType <: AbstractObjCObjectType
    ptr::CXObjCObjectType
end

"""
    struct ObjCObjectPointerType <: AbstractObjCObjectPointerType
Hold a pointer to a `clang::ObjCObjectPointerType` object.
"""
struct ObjCObjectPointerType <: AbstractObjCObjectPointerType
    ptr::CXObjCObjectPointerType
end

"""
    struct PipeType <: AbstractPipeType
Hold a pointer to a `clang::PipeType` object.
"""
struct PipeType <: AbstractPipeType
    ptr::CXPipeType
end
