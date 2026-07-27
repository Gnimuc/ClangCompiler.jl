# AST
"""
    get_identifier_table(x::ASTContext)
Return the [`IdentifierTable`](@ref) in the [`ASTContext`](@ref).
"""
get_identifier_table(x::ASTContext) = getIdents(x)

get_name(x::ASTContext, s::String) = get(getIdents(x), s)

function get_builtin_type(ctx::ASTContext, ::Type{T}) where {T<:AbstractBuiltinType}
    @check_ptrs ctx
    return T(ctx)
end

get_decl_type(x::ASTContext, decl) = getTypeDeclType(x, decl)
get_decl_type(x::ASTContext, decl, prev) = getTypeDeclType(x, decl, prev)

get_pointer_type(x::ASTContext, ty::QualType) = getPointerType(x, ty)
get_lvalue_reference_type(x::ASTContext, ty::QualType) = getLValueReferenceType(x, ty)

# Decl
get_ast_context(x::AbstractDecl) = getASTContext(x)
get_ast_context(x::DeclContext) = getParentASTContext(x)

get_name(x::AbstractNamedDecl) = getName(x)
get_name(x::DeclarationName) = getAsString(x)

get_begin_loc(x::AbstractDecl) = getBeginLoc(x)
get_end_loc(x::AbstractDecl) = getEndLoc(x)
get_loc(x::AbstractDecl) = getLocation(x)

is_empty(x::DeclarationName) = isEmpty(x)
get_string(x::DeclarationName) = getAsString(x)

dump(x::CXXScopeSpec) = dump(getScopeRep(x))

size_of(x::ASTContext, ty::QualType)::Int = getSizeOf(x, ty)

# record layout
get_record_layout(x::ASTContext, decl::AbstractRecordDecl) = getASTRecordLayout(x, decl)

"""
    field_offsets(x::ASTContext, decl::AbstractRecordDecl) -> Vector{UInt64}
Return the offset of each field of the record in **bits**, in declaration order.
"""
function field_offsets(x::ASTContext, decl::AbstractRecordDecl)
    layout = get_record_layout(x, decl)
    return [getFieldOffset(layout, i) for i in 0:(getFieldCount(layout) - 1)]
end

is_derived_from(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl) = isDerivedFrom(x, base)

# DeclContext
"""
    struct DeclIterator <: Any
An iterator for traversing the declarations in a `DeclContext`.
See also `clang::DeclContext::decl_iterator`.
"""
struct DeclIterator{T<:AbstractDecl}
    decl::T
end

function Base.iterate(x::DeclIterator, state=decl_iterator_begin(castToDeclContext(x.decl)))
    state.ptr == C_NULL && return nothing
    next_decl = getNextDeclInContext(state)
    next_decl.ptr == C_NULL && return nothing
    return (next_decl, next_decl)
end
