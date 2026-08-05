using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Sema | declaration groups, default-argument conversion and template deduction" begin
    # A throwaway interpreter: the conversions and deductions below build nodes in the
    # ASTContext, so none of it may leak into the interpreter the other files share.
    I = create_interpreter(String[])
    CC.parse(I, """
             template <typename T> struct SemaDedBox { T v; };
             template <typename T> struct SemaDedBox<T *> { T *v; };
             template <typename T> struct SemaDedPair { T a; T b; };
             struct SemaDedRec { int m; };
             void semaDedFn(int p);
             const int semaDedSeven = 7;
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    @test f(I, "semaDedSeven")
    seven = CC.getInit(CC.VarDecl(get_decl(f).ptr))
    @test seven isa CC.Expr_

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    ptr_ty = CC.getPointerType(ctx, int_ty)

    # --- the deduction report box, before anything has been deduced into it ---
    info = CC.TemplateDeductionInfo(loc)
    @test info isa CC.TemplateDeductionInfo
    @test info.ptr != C_NULL
    @test !CC.is_null_handle(CC.getLocation(info))
    @test CC.getDeducedDepth(info) == 0
    @test CC.getNumExplicitArgs(info) isa Integer  # shape-only: the target chooses this value
    @test !(CC.hasSFINAEDiagnostic(info))
    @test CC.getCallArgIndex(info) isa Integer  # shape-only: the target chooses this value
    @test CC.takeCanonical(info).ptr == C_NULL

    # --- matching a class template partial specialization against an argument list ---
    # The name reaches both the primary template and its partial specialization, so select
    # by kind rather than through get_decl.
    @test f(I, "SemaDedBox")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f)
                                     if CC.getDeclKindName(d) == "ClassTemplate").ptr)
    partials = CC.getPartialSpecializations(ctd)
    @test length(partials) == 1
    partial = partials[1]

    ptr_arg = CC.TemplateArgument(ptr_ty)
    ptr_args = CC.TemplateArgumentList(ctx, [ptr_arg])
    # `SemaDedBox<int *>` matches the `SemaDedBox<T *>` pattern with T = int
    @test CC.DeduceTemplateArguments(sema, partial, ptr_args, info) ==
          CC.CXTemplateDeductionResult_TDK_Success
    deduced = CC.takeSugared(info)
    @test deduced isa CC.TemplateArgumentList
    @test deduced.ptr != C_NULL
    @test size(deduced) == 1
    # the take* accessors transfer the list out of the report
    @test CC.takeSugared(info).ptr == C_NULL
    CC.dispose(ptr_arg)

    info2 = CC.TemplateDeductionInfo(loc)
    int_arg = CC.TemplateArgument(int_ty)
    int_args = CC.TemplateArgumentList(ctx, [int_arg])
    # a plain `int` cannot match the pointer pattern
    @test CC.DeduceTemplateArguments(sema, partial, int_args, info2) !=
          CC.CXTemplateDeductionResult_TDK_Success
    CC.dispose(int_arg)
    CC.dispose(info2)

    # --- deducing `auto` from an initializer ---
    auto_tsi = CC.getTrivialTypeSourceInfo(ctx, CC.getAutoDeductType(ctx), loc)
    auto_tl = CC.getTypeLoc(auto_tsi)
    info3 = CC.TemplateDeductionInfo(loc)
    kind, deduced_ty = CC.DeduceAutoType(sema, auto_tl, seven, info3)
    @test kind == CC.CXTemplateDeductionResult_TDK_Success
    @test deduced_ty isa CC.QualType
    @test CC.isIntegerType(CC.getTypePtr(deduced_ty))

    # the wrapper restates clang's own precondition: no `auto`, no deduction
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, int_ty, loc)
    int_tl = CC.getTypeLoc(int_tsi)
    @test_throws AssertionError CC.DeduceAutoType(sema, int_tl, seven, info3)
    CC.dispose(int_tl)
    CC.dispose(auto_tl)
    CC.dispose(info3)

    # --- template parameter list comparison; Complain=false is a pure query ---
    box_params = CC.getTemplateParameters(ctd)
    @test box_params isa CC.TemplateParameterList
    @test CC.TemplateParameterListsAreEqual(sema, box_params, box_params, false,
                                            CC.CXTemplateParameterListEqualKind_TPL_TemplateMatch,
                                            loc)
    @test f(I, "SemaDedPair")
    pair = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f)
                                      if CC.getDeclKindName(d) == "ClassTemplate").ptr)
    @test CC.TemplateParameterListsAreEqual(sema, box_params,
                                            CC.getTemplateParameters(pair), false,
                                            CC.CXTemplateParameterListEqualKind_TPL_TemplateMatch,
                                            loc) isa Bool

    # --- default member initializer and default argument conversion ---
    @test f(I, "SemaDedRec")
    rec = CC.CXXRecordDecl(get_decl(f).ptr)
    fld = first(CC.getFields(rec))
    @test fld isa CC.FieldDecl
    @test CC.ConvertMemberDefaultInitExpression(sema, fld, seven, loc) isa
          Union{Nothing,CC.Expr_}

    @test f(I, "semaDedFn")
    fn = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.getNumParams(fn) == 1
    param = CC.getParamDecl(fn, 0)
    @test CC.ConvertParamDefaultArgument(sema, param, seven, loc) isa Union{Nothing,CC.Expr_}

    # --- declaration groups ---
    dg = CC.ConvertDeclToDeclGroup(sema, rec)
    @test dg isa CC.DeclGroupRef
    @test dg.ptr != C_NULL
    dg2 = CC.ConvertDeclToDeclGroup(sema, fn, rec)
    @test dg2 isa CC.DeclGroupRef
    @test dg2.ptr != C_NULL

    CC.dispose(info)
    dispose(I)
end
