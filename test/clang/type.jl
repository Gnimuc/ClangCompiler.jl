using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

import ClangCompiler as CC
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

@testset "sugar type resolve" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "_Atomic int av;")
    f = DeclFinder(I)
    @test f(I, "av")
    vd = ClangCompiler.VarDecl(get_decl(f).ptr)
    ty = ClangCompiler.resolve(ClangCompiler.getTypePtr(ClangCompiler.getType(vd)))
    @test ty isa ClangCompiler.AtomicType
    @test !CC.is_null_handle(ClangCompiler.getValueType(ty))
    dispose(f)
    dispose(I)
end

@testset "Type classification (getTypeClass / resolve)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int *tc_p; int tc_arr[4]; int &tc_r = *tc_p;")
    f = DeclFinder(I)
    cases = [("tc_p", CC.PointerType, CC.LibClangEx.CXTypeClass_Pointer),
             # getTypeClass resolves straight to the leaf: array -> ConstantArray
             # (not the abstract Array), reference -> LValueReference.
             ("tc_arr", CC.ConstantArrayType, CC.LibClangEx.CXTypeClass_ConstantArray),
             ("tc_r", CC.LValueReferenceType, CC.LibClangEx.CXTypeClass_LValueReference)]
    for (name, carrier, cls) in cases
        @test f(I, name)
        typtr = CC.getTypePtr(CC.getType(CC.VarDecl(get_decl(f).ptr)))
        @test CC.getTypeClass(typtr) == cls
        @test CC.resolve(typtr) isa carrier
    end
    dispose(f)
    dispose(I)
end

@testset "get_template_args element access" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, """
    template<typename A, typename B, int N> struct GtaP {};
    GtaP<int, double, 3> gta_v;
    """)
    f = DeclFinder(I)
    @test f(I, "gta_v")
    qt = ClangCompiler.getType(ClangCompiler.VarDecl(get_decl(f).ptr))
    ty = ClangCompiler.resolve(ClangCompiler.getTypePtr(qt))
    ty isa ClangCompiler.ElaboratedType &&
        (ty = ClangCompiler.resolve(ClangCompiler.getTypePtr(ClangCompiler.desugar(ty))))
    @test ty isa ClangCompiler.TemplateSpecializationType
    args = ClangCompiler.get_template_args(ty)
    # every element must be readable — the old Ptr-stride walk returned garbage
    # for index >= 1
    @test length(args) == 3
    kinds = [ClangCompiler.getKind(a) for a in args]
    @test kinds[1] == kinds[2] == ClangCompiler.LibClangEx.CXTemplateArgument_Type
    # the as-written (sugared) spelling keeps `3` as an expression argument
    @test kinds[3] == ClangCompiler.LibClangEx.CXTemplateArgument_Expression
    dispose(f)
    dispose(I)
end

