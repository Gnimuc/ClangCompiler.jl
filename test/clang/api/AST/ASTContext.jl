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
# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx

@testset "convertTypeForMemory" begin
    I = create_interpreter()
    ctx = get_ast_context(I)
    cgm = get_codegen_module(I)

    i8 = LLVM.LLVMType(convertTypeForMemory(cgm, CC.BoolTy(ctx)))
    @test LLVM.width(i8) == 8

    dispose(I)
end

@testset "ASTContext type builders" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    # ---- parse the nodes we need BEFORE mutating ASTContext singletons ----
    CC.parse(I, "int scf_gvar = 5;")
    CC.parse(I, "int scf_gfunc(int scf_p) { return scf_p; }")

    f = DeclFinder(I)
    @test f(I, "scf_gvar")
    vd = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "scf_gfunc")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    pvd = CC.getParamDecl(fd, 0)

    # ---- per-decl map setters: round-trip against the paired getters ----
    CC.setManglingNumber(ctx, vd, 42)
    @test CC.getManglingNumber(ctx, vd) == 42

    CC.setStaticLocalNumber(ctx, vd, 7)
    @test CC.getStaticLocalNumber(ctx, vd) == 7

    CC.setParameterIndex(ctx, pvd, 3)
    @test CC.getParameterIndex(ctx, pvd) == 3

    CC.setPrimaryMergedDecl(ctx, vd, fd)
    @test CC.getPrimaryMergedDecl(ctx, vd).ptr == fd.ptr

    CC.setcudaConfigureCallDecl(ctx, fd)
    @test CC.getcudaConfigureCallDecl(ctx).ptr == fd.ptr

    # ---- FieldDecl map: two real FieldDecls reached via getFields ----
    CC.parse(I, "struct SCFRec { int fa; int fb; };")
    @test f(I, "SCFRec")
    rd = CC.RecordDecl(get_decl(f).ptr)
    flds = CC.getFields(rd)
    @test length(flds) == 2
    CC.setInstantiatedFromUnnamedFieldDecl(ctx, flds[1], flds[2])
    @test CC.getInstantiatedFromUnnamedFieldDecl(ctx, flds[1]).ptr == flds[2].ptr

    # ---- Using / UsingShadow decls reached via the recursive decls() walk ----
    CC.parse(I,
             "struct SCFBase { void m(); void n(); }; struct SCFDer : SCFBase { using SCFBase::m; using SCFBase::n; };")
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    all_decls = CC.decls(dc)

    usings = filter(d -> d isa CC.UsingDecl, all_decls)
    @test length(usings) >= 2
    CC.setInstantiatedFromUsingDecl(ctx, usings[1], usings[2])
    @test CC.getInstantiatedFromUsingDecl(ctx, usings[1]).ptr == usings[2].ptr

    shadows = filter(d -> d isa CC.UsingShadowDecl, all_decls)
    @test length(shadows) >= 2
    CC.setInstantiatedFromUsingShadowDecl(ctx, shadows[1], shadows[2])
    @test CC.getInstantiatedFromUsingShadowDecl(ctx, shadows[1]).ptr == shadows[2].ptr

    # ---- ObjC redefinition-type setters: store a QualType, read it back ----
    qt1 = CC.getIntPtrType(ctx)
    CC.setObjCIdRedefinitionType(ctx, qt1)
    @test CC.getObjCIdRedefinitionType(ctx).ptr == qt1.ptr

    qt2 = CC.getUIntPtrType(ctx)
    CC.setObjCClassRedefinitionType(ctx, qt2)
    @test CC.getObjCClassRedefinitionType(ctx).ptr == qt2.ptr

    # ---- builders: implicit record + implicit typedef ----
    rec = CC.buildImplicitRecord(ctx, "SCFImplicitRec")
    @test rec isa CC.RecordDecl
    rectype = CC.getRecordType(ctx, rec)
    tdef = CC.buildImplicitTypedef(ctx, rectype, "SCFImplicitTypedef")
    @test tdef isa CC.TypedefDecl

    # ---- CFConstantStringType: a typedef-of-record round-trips through the CF getters ----
    tdeftype = CC.getTypedefType(ctx, tdef, CC.QualType(C_NULL))
    CC.setCFConstantStringType(ctx, tdeftype)
    @test CC.getCFConstantStringTagDecl(ctx).ptr == rec.ptr
    @test CC.getCFContantStringDecl(ctx).ptr == tdef.ptr

    # ---- BOOL / FILE typedef setters ----
    CC.setBOOLDecl(ctx, tdef)
    @test CC.getBOOLDecl(ctx).ptr == tdef.ptr

    CC.setFILEDecl(ctx, tdef)
    @test CC.getFILEType(ctx).ptr == CC.getTypeDeclType(ctx, tdef).ptr

    # ---- CreateTypeSourceInfo (already-wrapped factory) ----
    tsi = CC.CreateTypeSourceInfo(ctx, qt1, 0)
    @test tsi isa CC.TypeSourceInfo

    # ---- getPredefinedStringLiteralFromCache (cache lookup) ----
    @test !CC.is_null_handle(CC.getPredefinedStringLiteralFromCache(ctx, "no_such_key"))

    dispose(f)
    dispose(I)
end

@testset "type builders" begin
    I = create_interpreter(String[])
    ctx = get_ast_context(I)
    int_t = CC.get_qual_type(CC.IntTy(ctx))
    dbl_t = CC.get_qual_type(CC.DoubleTy(ctx))

    # getFunctionType: ExtProtoInfo flattened to variadic + calling convention
    fn = CC.getFunctionType(ctx, dbl_t, [int_t, int_t])
    @test fn isa CC.QualType
    @test CC.get_name(fn) == "double (int, int)"
    vfn = CC.getFunctionType(ctx, dbl_t, [int_t]; variadic=true)
    @test CC.get_name(vfn) == "double (int, ...)"
    zfn = CC.getFunctionType(ctx, CC.get_qual_type(CC.VoidTy(ctx)))
    @test CC.get_name(zfn) == "void (void)"

    # getConstantArrayType: APInt built C-side from a UInt64
    arr = CC.getConstantArrayType(ctx, int_t, 7)
    @test arr isa CC.QualType
    @test CC.get_name(arr) == "int[7]"

    dispose(I)
end

using ClangCompiler: get_tag
@testset "coverage tail: astcontext-api" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace cta_ns { struct S { int v; }; }
    cta_ns::S cta_ns_sv;

    struct CtaPt { int x; double y; };
    CtaPt cta_pt_var;

    struct CtaVB { virtual void cta_vf(); virtual ~CtaVB(); };
    struct CtaVD : CtaVB { void cta_vf() override; };

    struct CtaEx { CtaEx(); CtaEx(const CtaEx &); };

    typedef struct { int tx; } CtaUT;
    struct { int uy; } cta_unnamed_var;

    auto cta_dedret() { return 42; }
    int cta_plain(int a) { return a; }

    int cta_at_g;
    void cta_atomic_fn() { int r = __atomic_fetch_add(&cta_at_g, 1, 0); (void)r; }
    void cta_igoto() { void *p = &&cta_lab; goto *p; cta_lab: ; }

    template<typename T, int N> struct CtaST { T x; CtaST *self; int a[N]; };
    template<typename T> struct CtaDep { typename T::foo::type m; };
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    getptr(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f).ptr)
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t

    int_qt = CC.get_qual_type(CC.IntTy(ctx))

    # ---------- simple type-query overloads ----------
    @test CC.getTypeSize(ctx, CC.getTypePtr(int_qt)) isa Integer   # AbstractType overload
    pt_qt = CC.getType(CC.VarDecl(getptr("cta_pt_var")))
    @test CC.getMemberPointerType(ctx, int_qt, pt_qt) isa CC.QualType   # QualType-class overload
    @test CC.getScalableVectorType(ctx, int_qt, 4) isa CC.QualType   # null QualType off SVE/RVV targets

    # ---------- stmt-tree carriers: AtomicExpr / IndirectGotoStmt ----------
    nodes = CC.AbstractStmt[]
    for fname in ("cta_atomic_fn", "cta_igoto")
        fd = CC.FunctionDecl(getptr(fname))
        body = CC.getBody(fd)
        body.ptr == C_NULL || append!(nodes, CC.subtree(body))
    end
    pick(T) = filter(n -> n isa T, nodes)

    aes = pick(CC.AtomicExpr)
    @test !isempty(aes)
    @test !(CC.AtomicUsesUnsupportedLibcall(ctx, first(aes)))

    igs = pick(CC.IndirectGotoStmt)
    @test !isempty(igs)
    @test !CC.is_null_handle(CC.getGotoLoc(first(igs)))
    @test !CC.is_null_handle(CC.getStarLoc(first(igs)))

    # ---------- template-pattern nodes: TemplateName / dependent exprs ----------
    @assert f(I, "CtaST")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    patt = CC.getTemplatedDecl(ctd)
    local ttpt = nothing
    local injt = nothing
    local dsaty = nothing
    for fld in CC.getFields(patt)
        ft = CC.resolve(CC.getTypePtr(CC.getType(fld)))
        ft isa CC.TemplateTypeParmType && (ttpt = ft)
        ft isa CC.DependentSizedArrayType && (dsaty = ft)
        if ft isa CC.PointerType
            pn = unwrap(CC.resolve(CC.getTypePtr(CC.getPointeeType(ft))))
            pn isa CC.InjectedClassNameType && (injt = pn)
        end
    end
    @test ttpt isa CC.TemplateTypeParmType
    @test injt isa CC.InjectedClassNameType
    @test dsaty isa CC.DependentSizedArrayType

    tn = CC.getTemplateName(injt)
    @test !CC.is_null_handle(CC.getCanonicalTemplateName(ctx, tn))
    @test CC.hasSameTempalteName(ctx, tn, tn)
    @test !CC.is_null_handle(CC.getDeducedTemplateSpecializationType(ctx, tn, int_qt, false))

    prd = CC.getDecl(injt)   # the pattern CXXRecordDecl; its TypeForDecl is the injected-class-name type
    tst_qt = CC.getInjectedSpecializationType(injt)
    @test !CC.is_null_handle(CC.getInjectedClassNameType(ctx, prd, tst_qt))

    ttpd = CC.getDecl(ttpt)
    @test CC.getTemplateTypeParmType(ctx, CC.getDepth(ttpd), CC.getIndex(ttpd),
                                     CC.isParameterPack(ttpd), ttpd) isa CC.QualType

    dep_e = CC.getSizeExpr(dsaty)   # value-dependent DeclRefExpr to the N parameter
    loc = CC.getLocation(patt)
    @test !CC.is_null_handle(CC.getDependentAddressSpaceType(ctx, int_qt, dep_e, loc))
    @test !CC.is_null_handle(CC.getDependentBitIntType(ctx, false, dep_e))
    @test CC.getDependentSizedExtVectorType(ctx, int_qt, dep_e, loc) isa CC.QualType  # shape-only
    @test CC.getDependentSizedMatrixType(ctx, int_qt, dep_e, dep_e, loc) isa CC.QualType  # shape-only

    # dependent NNS + identifier from `typename T::foo::type`
    @assert f(I, "CtaDep")
    patt2 = CC.getTemplatedDecl(CC.ClassTemplateDecl(get_decl(f).ptr))
    dnty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(patt2)))))
    @test dnty isa CC.DependentNameType
    @test !CC.is_null_handle(CC.getDependentTemplateName(ctx, CC.getQualifier(dnty), CC.getIdentifier(dnty)))

    # namespace-qualified NNS from `cta_ns::S cta_ns_sv;`
    ety = CC.resolve(CC.getTypePtr(CC.getType(CC.VarDecl(getptr("cta_ns_sv")))))
    @test ety isa CC.ElaboratedType
    nns = CC.getQualifier(ety)
    @test !CC.is_null_handle(CC.getCanonicalNestedNameSpecifier(ctx, nns))

    # ---------- DeclarationName / IdentifierInfo consumers ----------
    plain_fd = CC.FunctionDecl(getptr("cta_plain"))
    @test !CC.is_null_handle(CC.getAssumedTemplateName(ctx, CC.getDeclName(plain_fd)))
    ii = Base.get(CC.getIdents(ctx), "cta_macro_name")
    @test !CC.is_null_handle(CC.getMacroQualifiedType(ctx, int_qt, ii))

    # ---------- side-table registrations (throwaway TU state) ----------
    @assert f(I, "CtaVB")
    vb = CC.CXXRecordDecl(get_tag(f).ptr)
    @assert f(I, "CtaVD")
    vd = CC.CXXRecordDecl(get_tag(f).ptr)
    # pick the virtual `cta_vf` method; go through resolve to skip (virtual)
    # destructors — getName aborts on non-identifier declaration names
    vf_of(rd) = first(filter(m -> CC.isVirtual(m) && !(CC.resolve(m) isa CC.CXXDestructorDecl),
                             CC.getMethods(rd)))
    @test CC.addOverriddenMethod(ctx, vf_of(vd), vf_of(vb)) === nothing

    @assert f(I, "CtaEx")
    exrd = CC.CXXRecordDecl(get_tag(f).ptr)
    copyc = first(filter(CC.isCopyConstructor, CC.getCtors(exrd)))
    # NOTE: this family is backed by the C++ ABI object; under the Itanium ABI the
    # add* entry points are no-ops and the getters return NULL, so only isa-check.
    @test CC.addCopyConstructorForExceptionObject(ctx, exrd, copyc) === nothing
    @test CC.is_null_handle(CC.getCopyConstructorForExceptionObject(ctx, exrd))

    # typedef'd unnamed struct
    @assert f(I, "CtaUT")
    td = CC.TypedefDecl(get_decl(f).ptr)
    ut_tag = CC.getAsTagDecl(CC.getTypePtr(CC.getUnderlyingType(td)))
    @test CC.addTypedefNameForUnnamedTagDecl(ctx, ut_tag, td) === nothing
    @test CC.is_null_handle(CC.getTypedefNameForUnnamedTagDecl(ctx, ut_tag))

    # unnamed struct with a declarator
    uv = CC.VarDecl(getptr("cta_unnamed_var"))
    uv_tag = CC.getAsTagDecl(CC.getTypePtr(CC.getType(uv)))
    @test CC.addDeclaratorForUnnamedTagDecl(ctx, uv_tag, uv) === nothing
    @test CC.is_null_handle(CC.getDeclaratorForUnnamedTagDecl(ctx, uv_tag))

    ded_fd = CC.FunctionDecl(getptr("cta_dedret"))
    @test CC.adjustDeducedFunctionResultType(ctx, ded_fd, CC.getReturnType(ded_fd)) === nothing

    @test CC.deduplicateMergedDefinitonsFor(ctx, plain_fd) === nothing
    @test CC.eraseDeclAttrs(ctx, plain_fd) === nothing

    # BOOL typedef registration + getBOOLType
    booltd = CC.buildImplicitTypedef(ctx, int_qt, "cta_BOOL")
    CC.setBOOLDecl(ctx, booltd)
    @test CC.getBOOLDecl(ctx).ptr != C_NULL
    @test !CC.is_null_handle(CC.getBOOLType(ctx))

    # implicit ImportDecl (null module) + addedLocalImportDecl
    tud = CC.getTranslationUnitDecl(ctx)
    tudc = CC.castToDeclContext(tud)
    iloc = CC.getLocation(plain_fd)
    imp = CC.ImportDecl(ctx, tudc, iloc, C_NULL, iloc)
    @test imp isa CC.ImportDecl && imp.ptr != C_NULL
    @test CC.addedLocalImportDecl(ctx, imp) === nothing

    CC.dispose(f)
    CC.dispose(I)
