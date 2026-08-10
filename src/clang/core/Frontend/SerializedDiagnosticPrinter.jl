"""
    struct SerializedDiagnosticPrinter <: AbstractSerializedDiagnosticPrinter
Hold a pointer to the `clang::DiagnosticConsumer` that `clang::serialized_diags::create`
returns.

`clang::serialized_diags` names no public class for it — the factory hands back a
`std::unique_ptr<DiagnosticConsumer>` over a type private to the implementation file — so
this carrier stands for "the serializing consumer" rather than for a class that can be
named in clang's headers.
"""
struct SerializedDiagnosticPrinter <: AbstractSerializedDiagnosticPrinter
    ptr::CXDiagnosticConsumer
end
