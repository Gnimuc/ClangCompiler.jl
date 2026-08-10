# Replacement

"""
    Replacement(file_path::AbstractString, offset::Integer, len::Integer, text::AbstractString)
Create a `clang::tooling::Replacement` that replaces the `len` bytes at `offset` in
`file_path` with `text`.

This is the `SourceManager`-independent form: nothing about it is tied to a parse, which is
what lets a set of these be collected across translation units and applied at the end.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Replacement(file_path::AbstractString, offset::Integer, len::Integer,
                     text::AbstractString)
    ptr = clang_Replacement_create(file_path, offset, len, text)
    @assert ptr != C_NULL "Failed to create Replacement"
    return Replacement(ptr)
end

"""
    Replacement() -> Replacement
Create the invalid replacement — the one `isApplicable` rejects, and the one Clang's own
default constructor produces.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Replacement()
    ptr = clang_Replacement_createInvalid()
    @assert ptr != C_NULL "Failed to create Replacement"
    return Replacement(ptr)
end

"""
    Replacement(src_mgr::AbstractSourceManager, start::SourceLocation, len::Integer, text::AbstractString)
Create a replacement of the `len` bytes starting at `start`, resolving the location through
`src_mgr` into a file path and an offset.

`start` must be a valid source location: the constructor decomposes it, which Clang asserts
on.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Replacement(src_mgr::AbstractSourceManager, start::SourceLocation, len::Integer,
                     text::AbstractString)
    @check_ptrs src_mgr
    @assert isValid(start) "replacement start must be a valid source location"
    ptr = clang_Replacement_createFromSourceLocation(src_mgr, start, len, text)
    @assert ptr != C_NULL "Failed to create Replacement"
    return Replacement(ptr)
end

"""
    Replacement(src_mgr::AbstractSourceManager, range::CharSourceRange, text::AbstractString)
    Replacement(src_mgr::AbstractSourceManager, range::CharSourceRange, text::AbstractString,
                lang_opts::AbstractLangOptions)
Create a replacement of the text `range` covers.

`lang_opts` is only consulted for a *token* range, where the end of the last token has to be
lexed for; omitting it selects Clang's own default argument, a default-constructed
`LangOptions`. Both endpoints of `range` must be valid.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Replacement(src_mgr::AbstractSourceManager, range::CharSourceRange,
                     text::AbstractString, lang_opts::AbstractLangOptions)
    @check_ptrs src_mgr lang_opts
    @assert isValid(range) "replacement range endpoints must be valid source locations"
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    ptr = clang_Replacement_createFromCharSourceRange(src_mgr, r, range.is_token_range,
                                                      text, lang_opts)
    @assert ptr != C_NULL "Failed to create Replacement"
    return Replacement(ptr)
end

function Replacement(src_mgr::AbstractSourceManager, range::CharSourceRange,
                     text::AbstractString)
    @check_ptrs src_mgr
    @assert isValid(range) "replacement range endpoints must be valid source locations"
    r = CXSourceRange_(range.range.begin_loc.ptr, range.range.end_loc.ptr)
    ptr = clang_Replacement_createFromCharSourceRange(src_mgr, r, range.is_token_range,
                                                      text, C_NULL)
    @assert ptr != C_NULL "Failed to create Replacement"
    return Replacement(ptr)
end

dispose(x::Replacement) = clang_Replacement_dispose(x)

"""
    isApplicable(x::AbstractReplacement) -> Bool
Return whether this replacement names a file and can therefore be applied.
"""
function isApplicable(x::AbstractReplacement)
    @check_ptrs x
    return clang_Replacement_isApplicable(x)
end

"""
    getFilePath(x::AbstractReplacement) -> String
Return the path of the file this replacement edits, empty for an invalid replacement.
"""
function getFilePath(x::AbstractReplacement)
    @check_ptrs x
    return get_string(clang_Replacement_getFilePath(x))
end

