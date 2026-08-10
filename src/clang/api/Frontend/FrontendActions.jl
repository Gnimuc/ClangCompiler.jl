# FrontendActions
# Each factory returns the base `CXFrontendAction` handle, so every action here is released
# through `dispose(::AbstractFrontendAction)` in FrontendAction.jl. Running one is
# `ExecuteAction(ci, act)`, which borrows the action and never adopts it.

"""
    ReadPCHAndPreprocessAction() -> ReadPCHAndPreprocessAction
Build the action that preprocesses the input the way `-E` does after loading an implicit
PCH, so a run configured by [`AddImplicitPreamble`](@ref) sees the preamble's macros.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ReadPCHAndPreprocessAction()
    act = clang_ReadPCHAndPreprocessAction_create()
    @assert act != C_NULL "Failed to create ReadPCHAndPreprocessAction"
    return ReadPCHAndPreprocessAction(act)
end

"""
    ASTPrintAction() -> ASTPrintAction
Build the action that pretty-prints every top-level declaration to the instance's output
stream.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ASTPrintAction()
    act = clang_ASTPrintAction_create()
    @assert act != C_NULL "Failed to create ASTPrintAction"
    return ASTPrintAction(act)
end

"""
    ASTDumpAction() -> ASTDumpAction
Build the action that dumps the AST in the form `FrontendOptions.ASTDumpFormat` selects.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ASTDumpAction()
    act = clang_ASTDumpAction_create()
    @assert act != C_NULL "Failed to create ASTDumpAction"
    return ASTDumpAction(act)
end

"""
    GeneratePCHAction() -> GeneratePCHAction
Build the action that writes a precompiled header for the input translation unit — the
standard `cc1` route to producing a PCH, without the full `ASTUnit` parse `Save` needs.

Set the instance's `FrontendOptions.OutputFile` to the `.pch` to write before
[`ExecuteAction`](@ref) runs it (see [`setOutputFile`](@ref)). Leaving it empty is neither an
error nor a no-op: clang falls back to `"-"` when both the output path and the action's
extension are empty, and the PCH goes to standard output.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function GeneratePCHAction()
    act = clang_GeneratePCHAction_create()
    @assert act != C_NULL "Failed to create GeneratePCHAction"
    return GeneratePCHAction(act)
end

"""
    SyntaxOnlyAction() -> SyntaxOnlyAction
Build the action that parses and runs semantic analysis and then stops: a complete AST with
no LLVM module built, which is the cheap path for a lookup-only or diagnostics-only run.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function SyntaxOnlyAction()
    act = clang_SyntaxOnlyAction_create()
    @assert act != C_NULL "Failed to create SyntaxOnlyAction"
    return SyntaxOnlyAction(act)
end
