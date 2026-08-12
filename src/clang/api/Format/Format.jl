# FormatStyle

"""
    dispose(x::FormatStyle)
Release the heap copy of `clang::format::FormatStyle` behind `x`.
"""
dispose(x::FormatStyle) = clang_FormatStyle_dispose(x)

"""
    getLanguage(x::AbstractFormatStyle) -> CXLanguageKind
Return the language the style targets.
"""
function getLanguage(x::AbstractFormatStyle)
    @check_ptrs x
    return clang_FormatStyle_getLanguage(x)
end

"""
    setLanguage(x::AbstractFormatStyle, language::CXLanguageKind)
Set the language the style targets. `parseConfiguration` reads this field to pick the base
style when the YAML document carries a `BasedOnStyle` key.
"""
function setLanguage(x::AbstractFormatStyle, language::CXLanguageKind)
    @check_ptrs x
    return clang_FormatStyle_setLanguage(x, language)
end

"""
    getLLVMStyle(language::CXLanguageKind=CXLanguageKind_LK_Cpp) -> FormatStyle
Return the style that follows the LLVM coding standards.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getLLVMStyle(language::CXLanguageKind=CXLanguageKind_LK_Cpp)
    ptr = clang_format_getLLVMStyle(language)
    @assert ptr != C_NULL "Failed to create FormatStyle"
    return FormatStyle(ptr)
end

"""
    getGoogleStyle(language::CXLanguageKind=CXLanguageKind_LK_Cpp) -> FormatStyle
Return the style that follows Google's style guide for `language`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getGoogleStyle(language::CXLanguageKind=CXLanguageKind_LK_Cpp)
    ptr = clang_format_getGoogleStyle(language)
    @assert ptr != C_NULL "Failed to create FormatStyle"
    return FormatStyle(ptr)
end

"""
    getNoStyle() -> FormatStyle
Return the style under which formatting changes nothing at all.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getNoStyle()
    ptr = clang_format_getNoStyle()
    @assert ptr != C_NULL "Failed to create FormatStyle"
    return FormatStyle(ptr)
end

"""
    getPredefinedStyle(name::AbstractString,
                       language::CXLanguageKind=CXLanguageKind_LK_Cpp) -> Union{FormatStyle,Nothing}
Return the predefined style called `name` — "LLVM", "Google", "Chromium", "Mozilla",
"WebKit", "GNU", "Microsoft", "clang-format" or "none", compared case-insensitively — or
`nothing` when the name is not one of them.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getPredefinedStyle(name::AbstractString, language::CXLanguageKind=CXLanguageKind_LK_Cpp)
    ptr = clang_format_getPredefinedStyle(name, language)
    return ptr == C_NULL ? nothing : FormatStyle(ptr)
end

"""
    getStyle(style_name::AbstractString, filename::AbstractString,
             fallback_style::AbstractString="LLVM", code::AbstractString="",
             allow_unknown_options::Bool=false) -> Union{FormatStyle,Nothing}
Interpret `style_name` the way clang-format's `--style=` does: a predefined style name, an
inline `{key: value, ...}` document, `"file"` (search the parent directories of `filename`,
or the current directory when it is empty, for a `.clang-format`) or `"file:<path>"`.

`code` is only used to guess the language when `filename` is not enough. The lookup runs
against the real file system. Returns `nothing` when no style could be determined; the
reason is written to standard error by clang itself.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getStyle(style_name::AbstractString, filename::AbstractString, fallback_style::AbstractString="LLVM", code::AbstractString="", allow_unknown_options::Bool=false)
    ptr = clang_format_getStyle(style_name, filename, fallback_style, code, allow_unknown_options)
    return ptr == C_NULL ? nothing : FormatStyle(ptr)
end

"""
    parseConfiguration(x::AbstractFormatStyle, config::AbstractString,
                       allow_unknown_options::Bool=false) -> CXParseError
Parse a YAML `.clang-format` document *into* `x`, returning `CXParseError_Success` on
success and the specific parse error otherwise.

Options the document does not mention keep the value they already had in `x`, unless the
document sets `BasedOnStyle` — in which case the base is taken from `getLanguage(x)`.
"""
function parseConfiguration(x::AbstractFormatStyle, config::AbstractString, allow_unknown_options::Bool=false)
    @check_ptrs x
    return clang_format_parseConfiguration(config, x, allow_unknown_options)
end

"""
    configurationAsText(x::AbstractFormatStyle) -> String
Serialize `x` back to a YAML `.clang-format` document.
"""
function configurationAsText(x::AbstractFormatStyle)
    @check_ptrs x
    return get_string(clang_format_configurationAsText(x))
end

"""
    guessLanguage(filename::AbstractString, code::AbstractString) -> CXLanguageKind
Guess the language of `code` from its file name and its contents. Defaults to
`CXLanguageKind_LK_Cpp`.
"""
guessLanguage(filename::AbstractString, code::AbstractString) = clang_format_guessLanguage(filename, code)

"""
    getLanguageName(language::CXLanguageKind) -> String
