"""
    struct ASTContext <: Any
Hold a pointer to a `clang::ASTContext` object.
"""
struct ASTContext
    ptr::CXASTContext
end

function print_stats(x::ASTContext)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return clang_ASTContext_PrintStats(x.ptr)
end

function get_Idents(x::ASTContext)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return IdentifierTable(clang_ASTContext_getIdents(x.ptr))
end

function get_type_size(x::ASTContext, ty_ptr::CXType_)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return clang_ASTContext_getTypeSize(x.ptr, ty_ptr)
end
get_type_size(x::ASTContext, ty::AbstractQualType) = get_type_size(x, get_type_ptr(ty))

function get_typedecl_type(x::ASTContext, decl::TypeDecl, prev::TypeDecl=TypeDecl(C_NULL))
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    @assert decl.ptr != C_NULL "TypeDecl has a NULL pointer."
    return QualType(clang_ASTContext_getTypeDeclType(x.ptr, decl.ptr, prev.ptr))
end

function get_record_type(x::ASTContext, decl::RecordDecl)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    @assert decl.ptr != C_NULL "RecordDecl has a NULL pointer."
    return QualType(clang_ASTContext_getRecordType(x.ptr, decl.ptr))
end

get_decl_type(x::ASTContext, decl::NamedDecl) = get_typedecl_type(x, TypeDecl(decl))
get_decl_type(x::ASTContext, decl::AbstractTypeDecl) = get_typedecl_type(x, TypeDecl(decl.ptr))
get_decl_type(x::ASTContext, decl::AbstractRecordDecl) = get_record_type(x, RecordDecl(decl.ptr))

get_name(x::ASTContext, s::String) = get_name(get_Idents(x), s)

function get_pointer_type(x::ASTContext, ty::AbstractQualType)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return QualType(clang_ASTContext_getPointerType(x.ptr, ty.ptr))
end

function get_lvalue_reference_type(x::ASTContext, ty::AbstractQualType)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return QualType(clang_ASTContext_getLValueReferenceType(x.ptr, ty.ptr))
end

function get_rvalue_reference_type(x::ASTContext, ty::AbstractQualType)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return QualType(clang_ASTContext_getRValueReferenceType(x.ptr, ty.ptr))
end

function get_member_pointer_type(x::ASTContext, ty::AbstractQualType, class_ptr::CXType_)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return QualType(clang_ASTContext_getMemberPointerType(x.ptr, ty.ptr, class_ptr))
end
get_member_pointer_type(x::ASTContext, ty::AbstractQualType, class::AbstractQualType) = get_member_pointer_type(x, ty, get_type_ptr(class))

