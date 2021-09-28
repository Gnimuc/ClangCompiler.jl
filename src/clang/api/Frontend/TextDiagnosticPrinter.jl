# TextDiagnosticPrinter
function TextDiagnosticPrinter(opts::DiagnosticOptions)
    @check_ptrs opts
    status = Ref{CXInit_Error}(CXInit_NoError)
    consumer = clang_TextDiagnosticPrinter_create(opts.ptr, status)
    @assert status[] == CXInit_NoError
    return TextDiagnosticPrinter(consumer)
end
