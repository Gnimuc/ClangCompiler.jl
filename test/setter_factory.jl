using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).

const LX = CC.LibClangEx

@testset "SetFactory | Decl" begin
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

        vd  = CC.VarDecl(look("gvar").ptr)
        lvd = CC.VarDecl(look("lvar").ptr)
        fd  = CC.FunctionDecl(look("gfunc").ptr)
        rd  = CC.getDefinition(CC.RecordDecl(look("SFoo").ptr))
        ed  = CC.getDefinition(CC.EnumDecl(look("EFoo").ptr))
        tnd = CC.TypedefDecl(look("MyInt").ptr)
        csv = CC.VarDecl(look("cstr").ptr)

        # --- shared args (captured before any mutation) ---
        loc  = CC.getLocation(vd)
        loc2 = CC.getLocation(lvd)
        id   = CC.getIdentifier(vd)
        ty   = CC.getType(vd)            # int QualType
        ty2  = CC.getType(lvd)           # long QualType
        tsi  = CC.getTrivialTypeSourceInfo(ctx, ty, loc)
        name = CC.getDeclName(fd)
        fty  = CC.getType(fd)            # function QualType
        ftsi = CC.getTrivialTypeSourceInfo(ctx, fty, loc)

        fields = CC.getFields(rd)
        fld  = fields[1]                 # int fld : 3  (bitfield)
        fld2 = fields[2]                 # int fld2
        bw   = CC.getBitWidth(fld)       # a reusable IntegerLiteral Expr
        ea   = CC.getEnumerators(ed)[1]  # EA

        body = CC.getBody(fd)            # Stmt
        cs   = CC.resolve(body)          # CompoundStmt

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

        @test CC.FunctionDecl(ctx, dc, loc, loc, name, fty, ftsi, LX.CXStorageClass_SC_None, false, true) isa CC.FunctionDecl
        @test CC.FunctionDecl(ctx, 1) isa CC.FunctionDecl

        @test CC.FieldDecl(ctx, dc, loc, loc, id, ty, tsi, CC.Expr_(C_NULL), false, LX.CXInClassInitStyle_ICIS_NoInit) isa CC.FieldDecl
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
        CC.setScoped(ed, true);               @test CC.isScoped(ed)
        CC.setScopedUsingClassTag(ed, true);  @test CC.isScopedUsingClassTag(ed)
        CC.setFixed(ed, true);                @test CC.isFixed(ed)
        CC.setIntegerType(ed, ty2);           @test CC.getIntegerType(ed).ptr == ty2.ptr
        CC.setPromotionType(ed, ty);          @test CC.getPromotionType(ed).ptr == ty.ptr
        CC.setIntegerTypeSourceInfo(ed, tsi); @test CC.getIntegerTypeSourceInfo(ed).ptr == tsi.ptr

        # TagDecl setters (on the complete SFoo record)
        CC.setTagKind(rd, LX.CXTagTypeKind_Union);       @test CC.getTagKind(rd) == LX.CXTagTypeKind_Union
        CC.setBraceRange(rd, CC.SourceRange(loc, loc2))
        br = CC.getBraceRange(rd)
        @test br.begin_loc == loc && br.end_loc == loc2
        CC.setCompleteDefinitionRequired(rd, true);      @test CC.isCompleteDefinitionRequired(rd)
        CC.setEmbeddedInDeclarator(rd, true);            @test CC.isEmbeddedInDeclarator(rd)
        CC.setFreeStanding(rd, true);                    @test CC.isFreeStanding(rd)
        CC.setTypedefNameForAnonDecl(rd, tnd);           @test CC.getTypedefNameForAnonDecl(rd).ptr == tnd.ptr

        # RecordDecl flag setters (data() is valid — SFoo is complete)
        CC.setHasFlexibleArrayMember(rd, true);          @test CC.hasFlexibleArrayMember(rd)
        CC.setAnonymousStructOrUnion(rd, true);          @test CC.isAnonymousStructOrUnion(rd)
        CC.setHasObjectMember(rd, true);                 @test CC.hasObjectMember(rd)
        CC.setHasVolatileMember(rd, true);               @test CC.hasVolatileMember(rd)
        CC.setHasLoadedFieldsFromExternalStorage(rd, true); @test CC.hasLoadedFieldsFromExternalStorage(rd)
        CC.setNonTrivialToPrimitiveDefaultInitialize(rd, true); @test CC.isNonTrivialToPrimitiveDefaultInitialize(rd)
        CC.setNonTrivialToPrimitiveCopy(rd, true);       @test CC.isNonTrivialToPrimitiveCopy(rd)
        CC.setNonTrivialToPrimitiveDestroy(rd, true);    @test CC.isNonTrivialToPrimitiveDestroy(rd)
        CC.setHasNonTrivialToPrimitiveDefaultInitializeCUnion(rd, true); @test CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion(rd)
        CC.setHasNonTrivialToPrimitiveDestructCUnion(rd, true); @test CC.hasNonTrivialToPrimitiveDestructCUnion(rd)
        CC.setHasNonTrivialToPrimitiveCopyCUnion(rd, true); @test CC.hasNonTrivialToPrimitiveCopyCUnion(rd)
        CC.setParamDestroyedInCallee(rd, true);          @test CC.isParamDestroyedInCallee(rd)
        CC.setArgPassingRestrictions(rd, LX.CXRecordDecl_APK_CannotPassInRegs)
        @test CC.getArgPassingRestrictions(rd) == LX.CXRecordDecl_APK_CannotPassInRegs
        CC.setCapturedRecord(rd);                        @test CC.isCapturedRecord(rd)

        # BlockDecl (fresh) setters
        bd = CC.BlockDecl(ctx, dc, loc)
        @test bd isa CC.BlockDecl
        @test CC.BlockDecl(ctx, 1) isa CC.BlockDecl
        CC.setSignatureAsWritten(bd, ftsi);   @test CC.getSignatureAsWritten(bd).ptr == ftsi.ptr
        @test (CC.setBody(bd, cs); true)
        CC.setCapturesCXXThis(bd, true);      @test CC.capturesCXXThis(bd)
        CC.setBlockMissingReturnType(bd, false); @test !CC.blockMissingReturnType(bd)
        CC.setIsConversionFromLambda(bd, true); @test CC.isConversionFromLambda(bd)
        CC.setDoesNotEscape(bd, true);        @test CC.doesNotEscape(bd)
        CC.setCanAvoidCopyToHeap(bd, true);   @test CC.canAvoidCopyToHeap(bd)
        CC.setBlockMangling(bd, 7, tu);       @test CC.getBlockManglingNumber(bd) == 7

        # CapturedDecl (fresh) setters
        cd = CC.CapturedDecl(ctx, dc, 1)
        @test cd isa CC.CapturedDecl
        @test CC.CapturedDecl(ctx, 1, 1) isa CC.CapturedDecl
        CC.setNothrow(cd, true);              @test CC.isNothrow(cd)
        CC.setBody(cd, body);                 @test CC.getBody(cd).ptr == body.ptr
        ipd = CC.ImplicitParamDecl(ctx, dc, loc, id, ty, LX.CXImplicitParamKind_CapturedContext)
        CC.setParam(cd, 0, ipd);              @test CC.getParam(cd, 0).ptr == ipd.ptr
        CC.setContextParam(cd, 0, ipd);       @test CC.getContextParam(cd).ptr == ipd.ptr

        # ExportDecl (fresh) setter
        exd = CC.ExportDecl(ctx, dc, loc)
        @test exd isa CC.ExportDecl
        @test CC.ExportDecl(ctx, 1) isa CC.ExportDecl
        CC.setRBraceLoc(exd, loc2);           @test CC.getRBraceLoc(exd) == loc2

        # FileScopeAsmDecl (needs a StringLiteral)
        if sl isa CC.StringLiteral
            fsad = CC.FileScopeAsmDecl(ctx, dc, sl, loc, loc)
            @test fsad isa CC.FileScopeAsmDecl
            CC.setRParenLoc(fsad, loc2);      @test CC.getRParenLoc(fsad) == loc2
            CC.setAsmString(fsad, sl);        @test CC.getAsmString(fsad).ptr == sl.ptr
        end
        @test CC.FileScopeAsmDecl(ctx, 1) isa CC.FileScopeAsmDecl

        # AccessSpecDecl (fresh) setters
        asd = CC.AccessSpecDecl(ctx, LX.CXAccessSpecifier_AS_public, dc, loc, loc)
        @test asd isa CC.AccessSpecDecl
        @test CC.AccessSpecDecl(ctx, 1) isa CC.AccessSpecDecl
        CC.setColonLoc(asd, loc2);            @test CC.getColonLoc(asd) == loc2
        CC.setAccessSpecifierLoc(asd, loc2);  @test CC.getAccessSpecifierLoc(asd) == loc2

        # LinkageSpecDecl (fresh) setters
        lsd = CC.LinkageSpecDecl(ctx, dc, loc, loc, LX.CXLinkageSpecDecl_lang_c, true)
        @test lsd isa CC.LinkageSpecDecl
        @test CC.LinkageSpecDecl(ctx, 1) isa CC.LinkageSpecDecl
        CC.setLanguage(lsd, LX.CXLinkageSpecDecl_lang_cxx); @test CC.getLanguage(lsd) == LX.CXLinkageSpecDecl_lang_cxx
        CC.setExternLoc(lsd, loc2);           @test CC.getExternLoc(lsd) == loc2
        CC.setRBraceLoc(lsd, loc2);           @test CC.getRBraceLoc(lsd) == loc2

        # =========================================================
        # Already-wrapped setters — representative round-trips
        # =========================================================

        # VarDecl
        CC.setStorageClass(vd, LX.CXStorageClass_SC_Static); @test CC.getStorageClass(vd) == LX.CXStorageClass_SC_Static
        CC.setTSCSpec(vd, LX.CXThreadStorageClassSpecifier_TSCS_thread_local); @test CC.getTSCSpec(vd) == LX.CXThreadStorageClassSpecifier_TSCS_thread_local
        CC.setConstexpr(vd, true);            @test CC.isConstexpr(vd)
        CC.setInitCapture(vd, true);          @test CC.isInitCapture(vd)
        CC.setNRVOVariable(vd, true);         @test CC.isNRVOVariable(vd)
        CC.setExceptionVariable(vd, true);    @test CC.isExceptionVariable(vd)
        CC.setCXXForRangeDecl(vd, true);      @test CC.isCXXForRangeDecl(vd)
        CC.setObjCForDecl(vd, true);          @test CC.isObjCForDecl(vd)
        CC.setARCPseudoStrong(vd, true);      @test CC.isARCPseudoStrong(vd)
        CC.setPreviousDeclInSameBlockScope(vd, true); @test CC.isPreviousDeclInSameBlockScope(vd)
        CC.setInlineSpecified(vd);            @test CC.isInlineSpecified(vd)
        @test (CC.setImplicitlyInline(vd); true)
        @test (CC.setEscapingByref(vd); true)

        # FunctionDecl
        CC.setStorageClass(fd, LX.CXStorageClass_SC_Static); @test CC.getStorageClass(fd) == LX.CXStorageClass_SC_Static
        CC.setConstexprKind(fd, LX.CXConstexprSpecKind_Constexpr); @test CC.getConstexprKind(fd) == LX.CXConstexprSpecKind_Constexpr
        # isDeletedAsWritten() == IsDeleted && !isDefaulted, so probe it before setDefaulted
        CC.setDeletedAsWritten(fd, true);     @test CC.isDeletedAsWritten(fd)
        CC.setTrivial(fd, true);              @test CC.isTrivial(fd)
        CC.setTrivialForCall(fd, true);       @test CC.isTrivialForCall(fd)
        CC.setDefaulted(fd, true);            @test CC.isDefaulted(fd)
        CC.setExplicitlyDefaulted(fd, true);  @test CC.isExplicitlyDefaulted(fd)
        CC.setHasWrittenPrototype(fd, true);  @test CC.hasWrittenPrototype(fd)
        CC.setHasInheritedPrototype(fd, true); @test CC.hasInheritedPrototype(fd)
        CC.setHasImplicitReturnZero(fd, true); @test CC.hasImplicitReturnZero(fd)
        CC.setLateTemplateParsed(fd, true);   @test CC.isLateTemplateParsed(fd)
        CC.setInstantiationIsPending(fd, true); @test CC.instantiationIsPending(fd)
        CC.setUsesSEHTry(fd, true);           @test CC.usesSEHTry(fd)
        CC.setHasSkippedBody(fd, true);       @test CC.hasSkippedBody(fd)
        CC.setWillHaveBody(fd, true);         @test CC.willHaveBody(fd)
        CC.setIsMultiVersion(fd, true);       @test CC.isMultiVersion(fd)
        CC.setInlineSpecified(fd, true);      @test CC.isInlineSpecified(fd)
        @test (CC.setImplicitlyInline(fd, true); true)
        @test (CC.setRangeEnd(fd, loc); true)
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "SetFactory | DeclCXXTemplate" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)

    # Two real, distinct source locations + an identifier to feed factories/setters.
    CC.parse(I, "int aa = 1; int bb = 2;")
    f = DeclFinder(I)
    @test f(I, "aa")
    aa = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "bb")
    bb = CC.VarDecl(get_decl(f).ptr)
    loc_a = CC.getLocation(aa)
    loc_b = CC.getLocation(bb)
    id_a = CC.getIdentifier(aa)
    @test loc_a.ptr != loc_b.ptr

    # ---- AccessSpecDecl: factories + loc setters ----
    asd = CC.AccessSpecDecl(ctx, LCE.CXAccessSpecifier_AS_public, dc, loc_a, loc_a)
    @test asd isa CC.AccessSpecDecl
    asd2 = CC.AccessSpecDecl(ctx, UInt(1))
    @test asd2 isa CC.AccessSpecDecl
    CC.setAccessSpecifierLoc(asd, loc_b)
    @test CC.getAccessSpecifierLoc(asd).ptr == loc_b.ptr
    CC.setColonLoc(asd, loc_a)
    @test CC.getColonLoc(asd).ptr == loc_a.ptr

    # ---- LinkageSpecDecl: factories + setters ----
    lsd = CC.LinkageSpecDecl(ctx, dc, loc_a, loc_a, LCE.CXLinkageSpecDecl_lang_c, true)
    @test lsd isa CC.LinkageSpecDecl
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_c
    lsd2 = CC.LinkageSpecDecl(ctx, UInt(1))
    @test lsd2 isa CC.LinkageSpecDecl
    CC.setLanguage(lsd, LCE.CXLinkageSpecDecl_lang_cxx)
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_cxx
    CC.setExternLoc(lsd, loc_b)
    @test CC.getExternLoc(lsd).ptr == loc_b.ptr
    CC.setRBraceLoc(lsd, loc_a)
    @test CC.getRBraceLoc(lsd).ptr == loc_a.ptr

    # ---- CXXRecordDecl: Create + CreateLambda ----
    rd = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc_a, loc_a, id_a)
    @test rd isa CC.CXXRecordDecl
    tsi = CC.getTypeSourceInfo(aa)                    # a real TypeSourceInfo (int)
    lam = CC.CXXRecordDecl(ctx, dc, tsi, loc_a, false, false,
                           LCE.CXLambdaCaptureDefault_LCD_None)
    @test lam isa CC.CXXRecordDecl
    @test CC.isLambda(lam)

    # ---- CXXBaseSpecifier: setInheritConstructors round-trip ----
    CC.parse(I, "struct BB0 { BB0(int); }; struct DD0 : BB0 { using BB0::BB0; };")
    @test f(I, "DD0")
    dd0 = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.getNumBases(dd0) == 1
    base = CC.getBase(dd0, 0)
    CC.setInheritConstructors(base, true)
    @test CC.getInheritConstructors(base) == true
    CC.setInheritConstructors(base, false)
    @test CC.getInheritConstructors(base) == false

    # ---- CXXMethodDecl: Create (from a parsed method) + CreateDeserialized ----
    CC.parse(I, "struct Foo0 { void bar0(int); };")
    @test f(I, "Foo0")
    foo0 = CC.CXXRecordDecl(get_decl(f).ptr)
    bar0 = first(m for m in CC.getMethods(foo0) if CC.getName(m) == "bar0")
    ni = CC.getNameInfo(bar0)
    mty = CC.getType(bar0)
    mtsi = CC.getTypeSourceInfo(bar0)
    sloc = CC.getBeginLoc(bar0)
    eloc = CC.getLocation(bar0)
    md = CC.CXXMethodDecl(ctx, foo0, sloc, ni, mty, mtsi,
                          LCE.CXStorageClass_SC_None, false, false,
                          LCE.CXConstexprSpecKind_Unspecified, eloc)
    @test md isa CC.CXXMethodDecl
    md2 = CC.CXXMethodDecl(ctx, UInt(1))
    @test md2 isa CC.CXXMethodDecl

    # ---- Template factories/setters (already wrapped) reachable safely ----
    CC.parse(I, "template<class TT> struct S1 { TT x; };")
    @test f(I, "S1")
    s1 = CC.ClassTemplateDecl(get_decl(f).ptr)
    targ = CC.TemplateArgument(CC.getType(aa))        # an `int` template argument
    tal = CC.TemplateArgumentList(ctx, [targ])
    @test size(tal) == 1
    @test Base.get(tal, 0) isa CC.TemplateArgument
    ctsd = CC.ClassTemplateSpecializationDecl(ctx, s1, tal)
    @test ctsd isa CC.ClassTemplateSpecializationDecl
    @test CC.getTemplateArgs(ctsd) isa CC.TemplateArgumentList
    tal2 = CC.TemplateArgumentList(ctx, [targ])
    CC.setTemplateArgs(ctsd, tal2)
    @test size(CC.getTemplateArgs(ctsd)) == 1

    dispose(f)
    dispose(I)
