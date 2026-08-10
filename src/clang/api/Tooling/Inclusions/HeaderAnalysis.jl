# HeaderAnalysis — free functions in `clang::tooling`.

"""
    isSelfContainedHeader(fe::AbstractFileEntryRef, src_mgr::AbstractSourceManager,
                          header_info::AbstractHeaderSearch) -> Bool
Return whether `fe` names a header that can be handed to the parser on its own.

Self-contained means it has a header guard, or has been `#import`ed, or contains `#import`s
— *and* carries no dont-include-me pattern. `header_info` must be the `HeaderSearch` the
preprocessor behind `src_mgr` uses, because the guard state is read out of its per-file
info.

This can be expensive: when the per-file info does not settle the question, Clang falls back
to scanning the file's text.
"""
function isSelfContainedHeader(fe::AbstractFileEntryRef, src_mgr::AbstractSourceManager,
                               header_info::AbstractHeaderSearch)
    @check_ptrs fe src_mgr header_info
    return clang_tooling_isSelfContainedHeader(fe, src_mgr, header_info)
end

"""
    codeContainsImports(code::AbstractString) -> Bool
Return whether `code` contains any `#import` directive.
"""
codeContainsImports(code::AbstractString) = clang_tooling_codeContainsImports(code)

"""
    parseIWYUPragma(text::AbstractString) -> Union{String,Nothing}
Return the include-what-you-use directive `text` begins with, or `nothing` when it does not
begin one.

`"// IWYU pragma: keep"` answers `"keep"`. Only the first line of a multi-line comment is
considered. Clang returns a `std::optional<StringRef>`, and the shim splits the two halves
apart, so an empty directive and a missing one stay distinguishable.
"""
function parseIWYUPragma(text::AbstractString)
    found = Ref{Bool}(false)
    s = get_string(clang_tooling_parseIWYUPragma(text, found))
    return found[] ? s : nothing
end
