using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

@testset "APValue constant evaluation" begin
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
