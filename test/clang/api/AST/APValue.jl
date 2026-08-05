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

import ClangCompiler as CC
@testset "Coverage | ValueTypesMisc" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    src = """
    // APValue leaves
    constexpr int ci = 2 + 3;
    constexpr float cf = 1.5f;
    struct Pt { int x; int y; };
    constexpr Pt cpt = {7, 9};
    constexpr int carr[3] = {10, 20, 30};

    // NestedNameSpecifier flavours
    namespace A { namespace B { struct S {}; } }
    A::B::S nns_ab;
    struct Outer { struct Inner {}; };
    Outer::Inner nns_oi;
    namespace Shrt = A::B;
    Shrt::S nns_alias;
    template<typename T> struct Dep { typename T::foo::type m; };

    // Attr
    int __attribute__((aligned(16), deprecated)) gattr;
    int noattr;

    // Mangle / DeclarationName / DeclGroup
    int add(int a, int b) { return a + b; }
    const char *g_str = "hello";

    // TemplateArgument specialisations
    template<typename T, int N> struct STempl { T x; };
    STempl<int,3> stempl_obj;
    template<class> struct Holder {};
    template<template<class> class TT> struct UsesTT {};
    UsesTT<Holder> usett_obj;
    int gx;
    """
    CC.parse(I, src)

    varof(name) = (@test f(I, name); CC.VarDecl(get_decl(f).ptr))
    tst_of(vd) = begin
        t = CC.resolve(CC.getTypePtr(CC.getType(vd)))
        t isa CC.ElaboratedType && (t = CC.resolve(CC.getTypePtr(CC.getNamedType(t))))
        return t
    end

    # ---------- APValue ----------
    vd_ci = varof("ci")
    av_int = CC.evaluateValue(vd_ci)
    @test av_int.ptr != C_NULL
    @test CC.getKind(av_int) == CC.LibClangEx.CXAPValueKind_Int
    @test CC.isInt(av_int)
    @test !CC.isFloat(av_int)
    @test !CC.isArray(av_int)
    @test !CC.isStruct(av_int)
    gv_i = CC.LLVM.GenericValue(CC.getInt(av_int))
    @test convert(Int, gv_i) == 5

    vd_cf = varof("cf")
    av_flt = CC.evaluateValue(vd_cf)
    @test CC.getKind(av_flt) == CC.LibClangEx.CXAPValueKind_Float
    @test CC.isFloat(av_flt)
    gv_f = CC.LLVM.GenericValue(CC.getFloat(av_flt))
    @test CC.LLVM.intwidth(gv_f) == 32
    @test reinterpret(Float32, convert(UInt32, gv_f)) == 1.5f0
    CC.LLVM.dispose(gv_f)

    vd_carr = varof("carr")
    av_arr = CC.evaluateValue(vd_carr)
    @test av_arr.ptr != C_NULL
    @test CC.isArray(av_arr)
    @test CC.getKind(av_arr) == CC.LibClangEx.CXAPValueKind_Array
    @test CC.getArraySize(av_arr) == 3
    @test CC.getArrayInitializedElts(av_arr) == 3
    for (i, expected) in enumerate([10, 20, 30])
        elt = CC.getArrayInitializedElt(av_arr, i - 1)
        @test elt.ptr != C_NULL
        @test CC.isInt(elt)
        gv_elt = CC.LLVM.GenericValue(CC.getInt(elt))
        @test convert(Int, gv_elt) == expected
        CC.LLVM.dispose(gv_elt)
    end

    vd_cpt = varof("cpt")
    av_struct = CC.evaluateValue(vd_cpt)
    @test av_struct.ptr != C_NULL
    @test CC.isStruct(av_struct)
    @test CC.getKind(av_struct) == CC.LibClangEx.CXAPValueKind_Struct
    @test CC.getStructNumFields(av_struct) == 2
    @test CC.getStructNumBases(av_struct) == 0
    fld0 = CC.getStructField(av_struct, 0)
    @test fld0.ptr != C_NULL
    @test CC.isInt(fld0)
    gv_f0 = CC.LLVM.GenericValue(CC.getInt(fld0))
    @test convert(Int, gv_f0) == 7
    CC.LLVM.dispose(gv_f0)

    fld1 = CC.getStructField(av_struct, 1)
    @test fld1.ptr != C_NULL
    @test CC.isInt(fld1)
    gv_f1 = CC.LLVM.GenericValue(CC.getInt(fld1))
    @test convert(Int, gv_f1) == 9
    CC.LLVM.dispose(gv_f1)

    # APValue::dispose on an owned value (EvaluateAsRValue result).
    av_owned = CC.EvaluateAsRValue(CC.getInit(vd_ci), ctx)
    @test av_owned.ptr != C_NULL
    CC.dispose(av_owned)

    # ---------- NestedNameSpecifier ----------
    exercise_nns(nns; is_dep::Bool=false, expected_kind=nothing, expected_name::Union{String, Nothing}=nothing) = begin
        @test nns isa CC.NestedNameSpecifier
        if expected_kind !== nothing
            @test CC.getKind(nns) == expected_kind
        end
        @test CC.isDependent(nns) == is_dep
        @test CC.isInstantiationDependent(nns) == is_dep
        @test !(CC.containsUnexpandedParameterPack(nns))
        @test !(CC.containsErrors(nns))
        if expected_name !== nothing
            @test CC.getName(nns) == expected_name
        end
        CC.dump(nns)
        k = CC.getKind(nns)
        if k == CC.LibClangEx.CXNestedNameSpecifierKind_Namespace
            @test !CC.is_null_handle(CC.getAsNamespace(nns))
        elseif k == CC.LibClangEx.CXNestedNameSpecifierKind_NamespaceAlias
            @test !CC.is_null_handle(CC.getAsNamespaceAlias(nns))
        elseif k == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpec ||
               k == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpecWithTemplate
            @test !CC.is_null_handle(CC.getAsType(nns))
            @test !CC.is_null_handle(CC.getAsRecordDecl(nns))
        elseif k == CC.LibClangEx.CXNestedNameSpecifierKind_Identifier
            @test !CC.is_null_handle(CC.getAsIdentifier(nns))
        end
    end

    ety_ab = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_ab"))))
    @test ety_ab isa CC.ElaboratedType
    nns_ab = CC.getQualifier(ety_ab)               # Namespace (B), prefix Namespace (A)
    exercise_nns(nns_ab; is_dep=false, expected_kind=CC.LibClangEx.CXNestedNameSpecifierKind_Namespace, expected_name="A::B::")
    exercise_nns(CC.getPrefix(nns_ab); is_dep=false, expected_kind=CC.LibClangEx.CXNestedNameSpecifierKind_Namespace, expected_name="A::")

    ety_oi = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_oi"))))
    exercise_nns(CC.getQualifier(ety_oi); is_dep=false, expected_kind=CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpec, expected_name="struct Outer::")

    ety_al = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_alias"))))
    exercise_nns(CC.getQualifier(ety_al); is_dep=false, expected_kind=CC.LibClangEx.CXNestedNameSpecifierKind_NamespaceAlias, expected_name="Shrt::")

    # Dependent identifier NNS from `typename T::foo::type`.
    @test f(I, "Dep")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    patt = CC.getTemplatedDecl(ctd)
    for fld in CC.getFields(patt)
        dnt = CC.resolve(CC.getTypePtr(CC.getType(fld)))
        if dnt isa CC.DependentNameType
            exercise_nns(CC.getQualifier(dnt); is_dep=true, expected_kind=CC.LibClangEx.CXNestedNameSpecifierKind_Identifier, expected_name="T::foo::")
        end
    end

    # ---------- Attr ----------
    @test f(I, "gattr")
    attrs = CC.getAttrs(get_decl(f))
    @test length(attrs) == 2
    @test [CC.getKind(a) for a in attrs] == [CC.LibClangEx.CXAttrKind_Aligned, CC.LibClangEx.CXAttrKind_Deprecated]
    @test [CC.getSpelling(a) for a in attrs] == ["aligned", "deprecated"]
    for a in attrs
        @test !CC.is_null_handle(CC.getLocation(a))
        @test !(CC.isImplicit(a))
        @test !(CC.isInherited(a))
        @test !(CC.isPackExpansion(a))
    end

    # ---------- MangleContext ----------
    mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    @test mc isa CC.MangleContext
    @test CC.getKind(mc) == CC.LibClangEx.CXMangleContext_MK_Itanium
    @test !CC.is_null_handle(CC.getASTContext(mc))
    @test !CC.is_null_handle(CC.getDiags(mc))
    @test f(I, "add")
    add_nd = CC.NamedDecl(get_decl(f).ptr)
    @test CC.shouldMangleDeclName(mc, add_nd) == true
    @test CC.shouldMangleCXXName(mc, add_nd) == true
    @test CC.mangleName(mc, add_nd) == "_Z3addii"
    @test f(I, "Pt")
    pt_nd = CC.NamedDecl(get_decl(f).ptr)
    @test CC.getAnonymousStructId(mc, pt_nd) == 0

    # ---------- StringLiteral for shouldMangleStringLiteral ----------
    vd_str = varof("g_str")
    sl = nothing
    for n in CC.subtree(CC.resolve(CC.getInit(vd_str)))
        n isa CC.StringLiteral && (sl = n; break)
    end
    @test sl isa CC.StringLiteral
    @test !CC.shouldMangleStringLiteral(mc, sl)

    # ---------- DeclarationName ----------
    dn_empty = CC.DeclarationName()
    @test CC.isEmpty(dn_empty)
    @test isempty(CC.getAsString(dn_empty))
    CC.dump(dn_empty)

    dn_add = CC.getDeclName(add_nd)
    @test dn_add isa CC.DeclarationName
    @test !CC.isEmpty(dn_add)
    @test CC.getAsString(dn_add) == "add"
    CC.dump(dn_add)

    ii = CC.getIdentifier(add_nd)
    dn_ii = CC.DeclarationName(ii)
    @test CC.getAsString(dn_ii) == "add"

    # ---------- DeclarationNameInfo ----------
    loc = CC.getLocation(add_nd)
    dni = CC.DeclarationNameInfo(dn_add, loc)
    @test dni isa CC.DeclarationNameInfo
    @test CC.getName(dni) isa CC.DeclarationName
    @test !CC.is_null_handle(CC.getLoc(dni))
    @test !CC.is_null_handle(CC.getBeginLoc(dni))
    @test !CC.is_null_handle(CC.getEndLoc(dni))
    @test CC.getAsString(dni) == "add"
    CC.dispose(dni)

    # ---------- DeclGroupRef ----------
    @test f(I, "add")
    dgr = CC.DeclGroupRef(CC.Decl(get_decl(f).ptr))   # DeclGroupRef(x::Decl) wants the exact Decl carrier
    @test !CC.isNull(dgr)
    @test CC.isSingleDecl(dgr)
    @test !CC.isDeclGroup(dgr)
    @test !CC.is_null_handle(CC.getSingleDecl(dgr))

    # ---------- TemplateArgument (real specialisation args) ----------
    exercise_targ(ta) = begin
        @test ta isa CC.TemplateArgument
        k = CC.getKind(ta)
        @test k != CC.LibClangEx.CXTemplateArgument_Null
        @test !(CC.isNull(ta))
        @test !(CC.isDependent(ta))
        @test !(CC.isInstantiationDependent(ta))
        CC.dump(ta)
        if k == CC.LibClangEx.CXTemplateArgument_Type
            @test !CC.is_null_handle(CC.getAsType(ta))
        elseif k == CC.LibClangEx.CXTemplateArgument_Integral
            @test !CC.is_null_handle(CC.getIntegralType(ta))
            gv = CC.LLVM.GenericValue(CC.getAsIntegral(ta))
            @test convert(Int, gv) == 3
            CC.LLVM.dispose(gv)
        elseif k == CC.LibClangEx.CXTemplateArgument_Template
            @test !CC.is_null_handle(CC.getAsTemplate(ta))
            @test !CC.is_null_handle(CC.getAsTemplateOrTemplatePattern(ta))
        end
    end

    tst = tst_of(varof("stempl_obj"))
    @test tst isa CC.TemplateSpecializationType
    @test CC.getNumArgs(tst) == 2
    for i in 0:(CC.getNumArgs(tst) - 1)
        exercise_targ(CC.getArg(tst, i))
    end

    # The arguments of a TemplateSpecializationType are the ones as written, so the `3` of
    # `STempl<int,3>` arrives as an Expression. Clang evaluates it only into the
    # specialisation's own argument list, which is where the Integral arm is reachable.
    stempl_rec = CC.resolve(CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(varof("stempl_obj")))))
    @test stempl_rec isa CC.ClassTemplateSpecializationDecl
    conv_args = CC.getTemplateArgs(stempl_rec)
    n_conv = Int(size(conv_args))
    @test n_conv == 2
    kinds = CC.LibClangEx.CXTemplateArgument_ArgKind[]
    for i in 0:(n_conv - 1)
        arg = get(conv_args, i)
        push!(kinds, CC.getKind(arg))
        exercise_targ(arg)
    end
    @test CC.LibClangEx.CXTemplateArgument_Integral in kinds
    @test CC.LibClangEx.CXTemplateArgument_Type in kinds

    tst2 = tst_of(varof("usett_obj"))
    if tst2 isa CC.TemplateSpecializationType
        for i in 0:(CC.getNumArgs(tst2) - 1)
            exercise_targ(CC.getArg(tst2, i))
        end
    end

    # ---------- TemplateArgument (owned constructor paths) ----------
    int_qt = CC.getType(vd_ci)                    # `const int`

    ta_type = CC.TemplateArgument(int_qt)
    @test CC.getKind(ta_type) == CC.LibClangEx.CXTemplateArgument_Type
    @test !CC.is_null_handle(CC.getAsType(ta_type))
    @test !(CC.isNull(ta_type))
    @test !(CC.isDependent(ta_type))
    @test !(CC.isInstantiationDependent(ta_type))
    CC.dump(ta_type)
    CC.dispose(ta_type)

    # Integral, from the constexpr int's GenericValue.
    ta_int = CC.TemplateArgument(ctx, gv_i, int_qt)
    @test CC.getKind(ta_int) == CC.LibClangEx.CXTemplateArgument_Integral
    gv_back = CC.LLVM.GenericValue(CC.getAsIntegral(ta_int))
    @test convert(Int, gv_back) == 5
    CC.LLVM.dispose(gv_back)
    @test !CC.is_null_handle(CC.getIntegralType(ta_int))
    CC.setIntegralType(ta_int, int_qt)
    @test !CC.is_null_handle(CC.getIntegralType(ta_int))
    CC.dispose(ta_int)
    CC.LLVM.dispose(gv_i)

    # NullPtr, via constructFromQualType(isNullPtr=true) on a pointer type.
    ptr_qt = CC.getType(vd_str)                   # const char *
    ta_null = CC.TemplateArgument(ptr_qt, true)
    @test CC.getKind(ta_null) == CC.LibClangEx.CXTemplateArgument_NullPtr
    @test !CC.is_null_handle(CC.getNullPtrType(ta_null))
    CC.dispose(ta_null)

    # Declaration, via constructFromValueDecl on the `gx` global.
    @test f(I, "gx")
    vd_gx = CC.VarDecl(get_decl(f).ptr)
    ta_decl = CC.TemplateArgument(CC.ValueDecl(vd_gx.ptr), CC.getType(vd_gx))
    @test CC.getKind(ta_decl) == CC.LibClangEx.CXTemplateArgument_Declaration
    @test !CC.is_null_handle(CC.getAsDecl(ta_decl))
    @test !CC.is_null_handle(CC.getParamTypeForDecl(ta_decl))
    CC.dispose(ta_decl)

    dispose(f)
    dispose(I)
