"""
    struct TextDiagnosticPrinter <: AbstractTextDiagnosticPrinter
Hold a pointer to a `clang::TextDiagnosticPrinter` object.
"""
struct TextDiagnosticPrinter <: AbstractTextDiagnosticPrinter
    ptr::CXDiagnosticConsumer
end

Base.unsafe_convert(::Type{CXDiagnosticConsumer}, x::TextDiagnosticPrinter) = x.ptr
Base.cconvert(::Type{CXDiagnosticConsumer}, x::TextDiagnosticPrinter) = x
