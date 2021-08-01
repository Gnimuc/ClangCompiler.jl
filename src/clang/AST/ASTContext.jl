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

VoidTy(ctx::ASTContext) = VoidTy(clang_ASTContext_VoidTy_getTypePtrOrNull(ctx.ptr))
BoolTy(ctx::ASTContext) = BoolTy(clang_ASTContext_BoolTy_getTypePtrOrNull(ctx.ptr))
CharTy(ctx::ASTContext) = CharTy(clang_ASTContext_CharTy_getTypePtrOrNull(ctx.ptr))
WCharTy(ctx::ASTContext) = WCharTy(clang_ASTContext_WCharTy_getTypePtrOrNull(ctx.ptr))  # [C++ 3.9.1p5].
WideCharTy(ctx::ASTContext) = WideCharTy(clang_ASTContext_WideCharTy_getTypePtrOrNull(ctx.ptr))
WIntTy(ctx::ASTContext) = WIntTy(clang_ASTContext_WIntTy_getTypePtrOrNull(ctx.ptr))  # [C99 7.24.1], integer type unchanged by default promotions.
Char8Ty(ctx::ASTContext) = Char8Ty(clang_ASTContext_Char8Ty_getTypePtrOrNull(ctx.ptr))  # [C++20 proposal]
Char16Ty(ctx::ASTContext) = Char16Ty(clang_ASTContext_Char16Ty_getTypePtrOrNull(ctx.ptr))  # [C++0x 3.9.1p5], integer type in C99.
Char32Ty(ctx::ASTContext) = Char32Ty(clang_ASTContext_Char32Ty_getTypePtrOrNull(ctx.ptr))  # [C++0x 3.9.1p5], integer type in C99.
SignedCharTy(ctx::ASTContext) = SignedCharTy(clang_ASTContext_SignedCharTy_getTypePtrOrNull(ctx.ptr))
ShortTy(ctx::ASTContext) = ShortTy(clang_ASTContext_ShortTy_getTypePtrOrNull(ctx.ptr))
IntTy(ctx::ASTContext) = IntTy(clang_ASTContext_IntTy_getTypePtrOrNull(ctx.ptr))
LongTy(ctx::ASTContext) = LongTy(clang_ASTContext_LongTy_getTypePtrOrNull(ctx.ptr))
LongLongTy(ctx::ASTContext) = LongLongTy(clang_ASTContext_LongLongTy_getTypePtrOrNull(ctx.ptr))
Int128Ty(ctx::ASTContext) = Int128Ty(clang_ASTContext_Int128Ty_getTypePtrOrNull(ctx.ptr))
UnsignedCharTy(ctx::ASTContext) = UnsignedCharTy(clang_ASTContext_UnsignedCharTy_getTypePtrOrNull(ctx.ptr))
UnsignedShortTy(ctx::ASTContext) = UnsignedShortTy(clang_ASTContext_UnsignedShortTy_getTypePtrOrNull(ctx.ptr))
UnsignedIntTy(ctx::ASTContext) = UnsignedIntTy(clang_ASTContext_UnsignedIntTy_getTypePtrOrNull(ctx.ptr))
UnsignedLongTy(ctx::ASTContext) = UnsignedLongTy(clang_ASTContext_UnsignedLongTy_getTypePtrOrNull(ctx.ptr))
UnsignedLongLongTy(ctx::ASTContext) = UnsignedLongLongTy(clang_ASTContext_UnsignedLongLongTy_getTypePtrOrNull(ctx.ptr))
UnsignedInt128Ty(ctx::ASTContext) = UnsignedInt128Ty(clang_ASTContext_UnsignedInt128Ty_getTypePtrOrNull(ctx.ptr))
FloatTy(ctx::ASTContext) = FloatTy(clang_ASTContext_FloatTy_getTypePtrOrNull(ctx.ptr))
DoubleTy(ctx::ASTContext) = DoubleTy(clang_ASTContext_DoubleTy_getTypePtrOrNull(ctx.ptr))
LongDoubleTy(ctx::ASTContext) = LongDoubleTy(clang_ASTContext_LongDoubleTy_getTypePtrOrNull(ctx.ptr))
Float128Ty(ctx::ASTContext) = Float128Ty(clang_ASTContext_Float128Ty_getTypePtrOrNull(ctx.ptr))
HalfTy(ctx::ASTContext) = HalfTy(clang_ASTContext_HalfTy_getTypePtrOrNull(ctx.ptr))  # [OpenCL 6.1.1.1], ARM NEON
BFloat16Ty(ctx::ASTContext) = BFloat16Ty(clang_ASTContext_BFloat16Ty_getTypePtrOrNull(ctx.ptr))
Float16Ty(ctx::ASTContext) = Float16Ty(clang_ASTContext_Float16Ty_getTypePtrOrNull(ctx.ptr))  # C11 extension ISO/IEC TS 18661-3
FloatComplexTy(ctx::ASTContext) = FloatComplexTy(clang_ASTContext_FloatComplexTy_getTypePtrOrNull(ctx.ptr))
DoubleComplexTy(ctx::ASTContext) = DoubleComplexTy(clang_ASTContext_DoubleComplexTy_getTypePtrOrNull(ctx.ptr))
LongDoubleComplexTy(ctx::ASTContext) = LongDoubleComplexTy(clang_ASTContext_LongDoubleComplexTy_getTypePtrOrNull(ctx.ptr))
Float128ComplexTy(ctx::ASTContext) = Float128ComplexTy(clang_ASTContext_Float128ComplexTy_getTypePtrOrNull(ctx.ptr))
VoidPtrTy(ctx::ASTContext) = VoidPtrTy(clang_ASTContext_VoidPtrTy_getTypePtrOrNull(ctx.ptr))
NullPtrTy(ctx::ASTContext) = NullPtrTy(clang_ASTContext_NullPtrTy_getTypePtrOrNull(ctx.ptr))  # C++11 nullptr

function get_builtin_type(ctx::ASTContext, ::Type{T}) where {T<:AbstractBuiltinType}
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return T(ctx)
end
get_builtin_qualified_type(ctx::ASTContext, ty) = QualType(get_builtin_type(ctx, ty))
