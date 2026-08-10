# EditedSource

"""
    EditedSource(src_mgr::SourceManager, lang_opts::LangOptions)
Create the accumulator a `Commit` commits into: it holds the accepted edits for a whole
translation unit, keyed on file offsets, and folds several edits landing in the same macro
argument into one consistent rewrite.

Both arguments are stored as raw references and must outlive the result, and so must every
`Commit` created against it.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function EditedSource(src_mgr::SourceManager, lang_opts::LangOptions)
    @check_ptrs src_mgr lang_opts
    ptr = clang_EditedSource_create(src_mgr, lang_opts)
    @assert ptr != C_NULL "Failed to create EditedSource"
    return EditedSource(ptr)
end

dispose(x::EditedSource) = clang_EditedSource_dispose(x)

"""
    getSourceManager(x::AbstractEditedSource) -> SourceManager
Return the borrowed `SourceManager` `x` was created over — never `dispose` it through this
carrier.
"""
function getSourceManager(x::AbstractEditedSource)
    @check_ptrs x
    return SourceManager(clang_EditedSource_getSourceManager(x))
end

"""
    getLangOpts(x::AbstractEditedSource) -> LangOptions
Return the borrowed `LangOptions` `x` was created with.
"""
function getLangOpts(x::AbstractEditedSource)
    @check_ptrs x
    return LangOptions(clang_EditedSource_getLangOpts(x))
end

"""
    canInsertInOffset(x::AbstractEditedSource, orig_loc::SourceLocation, id::FileID,
                      offset::Integer) -> Bool
Return whether an insertion at byte `offset` of the file `id` names, reached from
`orig_loc`, would be consistent with the edits `x` already holds.

`clang::edit::FileOffset` is a `FileID` plus a byte offset, so it crosses as that pair.
"""
function canInsertInOffset(x::AbstractEditedSource, orig_loc::SourceLocation, id::FileID,
                           offset::Integer)
    @check_ptrs x id
    return clang_EditedSource_canInsertInOffset(x, orig_loc, id, offset)
end

"""
    commit(x::AbstractEditedSource, c::AbstractCommit) -> Bool
Record every edit of `c`, or none of them.

Returns `false` when `c` is not commitable — some edit in it was refused — or when one of
its edits conflicts with what `x` already holds; `x` is left exactly as it was in both
cases. That all-or-nothing behaviour is the thing plain `Rewriter` cannot offer.
"""
function commit(x::AbstractEditedSource, c::AbstractCommit)
    @check_ptrs x c
    return clang_EditedSource_commit(x, c)
end

"""
    applyRewrites(x::AbstractEditedSource, rw::AbstractRewriter,
                  adjust_removals::Bool=true)
Replay the edits `x` holds into `rw`, from which the resulting text is read back with
`getRewriteBufferText`.

`clang::edit::EditsReceiver` is a pure-virtual sink; libclangex compiles the one
implementation of it that forwards into a `Rewriter`, so no Julia-side subclass is
involved.

`adjust_removals` widens a removal to swallow the whitespace and trailing comment left
behind, which is what makes deletions look hand-written.

`x` and `rw` must be built over the same `SourceManager` — the offsets replayed here are
that manager's.
"""
function applyRewrites(x::AbstractEditedSource, rw::AbstractRewriter,
                       adjust_removals::Bool=true)
    @check_ptrs x rw
    @assert getSourceManager(x).ptr == getSourceMgr(rw).ptr "the edited source and the rewriter must share a SourceManager"
    return clang_EditedSource_applyRewrites(x, rw, adjust_removals)
end

"""
    clearRewrites(x::AbstractEditedSource)
Drop every edit `x` holds, leaving it as freshly created.
"""
function clearRewrites(x::AbstractEditedSource)
    @check_ptrs x
    return clang_EditedSource_clearRewrites(x)
end
