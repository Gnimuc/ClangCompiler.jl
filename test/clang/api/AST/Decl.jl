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

using ClangCompiler: get_tag
@testset "coverage tail: decl-api" begin
    LXD = CC.LibClangEx

    # depth-first search for the first node whose resolved carrier is `T`
    function dkfind(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = dkfind(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    I = create_interpreter(String[])
    fnd = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)

        CC.parse(I, """
            int dk_gvar = 3;
            long dk_lvar = 7;
            int dk_noinit;
            void dk_gfunc(int p) { int dk_loc = p; (void)dk_loc; }
            void dk_lblfn() { dk_lbl: goto dk_lbl; }
            void dk_vlafn(int n) { int dk_vla[n]; (void)dk_vla; }
            struct DKS { int dk_fb : 3; int dk_fi; };
            enum DKE { DK_EA = 1, DK_EB };
            typedef int DKMyInt;
            namespace DKNS {}
            struct DKA { static int dka_s; };
            struct DKB { static int dkb_s; };
            static union { int dkiu_a; };
            template<typename T> void dk_tfn(T x) { (void)x; }
            template<typename T> using DKAlias = T;
            template<typename T> struct DK6S { static int dk6_sdm; void dk6_m(); };
            template<typename T> int DK6S<T>::dk6_sdm = 0;
            template<typename T> void DK6S<T>::dk6_m() {}
            template<typename T> struct DK7S { T v; DK7S* dk7_self; };
            DK7S<int> dk7_var;
            template<typename T> struct DK8Out { template<typename U> struct DK8In { U u; }; };
            DK8Out<int>::DK8In<char> dk8_var;
            template<typename T> T dk10_vt = T();
            template<> int dk10_vt<char> = 5;
            int dk10_use = dk10_vt<int>;
            const char* dk_cstr = "dk_hi";
        """)

        look(name) = (@assert fnd(I, name) "lookup failed: $name"; get_decl(fnd))

        # ================= Section A: captures =================
        # Each incremental parse gets its own TranslationUnitDecl, so the TU (and
        # its DeclContext) must be captured after `parse`.
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)
        vd_g = CC.VarDecl(look("dk_gvar").ptr)
        vd_l = CC.VarDecl(look("dk_lvar").ptr)
        vd_n = CC.VarDecl(look("dk_noinit").ptr)
        gfd = CC.FunctionDecl(look("dk_gfunc").ptr)
        lblfd = CC.FunctionDecl(look("dk_lblfn").ptr)
        vlafd = CC.FunctionDecl(look("dk_vlafn").ptr)
        tnd = CC.TypedefDecl(look("DKMyInt").ptr)
        nsd = CC.NamespaceDecl(look("DKNS").ptr)
        vd_cstr = CC.VarDecl(look("dk_cstr").ptr)

        gloc = CC.getLocation(vd_g)
        lloc = CC.getLocation(vd_l)
        id = CC.getIdentifier(vd_g)
        qt_int = CC.getType(vd_g)
        tsi = CC.getTrivialTypeSourceInfo(ctx, qt_int, gloc)

        einit = CC.getInit(vd_g)                       # Expr_ (IntegerLiteral 3)
        il = CC.resolve(einit)
        @test il isa CC.IntegerLiteral
        gv = CC.getValue(il)                           # LLVMGenericValueRef

        gname = CC.getDeclName(vd_g)
        gbody = CC.getBody(gfd)                        # Stmt
        gfdc = CC.castToDeclContext(gfd)
        fname = CC.getDeclName(gfd)
        gfty = CC.getType(gfd)
        gftsi = CC.getTrivialTypeSourceInfo(ctx, gfty, gloc)

        # ================= LabelDecl =================
        ls = dkfind(CC.LabelStmt, CC.resolve(CC.getBody(lblfd)))
        @test ls isa CC.LabelStmt
        ld = CC.getDecl(ls)
        @test ld isa CC.LabelDecl
        @test CC.getStmt(ld).ptr == ls.ptr
        CC.setStmt(ld, ls)
        @test CC.getStmt(ld).ptr == ls.ptr
        @test CC.isGnuLocal(ld) isa Bool
        CC.setLocStart(ld, gloc)
        @test CC.getSourceRange(ld) isa CC.SourceRange
        @test CC.isMSAsmLabel(ld) == false
        @test CC.isResolvedMSAsmLabel(ld) isa Bool
        CC.setMSAsmLabelResolved(ld)
        @test CC.isResolvedMSAsmLabel(ld) isa Bool
        # MSAsmName is an empty StringRef here, so the shim returns NULL and the
        # wrapper's unsafe_string throws (safely) before any dereference.
        @test_throws ArgumentError CC.getMSAsmLabel(ld)

        # ================= TranslationUnitDecl / NamespaceDecl =================
        CC.getAnonymousNamespace(tu, nsd)              # misnamed setter wrapper
        @test CC.getAnonymousNamespace(tu).ptr == nsd.ptr
        CC.setInline(nsd, true)
        @test CC.isInline(nsd)
        CC.setAnonymousNamespace(nsd, nsd)
        @test CC.getAnonymousNamespace(nsd).ptr == nsd.ptr
        CC.setLocStart(nsd, gloc)
        CC.setRBraceLoc(nsd, lloc)
        @test CC.getRBraceLoc(nsd) == lloc

        # ================= NamedDecl / ValueDecl / DeclaratorDecl =================
        vd_f1 = CC.VarDecl(ctx, dc, gloc, gloc, id, qt_int, tsi, LXD.CXStorageClass_SC_None)
        CC.setDeclName(vd_f1, gname)
        @test CC.getName(vd_f1) == "dk_gvar"

        CC.setType(vd_l, CC.getType(vd_l))
        @test CC.getType(vd_l).ptr == CC.getType(vd_l).ptr

        CC.setTypeSourceInfo(vd_g, tsi)
        @test CC.getTypeSourceInfo(vd_g).ptr == tsi.ptr
        CC.setInnerLocStart(vd_g, gloc)
        @test CC.getInnerLocStart(vd_g) == gloc

        # ================= VarDecl =================
        es1 = CC.ensureEvaluatedStmt(vd_g)
        @test es1 isa CC.EvaluatedStmt && es1.ptr != C_NULL
        @test CC.getEvaluatedStmt(vd_g).ptr == es1.ptr
        CC.demoteThisDefinitionToDeclaration(vd_g)
        @test CC.isThisDeclarationADemotedDefinition(vd_g)

        CC.setInit(vd_n, einit)
        @test CC.hasInit(vd_n)
        @test CC.getInit(vd_n).ptr == einit.ptr

        # static data members: DKA::dka_s gets member-specialization info from DKB::dkb_s
        @assert fnd(I, "DKA")
        rd_a = CC.getDefinition(CC.RecordDecl(get_tag(fnd).ptr))
        sdm_a = nothing
        for d in CC.DeclIterator(rd_a)
            CC.getDeclKindName(d) == "Var" || continue
            sdm_a = CC.VarDecl(d.ptr)
            break
        end
        @assert fnd(I, "DKB")
        rd_b = CC.getDefinition(CC.RecordDecl(get_tag(fnd).ptr))
        sdm_b = nothing
        for d in CC.DeclIterator(rd_b)
            CC.getDeclKindName(d) == "Var" || continue
            sdm_b = CC.VarDecl(d.ptr)
            break
        end
        @test sdm_a isa CC.VarDecl && sdm_b isa CC.VarDecl
        CC.setInstantiationOfStaticDataMember(sdm_a, sdm_b,
                                              LXD.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        @test CC.getInstantiatedFromStaticDataMember(sdm_a).ptr == sdm_b.ptr
        CC.setTemplateSpecializationKind(sdm_a,
                                         LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization, gloc)
        @test CC.getTemplateSpecializationKind(sdm_a) ==
              LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization

        # described var template on a fresh VarDecl
        @assert fnd(I, "dk10_vt")
        vtd = nothing
        for d in CC.get_decls(fnd)
            if CC.getDeclKindName(d) == "VarTemplate"
                vtd = CC.VarTemplateDecl(d.ptr)
                break
            end
        end
        @test vtd isa CC.VarTemplateDecl
        vd_f2 = CC.VarDecl(ctx, dc, gloc, gloc, id, qt_int, tsi, LXD.CXStorageClass_SC_None)
        CC.setInstantiationOfStaticDataMember(vd_f2, vtd)  # wraps setDescribedVarTemplate
        @test CC.getDescribedVarTemplate(vd_f2).ptr == vtd.ptr

        # ================= ImplicitParamDecl / ParmVarDecl =================
        ipd = CC.ImplicitParamDecl(ctx, dc, gloc, id, qt_int, LXD.CXImplicitParamKind_CXXThis)
        @test CC.getParameterKind(ipd) == LXD.CXImplicitParamKind_CXXThis

        parm_a = CC.ParmVarDecl(ctx, dc, gloc, gloc, id, qt_int, tsi, LXD.CXStorageClass_SC_None)
        parm_b = CC.ParmVarDecl(ctx, dc, gloc, gloc, id, qt_int, tsi, LXD.CXStorageClass_SC_None)

        CC.setDefaultArg(parm_a, einit)
        @test CC.hasDefaultArg(parm_a)
        @test CC.getDefaultArg(parm_a).ptr == einit.ptr
        CC.getDefaultArg(parm_a, einit)                # wraps setUninstantiatedDefaultArg
        @test CC.hasUninstantiatedDefaultArg(parm_a)
        @test CC.getUninstantiatedDefaultArg(parm_a).ptr == einit.ptr
        CC.setUnparsedDefaultArg(parm_a)
        @test CC.hasUnparsedDefaultArg(parm_a)
        CC.setHasInheritedDefaultArg(parm_a, true)
        @test CC.hasInheritedDefaultArg(parm_a)
        CC.setKNRPromoted(parm_a, true)
        @test CC.isKNRPromoted(parm_a)
        CC.setScopeInfo(parm_a, 1, 2)
        @test CC.getFunctionScopeDepth(parm_a) == 1
        @test CC.getFunctionScopeIndex(parm_a) == 2
        CC.setOwningFunction(parm_a, gfdc)
        @test CC.getDeclContext(parm_a).ptr == gfdc.ptr
        CC.setObjCMethodScopeInfo(parm_b, 2)
        @test CC.isObjCMethodParameter(parm_b)

        # ================= FunctionDecl =================
        mkfd() = CC.FunctionDecl(ctx, dc, gloc, gloc, fname, gfty, gftsi,
                                 LXD.CXStorageClass_SC_None, false, true)

        fd_f1 = mkfd()
        CC.setBody(fd_f1, gbody)
        @test CC.doesThisDeclarationHaveABody(fd_f1)
        @test CC.getBody(fd_f1).ptr == gbody.ptr

        fd_f2 = mkfd()
        @test (CC.setLazyBody(fd_f2, 0); true)

        fd_f3 = mkfd()
        @test (CC.setDefaultedFunctionInfo(fd_f3, C_NULL); true)

        fd_f4 = mkfd()
        CC.setPreviousDeclaration(fd_f4, gfd)
        @test CC.getPreviousDecl(fd_f4).ptr == gfd.ptr

        fd_f5 = mkfd()
        CC.setInstantiationOfMemberFunction(fd_f5, gfd,
                                            LXD.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        @test CC.getMemberSpecializationInfo(fd_f5).ptr != C_NULL
        CC.setTemplateSpecializationKind(fd_f5,
                                         LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization, gloc)
        @test CC.getTemplateSpecializationKind(fd_f5) ==
              LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization

        @assert fnd(I, "dk_tfn")
        ftd = nothing
        for d in CC.get_decls(fnd)
            if CC.getDeclKindName(d) == "FunctionTemplate"
                ftd = CC.FunctionTemplateDecl(d.ptr)
                break
            end
        end
        @test ftd isa CC.FunctionTemplateDecl
        fd_f6 = mkfd()
        CC.setDescribedFunctionTemplate(fd_f6, ftd)
        @test CC.getDescribedFunctionTemplate(fd_f6).ptr == ftd.ptr

        fd_f7 = mkfd()
        CC.setTrailingRequiresClause(fd_f7, einit)
        @test CC.getTrailingRequiresClause(fd_f7).ptr == einit.ptr

        # DeclaratorDecl::getTemplateParameterList via an out-of-line member of a
        # class template (the written `template<typename T>` list is stored on the
        # declarator).
        tplh = nothing
        for d in CC.DeclIterator(tu)
            k = CC.getDeclKindName(d)
            if k == "Var"
                cand = CC.VarDecl(d.ptr)
                if CC.getNumTemplateParameterLists(cand) > 0
                    tplh = cand
                    break
                end
            elseif k == "CXXMethod"
                cand = CC.CXXMethodDecl(d.ptr)
                if CC.getNumTemplateParameterLists(cand) > 0
                    tplh = cand
                    break
                end
            end
        end
        @test tplh !== nothing
        if tplh !== nothing
            @test CC.getTemplateParameterList(tplh, 0) isa CC.TemplateParameterList
        end

        # ================= TypeDecl / TypedefDecl =================
        # NOTE: the QualType convenience setTypeForDecl(x, ::QualType) is not
        # exercised — it forwards get_type_ptr's Type_ carrier to the raw-Ptr
        # method and always throws MethodError.
        typ0 = CC.getTypeForDecl(tnd)
        CC.setTypeForDecl(tnd, typ0)                   # raw CXType_ variant
        @test CC.getTypeForDecl(tnd) == typ0
        CC.setLocStart(tnd, gloc)
        @test CC.getBeginLoc(tnd) == gloc

        # ================= TagDecl =================
        @assert fnd(I, "DKS")
        td_s = CC.TagDecl(get_tag(fnd).ptr)
        @test CC.getDefinition(td_s) isa CC.TagDecl
        @test CC.getDefinition(td_s).ptr != C_NULL

        rec_f = CC.RecordDecl(ctx, LXD.CXTagTypeKind_Struct, dc, gloc, gloc, id)
        CC.startDefinition(rec_f)
        @test CC.isBeingDefined(rec_f)
        CC.setCompleteDefinition(rec_f, true)
        @test CC.isCompleteDefinition(rec_f)

        # ================= FieldDecl =================
        rd_s = CC.getDefinition(CC.RecordDecl(td_s.ptr))
        flds = CC.getFields(rd_s)
        fb = flds[1]
        @test CC.isBitField(fb)
        CC.removeBitWidth(fb)
        @test !CC.isBitField(fb)

        fld_ici = CC.FieldDecl(ctx, dc, gloc, gloc, id, qt_int, tsi, CC.Expr_(C_NULL), false,
                               LXD.CXInClassInitStyle_ICIS_CopyInit)
        CC.setInClassInitializer(fld_ici, einit)
        CC.removeInClassInitializer(fld_ici)
        @test !CC.hasInClassInitializer(fld_ici)

        # captured-VLA field on a fresh captured record
        vds = dkfind(CC.DeclStmt, CC.resolve(CC.getBody(vlafd)))
        @test vds isa CC.DeclStmt
        vla_d = CC.getSingleDecl(vds)
        @test CC.getDeclKindName(vla_d) == "Var"
        vla_vd = CC.VarDecl(vla_d.ptr)
        vla_qt = CC.getType(vla_vd)
        vla_ty = CC.resolve(CC.getTypePtr(vla_qt))
        @test vla_ty isa CC.VariableArrayType
        rec_f2 = CC.RecordDecl(ctx, LXD.CXTagTypeKind_Struct, dc, gloc, gloc, id)
        CC.setCapturedRecord(rec_f2)
        fld_vla = CC.FieldDecl(ctx, CC.DeclContext(rec_f2), gloc, gloc, id, vla_qt, tsi,
                               CC.Expr_(C_NULL), false, LXD.CXInClassInitStyle_ICIS_NoInit)
        CC.setCapturedVLAType(fld_vla, vla_ty)
        @test CC.hasCapturedVLAType(fld_vla)
        @test CC.getCapturedVLAType(fld_vla) isa CC.VariableArrayType

        # ================= EnumDecl / EnumConstantDecl =================
        ed = CC.getDefinition(CC.EnumDecl(look("DKE").ptr))
        enum_f = CC.EnumDecl(ctx, dc, gloc, gloc, id)
        CC.setInstantiationOfMemberEnum(enum_f, ed,
                                        LXD.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        CC.setTemplateSpecializationKind(enum_f,
                                         LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization, gloc)
        @test CC.getTemplateSpecializationKind(enum_f) ==
              LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization

        ecd = CC.EnumConstantDecl(ctx, ed, gloc, id, qt_int, CC.Expr_(C_NULL), gv)
        @test ecd isa CC.EnumConstantDecl

        # ================= CapturedDecl =================
        cd_f = CC.CapturedDecl(ctx, dc, 1)
        ipd2 = CC.ImplicitParamDecl(ctx, dc, gloc, id, qt_int,
                                    LXD.CXImplicitParamKind_CapturedContext)
        CC.setContextParam(cd_f, 0, ipd2)
        @test CC.getContextParamPosition(cd_f) == 0
        @test CC.getNumParams(cd_f) == 1

        # ================= ExportDecl =================
        exd = CC.ExportDecl(ctx, dc, gloc)
        @test CC.getExportLoc(exd) == gloc
        @test CC.hasBraces(exd) == false
        CC.setRBraceLoc(exd, lloc)
        @test CC.hasBraces(exd)
        @test CC.getEndLoc(exd) == lloc
        @test CC.getSourceRange(exd) isa CC.SourceRange

        # ================= FileScopeAsmDecl =================
        sl = dkfind(CC.StringLiteral, CC.resolve(CC.getInit(vd_cstr)))
        @test sl isa CC.StringLiteral
        fsad = CC.FileScopeAsmDecl(ctx, dc, sl, gloc, lloc)
        @test CC.getAsmLoc(fsad) == gloc
        @test CC.getSourceRange(fsad) isa CC.SourceRange

        # ================= ImportDecl =================
        # CreateImplicit stores the module pointer without dereferencing it.
        imp1 = CC.ImportDecl(ctx, dc, gloc, C_NULL, gloc)
        @test imp1 isa CC.ImportDecl
        # A deserialized import is incomplete: no identifier locs, safe getters.
        imp2 = CC.ImportDecl(ctx, 99, 0)
        @test CC.getNumIdentifierLocs(imp2) == 0
        @test CC.getSourceRange(imp2) isa CC.SourceRange

        # ================= IndirectFieldDecl =================
        @assert fnd(I, "dkiu_a")
        dif = get_decl(fnd)
        @test CC.getDeclKindName(dif) == "IndirectField"
        ifd = CC.IndirectFieldDecl(dif.ptr)
        @test CC.getVarDecl(ifd) isa CC.VarDecl
        @test CC.getVarDecl(ifd).ptr != C_NULL
        @test CC.getCanonicalDecl(ifd) isa CC.IndirectFieldDecl
        # base Decl receivers on the plain Decl carrier
        @test CC.getBeginLoc(dif) isa CC.SourceLocation
        @test CC.isOutOfLine(dif) isa Bool

        # ================= TypeAliasDecl =================
        @assert fnd(I, "DKAlias")
        tatd = nothing
        for d in CC.get_decls(fnd)
            if CC.getDeclKindName(d) == "TypeAliasTemplate"
                tatd = CC.TypeAliasTemplateDecl(d.ptr)
                break
            end
        end
        @test tatd isa CC.TypeAliasTemplateDecl
        tad_f = CC.TypeAliasDecl(ctx, dc, gloc, gloc, id, tsi)
        CC.setDescribedAliasTemplate(tad_f, tatd)
        @test CC.getDescribedAliasTemplate(tad_f).ptr == tatd.ptr

        # ================= DeclTemplate =================
        vd7 = CC.VarDecl(look("dk7_var").ptr)
        specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd7)))
        @test CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        spec = CC.ClassTemplateSpecializationDecl(specrec.ptr)
        stpl = CC.getSpecializedTemplate(spec)
        args = CC.getTemplateArgs(spec)
        newspec = CC.ClassTemplateSpecializationDecl(ctx, stpl, args)
        @test (CC.AddSpecialization(stpl, newspec); true)

        # TemplateName::getAsTemplateDecl via the pattern's injected-class-name
        # (the DK7S* self-pointer field inside the template pattern)
        p7 = CC.getTemplatedDecl(stpl)                 # pattern CXXRecordDecl
        flds7 = CC.getFields(p7)
        @test length(flds7) == 2
        pt7 = CC.resolve(CC.getTypePtr(CC.getType(flds7[2])))
        @test pt7 isa CC.PointerType
        inj = CC.resolve(CC.getTypePtr(CC.getPointeeType(pt7)))
        if inj isa CC.ElaboratedType
            inj = CC.resolve(CC.getTypePtr(CC.desugar(inj)))
        end
        @test inj isa CC.InjectedClassNameType
        tn = CC.getTemplateName(inj)
        @test CC.getAsTemplateDecl(tn) isa CC.TemplateDecl
        @test CC.getAsTemplateDecl(tn).ptr != C_NULL

        # member template of an instantiated class template -> member specialization
        vd8 = CC.VarDecl(look("dk8_var").ptr)
        rec8 = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd8)))
        @test CC.getDeclKindName(rec8) == "ClassTemplateSpecialization"
        spec8 = CC.ClassTemplateSpecializationDecl(rec8.ptr)
        stpl8 = CC.getSpecializedTemplate(spec8)
        CC.setMemberSpecialization(stpl8)
        @test CC.isMemberSpecialization(stpl8)

        # VarTemplateSpecializationDecl::getTemplateArgs
        vtsd = nothing
        for d in CC.DeclIterator(tu)
            if CC.getDeclKindName(d) == "VarTemplateSpecialization"
                vtsd = CC.VarTemplateSpecializationDecl(d.ptr)
                break
            end
        end
        @test vtsd !== nothing
        if vtsd !== nothing
            @test CC.getTemplateArgs(vtsd) isa CC.TemplateArgumentList
        end

        # ================= ExplicitSpecifier =================
        # clang::ExplicitSpecifier is a trivially-copyable one-word value
        # (PointerIntPair<Expr*, 2, ExplicitSpecKind>); a zeroed pointer-sized
        # buffer is a valid {ResolvedFalse, nullptr} instance.
        esp = Libc.malloc(Csize_t(sizeof(Ptr{Cvoid})))
        try
            unsafe_store!(Ptr{UInt}(esp), UInt(0))
            es = CC.ExplicitSpecifier(esp)
            @test CC.getKind(es) == LXD.CXExplicitSpecKind_ResolvedFalse
            @test CC.isSpecified(es) == false
            @test CC.isExplicit(es) isa Bool
            @test CC.isInvalid(es) isa Bool
            CC.setKind(es, LXD.CXExplicitSpecKind_ResolvedTrue)
            @test CC.getKind(es) == LXD.CXExplicitSpecKind_ResolvedTrue
            CC.setExpr(es, einit)
            @test CC.getExpr(es).ptr == einit.ptr
        finally
            Libc.free(esp)
        end

        # ================= DeclBase: contexts, add/remove, stats =================
        e1 = CC.EmptyDecl(ctx, dc, gloc)
        e2 = CC.EmptyDecl(ctx, dc, gloc)
        e3 = CC.EmptyDecl(ctx, dc, gloc)
        CC.setDeclContext(e1, dc)
        CC.setLexicalDeclContext(e1, dc)
        @test CC.getDeclContext(e1).ptr == dc.ptr
        CC.addDecl(dc, e1)
        @test CC.containsDecl(dc, e1)
        CC.removeDecl(dc, e1)
        @test !CC.containsDecl(dc, e1)
        CC.addDeclInternal(dc, e2)
        @test CC.containsDecl(dc, e2)
        CC.addHiddenDecl(dc, e3)
        @test CC.containsDecl(dc, e3)
        # NOTE: EnableStatistics/PrintStats are not exercised — their wrappers
        # pass the receiver to the 0-arg static-method bindings and always
        # throw MethodError.
    finally
        dispose(fnd)
        dispose(I)
    end
