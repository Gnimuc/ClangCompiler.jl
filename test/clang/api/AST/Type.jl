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

@testset "QualType qualifier and classification tail" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    struct QtPod { int a; double b; };
    struct QtNonPod { QtNonPod(); ~QtNonPod(); int a; };
    typedef int qt_alias;
    QtPod qt_pod_v;
    QtNonPod qt_nonpod_v;
    qt_alias qt_alias_v;
    int qt_plain = 1;
    const int qt_const = 2;
    int &qt_ref = qt_plain;
    """)
    f = DeclFinder(I)
    qtof(name) = (@assert f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))

    plain = qtof("qt_plain")
    cqual = qtof("qt_const")

    # qualifier encodings: the full Qualifiers set vs the CVR-only subset
    @test CC.getQualifiersAsOpaqueValue(cqual) isa Unsigned
    @test CC.getQualifiersAsOpaqueValue(cqual) != CC.getQualifiersAsOpaqueValue(plain)
    @test CC.getLocalFastQualifiers(cqual) isa Unsigned
    @test CC.hasAddressSpace(plain) == false
    @test CC.getAddressSpace(plain) == CC.LibClangEx.CXLangAS_Default

    # qualifier ordering
    @test CC.isMoreQualifiedThan(cqual, plain)
    @test !CC.isMoreQualifiedThan(plain, cqual)
    @test CC.isAtLeastAsQualifiedAs(cqual, plain)
    @test CC.isAtLeastAsQualifiedAs(plain, plain)

    # reference stripping / paren stripping are identities on a plain int
    @test CC.getNonReferenceType(qtof("qt_ref")).ptr == plain.ptr
    @test CC.IgnoreParens(plain).ptr == plain.ptr

    # sugar removal through a typedef: one step peels the elaborated layer and
    # leaves the typedef, a second reaches the builtin; getDesugaredType goes
    # all the way in one call
    alias = qtof("qt_alias_v")
    step1 = CC.getSingleStepDesugaredType(alias, ctx)
    @test CC.get_name(CC.getSingleStepDesugaredType(step1, ctx)) == "int"
    @test CC.get_name(CC.getDesugaredType(alias, ctx)) == "int"
    @test CC.get_name(CC.getDesugaredType(plain, ctx)) == "int"

    # POD / trivial classification
    pod = qtof("qt_pod_v")
    nonpod = qtof("qt_nonpod_v")
    @test CC.isPODType(pod, ctx) == true
    @test CC.isPODType(nonpod, ctx) == false
    @test CC.isCXX98PODType(pod, ctx) isa Bool
    @test CC.isCXX11PODType(pod, ctx) isa Bool
    @test CC.isTrivialType(pod, ctx) == true
    @test CC.isTrivialType(nonpod, ctx) == false
    @test CC.isTriviallyCopyableType(pod, ctx) == true
    @test CC.isTriviallyCopyConstructibleType(pod, ctx) isa Bool
    @test CC.isTriviallyRelocatableType(pod, ctx) isa Bool
    @test CC.isConstant(cqual, ctx) isa Bool

    # destruction kind: none for a POD, a C++ destructor for the non-POD
    @test CC.isDestructedType(pod) == CC.LibClangEx.CXDestructionKind_DK_none
    @test CC.isDestructedType(nonpod) ==
          CC.LibClangEx.CXDestructionKind_DK_cxx_destructor

    dispose(f)
    dispose(I)
end

@testset "Type core queries" begin
    I = CC.create_interpreter()
    ctx = CC.get_ast_context(I)

    intty = CC.get_builtin_type(ctx, CC.IntTy)
    voidty = CC.get_builtin_type(ctx, CC.VoidTy)
    boolty = CC.get_builtin_type(ctx, CC.BoolTy)
    fltty = CC.get_builtin_type(ctx, CC.FloatTy)

    # object / completeness classification
    @test CC.isObjectType(intty)
    @test !CC.isObjectType(voidty)
    @test CC.isIncompleteOrObjectType(intty)
    @test CC.isIncompleteType(voidty)
    @test !CC.isIncompleteType(intty)
    @test CC.get_definition_if_incomplete(intty) === nothing

    # the ASTContext-taking predicate
    @test CC.isIntegralType(intty, ctx)
    @test !CC.isIntegralType(voidty, ctx)

    # dependence bits
    @test !CC.containsErrors(intty)
    @test !CC.containsUnexpandedParameterPack(intty)

    # builtin / placeholder queries
    @test !CC.isBitIntType(intty)
    @test !CC.isPlaceholderType(intty)
    @test CC.getAsPlaceholderType(intty).ptr == C_NULL

    # scalar classification (precondition: isScalarType)
    @test CC.getScalarTypeKind(intty) == CC.LibClangEx.CXScalarTypeKind_STK_Integral
    @test CC.getScalarTypeKind(boolty) == CC.LibClangEx.CXScalarTypeKind_STK_Bool
    @test CC.getScalarTypeKind(fltty) == CC.LibClangEx.CXScalarTypeKind_STK_Floating

    # navigation helpers -- a non-array type is its own base element type
    @test CC.getBaseElementTypeUnsafe(intty).ptr == intty.ptr
    @test CC.getAsArrayTypeUnsafe(intty).ptr == C_NULL
    @test CC.getLocallyUnqualifiedSingleStepDesugaredType(intty) isa CC.QualType

    name = CC.getTypeClassName(intty)
    @test name isa AbstractString
    @test !isempty(name)

    CC.dispose(I)
end

@testset "type-sub accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int tsub_arr[7];
    int tsub_fn(double, char);
    struct TsubRec { int m; };
    TsubRec tsub_rec;
    typedef int tsub_v4i __attribute__((vector_size(16)));
    tsub_v4i tsub_vec;
    int *_Nonnull tsub_nn = nullptr;
    auto tsub_auto = 3;
    void tsub_vla(int n) { int v[n]; (void)v; }
    template <int N> struct TsubS2 { int a[N]; };
    template <class... Ts> struct TsubHold { void tsub_mf(Ts... zs); };
    """)
    f = DeclFinder(I)
    rvar(name) = (f(I, name); CC.resolve(get_decl(f)))
    rty(name) = CC.resolve(CC.getTypePtr(CC.getType(rvar(name))))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t

    # ConstantArrayType::getSize -> caller-owned LLVMGenericValueRef (MARSHALLING.md §1)
    aty = rty("tsub_arr")
    @test aty isa CC.ConstantArrayType
    gv = CC.getSize(aty)
    @test gv != C_NULL
    @test LLVM.API.LLVMGenericValueToInt(gv, false) == 7
    LLVM.API.LLVMDisposeGenericValue(gv)

    # TagType::isBeingDefined — false for a complete record
    rec = unwrap(rty("tsub_rec"))
    @test rec isa CC.RecordType
    @test CC.isBeingDefined(rec) == false

    # FunctionProtoType: unqualified free function, no consumed parameters.
    # The out-of-range index exercises the restated clang assert (Invariant 3).
    fpt = CC.resolve(CC.getTypePtr(CC.getType(rvar("tsub_fn"))))
    @test fpt isa CC.FunctionProtoType
    @test CC.getMethodQuals(fpt) == 0
    @test CC.isParamConsumed(fpt, 0) == false
    @test CC.isParamConsumed(fpt, 1) == false
    @test_throws AssertionError CC.isParamConsumed(fpt, 2)

    # VectorType through the typedef's underlying type
    vsug = unwrap(rty("tsub_vec"))
    vt = vsug isa CC.TypedefType ? CC.resolve(CC.getTypePtr(CC.desugar(vsug))) : vsug
    if vt isa CC.VectorType
        @test CC.getNumElements(vt) == 4
        @test CC.resolve(CC.getTypePtr(CC.getElementType(vt))) isa CC.BuiltinType
        @test CC.isSugared(vt) == false
        @test CC.getTypePtr(CC.desugar(vt)) isa CC.Type_
    end

    # AttributedType: the _Nonnull nullability attribute wraps `int *`
    nn = rty("tsub_nn")
    if nn isa CC.AttributedType
        @test CC.isSugared(nn) == true
        @test CC.resolve(CC.getTypePtr(CC.getModifiedType(nn))) isa CC.PointerType
        @test CC.resolve(CC.getTypePtr(CC.getEquivalentType(nn))) isa CC.PointerType
        @test CC.desugar(nn).ptr == CC.getEquivalentType(nn).ptr
    end

    # AutoType: plain deduced `auto`, unconstrained
    aut = rty("tsub_auto")
    if aut isa CC.AutoType
        @test CC.isConstrained(aut) == false
        @test CC.isDecltypeAuto(aut) == false
        @test CC.isGNUAutoType(aut) == false
        @test CC.getTypeConstraintConcept(aut) isa CC.ConceptDecl
        @test CC.isDeduced(aut) == true          # inherited AbstractDeducedType method
    end

    # VariableArrayType::getBracketsRange (VLA declared in a function body)
    f(I, "tsub_vla")
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
    @test CC.getBracketsRange(vaty) isa CC.SourceRange

    # DependentSizedArrayType::getBracketsRange (template pattern field)
    f(I, "TsubS2")
    p2 = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dsaty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(p2)))))
    @test dsaty isa CC.DependentSizedArrayType
    @test CC.getBracketsRange(dsaty) isa CC.SourceRange

    # PackExpansionType: the parameter type `Ts... zs` of the member function
    f(I, "TsubHold")
    hdc = CC.castToDeclContext(CC.getTemplatedDecl(CC.resolve(get_decl(f))))
    local pet = nothing
    for d in CC.decls(hdc)
        d isa CC.CXXMethodDecl || continue
        fd = CC.FunctionDecl(d.ptr)
        CC.getNumParams(fd) > 0 || continue
        t = CC.resolve(CC.getTypePtr(CC.getType(CC.getParamDecl(fd, 0))))
        t isa CC.PackExpansionType && (pet = t)
    end
    @test pet isa CC.PackExpansionType
    if pet isa CC.PackExpansionType
        @test CC.resolve(CC.getTypePtr(CC.getPattern(pet))) isa CC.TemplateTypeParmType
        @test CC.getNumExpansions(pet) === nothing
    end

    dispose(I)
