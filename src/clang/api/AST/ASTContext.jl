function PrintStats(x::ASTContext)
    @check_ptrs x
    return clang_ASTContext_PrintStats(x)
end

function getTypeSize(x::ASTContext, ty_ptr::CXType_)
    @check_ptrs x
    return clang_ASTContext_getTypeSize(x, ty_ptr)
end
getTypeSize(x::ASTContext, ty::AbstractQualType) = getTypeSize(x, get_type_ptr(ty))

function getTypeDeclType(x::ASTContext, decl::TypeDecl, prev::TypeDecl=TypeDecl(C_NULL))
    @check_ptrs x decl
    return QualType(clang_ASTContext_getTypeDeclType(x, decl, prev))
end

function getRecordType(x::ASTContext, decl::RecordDecl)
    @check_ptrs x decl
    return QualType(clang_ASTContext_getRecordType(x, decl))
end

getTypeDeclType(x::ASTContext, decl::NamedDecl) = getTypeDeclType(x, TypeDecl(decl))
getTypeDeclType(x::ASTContext, decl::AbstractTypeDecl) = getTypeDeclType(x, TypeDecl(decl))
getTypeDeclType(x::ASTContext, decl::AbstractRecordDecl) = getRecordType(x, RecordDecl(decl))

function getPointerType(x::ASTContext, ty::AbstractQualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getPointerType(x, ty))
end

function getLValueReferenceType(x::ASTContext, ty::AbstractQualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getLValueReferenceType(x, ty))
end

function getRValueReferenceType(x::ASTContext, ty::AbstractQualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getRValueReferenceType(x, ty))
end

function getMemberPointerType(x::ASTContext, ty::AbstractQualType, class_ptr::CXType_)
    @check_ptrs x
    return QualType(clang_ASTContext_getMemberPointerType(x, ty, class_ptr))
end
getMemberPointerType(x::ASTContext, ty::AbstractQualType, class::AbstractQualType) = getMemberPointerType(x, ty, get_type_ptr(class))

function getIdents(x::ASTContext)
    @check_ptrs x
    return IdentifierTable(clang_ASTContext_getIdents(x))
end

VoidTy(ctx::ASTContext) = VoidTy(clang_ASTContext_VoidTy_getAsQualType(ctx))
BoolTy(ctx::ASTContext) = BoolTy(clang_ASTContext_BoolTy_getAsQualType(ctx))
CharTy(ctx::ASTContext) = CharTy(clang_ASTContext_CharTy_getAsQualType(ctx))
WCharTy(ctx::ASTContext) = WCharTy(clang_ASTContext_WCharTy_getAsQualType(ctx))  # [C++ 3.9.1p5].
WideCharTy(ctx::ASTContext) = WideCharTy(clang_ASTContext_WideCharTy_getAsQualType(ctx))
WIntTy(ctx::ASTContext) = WIntTy(clang_ASTContext_WIntTy_getAsQualType(ctx))  # [C99 7.24.1], integer type unchanged by default promotions.
Char8Ty(ctx::ASTContext) = Char8Ty(clang_ASTContext_Char8Ty_getAsQualType(ctx))  # [C++20 proposal]
Char16Ty(ctx::ASTContext) = Char16Ty(clang_ASTContext_Char16Ty_getAsQualType(ctx))  # [C++0x 3.9.1p5], integer type in C99.
Char32Ty(ctx::ASTContext) = Char32Ty(clang_ASTContext_Char32Ty_getAsQualType(ctx))  # [C++0x 3.9.1p5], integer type in C99.
SignedCharTy(ctx::ASTContext) = SignedCharTy(clang_ASTContext_SignedCharTy_getAsQualType(ctx))
ShortTy(ctx::ASTContext) = ShortTy(clang_ASTContext_ShortTy_getAsQualType(ctx))
IntTy(ctx::ASTContext) = IntTy(clang_ASTContext_IntTy_getAsQualType(ctx))
LongTy(ctx::ASTContext) = LongTy(clang_ASTContext_LongTy_getAsQualType(ctx))
LongLongTy(ctx::ASTContext) = LongLongTy(clang_ASTContext_LongLongTy_getAsQualType(ctx))
Int128Ty(ctx::ASTContext) = Int128Ty(clang_ASTContext_Int128Ty_getAsQualType(ctx))
UnsignedCharTy(ctx::ASTContext) = UnsignedCharTy(clang_ASTContext_UnsignedCharTy_getAsQualType(ctx))
UnsignedShortTy(ctx::ASTContext) = UnsignedShortTy(clang_ASTContext_UnsignedShortTy_getAsQualType(ctx))
UnsignedIntTy(ctx::ASTContext) = UnsignedIntTy(clang_ASTContext_UnsignedIntTy_getAsQualType(ctx))
UnsignedLongTy(ctx::ASTContext) = UnsignedLongTy(clang_ASTContext_UnsignedLongTy_getAsQualType(ctx))
UnsignedLongLongTy(ctx::ASTContext) = UnsignedLongLongTy(clang_ASTContext_UnsignedLongLongTy_getAsQualType(ctx))
UnsignedInt128Ty(ctx::ASTContext) = UnsignedInt128Ty(clang_ASTContext_UnsignedInt128Ty_getAsQualType(ctx))
FloatTy(ctx::ASTContext) = FloatTy(clang_ASTContext_FloatTy_getAsQualType(ctx))
DoubleTy(ctx::ASTContext) = DoubleTy(clang_ASTContext_DoubleTy_getAsQualType(ctx))
LongDoubleTy(ctx::ASTContext) = LongDoubleTy(clang_ASTContext_LongDoubleTy_getAsQualType(ctx))
Float128Ty(ctx::ASTContext) = Float128Ty(clang_ASTContext_Float128Ty_getAsQualType(ctx))
HalfTy(ctx::ASTContext) = HalfTy(clang_ASTContext_HalfTy_getAsQualType(ctx))  # [OpenCL 6.1.1.1], ARM NEON
BFloat16Ty(ctx::ASTContext) = BFloat16Ty(clang_ASTContext_BFloat16Ty_getAsQualType(ctx))
Float16Ty(ctx::ASTContext) = Float16Ty(clang_ASTContext_Float16Ty_getAsQualType(ctx))  # C11 extension ISO/IEC TS 18661-3
FloatComplexTy(ctx::ASTContext) = FloatComplexTy(clang_ASTContext_FloatComplexTy_getAsQualType(ctx))
DoubleComplexTy(ctx::ASTContext) = DoubleComplexTy(clang_ASTContext_DoubleComplexTy_getAsQualType(ctx))
LongDoubleComplexTy(ctx::ASTContext) = LongDoubleComplexTy(clang_ASTContext_LongDoubleComplexTy_getAsQualType(ctx))
Float128ComplexTy(ctx::ASTContext) = Float128ComplexTy(clang_ASTContext_Float128ComplexTy_getAsQualType(ctx))
VoidPtrTy(ctx::ASTContext) = VoidPtrTy(clang_ASTContext_VoidPtrTy_getAsQualType(ctx))
NullPtrTy(ctx::ASTContext) = NullPtrTy(clang_ASTContext_NullPtrTy_getAsQualType(ctx))  # C++11 nullptr
