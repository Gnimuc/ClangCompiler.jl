"""
    struct DiagnosticOptions <: AbstractDiagnosticOptions
Hold a pointer to a `clang::DiagnosticOptions` object.
"""
struct DiagnosticOptions <: AbstractDiagnosticOptions
    ptr::CXDiagnosticOptions
end

Base.unsafe_convert(::Type{CXDiagnosticOptions}, x::DiagnosticOptions) = x.ptr
Base.cconvert(::Type{CXDiagnosticOptions}, x::DiagnosticOptions) = x
