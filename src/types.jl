"""
    jlty_to_clty(::Type{T}, ctx::ASTContext) where {T}
Interface for mapping a Julia type to the corresponding Clang type representation.

See also, [`clty_to_jlty`](@ref). Note that, the mapping is not injective.
"""
jlty_to_clty(::Type{T}, ctx::ASTContext) where {T} = error("no mapping found for $T")

# builtin types
jlty_to_clty(::Type{Nothing}, ctx::ASTContext) = get_builtin_type(ctx, VoidTy)
jlty_to_clty(::Type{Bool}, ctx::ASTContext) = get_builtin_type(ctx, BoolTy)
jlty_to_clty(::Type{Int8}, ctx::ASTContext) = get_builtin_type(ctx, SignedCharTy)
jlty_to_clty(::Type{Int16}, ctx::ASTContext) = get_builtin_type(ctx, ShortTy)
jlty_to_clty(::Type{Int32}, ctx::ASTContext) = get_builtin_type(ctx, IntTy)
jlty_to_clty(::Type{Int64}, ctx::ASTContext) = get_builtin_type(ctx, LongLongTy)
jlty_to_clty(::Type{Int128}, ctx::ASTContext) = get_builtin_type(ctx, Int128Ty)
jlty_to_clty(::Type{UInt8}, ctx::ASTContext) = get_builtin_type(ctx, UnsignedCharTy)
jlty_to_clty(::Type{UInt16}, ctx::ASTContext) = get_builtin_type(ctx, UnsignedShortTy)
jlty_to_clty(::Type{UInt32}, ctx::ASTContext) = get_builtin_type(ctx, UnsignedIntTy)
jlty_to_clty(::Type{UInt64}, ctx::ASTContext) = get_builtin_type(ctx, UnsignedLongLongTy)
jlty_to_clty(::Type{UInt128}, ctx::ASTContext) = get_builtin_type(ctx, UnsignedInt128Ty)
jlty_to_clty(::Type{Float16}, ctx::ASTContext) = get_builtin_type(ctx, Float16Ty)
jlty_to_clty(::Type{Float32}, ctx::ASTContext) = get_builtin_type(ctx, FloatTy)
jlty_to_clty(::Type{Float64}, ctx::ASTContext) = get_builtin_type(ctx, DoubleTy)
jlty_to_clty(::Type{Ptr{Cvoid}}, ctx::ASTContext) = get_builtin_type(ctx, VoidPtrTy)

"""
    clty_to_jlty(::Type{T}) where {T}
Interface for mapping a Clang type to the corresponding Julia type representation.

See also, [`jlty_to_clty`](@ref). Note that, the mapping is not injective.
"""
clty_to_jlty(x::T) where {T<:AbstractClangType} = error("no mapping found for $T")

clty_to_jlty(x::AbstractType) = clty_to_jlty(resolve(x))

# builtin types
clty_to_jlty(x::T) where {T<:AbstractBuiltinType} = x

# Clang types
clty_to_jlty(x::BuiltinType) = clty_to_jlty(resolve(x))
clty_to_jlty(x::ElaboratedType) = x
clty_to_jlty(x::TypedefType) = x
clty_to_jlty(x::UsingType) = x
clty_to_jlty(x::PointerType) = x

# `TagType`s are resolved to `RecordType` or `EnumType`.
clty_to_jlty(x::TagType) = clty_to_jlty(resolve(x))
clty_to_jlty(x::RecordType) = x
clty_to_jlty(x::EnumType) = x

# `FunctionType`s are resolved to `FunctionProtoType` or `FunctionNoProtoType`.
clty_to_jlty(x::FunctionType) = clty_to_jlty(resolve(x))
clty_to_jlty(x::FunctionProtoType) = x
clty_to_jlty(x::FunctionNoProtoType) = x

# `ReferenceType`s are resolved to `LValueReferenceType` or `RValueReferenceType`.
clty_to_jlty(x::ReferenceType) = clty_to_jlty(resolve(x))
clty_to_jlty(x::LValueReferenceType) = x
clty_to_jlty(x::RValueReferenceType) = x

