using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "Driver resources path" begin
    path = CC.GetResourcesPath(Libdl.dlpath(CC.libclangex))
    @test path isa String
    @test !isempty(path)
    @test occursin("clang", path)
end
