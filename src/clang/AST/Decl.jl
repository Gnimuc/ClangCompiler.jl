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
    struct NamedDecl <: AbstractNamedDecl
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
Supertype for `TypeDecl`s.
"""
abstract type AbstractTypeDecl <: AbstractNamedDecl end

"""
    struct TypeDecl <: AbstractTypeDecl
Holds a pointer to a `clang::TypeDecl` object.
"""
struct TypeDecl <: AbstractTypeDecl
    ptr::CXTypeDecl
end

function get_type_for_decl(x::AbstractTypeDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return QualType(clang_TypeDecl_getTypeForDecl(x.ptr))
end

function set_type_for_decl(x::AbstractTypeDecl, ty::QualType)
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return clang_TypeDecl_setTypeForDecl(x.ptr, ty.ptr)
end

function get_begin_loc(x::AbstractTypeDecl)
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return SourceLocation(clang_TypeDecl_getBeginLoc(x.ptr))
end

function set_loc_start(x::AbstractTypeDecl, loc::SourceLocation)
    @assert x.ptr != C_NULL "TypeDecl has a NULL pointer."
    return clang_TypeDecl_setLocStart(x.ptr, loc.ptr)
end

"""
    abstract type AbstractTagDecl <: AbstractTypeDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractTypeDecl end

"""
    struct TagDecl <: AbstractTagDecl
Holds a pointer to a `clang::TagDecl` object.
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

function get_qualifier(x::AbstractTagDecl)
    @assert x.ptr != C_NULL "TagDecl has a NULL pointer."
    return NestedNameSpecifier(clang_TagDecl_getQualifier(x.ptr))
end

"""
    abstract type AbstractRecordDecl <: AbstractTagDecl
Supertype for `RecordDecl`s.
"""
abstract type AbstractRecordDecl <: AbstractTagDecl end

"""
    struct RecordDecl <: AbstractRecordDecl
Holds a pointer to a `clang::RecordDecl` object.
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
