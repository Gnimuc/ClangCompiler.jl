"""
    struct TextDiagnosticPrinter <: AbstractTextDiagnosticPrinter
Hold a pointer to a `clang::TextDiagnosticPrinter` object.
"""
struct TextDiagnosticPrinter <: AbstractTextDiagnosticPrinter
    ptr::CXDiagnosticConsumer
end

