"""
    struct TextDiagnosticPrinter <: AbstractDiagnosticConsumer
Holds a pointer to a `clang::TextDiagnosticPrinter` object.
"""
struct TextDiagnosticPrinter <: AbstractDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end

function TextDiagnosticPrinter(opts::DiagnosticOptions)
    @assert opts.ptr != C_NULL "DiagnosticOptions has a NULL pointer."
    status = Ref{CXInit_Error}(CXInit_NoError)
    consumer = clang_TextDiagnosticPrinter_create(opts.ptr, status)
    @assert status[] == CXInit_NoError
    return TextDiagnosticPrinter(consumer)
end
