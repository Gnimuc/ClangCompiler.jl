# FrontendTool/Utils
"""
    CreateFrontendAction(ci::CompilerInstance) -> FrontendAction
Build the action `FrontendOptions.ProgramAction` names.

That covers the whole `cc1` action zoo, including the ones this package has no factory for
(`-E`, the rewriters, the analyzer, plugin actions) plus the AST-merge and FixIt wrappers
clang layers on top. Set the action first with
[`setProgramAction`](@ref) on [`getFrontendOpts`](@ref); the default is
`CXActionKind_ParseSyntaxOnly`.

`ci` needs both diagnostics and an invocation: the frontend options are read through the
invocation with no null check, and a refusal is reported through the engine.

Throws when clang refused the action — an unrecognised or unavailable one is reported
through `ci`'s diagnostics engine and answered with no action at all.

The returned carrier stands for an action whose dynamic class only clang knows, so it is
released with the base `dispose(::AbstractFrontendAction)` rather than any per-class one.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CreateFrontendAction(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine"
    @assert hasInvocation(ci) "CompilerInstance has no invocation"
    act = clang_CreateFrontendAction(ci)
    @assert act != C_NULL "clang refused to create a FrontendAction for this ProgramAction"
    return FrontendAction(act)
end

"""
    ExecuteCompilerInvocation(ci::CompilerInstance) -> Bool
Run `ci` the way `clang -cc1` would: build the action `FrontendOptions.ProgramAction` names,
run it, and do the `cc1` housekeeping around it — `-help`/`-version`, the LLVM command-line
arguments in `FrontendOptions.LLVMArgs`, plugin loading and the statistics report.

The instance keeps ownership of everything; the action is built and destroyed inside.
Returns `false` when the action could not be created or the run failed.
"""
function ExecuteCompilerInvocation(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine"
    @assert hasInvocation(ci) "CompilerInstance has no invocation"
    return clang_ExecuteCompilerInvocation(ci)
end
