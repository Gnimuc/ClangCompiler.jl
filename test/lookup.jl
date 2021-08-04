using ClangCompiler
using Test

@testset "Lookup | Decl" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    cc = create_incremental_compiler(src, args)
    decl_lookup = DeclFinder(cc.instance)
    @test decl_lookup(cc, "vector", "std::vector")
    @test_nowarn decl = get_decl(decl_lookup)
    dispose(decl_lookup)
    dispose(cc)
end
