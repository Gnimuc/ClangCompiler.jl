# MatchFinder (clang::ast_matchers), collect-results mode
#
# Upstream reports matches through a virtual `MatchCallback::run`, which cannot cross the C
# boundary. The shim allocates the finder together with one fixed collector — the same
# `CollectMatchesCallback` shape Clang's own header-inline `match()` helpers use — so a match
# run leaves a list of results behind that is read back by index here.

"""
    MatchFinder()
Create a `clang::ast_matchers::MatchFinder` with the shim's result collector attached.

This function allocates and one should call `dispose` to release the resources after using
this object. Disposing it also frees the collected results, so copy out any
[`BoundNodes`](@ref) you still need first — those are independently owned.
"""
function MatchFinder()
    ptr = clang_MatchFinder_create()
    @assert ptr != C_NULL "Failed to create MatchFinder"
    return MatchFinder(ptr)
end

dispose(x::MatchFinder) = clang_MatchFinder_dispose(x)

"""
    addDynamicMatcher(x::AbstractMatchFinder, m::AbstractDynTypedMatcher) -> Bool
Register `m` to run on the next match, and return whether it is a valid *top-level* matcher.

`false` means `m`'s node family is not one the finder traverses; it is then not registered
and contributes nothing. Matchers accumulate, so several may be added and found in a single
pass over the AST. The finder stores a copy, so `m` may be disposed independently.
"""
function addDynamicMatcher(x::AbstractMatchFinder, m::AbstractDynTypedMatcher)
    @check_ptrs x m
    return clang_MatchFinder_addDynamicMatcher(x, m)
end

"""
    matchAST(x::AbstractMatchFinder, ctx::AbstractASTContext) -> Integer
Run every registered matcher over the whole translation unit of `ctx` and return the number
of matches collected.

Each run clears the previous results first, so [`getNumMatches`](@ref) and [`getMatch`](@ref)
always read the last run's. Pair this with the incremental interpreter's `ASTContext` and one
call replaces a hand-written walk of the declaration list.
"""
function matchAST(x::AbstractMatchFinder, ctx::AbstractASTContext)
    @check_ptrs x ctx
    return clang_MatchFinder_matchAST(x, ctx)
end

"""
    matchDecl(x::AbstractMatchFinder, d::AbstractDecl, ctx::AbstractASTContext) -> Integer
Run every registered matcher against the single declaration `d` and return the number of
matches collected.

This matches *on* `d`, not inside it: wrap the matcher in `findAll(...)` when the subtree
under `d` should be searched. Same clear-then-collect contract as [`matchAST`](@ref); `d`
must belong to `ctx`.
"""
function matchDecl(x::AbstractMatchFinder, d::AbstractDecl, ctx::AbstractASTContext)
    @check_ptrs x d ctx
    return clang_MatchFinder_matchDecl(x, d, ctx)
end

"""
    matchStmt(x::AbstractMatchFinder, s::AbstractStmt, ctx::AbstractASTContext) -> Integer
Run every registered matcher against the single statement `s`. See [`matchDecl`](@ref).
"""
function matchStmt(x::AbstractMatchFinder, s::AbstractStmt, ctx::AbstractASTContext)
    @check_ptrs x s ctx
    return clang_MatchFinder_matchStmt(x, s, ctx)
end

"""
    matchQualType(x::AbstractMatchFinder, t::QualType, ctx::AbstractASTContext) -> Integer
Run every registered matcher against the single type `t`. See [`matchDecl`](@ref).
"""
function matchQualType(x::AbstractMatchFinder, t::QualType, ctx::AbstractASTContext)
    @check_ptrs x t ctx
    return clang_MatchFinder_matchQualType(x, t, ctx)
end

"""
    getNumMatches(x::AbstractMatchFinder) -> Integer
Return the size of the collected result list — the number the last match run returned,
re-readable without re-running.
"""
function getNumMatches(x::AbstractMatchFinder)
    @check_ptrs x
    return clang_MatchFinder_getNumMatches(x)
end

"""
    getMatch(x::AbstractMatchFinder, i::Integer) -> BoundNodes
Return the `i`-th collected match, counting from 0.

The result is an owned copy rather than a view into the finder, precisely so that it outlives
the next match run; one should call `dispose` on it. This function allocates.
"""
function getMatch(x::AbstractMatchFinder, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumMatches(x) "match index $i out of range"
    return BoundNodes(clang_MatchFinder_getMatch(x, i))
end
