# AST
"""
    expr_type_ptr(e::AbstractExpr) -> Type_

Return the type `e` was given, asserting that it was given one at all.

`Expr::getType` yields a null `QualType` for an unevaluated string literal — which is what
the parser builds for a `static_assert` message — and `QualType::getTypePtr` asserts rather
than returning null. A precondition that reaches for the type pointer of an arbitrary
expression must therefore rule the null out first; this is the one place that does it.
"""
function expr_type_ptr(e::AbstractExpr)
    qty = getType(e)
    @assert !isNull(qty) "an unevaluated string literal has no type"
    return getTypePtr(qty)
end

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
    return [getFieldOffset(layout, i) for i = 0:(getFieldCount(layout) - 1)]
end

is_derived_from(x::AbstractCXXRecordDecl, base::AbstractCXXRecordDecl) = isDerivedFrom(x, base)

# Linked chains
"""
    struct ChainIterator{T,F}
Iterate one of Clang's linked chains: yield `head`, then `step(head)`, and so on until the
handle is null.

Only for a `step` that **borrows**. Every element must already be owned by the AST, the
preprocessor or the scope stack, because nothing here disposes anything —
`clang_TypeLoc_getNextTypeLoc`, which allocates a fresh box per call, must not be driven
from this type.

The terminator is [`is_null_handle`](@ref) rather than a comparison against `C_NULL`, so a
chain over a value type whose handle packs bits alongside the pointer ends where Clang says
it ends.

The element type is left unknown because a chain may widen as it walks: Clang declares
`getMostRecentDecl` and `getPreviousDecl` on several levels of the hierarchy, so a
`FunctionDecl` enters `redecls` through the `NamedDecl` overload and continues through the
`Decl` one. Every element still carries a pointer whose dynamic class is at least the
declared carrier, so refining with a `castTo*` is sound.
"""
struct ChainIterator{T,F}
    head::T
    step::F
end

Base.IteratorSize(::Type{<:ChainIterator}) = Base.SizeUnknown()
Base.IteratorEltype(::Type{<:ChainIterator}) = Base.EltypeUnknown()

function Base.iterate(x::ChainIterator, state=x.head)
    is_null_handle(state) && return nothing
    return (state, x.step(state))
end

# DeclContext
"""
    struct DeclIterator <: Any
An iterator for traversing the declarations in a `DeclContext`.
See also `clang::DeclContext::decl_iterator`.

Yields every declaration, starting with the one `decls_begin` names.

Each element is resolved to its concrete carrier, so `d isa NamespaceDecl` works. That costs
one extra ccall per node to read the kind; [`decls`](@ref) gets the same resolution for free
because its bulk extraction returns the kinds alongside the nodes, and it recurses into
nested contexts where this walks only the direct children.
"""
struct DeclIterator{T<:AbstractDecl}
    decl::T
end

Base.IteratorSize(::Type{<:DeclIterator}) = Base.SizeUnknown()
Base.eltype(::Type{<:DeclIterator}) = AbstractDecl

function Base.iterate(x::DeclIterator, state=decl_iterator_begin(castToDeclContext(x.decl)))
    is_null_handle(state) && return nothing
    # advance on the raw handle, yield the resolved carrier: `getNextDeclInContext` is
    # declared on Decl, and resolving is what makes an `isa` test against a concrete class
    # mean anything
    return (resolve(state), getNextDeclInContext(state))
end

"""
    decls_in(x::DeclContext)
Iterate the declarations `x` holds directly, without descending into nested contexts.

Elements are resolved to their concrete carriers, so `d isa NamespaceDecl` works. Use
`ChainIterator(decl_iterator_begin(x), getNextDeclInContext)` directly for the unresolved
walk when the extra ccall per node matters and the kind does not.
"""
decls_in(x::DeclContext) = Iterators.map(resolve, ChainIterator(decl_iterator_begin(x), getNextDeclInContext))

"""
    redecls(x::AbstractDecl) -> ChainIterator
Iterate `x`'s redeclaration chain from the most recent declaration back to the first.

A declaration split across a forward declaration and a definition appears once per
declaration; `getMostRecentDecl` and `getPreviousDecl` are the ends Clang exposes.
"""
redecls(x::AbstractDecl) = Iterators.map(resolve, ChainIterator(getMostRecentDecl(x), getPreviousDecl))

"""
    qualifiers(x::AbstractNestedNameSpecifier) -> ChainIterator
Iterate a nested-name-specifier outward: for `A::B::C`, `C` then `B` then `A`.
"""
qualifiers(x::AbstractNestedNameSpecifier) = ChainIterator(x, getPrefix)

"""
    parents(x::DeclContext) -> ChainIterator
Iterate `x`'s semantic parent contexts, outward to the translation unit.
"""
parents(x::DeclContext) = ChainIterator(getParent(x), getParent)

"""
    lexical_parents(x::DeclContext) -> ChainIterator
Iterate `x`'s lexical parent contexts, outward to the translation unit. This differs from
[`parents`](@ref) for anything written outside the context it belongs to -- an out-of-line
member definition is lexically in the namespace and semantically in the class.
"""
lexical_parents(x::DeclContext) = ChainIterator(getLexicalParent(x), getLexicalParent)
