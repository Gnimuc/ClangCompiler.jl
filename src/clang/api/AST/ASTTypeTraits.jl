# ASTTypeTraits
#
# `clang::DynTypedNode` is the one container that holds any AST node with a runtime tag saying
# which — and it is what `ASTContext::getParents` actually answers with. The parent accessors
# in `api/AST/ASTContext.jl` that split on Stmt-versus-Decl therefore have a blind spot: a
# type, a type location or a nested-name-specifier parent is answered as NULL by both, because
# those kinds live *inside* the node and the list the node came from is a temporary. A
# `DynTypedNode` is an owned copy, which removes the trap — and costs a `dispose`.

"""
    DynTypedNode(node) -> DynTypedNode
Box `node` — a `Stmt`, a `Decl`, a `Type_`, a `QualType`, a `TypeLoc`, a
`NestedNameSpecifier`, a `NestedNameSpecifierLoc` or an `Attr` — as a dynamically typed node.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function DynTypedNode(s::AbstractStmt)
    @check_ptrs s
    return DynTypedNode(clang_DynTypedNode_createFromStmt(s))
end

function DynTypedNode(d::AbstractDecl)
    @check_ptrs d
    return DynTypedNode(clang_DynTypedNode_createFromDecl(d))
end

function DynTypedNode(t::AbstractType)
    @check_ptrs t
    return DynTypedNode(clang_DynTypedNode_createFromType(t))
end

function DynTypedNode(t::QualType)
    @check_ptrs t
    return DynTypedNode(clang_DynTypedNode_createFromQualType(t))
end

function DynTypedNode(tl::AnyTypeLoc)
    @check_ptrs tl
    return DynTypedNode(clang_DynTypedNode_createFromTypeLoc(tl))
end

function DynTypedNode(nns::AbstractNestedNameSpecifier)
    @check_ptrs nns
    return DynTypedNode(clang_DynTypedNode_createFromNestedNameSpecifier(nns))
end

function DynTypedNode(nnsl::AbstractNestedNameSpecifierLoc)
    @check_ptrs nnsl
    return DynTypedNode(clang_DynTypedNode_createFromNestedNameSpecifierLoc(nnsl))
end

function DynTypedNode(a::AbstractAttr)
    @check_ptrs a
    return DynTypedNode(clang_DynTypedNode_createFromAttr(a))
end

dispose(x::DynTypedNode) = clang_DynTypedNode_dispose(x)

"""
    getNodeKindName(x::AbstractDynTypedNode) -> String
The name clang prints for the node's kind — `"IfStmt"`, `"QualType"`, `"PointerTypeLoc"` —
and `"<None>"` for the empty kind.

The kind is not mirrored as an enum: `clang::ASTNodeKind` keeps its identifiers private and
stamps them from five generated tables, so the printed name is the only stable spelling.
Discriminate with the `getAs*` family instead; this is for reporting.
"""
function getNodeKindName(x::AbstractDynTypedNode)
    @check_ptrs x
    return get_string(clang_DynTypedNode_getNodeKindName(x))
end

function isNodeKindNone(x::AbstractDynTypedNode)
    @check_ptrs x
    return clang_DynTypedNode_isNodeKindNone(x)
end

"""
    nodeKindHasPointerIdentity(x::AbstractDynTypedNode) -> Bool
Whether the node's kind is one whose value is a pointer into the AST rather than a value
copied into the node — the same split that decides whether [`getMemoizationData`](@ref)
answers.
"""
function nodeKindHasPointerIdentity(x::AbstractDynTypedNode)
    @check_ptrs x
    return clang_DynTypedNode_nodeKindHasPointerIdentity(x)
end

"""
    isNodeKindSame(a::AbstractDynTypedNode, b::AbstractDynTypedNode) -> Bool
Whether the two nodes have exactly the same kind. Never true when either kind is none.
"""
function isNodeKindSame(a::AbstractDynTypedNode, b::AbstractDynTypedNode)
    @check_ptrs a b
    return clang_DynTypedNode_isNodeKindSame(a, b)
end

"""
    isNodeKindBaseOf(base::AbstractDynTypedNode, derived::AbstractDynTypedNode) -> Bool
Whether `base`'s kind is the same as, or a base class of, `derived`'s — how to ask "is this
parent some kind of declaration?" without naming every subclass.
"""
function isNodeKindBaseOf(base::AbstractDynTypedNode, derived::AbstractDynTypedNode)
    @check_ptrs base derived
    return clang_DynTypedNode_isNodeKindBaseOf(base, derived)
end

"""
    getAsStmt(x::AbstractDynTypedNode) -> Stmt
