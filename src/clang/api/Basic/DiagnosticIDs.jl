# DiagnosticIDs
DiagnosticIDs() = DiagnosticIDs(create_diagnostic_ids())

"""
    create_diagnostic_ids() -> CXDiagnosticIDs
Return a pointer to a `clang::DiagnosticIDs` object.
"""
function create_diagnostic_ids()
    status = Ref{CXInit_Error}(CXInit_NoError)
    ids = clang_DiagnosticIDs_create(status)
    @assert status[] == CXInit_NoError
    return ids
end
