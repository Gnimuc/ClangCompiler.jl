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
jlty_to_clty(::Type{Ptr{Cvoid}}, ctx::ASTContext) = get_builtin_type(ctx, VoidPtr)

"""
    clty_to_jlty(::Type{T}, ctx::ASTContext) where {T}
Interface for mapping a Clang type to the corresponding Julia type representation.

See also, [`jlty_to_clty`](@ref). Note that, the mapping is not injective.
"""
clty_to_jlty(clty::T) where {T<:AbstractClangType} = error("no mapping found for $T")

# builtin types
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
clty_to_jlty(clty::UnsignedShortTy) = Cshort
clty_to_jlty(clty::UnsignedIntTy) = Cuint
clty_to_jlty(clty::UnsignedLongTy) = Culong
clty_to_jlty(clty::UnsignedLongLongTy) = Culonglong
clty_to_jlty(clty::UnsignedInt128Ty) = Cuint128
clty_to_jlty(clty::FloatTy) = Cfloat
clty_to_jlty(clty::DoubleTy) = Cdouble
clty_to_jlty(clty::Float16Ty) = Cfloat16
clty_to_jlty(clty::VoidPtrTy) = Ptr{Cvoid}
