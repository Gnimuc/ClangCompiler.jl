"""
    EmitBackendOutput(ci::CompilerInstance, m::LLVM.Module, action::CXBackendAction,
                      output_path::AbstractString) -> Bool
Run clang's middle-end and backend over `m` — the optimization pipeline `ci`'s
`CodeGenOptions` describe, then the emission `action` asks for — and write the result to
`output_path`.

This is how a module built incrementally (via [`StartModule`](@ref), say) reaches an object
file, an assembly file or bitcode with clang's exact pass and target configuration, which no
`FrontendAction` can do for a module the frontend did not itself produce.

Everything the C++ entry point takes separately is read off `ci`: its diagnostics engine,
its header-search / codegen / target / language options, the data layout of its target, and
the virtual file system its file manager holds.

PRECONDITIONS: `ci` must have a file manager and a target. The return value then reports
whether the pipeline added an error to `ci`'s diagnostics — the C++ function returns void
and says so only through them.
"""
function EmitBackendOutput(ci::CompilerInstance, m::LLVM.Module, action::CXBackendAction,
                           output_path::AbstractString)
    @check_ptrs ci
    @assert hasFileManager(ci) "CompilerInstance has no file manager."
    @assert hasTarget(ci) "CompilerInstance has no target."
    return clang_EmitBackendOutput(ci, m, action, output_path)
end
