"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

Base.unsafe_convert(::Type{CXDecl}, x::T) where {T<:AbstractDecl} = x.ptr
Base.cconvert(::Type{CXDecl}, x::T) where {T<:AbstractDecl} = x

"""
    struct Decl <: AbstractDecl
Hold a pointer to a `clang::Decl` object.
"""
struct Decl <: AbstractDecl
    ptr::CXDecl
end

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

Base.unsafe_convert(::Type{CXNamedDecl}, x::T) where {T<:AbstractNamedDecl} = x.ptr
Base.cconvert(::Type{CXNamedDecl}, x::T) where {T<:AbstractNamedDecl} = x

"""
    struct NamedDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamedDecl` object.
"""
struct NamedDecl <: AbstractNamedDecl
    ptr::CXNamedDecl
end

"""
    abstract type AbstractValueDecl <: AbstractNamedDecl
Supertype for `ValueDecl`s.
"""
abstract type AbstractValueDecl <: AbstractNamedDecl end

Base.unsafe_convert(::Type{CXValueDecl}, x::T) where {T<:AbstractValueDecl} = x.ptr
Base.cconvert(::Type{CXValueDecl}, x::T) where {T<:AbstractValueDecl} = x

"""
    struct ValueDecl <: AbstractValueDecl
Hold a pointer to a `clang::ValueDecl` object.
"""
struct ValueDecl <: AbstractValueDecl
    ptr::CXValueDecl
end

"""
    abstract type AbstractTagDecl <: AbstractNamedDecl
Supertype for `TypeDecl`s.
"""
abstract type AbstractTypeDecl <: AbstractNamedDecl end

Base.unsafe_convert(::Type{CXTypeDecl}, x::T) where {T<:AbstractTypeDecl} = x.ptr
Base.cconvert(::Type{CXTypeDecl}, x::T) where {T<:AbstractTypeDecl} = x

"""
    struct TypeDecl <: AbstractTypeDecl
Hold a pointer to a `clang::TypeDecl` object.
"""
struct TypeDecl <: AbstractTypeDecl
    ptr::CXTypeDecl
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
    @check_ptrs x
    return QualType(clang_TypedefNameDecl_getUnderlyingType(x.ptr))
end

function get_canonical_decl(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_TypedefNameDecl_getCanonicalDecl(x.ptr))
end

function get_anonymous_decl_with_typedef_name(x::AbstractTypedefNameDecl,
                                              any_redecl::Bool=false)
    @check_ptrs x
    return TagDecl(clang_TypedefNameDecl_getAnonDeclWithTypedefName(x.ptr, any_redecl))
end

function is_transparent_tag(x::AbstractTypedefNameDecl, any_redecl::Bool=false)
    @check_ptrs x
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
    @check_ptrs x
    return TagDecl(clang_TagDecl_getCanonicalDecl(x.ptr))
end

function is_definition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isThisDeclarationADefinition(x.ptr)
end

function is_complete_definition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isCompleteDefinition(x.ptr)
end

function set_complete_definition(x::AbstractTagDecl, v::Bool)
    @check_ptrs x
    return clang_TagDecl_setCompleteDefinition(x.ptr, v)
end

function is_being_defined(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isBeingDefined(x.ptr)
end

function is_free_standing(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isFreeStanding(x.ptr)
end

function start_definition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_startDefinition(x.ptr)
end

function get_definition(x::AbstractTagDecl)
    @check_ptrs x
    return TagDecl(clang_TagDecl_getDefinition(x.ptr))
end

function get_kind_name(x::AbstractTagDecl)
    @check_ptrs x
    return unsafe_string(clang_TagDecl_getKindName(x.ptr))
end

function get_tag_kind(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_getTagKind(x.ptr)
end

function is_struct(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isStruct(x.ptr)
end

function is_interface(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isInterface(x.ptr)
end

function is_class(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isClass(x.ptr)
end

function is_union(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isUnion(x.ptr)
end

function is_enum(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isEnum(x.ptr)
end

function has_name_for_linkage(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_hasNameForLinkage(x.ptr)
end

function get_typedef_name_for_anonymous_decl(x::AbstractTagDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_TagDecl_getTypedefNameForAnonDecl(x.ptr))
end

function get_qualifier(x::AbstractTagDecl)
    @check_ptrs x
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
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getCanonicalDecl(x.ptr))
end

function get_previous_decl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getPreviousDecl(x.ptr))
end

function get_most_recent_decl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getMostRecentDecl(x.ptr))
end

function get_definition(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getDefinition(x.ptr))
end

function get_integer_type(x::EnumDecl)
    @check_ptrs x
    return QualType(clang_EnumDecl_getIntegerType(x.ptr))
end

get_decl(x::EnumType) = EnumDecl(clang_EnumType_getDecl(get_type_ptr(x)))

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
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getPreviousDecl(x.ptr))
end

function get_most_recent_decl(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getMostRecentDecl(x.ptr))
end

function has_flexible_array_member(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasFlexibleArrayMember(x.ptr)
end

function is_anonymous_struct_or_union(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isAnonymousStructOrUnion(x.ptr)
end

function is_injected_class_name(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isInjectedClassName(x.ptr)
end

function is_lambda(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isLambda(x.ptr)
end

function is_captured_record(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isCapturedRecord(x.ptr)
end

function get_definition(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getDefinition(x.ptr))
end

function is_or_contains_union(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isOrContainsUnion(x.ptr)
end
