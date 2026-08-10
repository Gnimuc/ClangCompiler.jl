# AnalysisAction — the ASTFrontendAction that runs the whole static analyzer.

"""
    AnalysisAction() -> AnalysisAction
Build the frontend action that runs clang's static analyzer.

The action itself carries no configuration: what runs comes from the `CompilerInvocation`
it is executed against (`-analyze`, `-analyzer-checker=…`, `-analyzer-output=…`, or the
programmatic equivalents on [`getAnalyzerOpts`](@ref)). Run it with
[`ExecuteAction`](@ref); with `-analyzer-output=text` the warnings arrive through the
instance's `DiagnosticsEngine`, otherwise as files on disk.

This function allocates and one should call `dispose` to release the resources after using
this object. `ExecuteAction` borrows the action rather than adopting it, so the action is
still the caller's afterwards.
"""
function AnalysisAction()
    act = clang_ento_AnalysisAction_create()
    @assert act != C_NULL "Failed to create AnalysisAction"
    return AnalysisAction(act)
end

dispose(x::AnalysisAction) = clang_ento_AnalysisAction_dispose(x)