end

@testset "Coverage | APValue payload + mangler tail" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    src = """
    constexpr int pv_int = 5;
    constexpr int pv_arr[3] = {10, 20, 30};
    constexpr const int *pv_ptr = &pv_arr[1];
    constexpr const int *pv_null = nullptr;
    constexpr _Complex int pv_cint = 3;
    constexpr _Complex double pv_cdouble = 1.5;
    struct PvS { int m; };
    constexpr int PvS::*pv_memptr = &PvS::m;
    """
    CC.parse(I, src)

    valueof(name) = (@test f(I, name); CC.evaluateValue(CC.VarDecl(get_decl(f).ptr)))

    # needsCleanup is total: false for a small integer leaf, true for an aggregate.
    v_int = valueof("pv_int")
    @test !CC.needsCleanup(v_int)
    v_arr = valueof("pv_arr")
    @test CC.isArray(v_arr)
    @test CC.needsCleanup(v_arr)

    # Complex leaves ride the GenericValue bridge; the float halves carry raw bits.
    v_ci = valueof("pv_cint")
    @test CC.isComplexInt(v_ci)
    gv = CC.LLVM.GenericValue(CC.getComplexIntReal(v_ci))
    @test convert(Int, gv) == 3
    CC.LLVM.dispose(gv)
    gv = CC.LLVM.GenericValue(CC.getComplexIntImag(v_ci))
    @test convert(Int, gv) == 0
    CC.LLVM.dispose(gv)

    v_cf = valueof("pv_cdouble")
    @test CC.isComplexFloat(v_cf)
    gv = CC.LLVM.GenericValue(CC.getComplexFloatReal(v_cf))
    @test CC.LLVM.intwidth(gv) == 64
    @test reinterpret(Float64, convert(UInt64, gv)) == 1.5
    CC.LLVM.dispose(gv)
    gv = CC.LLVM.GenericValue(CC.getComplexFloatImag(v_cf))
    @test reinterpret(Float64, convert(UInt64, gv)) == 0.0
    CC.LLVM.dispose(gv)

    # LValue payload. Offset/call-index/version evaluations.
    v_ptr = valueof("pv_ptr")
    @test CC.isLValue(v_ptr)
    @test CC.getLValueOffset(v_ptr) == 4
    @test !CC.isLValueOnePastTheEnd(v_ptr)
    @test CC.hasLValuePath(v_ptr)
    @test CC.getLValueCallIndex(v_ptr) == 0
    @test CC.getLValueVersion(v_ptr) == 0
    @test !CC.isNullPointer(v_ptr)

    v_null = valueof("pv_null")
    @test CC.isLValue(v_null)
    @test CC.isNullPointer(v_null)
    @test CC.getLValueOffset(v_null) == 0

    # Member-pointer payload.
    v_mp = valueof("pv_memptr")
    @test CC.isMemberPointer(v_mp)
    @test !CC.is_null_handle(CC.getMemberPointerDecl(v_mp))
    @test CC.getMemberPointerDecl(v_mp).ptr != C_NULL
    @test !CC.isMemberPointerToDerivedMember(v_mp)

    # No portable source produces an AddrLabelDiff value, so the address-of-label
    # accessors are exercised through the preconditions they restate instead.
    @test_throws AssertionError CC.getAddrLabelDiffLHS(v_int)
    @test_throws AssertionError CC.getAddrLabelDiffRHS(v_int)
    @test_throws AssertionError CC.getComplexIntReal(v_int)
    @test_throws AssertionError CC.getLValueOffset(v_int)
    @test_throws AssertionError CC.getMemberPointerDecl(v_int)

    dispose(f)
    dispose(I)
