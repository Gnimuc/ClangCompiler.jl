using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Skiplist-drain tail (AST half): dyn_cast probes, ArrayRef views, decl
# factories, DeclContext pivots, and the process-global stats toggles.
# Assertions are host-portable: isa/Bool checks and round-trips of values
# set inside this file only.

const LX = CC.LibClangEx

@testset "APITail | Type queries" begin
    I = create_interpreter(String[])
    CC.parse(I, """
        int gint = 1;
        int *pint = &gint;
        int &lref = gint;
        int &&rref = 2;
        __complex__ double cxv;
        struct Point { int x; int y; };
        Point gpt;
        int Point::*mptr = &Point::x;
        int arr7[7];
        extern int iarr[];
        int fn2(int a, double b);
        auto undeduced_fn();
        int cval = (int)3.5;
        template <int N> struct S2 { int a[N]; };
        template <class T> struct S4 { typename T::template TT<int> w; };
        template <class T> struct S5 { decltype(T::val) u; };
        template <class T> struct S6 { T t; };
        template <class T> struct TP { };
        template <> struct TP<int> { int q; };
        TP<int> tpv;
        template <int N> struct NT { };
        NT<3> ntv;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    rvar(name) = (@assert f(I, name) "lookup failed: $name"; CC.resolve(get_decl(f)))
    qtof(name) = CC.getType(rvar(name))
    tpof(name) = CC.getTypePtr(qtof(name))
    rty(name) = CC.resolve(tpof(name))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t
    canon(name) = CC.getTypePtr(CC.getCanonicalTypeInternal(tpof(name)))
    function patfield(name)
        @assert f(I, name) "lookup failed: $name"
        pat = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
        return CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(pat)))))
    end

    ib = tpof("gint")

    # every dyn_cast probe is false on a plain builtin int
    preds = (CC.isa_ComplexType, CC.isa_PointerType, CC.isa_ReferenceType,
             CC.isa_LValueReferenceType, CC.isa_RValueReferenceType,
             CC.isa_MemberPointerType, CC.isa_ArrayType, CC.isa_ConstantArrayType,
             CC.isa_IncompleteArrayType, CC.isa_VariableArrayType,
             CC.isa_DependentSizedArrayType, CC.isa_FunctionType,
             CC.isa_FunctionNoProtoType, CC.isa_FunctionProtoType,
             CC.isa_DependentDecltypeType, CC.isa_RecordType,
             CC.isa_TemplateTypeParmType, CC.isa_AutoType)
    for p in preds
        @test p(ib) == false
    end

    # ...and true on a matching probe type
    @test CC.isa_ComplexType(tpof("cxv"))
    @test CC.isa_PointerType(tpof("pint"))
    @test CC.isa_ReferenceType(tpof("lref"))
    @test CC.isa_LValueReferenceType(tpof("lref"))
    @test CC.isa_RValueReferenceType(tpof("rref"))
    @test CC.isa_MemberPointerType(tpof("mptr"))
    a7 = tpof("arr7")
    @test CC.isa_ArrayType(a7)
    @test CC.isa_ConstantArrayType(a7)
    @test CC.isa_VariableArrayType(a7) == false
    @test CC.isa_IncompleteArrayType(tpof("iarr"))
    dsa = patfield("S2")
    @test dsa isa CC.DependentSizedArrayType
    @test CC.isa_DependentSizedArrayType(dsa)
    fpt = rty("fn2")
    @test fpt isa CC.FunctionProtoType
    @test CC.isa_FunctionType(fpt)
    @test CC.isa_FunctionProtoType(fpt)
    @test CC.isa_FunctionNoProtoType(fpt) == false
    @test CC.isa_DependentDecltypeType(patfield("S5"))
    @test CC.isa_TemplateTypeParmType(patfield("S6"))
    @test CC.isa_RecordType(canon("gpt"))

    # undeduced auto return type: AutoType probe + contained DeducedType
    fpt_u = rty("undeduced_fn")
    @test fpt_u isa CC.FunctionProtoType
    @test CC.isa_AutoType(CC.getTypePtr(CC.getReturnType(fpt_u)))
    dt = CC.getContainedDeducedType(tpof("undeduced_fn"))
    @test dt isa CC.DeducedType
    @test dt.ptr != C_NULL
    @test CC.getContainedDeducedType(ib).ptr == C_NULL

    # FunctionProtoType parameter/exception ArrayRef views
    pts = CC.getParamTypes(fpt)
    @test Int(pts.Length) == 2
    @test Int(pts.Length) == CC.getNumParams(fpt)
    pts2 = CC.param_types(fpt)
    @test Int(pts2.Length) == 2
    @test pts2.Data == pts.Data
    @test Int(CC.exceptions(fpt).Length) == 0

    # ConstantArrayType: int[7] occupies 28 bytes -> 5 addressing bits
    caty = CC.resolve(a7)
    @test caty isa CC.ConstantArrayType
    @test CC.getNumAddressingBits(caty, ctx) == 5

    # DependentTemplateSpecializationType: T::template TT<int> carries one argument
    dtst = unwrap(patfield("S4"))
    @test dtst isa CC.DependentTemplateSpecializationType
    @test Int(CC.getTemplateArguments(dtst).Length) == 1

    # TemplateArgument: non-type argument carries a type for NT<3>, none for TP<int>
    ntt = unwrap(rty("ntv"))
    @test ntt isa CC.TemplateSpecializationType
    @test CC.getNonTypeTemplateArgumentType(CC.getArg(ntt, 0)).ptr != C_NULL
    tst = unwrap(rty("tpv"))
    @test CC.getNonTypeTemplateArgumentType(CC.getArg(tst, 0)).ptr == C_NULL

    # TagDecl template parameter lists: one `template<>` header on the explicit
    # specialization, none on a plain struct
    spec_rd = CC.getDecl(CC.resolve(canon("tpv")))
    @test CC.getNumTemplateParameterLists(spec_rd) == 1
    tpl = CC.getTemplateParameterList(spec_rd, 0)
    @test tpl isa CC.TemplateParameterList
    @test size(tpl) == 0
    prd = CC.getDecl(CC.resolve(canon("gpt")))
    @test CC.getNumTemplateParameterLists(prd) == 0
    @test CC.mayInsertExtraPadding(prd) == false
    @test CC.mayInsertExtraPadding(prd, false) == false

    # CStyleCastExpr declares its own begin/end locs (begin == its LParen)
    cse = CC.resolve(CC.getInit(rvar("cval")))
    @test cse isa CC.CStyleCastExpr
    bl = CC.getBeginLoc(cse)
    el = CC.getEndLoc(cse)
    @test bl isa CC.SourceLocation
    @test el isa CC.SourceLocation
    @test bl.ptr == CC.getLParenLoc(cse).ptr

    # free-function operator spelling
    @test CC.getOperatorSpelling(LX.CXOverloadedOperatorKind_OO_Plus) == "+"
    @test CC.getOperatorSpelling(LX.CXOverloadedOperatorKind_OO_Subscript) == "[]"

    CC.dispose(f)
    CC.dispose(I)
end

@testset "APITail | Decl factories, pivots & stats" begin
    I = create_interpreter(String[])
    CC.parse(I, """
        int gint = 1;
        extern "C" { int cfn(int); }
        struct VBase { virtual int vm(); virtual ~VBase(); };
        struct VDer final : VBase { int vm() override; };
        VDer gvd;
        int usevm() { return gvd.vm(); }
        struct OB { virtual void om(); virtual ~OB(); };
        struct OD : OB { virtual void om2(); };
        OD god;
        void useo(OB &b) { god.om2(); b.om(); }
    """)
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)
    f = DeclFinder(I)
    getptr(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f).ptr)

    vd = CC.VarDecl(getptr("gint"))
    loc = CC.getLocation(vd)
    id = CC.getIdentifier(vd)
    int_qt = CC.getType(vd)

    # PragmaCommentDecl: kind and trailing arg round-trip
    pcd = CC.PragmaCommentDecl(ctx, tu, loc, LX.CXPragmaMSCommentKind_PCK_Lib, "libarg")
    @test pcd isa CC.PragmaCommentDecl
    @test CC.getCommentKind(pcd) == LX.CXPragmaMSCommentKind_PCK_Lib
    @test CC.getArg(pcd) == "libarg"
    @test CC.PragmaCommentDecl(ctx, 1, 8) isa CC.PragmaCommentDecl

    # PragmaDetectMismatchDecl: name/value round-trip
    pdd = CC.PragmaDetectMismatchDecl(ctx, tu, loc, "pname", "pval")
    @test pdd isa CC.PragmaDetectMismatchDecl
    @test CC.getName(pdd) == "pname"
    @test CC.getValue(pdd) == "pval"
    @test CC.PragmaDetectMismatchDecl(ctx, 2, 12) isa CC.PragmaDetectMismatchDecl

    @test CC.ExternCContextDecl(ctx, tu) isa CC.ExternCContextDecl

    @test CC.RequiresExprBodyDecl(ctx, dc, loc) isa CC.RequiresExprBodyDecl
    @test CC.RequiresExprBodyDecl(ctx, 3) isa CC.RequiresExprBodyDecl

    # EnumDecl.completeDefinition round-trip on a fresh (incomplete) enum
    ed = CC.EnumDecl(ctx, dc, loc, loc, id)
    @test CC.isCompleteDefinition(ed) == false
    CC.completeDefinition(ed, int_qt, int_qt, 31, 0)
    @test CC.isCompleteDefinition(ed) == true
    @test CC.getNumPositiveBits(ed) == 31
    @test CC.getNumNegativeBits(ed) == 0
    @test CC.getPromotionType(ed).ptr == int_qt.ptr

    # LinkageSpecDecl <-> DeclContext pivots round-trip
    local lsd = nothing
    for d in CC.decls(dc)
        d isa CC.LinkageSpecDecl && (lsd = d; break)
    end
    @test lsd isa CC.LinkageSpecDecl
    ldc = CC.DeclContext(lsd)
    @test ldc isa CC.DeclContext
    back = CC.LinkageSpecDecl(ldc)
    @test back isa CC.LinkageSpecDecl
    @test back.ptr == lsd.ptr

    # CXXMethodDecl: devirtualization + corresponding-method lookups
    local me = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(CC.FunctionDecl(getptr("usevm")))))
        n isa CC.MemberExpr && (me = n; break)
    end
    @test me isa CC.MemberExpr
    md = CC.CXXMethodDecl(CC.getMemberDecl(me).ptr)
    dv = CC.getDevirtualizedMethod(md, CC.getBase(me), false)
    @test dv isa CC.CXXMethodDecl
    @test dv.ptr != C_NULL
    @test CC.getName(dv) == "vm"

    vbase = CC.CXXRecordDecl(getptr("VBase"))
    vder = CC.CXXRecordDecl(getptr("VDer"))
    mib = CC.getCorrespondingMethodInClass(md, vbase, true)
    @test mib isa CC.CXXMethodDecl
    @test mib.ptr != C_NULL
    @test CC.getName(mib) == "vm"
    mdd = CC.getCorrespondingMethodDeclaredInClass(md, vder)
    @test mdd isa CC.CXXMethodDecl
    @test mdd.ptr != C_NULL
    @test CC.getName(mdd) == "vm"

    mes = [n for n in CC.subtree(CC.resolve(CC.getBody(CC.FunctionDecl(getptr("useo")))))
           if n isa CC.MemberExpr]
    @test length(mes) == 2
    byname = Dict(CC.getName(CC.getMemberDecl(m)) => m for m in mes)
    md_om2 = CC.getCanonicalDecl(CC.CXXMethodDecl(CC.getMemberDecl(byname["om2"]).ptr))
    md_om = CC.getCanonicalDecl(CC.CXXMethodDecl(CC.getMemberDecl(byname["om"]).ptr))
    @test CC.addOverriddenMethod(md_om2, md_om) === nothing

    # process-global stats toggles (PrintStats writes a summary to stderr)
    @test CC.EnableStatistics() === nothing
    @test CC.PrintStats() === nothing
    sema = CC.get_sema(I)
    @test CC.setCollectStats(sema, true) === nothing
    @test CC.setCollectStats(sema) === nothing
    @test CC.setCollectStats(sema, false) === nothing

    CC.dispose(f)
    CC.dispose(I)
end
