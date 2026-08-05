using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "name mangling" begin
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

@testset "mangling name generator surface" begin
    # No creator for clang::ASTNameGenerator crosses the C boundary yet, so only the
    # method surface is checkable here.
    @test hasmethod(CC.getAllManglings, Tuple{CC.ASTNameGenerator,CC.FunctionDecl})
end

@testset "Coverage | MangleContext tail" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    CC.parse(I, "constexpr int pv_int = 5;")

    # MangleContext tail. The mangled strings differ between the Itanium and MS
    # manglers, so only their shape is asserted.
    mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    @test CC.isAux(mc) == false
    @test CC.startNewFunction(mc) === nothing

    @test f(I, "pv_int")
    vd_int = CC.VarDecl(get_decl(f).ptr)
    nd_int = CC.NamedDecl(vd_int.ptr)
    id = CC.getAnonymousStructId(mc, nd_int)
    @test CC.getAnonymousStructIdForDebugInfo(mc, nd_int) == id

    int_qt = CC.getType(vd_int)
    @test !isempty(CC.mangleCanonicalTypeName(mc, int_qt))
    @test !isempty(CC.mangleCanonicalTypeName(mc, int_qt, true))
    @test !isempty(CC.mangleCXXRTTIName(mc, int_qt))
    @test !isempty(CC.mangleCXXRTTIName(mc, int_qt, true))

    dispose(f)
    dispose(I)
end

@testset "MangleContext: lambda, RTTI and variable-mangling entry points" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    f = DeclFinder(I)
    # Primitive-typed declarations only: the mangled spelling of a std-typed
    # signature differs between libc++ and libstdc++, and the Itanium and MS
    # manglers disagree on every string below, so only shape is asserted.
    CC.parse(I, """
             int mangle_fn(int a) { return a; }
             int mangle_gv = 41;
             auto mangle_lam = [](int x) { return x + 1; };
             """)

    @test f(I, "mangle_fn")
    fn_nd = CC.NamedDecl(get_decl(f).ptr)
    @test CC.isUniqueInternalLinkageDecl(mc, fn_nd) == false
    @test CC.needsUniqueInternalLinkageNames(mc) === nothing
    # An externally visible function never needs a uniqued name; the flag the call
    # above sets is what makes the Itanium mangler answer the query at all.
    @test !(CC.isUniqueInternalLinkageDecl(mc, fn_nd))

    @test f(I, "mangle_gv")
    gv = CC.VarDecl(get_decl(f).ptr)
    @test !isempty(CC.mangleStaticGuardVariable(mc, gv))
    @test !isempty(CC.mangleDynamicInitializer(mc, gv))

    gv_ty = CC.getType(gv)
    @test !CC.hasQualifiers(gv_ty)
    @test !isempty(CC.mangleCXXRTTI(mc, gv_ty))

    @test f(I, "mangle_lam")
    lam = CC.VarDecl(get_decl(f).ptr)
    closure = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(lam)))
    @test CC.isLambda(closure)
    # Itanium spells it `<lambdaN>` and MSVC `<lambda_N>`: only the prefix is shared.
    @test startswith(CC.getLambdaString(mc, closure), "<lambda")

    dispose(f)
    dispose(I)
end

@testset "Itanium mangling and the raw_ostream mangler tail" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    f = DeclFinder(I)
    # Primitive-typed declarations only: a std-typed signature mangles differently under
    # libc++ (macOS) and libstdc++ (Linux/Windows), and the Itanium and Microsoft manglers
    # share no spelling at all, so nothing but shape and the source spelling of the name
    # is asserted here.
    CC.parse(I, """
             struct MangleVtblBase {
                 MangleVtblBase();
                 virtual ~MangleVtblBase();
                 virtual int step(int n);
             };
             struct MangleVtblDerived : MangleVtblBase {
                 int step(int n) override;
             };
             int mangle_seh_host(int a) { return a; }
             int mangle_temp_var = 11;
             auto mangle_sig_lam = [](int x) { return x; };
             """)

    @test f(I, "mangle_seh_host")
    seh_fn = CC.FunctionDecl(get_decl(f).ptr)
    @test !isempty(CC.mangleCXXName(mc, seh_fn))
    @test !isempty(CC.mangleSEHFilterExpression(mc, seh_fn))
    @test !isempty(CC.mangleSEHFinallyBlock(mc, seh_fn))
    @test CC.mangleSEHFilterExpression(mc, seh_fn) != CC.mangleSEHFinallyBlock(mc, seh_fn)

    @test f(I, "mangle_temp_var")
    tv = CC.VarDecl(get_decl(f).ptr)
    @test !isempty(CC.mangleCXXName(mc, tv))
    @test !isempty(CC.mangleReferenceTemporary(mc, tv))
    @test !isempty(CC.mangleReferenceTemporary(mc, tv, 2))
    @test !isempty(CC.mangleDynamicAtExitDestructor(mc, tv))

    # The Itanium-only surface. The cast is the gate: it yields a NULL carrier under the
    # Microsoft C++ ABI, which is exactly what getKind reports.
    imc = CC.ItaniumMangleContext(mc)
    @test (imc.ptr != C_NULL) == (CC.getKind(mc) == CC.CXMangleContext_MK_Itanium)
    if imc.ptr != C_NULL
        @test f(I, "MangleVtblBase")
        base = CC.CXXRecordDecl(get_decl(f).ptr)
        @test f(I, "MangleVtblDerived")
        derived = CC.CXXRecordDecl(get_decl(f).ptr)

        vt = CC.mangleCXXVTable(imc, base)
        @test occursin("MangleVtblBase", vt)
        @test vt != CC.mangleCXXVTable(imc, derived)
        @test occursin("MangleVtblBase", CC.mangleCXXVTT(imc, base))
        ctor_vt = CC.mangleCXXCtorVTable(imc, derived, 0, base)
        @test occursin("MangleVtblDerived", ctor_vt)
        @test occursin("MangleVtblBase", ctor_vt)

        ctors = CC.getCtors(base)
        @test !isempty(ctors)
        @test occursin("MangleVtblBase", CC.mangleCXXCtorComdat(imc, first(ctors)))
        dtor = CC.getDestructor(base)
        @test occursin("MangleVtblBase", CC.mangleCXXDtorComdat(imc, dtor))

        tls_init = CC.mangleItaniumThreadLocalInit(imc, tv)
        tls_wrap = CC.mangleItaniumThreadLocalWrapper(imc, tv)
        @test occursin("mangle_temp_var", tls_init)
        @test occursin("mangle_temp_var", tls_wrap)
        @test tls_init != tls_wrap
        @test occursin("mangle_temp_var", CC.mangleDynamicStermFinalizer(imc, tv))

        @test f(I, "mangle_sig_lam")
        lam = CC.VarDecl(get_decl(f).ptr)
        closure = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(lam)))
        @test CC.isLambda(closure)
        @test !isempty(CC.mangleLambdaSig(imc, closure))

        m = CC.Module_("MangleInitProbeMod")
        @test occursin("MangleInitProbeMod", CC.mangleModuleInitializer(imc, m))
        dispose(m)
    end

    dispose(f)
    dispose(I)
end
