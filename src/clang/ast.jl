"""
    mutable struct ASTContext <: Any
Holds a pointer to a `clang::ASTContext` object.
"""
mutable struct ASTContext
    ptr::CXASTContext
end

function status(x::ASTContext)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return clang_ASTContext_PrintStats(x.ptr)
end

"""
    abstract type AbstractASTConsumer <: Any
Supertype for ASTConsumers.
"""
abstract type AbstractASTConsumer end

"""
    mutable struct ASTConsumer <: Any
"""
mutable struct ASTConsumer
    ptr::CXASTConsumer
end

function handle_translation_unit(csr::T, ctx::ASTContext) where {T<:AbstractASTConsumer}
    @assert csr.ptr != C_NULL "$T has a NULL pointer."
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    clang_ASTConsumer_HandleTranslationUnit(csr.ptr, ctx.ptr)
end

function status(csr::T) where {T<:AbstractASTConsumer}
    @assert csr.ptr != C_NULL "$T has a NULL pointer."
    return clang_ASTConsumer_PrintStats(csr.ptr)
end

# mapping between Julia builtin types and Clang builtin types
get_builtin_type(ctx::ASTContext, ty::Type) = error("missing rules for mapping $(typeof(ty)).")
get_builtin_type(ctx::ASTContext, ::Type{Cvoid}) = VoidTy(clang_ASTContext_VoidTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Bool}) = BoolTy(clang_ASTContext_BoolTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cuchar}) = CharTy(clang_ASTContext_CharTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{?}) = WCharTy(clang_ASTContext_WCharTy_getTypePtrOrNull(ctx.ptr))  # [C++ 3.9.1p5].
get_builtin_type(ctx::ASTContext, ::Type{Cwchar_t}) = WideCharTy(clang_ASTContext_WideCharTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{?}) = WIntTy(clang_ASTContext_WIntTy_getTypePtrOrNull(ctx.ptr))  # [C99 7.24.1], integer type unchanged by default promotions.
# get_builtin_type(ctx::ASTContext, ::Type{?}) = Char8Ty(clang_ASTContext_Char8Ty_getTypePtrOrNull(ctx.ptr))  # [C++20 proposal]
# get_builtin_type(ctx::ASTContext, ::Type{?}) = Char16Ty(clang_ASTContext_Char16Ty_getTypePtrOrNull(ctx.ptr))  # [C++0x 3.9.1p5], integer type in C99.
# get_builtin_type(ctx::ASTContext, ::Type{?}) = Char32Ty(clang_ASTContext_Char32Ty_getTypePtrOrNull(ctx.ptr))  # [C++0x 3.9.1p5], integer type in C99.
get_builtin_type(ctx::ASTContext, ::Type{Cchar}) = SignedCharTy(clang_ASTContext_SignedCharTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cshort}) = ShortTy(clang_ASTContext_ShortTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cint}) = IntTy(clang_ASTContext_IntTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Clong}) = LongTy(clang_ASTContext_LongTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Clonglong}) = LongLongTy(clang_ASTContext_LongLongTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Int128}) = Int128Ty(clang_ASTContext_Int128Ty_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cuchar}) = UnsignedCharTy(clang_ASTContext_UnsignedCharTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cushort}) = UnsignedShortTy(clang_ASTContext_UnsignedShortTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cuint}) = UnsignedIntTy(clang_ASTContext_UnsignedIntTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Culong}) = UnsignedLongTy(clang_ASTContext_UnsignedLongTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Culonglong}) = UnsignedLongLongTy(clang_ASTContext_UnsignedLongLongTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{UInt128}) = UnsignedInt128Ty(clang_ASTContext_UnsignedInt128Ty_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cfloat}) = FloatTy(clang_ASTContext_FloatTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Cdouble}) = DoubleTy(clang_ASTContext_DoubleTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{Float64}) = LongDoubleTy(clang_ASTContext_LongDoubleTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{?}) = Float128Ty(clang_ASTContext_Float128Ty_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{Float16}) = HalfTy(clang_ASTContext_HalfTy_getTypePtrOrNull(ctx.ptr))  # [OpenCL 6.1.1.1], ARM NEON
# get_builtin_type(ctx::ASTContext, ::Type{Float16}) = BFloat16Ty(clang_ASTContext_BFloat16Ty_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Float16}) = Float16Ty(clang_ASTContext_Float16Ty_getTypePtrOrNull(ctx.ptr))  # C11 extension ISO/IEC TS 18661-3
get_builtin_type(ctx::ASTContext, ::Type{ComplexF32}) = FloatComplexTy(clang_ASTContext_FloatComplexTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{ComplexF64}) = DoubleComplexTy(clang_ASTContext_DoubleComplexTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{?}) = LongDoubleComplexTy(clang_ASTContext_LongDoubleComplexTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{?}) = Float128ComplexTy(clang_ASTContext_Float128ComplexTy_getTypePtrOrNull(ctx.ptr))
get_builtin_type(ctx::ASTContext, ::Type{Ptr{Cvoid}}) = VoidPtrTy(clang_ASTContext_VoidPtrTy_getTypePtrOrNull(ctx.ptr))
# get_builtin_type(ctx::ASTContext, ::Type{?}) = NullPtrTy(clang_ASTContext_NullPtrTy_getTypePtrOrNull(ctx.ptr))  # C++11 nullptr
get_builtin_type(ctx::ASTContext, ::Type{Clong}) = LongTy(clang_ASTContext_LongTy_getTypePtrOrNull(ctx.ptr))

function get_builtin_qualified_type(ctx::ASTContext, ty::Type)
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return QualType(get_builtin_type(ctx, ty))
end
get_builtin_qualified_type(ctx::ASTContext, ty::T) where {T} = get_builtin_qualified_type(ctx, T)
