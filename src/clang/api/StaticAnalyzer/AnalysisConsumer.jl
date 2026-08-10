# ento::CreateAnalysisConsumer — the static analyzer without a FrontendAction.

"""
    CreateAnalysisConsumer(ci::CompilerInstance) -> ASTConsumer
Build the analyzer's AST consumer for `ci`, configured from `ci`'s `AnalyzerOptions`.

This is the analyzer for a caller that owns its own `CompilerInstance`/`Sema` lifecycle:
install the result with [`setASTConsumer`](@ref) and drive it with [`ParseAST`](@ref),
rather than handing a fresh [`AnalysisAction`](@ref) to `ExecuteAction`.

**Adopted** by `setASTConsumer`: once installed, the `CompilerInstance` frees it and calling
`dispose` on it is a double free. Dispose it only if it never reached an instance.

The instance must already be built out to an `ASTContext`: the consumer reads
`getAnalyzerOpts` off the invocation, turns warnings-as-errors off through
`getPreprocessor().getDiagnostics()`, and holds a cross-TU context bound to
`getASTContext()` — each an unchecked dereference, so a half-built instance aborts inside
clang rather than reporting anything.
"""
function CreateAnalysisConsumer(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "CompilerInstance has no invocation."
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine."
    @assert hasPreprocessor(ci) "CompilerInstance has no preprocessor."
    @assert hasASTContext(ci) "CompilerInstance has no AST context."
    return ASTConsumer(clang_ento_CreateAnalysisConsumer(ci))
end
