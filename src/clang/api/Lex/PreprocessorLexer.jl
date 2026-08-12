# PreprocessorLexer
"""
    LexIncludeFilename(x::AbstractPreprocessorLexer, filename_tok::AbstractToken)
Lex one token in header-name mode, so that `<stdio.h>` or `"foo.h"` comes back as a single
`header_name` token rather than as a run of punctuators.

Destructive: it consumes a token from the live stream, exactly as
[`Lex`](@ref) on the preprocessor does. Clang requires the lexer to be inside a directive,
a protected flag with no getter, so the shim sets that flag around the lex and clears it
afterwards.
"""
function LexIncludeFilename(x::AbstractPreprocessorLexer, filename_tok::AbstractToken)
    @check_ptrs x filename_tok
    clang_PreprocessorLexer_LexIncludeFilename(x, filename_tok)
    return nothing
end

"""
    isLexingRawMode(x::AbstractPreprocessorLexer) -> Bool
Return whether the lexer is in raw mode, which disables macro expansion, identifier lookup
and diagnostics. A raw-mode lexer may have no preprocessor at all.
"""
function isLexingRawMode(x::AbstractPreprocessorLexer)
    @check_ptrs x
    return clang_PreprocessorLexer_isLexingRawMode(x)
end

"""
    getPP(x::AbstractPreprocessorLexer) -> Preprocessor
Return the preprocessor driving this lexer, as a carrier holding `NULL` when there is none
(only possible in raw mode). [`getFileID`](@ref) and [`getFileEntry`](@ref) require it to
be non-null.
"""
function getPP(x::AbstractPreprocessorLexer)
    @check_ptrs x
    return Preprocessor(clang_PreprocessorLexer_getPP(x))
end

"""
    getFileID(x::AbstractPreprocessorLexer) -> FileID
Return the `FileID` of the file being lexed — which file the preprocessor is reading right
now, the thing an error raised inside a nested `#include` has to name.

Requires `getPP(x)` to be non-null; Clang asserts it. This function allocates and one
should call `dispose` to release the resources after using this object.
"""
function getFileID(x::AbstractPreprocessorLexer)
    @check_ptrs x
    @assert !is_null_handle(getPP(x)) "the lexer has no preprocessor"
    return FileID(clang_PreprocessorLexer_getFileID(x))
end

"""
    getInitialNumSLocEntries(x::AbstractPreprocessorLexer) -> Cuint
Return how many source-location entries the source manager held before this file was
entered.
"""
function getInitialNumSLocEntries(x::AbstractPreprocessorLexer)
    @check_ptrs x
    return clang_PreprocessorLexer_getInitialNumSLocEntries(x)
end

"""
    getFileEntry(x::AbstractPreprocessorLexer) -> FileEntryRef
Return the file behind this lexer's `FileID`, as a carrier holding `NULL` when the `FileID`
names a memory buffer rather than a file on disk.

Requires `getPP(x)` to be non-null; Clang asserts it. This function allocates and one
should call `dispose` to release the resources after using this object.
"""
function getFileEntry(x::AbstractPreprocessorLexer)
    @check_ptrs x
    @assert !is_null_handle(getPP(x)) "the lexer has no preprocessor"
    return FileEntryRef(clang_PreprocessorLexer_getFileEntry(x))
end

"""
    getNumConditionals(x::AbstractPreprocessorLexer) -> Cuint
Return how many `#if`/`#ifdef`/`#ifndef` blocks the lexer is currently inside.
"""
function getNumConditionals(x::AbstractPreprocessorLexer)
    @check_ptrs x
    return clang_PreprocessorLexer_getNumConditionals(x)
end

"""
    getConditionalStack(x::AbstractPreprocessorLexer) ->
        Vector{Tuple{SourceLocation,Bool,Bool,Bool}}
Return the conditional blocks the lexer is inside, outermost first. Each entry holds where
the conditional started, whether it sat inside a skipped block, whether tokens were already
emitted for it, and whether its `#else` has been seen.
"""
function getConditionalStack(x::AbstractPreprocessorLexer)
    @check_ptrs x
    n = getNumConditionals(x)
    locs = Vector{CXSourceLocation_}(undef, n)
    was_skipping = Vector{Bool}(undef, n)
    found_non_skip = Vector{Bool}(undef, n)
    found_else = Vector{Bool}(undef, n)
    n > 0 && clang_PreprocessorLexer_getConditionalStack(x, locs, was_skipping, found_non_skip, found_else)
    return [(SourceLocation(locs[i]), was_skipping[i], found_non_skip[i], found_else[i]) for i = 1:n]
end
