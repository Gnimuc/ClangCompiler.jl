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
if !@isdefined(_find_node)
    function _find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = _find_node(T, CC.resolve(c))
            r !== nothing && return r
        end
        return nothing
    end
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

        vd = CC.VarDecl(look("gvar"))
        lvd = CC.VarDecl(look("lvar"))
        fd = CC.FunctionDecl(look("gfunc"))
        rd = CC.getDefinition(CC.RecordDecl(look("SFoo")))
        ed = CC.getDefinition(CC.EnumDecl(look("EFoo")))
        tnd = CC.TypedefDecl(look("MyInt"))
        csv = CC.VarDecl(look("cstr"))

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
        @test !CC.is_null_handle(CC.TranslationUnitDecl(ctx))

        @test !CC.is_null_handle(CC.LabelDecl(ctx, dc, loc, id))
        @test !CC.is_null_handle(CC.LabelDecl(ctx, 1))

        @test !CC.is_null_handle(CC.NamespaceDecl(ctx, 1))

        @test !CC.is_null_handle(CC.VarDecl(ctx, dc, loc, loc, id, ty, tsi, LX.CXStorageClass_SC_None))
        @test !CC.is_null_handle(CC.VarDecl(ctx, 1))

        @test !CC.is_null_handle(CC.ImplicitParamDecl(ctx, dc, loc, id, ty, LX.CXImplicitParamKind_CXXThis))
        @test !CC.is_null_handle(CC.ImplicitParamDecl(ctx, 1))

        @test !CC.is_null_handle(CC.ParmVarDecl(ctx, dc, loc, loc, id, ty, tsi, LX.CXStorageClass_SC_None))
        @test !CC.is_null_handle(CC.ParmVarDecl(ctx, 1))

        @test !CC.is_null_handle(CC.FunctionDecl(ctx, dc, loc, loc, name, fty, ftsi, LX.CXStorageClass_SC_None, false,
                                                 true))
        @test !CC.is_null_handle(CC.FunctionDecl(ctx, 1))

        @test !CC.is_null_handle(CC.FieldDecl(ctx, dc, loc, loc, id, ty, tsi, CC.Expr_(C_NULL), false,
                                              LX.CXInClassInitStyle_ICIS_NoInit))
        @test !CC.is_null_handle(CC.FieldDecl(ctx, 1))

        @test !CC.is_null_handle(CC.EnumConstantDecl(ctx, 1))

        @test !CC.is_null_handle(CC.IndirectFieldDecl(ctx, 1))

        @test !CC.is_null_handle(CC.TypedefDecl(ctx, dc, loc, loc, id, tsi))
        @test !CC.is_null_handle(CC.TypedefDecl(ctx, 1))

        @test !CC.is_null_handle(CC.TypeAliasDecl(ctx, dc, loc, loc, id, tsi))
        @test !CC.is_null_handle(CC.TypeAliasDecl(ctx, 1))

        @test !CC.is_null_handle(CC.EnumDecl(ctx, dc, loc, loc, id))
        @test !CC.is_null_handle(CC.EnumDecl(ctx, 1))

        @test !CC.is_null_handle(CC.RecordDecl(ctx, LX.CXTagTypeKind_Struct, dc, loc, loc, id))
        @test !CC.is_null_handle(CC.RecordDecl(ctx, 1))

        @test !CC.is_null_handle(CC.ImportDecl(ctx, 1, 0))

        @test !CC.is_null_handle(CC.EmptyDecl(ctx, dc, loc))
        @test !CC.is_null_handle(CC.EmptyDecl(ctx, 1))

        # =========================================================
        # New setters (skiplisted) — round-trips
        # =========================================================

        # FunctionDecl::setIsPureVirtual
        CC.setVirtualAsWritten(fd, true)
        CC.setIsPureVirtual(fd, true)
        @test CC.isPureVirtual(fd)
        CC.setIsPureVirtual(fd, false)
        @test !CC.isPureVirtual(fd)

        # FieldDecl::setBitWidth
        CC.setBitWidth(fld2, bw)
        @test CC.isBitField(fld2)
        @test CC.getBitWidth(fld2).ptr == bw.ptr

        # FieldDecl::setInClassInitializer (fresh field w/ in-class-init storage)
        fdi = CC.FieldDecl(ctx, dc, loc, loc, id, ty, tsi, CC.Expr_(C_NULL), false, LX.CXInClassInitStyle_ICIS_CopyInit)
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
        CC.setScoped(ed, true)
        @test CC.isScoped(ed)
        CC.setScoped(ed, false)
        @test !CC.isScoped(ed)
        CC.setScopedUsingClassTag(ed, true)
        @test CC.isScopedUsingClassTag(ed)
        CC.setScopedUsingClassTag(ed, false)
        @test !CC.isScopedUsingClassTag(ed)
        CC.setFixed(ed, true)
        @test CC.isFixed(ed)
        CC.setFixed(ed, false)
        @test !CC.isFixed(ed)
        CC.setIntegerType(ed, ty2)
        @test CC.getIntegerType(ed).ptr == ty2.ptr
        CC.setPromotionType(ed, ty)
        @test CC.getPromotionType(ed).ptr == ty.ptr
        CC.setIntegerTypeSourceInfo(ed, tsi)
        @test CC.getIntegerTypeSourceInfo(ed).ptr == tsi.ptr

        # TagDecl setters (on the complete SFoo record)
        CC.setTagKind(rd, LX.CXTagTypeKind_Union)
        @test CC.getTagKind(rd) == LX.CXTagTypeKind_Union
        CC.setBraceRange(rd, CC.SourceRange(loc, loc2))
        br = CC.getBraceRange(rd)
        @test br.begin_loc == loc && br.end_loc == loc2
        CC.setCompleteDefinitionRequired(rd, true)
        @test CC.isCompleteDefinitionRequired(rd)
        CC.setCompleteDefinitionRequired(rd, false)
        @test !CC.isCompleteDefinitionRequired(rd)
        CC.setEmbeddedInDeclarator(rd, true)
        @test CC.isEmbeddedInDeclarator(rd)
        CC.setEmbeddedInDeclarator(rd, false)
        @test !CC.isEmbeddedInDeclarator(rd)
        CC.setFreeStanding(rd, true)
        @test CC.isFreeStanding(rd)
        CC.setFreeStanding(rd, false)
        @test !CC.isFreeStanding(rd)
        CC.setTypedefNameForAnonDecl(rd, tnd)
        @test CC.getTypedefNameForAnonDecl(rd).ptr == tnd.ptr

        # RecordDecl flag setters (data() is valid — SFoo is complete)
        CC.setHasFlexibleArrayMember(rd, true)
        @test CC.hasFlexibleArrayMember(rd)
        CC.setHasFlexibleArrayMember(rd, false)
        @test !CC.hasFlexibleArrayMember(rd)
        CC.setAnonymousStructOrUnion(rd, true)
        @test CC.isAnonymousStructOrUnion(rd)
        CC.setAnonymousStructOrUnion(rd, false)
        @test !CC.isAnonymousStructOrUnion(rd)
        CC.setHasObjectMember(rd, true)
        @test CC.hasObjectMember(rd)
        CC.setHasObjectMember(rd, false)
        @test !CC.hasObjectMember(rd)
        CC.setHasVolatileMember(rd, true)
        @test CC.hasVolatileMember(rd)
        CC.setHasVolatileMember(rd, false)
        @test !CC.hasVolatileMember(rd)
        CC.setHasLoadedFieldsFromExternalStorage(rd, true)
        @test CC.hasLoadedFieldsFromExternalStorage(rd)
        CC.setHasLoadedFieldsFromExternalStorage(rd, false)
        @test !CC.hasLoadedFieldsFromExternalStorage(rd)
        CC.setNonTrivialToPrimitiveDefaultInitialize(rd, true)
        @test CC.isNonTrivialToPrimitiveDefaultInitialize(rd)
        CC.setNonTrivialToPrimitiveDefaultInitialize(rd, false)
        @test !CC.isNonTrivialToPrimitiveDefaultInitialize(rd)
        CC.setNonTrivialToPrimitiveCopy(rd, true)
        @test CC.isNonTrivialToPrimitiveCopy(rd)
        CC.setNonTrivialToPrimitiveCopy(rd, false)
        @test !CC.isNonTrivialToPrimitiveCopy(rd)
        CC.setNonTrivialToPrimitiveDestroy(rd, true)
        @test CC.isNonTrivialToPrimitiveDestroy(rd)
        CC.setNonTrivialToPrimitiveDestroy(rd, false)
        @test !CC.isNonTrivialToPrimitiveDestroy(rd)
        CC.setHasNonTrivialToPrimitiveDefaultInitializeCUnion(rd, true)
        @test CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion(rd)
        CC.setHasNonTrivialToPrimitiveDefaultInitializeCUnion(rd, false)
        @test !CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion(rd)
        CC.setHasNonTrivialToPrimitiveDestructCUnion(rd, true)
        @test CC.hasNonTrivialToPrimitiveDestructCUnion(rd)
        CC.setHasNonTrivialToPrimitiveDestructCUnion(rd, false)
        @test !CC.hasNonTrivialToPrimitiveDestructCUnion(rd)
        CC.setHasNonTrivialToPrimitiveCopyCUnion(rd, true)
        @test CC.hasNonTrivialToPrimitiveCopyCUnion(rd)
        CC.setHasNonTrivialToPrimitiveCopyCUnion(rd, false)
        @test !CC.hasNonTrivialToPrimitiveCopyCUnion(rd)
        CC.setParamDestroyedInCallee(rd, true)
        @test CC.isParamDestroyedInCallee(rd)
        CC.setParamDestroyedInCallee(rd, false)
        @test !CC.isParamDestroyedInCallee(rd)
        CC.setArgPassingRestrictions(rd, LX.CXRecordDecl_APK_CannotPassInRegs)
        @test CC.getArgPassingRestrictions(rd) == LX.CXRecordDecl_APK_CannotPassInRegs
        CC.setCapturedRecord(rd)
        @test CC.isCapturedRecord(rd)

        # BlockDecl (fresh) setters
        bd = CC.BlockDecl(ctx, dc, loc)
        @test !CC.is_null_handle(CC.BlockDecl(ctx, 1))
        CC.setSignatureAsWritten(bd, ftsi)
        @test CC.getSignatureAsWritten(bd).ptr == ftsi.ptr
        @test (CC.setBody(bd, cs); true)
        CC.setCapturesCXXThis(bd, true)
        @test CC.capturesCXXThis(bd)
        CC.setCapturesCXXThis(bd, false)
        @test !CC.capturesCXXThis(bd)
        CC.setBlockMissingReturnType(bd, false)
        @test !CC.blockMissingReturnType(bd)
        CC.setBlockMissingReturnType(bd, true)
        @test CC.blockMissingReturnType(bd)
        CC.setIsConversionFromLambda(bd, true)
        @test CC.isConversionFromLambda(bd)
        CC.setIsConversionFromLambda(bd, false)
        @test !CC.isConversionFromLambda(bd)
        CC.setDoesNotEscape(bd, true)
        @test CC.doesNotEscape(bd)
        CC.setDoesNotEscape(bd, false)
        @test !CC.doesNotEscape(bd)
        CC.setCanAvoidCopyToHeap(bd, true)
        @test CC.canAvoidCopyToHeap(bd)
        CC.setCanAvoidCopyToHeap(bd, false)
        @test !CC.canAvoidCopyToHeap(bd)
        CC.setBlockMangling(bd, 7, tu)
        @test CC.getBlockManglingNumber(bd) == 7

        # CapturedDecl (fresh) setters — two params so getParam/setParam cannot ignore the index
        cd = CC.CapturedDecl(ctx, dc, 2)
        @test !CC.is_null_handle(CC.CapturedDecl(ctx, 1, 1))
        CC.setNothrow(cd, true)
        @test CC.isNothrow(cd)
        CC.setNothrow(cd, false)
        @test !CC.isNothrow(cd)
        CC.setBody(cd, body)
        @test CC.getBody(cd).ptr == body.ptr
        ipd = CC.ImplicitParamDecl(ctx, dc, loc, id, ty, LX.CXImplicitParamKind_CapturedContext)
        ipd1 = CC.ImplicitParamDecl(ctx, dc, loc, id, ty, LX.CXImplicitParamKind_CapturedContext)
        CC.setParam(cd, 0, ipd)
        CC.setParam(cd, 1, ipd1)
        @test CC.getParam(cd, 0).ptr == ipd.ptr
        @test CC.getParam(cd, 1).ptr == ipd1.ptr
        CC.setContextParam(cd, 1, ipd1)
        @test CC.getContextParam(cd).ptr == ipd1.ptr
        @test CC.getContextParamPosition(cd) == 1
        # All three index the same trailing parameter array, and clang asserts on each.
        n_cd = CC.getNumParams(cd)
        @test n_cd == 2
        @test_throws AssertionError CC.getParam(cd, n_cd)
        @test_throws AssertionError CC.setParam(cd, n_cd, ipd)
        @test_throws AssertionError CC.setContextParam(cd, n_cd, ipd)

        # ExportDecl (fresh) setter
        exd = CC.ExportDecl(ctx, dc, loc)
        @test !CC.is_null_handle(CC.ExportDecl(ctx, 1))
        CC.setRBraceLoc(exd, loc2)
        @test CC.getRBraceLoc(exd) == loc2

        # FileScopeAsmDecl (needs a StringLiteral)
        @test sl isa CC.StringLiteral
        fsad = CC.FileScopeAsmDecl(ctx, dc, sl, loc, loc)
        CC.setRParenLoc(fsad, loc2)
        @test CC.getRParenLoc(fsad) == loc2
        CC.setAsmString(fsad, sl)
        @test CC.getAsmString(fsad).ptr == sl.ptr
        @test !CC.is_null_handle(CC.FileScopeAsmDecl(ctx, 1))

        # AccessSpecDecl (fresh) setters
        asd = CC.AccessSpecDecl(ctx, LX.CXAccessSpecifier_AS_public, dc, loc, loc)
        @test !CC.is_null_handle(CC.AccessSpecDecl(ctx, 1))
        CC.setColonLoc(asd, loc2)
        @test CC.getColonLoc(asd) == loc2
        CC.setAccessSpecifierLoc(asd, loc2)
        @test CC.getAccessSpecifierLoc(asd) == loc2

        # LinkageSpecDecl (fresh) setters
        lsd = CC.LinkageSpecDecl(ctx, dc, loc, loc, LX.CXLinkageSpecDecl_lang_c, true)
        @test !CC.is_null_handle(CC.LinkageSpecDecl(ctx, 1))
        CC.setLanguage(lsd, LX.CXLinkageSpecDecl_lang_cxx)
        @test CC.getLanguage(lsd) == LX.CXLinkageSpecDecl_lang_cxx
        CC.setExternLoc(lsd, loc2)
        @test CC.getExternLoc(lsd) == loc2
        CC.setRBraceLoc(lsd, loc2)
        @test CC.getRBraceLoc(lsd) == loc2

        # =========================================================
        # Already-wrapped setters — representative round-trips
        # =========================================================

        # VarDecl
        CC.setStorageClass(vd, LX.CXStorageClass_SC_Static)
        @test CC.getStorageClass(vd) == LX.CXStorageClass_SC_Static
        CC.setTSCSpec(vd, LX.CXThreadStorageClassSpecifier_TSCS_thread_local)
        @test CC.getTSCSpec(vd) == LX.CXThreadStorageClassSpecifier_TSCS_thread_local
        CC.setConstexpr(vd, true)
        @test CC.isConstexpr(vd)
        CC.setConstexpr(vd, false)
        @test !CC.isConstexpr(vd)
        CC.setInitCapture(vd, true)
        @test CC.isInitCapture(vd)
        CC.setInitCapture(vd, false)
        @test !CC.isInitCapture(vd)
        CC.setNRVOVariable(vd, true)
        @test CC.isNRVOVariable(vd)
        CC.setNRVOVariable(vd, false)
        @test !CC.isNRVOVariable(vd)
        CC.setExceptionVariable(vd, true)
        @test CC.isExceptionVariable(vd)
        CC.setExceptionVariable(vd, false)
        @test !CC.isExceptionVariable(vd)
        CC.setCXXForRangeDecl(vd, true)
        @test CC.isCXXForRangeDecl(vd)
        CC.setCXXForRangeDecl(vd, false)
        @test !CC.isCXXForRangeDecl(vd)
        CC.setObjCForDecl(vd, true)
        @test CC.isObjCForDecl(vd)
        CC.setObjCForDecl(vd, false)
        @test !CC.isObjCForDecl(vd)
        CC.setARCPseudoStrong(vd, true)
        @test CC.isARCPseudoStrong(vd)
        CC.setARCPseudoStrong(vd, false)
        @test !CC.isARCPseudoStrong(vd)
        CC.setPreviousDeclInSameBlockScope(vd, true)
        @test CC.isPreviousDeclInSameBlockScope(vd)
        CC.setPreviousDeclInSameBlockScope(vd, false)
        @test !CC.isPreviousDeclInSameBlockScope(vd)
        CC.setInlineSpecified(vd)
        @test CC.isInlineSpecified(vd)
        @test (CC.setImplicitlyInline(vd); true)
        @test (CC.setEscapingByref(vd); true)

        # FunctionDecl
        CC.setStorageClass(fd, LX.CXStorageClass_SC_Static)
        @test CC.getStorageClass(fd) == LX.CXStorageClass_SC_Static
        CC.setConstexprKind(fd, LX.CXConstexprSpecKind_Constexpr)
        @test CC.getConstexprKind(fd) == LX.CXConstexprSpecKind_Constexpr
        # isDeletedAsWritten() == IsDeleted && !isDefaulted, so probe it before setDefaulted
        CC.setDeletedAsWritten(fd, true)
        @test CC.isDeletedAsWritten(fd)
        CC.setDeletedAsWritten(fd, false)
        @test !CC.isDeletedAsWritten(fd)
        CC.setTrivial(fd, true)
        @test CC.isTrivial(fd)
        CC.setTrivial(fd, false)
        @test !CC.isTrivial(fd)
        CC.setTrivialForCall(fd, true)
        @test CC.isTrivialForCall(fd)
        CC.setTrivialForCall(fd, false)
        @test !CC.isTrivialForCall(fd)
        CC.setDefaulted(fd, true)
        @test CC.isDefaulted(fd)
        CC.setDefaulted(fd, false)
        @test !CC.isDefaulted(fd)
        CC.setExplicitlyDefaulted(fd, true)
        @test CC.isExplicitlyDefaulted(fd)
        CC.setExplicitlyDefaulted(fd, false)
        @test !CC.isExplicitlyDefaulted(fd)
        CC.setHasWrittenPrototype(fd, true)
        @test CC.hasWrittenPrototype(fd)
        CC.setHasWrittenPrototype(fd, false)
        @test !CC.hasWrittenPrototype(fd)
        CC.setHasInheritedPrototype(fd, true)
        @test CC.hasInheritedPrototype(fd)
        CC.setHasInheritedPrototype(fd, false)
        @test !CC.hasInheritedPrototype(fd)
        CC.setHasImplicitReturnZero(fd, true)
        @test CC.hasImplicitReturnZero(fd)
        CC.setHasImplicitReturnZero(fd, false)
        @test !CC.hasImplicitReturnZero(fd)
        CC.setLateTemplateParsed(fd, true)
        @test CC.isLateTemplateParsed(fd)
        CC.setLateTemplateParsed(fd, false)
        @test !CC.isLateTemplateParsed(fd)
        CC.setInstantiationIsPending(fd, true)
        @test CC.instantiationIsPending(fd)
        CC.setInstantiationIsPending(fd, false)
        @test !CC.instantiationIsPending(fd)
        CC.setUsesSEHTry(fd, true)
        @test CC.usesSEHTry(fd)
        CC.setUsesSEHTry(fd, false)
        @test !CC.usesSEHTry(fd)
        CC.setHasSkippedBody(fd, true)
        @test CC.hasSkippedBody(fd)
        CC.setHasSkippedBody(fd, false)
        @test !CC.hasSkippedBody(fd)
        CC.setWillHaveBody(fd, true)
        @test CC.willHaveBody(fd)
        CC.setWillHaveBody(fd, false)
        @test !CC.willHaveBody(fd)
        CC.setIsMultiVersion(fd, true)
        @test CC.isMultiVersion(fd)
        CC.setIsMultiVersion(fd, false)
        @test !CC.isMultiVersion(fd)
        CC.setInlineSpecified(fd, true)
        @test CC.isInlineSpecified(fd)
        CC.setInlineSpecified(fd, false)
        @test !CC.isInlineSpecified(fd)
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
                                                      r = _fnd(T, CC.resolve(c))
                                                      r === nothing || return r
                                                  end; nothing)
    I = create_interpreter(String[])
    CC.parse(I, "const char *asmstr = \"roundtrip_asm\";")
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)
    @test f(I, "asmstr")
    vd = CC.VarDecl(get_decl(f))
    sl = _fnd(CC.StringLiteral, CC.resolve(CC.getInit(vd)))
    @test sl !== nothing
    loc = CC.getLocation(vd)
    asmdecl = CC.FileScopeAsmDecl(ctx, dc, sl, loc, loc)
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
    seed = CC.FunctionDecl(get_decl(f))
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
    getdecl(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

    vd = CC.VarDecl(getdecl("gint"))
    loc = CC.getLocation(vd)
    id = CC.getIdentifier(vd)
    int_qt = CC.getType(vd)

    # PragmaCommentDecl: kind and trailing arg round-trip
    pcd = CC.PragmaCommentDecl(ctx, tu, loc, LX.CXPragmaMSCommentKind_PCK_Lib, "libarg")
    @test CC.getCommentKind(pcd) == LX.CXPragmaMSCommentKind_PCK_Lib
    @test CC.getArg(pcd) == "libarg"
    @test !CC.is_null_handle(CC.PragmaCommentDecl(ctx, 1, 8))

    # PragmaDetectMismatchDecl: name/value round-trip
    pdd = CC.PragmaDetectMismatchDecl(ctx, tu, loc, "pname", "pval")
    @test CC.getName(pdd) == "pname"
    @test CC.getValue(pdd) == "pval"
    @test !CC.is_null_handle(CC.PragmaDetectMismatchDecl(ctx, 2, 12))

    @test !CC.is_null_handle(CC.ExternCContextDecl(ctx, tu))

    @test !CC.is_null_handle(CC.RequiresExprBodyDecl(ctx, dc, loc))
    @test !CC.is_null_handle(CC.RequiresExprBodyDecl(ctx, 3))

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
    back = CC.LinkageSpecDecl(ldc)
    @test back.ptr == lsd.ptr

    # CXXMethodDecl: devirtualization + corresponding-method lookups
    local me = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(CC.FunctionDecl(getdecl("usevm")))))
        n isa CC.MemberExpr && (me=n; break)
    end
    @test me isa CC.MemberExpr
    md = CC.CXXMethodDecl(CC.getMemberDecl(me))
    dv = CC.getDevirtualizedMethod(md, CC.getBase(me), false)
    @test CC.getName(dv) == "vm"

    vbase = CC.CXXRecordDecl(getdecl("VBase"))
    vder = CC.CXXRecordDecl(getdecl("VDer"))
    mib = CC.getCorrespondingMethodInClass(md, vbase, true)
    @test CC.getName(mib) == "vm"
    mdd = CC.getCorrespondingMethodDeclaredInClass(md, vder)
    @test CC.getName(mdd) == "vm"

    mes = [n for n in CC.subtree(CC.resolve(CC.getBody(CC.FunctionDecl(getdecl("useo"))))) if n isa CC.MemberExpr]
    @test length(mes) == 2
    byname = Dict(CC.getName(CC.getMemberDecl(m)) => m for m in mes)
    md_om2 = CC.getCanonicalDecl(CC.CXXMethodDecl(CC.getMemberDecl(byname["om2"])))
    md_om = CC.getCanonicalDecl(CC.CXXMethodDecl(CC.getMemberDecl(byname["om"])))
    @test CC.addOverriddenMethod(md_om2, md_om) === nothing

    # Process-global stats toggles (PrintStats writes a summary to stderr). The class is a
    # `::Type` tag because both are static. Untagged, these two lines sat in a `Decl` testset
    # and called `Stmt`'s statics -- the untagged spelling resolved to whichever hierarchy
    # was defined last, which is the reason the tag exists.
    @test CC.EnableStatistics(CC.Decl) === nothing
    @test CC.PrintStats(CC.Decl) === nothing
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
        CC.getDeclKindName(d) == "IndirectField" && push!(ifds, CC.IndirectFieldDecl(d))
    end
    @test length(ifds) == 2
    for ifd in ifds
        n = CC.getChainingSize(ifd)
        @test n == 2
        @test CC.getChainElement(ifd, 0).ptr != CC.getChainElement(ifd, 1).ptr
        @test CC.getChainElement(ifd, n - 1).ptr == CC.getAnonField(ifd).ptr
        @test_throws AssertionError CC.getChainElement(ifd, n)  # the restated clang assert (Invariant 3)
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
    rd = CC.CXXRecordDecl(get_decl(f))
    fields = collect(CC.getFields(rd))
    @test CC.getBitWidthValue(fields[1], ctx) == 3          # `int a : 3`
    @test !CC.isZeroSize(fields[1], ctx)
    @test CC.isMsStruct(rd, ctx) == Sys.iswindows()                   # value is target-ABI-dependent (MS layout on Windows)

    @test f(I, "fn")
    fd = CC.FunctionDecl(get_decl(f))
    @test CC.isFunctionOrFunctionTemplate(get_decl(f))
    csce = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(fd)))
        n isa CC.CStyleCastExpr && (csce=n; break)
    end
    @test csce !== nothing
    @test !CC.is_null_handle(CC.getLParenLoc(csce))
    @test !CC.is_null_handle(CC.getRParenLoc(csce))

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
        vd_g = CC.VarDecl(look("dk_gvar"))
        vd_l = CC.VarDecl(look("dk_lvar"))
        vd_n = CC.VarDecl(look("dk_noinit"))
        gfd = CC.FunctionDecl(look("dk_gfunc"))
        lblfd = CC.FunctionDecl(look("dk_lblfn"))
        vlafd = CC.FunctionDecl(look("dk_vlafn"))
        tnd = CC.TypedefDecl(look("DKMyInt"))
        nsd = CC.NamespaceDecl(look("DKNS"))
        vd_cstr = CC.VarDecl(look("dk_cstr"))

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
        @test CC.getStmt(ld).ptr == ls.ptr
        CC.setStmt(ld, ls)
        @test CC.getStmt(ld).ptr == ls.ptr
        @test !(CC.isGnuLocal(ld))
        CC.setLocStart(ld, gloc)
        @test !CC.is_null_handle(CC.getSourceRange(ld).begin_loc)
        @test CC.isMSAsmLabel(ld) == false
        @test !(CC.isResolvedMSAsmLabel(ld))
        CC.setMSAsmLabelResolved(ld)
        @test !(CC.isResolvedMSAsmLabel(ld))
        # MSAsmName is an empty StringRef here, so the shim returns NULL and the
        # wrapper's unsafe_string throws (safely) before any dereference.
        @test_throws ArgumentError CC.getMSAsmLabel(ld)

        # ================= TranslationUnitDecl / NamespaceDecl =================
        CC.getAnonymousNamespace(tu, nsd)              # misnamed setter wrapper
        @test CC.getAnonymousNamespace(tu).ptr == nsd.ptr
        CC.setInline(nsd, true)
        @test CC.isInline(nsd)
        CC.setInline(nsd, false)
        @test !CC.isInline(nsd)
        CC.setAnonymousNamespace(nsd, nsd)
        @test CC.getAnonymousNamespace(nsd).ptr == nsd.ptr
        CC.setLocStart(nsd, gloc)
        CC.setRBraceLoc(nsd, lloc)
        @test CC.getRBraceLoc(nsd) == lloc

        # ================= NamedDecl / ValueDecl / DeclaratorDecl =================
        vd_f1 = CC.VarDecl(ctx, dc, gloc, gloc, id, qt_int, tsi, LXD.CXStorageClass_SC_None)
        CC.setDeclName(vd_f1, gname)
        @test CC.getName(vd_f1) == "dk_gvar"

        # capture the value first: comparing the getter to itself passes whatever setType
        # writes, including null or another argument's payload
        newty = CC.get_qual_type(CC.DoubleTy(ctx))
        @test CC.getType(vd_l) != newty
        CC.setType(vd_l, newty)
        @test CC.getType(vd_l) == newty

        CC.setTypeSourceInfo(vd_g, tsi)
        @test CC.getTypeSourceInfo(vd_g).ptr == tsi.ptr
        CC.setInnerLocStart(vd_g, gloc)
        @test CC.getInnerLocStart(vd_g) == gloc

        # ================= VarDecl =================
        es1 = CC.ensureEvaluatedStmt(vd_g)
        @test CC.getEvaluatedStmt(vd_g).ptr == es1.ptr
        CC.demoteThisDefinitionToDeclaration(vd_g)
        @test CC.isThisDeclarationADemotedDefinition(vd_g)

        CC.setInit(vd_n, einit)
        @test CC.hasInit(vd_n)
        @test CC.getInit(vd_n).ptr == einit.ptr

        # static data members: DKA::dka_s gets member-specialization info from DKB::dkb_s
        @assert fnd(I, "DKA")
        rd_a = CC.getDefinition(CC.RecordDecl(get_tag(fnd)))
        sdm_a = nothing
        for d in CC.DeclIterator(rd_a)
            CC.getDeclKindName(d) == "Var" || continue
            sdm_a = CC.VarDecl(d)
            break
        end
        @assert fnd(I, "DKB")
        rd_b = CC.getDefinition(CC.RecordDecl(get_tag(fnd)))
        sdm_b = nothing
        for d in CC.DeclIterator(rd_b)
            CC.getDeclKindName(d) == "Var" || continue
            sdm_b = CC.VarDecl(d)
            break
        end
        @test sdm_a isa CC.VarDecl && sdm_b isa CC.VarDecl
        CC.setInstantiationOfStaticDataMember(sdm_a, sdm_b, LXD.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        @test CC.getInstantiatedFromStaticDataMember(sdm_a).ptr == sdm_b.ptr
        CC.setTemplateSpecializationKind(sdm_a, LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization, gloc)
        @test CC.getTemplateSpecializationKind(sdm_a) == LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization

        # described var template on a fresh VarDecl
        @assert fnd(I, "dk10_vt")
        vtd = nothing
        for d in CC.get_decls(fnd)
            if CC.getDeclKindName(d) == "VarTemplate"
                vtd = CC.VarTemplateDecl(d)
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
        CC.setHasInheritedDefaultArg(parm_a, false)
        @test !CC.hasInheritedDefaultArg(parm_a)
        CC.setKNRPromoted(parm_a, true)
        @test CC.isKNRPromoted(parm_a)
        CC.setKNRPromoted(parm_a, false)
        @test !CC.isKNRPromoted(parm_a)
        CC.setScopeInfo(parm_a, 1, 2)
        @test CC.getFunctionScopeDepth(parm_a) == 1
        @test CC.getFunctionScopeIndex(parm_a) == 2
        CC.setOwningFunction(parm_a, gfdc)
        @test CC.getDeclContext(parm_a).ptr == gfdc.ptr
        CC.setObjCMethodScopeInfo(parm_b, 2)
        @test CC.isObjCMethodParameter(parm_b)

        # ================= FunctionDecl =================
        mkfd() = CC.FunctionDecl(ctx, dc, gloc, gloc, fname, gfty, gftsi, LXD.CXStorageClass_SC_None, false, true)

        fd_f1 = mkfd()
        CC.setBody(fd_f1, gbody)
        @test CC.doesThisDeclarationHaveABody(fd_f1)
        @test CC.getBody(fd_f1).ptr == gbody.ptr

        fd_f2 = mkfd()
        @test (CC.setLazyBody(fd_f2, 0); true)

        fd_f3 = mkfd()
        @test (CC.setDefaultedFunctionInfo(fd_f3, LXD.CXFunctionDecl_DefaultedFunctionInfo(C_NULL)); true)

        fd_f4 = mkfd()
        CC.setPreviousDeclaration(fd_f4, gfd)
        @test CC.getPreviousDecl(fd_f4).ptr == gfd.ptr

        fd_f5 = mkfd()
        CC.setInstantiationOfMemberFunction(fd_f5, gfd, LXD.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        @test CC.getMemberSpecializationInfo(fd_f5).ptr != C_NULL
        CC.setTemplateSpecializationKind(fd_f5, LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization, gloc)
        @test CC.getTemplateSpecializationKind(fd_f5) == LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization

        @assert fnd(I, "dk_tfn")
        ftd = nothing
        for d in CC.get_decls(fnd)
            if CC.getDeclKindName(d) == "FunctionTemplate"
                ftd = CC.FunctionTemplateDecl(d)
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
                cand = CC.VarDecl(d)
                if CC.getNumTemplateParameterLists(cand) > 0
                    tplh = cand
                    break
                end
            elseif k == "CXXMethod"
                cand = CC.CXXMethodDecl(d)
                if CC.getNumTemplateParameterLists(cand) > 0
                    tplh = cand
                    break
                end
            end
        end
        @test tplh !== nothing
        @test CC.getName(CC.getParam(CC.getTemplateParameterList(tplh, 0), 0)) == "T"
        @test_throws AssertionError CC.getTemplateParameterList(tplh, CC.getNumTemplateParameterLists(tplh))

        # ================= TypeDecl / TypedefDecl =================
        typ0 = CC.getTypeForDecl(tnd)
        CC.setTypeForDecl(tnd, typ0)
        @test CC.getTypeForDecl(tnd) == typ0
        # and the QualType spelling reaches the same node through getTypePtr
        CC.setTypeForDecl(tnd, CC.getTypeDeclType(ctx, tnd))
        @test CC.getTypeForDecl(tnd) == typ0
        CC.setLocStart(tnd, gloc)
        @test CC.getBeginLoc(tnd) == gloc

        # ================= TagDecl =================
        @assert fnd(I, "DKS")
        td_s = CC.TagDecl(get_tag(fnd))
        @test CC.getName(CC.getDefinition(td_s)) == "DKS"

        rec_f = CC.RecordDecl(ctx, LXD.CXTagTypeKind_Struct, dc, gloc, gloc, id)
        CC.startDefinition(rec_f)
        @test CC.isBeingDefined(rec_f)
        CC.setCompleteDefinition(rec_f, true)
        @test CC.isCompleteDefinition(rec_f)

        # ================= FieldDecl =================
        rd_s = CC.getDefinition(CC.RecordDecl(td_s))
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
        vla_vd = CC.VarDecl(vla_d)
        vla_qt = CC.getType(vla_vd)
        vla_ty = CC.resolve(CC.getTypePtr(vla_qt))
        @test vla_ty isa CC.VariableArrayType
        rec_f2 = CC.RecordDecl(ctx, LXD.CXTagTypeKind_Struct, dc, gloc, gloc, id)
        CC.setCapturedRecord(rec_f2)
        fld_vla = CC.FieldDecl(ctx, CC.DeclContext(rec_f2), gloc, gloc, id, vla_qt, tsi, CC.Expr_(C_NULL), false,
                               LXD.CXInClassInitStyle_ICIS_NoInit)
        CC.setCapturedVLAType(fld_vla, vla_ty)
        @test CC.hasCapturedVLAType(fld_vla)
        @test CC.getCapturedVLAType(fld_vla).ptr == vla_ty.ptr

        # ================= EnumDecl / EnumConstantDecl =================
        ed = CC.getDefinition(CC.EnumDecl(look("DKE")))
        enum_f = CC.EnumDecl(ctx, dc, gloc, gloc, id)
        CC.setInstantiationOfMemberEnum(enum_f, ed, LXD.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        CC.setTemplateSpecializationKind(enum_f, LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization, gloc)
        @test CC.getTemplateSpecializationKind(enum_f) == LXD.CXTemplateSpecializationKind_TSK_ExplicitSpecialization

        ecd = CC.EnumConstantDecl(ctx, ed, gloc, id, qt_int, CC.Expr_(C_NULL), gv)
        @test CC.getName(ecd) == "dk_gvar"

        # ================= CapturedDecl =================
        cd_f = CC.CapturedDecl(ctx, dc, 1)
        ipd2 = CC.ImplicitParamDecl(ctx, dc, gloc, id, qt_int, LXD.CXImplicitParamKind_CapturedContext)
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
        @test !CC.is_null_handle(CC.getSourceRange(exd).begin_loc)

        # ================= FileScopeAsmDecl =================
        sl = dkfind(CC.StringLiteral, CC.resolve(CC.getInit(vd_cstr)))
        @test sl isa CC.StringLiteral
        fsad = CC.FileScopeAsmDecl(ctx, dc, sl, gloc, lloc)
        @test CC.getAsmLoc(fsad) == gloc
        @test !CC.is_null_handle(CC.getSourceRange(fsad).begin_loc)

        # ================= ImportDecl =================
        # CreateImplicit stores the module pointer without dereferencing it.
        imp1 = CC.ImportDecl(ctx, dc, gloc, CC.Module_(C_NULL), gloc)
        @test CC.is_null_handle(CC.getImportedModule(imp1))
        # A deserialized import is incomplete: no identifier locs, safe getters.
        imp2 = CC.ImportDecl(ctx, 99, 0)
        @test CC.getNumIdentifierLocs(imp2) == 0
        @test_throws AssertionError CC.getIdentifierLoc(imp2, 0)  # the restated clang assert (Invariant 3)
        @test CC.is_null_handle(CC.getSourceRange(imp2).begin_loc)

        # ================= IndirectFieldDecl =================
        @assert fnd(I, "dkiu_a")
        dif = get_decl(fnd)
        @test CC.getDeclKindName(dif) == "IndirectField"
        ifd = CC.IndirectFieldDecl(dif)
        @test CC.getName(ifd) == "dkiu_a"
        @test CC.getDeclKindName(CC.getVarDecl(ifd)) == "Var"
        @test CC.getCanonicalDecl(ifd).ptr == ifd.ptr
        # base Decl receivers on the plain Decl carrier
        @test !CC.is_null_handle(CC.getBeginLoc(dif))
        @test !(CC.isOutOfLine(dif))

        # ================= TypeAliasDecl =================
        @assert fnd(I, "DKAlias")
        tatd = nothing
        for d in CC.get_decls(fnd)
            if CC.getDeclKindName(d) == "TypeAliasTemplate"
                tatd = CC.TypeAliasTemplateDecl(d)
                break
            end
        end
        @test tatd isa CC.TypeAliasTemplateDecl
        tad_f = CC.TypeAliasDecl(ctx, dc, gloc, gloc, id, tsi)
        CC.setDescribedAliasTemplate(tad_f, tatd)
        @test CC.getDescribedAliasTemplate(tad_f).ptr == tatd.ptr

        # ================= DeclTemplate =================
        vd7 = CC.VarDecl(look("dk7_var"))
        specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd7)))
        @test CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        spec = CC.ClassTemplateSpecializationDecl(specrec)
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
        @test CC.getName(CC.getAsTemplateDecl(tn)) == "DK7S"

        # member template of an instantiated class template -> member specialization
        vd8 = CC.VarDecl(look("dk8_var"))
        rec8 = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd8)))
        @test CC.getDeclKindName(rec8) == "ClassTemplateSpecialization"
        spec8 = CC.ClassTemplateSpecializationDecl(rec8)
        stpl8 = CC.getSpecializedTemplate(spec8)
        CC.setMemberSpecialization(stpl8)
        @test CC.isMemberSpecialization(stpl8)

        # VarTemplateSpecializationDecl::getTemplateArgs
        vtsd = nothing
        for d in CC.DeclIterator(tu)
            if CC.getDeclKindName(d) == "VarTemplateSpecialization"
                vtsd = CC.VarTemplateSpecializationDecl(d)
                break
            end
        end
        @test vtsd isa CC.VarTemplateSpecializationDecl
        @test size(CC.getTemplateArgs(vtsd)) == 1

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
            @test !(CC.isExplicit(es))
            @test !(CC.isInvalid(es))
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
    enum class Wide : unsigned long long { Top = 0xFFFFFFFFFFFFFFFFULL, One = 1 };
    enum Negative { Neg = -3 };
    // `__int128` is gated on TargetInfo::hasInt128Type (pointer width >= 64), so this line
    // is an error under a 32-bit triple -- fine on all three x64 CI hosts, but it does not
    // belong in a fixture reused under a pinned 32-bit target.
    enum class Huge : unsigned __int128 { Big = (unsigned __int128)1 << 100, Small = 1 };

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
    getdecl(name) = (@assert f(I, name); get_decl(f))

    # ---------------- VarDecl / ValueDecl / DeclaratorDecl ----------------
    gvar = CC.VarDecl(getdecl("gvar"))
    cxglob = CC.VarDecl(getdecl("cxglob"))
    eglob = CC.VarDecl(getdecl("eglob"))
    sglob = CC.VarDecl(getdecl("sglob"))

    @test CC.hasLocalStorage(gvar) == false
    @test CC.isStaticLocal(gvar) == false
    @test CC.hasExternalStorage(gvar) == false
    @test CC.hasGlobalStorage(gvar) == true
    @test CC.isExternC(gvar) == false
    @test CC.isInExternCContext(gvar) == false
    @test CC.isInExternCXXContext(gvar) == false
    @test CC.isLocalVarDecl(gvar) == false
    @test CC.isLocalVarDeclOrParm(gvar) == false
    @test CC.isFunctionOrMethodVarDecl(gvar) == false
    @test CC.isStaticDataMember(gvar) == false
    @test CC.isOutOfLine(gvar) == false
    @test CC.isFileVarDecl(gvar) == true
    @test CC.hasInit(gvar) == true
    @test CC.hasConstantInitialization(gvar) == true
    @test CC.isDirectInit(gvar) == false
    @test CC.isThisDeclarationADemotedDefinition(gvar) == false
    @test CC.isExceptionVariable(gvar) == false
    @test CC.isNRVOVariable(gvar) == false
    @test CC.isCXXForRangeDecl(gvar) == false
    @test CC.isObjCForDecl(gvar) == false
    @test CC.isARCPseudoStrong(gvar) == false
    @test CC.isInline(gvar) == false
    @test CC.isInlineSpecified(gvar) == false
    @test CC.isConstexpr(gvar) == false
    @test CC.isInitCapture(gvar) == false
    @test CC.isParameterPack(gvar) == false
    @test CC.isPreviousDeclInSameBlockScope(gvar) == false
    @test CC.isEscapingByref(gvar) == false
    @test CC.isNonEscapingByref(gvar) == false
    @test CC.isKnownToBeDefined(gvar) == true
    @test CC.isWeak(gvar) == false

    @test CC.getStorageClass(gvar) == LX.CXStorageClass_SC_None
    @test CC.getTSCSpec(gvar) == LX.CXThreadStorageClassSpecifier_TSCS_unspecified
    @test CC.getStorageDuration(gvar) == LX.CXStorageDuration_SD_Static
    @test CC.getLanguageLinkage(gvar) == LX.CXLanguageLinkage_CXXLanguageLinkage
    @test CC.getTemplateSpecializationKind(gvar) == LX.CXTemplateSpecializationKind_TSK_Undeclared
    @test CC.getTemplateSpecializationKindForInstantiation(gvar) == LX.CXTemplateSpecializationKind_TSK_Undeclared
    @test CC.getInitializingDeclaration(gvar).ptr == gvar.ptr
    @test CC.getNumTemplateParameterLists(gvar) == 0

    @test CC.getAsString(CC.getType(gvar)) == "int"
    @test CC.getCanonicalDecl(gvar).ptr == gvar.ptr
    @test CC.is_null_handle(CC.getActingDefinition(gvar))
    @test CC.getDefinition(gvar).ptr == gvar.ptr
    @test CC.getInit(gvar).ptr == CC.getAnyInitializer(gvar).ptr
    @test CC.is_null_handle(CC.getTemplateInstantiationPattern(gvar))
    @test CC.is_null_handle(CC.getInstantiatedFromStaticDataMember(gvar))
    @test CC.is_null_handle(CC.getDescribedVarTemplate(gvar))
    @test CC.is_null_handle(CC.getPointOfInstantiation(gvar))
    @test !CC.is_null_handle(CC.evaluateValue(cxglob))
    # `extern int eglob;` declares without defining, so there is no initializer to fold.
    # Upstream reaches through getInit() with no null test and segfaults; the gate is what
    # turns that into an exception.
    @test CC.hasInit(eglob) == false
    @test_throws AssertionError CC.evaluateValue(eglob)
    @test !CC.is_null_handle(CC.getSourceRange(gvar).begin_loc)
    @test CC.mightBeUsableInConstantExpressions(cxglob, ctx) == true
    @test CC.isUsableInConstantExpressions(cxglob, ctx) == true
    @test CC.hasICEInitializer(cxglob, ctx) == true
    @test CC.hasExternalStorage(eglob) == true
    @test CC.getStorageClass(sglob) == LX.CXStorageClass_SC_Static

    # DeclaratorDecl accessors
    @test !CC.is_null_handle(CC.getTypeSourceInfo(gvar))
    @test !CC.is_null_handle(CC.getInnerLocStart(gvar))
    @test !CC.is_null_handle(CC.getOuterLocStart(gvar))
    @test !CC.is_null_handle(CC.getBeginLoc(gvar))
    @test CC.is_null_handle(CC.getQualifier(gvar))
    @test CC.is_null_handle(CC.getTrailingRequiresClause(gvar))
    @test !CC.is_null_handle(CC.getTypeSpecStartLoc(gvar))
    @test !CC.is_null_handle(CC.getTypeSpecEndLoc(gvar))

    # ---------------- NamedDecl (call on a plainly-named decl) ----------------
    @test CC.hasLinkage(gvar) == true
    @test CC.isCXXClassMember(gvar) == false
    @test CC.isCXXInstanceMember(gvar) == false
    @test CC.hasExternalFormalLinkage(gvar) == true
    @test CC.isExternallyVisible(gvar) == true
    @test CC.isExternallyDeclarable(gvar) == true
    @test CC.isLinkageValid(gvar) == true
    @test CC.hasLinkageBeenComputed(gvar) == true

    @test CC.getName(gvar) == "gvar"
    @test CC.getName(CC.getIdentifier(gvar)) == "gvar"
    @test CC.getUnderlyingDecl(gvar).ptr == gvar.ptr
    @test CC.getVisibility(gvar) == LX.CXVisibility_DefaultVisibility
    @test CC.getLinkageInternal(gvar) == LX.CXLinkage_External
    @test CC.getFormalLinkage(gvar) == LX.CXLinkage_External
    @test CC.getMostRecentDecl(gvar).ptr == gvar.ptr
    @test CC.declarationReplaces(gvar, gvar) == true
    @test CC.isFunctionOrFunctionTemplate(gvar) == false

    # ---------------- FunctionDecl ----------------
    add = CC.FunctionDecl(getdecl("add"))
    vfn = CC.FunctionDecl(getdecl("variadic_fn"))
    cfn = CC.FunctionDecl(getdecl("cfunc"))
    sfn = CC.FunctionDecl(getdecl("sfunc"))
    inl = CC.FunctionDecl(getdecl("inl_fn"))
    wdf = CC.FunctionDecl(getdecl("withdef"))

    @test CC.isPureVirtual(add) == false
    @test CC.hasBody(add) == true
    @test CC.hasTrivialBody(add) == false
    @test CC.isDefined(add) == true
    @test CC.isThisDeclarationADefinition(add) == true
    @test CC.isThisDeclarationInstantiatedFromAFriendDefinition(add) == false
    @test CC.doesThisDeclarationHaveABody(add) == true
    @test CC.isVariadic(add) == false
    @test CC.isVirtualAsWritten(add) == false
    @test CC.isLateTemplateParsed(add) == false
    @test CC.isTrivial(add) == false
    @test CC.isTrivialForCall(add) == false
    @test CC.isDefaulted(add) == false
    @test CC.isExplicitlyDefaulted(add) == false
    @test CC.isUserProvided(add) == true
    @test CC.hasImplicitReturnZero(add) == false
    @test CC.hasPrototype(add) == true
    @test CC.hasWrittenPrototype(add) == true
    @test CC.hasInheritedPrototype(add) == false
    @test CC.isConstexpr(add) == false
    @test CC.isConstexprSpecified(add) == false
    @test CC.isConsteval(add) == false
    @test CC.instantiationIsPending(add) == false
    @test CC.usesSEHTry(add) == false
    @test CC.isDeleted(add) == false
    @test CC.isDeletedAsWritten(add) == false
    @test CC.isMain(add) == false
    @test CC.isMSVCRTEntryPoint(add) == false
    @test CC.isReservedGlobalPlacementOperator(add) == false
    @test CC.isReplaceableGlobalAllocationFunction(add) == false
    @test CC.isInlineBuiltinDeclaration(add) == false
    @test CC.isDestroyingOperatorDelete(add) == false
    @test CC.isExternC(add) == false
    @test CC.isInExternCContext(add) == false
    @test CC.isInExternCXXContext(add) == false
    @test CC.isGlobal(add) == true
    @test CC.isNoReturn(add) == false
    @test CC.hasSkippedBody(add) == false
    @test CC.willHaveBody(add) == false
    @test CC.isMultiVersion(add) == false
    @test CC.isCPUDispatchMultiVersion(add) == false
    @test CC.isCPUSpecificMultiVersion(add) == false
    @test CC.isTargetMultiVersion(add) == false
    @test CC.isInlineSpecified(add) == false
    @test CC.isInlined(add) == false
    @test CC.isInlineDefinitionExternallyVisible(add) == true
    @test CC.isMSExternInline(add) == false
    @test CC.doesDeclarationForceExternallyVisibleDefinition(add) == false
    @test CC.isStatic(add) == false
    @test CC.isOverloadedOperator(add) == false
    @test CC.isFunctionTemplateSpecialization(add) == false
    @test CC.isImplicitlyInstantiable(add) == false
    @test CC.isTemplateInstantiation(add) == false
    @test CC.isOutOfLine(add) == false
    @test CC.hasOneParamOrDefaultArgs(add) == false
    @test CC.isDefined(wdf) == false

    @test CC.getConstexprKind(add) == LX.CXConstexprSpecKind_Unspecified
    @test CC.getExceptionSpecType(add) == LX.CXExceptionSpecificationType_EST_None
    @test CC.getStorageClass(add) == LX.CXStorageClass_SC_None
    @test CC.getLanguageLinkage(add) == LX.CXLanguageLinkage_CXXLanguageLinkage
    @test CC.getMultiVersionKind(add) == LX.CXMultiVersionKind_None
    @test CC.getTemplatedKind(add) == LX.CXFunctionDecl_TK_NonTemplate
    @test CC.getTemplateSpecializationKind(add) == LX.CXTemplateSpecializationKind_TSK_Undeclared
    @test CC.getTemplateSpecializationKindForInstantiation(add) == LX.CXTemplateSpecializationKind_TSK_Undeclared
    @test CC.getMemoryFunctionKind(add) == 0
    @test CC.getBuiltinID(add) == 0
    @test CC.getNumParams(add) == 2
    @test CC.getMinRequiredArguments(add) == 2
    @test CC.getODRHash(add) != 0

    @test CC.is_null_handle(CC.getExceptionSpecSourceRange(add).begin_loc)
    @test !CC.is_null_handle(CC.getParametersSourceRange(add).begin_loc)
    @test !CC.is_null_handle(CC.getReturnTypeSourceRange(add).begin_loc)
    @test !CC.is_null_handle(CC.getSourceRange(add).begin_loc)
    @test !CC.is_null_handle(CC.getNameInfo(add))
    @test CC.getDefinition(add).ptr == add.ptr
    @test CC.getCanonicalDecl(add).ptr == add.ptr
    @test CC.getAsString(CC.getReturnType(add)) == "int"
    @test CC.getAsString(CC.getDeclaredReturnType(add)) == "int"
    @test CC.getAsString(CC.getCallResultType(add)) == "int"
    @test CC.is_null_handle(CC.getLiteralIdentifier(add))
    @test CC.is_null_handle(CC.getMemberSpecializationInfo(add))
    @test CC.is_null_handle(CC.getDescribedFunctionTemplate(add))
    @test CC.is_null_handle(CC.getInstantiatedFromMemberFunction(add))
    @test CC.is_null_handle(CC.getTemplateSpecializationInfo(add))
    @test CC.is_null_handle(CC.getPrimaryTemplate(add))
    @test CC.is_null_handle(CC.getTemplateSpecializationArgs(add))
    @test CC.is_null_handle(CC.getTemplateSpecializationArgsAsWritten(add))
    @test CC.is_null_handle(CC.getDependentSpecializationInfo(add))
    @test CC.is_null_handle(CC.getPointOfInstantiation(add))
    @test CC.getName(CC.getParamDecl(add, 0)) == "a"
    @test CC.getName(CC.getParamDecl(add, 1)) == "b"
    @test_throws AssertionError CC.getParamDecl(add, CC.getNumParams(add))  # the restated clang assert (Invariant 3)
    @test CC.isVariadic(vfn) == true
    @test !CC.is_null_handle(CC.getEllipsisLoc(vfn))
    @test CC.isExternC(cfn) == true
    @test CC.isStatic(sfn) == true
    @test CC.isInlined(inl) == true

    # ---------------- ParmVarDecl ----------------
    p0 = CC.getParamDecl(add, 0)
    p1 = CC.getParamDecl(add, 1)
    pdef = CC.getParamDecl(wdf, 1)

    @test CC.isObjCMethodParameter(p0) == false
    @test CC.isDestroyedInCallee(p0) == false
    @test CC.isKNRPromoted(p0) == false
    @test CC.hasDefaultArg(p0) == false
    @test CC.hasUnparsedDefaultArg(p0) == false
    @test CC.hasUninstantiatedDefaultArg(p0) == false
    @test CC.hasInheritedDefaultArg(p0) == false

    @test CC.getFunctionScopeDepth(p0) == 0
    @test CC.getFunctionScopeIndex(p0) == 0
    @test CC.getFunctionScopeIndex(p1) == 1
    @test CC.getFunctionScopeIndex(pdef) == 1
    @test CC.is_null_handle(CC.getDefaultArgRange(p0).begin_loc)
    @test CC.getAsString(CC.getOriginalType(p0)) == "int"
    @test CC.hasDefaultArg(pdef) == true
    @test !CC.is_null_handle(CC.getDefaultArg(pdef))

    # ---------------- RecordDecl / TagDecl / TypeDecl ----------------
    rd = CC.RecordDecl(getdecl("Point"))

    @test CC.hasFlexibleArrayMember(rd) == false
    @test CC.isAnonymousStructOrUnion(rd) == false
    @test CC.isInjectedClassName(rd) == false
    @test CC.isLambda(rd) == false
    @test CC.isCapturedRecord(rd) == false
    @test CC.isOrContainsUnion(rd) == false
    @test CC.canPassInRegisters(rd) == true
    @test CC.hasLoadedFieldsFromExternalStorage(rd) == false
    @test CC.hasNonTrivialToPrimitiveCopyCUnion(rd) == false
    @test CC.hasNonTrivialToPrimitiveDefaultInitializeCUnion(rd) == false
    @test CC.hasNonTrivialToPrimitiveDestructCUnion(rd) == false
    @test CC.hasObjectMember(rd) == false
    @test CC.hasVolatileMember(rd) == false
    @test CC.isNonTrivialToPrimitiveCopy(rd) == false
    @test CC.isNonTrivialToPrimitiveDefaultInitialize(rd) == false
    @test CC.isNonTrivialToPrimitiveDestroy(rd) == false
    @test CC.isParamDestroyedInCallee(rd) == false

    @test CC.getNumFields(rd) == 4
    @test CC.getArgPassingRestrictions(rd) == LX.CXRecordDecl_APK_CanPassInRegs
    @test CC.is_null_handle(CC.getPreviousDecl(rd))
    @test CC.getMostRecentDecl(rd).ptr == rd.ptr
    @test CC.getDefinition(rd).ptr == rd.ptr
    @test CC.getName(CC.findFirstNamedDataMember(rd)) == "x"
    @test CC.isMsStruct(rd, ctx) == Sys.iswindows()
    # a plain struct is no template specialization, and the cast says which class it is
    @test_throws CC.CastError CC.ClassTemplateSpecializationDecl(rd)

    # TagDecl-level accessors (dispatch to AbstractTagDecl via RecordDecl)
    @test CC.isThisDeclarationADefinition(rd) == true
    @test CC.isCompleteDefinition(rd) == true
    @test CC.isBeingDefined(rd) == false
    @test CC.isFreeStanding(rd) == true
    @test CC.isStruct(rd) == true
    @test CC.isInterface(rd) == false
    @test CC.isClass(rd) == false
    @test CC.isUnion(rd) == false
    @test CC.isEnum(rd) == false
    @test CC.hasNameForLinkage(rd) == true
    @test CC.isCompleteDefinitionRequired(rd) == false
    @test CC.isDependentType(rd) == false
    @test CC.isEmbeddedInDeclarator(rd) == false
    @test CC.mayHaveOutOfDateDef(rd) == false

    @test CC.getCanonicalDecl(rd).ptr == rd.ptr
    @test CC.getKindName(rd) == "struct"
    @test CC.getTagKind(rd) == LX.CXTagTypeKind_Struct
    @test CC.is_null_handle(CC.getTypedefNameForAnonDecl(rd))
    @test CC.is_null_handle(CC.getQualifier(rd))
    @test !CC.is_null_handle(CC.getBraceRange(rd).begin_loc)
    @test !CC.is_null_handle(CC.getInnerLocStart(rd))
    @test !CC.is_null_handle(CC.getOuterLocStart(rd))
    @test !CC.is_null_handle(CC.getSourceRange(rd).begin_loc)

    # NamedDecl -> TypeDecl cast + TypeDecl accessors
    rec_named = CC.NamedDecl(getdecl("Point"))
    td_base = CC.TypeDecl(rec_named)
    @test td_base.ptr == rd.ptr
    @test CC.getTypeForDecl(rec_named).ptr == CC.getTypeForDecl(td_base).ptr
    @test !CC.is_null_handle(CC.getBeginLoc(td_base))

    # ---------------- FieldDecl ----------------
    fields = CC.getFields(rd)
    @test length(fields) == 4

    # fields[1]: int x
    @test CC.isBitField(fields[1]) == false
    @test CC.isMutable(fields[1]) == false
    @test CC.isUnnamedBitfield(fields[1]) == false
    @test CC.isAnonymousStructOrUnion(fields[1]) == false
    @test CC.hasCapturedVLAType(fields[1]) == false
    @test CC.hasInClassInitializer(fields[1]) == false
    @test CC.getFieldIndex(fields[1]) == 0
    @test CC.getInClassInitStyle(fields[1]) == LX.CXInClassInitStyle_ICIS_NoInit
    @test CC.is_null_handle(CC.getBitWidth(fields[1]))
    @test CC.getCanonicalDecl(fields[1]).ptr == fields[1].ptr
    @test CC.is_null_handle(CC.getCapturedVLAType(fields[1]))
    @test CC.is_null_handle(CC.getInClassInitializer(fields[1]))
    @test CC.getParent(fields[1]).ptr == rd.ptr
    @test CC.isZeroLengthBitField(fields[1], ctx) == false
    @test CC.isZeroSize(fields[1], ctx) == false

    # fields[2]: int y : 3 — polarity against field 1 on bit-width / index
    @test CC.isBitField(fields[2]) == true
    @test CC.getFieldIndex(fields[2]) == 1
    @test !CC.is_null_handle(CC.getBitWidth(fields[2]))
    @test CC.getParent(fields[2]).ptr == rd.ptr
    @test CC.isZeroLengthBitField(fields[2], ctx) == false
    @test CC.isZeroSize(fields[2], ctx) == false

    # fields[3]: double z
    @test CC.isBitField(fields[3]) == false
    @test CC.getFieldIndex(fields[3]) == 2

    # fields[4]: int : 0
    @test CC.isBitField(fields[4]) == true
    @test CC.isUnnamedBitfield(fields[4]) == true
    @test CC.getFieldIndex(fields[4]) == 3
    @test CC.isZeroLengthBitField(fields[4], ctx) == true
    @test CC.isZeroSize(fields[4], ctx) == true

    bf = fields[2]
    @test CC.getBitWidthValue(bf, ctx) == 3

    # ---------------- EnumDecl / EnumConstantDecl ----------------
    ed = CC.EnumDecl(getdecl("Color"))
    sed = CC.EnumDecl(getdecl("Scoped"))

    @test CC.isClosed(ed) == true
    @test CC.isClosedFlag(ed) == false
    @test CC.isClosedNonFlag(ed) == true
    @test CC.isComplete(ed) == true
    @test CC.isFixed(ed) == false
    @test CC.isScoped(ed) == false
    @test CC.isScopedUsingClassTag(ed) == false

    @test CC.isScoped(sed) == true
    @test CC.getNumNegativeBits(ed) == 0
    @test CC.getNumPositiveBits(ed) == 3
    @test CC.getODRHash(ed) != 0
    @test CC.getNumEnumerators(ed) == 3
    @test CC.getCanonicalDecl(ed).ptr == ed.ptr
    @test CC.is_null_handle(CC.getPreviousDecl(ed))
    @test CC.getMostRecentDecl(ed).ptr == ed.ptr
    @test CC.getDefinition(ed).ptr == ed.ptr
    @test CC.getAsString(CC.getIntegerType(sed)) == "long"
    @test CC.is_null_handle(CC.getInstantiatedFromMemberEnum(ed))
    @test !CC.is_null_handle(CC.getIntegerTypeRange(sed).begin_loc)
    @test !CC.is_null_handle(CC.getIntegerTypeSourceInfo(sed))
    @test CC.is_null_handle(CC.getMemberSpecializationInfo(ed))
    @test CC.isIntegerType(CC.getTypePtr(CC.getPromotionType(ed)))
    @test CC.is_null_handle(CC.getTemplateInstantiationPattern(ed))
    @test CC.getTemplateSpecializationKind(ed) == LX.CXTemplateSpecializationKind_TSK_Undeclared

    enumerators = CC.getEnumerators(ed)
    @test length(enumerators) == 3
    ec = enumerators[2]   # Green = 5
    @test CC.getEnumConstantDeclValue(ec) == 5
    @test CC.getZExtInitVal(ec) == 5
    @test CC.initValFitsInInt64(ec) == true
    @test CC.initValFitsInUInt64(ec) == true

    # Signedness is what the GenericValue bridge cannot carry, and the one case where the
    # two narrowing accessors disagree: an unsigned 64-bit enumerator with its top bit set
    # reads back as -1 through the sign-extending one. Which to trust is `isInitValSigned`.
    @test f(I, "Wide")
    wide = Dict(CC.getNameAsString(e) => e for e in CC.getEnumerators(CC.EnumDecl(get_decl(f))))
    @test CC.isInitValSigned(wide["Top"]) == false
    # A 64-bit enumerator is a single APInt word, so both narrowings are safe even though
    # one of them reports the value negative.
    @test CC.initValFitsInInt64(wide["Top"]) == true
    @test CC.initValFitsInUInt64(wide["Top"]) == true
    @test CC.getZExtInitVal(wide["Top"]) == 0xFFFFFFFFFFFFFFFF
    @test CC.getEnumConstantDeclValue(wide["Top"]) == -1
    @test CC.getZExtInitVal(wide["One"]) == CC.getEnumConstantDeclValue(wide["One"]) == 1

    # A 128-bit enumerator fits neither narrowing, which is what makes the two gates
    # observable at all: asserted only on values that fit, a predicate stuck at `true` passes
    # every test above. `Small` is the partition — same 128-bit enum, so the predicates are
    # answering about the VALUE rather than about the declared width.
    @test f(I, "Huge")
    huge = Dict(CC.getNameAsString(e) => e for e in CC.getEnumerators(CC.EnumDecl(get_decl(f))))
    @test CC.initValFitsInInt64(huge["Big"]) == false
    @test CC.initValFitsInUInt64(huge["Big"]) == false
    @test_throws AssertionError CC.getEnumConstantDeclValue(huge["Big"])
    @test_throws AssertionError CC.getZExtInitVal(huge["Big"])
    @test CC.initValFitsInInt64(huge["Small"]) == true
    @test CC.initValFitsInUInt64(huge["Small"]) == true
    @test CC.getEnumConstantDeclValue(huge["Small"]) == 1
    @test CC.getZExtInitVal(huge["Small"]) == 1

    @test f(I, "Negative")
    neg = only(CC.getEnumerators(CC.EnumDecl(get_decl(f))))
    @test CC.isInitValSigned(neg) == true
    @test CC.getEnumConstantDeclValue(neg) == -3
    @test CC.getCanonicalDecl(ec).ptr == ec.ptr
    @test !CC.is_null_handle(CC.getInitExpr(ec))
    # NamedDecl -> EnumConstantDecl cast
    ec_named = CC.NamedDecl(ec)
    @test CC.EnumConstantDecl(ec_named).ptr == ec.ptr

    # ---------------- TypedefNameDecl / TypedefDecl / TypeAliasDecl ----------------
    td = CC.TypedefDecl(getdecl("MyInt"))
    tad = CC.TypeAliasDecl(getdecl("MyAlias"))
    @test CC.getAsString(CC.getUnderlyingType(td)) == "int"
    @test CC.getCanonicalDecl(td).ptr == td.ptr
    @test CC.is_null_handle(CC.getAnonDeclWithTypedefName(td))
    @test CC.isTransparentTag(td) == false
    @test !CC.is_null_handle(CC.getTypeSourceInfo(td))
    @test CC.isModed(td) == false
    @test CC.getAsString(CC.getUnderlyingType(tad)) == "double"
    @test CC.is_null_handle(CC.getDescribedAliasTemplate(tad))

    # ---------------- NamespaceDecl ----------------
    ns = CC.NamespaceDecl(getdecl("ns"))
    tinl = CC.NamespaceDecl(getdecl("top_inl"))
    @test CC.isAnonymousNamespace(ns) == false
    @test CC.isInline(ns) == false
    @test CC.isInline(tinl) == true
    @test CC.isOriginalNamespace(ns) == true
    @test CC.getOriginalNamespace(ns).ptr == ns.ptr
    @test CC.isAnonymousNamespace(CC.getAnonymousNamespace(ns))
    @test CC.getCanonicalDecl(ns).ptr == ns.ptr
    @test !CC.is_null_handle(CC.getRBraceLoc(ns))

    # ---------------- TranslationUnitDecl ----------------
    tu = CC.getTranslationUnitDecl(gvar)
    @test CC.getASTContext(tu).ptr == ctx.ptr
    @test CC.is_null_handle(CC.getAnonymousNamespace(tu))

    # ---------------- BlockDecl (reached via the recursive decl walk) ----------------
    all_decls = CC.decls(CC.castToDeclContext(tu))
    blk = all_decls[findfirst(d -> d isa CC.BlockDecl, all_decls)]
    # Upstream indexes an ArrayRef unchecked, so one past the end is a read of adjacent memory
    # rather than null -- the gate is the only thing between a caller and that.
    @test_throws AssertionError CC.getParamDecl(blk, CC.getNumParams(blk))
    addend = all_decls[findfirst(d -> d isa CC.VarDecl && CC.getName(d) == "addend", all_decls)]
    @test CC.blockMissingReturnType(blk) == false
    @test CC.canAvoidCopyToHeap(blk) == true
    @test CC.capturesCXXThis(blk) == false
    @test CC.doesNotEscape(blk) == false
    @test CC.hasCaptures(blk) == true
    @test CC.isConversionFromLambda(blk) == false
    @test CC.isVariadic(blk) == false

    @test CC.is_null_handle(CC.getBlockManglingContextDecl(blk))
    @test CC.getBlockManglingNumber(blk) == 0
    @test !CC.is_null_handle(CC.getCaretLocation(blk))
    @test CC.getNumCaptures(blk) == 1
    @test CC.getNumParams(blk) == 1
    @test !CC.is_null_handle(CC.getSignatureAsWritten(blk))
    @test CC.capturesVariable(blk, addend) == true
    @test CC.getName(CC.getParamDecl(blk, 0)) == "q"
    @test length(CC.getParams(blk)) == 1

    dispose(f)
    dispose(I)
