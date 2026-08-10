# DynTypedMatcher (clang::ast_matchers::internal)
#
# The type-erased matcher every other file in this subsystem passes around. It has no
# constructor here — see `parseMatcherExpression`, which is the only way to build one — but
# each of the derivations below hands back a NEW owned matcher.

dispose(x::DynTypedMatcher) = clang_DynTypedMatcher_dispose(x)

"""
    tryBind(x::AbstractDynTypedMatcher, id::AbstractString) -> DynTypedMatcher
Return a new matcher with `id` bound to it, so every node it matches turns up in the
[`BoundNodes`](@ref) under `id`. This is the `.bind("id")` suffix applied *after* parsing,
without re-parsing the query string.

The result is a null handle when this matcher does not support binding (Clang returns an
empty `std::optional` there) — test it with `is_null_handle` before use.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function tryBind(x::AbstractDynTypedMatcher, id::AbstractString)
    @check_ptrs x
    return DynTypedMatcher(clang_DynTypedMatcher_tryBind(x, id))
end

"""
    withTraversalKind(x::AbstractDynTypedMatcher, kind::CXTraversalKind) -> DynTypedMatcher
Return a new matcher over the same implementation with `kind` forced, overriding whatever
traversal kind was already set.

`CXTraversalKind_TK_IgnoreUnlessSpelledInSource` is what makes a matcher skip the implicit
casts, materialised temporaries and rewritten operator calls that otherwise sit between a
template-heavy expression and the children actually spelled in the source — the single
biggest source of surprising matches in C++.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function withTraversalKind(x::AbstractDynTypedMatcher, kind::CXTraversalKind)
    @check_ptrs x
    return DynTypedMatcher(clang_DynTypedMatcher_withTraversalKind(x, kind))
end

"""
    getTraversalKind(x::AbstractDynTypedMatcher) -> Union{CXTraversalKind,Nothing}
Return the traversal kind this matcher forces, or `nothing` when it forces none.

`nothing` is the usual answer: most matchers defer to the surrounding context, and only a
matcher that has been through [`withTraversalKind`](@ref) (or was built from one that had)
reports a kind of its own.
"""
function getTraversalKind(x::AbstractDynTypedMatcher)
    @check_ptrs x
    kind = Ref{CXTraversalKind}(CXTraversalKind_TK_AsIs)
    return clang_DynTypedMatcher_getTraversalKind(x, kind) ? kind[] : nothing
end

"""
    getSupportedKind(x::AbstractDynTypedMatcher) -> String
Return the node family this matcher works on — `"Decl"`, `"Stmt"`, `"QualType"`, `"TypeLoc"`
and so on — as `clang::ASTNodeKind::asStringRef` spells it.

`ASTNodeKind` crosses the C boundary as a string only: it is a bare index into a table
stamped from the node `.inc` files, so its numbering follows the LLVM version and mirroring
it as an enum would freeze an LLVM-internal enumeration into this package's ABI.
"""
function getSupportedKind(x::AbstractDynTypedMatcher)
    @check_ptrs x
    return get_string(clang_DynTypedMatcher_getSupportedKind(x))
end

"""
    canConvertTo(x::AbstractDynTypedMatcher, to::AbstractDynTypedMatcher) -> Bool
Return whether `x` could be used where a matcher of `to`'s node family is required.

Only `to`'s [`getSupportedKind`](@ref) is read; the destination is spelled as a matcher
because `ASTNodeKind` itself does not cross the C boundary. `canConvertTo(x, x)` is therefore
the trivially true case, and a `Decl` matcher against a `Stmt` matcher is the false one.
"""
function canConvertTo(x::AbstractDynTypedMatcher, to::AbstractDynTypedMatcher)
    @check_ptrs x to
    return clang_DynTypedMatcher_canConvertTo(x, to)
end
