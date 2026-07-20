using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "member iteration" begin
    I = create_interpreter([joinpath(pkgdir(ClangCompiler), "test", "cxx", "main.cpp")])
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

    @test f(I, "Foo")
    foo = ClangCompiler.CXXRecordDecl(get_decl(f).ptr)
    @test ClangCompiler.getNumCtors(foo) == 2                     # Foo() and Foo(int)
    @test length(ClangCompiler.getMethods(foo)) == ClangCompiler.getNumMethods(foo)
    @test all(c -> c isa ClangCompiler.CXXConstructorDecl, ClangCompiler.getCtors(foo))

    dispose(f)
    dispose(I)
end

@testset "Decl predicate exercise" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, """
    int gv = 5; static int sv; constexpr int cev = 7;
    int variadic_fn(int, ...); inline int inl_fn(){ return 1; }
    struct Abstract { virtual void pure() = 0; };
    struct Base { virtual void v(); virtual ~Base(); int m; };
    struct Der : Base { void v() override; };
    """)
    f = DeclFinder(I)
    D(name, T) = (f(I, name); T(get_decl(f).ptr))

    gv = D("gv", ClangCompiler.VarDecl)
    @test ClangCompiler.hasGlobalStorage(gv)
    @test ClangCompiler.hasInit(gv)
    @test !ClangCompiler.isStaticLocal(D("sv", ClangCompiler.VarDecl))
    @test ClangCompiler.hasGlobalStorage(D("sv", ClangCompiler.VarDecl))
    @test ClangCompiler.hasInit(D("cev", ClangCompiler.VarDecl))

    vfn = D("variadic_fn", ClangCompiler.FunctionDecl)
    @test ClangCompiler.isVariadic(vfn)
    @test ClangCompiler.getNumParams(vfn) == 1
    @test ClangCompiler.isInlined(D("inl_fn", ClangCompiler.FunctionDecl))

    @test ClangCompiler.isAbstract(D("Abstract", ClangCompiler.CXXRecordDecl))
    base = D("Base", ClangCompiler.CXXRecordDecl)
    @test ClangCompiler.isPolymorphic(base)
    @test ClangCompiler.hasUserDeclaredDestructor(base)
    @test !ClangCompiler.isAbstract(base)
    der = D("Der", ClangCompiler.CXXRecordDecl)
    @test ClangCompiler.isPolymorphic(der)
    @test ClangCompiler.getNumBases(der) == 1

    dispose(f)
    dispose(I)
end

@testset "whole-TU decls traversal" begin
    I = create_interpreter(String[])
    CC.parse(I, "namespace N { struct S { int x; void m(); }; int g; }")
    f = DeclFinder(I)
    @test f(I, "N")
    nsdc = CC.castToDeclContext(get_decl(f))    # NamespaceDecl -> DeclContext pivot
    ds = CC.decls(nsdc)
    @test all(d -> d isa CC.AbstractDecl, ds)
    @test !any(d -> isabstracttype(typeof(d)), ds)          # every node resolved
    names = [CC.getDeclKindName(d) for d in ds]
    # recurses into the nested record: S, then S's members (x, m), plus g.
    @test "CXXRecord" in names
    @test "Field" in names
    @test "CXXMethod" in names
    @test "Var" in names
    @test any(d -> d isa CC.CXXRecordDecl, ds)
    @test any(d -> d isa CC.FieldDecl && CC.getName(d) == "x", ds)
    dispose(f)
    dispose(I)
end

@testset "Decl classification (getKind / resolve)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int gv = 3; int fn(int a){return a;} struct S { int m; }; namespace N {}")
    f = DeclFinder(I)
    cases = [("gv", CC.VarDecl, CC.LibClangEx.CXDeclKind_Var, "Var"),
             ("fn", CC.FunctionDecl, CC.LibClangEx.CXDeclKind_Function, "Function"),
             ("S", CC.CXXRecordDecl, CC.LibClangEx.CXDeclKind_CXXRecord, "CXXRecord"),
             ("N", CC.NamespaceDecl, CC.LibClangEx.CXDeclKind_Namespace, "Namespace")]
    for (name, carrier, kind, kindname) in cases
        @test f(I, name)
        d = get_decl(f)                       # base Decl carrier
        @test CC.getKind(d) == kind
        @test CC.getDeclKindName(d) == kindname
        r = CC.resolve(d)                     # O(1) downcast via getKind
        @test r isa carrier
        @test r.ptr == d.ptr                  # Decl is the primary base: identity
    end
    dispose(f)
    dispose(I)
end
