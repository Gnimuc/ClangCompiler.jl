# ParentMapContext

"""
    clear(x::AbstractParentMapContext)
Drop the cached parent map. The next parent query rebuilds it over the `ASTContext`'s current
traversal scope.

This is the cheap half of the invalidation the parent family needs: the map is built once and
cached, so declarations and statements produced by a *later* incremental parse are absent from
it and report no parents until the cache is dropped. [`setTraversalScope`](@ref) drops it too,
but only as a side effect of narrowing the scope.
"""
function clear(x::AbstractParentMapContext)
    @check_ptrs x
    return clang_ParentMapContext_clear(x)
end

"""
    getTraversalKind(x::AbstractParentMapContext) -> CXTraversalKind
Return the kind every parent query and every [`traverseIgnored`](@ref) call applies:
`CXTraversalKind_TK_AsIs` walks all nodes, `CXTraversalKind_TK_IgnoreUnlessSpelledInSource`
skips the ones clang synthesised rather than read from the source.
"""
function getTraversalKind(x::AbstractParentMapContext)
    @check_ptrs x
    return clang_ParentMapContext_getTraversalKind(x)
end

"""
    setTraversalKind(x::AbstractParentMapContext, kind::CXTraversalKind)
Set the traversal kind, changing what the parent chain steps through — implicit casts,
materialised temporaries and rewritten operator calls are edges under
`CXTraversalKind_TK_AsIs` and invisible under
`CXTraversalKind_TK_IgnoreUnlessSpelledInSource`.

The cached map is *not* dropped: clang applies the kind as the map is walked, not as it is
built.
"""
function setTraversalKind(x::AbstractParentMapContext, kind::CXTraversalKind)
    @check_ptrs x
    return clang_ParentMapContext_setTraversalKind(x, kind)
end

"""
    traverseIgnored(x::AbstractParentMapContext, e::AbstractExpr) -> Expr_
Return `e` with whatever the current traversal kind ignores skipped: `e` itself under
`CXTraversalKind_TK_AsIs`, and [`IgnoreUnlessSpelledInSource`](@ref)`(e)` under
`CXTraversalKind_TK_IgnoreUnlessSpelledInSource`.

This is the same skipping rule the parent walk applies, made available for a single
expression. The result is borrowed from the AST arena.
"""
function traverseIgnored(x::AbstractParentMapContext, e::AbstractExpr)
    @check_ptrs x e
    return Expr_(clang_ParentMapContext_traverseIgnored(x, e))
end