end

@testset "Coverage | Decl" begin
    I = create_interpreter(["-fblocks"])
    CC.parse(I, """
    namespace ns { int nsvar; namespace { int anon_v; } }
    inline namespace top_inl { int tinl_v; }

    const int cglob = 42;
    static int sglob = 7;
    extern int eglob;
    constexpr int cxglob = 2 + 3;
    int gvar = 10;

    typedef int MyInt;
    using MyAlias = double;

    enum Color { Red, Green = 5, Blue };
    enum class Scoped : long { A, B, C };

    struct Point {
        int x;
        int y : 3;
        double z;
        int : 0;
        static int count;
    };

    int variadic_fn(int a, double b, ...);
    int add(int a, int b) { return a + b; }
    extern "C" int cfunc(int);
    inline int inl_fn() { return 1; }
    static int sfunc() { return 0; }
    int withdef(int a, int b = 3);

    void host() {
        int addend = 10;
        int (^blk)(int) = ^int(int q){ return q + addend; };
        (void)blk;
    }
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    getptr(name) = (@assert f(I, name); get_decl(f).ptr)

    # ---------------- VarDecl / ValueDecl / DeclaratorDecl ----------------
    gvar = CC.VarDecl(getptr("gvar"))
    cxglob = CC.VarDecl(getptr("cxglob"))
    eglob = CC.VarDecl(getptr("eglob"))
    sglob = CC.VarDecl(getptr("sglob"))

    var_bools = (CC.hasLocalStorage, CC.isStaticLocal, CC.hasExternalStorage,
                 CC.hasGlobalStorage, CC.isExternC, CC.isInExternCContext,
                 CC.isInExternCXXContext, CC.isLocalVarDecl, CC.isLocalVarDeclOrParm,
                 CC.isFunctionOrMethodVarDecl, CC.isStaticDataMember, CC.isOutOfLine,
                 CC.isFileVarDecl, CC.hasInit, CC.hasConstantInitialization,
                 CC.isDirectInit, CC.isThisDeclarationADemotedDefinition,
                 CC.isExceptionVariable, CC.isNRVOVariable, CC.isCXXForRangeDecl,
                 CC.isObjCForDecl, CC.isARCPseudoStrong, CC.isInline, CC.isInlineSpecified,
                 CC.isConstexpr, CC.isInitCapture, CC.isParameterPack,
                 CC.isPreviousDeclInSameBlockScope, CC.isEscapingByref,
                 CC.isNonEscapingByref, CC.isKnownToBeDefined, CC.isWeak)
    for g in var_bools
        @test g(gvar) isa Bool
    end

    var_misc = (CC.getStorageClass, CC.getTSCSpec, CC.getStorageDuration,
                CC.getLanguageLinkage, CC.getTemplateSpecializationKind,
                CC.getTemplateSpecializationKindForInstantiation,
                CC.getInitializingDeclaration, CC.getNumTemplateParameterLists)
    for g in var_misc
        @test g(gvar) !== nothing
    end

    @test CC.getType(gvar) isa CC.QualType
    @test CC.getCanonicalDecl(gvar) isa CC.VarDecl
    @test CC.getActingDefinition(gvar) isa CC.VarDecl
    @test CC.getDefinition(gvar) isa CC.VarDecl
    @test CC.getAnyInitializer(gvar) isa CC.Expr_
    @test CC.getInit(gvar) isa CC.Expr_
    @test CC.getTemplateInstantiationPattern(gvar) isa CC.VarDecl
    @test CC.getInstantiatedFromStaticDataMember(gvar) isa CC.VarDecl
    @test CC.getDescribedVarTemplate(gvar) !== nothing
    @test CC.getPointOfInstantiation(gvar) isa CC.SourceLocation
    @test CC.evaluateValue(cxglob) isa CC.APValue
    @test CC.getSourceRange(gvar) isa CC.SourceRange
    @test CC.mightBeUsableInConstantExpressions(cxglob, ctx) isa Bool
    @test CC.isUsableInConstantExpressions(cxglob, ctx) isa Bool
    @test CC.hasICEInitializer(cxglob, ctx) isa Bool
    @test CC.hasExternalStorage(eglob) isa Bool
    @test CC.getStorageClass(sglob) !== nothing

    # DeclaratorDecl accessors
    @test CC.getTypeSourceInfo(gvar) isa CC.TypeSourceInfo
    @test CC.getInnerLocStart(gvar) isa CC.SourceLocation
    @test CC.getOuterLocStart(gvar) isa CC.SourceLocation
    @test CC.getBeginLoc(gvar) isa CC.SourceLocation
    @test CC.getQualifier(gvar) isa CC.NestedNameSpecifier
    @test CC.getTrailingRequiresClause(gvar) isa CC.Expr_
    @test CC.getTypeSpecStartLoc(gvar) isa CC.SourceLocation
    @test CC.getTypeSpecEndLoc(gvar) isa CC.SourceLocation

    # ---------------- NamedDecl (call on a plainly-named decl) ----------------
    named_bools = (CC.hasLinkage, CC.isCXXClassMember, CC.isCXXInstanceMember,
                   CC.hasExternalFormalLinkage, CC.isExternallyVisible,
                   CC.isExternallyDeclarable, CC.isLinkageValid, CC.hasLinkageBeenComputed)
    for g in named_bools
        @test g(gvar) isa Bool
    end
    @test CC.getName(gvar) isa String
    @test CC.getIdentifier(gvar) isa CC.IdentifierInfo
    @test CC.getDeclName(gvar) isa CC.DeclarationName
    @test CC.getUnderlyingDecl(gvar) isa CC.NamedDecl
    @test CC.getVisibility(gvar) !== nothing
    @test CC.getLinkageInternal(gvar) !== nothing
    @test CC.getFormalLinkage(gvar) !== nothing
    @test CC.getMostRecentDecl(gvar) !== nothing
    @test CC.declarationReplaces(gvar, gvar) isa Bool
    @test CC.isFunctionOrFunctionTemplate(gvar) isa Bool

    # ---------------- FunctionDecl ----------------
    add = CC.FunctionDecl(getptr("add"))
    vfn = CC.FunctionDecl(getptr("variadic_fn"))
    cfn = CC.FunctionDecl(getptr("cfunc"))
    sfn = CC.FunctionDecl(getptr("sfunc"))
    inl = CC.FunctionDecl(getptr("inl_fn"))
    wdf = CC.FunctionDecl(getptr("withdef"))

    fn_bools = (CC.isPureVirtual, CC.hasBody, CC.hasTrivialBody, CC.isDefined,
                CC.isThisDeclarationADefinition,
                CC.isThisDeclarationInstantiatedFromAFriendDefinition,
                CC.doesThisDeclarationHaveABody, CC.isVariadic, CC.isVirtualAsWritten,
                CC.isLateTemplateParsed, CC.isTrivial, CC.isTrivialForCall,
                CC.isDefaulted, CC.isExplicitlyDefaulted, CC.isUserProvided,
                CC.hasImplicitReturnZero, CC.hasPrototype, CC.hasWrittenPrototype,
                CC.hasInheritedPrototype, CC.isConstexpr, CC.isConstexprSpecified,
                CC.isConsteval, CC.instantiationIsPending, CC.usesSEHTry, CC.isDeleted,
                CC.isDeletedAsWritten, CC.isMain, CC.isMSVCRTEntryPoint,
                CC.isReservedGlobalPlacementOperator,
                CC.isReplaceableGlobalAllocationFunction, CC.isInlineBuiltinDeclaration,
                CC.isDestroyingOperatorDelete, CC.isExternC, CC.isInExternCContext,
                CC.isInExternCXXContext, CC.isGlobal, CC.isNoReturn, CC.hasSkippedBody,
                CC.willHaveBody, CC.isMultiVersion, CC.isCPUDispatchMultiVersion,
                CC.isCPUSpecificMultiVersion, CC.isTargetMultiVersion, CC.isInlineSpecified,
                CC.isInlined, CC.isInlineDefinitionExternallyVisible, CC.isMSExternInline,
                CC.doesDeclarationForceExternallyVisibleDefinition, CC.isStatic,
                CC.isOverloadedOperator, CC.isFunctionTemplateSpecialization,
                CC.isImplicitlyInstantiable, CC.isTemplateInstantiation, CC.isOutOfLine,
                CC.hasOneParamOrDefaultArgs)
    for g in fn_bools
        @test g(add) isa Bool
    end

    fn_misc = (CC.getConstexprKind, CC.getExceptionSpecType, CC.getStorageClass,
               CC.getLanguageLinkage, CC.getMultiVersionKind, CC.getTemplatedKind,
               CC.getTemplateSpecializationKind,
               CC.getTemplateSpecializationKindForInstantiation, CC.getMemoryFunctionKind,
               CC.getBuiltinID, CC.getNumParams, CC.getMinRequiredArguments, CC.getODRHash)
    for g in fn_misc
        @test g(add) !== nothing
    end

    @test CC.getExceptionSpecSourceRange(add) isa CC.SourceRange
    @test CC.getParametersSourceRange(add) isa CC.SourceRange
    @test CC.getReturnTypeSourceRange(add) isa CC.SourceRange
    @test CC.getSourceRange(add) isa CC.SourceRange
    @test CC.getNameInfo(add) !== nothing
    @test CC.getDefinition(add) isa CC.FunctionDecl
    @test CC.getBody(add) isa CC.Stmt
    @test CC.getCanonicalDecl(add) isa CC.FunctionDecl
    @test CC.getReturnType(add) isa CC.QualType
    @test CC.getDeclaredReturnType(add) isa CC.QualType
    @test CC.getCallResultType(add) isa CC.QualType
    @test CC.getLiteralIdentifier(add) isa CC.IdentifierInfo
    @test CC.getMemberSpecializationInfo(add) !== nothing
    @test CC.getDescribedFunctionTemplate(add) !== nothing
    @test CC.getInstantiatedFromMemberFunction(add) isa CC.FunctionDecl
    @test CC.getTemplateSpecializationInfo(add) !== nothing
    @test CC.getPrimaryTemplate(add) !== nothing
    @test CC.getTemplateSpecializationArgs(add) !== nothing
    @test CC.getTemplateSpecializationArgsAsWritten(add) !== nothing
    @test CC.getDependentSpecializationInfo(add) !== nothing
    @test CC.getPointOfInstantiation(add) isa CC.SourceLocation
    @test CC.getParamDecl(add, 0) !== nothing
    @test CC.isVariadic(vfn) isa Bool
    @test CC.getEllipsisLoc(vfn) !== nothing
    @test CC.isExternC(cfn) isa Bool
    @test CC.isStatic(sfn) isa Bool
    @test CC.isInlined(inl) isa Bool

    # ---------------- ParmVarDecl ----------------
    p0 = CC.getParamDecl(add, 0)
    pdef = CC.getParamDecl(wdf, 1)
    parm_bools = (CC.isObjCMethodParameter, CC.isDestroyedInCallee, CC.isKNRPromoted,
                  CC.hasDefaultArg, CC.hasUnparsedDefaultArg, CC.hasUninstantiatedDefaultArg,
                  CC.hasInheritedDefaultArg)
    for g in parm_bools
        @test g(p0) isa Bool
    end
    @test CC.getFunctionScopeDepth(p0) !== nothing
    @test CC.getFunctionScopeIndex(p0) !== nothing
    @test CC.getDefaultArgRange(p0) isa CC.SourceRange
    @test CC.getOriginalType(p0) isa CC.QualType
    @test CC.hasDefaultArg(pdef)
    @test CC.getDefaultArg(pdef) isa CC.Expr_

    # ---------------- RecordDecl / TagDecl / TypeDecl ----------------
    rd = CC.RecordDecl(getptr("Point"))
    rec_bools = (CC.hasFlexibleArrayMember, CC.isAnonymousStructOrUnion,
                 CC.isInjectedClassName, CC.isLambda, CC.isCapturedRecord,
                 CC.isOrContainsUnion, CC.canPassInRegisters,
                 CC.hasLoadedFieldsFromExternalStorage, CC.hasNonTrivialToPrimitiveCopyCUnion,
                 CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion,
                 CC.hasNonTrivialToPrimitiveDestructCUnion, CC.hasObjectMember,
                 CC.hasVolatileMember, CC.isNonTrivialToPrimitiveCopy,
                 CC.isNonTrivialToPrimitiveDefaultInitialize,
                 CC.isNonTrivialToPrimitiveDestroy, CC.isParamDestroyedInCallee)
    for g in rec_bools
        @test g(rd) isa Bool
    end
    @test CC.getNumFields(rd) isa Integer
    @test CC.getArgPassingRestrictions(rd) !== nothing
    @test CC.getPreviousDecl(rd) isa CC.RecordDecl
    @test CC.getMostRecentDecl(rd) isa CC.RecordDecl
    @test CC.getDefinition(rd) isa CC.RecordDecl
    @test CC.findFirstNamedDataMember(rd) isa CC.FieldDecl
    @test CC.isMsStruct(rd, ctx) isa Bool
    @test CC.ClassTemplateSpecializationDecl(rd) !== nothing

    # TagDecl-level accessors (dispatch to AbstractTagDecl via RecordDecl)
    tag_bools = (CC.isThisDeclarationADefinition, CC.isCompleteDefinition,
                 CC.isBeingDefined, CC.isFreeStanding, CC.isStruct, CC.isInterface,
                 CC.isClass, CC.isUnion, CC.isEnum, CC.hasNameForLinkage,
                 CC.isCompleteDefinitionRequired, CC.isDependentType,
                 CC.isEmbeddedInDeclarator, CC.mayHaveOutOfDateDef)
    for g in tag_bools
        @test g(rd) isa Bool
    end
    @test CC.DeclContext(rd) isa CC.DeclContext
    @test CC.getCanonicalDecl(rd) isa CC.TagDecl
    @test CC.getDefinition(rd) isa CC.RecordDecl
    @test CC.getKindName(rd) isa String
    @test CC.getTagKind(rd) !== nothing
    @test CC.getTypedefNameForAnonDecl(rd) isa CC.TypedefNameDecl
    @test CC.getQualifier(rd) isa CC.NestedNameSpecifier
    @test CC.getBraceRange(rd) isa CC.SourceRange
    @test CC.getInnerLocStart(rd) isa CC.SourceLocation
    @test CC.getOuterLocStart(rd) isa CC.SourceLocation
    @test CC.getSourceRange(rd) isa CC.SourceRange

    # NamedDecl -> TypeDecl cast + TypeDecl accessors
    rec_named = CC.NamedDecl(getptr("Point"))
    td_base = CC.TypeDecl(rec_named)
    @test td_base isa CC.TypeDecl
    @test CC.getTypeForDecl(rec_named) !== nothing
    @test CC.getTypeForDecl(td_base) !== nothing
    @test CC.getBeginLoc(td_base) isa CC.SourceLocation
    @test CC.getSourceRange(td_base) isa CC.SourceRange

    # ---------------- FieldDecl ----------------
    fields = CC.getFields(rd)
    @test !isempty(fields)
    for fld in fields
        @test CC.isBitField(fld) isa Bool
        @test CC.isMutable(fld) isa Bool
        @test CC.isUnnamedBitfield(fld) isa Bool
        @test CC.isAnonymousStructOrUnion(fld) isa Bool
        @test CC.hasCapturedVLAType(fld) isa Bool
        @test CC.hasInClassInitializer(fld) isa Bool
        @test CC.getFieldIndex(fld) isa Integer
        @test CC.getInClassInitStyle(fld) !== nothing
        @test CC.getBitWidth(fld) isa CC.Expr_
        @test CC.getCanonicalDecl(fld) isa CC.FieldDecl
        @test CC.getCapturedVLAType(fld) isa CC.VariableArrayType
        @test CC.getInClassInitializer(fld) isa CC.Expr_
        @test CC.getParent(fld) isa CC.RecordDecl
        @test CC.getSourceRange(fld) isa CC.SourceRange
        @test CC.isZeroLengthBitField(fld, ctx) isa Bool
        @test CC.isZeroSize(fld, ctx) isa Bool
    end
    bf = fields[findfirst(CC.isBitField, fields)]
    @test CC.getBitWidthValue(bf, ctx) isa Integer

    # ---------------- EnumDecl / EnumConstantDecl ----------------
    ed = CC.EnumDecl(getptr("Color"))
    sed = CC.EnumDecl(getptr("Scoped"))
    enum_bools = (CC.isClosed, CC.isClosedFlag, CC.isClosedNonFlag, CC.isComplete,
                  CC.isFixed, CC.isScoped, CC.isScopedUsingClassTag)
    for g in enum_bools
        @test g(ed) isa Bool
    end
    @test CC.isScoped(sed) isa Bool
    @test CC.getNumNegativeBits(ed) !== nothing
    @test CC.getNumPositiveBits(ed) !== nothing
    @test CC.getODRHash(ed) !== nothing
    @test CC.getNumEnumerators(ed) isa Integer
    @test CC.getCanonicalDecl(ed) isa CC.EnumDecl
    @test CC.getPreviousDecl(ed) isa CC.EnumDecl
    @test CC.getMostRecentDecl(ed) isa CC.EnumDecl
    @test CC.getDefinition(ed) isa CC.EnumDecl
    @test CC.getIntegerType(sed) isa CC.QualType
    @test CC.getInstantiatedFromMemberEnum(ed) isa CC.EnumDecl
    @test CC.getIntegerTypeRange(sed) isa CC.SourceRange
    @test CC.getIntegerTypeSourceInfo(sed) isa CC.TypeSourceInfo
    @test CC.getMemberSpecializationInfo(ed) !== nothing
    @test CC.getPromotionType(ed) isa CC.QualType
    @test CC.getTemplateInstantiationPattern(ed) isa CC.EnumDecl
    @test CC.getTemplateSpecializationKind(ed) !== nothing

    enumerators = CC.getEnumerators(ed)
    @test length(enumerators) == 3
    ec = enumerators[2]   # Green = 5
    @test CC.getEnumConstantDeclValue(ec) isa Integer
    @test CC.getCanonicalDecl(ec) isa CC.EnumConstantDecl
    @test CC.getInitExpr(ec) isa CC.Expr_
    @test CC.getSourceRange(ec) isa CC.SourceRange
    # NamedDecl -> EnumConstantDecl cast
    ec_named = CC.NamedDecl(ec.ptr)
    @test CC.EnumConstantDecl(ec_named) isa CC.EnumConstantDecl

    # ---------------- TypedefNameDecl / TypedefDecl / TypeAliasDecl ----------------
    td = CC.TypedefDecl(getptr("MyInt"))
    tad = CC.TypeAliasDecl(getptr("MyAlias"))
    @test CC.getUnderlyingType(td) isa CC.QualType
    @test CC.getCanonicalDecl(td) isa CC.TypedefNameDecl
    @test CC.getAnonDeclWithTypedefName(td) isa CC.TagDecl
    @test CC.isTransparentTag(td) isa Bool
    @test CC.getTypeSourceInfo(td) isa CC.TypeSourceInfo
    @test CC.isModed(td) isa Bool
    @test CC.getSourceRange(td) isa CC.SourceRange
    @test CC.getUnderlyingType(tad) isa CC.QualType
    @test CC.getDescribedAliasTemplate(tad) !== nothing
    @test CC.getSourceRange(tad) isa CC.SourceRange

    # ---------------- NamespaceDecl ----------------
    ns = CC.NamespaceDecl(getptr("ns"))
    tinl = CC.NamespaceDecl(getptr("top_inl"))
    @test CC.isAnonymousNamespace(ns) isa Bool
    @test CC.isInline(ns) isa Bool
    @test CC.isInline(tinl) isa Bool
    @test CC.isOriginalNamespace(ns) isa Bool
    @test CC.getOriginalNamespace(ns) isa CC.NamespaceDecl
    @test CC.getAnonymousNamespace(ns) isa CC.NamespaceDecl
    @test CC.getCanonicalDecl(ns) isa CC.NamespaceDecl
    @test CC.getSourceRange(ns) isa CC.SourceRange
    @test CC.getBeginLoc(ns) isa CC.SourceLocation
    @test CC.getRBraceLoc(ns) isa CC.SourceLocation

    # ---------------- TranslationUnitDecl ----------------
    tu = CC.getTranslationUnitDecl(gvar)
    @test CC.getASTContext(tu) isa CC.ASTContext
    @test CC.getAnonymousNamespace(tu) isa CC.NamespaceDecl

    # ---------------- BlockDecl (reached via the recursive decl walk) ----------------
    all_decls = CC.decls(CC.castToDeclContext(tu))
    blk = all_decls[findfirst(d -> d isa CC.BlockDecl, all_decls)]
    addend = all_decls[findfirst(d -> d isa CC.VarDecl && CC.getName(d) == "addend", all_decls)]
    blk_bools = (CC.blockMissingReturnType, CC.canAvoidCopyToHeap, CC.capturesCXXThis,
                 CC.doesNotEscape, CC.hasCaptures, CC.isConversionFromLambda, CC.isVariadic)
    for g in blk_bools
        @test g(blk) isa Bool
    end
    @test CC.getBlockManglingContextDecl(blk) isa CC.Decl
    @test CC.getBlockManglingNumber(blk) !== nothing
    @test CC.getCaretLocation(blk) isa CC.SourceLocation
    @test CC.getNumCaptures(blk) !== nothing
    @test CC.getNumParams(blk) !== nothing
    @test CC.getSignatureAsWritten(blk) isa CC.TypeSourceInfo
    @test CC.getSourceRange(blk) isa CC.SourceRange
    @test CC.capturesVariable(blk, addend) isa Bool
    @test CC.getParamDecl(blk, 0) isa CC.ParmVarDecl
    @test CC.getParams(blk) isa Vector{CC.ParmVarDecl}

    dispose(f)
    dispose(I)
end

@testset "Coverage | fixed wrapper arity bugs" begin
    # Regression for three wrappers whose Julia arity/name had drifted from the
    # binding so any call errored (never covered before).
    I = create_interpreter(String[])
    CC.parse(I, "int gvfix = 0; int plainfix(int a){ return a; } struct Afix { virtual void p() = 0; virtual void q(); };")
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    @test f(I, "gvfix")
    @test CC.isNoDestroy(CC.VarDecl(get_decl(f).ptr), ctx) isa Bool     # was: missing ctx arg

    @test f(I, "plainfix")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.getTemplateInstantiationPattern(fd, true) isa CC.FunctionDecl  # was: missing for_def arg

    @test f(I, "Afix")
    afix = CC.CXXRecordDecl(get_decl(f).ptr)
    @test any(m -> CC.isPureVirtual(m), CC.getMethods(afix))            # isPure removed; isPureVirtual is the live one

    dispose(f)
    dispose(I)
end

@testset "Decl tail: visibility, destruction, allocation-function info" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        CC.parse(I, """
        struct DtTailTrivial { int a; };
        struct DtTailNonTrivial { ~DtTailNonTrivial(); };
        int dt_tail_plain = 1;
        DtTailTrivial dt_tail_triv;
        DtTailNonTrivial dt_tail_nontriv;
        __attribute__((visibility("hidden"))) int dt_tail_hidden = 2;
        void dt_tail_fn();
        """)
        D(name, T) = (f(I, name); T(get_decl(f).ptr))
        ctx = CC.get_ast_context(I)

        # VarDecl::needsDestruction — the ASTContext-taking query.
        @test CC.needsDestruction(D("dt_tail_plain", CC.VarDecl), ctx) ==
              LX.CXDestructionKind_DK_none
        @test CC.needsDestruction(D("dt_tail_triv", CC.VarDecl), ctx) ==
              LX.CXDestructionKind_DK_none
        @test CC.needsDestruction(D("dt_tail_nontriv", CC.VarDecl), ctx) !=
              LX.CXDestructionKind_DK_none

        # NamedDecl::getLinkageAndVisibility — the LinkageInfo aggregate.
        plain = D("dt_tail_plain", CC.VarDecl)
        linkage, visibility, is_explicit = CC.getLinkageAndVisibility(plain)
        @test linkage isa LX.CXLinkage
        @test visibility isa LX.CXVisibility
        @test is_explicit isa Bool
        @test visibility == CC.getVisibility(plain)   # same LinkageInfo field
        @test linkage == CC.getLinkageInternal(plain)

        # NamedDecl::getExplicitVisibility — the std::optional surface.
        @test CC.getExplicitVisibility(plain) === nothing
        @test CC.getExplicitVisibility(plain, true) === nothing
        # The visibility attribute is honoured only on targets that support it
        # (it is ignored for COFF), so accept either branch of the optional.
        hidden_vis = CC.getExplicitVisibility(D("dt_tail_hidden", CC.VarDecl))
        @test hidden_vis === nothing || hidden_vis isa LX.CXVisibility

        # FunctionDecl allocation-function info: an ordinary function is not a
        # replaceable global allocation function and requests no alignment.
        fn = D("dt_tail_fn", CC.FunctionDecl)
        replaceable, alignment_param, is_nothrow = CC.getReplaceableGlobalAllocationFunctionInfo(fn)
        @test replaceable == CC.isReplaceableGlobalAllocationFunction(fn)
        @test replaceable === false
        @test alignment_param === nothing
        @test is_nothrow isa Bool
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "Decl DeclContext pivots (castTo/castFrom)" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)

        CC.parse(I, """
                 namespace NSpivot {}
                 void fpivot(int p) {}
                 """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        nd = CC.NamespaceDecl(look("NSpivot").ptr)
        fd = CC.FunctionDecl(look("fpivot").ptr)

        # Each Decl that is also a DeclContext crosses to its DeclContext subobject
        # and back; castFrom is the offset-exact inverse, so the pointer round-trips.

        # TranslationUnitDecl <-> DeclContext
        tu_dc = CC.DeclContext(tu)
        @test tu_dc isa CC.DeclContext
        @test CC.TranslationUnitDecl(tu_dc).ptr == tu.ptr

        # NamespaceDecl <-> DeclContext
        nd_dc = CC.DeclContext(nd)
        @test nd_dc isa CC.DeclContext
        @test CC.NamespaceDecl(nd_dc).ptr == nd.ptr

        # FunctionDecl <-> DeclContext
        fd_dc = CC.DeclContext(fd)
        @test fd_dc isa CC.DeclContext
        @test CC.FunctionDecl(fd_dc).ptr == fd.ptr

        # ExternCContextDecl <-> DeclContext (the AST's singleton extern "C" context)
        ecd = CC.getExternCContextDecl(ctx)
        ecd_dc = CC.DeclContext(ecd)
        @test ecd_dc isa CC.DeclContext
        @test CC.ExternCContextDecl(ecd_dc).ptr == ecd.ptr
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "Decl.jl decl-d: reserved/ObjC identifier queries" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        lo = CC.getLangOpts(ctx)

        CC.parse(I, """
            int plain_global = 1;
            void ddfunc(int p0) { (void)p0; }
        """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        vd = CC.VarDecl(look("plain_global").ptr)
        fd = CC.FunctionDecl(look("ddfunc").ptr)

        # NamedDecl::isReserved -> ReservedIdentifierStatus; an ordinary global
        # name obeys no reserved-identifier rule.
        rs = CC.isReserved(vd, lo)
        @test rs isa CC.LibClangEx.CXReservedIdentifierStatus
        @test rs == CC.LibClangEx.CXReservedIdentifierStatus_NotReserved

        # NamedDecl::getObjCFStringFormattingFamily -> SFF_None for a non-ObjC decl.
        ff = CC.getObjCFStringFormattingFamily(vd)
        @test ff isa CC.LibClangEx.CXObjCStringFormatFamily
        @test ff == CC.LibClangEx.CXObjCStringFormatFamily_SFF_None

        # ParmVarDecl::getObjCDeclQualifier -> OBJC_TQ_None for an ordinary
        # C++ parameter (getter is total; setObjCDeclQualifier is not wrapped
        # because it asserts IsObjCMethodParam).
        pvd = CC.getParamDecl(fd, 0)
        q = CC.getObjCDeclQualifier(pvd)
        @test q isa CC.LibClangEx.CXObjCDeclQualifier
        @test q == CC.LibClangEx.CXObjCDeclQualifier_OBJC_TQ_None
    finally
        dispose(I)
    end
end

@testset "Decl.jl decl-f: HLSLBufferDecl, field_empty, non-escaping byref capture" begin
    I = create_interpreter(["-fblocks"])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)

        CC.parse(I, """
            int hb_anchor = 1;
            struct HBEmpty {};
            struct HBFull { int a; double b; };
            void hb_host() {
                int addend = 10;
                int (^blk)(int) = ^int(int q){ return q + addend; };
                (void)blk;
            }
        """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        anchor = CC.VarDecl(look("hb_anchor").ptr)
        loc = CC.getLocation(anchor)
        id = CC.getIdentifier(anchor)

        # ---------------- RecordDecl::field_empty ----------------
        empty_rd = CC.getDefinition(CC.RecordDecl(look("HBEmpty").ptr))
        full_rd = CC.getDefinition(CC.RecordDecl(look("HBFull").ptr))
        @test CC.field_empty(empty_rd)
        @test !CC.field_empty(full_rd)
        # agrees with the count+fill protocol on the same records
        @test CC.field_empty(empty_rd) == (CC.getNumFields(empty_rd) == 0)
        @test CC.field_empty(full_rd) == (CC.getNumFields(full_rd) == 0)

        # ---------------- BlockDecl::Capture::isNonEscapingByref ----------------
        # A BlockDecl is not a top-level decl: it hangs off the BlockExpr inside
        # hb_host's body, so reach it through the expression rather than decls(tu).
        function find_node(::Type{T}, x) where {T}
            x isa T && return x
            for c in CC.children(x)
                r = find_node(T, CC.resolve(c))
                r === nothing || return r
            end
            return nothing
        end
        host = CC.FunctionDecl(look("hb_host").ptr)
        be = find_node(CC.BlockExpr, CC.resolve(CC.getBody(host)))
        @test be isa CC.BlockExpr
        blk = CC.getBlockDecl(be)
        @test blk.ptr != C_NULL
        @test CC.getNumCaptures(blk) >= 1
        @test CC.isCaptureNonEscapingByref(blk, 0) isa Bool
        # `addend` is captured by value, so it is neither an escaping nor a
        # non-escaping __block byref capture.
        @test CC.isCaptureByRef(blk, 0) || !CC.isCaptureNonEscapingByref(blk, 0)

        # ---------------- HLSLBufferDecl ----------------
        hb = CC.HLSLBufferDecl(ctx, dc, true, loc, id, loc, loc)
        @test hb isa CC.HLSLBufferDecl
        @test hb.ptr != C_NULL
        @test CC.isCBuffer(hb)
        @test CC.getName(hb) == "hb_anchor"
        # KwLoc and LBraceLoc round-trip the locations passed to Create
        @test CC.getLocStart(hb) isa CC.SourceLocation
        @test CC.getLocStart(hb).ptr == loc.ptr
        @test CC.getLBraceLoc(hb) isa CC.SourceLocation
        @test CC.getLBraceLoc(hb).ptr == loc.ptr
        # RBraceLoc is default-constructed by Create, so only a value set here is asserted
        @test CC.getRBraceLoc(hb) isa CC.SourceLocation
        CC.setRBraceLoc(hb, loc)
        @test CC.getRBraceLoc(hb).ptr == loc.ptr
        @test CC.getSourceRange(hb) isa CC.SourceRange

        tb = CC.HLSLBufferDecl(ctx, dc, false, loc, id, loc, loc)
        @test !CC.isCBuffer(tb)

        @test CC.HLSLBufferDecl(ctx, 1) isa CC.HLSLBufferDecl

        # Decl <-> DeclContext pivot: offset-correct in both directions
        hbdc = CC.DeclContext(hb)
        @test hbdc isa CC.DeclContext
        @test CC.HLSLBufferDecl(hbdc) isa CC.HLSLBufferDecl
        @test CC.HLSLBufferDecl(hbdc).ptr == hb.ptr
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "Decl.jl decl-g: namespace factory, outer template lists, defaulted-function info" begin
    LXG = CC.LibClangEx
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)

        CC.parse(I, """
            int dg_anchor = 1;
            enum DGColor { DGRed = 3, DGBlue = 9 };
            template <typename T> struct DGTmpl { T v; };
            void dg_fn(int) {}
        """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        anchor = CC.VarDecl(look("dg_anchor").ptr)
        loc = CC.getLocation(anchor)
        id = CC.getIdentifier(anchor)
        qt_int = CC.getType(anchor)
        tsi = CC.getTypeSourceInfo(anchor)
        ed = CC.EnumDecl(look("DGColor").ptr)
        loc2 = CC.getLocation(ed)

        # ---------------- NamespaceDecl::Create ----------------
        ns = CC.NamespaceDecl(ctx, dc, true, loc2, loc, id)
        @test ns isa CC.NamespaceDecl
        @test ns.ptr != C_NULL
        @test CC.getName(ns) == "dg_anchor"
        @test CC.isInline(ns)
        @test !CC.isNested(ns)
        # IdLoc (not StartLoc) is what Decl::getLocation reports, so passing two
        # distinct locations pins down which parameter each argument reached.
        @test CC.getLocation(ns).ptr == loc.ptr
        # the trailing Nested flag is a parameter of its own, not an alias of Inline
        ns2 = CC.NamespaceDecl(ctx, dc, false, loc2, loc, id, CC.NamespaceDecl(C_NULL), true)
        @test !CC.isInline(ns2)
        @test CC.isNested(ns2)

        # ---------------- EnumConstantDecl::setInitVal ----------------
        ecs = CC.getEnumerators(ed)
        @test length(ecs) == 2
        v_red = CC.getInitVal(ecs[1])
        v_blue = CC.getInitVal(ecs[2])
        @test v_red != C_NULL
        @test v_blue != C_NULL
        # the mutation target is a detached enumerator: EnumConstantDecl::Create does not
        # add it to DGColor, so nothing in the live AST changes value here.
        fresh = CC.EnumConstantDecl(ctx, ed, loc, id, CC.getType(ecs[1]), CC.Expr_(C_NULL),
                                    v_red)
        @test CC.getEnumConstantDeclValue(fresh) == CC.getEnumConstantDeclValue(ecs[1])
        CC.setInitVal(fresh, ctx, v_blue, false)
        @test CC.getEnumConstantDeclValue(fresh) == CC.getEnumConstantDeclValue(ecs[2])
        @test CC.getEnumConstantDeclValue(fresh) != CC.getEnumConstantDeclValue(ecs[1])
        CC.LLVM.API.LLVMDisposeGenericValue(v_red)
        CC.LLVM.API.LLVMDisposeGenericValue(v_blue)

        # ---------------- setTemplateParameterListsInfo ----------------
        ctd = CC.ClassTemplateDecl(look("DGTmpl").ptr)
        tpl = CC.getTemplateParameters(ctd)
        @test tpl isa CC.TemplateParameterList
        @test tpl.ptr != C_NULL

        # TagDecl arm, on a freshly created (detached) record
        rec = CC.RecordDecl(ctx, LXG.CXTagTypeKind_Struct, dc, loc, loc, id)
        @test CC.getNumTemplateParameterLists(rec) == 0
        CC.setTemplateParameterListsInfo(rec, ctx, [tpl])
        @test CC.getNumTemplateParameterLists(rec) == 1
        @test CC.getTemplateParameterList(rec, 0).ptr == tpl.ptr
        @test_throws AssertionError CC.setTemplateParameterListsInfo(rec, ctx,
                                                                    CC.TemplateParameterList[])

        # DeclaratorDecl arm, on a freshly created (detached) variable
        vd = CC.VarDecl(ctx, dc, loc, loc, id, qt_int, tsi, LXG.CXStorageClass_SC_None)
        @test CC.getNumTemplateParameterLists(vd) == 0
        CC.setTemplateParameterListsInfo(vd, ctx, [tpl])
        @test CC.getNumTemplateParameterLists(vd) == 1
        @test CC.getTemplateParameterList(vd, 0).ptr == tpl.ptr
        @test_throws AssertionError CC.setTemplateParameterListsInfo(vd, ctx,
                                                                    CC.TemplateParameterList[])

        # ---------------- ParmVarDecl::setObjCDeclQualifier ----------------
        parm = CC.ParmVarDecl(ctx, dc, loc, loc, id, qt_int, tsi, LXG.CXStorageClass_SC_None)
        # the qualifier shares a bitfield with the scope depth, so the wrapper refuses a
        # plain C/C++ parameter until setObjCMethodScopeInfo marks it as an ObjC one
        @test !CC.isObjCMethodParameter(parm)
        @test_throws AssertionError CC.setObjCDeclQualifier(parm,
                                                            LXG.CXObjCDeclQualifier_OBJC_TQ_Byref)
        CC.setObjCMethodScopeInfo(parm, 0)
        @test CC.isObjCMethodParameter(parm)
        CC.setObjCDeclQualifier(parm, LXG.CXObjCDeclQualifier_OBJC_TQ_Byref)
        @test CC.getObjCDeclQualifier(parm) == LXG.CXObjCDeclQualifier_OBJC_TQ_Byref
        CC.setObjCDeclQualifier(parm, LXG.CXObjCDeclQualifier_OBJC_TQ_Oneway)
        @test CC.getObjCDeclQualifier(parm) == LXG.CXObjCDeclQualifier_OBJC_TQ_Oneway

        # ---------------- FunctionDecl::DefaultedFunctionInfo ----------------
        fn = CC.FunctionDecl(look("dg_fn").ptr)
        info0 = CC.getDefaultedFunctionInfo(fn)
        @test info0 isa CC.DefaultedFunctionInfo
        # an ordinary function stores a body, so the union holds no defaulted info
        @test info0.ptr == C_NULL

        nd_a = CC.NamedDecl(anchor.ptr)
        nd_b = CC.NamedDecl(ed.ptr)
        info = CC.DefaultedFunctionInfo(ctx, [nd_a, nd_b],
                                        [LXG.CXAccessSpecifier_AS_public,
                                         LXG.CXAccessSpecifier_AS_private])
        @test info isa CC.DefaultedFunctionInfo
        @test info.ptr != C_NULL
        @test CC.getNumUnqualifiedLookups(info) == 2
        # decls and accesses are read in lockstep at the same index
        @test CC.getUnqualifiedLookupDecl(info, 0).ptr == nd_a.ptr
        @test CC.getUnqualifiedLookupDecl(info, 1).ptr == nd_b.ptr
        @test CC.getUnqualifiedLookupAccess(info, 0) == LXG.CXAccessSpecifier_AS_public
        @test CC.getUnqualifiedLookupAccess(info, 1) == LXG.CXAccessSpecifier_AS_private
        @test_throws AssertionError CC.getUnqualifiedLookupDecl(info, 2)
        @test_throws AssertionError CC.getUnqualifiedLookupAccess(info, 2)
        @test_throws AssertionError CC.DefaultedFunctionInfo(ctx, [nd_a],
                                                             CC.CXAccessSpecifier[])

        # the carrier overload of the existing setter round-trips the info back out
        info1 = CC.DefaultedFunctionInfo(ctx, [nd_a], [LXG.CXAccessSpecifier_AS_none])
        fn_hollow = CC.FunctionDecl(ctx, 1)
        CC.setDefaultedFunctionInfo(fn_hollow, info1)
        @test CC.getDefaultedFunctionInfo(fn_hollow).ptr == info1.ptr
        @test CC.getNumUnqualifiedLookups(CC.getDefaultedFunctionInfo(fn_hollow)) == 1
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "Decl.jl decl-h: kind family predicates, qualifier extents, TagDecl pivot" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)
        K = CC.LibClangEx

        CC.parse(I, """
                 namespace NDH { struct SDH; void fdh(); }
                 struct NDH::SDH { int m; };
                 void NDH::fdh() {}
                 struct PlainDH { int p; };
                 void plaindh() {}
                 """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        # ---------------- classofKind: the Decl::Kind range tests ----------------
        # These read a kind and not a declaration, so they are asserted against named
        # enumerators rather than against whatever kind the host AST happens to build.
        @test CC.classofKind(CC.NamedDecl, K.CXDeclKind_Function)
        @test CC.classofKind(CC.NamedDecl, K.CXDeclKind_Field)
        @test !CC.classofKind(CC.NamedDecl, K.CXDeclKind_TranslationUnit)

        @test CC.classofKind(CC.ValueDecl, K.CXDeclKind_Var)
        @test CC.classofKind(CC.ValueDecl, K.CXDeclKind_EnumConstant)
        @test !CC.classofKind(CC.ValueDecl, K.CXDeclKind_Namespace)

        @test CC.classofKind(CC.DeclaratorDecl, K.CXDeclKind_Function)
        @test CC.classofKind(CC.DeclaratorDecl, K.CXDeclKind_Var)
        @test !CC.classofKind(CC.DeclaratorDecl, K.CXDeclKind_EnumConstant)

        @test CC.classofKind(CC.VarDecl, K.CXDeclKind_Var)
        @test CC.classofKind(CC.VarDecl, K.CXDeclKind_ParmVar)
        @test !CC.classofKind(CC.VarDecl, K.CXDeclKind_Field)

        @test CC.classofKind(CC.FunctionDecl, K.CXDeclKind_Function)
        @test CC.classofKind(CC.FunctionDecl, K.CXDeclKind_CXXMethod)
        @test !CC.classofKind(CC.FunctionDecl, K.CXDeclKind_Var)

        @test CC.classofKind(CC.FieldDecl, K.CXDeclKind_Field)
        @test !CC.classofKind(CC.FieldDecl, K.CXDeclKind_Var)

        @test CC.classofKind(CC.TypeDecl, K.CXDeclKind_Record)
        @test CC.classofKind(CC.TypeDecl, K.CXDeclKind_Typedef)
        @test !CC.classofKind(CC.TypeDecl, K.CXDeclKind_Function)

        @test CC.classofKind(CC.TypedefNameDecl, K.CXDeclKind_Typedef)
        @test CC.classofKind(CC.TypedefNameDecl, K.CXDeclKind_TypeAlias)
        @test !CC.classofKind(CC.TypedefNameDecl, K.CXDeclKind_Record)

        # the range test covers subclasses: every record and enum kind is a TagDecl
        @test CC.classofKind(CC.TagDecl, K.CXDeclKind_Record)
        @test CC.classofKind(CC.TagDecl, K.CXDeclKind_CXXRecord)
        @test CC.classofKind(CC.TagDecl, K.CXDeclKind_Enum)
        @test !CC.classofKind(CC.TagDecl, K.CXDeclKind_Typedef)

        @test CC.classofKind(CC.RecordDecl, K.CXDeclKind_Record)
        @test CC.classofKind(CC.RecordDecl, K.CXDeclKind_CXXRecord)
        @test !CC.classofKind(CC.RecordDecl, K.CXDeclKind_Enum)

        # the kinds the live AST reports agree with the enumerator-driven answers
        plain_fd = CC.FunctionDecl(look("plaindh").ptr)
        @test CC.classofKind(CC.FunctionDecl, CC.getKind(plain_fd))
        @test CC.classofKind(CC.DeclaratorDecl, CC.getKind(plain_fd))
        @test !CC.classofKind(CC.TagDecl, CC.getKind(plain_fd))
        @test !CC.classofKind(CC.NamedDecl, CC.getKind(tu))

        # ---------------- getQualifierRange ----------------
        # `void NDH::fdh() {}` redeclares the in-namespace `fdh`, and only the
        # out-of-line redeclaration carries the written `NDH::`.
        fd = CC.FunctionDecl(CC.getMostRecentDecl(CC.NamedDecl(look("NDH::fdh").ptr)).ptr)
        @test CC.getQualifier(fd).ptr != C_NULL
        qr = CC.getQualifierRange(fd)
        @test qr isa CC.SourceRange
        @test qr.begin_loc.ptr != C_NULL

        # unqualified declarator: no specifier was written, so the extent is invalid
        @test CC.getQualifier(plain_fd).ptr == C_NULL
        @test CC.getQualifierRange(plain_fd).begin_loc.ptr == C_NULL

        rd = CC.getMostRecentDecl(CC.RecordDecl(look("NDH::SDH").ptr))
        tag_qr = CC.getQualifierRange(rd)
        @test tag_qr isa CC.SourceRange
        # qualifier and extent agree on whether a specifier was written
        @test (CC.getQualifier(rd).ptr == C_NULL) == (tag_qr.begin_loc.ptr == C_NULL)

        plain_rd = CC.RecordDecl(look("PlainDH").ptr)
        @test CC.getQualifier(plain_rd).ptr == C_NULL
        @test CC.getQualifierRange(plain_rd).begin_loc.ptr == C_NULL

        # ---------------- TagDecl <-> DeclContext pivot ----------------
        rd_dc = CC.DeclContext(plain_rd)
        @test rd_dc isa CC.DeclContext
        @test CC.TagDecl(rd_dc).ptr == plain_rd.ptr
        # TagDecl(::DeclContext) goes through dyn_cast_or_null, so a context whose kind
        # is not a tag declaration's yields the NULL carrier rather than throwing.
        @test CC.TagDecl(CC.DeclContext(tu)).ptr == C_NULL
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "Decl single-kind Decl::Kind tests" begin
    K = CC.LibClangEx
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)

        CC.parse(I, """
                 namespace NDI { int ndi_x; }
                 enum EDI { EDI_A };
                 typedef int TDI;
                 using TAI = int;
                 void fdi(int pdi) { (void)pdi; }
                 """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        # Every class below is final in Clang's hierarchy, so its kind test is a single
        # equality rather than a range. The assertions name enumerators instead of
        # reading a host-decided kind, so they are portable across CI runners.
        @test CC.classofKind(CC.TranslationUnitDecl, K.CXDeclKind_TranslationUnit)
        @test !CC.classofKind(CC.TranslationUnitDecl, K.CXDeclKind_Namespace)

        @test CC.classofKind(CC.PragmaCommentDecl, K.CXDeclKind_PragmaComment)
        @test !CC.classofKind(CC.PragmaCommentDecl, K.CXDeclKind_PragmaDetectMismatch)

        @test CC.classofKind(CC.PragmaDetectMismatchDecl, K.CXDeclKind_PragmaDetectMismatch)
        @test !CC.classofKind(CC.PragmaDetectMismatchDecl, K.CXDeclKind_PragmaComment)

        @test CC.classofKind(CC.ExternCContextDecl, K.CXDeclKind_ExternCContext)
        @test !CC.classofKind(CC.ExternCContextDecl, K.CXDeclKind_LinkageSpec)

        @test CC.classofKind(CC.LabelDecl, K.CXDeclKind_Label)
        @test !CC.classofKind(CC.LabelDecl, K.CXDeclKind_Var)

        @test CC.classofKind(CC.NamespaceDecl, K.CXDeclKind_Namespace)
        @test !CC.classofKind(CC.NamespaceDecl, K.CXDeclKind_NamespaceAlias)

        @test CC.classofKind(CC.ImplicitParamDecl, K.CXDeclKind_ImplicitParam)
        @test !CC.classofKind(CC.ImplicitParamDecl, K.CXDeclKind_ParmVar)

        @test CC.classofKind(CC.ParmVarDecl, K.CXDeclKind_ParmVar)
        @test !CC.classofKind(CC.ParmVarDecl, K.CXDeclKind_Var)

        @test CC.classofKind(CC.EnumConstantDecl, K.CXDeclKind_EnumConstant)
        @test !CC.classofKind(CC.EnumConstantDecl, K.CXDeclKind_Enum)

        @test CC.classofKind(CC.IndirectFieldDecl, K.CXDeclKind_IndirectField)
        @test !CC.classofKind(CC.IndirectFieldDecl, K.CXDeclKind_Field)

        @test CC.classofKind(CC.TypedefDecl, K.CXDeclKind_Typedef)
        @test !CC.classofKind(CC.TypedefDecl, K.CXDeclKind_TypeAlias)

        @test CC.classofKind(CC.TypeAliasDecl, K.CXDeclKind_TypeAlias)
        @test !CC.classofKind(CC.TypeAliasDecl, K.CXDeclKind_Typedef)

        @test CC.classofKind(CC.EnumDecl, K.CXDeclKind_Enum)
        @test !CC.classofKind(CC.EnumDecl, K.CXDeclKind_Record)

        @test CC.classofKind(CC.FileScopeAsmDecl, K.CXDeclKind_FileScopeAsm)
        @test !CC.classofKind(CC.FileScopeAsmDecl, K.CXDeclKind_TopLevelStmt)

        @test CC.classofKind(CC.TopLevelStmtDecl, K.CXDeclKind_TopLevelStmt)
        @test !CC.classofKind(CC.TopLevelStmtDecl, K.CXDeclKind_FileScopeAsm)

        @test CC.classofKind(CC.BlockDecl, K.CXDeclKind_Block)
        @test !CC.classofKind(CC.BlockDecl, K.CXDeclKind_Captured)

        @test CC.classofKind(CC.CapturedDecl, K.CXDeclKind_Captured)
        @test !CC.classofKind(CC.CapturedDecl, K.CXDeclKind_Block)

        @test CC.classofKind(CC.ImportDecl, K.CXDeclKind_Import)
        @test !CC.classofKind(CC.ImportDecl, K.CXDeclKind_Export)

        @test CC.classofKind(CC.ExportDecl, K.CXDeclKind_Export)
        @test !CC.classofKind(CC.ExportDecl, K.CXDeclKind_Import)

        @test CC.classofKind(CC.EmptyDecl, K.CXDeclKind_Empty)
        @test !CC.classofKind(CC.EmptyDecl, K.CXDeclKind_TopLevelStmt)

        # "final class" is the shape being asserted: scanning the whole mirrored enum
        # finds exactly one kind that answers true, unlike the range tests above it.
        @test count(k -> CC.classofKind(CC.NamespaceDecl, k), instances(K.CXDeclKind)) == 1
        @test count(k -> CC.classofKind(CC.EnumDecl, k), instances(K.CXDeclKind)) == 1
        @test count(k -> CC.classofKind(CC.ParmVarDecl, k), instances(K.CXDeclKind)) == 1

        # the kinds the live AST reports agree with the enumerator-driven answers
        @test CC.classofKind(CC.TranslationUnitDecl, CC.getKind(tu))
        @test CC.classofKind(CC.NamespaceDecl, CC.getKind(look("NDI")))
        @test CC.classofKind(CC.EnumDecl, CC.getKind(look("EDI")))
        @test CC.classofKind(CC.EnumConstantDecl, CC.getKind(look("EDI_A")))
        @test CC.classofKind(CC.TypedefDecl, CC.getKind(look("TDI")))
        @test CC.classofKind(CC.TypeAliasDecl, CC.getKind(look("TAI")))

        fdi = CC.FunctionDecl(look("fdi").ptr)
        @test CC.classofKind(CC.ParmVarDecl, CC.getKind(CC.getParamDecl(fdi, 0)))
        @test !CC.classofKind(CC.NamespaceDecl, CC.getKind(fdi))
        @test !CC.classofKind(CC.TranslationUnitDecl, CC.getKind(fdi))
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "BlockDecl parameter and capture installation" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        LXB = CC.LibClangEx
        CC.parse(I, """
            int bpc_first = 1;
            int bpc_second = 2;
        """)
        ctx = CC.get_ast_context(I)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)
        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        # every lookup runs before the synthetic decls below are minted, so no name
        # this testset creates can make get_decl ambiguous
        first_vd = CC.VarDecl(look("bpc_first").ptr)
        second_vd = CC.VarDecl(look("bpc_second").ptr)
        loc = CC.getLocation(first_vd)
        id = CC.getIdentifier(first_vd)
        ty = CC.getType(first_vd)
        tsi = CC.getTrivialTypeSourceInfo(ctx, ty, loc)

        # ---------------- BlockDecl::setParams ----------------
        bd = CC.BlockDecl(ctx, dc, loc)
        @test CC.getNumParams(bd) == 0
        p0 = CC.ParmVarDecl(ctx, dc, loc, loc, id, ty, tsi, LXB.CXStorageClass_SC_None)
        p1 = CC.ParmVarDecl(ctx, dc, loc, loc, id, ty, tsi, LXB.CXStorageClass_SC_None)
        CC.setParams(bd, [p0, p1])
        @test CC.getNumParams(bd) == 2
        @test CC.getParamDecl(bd, 0).ptr == p0.ptr
        @test CC.getParamDecl(bd, 1).ptr == p1.ptr
        @test [p.ptr for p in CC.getParams(bd)] == [p0.ptr, p1.ptr]
        # a zero-length install stores nothing, so the block stays installable
        empty_bd = CC.BlockDecl(ctx, dc, loc)
        CC.setParams(empty_bd, CC.ParmVarDecl[])
        @test CC.getNumParams(empty_bd) == 0
        CC.setParams(empty_bd, [p0])
        @test CC.getNumParams(empty_bd) == 1

        # ---------------- BlockDecl::setCaptures ----------------
        @test CC.getNumCaptures(bd) == 0
        CC.setCaptures(bd, ctx, [first_vd, second_vd], [false, true], [true, false],
                       [nothing, nothing], false)
        @test CC.getNumCaptures(bd) == 2
        @test CC.hasCaptures(bd)
        @test CC.getCaptureVariable(bd, 0).ptr == first_vd.ptr
        @test CC.getCaptureVariable(bd, 1).ptr == second_vd.ptr
        @test !CC.isCaptureByRef(bd, 0)
        @test CC.isCaptureByRef(bd, 1)
        @test CC.isCaptureNested(bd, 0)
        @test !CC.isCaptureNested(bd, 1)
        @test !CC.captureHasCopyExpr(bd, 0)
        @test !CC.captureHasCopyExpr(bd, 1)
        @test !CC.capturesCXXThis(bd)
        @test CC.capturesVariable(bd, first_vd)
        # a second call replaces the list rather than extending it, and carries the
        # this-capture flag with it
        CC.setCaptures(bd, ctx, [second_vd], [false], [false], [nothing], true)
        @test CC.getNumCaptures(bd) == 1
        @test CC.getCaptureVariable(bd, 0).ptr == second_vd.ptr
        @test !CC.capturesVariable(bd, first_vd)
        @test CC.capturesCXXThis(bd)

        # ---------------- BlockDecl::Capture::setCopyExpr ----------------
        init = CC.getInit(second_vd)
        @test init.ptr != C_NULL
        CC.setCaptureCopyExpr(bd, 0, init)
        @test CC.captureHasCopyExpr(bd, 0)
        @test CC.getCaptureCopyExpr(bd, 0).ptr == init.ptr
        CC.setCaptureCopyExpr(bd, 0, CC.Expr_(C_NULL))
        @test !CC.captureHasCopyExpr(bd, 0)
        # the same expression installed through the builder instead of the setter
        CC.setCaptures(bd, ctx, [second_vd], [false], [false], [init], false)
        @test CC.captureHasCopyExpr(bd, 0)
        @test CC.getCaptureCopyExpr(bd, 0).ptr == init.ptr

        # ---------------- HLSLBufferDecl::classofKind ----------------
        @test CC.classofKind(CC.HLSLBufferDecl, LXB.CXDeclKind_HLSLBuffer)
        @test !CC.classofKind(CC.HLSLBufferDecl, LXB.CXDeclKind_Record)
        # HLSLBufferDecl is final, so exactly one enumerator of the mirror answers true
        @test count(k -> CC.classofKind(CC.HLSLBufferDecl, k), instances(LXB.CXDeclKind)) == 1

        # ---------------- Decl::classof ----------------
        @test CC.classof(CC.TranslationUnitDecl, tu)
        @test !CC.classof(CC.TranslationUnitDecl, first_vd)
        @test CC.classof(CC.VarDecl, first_vd)
        @test CC.classof(CC.NamedDecl, first_vd)
        @test CC.classof(CC.DeclaratorDecl, first_vd)
        @test !CC.classof(CC.FunctionDecl, first_vd)
        @test CC.classof(CC.BlockDecl, bd)
        @test !CC.classof(CC.CapturedDecl, bd)
        @test CC.classof(CC.ParmVarDecl, p0)
        @test CC.classof(CC.VarDecl, p0)    # the range test covers the subclass
        # the handle spelling and the kind-only spelling agree, both ways
        for T in (CC.VarDecl, CC.NamedDecl, CC.TagDecl, CC.BlockDecl, CC.ParmVarDecl)
            @test CC.classof(T, first_vd) == CC.classofKind(T, CC.getKind(first_vd))
            @test CC.classof(T, bd) == CC.classofKind(T, CC.getKind(bd))
        end
    finally
        dispose(f)
        dispose(I)
    end
end
