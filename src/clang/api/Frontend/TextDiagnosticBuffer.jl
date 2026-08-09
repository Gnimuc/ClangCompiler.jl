"""
    TextDiagnosticBuffer() -> TextDiagnosticBuffer
Build a diagnostic consumer that records every diagnostic instead of printing it, so the
message text and source location of each one can be read back — which the counts
`getNumErrors` and `getNumWarnings` give a caller no way to reach.

This function allocates and one should call `dispose` to release the resources after using
this object — unless it has been handed to an owning API first, at which point disposing it
is a double free (see [`DiagnosticsEngine`](@ref)'s `should_own_client`).
"""
function TextDiagnosticBuffer()
    return TextDiagnosticBuffer(clang_TextDiagnosticBuffer_create())
end

dispose(x::TextDiagnosticBuffer) = clang_DiagnosticConsumer_dispose(x)

"""
    size(x::AbstractTextDiagnosticBuffer, level::CXTextDiagnosticBuffer_Level) -> UInt32
The number of diagnostics buffered at `level`. Fatal diagnostics are counted under
`CXTextDiagnosticBuffer_Error`.
"""
function Base.size(x::AbstractTextDiagnosticBuffer, level::CXTextDiagnosticBuffer_Level)
    @check_ptrs x
    return clang_TextDiagnosticBuffer_size(x, level)
end

"""
    getMessage(x::AbstractTextDiagnosticBuffer, level, i::Integer) -> String
The text of the `i`-th diagnostic at `level`, indexed from `0` in emission order.
"""
function getMessage(x::AbstractTextDiagnosticBuffer, level::CXTextDiagnosticBuffer_Level, i::Integer)
    @check_ptrs x
    @assert 0 <= i < Base.size(x, level) "diagnostic index $i out of range"
    return get_string(clang_TextDiagnosticBuffer_getMessage(x, level, i))
end

"""
    getLocation(x::AbstractTextDiagnosticBuffer, level, i::Integer) -> SourceLocation
Where the `i`-th diagnostic at `level` was raised. Only meaningful against the
`SourceManager` that was live at the time, and invalid for a diagnostic raised before any
file was entered.
"""
function getLocation(x::AbstractTextDiagnosticBuffer, level::CXTextDiagnosticBuffer_Level, i::Integer)
    @check_ptrs x
    @assert 0 <= i < Base.size(x, level) "diagnostic index $i out of range"
    return SourceLocation(clang_TextDiagnosticBuffer_getLocation(x, level, i))
end

"""
    FlushDiagnostics(x::AbstractTextDiagnosticBuffer, de::DiagnosticsEngine)
Replay every buffered diagnostic into `de`, which reports them through its own consumer.

`de`'s consumer must be something other than `x`. Clang walks the buffer's interleaved list
while reporting, so replaying into the engine this buffer is installed on appends to that
list mid-walk and the iteration runs off a reallocated vector — a segfault rather than a
duplicated message.
"""
function FlushDiagnostics(x::AbstractTextDiagnosticBuffer, de::DiagnosticsEngine)
    @check_ptrs x de
    @assert getClient(de).ptr != x.ptr "cannot flush a buffer into the engine it is the consumer of"
    return clang_TextDiagnosticBuffer_FlushDiagnostics(x, de)
end
