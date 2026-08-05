"""
    struct DiagnosticIDs <: AbstractDiagnosticIDs
Hold a pointer to a `clang::DiagnosticIDs` object.
"""
struct DiagnosticIDs <: AbstractDiagnosticIDs
    ptr::CXDiagnosticIDs
end

