# html
#
# These free functions introduce no carrier of their own: each one MUTATES an existing
# `Rewriter`, turning the source of one `FileID` into HTML. Read the result back with
# `getRewriteBufferText`, so the whole round trip stays in memory.

# Both endpoints of a highlighted range have to expand into the same file — clang asserts
# it — and answering that needs the rewriter's own SourceManager.
function _same_expansion_file(x::AbstractRewriter, b::SourceLocation, e::SourceLocation)
    sm = getSourceMgr(x)
    fb = getFileID(sm, getExpansionLoc(sm, b))
    fe = getFileID(sm, getExpansionLoc(sm, e))
    same = getHashValue(fb) == getHashValue(fe)
    dispose(fb)
    dispose(fe)
    return same
end

"""
    HighlightRange(x::AbstractRewriter, b::SourceLocation, e::SourceLocation,
                   start_tag::AbstractString, end_tag::AbstractString,
                   is_token_range::Bool=true)
Wrap the source between `b` and `e` in `start_tag`/`end_tag`, repeating the pair on every
line when the range is multiline so the markup nests correctly.

`is_token_range` extends `e` over the whole of the token that starts there.

Both locations must be valid and must expand into the same file — clang asserts the latter.
"""
function HighlightRange(x::AbstractRewriter, b::SourceLocation, e::SourceLocation, start_tag::AbstractString, end_tag::AbstractString, is_token_range::Bool=true)
    @check_ptrs x
    @assert isValid(b) && isValid(e) "highlighted range endpoints must be valid source locations"
    @assert _same_expansion_file(x, b, e) "highlighted range endpoints must expand into the same file"
    return clang_html_HighlightRange(x, b, e, start_tag, end_tag, is_token_range)
end

"""
    HighlightRange(x::AbstractRewriter, range::CharSourceRange,
                   start_tag::AbstractString, end_tag::AbstractString)
`CharSourceRange` form of `HighlightRange`; the range's token/character flag decides whether
the last token is covered in full.
"""
HighlightRange(x::AbstractRewriter, range::CharSourceRange, start_tag::AbstractString, end_tag::AbstractString) = HighlightRange(x, getBegin(range), getEnd(range), start_tag, end_tag, isTokenRange(range))

"""
    EscapeText(x::AbstractRewriter, id::FileID, escape_spaces::Bool=false,
               replace_tabs::Bool=false)
Rewrite the file `id` names so the characters HTML would otherwise read as markup become
entities. `escape_spaces` turns runs of spaces into non-breaking spaces and `replace_tabs`
expands tabs.

`id` must be valid and belong to the rewriter's own `SourceManager`.
"""
function EscapeText(x::AbstractRewriter, id::FileID, escape_spaces::Bool=false, replace_tabs::Bool=false)
    @check_ptrs x id
    @assert isValid(id) "the file ID must designate a source file"
    return clang_html_EscapeText(x, id, escape_spaces, replace_tabs)
end

"""
    EscapeText(s::AbstractString, escape_spaces::Bool=false, replace_tabs::Bool=true) -> String
HTMLize a string rather than a file. Note the different default for `replace_tabs`, which
mirrors clang's own two overloads.
"""
EscapeText(s::AbstractString, escape_spaces::Bool=false, replace_tabs::Bool=true) = get_string(clang_html_EscapeTextOfString(s, escape_spaces, replace_tabs))

"""
    AddLineNumbers(x::AbstractRewriter, id::FileID)
Prefix every line of the file `id` names with a numbered table cell.

`id` must be valid and belong to the rewriter's own `SourceManager`.
"""
function AddLineNumbers(x::AbstractRewriter, id::FileID)
    @check_ptrs x id
    @assert isValid(id) "the file ID must designate a source file"
    return clang_html_AddLineNumbers(x, id)
end

"""
    AddHeaderFooterInternalBuiltinCSS(x::AbstractRewriter, id::FileID, title::AbstractString)
Wrap the file `id` names in a complete HTML document: a `<head>` carrying clang's own
built-in stylesheet inline and `title` as the `<title>`, plus the closing tags.

`id` must be valid and belong to the rewriter's own `SourceManager`.
"""
function AddHeaderFooterInternalBuiltinCSS(x::AbstractRewriter, id::FileID, title::AbstractString)
    @check_ptrs x id
    @assert isValid(id) "the file ID must designate a source file"
    return clang_html_AddHeaderFooterInternalBuiltinCSS(x, id, title)
end

"""
    SyntaxHighlight(x::AbstractRewriter, id::FileID, pp::AbstractPreprocessor)
Relex the file `id` names with clang's own lexer and wrap keywords, comments, literals and
preprocessor directives in `<span class=...>` tags.

`pp` supplies both the language options and the `SourceManager` the relex runs against, so
`id` must be valid and belong to *that* manager — which is also the one `x` was built from.
"""
function SyntaxHighlight(x::AbstractRewriter, id::FileID, pp::AbstractPreprocessor)
    @check_ptrs x id pp
    @assert isValid(id) "the file ID must designate a source file"
    return clang_html_SyntaxHighlight(x, id, pp)
end

"""
    HighlightMacros(x::AbstractRewriter, id::FileID, pp::AbstractPreprocessor)
Re-expand the macros of the file `id` names and annotate each expansion with what it
expanded to.

This reads the macro table as it stands *now*, so it is only meaningful once `pp` has
finished lexing the file; clang describes the result as close rather than exact.

Same precondition as `SyntaxHighlight`: `id` must be valid and belong to `pp`'s
`SourceManager`.
"""
function HighlightMacros(x::AbstractRewriter, id::FileID, pp::AbstractPreprocessor)
    @check_ptrs x id pp
    @assert isValid(id) "the file ID must designate a source file"
    return clang_html_HighlightMacros(x, id, pp)
end
