using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "preprocessor includes round-trip" begin
    I = create_interpreter(["-include", "cstddef"])
    ppo = CC.getPreprocessorOpts(get_instance(I))
    incs = CC.getIncludes(ppo)
    @test incs isa Vector{String}
    @test "cstddef" in incs
    dispose(I)
end
