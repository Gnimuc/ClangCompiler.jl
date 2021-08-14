"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

"""
    struct Decl <: AbstractDecl
Hold a pointer to a `clang::Decl` object.
"""
struct Decl <: AbstractDecl
    ptr::CXDecl
end

function dump(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_dumpColor(x.ptr)
end

function is_out_of_line(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isOutOfLine(x.ptr)
end

function get_location(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return SourceLocation(clang_Decl_getLocation(x.ptr))
end

function get_begin_loc(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return SourceLocation(clang_Decl_getBeginLoc(x.ptr))
end

function get_end_loc(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return SourceLocation(clang_Decl_getEndLoc(x.ptr))
end

function get_decl_kind_name(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return unsafe_string(clang_Decl_getDeclKindName(x.ptr))
end

function get_next_decl_in_context(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return Decl(clang_Decl_getNextDeclInContext(x.ptr))
end

function get_decl_context(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return DeclContext(clang_Decl_getDeclContext(x.ptr))
end

function get_non_closure_context(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return Decl(clang_Decl_getNonClosureContext(x.ptr))
end

function is_in_anonymous_namespace(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isInAnonymousNamespace(x.ptr)
end

function is_in_std_namespace(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isInStdNamespace(x.ptr)
end

function get_lang_options(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return LangOptions(clang_Decl_getLangOpts(x.ptr))
end

function get_lexical_decl_context(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return DeclContext(clang_Decl_getLexicalDeclContext(x.ptr))
end

function is_templated(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isTemplated(x.ptr)
end

function is_canonical(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isCanonicalDecl(x.ptr)
end

function get_previous_decl(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return Decl(clang_Decl_getPreviousDecl(x.ptr))
end

function is_first_decl(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isFirstDecl(x.ptr)
end

function get_most_recent_decl(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return Decl(clang_Decl_getMostRecentDecl(x.ptr))
end

function is_template_parameter(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isTemplateParameter(x.ptr)
end

function is_template_decl(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_isTemplateDecl(x.ptr)
end

function get_described_template(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return TemplateDecl(clang_Decl_getDescribedTemplate(x.ptr))
end

function set_decl_context(decl::AbstractDecl, x::DeclContext)
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    return clang_Decl_setDeclContext(decl.ptr, x.ptr)
end

function set_lexcial_decl_context(decl::AbstractDecl, x::DeclContext)
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    return clang_Decl_setLexicalDeclContext(decl.ptr, x.ptr)
end

function add_decl(x::DeclContext, decl::AbstractDecl)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    return clang_DeclContext_addDecl(x.ptr, decl.ptr)
end

function add_decl_internal(x::DeclContext, decl::AbstractDecl)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    return clang_DeclContext_addDeclInternal(x.ptr, decl.ptr)
end

function add_hidden_decl(x::DeclContext, decl::AbstractDecl)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    return clang_DeclContext_addHiddenDecl(x.ptr, decl.ptr)
end

function remove_decl(x::DeclContext, decl::AbstractDecl)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    return clang_DeclContext_removeDecl(x.ptr, decl.ptr)
end

function contains_decl(x::DeclContext, decl::AbstractDecl)
    @assert x.ptr != C_NULL "DeclContext has a NULL pointer."
    @assert decl.ptr != C_NULL "Decl has a NULL pointer."
    return clang_DeclContext_containsDecl(x.ptr, decl.ptr)
end

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

"""
    struct NamedDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamedDecl` object.
"""
struct NamedDecl <: AbstractNamedDecl
    ptr::CXNamedDecl
end

function is_out_of_line(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_isOutOfLine(x.ptr)
end

function get_identifier(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return IdentifierInfo(clang_NamedDecl_getIdentifier(x.ptr))
end

function get_name(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return unsafe_string(clang_NamedDecl_getName(x.ptr))
end

name(x::AbstractNamedDecl) = get_name(x)

function set_name(x::AbstractNamedDecl, name::DeclarationName)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_setDeclName(x.ptr, name.ptr)
end

function has_linkage(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_hasLinkage(x.ptr)
end

function is_cxx_class_member(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_isCXXClassMember(x.ptr)
end

function is_cxx_instance_member(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_isCXXInstanceMember(x.ptr)
end

function has_external_formal_linkage(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_hasExternalFormalLinkage(x.ptr)
end

function is_externally_visible(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_isExternallyVisible(x.ptr)
end

function is_externally_declarable(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_isExternallyDeclarable(x.ptr)
end

function get_underlying_decl(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return NamedDecl(clang_NamedDecl_getUnderlyingDecl(x.ptr))
end

function get_most_recent_decl(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return clang_NamedDecl_getMostRecentDecl(x.ptr)
end

"""
    abstract type AbstractValueDecl <: AbstractNamedDecl
Supertype for `ValueDecl`s.
"""
abstract type AbstractValueDecl <: AbstractNamedDecl end

"""
    struct ValueDecl <: AbstractValueDecl
Hold a pointer to a `clang::ValueDecl` object.
"""
struct ValueDecl <: AbstractValueDecl
    ptr::CXValueDecl
end

function get_type(x::AbstractValueDecl)
    @assert x.ptr != C_NULL "ValueDecl has a NULL pointer."
    return QualType(clang_ValueDecl_getType(x.ptr))
end

function set_type(x::AbstractValueDecl, ty::AbstractQualType)
    @assert x.ptr != C_NULL "ValueDecl has a NULL pointer."
    return clang_ValueDecl_getType(x.ptr, ty.ptr)
end

function is_weak(x::AbstractValueDecl)
    @assert x.ptr != C_NULL "ValueDecl has a NULL pointer."
    return clang_ValueDecl_isWeak(x.ptr)
end

function TemplateArgument(decl::ValueDecl, ty::AbstractQualType)
    @assert decl.ptr != C_NULL "ValueDecl has a NULL pointer."
    return TemplateArgument(clang_TemplateArgument_constructFromValueDecl(decl.ptr, ty.ptr))
end

function get_as_decl(x::TemplateArgument)
    @assert x.ptr != C_NULL "TemplateArgument has a NULL pointer."
    return ValueDecl(clang_TemplateArgument_getAsDecl(x.ptr))
end

"""
    abstract type AbstractTagDecl <: AbstractNamedDecl
Supertype for `TypeDecl`s.
"""
abstract type AbstractTypeDecl <: AbstractNamedDecl end

"""
    struct TypeDecl <: AbstractTypeDecl
Hold a pointer to a `clang::TypeDecl` object.
"""
struct TypeDecl <: AbstractTypeDecl
    ptr::CXTypeDecl
end

function get_type_for_decl(x::AbstractTypeDecl)::CXType_
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return clang_TypeDecl_getTypeForDecl(x.ptr)
end
get_type_for_decl(x::NamedDecl) = get_type_for_decl(TypeDecl(x))

function set_type_for_decl(x::AbstractTypeDecl, ty_ptr::CXType_)
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return clang_TypeDecl_setTypeForDecl(x.ptr, ty_ptr)
end
set_type_for_decl(x::AbstractTypeDecl, ty::AbstractQualType) = set_type_for_decl(x, get_type_ptr(ty))

function get_begin_loc(x::AbstractTypeDecl)
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return SourceLocation(clang_TypeDecl_getBeginLoc(x.ptr))
end

function set_loc_start(x::AbstractTypeDecl, loc::SourceLocation)
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return clang_TypeDecl_setLocStart(x.ptr, loc.ptr)
end

"""
    abstract type AbstractTypedefNameDecl <: AbstractTypeDecl
Supertype for `TypedefNameDecl`s.
"""
abstract type AbstractTypedefNameDecl <: AbstractTypeDecl end

"""
    struct TypedefNameDecl <: AbstractTypedefNameDecl
Hold a pointer to a `clang::TypedefNameDecl` object.
"""
struct TypedefNameDecl <: AbstractTypedefNameDecl
    ptr::CXTypedefNameDecl
end

function get_underlying_type(x::AbstractTypedefNameDecl)
    @assert x.ptr != C_NULL "TypedefNameDecl has a NULL pointer."
    return QualType(clang_TypedefNameDecl_getUnderlyingType(x.ptr))
end

function get_canonical_decl(x::AbstractTypedefNameDecl)
    @assert x.ptr != C_NULL "TypedefNameDecl has a NULL pointer."
    return TypedefNameDecl(clang_TypedefNameDecl_getCanonicalDecl(x.ptr))
end

function get_anonymous_decl_with_typedef_name(x::AbstractTypedefNameDecl,
                                              any_redecl::Bool=false)
    @assert x.ptr != C_NULL "TypedefNameDecl has a NULL pointer."
    return TagDecl(clang_TypedefNameDecl_getAnonDeclWithTypedefName(x.ptr, any_redecl))
end

function is_transparent_tag(x::AbstractTypedefNameDecl, any_redecl::Bool=false)
    @assert x.ptr != C_NULL "TypedefNameDecl has a NULL pointer."
    return clang_TypedefNameDecl_isTransparentTag(x.ptr)
end

"""
    abstract type AbstractTagDecl <: AbstractTypeDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractTypeDecl end

"""
    struct TagDecl <: AbstractTagDecl
Hold a pointer to a `clang::TagDecl` object.
"""
struct TagDecl <: AbstractTagDecl
    ptr::CXTagDecl
end

function get_canonical_decl(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TagDecl(clang_TagDecl_getCanonicalDecl(x.ptr))
end

function is_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isThisDeclarationADefinition(x.ptr)
end

function is_complete_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isCompleteDefinition(x.ptr)
end

function set_complete_definition(x::AbstractTagDecl, v::Bool)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_setCompleteDefinition(x.ptr, v)
end

function is_being_defined(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isBeingDefined(x.ptr)
end

function is_free_standing(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isFreeStanding(x.ptr)
end

function start_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_startDefinition(x.ptr)
end

function get_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TagDecl(clang_TagDecl_getDefinition(x.ptr))
end

function get_kind_name(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return unsafe_string(clang_TagDecl_getKindName(x.ptr))
end

function get_tag_kind(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_getTagKind(x.ptr)
end

function is_struct(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isStruct(x.ptr)
end

function is_interface(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isInterface(x.ptr)
end

function is_class(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isClass(x.ptr)
end

function is_union(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isUnion(x.ptr)
end

function is_enum(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_isEnum(x.ptr)
end

function has_name_for_linkage(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TagDecl_hasNameForLinkage(x.ptr)
end

function get_typedef_name_for_anonymous_decl(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TypedefNameDecl(clang_TagDecl_getTypedefNameForAnonDecl(x.ptr))
end

function get_qualifier(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return NestedNameSpecifier(clang_TagDecl_getQualifier(x.ptr))
end

"""
    struct EnumDecl <: AbstractTagDecl
Hold a pointer to a `clang::EnumDecl` object.
"""
struct EnumDecl <: AbstractTagDecl
    ptr::CXEnumDecl
end

function get_canonical_decl(x::EnumDecl)
    @assert x.ptr != C_NULL "EnumDecl has a NULL pointer."
    return EnumDecl(clang_EnumDecl_getCanonicalDecl(x.ptr))
end

function get_previous_decl(x::EnumDecl)
    @assert x.ptr != C_NULL "EnumDecl has a NULL pointer."
    return EnumDecl(clang_EnumDecl_getPreviousDecl(x.ptr))
end

function get_most_recent_decl(x::EnumDecl)
    @assert x.ptr != C_NULL "EnumDecl has a NULL pointer."
    return EnumDecl(clang_EnumDecl_getMostRecentDecl(x.ptr))
end

function get_definition(x::EnumDecl)
    @assert x.ptr != C_NULL "EnumDecl has a NULL pointer."
    return EnumDecl(clang_EnumDecl_getDefinition(x.ptr))
end

function get_integer_type(x::EnumDecl)
    @assert x.ptr != C_NULL "EnumDecl has a NULL pointer."
    return QualType(clang_EnumDecl_getIntegerType(x.ptr))
end

function get_decl(x::EnumType)
    @assert x.ptr != C_NULL "EnumType has a NULL pointer."
    return EnumDecl(clang_EnumType_getDecl(x.ptr))
end

"""
    abstract type AbstractRecordDecl <: AbstractTagDecl
Supertype for `RecordDecl`s.
"""
abstract type AbstractRecordDecl <: AbstractTagDecl end

"""
    struct RecordDecl <: AbstractRecordDecl
Hold a pointer to a `clang::RecordDecl` object.
"""
struct RecordDecl <: AbstractRecordDecl
    ptr::CXRecordDecl
end

function get_previous_decl(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return RecordDecl(clang_RecordDecl_getPreviousDecl(x.ptr))
end

function get_most_recent_decl(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return RecordDecl(clang_RecordDecl_getMostRecentDecl(x.ptr))
end

function has_flexible_array_member(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return clang_RecordDecl_hasFlexibleArrayMember(x.ptr)
end

function is_anonymous_struct_or_union(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return clang_RecordDecl_isAnonymousStructOrUnion(x.ptr)
end

function is_injected_class_name(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return clang_RecordDecl_isInjectedClassName(x.ptr)
end

function is_lambda(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return clang_RecordDecl_isLambda(x.ptr)
end

function is_captured_record(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return clang_RecordDecl_isCapturedRecord(x.ptr)
end

function get_definition(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return RecordDecl(clang_RecordDecl_getDefinition(x.ptr))
end

function is_or_contains_union(x::AbstractRecordDecl)
    @assert x.ptr != C_NULL "RecordDecl has a NULL pointer."
    return clang_RecordDecl_isOrContainsUnion(x.ptr)
end
