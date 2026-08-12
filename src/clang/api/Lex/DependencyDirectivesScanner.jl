# DependencyDirectivesScanner
"""
    scanSourceForDependencyDirectives(source::AbstractString;
                                      diag=nothing,
                                      loc::SourceLocation=SourceLocation()) ->
        Tuple{DependencyDirectivesScan,Bool}
Scan `source` down to the preprocessor directives that can change what a translation unit
includes — `#define`, `#include`, `#import`, `@import`, the C++20 module declarations and
the conditional logic wrapping any of them — and return the scan together with whether it
hit an error.

Nothing is constructed to do this: no `Preprocessor`, no `SourceManager`, no
`FileManager`. That is what makes it cheap enough to re-run whenever a file on disk changes
in order to decide whether a precompiled header has to be rebuilt. `diag` and `loc` only
place the diagnostics a malformed directive would report; with `diag = nothing` those are
discarded and `loc` is irrelevant.

A failed scan still yields a usable handle holding whatever was scanned before the failure.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function scanSourceForDependencyDirectives(source::AbstractString; diag::Union{AbstractDiagnosticsEngine,Nothing}=nothing, loc::SourceLocation=SourceLocation())
    d = diag === nothing ? CXDiagnosticsEngine(C_NULL) : Base.unsafe_convert(CXDiagnosticsEngine, diag)
    had_error = Ref{Bool}(false)
    s = clang_DependencyDirectivesScan_create(source, ncodeunits(source), d, loc, had_error)
    @assert s != C_NULL "Failed to create DependencyDirectivesScan"
    return (DependencyDirectivesScan(s), had_error[])
end

dispose(x::DependencyDirectivesScan) = clang_DependencyDirectivesScan_dispose(x)

"""
    getNumTokens(x::AbstractDependencyDirectivesScan) -> Cuint
Return the number of tokens the scan kept, across all directives.
"""
function getNumTokens(x::AbstractDependencyDirectivesScan)
    @check_ptrs x
    return clang_DependencyDirectivesScan_getNumTokens(x)
end

"""
    getToken(x::AbstractDependencyDirectivesScan, idx::Integer) ->
        NamedTuple{(:offset, :length, :kind, :flags)}
Return token `idx` (0-based): where it starts and how long it is in the scanned input, its
raw `clang::tok::TokenKind` value, and its raw token-flag bitmask (the bits `CXTokenFlags`
names).

`idx` must be less than [`getNumTokens`](@ref); the shim indexes the token vector unchecked.
"""
function getToken(x::AbstractDependencyDirectivesScan, idx::Integer)
    @check_ptrs x
    @assert 0 <= idx < getNumTokens(x) "token index out of range"
    offset = Ref{Cuint}(0)
    len = Ref{Cuint}(0)
    kind = Ref{Cuint}(0)
    flags = Ref{Cuint}(0)
    clang_DependencyDirectivesScan_getToken(x, idx, offset, len, kind, flags)
    return (offset=offset[], length=len[], kind=kind[], flags=flags[])
end

"""
    getNumDirectives(x::AbstractDependencyDirectivesScan) -> Cuint
Return the number of directives the scan recorded. A successful scan always ends with a
`pp_eof` directive, so this is never zero.
"""
function getNumDirectives(x::AbstractDependencyDirectivesScan)
    @check_ptrs x
    return clang_DependencyDirectivesScan_getNumDirectives(x)
end

"""
    getDirectiveKind(x::AbstractDependencyDirectivesScan, idx::Integer) -> CXDependencyDirectiveKind
Return which directive (or module declaration) entry `idx` records. `idx` is 0-based and
must be less than [`getNumDirectives`](@ref).
"""
function getDirectiveKind(x::AbstractDependencyDirectivesScan, idx::Integer)
    @check_ptrs x
    @assert 0 <= idx < getNumDirectives(x) "directive index out of range"
    return clang_DependencyDirectivesScan_getDirectiveKind(x, idx)
end

"""
    getNumDirectiveTokens(x::AbstractDependencyDirectivesScan, idx::Integer) -> Cuint
Return how many tokens directive `idx` spans. `idx` is 0-based and must be less than
[`getNumDirectives`](@ref).
"""
function getNumDirectiveTokens(x::AbstractDependencyDirectivesScan, idx::Integer)
    @check_ptrs x
    @assert 0 <= idx < getNumDirectives(x) "directive index out of range"
    return clang_DependencyDirectivesScan_getNumDirectiveTokens(x, idx)
end

"""
    getDirectiveFirstTokenIndex(x::AbstractDependencyDirectivesScan, idx::Integer) -> Cuint
Return the index, in the flat token array, of directive `idx`'s first token; `0` when the
directive spans none. `idx` is 0-based and must be less than [`getNumDirectives`](@ref).
"""
function getDirectiveFirstTokenIndex(x::AbstractDependencyDirectivesScan, idx::Integer)
    @check_ptrs x
    @assert 0 <= idx < getNumDirectives(x) "directive index out of range"
    return clang_DependencyDirectivesScan_getDirectiveFirstTokenIndex(x, idx)
end

"""
    getDirectiveTokens(x::AbstractDependencyDirectivesScan, idx::Integer) -> Vector
Return directive `idx`'s tokens, each in the shape [`getToken`](@ref) produces.
"""
function getDirectiveTokens(x::AbstractDependencyDirectivesScan, idx::Integer)
    n = getNumDirectiveTokens(x, idx)
    first_idx = getDirectiveFirstTokenIndex(x, idx)
    return [getToken(x, first_idx + i) for i = 0:(Int(n) - 1)]
end

"""
    printAsSource(x::AbstractDependencyDirectivesScan) -> String
Return the minimized source the scanned directives render back to: the original text with
everything that cannot affect dependencies removed.
"""
function printAsSource(x::AbstractDependencyDirectivesScan)
    @check_ptrs x
    return get_string(clang_DependencyDirectivesScan_printAsSource(x))
end
