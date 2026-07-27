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
    @test gv_f isa CC.LLVM.GenericValue
    CC.LLVM.dispose(gv_f)

    vd_carr = varof("carr")
    av_arr = CC.evaluateValue(vd_carr)
    @test av_arr.ptr != C_NULL
    if CC.isArray(av_arr)
        @test CC.getKind(av_arr) == CC.LibClangEx.CXAPValueKind_Array
        @test CC.getArraySize(av_arr) isa Integer
        @test CC.getArrayInitializedElts(av_arr) isa Integer
        if CC.getArrayInitializedElts(av_arr) > 0
            elt = CC.getArrayInitializedElt(av_arr, 0)
            @test elt isa CC.APValue
            CC.isInt(elt) && (@test convert(Int, CC.LLVM.GenericValue(CC.getInt(elt))) == 10)
        end
    end

    vd_cpt = varof("cpt")
    av_struct = CC.evaluateValue(vd_cpt)
    @test av_struct.ptr != C_NULL
    if CC.isStruct(av_struct)
        @test CC.getKind(av_struct) == CC.LibClangEx.CXAPValueKind_Struct
        @test CC.getStructNumFields(av_struct) isa Integer
        if CC.getStructNumFields(av_struct) > 0
            fld = CC.getStructField(av_struct, 0)
            @test fld isa CC.APValue
        end
    end

    # APValue::dispose on an owned value (EvaluateAsRValue result).
    av_owned = CC.EvaluateAsRValue(CC.getInit(vd_ci), ctx)
    @test av_owned.ptr != C_NULL
    CC.dispose(av_owned)

    # ---------- NestedNameSpecifier ----------
    exercise_nns(nns) = begin
        @test nns isa CC.NestedNameSpecifier
        @test CC.getKind(nns) isa CC.LibClangEx.CXNestedNameSpecifierKind
        @test CC.isDependent(nns) isa Bool
        @test CC.isInstantiationDependent(nns) isa Bool
        @test CC.containsUnexpandedParameterPack(nns) isa Bool
        @test CC.containsErrors(nns) isa Bool
        @test CC.getName(nns) isa AbstractString
        @test CC.getPrefix(nns) isa CC.NestedNameSpecifier
        CC.dump(nns)
        k = CC.getKind(nns)
        if k == CC.LibClangEx.CXNestedNameSpecifierKind_Namespace
            @test CC.getAsNamespace(nns) isa CC.NamespaceDecl
        elseif k == CC.LibClangEx.CXNestedNameSpecifierKind_NamespaceAlias
            @test CC.getAsNamespaceAlias(nns) isa CC.NamespaceAliasDecl
        elseif k == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpec ||
               k == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpecWithTemplate
            @test CC.getAsType(nns) isa CC.Type_
            @test CC.getAsRecordDecl(nns) isa CC.CXXRecordDecl
        elseif k == CC.LibClangEx.CXNestedNameSpecifierKind_Identifier
            @test CC.getAsIdentifier(nns) isa CC.IdentifierInfo
        end
    end

    ety_ab = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_ab"))))
    @test ety_ab isa CC.ElaboratedType
    nns_ab = CC.getQualifier(ety_ab)               # Namespace (B), prefix Namespace (A)
    exercise_nns(nns_ab)
    exercise_nns(CC.getPrefix(nns_ab))             # the A:: prefix

    ety_oi = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_oi"))))
    exercise_nns(CC.getQualifier(ety_oi))          # TypeSpec (Outer)

    ety_al = CC.resolve(CC.getTypePtr(CC.getType(varof("nns_alias"))))
    exercise_nns(CC.getQualifier(ety_al))          # NamespaceAlias (Shrt)

    # Dependent identifier NNS from `typename T::foo::type`.
    @test f(I, "Dep")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    patt = CC.getTemplatedDecl(ctd)
    for fld in CC.getFields(patt)
        dnt = CC.resolve(CC.getTypePtr(CC.getType(fld)))
        if dnt isa CC.DependentNameType
            exercise_nns(CC.getQualifier(dnt))
        end
    end

    # ---------- Attr ----------
    @test f(I, "gattr")
    attrs = CC.getAttrs(get_decl(f))
    @test !isempty(attrs)
    for a in attrs
        @test CC.getKind(a) isa CC.LibClangEx.CXAttrKind
        @test CC.getSpelling(a) isa AbstractString
        @test CC.getLocation(a) isa CC.SourceLocation
        @test CC.isImplicit(a) isa Bool
        @test CC.isInherited(a) isa Bool
        @test CC.isPackExpansion(a) isa Bool
    end

    # ---------- MangleContext ----------
    mc = CC.createMangleContext(ctx, CC.getTargetInfo(ctx))
    @test mc isa CC.MangleContext
    @test CC.getKind(mc) isa CC.LibClangEx.CXMangleContext_ManglerKind
    @test CC.getASTContext(mc) isa CC.ASTContext
    @test CC.getDiags(mc) isa CC.DiagnosticsEngine
    @test f(I, "add")
    add_nd = CC.NamedDecl(get_decl(f).ptr)
    @test CC.shouldMangleDeclName(mc, add_nd) isa Bool
    @test CC.shouldMangleCXXName(mc, add_nd) isa Bool
    @test CC.mangleName(mc, add_nd) == "_Z3addii"
    @test f(I, "Pt")
    pt_nd = CC.NamedDecl(get_decl(f).ptr)
    @test CC.getAnonymousStructId(mc, pt_nd) isa Integer

    # ---------- StringLiteral for shouldMangleStringLiteral ----------
    vd_str = varof("g_str")
    sl = nothing
    for n in CC.subtree(CC.resolve(CC.getInit(vd_str)))
        n isa CC.StringLiteral && (sl = n; break)
    end
    @test sl isa CC.StringLiteral
    @test CC.shouldMangleStringLiteral(mc, sl) isa Bool

    # ---------- DeclarationName ----------
    dn_empty = CC.DeclarationName()
    @test CC.isEmpty(dn_empty)
    @test CC.getAsString(dn_empty) isa AbstractString
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
    @test CC.getLoc(dni) isa CC.SourceLocation
    @test CC.getBeginLoc(dni) isa CC.SourceLocation
    @test CC.getEndLoc(dni) isa CC.SourceLocation
    @test CC.getAsString(dni) == "add"
    CC.dispose(dni)

    # ---------- DeclGroupRef ----------
    @test f(I, "add")
    dgr = CC.DeclGroupRef(CC.Decl(get_decl(f).ptr))   # DeclGroupRef(x::Decl) wants the exact Decl carrier
    @test !CC.isNull(dgr)
    @test CC.isSingleDecl(dgr)
    @test !CC.isDeclGroup(dgr)
    @test CC.getSingleDecl(dgr) isa CC.Decl

    # ---------- TemplateArgument (real specialisation args) ----------
    exercise_targ(ta) = begin
        @test ta isa CC.TemplateArgument
        k = CC.getKind(ta)
        @test k isa CC.LibClangEx.CXTemplateArgument_ArgKind
        @test CC.isNull(ta) isa Bool
        @test CC.isDependent(ta) isa Bool
        @test CC.isInstantiationDependent(ta) isa Bool
        CC.dump(ta)
        if k == CC.LibClangEx.CXTemplateArgument_Type
            @test CC.getAsType(ta) isa CC.QualType
        elseif k == CC.LibClangEx.CXTemplateArgument_Integral
            @test CC.getIntegralType(ta) isa CC.QualType
            gv = CC.LLVM.GenericValue(CC.getAsIntegral(ta))
            @test gv isa CC.LLVM.GenericValue
            CC.LLVM.dispose(gv)
        elseif k == CC.LibClangEx.CXTemplateArgument_Template
            @test CC.getAsTemplate(ta) isa CC.TemplateName
            @test CC.getAsTemplateOrTemplatePattern(ta) isa CC.TemplateName
        end
    end

    tst = tst_of(varof("stempl_obj"))
    @test tst isa CC.TemplateSpecializationType
    @test CC.getNumArgs(tst) == 2
    for i in 0:(CC.getNumArgs(tst) - 1)
        exercise_targ(CC.getArg(tst, i))
    end

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
    @test CC.getAsType(ta_type) isa CC.QualType
    @test CC.isNull(ta_type) isa Bool
    @test CC.isDependent(ta_type) isa Bool
    @test CC.isInstantiationDependent(ta_type) isa Bool
    CC.dump(ta_type)
    CC.dispose(ta_type)

    # Integral, from the constexpr int's GenericValue.
    ta_int = CC.TemplateArgument(ctx, gv_i, int_qt)
    @test CC.getKind(ta_int) == CC.LibClangEx.CXTemplateArgument_Integral
    gv_back = CC.LLVM.GenericValue(CC.getAsIntegral(ta_int))
    @test convert(Int, gv_back) == 5
    CC.LLVM.dispose(gv_back)
    @test CC.getIntegralType(ta_int) isa CC.QualType
    CC.setIntegralType(ta_int, int_qt)
    @test CC.getIntegralType(ta_int) isa CC.QualType
    CC.dispose(ta_int)
    CC.LLVM.dispose(gv_i)

    # NullPtr, via constructFromQualType(isNullPtr=true) on a pointer type.
    ptr_qt = CC.getType(vd_str)                   # const char *
    ta_null = CC.TemplateArgument(ptr_qt, true)
    @test CC.getKind(ta_null) == CC.LibClangEx.CXTemplateArgument_NullPtr
    @test CC.getNullPtrType(ta_null) isa CC.QualType
    CC.dispose(ta_null)

    # Declaration, via constructFromValueDecl on the `gx` global.
    @test f(I, "gx")
    vd_gx = CC.VarDecl(get_decl(f).ptr)
    ta_decl = CC.TemplateArgument(CC.ValueDecl(vd_gx.ptr), CC.getType(vd_gx))
    @test CC.getKind(ta_decl) == CC.LibClangEx.CXTemplateArgument_Declaration
    @test CC.getAsDecl(ta_decl) isa CC.ValueDecl
    @test CC.getParamTypeForDecl(ta_decl) isa CC.QualType
    CC.dispose(ta_decl)

    dispose(f)
    dispose(I)
end