# `ArrayType`s are resolved to `ConstantArrayType`, `IncompleteArrayType`, `VariableArrayType`, or `DependentSizedArrayType`.
clty_to_jlty(x::ArrayType) = clty_to_jlty(resolve(x))
clty_to_jlty(x::ConstantArrayType) = x
clty_to_jlty(x::IncompleteArrayType) = x
clty_to_jlty(x::VariableArrayType) = x
clty_to_jlty(x::DependentSizedArrayType) = x

# templates
clty_to_jlty(x::TemplateTypeParmType) = x
clty_to_jlty(x::SubstTemplateTypeParmType) = x
clty_to_jlty(x::SubstTemplateTypeParmPackType) = x
clty_to_jlty(x::TemplateSpecializationType) = x
clty_to_jlty(x::DependentNameType) = x
clty_to_jlty(x::DependentTemplateSpecializationType) = x

# CXTypeClass value -> concrete Julia carrier type, built from the vendored
# TypeNodes.inc table (the same table the C CXTypeClass enum is stamped from), so
# resolving a type is one ccall (getTypeClass) + one lookup instead of the
# order-sensitive is_*_type predicate chain this replaced. Concrete classes
# whose carrier is not wrapped fall back to UnexposedType; getTypeClass returns a
# concrete class directly, so Tag/Function/Reference/Array resolve straight to
# their leaf (Record/Enum, Proto/NoProto, LValue/RValue, Constant/…) — the
# sub-resolves below stay for callers that hold an abstract carrier.
# The classes derive from TypeNodes.inc, so the map is generated from it into
# lib/<major>/TypeClassMap.jl (defines `TYPE_CLASS_TO_TYPE`).
include("TypeClassMap.jl")

"""
    resolve(ty::AbstractType)
Return `ty` rewrapped as the concrete Type reported by `getTypeClass` (Clang's
RTTI). Builtin types resolve to the `BuiltinType` carrier; a second `resolve`
refines those to the per-kind singletons. Falls back to `UnexposedType` for
classes without a wrapped carrier.
"""
function resolve(ty::AbstractType)
    T = get(TYPE_CLASS_TO_TYPE, getTypeClass(ty), nothing)
    return T === nothing ? resolve(UnexposedType(ty)) : T(ty.ptr)
end

resolve(x::UnexposedType) = x

function resolve(ty::AbstractBuiltinType)
    is_void_ty(ty) && return VoidTy(ty.ptr)
    is_bool_ty(ty) && return BoolTy(ty.ptr)
    is_char_ty(ty) && return CharTy(ty.ptr)
    is_wchar_ty(ty) && return WCharTy(ty.ptr)
    is_widechar_ty(ty) && return WideCharTy(ty.ptr)
    is_signed_char_ty(ty) && return SignedCharTy(ty.ptr)
    is_short_ty(ty) && return ShortTy(ty.ptr)
    is_int_ty(ty) && return IntTy(ty.ptr)
    is_long_ty(ty) && return LongTy(ty.ptr)
    is_longlong_ty(ty) && return LongLongTy(ty.ptr)
    is_int128_ty(ty) && return Int128Ty(ty.ptr)
    is_unsigned_char_ty(ty) && return UnsignedCharTy(ty.ptr)
    is_unsigned_short_ty(ty) && return UnsignedShortTy(ty.ptr)
    is_unsigned_int_ty(ty) && return UnsignedIntTy(ty.ptr)
    is_unsigned_long_ty(ty) && return UnsignedLongTy(ty.ptr)
    is_unsigned_longlong_ty(ty) && return UnsignedLongLongTy(ty.ptr)
    is_unsigned_int128_ty(ty) && return UnsignedInt128Ty(ty.ptr)
    is_char8_ty(ty) && return Char8Ty(ty.ptr)
    is_char16_ty(ty) && return Char16Ty(ty.ptr)
    is_char32_ty(ty) && return Char32Ty(ty.ptr)
    is_float_ty(ty) && return FloatTy(ty.ptr)
    is_double_ty(ty) && return DoubleTy(ty.ptr)
    is_long_double_ty(ty) && return LongDoubleTy(ty.ptr)
    is_float16_ty(ty) && return Float16Ty(ty.ptr)
    is_half_ty(ty) && return HalfTy(ty.ptr)
    is_bfloat_ty(ty) && return BFloat16Ty(ty.ptr)
    is_float128_ty(ty) && return Float128Ty(ty.ptr)
    is_nullptr_ty(ty) && return NullPtrTy(ty.ptr)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractTagType)
    is_record_type(ty) && return RecordType(ty.ptr)
    is_enum_type(ty) && return EnumType(ty.ptr)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractFunctionType)
    is_function_no_proto_type(ty) && return FunctionNoProtoType(ty.ptr)
    is_function_proto_type(ty) && return FunctionProtoType(ty.ptr)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractReferenceType)
    is_lvalue_reference_type(ty) && return LValueReferenceType(ty.ptr)
    is_rvalue_reference_type(ty) && return RValueReferenceType(ty.ptr)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractArrayType)
    is_constant_array_type(ty) && return ConstantArrayType(ty.ptr)
    is_incomplete_array_type(ty) && return IncompleteArrayType(ty.ptr)
    is_variable_array_type(ty) && return VariableArrayType(ty.ptr)
    is_dependent_size_array_type(ty) && return DependentSizedArrayType(ty.ptr)
    return resolve(UnexposedType(ty))
