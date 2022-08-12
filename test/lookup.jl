using ClangCompiler
using Test

@testset "Lookup | Decl" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    irgen = ClangCompiler.IncrementalIRGenerator(src, args)
    decl_lookup = DeclFinder(get_instance(irgen))
    @test decl_lookup(irgen, "vector", "std::vector")
    @test_nowarn decl = get_decl(decl_lookup)
    dispose(decl_lookup)
    dispose(irgen)
end
