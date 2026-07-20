using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx
# Skiplist-drain tail (AST half): dyn_cast probes, ArrayRef views, decl
# factories, DeclContext pivots, and the process-global stats toggles.
# Assertions are host-portable: isa/Bool checks and round-trips of values
# set inside this file only.
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

@testset "Decl setters and factories" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)

        CC.parse(I, """
            int gvar = 3;
            long lvar = 7;
            void gfunc(int p) { int loc0 = p; }
            struct SFoo { int fld : 3; int fld2; };
            enum EFoo { EA, EB };
            typedef int MyInt;
            namespace NS {}
            const char cstr[] = "hi";
        """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        vd = CC.VarDecl(look("gvar").ptr)
        lvd = CC.VarDecl(look("lvar").ptr)
        fd = CC.FunctionDecl(look("gfunc").ptr)
        rd = CC.getDefinition(CC.RecordDecl(look("SFoo").ptr))
        ed = CC.getDefinition(CC.EnumDecl(look("EFoo").ptr))
        tnd = CC.TypedefDecl(look("MyInt").ptr)
        csv = CC.VarDecl(look("cstr").ptr)

        # --- shared args (captured before any mutation) ---
        loc = CC.getLocation(vd)
        loc2 = CC.getLocation(lvd)
        id = CC.getIdentifier(vd)
        ty = CC.getType(vd)            # int QualType
        ty2 = CC.getType(lvd)           # long QualType
        tsi = CC.getTrivialTypeSourceInfo(ctx, ty, loc)
        name = CC.getDeclName(fd)
        fty = CC.getType(fd)            # function QualType
        ftsi = CC.getTrivialTypeSourceInfo(ctx, fty, loc)

        fields = CC.getFields(rd)
        fld = fields[1]                 # int fld : 3  (bitfield)
        fld2 = fields[2]                 # int fld2
        bw = CC.getBitWidth(fld)       # a reusable IntegerLiteral Expr
        ea = CC.getEnumerators(ed)[1]  # EA

        body = CC.getBody(fd)            # Stmt
        cs = CC.resolve(body)          # CompoundStmt

        sl_expr = CC.getInit(csv)
        sl = CC.resolve(sl_expr)         # StringLiteral (guarded below)

        # =========================================================
        # Factories: Create / CreateDeserialized
        # =========================================================
        @test CC.TranslationUnitDecl(ctx) isa CC.TranslationUnitDecl

        @test CC.LabelDecl(ctx, dc, loc, id) isa CC.LabelDecl
        @test CC.LabelDecl(ctx, 1) isa CC.LabelDecl

        @test CC.NamespaceDecl(ctx, 1) isa CC.NamespaceDecl

        @test CC.VarDecl(ctx, dc, loc, loc, id, ty, tsi, LX.CXStorageClass_SC_None) isa CC.VarDecl
        @test CC.VarDecl(ctx, 1) isa CC.VarDecl

        @test CC.ImplicitParamDecl(ctx, dc, loc, id, ty, LX.CXImplicitParamKind_CXXThis) isa CC.ImplicitParamDecl
        @test CC.ImplicitParamDecl(ctx, 1) isa CC.ImplicitParamDecl

        @test CC.ParmVarDecl(ctx, dc, loc, loc, id, ty, tsi, LX.CXStorageClass_SC_None) isa CC.ParmVarDecl
        @test CC.ParmVarDecl(ctx, 1) isa CC.ParmVarDecl

        @test CC.FunctionDecl(ctx, dc, loc, loc, name, fty, ftsi, LX.CXStorageClass_SC_None, false, true) isa
              CC.FunctionDecl
        @test CC.FunctionDecl(ctx, 1) isa CC.FunctionDecl

        @test CC.FieldDecl(ctx, dc, loc, loc, id, ty, tsi, CC.Expr_(C_NULL), false,
                           LX.CXInClassInitStyle_ICIS_NoInit) isa CC.FieldDecl
        @test CC.FieldDecl(ctx, 1) isa CC.FieldDecl

        @test CC.EnumConstantDecl(ctx, 1) isa CC.EnumConstantDecl

        @test CC.IndirectFieldDecl(ctx, 1) isa CC.IndirectFieldDecl

        @test CC.TypedefDecl(ctx, dc, loc, loc, id, tsi) isa CC.TypedefDecl
        @test CC.TypedefDecl(ctx, 1) isa CC.TypedefDecl

        @test CC.TypeAliasDecl(ctx, dc, loc, loc, id, tsi) isa CC.TypeAliasDecl
        @test CC.TypeAliasDecl(ctx, 1) isa CC.TypeAliasDecl

        @test CC.EnumDecl(ctx, dc, loc, loc, id) isa CC.EnumDecl
        @test CC.EnumDecl(ctx, 1) isa CC.EnumDecl

        @test CC.RecordDecl(ctx, LX.CXTagTypeKind_Struct, dc, loc, loc, id) isa CC.RecordDecl
        @test CC.RecordDecl(ctx, 1) isa CC.RecordDecl

        @test CC.ImportDecl(ctx, 1, 0) isa CC.ImportDecl

        @test CC.EmptyDecl(ctx, dc, loc) isa CC.EmptyDecl
        @test CC.EmptyDecl(ctx, 1) isa CC.EmptyDecl

        # =========================================================
        # New setters (skiplisted) — round-trips
        # =========================================================

        # FunctionDecl::setIsPureVirtual
        CC.setVirtualAsWritten(fd, true)
        CC.setIsPureVirtual(fd, true)
        @test CC.isPureVirtual(fd)

        # FieldDecl::setBitWidth
        CC.setBitWidth(fld2, bw)
        @test CC.isBitField(fld2)
        @test CC.getBitWidth(fld2).ptr == bw.ptr

        # FieldDecl::setInClassInitializer (fresh field w/ in-class-init storage)
        fdi = CC.FieldDecl(ctx, dc, loc, loc, id, ty, tsi, CC.Expr_(C_NULL), false,
                           LX.CXInClassInitStyle_ICIS_CopyInit)
        @test CC.hasInClassInitializer(fdi)
        CC.setInClassInitializer(fdi, bw)
        @test CC.getInClassInitializer(fdi).ptr == bw.ptr

        # EnumConstantDecl::setInitExpr
        CC.setInitExpr(ea, bw)
        @test CC.getInitExpr(ea).ptr == bw.ptr

        # TypedefNameDecl setters
        CC.setTypeSourceInfo(tnd, tsi)
        @test CC.getTypeSourceInfo(tnd).ptr == tsi.ptr
        CC.setModedTypeSourceInfo(tnd, tsi, ty2)
        @test CC.isModed(tnd)

        # EnumDecl setters
        CC.setScoped(ed, true);
        @test CC.isScoped(ed)
        CC.setScopedUsingClassTag(ed, true);
        @test CC.isScopedUsingClassTag(ed)
        CC.setFixed(ed, true);
        @test CC.isFixed(ed)
        CC.setIntegerType(ed, ty2);
        @test CC.getIntegerType(ed).ptr == ty2.ptr
        CC.setPromotionType(ed, ty);
        @test CC.getPromotionType(ed).ptr == ty.ptr
        CC.setIntegerTypeSourceInfo(ed, tsi);
        @test CC.getIntegerTypeSourceInfo(ed).ptr == tsi.ptr

        # TagDecl setters (on the complete SFoo record)
        CC.setTagKind(rd, LX.CXTagTypeKind_Union);
        @test CC.getTagKind(rd) == LX.CXTagTypeKind_Union
        CC.setBraceRange(rd, CC.SourceRange(loc, loc2))
        br = CC.getBraceRange(rd)
        @test br.begin_loc == loc && br.end_loc == loc2
        CC.setCompleteDefinitionRequired(rd, true);
        @test CC.isCompleteDefinitionRequired(rd)
        CC.setEmbeddedInDeclarator(rd, true);
        @test CC.isEmbeddedInDeclarator(rd)
        CC.setFreeStanding(rd, true);
        @test CC.isFreeStanding(rd)
        CC.setTypedefNameForAnonDecl(rd, tnd);
        @test CC.getTypedefNameForAnonDecl(rd).ptr == tnd.ptr

        # RecordDecl flag setters (data() is valid — SFoo is complete)
        CC.setHasFlexibleArrayMember(rd, true);
        @test CC.hasFlexibleArrayMember(rd)
        CC.setAnonymousStructOrUnion(rd, true);
        @test CC.isAnonymousStructOrUnion(rd)
        CC.setHasObjectMember(rd, true);
        @test CC.hasObjectMember(rd)
        CC.setHasVolatileMember(rd, true);
        @test CC.hasVolatileMember(rd)
        CC.setHasLoadedFieldsFromExternalStorage(rd, true);
        @test CC.hasLoadedFieldsFromExternalStorage(rd)
        CC.setNonTrivialToPrimitiveDefaultInitialize(rd, true);
        @test CC.isNonTrivialToPrimitiveDefaultInitialize(rd)
        CC.setNonTrivialToPrimitiveCopy(rd, true);
        @test CC.isNonTrivialToPrimitiveCopy(rd)
        CC.setNonTrivialToPrimitiveDestroy(rd, true);
        @test CC.isNonTrivialToPrimitiveDestroy(rd)
        CC.setHasNonTrivialToPrimitiveDefaultInitializeCUnion(rd, true);
        @test CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion(rd)
        CC.setHasNonTrivialToPrimitiveDestructCUnion(rd, true);
        @test CC.hasNonTrivialToPrimitiveDestructCUnion(rd)
        CC.setHasNonTrivialToPrimitiveCopyCUnion(rd, true);
        @test CC.hasNonTrivialToPrimitiveCopyCUnion(rd)
        CC.setParamDestroyedInCallee(rd, true);
        @test CC.isParamDestroyedInCallee(rd)
        CC.setArgPassingRestrictions(rd, LX.CXRecordDecl_APK_CannotPassInRegs)
        @test CC.getArgPassingRestrictions(rd) == LX.CXRecordDecl_APK_CannotPassInRegs
        CC.setCapturedRecord(rd);
        @test CC.isCapturedRecord(rd)

        # BlockDecl (fresh) setters
        bd = CC.BlockDecl(ctx, dc, loc)
        @test bd isa CC.BlockDecl
        @test CC.BlockDecl(ctx, 1) isa CC.BlockDecl
        CC.setSignatureAsWritten(bd, ftsi);
        @test CC.getSignatureAsWritten(bd).ptr == ftsi.ptr
        @test (CC.setBody(bd, cs); true)
        CC.setCapturesCXXThis(bd, true);
        @test CC.capturesCXXThis(bd)
        CC.setBlockMissingReturnType(bd, false);
        @test !CC.blockMissingReturnType(bd)
        CC.setIsConversionFromLambda(bd, true);
        @test CC.isConversionFromLambda(bd)
        CC.setDoesNotEscape(bd, true);
        @test CC.doesNotEscape(bd)
        CC.setCanAvoidCopyToHeap(bd, true);
        @test CC.canAvoidCopyToHeap(bd)
        CC.setBlockMangling(bd, 7, tu);
        @test CC.getBlockManglingNumber(bd) == 7

        # CapturedDecl (fresh) setters
        cd = CC.CapturedDecl(ctx, dc, 1)
        @test cd isa CC.CapturedDecl
        @test CC.CapturedDecl(ctx, 1, 1) isa CC.CapturedDecl
        CC.setNothrow(cd, true);
        @test CC.isNothrow(cd)
        CC.setBody(cd, body);
        @test CC.getBody(cd).ptr == body.ptr
        ipd = CC.ImplicitParamDecl(ctx, dc, loc, id, ty, LX.CXImplicitParamKind_CapturedContext)
        CC.setParam(cd, 0, ipd);
        @test CC.getParam(cd, 0).ptr == ipd.ptr
        CC.setContextParam(cd, 0, ipd);
        @test CC.getContextParam(cd).ptr == ipd.ptr

        # ExportDecl (fresh) setter
        exd = CC.ExportDecl(ctx, dc, loc)
        @test exd isa CC.ExportDecl
        @test CC.ExportDecl(ctx, 1) isa CC.ExportDecl
        CC.setRBraceLoc(exd, loc2);
        @test CC.getRBraceLoc(exd) == loc2

        # FileScopeAsmDecl (needs a StringLiteral)
        if sl isa CC.StringLiteral
            fsad = CC.FileScopeAsmDecl(ctx, dc, sl, loc, loc)
            @test fsad isa CC.FileScopeAsmDecl
            CC.setRParenLoc(fsad, loc2);
            @test CC.getRParenLoc(fsad) == loc2
            CC.setAsmString(fsad, sl);
            @test CC.getAsmString(fsad).ptr == sl.ptr
        end
        @test CC.FileScopeAsmDecl(ctx, 1) isa CC.FileScopeAsmDecl

        # AccessSpecDecl (fresh) setters
        asd = CC.AccessSpecDecl(ctx, LX.CXAccessSpecifier_AS_public, dc, loc, loc)
        @test asd isa CC.AccessSpecDecl
        @test CC.AccessSpecDecl(ctx, 1) isa CC.AccessSpecDecl
        CC.setColonLoc(asd, loc2);
        @test CC.getColonLoc(asd) == loc2
        CC.setAccessSpecifierLoc(asd, loc2);
        @test CC.getAccessSpecifierLoc(asd) == loc2

        # LinkageSpecDecl (fresh) setters
        lsd = CC.LinkageSpecDecl(ctx, dc, loc, loc, LX.CXLinkageSpecDecl_lang_c, true)
        @test lsd isa CC.LinkageSpecDecl
        @test CC.LinkageSpecDecl(ctx, 1) isa CC.LinkageSpecDecl
        CC.setLanguage(lsd, LX.CXLinkageSpecDecl_lang_cxx);
        @test CC.getLanguage(lsd) == LX.CXLinkageSpecDecl_lang_cxx
        CC.setExternLoc(lsd, loc2);
        @test CC.getExternLoc(lsd) == loc2
        CC.setRBraceLoc(lsd, loc2);
        @test CC.getRBraceLoc(lsd) == loc2

        # =========================================================
        # Already-wrapped setters — representative round-trips
        # =========================================================

        # VarDecl
        CC.setStorageClass(vd, LX.CXStorageClass_SC_Static);
        @test CC.getStorageClass(vd) == LX.CXStorageClass_SC_Static
        CC.setTSCSpec(vd, LX.CXThreadStorageClassSpecifier_TSCS_thread_local);
        @test CC.getTSCSpec(vd) == LX.CXThreadStorageClassSpecifier_TSCS_thread_local
        CC.setConstexpr(vd, true);
        @test CC.isConstexpr(vd)
        CC.setInitCapture(vd, true);
        @test CC.isInitCapture(vd)
        CC.setNRVOVariable(vd, true);
        @test CC.isNRVOVariable(vd)
        CC.setExceptionVariable(vd, true);
        @test CC.isExceptionVariable(vd)
        CC.setCXXForRangeDecl(vd, true);
        @test CC.isCXXForRangeDecl(vd)
        CC.setObjCForDecl(vd, true);
        @test CC.isObjCForDecl(vd)
        CC.setARCPseudoStrong(vd, true);
        @test CC.isARCPseudoStrong(vd)
        CC.setPreviousDeclInSameBlockScope(vd, true);
        @test CC.isPreviousDeclInSameBlockScope(vd)
        CC.setInlineSpecified(vd);
        @test CC.isInlineSpecified(vd)
        @test (CC.setImplicitlyInline(vd); true)
        @test (CC.setEscapingByref(vd); true)

        # FunctionDecl
        CC.setStorageClass(fd, LX.CXStorageClass_SC_Static);
        @test CC.getStorageClass(fd) == LX.CXStorageClass_SC_Static
        CC.setConstexprKind(fd, LX.CXConstexprSpecKind_Constexpr);
        @test CC.getConstexprKind(fd) == LX.CXConstexprSpecKind_Constexpr
        # isDeletedAsWritten() == IsDeleted && !isDefaulted, so probe it before setDefaulted
        CC.setDeletedAsWritten(fd, true);
        @test CC.isDeletedAsWritten(fd)
        CC.setTrivial(fd, true);
        @test CC.isTrivial(fd)
        CC.setTrivialForCall(fd, true);
        @test CC.isTrivialForCall(fd)
        CC.setDefaulted(fd, true);
        @test CC.isDefaulted(fd)
        CC.setExplicitlyDefaulted(fd, true);
        @test CC.isExplicitlyDefaulted(fd)
        CC.setHasWrittenPrototype(fd, true);
        @test CC.hasWrittenPrototype(fd)
        CC.setHasInheritedPrototype(fd, true);
        @test CC.hasInheritedPrototype(fd)
        CC.setHasImplicitReturnZero(fd, true);
        @test CC.hasImplicitReturnZero(fd)
        CC.setLateTemplateParsed(fd, true);
        @test CC.isLateTemplateParsed(fd)
        CC.setInstantiationIsPending(fd, true);
        @test CC.instantiationIsPending(fd)
        CC.setUsesSEHTry(fd, true);
        @test CC.usesSEHTry(fd)
        CC.setHasSkippedBody(fd, true);
        @test CC.hasSkippedBody(fd)
        CC.setWillHaveBody(fd, true);
        @test CC.willHaveBody(fd)
        CC.setIsMultiVersion(fd, true);
        @test CC.isMultiVersion(fd)
        CC.setInlineSpecified(fd, true);
        @test CC.isInlineSpecified(fd)
        @test (CC.setImplicitlyInline(fd, true); true)
        @test (CC.setRangeEnd(fd, loc); true)
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "FileScopeAsmDecl_Create round-trip" begin
    # Regression: clang_FileScopeAsmDecl_Create had cast the DeclContext (not the
    # Str param) to StringLiteral, so getAsmString returned garbage. A content
    # round-trip (not just isa) catches it.
    _fnd(::Type{T}, x) where {T} = x isa T ? x : (for c in CC.children(x)
                                                      ;
                                                      r = _fnd(T, CC.resolve(c));
                                                      r === nothing || return r;
                                                  end; nothing)
    I = create_interpreter(String[])
    CC.parse(I, "const char *asmstr = \"roundtrip_asm\";")
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)
    @test f(I, "asmstr")
    vd = CC.VarDecl(get_decl(f).ptr)
    sl = _fnd(CC.StringLiteral, CC.resolve(CC.getInit(vd)))
    @test sl !== nothing
    loc = CC.getLocation(vd)
    asmdecl = CC.FileScopeAsmDecl(ctx, dc, sl, loc, loc)
    @test asmdecl isa CC.FileScopeAsmDecl
    @test CC.getString(CC.getAsmString(asmdecl)) == "roundtrip_asm"   # was garbage before the fix
    dispose(f)
    dispose(I)