"""
    getOffset(x::AbstractReplacement) -> UInt32
Return the byte offset of the replaced range.
"""
function getOffset(x::AbstractReplacement)
    @check_ptrs x
    return clang_Replacement_getOffset(x)
end

"""
    getLength(x::AbstractReplacement) -> UInt32
Return the length in bytes of the replaced range.
"""
function getLength(x::AbstractReplacement)
    @check_ptrs x
    return clang_Replacement_getLength(x)
end

"""
    getReplacementText(x::AbstractReplacement) -> String
Return the text this replacement puts in place of the range.
"""
function getReplacementText(x::AbstractReplacement)
    @check_ptrs x
    return get_string(clang_Replacement_getReplacementText(x))
end

"""
    apply(x::AbstractReplacement, rewriter::AbstractRewriter) -> Bool
Apply this replacement through `rewriter`, returning `true` on success.

Note the polarity: the `Rewriter`'s own `InsertText`/`ReplaceText` return `true` on
*failure*, and this does the opposite, because that is what Clang's two APIs do.
"""
function apply(x::AbstractReplacement, rewriter::AbstractRewriter)
    @check_ptrs x rewriter
    return clang_Replacement_apply(x, rewriter)
end

"""
    toString(x::AbstractReplacement) -> String
Return the human-readable form, `"path: offset:+length:\\"text\\""`.
"""
function toString(x::AbstractReplacement)
    @check_ptrs x
    return get_string(clang_Replacement_toString(x))
end

# Replacements

"""
    Replacements() -> Replacements
Create an empty, conflict-free set of replacements.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Replacements()
    ptr = clang_Replacements_create()
    @assert ptr != C_NULL "Failed to create Replacements"
    return Replacements(ptr)
end

"""
    Replacements(r::AbstractReplacement) -> Replacements
Create a set holding a copy of `r`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Replacements(r::AbstractReplacement)
    @check_ptrs r
    ptr = clang_Replacements_createFromReplacement(r)
    @assert ptr != C_NULL "Failed to create Replacements"
    return Replacements(ptr)
end

dispose(x::Replacements) = clang_Replacements_dispose(x)

"""
    add(x::AbstractReplacements, r::AbstractReplacement) -> (Bool, String)
Add `r` to the set, returning whether it went in and, when it did not, Clang's explanation.

The set only ever holds *order-independent* replacements, so this is where Clang refuses:
`r` conflicts with one already in the set — they overlap in a way that makes the result
depend on which is applied first — or it names a different file. Clang reports that as an
`llvm::Error`; the message is the second half of the returned tuple, empty on success.

Replacements at offset `typemax(UInt32)` are exempt from the conflict check: Clang treats
them as a deliberately special category.
"""
function add(x::AbstractReplacements, r::AbstractReplacement)
    @check_ptrs x r
    err = Ref{CXString}()
    ok = clang_Replacements_add(x, r, err)
    return ok, get_string(err[])
end

"""
    Base.merge(x::AbstractReplacements, other::AbstractReplacements) -> Replacements
Return a new set equivalent to applying `x` and then `other`, where `other` refers to the
code *after* `x` has been applied.

This is the way to sequence order-dependent edits, which `add` refuses. Neither argument is
modified.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function Base.merge(x::AbstractReplacements, other::AbstractReplacements)
    @check_ptrs x other
    ptr = clang_Replacements_merge(x, other)
    @assert ptr != C_NULL "Failed to merge Replacements"
    return Replacements(ptr)
end

"""
    getAffectedRanges(x::AbstractReplacements) -> Vector{Tuple{UInt32,UInt32}}
Return the `(offset, length)` ranges the changed code occupies *after* the replacements are
applied.