end

@testset "Coverage | fixed wrapper arity bugs" begin
    # Regression for three wrappers whose Julia arity/name had drifted from the
    # binding so any call errored (never covered before).
    I = create_interpreter(String[])
    CC.parse(I,
             "int gvfix = 0; int plainfix(int a){ return a; } struct Afix { virtual void p() = 0; virtual void q(); };")
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    @test f(I, "gvfix")
    @test CC.isNoDestroy(CC.VarDecl(get_decl(f)), ctx) == false     # was: missing ctx arg

    @test f(I, "plainfix")
    fd = CC.FunctionDecl(get_decl(f))
    @test CC.is_null_handle(CC.getTemplateInstantiationPattern(fd, true))  # was: missing for_def arg

    @test f(I, "Afix")
    afix = CC.CXXRecordDecl(get_decl(f))
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
        # the lookup hands back a NamedDecl; each probe names the class it expects
        D(name, T) = (f(I, name); T(get_decl(f)))
        ctx = CC.get_ast_context(I)

        # VarDecl::needsDestruction — the ASTContext-taking query.
        @test CC.needsDestruction(D("dt_tail_plain", CC.VarDecl), ctx) == LX.CXDestructionKind_DK_none
        @test CC.needsDestruction(D("dt_tail_triv", CC.VarDecl), ctx) == LX.CXDestructionKind_DK_none
        @test CC.needsDestruction(D("dt_tail_nontriv", CC.VarDecl), ctx) != LX.CXDestructionKind_DK_none

        # NamedDecl::getLinkageAndVisibility — the LinkageInfo aggregate.
        plain = D("dt_tail_plain", CC.VarDecl)
        linkage, visibility, is_explicit = CC.getLinkageAndVisibility(plain)
        @test linkage == LX.CXLinkage_External
        @test visibility == LX.CXVisibility_DefaultVisibility
        @test is_explicit == false
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
        @test is_nothrow == false
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

        nd = CC.NamespaceDecl(look("NSpivot"))
        fd = CC.FunctionDecl(look("fpivot"))

        # Each Decl that is also a DeclContext crosses to its DeclContext subobject
        # and back; castFrom is the offset-exact inverse, so the pointer round-trips.

        # TranslationUnitDecl <-> DeclContext
        tu_dc = CC.DeclContext(tu)
        @test CC.TranslationUnitDecl(tu_dc).ptr == tu.ptr

        # NamespaceDecl <-> DeclContext
        nd_dc = CC.DeclContext(nd)
        @test CC.NamespaceDecl(nd_dc).ptr == nd.ptr

        # FunctionDecl <-> DeclContext
        fd_dc = CC.DeclContext(fd)
        @test CC.FunctionDecl(fd_dc).ptr == fd.ptr

        # ExternCContextDecl <-> DeclContext (the AST's singleton extern "C" context)
        ecd = CC.getExternCContextDecl(ctx)
        ecd_dc = CC.DeclContext(ecd)
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

        vd = CC.VarDecl(look("plain_global"))
        fd = CC.FunctionDecl(look("ddfunc"))

        # NamedDecl::isReserved -> ReservedIdentifierStatus; an ordinary global
        # name obeys no reserved-identifier rule.
        rs = CC.isReserved(vd, lo)
        @test rs == CC.LibClangEx.CXReservedIdentifierStatus_NotReserved

        # NamedDecl::getObjCFStringFormattingFamily -> SFF_None for a non-ObjC decl.
        ff = CC.getObjCFStringFormattingFamily(vd)
        @test ff == CC.LibClangEx.CXObjCStringFormatFamily_SFF_None

        # ParmVarDecl::getObjCDeclQualifier -> OBJC_TQ_None for an ordinary
        # C++ parameter (getter is total; setObjCDeclQualifier is not wrapped
        # because it asserts IsObjCMethodParam).
        pvd = CC.getParamDecl(fd, 0)
        q = CC.getObjCDeclQualifier(pvd)
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

        anchor = CC.VarDecl(look("hb_anchor"))
        loc = CC.getLocation(anchor)
        id = CC.getIdentifier(anchor)

        # ---------------- RecordDecl::field_empty ----------------
        empty_rd = CC.getDefinition(CC.RecordDecl(look("HBEmpty")))
        full_rd = CC.getDefinition(CC.RecordDecl(look("HBFull")))
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
        host = CC.FunctionDecl(look("hb_host"))
        be = find_node(CC.BlockExpr, CC.resolve(CC.getBody(host)))
        @test be isa CC.BlockExpr
        blk = CC.getBlockDecl(be)
        @test CC.getNumCaptures(blk) >= 1
        @test !(CC.isCaptureNonEscapingByref(blk, 0))
        # `addend` is captured by value, so it is neither an escaping nor a
        # non-escaping __block byref capture.
        @test CC.isCaptureByRef(blk, 0) || !CC.isCaptureNonEscapingByref(blk, 0)

        # ---------------- HLSLBufferDecl ----------------
        hb = CC.HLSLBufferDecl(ctx, dc, true, loc, id, loc, loc)
        @test CC.isCBuffer(hb)
        @test CC.getName(hb) == "hb_anchor"
        # KwLoc and LBraceLoc round-trip the locations passed to Create
        @test CC.getLocStart(hb).ptr == loc.ptr
        @test CC.getLBraceLoc(hb).ptr == loc.ptr
        # RBraceLoc is default-constructed by Create, so only a value set here is asserted
        @test CC.is_null_handle(CC.getRBraceLoc(hb))
        CC.setRBraceLoc(hb, loc)
        @test CC.getRBraceLoc(hb).ptr == loc.ptr
        @test !CC.is_null_handle(CC.getSourceRange(hb).begin_loc)

        tb = CC.HLSLBufferDecl(ctx, dc, false, loc, id, loc, loc)
        @test !CC.isCBuffer(tb)

        @test !CC.is_null_handle(CC.HLSLBufferDecl(ctx, 1))

        # Decl <-> DeclContext pivot: offset-correct in both directions
        hbdc = CC.DeclContext(hb)
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

        anchor = CC.VarDecl(look("dg_anchor"))
        loc = CC.getLocation(anchor)
        id = CC.getIdentifier(anchor)
        qt_int = CC.getType(anchor)
        tsi = CC.getTypeSourceInfo(anchor)
        ed = CC.EnumDecl(look("DGColor"))
        loc2 = CC.getLocation(ed)

        # ---------------- NamespaceDecl::Create ----------------
        ns = CC.NamespaceDecl(ctx, dc, true, loc2, loc, id)
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
        fresh = CC.EnumConstantDecl(ctx, ed, loc, id, CC.getType(ecs[1]), CC.Expr_(C_NULL), v_red)
        @test CC.getEnumConstantDeclValue(fresh) == CC.getEnumConstantDeclValue(ecs[1])
        CC.setInitVal(fresh, ctx, v_blue, false)
        @test CC.getEnumConstantDeclValue(fresh) == CC.getEnumConstantDeclValue(ecs[2])
        @test CC.getEnumConstantDeclValue(fresh) != CC.getEnumConstantDeclValue(ecs[1])
        CC.LLVM.API.LLVMDisposeGenericValue(v_red)
        CC.LLVM.API.LLVMDisposeGenericValue(v_blue)

        # ---------------- setTemplateParameterListsInfo ----------------
        ctd = CC.ClassTemplateDecl(look("DGTmpl"))
        tpl = CC.getTemplateParameters(ctd)
        @test size(tpl) >= 1

        # TagDecl arm, on a freshly created (detached) record
        rec = CC.RecordDecl(ctx, LXG.CXTagTypeKind_Struct, dc, loc, loc, id)
        @test CC.getNumTemplateParameterLists(rec) == 0
        CC.setTemplateParameterListsInfo(rec, ctx, [tpl])
        @test CC.getNumTemplateParameterLists(rec) == 1
        @test CC.getTemplateParameterList(rec, 0).ptr == tpl.ptr
        @test_throws AssertionError CC.getTemplateParameterList(rec, 1)  # the restated clang assert (Invariant 3)
        @test_throws AssertionError CC.setTemplateParameterListsInfo(rec, ctx, CC.TemplateParameterList[])

        # DeclaratorDecl arm, on a freshly created (detached) variable
        vd = CC.VarDecl(ctx, dc, loc, loc, id, qt_int, tsi, LXG.CXStorageClass_SC_None)
        @test CC.getNumTemplateParameterLists(vd) == 0
        CC.setTemplateParameterListsInfo(vd, ctx, [tpl])
        @test CC.getNumTemplateParameterLists(vd) == 1
        @test CC.getTemplateParameterList(vd, 0).ptr == tpl.ptr
        @test_throws AssertionError CC.setTemplateParameterListsInfo(vd, ctx, CC.TemplateParameterList[])

        # ---------------- ParmVarDecl::setObjCDeclQualifier ----------------
        parm = CC.ParmVarDecl(ctx, dc, loc, loc, id, qt_int, tsi, LXG.CXStorageClass_SC_None)
        # the qualifier shares a bitfield with the scope depth, so the wrapper refuses a
        # plain C/C++ parameter until setObjCMethodScopeInfo marks it as an ObjC one
        @test !CC.isObjCMethodParameter(parm)
        @test_throws AssertionError CC.setObjCDeclQualifier(parm, LXG.CXObjCDeclQualifier_OBJC_TQ_Byref)
        CC.setObjCMethodScopeInfo(parm, 0)
        @test CC.isObjCMethodParameter(parm)
        CC.setObjCDeclQualifier(parm, LXG.CXObjCDeclQualifier_OBJC_TQ_Byref)
        @test CC.getObjCDeclQualifier(parm) == LXG.CXObjCDeclQualifier_OBJC_TQ_Byref
        CC.setObjCDeclQualifier(parm, LXG.CXObjCDeclQualifier_OBJC_TQ_Oneway)
        @test CC.getObjCDeclQualifier(parm) == LXG.CXObjCDeclQualifier_OBJC_TQ_Oneway

        # ---------------- FunctionDecl::DefaultedFunctionInfo ----------------
        fn = CC.FunctionDecl(look("dg_fn"))
        info0 = CC.getDefaultedFunctionInfo(fn)
        # an ordinary function stores a body, so the union holds no defaulted info
        @test info0.ptr == C_NULL

        nd_a = CC.NamedDecl(anchor)
        nd_b = CC.NamedDecl(ed)
        info = CC.DefaultedFunctionInfo(ctx, [nd_a, nd_b],
                                        [LXG.CXAccessSpecifier_AS_public, LXG.CXAccessSpecifier_AS_private])
        @test info.ptr != C_NULL
        @test CC.getNumUnqualifiedLookups(info) == 2
        # decls and accesses are read in lockstep at the same index
        @test CC.getUnqualifiedLookupDecl(info, 0).ptr == nd_a.ptr
        @test CC.getUnqualifiedLookupDecl(info, 1).ptr == nd_b.ptr
        @test CC.getUnqualifiedLookupAccess(info, 0) == LXG.CXAccessSpecifier_AS_public
        @test CC.getUnqualifiedLookupAccess(info, 1) == LXG.CXAccessSpecifier_AS_private
        @test_throws AssertionError CC.getUnqualifiedLookupDecl(info, 2)
        @test_throws AssertionError CC.getUnqualifiedLookupAccess(info, 2)
        @test_throws AssertionError CC.DefaultedFunctionInfo(ctx, [nd_a], CC.CXAccessSpecifier[])

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
        plain_fd = CC.FunctionDecl(look("plaindh"))
        @test CC.getKind(plain_fd) == K.CXDeclKind_Function
        @test CC.classofKind(CC.FunctionDecl, CC.getKind(plain_fd))
        @test CC.classofKind(CC.DeclaratorDecl, CC.getKind(plain_fd))
        @test !CC.classofKind(CC.TagDecl, CC.getKind(plain_fd))
        @test CC.getKind(tu) == K.CXDeclKind_TranslationUnit
        @test !CC.classofKind(CC.NamedDecl, CC.getKind(tu))

        # ---------------- getQualifierRange ----------------
        # `void NDH::fdh() {}` redeclares the in-namespace `fdh`, and only the
        # out-of-line redeclaration carries the written `NDH::`.
        fd = CC.FunctionDecl(CC.getMostRecentDecl(CC.NamedDecl(look("NDH::fdh"))))
        @test CC.getQualifier(fd).ptr != C_NULL
        qr = CC.getQualifierRange(fd)
        @test !CC.is_null_handle(qr.begin_loc)

        # unqualified declarator: no specifier was written, so the extent is invalid
        @test CC.getQualifier(plain_fd).ptr == C_NULL
        @test CC.getQualifierRange(plain_fd).begin_loc.ptr == C_NULL

        rd = CC.getMostRecentDecl(CC.RecordDecl(look("NDH::SDH")))
        tag_qr = CC.getQualifierRange(rd)
        @test !CC.is_null_handle(tag_qr.begin_loc)
        # qualifier and extent agree on whether a specifier was written
        @test (CC.getQualifier(rd).ptr == C_NULL) == (tag_qr.begin_loc.ptr == C_NULL)

        plain_rd = CC.RecordDecl(look("PlainDH"))
        @test CC.getQualifier(plain_rd).ptr == C_NULL
        @test CC.getQualifierRange(plain_rd).begin_loc.ptr == C_NULL

        # ---------------- TagDecl <-> DeclContext pivot ----------------
        rd_dc = CC.DeclContext(plain_rd)
        @test CC.TagDecl(rd_dc).ptr == plain_rd.ptr
        # `TagDecl(::DeclContext)` crosses the two hierarchies rather than narrowing within
        # one, so unlike the Decl-rooted casts it reports a miss as the NULL carrier: there is
        # no `CastError` to raise about a context that is simply not also a tag declaration.
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

        fdi = CC.FunctionDecl(look("fdi"))
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
        first_vd = CC.VarDecl(look("bpc_first"))
        second_vd = CC.VarDecl(look("bpc_second"))
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
        CC.setCaptures(bd, ctx, [first_vd, second_vd], [false, true], [true, false], [nothing, nothing], false)
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

