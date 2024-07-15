using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl
using Test

@testset "Lookup" begin
    I = create_interpreter(["-include", "vector"])

    decl_lookup = DeclFinder(I)
    @test decl_lookup(I, "std::vector")
    decl = get_decl(decl_lookup)
    @test decl isa ClangCompiler.NamedDecl

    dispose(decl_lookup)
    dispose(I)
end
