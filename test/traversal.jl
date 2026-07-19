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

@testset "Traversal | member iteration" begin
    I = create_interpreter([joinpath(@__DIR__, "cxx", "main.cpp")])
    f = DeclFinder(I)

    @test f(I, "Node")
    node = ClangCompiler.CXXRecordDecl(get_decl(f).ptr)
    @test ClangCompiler.getNumFields(node) == 2
    @test [ClangCompiler.getName(x) for x in ClangCompiler.getFields(node)] == ["x", "y"]

    ClangCompiler.parse(I, "struct BaseA { int a; }; struct BaseB { int b; }; struct Der : BaseA, BaseB { int c; };")
    @test f(I, "Der")
    der = ClangCompiler.CXXRecordDecl(get_decl(f).ptr)
    @test ClangCompiler.getNumFields(der) == 1
    @test ClangCompiler.getNumBases(der) == 2
    @test ClangCompiler.getNumVBases(der) == 0
    bases = ClangCompiler.getBases(der)
    basenames = [ClangCompiler.getName(ClangCompiler.getAsCXXRecordDecl(ClangCompiler.getTypePtr(ClangCompiler.getType(b))))
                 for b in bases]
    @test basenames == ["BaseA", "BaseB"]

    dispose(f)
    dispose(I)
end

@testset "Traversal | name mangling" begin
    I = create_interpreter([joinpath(@__DIR__, "cxx", "main.cpp")])
    ctx = ClangCompiler.get_ast_context(I)
    mc = ClangCompiler.createMangleContext(ctx, ClangCompiler.getTargetInfo(ctx))
    f = DeclFinder(I)
    @test f(I, "sum")
    nd = ClangCompiler.NamedDecl(get_decl(f).ptr)
    @test ClangCompiler.shouldMangleDeclName(mc, nd)
    @test ClangCompiler.mangleName(mc, nd) == "_Z3sumRNSt3__16vectorIfNS_9allocatorIfEEEE"
    dispose(f)
    dispose(I)
end