end

@testset "APValue lvalue base/path navigation and TemplateArgument pack construction" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    src = """
    constexpr int rv_int = 7;
    constexpr int rv_arr[3] = {1, 2, 3};
    constexpr const int *rv_ptr = &rv_arr[2];
    constexpr const int *rv_null = nullptr;
    struct RvB { int b; };
    struct RvD : RvB { int d; };
    constexpr int RvB::*rv_mp_base = &RvB::b;
    constexpr int RvD::*rv_mp_derived = rv_mp_base;
    template <typename... RTs> struct RPack { };
    template <typename... RUs> struct RFwd { RPack<RUs...> m; };
    template <typename RT> struct RBox { };
    template <template <typename> class RTT = RBox> struct RHolder { };
    """
    CC.parse(I, src)

    vardecl(name) = (@test f(I, name); CC.VarDecl(get_decl(f).ptr))

    # The lvalue base designator: &rv_arr[2] is based on the rv_arr VarDecl arm.
    vd_ptr = vardecl("rv_ptr")
    v_ptr = CC.evaluateValue(vd_ptr)
    @test CC.isLValue(v_ptr)
    @test !CC.isLValueBaseNull(v_ptr)
    base_vd = CC.getLValueBaseAsValueDecl(v_ptr)
    @test base_vd isa CC.ValueDecl
    @test base_vd.ptr != C_NULL
    @test CC.getName(base_vd) == "rv_arr"
    @test CC.getLValueBaseAsExpr(v_ptr).ptr == C_NULL
    @test CC.getLValueBaseType(v_ptr).ptr != C_NULL

    # ... and its one-entry designator path, whose entry is the source-level index.
    @test CC.getLValuePathLength(v_ptr) == 1
    @test CC.getLValuePathAsArrayIndex(v_ptr, 0) == 2
    @test_throws AssertionError CC.getLValuePathAsArrayIndex(v_ptr, 1)

    vd_null = vardecl("rv_null")
    v_null = CC.evaluateValue(vd_null)
    @test CC.isLValueBaseNull(v_null)
    @test CC.getLValueBaseAsValueDecl(v_null).ptr == C_NULL
    @test CC.getLValueBaseType(v_null).ptr == C_NULL
    # a null pointer still carries a designator path — an empty one
    @test CC.hasLValuePath(v_null)
    @test CC.getLValuePathLength(v_null) == 0

    # The member-pointer class chain: empty for &RvB::b, non-empty once the pointer
    # has been converted to a pointer to a member of the derived class.
    v_mpb = CC.evaluateValue(vardecl("rv_mp_base"))
    @test CC.isMemberPointer(v_mpb)
    @test CC.getMemberPointerPathSize(v_mpb) == 0
    @test_throws AssertionError CC.getMemberPointerPathEntry(v_mpb, 0)

    v_mpd = CC.evaluateValue(vardecl("rv_mp_derived"))
    @test CC.isMemberPointer(v_mpd)
    # the class chain is what the base-to-derived conversion records; clang's
    # IsDerivedMember flag stays false for it, so only the path length distinguishes
    # rv_mp_derived from rv_mp_base
    @test !(CC.isMemberPointerToDerivedMember(v_mpd))
    @test CC.getMemberPointerPathSize(v_mpd) == 1
    @test CC.getName(CC.getMemberPointerPathEntry(v_mpd, 0)) == "RvD"
    @test CC.getMemberPointerPathEntry(v_mpd, 0).ptr != C_NULL

    # toIntegralConstant: the integer path ignores src_ty, the null-pointer path runs
    # it through the target's null pointer value, and a based lvalue has no integral form.
    vd_int = vardecl("rv_int")
    v_int = CC.evaluateValue(vd_int)
    gvr = CC.toIntegralConstant(v_int, CC.getType(vd_int), ctx)
    @test gvr != C_NULL
    gv = CC.LLVM.GenericValue(gvr)
    @test convert(Int, gv) == 7
    CC.LLVM.dispose(gv)

    gvr_null = CC.toIntegralConstant(v_null, CC.getType(vd_null), ctx)
    @test gvr_null != C_NULL
    CC.LLVM.dispose(CC.LLVM.GenericValue(gvr_null))
    @test CC.toIntegralConstant(v_ptr, CC.getType(vd_ptr), ctx) == C_NULL

    # An owned indeterminate value, swapped against an owned evaluated one.
    indet = CC.IndeterminateValue()
    @test CC.isIndeterminate(indet)
    @test !CC.hasValue(indet)
    owned = CC.EvaluateAsRValue(CC.getInit(vd_int), ctx)
    @test CC.isInt(owned)
    CC.swap(indet, owned)
    @test CC.isInt(indet)
    @test CC.isIndeterminate(owned)
    dispose(indet)
    dispose(owned)

    # A pack copied into the ASTContext arena, and the empty pack.
    a0 = CC.TemplateArgument(CC.getType(vd_int))
    a1 = CC.TemplateArgument(CC.getType(vardecl("rv_arr")))
    pack = CC.CreatePackCopy(ctx, [a0, a1])
    @test pack isa CC.TemplateArgument
    @test CC.getKind(pack) == CC.LibClangEx.CXTemplateArgument_Pack
    @test CC.pack_size(pack) == 2
    @test CC.getKind(CC.getPackElement(pack, 0)) == CC.LibClangEx.CXTemplateArgument_Type
    dispose(pack)

    empty_pack = CC.getEmptyPack()
    @test CC.getKind(empty_pack) == CC.LibClangEx.CXTemplateArgument_Pack
    @test CC.pack_size(empty_pack) == 0
    dispose(empty_pack)

    # No portable source produces a StructuralValue argument, so those accessors are
    # exercised through the kind preconditions they restate.
    @test_throws AssertionError CC.getAsStructuralValue(a0)
    @test_throws AssertionError CC.getStructuralValueType(a0)
    @test_throws AssertionError CC.getPackExpansionPattern(a0)
    dispose(a0)
    dispose(a1)

    # RPack<RUs...> inside the RFwd pattern carries a pack-expansion type argument.
    @test f(I, "RFwd")
    rfwd = CC.ClassTemplateDecl(get_decl(f).ptr)
    rfwd_patt = CC.CXXRecordDecl(CC.getTemplatedDecl(rfwd).ptr)
    fld = first(CC.getFields(rfwd_patt))
    fty = CC.resolve(CC.getTypePtr(CC.getType(fld)))
    fty isa CC.ElaboratedType && (fty = CC.resolve(CC.getTypePtr(CC.getNamedType(fty))))
    @test fty isa CC.TemplateSpecializationType
    parg = CC.getArg(fty, 0)
    @test CC.isPackExpansion(parg)
    patt = CC.getPackExpansionPattern(parg)
    @test patt isa CC.TemplateArgument
    @test CC.getKind(patt) == CC.LibClangEx.CXTemplateArgument_Type
    dispose(patt)

    # The remaining TemplateArgumentLoc source-expression accessors: a Template-kind
    # argument satisfies none of their kind preconditions.
    @test f(I, "RHolder")
    rholder = CC.ClassTemplateDecl(get_decl(f).ptr)
    rttp = CC.TemplateTemplateParmDecl(CC.getParam(CC.getTemplateParameters(rholder), 0).ptr)
    @test CC.hasDefaultArgument(rttp)
    tal = CC.getDefaultArgument(rttp)
    @test CC.getKind(CC.getArgument(tal)) == CC.LibClangEx.CXTemplateArgument_Template
    @test_throws AssertionError CC.getSourceDeclExpression(tal)
    @test_throws AssertionError CC.getSourceNullPtrExpression(tal)
    @test_throws AssertionError CC.getSourceIntegralExpression(tal)
    @test_throws AssertionError CC.getSourceStructuralValueExpression(tal)

    dispose(f)
    dispose(I)