using ClangCompiler: get_tag
@testset "coverage tail: type-middle" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    #define TMID_ND __attribute__((noderef))
    int tmid_g = 1;
    const int tmid_ci = 2;
    int *tmid_p = &tmid_g;
    int &tmid_lr = tmid_g;
    int &&tmid_rr = 3;
    __complex__ double tmid_cx;
    struct TmidRec { int m; };
    TmidRec tmid_rc;
    int TmidRec::*tmid_mp = &TmidRec::m;
    int tmid_arr[3];
    extern int tmid_iarr[];
    int tmid_fn(double a, char b);
    void tmid_vla_fn(int n) { int v[n]; (void)v; }
    void tmid_decay_fn(int a[4]);
    typedef int tmid_td_t;
    tmid_td_t tmid_tdv;
    enum TmidE : int { TMID_A };
    TmidE tmid_ev;
    __underlying_type(TmidE) tmid_ut = 0;
    int (*tmid_pf)(char);
    int tmid_d0 = 1;
    decltype(tmid_d0) tmid_dc = 2;
    auto tmid_au = 1;
    int TMID_ND *tmid_mq;
    template <class T> struct TmidS6 { T t; };
    template <int N> struct TmidS2 { int a[N]; };
    template <class T> struct TmidS4 { typename T::template TT<int> w; };
    template <class T> struct TmidDN { typename T::ty m; };
    template <class T> struct TmidIC { TmidIC *self; };
    template <int N> struct TmidDAS { typedef int __attribute__((address_space(N))) att; att *p; };
    template <int N> struct TmidDEV { typedef int evt __attribute__((ext_vector_type(N))); evt e; };
    template <class B> struct TmidUU : B { using typename B::uty; uty m; };
    template <class T> struct TmidTP { };
    TmidTP<int> tmid_tpv;
    template <class T> struct TmidSB { T v; };
    TmidSB<int> tmid_sbv;
    namespace tmid_ns { struct TmidUS { int q; }; }
    using tmid_ns::TmidUS;
    TmidUS tmid_usv;
    template <class T> struct TmidCT { T v; constexpr TmidCT(T x) : v(x) {} };
    TmidCT tmid_ctv{1};
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    getdecl(name) = (r = f(I, name); @assert r "lookup failed: $name"; get_decl(f))
    qtof(name) = CC.getType(CC.VarDecl(getdecl(name).ptr))
    tpof(name) = CC.getTypePtr(qtof(name))
    canon(tp) = CC.getTypePtr(CC.get_qual_type(tp))
    unwrap(tp) = (r = CC.resolve(tp); r isa CC.ElaboratedType ? CC.getTypePtr(CC.getNamedType(r)) : tp)
    function patfield(name)
        r = f(I, name)
        @assert r "lookup failed: $name"
        pat = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
        return CC.getTypePtr(CC.getType(first(CC.getFields(pat))))
    end
    function tmid_find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = tmid_find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    # builtin per-kind predicates: concrete singleton method + AbstractType fallback
    builtin_pairs = Any[(CC.VoidTy, CC.is_void_ty), (CC.BoolTy, CC.is_bool_ty),
                        (CC.CharTy, CC.is_char_ty), (CC.WCharTy, CC.is_wchar_ty),
                        (CC.WideCharTy, CC.is_widechar_ty), (CC.Char8Ty, CC.is_char8_ty),
                        (CC.Char16Ty, CC.is_char16_ty), (CC.Char32Ty, CC.is_char32_ty),
                        (CC.SignedCharTy, CC.is_signed_char_ty), (CC.ShortTy, CC.is_short_ty),
                        (CC.IntTy, CC.is_int_ty), (CC.LongTy, CC.is_long_ty),
                        (CC.LongLongTy, CC.is_longlong_ty), (CC.Int128Ty, CC.is_int128_ty),
                        (CC.UnsignedCharTy, CC.is_unsigned_char_ty),
                        (CC.UnsignedShortTy, CC.is_unsigned_short_ty),
                        (CC.UnsignedIntTy, CC.is_unsigned_int_ty),
                        (CC.UnsignedLongTy, CC.is_unsigned_long_ty),
                        (CC.UnsignedLongLongTy, CC.is_unsigned_longlong_ty),
                        (CC.UnsignedInt128Ty, CC.is_unsigned_int128_ty),
                        (CC.FloatTy, CC.is_float_ty), (CC.DoubleTy, CC.is_double_ty),
                        (CC.LongDoubleTy, CC.is_long_double_ty), (CC.Float128Ty, CC.is_float128_ty),
                        (CC.HalfTy, CC.is_half_ty), (CC.BFloat16Ty, CC.is_bfloat_ty),
                        (CC.Float16Ty, CC.is_float16_ty), (CC.NullPtrTy, CC.is_nullptr_ty)]
    for (T, pred) in builtin_pairs
        conc = T(ctx)
        @test pred(conc) === true                     # concrete singleton method
        @test pred(CC.BuiltinType(conc.ptr)) === true # AbstractType method via base carrier
    end
    @test CC.is_builtin_type(CC.IntTy(ctx)) === true  # AbstractBuiltinType method
    @test CC.is_builtin_type(tpof("tmid_g")) === true # AbstractType method

    # ComplexType
    cxtp = tpof("tmid_cx")
    @test CC.is_complex_type(cxtp) === true
    cxr = CC.resolve(cxtp)
    @test cxr isa CC.ComplexType
    @test CC.is_complex_type(cxr) === true

    # PointerType
    pty = CC.resolve(tpof("tmid_p"))
    @test pty isa CC.PointerType
    @test CC.is_pointer_type(pty) === true
    @test CC.get_pointee_type(pty) isa CC.QualType

    # ReferenceType / LValue / RValue
    ltp = tpof("tmid_lr")
    @test CC.is_lvalue_reference_type(ltp) === true
    lvr = CC.resolve(ltp)
    @test lvr isa CC.LValueReferenceType
    @test CC.is_reference_type(lvr) === true
    @test CC.get_pointee_type(lvr) isa CC.QualType
    @test CC.is_lvalue_reference_type(lvr) === true
    rtp = tpof("tmid_rr")
    @test CC.is_rvalue_reference_type(rtp) === true
    @test CC.is_rvalue_reference_type(CC.resolve(rtp)) === true

    # MemberPointerType
    mtp = tpof("tmid_mp")
    @test CC.is_member_pointer_type(mtp) === true
    mpt = CC.resolve(mtp)
    @test mpt isa CC.MemberPointerType
    @test CC.is_member_pointer_type(mpt) === true
    @test CC.get_pointee_type(mpt) isa CC.QualType
    @test CC.get_class(mpt) isa CC.Type_

    # ConstantArrayType / IncompleteArrayType
    atp = tpof("tmid_arr")
    @test CC.is_constant_array_type(atp) === true
    caty = CC.resolve(atp)
    @test caty isa CC.ConstantArrayType
    @test CC.is_array_type(caty) === true
    @test CC.is_constant_array_type(caty) === true
    itp = tpof("tmid_iarr")
    @test CC.is_incomplete_array_type(itp) === true
    @test CC.is_incomplete_array_type(CC.resolve(itp)) === true

    # VariableArrayType via a VLA local
    vfd = CC.FunctionDecl(getdecl("tmid_vla_fn").ptr)
    ds = tmid_find_node(CC.DeclStmt, CC.resolve(CC.getBody(vfd)))
    @test ds isa CC.DeclStmt
    vvd = CC.VarDecl(CC.getSingleDecl(ds).ptr)
    vtp = CC.getTypePtr(CC.getType(vvd))
    @test CC.is_variable_array_type(vtp) === true
    vat = CC.resolve(vtp)
    @test vat isa CC.VariableArrayType
    @test CC.is_variable_array_type(vat) === true

    # DependentSizedArrayType via a template pattern field
    dsatp = patfield("TmidS2")
    @test CC.is_dependent_size_array_type(dsatp) === true
    dsat = CC.resolve(dsatp)
    @test dsat isa CC.DependentSizedArrayType
    @test CC.is_dependent_size_array_type(dsat) === true

    # FunctionType / FunctionProtoType / FunctionNoProtoType
    ftp = CC.getTypePtr(CC.getType(CC.FunctionDecl(getdecl("tmid_fn").ptr)))
    @test CC.is_function_type(ftp) === true
    fpt = CC.resolve(CC.resolve(ftp))
    @test fpt isa CC.FunctionProtoType
    @test CC.is_function_type(fpt) === true
    @test CC.is_function_proto_type(ftp) === true
    @test CC.is_function_proto_type(fpt) === true
    @test CC.get_return_type(fpt) isa CC.QualType
    @test CC.get_param_num(fpt) == 2
    @test CC.get_param_type(fpt, 1) isa CC.QualType
    ps = CC.get_params(fpt)
    @test length(ps) == 2 && all(x -> x isa CC.QualType, ps)
    npqt = CC.getFunctionNoProtoType(ctx, CC.get_qual_type(CC.IntTy(ctx)))
    np = CC.resolve(CC.resolve(CC.getTypePtr(npqt)))
    @test np isa CC.FunctionNoProtoType
    @test CC.is_function_no_proto_type(np) === true

    # TypedefType
    elab = CC.resolve(tpof("tmid_tdv"))
    tdtp = elab isa CC.ElaboratedType ? CC.getTypePtr(CC.desugar(elab)) : tpof("tmid_tdv")
    @test CC.is_typedef_type(tdtp) === true
    tdt = CC.resolve(tdtp)
    @test tdt isa CC.TypedefType
    @test CC.is_typedef_type(tdt) === true

    # TagType / RecordType / EnumType
    rctp = canon(tpof("tmid_rc"))
    @test CC.is_tag_type(rctp) === true
    rct = CC.resolve(rctp)
    @test rct isa CC.RecordType
    @test CC.is_tag_type(rct) === true
    @test CC.is_record_type(rct) === true
    evtp = canon(tpof("tmid_ev"))
    @test CC.is_enum_type(evtp) === true
    ent = CC.resolve(evtp)
    @test ent isa CC.EnumType
    @test CC.is_enum_type(ent) === true
    @test CC.get_integer_type(ent) isa CC.QualType
    @test CC.get_name(ent) == "TmidE"

    # TemplateTypeParmType
    ttp = patfield("TmidS6")
    @test CC.is_template_type_parm_type(ttp) === true
    ttr = CC.resolve(ttp)
    @test ttr isa CC.TemplateTypeParmType
    @test CC.is_template_type_parm_type(ttr) === true

    # SubstTemplateTypeParmType via an instantiated member
    sbrec = CC.getDecl(CC.resolve(canon(tpof("tmid_sbv"))))
    stp = CC.getTypePtr(CC.getType(first(CC.getFields(sbrec))))
    @test CC.is_subst_template_type_parm_type(stp) === true
    str = CC.resolve(stp)
    @test str isa CC.SubstTemplateTypeParmType
    @test CC.is_subst_template_type_parm_type(str) === true

    # SubstTemplateTypeParmPackType: only the generic probe is reachable
    @test CC.is_subst_template_type_parm_pack_type(tpof("tmid_g")) === false

    # TemplateSpecializationType
    tstp = unwrap(tpof("tmid_tpv"))
    @test CC.is_template_specialization_type(tstp) === true
    tst = CC.resolve(tstp)
    @test tst isa CC.TemplateSpecializationType
    @test CC.is_template_specialization_type(tst) === true
    @test CC.is_sugared(tst) isa Bool

    # ElaboratedType
    @test CC.is_elaborated_type(tpof("tmid_rc")) === true
    el = CC.resolve(tpof("tmid_rc"))
    @test el isa CC.ElaboratedType
    @test CC.is_elaborated_type(el) === true

    # DependentNameType
    dntp = unwrap(patfield("TmidDN"))
    @test CC.is_dependent_name_type(dntp) === true
    dnt = CC.resolve(dntp)
    @test dnt isa CC.DependentNameType
    @test CC.is_dependent_name_type(dnt) === true

    # DependentTemplateSpecializationType
    dtsp = unwrap(patfield("TmidS4"))
    @test CC.is_dependent_template_specilization_type(dtsp) === true
    dtt = CC.resolve(dtsp)
    @test dtt isa CC.DependentTemplateSpecializationType
    @test CC.is_dependent_template_specilization_type(dtt) === true

    # AtomicType via the ASTContext builder
    atomtp = CC.getTypePtr(CC.getAtomicType(ctx, CC.get_qual_type(CC.IntTy(ctx))))
    @test CC.is_atomic_type(atomtp) === true
    art = CC.resolve(atomtp)
    @test art isa CC.AtomicType
    @test CC.is_atomic_type(art) === true

    # AdjustedType / DecayedType via a decayed array parameter
    dfd = CC.FunctionDecl(getdecl("tmid_decay_fn").ptr)
    dtp = CC.getTypePtr(CC.getType(CC.getParamDecl(dfd, 0)))
    @test CC.is_adjusted_type(dtp) === true
    @test CC.is_decayed_type(dtp) === true
    dct = CC.resolve(dtp)
    @test dct isa CC.DecayedType
    @test CC.is_adjusted_type(dct) === true
    @test CC.is_decayed_type(dct) === true

    # InjectedClassNameType via the pattern's self pointer
    icp = CC.resolve(patfield("TmidIC"))
    @test icp isa CC.PointerType
    icin = unwrap(CC.getTypePtr(CC.get_pointee_type(icp)))
    @test CC.is_injected_class_name_type(icin) === true
    ict = CC.resolve(icin)
    @test ict isa CC.InjectedClassNameType
    @test CC.is_injected_class_name_type(ict) === true

    # MacroQualifiedType via a macro-spelled noderef attribute
    mqp = CC.resolve(tpof("tmid_mq"))
    @test mqp isa CC.PointerType
    mqtp = CC.getTypePtr(CC.get_pointee_type(mqp))
    @test CC.is_macro_qualified_type(mqtp) === true
    mqt = CC.resolve(mqtp)
    @test mqt isa CC.MacroQualifiedType
    @test CC.is_macro_qualified_type(mqt) === true

    # UnaryTransformType
    uttp = tpof("tmid_ut")
    @test CC.is_unary_transform_type(uttp) === true
    utt = CC.resolve(uttp)
    @test utt isa CC.UnaryTransformType
    @test CC.is_unary_transform_type(utt) === true

    # ParenType via a function pointer declarator
    pfp = CC.resolve(tpof("tmid_pf"))
    @test pfp isa CC.PointerType
    parentp = CC.getTypePtr(CC.get_pointee_type(pfp))
    @test CC.is_paren_type(parentp) === true
    prt = CC.resolve(parentp)
    @test prt isa CC.ParenType
    @test CC.is_paren_type(prt) === true

    # DependentAddressSpaceType via the pattern's pointer-to-address-space field
    dasptr = CC.resolve(patfield("TmidDAS"))
    @test dasptr isa CC.PointerType
    dastp = canon(CC.getTypePtr(CC.get_pointee_type(dasptr)))
    @test CC.is_dependent_address_space_type(dastp) === true
    dast = CC.resolve(dastp)
    @test dast isa CC.DependentAddressSpaceType
    @test CC.is_dependent_address_space_type(dast) === true

    # DependentSizedExtVectorType
    devtp = canon(patfield("TmidDEV"))
    @test CC.is_dependent_sized_ext_vector_type(devtp) === true
    devt = CC.resolve(devtp)
    @test devt isa CC.DependentSizedExtVectorType
    @test CC.is_dependent_sized_ext_vector_type(devt) === true

    # DecltypeType
    dctp = tpof("tmid_dc")
    @test CC.is_decltype_type(dctp) === true
    dclt = CC.resolve(dctp)
    @test dclt isa CC.DecltypeType
    @test CC.is_decltype_type(dclt) === true

    # DeducedType
    autp = tpof("tmid_au")
    @test CC.is_deduced_type(autp) === true
    dt = CC.getContainedDeducedType(autp)
    @test dt isa CC.DeducedType
    @test CC.is_deduced_type(dt) === true

    # DeducedTemplateSpecializationType via CTAD
    cttp = unwrap(tpof("tmid_ctv"))
    @test CC.is_deduced_template_specialization_type(cttp) === true
    ctt = CC.resolve(cttp)
    @test ctt isa CC.DeducedTemplateSpecializationType
    @test CC.is_deduced_template_specialization_type(ctt) === true

    # UnresolvedUsingType / UsingType
    uutp = unwrap(patfield("TmidUU"))
    @test CC.is_unresolved_using_type(uutp) === true
    ustp = unwrap(tpof("tmid_usv"))
    @test CC.is_using_type(ustp) === true

    # QualType qualifier helpers
    ciqt = qtof("tmid_ci")
    gqt = qtof("tmid_g")
    @test CC.is_const(ciqt) === true
    @test CC.is_restrict(ciqt) === false
    @test CC.is_volatile(ciqt) === false
    @test CC.has_qualifiers(ciqt) === true
    @test CC.is_local_const(ciqt) === true
    @test CC.is_local_restrict(ciqt) === false
    @test CC.is_local_volatile(ciqt) === false
    @test CC.has_local_qualifiers(ciqt) === true
    @test CC.is_const(CC.add_const(gqt)) === true
    @test CC.is_restrict(CC.add_restrict(gqt)) === true
    @test CC.is_volatile(CC.add_volatile(gqt)) === true
    @test CC.get_canonical_type(ciqt) isa CC.QualType

    CC.dispose(f)
    CC.dispose(I)
end
