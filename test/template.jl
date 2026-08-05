using ClangCompiler
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl
using Test
import ClangCompiler as CC

@testset "specialize" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <int N> struct TplArr { int a[N]; };
    template <bool B, class T> struct TplOpt {};
    """)
    ctx = CC.get_ast_context(I)
    llctx = LLVM.Context()
    f = DeclFinder(I)

    # non-type (integer) template argument
    @test f(I, "TplArr")
    arr_ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    spec = CC.specialize(llctx, ctx, arr_ctd, Int32(4))
    @test spec isa CC.ClassTemplateSpecializationDecl
    @test spec.ptr != C_NULL
    @test size(CC.getTemplateArgs(spec)) == 1
    # a second call finds the registered specialization instead of re-creating it
    respec = CC.specialize(llctx, ctx, arr_ctd, Int32(4))
    @test respec.ptr == spec.ptr

    # bool + type template arguments
    @test f(I, "TplOpt")
    opt_ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    spec2 = CC.specialize(llctx, ctx, opt_ctd, true, CC.jlty_to_clty(Float64, ctx))
    @test spec2 isa CC.ClassTemplateSpecializationDecl
    @test spec2.ptr != C_NULL
    @test size(CC.getTemplateArgs(spec2)) == 2

    # unsupported argument kinds are rejected
    @test_throws ErrorException CC.specialize(llctx, ctx, arr_ctd, "4")

    dispose(f)
    LLVM.dispose(llctx)
    dispose(I)
end
