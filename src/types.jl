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
    return T === nothing ? resolve(UnexposedType(ty)) : unchecked_cast(T, ty)
end

resolve(x::UnexposedType) = x

function resolve(ty::AbstractBuiltinType)
    is_void_ty(ty) && return unchecked_cast(VoidTy, ty)
    is_bool_ty(ty) && return unchecked_cast(BoolTy, ty)
    is_char_ty(ty) && return unchecked_cast(CharTy, ty)
    is_wchar_ty(ty) && return unchecked_cast(WCharTy, ty)
    is_widechar_ty(ty) && return unchecked_cast(WideCharTy, ty)
    is_signed_char_ty(ty) && return unchecked_cast(SignedCharTy, ty)
    is_short_ty(ty) && return unchecked_cast(ShortTy, ty)
    is_int_ty(ty) && return unchecked_cast(IntTy, ty)
    is_long_ty(ty) && return unchecked_cast(LongTy, ty)
    is_longlong_ty(ty) && return unchecked_cast(LongLongTy, ty)
    is_int128_ty(ty) && return unchecked_cast(Int128Ty, ty)
    is_unsigned_char_ty(ty) && return unchecked_cast(UnsignedCharTy, ty)
    is_unsigned_short_ty(ty) && return unchecked_cast(UnsignedShortTy, ty)
    is_unsigned_int_ty(ty) && return unchecked_cast(UnsignedIntTy, ty)
    is_unsigned_long_ty(ty) && return unchecked_cast(UnsignedLongTy, ty)
    is_unsigned_longlong_ty(ty) && return unchecked_cast(UnsignedLongLongTy, ty)
    is_unsigned_int128_ty(ty) && return unchecked_cast(UnsignedInt128Ty, ty)
    is_char8_ty(ty) && return unchecked_cast(Char8Ty, ty)
    is_char16_ty(ty) && return unchecked_cast(Char16Ty, ty)
    is_char32_ty(ty) && return unchecked_cast(Char32Ty, ty)
    is_float_ty(ty) && return unchecked_cast(FloatTy, ty)
    is_double_ty(ty) && return unchecked_cast(DoubleTy, ty)
    is_long_double_ty(ty) && return unchecked_cast(LongDoubleTy, ty)
    is_float16_ty(ty) && return unchecked_cast(Float16Ty, ty)
    is_half_ty(ty) && return unchecked_cast(HalfTy, ty)
    is_bfloat_ty(ty) && return unchecked_cast(BFloat16Ty, ty)
    is_float128_ty(ty) && return unchecked_cast(Float128Ty, ty)
    is_nullptr_ty(ty) && return unchecked_cast(NullPtrTy, ty)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractTagType)
    is_record_type(ty) && return unchecked_cast(RecordType, ty)
    is_enum_type(ty) && return unchecked_cast(EnumType, ty)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractFunctionType)
    is_function_no_proto_type(ty) && return unchecked_cast(FunctionNoProtoType, ty)
    is_function_proto_type(ty) && return unchecked_cast(FunctionProtoType, ty)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractReferenceType)
    is_lvalue_reference_type(ty) && return unchecked_cast(LValueReferenceType, ty)
    is_rvalue_reference_type(ty) && return unchecked_cast(RValueReferenceType, ty)
    return resolve(UnexposedType(ty))
end

function resolve(ty::AbstractArrayType)
    is_constant_array_type(ty) && return unchecked_cast(ConstantArrayType, ty)
    is_incomplete_array_type(ty) && return unchecked_cast(IncompleteArrayType, ty)
    is_variable_array_type(ty) && return unchecked_cast(VariableArrayType, ty)
    is_dependent_size_array_type(ty) && return unchecked_cast(DependentSizedArrayType, ty)
    return resolve(UnexposedType(ty))
end

"""
    jlty_to_llvmty(::Type{T}, ctx::LLVM.Context) where {T}
Interface for mapping a Julia type to the corresponding LLVM type representation.

The type object is created in `ctx`: LLVM.jl's type constructors read the task-bound
context, so `ctx` is temporarily activated for the duration of the call.
"""
jlty_to_llvmty(::Type{T}, ctx::LLVM.Context) where {T} = error("no mapping found for $T")

# Julia type to IntegerType <: LLVMType
# LLVM does not make a distinction between signed and unsigned integer type.
jlty_to_llvmty(::Type{Bool}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int8Type, ctx)
jlty_to_llvmty(::Type{Int8}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int8Type, ctx)
jlty_to_llvmty(::Type{Int16}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int16Type, ctx)
jlty_to_llvmty(::Type{Int32}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int32Type, ctx)
jlty_to_llvmty(::Type{Int64}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int64Type, ctx)
jlty_to_llvmty(::Type{Int128}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int128Type, ctx)
jlty_to_llvmty(::Type{UInt8}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int8Type, ctx)
jlty_to_llvmty(::Type{UInt16}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int16Type, ctx)
jlty_to_llvmty(::Type{UInt32}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int32Type, ctx)
jlty_to_llvmty(::Type{UInt64}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int64Type, ctx)
jlty_to_llvmty(::Type{UInt128}, ctx::LLVM.Context) = LLVM.context!(LLVM.Int128Type, ctx)

# Julia type to FloatingPointType <: LLVMType
jlty_to_llvmty(::Type{Float16}, ctx::LLVM.Context) = LLVM.context!(LLVM.HalfType, ctx)
jlty_to_llvmty(::Type{Float32}, ctx::LLVM.Context) = LLVM.context!(LLVM.FloatType, ctx)
jlty_to_llvmty(::Type{Float64}, ctx::LLVM.Context) = LLVM.context!(LLVM.DoubleType, ctx)

# Julia type to VoidType <: LLVMType
jlty_to_llvmty(::Type{Nothing}, ctx::LLVM.Context) = LLVM.context!(LLVM.VoidType, ctx)

# Julia type to PointerType <: LLVMType (an opaque pointer in address space 0)
jlty_to_llvmty(::Type{Ptr{Cvoid}}, ctx::LLVM.Context) = LLVM.context!(LLVM.PointerType, ctx)

"""
    clty_to_llvmty_mem(ty::T, cgm::CodeGenModule) where {T<:AbstractClangType} -> LLVM.LLVMType
Convert a Clang type to the corresponding memory representation of the LLVM type.
"""
function clty_to_llvmty_mem(ty::T, cgm::CodeGenModule) where {T<:AbstractClangType}
    return LLVM.LLVMType(convertTypeForMemory(cgm, ty))
end
