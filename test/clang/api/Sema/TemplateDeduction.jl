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
    seven = CC.getInit(CC.VarDecl(get_decl(f)))
    @test seven isa CC.Expr_

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    ptr_ty = CC.getPointerType(ctx, int_ty)

    # --- the deduction report box, before anything has been deduced into it ---
    info = CC.TemplateDeductionInfo(loc)
    @test info isa CC.TemplateDeductionInfo
    @test info.ptr != C_NULL
    @test !CC.is_null_handle(CC.getLocation(info))
    @test CC.getDeducedDepth(info) == 0
    @test Int(CC.getNumExplicitArgs(info)) == 0
    @test !(CC.hasSFINAEDiagnostic(info))
    @test Int(CC.getCallArgIndex(info)) == 0
    @test CC.takeCanonical(info).ptr == C_NULL

    # --- matching a class template partial specialization against an argument list ---
    # The name reaches both the primary template and its partial specialization, so select
    # by kind rather than through get_decl.
    @test f(I, "SemaDedBox")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
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
    pair = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    @test CC.TemplateParameterListsAreEqual(sema, box_params,
                                            CC.getTemplateParameters(pair), false,
                                            CC.CXTemplateParameterListEqualKind_TPL_TemplateMatch,
                                            loc) isa Bool

    # --- default member initializer and default argument conversion ---
    @test f(I, "SemaDedRec")
    rec = CC.CXXRecordDecl(get_decl(f))
    fld = first(CC.getFields(rec))
    @test fld isa CC.FieldDecl
    @test CC.ConvertMemberDefaultInitExpression(sema, fld, seven, loc) isa
          Union{Nothing,CC.Expr_}

    @test f(I, "semaDedFn")
    fn = CC.FunctionDecl(get_decl(f))
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

