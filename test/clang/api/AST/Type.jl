using ClangCompiler
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: clty_to_jlty, jlty_to_clty
using ClangCompiler: get_ast_context, get_codegen_module, convertTypeForMemory
using Test
import ClangCompiler as CC

CC.clty_to_jlty(x::CC.VoidTy) = Cvoid
CC.clty_to_jlty(x::CC.BoolTy) = Bool
CC.clty_to_jlty(x::CC.CharTy) = Cuchar
CC.clty_to_jlty(x::CC.WCharTy) = Cwchar_t
CC.clty_to_jlty(x::CC.WideCharTy) = Cwchar_t
CC.clty_to_jlty(x::CC.SignedCharTy) = Cchar
CC.clty_to_jlty(x::CC.ShortTy) = Cshort
CC.clty_to_jlty(x::CC.IntTy) = Cint
CC.clty_to_jlty(x::CC.LongTy) = Clong
CC.clty_to_jlty(x::CC.LongLongTy) = Clonglong
CC.clty_to_jlty(x::CC.Int128Ty) = Int128
CC.clty_to_jlty(x::CC.UnsignedCharTy) = Cuchar
CC.clty_to_jlty(x::CC.UnsignedShortTy) = Cushort
CC.clty_to_jlty(x::CC.UnsignedIntTy) = Cuint
CC.clty_to_jlty(x::CC.UnsignedLongTy) = Culong
CC.clty_to_jlty(x::CC.UnsignedLongLongTy) = Culonglong
CC.clty_to_jlty(x::CC.UnsignedInt128Ty) = UInt128
CC.clty_to_jlty(x::CC.FloatTy) = Cfloat
CC.clty_to_jlty(x::CC.DoubleTy) = Cdouble
CC.clty_to_jlty(x::CC.Float16Ty) = Float16
CC.clty_to_jlty(x::CC.HalfTy) = Float16
CC.clty_to_jlty(x::CC.BFloat16Ty) = Float16
CC.clty_to_jlty(x::CC.NullPtrTy) = Ptr{Cvoid}
CC.clty_to_jlty(x::CC.VoidPtrTy) = Ptr{Cvoid}
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
# Skiplist-drain tail (AST half): dyn_cast probes, ArrayRef views, decl
# factories, DeclContext pivots, and the process-global stats toggles.
# Assertions are host-portable: isa/Bool checks and round-trips of values
# set inside this file only.
const LX = CC.LibClangEx
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "qualifier and predicate exercise" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    const int ci = 0; volatile int vi = 0; int gx = 0; int *p; int &r = gx;
    int arr[3]; int fn5(double, char); typedef int myint; myint mi;
    enum E { A }; E ev; struct Rec { int m; }; Rec rc;
    """)
    f = CC.DeclFinder(I)
    tp(name) = (f(I, name); CC.getTypePtr(CC.getType(CC.VarDecl(CC.get_decl(f).ptr))))
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(CC.get_decl(f).ptr)))

    # QualType qualifiers
    @test CC.isConstQualified(qt("ci"))
    @test !CC.isVolatileQualified(qt("ci"))
    @test CC.isVolatileQualified(qt("vi"))
    @test CC.hasQualifiers(qt("ci"))
    @test !CC.hasQualifiers(qt("gx"))
    @test !CC.isNull(qt("gx"))

    # pointer / reference / array accessors
    pty = CC.resolve(tp("p"))
    @test pty isa CC.PointerType
    @test CC.is_pointer_type(tp("p"))
    @test CC.resolve(CC.getTypePtr(CC.getPointeeType(pty))) isa CC.BuiltinType
    @test CC.resolve(tp("r")) isa CC.LValueReferenceType
    @test CC.is_reference_type(tp("r"))
    aty = CC.resolve(tp("arr"))
    @test aty isa CC.ConstantArrayType
    @test CC.is_array_type(tp("arr"))
    @test CC.resolve(CC.getTypePtr(CC.getElementType(aty))) isa CC.BuiltinType

    # function type return
    f(I, "fn5")
    fty = CC.resolve(CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(CC.get_decl(f).ptr)))))
    @test fty isa CC.FunctionProtoType
    @test CC.resolve(CC.getTypePtr(CC.getReturnType(fty))) isa CC.BuiltinType

    # typedef sugar desugars; elaborated record/enum sugar unwraps to a concrete leaf
    @test CC.desugar(CC.resolve(tp("mi"))) isa CC.QualType
    @test CC.resolve(tp("rc")) isa CC.ElaboratedType
    @test CC.is_record_type(tp("rc"))
    @test CC.resolve(CC.getTypePtr(CC.getNamedType(CC.resolve(tp("ev"))))) isa CC.EnumType

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Type queries" begin
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

@testset "TemplateSpecializationType arguments" begin
    I = create_interpreter(String[])
    CC.parse(I, "template<typename T, int N> struct STempl { T x; }; STempl<int,3> stempl_obj;")
    f = DeclFinder(I)
    @test f(I, "stempl_obj")
    vd = CC.VarDecl(get_decl(f).ptr)
    ety = CC.resolve(CC.getTypePtr(CC.getType(vd)))
    tst = CC.resolve(CC.getTypePtr(CC.getNamedType(ety)))
    @test tst isa CC.TemplateSpecializationType
    @test CC.getNumArgs(tst) == 2
    @test CC.getArg(tst, 0) isa CC.TemplateArgument
    dispose(f)
    dispose(I)
end

@testset "FunctionProtoType accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fpt_probe(double a, char b) noexcept;")
    f = DeclFinder(I)
    @test f(I, "fpt_probe")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    ty = CC.resolve(CC.resolve(CC.getTypePtr(CC.getType(fd))))   # Type_ -> FunctionType -> FunctionProtoType
    @test ty isa CC.FunctionProtoType
    @test CC.getNumParams(ty) == 2
    @test CC.isVariadic(ty) == false
    @test CC.getNumExceptions(ty) == 0
    @test CC.isIntegerType(CC.getTypePtr(CC.getReturnType(ty)))
    @test CC.isRealFloatingType(CC.getTypePtr(CC.getParamType(ty, 0)))
    @test Integer(CC.getCallConv(ty)) == Integer(CC.LibClangEx.CXCallingConv_CC_C)
    @test CC.getExceptionSpecType(ty) == CC.LibClangEx.CXExceptionSpecificationType_EST_BasicNoexcept
    dispose(f)
    dispose(I)
end

using ClangCompiler: DeclFinder, get_decl, get_tag
@testset "coverage tail: type-api" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    int tapi_gx = 0;
    int *tapi_p = &tapi_gx;

    template <class T> struct TapiWrap { T val; };
    TapiWrap<int> tapi_w;

    template <class A, class B> struct TapiPair {};
    template <class... As> struct TapiHost3 {};
    template <typename... Ts> struct TapiPackOuter {
      template <typename... Us> using Zip = TapiHost3<TapiPair<Ts, Us>...>;
    };
    TapiPackOuter<int, long> tapi_po;

    template <class T> struct TapiS4 { typename T::template Inner<int> v; };
    template <class T> struct TapiS5 : T { using typename T::type; type m; };

    template <template <class> class... TT> struct TapiTTHost { int h; };
    template <template <class> class... UU> struct TapiTTUser { TapiTTHost<UU...> field; };

    template <class T> struct TapiCTAD { T t; TapiCTAD(T x) : t(x) {} };
    TapiCTAD tapi_ctad(1);

    template <int Ia> struct TapiDAS { typedef int __attribute__((address_space(Ia))) DASTy; };
    template <int Na> struct TapiDEV { typedef int __attribute__((ext_vector_type(Na))) EVTy; };
    """)

    f = DeclFinder(I)
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t
    vdecl(name) = (f(I, name); CC.VarDecl(get_decl(f).ptr))
    vqt(name) = CC.getType(vdecl(name))
    patt_of(name) = (f(I, name); CC.getTemplatedDecl(CC.resolve(get_decl(f))))

    # ---------------- Type::getPointeeType (generic) + isa_UnresolvedUsingType ----------------
    ptp = CC.getTypePtr(vqt("tapi_p"))
    @test ptp isa CC.Type_
    @test CC.getPointeeType(ptp) isa CC.QualType
    @test CC.isa_UnresolvedUsingType(ptp) isa Bool

    # ---------------- FunctionNoProtoType ----------------
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    fnp = CC.resolve(CC.getTypePtr(CC.getFunctionNoProtoType(ctx, int_qt)))
    fnp isa CC.FunctionNoProtoType || (fnp = CC.resolve(fnp))
    @test fnp isa CC.FunctionNoProtoType
    @test CC.desugar(fnp) isa CC.QualType
    @test CC.isSugared(fnp) isa Bool

    # ---------------- SubstTemplateTypeParmType (instantiated member of TapiWrap<int>) ----------------
    w_crt = CC.resolve(CC.getTypePtr(CC.getCanonicalType(vqt("tapi_w"))))
    @test w_crt isa CC.RecordType
    sttp = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(CC.getDecl(w_crt))))))
    @test sttp isa CC.SubstTemplateTypeParmType
    @test CC.getReplacementType(sttp) isa CC.QualType
    @test CC.desugar(sttp) isa CC.QualType
    @test CC.getAssociatedDecl(sttp) isa CC.Decl
    @test CC.getIndex(sttp) isa Integer
    @test CC.getReplacedParameter(sttp) isa CC.TemplateTypeParmDecl
    @test CC.isSugared(sttp) == true

    # ---------------- SubstTemplateTypeParmPackType (member alias template of TapiPackOuter<int,long>) ----------------
    # `Zip`'s underlying type in the specialization is TapiHost3<TapiPair<Ts, Us>...> with Ts
    # substituted but the expansion blocked by the unexpanded Us — the substituted `Ts` inside
    # the retained pack-expansion pattern is a SubstTemplateTypeParmPackType.
    po_crt = CC.resolve(CC.getTypePtr(CC.getCanonicalType(vqt("tapi_po"))))
    local zip_at = nothing
    for d in CC.decls(CC.castToDeclContext(CC.getDecl(po_crt)))
        d isa CC.TypeAliasTemplateDecl && CC.getName(d) == "Zip" && (zip_at = d)
    end
    @test zip_at isa CC.TypeAliasTemplateDecl
    zip_ad = CC.resolve(CC.getTemplatedDecl(zip_at))
    @test zip_ad isa CC.TypeAliasDecl
    host_tst = unwrap(CC.resolve(CC.getTypePtr(CC.getUnderlyingType(zip_ad))))
    @test host_tst isa CC.TemplateSpecializationType
    pk_arg = CC.getArg(host_tst, 0)
    @test CC.getKind(pk_arg) == CC.LibClangEx.CXTemplateArgument_Type
    packexp_qt = CC.getAsType(pk_arg)  # PackExpansionType (no carrier) — unwrap via its TypeLoc
    pk_tl = CC.getTypeLoc(CC.getTrivialTypeSourceInfo(ctx, packexp_qt, CC.getLocation(zip_ad)))
    pk_inner_tl = CC.getNextTypeLoc(pk_tl)
    @test !CC.isNull(pk_inner_tl)
    pair_tst = unwrap(CC.resolve(CC.getTypePtr(CC.getType(pk_inner_tl))))
    dispose(pk_inner_tl)
    dispose(pk_tl)
    @test pair_tst isa CC.TemplateSpecializationType
    pk = CC.resolve(CC.getTypePtr(CC.getAsType(CC.getArg(pair_tst, 0))))
    @test pk isa CC.SubstTemplateTypeParmPackType
    @test CC.desugar(pk) isa CC.QualType
    @test CC.getAssociatedDecl(pk) isa CC.Decl
    @test CC.getArgumentPack(pk) !== nothing
    @test CC.getFinal(pk) isa Bool
    @test CC.getIndex(pk) isa Integer
    @test CC.getNumArgs(pk) == 2
    @test CC.getReplacedParameter(pk) isa CC.TemplateTypeParmDecl
    @test CC.isSugared(pk) isa Bool

    # ---------------- DependentTemplateSpecializationType (pattern TapiS4 field v) ----------------
    dtst = unwrap(CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(patt_of("TapiS4")))))))
    @test dtst isa CC.DependentTemplateSpecializationType
    @test CC.desugar(dtst) isa CC.QualType
    @test CC.getIdentifier(dtst) isa CC.IdentifierInfo
    @test CC.getQualifier(dtst) isa CC.NestedNameSpecifier
    @test CC.isSugared(dtst) isa Bool

    # ---------------- UnresolvedUsingType (pattern TapiS5 field m) ----------------
    uut = unwrap(CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(patt_of("TapiS5")))))))
    @test uut isa CC.UnresolvedUsingType
    @test CC.desugar(uut) isa CC.QualType
    @test CC.getDecl(uut) isa CC.UnresolvedUsingTypenameDecl
    @test CC.isSugared(uut) isa Bool

    # ---------------- DeducedTemplateSpecializationType + DeducedType (CTAD variable) ----------------
    ctad_vd = vdecl("tapi_ctad")
    dts = unwrap(CC.resolve(CC.getTypePtr(CC.getType(ctad_vd))))
    if !(dts isa CC.DeducedTemplateSpecializationType)
        # the deduced sugar lives on the as-written type in the TypeSourceInfo
        ctl = CC.getTypeLoc(CC.getTypeSourceInfo(ctad_vd))
        dts = unwrap(CC.resolve(CC.getTypePtr(CC.getType(ctl))))
        dispose(ctl)
    end
    @test dts isa CC.DeducedTemplateSpecializationType
    @test CC.getTemplateName(dts) isa CC.TemplateName
    @test CC.desugar(dts) isa CC.QualType
    @test CC.getDeducedType(dts) isa CC.QualType
    @test CC.isDeduced(dts) isa Bool
    @test CC.isSugared(dts) isa Bool

    # ---------------- DependentAddressSpaceType (typedef DASTy in pattern TapiDAS) ----------------
    local das_td = nothing
    for d in CC.decls(CC.castToDeclContext(patt_of("TapiDAS")))
        d isa CC.TypedefDecl && CC.getName(d) == "DASTy" && (das_td = d)
    end
    @test das_td isa CC.TypedefDecl
    dast = CC.resolve(CC.getTypePtr(CC.getUnderlyingType(das_td)))
    @test dast isa CC.DependentAddressSpaceType
    @test CC.desugar(dast) isa CC.QualType
    @test CC.getAddrSpaceExpr(dast) isa CC.Expr_
    @test CC.getPointeeType(dast) isa CC.QualType
    @test CC.isSugared(dast) isa Bool

    # ---------------- DependentSizedExtVectorType (typedef EVTy in pattern TapiDEV) ----------------
    local dev_td = nothing
    for d in CC.decls(CC.castToDeclContext(patt_of("TapiDEV")))
        d isa CC.TypedefDecl && CC.getName(d) == "EVTy" && (dev_td = d)
    end
    @test dev_td isa CC.TypedefDecl
    devt = CC.resolve(CC.getTypePtr(CC.getUnderlyingType(dev_td)))
    @test devt isa CC.DependentSizedExtVectorType
    @test CC.desugar(devt) isa CC.QualType
    @test CC.getElementType(devt) isa CC.QualType
    @test CC.getSizeExpr(devt) isa CC.Expr_
    @test CC.isSugared(devt) isa Bool

    # ---------------- MacroQualifiedType (built via ASTContext with a borrowed IdentifierInfo) ----------------
    mqt = CC.resolve(CC.getTypePtr(CC.getMacroQualifiedType(ctx, int_qt, CC.getIdentifier(dtst))))
    @test mqt isa CC.MacroQualifiedType
    @test CC.desugar(mqt) isa CC.QualType
    @test CC.getMacroIdentifier(mqt) isa CC.IdentifierInfo
    @test CC.getModifiedType(mqt) isa CC.QualType
    @test CC.getUnderlyingType(mqt) isa CC.QualType
    @test CC.isSugared(mqt) isa Bool

    # ---------------- ParenType (built via ASTContext) ----------------
    pty = CC.resolve(CC.getTypePtr(CC.getParenType(ctx, int_qt)))
    @test pty isa CC.ParenType
    @test CC.desugar(pty) isa CC.QualType
    @test CC.getInnerType(pty) isa CC.QualType
    @test CC.isSugared(pty) isa Bool

    # ---------------- TemplateArgument::getNumTemplateExpansions (TT-pack expansion arg) ----------------
    ttst = unwrap(CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(patt_of("TapiTTUser")))))))
    @test ttst isa CC.TemplateSpecializationType
    ta = CC.getArg(ttst, 0)
    @test CC.getKind(ta) == CC.LibClangEx.CXTemplateArgument_TemplateExpansion
    # a `Ts...` expansion written without a fixed count has a disengaged
    # optional on the C++ side — the wrapper surfaces that as `nothing`
    nexp = CC.getNumTemplateExpansions(ta)
    @test nexp === nothing || nexp isa UInt32

    # ---------------- TypeLoc base + AbstractTypeLoc carriers ----------------
    gx_vd = vdecl("tapi_gx")
    tl = CC.getTypeLoc(CC.getTypeSourceInfo(gx_vd))
    @test CC.getEndLoc(tl) isa CC.SourceLocation
    @test CC.getLocalSourceRange(tl) isa CC.SourceRange
    btl = CC.BuiltinTypeLoc(tl)
    @test btl isa CC.BuiltinTypeLoc
    @test CC.getType(btl) isa CC.QualType
    @test CC.getBeginLoc(btl) isa CC.SourceLocation
    @test CC.getEndLoc(btl) isa CC.SourceLocation
    @test CC.getLocalSourceRange(btl) isa CC.SourceRange
    dispose(btl)
    dispose(tl)

    # ---------------- AdjustedTypeLoc (trivial TSI of a decayed array type) ----------------
    arr_qt = CC.getConstantArrayType(ctx, int_qt, 3)
    dec_qt = CC.getDecayedType(ctx, arr_qt)
    tsi2 = CC.getTrivialTypeSourceInfo(ctx, dec_qt, CC.getLocation(gx_vd))
    tl2 = CC.getTypeLoc(tsi2)
    atl = CC.AdjustedTypeLoc(tl2)
    @test atl isa CC.AdjustedTypeLoc
    orig = CC.getOriginalLoc(atl)
    @test orig isa CC.TypeLoc
    dispose(orig)
    dispose(atl)
    dispose(tl2)

    dispose(f)
    dispose(I)

    # ---------------- FunctionProtoType::getExceptionType (dynamic exception spec, C++14) ----------------
    I2 = create_interpreter(["-std=c++14"])
    CC.parse(I2, "int tapi_thr(int) throw(int);")
    f2 = DeclFinder(I2)
    @test f2(I2, "tapi_thr")
    ft2 = CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(get_decl(f2).ptr))))
    ft2 isa CC.FunctionProtoType || (ft2 = CC.resolve(ft2))
    @test ft2 isa CC.FunctionProtoType
    @test CC.getNumExceptions(ft2) == 1
    @test CC.getExceptionType(ft2, 0) isa CC.QualType
    dispose(f2)
    dispose(I2)
