# Commit
#
# RETURN CONVENTION, the opposite of `Rewriter`'s: every edit here returns `true` on
# SUCCESS and `false` when the edit could not be expressed — an unrewritable location, a
# range that only exists inside a macro body, a system header. Each of them is total: an
# invalid location makes the edit fail rather than misbehave. A single `false` latches
# `isCommitable` to `false`, and `commit` then rejects the whole batch.

"""
    Commit(editor::EditedSource)
Create a batch of source edits that `editor` will accept or reject as a whole.

This is what plain `Rewriter` cannot do: a `Commit` knows about macro expansions — it can
rewrite through a macro *argument*, refuses to rewrite a location that only exists inside a
macro *body*, and the moment one edit is refused the whole batch stops being commitable, so
no half-applied rewrite reaches the source.

The commit holds `editor` and the `SourceManager`/`LangOptions` behind it by raw reference,
so it must be disposed before them.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Commit(editor::EditedSource)
    @check_ptrs editor
    ptr = clang_Commit_create(editor)
    @assert ptr != C_NULL "Failed to create Commit"
    return Commit(ptr)
end

dispose(x::Commit) = clang_Commit_dispose(x)

"""
    isCommitable(x::AbstractCommit) -> Bool
Return `false` once any edit in the batch has been refused. `commit` rejects a `Commit` for
which this is `false`, leaving the edited source untouched.
"""
function isCommitable(x::AbstractCommit)
    @check_ptrs x
    return clang_Commit_isCommitable(x)
end

"""
    insert(x::AbstractCommit, loc::SourceLocation, text::AbstractString,
           after_token::Bool=false, before_previous_insertions::Bool=false) -> Bool
Insert `text` at `loc`. `after_token` puts it after the whole token that starts at `loc`
rather than at `loc` itself; `before_previous_insertions` orders it ahead of text already
inserted at the same point.

An empty `text` succeeds and records nothing.
"""
function insert(x::AbstractCommit, loc::SourceLocation, text::AbstractString,
                after_token::Bool=false, before_previous_insertions::Bool=false)
    @check_ptrs x
    return clang_Commit_insert(x, loc, text, after_token, before_previous_insertions)
end

"""
    insertAfterToken(x::AbstractCommit, loc::SourceLocation, text::AbstractString,
                     before_previous_insertions::Bool=false) -> Bool
Insert `text` after the token that starts at `loc`.
"""
function insertAfterToken(x::AbstractCommit, loc::SourceLocation, text::AbstractString,
                          before_previous_insertions::Bool=false)
    @check_ptrs x
    return clang_Commit_insertAfterToken(x, loc, text, before_previous_insertions)
end

"""
    insertBefore(x::AbstractCommit, loc::SourceLocation, text::AbstractString) -> Bool
Insert `text` at `loc`, ahead of anything already inserted there.
"""
function insertBefore(x::AbstractCommit, loc::SourceLocation, text::AbstractString)
    @check_ptrs x
    return clang_Commit_insertBefore(x, loc, text)
end

"""
    insertFromRange(x::AbstractCommit, loc::SourceLocation, range::CharSourceRange,
                    after_token::Bool=false, before_previous_insertions::Bool=false) -> Bool
Insert at `loc` a copy of the source text `range` currently covers.
"""
function insertFromRange(x::AbstractCommit, loc::SourceLocation, range::CharSourceRange,
                         after_token::Bool=false, before_previous_insertions::Bool=false)
    @check_ptrs x
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    return clang_Commit_insertFromRange(x, loc, r, range.is_token_range, after_token,
                                        before_previous_insertions)
end

"""
    insertWrap(x::AbstractCommit, before::AbstractString, range::CharSourceRange,
               after::AbstractString) -> Bool
Surround `range` with `before` and `after`.
"""
function insertWrap(x::AbstractCommit, before::AbstractString, range::CharSourceRange,
                    after::AbstractString)
    @check_ptrs x
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    return clang_Commit_insertWrap(x, before, r, range.is_token_range, after)
end

"""
    remove(x::AbstractCommit, range::CharSourceRange) -> Bool
Delete the source `range` covers.
"""
function remove(x::AbstractCommit, range::CharSourceRange)
    @check_ptrs x
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    return clang_Commit_remove(x, r, range.is_token_range)
end

"""
    replace(x::AbstractCommit, range::CharSourceRange, text::AbstractString) -> Bool
Replace the source `range` covers with `text`.

This extends `Base.replace` instead of defining a new `replace`, which would shadow the
string method this package calls in `src/lookup.jl`.
"""
function Base.replace(x::AbstractCommit, range::CharSourceRange, text::AbstractString)
    @check_ptrs x
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    return clang_Commit_replace(x, r, range.is_token_range, text)
end

"""
    replaceWithInner(x::AbstractCommit, range::CharSourceRange,
                     inner::CharSourceRange) -> Bool
Replace `range` with the text of `inner` — the shape of "drop the call and keep its
argument". `inner` must lie inside `range` and in the same file; when it does not, the edit
is refused rather than misapplied.
"""
function replaceWithInner(x::AbstractCommit, range::CharSourceRange, inner::CharSourceRange)
    @check_ptrs x
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    ir = CXSourceRange_(inner.range.begin_loc.ptr, inner.range.end_loc.ptr)
    return clang_Commit_replaceWithInner(x, r, range.is_token_range, ir,
                                         inner.is_token_range)
end

"""
    replaceText(x::AbstractCommit, loc::SourceLocation, text::AbstractString,
                replacement_text::AbstractString) -> Bool
Replace the token spelled `text` at `loc` with `replacement_text`. Either string being
empty succeeds and records nothing.
"""
function replaceText(x::AbstractCommit, loc::SourceLocation, text::AbstractString,
                     replacement_text::AbstractString)
    @check_ptrs x
    return clang_Commit_replaceText(x, loc, text, replacement_text)
end
