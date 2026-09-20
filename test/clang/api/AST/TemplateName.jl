using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "TemplateName surface" begin
    I = create_interpreter(String[])
    CC.parse(I, "template<typename T> struct CtnBox { T v; }; CtnBox<int> ctn_b;")
    f = DeclFinder(I)

    @test f(I, "ctn_b")
    qt = CC.getType(CC.VarDecl(get_decl(f)))
    t0 = CC.resolve(CC.getTypePtr(qt))
    t0 isa CC.ElaboratedType && (t0 = CC.resolve(CC.getTypePtr(CC.desugar(t0))))
    @test t0 isa CC.TemplateSpecializationType

    tn = CC.getTemplateName(t0)
    @test CC.get_name(t0) == "CtnBox"
    @test CC.isNull(tn) == false
    # `CtnBox<int>` is written without a nested-name-specifier, but the elaborated
    # sugar still stores the name as a QualifiedTemplateName.
    @test CC.getKind(tn) == CC.LibClangEx.CXTemplateName_QualifiedTemplate
    @test CC.isDependent(tn) == false
    @test !(CC.isInstantiationDependent(tn))
    @test CC.containsUnexpandedParameterPack(tn) == false
    redirect_stdio(; stderr=devnull) do
        @test CC.dump(tn) === nothing
    end

    dispose(f)
    dispose(I)
end

@testset "TemplateName kind payloads" begin
    I = create_interpreter(String[])
    src = """
    namespace TnNS { template <typename T> struct TnBox { T v; }; }
    template <typename T> struct TnAlt { T v; };
    template <template <typename> class TT> struct TnHolder { TT<int> m; };
    template <template <typename> class TT, template <typename> class UU>
    struct TnHolder2 { TT<int> m; UU<int> n; };
    TnHolder<TnNS::TnBox> tn_qual_v;
    TnHolder2<TnNS::TnBox, TnAlt> tn_two;
    template <typename T> TnHolder<T::template Inner> tn_dep_probe();
    """
    CC.parse(I, src)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # A written type name carries its qualifier in an ElaboratedType wrapper; strip it.
    tst_of(qt) = begin
        t = CC.resolve(CC.getTypePtr(qt))
        t isa CC.ElaboratedType && (t = CC.resolve(CC.getTypePtr(CC.getNamedType(t))))
        return t
    end

    @test f(I, "tn_qual_v")
    outer = tst_of(CC.getType(CC.VarDecl(get_decl(f))))
    @test outer isa CC.TemplateSpecializationType

    # A template template argument has no ElaboratedType to hold its qualifier, so
    # "TnNS::TnBox" is a QualifiedTemplateName in the argument itself.
    qarg = CC.getArg(outer, 0)
    @test CC.getKind(qarg) == CC.LibClangEx.CXTemplateArgument_Template
    tn_q = CC.getAsTemplate(qarg)
    @test CC.getKind(tn_q) == CC.LibClangEx.CXTemplateName_QualifiedTemplate
    # `TnNS::TnBox` names a concrete template, so nothing about it is dependent
    @test Int(CC.getDependence(tn_q)) == 0
    @test CC.getAsString(tn_q, ctx) == "TnNS::TnBox"
    @test CC.getAsString(tn_q, ctx, CC.LibClangEx.CXTemplateName_Qualified_None) == "TnBox"
    @test CC.getAsString(tn_q, ctx, CC.LibClangEx.CXTemplateName_Qualified_AsWritten) ==
          "TnNS::TnBox"

    qtn = CC.getAsQualifiedTemplateName(tn_q)
    @test !(CC.hasTemplateKeyword(qtn))
    nns = CC.getQualifier(qtn)
    @test CC.getName(nns) == "TnNS::"
    und = CC.getUnderlyingTemplate(qtn)
    @test CC.getKind(und) == CC.LibClangEx.CXTemplateName_Template

    # The getAs* family is total: every other arm answers with a NULL carrier.
    @test CC.getAsOverloadedTemplate(tn_q).ptr == C_NULL
    @test CC.getAsAssumedTemplateName(tn_q).ptr == C_NULL
    @test CC.getAsSubstTemplateTemplateParm(tn_q).ptr == C_NULL
    @test CC.getAsSubstTemplateTemplateParmPack(tn_q).ptr == C_NULL
    @test CC.getAsDependentTemplateName(tn_q).ptr == C_NULL
    @test CC.getAsUsingShadowDecl(tn_q).ptr == C_NULL

    # Inside the instantiation, TT<int> became TnNS::TnBox<int> through a substituted
    # template template parameter.
    rd = CC.getAsCXXRecordDecl(outer)
    @test !CC.is_null_handle(rd)
    flds = CC.getFields(rd)
    @test length(flds) == 1
    ftst = tst_of(CC.getType(flds[1]))
    @test ftst isa CC.TemplateSpecializationType
    tn_s = CC.getTemplateName(ftst)
    @test CC.getKind(tn_s) == CC.LibClangEx.CXTemplateName_SubstTemplateTemplateParm
    sub = CC.getAsSubstTemplateTemplateParm(tn_s)
    # the substitution stands in for the first (and only) template template parameter
    @test Int(CC.getIndex(sub)) == 0
    @test CC.getName(CC.NamedDecl(CC.getAssociatedDecl(sub))) == "TnHolder"
    repl = CC.getReplacement(sub)
    @test CC.isNull(repl) == false

    # two template template parameters so getIndex cannot ignore its subject
    @test f(I, "tn_two")
    two = tst_of(CC.getType(CC.VarDecl(get_decl(f))))
    @test two isa CC.TemplateSpecializationType
    two_rd = CC.getAsCXXRecordDecl(two)
    @test !CC.is_null_handle(two_rd)
    two_flds = CC.getFields(two_rd)
    @test length(two_flds) == 2
    idx = Int[]
    for fld in two_flds
        ft = tst_of(CC.getType(fld))
        @test ft isa CC.TemplateSpecializationType
        st = CC.getAsSubstTemplateTemplateParm(CC.getTemplateName(ft))
        push!(idx, Int(CC.getIndex(st)))
    end
    @test sort(idx) == [0, 1]

    # "T::template Inner" as a template template argument is a DependentTemplateName.
    @test f(I, "tn_dep_probe")
    ftd = first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "FunctionTemplate")
    fd = CC.getTemplatedDecl(CC.FunctionTemplateDecl(ftd))
    dtst = tst_of(CC.getReturnType(fd))
    @test dtst isa CC.TemplateSpecializationType
    darg = CC.getArg(dtst, 0)
    @test CC.getKind(darg) == CC.LibClangEx.CXTemplateArgument_Template
    tn_d = CC.getAsTemplate(darg)
    @test CC.getKind(tn_d) == CC.LibClangEx.CXTemplateName_DependentTemplate
    @test CC.getDependence(tn_d) != 0
    dtn = CC.getAsDependentTemplateName(tn_d)
    @test !CC.is_null_handle(CC.getQualifier(dtn))
    @test CC.isIdentifier(dtn)
    @test CC.isOverloadedOperator(dtn) == false
    @test CC.getName(CC.getIdentifier(dtn)) == "Inner"
    # getOperator reads the other arm of the name union; the wrapper refuses the call.
    @test_throws AssertionError CC.getOperator(dtn)

    dispose(f)
    dispose(I)
end