end

@testset "builtin QualType pivot constructors" begin
    I = create_interpreter(String[])
    ctx = get_ast_context(I)

    # `T(x::QualType)` pivots: rebuild each builtin singleton carrier from its
    # own canonical QualType (faithful by construction)
    n = 0
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        T = getproperty(CC, nm)
        (T isa DataType && T <: CC.AbstractBuiltinType) || continue
        hasmethod(T, Tuple{CC.ASTContext}) || continue
        which(T, Tuple{CC.ASTContext}).sig <: Tuple{Type,CC.ASTContext} || continue
        conc = T(ctx)
        conc.ptr == C_NULL && continue
        t2 = T(CC.get_qual_type(conc))
        @test t2 isa T
        @test t2.ptr != C_NULL
        n += 1
    end
    @test n >= 25
    @test CC.BuiltinType(CC.get_qual_type(CC.IntTy(ctx))) isa CC.BuiltinType

    dispose(I)
end

@testset "Coverage | Type" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    const int ci = 0;
    volatile int vi = 0;
    int gx = 0;
    int *p = &gx;
    int &r = gx;
    int &&rr = 5;
    int arr[3] = {1, 2, 3};
    extern int iarr[];
    double _Complex cd;
    _Atomic int ai;
    int fn5(double, char);
    void fnv(int, ...);
    void fnne() noexcept(true);
    typedef int myint;
    myint mi = 0;
    enum E { A, B };
    E ev = A;
    __underlying_type(E) ut = 0;
    namespace N { typedef int Tn; }
    using N::Tn;
    Tn uv = 0;
    struct Rec { int m; const int cm = 0; void meth(); };
    Rec rc;
    int Rec::*mp = &Rec::m;
    void (Rec::*mfp)() = &Rec::meth;
    int dv = 0;
    decltype(dv) dd = 0;
    void g(int a[10]);
    template <class T> struct STempl { T x; STempl *next; };
    STempl<int> si;
    template <class T> using AliasT = STempl<T>;
    AliasT<int> at2;
    template <int N> struct S2 { int a[N]; };
    template <class T> struct S3 { typename T::type v; };
    void vlafn(int n) { int vla[n]; (void)vla; }
    """)

    f = CC.DeclFinder(I)
    rvar(name) = (f(I, name); CC.resolve(get_decl(f)))
    qtof(name) = CC.getType(rvar(name))
    tpof(name) = CC.getTypePtr(qtof(name))
    rty(name) = CC.resolve(tpof(name))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t
    fpt_of(name) = (f(I, name); CC.resolve(CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(get_decl(f).ptr))))))

    # ---------------- QualType ----------------
    cq = qtof("ci")
    @test CC.getTypePtr(cq) isa CC.Type_
    @test CC.getTypePtrOrNull(cq) isa CC.Type_
    @test CC.isCanonical(cq) isa Bool
    @test CC.isNull(cq) isa Bool
    @test CC.isConstQualified(cq) isa Bool
    @test CC.isRestrictQualified(cq) isa Bool
    @test CC.isVolatileQualified(cq) isa Bool
    @test CC.hasQualifiers(cq) isa Bool
    @test CC.withConst(cq) isa CC.QualType
    @test CC.withRestrict(cq) isa CC.QualType
    @test CC.withVolatile(cq) isa CC.QualType
    @test CC.addConst(cq) isa CC.QualType
    @test CC.addRestrict(cq) isa CC.QualType
    @test CC.addVolatile(cq) isa CC.QualType
    @test CC.isLocalConstQualified(cq) isa Bool
    @test CC.isLocalRestrictQualified(cq) isa Bool
    @test CC.isLocalVolatileQualified(cq) isa Bool
    @test CC.hasLocalQualifiers(cq) isa Bool
    @test CC.getCVRQualifiers(cq) isa Integer
    @test CC.getAsString(cq) isa AbstractString
    @test (CC.dump(cq); true)
    @test CC.getCanonicalType(cq) isa CC.QualType
    @test CC.getLocalUnqualifiedType(cq) isa CC.QualType
    @test CC.getUnqualifiedType(cq) isa CC.QualType

    # ---------------- Type (predicate/accessor block on a plain Type_) ----------------
    ty = tpof("gx")
    preds = Function[CC.canDecayToPointerType, CC.hasAutoForTrailingReturnType,
        CC.hasFloatingRepresentation, CC.hasIntegerRepresentation, CC.hasObjCPointerRepresentation,
        CC.hasPointerRepresentation, CC.hasSignedIntegerRepresentation, CC.hasSizedVLAType,
        CC.hasUnnamedOrLocalType, CC.hasUnsignedIntegerRepresentation, CC.isAggregateType,
        CC.isAlignValT, CC.isAnyCharacterType, CC.isAnyComplexType, CC.isAnyPointerType,
        CC.isArithmeticType, CC.isAtomicType, CC.isBFloat16Type, CC.isBlockPointerType,
        CC.isCanonicalUnqualified, CC.isChar16Type, CC.isChar32Type, CC.isChar8Type,
        CC.isClassType, CC.isComplexIntegerType, CC.isCompoundType, CC.isConstantMatrixType,
        CC.isConstantSizeType, CC.isDecltypeType, CC.isDependentAddressSpaceType,
        CC.isDependentType, CC.isElaboratedTypeSpecifier, CC.isExtVectorType,
        CC.isFixedPointOrIntegerType, CC.isFixedPointType, CC.isFloat128Type, CC.isFloat16Type,
        CC.isFloatingType, CC.isFromAST, CC.isFunctionReferenceType, CC.isFundamentalType,
        CC.isHalfType, CC.isInstantiationDependentType, CC.isIntegerType,
        CC.isIntegralOrEnumerationType, CC.isIntegralOrUnscopedEnumerationType,
        CC.isInterfaceType, CC.isLinkageValid, CC.isMatrixType, CC.isMemberDataPointerType,
        CC.isNothrowT, CC.isNullPtrType, CC.isObjCBoxableRecordType, CC.isObjectPointerType,
        CC.isOverloadableType, CC.isRealFloatingType, CC.isRealType, CC.isSaturatedFixedPointType,
        CC.isScalarType, CC.isScopedEnumeralType, CC.isSignedFixedPointType,
        CC.isSignedIntegerOrEnumerationType, CC.isSignedIntegerType, CC.isSizelessBuiltinType,
        CC.isSizelessType, CC.isSpecifierType, CC.isStdByteType, CC.isStructureOrClassType,
        CC.isStructureType, CC.isTypedefNameType, CC.isUndeducedAutoType, CC.isUndeducedType,
        CC.isUnionType, CC.isUnsaturatedFixedPointType, CC.isUnscopedEnumerationType,
        CC.isUnsignedFixedPointType, CC.isUnsignedIntegerOrEnumerationType,
        CC.isUnsignedIntegerType, CC.isVariablyModifiedType, CC.isVectorType,
        CC.isVisibilityExplicit, CC.isVoidPointerType, CC.isWideCharType, CC.isVoidType,
        CC.isBooleanType, CC.isPointerType, CC.isFunctionPointerType, CC.isFunctionType,
        CC.isMemberFunctionPointerType, CC.isReferenceType, CC.isCharType, CC.isEnumeralType,
        CC.isBuiltinType, CC.isComplexType, CC.isArrayType, CC.isLValueReferenceType,
        CC.isRValueReferenceType, CC.isMemberPointerType, CC.isConstantArrayType,
        CC.isIncompleteArrayType, CC.isVariableArrayType, CC.isDependentSizedArrayType,
        CC.isFunctionNoProtoType, CC.isFunctionProtoType, CC.isRecordType,
        CC.isTemplateTypeParmType, CC.isa_TypedefType, CC.isa_TagType, CC.isa_EnumType,
        CC.isa_SubstTemplateTypeParmType, CC.isa_SubstTemplateTypeParmPackType,
        CC.isa_TemplateSpecializationType, CC.isa_ElaboratedType, CC.isa_DependentNameType,
        CC.isa_DependentTemplateSpecializationType, CC.isa_UsingType, CC.isa_AtomicType,
        CC.isa_AdjustedType, CC.isa_DecayedType, CC.isa_InjectedClassNameType,
        CC.isa_MacroQualifiedType, CC.isa_UnaryTransformType, CC.isa_ParenType,
        CC.isa_DependentAddressSpaceType, CC.isa_DependentSizedExtVectorType,
        CC.isa_DecltypeType, CC.isa_DeducedType, CC.isa_DeducedTemplateSpecializationType]
    for fn in preds
        @test fn(ty) isa Bool
    end

    @test CC.getTypeClass(ty) !== nothing
    @test CC.getCanonicalTypeInternal(ty) isa CC.QualType
    @test CC.getArrayElementTypeNoTypeQual(ty) isa CC.Type_
    @test CC.getPointeeOrArrayElementType(ty) isa CC.Type_
    @test CC.getUnqualifiedDesugaredType(ty) isa CC.Type_
    @test (CC.dump(ty); true)
    # getAs* accessors return their target carrier (possibly NULL-backed) — call on a record type
    recty = unwrap(rty("rc"))
    @test CC.getAsCXXRecordDecl(recty) isa CC.CXXRecordDecl
    @test CC.getAsComplexIntegerType(ty) isa CC.ComplexType
    @test CC.getAsRecordDecl(recty) isa CC.RecordDecl
    @test CC.getAsStructureType(recty) isa CC.RecordType
    @test CC.getAsTagDecl(recty) isa CC.TagDecl
    @test CC.getAsUnionType(ty) isa CC.RecordType
    @test CC.getPointeeCXXRecordDecl(rty("p")) isa CC.CXXRecordDecl

    # ---------------- BuiltinType isa_* ----------------
    bt = rty("gx")
    @test bt isa CC.BuiltinType
    bpreds = Function[CC.isa_BuiltinType_Void, CC.isa_BuiltinType_Bool, CC.isa_BuiltinType_Char_U,
        CC.isa_BuiltinType_Char_S, CC.isa_BuiltinType_WChar_U, CC.isa_BuiltinType_WChar_S,
        CC.isa_BuiltinType_Char8, CC.isa_BuiltinType_Char16, CC.isa_BuiltinType_Char32,
        CC.isa_BuiltinType_SChar, CC.isa_BuiltinType_Short, CC.isa_BuiltinType_Int,
        CC.isa_BuiltinType_Long, CC.isa_BuiltinType_LongLong, CC.isa_BuiltinType_Int128,
        CC.isa_BuiltinType_UChar, CC.isa_BuiltinType_UShort, CC.isa_BuiltinType_UInt,
        CC.isa_BuiltinType_ULong, CC.isa_BuiltinType_ULongLong, CC.isa_BuiltinType_UInt128,
        CC.isa_BuiltinType_Float, CC.isa_BuiltinType_Double, CC.isa_BuiltinType_LongDouble,
        CC.isa_BuiltinType_Float128, CC.isa_BuiltinType_Half, CC.isa_BuiltinType_BFloat16,
        CC.isa_BuiltinType_Float16, CC.isa_BuiltinType_NullPtr]
    for fn in bpreds
        @test fn(bt) isa Bool
    end

    # ---------------- ComplexType ----------------
    cty = rty("cd")
    @test cty isa CC.ComplexType
    @test CC.desugar(cty) isa CC.QualType
    @test CC.getElementType(cty) isa CC.QualType
    @test CC.isSugared(cty) isa Bool

    # ---------------- PointerType ----------------
    pty = rty("p")
    @test pty isa CC.PointerType
    @test CC.getPointeeType(pty) isa CC.QualType
    @test CC.desugar(pty) isa CC.QualType
    @test CC.isSugared(pty) isa Bool

    # ---------------- ReferenceType / LValue / RValue ----------------
    lref = rty("r")
    @test lref isa CC.LValueReferenceType
    @test CC.getPointeeType(lref) isa CC.QualType
    @test CC.getPointeeTypeAsWritten(lref) isa CC.QualType
    @test CC.isInnerRef(lref) isa Bool
    @test CC.isSpelledAsLValue(lref) isa Bool
    @test CC.desugar(lref) isa CC.QualType
    @test CC.isSugared(lref) isa Bool
    rref = rty("rr")
    @test rref isa CC.RValueReferenceType
    @test CC.getPointeeType(rref) isa CC.QualType
    @test CC.desugar(rref) isa CC.QualType
    @test CC.isSugared(rref) isa Bool

    # ---------------- MemberPointerType ----------------
    mpt = rty("mp")
    @test mpt isa CC.MemberPointerType
    @test CC.getPointeeType(mpt) isa CC.QualType
    @test CC.getClass(mpt) isa CC.Type_
    @test CC.desugar(mpt) isa CC.QualType
    @test CC.getMostRecentCXXRecordDecl(mpt) isa CC.CXXRecordDecl
    @test CC.isMemberDataPointer(mpt) isa Bool
    @test CC.isSugared(mpt) isa Bool
    mfpt = rty("mfp")
    @test CC.isMemberFunctionPointer(mfpt) isa Bool

    # ---------------- ArrayType + ConstantArrayType ----------------
    aty = rty("arr")
    @test aty isa CC.ConstantArrayType
    @test CC.getElementType(aty) isa CC.QualType
    @test CC.getIndexTypeCVRQualifiers(aty) isa Integer
    @test CC.getSizeModifier(aty) !== nothing
    @test CC.desugar(aty) isa CC.QualType
    @test CC.getSizeExpr(aty) isa CC.Expr_
    @test CC.isSugared(aty) isa Bool

    # ---------------- IncompleteArrayType ----------------
    ity = rty("iarr")
    @test ity isa CC.IncompleteArrayType
    @test CC.desugar(ity) isa CC.QualType
    @test CC.isSugared(ity) isa Bool

    # ---------------- VariableArrayType (VLA in a function body) ----------------
    f(I, "vlafn")
    vlabody = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f).ptr)))
    local vaty = nothing
    for n in CC.subtree(vlabody)
        if n isa CC.DeclStmt
            for d in CC.getDecls(n)
                rd = CC.resolve(d)
                if rd isa CC.VarDecl
                    t = CC.resolve(CC.getTypePtr(CC.getType(rd)))
                    t isa CC.VariableArrayType && (vaty = t)
                end
            end
        end
    end
    @test vaty isa CC.VariableArrayType
    @test CC.desugar(vaty) isa CC.QualType
    @test CC.getSizeExpr(vaty) isa CC.Expr_
    @test CC.isSugared(vaty) isa Bool

    # ---------------- FunctionType + FunctionProtoType ----------------
    fpt = fpt_of("fn5")
    @test fpt isa CC.FunctionProtoType
    @test CC.getReturnType(fpt) isa CC.QualType
    @test CC.getCallConv(fpt) !== nothing
    @test CC.getCmseNSCallAttr(fpt) isa Bool
    @test CC.getHasRegParm(fpt) isa Bool
    @test CC.getNoReturnAttr(fpt) isa Bool
    @test CC.getRegParmType(fpt) isa Integer
    @test CC.isConst(fpt) isa Bool
    @test CC.isRestrict(fpt) isa Bool
    @test CC.isVolatile(fpt) isa Bool
    @test CC.getNumParams(fpt) == 2
    @test CC.getParamType(fpt, 0) isa CC.QualType
    @test CC.isNoThrow(fpt) isa Bool
    @test CC.desugar(fpt) isa CC.QualType
    @test CC.getExceptionSpecDecl(fpt) isa CC.FunctionDecl
    @test CC.getExceptionSpecTemplate(fpt) isa CC.FunctionDecl
    @test CC.getNumExceptions(fpt) isa Integer
    @test CC.getExceptionSpecType(fpt) !== nothing
    @test CC.hasDependentExceptionSpec(fpt) isa Bool
    @test CC.hasDynamicExceptionSpec(fpt) isa Bool
    @test CC.hasExceptionSpec(fpt) isa Bool
    @test CC.hasInstantiationDependentExceptionSpec(fpt) isa Bool
    @test CC.hasNoexceptExceptionSpec(fpt) isa Bool
    @test CC.hasTrailingReturn(fpt) isa Bool
    @test CC.isSugared(fpt) isa Bool
    @test CC.isTemplateVariadic(fpt) isa Bool
    @test CC.isVariadic(fpt) isa Bool
    if CC.getNumExceptions(fpt) > 0
        @test CC.getExceptionType(fpt, 0) isa CC.QualType
    end
    # a noexcept(expr) function reaches getNoexceptExpr
    fptne = fpt_of("fnne")
    @test CC.getNoexceptExpr(fptne) isa CC.Expr_
    # a variadic function makes isVariadic true
    @test CC.isVariadic(fpt_of("fnv")) == true

    # ---------------- DecayedType / AdjustedType (decayed function parameter) ----------------
    f(I, "g")
    gparm = CC.getParamDecl(CC.FunctionDecl(get_decl(f).ptr), 0)
    dty = CC.resolve(CC.getTypePtr(CC.getType(gparm)))
    @test dty isa CC.DecayedType
    @test CC.getDecayedType(dty) isa CC.QualType
    @test CC.getPointeeType(dty) isa CC.QualType
    @test CC.desugar(dty) isa CC.QualType
    @test CC.getAdjustedType(dty) isa CC.QualType
    @test CC.getOriginalType(dty) isa CC.QualType
    @test CC.isSugared(dty) isa Bool

    # ---------------- DecltypeType ----------------
    dcty = rty("dd")
    @test dcty isa CC.DecltypeType
    @test CC.desugar(dcty) isa CC.QualType
    @test CC.getUnderlyingExpr(dcty) isa CC.Expr_
    @test CC.getUnderlyingType(dcty) isa CC.QualType
    @test CC.isSugared(dcty) isa Bool

    # ---------------- AtomicType ----------------
    atty = rty("ai")
    @test atty isa CC.AtomicType
    @test CC.desugar(atty) isa CC.QualType
    @test CC.getValueType(atty) isa CC.QualType
    @test CC.isSugared(atty) isa Bool

    # ---------------- UnaryTransformType ----------------
    utty = rty("ut")
    @test utty isa CC.UnaryTransformType
    @test CC.desugar(utty) isa CC.QualType
    @test CC.getBaseType(utty) isa CC.QualType
    @test CC.getUnderlyingType(utty) isa CC.QualType
    @test CC.isSugared(utty) isa Bool

    # ---------------- UsingType ----------------
    usty = unwrap(rty("uv"))
    @test usty isa CC.UsingType
    @test CC.desugar(usty) isa CC.QualType
    @test CC.getFoundDecl(usty) isa CC.UsingShadowDecl
    @test CC.getUnderlyingType(usty) isa CC.QualType
    @test CC.isSugared(usty) isa Bool

    # ---------------- TypedefType ----------------
    tdty = unwrap(rty("mi"))
    @test tdty isa CC.TypedefType
    @test CC.desugar(tdty) isa CC.QualType
    @test CC.getDecl(tdty) isa CC.TypedefNameDecl
    @test CC.isSugared(tdty) isa Bool

    # ---------------- ElaboratedType (sugar wrapper around record/enum/typedef) ----------------
    elab = rty("rc")
    @test elab isa CC.ElaboratedType
    @test CC.desugar(elab) isa CC.QualType
    @test CC.getNamedType(elab) isa CC.QualType
    @test CC.getOwnedTagDecl(elab) isa CC.TagDecl
    @test CC.getQualifier(elab) isa CC.NestedNameSpecifier
    @test CC.isSugared(elab) isa Bool

    # ---------------- RecordType + TagType ----------------
    rrt = unwrap(rty("rc"))
    @test rrt isa CC.RecordType
    @test CC.getDecl(rrt) isa CC.RecordDecl
    @test CC.desugar(rrt) isa CC.QualType
    @test CC.hasConstFields(rrt) isa Bool
    @test CC.isSugared(rrt) isa Bool
    @test CC.getDecl(CC.TagType(rrt.ptr)) isa CC.TagDecl

    # ---------------- EnumType ----------------
    ety = unwrap(rty("ev"))
    @test ety isa CC.EnumType
    @test CC.getDecl(ety) isa CC.EnumDecl
    @test CC.getIntegerType(ety) isa CC.QualType
    @test CC.getName(ety) isa AbstractString
    @test CC.desugar(ety) isa CC.QualType
    @test CC.isSugared(ety) isa Bool

    # ---------------- TemplateSpecializationType ----------------
    tst = unwrap(rty("si"))
    @test tst isa CC.TemplateSpecializationType
    @test CC.isCurrentInstantiation(tst) isa Bool
    @test CC.isTypeAlias(tst) isa Bool
    @test CC.getTemplateArguments(tst) !== nothing
    @test CC.getNumArgs(tst) >= 1
    @test CC.getArg(tst, 0) isa CC.TemplateArgument
    @test CC.isSugared(tst) isa Bool
    @test CC.desugar(tst) isa CC.QualType
    # an alias-template specialization exercises getAliasedType
    tsta = unwrap(rty("at2"))
    if tsta isa CC.TemplateSpecializationType && CC.isTypeAlias(tsta)
        @test CC.getAliasedType(tsta) isa CC.QualType
    end

    # ---------------- template-pattern-only carriers ----------------
    f(I, "STempl")
    patt = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    local ttpt = nothing
    local injt = nothing
    for fld in CC.getFields(patt)
        ft = CC.resolve(CC.getTypePtr(CC.getType(fld)))
        ft isa CC.TemplateTypeParmType && (ttpt = ft)
        if ft isa CC.PointerType
            pn = unwrap(CC.resolve(CC.getTypePtr(CC.getPointeeType(ft))))
            pn isa CC.InjectedClassNameType && (injt = pn)
        end
    end

    # TemplateTypeParmType
    @test ttpt isa CC.TemplateTypeParmType
    @test CC.desugar(ttpt) isa CC.QualType
    @test CC.getDecl(ttpt) isa CC.TemplateTypeParmDecl
    @test CC.getDepth(ttpt) isa Integer
    @test CC.getIndex(ttpt) isa Integer
    @test CC.isParameterPack(ttpt) isa Bool
    @test CC.isSugared(ttpt) isa Bool

    # InjectedClassNameType
    @test injt isa CC.InjectedClassNameType
    @test CC.desugar(injt) isa CC.QualType
    @test CC.getDecl(injt) isa CC.CXXRecordDecl
    @test CC.getInjectedSpecializationType(injt) isa CC.QualType
    @test CC.getInjectedTST(injt) isa CC.TemplateSpecializationType
    @test CC.getTemplateName(injt) isa CC.TemplateName
    @test CC.isSugared(injt) isa Bool

    # DependentSizedArrayType (template pattern S2 field a)
    f(I, "S2")
    p2 = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dsaty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(p2)))))
    @test dsaty isa CC.DependentSizedArrayType
    @test CC.desugar(dsaty) isa CC.QualType
    @test CC.getSizeExpr(dsaty) isa CC.Expr_
    @test CC.isSugared(dsaty) isa Bool
    @test CC.getElementType(dsaty) isa CC.QualType

    # DependentNameType (template pattern S3 field v)
    f(I, "S3")
    p3 = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dnty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(p3)))))
    @test dnty isa CC.DependentNameType
    @test CC.desugar(dnty) isa CC.QualType
    @test CC.getIdentifier(dnty) isa CC.IdentifierInfo
    @test CC.getQualifier(dnty) isa CC.NestedNameSpecifier
    @test CC.isSugared(dnty) isa Bool

    CC.dispose(f)
    CC.dispose(I)
end