end

@testset "FunctionDecl_Create bool round-trip" begin
    # Regression: clang_FunctionDecl_Create omitted LLVM-18's UsesFPIntrin slot,
    # so (isInlineSpecified, hasWrittenPrototype) landed one argument to the left —
    # isInlineSpecified went into UsesFPIntrin, hasWrittenPrototype into
    # isInlineSpecified, and the real hasWrittenPrototype defaulted to true. A
    # content round-trip over two distinct flag combos catches the misalignment.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    CC.parse(I, "void ffn_seed(int p) {}")
    f = DeclFinder(I)
    @test f(I, "ffn_seed")
    seed = CC.FunctionDecl(get_decl(f).ptr)
    name = CC.getDeclName(seed)
    fty = CC.getType(seed)
    loc = CC.getLocation(seed)
    tsi = CC.getTrivialTypeSourceInfo(ctx, fty, loc)

    # inline + no-written-prototype
    fd1 = CC.FunctionDecl(ctx, dc, loc, loc, name, fty, tsi, LX.CXStorageClass_SC_None, true, false)
    @test CC.isInlineSpecified(fd1) == true       # was false before the fix
    @test CC.hasWrittenPrototype(fd1) == false     # was true (defaulted) before the fix

    # the complementary combo: non-inline + written-prototype
    fd2 = CC.FunctionDecl(ctx, dc, loc, loc, name, fty, tsi, LX.CXStorageClass_SC_None, false, true)
    @test CC.isInlineSpecified(fd2) == false
    @test CC.hasWrittenPrototype(fd2) == true

    dispose(f)
    dispose(I)
