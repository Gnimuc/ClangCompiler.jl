# DiagnosticIDs
DiagnosticIDs() = DiagnosticIDs(create_diagnostic_ids())

"""
    create_diagnostic_ids() -> CXDiagnosticIDs
Return a pointer to a `clang::DiagnosticIDs` object.
"""
function create_diagnostic_ids()
    ids = clang_DiagnosticIDs_create()
    @assert ids != C_NULL "Failed to create DiagnosticIDs"
    return ids
end
