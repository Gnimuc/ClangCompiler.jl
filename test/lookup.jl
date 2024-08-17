using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, get_decls
using Test

@testset "Lookup" begin
    I = create_interpreter(["-include", "vector", "-include", "ctime"])

    decl_lookup = DeclFinder(I)
    @test decl_lookup(I, "std::vector")
    decl = get_decl(decl_lookup)
    @test decl isa ClangCompiler.NamedDecl

    @test decl_lookup(I, "clock")
    x = get_decl(decl_lookup)
    y = get_decls(decl_lookup)
    @test x == first(y)

    dispose(decl_lookup)
    dispose(I)
end
