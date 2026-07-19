# Higher-level helpers over the Stmt hierarchy.

# CXStmtClass value -> concrete Julia carrier type, built from the same table
# the C enum is stamped from, so downcasting is one ccall + one lookup instead
# of a per-class predicate chain.
const STMT_CLASS_TO_TYPE = Dict{CXStmtClass,Any}()
for node in STMT_NODES
    node.isabstract && continue
    cls = getproperty(LibClangEx, Symbol("CXStmtClass_", node.name, "Class"))
    STMT_CLASS_TO_TYPE[cls] = getfield(@__MODULE__, stmt_carrier_name(node.name))
end

"""
    resolve(x::AbstractStmt)
Return `x` rewrapped as the concrete statement/expression type reported by
`getStmtClass`. Falls back to returning `x` unchanged for unknown classes.
"""
function resolve(x::AbstractStmt)
    T = get(STMT_CLASS_TO_TYPE, getStmtClass(x), nothing)
    return T === nothing ? x : T(x.ptr)
end

"""
    children(x::AbstractStmt) -> Vector{AbstractStmt}
Direct sub-statements of `x`, each resolved to its concrete type. NULL slots
(e.g. a missing `else` branch) are dropped; use [`getChildren`](@ref) to keep
positional NULLs.
"""
function children(x::AbstractStmt)
    return [resolve(c) for c in getChildren(x) if c.ptr != C_NULL]
end

get_stmt_class(x::AbstractStmt) = getStmtClass(x)
get_stmt_class_name(x::AbstractStmt) = getStmtClassName(x)
dump_ast(x::AbstractStmt) = clang_Stmt_dump(x)
