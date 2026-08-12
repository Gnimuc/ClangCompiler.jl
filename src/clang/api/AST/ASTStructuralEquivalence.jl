# ASTStructuralEquivalence
#
# The ODR-shaped question "are these two declarations the same declaration written twice?",
# answerable across two `ASTContext`s. It is the conflict check to run before an
# [`ASTImporter`](@ref) import, and the dedup check for one header parsed twice.

"""
    StructuralEquivalenceContext(from_ctx::AbstractASTContext, to_ctx::AbstractASTContext;
                                 kind::CXStructuralEquivalenceKind=CXStructuralEquivalenceKind_Default,
                                 strict_type_spelling::Bool=false, complain::Bool=false,
                                 error_on_tag_type_mismatch::Bool=false,
                                 ignore_template_parm_depth::Bool=false) -> StructuralEquivalenceContext
Create a comparison context between `from_ctx` and `to_ctx`. Passing one context twice is
legal and is how declarations inside a single AST are deduplicated.

`strict_type_spelling` demands two types be *spelled* alike rather than merely mean the same
thing; `complain` routes each mismatch through the diagnostics of the context it was found in;
`error_on_tag_type_mismatch` turns a `struct`-versus-`class` mismatch from a warning into an
error; `ignore_template_parm_depth` lets template parameters at different depths match.

The context caches: a pair once found non-equivalent stays non-equivalent, so reuse one for a
batch of related questions and build a fresh one once the ASTs have changed underneath.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function StructuralEquivalenceContext(from_ctx::AbstractASTContext, to_ctx::AbstractASTContext; kind::CXStructuralEquivalenceKind=CXStructuralEquivalenceKind_Default, strict_type_spelling::Bool=false, complain::Bool=false, error_on_tag_type_mismatch::Bool=false, ignore_template_parm_depth::Bool=false)
    @check_ptrs from_ctx to_ctx
    return StructuralEquivalenceContext(clang_StructuralEquivalenceContext_create(from_ctx, to_ctx, kind, strict_type_spelling, complain, error_on_tag_type_mismatch, ignore_template_parm_depth))
end

dispose(x::StructuralEquivalenceContext) = clang_StructuralEquivalenceContext_dispose(x)

function getFromCtx(x::AbstractStructuralEquivalenceContext)
    @check_ptrs x
    return ASTContext(clang_StructuralEquivalenceContext_getFromCtx(x))
end

function getToCtx(x::AbstractStructuralEquivalenceContext)
    @check_ptrs x
    return ASTContext(clang_StructuralEquivalenceContext_getToCtx(x))
end

"""
    IsEquivalent(x::AbstractStructuralEquivalenceContext, a, b) -> Bool
Whether the two declarations, types or statements are structurally equivalent.

`a` must come from the context's "from" AST and `b` from its "to" AST.
"""
function IsEquivalent(x::AbstractStructuralEquivalenceContext, d1::AbstractDecl, d2::AbstractDecl)
    @check_ptrs x d1 d2
    return clang_StructuralEquivalenceContext_IsEquivalentDecl(x, d1, d2)
end

function IsEquivalent(x::AbstractStructuralEquivalenceContext, t1::QualType, t2::QualType)
    @check_ptrs x t1 t2
    return clang_StructuralEquivalenceContext_IsEquivalentQualType(x, t1, t2)
end

function IsEquivalent(x::AbstractStructuralEquivalenceContext, s1::AbstractStmt, s2::AbstractStmt)
    @check_ptrs x s1 s2
    return clang_StructuralEquivalenceContext_IsEquivalentStmt(x, s1, s2)
end

"""
    findUntaggedStructOrUnionIndex(anon::AbstractRecordDecl) -> Int or nothing
The 0-based index of the anonymous struct or union `anon` within its context, and `nothing`
when that context is not a record — at namespace or block scope there is nothing to index
into.
"""
function findUntaggedStructOrUnionIndex(anon::AbstractRecordDecl)
    @check_ptrs anon
    has_index = Ref{Bool}(false)
    idx = clang_StructuralEquivalenceContext_findUntaggedStructOrUnionIndex(anon, has_index)
    return has_index[] ? Int(idx) : nothing
end
