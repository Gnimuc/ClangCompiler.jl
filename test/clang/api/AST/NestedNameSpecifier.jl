using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "NestedNameSpecifier navigation" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    namespace A { namespace B { struct S {}; } }
    A::B::S nns_ab;
    struct Outer { struct Inner {}; };
    Outer::Inner nns_oi;
    namespace Shrt = A::B;
    Shrt::S nns_alias;
    template<typename T> struct Dep { typename T::foo::type m; };
    """)
    f = DeclFinder(I)
    varof(name) = (@test f(I, name); CC.VarDecl(get_decl(f)))

    ety_ab = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_ab"))))
    @test ety_ab isa CC.ElaboratedType
    nns_ab = CC.getQualifier(ety_ab)
    @test CC.getKind(nns_ab) == CC.LibClangEx.CXNestedNameSpecifierKind_Namespace
    @test CC.getName(nns_ab) == "A::B::"
    @test CC.getName(CC.getAsNamespace(nns_ab)) == "B"
    @test CC.isDependent(nns_ab) == false
    @test CC.isInstantiationDependent(nns_ab) == false
    @test !(CC.containsUnexpandedParameterPack(nns_ab))
    @test !(CC.containsErrors(nns_ab))

    prefix = CC.getPrefix(nns_ab)
    @test CC.getKind(prefix) == CC.LibClangEx.CXNestedNameSpecifierKind_Namespace
    @test CC.getName(prefix) == "A::"
    @test CC.getName(CC.getAsNamespace(prefix)) == "A"

    ety_oi = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_oi"))))
    nns_oi = CC.getQualifier(ety_oi)
    @test CC.getKind(nns_oi) == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpec
    @test CC.getName(nns_oi) == "struct Outer::"
    @test CC.getName(CC.getAsRecordDecl(nns_oi)) == "Outer"

    ety_al = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_alias"))))
    nns_al = CC.getQualifier(ety_al)
    @test CC.getKind(nns_al) == CC.LibClangEx.CXNestedNameSpecifierKind_NamespaceAlias
    @test CC.getName(nns_al) == "Shrt::"
    @test CC.getName(CC.getAsNamespaceAlias(nns_al)) == "Shrt"

    @test f(I, "Dep")
    ctd = CC.ClassTemplateDecl(get_decl(f))
    found_dep = false
    for fld in CC.getFields(CC.getTemplatedDecl(ctd))
        dnt = CC.resolve(CC.getTypePtr(CC.getType(fld)))
        dnt isa CC.DependentNameType || continue
        nns_dep = CC.getQualifier(dnt)
        @test CC.getKind(nns_dep) == CC.LibClangEx.CXNestedNameSpecifierKind_Identifier
        @test CC.getName(nns_dep) == "T::foo::"
        @test CC.isDependent(nns_dep)
        @test CC.getName(CC.getAsIdentifier(nns_dep)) == "foo"
        found_dep = true
    end
    @test found_dep

    dispose(f)
    dispose(I)
end
