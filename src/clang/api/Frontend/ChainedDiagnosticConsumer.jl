# ChainedDiagnosticConsumer
"""
    ChainedDiagnosticConsumer(primary::AbstractDiagnosticConsumer, secondary::AbstractDiagnosticConsumer) -> ChainedDiagnosticConsumer
Build a consumer that sends every diagnostic to `primary` and then to `secondary`.

A `DiagnosticsEngine` holds exactly one client, so this is how a program both echoes
diagnostics to the terminal (a [`TextDiagnosticPrinter`](@ref)) and keeps them for
inspection (a [`TextDiagnosticBuffer`](@ref)). `primary` is the one whose
`IncludeInDiagnosticCounts` decides whether a diagnostic is counted.

`primary` is **not** adopted — this uses clang's non-owning-primary constructor, so the
caller still disposes it and must keep it alive at least as long as the chain. `secondary`
**is** adopted, and disposing it afterwards is a double free.

This function allocates and one should call `dispose` to release the resources after using
this object — unless an engine that owns its client has since taken it.
"""
function ChainedDiagnosticConsumer(primary::AbstractDiagnosticConsumer,
                                   secondary::AbstractDiagnosticConsumer)
    @check_ptrs primary secondary
    @assert Base.unsafe_convert(CXDiagnosticConsumer, primary) !=
            Base.unsafe_convert(CXDiagnosticConsumer, secondary) "the two clients of a chain must differ"
    dc = clang_ChainedDiagnosticConsumer_create(primary, secondary)
    @assert dc != C_NULL "Failed to create ChainedDiagnosticConsumer"
    return ChainedDiagnosticConsumer(dc)
end
