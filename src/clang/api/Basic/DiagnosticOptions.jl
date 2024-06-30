# DiagnosticOptions
DiagnosticOptions() = DiagnosticOptions(create_diagnostic_opts())

"""
    create_diagnostic_opts() -> CXDiagnosticOptions
Return a pointer to a `clang::DiagnosticOptions` object.
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
