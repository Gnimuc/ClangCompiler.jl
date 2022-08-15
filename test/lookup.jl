using ClangCompiler
using Test

@testset "Lookup | Decl" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    irgen = ClangCompiler.IncrementalIRGenerator(src, args)
    decl_lookup = DeclFinder(get_instance(irgen))
    @test decl_lookup(irgen, "vector", "std::vector")
    @test_nowarn decl = get_decl(decl_lookup)

    @test decl_lookup(irgen, "sum", "sum")
    decl = get_decl(decl_lookup)
    fdecl = ClangCompiler.getAsFunction(decl)

    @test fdecl isa ClangCompiler.FunctionDecl

    # TODO Assert that mangling the decl leads to
    # `_Z3sumRSt6vectorIfSaIfEE`

    dispose(decl_lookup)
    dispose(irgen)
end
