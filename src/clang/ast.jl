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

get_pointer_type(x::ASTContext, ty::AbstractQualType) = getPointerType(x, ty)
get_lvalue_reference_type(x::ASTContext, ty::AbstractQualType) = getLValueReferenceType(x, ty)

# Decl
get_ast_context(x::AbstractDecl) = getASTContext(x)
get_ast_context(x::DeclContext) = getParentASTContext(x)

get_name(x::AbstractNamedDecl) = getName(x)
get_name(x::DeclarationName) = getAsString(x)

get_begin_loc(x::AbstractDecl) = getBeginLoc(x)
get_end_loc(x::AbstractDecl) = getEndLoc(x)
get_loc(x::AbstractDecl) = getLocation(x)

dump(x::AbstractDecl) = dumpColor(x)

Base.isempty(x::DeclarationName) = isEmpty(x)
Base.string(x::DeclarationName) = get_as_string(x)

dump(x::CXXScopeSpec) = dump(getScopeRep(x))

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