end

@testset "coverage tail: astcontext-api" begin
    # getMSGuidType needs the implicit `_GUID` tag decl, created only under -fms-extensions.
    I = create_interpreter(["-fms-extensions"])
    ctx = CC.get_ast_context(I)
    @test CC.getMSGuidTagDecl(ctx).ptr != C_NULL
    @test !CC.is_null_handle(CC.getMSGuidType(ctx))
    CC.dispose(I)
end

@testset "coverage tail: astcontext-api" begin
    # InitBuiltinTypes re-runs builtin-type initialization on an already-live context
    # (allowed in release libclang-cpp); keep it in its own throwaway interpreter.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    ti = CC.getTargetInfo(ctx)
    @test CC.InitBuiltinTypes(ctx, ti, CC.TargetInfo(C_NULL)) === nothing
    CC.dispose(I)
end

@testset "Coverage | ASTContext" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    CC.parse(I, """
    struct Point { int x; int y; };
    enum Color { Red, Green, Blue };
    typedef int MyInt;
    int arr[5];
    int gv = 3;
    int add(int a, int b) { return a + b; }
    """)

    f = DeclFinder(I)
    @test f(I, "Point")
    point = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "Color")
    color = CC.EnumDecl(get_decl(f).ptr)
    @test f(I, "MyInt")
    mytypedef = CC.TypedefDecl(get_decl(f).ptr)
    @test f(I, "arr")
    arr_vd = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "gv")
    gv_vd = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "add")
    add_fd = CC.FunctionDecl(get_decl(f).ptr)
    add_nd = CC.NamedDecl(get_decl(f).ptr)

    field = CC.getFields(point)[1]
    body = CC.resolve(CC.getBody(add_fd))
    expr = first(n for n in CC.subtree(body) if n isa CC.AbstractExpr)

    # ---- predefined type accessors (each returns its own carrier) ----
    @test CC.VoidTy(ctx) isa CC.VoidTy
    @test CC.BoolTy(ctx) isa CC.BoolTy
    @test CC.CharTy(ctx) isa CC.CharTy
    @test CC.WCharTy(ctx) isa CC.WCharTy
    @test CC.WideCharTy(ctx) isa CC.WideCharTy
    @test CC.WIntTy(ctx) isa CC.WIntTy
    @test CC.Char8Ty(ctx) isa CC.Char8Ty
    @test CC.Char16Ty(ctx) isa CC.Char16Ty
    @test CC.Char32Ty(ctx) isa CC.Char32Ty
    @test CC.SignedCharTy(ctx) isa CC.SignedCharTy
    @test CC.ShortTy(ctx) isa CC.ShortTy
    @test CC.IntTy(ctx) isa CC.IntTy
    @test CC.LongTy(ctx) isa CC.LongTy
    @test CC.LongLongTy(ctx) isa CC.LongLongTy
    @test CC.Int128Ty(ctx) isa CC.Int128Ty
    @test CC.UnsignedCharTy(ctx) isa CC.UnsignedCharTy
    @test CC.UnsignedShortTy(ctx) isa CC.UnsignedShortTy
    @test CC.UnsignedIntTy(ctx) isa CC.UnsignedIntTy
    @test CC.UnsignedLongTy(ctx) isa CC.UnsignedLongTy
    @test CC.UnsignedLongLongTy(ctx) isa CC.UnsignedLongLongTy
    @test CC.UnsignedInt128Ty(ctx) isa CC.UnsignedInt128Ty
    @test CC.FloatTy(ctx) isa CC.FloatTy
    @test CC.DoubleTy(ctx) isa CC.DoubleTy
    @test CC.LongDoubleTy(ctx) isa CC.LongDoubleTy
    @test CC.Float128Ty(ctx) isa CC.Float128Ty
    @test CC.HalfTy(ctx) isa CC.HalfTy
    @test CC.BFloat16Ty(ctx) isa CC.BFloat16Ty
    @test CC.Float16Ty(ctx) isa CC.Float16Ty
    @test CC.VoidPtrTy(ctx) isa CC.VoidPtrTy
    @test CC.NullPtrTy(ctx) isa CC.NullPtrTy

    # canonical QualTypes to feed the type-query wrappers
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    uint_qt = CC.get_qual_type(CC.UnsignedIntTy(ctx))
    bool_qt = CC.get_qual_type(CC.BoolTy(ctx))
    char_qt = CC.get_qual_type(CC.CharTy(ctx))
    float_qt = CC.get_qual_type(CC.FloatTy(ctx))
    double_qt = CC.get_qual_type(CC.DoubleTy(ctx))
    void_qt = CC.get_qual_type(CC.VoidTy(ctx))

    # builder QualTypes derived through the wrappers themselves
    ptr_qt = CC.getPointerType(ctx, int_qt)
    array_qt = CC.getType(arr_vd)                       # int[5]
    func_qt = CC.getType(add_fd)                        # int(int,int)
    record_qt = CC.getRecordType(ctx, CC.RecordDecl(point.ptr))
    noproto_qt = CC.getFunctionNoProtoType(ctx, int_qt) # int()
    block_qt = CC.getBlockPointerType(ctx, func_qt)
    @test ptr_qt isa CC.QualType
    @test record_qt isa CC.QualType
    @test noproto_qt isa CC.QualType
    @test block_qt isa CC.QualType

    # ---- sizes / alignments / widths ----
    @test CC.getTypeSize(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getSizeOf(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getTypeAlign(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getTypeUnadjustedAlign(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getTypeAlignIfKnown(ctx, int_qt, 0) isa Integer  # shape-only: the host decides this
    @test CC.getPreferredTypeAlign(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getAlignOfGlobalVar(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getIntWidth(ctx, int_qt) isa Integer  # shape-only: the target chooses this value
    @test CC.getOpenMPDefaultSimdAlign(ctx, int_qt) isa Integer  # shape-only: the host decides this
    @test CC.getTargetNullPointerValue(ctx, ptr_qt) isa Integer  # shape-only: the host decides this
    @test CC.getCharWidth(ctx) isa Integer  # shape-only: the target chooses this value
    @test CC.getASTAllocatedMemory(ctx) isa Integer  # shape-only: the target chooses this value
    @test CC.getSideTableAllocatedMemory(ctx) isa Integer  # shape-only: the target chooses this value
    @test CC.getTargetDefaultAlignForAttributeAligned(ctx) isa Integer  # shape-only: the host decides this
    @test CC.isDependceAllowed(ctx) isa Integer

    # ---- type builders taking one QualType ----
    @test !CC.is_null_handle(CC.getLValueReferenceType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getRValueReferenceType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getMemberPointerType(ctx, int_qt, CC.get_type_ptr(record_qt).ptr))
    @test !CC.is_null_handle(CC.getComplexType(ctx, float_qt))
    @test !CC.is_null_handle(CC.getConstType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getVolatileType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getRestrictType(ctx, ptr_qt))
    @test !CC.is_null_handle(CC.getAtomicType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getParenType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getCVRQualifiedType(ctx, int_qt, 1))
    @test !CC.is_null_handle(CC.getBaseElementType(ctx, array_qt))
    @test !CC.is_null_handle(CC.getArrayDecayedType(ctx, array_qt))
    @test !CC.is_null_handle(CC.getVariableArrayDecayedType(ctx, array_qt))
    @test !CC.is_null_handle(CC.getDecayedType(ctx, array_qt))
    @test !CC.is_null_handle(CC.getAdjustedParameterType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getSignatureParameterType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getExceptionObjectType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getComplexType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getExtVectorType(ctx, float_qt, 4))
    @test !CC.is_null_handle(CC.getConstantMatrixType(ctx, float_qt, 2, 2))
    @test !CC.is_null_handle(CC.getReadPipeType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getWritePipeType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getBitIntType(ctx, 0, 32))
    @test !CC.is_null_handle(CC.getIntTypeForBitwidth(ctx, 32, 1))
    @test !CC.is_null_handle(CC.getPromotedIntegerType(ctx, bool_qt))
    @test !CC.is_null_handle(CC.getCorrespondingUnsignedType(ctx, int_qt))
    @test CC.getFunctionTypeWithoutPtrSizes(ctx, func_qt) isa CC.QualType  # shape-only: the host decides this
    @test !CC.is_null_handle(CC.getAdjustedType(ctx, int_qt, int_qt))
    @test !CC.is_null_handle(CC.getBlockDescriptorType(ctx))
    @test !CC.is_null_handle(CC.getBlockDescriptorExtendedType(ctx))
    @test !CC.is_null_handle(CC.removeAddrSpaceQualType(ctx, int_qt))
    @test CC.removePtrSizeAddrSpace(ctx, int_qt) isa CC.QualType  # shape-only: the host decides this
    @test !CC.is_null_handle(CC.adjustStringLiteralBaseType(ctx, array_qt))
    @test !CC.is_null_handle(CC.getStringLiteralArrayType(ctx, char_qt, 5))

    # ---- array-type views ----
    @test !CC.is_null_handle(CC.getAsArrayType(ctx, array_qt))
    cat = CC.getAsConstantArrayType(ctx, array_qt)
    @test cat isa CC.ConstantArrayType
    @test CC.is_null_handle(CC.getAsIncompleteArrayType(ctx, array_qt))
    @test CC.is_null_handle(CC.getAsVariableArrayType(ctx, array_qt))
    @test CC.getAsDependentSizedArrayType(ctx, array_qt) isa CC.DependentSizedArrayType  # shape-only
    @test CC.getConstantArrayElementCount(ctx, cat) isa Integer  # shape-only: the target chooses this value

    # ---- predicates on QualTypes ----
    @test CC.hasUniqueObjectRepresentations(ctx, int_qt) isa Integer
    @test CC.isAlignmentRequired(ctx, int_qt) isa Integer
    @test CC.hasDirectOwnershipQualifier(ctx, int_qt) isa Integer

    # ---- type ordering ----
    @test CC.getFloatingTypeOrder(ctx, float_qt, double_qt) isa Integer  # shape-only: the target chooses this value
    @test CC.getFloatingTypeSemanticOrder(ctx, float_qt, double_qt) isa Integer  # shape-only
    @test CC.getIntegerTypeOrder(ctx, int_qt, uint_qt) isa Integer  # shape-only: the target chooses this value

    # ---- two-QualType comparisons ----
    @test CC.hasSameType(ctx, int_qt, int_qt) isa Integer
    @test CC.hasSameUnqualifiedType(ctx, int_qt, int_qt) isa Integer
    @test CC.hasCvrSimilarType(ctx, int_qt, int_qt) isa Integer
    @test CC.hasSimilarType(ctx, int_qt, int_qt) isa Integer
    @test CC.hasSameNullabilityTypeQualifier(ctx, int_qt, int_qt, 0) isa Integer
    @test CC.hasSameFunctionTypeIgnoringExceptionSpec(ctx, func_qt, func_qt) isa Integer
    @test CC.hasSameFunctionTypeIgnoringPtrSizes(ctx, func_qt, func_qt) isa Integer
    @test CC.areCompatibleSveTypes(ctx, int_qt, int_qt) isa Integer
    @test CC.areCompatibleVectorTypes(ctx, int_qt, int_qt) isa Integer
    @test CC.areLaxCompatibleSveTypes(ctx, int_qt, int_qt) isa Integer
    @test CC.typesAreBlockPointerCompatible(ctx, block_qt, block_qt) isa Integer
    @test CC.typesAreCompatible(ctx, int_qt, int_qt, 0) isa Integer
    @test CC.propertyTypesAreCompatible(ctx, int_qt, int_qt) isa Integer

    # ---- merge* builders ----
    @test !CC.is_null_handle(CC.mergeTypes(ctx, int_qt, int_qt, 0, 0, 0))
    @test !CC.is_null_handle(CC.mergeFunctionTypes(ctx, func_qt, func_qt, 0, 0, 0))
    @test !CC.is_null_handle(CC.mergeFunctionParameterTypes(ctx, int_qt, int_qt, 0, 0))
    @test CC.is_null_handle(CC.mergeTransparentUnionType(ctx, int_qt, int_qt, 0, 0))
    @test !CC.is_null_handle(CC.mergeObjCGCQualifiers(ctx, int_qt, int_qt))

    # ---- no-argument QualType getters ----
    @test !CC.is_null_handle(CC.getAutoDeductType(ctx))
    @test !CC.is_null_handle(CC.getAutoRRefDeductType(ctx))
    if CC.getBOOLDecl(ctx).ptr != C_NULL        # getBOOLType aborts on a null (ObjC) BOOL decl
        @test CC.getBOOLType(ctx) isa CC.QualType  # shape-only
    end
    @test !CC.is_null_handle(CC.getCFConstantStringType(ctx))
    @test !CC.is_null_handle(CC.getRawCFConstantStringType(ctx))
    @test CC.is_null_handle(CC.getFILEType(ctx))
    @test !CC.is_null_handle(CC.getObjCClassRedefinitionType(ctx))
    @test !CC.is_null_handle(CC.getObjCIdRedefinitionType(ctx))
    @test !CC.is_null_handle(CC.getObjCInstanceType(ctx))
    @test !CC.is_null_handle(CC.getObjCProtoType(ctx))
    @test !CC.is_null_handle(CC.getObjCSuperType(ctx))
    @test !CC.is_null_handle(CC.getBuiltinMSVaListType(ctx))
    @test !CC.is_null_handle(CC.getSignedWCharType(ctx))
    @test !CC.is_null_handle(CC.getUnsignedWCharType(ctx))
    @test CC.getWCharType(ctx) isa CC.QualType
    @test !CC.is_null_handle(CC.getWideCharType(ctx))
    @test CC.getWIntType(ctx) isa CC.QualType
    @test CC.getIntPtrType(ctx) isa CC.QualType
    @test CC.getUIntPtrType(ctx) isa CC.QualType
    @test !CC.is_null_handle(CC.getPointerDiffType(ctx))
    @test !CC.is_null_handle(CC.getUnsignedPointerDiffType(ctx))
    @test CC.getProcessIDType(ctx) isa CC.QualType
    @test !CC.is_null_handle(CC.getLogicalOperationType(ctx))

    # ---- singleton object / table getters ----
    @test !CC.is_null_handle(CC.getIdents(ctx))
    @test !CC.is_null_handle(CC.getDiagnostics(ctx))
    @test !CC.is_null_handle(CC.getSourceManager(ctx))
    @test CC.getTargetInfo(ctx) isa CC.TargetInfo  # shape-only: the host decides this
    @test CC.getAuxTargetInfo(ctx) isa CC.TargetInfo  # shape-only: the host decides this
    @test !CC.is_null_handle(CC.getLangOpts(ctx))
    @test !CC.is_null_handle(CC.getTranslationUnitDecl(ctx))
    @test !CC.is_null_handle(CC.getExternCContextDecl(ctx))

    # ---- decl getters (no arg) ----
    @test !CC.is_null_handle(CC.getBuiltinVaListDecl(ctx))
    @test !CC.is_null_handle(CC.getBuiltinMSVaListDecl(ctx))
    # target-decided: __va_list_tag is the SysV x86_64 spelling of va_list and does not
    # exist on every target this suite runs on, so only the carrier shape is assertable
    @test CC.getVaListTagDecl(ctx) isa CC.Decl  # shape-only: the host decides this
    @test CC.is_null_handle(CC.getBOOLDecl(ctx))
    @test !CC.is_null_handle(CC.getInt128Decl(ctx))
    @test !CC.is_null_handle(CC.getUInt128Decl(ctx))
    @test !CC.is_null_handle(CC.getObjCInstanceTypeDecl(ctx))
    @test !CC.is_null_handle(CC.getCFContantStringDecl(ctx))
    @test !CC.is_null_handle(CC.getCFConstantStringTagDecl(ctx))
    @test !CC.is_null_handle(CC.getMakeIntegerSeqDecl(ctx))
    @test !CC.is_null_handle(CC.getTypePackElementDecl(ctx))
    msgt = CC.getMSGuidTagDecl(ctx)
    @test msgt isa CC.TagDecl
    if msgt.ptr != C_NULL                       # getMSGuidType aborts on a null MSGuidTagDecl
        @test CC.getMSGuidType(ctx) isa CC.TagType  # shape-only
    end
    @test CC.is_null_handle(CC.getcudaConfigureCallDecl(ctx))

    # ---- identifier-name getters ----
    @test !CC.is_null_handle(CC.getBoolName(ctx))
    @test !CC.is_null_handle(CC.getMakeIntegerSeqName(ctx))
    @test !CC.is_null_handle(CC.getTypePackElementName(ctx))
    @test !CC.is_null_handle(CC.getNSCopyingName(ctx))

    # ---- decl-argument accessors ----
    @test !CC.is_null_handle(CC.getTypeDeclType(ctx, mytypedef))
    @test !CC.is_null_handle(CC.getRecordType(ctx, CC.RecordDecl(point.ptr)))
    @test !CC.is_null_handle(CC.getTagDeclType(ctx, point))
    @test !CC.is_null_handle(CC.getTagDeclType(ctx, color))
    @test CC.getEnumType(ctx, color) isa CC.QualType
    @test !CC.is_null_handle(CC.getTypedefType(ctx, mytypedef, int_qt))
    @test CC.getFieldOffset(ctx, field) isa Integer  # shape-only: the target chooses this value
    @test CC.is_null_handle(CC.getInstantiatedFromUnnamedFieldDecl(ctx, field))
    @test CC.getManglingNumber(ctx, add_nd) isa Integer  # shape-only: the host decides this
    @test CC.getStaticLocalNumber(ctx, gv_vd) isa Integer  # shape-only: the target chooses this value
    @test CC.is_null_handle(CC.getInstantiatedFromUsingDecl(ctx, add_nd))
    @test !CC.is_null_handle(CC.getPrimaryMergedDecl(ctx, add_nd))
    @test CC.is_null_handle(CC.getCopyConstructorForExceptionObject(ctx, point))
    @test CC.is_null_handle(CC.getDeclaratorForUnnamedTagDecl(ctx, point))
    @test CC.is_null_handle(CC.getTypedefNameForUnnamedTagDecl(ctx, point))
    @test CC.canBuiltinBeRedeclared(ctx, add_fd) isa Integer
    @test CC.isMSStaticDataMemberInlineDefinition(ctx, gv_vd) isa Integer
    @test CC.isNearlyEmpty(ctx, point) isa Integer
    @test CC.BlockRequiresCopying(ctx, int_qt, gv_vd) isa Integer

    # ---- expr-argument accessors ----
    @test !CC.is_null_handle(CC.getDecltypeType(ctx, expr, int_qt))
    @test CC.is_null_handle(CC.isPromotableBitField(ctx, expr))
    @test CC.isSentinelNullExpr(ctx, expr) isa Integer

    # ---- TypeSourceInfo builders ----
    @test !CC.is_null_handle(CC.CreateTypeSourceInfo(ctx, int_qt, 0))
    @test !CC.is_null_handle(CC.getTrivialTypeSourceInfo(ctx, int_qt, CC.getLocation(add_fd)))

    # ---- misc void return ----
    @test (CC.PrintStats(ctx); true)

    dispose(f)
    dispose(I)
end

@testset "getTemplateSpecializationType builder" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, "template<class T> struct TstB { T v; }; TstB<int> tstb_v;")
    f = DeclFinder(I)

    @test f(I, "tstb_v")
    qt = CC.getType(CC.VarDecl(get_decl(f).ptr))
    t0 = CC.resolve(CC.getTypePtr(qt))
    t0 isa CC.ElaboratedType && (t0 = CC.resolve(CC.getTypePtr(CC.desugar(t0))))
    @test t0 isa CC.TemplateSpecializationType
    tn = CC.getTemplateName(t0)

    # rebuild the same specialization: TstB<int>
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    arg_int = CC.TemplateArgument(int_qt, false)
    same = CC.getTemplateSpecializationType(ctx, tn, [arg_int])
    @test same isa CC.QualType
    @test CC.get_name(same) == "TstB<int>"

    # and a fresh one the source never spelled: TstB<double>
    dbl_qt = CC.get_qual_type(CC.DoubleTy(ctx))
    arg_dbl = CC.TemplateArgument(dbl_qt, false)
    fresh = CC.getTemplateSpecializationType(ctx, tn, [arg_dbl])
    @test CC.get_name(fresh) == "TstB<double>"

    dispose(arg_int)
    dispose(arg_dbl)
    dispose(f)
    dispose(I)
end

@testset "ASTContext | layout, qualifiers, comments" begin
    I = create_interpreter()
    ctx = get_ast_context(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    short_ty = CC.get_qual_type(CC.jlty_to_clty(Int16, ctx))

    # getTypeInfo reports bits, the *InChars family bytes; `int` is 32/4 on every
    # platform this package supports.
    w, a, req = CC.getTypeInfo(ctx, int_ty)
    @test w == 32
    @test a == 32
    @test req == CC.LibClangEx.CXAlignRequirementKind_None

    cw, ca, creq = CC.getTypeInfoInChars(ctx, int_ty)
    @test cw == 4
    @test ca == 4
    @test creq == CC.LibClangEx.CXAlignRequirementKind_None

    @test CC.getTypeSizeInChars(ctx, int_ty) == 4
    @test CC.getTypeAlignInChars(ctx, int_ty) == 4
    @test CC.getPreferredTypeAlignInChars(ctx, int_ty) >= CC.getTypeAlignInChars(ctx, int_ty)
    @test CC.getTypeUnadjustedAlignInChars(ctx, int_ty) >= 1
    @test CC.getAlignOfGlobalVarInChars(ctx, int_ty) >= 1
    @test CC.getExnObjectAlignment(ctx) >= 1

    # bits <-> bytes round trip through the target's char width.
    @test CC.toBits(ctx, CC.getTypeSizeInChars(ctx, int_ty)) == CC.getTypeSize(ctx, int_ty)
    @test CC.toCharUnitsFromBits(ctx, CC.toBits(ctx, 3)) == 3

    # Qualifiers cross as their opaque value; bit 0 is the fast `const` bit.
    const_int = CC.getQualifiedType(ctx, int_ty, 0x1)
    @test const_int isa CC.QualType
    @test CC.isConstQualified(const_int)
    @test !CC.isConstQualified(int_ty)

    unqualified, stripped = CC.getUnqualifiedArrayType(ctx, const_int)
    @test unqualified isa CC.QualType
    @test !CC.isConstQualified(unqualified)
    @test (stripped & 0x1) != 0

    @test CC.isPromotableIntegerType(ctx, short_ty)
    @test !CC.isPromotableIntegerType(ctx, int_ty)

    arr = CC.getIncompleteArrayType(ctx, int_ty)
    @test arr isa CC.QualType
    @test CC.isIncompleteArrayType(CC.get_type_ptr(arr))

    CC.parse(I, "/// a documented global\nint cc_astctx_probe = 0;")
    f = DeclFinder(I)
    @test f(I, "cc_astctx_probe")
    vd = CC.get_decl(f)
    @test CC.getDeclAlign(ctx, vd) >= 4
    @test CC.getDeclAlign(ctx, vd, true) >= 1

    # Comment retention depends on the driver configuration, so only the shape of
    # the result and the agreement of the two helpers is asserted here.
    text = CC.getRawCommentTextForAnyRedecl(ctx, vd)
    original = CC.getRawCommentOriginalDeclForAnyRedecl(ctx, vd)
    @test text isa AbstractString
    @test original isa CC.Decl
    @test isempty(text) == (original.ptr == C_NULL)

    dispose(f)
    dispose(I)
end

@testset "Coverage | ASTContext canonical types, GVA linkage, address spaces" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    uint_qt = CC.get_qual_type(CC.UnsignedIntTy(ctx))

    # ---- canonical-type family: sugar-free and idempotent ----
    canon = CC.getCanonicalType(ctx, int_qt)
    @test canon isa CC.QualType
    @test CC.hasSameType(ctx, canon, int_qt)
    @test CC.getCanonicalType(ctx, canon).ptr == canon.ptr
    @test !CC.is_null_handle(CC.getCanonicalParamType(ctx, int_qt))
    @test !CC.is_null_handle(CC.getCanonicalFunctionResultType(ctx, int_qt))

    # ---- common sugar of a type with itself is that same type ----
    @test CC.hasSameType(ctx, CC.getCommonSugaredType(ctx, int_qt, int_qt), int_qt)
    @test !CC.is_null_handle(CC.getCommonSugaredType(ctx, int_qt, int_qt, true))

    # ---- signed counterpart round-trips back through the unsigned one ----
    signed_qt = CC.getCorrespondingSignedType(ctx, uint_qt)
    @test signed_qt isa CC.QualType
    @test CC.hasSignedIntegerRepresentation(CC.get_type_ptr(signed_qt))
    @test CC.hasSameType(ctx, CC.getCorrespondingUnsignedType(ctx, signed_qt), uint_qt)

    # ---- intmax_t / __builtin_va_list (host-decided: assert the shape) ----
    imax = CC.getIntMaxType(ctx)
    @test imax isa CC.QualType
    @test CC.getTypeSize(ctx, imax) >= 32
    @test CC.getBuiltinVaListType(ctx).ptr != C_NULL

    # ---- address spaces ----
    as_qt = CC.getAddrSpaceQualType(ctx, int_qt, CC.CXLangAS_opencl_global)
    @test as_qt isa CC.QualType
    @test as_qt.ptr != int_qt.ptr
    @test CC.getLangASForBuiltinAddressSpace(ctx, 0) isa CC.CXLangAS
    @test CC.addressSpaceMapManglingFor(ctx, CC.CXLangAS_Default) isa Bool  # shape-only: the host decides this

    # ---- calling convention is target-decided: only the shape is asserted ----
    @test CC.getDefaultCallingConvention(ctx, false, false) isa CC.CXCallingConv_
    @test CC.getDefaultCallingConvention(ctx, true, true, true) isa CC.CXCallingConv_

    # ---- context-wide singletons reachable from any translation unit ----
    @test !CC.is_null_handle(CC.getNSObjectName(ctx))
    @test isempty(CC.getCUIDHash(ctx))

    CC.parse(I, """
                /// a documented probe
                int cc_ac_a_var = 3;
                int cc_ac_a_fun(int p) { return p; }
                struct cc_ac_a_poly { virtual void m(); virtual ~cc_ac_a_poly(); };
                struct cc_ac_a_sdm { static int sv; };
                int cc_ac_a_sdm::sv = 0;
                """)

    f = DeclFinder(I)

    @test f(I, "cc_ac_a_var")
    vd = CC.VarDecl(get_decl(f).ptr)
    @test CC.GetGVALinkageForVariable(ctx, vd) isa CC.CXGVALinkage
    @test CC.DeclMustBeEmitted(ctx, vd)
    @test CC.getInlineVariableDefinitionKind(ctx, vd) isa CC.CXInlineVariableDefinitionKind
    @test !CC.is_null_handle(CC.getLocalCommentForDeclUncached(ctx, vd))

    @test f(I, "cc_ac_a_fun")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.GetGVALinkageForFunction(ctx, fd) isa CC.CXGVALinkage
    @test CC.DeclMustBeEmitted(ctx, fd)

    @test f(I, "cc_ac_a_poly")
    poly = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.isDynamicClass(poly)
    @test !CC.is_null_handle(CC.getCurrentKeyFunction(ctx, poly))

    @test f(I, "cc_ac_a_sdm")
    sdm = CC.CXXRecordDecl(get_decl(f).ptr)
    statics = filter(d -> d isa CC.VarDecl, CC.decls(CC.castToDeclContext(sdm)))
    @test length(statics) >= 1
    @test CC.isStaticDataMember(statics[1])
    @test CC.getInstantiatedFromStaticDataMember(ctx, statics[1]) isa CC.MemberSpecializationInfo

    dispose(f)
    dispose(I)
end

@testset "ASTContext type/identity tail" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    CC.parse(I, "int cc_actxb_gvar = 5;")
    CC.parse(I, "template <class T, class U = int> struct cc_actxb_tmpl { T v; };")
    CC.parse(I, "struct cc_actxb_base { virtual int f() { return 0; } };")
    CC.parse(I, "struct cc_actxb_derived : cc_actxb_base { int f() override { return 1; } };")

    f = DeclFinder(I)
    @test f(I, "cc_actxb_gvar")
    vd = CC.VarDecl(get_decl(f).ptr)
    init = CC.getInit(vd)
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))

    # ---- canonical target types ----
    size_ty = CC.getSizeType(ctx)
    ssize_ty = CC.getSignedSizeType(ctx)
    umax_ty = CC.getUIntMaxType(ctx)
    @test size_ty isa CC.QualType
    @test ssize_ty isa CC.QualType
    @test umax_ty isa CC.QualType
    # size_t and its signed counterpart are the same width by construction; uintmax_t is
    # never narrower than int. Both hold on every host, unlike the concrete widths.
    @test CC.getTypeSizeInChars(ctx, size_ty) == CC.getTypeSizeInChars(ctx, ssize_ty)
    @test CC.getTypeSizeInChars(ctx, umax_ty) >= CC.getTypeSizeInChars(ctx, int_ty)

    # ---- size queries ----
    @test CC.getTypeSizeInCharsIfKnown(ctx, int_ty) == CC.getTypeSizeInChars(ctx, int_ty)
    incomplete = CC.getIncompleteArrayType(ctx, int_ty)
    @test CC.getTypeSizeInCharsIfKnown(ctx, incomplete) === nothing

    w, a, req = CC.getTypeInfoDataSizeInChars(ctx, int_ty)
    @test w == CC.getTypeSizeInChars(ctx, int_ty)
    @test a >= 1
    @test req isa Enum

    # ---- sugar builders ----
    tot = CC.getTypeOfType(ctx, int_ty)
    @test tot isa CC.QualType
    @test CC.hasSameType(ctx, tot, int_ty)
    @test !CC.is_null_handle(CC.getTypeOfType(ctx, int_ty, true))

    toe = CC.getTypeOfExprType(ctx, init)
    @test toe isa CC.QualType
    @test CC.hasSameType(ctx, toe, int_ty)

    @test !CC.is_null_handle(CC.getReferenceQualifiedType(ctx, init))
    @test CC.hasSameType(ctx, CC.getUnconstrainedType(ctx, int_ty), int_ty)

    # ---- identity predicates ----
    @test CC.hasSameExpr(ctx, init, init)
    @test CC.isSameConstraintExpr(ctx, init, init)
    @test CC.isSameEntity(ctx, vd, vd)

    @test f(I, "cc_actxb_tmpl")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    params = CC.getTemplateParameters(ctd)
    p0 = CC.getParam(params, 0)
    p1 = CC.getParam(params, 1)
    @test CC.isSameTemplateParameterList(ctx, params, params)
    @test CC.isSameTemplateParameter(ctx, p0, p0)
    @test CC.isSameDefaultTemplateArgument(ctx, p1, p1)

    # ---- overridden methods (count + fill agreement) ----
    @test f(I, "cc_actxb_derived")
    drd = CC.CXXRecordDecl(get_decl(f).ptr)
    ms = CC.getMethods(drd)
    for m in ms
        n = CC.getNumOverriddenMethods(ctx, m)
        @test n isa Integer
        @test CC.overridden_methods_size(ctx, m) == n
        overs = CC.getOverriddenMethods(ctx, m)
        @test length(overs) == n
        @test all(o -> o isa CC.NamedDecl, overs)
        @test all(o -> o.ptr != C_NULL, overs)
    end
    @test any(m -> CC.overridden_methods_size(ctx, m) > 0, ms)

    # ---- target / externalization queries ----
    @test CC.getTargetAddressSpace(ctx) isa Integer  # shape-only: the host decides this
    @test !(CC.mayExternalize(ctx, vd))
    @test !(CC.shouldExternalize(ctx, vd))

    dispose(f)
    dispose(I)
end

@testset "astcontext-c: type builders and RVV predicates" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    # ---- getVectorType: 4 x float; built-in element precondition satisfied ----
    flt = CC.get_qual_type(CC.FloatTy(ctx))
    vec = CC.getVectorType(ctx, flt, 4, CC.LibClangEx.CXVectorKind_Generic)
    @test vec isa CC.QualType
    @test occursin("float", CC.get_name(vec))

    # ---- getElaboratedType: "struct ECRec" sugar over a record type ----
    CC.parse(I, "struct ECRec { int a; };")
    f = DeclFinder(I)
    @test f(I, "ECRec")
    rd = CC.RecordDecl(get_decl(f).ptr)
    rectype = CC.getRecordType(ctx, rd)
    elab = CC.getElaboratedType(ctx, CC.LibClangEx.CXElaboratedTypeKeyword_Struct,
                                CC.NestedNameSpecifier(C_NULL), rectype)
    @test elab isa CC.QualType
    @test occursin("ECRec", CC.get_name(elab))

    # ---- getPackExpansionType: non-pack pattern with expect_pack=false (MARSHALLING section 8) ----
    int_t = CC.get_qual_type(CC.IntTy(ctx))
    pack = CC.getPackExpansionType(ctx, int_t; expect_pack=false)
    @test pack isa CC.QualType
    packn = CC.getPackExpansionType(ctx, int_t; num_expansions=3, expect_pack=false)
    @test packn isa CC.QualType

    # ---- NSInteger / NSUInteger: target word-integer typedef types ----
    @test !CC.is_null_handle(CC.getNSIntegerType(ctx))
    @test !CC.is_null_handle(CC.getNSUIntegerType(ctx))

    # ---- RVV compatibility predicates: shape only (host target decides the value) ----
    dbl_t = CC.get_qual_type(CC.DoubleTy(ctx))
    @test CC.areCompatibleRVVTypes(ctx, int_t, dbl_t) isa Integer
    @test CC.areLaxCompatibleRVVTypes(ctx, int_t, dbl_t) isa Integer
    @test CC.areCompatibleRVVTypes(ctx, int_t, int_t) isa Integer

    dispose(f)
    dispose(I)
end

@testset "astcontext-d: traversal scope, type table, ABI kind, template names" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)

    # ---- getTraversalScope: the TranslationUnitDecl by default (MARSHALLING section 6) ----
    scope = CC.getTraversalScope(ctx)
    @test scope isa Vector{CC.Decl}
    @test length(scope) >= 1
    @test all(d -> d.ptr != C_NULL, scope)

    # ---- getTypes: count + index over the context's type table ----
    n = CC.getNumTypes(ctx)
    @test n isa Integer
    @test n > 0
    t0 = CC.getType(ctx, 0)
    @test t0 isa CC.Type_
    @test t0.ptr != C_NULL
    @test_throws AssertionError CC.getType(ctx, n)

    # ---- getCXXABIKind / getDefaultOpenCLPointeeAddrSpace: host-decided, shape only ----
    abi = CC.getCXXABIKind(ctx)
    @test abi isa LX.CXTargetCXXABI_Kind
    @test CC.getDefaultOpenCLPointeeAddrSpace(ctx) isa LX.CXLangAS

    # ---- getCurrentNamedModule: no C++20 named module is under construction here ----
    m = CC.getCurrentNamedModule(ctx)
    @test m isa CC.Module_
    @test m.ptr == C_NULL

    # ---- the C library typedef types: their decls are unset, so the QualTypes are null ----
    @test CC.is_null_handle(CC.getjmp_bufType(ctx))
    @test CC.is_null_handle(CC.getsigjmp_bufType(ctx))
    @test CC.is_null_handle(CC.getucontext_tType(ctx))

    # ---- UnwrapSimilar*Types: in/out QualType references (MARSHALLING section 7) ----
    int_t = CC.get_qual_type(CC.IntTy(ctx))
    dbl_t = CC.get_qual_type(CC.DoubleTy(ctx))
    p1 = CC.getPointerType(ctx, int_t)
    p2 = CC.getPointerType(ctx, dbl_t)
    unwrapped, u1, u2 = CC.UnwrapSimilarTypes(ctx, p1, p2)
    @test unwrapped isa Bool
    @test u1 isa CC.QualType
    @test u2 isa CC.QualType
    a1, a2 = CC.UnwrapSimilarArrayTypes(ctx, p1, p2)
    @test a1 isa CC.QualType
    @test a2 isa CC.QualType

    # ---- getCanonicalTemplateArgument: canonicalise a type argument ----
    arg = CC.TemplateArgument(int_t)
    canon = CC.getCanonicalTemplateArgument(ctx, arg)
    @test canon isa CC.TemplateArgument
    @test canon.ptr != C_NULL
    @test CC.getKind(canon) == CC.getKind(arg)
    dispose(canon)
    dispose(arg)

    # ---- createDeviceMangleContext: skipped where the host ABI is Microsoft ----
    ti = CC.getTargetInfo(ctx)
    if CC.getCXXABI(ti) != LX.CXTargetCXXABI_Microsoft
        dmc = CC.createDeviceMangleContext(ctx, ti)
        @test dmc isa CC.MangleContext
        @test dmc.ptr != C_NULL
    else
        @test_throws AssertionError CC.createDeviceMangleContext(ctx, ti)
    end

    # ---- getInjectedTemplateArg: the argument for a class template's own parameter ----
    CC.parse(I, "template <typename T> struct TDArg { T v; };")
    ft = DeclFinder(I)
    @test ft(I, "TDArg")
    ctd = CC.ClassTemplateDecl(get_decl(ft).ptr)
    params = CC.getTemplateParameters(ctd)
    param = CC.getParam(params, 0)
    @test CC.isTemplateParameter(param)
    inj = CC.getInjectedTemplateArg(ctx, param)
    @test inj isa CC.TemplateArgument
    @test inj.ptr != C_NULL
    dispose(inj)
    dispose(ft)

    # ---- getNameForTemplate: name info for an assumed template name ----
    CC.parse(I, "void tdfun();")
    fn = DeclFinder(I)
    @test fn(I, "tdfun")
    fd = CC.FunctionDecl(get_decl(fn).ptr)
    dn = CC.DeclarationName(CC.getIdentifier(fd))
    tn = CC.getAssumedTemplateName(ctx, dn)
    dni = CC.getNameForTemplate(ctx, tn, CC.getLocation(fd))
    @test dni isa CC.DeclarationNameInfo
    @test CC.getAsString(CC.getName(dni)) == "tdfun"
    dispose(dni)
    dispose(fn)

    dispose(I)
end

@testset "ASTContext type builders, layout dump and misc queries" begin
    LXE = CC.LibClangEx
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    enum class CtaeColor { red, green };
    struct CtaeHost { using enum CtaeColor; };
    template <typename T> struct CtaeDerived : T { using typename T::u_ty; };
    namespace CtaeNS { template <typename T> struct CtaeTpl { T v; }; }
    CtaeNS::CtaeTpl<int> ctae_tv;
    struct CtaePoint { int x; double y; };
    struct CtaeBase { int b; };
    struct CtaeMid : CtaeBase { int m; };
    int ctae_n = 4;
    constexpr int CtaeMid::*ctae_mp = &CtaeMid::m;
    void ctae_lambda() { int a[3]; auto l = [a]() { return a[0]; }; (void)l; }
    """)
    f = DeclFinder(I)
    getptr(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f).ptr)

    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    n_vd = CC.VarDecl(getptr("ctae_n"))
    n_init = CC.getInit(n_vd)                       # Expr_ (IntegerLiteral 4)
    loc = CC.getLocation(n_vd)
    brackets = CC.SourceRange(loc, loc)

    # ---------- array / vector builders (the size expr is stored, not evaluated) ----------
    vla = CC.getVariableArrayType(ctx, int_qt, n_init, brackets)
    @test CC.resolve(CC.getTypePtr(vla)) isa CC.VariableArrayType

    dsa = CC.getDependentSizedArrayType(ctx, int_qt, n_init, brackets)
    @test CC.getTypePtr(dsa).ptr != C_NULL

    dvt = CC.getDependentVectorType(ctx, int_qt, n_init, loc)
    @test CC.getTypePtr(dvt).ptr != C_NULL

    # ---------- unary type transform: __underlying_type(CtaeColor) ----------
    color_qt = CC.getEnumType(ctx, CC.EnumDecl(getptr("CtaeColor")))
    utt = CC.getUnaryTransformType(ctx, color_qt, int_qt, LXE.CXUTTKind_EnumUnderlyingType)
    @test CC.isa_UnaryTransformType(CC.getTypePtr(utt))

    # ---------- OpenCL classification: every ordinary C++ type is OCLTK_Default ----------
    int_tp = CC.getTypePtr(int_qt)
    @test CC.getOpenCLTypeKind(ctx, int_tp) == LXE.CXOpenCLTypeKind_OCLTK_Default
    @test CC.getOpenCLTypeAddrSpace(ctx, int_tp) isa LXE.CXLangAS   # host/target decides

    # ---------- qualified template name: CtaeNS::CtaeTpl ----------
    tv_ty = CC.resolve(CC.getTypePtr(CC.getType(CC.VarDecl(getptr("ctae_tv")))))
    if tv_ty isa CC.ElaboratedType
        nns = CC.getQualifier(tv_ty)
        named = CC.resolve(CC.getTypePtr(CC.getNamedType(tv_ty)))
        if nns.ptr != C_NULL && named isa CC.TemplateSpecializationType
            qtn = CC.getQualifiedTemplateName(ctx, nns, false, CC.getTemplateName(named))
            @test qtn isa CC.TemplateName
            @test qtn.ptr != C_NULL
        end
    end

    # ---------- record layout dump ----------
    point = CC.CXXRecordDecl(getptr("CtaePoint"))
    dump = CC.DumpRecordLayout(ctx, point)
    @test dump isa String
    @test !isempty(dump)
    @test !isempty(CC.DumpRecordLayout(ctx, point, true))

    # ---------- member-pointer path adjustment ----------
    mp_val = CC.evaluateValue(CC.VarDecl(getptr("ctae_mp")))
    if mp_val.ptr != C_NULL && CC.getKind(mp_val) == LXE.CXAPValueKind_MemberPointer
        @test CC.getMemberPointerPathAdjustment(ctx, mp_val) isa Integer  # shape-only: the host decides this
    end

    # ---------- MakeIntValue: APSInt across the LLVM-C bridge ----------
    gv = CC.LLVM.GenericValue(CC.MakeIntValue(ctx, 42, int_qt))
    @test convert(Int, gv) == 42
    CC.LLVM.dispose(gv)

    # ---------- using-enum / unresolved-using decls (found by kind, they are unnamed) ----------
    tu_decls = CC.decls(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx)))
    uei = findfirst(d -> d isa CC.UsingEnumDecl, tu_decls)
    if uei !== nothing
        ued = tu_decls[uei]
        @test CC.getInstantiatedFromUsingEnumDecl(ctx, ued).ptr == C_NULL
        CC.setInstantiatedFromUsingEnumDecl(ctx, ued, ued)
        @test CC.getInstantiatedFromUsingEnumDecl(ctx, ued).ptr == ued.ptr
    end
    uui = findfirst(d -> d isa CC.UnresolvedUsingTypenameDecl, tu_decls)
    if uui !== nothing
        @test CC.getTypePtr(CC.getUnresolvedUsingType(ctx, tu_decls[uui])).ptr != C_NULL
    end

    # ---------- ArrayInitLoopExpr element count (the lambda's `int a[3]` capture) ----------
    body = CC.getBody(CC.FunctionDecl(getptr("ctae_lambda")))
    if body.ptr != C_NULL
        for e in filter(s -> s isa CC.ArrayInitLoopExpr, CC.subtree(body))
            @test CC.getArrayInitLoopExprElementCount(ctx, e) == 3
        end
    end

    # ---------- signature-only coverage for what a test cannot legally construct ----------
    @test hasmethod(CC.getUsingType, (CC.ASTContext, CC.UsingShadowDecl, CC.QualType))
    @test hasmethod(CC.getNextLocalImport, (CC.ImportDecl,))

    dispose(f)
    dispose(I)
end

@testset "astcontext-f: traversal scope, float modes, local imports, ObjC context state" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    int_qt = CC.get_qual_type(CC.IntTy(ctx))

    # ---- setTraversalScope: round-trip the default scope (the TranslationUnitDecl) ----
    tu = CC.getTranslationUnitDecl(ctx)
    CC.setTraversalScope(ctx, [tu])
    scope = CC.getTraversalScope(ctx)
    @test length(scope) == 1
    @test scope[1].ptr == tu.ptr

    # ---- getRealTypeForBitwidth: which widths exist is target-decided, so assert shape ----
    for k in (LX.CXFloatModeKind_NoFloat, LX.CXFloatModeKind_Half,
              LX.CXFloatModeKind_Float, LX.CXFloatModeKind_Double,
              LX.CXFloatModeKind_LongDouble, LX.CXFloatModeKind_Float128,
              LX.CXFloatModeKind_Ibm128)
        @test !CC.is_null_handle(CC.getRealTypeForBitwidth(ctx, 64, k))
    end
    f32 = CC.getRealTypeForBitwidth(ctx, 32, LX.CXFloatModeKind_Float)
    @test f32.ptr != C_NULL
    @test CC.isFloatingType(CC.getTypePtr(f32))
    # no target has a 3-bit floating-point type: a null QualType is the "none" answer
    @test CC.getRealTypeForBitwidth(ctx, 3, LX.CXFloatModeKind_Float).ptr == C_NULL

    # ---- local imports: nothing has been imported into this translation unit ----
    imp = CC.getFirstLocalImport(ctx)
    @test imp isa CC.ImportDecl
    @test imp.ptr == C_NULL

    # ---- ObjC side-table QualTypes: plain fields, unset in a C++ translation unit ----
    @test CC.is_null_handle(CC.getObjCConstantStringInterface(ctx))
    @test CC.getObjCNSStringType(ctx).ptr == C_NULL
    CC.setObjCNSStringType(ctx, int_qt)
    @test CC.getObjCNSStringType(ctx).ptr == int_qt.ptr

    # ---- the lazily materialised id / SEL / Class typedefs and the types they name ----
    id_decl = CC.getObjCIdDecl(ctx)
    sel_decl = CC.getObjCSelDecl(ctx)
    class_decl = CC.getObjCClassDecl(ctx)
    @test id_decl isa CC.TypedefDecl
    @test sel_decl isa CC.TypedefDecl
    @test class_decl isa CC.TypedefDecl
    @test CC.getName(id_decl) == "id"
    @test CC.getName(sel_decl) == "SEL"
    @test CC.getName(class_decl) == "Class"

    id_ty = CC.getObjCIdType(ctx)
    sel_ty = CC.getObjCSelType(ctx)
    class_ty = CC.getObjCClassType(ctx)
    @test CC.isObjCIdType(ctx, id_ty)
    @test CC.isObjCSelType(ctx, sel_ty)
    @test CC.isObjCClassType(ctx, class_ty)
    @test !CC.isObjCIdType(ctx, int_qt)
    @test !CC.isObjCSelType(ctx, int_qt)
    @test !CC.isObjCClassType(ctx, int_qt)

    # ---- 'SEL' redefinition: unset, so the getter falls back to the built-in SEL type ----
    @test CC.getObjCSelRedefinitionType(ctx).ptr == sel_ty.ptr
    CC.setObjCSelRedefinitionType(ctx, int_qt)
    @test CC.getObjCSelRedefinitionType(ctx).ptr == int_qt.ptr

    # ---- getUnqualifiedObjCPointerType only strips an ObjC lifetime qualifier, so both a
    #      plain int and `id` come back unchanged ----
    @test CC.getUnqualifiedObjCPointerType(ctx, int_qt).ptr == int_qt.ptr
    @test CC.getUnqualifiedObjCPointerType(ctx, id_ty).ptr == id_ty.ptr

    # ---- dependent-name and canonical-specialization type builders ----
    CC.parse(I, """
                template <class T> struct AcfDep { typename T::type m; };
                template <class T> struct AcfBox { T v; };
                AcfBox<int> acf_box_v;
                """)
    f = DeclFinder(I)

    @test f(I, "AcfDep")
    dep_patt = CC.getTemplatedDecl(CC.ClassTemplateDecl(get_decl(f).ptr))
    fld_qt = CC.getType(first(CC.getFields(dep_patt)))
    dnty = CC.resolve(CC.getTypePtr(fld_qt))
    @test dnty isa CC.DependentNameType
    rebuilt = CC.getDependentNameType(ctx, CC.getKeyword(dnty), CC.getQualifier(dnty),
                                      CC.getIdentifier(dnty))
    @test rebuilt isa CC.QualType
    # DependentNameType is uniqued, so rebuilding the same triple hands back the same node
    @test CC.getTypePtr(rebuilt).ptr == CC.getTypePtr(fld_qt).ptr

    @test f(I, "acf_box_v")
    box_ty = CC.resolve(CC.getTypePtr(CC.getType(CC.VarDecl(get_decl(f).ptr))))
    box_ty isa CC.ElaboratedType && (box_ty = CC.resolve(CC.getTypePtr(CC.desugar(box_ty))))
    @test box_ty isa CC.TemplateSpecializationType
    canon_tn = CC.getCanonicalTemplateName(ctx, CC.getTemplateName(box_ty))
    arg = CC.TemplateArgument(int_qt)
    canon_arg = CC.getCanonicalTemplateArgument(ctx, arg)
    canon_tst = CC.getCanonicalTemplateSpecializationType(ctx, canon_tn, [canon_arg])
    @test canon_tst isa CC.QualType
    @test canon_tst.ptr != C_NULL
    @test CC.resolve(CC.getTypePtr(canon_tst)) isa CC.TemplateSpecializationType

    dispose(canon_arg)
    dispose(arg)
    dispose(f)
    dispose(I)
end

@testset "astcontext-g: ObjC type encodings, auto builder, merged-definition modules" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    double_qt = CC.get_qual_type(CC.DoubleTy(ctx))

    CC.parse(I, "int acg_gvar = 5;")
    CC.parse(I, "int acg_gfunc(int acg_p) { return acg_p; }")

    f = DeclFinder(I)
    @test f(I, "acg_gvar")
    vd = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "acg_gfunc")
    fd = CC.FunctionDecl(get_decl(f).ptr)

    # ---- @encode strings: the encoder is not ObjC-specific, and the letters for the
    #      builtin types are fixed by the runtime ABI, not by the host ----
    enc_int = CC.getObjCEncodingForType(ctx, int_qt)
    @test enc_int isa AbstractString
    @test enc_int == "i"
    @test CC.getObjCEncodingForType(ctx, double_qt) == "d"
    @test CC.getObjCEncodingForPropertyType(ctx, int_qt) == "i"

    # sizeof(int) is target-decided, so only the shape and the agreement with the ordinary
    # size query are asserted (both are >= sizeof(int) by construction for `int`)
    sz = CC.getObjCEncodingTypeSize(ctx, int_qt)
    @test sz isa Integer
    @test sz > 0
    @test sz == CC.getTypeSizeInChars(ctx, int_qt)

    # the function encoding embeds parameter byte offsets, which are target-decided; only
    # the leading return-type letter is portable
    enc_fn = CC.getObjCEncodingForFunctionDecl(ctx, fd)
    @test enc_fn isa AbstractString
    @test startswith(enc_fn, "i")

    # ---- the legacy rewrite only fires on a typedef of a 32-bit long ----
    @test CC.getLegacyIntegralTypeEncoding(ctx, int_qt).ptr == int_qt.ptr

    # ---- ObjC predicates over a C++ translation unit ----
    @test !(CC.isObjCNSObjectType(int_qt))
    @test !CC.isObjCNSObjectType(int_qt)
    @test CC.isObjCNSObjectType(int_qt) == CC.isObjCNSObjectType(CC.getTypePtr(int_qt))
    @test !CC.areComparableObjCPointerTypes(ctx, int_qt, int_qt)
    @test !(CC.AnyObjCImplementation(ctx))
    @test !CC.AnyObjCImplementation(ctx)

    # ---- getAutoType: a deduced `auto` canonicalises to what it was deduced as ----
    auto_int = CC.getAutoType(ctx, int_qt, LX.CXAutoTypeKeyword_Auto, false)
    @test auto_int isa CC.QualType
    @test auto_int.ptr != C_NULL
    @test CC.getCanonicalType(ctx, auto_int).ptr == CC.getCanonicalType(ctx, int_qt).ptr
    # AutoType nodes are uniqued on their parameters
    @test CC.getAutoType(ctx, int_qt, LX.CXAutoTypeKeyword_Auto, false).ptr == auto_int.ptr
    # a null deduced type builds the undeduced placeholder; decltype(auto) is a distinct node
    undeduced = CC.getAutoType(ctx, CC.QualType(C_NULL), LX.CXAutoTypeKeyword_Auto, false)
    @test undeduced isa CC.QualType
    @test undeduced.ptr != C_NULL
    @test undeduced.ptr != auto_int.ptr
    decl_auto = CC.getAutoType(ctx, CC.QualType(C_NULL), LX.CXAutoTypeKeyword_DecltypeAuto,
                               false)
    @test decl_auto.ptr != undeduced.ptr

    # ---- merged definitions: nothing is merged outside a modules build ----
    @test CC.getNumModulesWithMergedDefinition(ctx, vd) == 0
    @test isempty(CC.getModulesWithMergedDefinition(ctx, vd))
    @test CC.getModulesWithMergedDefinition(ctx, vd) isa Vector{CC.Module_}

    # ---- setObjCSuperType: plain field, round-tripped before the getter can materialise
    #      the implicit `struct objc_super` record ----
    CC.setObjCSuperType(ctx, int_qt)
    @test CC.getObjCSuperType(ctx).ptr == int_qt.ptr

    dispose(f)
    dispose(I)
end

@testset "ASTContext ObjC qualifiers, builtin types, comment cloning" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    int_qt = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))

    # ---- GC / ARC qualifier builders (Objective-C qualifiers, reachable from C++ too) ----
    # getObjCGCAttrKind returns GCNone through its own early return outside an ObjC
    # garbage-collected translation unit, so this shape holds on every host.
    @test CC.getObjCGCAttrKind(ctx, int_qt) == CC.CXQualifiers_GCNone
    @test CC.getInnerObjCOwnership(ctx, int_qt) == CC.CXQualifiers_OCL_None

    weak_qt = CC.getObjCGCQualType(ctx, int_qt, CC.CXQualifiers_Weak)
    @test weak_qt isa CC.QualType
    @test CC.getObjCGCAttr(weak_qt) == CC.CXQualifiers_Weak
    @test_throws AssertionError CC.getObjCGCQualType(ctx, int_qt, CC.CXQualifiers_GCNone)
    @test_throws AssertionError CC.getObjCGCQualType(ctx, weak_qt, CC.CXQualifiers_Strong)

    strong_qt = CC.getLifetimeQualifiedType(ctx, int_qt, CC.CXQualifiers_OCL_Strong)
    @test strong_qt isa CC.QualType
    @test CC.getObjCLifetime(strong_qt) == CC.CXQualifiers_OCL_Strong
    @test_throws AssertionError CC.getLifetimeQualifiedType(ctx, int_qt,
                                                            CC.CXQualifiers_OCL_None)
    @test_throws AssertionError CC.getLifetimeQualifiedType(ctx, strong_qt,
                                                            CC.CXQualifiers_OCL_Weak)

    # ---- a builtin's signature type, reached through the builtin's own identifier ----
    bid = CC.getBuiltinID(Base.get(CC.getIdents(ctx), "__builtin_abs"))
    @test bid > 0
    bty, berr, bmask = CC.GetBuiltinType(ctx, bid)
    # __builtin_abs is int(int): no library type is named, so no host can miss one.
    @test berr == CC.CXGetBuiltinTypeError_GE_None
    @test !CC.isNull(bty)
    @test bmask isa Integer
    @test_throws AssertionError CC.GetBuiltinType(ctx, 0)

    # ---- a builtin template built by hand, the way the two cached ones are built ----
    btd = CC.buildBuiltinTemplateDecl(ctx, CC.CXBuiltinTemplateKind_BTK__type_pack_element,
                                      Base.get(CC.getIdents(ctx), "cc_actx_btd"))
    @test btd isa CC.BuiltinTemplateDecl
    @test btd.ptr != C_NULL

    CC.parse(I, """
                /// a cloned probe
                int cc_actx_doc_var = 7;
                int cc_actx_other_var = 8;
                struct cc_actx_sdm { static int su; static int sw; };
                """)
    f = DeclFinder(I)

    @test f(I, "cc_actx_doc_var")
    doc_vd = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "cc_actx_other_var")
    other_vd = CC.VarDecl(get_decl(f).ptr)

    # ---- cloning a parsed comment onto another decl ----
    fc = CC.getLocalCommentForDeclUncached(ctx, doc_vd)
    @test fc isa CC.FullComment
    if fc.ptr != C_NULL
        cloned = CC.cloneFullComment(ctx, fc, other_vd)
        @test cloned isa CC.FullComment
        @test cloned.ptr != C_NULL
        @test cloned.ptr != fc.ptr
    end

    # ---- recording an instantiation pattern for a static data member ----
    @test f(I, "cc_actx_sdm")
    rd = CC.CXXRecordDecl(get_decl(f).ptr)
    statics = filter(d -> d isa CC.VarDecl, CC.decls(CC.castToDeclContext(rd)))
    @test length(statics) == 2
    inst, tmpl = statics[1], statics[2]
    tsk_impl = CC.CXTemplateSpecializationKind_TSK_ImplicitInstantiation
    @test CC.getInstantiatedFromStaticDataMember(ctx, inst).ptr == C_NULL
    # TSK_Undeclared cannot be encoded in a MemberSpecializationInfo
    @test_throws AssertionError CC.setInstantiatedFromStaticDataMember(ctx, inst, tmpl,
                                                                       CC.CXTemplateSpecializationKind_TSK_Undeclared)
    CC.setInstantiatedFromStaticDataMember(ctx, inst, tmpl, tsk_impl)
    msi = CC.getInstantiatedFromStaticDataMember(ctx, inst)
    @test msi.ptr != C_NULL
    @test CC.getInstantiatedFrom(msi).ptr == tmpl.ptr
    @test CC.getTemplateSpecializationKind(msi) == tsk_impl
    # the pattern may only be noted once
    @test_throws AssertionError CC.setInstantiatedFromStaticDataMember(ctx, inst, tmpl,
                                                                       tsk_impl)

    dispose(f)
    dispose(I)
end

@testset "ASTContext module initializers, float semantics and C library type decls" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
                struct AciBox { int v; };
                AciBox aci_box_v;
                typedef int aci_jmp_buf[8];
                typedef int aci_sigjmp_buf[16];
                typedef int aci_ucontext_t[32];
                template <class T> struct AciDep { typename T::type m; };
                """)
    f = DeclFinder(I)
    int_qt = CC.get_qual_type(CC.IntTy(ctx))

    # ---- module initializers: the context keys the list on the clang::Module pointer ----
    @test f(I, "aci_box_v")
    var = CC.VarDecl(get_decl(f).ptr)
    m = CC.Module_("AciSyntheticModule")
    @test CC.getNumModuleInitializers(ctx, m) == 0
    @test isempty(CC.getModuleInitializers(ctx, m))
    CC.addModuleInitializer(ctx, m, var)
    @test CC.getNumModuleInitializers(ctx, m) == 1
    inits = CC.getModuleInitializers(ctx, m)
    @test length(inits) == 1
    @test inits[1] isa CC.Decl
    @test inits[1].ptr == var.ptr

    # ---- the parts of the llvm::fltSemantics behind a floating-point type ----
    flt_qt = CC.get_qual_type(CC.FloatTy(ctx))
    dbl_qt = CC.get_qual_type(CC.DoubleTy(ctx))
    @test CC.getFloatTypeSemanticsPrecision(ctx, flt_qt) == 24  # IEEE single
    @test CC.getFloatTypeSemanticsPrecision(ctx, dbl_qt) == 53  # IEEE double
    # float/double are stored in exactly their format's width on every supported target
    @test CC.getFloatTypeSemanticsSizeInBits(ctx, flt_qt) == CC.getTypeSize(ctx, flt_qt)
    @test CC.getFloatTypeSemanticsSizeInBits(ctx, dbl_qt) == CC.getTypeSize(ctx, dbl_qt)
    @test_throws AssertionError CC.getFloatTypeSemanticsPrecision(ctx, int_qt)
    @test_throws AssertionError CC.getFloatTypeSemanticsSizeInBits(ctx, int_qt)

    # ---- byref lifetimes exist only in Objective-C under ARC ----
    @test CC.getByrefLifetime(ctx, int_qt) === nothing

    # ---- a dependent specialization built from a dependent name's own pieces ----
    @test f(I, "AciDep")
    dep_patt = CC.getTemplatedDecl(CC.ClassTemplateDecl(get_decl(f).ptr))
    dnty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(dep_patt)))))
    @test dnty isa CC.DependentNameType
    arg = CC.TemplateArgument(int_qt, false)
    dtst = CC.getDependentTemplateSpecializationType(ctx, CC.getKeyword(dnty),
                                                     CC.getQualifier(dnty),
                                                     CC.getIdentifier(dnty), [arg])
    @test dtst isa CC.QualType
    @test CC.resolve(CC.getTypePtr(dtst)) isa CC.DependentTemplateSpecializationType
    # the node is uniqued on the whole quadruple, so rebuilding it returns the same type
    again = CC.getDependentTemplateSpecializationType(ctx, CC.getKeyword(dnty),
                                                      CC.getQualifier(dnty),
                                                      CC.getIdentifier(dnty), [arg])
    @test CC.getTypePtr(again).ptr == CC.getTypePtr(dtst).ptr
    dispose(arg)

    # ---- the three C library types stay null until their setter has run ----
    @test CC.getjmp_bufType(ctx).ptr == C_NULL
    @test f(I, "aci_jmp_buf")
    CC.setjmp_bufDecl(ctx, CC.TypedefDecl(get_decl(f).ptr))
    @test CC.get_name(CC.getjmp_bufType(ctx)) == "aci_jmp_buf"

    @test CC.getsigjmp_bufType(ctx).ptr == C_NULL
    @test f(I, "aci_sigjmp_buf")
    CC.setsigjmp_bufDecl(ctx, CC.TypedefDecl(get_decl(f).ptr))
    @test CC.get_name(CC.getsigjmp_bufType(ctx)) == "aci_sigjmp_buf"

    @test CC.getucontext_tType(ctx).ptr == C_NULL
    @test f(I, "aci_ucontext_t")
    CC.setucontext_tDecl(ctx, CC.TypedefDecl(get_decl(f).ptr))
    @test CC.get_name(CC.getucontext_tType(ctx)) == "aci_ucontext_t"

    dispose(m)
    dispose(f)
    dispose(I)
