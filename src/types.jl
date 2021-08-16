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
clty_to_jlty(clty::T) where {T<:AbstractClangType} = error("no mapping found for $T")

# builtin types
clty_to_jlty(clty::T) where {T<:AbstractBuiltinType} = error("no mapping found for builtin type: $T")
clty_to_jlty(clty::VoidTy) = Cvoid
clty_to_jlty(clty::BoolTy) = Bool
clty_to_jlty(clty::CharTy) = Cchar
clty_to_jlty(clty::WideCharTy) = Cwchar_t
clty_to_jlty(clty::SignedCharTy) = Cchar
clty_to_jlty(clty::ShortTy) = Cshort
clty_to_jlty(clty::IntTy) = Cint
clty_to_jlty(clty::LongTy) = Clong
clty_to_jlty(clty::LongLongTy) = Clonglong
clty_to_jlty(clty::Int128Ty) = Int128
clty_to_jlty(clty::UnsignedCharTy) = Cuchar
clty_to_jlty(clty::UnsignedShortTy) = Cushort
clty_to_jlty(clty::UnsignedIntTy) = Cuint
clty_to_jlty(clty::UnsignedLongTy) = Culong
clty_to_jlty(clty::UnsignedLongLongTy) = Culonglong
clty_to_jlty(clty::UnsignedInt128Ty) = UInt128
clty_to_jlty(clty::FloatTy) = Cfloat
clty_to_jlty(clty::DoubleTy) = Cdouble
clty_to_jlty(clty::Float16Ty) = Float16
clty_to_jlty(clty::VoidPtrTy) = Ptr{Cvoid}

# Clang types
clty_to_jlty(clty::QualType) = clty_to_jlty(typeclass(clty))
clty_to_jlty(clty::BuiltinType) = clty_to_jlty(typeclass(clty))
clty_to_jlty(clty::ReferenceType) = clty_to_jlty(typeclass(clty))
clty_to_jlty(clty::FunctionType) = clty_to_jlty(typeclass(clty))
clty_to_jlty(clty::ArrayType) = clty_to_jlty(typeclass(clty))
clty_to_jlty(clty::TagType) = clty_to_jlty(typeclass(clty))

clty_to_jlty(clty::PointerType) = Ptr{clty_to_jlty(get_pointee_type(clty))}

function typeclass(ty::QualType)
    is_builtin_type(ty) && return BuiltinType(ty.ptr)
    is_complex_type(ty) && return ComplexType(ty.ptr)
    is_pointer_type(ty) && return PointerType(ty.ptr)
    is_reference_type(ty) && return ReferenceType(ty.ptr)
    is_member_pointer_type(ty) && return MemberPointerType(ty.ptr)
    is_array_type(ty) && return ArrayType(tty.ptry)
    is_function_type(ty) && return FunctionType(ty.ptr)
    is_typedef_type(ty) && return TypedefType(ty.ptr)
    is_tag_type(ty) && return TagType(ty.ptr)
    is_template_type_parm_type(ty) && return TemplateTypeParmType(ty.ptr)
    is_subst_template_type_parm_type(ty) && return SubstTemplateTypeParmType(ty.ptr)
    is_subst_template_type_parm_pack_type(ty) && return SubstTemplateTypeParmPackType(ty.ptr)
    is_template_specialization_type(ty) && return TemplateSpecializationType(ty.ptr)
    is_elaborated_type(ty) && return ElaboratedType(ty.ptr)
    is_dependent_name_type(ty) && return DependentNameType(ty.ptr)
    is_dependent_template_specilization_type(ty) && return DependentTemplateSpecializationType(ty.ptr)
    return UnexposedType(ty)
end

function typeclass(ty::BuiltinType)
    true && return VoidTy(ty.ptr)
    true && return BoolTy(ty.ptr)
    true && return CharTy(ty.ptr)
    true && return WideCharTy(ty.ptr)
    true && return SignedCharTy(ty.ptr)
    true && return IntTy(ty.ptr)
    true && return LongTy(ty.ptr)
    true && return LongLongTy(ty.ptr)
    true && return Int128Ty(ty.ptr)
    true && return UnsignedCharTy(ty.ptr)
    true && return UnsignedShortTy(ty.ptr)
    true && return UnsignedIntTy(ty.ptr)
    true && return UnsignedLongTy(ty.ptr)
    true && return UnsignedLongLongTy(ty.ptr)
    true && return UnsignedInt128Ty(ty.ptr)
    true && return FloatTy(ty.ptr)
    true && return DoubleTy(ty.ptr)
    true && return Float16Ty(ty.ptr)
    true && return VoidPtrTy(ty.ptr)
    return UnexposedType(ty)
end

function typeclass(ty::ReferenceType)
    is_lvalue_reference_type(ty) && return LValueReferenceType(ty.ptr)
    is_rvalue_reference_type(ty) && return RValueReferenceType(ty.ptr)
    return UnexposedType(ty)
end

function typeclass(ty::FunctionType)
    is_function_no_proto_type(ty) && return FunctionNoProtoType(ty.ptr)
    is_function_proto_type(ty) && return FunctionProtoType(ty.ptr)
    return UnexposedType(ty)
end

function typeclass(ty::ArrayType)
    is_constant_array_type(ty) && return ConstantArrayType(ty.ptr)
    is_incomplete_array_type(ty) && return IncompleteArrayType(ty.ptr)
    is_variable_array_type(ty) && return VariableArrayType(ty.ptr)
    is_dependent_size_array_type(ty) && return DependentSizedArrayType(ty.ptr)
    return UnexposedType(ty)
end

function typeclass(ty::TagType)
    is_record_type(ty) && return RecordType(ty.ptr)
    is_enum_type(ty) && return EnumType(ty.ptr)
    return UnexposedType(ty)
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