end

@testset "Decl factories, pivots & stats" begin
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
        d isa CC.LinkageSpecDecl && (lsd=d; break)
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
        n isa CC.MemberExpr && (me=n; break)
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

@testset "IndirectFieldDecl chain" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct AnonHost { union { int a; long b; }; };")
    f = DeclFinder(I)
    @test f(I, "AnonHost")
    host = get_decl(f)
    ifds = CC.IndirectFieldDecl[]
    for d in DeclIterator(host)
        CC.getDeclKindName(d) == "IndirectField" && push!(ifds, CC.IndirectFieldDecl(d.ptr))
    end
    @test length(ifds) == 2
    for ifd in ifds
        n = CC.getChainingSize(ifd)
        @test n == 2
        @test CC.getChainElement(ifd, n - 1).ptr == CC.getAnonField(ifd).ptr
    end
    dispose(f)
    dispose(I)
end

@testset "introspection accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct S { int a : 3; int b; }; int fn(){ return (int)3.5; }")
    f = DeclFinder(I)
    ctx = CC.get_ast_context(I)

    @test f(I, "S")
    rd = CC.CXXRecordDecl(get_decl(f).ptr)
    fields = collect(CC.getFields(rd))
    @test CC.getBitWidthValue(fields[1], ctx) == 3          # `int a : 3`
    @test !CC.isZeroSize(fields[1], ctx)
    @test CC.isMsStruct(rd, ctx) isa Bool                   # value is target-ABI-dependent (MS layout on Windows)

    @test f(I, "fn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.isFunctionOrFunctionTemplate(get_decl(f))
    csce = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(fd)))
        n isa CC.CStyleCastExpr && (csce=n; break)
    end
    @test csce !== nothing
    @test CC.getLParenLoc(csce) isa CC.SourceLocation
    @test CC.getRParenLoc(csce) isa CC.SourceLocation

    dispose(f)
    dispose(I)
end
