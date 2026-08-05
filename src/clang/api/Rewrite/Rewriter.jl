# Rewriter

"""
    Rewriter(src_mgr::SourceManager, lang_opts::LangOptions)
Create a `clang::Rewriter` that edits the buffers of `src_mgr`, lexing with `lang_opts`.

The rewriter stores raw references to both of them, so it must be disposed *before* the
`SourceManager` it was built from.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Rewriter(src_mgr::SourceManager, lang_opts::LangOptions)
    @check_ptrs src_mgr lang_opts
    ptr = clang_Rewriter_create(src_mgr, lang_opts)
    @assert ptr != C_NULL "Failed to create Rewriter"
    return Rewriter(ptr)
end

dispose(x::Rewriter) = clang_Rewriter_dispose(x)

function getSourceMgr(x::AbstractRewriter)
    @check_ptrs x
    return SourceManager(clang_Rewriter_getSourceMgr(x))
end

"""
    isRewritable(loc::SourceLocation) -> Bool
Return `true` if `loc` is a raw file location and therefore rewritable. Locations that come
from macro expansions are not.

This mirrors `SourceLocation::isFileID`, which also reports `true` for an *invalid*
location — validity is a separate check (`isValid`).
"""
isRewritable(loc::SourceLocation) = clang_Rewriter_isRewritable(loc)

"""
    getRangeSize(x::AbstractRewriter, range::SourceRange) -> Int32
Return the size in bytes of `range` in the rewritten buffer, or `-1` when its endpoints are
unrewritable or live in different files.

`clang::Rewriter` asserts that both endpoints are valid source locations, so that is
restated here.
"""
function getRangeSize(x::AbstractRewriter, range::SourceRange)
    @check_ptrs x
    @assert isValid(range) "source range endpoints must be valid source locations"
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return clang_Rewriter_getRangeSize(x, r)
end

"""
    getRewrittenText(x::AbstractRewriter, range::SourceRange) -> String
Return the rewritten form of the text covered by `range`, or the empty string when the range
is unrewritable or spans two buffers.

Same precondition as `getRangeSize`: both endpoints must be valid source locations.
"""
function getRewrittenText(x::AbstractRewriter, range::SourceRange)
    @check_ptrs x
    @assert isValid(range) "source range endpoints must be valid source locations"
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return get_string(clang_Rewriter_getRewrittenText(x, r))
end

"""
    InsertText(x::AbstractRewriter, loc::SourceLocation, str::AbstractString,
               insert_after::Bool=true, indent_new_lines::Bool=false) -> Bool
Insert `str` at `loc`. Returns `true` when the edit was *rejected* (the location was not
rewritable) and `false` on success — the Clang convention is preserved verbatim.

`loc` must be a valid source location (`clang::Rewriter` asserts on an invalid one).
"""
function InsertText(x::AbstractRewriter, loc::SourceLocation, str::AbstractString, insert_after::Bool=true, indent_new_lines::Bool=false)
    @check_ptrs x
    @assert isValid(loc) "insertion location must be a valid source location"
    return clang_Rewriter_InsertText(x, loc, str, insert_after, indent_new_lines)
end

"""
    InsertTextAfter(x::AbstractRewriter, loc::SourceLocation, str::AbstractString) -> Bool
Insert `str` at `loc`, after any text previously inserted at the same point. Returns `true`
on failure. `loc` must be valid.
"""
function InsertTextAfter(x::AbstractRewriter, loc::SourceLocation, str::AbstractString)
    @check_ptrs x
    @assert isValid(loc) "insertion location must be a valid source location"
    return clang_Rewriter_InsertTextAfter(x, loc, str)
end

"""
    InsertTextAfterToken(x::AbstractRewriter, loc::SourceLocation, str::AbstractString) -> Bool
Insert `str` after the token that starts at `loc`. Returns `true` on failure. `loc` must be
valid.
"""
function InsertTextAfterToken(x::AbstractRewriter, loc::SourceLocation, str::AbstractString)
    @check_ptrs x
    @assert isValid(loc) "insertion location must be a valid source location"
    return clang_Rewriter_InsertTextAfterToken(x, loc, str)
end

"""
    InsertTextBefore(x::AbstractRewriter, loc::SourceLocation, str::AbstractString) -> Bool