VoidTy(ctx::ASTContext) = VoidTy(clang_ASTContext_VoidTy_getAsQualType(ctx.ptr))
BoolTy(ctx::ASTContext) = BoolTy(clang_ASTContext_BoolTy_getAsQualType(ctx.ptr))
CharTy(ctx::ASTContext) = CharTy(clang_ASTContext_CharTy_getAsQualType(ctx.ptr))
WCharTy(ctx::ASTContext) = WCharTy(clang_ASTContext_WCharTy_getAsQualType(ctx.ptr))  # [C++ 3.9.1p5].
WideCharTy(ctx::ASTContext) = WideCharTy(clang_ASTContext_WideCharTy_getAsQualType(ctx.ptr))
WIntTy(ctx::ASTContext) = WIntTy(clang_ASTContext_WIntTy_getAsQualType(ctx.ptr))  # [C99 7.24.1], integer type unchanged by default promotions.
Char8Ty(ctx::ASTContext) = Char8Ty(clang_ASTContext_Char8Ty_getAsQualType(ctx.ptr))  # [C++20 proposal]
Char16Ty(ctx::ASTContext) = Char16Ty(clang_ASTContext_Char16Ty_getAsQualType(ctx.ptr))  # [C++0x 3.9.1p5], integer type in C99.
Char32Ty(ctx::ASTContext) = Char32Ty(clang_ASTContext_Char32Ty_getAsQualType(ctx.ptr))  # [C++0x 3.9.1p5], integer type in C99.
SignedCharTy(ctx::ASTContext) = SignedCharTy(clang_ASTContext_SignedCharTy_getAsQualType(ctx.ptr))
ShortTy(ctx::ASTContext) = ShortTy(clang_ASTContext_ShortTy_getAsQualType(ctx.ptr))
IntTy(ctx::ASTContext) = IntTy(clang_ASTContext_IntTy_getAsQualType(ctx.ptr))
LongTy(ctx::ASTContext) = LongTy(clang_ASTContext_LongTy_getAsQualType(ctx.ptr))
LongLongTy(ctx::ASTContext) = LongLongTy(clang_ASTContext_LongLongTy_getAsQualType(ctx.ptr))
Int128Ty(ctx::ASTContext) = Int128Ty(clang_ASTContext_Int128Ty_getAsQualType(ctx.ptr))
UnsignedCharTy(ctx::ASTContext) = UnsignedCharTy(clang_ASTContext_UnsignedCharTy_getAsQualType(ctx.ptr))
UnsignedShortTy(ctx::ASTContext) = UnsignedShortTy(clang_ASTContext_UnsignedShortTy_getAsQualType(ctx.ptr))
UnsignedIntTy(ctx::ASTContext) = UnsignedIntTy(clang_ASTContext_UnsignedIntTy_getAsQualType(ctx.ptr))
UnsignedLongTy(ctx::ASTContext) = UnsignedLongTy(clang_ASTContext_UnsignedLongTy_getAsQualType(ctx.ptr))
UnsignedLongLongTy(ctx::ASTContext) = UnsignedLongLongTy(clang_ASTContext_UnsignedLongLongTy_getAsQualType(ctx.ptr))
UnsignedInt128Ty(ctx::ASTContext) = UnsignedInt128Ty(clang_ASTContext_UnsignedInt128Ty_getAsQualType(ctx.ptr))
FloatTy(ctx::ASTContext) = FloatTy(clang_ASTContext_FloatTy_getAsQualType(ctx.ptr))
DoubleTy(ctx::ASTContext) = DoubleTy(clang_ASTContext_DoubleTy_getAsQualType(ctx.ptr))
LongDoubleTy(ctx::ASTContext) = LongDoubleTy(clang_ASTContext_LongDoubleTy_getAsQualType(ctx.ptr))
Float128Ty(ctx::ASTContext) = Float128Ty(clang_ASTContext_Float128Ty_getAsQualType(ctx.ptr))
HalfTy(ctx::ASTContext) = HalfTy(clang_ASTContext_HalfTy_getAsQualType(ctx.ptr))  # [OpenCL 6.1.1.1], ARM NEON
BFloat16Ty(ctx::ASTContext) = BFloat16Ty(clang_ASTContext_BFloat16Ty_getAsQualType(ctx.ptr))
Float16Ty(ctx::ASTContext) = Float16Ty(clang_ASTContext_Float16Ty_getAsQualType(ctx.ptr))  # C11 extension ISO/IEC TS 18661-3
FloatComplexTy(ctx::ASTContext) = FloatComplexTy(clang_ASTContext_FloatComplexTy_getAsQualType(ctx.ptr))
DoubleComplexTy(ctx::ASTContext) = DoubleComplexTy(clang_ASTContext_DoubleComplexTy_getAsQualType(ctx.ptr))
LongDoubleComplexTy(ctx::ASTContext) = LongDoubleComplexTy(clang_ASTContext_LongDoubleComplexTy_getAsQualType(ctx.ptr))
Float128ComplexTy(ctx::ASTContext) = Float128ComplexTy(clang_ASTContext_Float128ComplexTy_getAsQualType(ctx.ptr))
VoidPtrTy(ctx::ASTContext) = VoidPtrTy(clang_ASTContext_VoidPtrTy_getAsQualType(ctx.ptr))
NullPtrTy(ctx::ASTContext) = NullPtrTy(clang_ASTContext_NullPtrTy_getAsQualType(ctx.ptr))  # C++11 nullptr

