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
    @test CC.mangleCanonicalTypeName(mc, int_qt, true) isa String
    @test !isempty(CC.mangleCXXRTTIName(mc, int_qt))
    @test CC.mangleCXXRTTIName(mc, int_qt, true) isa String

    dispose(f)
    dispose(I)
end
