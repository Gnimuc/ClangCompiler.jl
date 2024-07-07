for sym in [:ComplexType,
            :PointerType,
            :ReferenceType,
            :LValueReferenceType,
            :RValueReferenceType,
            :MemberPointerType,
            :ArrayType,
            :ConstantArrayType,
            :IncompleteArrayType,
            :VariableArrayType,
            :DependentSizedArrayType,
            :FunctionType,
            :FunctionNoProtoType,
            :FunctionProtoType,
            :TypedefType,
            :TagType,
            :RecordType,
            :EnumType,
            :TemplateTypeParmType,
            :SubstTemplateTypeParmType,
            :SubstTemplateTypeParmPackType,
            :TemplateSpecializationType,
            :TypeWithKeyword,
            :ElaboratedType,
            :DependentNameType,
            :DependentTemplateSpecializationType]
    asym = Symbol("Abstract", sym)
    cxsym = Symbol("CX", sym)

    @eval begin
        struct $sym <: $asym
            ptr::$cxsym
        end

        Base.unsafe_convert(::Type{$cxsym}, x::$sym) = x.ptr
        Base.cconvert(::Type{$cxsym}, x::$sym) = x
    end
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
struct Type_ <: AbstractType
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

#! format: off
for sym in [:VoidTy,
            :BoolTy,
            :CharTy,
            :WCharTy,    # [C++ 3.9.1p5].
            :WideCharTy, # Same as WCharTy in C++, integer type in C99.
            :WIntTy,     # [C99 7.24.1], integer type unchanged by default promotions.
            :Char8Ty,    # [C++20 proposal]
            :Char16Ty,   # [C++0x 3.9.1p5], integer type in C99.
            :Char32Ty,   # [C++0x 3.9.1p5], integer type in C99.
            :SignedCharTy,
            :ShortTy,
            :IntTy,
            :LongTy,
            :LongLongTy,
            :Int128Ty,
            :UnsignedCharTy,
            :UnsignedShortTy,
            :UnsignedIntTy,
            :UnsignedLongTy,
            :UnsignedLongLongTy,
            :UnsignedInt128Ty,
            :FloatTy,
            :DoubleTy,
            :LongDoubleTy,
            :Float128Ty,
            :HalfTy,     # [OpenCL 6.1.1.1], ARM NEON
            :BFloat16Ty,
            :Float16Ty,  # C11 extension ISO/IEC TS 18661-3
            :FloatComplexTy,
            :DoubleComplexTy,
            :LongDoubleComplexTy,
            :Float128ComplexTy,
            :VoidPtrTy,
            :NullPtrTy]
    @eval begin
        struct $sym <: AbstractBuiltinType
            ptr::CXType_
        end

        $sym(x::QualType) = $sym(get_type_ptr(x))
    end
end
#! format: on

"""
    struct TypeSourceInfo
Hold a pointer to a `clang::TypeSourceInfo` object.
"""
struct TypeSourceInfo
    ptr::CXTypeSourceInfo
end

Base.unsafe_convert(::Type{CXTypeSourceInfo}, x::TypeSourceInfo) = x.ptr
Base.cconvert(::Type{CXTypeSourceInfo}, x::TypeSourceInfo) = x