Clang hands these back as a `std::vector<tooling::Range>`, so the shim reports the count and
fills a caller buffer; this does both halves.
"""
function getAffectedRanges(x::AbstractReplacements)
    @check_ptrs x
    n = clang_Replacements_getAffectedRanges(x, C_NULL, C_NULL, 0)
    n == 0 && return Tuple{UInt32,UInt32}[]
    offsets = Vector{UInt32}(undef, n)
    lengths = Vector{UInt32}(undef, n)
    clang_Replacements_getAffectedRanges(x, offsets, lengths, n)
    return [(offsets[i], lengths[i]) for i in 1:n]
end

"""
    getShiftedCodePosition(x::AbstractReplacements, position::Integer) -> UInt32
Return where byte `position` in the original code ends up once the replacements are applied.

An insertion exactly at `position` shifts it past the inserted text.
"""
function getShiftedCodePosition(x::AbstractReplacements, position::Integer)
    @check_ptrs x
    return clang_Replacements_getShiftedCodePosition(x, position)
end

"""
    Base.size(x::AbstractReplacements) -> UInt32
Return how many replacements the set holds.
"""
function Base.size(x::AbstractReplacements)
    @check_ptrs x
    return clang_Replacements_size(x)
end

"""
    clear(x::AbstractReplacements)
Drop every replacement in the set.
"""
function clear(x::AbstractReplacements)
    @check_ptrs x
    return clang_Replacements_clear(x)
end

"""
    empty(x::AbstractReplacements) -> Bool
Return whether the set holds no replacements.
"""
function empty(x::AbstractReplacements)
    @check_ptrs x
    return clang_Replacements_empty(x)
end

"""
    getReplacement(x::AbstractReplacements, i::Integer) -> Replacement
Return the `i`-th replacement of the set, counting from 0 in Clang's own order (by file,
then offset, then length).

The result is *borrowed* from the set: do not `dispose` it, and do not hold it across an
`add`, `clear` or `merge`.
"""
function getReplacement(x::AbstractReplacements, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_Replacements_size(x) "replacement index out of range"
    return Replacement(clang_Replacements_getReplacement(x, i))
end

"""
    applyAllReplacements(x::AbstractReplacements, rewriter::AbstractRewriter) -> Bool
Apply every replacement in `x` through `rewriter`, returning `true` only if all of them
applied.

The applications are independent: one failing does not stop the others.
"""
function applyAllReplacements(x::AbstractReplacements, rewriter::AbstractRewriter)
    @check_ptrs x rewriter
    return clang_tooling_applyAllReplacements(x, rewriter)
end

"""
    applyAllReplacements(code::AbstractString, x::AbstractReplacements) -> (Bool, String)
Apply every replacement in `x` to `code` and return the rewritten text.

This is the string-level form, with no `SourceManager` and no `Rewriter` anywhere: the file
path stored in each replacement is ignored entirely. Clang returns an
`llvm::Expected<std::string>`, so the first half of the tuple says whether it succeeded and
the second is either the new code or the error message.
"""
function applyAllReplacements(code::AbstractString, x::AbstractReplacements)
    @check_ptrs x
    ok = Ref{Bool}(false)
    out = get_string(clang_tooling_applyAllReplacementsToCode(code, x, ok))
    return ok[], out
end

"""
    formatAndApplyAllReplacements(file_path::AbstractString, x::AbstractReplacements,
                                  rewriter::AbstractRewriter, style::AbstractString="file") -> Bool
Apply every replacement in `x` to `file_path` through `rewriter` *and* run clang-format over
the ranges that changed.

Clang's own entry point takes a whole file-to-replacements map; this is the single-file case
of it, which is the one a generator building edits for one buffer wants. `style` is a
clang-format style name — `"LLVM"`, `"Google"`, or `"file"` to read a `.clang-format`
alongside `file_path`.

`x` must be conflict-free, which is exactly what building it through `add` guarantees.
"""
function formatAndApplyAllReplacements(file_path::AbstractString, x::AbstractReplacements,
                                       rewriter::AbstractRewriter,
                                       style::AbstractString="file")
    @check_ptrs x rewriter
    return clang_tooling_formatAndApplyAllReplacements(file_path, x, rewriter, style)
end
