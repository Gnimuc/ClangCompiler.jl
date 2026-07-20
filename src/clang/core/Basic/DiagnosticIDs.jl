"""
    struct DiagnosticIDs <: AbstractDiagnosticIDs
Hold a pointer to a `clang::DiagnosticIDs` object.
"""
struct DiagnosticIDs <: AbstractDiagnosticIDs
    ptr::CXDiagnosticIDs
end

Base.unsafe_convert(::Type{CXDiagnosticIDs}, x::DiagnosticIDs) = x.ptr
Base.cconvert(::Type{CXDiagnosticIDs}, x::DiagnosticIDs) = x
