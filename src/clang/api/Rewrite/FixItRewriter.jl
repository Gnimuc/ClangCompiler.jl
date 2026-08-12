# FixItRewriter

"""
    FixItRewriter(diags::DiagnosticsEngine, src_mgr::SourceManager, lang_opts::LangOptions;
                  in_place::Bool=false, fix_what_you_can::Bool=false,
                  fix_only_warnings::Bool=false, silent::Bool=false)
Create a diagnostic consumer that applies the fix-it hints clang attaches to its own
diagnostics — "did you mean ...", a missing semicolon, a misspelled member — to the source
they came from.

`clang::FixItOptions::RewriteFilename` is a pure virtual, so libclangex compiles the one
subclass of it this package needs: its behaviour is the four keyword flags below, and its
file-naming rule appends `.fixit` to whatever name it is handed.

`in_place` rewrites the original files rather than those `.fixit` siblings;
`fix_what_you_can` keeps the fixes already applied even when some diagnostic in the same
file could not be fixed; `fix_only_warnings` skips the hints attached to errors; `silent`
forwards a diagnostic onward only when it is an error or carried a fix-it that was applied.

OWNERSHIP: `clang::FixItRewriter` installs itself as `diags`' diagnostic client on
construction (taking over the previous client's ownership) and puts the previous one back
on destruction. So from this call until `dispose`, every diagnostic `diags` reports goes
through the rewriter first — do not call `setClient` or `takeClient` on `diags` in between,
and dispose the rewriter *before* `diags`, `src_mgr` and `lang_opts`, all three of which it
holds by raw reference.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function FixItRewriter(diags::DiagnosticsEngine, src_mgr::SourceManager, lang_opts::LangOptions; in_place::Bool=false, fix_what_you_can::Bool=false, fix_only_warnings::Bool=false, silent::Bool=false)
    @check_ptrs diags src_mgr lang_opts
    ptr = clang_FixItRewriter_create(diags, src_mgr, lang_opts, in_place, fix_what_you_can, fix_only_warnings, silent)
    @assert ptr != C_NULL "Failed to create FixItRewriter"
    return FixItRewriter(ptr)
end

"""
    dispose(x::FixItRewriter)
Destroy the rewriter, which also restores the diagnostic client it displaced.
"""
dispose(x::FixItRewriter) = clang_FixItRewriter_dispose(x)

"""
    WriteFixedFiles(x::AbstractFixItRewriter) -> Bool
Write every fixed file to *disk* — over the original when the rewriter was created with
`in_place=true`, otherwise to a `<path>.fixit` sibling — and return `true` if any of them
could not be written.

This is also the step that materializes the fixes: as diagnostics arrive their hints are
batched into a private `clang::edit::EditedSource`, and it is this call that replays the
batch into the rewriter's buffers. Until it has run, `IsModified` is `false` for every
file, `getNumBuffers` is `0` and `WriteFixedFile` yields the empty string.

Every changed file must be backed by a real file on disk: the output path is derived from
the `FileID`'s `FileEntry`, and a `FileID` created from a memory buffer — which is what the
incremental `Interpreter` parses from — has none.
"""
function WriteFixedFiles(x::AbstractFixItRewriter)
    @check_ptrs x
    return clang_FixItRewriter_WriteFixedFiles(x)
end

"""
    IsModified(x::AbstractFixItRewriter, id::FileID) -> Bool
Return whether any fix-it landed in the file `id` names. Only meaningful after
`WriteFixedFiles`; see the sequencing note there.
"""
function IsModified(x::AbstractFixItRewriter, id::FileID)
    @check_ptrs x id
    return clang_FixItRewriter_IsModified(x, id)
end

"""
    getNumBuffers(x::AbstractFixItRewriter) -> UInt32
Return how many files carry a fix. Only meaningful after `WriteFixedFiles`.
"""
function getNumBuffers(x::AbstractFixItRewriter)
    @check_ptrs x
    return clang_FixItRewriter_getNumBuffers(x)
end

"""
    getBufferFileID(x::AbstractFixItRewriter, i::Integer) -> FileID
Return the `FileID` of the `i`-th fixed file, counting from zero.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getBufferFileID(x::AbstractFixItRewriter, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumBuffers(x) "fixed-file index out of range"
    return FileID(clang_FixItRewriter_getBufferFileID(x, i))
end

"""
    WriteFixedFile(x::AbstractFixItRewriter, id::FileID) -> String
Return the fixed text of the file `id` names, in memory. Only meaningful after
`WriteFixedFiles`; see the sequencing note there.

Returns the empty string when `id` carries no fix — clang's one failure mode here —
which `IsModified` tells apart from a file that really did rewrite to nothing.
"""
function WriteFixedFile(x::AbstractFixItRewriter, id::FileID)
    @check_ptrs x id
    return get_string(clang_FixItRewriter_WriteFixedFile(x, id))
end

"""
    IncludeInDiagnosticCounts(x::AbstractFixItRewriter) -> Bool
Return whether the diagnostics this consumer handles count towards the engine's totals.
"""
function IncludeInDiagnosticCounts(x::AbstractFixItRewriter)
    @check_ptrs x
    return clang_FixItRewriter_IncludeInDiagnosticCounts(x)
end

"""
    Diag(x::AbstractFixItRewriter, loc::SourceLocation, diag_id::Integer)
Emit the diagnostic `diag_id` at `loc` through the client this rewriter displaced.
"""
function Diag(x::AbstractFixItRewriter, loc::SourceLocation, diag_id::Integer)
    @check_ptrs x
    return clang_FixItRewriter_Diag(x, loc, diag_id)
end
