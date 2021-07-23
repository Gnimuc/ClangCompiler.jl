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

"""
    CanQualType <: Any
Represent a canonical, qualified type.
"""
struct CanQualType
    ptr::CXType_
end

# mapping between Julia builtin types and Clang builtin types
_get_builtin_type(ctx::ASTContext, ::Type) = error("only Julia builtin types can be mapped to Clang builtin types.")
_get_builtin_type(ctx::ASTContext, ::Type{Cvoid}) = clang_ASTContext_VoidTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Bool}) = clang_ASTContext_BoolTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cuchar}) = clang_ASTContext_CharTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_WCharTy_getTypePtrOrNull(ctx.ptr)  # [C++ 3.9.1p5].
_get_builtin_type(ctx::ASTContext, ::Type{Cwchar_t}) = clang_ASTContext_WideCharTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_WIntTy_getTypePtrOrNull(ctx.ptr)  # [C99 7.24.1], integer type unchanged by default promotions.
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_Char8Ty_getTypePtrOrNull(ctx.ptr)  # [C++20 proposal]
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_Char16Ty_getTypePtrOrNull(ctx.ptr)  # [C++0x 3.9.1p5], integer type in C99.
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_Char32Ty_getTypePtrOrNull(ctx.ptr)  # [C++0x 3.9.1p5], integer type in C99.
_get_builtin_type(ctx::ASTContext, ::Type{Cchar}) = clang_ASTContext_SignedCharTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cshort}) = clang_ASTContext_ShortTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cint}) = clang_ASTContext_IntTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Clong}) = clang_ASTContext_LongTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Clonglong}) = clang_ASTContext_LongLongTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Int128}) = clang_ASTContext_Int128Ty_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cuchar}) = clang_ASTContext_UnsignedCharTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cushort}) = clang_ASTContext_UnsignedShortTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cuint}) = clang_ASTContext_UnsignedIntTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Culong}) = clang_ASTContext_UnsignedLongTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Culonglong}) = clang_ASTContext_UnsignedLongLongTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{UInt128}) = clang_ASTContext_UnsignedInt128Ty_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cfloat}) = clang_ASTContext_FloatTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Cdouble}) = clang_ASTContext_DoubleTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{Float64}) = clang_ASTContext_LongDoubleTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_Float128Ty_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{Float16}) = clang_ASTContext_HalfTy_getTypePtrOrNull(ctx.ptr)  # [OpenCL 6.1.1.1], ARM NEON
# _get_builtin_type(ctx::ASTContext, ::Type{Float16}) = clang_ASTContext_BFloat16Ty_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Float16}) = clang_ASTContext_Float16Ty_getTypePtrOrNull(ctx.ptr)  # C11 extension ISO/IEC TS 18661-3
_get_builtin_type(ctx::ASTContext, ::Type{ComplexF32}) = clang_ASTContext_FloatComplexTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{ComplexF64}) = clang_ASTContext_DoubleComplexTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_LongDoubleComplexTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_Float128ComplexTy_getTypePtrOrNull(ctx.ptr)
_get_builtin_type(ctx::ASTContext, ::Type{Ptr{Cvoid}}) = clang_ASTContext_VoidPtrTy_getTypePtrOrNull(ctx.ptr)
# _get_builtin_type(ctx::ASTContext, ::Type{?}) = clang_ASTContext_NullPtrTy_getTypePtrOrNull(ctx.ptr)  # C++11 nullptr
_get_builtin_type(ctx::ASTContext, ::Type{Clong}) = clang_ASTContext_LongTy_getTypePtrOrNull(ctx.ptr)

function get_builtin_clang_type(ctx::ASTContext, ty::Type)
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return CanQualType(_get_builtin_type(ctx, ty))
end
get_builtin_clang_type(ctx::ASTContext, ty::T) where {T} = get_builtin_clang_type(ctx, T)
