"""
    struct DiagnosticOptions <: AbstractDiagnosticOptions
Hold a pointer to a `clang::DiagnosticOptions` object.
"""
struct DiagnosticOptions <: AbstractDiagnosticOptions
    ptr::CXDiagnosticOptions
end