Return a printable name for `language` ("C++", "Json", ...), or "Unknown".
"""
getLanguageName(language::CXLanguageKind) = get_string(clang_format_getLanguageName(language))

# Text in, text out. Each of these formats the WHOLE of `code`, applies the edit script
# clang produced inside the shim, and returns the resulting text. The empty string means
# either that `code` was empty or that the attempt failed — clang logs the reason to
# standard error.

"""
    reformat(x::AbstractFormatStyle, code::AbstractString,
             filename::AbstractString="<stdin>") -> (String, Bool, UInt32)
Reformat the whole of `code` under `x` and return the formatted text together with the two
fields of `clang::format::FormattingAttemptStatus`: whether formatting completed, and — when
it did not — the one-based line at which clang's best-effort analysis places the
non-recoverable syntax error that stopped it.

`filename` only decides which language rules apply; nothing is read from disk.
"""
function reformat(x::AbstractFormatStyle, code::AbstractString, filename::AbstractString="<stdin>")
    @check_ptrs x
    complete = Ref{Bool}(true)
    line = Ref{Cuint}(0)
    s = get_string(clang_format_reformat(x, code, filename, complete, line))
    return s, complete[], line[]
end

"""
    sortIncludes(x::AbstractFormatStyle, code::AbstractString,
                 filename::AbstractString="<stdin>") -> String
Sort every `#include` block of `code` under `x` and return the resulting text.
"""
function sortIncludes(x::AbstractFormatStyle, code::AbstractString, filename::AbstractString="<stdin>")
    @check_ptrs x
    return get_string(clang_format_sortIncludes(x, code, filename))
end

"""
    cleanup(x::AbstractFormatStyle, code::AbstractString,
            filename::AbstractString="<stdin>") -> String
Remove the erroneous and redundant leftovers of a mechanical edit — dangling commas, empty
namespaces, redundant constructor-initializer colons — and return the resulting text.
"""
function cleanup(x::AbstractFormatStyle, code::AbstractString, filename::AbstractString="<stdin>")
    @check_ptrs x
    return get_string(clang_format_cleanup(x, code, filename))
end

"""
    fixNamespaceEndComments(x::AbstractFormatStyle, code::AbstractString,
                            filename::AbstractString="<stdin>") -> String
Add or correct the `// namespace foo` comment on every namespace closing brace of `code`.
"""
function fixNamespaceEndComments(x::AbstractFormatStyle, code::AbstractString, filename::AbstractString="<stdin>")
    @check_ptrs x
    return get_string(clang_format_fixNamespaceEndComments(x, code, filename))
end

"""
    sortUsingDeclarations(x::AbstractFormatStyle, code::AbstractString,
                          filename::AbstractString="<stdin>") -> String
Sort every run of consecutive `using` declarations in `code`.
"""
function sortUsingDeclarations(x::AbstractFormatStyle, code::AbstractString, filename::AbstractString="<stdin>")
    @check_ptrs x
    return get_string(clang_format_sortUsingDeclarations(x, code, filename))
end

"""
    formatReplacements(x::AbstractFormatStyle, code::AbstractString,
                       offsets::Vector{UInt32}, lengths::Vector{UInt32},
                       texts::Vector{String}, filename::AbstractString="<stdin>") -> String
Apply an edit script to `code` and reformat the regions it touched.

The script is three parallel vectors: the byte offset into `code` at which each replacement
starts, the number of bytes it replaces, and the text to put there. The empty string comes
back when the script is order-dependent — `clang::tooling::Replacements` refuses to hold
two edits whose result depends on which is applied first.
"""
function formatReplacements(x::AbstractFormatStyle, code::AbstractString, offsets::Vector{UInt32}, lengths::Vector{UInt32}, texts::Vector{String}, filename::AbstractString="<stdin>")
    @check_ptrs x
    @assert length(offsets) == length(lengths) == length(texts) "offsets, lengths and texts must be parallel"
    return get_string(clang_format_formatReplacements(x, code, filename, offsets, lengths, texts, length(texts)))
end

"""
    cleanupAroundReplacements(x::AbstractFormatStyle, code::AbstractString,
                              offsets::Vector{UInt32}, lengths::Vector{UInt32},
                              texts::Vector{String},
                              filename::AbstractString="<stdin>") -> String
Apply an edit script to `code` and clean up around the edits instead of reformatting them,
returning the resulting text. The script has the same three-parallel-vector shape as
`formatReplacements`.

This is also how `#include` directives are inserted and removed, through clang's
`UINT_MAX`-offset convention: an entry whose offset is `typemax(UInt32)` and whose length is
`0` inserts its text — a whole `#include "..."` line — into the right block, and one whose
offset is `typemax(UInt32)` and whose length is `1` removes the header its text names.
"""
function cleanupAroundReplacements(x::AbstractFormatStyle, code::AbstractString, offsets::Vector{UInt32}, lengths::Vector{UInt32}, texts::Vector{String}, filename::AbstractString="<stdin>")
    @check_ptrs x
    @assert length(offsets) == length(lengths) == length(texts) "offsets, lengths and texts must be parallel"
    return get_string(clang_format_cleanupAroundReplacements(x, code, filename, offsets, lengths, texts, length(texts)))
end
