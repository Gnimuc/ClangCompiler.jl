# ASTConsumer
function PrintStats(x::T) where {T<:AbstractASTConsumer}
    @check_ptrs x
    return clang_ASTConsumer_PrintStats(x)
end

function HandleTranslationUnit(csr::T, ctx::ASTContext) where {T<:AbstractASTConsumer}
    @check_ptrs csr ctx
    return clang_ASTConsumer_HandleTranslationUnit(csr, ctx)
end

# ASTContext
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
    return QualType(clang_ASTContext_getTypeDeclType(x, decl.ptr, prev.ptr))
end

function getRecordType(x::ASTContext, decl::RecordDecl)
    @check_ptrs x decl
    return QualType(clang_ASTContext_getRecordType(x, decl.ptr))
end

getTypeDeclType(x::ASTContext, decl::NamedDecl) = getTypeDeclType(x, TypeDecl(decl))
getTypeDeclType(x::ASTContext, decl::AbstractTypeDecl) = getTypeDeclType(x, TypeDecl(decl.ptr))
getTypeDeclType(x::ASTContext, decl::AbstractRecordDecl) = getRecordType(x, RecordDecl(decl.ptr))

function getPointerType(x::ASTContext, ty::AbstractQualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getPointerType(x.ptr, ty.ptr))
end

function getLValueReferenceType(x::ASTContext, ty::AbstractQualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getLValueReferenceType(x.ptr, ty.ptr))
end

function getRValueReferenceType(x::ASTContext, ty::AbstractQualType)
    @check_ptrs x
    return QualType(clang_ASTContext_getRValueReferenceType(x.ptr, ty.ptr))
end

function getMemberPointerType(x::ASTContext, ty::AbstractQualType, class_ptr::CXType_)
    @check_ptrs x
    return QualType(clang_ASTContext_getMemberPointerType(x.ptr, ty.ptr, class_ptr))
end
getMemberPointerType(x::ASTContext, ty::AbstractQualType, class::AbstractQualType) = getMemberPointerType(x, ty, get_type_ptr(class))

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

function getASTContext(x::AbstractDecl)
    @check_ptrs x
    return ASTContext(clang_Decl_getASTContext(x.ptr))
end

function getParentASTContext(x::DeclContext)
    @check_ptrs x
    return ASTContext(clang_DeclContext_getParentASTContext(x.ptr))
end

function getIdents(x::ASTContext)
    @check_ptrs x
    return IdentifierTable(clang_ASTContext_getIdents(x))
end