end

@testset "Coverage | TemplateArgumentListInfo and the lvalue-base union arms" begin
    I = create_interpreter(["-std=c++17"])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    CC.parse(I, """
             template <typename TLIT> struct TLIBox { };
             template <template <typename> class TLITT = TLIBox> struct TLIHolder { };
             constexpr int tli_arr[2] = {7, 9};
             constexpr const int *tli_ptr = &tli_arr[1];
             constexpr int tli_int = 5;
             """)

    # A Template-kind TemplateArgumentLoc to feed the builder with. Selecting by kind
    # keeps the lookup unambiguous even though the testset instantiates a template.
    @test f(I, "TLIHolder")
    holder = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f)
                                        if getDeclKindName(d) == "ClassTemplate").ptr)
    ttp = CC.TemplateTemplateParmDecl(CC.getParam(CC.getTemplateParameters(holder), 0).ptr)
    @test CC.hasDefaultArgument(ttp)
    tal = CC.getDefaultArgument(ttp)
    @test tal isa CC.TemplateArgumentLoc
    @test CC.getKind(CC.getArgument(tal)) == CC.LibClangEx.CXTemplateArgument_Template

    # getTemplateQualifierLoc is total, so the specifier is a carrier for every kind.
    @test CC.is_null_handle(CC.getTemplateQualifier(tal))

    # The builder list starts empty and remembers the two delimiters it was handed.
    lb = CC.getBeginLoc(holder)
    le = CC.getEndLoc(holder)
    @test lb.ptr != le.ptr
    li = CC.TemplateArgumentListInfo(lb, le)
    @test li isa CC.TemplateArgumentListInfo
    @test li.ptr != C_NULL
    @test CC.size(li) == 0
    @test CC.getLAngleLoc(li).ptr == lb.ptr
    @test CC.getRAngleLoc(li).ptr == le.ptr
    @test_throws AssertionError CC.getArgument(li, 0)

    # ... and the setters swap them back out.
    CC.setLAngleLoc(li, le)
    CC.setRAngleLoc(li, lb)
    @test CC.getLAngleLoc(li).ptr == le.ptr
    @test CC.getRAngleLoc(li).ptr == lb.ptr

    # addArgument appends a copy; size and the index accessor follow it.
    CC.addArgument(li, tal)
    @test CC.size(li) == 1
    a0 = CC.getArgument(li, 0)
    @test a0 isa CC.TemplateArgumentLoc
    @test CC.getKind(CC.getArgument(a0)) == CC.LibClangEx.CXTemplateArgument_Template
    CC.addArgument(li, tal)
    @test CC.size(li) == 2
    @test_throws AssertionError CC.getArgument(li, 2)

    # ... and the arena-allocated copy reproduces the whole list.
    astli = CC.ASTTemplateArgumentListInfo(ctx, li)
    @test astli isa CC.ASTTemplateArgumentListInfo
    @test astli.ptr != C_NULL
    @test CC.getNumTemplateArgs(astli) == 2
    @test CC.getLAngleLoc(astli).ptr == le.ptr
    @test CC.getRAngleLoc(astli).ptr == lb.ptr
    @test CC.getKind(CC.getArgument(CC.getTemplateArg(astli, 0))) ==
          CC.LibClangEx.CXTemplateArgument_Template
    dispose(li)

    # The two arms of the lvalue base's union that only exist mid-fold: a completed
    # constant designates neither, so both predicates read false and every payload
    # accessor rejects the call through the precondition it restates.
    @test f(I, "tli_ptr")
    v_ptr = CC.evaluateValue(CC.VarDecl(get_decl(f).ptr))
    @test CC.isLValue(v_ptr)
    @test CC.isLValueBaseTypeInfo(v_ptr) == false
    @test CC.isLValueBaseDynamicAlloc(v_ptr) == false
    @test_throws AssertionError CC.getLValueBaseTypeInfoOperand(v_ptr)
    @test_throws AssertionError CC.getLValueBaseTypeInfoType(v_ptr)
    @test_throws AssertionError CC.getLValueBaseDynamicAllocIndex(v_ptr)
    @test_throws AssertionError CC.getLValueBaseDynamicAllocType(v_ptr)

    # ... and the arm predicates are themselves lvalue-only.
    @test f(I, "tli_int")
    v_int = CC.evaluateValue(CC.VarDecl(get_decl(f).ptr))
    @test CC.isInt(v_int)
    @test_throws AssertionError CC.isLValueBaseTypeInfo(v_int)
    @test_throws AssertionError CC.isLValueBaseDynamicAlloc(v_int)

    # The index bound is a pure static of the dynamic-allocation encoding.
    @test CC.getMaxIndex() == 536870910

    dispose(f)
    dispose(I)