end

@testset "SetFactory | TypeASTContext" begin
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
    pvd = CC.ParmVarDecl(CC.getParamDecl(fd, 0))

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
    CC.parse(I, "struct SCFBase { void m(); void n(); }; struct SCFDer : SCFBase { using SCFBase::m; using SCFBase::n; };")
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

@testset "SetFactory | ExprStmt" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
        """
        int compute(int n) {
            int arr[3] = {1, 2, 3};
            double d = 1.5;
            double dd = (double)n;
            return (int)d + arr[0];
        }
        """)
    ctx = CC.get_ast_context(I)

    lookup = DeclFinder(I)
    @test lookup(I, "compute")
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
    nodes = CC.subtree(CC.getBody(fd))

    il = first(filter(n -> n isa CC.IntegerLiteral, nodes))
    cs = first(filter(n -> n isa CC.CStyleCastExpr, nodes))

    # ---- Factories (read-only on the parsed nodes) ---------------------------
    ity = CC.getType(il)

    # CStyleCastExpr::CreateEmpty(ctx, PathSize, HasFPFeatures)
    empty_cast = CC.CStyleCastExpr(ctx, 0, false)
    @test empty_cast isa CC.CStyleCastExpr

    # CStyleCastExpr::Create (no-type-info): int -> int NoOp cast over `il`
    noop = CC.CStyleCastExpr(ctx, ity, CC.LibClangEx.CXExprValueKind_VK_PRValue,
                             CC.LibClangEx.CXCastKind_CK_NoOp, il)
    @test noop isa CC.CStyleCastExpr
    @test CC.getCastKind(noop) == CC.LibClangEx.CXCastKind_CK_NoOp
    @test CC.getSubExpr(noop).ptr == il.ptr

    # IntegerLiteral::Create(ctx, APInt-as-GenericValue, type, loc)
    gv = CC.getValue(il)
    newil = CC.IntegerLiteral(ctx, gv, ity, CC.getLocation(il))
    @test newil isa CC.IntegerLiteral

    # ---- Setters: round-trip through the paired getters ----------------------
    loc_a = CC.getLocation(il)      # a valid SourceLocation
    loc_b = CC.getRParenLoc(cs)     # a different valid SourceLocation
    @test loc_a.ptr != loc_b.ptr

    # CStyleCastExpr::setLParenLoc / setRParenLoc (mutate the freshly-parsed cast)
    CC.setLParenLoc(cs, loc_a)
    @test CC.getLParenLoc(cs).ptr == loc_a.ptr
    CC.setRParenLoc(cs, loc_b)
    @test CC.getRParenLoc(cs).ptr == loc_b.ptr

    # IntegerLiteral::setLocation on both a parsed and a freshly-created literal
    CC.setLocation(il, loc_b)
    @test CC.getLocation(il).ptr == loc_b.ptr
    CC.setLocation(newil, loc_a)
    @test CC.getLocation(newil).ptr == loc_a.ptr

    dispose(lookup)
    dispose(I)