@testset "TemplateDeduction | variable-template partials and function templates" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
              template <class T> constexpr int SemaVBox = 1;
              template <class T> constexpr int SemaVBox<T *> = 2;
              template <class T> void sema_ident(T) {}
              template <class T> void sema_call2(T a, T b);
              template <class T> void sema_callptr(T *a, T b);
              int sema_arg_i = 1;
              double sema_arg_d = 2.5;
              void sema_explicit_use() { void (*p)(int, int) = &sema_call2<int>; (void)p; }
              """)
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    loc = CC.SourceLocation()
    int_ty = CC.get_qual_type(CC.IntTy(ctx))
    ptr_ty = CC.getPointerType(ctx, int_ty)
    f = DeclFinder(I)

    @testset "a variable template's partial specialization deduces like a class's" begin
        @test f(I, "SemaVBox")
        vtd = CC.VarTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "VarTemplate"))
        partials = CC.getPartialSpecializations(vtd)
        @test length(partials) == 1

        info = CC.TemplateDeductionInfo(loc)
        arg = CC.TemplateArgument(ptr_ty)
        args = CC.TemplateArgumentList(ctx, [arg])
        # `SemaVBox<int *>` matches the `SemaVBox<T *>` pattern
        @test CC.DeduceTemplateArguments(sema, partials[1], args, info) ==
              CC.CXTemplateDeductionResult_TDK_Success
        @test CC.size(CC.takeSugared(info)) == 1
        CC.dispose(arg)
        CC.dispose(info)

        # ...and a plain `int` does not, which is what makes the success above mean something
        info2 = CC.TemplateDeductionInfo(loc)
        arg2 = CC.TemplateArgument(int_ty)
        args2 = CC.TemplateArgumentList(ctx, [arg2])
        @test CC.DeduceTemplateArguments(sema, partials[1], args2, info2) ==
              CC.CXTemplateDeductionResult_TDK_NonDeducedMismatch
        CC.dispose(arg2)
        CC.dispose(info2)
    end

    @testset "a function template deduces from a target function type" begin
        CC.reset(f)
        @test f(I, "sema_ident")
        ft = CC.FunctionTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "FunctionTemplate"))
        void_ty = CC.get_qual_type(CC.VoidTy(ctx))

        info = CC.TemplateDeductionInfo(loc)
        proto = CC.getFunctionType(ctx, void_ty, CC.QualType[int_ty])
        r, spec = CC.DeduceTemplateArguments(sema, ft, info; arg_function_type=proto)
        @test r == CC.CXTemplateDeductionResult_TDK_Success
        @test spec !== nothing
        @test CC.getName(spec) == "sema_ident"
        CC.dispose(info)

        # With neither explicit arguments nor a target type there is nothing to deduce from,
        # so the specialization stays `nothing` -- the out-parameter is written on success only.
        info2 = CC.TemplateDeductionInfo(loc)
        r2, spec2 = CC.DeduceTemplateArguments(sema, ft, info2)
        @test r2 != CC.CXTemplateDeductionResult_TDK_Success
        @test spec2 === nothing
        CC.dispose(info2)
    end

    @testset "a function template deduces from the arguments of a call" begin
        # The overload-resolution form. The three above deduce from a template-argument list
        # or a target function type; only this one is handed the call's arguments, and it
        # tells the failure modes apart by which argument broke -- a shim ignoring the
        # argument buffer gives one answer for all four cases below.
        expr_of(name) = (CC.reset(f); @assert f(I, name); CC.getInit(CC.VarDecl(get_decl(f))))
        template_named(name) = (CC.reset(f); @assert f(I, name);
                                CC.FunctionTemplateDecl(first(d for d in CC.get_decls(f)
                                                              if CC.getDeclKindName(d) == "FunctionTemplate")))
        ei, ed = expr_of("sema_arg_i"), expr_of("sema_arg_d")
        @test CC.getAsString(CC.getType(ei)) == "int"
        @test CC.getAsString(CC.getType(ed)) == "double"
        call2, callptr = template_named("sema_call2"), template_named("sema_callptr")

        function deduce(tmpl, args; kwargs...)
            info = CC.TemplateDeductionInfo(loc)
            r, spec = CC.DeduceTemplateArguments(sema, tmpl, args, info; kwargs...)
            idx = Int(CC.getCallArgIndex(info))
            CC.dispose(info)
            return r, spec, idx
        end

        # Two `int`s deduce T = int.
        r, spec, _ = deduce(call2, [ei, ei])
        @test r == CC.CXTemplateDeductionResult_TDK_Success
        @test spec !== nothing
        @test CC.getName(spec) == "sema_call2"

        # An `int` then a `double` deduce T twice, inconsistently -- and this is the second
        # argument disagreeing with the first, not either one being unusable on its own.
        r, spec, idx = deduce(call2, [ei, ed])
        @test r == CC.CXTemplateDeductionResult_TDK_Inconsistent
        @test spec === nothing
        # ISSUE 50 expected this overload to make `getCallArgIndex` meaningful. It does not:
        # clang 18 leaves it at 0 through every path this entry point reaches, so the
        # `deduction_callarg_zero` mutant stays blocked rather than being killed here.
        @test idx == 0

        # No arguments at all: a different failure again, and reached without touching the
        # (empty) buffer.
        r, spec, _ = deduce(call2, CC.Expr_[])
        @test r == CC.CXTemplateDeductionResult_TDK_TooFewArguments
        @test spec === nothing

        # A `T *` parameter against an `int` argument is a non-deduced mismatch -- a fourth
        # outcome, so the result tracks the parameter/argument pairing rather than the count.
        r, spec, _ = deduce(callptr, [ei, ei])
        @test r == CC.CXTemplateDeductionResult_TDK_NonDeducedMismatch
        @test spec === nothing

        # Explicit template arguments participate rather than being dropped: naming T = int
        # makes the same (int, double) call stop being a deduction conflict, because there
        # is nothing left to deduce. The `<int>` comes off a reference the source wrote,
        # since a TemplateArgumentLoc cannot be built from nothing.
        CC.reset(f)
        @test f(I, "sema_explicit_use")
        use = CC.FunctionDecl(get_decl(f))
        dre = first(n for n in CC.subtree(CC.getBody(use))
                    if n isa CC.DeclRefExpr && CC.hasExplicitTemplateArgs(n))
        explicit = CC.TemplateArgumentListInfo(CC.getLAngleLoc(dre), CC.getRAngleLoc(dre))
        CC.copyTemplateArgumentsInto(dre, explicit)
        @test size(explicit) == 1

        r, spec, _ = deduce(call2, [ei, ed]; explicit_args=explicit)
        @test r == CC.CXTemplateDeductionResult_TDK_Success
        @test spec !== nothing
        CC.dispose(explicit)
    end

    CC.dispose(f)
    dispose(I)
end
