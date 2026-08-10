"""
    struct VerifyDiagnosticConsumer <: AbstractVerifyDiagnosticConsumer
Hold a pointer to a `clang::VerifyDiagnosticConsumer` object.

The consumer behind `-verify`: it reads `expected-error`/`expected-warning`/`expected-note`/
`expected-remark` markers out of the source being parsed and reports a diagnostic of its own
for every mismatch with what clang actually emitted.
"""
struct VerifyDiagnosticConsumer <: AbstractVerifyDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end