end

"""
    jlty_to_llvmty(::Type{T}, ctx::LLVM.Context) where {T}
Interface for mapping a Julia type to the corresponding LLVM type representation.
"""
jlty_to_llvmty(::Type{T}, ctx::LLVM.Context) where {T} = error("no mapping found for $T")

# Julia type to IntegerType <: LLVMType
# LLVM does not make a distinction between signed and unsigned integer type.
jlty_to_llvmty(::Type{Bool}, ctx::LLVM.Context) = LLVM.Int8Type(ctx)
jlty_to_llvmty(::Type{Int8}, ctx::LLVM.Context) = LLVM.Int8Type(ctx)
jlty_to_llvmty(::Type{Int16}, ctx::LLVM.Context) = LLVM.Int16Type(ctx)
jlty_to_llvmty(::Type{Int32}, ctx::LLVM.Context) = LLVM.Int32Type(ctx)
jlty_to_llvmty(::Type{Int64}, ctx::LLVM.Context) = LLVM.Int64Type(ctx)
jlty_to_llvmty(::Type{Int128}, ctx::LLVM.Context) = LLVM.Int128Type(ctx)
jlty_to_llvmty(::Type{UInt8}, ctx::LLVM.Context) = LLVM.Int8Type(ctx)
jlty_to_llvmty(::Type{UInt16}, ctx::LLVM.Context) = LLVM.Int16Type(ctx)
jlty_to_llvmty(::Type{UInt32}, ctx::LLVM.Context) = LLVM.Int32Type(ctx)
jlty_to_llvmty(::Type{UInt64}, ctx::LLVM.Context) = LLVM.Int64Type(ctx)
jlty_to_llvmty(::Type{UInt128}, ctx::LLVM.Context) = LLVM.Int128Type(ctx)

# Julia type to FloatingPointType <: LLVMType
jlty_to_llvmty(::Type{Float16}, ctx::LLVM.Context) = LLVM.HalfType(ctx)
jlty_to_llvmty(::Type{Float32}, ctx::LLVM.Context) = LLVM.FloatType(ctx)
jlty_to_llvmty(::Type{Float64}, ctx::LLVM.Context) = LLVM.DoubleType(ctx)

# Julia type to VoidType <: LLVMType
jlty_to_llvmty(::Type{Nothing}, ctx::LLVM.Context) = LLVM.VoidType(ctx)

# Julia type to PointerType <: SequentialType <: CompositeType <: LLVMType
jlty_to_llvmty(::Type{Ptr{Cvoid}}, ctx::LLVM.Context) = LLVM.PointerType(LLVM.VoidType(ctx))

"""
    clty_to_llvmty_mem(ty::T, cgm::CodeGenModule) where {T<:AbstractClangType} -> LLVMType
Convert a Clang type to the corresponding memory representation of the LLVM type.
"""
function clty_to_llvmty_mem(ty::T, cgm::CodeGenModule) where {T<:AbstractClangType}
    return LLVMType(convertTypeForMemory(cgm, ty))
end
