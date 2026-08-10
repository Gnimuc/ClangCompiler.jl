# BoundNodes (clang::ast_matchers)
#
# The payload of one match: the map from every `bind("id")` in a matcher expression to the
# node that id matched. A `BoundNodes` is always an owned copy handed out by
# [`getMatch`](@ref), so it survives the next run of its finder and must be disposed.

dispose(x::BoundNodes) = clang_BoundNodes_dispose(x)

"""
    getNumBindings(x::AbstractBoundNodes) -> Integer
Return the number of ids bound by this match.

Clang keys the map on `std::string`, so the ids [`getBindingID`](@ref) hands back are in
sorted order and the same index means the same id for the life of the match.
"""
function getNumBindings(x::AbstractBoundNodes)
    @check_ptrs x
    return clang_BoundNodes_getNumBindings(x)
end

"""
    getBindingID(x::AbstractBoundNodes, i::Integer) -> String
Return the `i`-th bound id, counting from 0.
"""
function getBindingID(x::AbstractBoundNodes, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumBindings(x) "binding index $i out of range"
    return get_string(clang_BoundNodes_getBindingID(x, i))
end

"""
    getNodeAsDecl(x::AbstractBoundNodes, id::AbstractString) -> Decl
Return the declaration bound to `id`, or a null handle when nothing is bound to `id` *or*
what is bound is not a declaration.

That double meaning is the point: the four `getNodeAs*` accessors are how a bound node's
family is discovered, since `BoundNodes` stores type-erased nodes and Clang answers a
mismatched request with `NULL` rather than an error. The result is borrowed from the AST
arena.
"""
function getNodeAsDecl(x::AbstractBoundNodes, id::AbstractString)
    @check_ptrs x
    return Decl(clang_BoundNodes_getNodeAsDecl(x, id))
end

"""
    getNodeAsStmt(x::AbstractBoundNodes, id::AbstractString) -> Stmt
Return the statement (or expression) bound to `id`, or a null handle on a kind mismatch. The
result is borrowed from the AST arena.
"""
function getNodeAsStmt(x::AbstractBoundNodes, id::AbstractString)
    @check_ptrs x
    return Stmt(clang_BoundNodes_getNodeAsStmt(x, id))
end

"""
    getNodeAsQualType(x::AbstractBoundNodes, id::AbstractString) -> QualType
Return the type bound to `id`, or a null `QualType` on a kind mismatch.
"""
function getNodeAsQualType(x::AbstractBoundNodes, id::AbstractString)
    @check_ptrs x
    return QualType(clang_BoundNodes_getNodeAsQualType(x, id))
end

"""
    getNodeAsTypeLoc(x::AbstractBoundNodes, id::AbstractString) -> TypeLoc
Return the type-with-source-locations bound to `id`, or a null handle on a kind mismatch.

Unlike the other three this one allocates: a `TypeLoc` is a by-value pair that would
otherwise point into the match's own storage, so the shim boxes a copy. One should call
`dispose` to release it after use.
"""
function getNodeAsTypeLoc(x::AbstractBoundNodes, id::AbstractString)
    @check_ptrs x
    return TypeLoc(clang_BoundNodes_getNodeAsTypeLoc(x, id))
end
