"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

"""
    struct Decl <: AbstractDecl
Holds a pointer to a `clang::Decl` object.
"""
struct Decl <: AbstractDecl
    ptr::CXDecl
end

function dump(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return clang_Decl_dumpColor(x.ptr)
end

function get_location(x::AbstractDecl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return SourceLocation(clang_Decl_getLocation(x.ptr))
end

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

"""
    struct NamedDecl <: AbstractDecl
Holds a pointer to a `clang::NamedDecl` object.
"""
struct NamedDecl <: AbstractNamedDecl
    ptr::CXNamedDecl
end

function get_identifier(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return IdentifierInfo(clang_NamedDecl_getIdentifier(x.ptr))
end

function name(x::AbstractNamedDecl)
    @assert x.ptr != C_NULL "NamedDecl has a NULL pointer."
    return unsafe_string(clang_NamedDecl_getName(x.ptr))
end

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
    abstract type AbstractTagDecl <: AbstractNamedDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractNamedDecl end

"""
    struct TagDecl <: AbstractNamedDecl
Holds a pointer to a `clang::TagDecl` object.
"""
struct TagDecl <: AbstractNamedDecl
    ptr::CXTagDecl
end

function get_type_for_decl(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return QualType(clang_TypeDecl_getTypeForDecl(x.ptr))
end

function set_type_for_decl(x::AbstractTagDecl, ty::QualType)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_setTypeForDecl(x.ptr, ty.ptr)
end

function get_begin_loc(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return SourceLocation(clang_TypeDecl_getBeginLoc(x.ptr))
end

function set_loc_start(x::AbstractTagDecl, loc::SourceLocation)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_setLocStart(x.ptr, loc.ptr)
end

function get_canonical_decl(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TagDecl(clang_TypeDecl_getCanonicalDecl(x.ptr))
end

function is_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isThisDeclarationADefinition(x.ptr)
end

function is_complete_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isCompleteDefinition(x.ptr)
end

function set_complete_definition(x::AbstractTagDecl, v::Bool)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_setCompleteDefinition(x.ptr, v)
end

function is_being_defined(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isBeingDefined(x.ptr)
end

function is_free_standing(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isFreeStanding(x.ptr)
end

function start_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_startDefinition(x.ptr)
end

function get_definition(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TagDecl(clang_TypeDecl_getDefinition(x.ptr))
end

function get_kind_name(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return unsafe_string(clang_TypeDecl_getKindName(x.ptr))
end

function is_struct(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isStruct(x.ptr)
end

function is_interface(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isInterface(x.ptr)
end

function is_class(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isClass(x.ptr)
end

function is_union(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isUnion(x.ptr)
end

function is_enum(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_isEnum(x.ptr)
end

function has_name_for_linkage(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_hasNameForLinkage(x.ptr)
end

function get_qualifier(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return NestedNameSpecifier(clang_TypeDecl_getQualifier(x.ptr))
end

function get_num_template_parameter_lists(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return clang_TypeDecl_getNumTemplateParameterLists(x.ptr)
end

function get_template_parameter_list(x::AbstractTagDecl, i::Integer)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return TemplateParameterList(clang_TypeDecl_getTemplateParameterList(x.ptr, i))
end

function get_param(x::TemplateParameterList, i::Integer)
    @assert x.ptr != C_NULL "TemplateParameterList has a NULL pointer."
    return NamedDecl(clang_TemplateParameterList_getParam(x.ptr, i))
end
