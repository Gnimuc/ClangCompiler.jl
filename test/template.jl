using ClangCompiler
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl
using Test
import ClangCompiler as CC

@testset "specialize unifies through sugar" begin
    # `TemplateArgument::Profile` folds the integral type, and Sema runs its arguments through
    # `getCanonicalTemplateArgument` before the folding set sees them. So a parameter written
    # through a typedef -- which is every `template <std::size_t N>` -- or as an enum keys on the
    # sugar-free type, and building the argument with the type as written yields a SECOND
    # ClassTemplateSpecializationDecl for a type clang already has.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
             typedef int MyInt;
             enum Color : int { Red = 0, Blue = 1 };
             template <int N>   struct SugPlain { int a[N]; };
             template <MyInt N> struct SugTypedef { int a[N]; };
             template <Color C> struct SugEnum { int a[2]; };
             SugPlain<4>   sug_plain_obj;
             SugTypedef<4> sug_typedef_obj;
             SugEnum<Blue> sug_enum_obj;
             """)
    # the decl clang itself built for a source-written variable of that specialization
    sema_spec(name) = CC.resolve(CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(CC.VarDecl(CC.find_decl(I, name))))))
    for (tmpl, var, arg) in (("SugPlain", "sug_plain_obj", Int32(4)), ("SugTypedef", "sug_typedef_obj", Int32(4)), ("SugEnum", "sug_enum_obj", Int32(1)))
        ctd = CC.ClassTemplateDecl(CC.find_decl(I, tmpl))
        mine = CC.specialize(ctx, ctd, arg)
        theirs = sema_spec(var)
        @test mine isa CC.ClassTemplateSpecializationDecl
        # the same decl, not merely one of the same class
        @test Base.unsafe_convert(CC.CXDecl, mine) == Base.unsafe_convert(CC.CXDecl, theirs)
    end
    dispose(I)
end

@testset "specialize packs a variadic non-type parameter as Sema does" begin
    # Sema folds `Pk<1,2,3>` into ONE `Pack` argument, and
    # `ClassTemplateSpecializationDecl::Profile` folds the argument count first, so a
    # three-argument list can never unify with it however right each argument is.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
             template <int... Ns> struct Pk { int a[sizeof...(Ns)]; };
             Pk<1, 2, 3> pk_obj;
             """)
    ctd = CC.ClassTemplateDecl(CC.find_decl(I, "Pk"))
    theirs = CC.resolve(CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(CC.VarDecl(CC.find_decl(I, "pk_obj"))))))
    mine = CC.specialize(ctx, ctd, Int32(1), Int32(2), Int32(3))
    @test Base.unsafe_convert(CC.CXDecl, mine) == Base.unsafe_convert(CC.CXDecl, theirs)
    # and the shape is a pack, not three loose arguments
    built = CC.getTemplateArgs(mine)
    @test size(built) == 1
    @test CC.getKind(get(built, 0)) == CC.LibClangEx.CXTemplateArgument_Pack
    dispose(I)
end

@testset "a non-type template argument needs a type clang can measure" begin
    # The shim reads the type's signedness and width, so it has an answer only for a
    # non-dependent integral or enumeration type. Before these gates a null type reached
    # `QualType::operator->` and took SIGABRT, and a dependent one reached `getTypeSize`'s
    # `llvm_unreachable`, which a release build falls through.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    llctx = LLVM.Context()
    CC.parse(I, "struct NtaRec { int m; };")
    v = LLVM.GenericValue(LLVM.IntType(32), 4)

    # null: `QualType::operator->` asserts, and the assert is compiled into the release build
    @test_throws AssertionError CC.TemplateArgument(ctx, v, CC.QualType(C_NULL))
    # non-integral: a record type has no signedness and no integer width
    rec = CC.getTypeDeclType(ctx, CC.TypeDecl(CC.find_decl(I, "NtaRec")))
    @test !CC.isIntegralOrEnumerationType(CC.getTypePtr(rec))
    @test_throws AssertionError CC.TemplateArgument(ctx, v, rec)
    # and the shape that still works, so the gates are not simply refusing everything
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    ta = CC.TemplateArgument(ctx, v, int_qt)
    @test CC.getKind(ta) == CC.LibClangEx.CXTemplateArgument_Integral

    # The Integer method is the same argument without the LLVM detour: the GenericValue only
    # ever carried raw bits, since signedness and width come from the QualType either way. Both
    # are built here and their integral payloads compared, so a divergence between the two C
    # entry points shows up as a value mismatch rather than as a specialization that silently
    # fails to unify much later. That end of it -- that the argument profiles the same as the
    # one Sema builds -- is covered by the "unifies with the specialization Sema builds"
    # testset below, which now runs through this path.
    ta_i = CC.TemplateArgument(ctx, 4, int_qt)
    @test CC.getKind(ta_i) == CC.LibClangEx.CXTemplateArgument_Integral
    gv_v = LLVM.GenericValue(CC.getAsIntegral(ta))
    gv_i = LLVM.GenericValue(CC.getAsIntegral(ta_i))
    @test convert(Int, gv_v) == 4
    @test convert(Int, gv_i) == convert(Int, gv_v)
    @test CC.getAsString(CC.getIntegralType(ta_i)) == CC.getAsString(CC.getIntegralType(ta))
    LLVM.dispose(gv_v)
    LLVM.dispose(gv_i)
    # and the same gates apply to it
    @test_throws AssertionError CC.TemplateArgument(ctx, 4, CC.QualType(C_NULL))
    @test_throws AssertionError CC.TemplateArgument(ctx, 4, rec)
    CC.dispose(ta_i)

    CC.dispose(ta)
    LLVM.dispose(v)
    LLVM.dispose(llctx)
    dispose(I)
end

@testset "specialize" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <int N> struct TplArr { int a[N]; };
    template <bool B, class T> struct TplOpt {};
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # non-type (integer) template argument
    @test f(I, "TplArr")
    arr_ctd = CC.ClassTemplateDecl(get_decl(f))
    spec = CC.specialize(ctx, arr_ctd, Int32(4))
    @test spec isa CC.ClassTemplateSpecializationDecl
    @test spec.ptr != C_NULL
    @test size(CC.getTemplateArgs(spec)) == 1
    # a second call finds the registered specialization instead of re-creating it
    respec = CC.specialize(ctx, arr_ctd, Int32(4))
    @test respec.ptr == spec.ptr

    # bool + type template arguments
    @test f(I, "TplOpt")
    opt_ctd = CC.ClassTemplateDecl(get_decl(f))
    spec2 = CC.specialize(ctx, opt_ctd, true, CC.jlty_to_clty(Float64, ctx))
    @test spec2 isa CC.ClassTemplateSpecializationDecl
    @test spec2.ptr != C_NULL
    @test size(CC.getTemplateArgs(spec2)) == 2

    # unsupported argument kinds are rejected
    @test_throws ErrorException CC.specialize(ctx, arr_ctd, "4")

    dispose(f)
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
    for (tpl, var, arg) in (("UniI", "uni_i", Int32(4)), ("UniU", "uni_u", UInt32(4)), ("UniB", "uni_b", true), ("UniL", "uni_l", Int64(4)))
        built = CC.specialize(ctx, class_template(tpl), arg)
        @test decl_id(built) == decl_id(sema_specialization(var))
    end

    dispose(f)
    dispose(I)
end
