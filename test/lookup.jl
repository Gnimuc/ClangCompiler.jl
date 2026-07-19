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

@testset "Lookup | qualified, template-id, tag" begin
    I = create_interpreter(["-include", "vector"])
    f = DeclFinder(I)

    # namespace-qualified template-id: exercises the template-id branch of
    # diagnose_declname (type_name empty -> strip at '<').
    @test f(I, "std::vector<int>")
    @test get_decl(f) isa ClangCompiler.NamedDecl

    # class-qualified nested lookup: exercises the "class " scope-name stripping
    # in strip_nns and the annot-cxxscope path in parse_cxx_scope_spec.
    ClangCompiler.parse(I, "class Outer { public: class Inner {}; };")
    @test f(I, "Outer::Inner")
    @test ClangCompiler.getName(get_decl(f)) == "Inner"

    # get_tag on a single tag decl.
    ClangCompiler.parse(I, "struct TagS { int a; };")
    @test f(I, "TagS")
    @test ClangCompiler.get_tag(f) isa ClangCompiler.NamedDecl

    # a name that does not resolve returns false.
    @test !f(I, "no_such_symbol_xyz")

    dispose(f)
    dispose(I)
end