end

@testset "APValue profiles, designator entries and leaf mutators; comment array setters" begin
    # --- APValue: Profile hashes, base-or-member path entries, leaf mutators ---
    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    CC.parse(I, """
             struct ApvS { int m; int n; };
             union ApvU { int a; double b; };
             constexpr ApvS apv_s{1, 2};
             constexpr ApvU apv_u{7};
             constexpr int apv_three = 3;
             constexpr int apv_five = 5;
             constexpr int apv_seven = 7;
             constexpr double apv_d1 = 1.5;
             constexpr double apv_d2 = 2.5;
             constexpr _Complex int apv_ci1 = 3;
             constexpr _Complex int apv_ci2 = 9;
             constexpr _Complex double apv_cd1 = 1.5;
             constexpr _Complex double apv_cd2 = 4.25;
             constexpr const int *apv_pn = &apv_s.n;
             constexpr const int *apv_pn2 = &apv_s.n;
             constexpr const int *apv_pm = &apv_s.m;
             """)
    # VarDecl::evaluateValue caches its result in the decl, so every value here is
    # borrowed and none is disposed; the mutators below rewrite those cached leaves.
    cached(name) = (@test f(I, name); CC.evaluateValue(CC.VarDecl(get_decl(f).ptr)))

    av3, av5, av7 = cached("apv_three"), cached("apv_five"), cached("apv_seven")
    @test CC.isInt(av5) && CC.isInt(av7)
    @test CC.getProfileHash(av5) > 0
    @test CC.getProfileHash(av5) != CC.getProfileHash(av7)

    # setInt overwrites the leaf in place, so feeding av5 the bits of av7 makes the two
    # profiles identical — equal profiles always hash equal.
    gv7 = CC.getInt(av7)
    CC.setInt(av5, gv7, false)
    CC.LLVM.dispose(CC.LLVM.GenericValue(gv7))
    back = CC.LLVM.GenericValue(CC.getInt(av5))
    @test convert(Int, back) == 7
    CC.LLVM.dispose(back)
    @test CC.getProfileHash(av5) == CC.getProfileHash(av7)

    # setFloat rebuilds the APFloat from the value's own semantics plus the raw bits.
    avd1, avd2 = cached("apv_d1"), cached("apv_d2")
    @test CC.isFloat(avd1) && CC.isFloat(avd2)
    gvd2 = CC.getFloat(avd2)
    CC.setFloat(avd1, gvd2)
    CC.LLVM.dispose(CC.LLVM.GenericValue(gvd2))
    backf = CC.LLVM.GenericValue(CC.getFloat(avd1))
    @test reinterpret(Float64, convert(UInt64, backf)) == 2.5
    CC.LLVM.dispose(backf)

    avci1, avci2 = cached("apv_ci1"), cached("apv_ci2")
    @test CC.isComplexInt(avci1) && CC.isComplexInt(avci2)
    r_i, i_i = CC.getComplexIntReal(avci2), CC.getComplexIntImag(avci2)
    CC.setComplexInt(avci1, r_i, i_i, false)
    CC.LLVM.dispose(CC.LLVM.GenericValue(r_i))
    CC.LLVM.dispose(CC.LLVM.GenericValue(i_i))
    backci = CC.LLVM.GenericValue(CC.getComplexIntReal(avci1))
    @test convert(Int, backci) == 9
    CC.LLVM.dispose(backci)

    avcd1, avcd2 = cached("apv_cd1"), cached("apv_cd2")
    @test CC.isComplexFloat(avcd1) && CC.isComplexFloat(avcd2)
    r_f, i_f = CC.getComplexFloatReal(avcd2), CC.getComplexFloatImag(avcd2)
    CC.setComplexFloat(avcd1, r_f, i_f)
    CC.LLVM.dispose(CC.LLVM.GenericValue(r_f))
    CC.LLVM.dispose(CC.LLVM.GenericValue(i_f))
    backcd = CC.LLVM.GenericValue(CC.getComplexFloatReal(avcd1))
    @test reinterpret(Float64, convert(UInt64, backcd)) == 4.25
    CC.LLVM.dispose(backcd)

    # setUnion keeps the active member and replaces only the payload.
    avu = cached("apv_u")
    @test CC.isUnion(avu)
    fld = CC.getUnionField(avu)
    @test fld.ptr != C_NULL
    before = CC.LLVM.GenericValue(CC.getInt(CC.getUnionValue(avu)))
    @test convert(Int, before) == 7
    CC.LLVM.dispose(before)
    CC.setUnion(avu, fld, av3)
    @test CC.getUnionField(avu).ptr == fld.ptr
    after = CC.LLVM.GenericValue(CC.getInt(CC.getUnionValue(avu)))
    @test convert(Int, after) == 3
    CC.LLVM.dispose(after)

    # A designator path entry read as the member it names, rather than as an array index.
    avpn, avpn2, avpm = cached("apv_pn"), cached("apv_pn2"), cached("apv_pm")
    @test CC.isLValue(avpn)
    @test CC.hasLValuePath(avpn)
    @test CC.getLValuePathLength(avpn) >= 1
    d = CC.getLValuePathAsBaseOrMember(avpn, 0)
    @test d isa CC.Decl
    @test CC.getDeclKindName(d) == "Field"
    @test !CC.isLValuePathBaseOrMemberVirtual(avpn, 0)
    @test CC.getLValuePathEntryProfileHash(avpn, 0) > 0

    # Two pointers written to the same member of the same object have the same profile,
    # the same base and the same path entry; one to a different member shares only the base.
    @test CC.getProfileHash(avpn2) == CC.getProfileHash(avpn)
    @test CC.getLValuePathEntryProfileHash(avpn2, 0) == CC.getLValuePathEntryProfileHash(avpn, 0)
    @test CC.getLValueBaseProfileHash(avpn2) == CC.getLValueBaseProfileHash(avpn)
    @test CC.getLValueBaseProfileHash(avpm) == CC.getLValueBaseProfileHash(avpn)
    dispose(I)

    # --- Comment: the Attribute/Argument array setters round-trip through the arena ---
    J = create_interpreter()
    CC.parse(J, """
             /// \\brief Adds <a href="ref">two</a> numbers.
             /// \\param a the first addend
             int apv_doc_add(int a, int b) { return a + b; }
             """)
    jctx = CC.get_ast_context(J)
    jpp = CC.getPreprocessor(CC.get_instance(J))
    g = DeclFinder(J)
    @test g(J, "apv_doc_add")
    fc = CC.getCommentForDecl(jctx, get_decl(g), jpp)
    @test fc isa CC.FullComment

    # child_count is an unsigned C count: widen it before building a range, or a childless
    # node turns `0:(n - 1)` into a 2^32-long loop.
    nchild(c) = Int(CC.child_count(c))
    nodes = CC.Comment[]
    queue = CC.Comment[CC.getChild(fc, i) for i = 0:(nchild(fc) - 1)]
    while !isempty(queue)
        c = popfirst!(queue)
        push!(nodes, c)
        append!(queue, CC.Comment[CC.getChild(c, i) for i = 0:(nchild(c) - 1)])
    end
    @test !isempty(nodes)

    tags = filter(h -> h.ptr != C_NULL, [CC.HTMLStartTagComment(c) for c in nodes])
    @test !isempty(tags)
    h = first(tags)
    na = Int(CC.getNumAttrs(h))
    @test na >= 1
    names = String[CC.getAttrName(h, k) for k = 0:(na - 1)]
    values = String[CC.getAttrValue(h, k) for k = 0:(na - 1)]
    name_begins = CC.SourceLocation[CC.getAttrNameRange(h, k).begin_loc for k = 0:(na - 1)]
    equals_locs = CC.SourceLocation[CC.getAttrEqualsLoc(h, k) for k = 0:(na - 1)]
    value_ranges = CC.SourceRange[CC.getAttrValueRange(h, k) for k = 0:(na - 1)]
    @test "href" in names
    # setAttrs recomputes the tag's range end from the last attribute's value range, which is
    # not where the parser had left it (the parser ends the tag at its own closing token), so
    # the property to check is the recomputation rule, not that the end is unchanged.
    CC.setAttrs(h, jctx, name_begins, names, equals_locs, value_ranges, values)
    @test Int(CC.getNumAttrs(h)) == na
    @test String[CC.getAttrName(h, k) for k = 0:(na - 1)] == names
    @test String[CC.getAttrValue(h, k) for k = 0:(na - 1)] == values
    @test CC.getSourceRange(h).end_loc.ptr == value_ranges[end].end_loc.ptr

    blocks = filter(b -> b.ptr != C_NULL, [CC.BlockCommandComment(c) for c in nodes])
    witharg = filter(b -> CC.getNumArgs(b) > 0, blocks)
    @test !isempty(witharg)
    b = first(witharg)
    nb = Int(CC.getNumArgs(b))
    texts = String[CC.getArgText(b, k) for k = 0:(nb - 1)]
    ranges = CC.SourceRange[CC.getArgRange(b, k) for k = 0:(nb - 1)]
    CC.setArgs(b, jctx, texts, ranges)
    @test Int(CC.getNumArgs(b)) == nb
    @test String[CC.getArgText(b, k) for k = 0:(nb - 1)] == texts
    dispose(J)
end