@testset "Decl | setObjectOfFriendDecl moves the identifier namespace" begin
    # Built on standalone FunctionDecls that are never added to the DeclContext, because the
    # change is irreversible -- clang exposes no setIdentifierNamespace -- and must not touch
    # a declaration the live interpreter's lookup depends on.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    CC.parse(I, "void friend_seed(int p) {}")
    f = DeclFinder(I)
    @test f(I, "friend_seed")
    seed = CC.FunctionDecl(get_decl(f))
    name = CC.getDeclName(seed)
    fty = CC.getType(seed)
    loc = CC.getLocation(seed)
    tsi = CC.getTrivialTypeSourceInfo(ctx, fty, loc)
    mk() = CC.FunctionDecl(ctx, dc, loc, loc, name, fty, tsi, LX.CXStorageClass_SC_None, false, true)

    ordinary = UInt32(CC.CXDecl_IDNS_Ordinary)
    ofriend = UInt32(CC.CXDecl_IDNS_OrdinaryFriend)

    fd0 = mk()
    @test (UInt32(CC.getIdentifierNamespace(fd0)) & ordinary) != 0
    @test CC.getFriendObjectKind(fd0) == CC.CXDecl_FOK_None

    # without injection the decl leaves the ordinary namespace for the friend one
    fd1 = mk()
    CC.setObjectOfFriendDecl(fd1)
    ns1 = UInt32(CC.getIdentifierNamespace(fd1))
    @test (ns1 & ofriend) != 0
    @test (ns1 & ordinary) == 0
    @test CC.getFriendObjectKind(fd1) == CC.CXDecl_FOK_Undeclared

    # with injection it keeps the ordinary bits too, and clang reports it as declared --
    # so the argument changes the observed result, not just the path taken
    fd2 = mk()
    CC.setObjectOfFriendDecl(fd2; perform_friend_injection=true)
    ns2 = UInt32(CC.getIdentifierNamespace(fd2))
    @test (ns2 & ofriend) != 0
    @test (ns2 & ordinary) != 0
    @test CC.getFriendObjectKind(fd2) == CC.CXDecl_FOK_Declared
    @test ns1 != ns2

    dispose(f)
    dispose(I)
end
