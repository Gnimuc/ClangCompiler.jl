using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "CUDA builder knobs (throwaway builder)" begin
    builder = CC.IncrementalCompilerBuilder()
    @test CC.SetCudaSDK(builder, "/nonexistent/cuda/sdk") === nothing
    @test CC.SetOffloadArch(builder, "sm_80") === nothing
    dispose(builder)
end
