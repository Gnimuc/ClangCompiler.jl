"""
    struct DiagnosticOptions <: Any
Hold a pointer to a `clang::DiagnosticOptions` object.
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

function PrintStats(x::DiagnosticOptions)
    @check_ptrs x
    return clang_DiagnosticOptions_PrintStats(x.ptr)
end

function set_show_colors(x::DiagnosticOptions, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticOptions_setShowColors(x.ptr, should_show)
end

function set_show_presumed_loc(x::DiagnosticOptions, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticOptions_setShowPresumedLoc(x.ptr, should_show)
end
