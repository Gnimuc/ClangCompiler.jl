using ClangCompiler
using Test
import ClangCompiler as cc

@testset "Traversal | AST" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    irgen = ClangCompiler.IncrementalIRGenerator(src, args)
    decl_lookup = DeclFinder(get_instance(irgen))
    @test decl_lookup(irgen, "Node", "Node")
    decl = get_decl(decl_lookup)
    for field in cc.DeclIterator(decl)
        cc.dump(field)
        @test cc.getDeclKindName(field) == "Field"
    end
    dispose(decl_lookup)
    dispose(irgen)
end
