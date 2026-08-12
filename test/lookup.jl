using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, get_decls
using Test

@testset "Lookup" begin
    I = create_interpreter(["-include", "vector", "-include", "ctime"])

    decl_lookup = DeclFinder(I)
    @test decl_lookup(I, "std::vector")
    decl = get_decl(decl_lookup)
    # resolved to the class clang reported, not the base carrier: `std::vector` is a template,
    # and a base-typed result would make every `isa` against it silently false
    @test decl isa CC.ClassTemplateDecl
    @test decl isa CC.AbstractNamedDecl

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
    # resolved, so the template-id lookup reports the class clang actually found
    @test get_decl(f) isa CC.AbstractNamedDecl

    # Nested lookup through every tag keyword, not just `class`. clang's specifier printer
    # emits the keyword the source did not write (`app::struct Widget::`), and `strip_nns`
    # removes it by length arithmetic -- so a keyword it does not know about makes the
    # arithmetic run off the name. Handling `class` alone is exactly why a struct-qualified
    # lookup raised while this one passed, which is why all four are exercised here.
    CC.parse(I, """
        class Outer { public: class Inner {}; };
        struct OuterS { struct InnerS { int a; }; static int mem(int); };
        union OuterU { struct InnerU { int b; } iu; int c; };
    """)
    for (qname, leaf) in
        (("Outer::Inner", "Inner"), ("OuterS::InnerS", "InnerS"), ("OuterS::mem", "mem"), ("OuterU::InnerU", "InnerU"))
        @test f(I, qname)
        @test CC.getName(get_decl(f)) == leaf
    end

    # and the same through the public helper, which is the spelling a user writes
    @test CC.qualified_name(CC.find_decl(I, "OuterS::mem")) == "OuterS::mem"

    # get_tag on a single tag decl.
    CC.parse(I, "struct TagS { int a; };")
    @test f(I, "TagS")
    @test CC.get_tag(f) isa CC.NamedDecl

    # a name that does not resolve returns false.
    @test !f(I, "no_such_symbol_xyz")

    dispose(f)
    dispose(I)
end