end

@testset "SetFactory | FileScopeAsmDecl_Create round-trip" begin
    # Regression: clang_FileScopeAsmDecl_Create had cast the DeclContext (not the
    # Str param) to StringLiteral, so getAsmString returned garbage. A content
    # round-trip (not just isa) catches it.
    _fnd(::Type{T}, x) where {T} =
        x isa T ? x : (for c in CC.children(x); r = _fnd(T, CC.resolve(c)); r === nothing || return r; end; nothing)
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

@testset "SetFactory | FunctionDecl_Create bool round-trip" begin
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

@testset "SetFactory | CXXMethodDecl_Create bool round-trip" begin
    # Regression: clang_CXXMethodDecl_Create forwarded (isInline, UsesFPIntrin) in
    # reversed order, so a method created inline read back non-inline. isInlineSpecified
    # is inherited from FunctionDecl; reach it through the free primary-base upcast.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    CC.parse(I, "struct MFoo { void mbar(int); };")
    f = DeclFinder(I)
    @test f(I, "MFoo")
    mfoo = CC.CXXRecordDecl(get_decl(f).ptr)
    mbar = first(m for m in CC.getMethods(mfoo) if CC.getName(m) == "mbar")
    ni = CC.getNameInfo(mbar)
    mty = CC.getType(mbar)
    mtsi = CC.getTypeSourceInfo(mbar)
    sloc = CC.getBeginLoc(mbar)
    eloc = CC.getLocation(mbar)

    # uses_fp_intrin=false, is_inline=true
    md = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None,
                          false, true, LX.CXConstexprSpecKind_Unspecified, eloc)
    @test md isa CC.CXXMethodDecl
    @test CC.isInlineSpecified(CC.FunctionDecl(md.ptr)) == true    # was false before the fix

    # complementary: uses_fp_intrin=false, is_inline=false
    md2 = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None,
                           false, false, LX.CXConstexprSpecKind_Unspecified, eloc)
    @test CC.isInlineSpecified(CC.FunctionDecl(md2.ptr)) == false

    dispose(f)
    dispose(I)
end
