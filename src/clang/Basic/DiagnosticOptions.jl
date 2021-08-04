"""
    struct DiagnosticOptions <: Any
Holds a pointer to a `clang::DiagnosticOptions` object.
"""
struct DiagnosticOptions
    ptr::CXDiagnosticOptions
end
DiagnosticOptions() = DiagnosticOptions(create_diagnostic_opts())

"""
    create_diagnostic_opts() -> CXDiagnosticOptions
Return a pointer to a `clang::DiagnosticOptions` object.
"""
function create_diagnostic_opts()
    status = Ref{CXInit_Error}(CXInit_NoError)
    opts = clang_DiagnosticOptions_create(status)
    @assert status[] == CXInit_NoError
    return opts
end

function print_stats(x::DiagnosticOptions)
    @assert x.ptr != C_NULL "DiagnosticOptions has a NULL pointer."
    return clang_DiagnosticOptions_PrintStats(x.ptr)
end

function set_show_colors(x::DiagnosticOptions, should_show::Bool)
    @assert x.ptr != C_NULL "DiagnosticOptions has a NULL pointer."
    return clang_DiagnosticOptions_setShowColors(x.ptr, should_show)
end

function set_show_presumed_loc(x::DiagnosticOptions, should_show::Bool)
    @assert x.ptr != C_NULL "DiagnosticOptions has a NULL pointer."
    return clang_DiagnosticOptions_setShowPresumedLoc(x.ptr, should_show)
end
