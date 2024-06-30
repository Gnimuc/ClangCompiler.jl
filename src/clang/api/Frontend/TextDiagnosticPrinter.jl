# TextDiagnosticPrinter
function TextDiagnosticPrinter(opts::DiagnosticOptions)
    @check_ptrs opts
    consumer = clang_TextDiagnosticPrinter_create(opts)
    @assert consumer != C_NULL "Failed to create TextDiagnosticPrinter"
    return TextDiagnosticPrinter(consumer)
end