function get_builtin_type(ctx::ASTContext, ::Type{T}) where {T<:AbstractBuiltinType}
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return T(ctx)
end
get_builtin_qualified_type(ctx::ASTContext, ty) = QualType(get_builtin_type(ctx, ty))

function get_ast_context(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return ASTContext(clang_Decl_getASTContext(x.ptr))
end

function get_ast_context(x::DeclContext)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    return ASTContext(clang_DeclContext_getParentASTContext(x.ptr))
end

function TemplateArgument(ctx::ASTContext, v::GenericValue, ty::AbstractQualType)
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return TemplateArgument(clang_TemplateArgument_constructFromIntegral(ctx.ptr, v.ref,
                                                                         ty.ptr))
end

function TemplateArgumentList(ctx::ASTContext, args::Vector{CXTemplateArgument})
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return TemplateArgumentList(clang_TemplateArgumentList_CreateCopy(ctx.ptr, args,
                                                                      length(args)))
end

function TemplateArgumentList(ctx::ASTContext, args::Vector{TemplateArgument})
    return TemplateArgumentList(ctx, [arg.ptr for arg in args])
end

function ClassTemplateSpecializationDecl(ctx::ASTContext, tk::CXTagTypeKind,
                                         dc::DeclContext, start_loc::SourceLocation,
                                         id_loc::SourceLocation,
                                         template::ClassTemplateDecl,
                                         args::TemplateArgumentList,
                                         prev_decl::ClassTemplateSpecializationDecl)
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    @assert dc.ptr != C_NULL "DeclContext has a NULL pointer."
    @assert template.ptr != C_NULL "ClassTemplateDecl has a NULL pointer."
    @assert args.ptr != C_NULL "TemplateArgumentList has a NULL pointer."
    return ClassTemplateSpecializationDecl(clang_ClassTemplateSpecializationDecl_Create(ctx.ptr,
                                                                                        tk,
                                                                                        dc.ptr,
                                                                                        start_loc.ptr,
                                                                                        id_loc.ptr,
                                                                                        template.ptr,
                                                                                        args.ptr,
                                                                                        prev_decl.ptr))
end

function ClassTemplateSpecializationDecl(ctx::ASTContext, template::ClassTemplateDecl,
                                         args::TemplateArgumentList,
                                         prev_decl::ClassTemplateSpecializationDecl=ClassTemplateSpecializationDecl(C_NULL))
    tdecl = get_template_decl(template)
    tk = get_tag_kind(tdecl)
    dc_ctx = get_decl_context(template)
    start_loc = get_begin_loc(tdecl)
    id_loc = get_location(template)
    return ClassTemplateSpecializationDecl(ctx, tk, dc_ctx, start_loc, id_loc, template,
                                           args, prev_decl)
end

# cast
function DeclContext(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return DeclContext(clang_TagDecl_castToDeclContext(x.ptr))
end

function TagDecl(x::DeclContext)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    return TagDecl(clang_DeclContext_castToTagDecl(x.ptr))
end

function RecordDecl(x::DeclContext)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    return RecordDecl(clang_DeclContext_castToRecordDecl(x.ptr))
end

function CXXRecordDecl(x::DeclContext)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    return CXXRecordDecl(clang_DeclContext_castToCXXRecordDecl(x.ptr))
end

function ClassTemplateDecl(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return ClassTemplateDecl(clang_Decl_castToClassTemplateDecl(x.ptr))
end

function ValueDecl(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return ValueDecl(clang_Decl_castToValueDecl(x.ptr))
end

function TypeDecl(x::NamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return TypeDecl(clang_NamedDecl_castToTypeDecl(x.ptr))
end
