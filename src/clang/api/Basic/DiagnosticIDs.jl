# DiagnosticIDs
DiagnosticIDs() = DiagnosticIDs(create_diagnostic_ids())

"""
    create_diagnostic_ids() -> CXDiagnosticIDs
Return a pointer to a `clang::DiagnosticIDs` object.

The table comes back already holding the caller's reference, so one table can back several
[`DiagnosticsEngine`](@ref)s in turn and one [`dispose`](@ref) at the end frees it
(MARSHALLING.md §12). Custom diagnostic ids registered through any engine live in this table,
so they stay valid across engines for as long as it does.
"""
function create_diagnostic_ids()
    ids = clang_DiagnosticIDs_create()
    @assert ids != C_NULL "Failed to create DiagnosticIDs"
    return ids
end

dispose(x::DiagnosticIDs) = clang_DiagnosticIDs_dispose(x)