end

@testset "Qualifiers encoding and the QualType qualifier tail" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    const int qtl_ci = 0;
    volatile int qtl_vi = 0;
    int qtl_gx = 0;
    struct QtlPlain { int m; };
    struct QtlPoly { int m; virtual void qtl_vf() {} };
    struct QtlIncomplete;
    QtlPlain qtl_plain;
    QtlPoly qtl_poly;
    QtlPoly *qtl_pp_poly;
    QtlPlain *qtl_pp_plain;
    QtlIncomplete *qtl_pp_inc;
    QtlPoly &qtl_rr_poly = *qtl_pp_poly;
    """)
    f = CC.DeclFinder(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(CC.get_decl(f).ptr)))

    # Qualifiers has no carrier struct: it crosses as its opaque unsigned
    # encoding, so every wrapper below dispatches on Integer.
    q0 = CC.fromCVRMask(0)
    @test q0 isa Integer
    @test CC.empty(q0)
    @test !CC.hasConst(q0)
    @test !CC.hasVolatile(q0)
    @test !CC.hasRestrict(q0)
    @test CC.getCVRQualifiers(q0) == 0
    @test isempty(CC.getAsString(q0))
    @test_throws AssertionError CC.fromCVRMask(8)

    qc = CC.withConst(q0)
    qv = CC.withVolatile(q0)
    qr = CC.withRestrict(q0)
    @test CC.hasConst(qc)
    @test !CC.empty(qc)
    @test CC.hasVolatile(qv)
    @test CC.hasRestrict(qr)
    @test occursin("const", CC.getAsString(qc))

    qcv = CC.withVolatile(qc)
    @test CC.hasConst(qcv) && CC.hasVolatile(qcv)
    @test CC.fromCVRMask(CC.getCVRQualifiers(qcv)) == qcv
    @test CC.compatiblyIncludes(qcv, qc)
    @test !CC.compatiblyIncludes(qc, qcv)
    @test CC.isStrictSupersetOf(qcv, qc)
    @test !CC.isStrictSupersetOf(qc, qcv)
    @test !CC.hasAddressSpace(qcv)
    @test CC.getAddressSpace(q0) == CC.LibClangEx.CXLangAS_Default

    # QualType -> the same Qualifiers encoding, then the classification tail.
    @test CC.getLocalQualifiers(qt("qtl_ci")) == CC.getQualifiersAsOpaqueValue(qt("qtl_ci"))
    @test CC.hasConst(CC.getLocalQualifiers(qt("qtl_ci")))
    @test CC.hasVolatile(CC.getLocalQualifiers(qt("qtl_vi")))
    @test CC.empty(CC.getLocalQualifiers(qt("qtl_gx")))

    @test CC.isReferenceable(qt("qtl_gx"))
    @test CC.getAtomicUnqualifiedType(qt("qtl_ci")) isa CC.QualType
    @test !CC.hasQualifiers(CC.getAtomicUnqualifiedType(qt("qtl_ci")))

    id = CC.getBaseTypeIdentifier(qt("qtl_plain"))
    @test id isa CC.IdentifierInfo
    @test CC.getName(id) == "QtlPlain"

    # Both reach the POINTEE class, so a class type named directly answers
    # false/true no matter how it is defined; only a pointer or reference sees
    # the class. An incomplete pointee answers true both ways.
    @test !CC.mayBeDynamicClass(qt("qtl_poly"))
    @test CC.mayBeNotDynamicClass(qt("qtl_poly"))

    @test CC.mayBeDynamicClass(qt("qtl_pp_poly"))
    @test !CC.mayBeNotDynamicClass(qt("qtl_pp_poly"))
    @test CC.mayBeDynamicClass(qt("qtl_rr_poly"))
    @test !CC.mayBeNotDynamicClass(qt("qtl_rr_poly"))

    @test !CC.mayBeDynamicClass(qt("qtl_pp_plain"))
    @test CC.mayBeNotDynamicClass(qt("qtl_pp_plain"))
    @test !CC.mayBeDynamicClass(qt("qtl_gx"))
    @test CC.mayBeNotDynamicClass(qt("qtl_gx"))

    @test CC.mayBeDynamicClass(qt("qtl_pp_inc"))
    @test CC.mayBeNotDynamicClass(qt("qtl_pp_inc"))

    dispose(I)
end

@testset "Type/QualType/Qualifiers -- literal, layout and fast-qualifier tail" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    struct WL9Pod { int a; double b; };
    struct WL9Mixed { public: int a; private: int b; };
    struct WL9NonLit { ~WL9NonLit() {} int a; };
    const int wl9ci = 0;
    int wl9i = 0;
    int wl9i2 = 1;
    double wl9d = 0.0;
    WL9Pod wl9pod;
    WL9Mixed wl9mixed;
    WL9NonLit wl9nonlit;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))
    tp(name) = CC.getTypePtr(qt(name))

    # Qualifiers: the fast/non-fast split, round-tripped through the opaque encoding.
    @test CC.fromFastMask(0x7) == CC.fromCVRMask(0x7)
    @test CC.getFastQualifiers(CC.fromFastMask(0x5)) == 0x5
    @test CC.hasFastQualifiers(CC.fromFastMask(0x1))
    @test !CC.hasFastQualifiers(CC.fromFastMask(0x0))
    @test !CC.hasNonFastQualifiers(CC.fromFastMask(0x7))
    @test CC.getNonFastQualifiers(CC.fromFastMask(0x7)) == 0x0
    @test_throws AssertionError CC.fromFastMask(8)

    # QualType: local CVR bits come straight off the inline fast-qualifier field.
    constmask = CC.getLocalCVRQualifiers(qt("wl9ci"))
    @test constmask == CC.getLocalFastQualifiers(qt("wl9ci"))
    @test CC.hasConst(CC.fromFastMask(constmask))
    @test CC.getLocalCVRQualifiers(qt("wl9i")) == 0x0
    @test !CC.hasLocalNonFastQualifiers(qt("wl9i"))
    @test CC.hasLocalNonFastQualifiers(qt("wl9ci")) isa Bool

    # QualType: canonical-as-param, storage constness, trivial equality comparison.
    @test CC.isCanonicalAsParam(CC.getCanonicalType(qt("wl9i")))
    @test !CC.isCanonicalAsParam(qt("wl9ci"))
    @test CC.isCanonicalAsParam(qt("wl9pod")) isa Bool
    @test !CC.isConstantStorage(qt("wl9i"), ctx, false, false)
    @test CC.isConstantStorage(qt("wl9ci"), ctx, false, false) isa Bool
    @test CC.isTriviallyEqualityComparableType(qt("wl9i"), ctx)
    @test CC.isTriviallyEqualityComparableType(qt("wl9d"), ctx) isa Bool

    # QualType: CVR construction and pack-expansion stripping.
    ci = CC.withCVRQualifiers(qt("wl9i"), constmask)
    @test CC.isConstQualified(ci)
    @test !CC.isConstQualified(qt("wl9i"))
    @test_throws AssertionError CC.withCVRQualifiers(qt("wl9i"), 8)
    @test CC.getAsString(CC.getNonPackExpansionType(qt("wl9i"))) == CC.getAsString(qt("wl9i"))

    # Type: literal / standard-layout / structural classification.
    ity = tp("wl9i")
    @test CC.isLiteralType(ity, ctx)
    @test CC.isStandardLayoutType(ity)
    @test CC.isStructuralType(ity)
    @test CC.isStandardLayoutType(tp("wl9pod"))
    @test !CC.isStandardLayoutType(tp("wl9mixed"))
    @test !CC.isLiteralType(tp("wl9nonlit"), ctx)
    @test CC.isStructuralType(tp("wl9pod")) isa Bool

    # Type: exactly one BuiltinType::Kind matches `int`; the value itself is host-internal.
    # The scan must run well past the "obvious" small range — the Kind enum stamps the
    # OpenCL/SVE/RVV image and vector types first, so the C and C++ builtins sit in the 400s.
    kinds = filter(k -> CC.isSpecificBuiltinType(ity, k), 0:1023)
    @test length(kinds) == 1
    @test CC.isSpecificBuiltinType(tp("wl9i2"), only(kinds))
    @test !CC.isSpecificBuiltinType(tp("wl9d"), only(kinds))
    @test !CC.isSpecificBuiltinType(tp("wl9pod"), only(kinds))

    # Type: placeholder / target-specific negatives and the contained-auto probe.
    @test !CC.isNonOverloadPlaceholderType(ity)
    @test !CC.isIbm128Type(ity)
    @test !CC.isSizelessVectorType(ity)
    @test CC.isSizelessVectorType(tp("wl9pod")) isa Bool
    @test CC.getContainedAutoType(ity) isa CC.AutoType
    @test CC.getContainedAutoType(ity).ptr == C_NULL
    @test CC.getContainedDeducedType(ity).ptr == C_NULL

    dispose(I)
end

@testset "type-c payload accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int tc_i = 0;
    double tc_d = 0.0;
    unsigned tc_u = 0u;
    typedef int tc_v4i __attribute__((vector_size(16)));
    tc_v4i tc_vec;
    int *_Nonnull tc_nn = nullptr;
    typedef int tc_myint; tc_myint tc_td = 0;
    namespace tc_ns { typedef int tc_tn; }
    using tc_ns::tc_tn; tc_tn tc_using = 0;
    int tc_fn(double, char);
    auto tc_auto = 3;
    decltype(auto) tc_dauto = 3;
    __auto_type tc_gauto = 3;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    rvar(name) = (f(I, name); CC.resolve(get_decl(f)))
    rty(name) = CC.resolve(CC.getTypePtr(CC.getType(rvar(name))))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t

    # BuiltinType: signed int classifies as integer, signed, non-float
    bi = rty("tc_i")
    @test bi isa CC.BuiltinType
    @test CC.isInteger(bi) == true
    @test CC.isSignedInteger(bi) == true
    @test CC.isUnsignedInteger(bi) == false
    @test CC.isFloatingPoint(bi) == false
    @test CC.isSVEBool(bi) == false
    @test CC.isSVECount(bi) == false
    @test CC.isSugared(bi) == false
    @test CC.getTypePtr(CC.desugar(bi)) isa CC.Type_

    # BuiltinType: double is floating-point; unsigned is unsigned-integer
    bd = rty("tc_d")
    @test bd isa CC.BuiltinType
    @test CC.isFloatingPoint(bd) == true
    @test CC.isInteger(bd) == false
    bu = rty("tc_u")
    @test bu isa CC.BuiltinType
    @test CC.isUnsignedInteger(bu) == true
    @test CC.isSignedInteger(bu) == false

    # VectorType::getVectorKind via the vector_size typedef's underlying type
    vsug = unwrap(rty("tc_vec"))
    vt = vsug isa CC.TypedefType ? CC.resolve(CC.getTypePtr(CC.desugar(vsug))) : vsug
    if vt isa CC.VectorType
        @test CC.getVectorKind(vt) isa CC.LibClangEx.CXVectorKind
        @test CC.getVectorKind(vt) == CC.LibClangEx.CXVectorKind_Generic
    end

    # FunctionType::getCallResultType — int(double, char) yields an int result
    fpt = rty("tc_fn")
    @test fpt isa CC.FunctionProtoType
    crt = CC.getCallResultType(fpt, ctx)
    @test crt isa CC.QualType
    @test CC.resolve(CC.getTypePtr(crt)) isa CC.BuiltinType

    # AttributedType: the _Nonnull nullability attribute
    nn = rty("tc_nn")
    if nn isa CC.AttributedType
        @test CC.isQualifier(nn) isa Bool
        @test CC.isMSTypeSpec(nn) == false
        @test CC.isWebAssemblyFuncrefSpec(nn) == false
        @test CC.isCallingConv(nn) == false
    end

    # TypedefType::typeMatchesDecl — a plain typedef's type matches its decl
    td = unwrap(rty("tc_td"))
    if td isa CC.TypedefType
        @test CC.typeMatchesDecl(td) isa Bool
        @test CC.typeMatchesDecl(td) == true
    end

    # UsingType::typeMatchesDecl
    us = unwrap(rty("tc_using"))
    @test us isa CC.UsingType
    @test CC.typeMatchesDecl(us) isa Bool

    # AutoType::getKeyword across the three keyword spellings
    for (nm, kw) in (("tc_auto", CC.LibClangEx.CXAutoTypeKeyword_Auto),
                     ("tc_dauto", CC.LibClangEx.CXAutoTypeKeyword_DecltypeAuto),
                     ("tc_gauto", CC.LibClangEx.CXAutoTypeKeyword_GNUAutoType))
        f(I, nm) || continue
        t = CC.resolve(CC.getTypePtr(CC.getType(CC.resolve(get_decl(f)))))
        if t isa CC.AutoType
            @test CC.getKeyword(t) isa CC.LibClangEx.CXAutoTypeKeyword
            @test CC.getKeyword(t) == kw
        end
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "type-d payload accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    struct TdRec { int m; };
    TdRec td_rec;
    int td_fn(double a, char b);
    int td_arr[4];
    void td_vla(int n) { int v[n]; (void)v; }
    template <class T> struct TdParm { T td_field; };
    template <int N> struct TdArr { int td_a[N]; };
    template <class... Ts> struct TdHold { void td_mf(Ts... zs); };
    """)
    f = DeclFinder(I)
    rvar(name) = (f(I, name); CC.resolve(get_decl(f)))
    rty(name) = CC.resolve(CC.getTypePtr(CC.getType(rvar(name))))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t

    # TypeWithKeyword::getKeyword (an ElaboratedType is a TypeWithKeyword)
    ety = rty("td_rec")
    @test ety isa CC.ElaboratedType
    @test CC.getKeyword(ety) isa CC.LibClangEx.CXElaboratedTypeKeyword

    # Type::getLinkage / getVisibility -- shape only (host-decided enum value)
    rec = unwrap(ety)
    @test rec isa CC.RecordType
    @test CC.getLinkage(rec) isa CC.LibClangEx.CXLinkage
    @test CC.getVisibility(rec) isa CC.LibClangEx.CXVisibility

    # ArrayType::getIndexTypeQualifiers -- empty qualifiers encode to 0
    aty = rty("td_arr")
    @test aty isa CC.ConstantArrayType
    @test CC.getIndexTypeQualifiers(aty) == 0

    # FunctionProtoType::getEllipsisLoc / hasExtParameterInfos
    fpt = CC.resolve(CC.getTypePtr(CC.getType(rvar("td_fn"))))
    @test fpt isa CC.FunctionProtoType
    @test CC.getEllipsisLoc(fpt) isa CC.SourceLocation
    @test CC.hasExtParameterInfos(fpt) isa Bool

    # VariableArrayType::getLBracketLoc / getRBracketLoc (VLA in a function body)
    f(I, "td_vla")
    local vaty = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f).ptr))))
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
    @test CC.getLBracketLoc(vaty) isa CC.SourceLocation
    @test CC.getRBracketLoc(vaty) isa CC.SourceLocation

    # DependentSizedArrayType::getLBracketLoc / getRBracketLoc (template pattern field)
    f(I, "TdArr")
    parr = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dsaty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(parr)))))
    @test dsaty isa CC.DependentSizedArrayType
    @test CC.getLBracketLoc(dsaty) isa CC.SourceLocation
    @test CC.getRBracketLoc(dsaty) isa CC.SourceLocation

    # TemplateTypeParmType::getIdentifier (`T` field of the template pattern)
    f(I, "TdParm")
    pparm = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    ttpt = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(pparm)))))
    @test ttpt isa CC.TemplateTypeParmType
    @test CC.getIdentifier(ttpt) isa CC.IdentifierInfo

    # PackExpansionType::isSugared / desugar (the `Ts... zs` parameter type)
    f(I, "TdHold")
    hdc = CC.castToDeclContext(CC.getTemplatedDecl(CC.resolve(get_decl(f))))
    local pet = nothing
    for d in CC.decls(hdc)
        d isa CC.CXXMethodDecl || continue
        fd = CC.FunctionDecl(d.ptr)
        CC.getNumParams(fd) > 0 || continue
        t = CC.resolve(CC.getTypePtr(CC.getType(CC.getParamDecl(fd, 0))))
        t isa CC.PackExpansionType && (pet = t)
    end
    @test pet isa CC.PackExpansionType
    if pet isa CC.PackExpansionType
        @test CC.isSugared(pet) isa Bool
        @test CC.getTypePtr(CC.desugar(pet)) isa CC.Type_
    end

    dispose(f)
    dispose(I)
