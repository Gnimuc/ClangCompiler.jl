# Stmt
function getStmtClass(x::AbstractStmt)
    @check_ptrs x
    return clang_Stmt_getStmtClass(x)
end

function getStmtClassName(x::AbstractStmt)
    @check_ptrs x
    return unsafe_string(clang_Stmt_getStmtClassName(x))
end

function getBeginLoc(x::AbstractStmt)
    @check_ptrs x
    return SourceLocation(clang_Stmt_getBeginLoc(x))
end

function getEndLoc(x::AbstractStmt)
    @check_ptrs x
    return SourceLocation(clang_Stmt_getEndLoc(x))
end

function getSourceRange(x::AbstractStmt)
    @check_ptrs x
    r = clang_Stmt_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getNumChildren(x::AbstractStmt)
    @check_ptrs x
    return Int(clang_Stmt_getNumChildren(x))
end

"""
    getChildren(x::AbstractStmt) -> Vector{Stmt}
Return the direct sub-statements. Slots may hold a NULL pointer (e.g. the
missing `else` branch of an `IfStmt` keeps its position).
"""
function getChildren(x::AbstractStmt)
    @check_ptrs x
    n = clang_Stmt_getNumChildren(x)
    buf = Vector{CXStmt}(undef, n)
    n > 0 && clang_Stmt_getChildren(x, buf)
    return [Stmt(p) for p in buf]
end

# Stmt Cast — one constructor-shaped downcast and one predicate per class in
# the hierarchy (abstract bases included), stamped from the STMT_NODES table.
# The wrapped pointer is NULL when the node is not of that class
# (dyn_cast_or_null semantics). Classes clang itself names `Abstract*` have no
# carrier struct, so they get only the predicate.
for node in STMT_NODES
    pred = Symbol("clang_Stmt_is", node.name)
    isname = Symbol("is", node.name)
    @eval function $isname(x::AbstractStmt)
        @check_ptrs x
        return $pred(x)
    end
    startswith(String(node.name), "Abstract") && continue
    tsym = stmt_carrier_name(node.name)
    cast = Symbol("clang_Stmt_castTo", node.name)
    @eval function $tsym(x::AbstractStmt)
        @check_ptrs x
        return $tsym($cast(x))
    end
end
