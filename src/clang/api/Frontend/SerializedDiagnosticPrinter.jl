# SerializedDiagnosticPrinter
"""
    SerializedDiagnosticPrinter(output_file::AbstractString, opts::AbstractDiagnosticOptions; merge_child_records::Bool=false) -> SerializedDiagnosticPrinter
Build a consumer that writes each diagnostic to `output_file` in the `.dia` bitcode format,
so a build system or IDE gets structured diagnostics without parsing clang's text output.

`merge_child_records` folds an already-existing `.dia` at the same path into the
new one, which is what clang does for a driver run whose `cc1` subprocesses each wrote their
own file.

The file is finished in the consumer's `finish()`, which [`finish`](@ref) reaches: a caller
driving the pipeline by hand should call it before reading the file.

This function allocates and one should call `dispose` to release the resources after using
this object — unless an engine that owns its client has since taken it.

`opts` stays the caller's. The writer keeps them in its shared state through an
`IntrusiveRefCntPtr` for exactly as long as it lives, and because [`DiagnosticOptions`](@ref)
hands back an object already holding the caller's own reference (MARSHALLING.md §12) that
borrow runs 1 → 2 → 1. Dispose them when you are done, in either order relative to this
consumer.
"""
function SerializedDiagnosticPrinter(output_file::AbstractString,
                                     opts::AbstractDiagnosticOptions;
                                     merge_child_records::Bool=false)
    @check_ptrs opts
    @assert !isempty(output_file) "SerializedDiagnosticPrinter needs an output path"
    dc = clang_serialized_diags_create(output_file, opts, merge_child_records)
    @assert dc != C_NULL "Failed to create the serialized diagnostic consumer"
    return SerializedDiagnosticPrinter(dc)
end
