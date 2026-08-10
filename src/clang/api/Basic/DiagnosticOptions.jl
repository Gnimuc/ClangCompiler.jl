# DiagnosticOptions
DiagnosticOptions() = DiagnosticOptions(create_diagnostic_opts())

"""
    create_diagnostic_opts() -> CXDiagnosticOptions
Return a pointer to a `clang::DiagnosticOptions` object.

The options come back already holding the caller's reference, so they survive being lent to a
printer, an engine or a tool invocation and one [`dispose`](@ref) at the end still frees them
(MARSHALLING.md §12). Several consumers may hold the same options at once, and the order they
are disposed in relative to those consumers does not matter.
"""
function create_diagnostic_opts()
    opts = clang_DiagnosticOptions_create()
    @assert opts != C_NULL "Failed to create DiagnosticOptions"
    return opts
end

function PrintStats(x::DiagnosticOptions)
    @check_ptrs x
    return clang_DiagnosticOptions_PrintStats(x)
end

function setShowColors(x::DiagnosticOptions, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticOptions_setShowColors(x, should_show)
end

function setShowPresumedLoc(x::DiagnosticOptions, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticOptions_setShowPresumedLoc(x, should_show)
end

"""
    getVerifyPrefixes(x::AbstractDiagnosticOptions) -> Vector{String}
The directive prefixes [`VerifyDiagnosticConsumer`](@ref) recognises, sorted.
"""
function getVerifyPrefixes(x::AbstractDiagnosticOptions)
    @check_ptrs x
    # Int() first: the count is a C `unsigned`, and `0:(UInt32(0) - 1)` is four billion
    # iterations rather than the empty range an empty list wants.
    n = Int(clang_DiagnosticOptions_getVerifyPrefixesNum(x))
    return [get_string(clang_DiagnosticOptions_getVerifyPrefix(x, i)) for i in 0:(n - 1)]
end

"""
    addVerifyPrefix(x::AbstractDiagnosticOptions, prefix::AbstractString)
Add a directive prefix for [`VerifyDiagnosticConsumer`](@ref) to recognise.

Clang fills this list from `-verify` / `-verify=<prefix>` alone — plain `-verify` adds
`"expected"` — so a caller that installs the consumer itself must add at least one prefix,
or the consumer finds no directives in any source and reports that as an error.
"""
function addVerifyPrefix(x::AbstractDiagnosticOptions, prefix::AbstractString)
    @check_ptrs x
    @assert !isempty(prefix) "a verify prefix must not be empty"
    return clang_DiagnosticOptions_addVerifyPrefix(x, prefix)
end

dispose(x::DiagnosticOptions) = clang_DiagnosticOptions_dispose(x)
