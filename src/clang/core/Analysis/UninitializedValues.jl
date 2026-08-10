abstract type AbstractUninitVariablesResult end

"""
    struct UninitVariablesResult <: AbstractUninitVariablesResult
Hold a pointer to the buffer one `clang::runUninitializedVariablesAnalysis` run recorded.

There is no `clang::UninitVariablesResult`: clang reports each use through the virtual
`UninitVariablesHandler`, handing out a `UninitUse` temporary that dies with the callback,
so the shim runs the analysis behind one fixed handler subclass and keeps the reports.
The pointee is caller-owned — call `dispose` after use. It holds borrowed AST pointers, so
it stays meaningful exactly as long as the translation unit does.
"""
struct UninitVariablesResult <: AbstractUninitVariablesResult
    ptr::CXUninitVariablesResult
end