Insert `str` at `loc`, before any text previously inserted at the same point. Returns `true`
on failure. `loc` must be valid.
"""
function InsertTextBefore(x::AbstractRewriter, loc::SourceLocation, str::AbstractString)
    @check_ptrs x
    @assert isValid(loc) "insertion location must be a valid source location"
    return clang_Rewriter_InsertTextBefore(x, loc, str)
end

"""
    RemoveText(x::AbstractRewriter, start::SourceLocation, length::Integer) -> Bool
Remove `length` bytes starting at `start`. Returns `true` on failure. `start` must be valid.
"""
function RemoveText(x::AbstractRewriter, start::SourceLocation, length::Integer)
    @check_ptrs x
    @assert isValid(start) "removal location must be a valid source location"
    return clang_Rewriter_RemoveText(x, start, length)
end

"""
    RemoveText(x::AbstractRewriter, range::SourceRange) -> Bool
Remove the text covered by `range`. Returns `true` on failure. Both endpoints must be valid.
"""
function RemoveText(x::AbstractRewriter, range::SourceRange)
    @check_ptrs x
    @assert isValid(range) "source range endpoints must be valid source locations"
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return clang_Rewriter_RemoveTextInRange(x, r)
end

"""
    ReplaceText(x::AbstractRewriter, start::SourceLocation, orig_length::Integer,
                new_str::AbstractString) -> Bool
Replace `orig_length` bytes at `start` with `new_str`. Returns `true` on failure. `start`
must be valid.
"""
function ReplaceText(x::AbstractRewriter, start::SourceLocation, orig_length::Integer, new_str::AbstractString)
    @check_ptrs x
    @assert isValid(start) "replacement location must be a valid source location"
    return clang_Rewriter_ReplaceText(x, start, orig_length, new_str)
end

"""
    ReplaceText(x::AbstractRewriter, range::SourceRange, new_str::AbstractString) -> Bool
Replace the text covered by `range` with `new_str`. Returns `true` on failure. Both
endpoints must be valid.
"""
function ReplaceText(x::AbstractRewriter, range::SourceRange, new_str::AbstractString)
    @check_ptrs x
    @assert isValid(range) "source range endpoints must be valid source locations"
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return clang_Rewriter_ReplaceTextInRange(x, r, new_str)
end

"""
    ReplaceText(x::AbstractRewriter, range::SourceRange, replacement::SourceRange) -> Bool
Replace the text covered by `range` with the current text of `replacement`. Returns `true`
on failure. Every endpoint must be valid.
"""
function ReplaceText(x::AbstractRewriter, range::SourceRange, replacement::SourceRange)
    @check_ptrs x
    @assert isValid(range) "source range endpoints must be valid source locations"
    @assert isValid(replacement) "replacement range endpoints must be valid source locations"
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    rr = CXSourceRange_(replacement.begin_loc.ptr, replacement.end_loc.ptr)
    return clang_Rewriter_ReplaceTextInRangeWithRange(x, r, rr)
end

"""
    IncreaseIndentation(x::AbstractRewriter, range::SourceRange, parent_indent::SourceLocation) -> Bool
Increase the indentation of the lines spanned by `range`, using `parent_indent` — a location
indented one degree less than `range` — as the reference. Returns `true` on failure.

Every location involved must be valid.
"""
function IncreaseIndentation(x::AbstractRewriter, range::SourceRange, parent_indent::SourceLocation)
    @check_ptrs x
    @assert isValid(range) "source range endpoints must be valid source locations"
    @assert isValid(parent_indent) "parent indentation location must be valid"
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return clang_Rewriter_IncreaseIndentation(x, r, parent_indent)
end

"""
    overwriteChangedFiles(x::AbstractRewriter) -> Bool
Save every rewritten buffer back to its file on disk. Returns `true` if any file could not
be saved; errors are reported through the `SourceManager`'s `DiagnosticsEngine`.
"""
function overwriteChangedFiles(x::AbstractRewriter)
    @check_ptrs x
    return clang_Rewriter_overwriteChangedFiles(x)
end

"""
    getLangOpts(x::AbstractRewriter) -> LangOptions
Return the language options `x` was created with, borrowed — never `dispose` it through this
carrier.
"""
function getLangOpts(x::AbstractRewriter)
    @check_ptrs x
    return LangOptions(clang_Rewriter_getLangOpts(x))
end
