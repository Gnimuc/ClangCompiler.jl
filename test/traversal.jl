using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

@testset "Traversal | AST" begin
    I = create_interpreter([joinpath(@__DIR__, "cxx", "main.cpp")])

    decl_lookup = DeclFinder(I)
    @test decl_lookup(I, "Node")
    decl = get_decl(decl_lookup)
    for field in DeclIterator(decl)
        ClangCompiler.dump(field)
        @test getDeclKindName(field) == "Field"
    end

    @test decl_lookup(I, "Foo")
    decl = get_decl(decl_lookup)
    for x in DeclIterator(decl)
        ClangCompiler.dump(x)
    end

    dispose(decl_lookup)
    dispose(I)
end
