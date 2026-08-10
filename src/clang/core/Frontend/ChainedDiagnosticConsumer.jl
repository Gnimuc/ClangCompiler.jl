"""
    struct ChainedDiagnosticConsumer <: AbstractChainedDiagnosticConsumer
Hold a pointer to a `clang::ChainedDiagnosticConsumer` object.

Sends every diagnostic to two clients in turn, which is how a program can both echo
diagnostics to the terminal and keep them for inspection — a `DiagnosticsEngine` has room
for exactly one client.
"""
struct ChainedDiagnosticConsumer <: AbstractChainedDiagnosticConsumer
    ptr::CXDiagnosticConsumer
end