end

@testset "type-e payload accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int te_i;
    const int te_ci = 0;
    volatile int te_vi = 0;
    int te_fn(double a, char b);
    void te_void();
    struct TeQ {
        void te_plain();
        void te_lref() &;
        void te_rref() &&;
        void te_nx() noexcept;
    };
    """)
    f = DeclFinder(I)
    ctx = CC.get_ast_context(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))
    fty(name) = (f(I, name); CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(get_decl(f).ptr)))))

    # Type -- the sizeless-builtin / WebAssembly / OpenCL probes, all false for plain `int`
    ity = CC.getTypePtr(qt("te_i"))
    @test ity isa CC.Type_
    @test CC.isSVESizelessBuiltinType(ity) == false
    @test CC.isRVVSizelessBuiltinType(ity) == false
    @test CC.isWebAssemblyExternrefType(ity) == false
    @test CC.isWebAssemblyTableType(ity) == false
    @test CC.isExtVectorBoolType(ity) == false
    @test CC.isPipeType(ity) == false

    # QualType -- the non-trivial-C-struct family
    @test CC.isNonTrivialToPrimitiveDefaultInitialize(qt("te_i")) ==
          CC.LibClangEx.CXPrimitiveDefaultInitializeKind_PDIK_Trivial
    @test CC.isNonTrivialToPrimitiveCopy(qt("te_i")) ==
          CC.LibClangEx.CXPrimitiveCopyKind_PCK_Trivial
    @test CC.isNonTrivialToPrimitiveCopy(qt("te_vi")) ==
          CC.LibClangEx.CXPrimitiveCopyKind_PCK_VolatileTrivial
    @test CC.isNonTrivialToPrimitiveDestructiveMove(qt("te_i")) ==
          CC.LibClangEx.CXPrimitiveCopyKind_PCK_Trivial
    @test CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion(qt("te_i")) == false
    @test CC.hasNonTrivialToPrimitiveDestructCUnion(qt("te_i")) == false
    @test CC.hasNonTrivialToPrimitiveCopyCUnion(qt("te_i")) == false

    # QualType::isCForbiddenLValueType -- `void` is forbidden, `int` is not
    @test CC.isCForbiddenLValueType(qt("te_i")) == false
    vfty = fty("te_void")
    @test vfty isa CC.FunctionProtoType
    @test CC.isCForbiddenLValueType(CC.getReturnType(vfty)) == true

    # QualType::getNonLValueExprType -- top-level cv drops off a non-class type in C++
    @test CC.getAsString(qt("te_ci")) == "const int"
    @test CC.getAsString(CC.getNonLValueExprType(qt("te_ci"), ctx)) == "int"

    # FunctionProtoType -- ref-qualifier, noexcept classification, SME bitmask
    fpt = fty("te_fn")
    @test fpt isa CC.FunctionProtoType
    @test CC.getRefQualifier(fpt) == CC.LibClangEx.CXRefQualifierKind_RQ_None
    @test CC.canThrow(fpt) == CC.LibClangEx.CXCanThrowResult_CT_Can
    @test CC.getAArch64SMEAttributes(fpt) isa Integer
    @test CC.getAArch64SMEAttributes(fpt) == 0

    f(I, "TeQ")
    dc = CC.castToDeclContext(CC.resolve(get_decl(f)))
    rqs = Set{Any}()
    cts = Set{Any}()
    for d in CC.decls(dc)
        d isa CC.CXXMethodDecl || continue
        t = CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(d.ptr))))
        t isa CC.FunctionProtoType || continue
        push!(rqs, CC.getRefQualifier(t))
        push!(cts, CC.canThrow(t))
    end
    @test CC.LibClangEx.CXRefQualifierKind_RQ_LValue in rqs
    @test CC.LibClangEx.CXRefQualifierKind_RQ_RValue in rqs
    @test CC.LibClangEx.CXCanThrowResult_CT_Cannot in cts

    # FunctionType::getNameForCallConv -- a static over the mirrored CallingConv enum
    @test CC.getNameForCallConv(CC.LibClangEx.CXCallingConv_CC_C) == "cdecl"

    # TypeSourceInfo::getType / overrideType on a freshly built TypeSourceInfo
    f(I, "te_i")
    ivd = CC.resolve(get_decl(f))
    tsi = CC.getTrivialTypeSourceInfo(ctx, CC.getType(ivd), CC.getLocation(ivd))
    @test CC.getType(tsi) isa CC.QualType
    @test CC.getAsString(CC.getType(tsi)) == "int"
    CC.overrideType(tsi, qt("te_ci"))
    @test CC.getAsString(CC.getType(tsi)) == "const int"

    dispose(f)
    dispose(I)
end

@testset "type-f payload accessors" begin
    LX = CC.LibClangEx
    I = create_interpreter(String[])
    CC.parse(I, """
    int tf_i;
    const int tf_ci = 0;
    """)
    f = DeclFinder(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))

    # Qualifiers -- hasOnly* separates an exact set from a superset
    q0 = CC.fromCVRMask(0)
    qc = CC.withConst(q0)
    qv = CC.withVolatile(q0)
    qr = CC.withRestrict(q0)
    qcv = CC.withVolatile(qc)
    @test CC.hasOnlyConst(qc) == true
    @test CC.hasOnlyConst(qcv) == false
    @test CC.hasOnlyVolatile(qv) == true
    @test CC.hasOnlyVolatile(qcv) == false
    @test CC.hasOnlyRestrict(qr) == true
    @test CC.hasOnlyRestrict(qcv) == false

    # Qualifiers -- the CVR/unaligned/emptiness probes
    @test CC.hasCVRQualifiers(q0) == false
    @test CC.hasCVRQualifiers(qcv) == true
    @test CC.getCVRUQualifiers(q0) == 0
    @test CC.getCVRUQualifiers(qcv) == CC.getCVRQualifiers(qcv)
    @test CC.hasUnaligned(qcv) == false
    @test CC.hasQualifiers(q0) == false
    @test CC.hasQualifiers(qcv) == true
    @test CC.hasQualifiers(qcv) == !CC.empty(qcv)

    # Qualifiers -- the address-space tail; a CVR-only set carries LangAS::Default
    @test CC.withoutAddressSpace(qcv) == qcv
    @test CC.hasAddressSpace(CC.withoutAddressSpace(qcv)) == false
    @test CC.hasTargetSpecificAddressSpace(qcv) == false
    @test CC.getAddressSpaceAttributePrintValue(qcv) == 0
    @test CC.isAddressSpaceSupersetOf(LX.CXLangAS_opencl_global,
                                      LX.CXLangAS_opencl_global) == true
    @test CC.isAddressSpaceSupersetOf(LX.CXLangAS_opencl_generic,
                                      LX.CXLangAS_opencl_global) == true
    @test CC.isAddressSpaceSupersetOf(LX.CXLangAS_opencl_global,
                                      LX.CXLangAS_opencl_generic) == false
    @test CC.getAddrSpaceAsString(LX.CXLangAS_Default) isa String
    @test occursin("global", CC.getAddrSpaceAsString(LX.CXLangAS_opencl_global))

    # QualType -- the fast-qualifier constructors, read back through getAsString
    plain = qt("tf_i")
    ci = qt("tf_ci")
    @test CC.getLocalFastQualifiers(plain) == 0
    @test CC.getAsString(CC.withFastQualifiers(plain, CC.getCVRQualifiers(qc))) == "const int"
    @test CC.getAsString(CC.withoutLocalFastQualifiers(ci)) == "int"
    @test CC.getAsString(CC.withExactLocalFastQualifiers(ci, 0)) == "int"
    vol = CC.withExactLocalFastQualifiers(ci, CC.getCVRQualifiers(qv))
    @test CC.isLocalVolatileQualified(vol) == true
    @test CC.isLocalConstQualified(vol) == false
    @test_throws AssertionError CC.withFastQualifiers(plain, 8)
    @test_throws AssertionError CC.withExactLocalFastQualifiers(plain, 8)

    # TypeWithKeyword -- the static keyword <-> tag-kind conversions
    @test CC.getKeywordForTagTypeKind(LX.CXTagTypeKind_Struct) ==
          LX.CXElaboratedTypeKeyword_Struct
    @test CC.getKeywordForTagTypeKind(LX.CXTagTypeKind_Enum) ==
          LX.CXElaboratedTypeKeyword_Enum
    @test CC.getTagTypeKindForKeyword(LX.CXElaboratedTypeKeyword_Union) ==
          LX.CXTagTypeKind_Union
    @test CC.KeywordIsTagTypeKind(LX.CXElaboratedTypeKeyword_Class) == true
    @test CC.KeywordIsTagTypeKind(LX.CXElaboratedTypeKeyword_Typename) == false
    @test CC.KeywordIsTagTypeKind(LX.CXElaboratedTypeKeyword_None) == false
    @test_throws AssertionError CC.getTagTypeKindForKeyword(LX.CXElaboratedTypeKeyword_None)
    @test CC.getKeywordName(LX.CXElaboratedTypeKeyword_Struct) == "struct"
    @test CC.getKeywordName(LX.CXElaboratedTypeKeyword_Typename) == "typename"
    @test CC.getKeywordName(LX.CXElaboratedTypeKeyword_None) isa String
    @test CC.getTagTypeKindName(LX.CXTagTypeKind_Class) == "class"
    @test CC.getTagTypeKindName(LX.CXTagTypeKind_Union) == "union"

    dispose(f)
    dispose(I)
end

@testset "type-g payload accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int tg_i;
    const volatile int tg_cvi = 0;
    int *tg_p;
    """)
    f = DeclFinder(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))

    # QualType -- the local-qualifier removers return a new value and leave the receiver
    # alone, because a QualType crosses by value.
    cvi = qt("tg_cvi")
    @test CC.isLocalConstQualified(cvi) == true
    @test CC.isLocalVolatileQualified(cvi) == true
    noconst = CC.removeLocalConst(cvi)
    @test CC.isLocalConstQualified(noconst) == false
    @test CC.isLocalVolatileQualified(noconst) == true
    novol = CC.removeLocalVolatile(noconst)
    @test CC.isLocalVolatileQualified(novol) == false
    @test CC.getAsString(novol) == "int"
    @test CC.isLocalConstQualified(cvi) == true
    @test CC.isLocalVolatileQualified(cvi) == true

    # removing a qualifier that is not there is a no-op; removing one that is clears it
    @test CC.isLocalRestrictQualified(CC.removeLocalRestrict(cvi)) == false
    @test CC.getAsString(CC.removeLocalRestrict(novol)) == "int"
    rq = CC.withRestrict(qt("tg_p"))
    @test CC.isLocalRestrictQualified(rq) == true
    @test CC.isLocalRestrictQualified(CC.removeLocalRestrict(rq)) == false
    @test CC.isLocalConstQualified(CC.removeLocalConst(rq)) == false

    ity = CC.getTypePtr(qt("tg_i"))
    pty = CC.getTypePtr(qt("tg_p"))

    # Type -- the ObjC classification family is uniformly false in a C++ translation unit
    for t in (ity, pty)
        @test CC.isObjCObjectPointerType(t) == false
        @test CC.isObjCRetainableType(t) == false
        @test CC.isObjCObjectType(t) == false
        @test CC.isObjCObjectOrInterfaceType(t) == false
        @test CC.isObjCIdType(t) == false
        @test CC.isObjCClassType(t) == false
        @test CC.isObjCSelType(t) == false
        @test CC.isObjCBuiltinType(t) == false
    end
    # isObjCBuiltinType is exactly the disjunction of the three singleton probes
    for t in (ity, pty)
        @test CC.isObjCBuiltinType(t) ==
              (CC.isObjCIdType(t) || CC.isObjCClassType(t) || CC.isObjCSelType(t))
    end

    # Type -- the OpenCL opaque-type family, likewise false outside OpenCL
    for t in (ity, pty)
        @test CC.isImageType(t) == false
        @test CC.isSamplerT(t) == false
        @test CC.isEventT(t) == false
        @test CC.isClkEventT(t) == false
        @test CC.isQueueT(t) == false
        @test CC.isReserveIDT(t) == false
        @test CC.isOCLIntelSubgroupAVCType(t) == false
        @test CC.isOCLExtOpaqueType(t) == false
        @test CC.isOpenCLSpecificType(t) == false
    end
    # isOpenCLSpecificType is exactly the union clang documents
    for t in (ity, pty)
        @test CC.isOpenCLSpecificType(t) ==
              (CC.isSamplerT(t) || CC.isEventT(t) || CC.isImageType(t) ||
               CC.isClkEventT(t) || CC.isQueueT(t) || CC.isReserveIDT(t) ||
               CC.isPipeType(t) || CC.isOCLExtOpaqueType(t))
    end

    dispose(f)
    dispose(I)