The node as a statement, or a NULL carrier when it holds something else.

The `getAs*` family is the discrimination: at most one of them answers non-NULL for a given
node, and each answers for a whole hierarchy — an `IfStmt` node answers this one. The
pointer-identity kinds below hand back borrowed AST-arena pointers.
"""
function getAsStmt(x::AbstractDynTypedNode)
    @check_ptrs x
    return Stmt(clang_DynTypedNode_getAsStmt(x))
end

function getAsDecl(x::AbstractDynTypedNode)
    @check_ptrs x
    return Decl(clang_DynTypedNode_getAsDecl(x))
end

function getAsType(x::AbstractDynTypedNode)
    @check_ptrs x
    return Type_(clang_DynTypedNode_getAsType(x))
end

function getAsNestedNameSpecifier(x::AbstractDynTypedNode)
    @check_ptrs x
    return NestedNameSpecifier(clang_DynTypedNode_getAsNestedNameSpecifier(x))
end

function getAsAttr(x::AbstractDynTypedNode)
    @check_ptrs x
    return Attr(clang_DynTypedNode_getAsAttr(x))
end

function getAsCXXCtorInitializer(x::AbstractDynTypedNode)
    @check_ptrs x
    return CXXCtorInitializer(clang_DynTypedNode_getAsCXXCtorInitializer(x))
end

function getAsCXXBaseSpecifier(x::AbstractDynTypedNode)
    @check_ptrs x
    return CXXBaseSpecifier(clang_DynTypedNode_getAsCXXBaseSpecifier(x))
end

"""
    getAsQualType(x::AbstractDynTypedNode) -> QualType
The node as a qualified type. A `QualType` crosses as its own encoding, so this is a copy and
needs no lifetime caveat; the NULL carrier means both "not a type node" and "a node holding a
null type".
"""
function getAsQualType(x::AbstractDynTypedNode)
    @check_ptrs x
    return QualType(clang_DynTypedNode_getAsQualType(x))
end

"""
    getAsTypeLoc(x::AbstractDynTypedNode) -> TypeLoc
The node as a type location, copied out of `x` into its own box, or a NULL carrier when the
node holds something else.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getAsTypeLoc(x::AbstractDynTypedNode)
    @check_ptrs x
    return TypeLoc(clang_DynTypedNode_getAsTypeLoc(x))
end

"""
    getAsNestedNameSpecifierLoc(x::AbstractDynTypedNode) -> NestedNameSpecifierLoc
The node as a nested-name-specifier location, copied out of `x` into its own box, or a NULL
carrier when the node holds something else.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getAsNestedNameSpecifierLoc(x::AbstractDynTypedNode)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_DynTypedNode_getAsNestedNameSpecifierLoc(x))
end

"""
    getAsTemplateArgument(x::AbstractDynTypedNode) -> TemplateArgument
The node as a template argument, or a NULL carrier.

The exception in the family: a template argument has no box-and-dispose carrier of its own, so
the result points *into* `x` and dies with it.
"""
function getAsTemplateArgument(x::AbstractDynTypedNode)
    @check_ptrs x
    return TemplateArgument(clang_DynTypedNode_getAsTemplateArgument(x))
end

"""
    getMemoizationData(x::AbstractDynTypedNode) -> Ptr{Cvoid}
The address that identifies the node, or `C_NULL` for a kind stored by value. Two nodes of the
same kind name the same AST node exactly when this is equal and non-null.
"""
function getMemoizationData(x::AbstractDynTypedNode)
    @check_ptrs x
    return clang_DynTypedNode_getMemoizationData(x)
end

function getSourceRange(x::AbstractDynTypedNode)
    @check_ptrs x
    r = clang_DynTypedNode_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    print(x::AbstractDynTypedNode, pp::PrintingPolicy) -> String
The node re-printed as source under `pp`.
"""
function print(x::AbstractDynTypedNode, pp::PrintingPolicy)
    @check_ptrs x pp
    return get_string(clang_DynTypedNode_print(x, pp))
end

"""
    dump(x::AbstractDynTypedNode, ctx::AbstractASTContext) -> String
The node's AST dump.
"""
function dump(x::AbstractDynTypedNode, ctx::AbstractASTContext)
    @check_ptrs x ctx
    return get_string(clang_DynTypedNode_dump(x, ctx))
end