# Decl
function dumpColor(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_dumpColor(x)
end

function isOutOfLine(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isOutOfLine(x)
end

function getLocation(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getLocation(x))
end

function getDeclKindName(x::AbstractDecl)
    @check_ptrs x
    return unsafe_string(clang_Decl_getDeclKindName(x))
end

function getNextDeclInContext(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getNextDeclInContext(x))
end

function get_decl_context(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getDeclContext(x))
end

function get_non_closure_context(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getNonClosureContext(x))
end

function is_in_anonymous_namespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInAnonymousNamespace(x)
end

function is_in_std_namespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInStdNamespace(x)
end

function get_lang_options(x::AbstractDecl)
    @check_ptrs x
    return LangOptions(clang_Decl_getLangOpts(x))
end

function get_lexical_decl_context(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getLexicalDeclContext(x))
end

function is_templated(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplated(x)
end

function is_canonical(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCanonicalDecl(x)
end

function get_previous_decl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getPreviousDecl(x))
end

function is_first_decl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFirstDecl(x)
end

function get_most_recent_decl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getMostRecentDecl(x))
end

function is_template_parameter(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateParameter(x)
end

function is_template_decl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateDecl(x)
end

function get_described_template(x::AbstractDecl)
    @check_ptrs x
    return TemplateDecl(clang_Decl_getDescribedTemplate(x))
end

function set_decl_context(decl::AbstractDecl, x::DeclContext)
    @check_ptrs x decl
    return clang_Decl_setDeclContext(decl.ptr, x.ptr)
end

function set_lexcial_decl_context(decl::AbstractDecl, x::DeclContext)
    @check_ptrs x decl
    return clang_Decl_setLexicalDeclContext(decl.ptr, x.ptr)
end

function add_decl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDecl(x.ptr, decl.ptr)
end

function add_decl_internal(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDeclInternal(x.ptr, decl.ptr)
end

function add_hidden_decl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addHiddenDecl(x.ptr, decl.ptr)
end

function remove_decl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_removeDecl(x.ptr, decl.ptr)
end

function contains_decl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_containsDecl(x.ptr, decl.ptr)
end

function getBeginLoc(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getBeginLoc(x.ptr))
end

function getEndLoc(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getEndLoc(x.ptr))
end

# NamedDecl
function isOutOfLine(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isOutOfLine(x)
end

function get_identifier(x::AbstractNamedDecl)
    @check_ptrs x
    return IdentifierInfo(clang_NamedDecl_getIdentifier(x))
end

function get_name(x::AbstractNamedDecl)
    @check_ptrs x
    return unsafe_string(clang_NamedDecl_getName(x))
end

name(x::AbstractNamedDecl) = get_name(x)

function get_decl_name(x::AbstractNamedDecl)
    @check_ptrs x
    return DeclarationName(clang_NamedDecl_getDeclName(x))
end

function set_name(x::AbstractNamedDecl, name::DeclarationName)
    @check_ptrs x
    return clang_NamedDecl_setDeclName(x, name.ptr)
end

function has_linkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasLinkage(x)
end

function is_cxx_class_member(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isCXXClassMember(x)
end

function is_cxx_instance_member(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isCXXInstanceMember(x)
end

function has_external_formal_linkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasExternalFormalLinkage(x)
end

function is_externally_visible(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isExternallyVisible(x)
end

function is_externally_declarable(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isExternallyDeclarable(x)
end

function get_underlying_decl(x::AbstractNamedDecl)
    @check_ptrs x
    return NamedDecl(clang_NamedDecl_getUnderlyingDecl(x))
end

function get_most_recent_decl(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_getMostRecentDecl(x)
end

# ValueDecl
function get_type(x::AbstractValueDecl)
    @check_ptrs x
    return QualType(clang_ValueDecl_getType(x.ptr))
end

function set_type(x::AbstractValueDecl, ty::AbstractQualType)
    @check_ptrs x
    return clang_ValueDecl_getType(x.ptr, ty.ptr)
end

function is_weak(x::AbstractValueDecl)
    @check_ptrs x
    return clang_ValueDecl_isWeak(x.ptr)
end

function TemplateArgument(decl::ValueDecl, ty::AbstractQualType)
    @check_ptrs decl
    return TemplateArgument(clang_TemplateArgument_constructFromValueDecl(decl.ptr, ty.ptr))
end

function get_as_decl(x::TemplateArgument)
    @check_ptrs x
    return ValueDecl(clang_TemplateArgument_getAsDecl(x.ptr))
end

# TypeDecl
function get_type_for_decl(x::AbstractTypeDecl)::CXType_
    @check_ptrs x
    return clang_TypeDecl_getTypeForDecl(x.ptr)
end
get_type_for_decl(x::NamedDecl) = get_type_for_decl(TypeDecl(x))

function set_type_for_decl(x::AbstractTypeDecl, ty_ptr::CXType_)
    @check_ptrs x
    return clang_TypeDecl_setTypeForDecl(x.ptr, ty_ptr)
end
set_type_for_decl(x::AbstractTypeDecl, ty::AbstractQualType) = set_type_for_decl(x, get_type_ptr(ty))

function get_begin_loc(x::AbstractTypeDecl)
    @check_ptrs x
    return SourceLocation(clang_TypeDecl_getBeginLoc(x.ptr))
end

function set_loc_start(x::AbstractTypeDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_TypeDecl_setLocStart(x.ptr, loc.ptr)
end


# DeclarationName
function DeclarationName(x::IdentifierInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationName_createFromIdentifierInfo(x))
end

dump(x::DeclarationName) = clang_DeclarationName_dump(x)
isEmpty(x::DeclarationName) = clang_DeclarationName_isEmpty(x)




# IdentifierTable
function PrintStats(x::IdentifierTable)
    @check_ptrs x
    return clang_IdentifierTable_PrintStats(x)
end

function get(x::IdentifierTable, s::String)
    @check_ptrs x
    return IdentifierInfo(clang_IdentifierTable_get(x, s))
end


###

function TemplateArgument(ctx::ASTContext, v::GenericValue, ty::AbstractQualType)
    @check_ptrs ctx
    return TemplateArgument(clang_TemplateArgument_constructFromIntegral(ctx.ptr, v.ref,
                                                                         ty.ptr))
end

function TemplateArgumentList(ctx::ASTContext, args::Vector{CXTemplateArgument})
    @check_ptrs ctx
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
    @check_ptrs ctx dc template args
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
    @check_ptrs x
    return DeclContext(clang_TagDecl_castToDeclContext(x.ptr))
end

function TagDecl(x::DeclContext)
    @check_ptrs x
    return TagDecl(clang_DeclContext_castToTagDecl(x.ptr))
end

function RecordDecl(x::DeclContext)
    @check_ptrs x
    return RecordDecl(clang_DeclContext_castToRecordDecl(x.ptr))
end

function CXXRecordDecl(x::DeclContext)
    @check_ptrs x
    return CXXRecordDecl(clang_DeclContext_castToCXXRecordDecl(x.ptr))
end

function ClassTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_Decl_castToClassTemplateDecl(x.ptr))
end

function ValueDecl(x::AbstractDecl)
    @check_ptrs x
    return ValueDecl(clang_Decl_castToValueDecl(x.ptr))
end

function TypeDecl(x::NamedDecl)
    @check_ptrs x
    return TypeDecl(clang_NamedDecl_castToTypeDecl(x.ptr))
end
