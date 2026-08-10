# VerifyDiagnosticConsumer
"""
    VerifyDiagnosticConsumer(diags::DiagnosticsEngine) -> VerifyDiagnosticConsumer
Build the `-verify` consumer: it reads `expected-error`, `expected-warning`,
`expected-note` and `expected-remark` markers out of the source being parsed and, when the
source file ends, reports a diagnostic for every mismatch with what clang actually emitted.

`diags`'s [`DiagnosticOptions`](@ref) must already list at least one verify prefix (see
[`addVerifyPrefix`](@ref)). Clang fills that list from `-verify` alone, so a consumer
installed by hand starts with none — and then no comment in any source is a directive and
the consumer reports that as an error.

`diags` is stored by reference and must outlive the consumer. It is also where the mismatch
reports go: at construction the consumer takes over the engine's current client as its own
primary, so `diags` must already carry the client that should print them.

Disposal is ordered: the destructor runs one last check through both the engine and that
captured client, so neither may be released first, and the consumer must be taken off the
engine before it is disposed.

Verification runs when the source file ends, so a caller driving the parse by hand only gets
an answer after [`EndSourceFile`](@ref).

This function allocates and one should call `dispose` to release the resources after using
this object — unless an engine that owns its client has since taken it.
"""
function VerifyDiagnosticConsumer(diags::DiagnosticsEngine)
    @check_ptrs diags
    dc = clang_VerifyDiagnosticConsumer_create(diags)
    @assert dc != C_NULL "Failed to create VerifyDiagnosticConsumer"
    return VerifyDiagnosticConsumer(dc)
end
