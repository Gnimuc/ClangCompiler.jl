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
    arr_ctd = CC.ClassTemplateDecl(get_decl(f))
    spec = CC.specialize(llctx, ctx, arr_ctd, Int32(4))
    @test spec isa CC.ClassTemplateSpecializationDecl
    @test spec.ptr != C_NULL
    @test size(CC.getTemplateArgs(spec)) == 1
    # a second call finds the registered specialization instead of re-creating it
    respec = CC.specialize(llctx, ctx, arr_ctd, Int32(4))
    @test respec.ptr == spec.ptr

    # bool + type template arguments
    @test f(I, "TplOpt")
    opt_ctd = CC.ClassTemplateDecl(get_decl(f))
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

@testset "specialize unifies with the specialization Sema builds" begin
    # The assertion above -- `respec.ptr == spec.ptr` -- only shows that a Julia-built argument
    # list matches *itself*. It stays green while every such list profiles differently from the
    # one Sema builds for the same C++ type, which is exactly the bug it failed to catch:
    # `TemplateArgument::Profile` folds the integral argument's signedness and bit width into the
    # FoldingSetNodeID (APSInt::Profile adds IsUnsigned, then APInt::Profile the width and value),
    # so an argument built with the wrong flag or width never unifies. The ASTContext then holds
    # two ClassTemplateSpecializationDecls for one type, and instantiating a member on the wrong
    # one gives CodeGen two definitions under a single mangled name.
    #
    # The only assertion that catches that is against the decl clang itself created for a
    # source-written specialization, which is what this does.
    I = create_interpreter(String[])
    CC.parse(I, """
             template <int N>      struct UniI { int a[N]; };
             template <unsigned N> struct UniU { int a[N]; };
             template <bool B>     struct UniB { int a[B ? 2 : 1]; };
             template <long N>     struct UniL { int a[N]; };
             UniI<4> uni_i; UniU<4u> uni_u; UniB<true> uni_b; UniL<4L> uni_l;
             """)
    ctx = CC.get_ast_context(I)
    llctx = LLVM.Context()
    f = DeclFinder(I)

    function class_template(name)
        CC.reset(f)
        @test f(I, name)
        return CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    end
    "The specialization clang built for a source-written variable of that type."
    function sema_specialization(varname)
        ty = CC.getType(CC.find_decl(I, varname))
        return CC.ClassTemplateSpecializationDecl(CC.getAsCXXRecordDecl(CC.getTypePtr(ty)))
    end
    decl_id(d) = Base.unsafe_convert(CC.LibClangEx.CXDecl, d)

    # Signed, unsigned and bool each get the signedness and width from the parameter's own type.
    # `long` is the case that also proves the type itself comes from the parameter: Julia has one
    # 64-bit integer and `jlty_to_clty` maps it to `long long`, so guessing from the Julia type
    # yields a different QualType and a different profile.
    for (tpl, var, arg) in (("UniI", "uni_i", Int32(4)), ("UniU", "uni_u", UInt32(4)),
                            ("UniB", "uni_b", true), ("UniL", "uni_l", Int64(4)))
        built = CC.specialize(llctx, ctx, class_template(tpl), arg)
        @test decl_id(built) == decl_id(sema_specialization(var))
    end

    dispose(f)
    LLVM.dispose(llctx)
    dispose(I)
end