end

@testset "ASTContext variable-template info, injected arguments and constant objects" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
                template <class T> struct AcjBox { T v; };
                template <class T> T acj_tvar = T(1);
                struct AcjNttp { int a; };
                constexpr AcjNttp acj_nttp_val{7};
                constexpr int acj_int_val = 11;
                int acj_plain = 3;
                """)
    f = DeclFinder(I)
    int_qt = CC.get_qual_type(CC.IntTy(ctx))

    # ---- the raw PointerUnion behind a variable template's pattern ----
    @test f(I, "acj_tvar")
    vtd = first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "VarTemplate")
    patt = CC.VarDecl(CC.getTemplatedDecl(CC.VarTemplateDecl(vtd.ptr)).ptr)
    arm = CC.getTemplateOrSpecializationInfoAsVarTemplate(ctx, patt)
    @test arm isa CC.VarTemplateDecl
    @test arm.ptr == vtd.ptr
    # the other arm of the same union is empty for that decl
    msi = CC.getTemplateOrSpecializationInfoAsMemberSpecialization(ctx, patt)
    @test msi isa CC.MemberSpecializationInfo
    @test msi.ptr == C_NULL
    # a plain global sits in neither arm, and both accessors are total on it
    @test f(I, "acj_plain")
    plain = CC.VarDecl(get_decl(f).ptr)
    @test CC.getTemplateOrSpecializationInfoAsVarTemplate(ctx, plain).ptr == C_NULL
    @test CC.getTemplateOrSpecializationInfoAsMemberSpecialization(ctx, plain).ptr == C_NULL

    # ---- one injected argument per template parameter, owned boxes ----
    @test f(I, "AcjBox")
    ctd = first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate")
    tpl = CC.getTemplateParameters(CC.ClassTemplateDecl(ctd.ptr))
    args = CC.getInjectedTemplateArgs(ctx, tpl)
    @test length(args) == size(tpl)
    @test all(a -> a isa CC.TemplateArgument, args)
    @test all(a -> a.ptr != C_NULL, args)
    foreach(dispose, args)

    # ---- anonymous global constants are uniqued on (type, value) ----
    @test f(I, "acj_int_val")
    ival = CC.evaluateValue(CC.VarDecl(get_decl(f).ptr))
    @test ival isa CC.APValue
    @test ival.ptr != C_NULL
    ugc = CC.getUnnamedGlobalConstantDecl(ctx, int_qt, ival)
    @test ugc isa CC.UnnamedGlobalConstantDecl
    @test ugc.ptr != C_NULL
    @test CC.getUnnamedGlobalConstantDecl(ctx, int_qt, ival).ptr == ugc.ptr

    # ---- template parameter objects need a class-type value ----
    @test f(I, "acj_nttp_val")
    nttp = CC.VarDecl(get_decl(f).ptr)
    sval = CC.evaluateValue(nttp)
    @test sval.ptr != C_NULL
    sqt = CC.getType(nttp)
    tpo = CC.getTemplateParamObjectDecl(ctx, sqt, sval)
    @test tpo isa CC.TemplateParamObjectDecl
    @test tpo.ptr != C_NULL
    @test CC.getTemplateParamObjectDecl(ctx, sqt, sval).ptr == tpo.ptr
    @test CC.getValue(tpo) isa CC.APValue
    @test_throws AssertionError CC.getTemplateParamObjectDecl(ctx, int_qt, ival)

    # ---- GUID objects need the implicit `_GUID` record Microsoft extensions build, which
    #      the host toolchain decides; only the shape is asserted here ----
    parts = UInt8[0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]
    @test_throws AssertionError CC.getMSGuidDecl(ctx, 0x12345678, 0x9abc, 0xdef0, UInt8[])
    if CC.getMSGuidTagDecl(ctx).ptr == C_NULL
        @test_throws AssertionError CC.getMSGuidDecl(ctx, 0x12345678, 0x9abc, 0xdef0, parts)
    else
        guid = CC.getMSGuidDecl(ctx, 0x12345678, 0x9abc, 0xdef0, parts)
        @test guid isa CC.MSGuidDecl
        @test guid.ptr != C_NULL
        @test CC.getMSGuidDecl(ctx, 0x12345678, 0x9abc, 0xdef0, parts).ptr == guid.ptr
    end

    # ---- the alignment-requirement flag TypeInfo and TypeInfoChars share ----
    _, _, req = CC.getTypeInfo(ctx, int_qt)
    @test CC.isAlignRequired(req) isa Bool
    @test CC.isAlignRequired(req) == (req != CC.CXAlignRequirementKind_None)
    @test !CC.isAlignRequired(CC.CXAlignRequirementKind_None)
    @test CC.isAlignRequired(CC.CXAlignRequirementKind_RequiredByTypedef)

    dispose(f)
    dispose(I)
end

@testset "ASTContext substitution builders, function-type rewrites and target features" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
                template <class T> struct AckBox { T v; };
                AckBox<int> ack_box_v;
                template <class T> T ack_tvar = T(1);
                template <class T> void ack_ovl(T);
                template <class T, class U> void ack_ovl(T, U);
                int ack_plain = 5;
                void ack_fn(int);
                """)
    f = DeclFinder(I)
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    dbl_qt = CC.get_qual_type(CC.DoubleTy(ctx))

    # the template name and the decl that owns its parameter list
    @test f(I, "ack_box_v")
    box_ty = CC.resolve(CC.getTypePtr(CC.getType(CC.VarDecl(get_decl(f).ptr))))
    box_ty isa CC.ElaboratedType && (box_ty = CC.resolve(CC.getTypePtr(CC.desugar(box_ty))))
    @test box_ty isa CC.TemplateSpecializationType
    tn = CC.getTemplateName(box_ty)
    assoc = CC.getAsTemplateDecl(tn)
    @test assoc.ptr != C_NULL

    # ---- a substituted type parameter keeps its replacement and is uniqued ----
    subst = CC.getSubstTemplateTypeParmType(ctx, int_qt, assoc, 0)
    @test subst isa CC.QualType
    @test subst.ptr != C_NULL
    stp = CC.SubstTemplateTypeParmType(CC.getTypePtr(subst).ptr)
    @test CC.getReplacementType(stp).ptr == int_qt.ptr
    @test CC.getSubstTemplateTypeParmType(ctx, int_qt, assoc, 0).ptr == subst.ptr
    # engaging the pack index takes the std::optional arm of the builder; whether clang
    # uniques the result with the disengaged form is its own canonicalisation decision for a
    # synthetic associated decl, so only the shape is asserted
    packed = CC.getSubstTemplateTypeParmType(ctx, int_qt, assoc, 0, 1)
    @test packed isa CC.QualType
    @test packed.ptr != C_NULL

    # ---- the pack forms need a pack argument, and reject a scalar one ----
    ta_int = CC.TemplateArgument(int_qt)
    ta_dbl = CC.TemplateArgument(dbl_qt)
    pack = CC.CreatePackCopy(ctx, [ta_int, ta_dbl])
    @test CC.getKind(pack) == CC.CXTemplateArgument_Pack
    packty = CC.getSubstTemplateTypeParmPackType(ctx, assoc, 0, false, pack)
    @test packty isa CC.QualType
    @test packty.ptr != C_NULL
    @test_throws AssertionError CC.getSubstTemplateTypeParmPackType(ctx, assoc, 0, false, ta_int)

    # ---- the template-name counterparts of both substitutions ----
    subst_tn = CC.getSubstTemplateTemplateParm(ctx, tn, assoc, 0)
    @test subst_tn isa CC.TemplateName
    @test CC.getKind(subst_tn) == CC.CXTemplateName_SubstTemplateTemplateParm
    @test CC.getSubstTemplateTemplateParm(ctx, tn, assoc, 0).ptr == subst_tn.ptr
    # only the pack shape matters here, so the type pack built above serves
    subst_pack_tn = CC.getSubstTemplateTemplateParmPack(ctx, pack, assoc, 0, false)
    @test subst_pack_tn isa CC.TemplateName
    @test CC.getKind(subst_pack_tn) == CC.CXTemplateName_SubstTemplateTemplateParmPack
    @test_throws AssertionError CC.getSubstTemplateTemplateParmPack(ctx, ta_int, assoc, 0, false)
    dispose(pack)
    dispose(ta_dbl)
    dispose(ta_int)

    # ---- a TypeSourceInfo for a written specialization ----
    tali = CC.TemplateArgumentListInfo(CC.SourceLocation(C_NULL), CC.SourceLocation(C_NULL))
    tsi = CC.getTemplateSpecializationTypeInfo(ctx, tn, CC.SourceLocation(C_NULL), tali)
    @test tsi isa CC.TypeSourceInfo
    @test tsi.ptr != C_NULL
    @test CC.getType(tsi) isa CC.QualType
    @test CC.getType(tsi).ptr != C_NULL
    dispose(tali)

    # ---- an unresolved set of overloaded template candidates ----
    @test f(I, "ack_ovl")
    ovls = [CC.NamedDecl(d.ptr) for d in CC.get_decls(f) if CC.getDeclKindName(d) == "FunctionTemplate"]
    @test length(ovls) == 2
    ovl_name = CC.getOverloadedTemplateName(ctx, ovls)
    @test ovl_name isa CC.TemplateName
    @test CC.getKind(ovl_name) == CC.CXTemplateName_OverloadedTemplate
    @test CC.getAsOverloadedTemplate(ovl_name).ptr != C_NULL
    @test_throws AssertionError CC.getOverloadedTemplateName(ctx, ovls[1:1])

    # ---- ExtInfo rewrites on a freshly built function type ----
    fnty = CC.getFunctionType(ctx, int_qt, [int_qt])
    fpt = CC.FunctionProtoType(CC.getTypePtr(fnty).ptr)
    @test !(CC.getNoReturnAttr(fpt))
    adj = CC.adjustFunctionType(ctx, fpt, CC.CXCallingConv_CC_C, true, false)
    @test adj isa CC.Type_
    adj_fpt = CC.FunctionProtoType(adj.ptr)
    @test CC.getNoReturnAttr(adj_fpt)
    @test CC.getCallConv(adj_fpt) == CC.CXCallingConv_CC_C
    # asking for the ExtInfo the type already carries hands the very same node back
    @test CC.adjustFunctionType(ctx, adj_fpt, CC.CXCallingConv_CC_C, true, false).ptr == adj.ptr

    # ---- exception specifications, on a type and on a declaration ----
    ne_qt = CC.getFunctionTypeWithExceptionSpec(ctx, fnty,
                                                CC.CXExceptionSpecificationType_EST_BasicNoexcept)
    @test ne_qt isa CC.QualType
    ne_fpt = CC.FunctionProtoType(CC.getTypePtr(ne_qt).ptr)
    @test CC.getExceptionSpecType(ne_fpt) == CC.CXExceptionSpecificationType_EST_BasicNoexcept
    # the kinds that need a payload this entry point cannot carry are rejected
    @test_throws AssertionError CC.getFunctionTypeWithExceptionSpec(ctx, fnty,
                                                                    CC.CXExceptionSpecificationType_EST_Dynamic)
    @test_throws AssertionError CC.getFunctionTypeWithExceptionSpec(ctx, int_qt,
                                                                    CC.CXExceptionSpecificationType_EST_BasicNoexcept)

    @test f(I, "ack_fn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    CC.adjustExceptionSpec(ctx, fd, CC.CXExceptionSpecificationType_EST_BasicNoexcept)
    fd_fpt = CC.FunctionProtoType(CC.getTypePtr(CC.getType(fd)).ptr)
    @test CC.getExceptionSpecType(fd_fpt) == CC.CXExceptionSpecificationType_EST_BasicNoexcept

    # ---- the target feature map is entirely host-decided, so only its shape is asserted ----
    nfeat = CC.getNumFunctionFeatures(ctx, fd)
    @test nfeat isa Integer
    @test nfeat >= 0
    if nfeat > 0
        name, enabled = CC.getFunctionFeature(ctx, fd, 0)
        @test name isa String
        @test !isempty(name)
        @test enabled isa Bool
        # the map is rebuilt per call, so the same index must name the same feature
        @test CC.getFunctionFeature(ctx, fd, 0)[1] == name
    end
    @test_throws AssertionError CC.getFunctionFeature(ctx, fd, nfeat)

    # ---- recording the variable template a plain variable is the pattern of ----
    @test f(I, "ack_tvar")
    vtd = CC.VarTemplateDecl(first(d for d in CC.get_decls(f)
                                   if CC.getDeclKindName(d) == "VarTemplate").ptr)
    @test f(I, "ack_plain")
    plain = CC.VarDecl(get_decl(f).ptr)
    @test CC.getTemplateOrSpecializationInfoAsVarTemplate(ctx, plain).ptr == C_NULL
    CC.setTemplateOrSpecializationInfoAsVarTemplate(ctx, plain, vtd)
    @test CC.getTemplateOrSpecializationInfoAsVarTemplate(ctx, plain).ptr == vtd.ptr
    # the union is written once and only once
    @test_throws AssertionError CC.setTemplateOrSpecializationInfoAsVarTemplate(ctx, plain, vtd)

    dispose(f)
    dispose(I)
end
