# Higher-level helpers over the Stmt hierarchy.

# CXStmtClass value -> concrete Julia carrier type, so resolving is one ccall
# + one lookup instead of a per-class predicate chain. The classes and carriers
# both derive from StmtNodes.inc, so the map is generated from it into
# src/clang/StmtClassMap.jl (defines `STMT_CLASS_TO_TYPE`).
include("StmtClassMap.jl")

"""
    resolve(x::AbstractStmt)
Return `x` rewrapped as the concrete statement/expression type reported by
`getStmtClass`. Falls back to returning `x` unchanged for unknown classes.
"""
function resolve(x::AbstractStmt)
    T = get(STMT_CLASS_TO_TYPE, getStmtClass(x), nothing)
    return T === nothing ? x : unchecked_cast(T, x)
end

"""
    children(x::AbstractStmt) -> Vector{AbstractStmt}
Direct sub-statements of `x`, each resolved to its concrete type. NULL slots — the absent
`init`/`cond`/`inc` of a `for (;;)`, which occupy four of that `ForStmt`'s five slots — are
dropped; use [`getChildren`](@ref) to keep them positional.

The element type is `AbstractStmt` whatever the children turn out to be, matching
[`subtree`](@ref). Letting the comprehension infer it instead would name a concrete carrier —
`Vector{ReturnStmt}` for a one-child node — and that leaks a class name from clang's
`StmtNodes.inc` into the return *type*, where it changes with the LLVM version rather than
with the code being analysed.
"""
function children(x::AbstractStmt)
    return AbstractStmt[resolve(c) for c in getChildren(x) if c.ptr != C_NULL]
end

"""
    subtree(x::AbstractStmt) -> Vector{AbstractStmt}
Every statement in `x`'s subtree in pre-order (`x` first), each resolved to its
concrete type. The whole subtree is bulk-extracted in a single pair of ccalls
(size + fill) that also returns each node's `CXStmtClass`, so building the
resolved carriers needs no per-node round-trip — O(1) FFI calls for the walk
instead of the O(nodes) that repeated [`children`](@ref) recursion costs. Use
this for whole-function/whole-subtree analysis; use `children` for one level.
"""
function subtree(x::AbstractStmt)
    @check_ptrs x
    n = Int(clang_Stmt_getSubtreeSize(x))
    nodes = Vector{CXStmt}(undef, n)
    classes = Vector{CXStmtClass}(undef, n)
    clang_Stmt_collectSubtree(x, nodes, classes)
    # the collector reports each node's class alongside it, which is what establishes the
    # narrowing from the `CXStmt` it handed back
    return AbstractStmt[unchecked_cast(STMT_CLASS_TO_TYPE[classes[i]], nodes[i]) for i = 1:n]
end

get_stmt_class(x::AbstractStmt) = getStmtClass(x)
get_stmt_class_name(x::AbstractStmt) = getStmtClassName(x)
dump_ast(x::AbstractStmt) = clang_Stmt_dump(x)
