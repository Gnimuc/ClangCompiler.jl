# ExtractAPIAction — clang's -extract-api pipeline.

"""
    ExtractAPIAction() -> ExtractAPIAction
Build the frontend action that writes a translation unit's API surface as Symbol Graph
JSON (the swift-docc-symbolkit format).

The action synthesizes one header including all of the invocation's inputs, walks the
resulting AST, and writes the graph to the invocation's output file, so the inputs and the
`-o` path both come from the `CompilerInvocation` it is executed against. Nothing of
clang's `ExtractAPI` C++ types crosses this boundary: the deliverable is the JSON, which
carries names, USRs, declaration fragments, doc comments and relationships, and which is
parsed in Julia.

This function allocates and one should call `dispose` to release the resources after using
this object. [`ExecuteAction`](@ref) borrows the action rather than adopting it, so the
action is still the caller's afterwards.
"""
function ExtractAPIAction()
    act = clang_ExtractAPIAction_create()
    @assert act != C_NULL "Failed to create ExtractAPIAction"
    return ExtractAPIAction(act)
end

dispose(x::ExtractAPIAction) = clang_ExtractAPIAction_dispose(x)