end

@testset "Qualifiers mutator tail and the placeholder-kind gate" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int qmt_i = 0;
    """)
    f = DeclFinder(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))
    ity = CC.getTypePtr(qt("qmt_i"))

    # Qualifiers has no carrier struct: it crosses as its opaque unsigned encoding, so every
    # wrapper below dispatches on Integer and returns a fresh encoding rather than mutating.
    q0 = CC.fromCVRMask(0)
    qc = CC.withConst(q0)
    qv = CC.withVolatile(q0)
    qr = CC.withRestrict(q0)
    qcv = CC.withVolatile(qc)
    qcvr = CC.withRestrict(qcv)

    # the remove* trio is the exact inverse of the with* trio, and a no-op otherwise
    @test CC.removeConst(qc) == q0
    @test CC.removeVolatile(qv) == q0
    @test CC.removeRestrict(qr) == q0
    @test CC.removeConst(q0) == q0
    @test CC.removeConst(qcv) == qv
    @test CC.hasVolatile(CC.removeConst(qcv))
    @test !CC.hasConst(CC.removeConst(qcv))

    # the CVR mask mutators, and the mask precondition each of them restates
    cvr = CC.getCVRQualifiers(qcvr)
    @test CC.setCVRQualifiers(q0, cvr) == qcvr
    @test CC.setCVRQualifiers(qcvr, 0) == q0
    @test CC.addCVRQualifiers(qc, CC.getCVRQualifiers(qv)) == qcv
    @test CC.addCVRQualifiers(qcvr, 0) == qcvr
    @test CC.removeCVRQualifiers(qcvr, cvr) == q0
    @test CC.removeCVRQualifiers(qcvr, CC.getCVRQualifiers(qc)) == CC.withRestrict(qv)
    @test_throws AssertionError CC.setCVRQualifiers(q0, 8)
    @test_throws AssertionError CC.addCVRQualifiers(q0, 8)
    @test_throws AssertionError CC.removeCVRQualifiers(q0, 8)

    # the unaligned bit: setUnaligned covers clang's addUnaligned/removeUnaligned pair, and
    # the CVRU forms are the CVR ones widened with it
    qu = CC.setUnaligned(q0, true)
    @test CC.hasUnaligned(qu)
    @test CC.setUnaligned(qu, false) == q0
    @test CC.setUnaligned(qu, true) == qu
    qcvru = CC.setUnaligned(qcvr, true)
    @test CC.fromCVRUMask(CC.getCVRUQualifiers(qcvru)) == qcvru
    @test CC.fromCVRUMask(0) == q0
    @test CC.addCVRUQualifiers(qcvr, CC.getCVRUQualifiers(qu)) == qcvru
    @test CC.getCVRQualifiers(qcvru) == cvr
    @test_throws AssertionError CC.fromCVRUMask(16)
    @test_throws AssertionError CC.addCVRUQualifiers(q0, 16)

    # fast qualifiers are that same const/volatile/restrict subset, reached by their own trio
    @test CC.getFastQualifiers(qcvr) == cvr
    @test CC.setFastQualifiers(q0, cvr) == qcvr
    @test CC.setFastQualifiers(qcvr, 0) == q0
    @test CC.addFastQualifiers(q0, cvr) == qcvr
    @test CC.removeFastQualifiers(qcvr, cvr) == q0
    @test CC.hasFastQualifiers(CC.addFastQualifiers(q0, cvr))
    @test_throws AssertionError CC.setFastQualifiers(q0, 8)
    @test_throws AssertionError CC.addFastQualifiers(q0, 8)
    @test_throws AssertionError CC.removeFastQualifiers(q0, 8)

    # whole-set union and difference
    @test CC.addQualifiers(qc, qv) == qcv
    @test CC.addQualifiers(q0, qcvr) == qcvr
    @test CC.removeQualifiers(qcvr, qc) == CC.withRestrict(qv)
    @test CC.removeQualifiers(qcvr, qcvr) == q0
    @test CC.removeQualifiers(qc, qv) == qc

    # the address-space setters: addAddressSpace rejects the default space, setAddressSpace
    # accepts it and is then exactly withoutAddressSpace
    gl = CC.LibClangEx.CXLangAS_opencl_global
    lo = CC.LibClangEx.CXLangAS_opencl_local
    qas = CC.setAddressSpace(q0, gl)
    @test CC.hasAddressSpace(qas)
    @test CC.getAddressSpace(qas) == gl
    @test CC.setAddressSpace(qas, CC.LibClangEx.CXLangAS_Default) == q0
    @test CC.withoutAddressSpace(qas) == q0
    @test CC.addAddressSpace(q0, lo) == CC.setAddressSpace(q0, lo)
    @test CC.getAddressSpace(CC.addAddressSpace(qcvr, lo)) == lo
    @test_throws AssertionError CC.addAddressSpace(q0, CC.LibClangEx.CXLangAS_Default)

    # removeCommonQualifiers hands back the shared set plus both inputs stripped of it
    common, lrest, rrest = CC.removeCommonQualifiers(qcv, CC.withRestrict(qc))
    @test common == qc
    @test lrest == qv
    @test rrest == qr
    nocommon, lsame, rsame = CC.removeCommonQualifiers(qc, qv)
    @test nocommon == q0
    @test lsame == qc
    @test rsame == qv

    # BuiltinType::isPlaceholderTypeKind is `K >= Overload`, so it is monotone from that
    # Kind upwards, and it is the gate isSpecificPlaceholderType asserts on -- probe it
    # rather than hard-coding a Kind. The scan must run well past the "obvious" small
    # range: clang stamps the OpenCL/SVE/RVV types into Kind first, so the placeholders
    # sit in the high 400s (Overload is 489 in clang 18).
    phkinds = filter(k -> CC.isPlaceholderTypeKind(k), 0:1023)
    @test !isempty(phkinds)
    ovl = first(phkinds)
    @test ovl > 0
    @test CC.isPlaceholderTypeKind(ovl)
    @test !CC.isPlaceholderTypeKind(ovl - 1)
    @test all(k -> CC.isPlaceholderTypeKind(k), ovl:1023)

    # an `int` is a placeholder of no kind at all, and a non-placeholder Kind is rejected
    @test CC.isPlaceholderType(ity) == false
    @test CC.isSpecificPlaceholderType(ity, ovl) == false
    @test CC.isSpecificPlaceholderType(ity, last(phkinds)) == false
    @test_throws AssertionError CC.isSpecificPlaceholderType(ity, ovl - 1)

    dispose(f)
    dispose(I)
end

@testset "type-i payload accessors" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    typedef const int ti_ci;
    volatile ti_ci ti_vci = 0;
    int ti_i = 0;
    int *ti_p = &ti_i;
    int *_Nonnull ti_nn = &ti_i;
    enum class TiEnum : int { A };
    using TiUnder = __underlying_type(TiEnum);
    template <class T> struct TiWrap { T val; };
    TiWrap<int> ti_w;
    """)
    f = DeclFinder(I)
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(get_decl(f).ptr)))

    ity = CC.getTypePtr(qt("ti_i"))
    pty = CC.getTypePtr(qt("ti_p"))

    # AttributedType/Type::hasAttr -- `int *_Nonnull` carries one attribute sugar node and a
    # bare `int` carries none, so hasAttr walks the chain to a definite answer either way.
    nnty = CC.resolve(CC.getTypePtr(qt("ti_nn")))
    @test nnty isa CC.AttributedType
    @test CC.getAttrKind(nnty) == CC.LibClangEx.CXAttrKind_TypeNonNull
    @test CC.hasAttr(nnty, CC.getAttrKind(nnty)) == true
    @test CC.hasAttr(CC.getTypePtr(qt("ti_nn")), CC.LibClangEx.CXAttrKind_TypeNonNull) == true
    @test CC.hasAttr(ity, CC.LibClangEx.CXAttrKind_TypeNonNull) == false
    @test CC.hasAttr(pty, CC.LibClangEx.CXAttrKind_TypeNonNull) == false

    # canHaveNullability is "is this some kind of pointer"; the flag is only consulted for a
    # dependent type, so it changes nothing for these two
    @test CC.canHaveNullability(pty) == true
    @test CC.canHaveNullability(ity) == false
    @test CC.canHaveNullability(ity, false) == false
    @test CC.canHaveNullability(pty, false) == true

    # SplitQualType crosses as (Type_, opaque Qualifiers). `volatile ti_ci` is a volatile
    # typedef of `const int`, so both levels of qualifier come back together.
    vci = qt("ti_vci")
    dty, dquals = CC.getSplitDesugaredType(vci)
    @test dty isa CC.Type_
    @test CC.getTypeClassName(dty) == "Builtin"
    @test CC.hasConst(dquals) == true
    @test CC.hasVolatile(dquals) == true

    uty, uquals = CC.getSplitUnqualifiedType(vci)
    @test uty isa CC.Type_
    @test CC.hasConst(uquals) == true
    @test CC.hasVolatile(uquals) == true
    # clang_QualType_constructFromTypePtr is wrapped as the QualType(Type_, quals)
    # constructor, not a free function.
    @test CC.isConstQualified(CC.QualType(uty, 0)) == false

    @test_throws AssertionError CC.getSplitDesugaredType(CC.QualType(C_NULL))
    @test_throws AssertionError CC.getSplitUnqualifiedType(CC.QualType(C_NULL))

    # address spaces: everything in a plain C++ TU sits in the default space, which overlaps
    # itself and every other default-space type
    @test CC.isAddressSpaceOverlapping(qt("ti_i"), qt("ti_p")) == true
    @test CC.isAddressSpaceOverlapping(vci, vci) == true
    @test_throws AssertionError CC.isAddressSpaceOverlapping(CC.QualType(C_NULL), vci)
    @test_throws AssertionError CC.isAddressSpaceOverlapping(vci, CC.QualType(C_NULL))

    # BuiltinType -- the Kind round-trips through the Type-level kind queries. clang stamps
    # the OpenCL/SVE/RVV builtins into Kind first, so `int` lands in the 400s; assert the
    # round-trip, never a literal.
    bty = CC.resolve(ity)
    @test bty isa CC.BuiltinType
    k = CC.getKind(bty)
    @test k isa Integer
    @test CC.isSpecificBuiltinType(ity, k) == true
    @test CC.isPlaceholderTypeKind(k) == false
    @test CC.isPlaceholderType(bty) == false
    @test CC.isNonOverloadPlaceholderType(bty) == false
    # the BuiltinType receivers agree with the Type-level ones they shadow
    @test CC.isPlaceholderType(bty) == CC.isPlaceholderType(ity)
    @test CC.isNonOverloadPlaceholderType(bty) == CC.isNonOverloadPlaceholderType(ity)

    # ConstantArrayType's size cap is target-decided -- assert its shape only
    mb = CC.getMaxSizeBits(ctx)
    @test mb isa Integer
    @test mb > 0

    # the matrix-type statics are pure functions with no receiver at all
    cap = CC.getMaxElementsPerDimension()
    @test cap == (1 << 20) - 1
    @test CC.isDimensionValid(1) == true
    @test CC.isDimensionValid(0) == false
    @test CC.isDimensionValid(cap) == true
    @test CC.isDimensionValid(Int(cap) + 1) == false
    @test CC.isValidElementType(qt("ti_i")) == true
    @test CC.isValidElementType(qt("ti_p")) == false
    @test_throws AssertionError CC.isValidElementType(CC.QualType(C_NULL))

    # the AArch64 SME state fields are a pure bit decode: ZA at bits 2-4, ZT0 at bits 5-7
    none = CC.LibClangEx.CXArmStateValue_ARM_None
    @test CC.getArmZAState(0) == none
    @test CC.getArmZT0State(0) == none
    @test CC.getArmZAState(2 << 2) == CC.LibClangEx.CXArmStateValue_ARM_In
    @test CC.getArmZAState(4 << 2) == CC.LibClangEx.CXArmStateValue_ARM_InOut
    @test CC.getArmZT0State(3 << 5) == CC.LibClangEx.CXArmStateValue_ARM_Out
    @test CC.getArmZT0State(1 << 5) == CC.LibClangEx.CXArmStateValue_ARM_Preserves
    # neither field bleeds into the other
    @test CC.getArmZAState(3 << 5) == none
    @test CC.getArmZT0State(2 << 2) == none
    # 5..7 fit the three-bit field but name no ArmStateValue, so the wrappers reject them
    @test_throws AssertionError CC.getArmZAState(7 << 2)
    @test_throws AssertionError CC.getArmZT0State(5 << 5)

    # UnaryTransformType -- `__underlying_type(E)` keeps its trait kind in the sugar
    @assert f(I, "TiUnder") "lookup failed: TiUnder"
    tad = CC.resolve(get_decl(f))
    @test tad isa CC.TypeAliasDecl
    utt = CC.resolve(CC.getTypePtr(CC.getUnderlyingType(tad)))
    @test utt isa CC.UnaryTransformType
    @test CC.getUTTKind(utt) == CC.LibClangEx.CXUTTKind_EnumUnderlyingType
    @test CC.getAsString(CC.getUnderlyingType(utt)) == "int"

    # SubstTemplateTypeParmType -- TiWrap<int>::val replaces a non-pack parameter, so the
    # optional pack index is disengaged
    w_crt = CC.resolve(CC.getTypePtr(CC.getCanonicalType(qt("ti_w"))))
    @test w_crt isa CC.RecordType
    sttp = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(CC.getDecl(w_crt))))))
    @test sttp isa CC.SubstTemplateTypeParmType
    @test CC.getPackIndex(sttp) === nothing

    # AutoType -- the canonical undeduced `auto` carries no type-constraint arguments
    aty = CC.resolve(CC.getTypePtr(CC.getAutoDeductType(ctx)))
    @test aty isa CC.AutoType
    @test CC.isConstrained(aty) == false
    @test CC.getTypeConstraintArguments(aty).Length == 0

    dispose(f)
    dispose(I)
end
