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
    @test CC.getPredefinedStringLiteralFromCache(ctx, "no_such_key") isa CC.StringLiteral

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
    @test CC.AtomicUsesUnsupportedLibcall(ctx, first(aes)) isa Bool

    igs = pick(CC.IndirectGotoStmt)
    @test !isempty(igs)
    @test CC.getGotoLoc(first(igs)) isa CC.SourceLocation
    @test CC.getStarLoc(first(igs)) isa CC.SourceLocation

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
    @test CC.getCanonicalTemplateName(ctx, tn) isa CC.TemplateName
    @test CC.hasSameTempalteName(ctx, tn, tn)
    @test CC.getDeducedTemplateSpecializationType(ctx, tn, int_qt, false) isa CC.QualType

    prd = CC.getDecl(injt)   # the pattern CXXRecordDecl; its TypeForDecl is the injected-class-name type
    tst_qt = CC.getInjectedSpecializationType(injt)
    @test CC.getInjectedClassNameType(ctx, prd, tst_qt) isa CC.QualType

    ttpd = CC.getDecl(ttpt)
    @test CC.getTemplateTypeParmType(ctx, CC.getDepth(ttpd), CC.getIndex(ttpd),
                                     CC.isParameterPack(ttpd), ttpd) isa CC.QualType

    dep_e = CC.getSizeExpr(dsaty)   # value-dependent DeclRefExpr to the N parameter
    loc = CC.getLocation(patt)
    @test CC.getDependentAddressSpaceType(ctx, int_qt, dep_e, loc) isa CC.QualType
    @test CC.getDependentBitIntType(ctx, false, dep_e) isa CC.QualType
    @test CC.getDependentSizedExtVectorType(ctx, int_qt, dep_e, loc) isa CC.QualType
    @test CC.getDependentSizedMatrixType(ctx, int_qt, dep_e, dep_e, loc) isa CC.QualType

    # dependent NNS + identifier from `typename T::foo::type`
    @assert f(I, "CtaDep")
    patt2 = CC.getTemplatedDecl(CC.ClassTemplateDecl(get_decl(f).ptr))
    dnty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(patt2)))))
    @test dnty isa CC.DependentNameType
    @test CC.getDependentTemplateName(ctx, CC.getQualifier(dnty), CC.getIdentifier(dnty)) isa CC.TemplateName

    # namespace-qualified NNS from `cta_ns::S cta_ns_sv;`
    ety = CC.resolve(CC.getTypePtr(CC.getType(CC.VarDecl(getptr("cta_ns_sv")))))
    @test ety isa CC.ElaboratedType
    nns = CC.getQualifier(ety)
    @test CC.getCanonicalNestedNameSpecifier(ctx, nns) isa CC.NestedNameSpecifier

    # ---------- DeclarationName / IdentifierInfo consumers ----------
    plain_fd = CC.FunctionDecl(getptr("cta_plain"))
    @test CC.getAssumedTemplateName(ctx, CC.getDeclName(plain_fd)) isa CC.TemplateName
    ii = Base.get(CC.getIdents(ctx), "cta_macro_name")
    @test CC.getMacroQualifiedType(ctx, int_qt, ii) isa CC.QualType

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
    @test CC.getCopyConstructorForExceptionObject(ctx, exrd) isa CC.CXXConstructorDecl

    # typedef'd unnamed struct
    @assert f(I, "CtaUT")
    td = CC.TypedefDecl(get_decl(f).ptr)
    ut_tag = CC.getAsTagDecl(CC.getTypePtr(CC.getUnderlyingType(td)))
    @test CC.addTypedefNameForUnnamedTagDecl(ctx, ut_tag, td) === nothing
    @test CC.getTypedefNameForUnnamedTagDecl(ctx, ut_tag) isa CC.TypedefNameDecl

    # unnamed struct with a declarator
    uv = CC.VarDecl(getptr("cta_unnamed_var"))
    uv_tag = CC.getAsTagDecl(CC.getTypePtr(CC.getType(uv)))
    @test CC.addDeclaratorForUnnamedTagDecl(ctx, uv_tag, uv) === nothing
    @test CC.getDeclaratorForUnnamedTagDecl(ctx, uv_tag) isa CC.DeclaratorDecl

    ded_fd = CC.FunctionDecl(getptr("cta_dedret"))
    @test CC.adjustDeducedFunctionResultType(ctx, ded_fd, CC.getReturnType(ded_fd)) === nothing

    @test CC.deduplicateMergedDefinitonsFor(ctx, plain_fd) === nothing
    @test CC.eraseDeclAttrs(ctx, plain_fd) === nothing

    # BOOL typedef registration + getBOOLType
    booltd = CC.buildImplicitTypedef(ctx, int_qt, "cta_BOOL")
    CC.setBOOLDecl(ctx, booltd)
    @test CC.getBOOLDecl(ctx).ptr != C_NULL
    @test CC.getBOOLType(ctx) isa CC.QualType

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
    @test CC.getMSGuidType(ctx) isa CC.TagType
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
    @test CC.getTypeSize(ctx, int_qt) isa Integer
    @test CC.getSizeOf(ctx, int_qt) isa Integer
    @test CC.getTypeAlign(ctx, int_qt) isa Integer
    @test CC.getTypeUnadjustedAlign(ctx, int_qt) isa Integer
    @test CC.getTypeAlignIfKnown(ctx, int_qt, 0) isa Integer
    @test CC.getPreferredTypeAlign(ctx, int_qt) isa Integer
    @test CC.getAlignOfGlobalVar(ctx, int_qt) isa Integer
    @test CC.getIntWidth(ctx, int_qt) isa Integer
    @test CC.getOpenMPDefaultSimdAlign(ctx, int_qt) isa Integer
    @test CC.getTargetNullPointerValue(ctx, ptr_qt) isa Integer
    @test CC.getCharWidth(ctx) isa Integer
    @test CC.getASTAllocatedMemory(ctx) isa Integer
    @test CC.getSideTableAllocatedMemory(ctx) isa Integer
    @test CC.getTargetDefaultAlignForAttributeAligned(ctx) isa Integer
    @test CC.isDependceAllowed(ctx) isa Integer

    # ---- type builders taking one QualType ----
    @test CC.getLValueReferenceType(ctx, int_qt) isa CC.QualType
    @test CC.getRValueReferenceType(ctx, int_qt) isa CC.QualType
    @test CC.getMemberPointerType(ctx, int_qt, CC.get_type_ptr(record_qt).ptr) isa CC.QualType
    @test CC.getComplexType(ctx, float_qt) isa CC.QualType
    @test CC.getConstType(ctx, int_qt) isa CC.QualType
    @test CC.getVolatileType(ctx, int_qt) isa CC.QualType
    @test CC.getRestrictType(ctx, ptr_qt) isa CC.QualType
    @test CC.getAtomicType(ctx, int_qt) isa CC.QualType
    @test CC.getParenType(ctx, int_qt) isa CC.QualType
    @test CC.getCVRQualifiedType(ctx, int_qt, 1) isa CC.QualType
    @test CC.getBaseElementType(ctx, array_qt) isa CC.QualType
    @test CC.getArrayDecayedType(ctx, array_qt) isa CC.QualType
    @test CC.getVariableArrayDecayedType(ctx, array_qt) isa CC.QualType
    @test CC.getDecayedType(ctx, array_qt) isa CC.QualType
    @test CC.getAdjustedParameterType(ctx, int_qt) isa CC.QualType
    @test CC.getSignatureParameterType(ctx, int_qt) isa CC.QualType
    @test CC.getExceptionObjectType(ctx, int_qt) isa CC.QualType
    @test CC.getComplexType(ctx, int_qt) isa CC.QualType
    @test CC.getExtVectorType(ctx, float_qt, 4) isa CC.QualType
    @test CC.getConstantMatrixType(ctx, float_qt, 2, 2) isa CC.QualType
    @test CC.getReadPipeType(ctx, int_qt) isa CC.QualType
    @test CC.getWritePipeType(ctx, int_qt) isa CC.QualType
    @test CC.getBitIntType(ctx, 0, 32) isa CC.QualType
    @test CC.getIntTypeForBitwidth(ctx, 32, 1) isa CC.QualType
    @test CC.getPromotedIntegerType(ctx, bool_qt) isa CC.QualType
    @test CC.getCorrespondingUnsignedType(ctx, int_qt) isa CC.QualType
    @test CC.getFunctionTypeWithoutPtrSizes(ctx, func_qt) isa CC.QualType
    @test CC.getAdjustedType(ctx, int_qt, int_qt) isa CC.QualType
    @test CC.getBlockDescriptorType(ctx) isa CC.QualType
    @test CC.getBlockDescriptorExtendedType(ctx) isa CC.QualType
    @test CC.removeAddrSpaceQualType(ctx, int_qt) isa CC.QualType
    @test CC.removePtrSizeAddrSpace(ctx, int_qt) isa CC.QualType
    @test CC.adjustStringLiteralBaseType(ctx, array_qt) isa CC.QualType
    @test CC.getStringLiteralArrayType(ctx, char_qt, 5) isa CC.QualType

    # ---- array-type views ----
    @test CC.getAsArrayType(ctx, array_qt) isa CC.ArrayType
    cat = CC.getAsConstantArrayType(ctx, array_qt)
    @test cat isa CC.ConstantArrayType
    @test CC.getAsIncompleteArrayType(ctx, array_qt) isa CC.IncompleteArrayType
    @test CC.getAsVariableArrayType(ctx, array_qt) isa CC.VariableArrayType
    @test CC.getAsDependentSizedArrayType(ctx, array_qt) isa CC.DependentSizedArrayType
    @test CC.getConstantArrayElementCount(ctx, cat) isa Integer

    # ---- predicates on QualTypes ----
    @test CC.hasUniqueObjectRepresentations(ctx, int_qt) isa Integer
    @test CC.isAlignmentRequired(ctx, int_qt) isa Integer
    @test CC.hasDirectOwnershipQualifier(ctx, int_qt) isa Integer

    # ---- type ordering ----
    @test CC.getFloatingTypeOrder(ctx, float_qt, double_qt) isa Integer
    @test CC.getFloatingTypeSemanticOrder(ctx, float_qt, double_qt) isa Integer
    @test CC.getIntegerTypeOrder(ctx, int_qt, uint_qt) isa Integer

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
    @test CC.mergeTypes(ctx, int_qt, int_qt, 0, 0, 0) isa CC.QualType
    @test CC.mergeFunctionTypes(ctx, func_qt, func_qt, 0, 0, 0) isa CC.QualType
    @test CC.mergeFunctionParameterTypes(ctx, int_qt, int_qt, 0, 0) isa CC.QualType
    @test CC.mergeTransparentUnionType(ctx, int_qt, int_qt, 0, 0) isa CC.QualType
    @test CC.mergeObjCGCQualifiers(ctx, int_qt, int_qt) isa CC.QualType

    # ---- no-argument QualType getters ----
    @test CC.getAutoDeductType(ctx) isa CC.QualType
    @test CC.getAutoRRefDeductType(ctx) isa CC.QualType
    if CC.getBOOLDecl(ctx).ptr != C_NULL        # getBOOLType aborts on a null (ObjC) BOOL decl
        @test CC.getBOOLType(ctx) isa CC.QualType
    end
    @test CC.getCFConstantStringType(ctx) isa CC.QualType
    @test CC.getRawCFConstantStringType(ctx) isa CC.QualType
    @test CC.getFILEType(ctx) isa CC.QualType
    @test CC.getObjCClassRedefinitionType(ctx) isa CC.QualType
    @test CC.getObjCIdRedefinitionType(ctx) isa CC.QualType
    @test CC.getObjCInstanceType(ctx) isa CC.QualType
    @test CC.getObjCProtoType(ctx) isa CC.QualType
    @test CC.getObjCSuperType(ctx) isa CC.QualType
    @test CC.getBuiltinMSVaListType(ctx) isa CC.QualType
    @test CC.getSignedWCharType(ctx) isa CC.QualType
    @test CC.getUnsignedWCharType(ctx) isa CC.QualType
    @test CC.getWCharType(ctx) isa CC.QualType
    @test CC.getWideCharType(ctx) isa CC.QualType
    @test CC.getWIntType(ctx) isa CC.QualType
    @test CC.getIntPtrType(ctx) isa CC.QualType
    @test CC.getUIntPtrType(ctx) isa CC.QualType
    @test CC.getPointerDiffType(ctx) isa CC.QualType
    @test CC.getUnsignedPointerDiffType(ctx) isa CC.QualType
    @test CC.getProcessIDType(ctx) isa CC.QualType
    @test CC.getLogicalOperationType(ctx) isa CC.QualType

    # ---- singleton object / table getters ----
    @test CC.getIdents(ctx) isa CC.IdentifierTable
    @test CC.getDiagnostics(ctx) isa CC.DiagnosticsEngine
    @test CC.getSourceManager(ctx) isa CC.SourceManager
    @test CC.getTargetInfo(ctx) isa CC.TargetInfo
    @test CC.getAuxTargetInfo(ctx) isa CC.TargetInfo
    @test CC.getLangOpts(ctx) isa CC.LangOptions
    @test CC.getTranslationUnitDecl(ctx) isa CC.TranslationUnitDecl
    @test CC.getExternCContextDecl(ctx) isa CC.ExternCContextDecl

    # ---- decl getters (no arg) ----
    @test CC.getBuiltinVaListDecl(ctx) isa CC.TypedefDecl
    @test CC.getBuiltinMSVaListDecl(ctx) isa CC.TypedefDecl
    @test CC.getVaListTagDecl(ctx) isa CC.Decl
    @test CC.getBOOLDecl(ctx) isa CC.TypedefDecl
    @test CC.getInt128Decl(ctx) isa CC.TypedefDecl
    @test CC.getUInt128Decl(ctx) isa CC.TypedefDecl
    @test CC.getObjCInstanceTypeDecl(ctx) isa CC.TypedefDecl
    @test CC.getCFContantStringDecl(ctx) isa CC.TypedefDecl
    @test CC.getCFConstantStringTagDecl(ctx) isa CC.RecordDecl
    @test CC.getMakeIntegerSeqDecl(ctx) isa CC.BuiltinTemplateDecl
    @test CC.getTypePackElementDecl(ctx) isa CC.BuiltinTemplateDecl
    msgt = CC.getMSGuidTagDecl(ctx)
    @test msgt isa CC.TagDecl
    if msgt.ptr != C_NULL                       # getMSGuidType aborts on a null MSGuidTagDecl
        @test CC.getMSGuidType(ctx) isa CC.TagType
    end
    @test CC.getcudaConfigureCallDecl(ctx) isa CC.FunctionDecl

    # ---- identifier-name getters ----
    @test CC.getBoolName(ctx) isa CC.IdentifierInfo
    @test CC.getMakeIntegerSeqName(ctx) isa CC.IdentifierInfo
    @test CC.getTypePackElementName(ctx) isa CC.IdentifierInfo
    @test CC.getNSCopyingName(ctx) isa CC.IdentifierInfo

    # ---- decl-argument accessors ----
    @test CC.getTypeDeclType(ctx, mytypedef) isa CC.QualType
    @test CC.getRecordType(ctx, CC.RecordDecl(point.ptr)) isa CC.QualType
    @test CC.getTagDeclType(ctx, point) isa CC.QualType
    @test CC.getTagDeclType(ctx, color) isa CC.QualType
    @test CC.getEnumType(ctx, color) isa CC.QualType
    @test CC.getTypedefType(ctx, mytypedef, int_qt) isa CC.QualType
    @test CC.getFieldOffset(ctx, field) isa Integer
    @test CC.getInstantiatedFromUnnamedFieldDecl(ctx, field) isa CC.FieldDecl
    @test CC.getManglingNumber(ctx, add_nd) isa Integer
    @test CC.getStaticLocalNumber(ctx, gv_vd) isa Integer
    @test CC.getInstantiatedFromUsingDecl(ctx, add_nd) isa CC.NamedDecl
    @test CC.getPrimaryMergedDecl(ctx, add_nd) isa CC.Decl
    @test CC.getCopyConstructorForExceptionObject(ctx, point) isa CC.CXXConstructorDecl
    @test CC.getDeclaratorForUnnamedTagDecl(ctx, point) isa CC.DeclaratorDecl
    @test CC.getTypedefNameForUnnamedTagDecl(ctx, point) isa CC.TypedefNameDecl
    @test CC.canBuiltinBeRedeclared(ctx, add_fd) isa Integer
    @test CC.isMSStaticDataMemberInlineDefinition(ctx, gv_vd) isa Integer
    @test CC.isNearlyEmpty(ctx, point) isa Integer
    @test CC.BlockRequiresCopying(ctx, int_qt, gv_vd) isa Integer

    # ---- expr-argument accessors ----
    @test CC.getDecltypeType(ctx, expr, int_qt) isa CC.QualType
    @test CC.isPromotableBitField(ctx, expr) isa CC.QualType
    @test CC.isSentinelNullExpr(ctx, expr) isa Integer

    # ---- TypeSourceInfo builders ----
    @test CC.CreateTypeSourceInfo(ctx, int_qt, 0) isa CC.TypeSourceInfo
    @test CC.getTrivialTypeSourceInfo(ctx, int_qt, CC.getLocation(add_fd)) isa CC.TypeSourceInfo

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
