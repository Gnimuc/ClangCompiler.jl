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

    @test f(I, "Foo")
    foo = ClangCompiler.CXXRecordDecl(get_decl(f).ptr)
    @test ClangCompiler.getNumCtors(foo) == 2                     # Foo() and Foo(int)
    @test length(ClangCompiler.getMethods(foo)) == ClangCompiler.getNumMethods(foo)
    @test all(c -> c isa ClangCompiler.CXXConstructorDecl, ClangCompiler.getCtors(foo))

    dispose(f)
    dispose(I)
end

@testset "Traversal | name mangling" begin
    I = create_interpreter(String[])
    ctx = ClangCompiler.get_ast_context(I)
    mc = ClangCompiler.createMangleContext(ctx, ClangCompiler.getTargetInfo(ctx))
    f = DeclFinder(I)
    # Primitive-signature functions so the expected Itanium mangling is
    # stable across every target the interpreter may resolve. A std-library
    # parameter (e.g. std::vector) would drag in the platform-specific inline
    # namespace (`std` under libstdc++ vs `std::__1` under libc++) and make the
    # string host-dependent.
    ClangCompiler.parse(I, "int add(int a, int b) { return a + b; } void ref(int &r) { r = 0; }")

    @test f(I, "add")
    add_nd = ClangCompiler.NamedDecl(get_decl(f).ptr)
    @test ClangCompiler.shouldMangleDeclName(mc, add_nd)
    @test ClangCompiler.mangleName(mc, add_nd) == "_Z3addii"

    @test f(I, "ref")
    ref_nd = ClangCompiler.NamedDecl(get_decl(f).ptr)
    @test ClangCompiler.mangleName(mc, ref_nd) == "_Z3refRi"

    dispose(f)
    dispose(I)
end

@testset "Traversal | sugar type resolve" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "_Atomic int av;")
    f = DeclFinder(I)
    @test f(I, "av")
    vd = ClangCompiler.VarDecl(get_decl(f).ptr)
    ty = ClangCompiler.resolve(ClangCompiler.getTypePtr(ClangCompiler.getType(vd)))
    @test ty isa ClangCompiler.AtomicType
    @test ClangCompiler.getValueType(ty) isa ClangCompiler.QualType
    dispose(f)
    dispose(I)
end

@testset "Traversal | APValue constant evaluation" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "constexpr int cx = 2 + 3;")
    f = DeclFinder(I)
    @test f(I, "cx")
    vd = ClangCompiler.VarDecl(get_decl(f).ptr)

    # VarDecl::evaluateValue — borrowed, cached in the VarDecl (never disposed).
    av = ClangCompiler.evaluateValue(vd)
    @test av.ptr != C_NULL
    @test ClangCompiler.isInt(av)
    @test ClangCompiler.getKind(av) == ClangCompiler.LibClangEx.CXAPValueKind_Int
    gv = ClangCompiler.LLVM.GenericValue(ClangCompiler.getInt(av))
    @test convert(Int, gv) == 5
    ClangCompiler.LLVM.dispose(gv)

    # Expr::EvaluateAsRValue — owned, must be disposed.
    ctx = ClangCompiler.get_ast_context(I)
    init = ClangCompiler.getInit(vd)
    av2 = ClangCompiler.EvaluateAsRValue(init, ctx)
    @test av2.ptr != C_NULL
    gv2 = ClangCompiler.LLVM.GenericValue(ClangCompiler.getInt(av2))
    @test convert(Int, gv2) == 5
    ClangCompiler.LLVM.dispose(gv2)
    ClangCompiler.dispose(av2)

    # Constant-evaluation predicates + the typed Evaluate* entry points.
    @test ClangCompiler.isEvaluatable(init, ctx)
    @test ClangCompiler.isIntegerConstantExpr(init, ctx)
    @test ClangCompiler.isCXX11ConstantExpr(init, ctx)

    avi = ClangCompiler.EvaluateAsInt(init, ctx)
    @test avi.ptr != C_NULL && ClangCompiler.isInt(avi)
    gvi = ClangCompiler.LLVM.GenericValue(ClangCompiler.getInt(avi))
    @test convert(Int, gvi) == 5
    ClangCompiler.LLVM.dispose(gvi)
    ClangCompiler.dispose(avi)

    ClangCompiler.parse(I, "constexpr bool cb = (2 > 1); constexpr float cf = 1.5f;")
    @test f(I, "cb")
    cb_init = ClangCompiler.getInit(ClangCompiler.VarDecl(get_decl(f).ptr))
    @test ClangCompiler.EvaluateAsBooleanCondition(cb_init, ctx) == 1

    @test f(I, "cf")
    cf_init = ClangCompiler.getInit(ClangCompiler.VarDecl(get_decl(f).ptr))
    gvf = ClangCompiler.LLVM.GenericValue(ClangCompiler.EvaluateAsFloat(cf_init, ctx))
    @test ClangCompiler.LLVM.intwidth(gvf) == 32                  # APFloat bits (bitcastToAPInt)
    @test reinterpret(Float32, convert(UInt32, gvf)) == 1.5f0
    ClangCompiler.LLVM.dispose(gvf)

    # A non-constant expression yields the null/-1 sentinels.
    ClangCompiler.parse(I, "int nc_fn(); int nc = nc_fn();")
    @test f(I, "nc")
    nc_init = ClangCompiler.getInit(ClangCompiler.VarDecl(get_decl(f).ptr))
    @test !ClangCompiler.isEvaluatable(nc_init, ctx)
    @test ClangCompiler.EvaluateAsInt(nc_init, ctx).ptr == C_NULL
    @test ClangCompiler.EvaluateAsBooleanCondition(nc_init, ctx) == -1

    dispose(f)
    dispose(I)
end

@testset "Traversal | template navigation" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "template<typename T, int N> struct S { T x; };")
    f = DeclFinder(I)
    @test f(I, "S")
    ctd = ClangCompiler.ClassTemplateDecl(get_decl(f).ptr)
    tpl = ClangCompiler.getTemplateParameters(ctd)
    @test ClangCompiler.getMinRequiredArguments(tpl) == 2
    ttp = ClangCompiler.TemplateTypeParmDecl(ClangCompiler.getParam(tpl, 0).ptr)
    @test ClangCompiler.getDepth(ttp) == 0
    @test ClangCompiler.getIndex(ttp) == 0
    @test !ClangCompiler.isParameterPack(ttp)
    @test ClangCompiler.getName(ClangCompiler.getTemplatedDecl(ctd)) == "S"
    dispose(f)
    dispose(I)
end

@testset "Traversal | Decl predicate exercise" begin
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
