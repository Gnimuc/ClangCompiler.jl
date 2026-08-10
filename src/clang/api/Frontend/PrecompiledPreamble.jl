# PrecompiledPreamble
# `clang::PreambleBounds` is a two-field aggregate, so it is reproduced structurally in
# Julia (core/Frontend/PrecompiledPreamble.jl) and rebuilt at each ccall the way
# `SourceRange` is.

"""
    ComputePreambleBounds(lang_opts::AbstractLangOptions, buffer::AbstractString, max_lines::Integer=0) -> PreambleBounds
Lex `buffer` far enough to find where its leading `#include` block ends.

`max_lines` caps how far the lexer looks; `0` means no cap. Pure computation over the bytes
given — no file is opened and nothing is cached.
"""
function ComputePreambleBounds(lang_opts::AbstractLangOptions, buffer::AbstractString,
                               max_lines::Integer=0)
    @check_ptrs lang_opts
    @assert max_lines >= 0 "max_lines must not be negative"
    b = clang_ComputePreambleBounds(lang_opts, buffer, ncodeunits(buffer), max_lines)
    return PreambleBounds(b.Size, b.PreambleEndsAtStartOfLine)
end

"""
    PrecompiledPreamble(invocation, contents, main_file_name, bounds, diags; storage_path="") -> PrecompiledPreamble

Build the preamble PCH for `bounds` of `contents`, writing it to a temporary file under
`storage_path` (the system temporary directory when that is empty).

`main_file_name` is the buffer's identifier and must be the file `invocation` names as its
input: that name is what the remapping is keyed on. Problems are reported through `diags`.

Throws when clang could not build the preamble; the reason is logged to stderr, since the
`llvm::ErrorOr` clang returns does not cross the C boundary.

This function allocates and one should call `dispose` to release the resources after using
this object. The object also owns the main-file buffer the later
[`AddImplicitPreamble`](@ref) remaps, so it must outlive both the compiler run that consumes
it and the AST that run builds.
"""
function PrecompiledPreamble(invocation::AbstractCompilerInvocation,
                             contents::AbstractString, main_file_name::AbstractString,
                             bounds::PreambleBounds, diags::DiagnosticsEngine;
                             storage_path::AbstractString="")
    @check_ptrs invocation diags
    p = clang_PrecompiledPreamble_Build(invocation, contents, ncodeunits(contents),
                                        main_file_name,
                                        CXPreambleBounds_(bounds.size,
                                                          bounds.ends_at_start_of_line),
                                        diags, storage_path)
    @assert p != C_NULL "Failed to build PrecompiledPreamble"
    return PrecompiledPreamble(p)
end

dispose(x::PrecompiledPreamble) = clang_PrecompiledPreamble_dispose(x)

"""
    getBounds(x::AbstractPrecompiledPreamble) -> PreambleBounds
The bounds the preamble was built for.
"""
function getBounds(x::AbstractPrecompiledPreamble)
    @check_ptrs x
    b = clang_PrecompiledPreamble_getBounds(x)
    return PreambleBounds(b.Size, b.PreambleEndsAtStartOfLine)
end

"""
    getSize(x::AbstractPrecompiledPreamble) -> UInt
Bytes the PCH takes on disk.

Clang documents this as logging and debugging only: it reports `0` when the filesystem
query fails rather than distinguishing that from an empty preamble.
"""
function getSize(x::AbstractPrecompiledPreamble)
    @check_ptrs x
    return clang_PrecompiledPreamble_getSize(x)
end

"""
    getContents(x::AbstractPrecompiledPreamble) -> String
The prefix of the main file the preamble was built from — its first `getBounds(x).size`
bytes.
"""
function getContents(x::AbstractPrecompiledPreamble)
    @check_ptrs x
    return get_string(clang_PrecompiledPreamble_getContents(x))
end

"""
    CanReuse(x::AbstractPrecompiledPreamble, invocation, contents, main_file_name, bounds) -> Bool
Whether this preamble is still valid for new `contents` of the main file: the preamble bytes
must still match and no file it read may have changed.

This is the query the whole class exists for — a `true` answer is what lets a reparse skip
the headers.
"""
function CanReuse(x::AbstractPrecompiledPreamble, invocation::AbstractCompilerInvocation,
                  contents::AbstractString, main_file_name::AbstractString,
                  bounds::PreambleBounds)
    @check_ptrs x invocation
    return clang_PrecompiledPreamble_CanReuse(x, invocation, contents, ncodeunits(contents),
                                              main_file_name,
                                              CXPreambleBounds_(bounds.size,
                                                                bounds.ends_at_start_of_line))
end

"""
    AddImplicitPreamble(x::AbstractPrecompiledPreamble, ci::AbstractCompilerInvocation, contents, main_file_name)
Rewire `ci` to consume this preamble as an implicit PCH, remapping its main file to a copy
of `contents` that `x` keeps alive.

[`CanReuse`](@ref) should hold for the same invocation, contents and bounds. It is not
asserted here: rechecking costs a stat of every file in the preamble, which is the very work
this class exists to avoid, and a stale preamble parses differently rather than corrupting
memory. Use [`OverridePreamble`](@ref) when a mismatch is expected and acceptable.
"""
function AddImplicitPreamble(x::AbstractPrecompiledPreamble,
                             ci::AbstractCompilerInvocation, contents::AbstractString,
                             main_file_name::AbstractString)
    @check_ptrs x ci
    return clang_PrecompiledPreamble_AddImplicitPreamble(x, ci, contents,
                                                         ncodeunits(contents),
                                                         main_file_name)
end

"""
    OverridePreamble(x::AbstractPrecompiledPreamble, ci::AbstractCompilerInvocation, contents, main_file_name)
The same rewiring as [`AddImplicitPreamble`](@ref) without its reuse expectation: use it
when the preamble is known not to match and a possibly-different parse is acceptable.
"""
function OverridePreamble(x::AbstractPrecompiledPreamble, ci::AbstractCompilerInvocation,
                          contents::AbstractString, main_file_name::AbstractString)
    @check_ptrs x ci
    return clang_PrecompiledPreamble_OverridePreamble(x, ci, contents, ncodeunits(contents),
                                                      main_file_name)
end
