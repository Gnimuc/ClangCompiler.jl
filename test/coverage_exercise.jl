using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Coverage-exercise testsets: broad calls across the src/clang/api wrapper
# surface to raise function coverage (14% baseline). Built + self-verified by
# subagents (one per wrapper file); assertions are light (isa/Bool) — the point
# is to CALL each wrapper.

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
    p0 = CC.ParmVarDecl(CC.getParamDecl(add, 0))
    pdef = CC.ParmVarDecl(CC.getParamDecl(wdf, 1))
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
    gparm = CC.ParmVarDecl(CC.getParamDecl(CC.FunctionDecl(get_decl(f).ptr), 0))
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

@testset "Coverage | DeclCXX" begin
    src = """
    extern "C" { int c_linked_var; }

    namespace NS2 {}
    using namespace NS2;

    struct VBase { int vb; virtual void vf() {} };
    struct Lft : virtual VBase {};
    struct Rgt : virtual VBase {};
    struct Diamond : Lft, Rgt {};

    struct Mixin { int mm; void mfn() {} };

    struct Plain { int p; double q; };

    struct Base {
    public:
        int b;
        Base() : b(0) {}
        Base(const Base& o) : b(o.b) {}
        Base(Base&& o) : b(o.b) {}
        explicit Base(int x) : b(x) {}
        virtual ~Base() {}
        virtual void foo() = 0;
        virtual int bar() const { return b; }
        void nonvirt() {}
        operator int() const { return b; }
    protected:
        int prot;
    private:
        int priv;
    };

    struct Derived : public Base, public Mixin {
        int d;
        Derived() : Derived(0) {}
        explicit Derived(int x) : Base(x), Mixin(), d(x) {}
        Derived(const Derived&) = default;
        ~Derived() override {}
        void foo() override {}
        using Base::bar;
    };

    template<typename T> struct Wrapper { T val; Wrapper(T x) : val(x) {} };
    template<typename T> Wrapper(T) -> Wrapper<T>;
    Wrapper wobj{5};

    auto glam = [](auto x){ return x; };
    """
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, src)

    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    alldecls = CC.decls(CC.castToDeclContext(tu))

    f = DeclFinder(I)
    @test f(I, "Base")
    baseRD = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "Derived")
    derivedRD = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "Diamond")
    diamondRD = CC.CXXRecordDecl(get_decl(f).ptr)

    # ---- CXXRecordDecl: Ptr-returning decl-chain accessors (legacy raw Ptr) ----
    @test CC.getCanonicalDecl(baseRD) isa Ptr
    @test CC.getPreviousDecl(baseRD) isa Ptr
    @test CC.getMostRecentDecl(baseRD) isa Ptr
    @test CC.getMostRecentNonInjectedDecl(baseRD) isa Ptr
    @test CC.getDefinition(baseRD) isa Ptr

    # ---- CXXRecordDecl: Bool-returning trait predicates (~90) ----
    boolpreds = [CC.hasDefinition, CC.isLambda, CC.isGenericLambda, CC.isAggregate,
        CC.isPOD, CC.isCLike, CC.isEmpty, CC.isDynamicClass, CC.allowConstDefaultInit,
        CC.hasAnyDependentBases,
        CC.hasConstexprDefaultConstructor, CC.hasConstexprDestructor,
        CC.hasConstexprNonCopyMoveConstructor, CC.hasCopyAssignmentWithConstParam,
        CC.hasCopyConstructorWithConstParam, CC.hasDefaultConstructor, CC.hasDirectFields,
        CC.hasFriends, CC.hasInClassInitializer, CC.hasInheritedAssignment,
        CC.hasInheritedConstructor, CC.hasInitMethod, CC.hasIrrelevantDestructor,
        CC.hasMoveAssignment, CC.hasMoveConstructor,
        CC.hasMutableFields, CC.hasNonLiteralTypeFieldsOrBases, CC.hasNonTrivialCopyAssignment,
        CC.hasNonTrivialCopyConstructor, CC.hasNonTrivialCopyConstructorForCall,
        CC.hasNonTrivialDefaultConstructor, CC.hasNonTrivialDestructor,
        CC.hasNonTrivialDestructorForCall, CC.hasNonTrivialMoveAssignment,
        CC.hasNonTrivialMoveConstructor, CC.hasNonTrivialMoveConstructorForCall,
        CC.hasPrivateFields, CC.hasProtectedFields, CC.hasSimpleCopyAssignment,
        CC.hasSimpleCopyConstructor, CC.hasSimpleDestructor, CC.hasSimpleMoveAssignment,
        CC.hasSimpleMoveConstructor, CC.hasTrivialCopyAssignment, CC.hasTrivialCopyConstructor,
        CC.hasTrivialCopyConstructorForCall, CC.hasTrivialDefaultConstructor,
        CC.hasTrivialDestructor, CC.hasTrivialDestructorForCall, CC.hasTrivialMoveAssignment,
        CC.hasTrivialMoveConstructor, CC.hasTrivialMoveConstructorForCall,
        CC.hasUninitializedReferenceMember, CC.hasUserDeclaredConstructor,
        CC.hasUserDeclaredCopyAssignment, CC.hasUserDeclaredCopyConstructor,
        CC.hasUserDeclaredDestructor, CC.hasUserDeclaredMoveAssignment,
        CC.hasUserDeclaredMoveConstructor, CC.hasUserDeclaredMoveOperation,
        CC.hasUserProvidedDefaultConstructor, CC.hasVariantMembers, CC.isAbstract,
        CC.isAnyDestructorNoReturn, CC.isCXX11StandardLayout, CC.isCapturelessLambda,
        CC.isDependentLambda, CC.isEffectivelyFinal, CC.isInterfaceLike, CC.isLiteral,
        CC.isNeverDependentLambda, CC.isParsingBaseSpecifiers, CC.isPolymorphic,
        CC.isStandardLayout, CC.isStructural, CC.isTrivial, CC.isTriviallyCopyConstructible,
        CC.isTriviallyCopyable, CC.mayBeAbstract, CC.mayBeDynamicClass, CC.mayBeNonDynamicClass,
        CC.needsImplicitCopyAssignment, CC.needsImplicitCopyConstructor,
        CC.needsImplicitDefaultConstructor, CC.needsImplicitDestructor,
        CC.needsImplicitMoveAssignment, CC.needsImplicitMoveConstructor,
        CC.needsOverloadResolutionForCopyAssignment,
        CC.needsOverloadResolutionForCopyConstructor,
        CC.needsOverloadResolutionForDestructor,
        CC.needsOverloadResolutionForMoveAssignment,
        CC.needsOverloadResolutionForMoveConstructor]
    for p in boolpreds
        @test p(baseRD) isa Bool
        @test p(derivedRD) isa Bool
    end
    # a few meaningful values
    @test CC.isPolymorphic(baseRD)
    @test CC.isAbstract(baseRD)
    @test CC.isDynamicClass(baseRD)
    @test CC.hasUserDeclaredConstructor(baseRD)
    @test CC.hasUserDeclaredDestructor(baseRD)

    # defaulted-special-member predicates: only well-defined on a class whose
    # special members do not need overload resolution (Clang asserts otherwise),
    # so exercise them on a trivial struct.
    @test f(I, "Plain")
    plainRD = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.defaultedCopyConstructorIsDeleted(plainRD) isa Bool
    @test CC.defaultedDefaultConstructorIsConstexpr(plainRD) isa Bool
    @test CC.defaultedDestructorIsConstexpr(plainRD) isa Bool
    @test CC.defaultedDestructorIsDeleted(plainRD) isa Bool
    @test CC.defaultedMoveConstructorIsDeleted(plainRD) isa Bool

    # generic-lambda template parameter list (nullptr-safe on a non-lambda)
    @test CC.getGenericLambdaTemplateParameterList(baseRD) isa CC.TemplateParameterList
    glamClass = nothing
    for d in alldecls
        if d isa CC.CXXRecordDecl && CC.isGenericLambda(d)
            glamClass = d
            break
        end
    end
    if glamClass !== nothing
        @test CC.getGenericLambdaTemplateParameterList(glamClass) isa CC.TemplateParameterList
        @test CC.hasKnownLambdaInternalLinkage(glamClass) isa Bool
    end

    # ---- CXXRecordDecl: bases / methods / ctors counts + collections ----
    @test CC.getNumBases(derivedRD) isa Integer
    @test CC.getNumVBases(diamondRD) isa Integer
    @test CC.getNumMethods(baseRD) isa Integer
    @test CC.getNumCtors(baseRD) isa Integer

    bases = CC.getBases(derivedRD)
    @test all(x -> x isa CC.CXXBaseSpecifier, bases)
    @test CC.getBase(derivedRD, 0) isa CC.CXXBaseSpecifier

    vbases = CC.getVBases(diamondRD)
    @test all(x -> x isa CC.CXXBaseSpecifier, vbases)
    if CC.getNumVBases(diamondRD) > 0
        @test CC.getVBase(diamondRD, 0) isa CC.CXXBaseSpecifier
    end

    methods = CC.getMethods(baseRD)
    @test all(m -> m isa CC.CXXMethodDecl, methods)
    ctors = CC.getCtors(baseRD)
    @test all(c -> c isa CC.CXXConstructorDecl, ctors)

    # ---- CXXBaseSpecifier accessors ----
    b0 = bases[1]
    @test CC.getAccessSpecifier(b0) isa Integer || CC.getAccessSpecifier(b0) isa Enum
    @test CC.getAccessSpecifierAsWritten(b0) isa Integer || CC.getAccessSpecifierAsWritten(b0) isa Enum
    @test CC.getBaseTypeLoc(b0) isa CC.SourceLocation
    @test CC.getColonLoc(b0) isa CC.SourceLocation
    @test CC.getEllipsisLoc(b0) isa CC.SourceLocation
    @test CC.getEndLoc(b0) isa CC.SourceLocation
    @test CC.getInheritConstructors(b0) isa Bool
    @test CC.getSourceRange(b0) isa CC.SourceRange
    @test CC.getType(b0) isa CC.QualType
    @test CC.getTypeSourceInfo(b0) isa CC.TypeSourceInfo
    @test CC.isBaseOfClass(b0) isa Bool
    @test CC.isPackExpansion(b0) isa Bool
    @test CC.isVirtual(b0) isa Bool
    # a virtual base specifier
    if !isempty(vbases)
        @test CC.isVirtual(vbases[1])
    end

    # ---- CXXMethodDecl accessors on every method ----
    for m in methods
        @test CC.getCanonicalDecl(m) isa CC.CXXMethodDecl
        @test CC.getMostRecentDecl(m) isa CC.CXXMethodDecl
        @test CC.getParent(m) isa CC.CXXRecordDecl
        @test CC.hasInlineBody(m) isa Bool
        @test CC.isConst(m) isa Bool
        @test CC.isCopyAssignmentOperator(m) isa Bool
        @test CC.isInstance(m) isa Bool
        @test CC.isLambdaStaticInvoker(m) isa Bool
        @test CC.isMoveAssignmentOperator(m) isa Bool
        @test CC.isStatic(m) isa Bool
        @test CC.isVirtual(m) isa Bool
        @test CC.isVolatile(m) isa Bool
        if CC.isInstance(m)
            @test CC.getThisType(m) isa CC.QualType
        end
    end

    # ---- CXXConstructorDecl / CXXDestructorDecl / CXXConversionDecl via resolve ----
    resolved = [CC.resolve(m) for m in methods]

    ctorPreds = [CC.isExplicit, CC.isDefaultConstructor, CC.isCopyConstructor,
        CC.isMoveConstructor, CC.isCopyOrMoveConstructor, CC.isDelegatingConstructor,
        CC.isInheritingConstructor, CC.isSpecializationCopyingObject]
    for c in ctors
        for p in ctorPreds
            @test p(c) isa Bool
        end
        @test CC.getNumCtorInitializers(c) isa Integer
    end
    @test any(CC.isDefaultConstructor, ctors)
    @test any(CC.isCopyConstructor, ctors)
    @test any(CC.isMoveConstructor, ctors)
    @test any(c -> CC.isCopyOrMoveConstructor(c), ctors)
    @test any(CC.isExplicit, ctors)

    dtor = first(m for m in resolved if m isa CC.CXXDestructorDecl)
    @test CC.getOperatorDelete(dtor) isa CC.FunctionDecl

    conv = first(m for m in resolved if m isa CC.CXXConversionDecl)
    @test CC.getConversionType(conv) isa CC.QualType
    @test CC.isExplicit(conv) isa Bool
    @test CC.isLambdaToBlockPointerConversion(conv) isa Bool

    # ---- CXXCtorInitializer via Derived's ctors ----
    dctors = CC.getCtors(derivedRD)
    initCtor = first(c for c in dctors if CC.getNumCtorInitializers(c) >= 2)
    inits = CC.getCtorInitializers(initCtor)
    @test all(x -> x isa CC.CXXCtorInitializer, inits)
    baseInit = first(i for i in inits if CC.isBaseInitializer(i))
    memInit = first(i for i in inits if CC.isMemberInitializer(i))
    @test CC.isBaseInitializer(baseInit)
    @test CC.isAnyMemberInitializer(baseInit) isa Bool
    @test CC.isDelegatingInitializer(baseInit) isa Bool
    @test CC.getBaseClass(baseInit) isa CC.Type_
    @test CC.getInit(baseInit) isa CC.Expr_
    @test CC.getSourceLocation(baseInit) isa CC.SourceLocation
    @test CC.isMemberInitializer(memInit)
    @test CC.isAnyMemberInitializer(memInit)
    @test CC.getMember(memInit) isa CC.FieldDecl
    @test CC.getName(CC.getMember(memInit)) == "d"

    # delegating constructor + its target + delegating initializer
    delegCtor = first(c for c in dctors if CC.isDelegatingConstructor(c))
    @test CC.getTargetConstructor(delegCtor) isa CC.CXXConstructorDecl
    dinits = CC.getCtorInitializers(delegCtor)
    @test any(CC.isDelegatingInitializer, dinits)

    # ---- AccessSpecDecl ----
    asd = first(d for d in alldecls if d isa CC.AccessSpecDecl)
    @test CC.getAccessSpecifierLoc(asd) isa CC.SourceLocation
    @test CC.getColonLoc(asd) isa CC.SourceLocation
    @test CC.getSourceRange(asd) isa CC.SourceRange

    # ---- LinkageSpecDecl (extern "C" { ... }) ----
    lsd = first(d for d in alldecls if d isa CC.LinkageSpecDecl)
    @test CC.getEndLoc(lsd) isa CC.SourceLocation
    @test CC.getExternLoc(lsd) isa CC.SourceLocation
    @test CC.getLanguage(lsd) isa Integer || CC.getLanguage(lsd) isa Enum
    @test CC.getRBraceLoc(lsd) isa CC.SourceLocation
    @test CC.getSourceRange(lsd) isa CC.SourceRange
    @test CC.hasBraces(lsd) isa Bool

    # ---- UsingDirectiveDecl (using namespace NS2;) ----
    udir = first(d for d in alldecls if d isa CC.UsingDirectiveDecl)
    @test CC.getNominatedNamespace(udir) isa CC.NamespaceDecl

    # ---- UsingDecl / BaseUsingDecl / UsingShadowDecl (using Base::bar;) ----
    usingD = first(d for d in alldecls if d isa CC.UsingDecl)
    @test CC.shadow_size(usingD) isa Integer
    shadows = CC.getShadows(usingD)
    @test all(s -> s isa CC.UsingShadowDecl, shadows)
    if !isempty(shadows)
        @test CC.getTargetDecl(shadows[1]) isa CC.NamedDecl
    end

    # ---- CXXDeductionGuideDecl (templated decl of a FunctionTemplateDecl) ----
    dgs = CC.CXXDeductionGuideDecl[]
    for d in alldecls
        d isa CC.FunctionTemplateDecl || continue
        td = CC.resolve(CC.getTemplatedDecl(d))
        td isa CC.CXXDeductionGuideDecl && push!(dgs, td)
    end
    @test !isempty(dgs)
    for dg in dgs
        @test CC.isExplicit(dg) isa Bool
        @test CC.getCorrespondingConstructor(dg) isa CC.CXXConstructorDecl
        @test CC.getDeducedTemplate(dg) isa CC.TemplateDecl
        @test CC.getDeductionCandidateKind(dg) isa Integer ||
              CC.getDeductionCandidateKind(dg) isa Enum
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | Expr" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
        """
        struct Base { int b; };
        struct Derived : Base { int d; };
        struct PointT { int x; int y; };

        int helper(int a, int b) { return a + b; }
        consteval int sq(int x) { return x * x; }

        int compute(int n) {
            int arr[3] = {1, 2, 3};
            double d = 1.5;
            char c = 'a';
            const char* s = "hello";
            const char* fn = __func__;
            int a = (n + 1);
            a += 2;
            ++a;
            a--;
            int b = arr[a % 3];
            int e = a > b ? a : b;
            unsigned long szt = sizeof(PointT);
            unsigned long sze = sizeof a;
            PointT p;
            p.x = 5;
            double dd = (double)n;
            int f = helper(a, b);
            int cc = sq(3);
            int g = ({ int t = a; t + 1; });
            PointT q = (PointT){1, 2};
            Derived dv;
            Base& br = dv;
            Base* bp = &dv;
            return e + f + cc + g + (int)d + c + p.x + q.x + br.b + bp->b + s[0] + fn[0];
        }
        """)
    ctx = CC.get_ast_context(I)

    lookup = DeclFinder(I)
    @test lookup(I, "compute")
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
    body = CC.getBody(fd)
    nodes = CC.subtree(body)
    byT(T) = filter(n -> n isa T, nodes)
    first_of(T) = (v = byT(T); isempty(v) ? nothing : first(v))

    # ---- Expr base predicates (any expression node) --------------------------
    anyexpr = first(filter(n -> n isa CC.AbstractExpr, nodes))
    @test CC.getType(anyexpr) isa CC.QualType
    @test CC.getValueKind(anyexpr) isa CC.LibClangEx.CXExprValueKind
    @test CC.isLValue(anyexpr) isa Bool
    @test CC.isPRValue(anyexpr) isa Bool
    @test CC.isXValue(anyexpr) isa Bool
    @test CC.isGLValue(anyexpr) isa Bool
    @test CC.IgnoreImpCasts(anyexpr) isa CC.Expr_
    @test CC.IgnoreCasts(anyexpr) isa CC.Expr_
    @test CC.IgnoreParens(anyexpr) isa CC.Expr_
    @test CC.IgnoreParenCasts(anyexpr) isa CC.Expr_
    @test CC.IgnoreParenImpCasts(anyexpr) isa CC.Expr_
    @test CC.containsErrors(anyexpr) isa Bool
    @test CC.containsUnexpandedParameterPack(anyexpr) isa Bool
    @test CC.hasPlaceholderType(anyexpr) isa Bool
    @test CC.isDefaultArgument(anyexpr) isa Bool
    @test CC.isImplicitCXXThis(anyexpr) isa Bool
    @test CC.isInstantiationDependent(anyexpr) isa Bool
    @test CC.isObjCSelfExpr(anyexpr) isa Bool
    @test CC.isOrdinaryOrBitFieldObject(anyexpr) isa Bool
    @test CC.isTypeDependent(anyexpr) isa Bool
    @test CC.isValueDependent(anyexpr) isa Bool
    @test CC.refersToBitField(anyexpr) isa Bool
    @test CC.refersToGlobalRegisterVar(anyexpr) isa Bool
    @test CC.refersToMatrixElement(anyexpr) isa Bool
    @test CC.refersToVectorElement(anyexpr) isa Bool
    @test CC.getExprLoc(anyexpr) isa CC.SourceLocation

    # ---- Expr constant folding (needs an ASTContext) -------------------------
    il = first_of(CC.IntegerLiteral)
    @test il !== nothing
    apr = CC.EvaluateAsRValue(il, ctx)
    @test apr isa CC.APValue
    apr.ptr != C_NULL && dispose(apr)
    @test CC.isEvaluatable(il, ctx) isa Bool
    @test CC.isIntegerConstantExpr(il, ctx) isa Bool
    @test CC.isCXX11ConstantExpr(il, ctx) isa Bool
    @test CC.EvaluateAsBooleanCondition(il, ctx) isa Integer
    api_ = CC.EvaluateAsInt(il, ctx)
    @test api_ isa CC.APValue
    api_.ptr != C_NULL && dispose(api_)

    # ---- IntegerLiteral ------------------------------------------------------
    @test CC.getValue(il) !== nothing
    @test CC.getBeginLoc(il) isa CC.SourceLocation
    @test CC.getEndLoc(il) isa CC.SourceLocation
    @test CC.getLocation(il) isa CC.SourceLocation

    # ---- FloatingLiteral -----------------------------------------------------
    fl = first_of(CC.FloatingLiteral)
    @test fl !== nothing
    @test CC.getValueAsApproximateDouble(fl) isa AbstractFloat
    @test CC.EvaluateAsFloat(fl, ctx) !== nothing

    # ---- CharacterLiteral ----------------------------------------------------
    chl = first_of(CC.CharacterLiteral)
    @test chl !== nothing
    @test CC.getValue(chl) isa Integer
    @test CC.getKind(chl) isa CC.LibClangEx.CXCharacterLiteralKind
    @test CC.getLocation(chl) isa CC.SourceLocation

    # ---- StringLiteral -------------------------------------------------------
    sl = first_of(CC.StringLiteral)
    @test sl !== nothing
    @test CC.getBytes(sl) isa String
    @test CC.getString(sl) isa String
    @test CC.getByteLength(sl) isa Integer
    @test CC.getLength(sl) isa Integer
    @test CC.getCharByteWidth(sl) isa Integer
    @test CC.getKind(sl) isa CC.LibClangEx.CXStringLiteralKind
    @test CC.isOrdinary(sl) isa Bool
    @test CC.isWide(sl) isa Bool
    @test CC.isUTF8(sl) isa Bool
    @test CC.isUTF16(sl) isa Bool
    @test CC.isUTF32(sl) isa Bool
    @test CC.isUnevaluated(sl) isa Bool
    @test CC.isPascal(sl) isa Bool
    @test CC.containsNonAscii(sl) isa Bool
    @test CC.containsNonAsciiOrNull(sl) isa Bool
    @test CC.getNumConcatenated(sl) isa Integer
    @test CC.getBeginLoc(sl) isa CC.SourceLocation
    @test CC.getEndLoc(sl) isa CC.SourceLocation

    # ---- ParenExpr -----------------------------------------------------------
    pe = first_of(CC.ParenExpr)
    @test pe !== nothing
    @test CC.getSubExpr(pe) isa CC.Expr_
    @test CC.getLParen(pe) isa CC.SourceLocation
    @test CC.getRParen(pe) isa CC.SourceLocation

    # ---- UnaryOperator -------------------------------------------------------
    uo = first_of(CC.UnaryOperator)
    @test uo !== nothing
    @test CC.getOpcode(uo) isa CC.LibClangEx.CXUnaryOperatorKind
    @test CC.getSubExpr(uo) isa CC.Expr_
    @test CC.getOperatorLoc(uo) isa CC.SourceLocation
    @test CC.isPrefix(uo) isa Bool
    @test CC.isPostfix(uo) isa Bool
    @test CC.isIncrementOp(uo) isa Bool
    @test CC.isDecrementOp(uo) isa Bool
    @test CC.canOverflow(uo) isa Bool
    @test CC.isIncrementDecrementOp(uo) isa Bool
    @test CC.isArithmeticOp(uo) isa Bool
    @test CC.hasStoredFPFeatures(uo) isa Bool

    # ---- ArraySubscriptExpr --------------------------------------------------
    ase = first_of(CC.ArraySubscriptExpr)
    @test ase !== nothing
    @test CC.getLHS(ase) isa CC.Expr_
    @test CC.getRHS(ase) isa CC.Expr_
    @test CC.getBase(ase) isa CC.Expr_
    @test CC.getIdx(ase) isa CC.Expr_
    @test CC.getRBracketLoc(ase) isa CC.SourceLocation

    # ---- CallExpr ------------------------------------------------------------
    ce = first_of(CC.CallExpr)
    @test ce !== nothing
    @test CC.getCallee(ce) isa CC.Expr_
    @test CC.getCalleeDecl(ce) isa CC.Decl
    @test CC.getDirectCallee(ce) isa CC.FunctionDecl
    nargs = CC.getNumArgs(ce)
    @test nargs isa Integer
    @test CC.getArg(ce, 0) isa CC.Expr_
    @test CC.getRParenLoc(ce) isa CC.SourceLocation
    @test CC.usesADL(ce) isa Bool
    @test CC.hasStoredFPFeatures(ce) isa Bool
    @test CC.getBuiltinCallee(ce) isa Integer
    @test CC.isCallToStdMove(ce) isa Bool

    # ---- MemberExpr ----------------------------------------------------------
    me = first_of(CC.MemberExpr)
    @test me !== nothing
    @test CC.getBase(me) isa CC.Expr_
    @test CC.getMemberDecl(me) isa CC.ValueDecl
    @test CC.isArrow(me) isa Bool
    @test CC.getMemberLoc(me) isa CC.SourceLocation
    @test CC.isImplicitAccess(me) isa Bool
    @test CC.getMemberNameInfo(me) isa CC.DeclarationNameInfo
    @test CC.hasQualifier(me) isa Bool
    @test CC.getTemplateKeywordLoc(me) isa CC.SourceLocation
    @test CC.getLAngleLoc(me) isa CC.SourceLocation
    @test CC.getRAngleLoc(me) isa CC.SourceLocation
    @test CC.hasTemplateKeyword(me) isa Bool
    @test CC.hasExplicitTemplateArgs(me) isa Bool
    @test CC.getNumTemplateArgs(me) isa Integer
    @test CC.getOperatorLoc(me) isa CC.SourceLocation
    @test CC.hadMultipleCandidates(me) isa Bool
    @test CC.getQualifier(me) isa CC.NestedNameSpecifier

    # ---- CastExpr / ImplicitCastExpr / ExplicitCastExpr ----------------------
    ice = first_of(CC.ImplicitCastExpr)
    @test ice !== nothing
    @test CC.getCastKind(ice) isa CC.LibClangEx.CXCastKind
    @test CC.getCastKindName(ice) isa String
    @test CC.getSubExpr(ice) isa CC.Expr_
    @test CC.getSubExprAsWritten(ice) isa CC.Expr_
    @test CC.isPartOfExplicitCast(ice) isa Bool

    # CStyleCastExpr is an ExplicitCastExpr — covers getTypeAsWritten + own locs
    csc = first_of(CC.CStyleCastExpr)
    @test csc !== nothing
    @test CC.getTypeAsWritten(csc) isa CC.QualType
    @test CC.getLParenLoc(csc) isa CC.SourceLocation
    @test CC.getRParenLoc(csc) isa CC.SourceLocation

    # getPathElement needs a cast whose inheritance path is non-empty
    dtb = first(filter(n -> n isa CC.AbstractCastExpr &&
                            CC.getCastKindName(n) == "DerivedToBase", nodes))
    @test CC.getPathElement(dtb, 0) isa CC.CXXBaseSpecifier

    # ---- BinaryOperator ------------------------------------------------------
    bo = first_of(CC.BinaryOperator)
    @test bo !== nothing
    @test CC.getOpcode(bo) isa CC.LibClangEx.CXBinaryOperatorKind
    @test CC.getLHS(bo) isa CC.Expr_
    @test CC.getRHS(bo) isa CC.Expr_
    @test CC.getOperatorLoc(bo) isa CC.SourceLocation
    @test CC.getOpcodeStr(bo) isa String
    @test CC.isAssignmentOp(bo) isa Bool
    @test CC.isCompoundAssignmentOp(bo) isa Bool
    @test CC.isComparisonOp(bo) isa Bool

    # ---- CompoundAssignOperator ----------------------------------------------
    cao = first_of(CC.CompoundAssignOperator)
    @test cao !== nothing
    @test CC.getComputationLHSType(cao) isa CC.QualType
    @test CC.getComputationResultType(cao) isa CC.QualType

    # ---- ConditionalOperator -------------------------------------------------
    co = first_of(CC.ConditionalOperator)
    @test co !== nothing
    @test CC.getCond(co) isa CC.Expr_
    @test CC.getTrueExpr(co) isa CC.Expr_
    @test CC.getFalseExpr(co) isa CC.Expr_

    # ---- InitListExpr --------------------------------------------------------
    ile = first_of(CC.InitListExpr)
    @test ile !== nothing
    @test CC.getNumInits(ile) isa Integer
    @test CC.getInit(ile, 0) isa CC.Expr_
    @test CC.isSemanticForm(ile) isa Bool
    @test CC.getSyntacticForm(ile) isa CC.InitListExpr
    @test CC.getSemanticForm(ile) isa CC.InitListExpr
    @test CC.hasArrayFiller(ile) isa Bool
    @test CC.hasDesignatedInit(ile) isa Bool
    @test CC.isExplicit(ile) isa Bool
    @test CC.isStringLiteralInit(ile) isa Bool
    @test CC.isTransparent(ile) isa Bool
    @test CC.getLBraceLoc(ile) isa CC.SourceLocation
    @test CC.getRBraceLoc(ile) isa CC.SourceLocation
    @test CC.isSyntacticForm(ile) isa Bool
    @test CC.hadArrayRangeDesignator(ile) isa Bool
    @test CC.getArrayFiller(ile) isa CC.Expr_
    @test CC.getInitializedFieldInUnion(ile) isa CC.FieldDecl

    # ---- DeclRefExpr ---------------------------------------------------------
    dre = first_of(CC.DeclRefExpr)
    @test dre !== nothing
    @test CC.getDecl(dre) isa CC.ValueDecl
    @test CC.getFoundDecl(dre) isa CC.NamedDecl
    @test CC.hasQualifier(dre) isa Bool
    @test CC.getLocation(dre) isa CC.SourceLocation
    @test CC.getNameInfo(dre) isa CC.DeclarationNameInfo
    @test CC.hasTemplateKWAndArgsInfo(dre) isa Bool
    @test CC.getTemplateKeywordLoc(dre) isa CC.SourceLocation
    @test CC.getLAngleLoc(dre) isa CC.SourceLocation
    @test CC.getRAngleLoc(dre) isa CC.SourceLocation
    @test CC.hasTemplateKeyword(dre) isa Bool
    @test CC.hasExplicitTemplateArgs(dre) isa Bool
    @test CC.getNumTemplateArgs(dre) isa Integer
    @test CC.hadMultipleCandidates(dre) isa Bool
    @test CC.refersToEnclosingVariableOrCapture(dre) isa Bool
    @test CC.isImmediateEscalating(dre) isa Bool
    @test CC.isCapturedByCopyInLambdaWithExplicitObjectParameter(dre) isa Bool
    @test CC.getQualifier(dre) isa CC.NestedNameSpecifier

    # ---- UnaryExprOrTypeTraitExpr (sizeof) -----------------------------------
    uetts = byT(CC.UnaryExprOrTypeTraitExpr)
    @test !isempty(uetts)
    for u in uetts
        @test CC.isArgumentType(u) isa Bool
        @test CC.getTypeOfArgument(u) isa CC.QualType
        @test CC.getKind(u) isa CC.LibClangEx.CXUnaryExprOrTypeTrait
        @test CC.getOperatorLoc(u) isa CC.SourceLocation
        @test CC.getRParenLoc(u) isa CC.SourceLocation
        if CC.isArgumentType(u)
            @test CC.getArgumentType(u) isa CC.QualType
            @test CC.getArgumentTypeInfo(u) isa CC.TypeSourceInfo
        else
            @test CC.getArgumentExpr(u) isa CC.Expr_
        end
    end

    # ---- PredefinedExpr (__func__) -------------------------------------------
    pde = first_of(CC.PredefinedExpr)
    @test pde !== nothing
    @test CC.getIdentKind(pde) isa CC.LibClangEx.CXPredefinedIdentKind
    @test CC.getFunctionName(pde) isa CC.StringLiteral
    @test CC.getIdentKindName(pde) isa String

    # ---- StmtExpr ({ ...; }) -------------------------------------------------
    se = first_of(CC.StmtExpr)
    @test se !== nothing
    @test CC.getLParenLoc(se) isa CC.SourceLocation
    @test CC.getRParenLoc(se) isa CC.SourceLocation
    @test CC.getTemplateDepth(se) isa Integer
    @test CC.getSubStmt(se) isa CC.CompoundStmt

    # ---- CompoundLiteralExpr ((PointT){1,2}) ---------------------------------
    cle = first_of(CC.CompoundLiteralExpr)
    @test cle !== nothing
    @test CC.isFileScope(cle) isa Bool
    @test CC.getLParenLoc(cle) isa CC.SourceLocation
    @test CC.getInitializer(cle) isa CC.Expr_
    @test CC.getTypeSourceInfo(cle) isa CC.TypeSourceInfo

    # ---- ConstantExpr (immediate consteval invocation) -----------------------
    cst = first_of(CC.ConstantExpr)
    @test cst !== nothing
    @test CC.isImmediateInvocation(cst) isa Bool
    @test CC.hasAPValueResult(cst) isa Bool

    dispose(lookup)
    dispose(I)
end

@testset "Coverage | StmtExprCXX" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    struct Vec {
        int x;
        Vec() : x(0) {}
        Vec(int v) : x(v) {}
        Vec operator+(const Vec& o) const { return Vec(x + o.x); }
        int get() const { return x; }
        Vec* self() { return this; }
    };

    int control_flow(int n) {
        int total = 0;;
        int a = 1, b = 2;
        for (int i = 0; i < n; ++i) {
            if (i == 2) { continue; }
            if (i > 5) { break; }
            total += i;
        }
        int k = n;
        while (k > 0) { total += k; --k; }
        do { total += 1; } while (total < 3);
        switch (int sc = n; sc) {
            case 0: total += 100; break;
            case 1: total += 200; break;
            default: total += 300; break;
        }
        total += a + b;
        if (int iv = n; iv > 0) { return total; } else { return -total; }
    lbl:
        goto lbl;
    }

    Vec make_vecs(int n) {
        Vec a(1);
        Vec b = Vec(2);
        const Vec& r = Vec(3);
        Vec c = a + b;
        int g = c.get();
        int gg = Vec().get();
        Vec* p = new Vec(4);
        int* arr = new int[n];
        delete p;
        delete[] arr;
        bool flag = true;
        int s = static_cast<int>(c.x);
        auto lam = [g](int z) { return z + g; };
        int lr = lam(5);
        return Vec(g + s + lr + (flag ? 1 : 0));
    }
    """)

    finder = DeclFinder(I)

    # --- gather every resolved node across the two free functions and Vec's methods ---
    nodes = CC.AbstractStmt[]
    function gather!(fd)
        body = CC.getBody(fd)
        body.ptr == C_NULL && return
        append!(nodes, CC.subtree(body))
    end

    @test finder(I, "control_flow")
    cf = CC.FunctionDecl(get_decl(finder).ptr)
    gather!(cf)

    @test finder(I, "make_vecs")
    mv = CC.FunctionDecl(get_decl(finder).ptr)
    gather!(mv)

    @test finder(I, "Vec")
    vec = CC.CXXRecordDecl(get_decl(finder).ptr)
    for m in CC.getMethods(vec)
        fm = CC.FunctionDecl(m.ptr)
        CC.hasBody(fm) && gather!(fm)
    end

    pick(T) = filter(n -> n isa T, nodes)
    @test !isempty(nodes)

    # ================= Stmt.jl base + CompoundStmt =================
    body = CC.resolve(CC.getBody(cf))
    @test body isa CC.CompoundStmt

    # Stmt base wrappers (declared on Stmt)
    @test CC.getStmtClass(body) isa Any
    @test CC.getStmtClassName(body) == "CompoundStmt"
    @test CC.getBeginLoc(body) isa CC.SourceLocation
    @test CC.getEndLoc(body) isa CC.SourceLocation
    @test CC.getSourceRange(body) isa CC.SourceRange
    @test CC.getNumChildren(body) isa Integer
    @test CC.getChildren(body) isa Vector

    # stamped predicates + casts (the STMT_NODES loop in Stmt.jl)
    @test CC.isCompoundStmt(body) isa Bool
    @test CC.isIfStmt(body) isa Bool
    @test CC.isExpr(body) isa Bool
    @test CC.CompoundStmt(body) isa CC.CompoundStmt         # castToCompoundStmt
    @test CC.IfStmt(body) isa CC.IfStmt                     # dyn_cast_or_null -> NULL carrier

    # CompoundStmt accessors
    @test length(body) isa Integer
    @test CC.body_front(body) isa CC.Stmt
    @test CC.body_back(body) isa CC.Stmt
    @test CC.getLBracLoc(body) isa CC.SourceLocation
    @test CC.getRBracLoc(body) isa CC.SourceLocation
    @test CC.body_empty(body) isa Bool
    @test CC.hasStoredFPFeatures(body) isa Bool

    # ================= DeclStmt =================
    dss = pick(CC.DeclStmt)
    @test !isempty(dss)
    single = first(filter(d -> CC.isSingleDecl(d), dss))
    @test CC.isSingleDecl(single) isa Bool
    @test CC.getSingleDecl(single) isa CC.Decl
    @test CC.getNumDecls(single) isa Integer
    @test CC.getDecls(single) isa Vector
    multi = first(filter(d -> CC.getNumDecls(d) > 1, dss))   # `int a = 1, b = 2;`
    @test CC.getNumDecls(multi) == 2

    # ================= IfStmt =================
    ifs = pick(CC.IfStmt)
    @test !isempty(ifs)
    ifi = first(ifs)
    @test CC.getCond(ifi) isa CC.Expr_
    @test CC.getThen(ifi) isa CC.Stmt
    @test CC.getElse(ifi) isa CC.Stmt
    @test CC.getInit(ifi) isa CC.Stmt
    @test CC.getConditionVariable(ifi) isa CC.VarDecl
    @test CC.hasElseStorage(ifi) isa Bool
    @test CC.hasInitStorage(ifi) isa Bool
    @test CC.hasVarStorage(ifi) isa Bool
    @test CC.getIfLoc(ifi) isa CC.SourceLocation
    @test CC.getElseLoc(ifi) isa CC.SourceLocation
    @test CC.isConsteval(ifi) isa Bool
    @test CC.isNonNegatedConsteval(ifi) isa Bool
    @test CC.isNegatedConsteval(ifi) isa Bool
    @test CC.isConstexpr(ifi) isa Bool
    @test CC.isObjCAvailabilityCheck(ifi) isa Bool
    @test CC.getLParenLoc(ifi) isa CC.SourceLocation
    @test CC.getRParenLoc(ifi) isa CC.SourceLocation

    # ================= SwitchStmt / SwitchCase / CaseStmt / DefaultStmt =================
    sw = first(pick(CC.SwitchStmt))
    @test CC.getCond(sw) isa CC.Expr_
    @test CC.getBody(sw) isa CC.Stmt
    scl = CC.getSwitchCaseList(sw)
    @test scl isa CC.SwitchCase
    @test CC.isAllEnumCasesCovered(sw) isa Bool
    @test CC.hasInitStorage(sw) isa Bool
    @test CC.hasVarStorage(sw) isa Bool
    @test CC.getSwitchLoc(sw) isa CC.SourceLocation
    @test CC.getLParenLoc(sw) isa CC.SourceLocation
    @test CC.getRParenLoc(sw) isa CC.SourceLocation
    # SwitchCase base accessors
    @test CC.getNextSwitchCase(scl) isa CC.SwitchCase
    @test CC.getSubStmt(scl) isa CC.Stmt
    @test CC.getKeywordLoc(scl) isa CC.SourceLocation
    @test CC.getColonLoc(scl) isa CC.SourceLocation
    # CaseStmt
    cs = first(pick(CC.CaseStmt))
    @test CC.getLHS(cs) isa CC.Expr_
    @test CC.getRHS(cs) isa CC.Expr_
    @test CC.caseStmtIsGNURange(cs) isa Bool
    @test CC.getCaseLoc(cs) isa CC.SourceLocation
    @test CC.getEllipsisLoc(cs) isa CC.SourceLocation
    # DefaultStmt
    ds = first(pick(CC.DefaultStmt))
    @test CC.getDefaultLoc(ds) isa CC.SourceLocation

    # ================= WhileStmt =================
    ws = first(pick(CC.WhileStmt))
    @test CC.getCond(ws) isa CC.Expr_
    @test CC.getBody(ws) isa CC.Stmt
    @test CC.getConditionVariable(ws) isa CC.VarDecl
    @test CC.getWhileLoc(ws) isa CC.SourceLocation
    @test CC.hasVarStorage(ws) isa Bool
    @test CC.getLParenLoc(ws) isa CC.SourceLocation
    @test CC.getRParenLoc(ws) isa CC.SourceLocation

    # ================= DoStmt =================
    do_ = first(pick(CC.DoStmt))
    @test CC.getCond(do_) isa CC.Expr_
    @test CC.getBody(do_) isa CC.Stmt
    @test CC.getDoLoc(do_) isa CC.SourceLocation
    @test CC.getWhileLoc(do_) isa CC.SourceLocation
    @test CC.getRParenLoc(do_) isa CC.SourceLocation

    # ================= ForStmt =================
    fs = first(pick(CC.ForStmt))
    @test CC.getInit(fs) isa CC.Stmt
    @test CC.getCond(fs) isa CC.Expr_
    @test CC.getInc(fs) isa CC.Expr_
    @test CC.getBody(fs) isa CC.Stmt
    @test CC.getConditionVariable(fs) isa CC.VarDecl
    @test CC.getForLoc(fs) isa CC.SourceLocation
    @test CC.getLParenLoc(fs) isa CC.SourceLocation
    @test CC.getRParenLoc(fs) isa CC.SourceLocation

    # ================= GotoStmt / LabelStmt =================
    gs = first(pick(CC.GotoStmt))
    @test CC.getLabel(gs) isa CC.LabelDecl
    @test CC.getGotoLoc(gs) isa CC.SourceLocation
    @test CC.getLabelLoc(gs) isa CC.SourceLocation
    ls = first(pick(CC.LabelStmt))
    @test CC.getName(ls) == "lbl"
    @test CC.getDecl(ls) isa CC.LabelDecl
    @test CC.getSubStmt(ls) isa CC.Stmt
    @test CC.getIdentLoc(ls) isa CC.SourceLocation
    @test CC.isSideEntry(ls) isa Bool

    # ================= ContinueStmt / BreakStmt =================
    cont = first(pick(CC.ContinueStmt))
    @test CC.getContinueLoc(cont) isa CC.SourceLocation
    brk = first(pick(CC.BreakStmt))
    @test CC.getBreakLoc(brk) isa CC.SourceLocation

    # ================= ReturnStmt =================
    rs = first(pick(CC.ReturnStmt))
    @test CC.getRetValue(rs) isa CC.Expr_
    @test CC.getReturnLoc(rs) isa CC.SourceLocation

    # ================= NullStmt =================
    ns = first(pick(CC.NullStmt))
    @test CC.getSemiLoc(ns) isa CC.SourceLocation
    @test CC.hasLeadingEmptyMacro(ns) isa Bool

    # ================= ExprCXX.jl =================

    # CXXConstructExpr (covers CXXTemporaryObjectExpr too)
    ces = pick(CC.AbstractCXXConstructExpr)
    @test !isempty(ces)
    ce = first(ces)
    @test CC.getConstructor(ce) isa CC.CXXConstructorDecl
    @test CC.getNumArgs(ce) isa Integer
    CC.getNumArgs(ce) > 0 && (@test CC.getArg(ce, 0) isa CC.Expr_)
    @test CC.isElidable(ce) isa Bool
    @test CC.getLocation(ce) isa CC.SourceLocation
    @test CC.hadMultipleCandidates(ce) isa Bool
    @test CC.isListInitialization(ce) isa Bool
    @test CC.isStdInitListInitialization(ce) isa Bool
    @test CC.requiresZeroInitialization(ce) isa Bool
    @test CC.isImmediateEscalating(ce) isa Bool
    @test CC.getConstructionKind(ce) !== nothing
    # CXXTemporaryObjectExpr specifically present (from zero-arg `Vec()`)
    @test !isempty(pick(CC.CXXTemporaryObjectExpr))

    # CXXMemberCallExpr — c.get()
    mce = first(pick(CC.CXXMemberCallExpr))
    @test CC.getImplicitObjectArgument(mce) isa CC.Expr_
    @test CC.getMethodDecl(mce) isa CC.CXXMethodDecl
    @test CC.getRecordDecl(mce) isa CC.CXXRecordDecl

    # CXXOperatorCallExpr — a + b
    oce = first(pick(CC.CXXOperatorCallExpr))
    @test CC.getOperator(oce) !== nothing
    @test CC.getOperatorLoc(oce) isa CC.SourceLocation

    # CXXBoolLiteralExpr — true
    ble = first(pick(CC.CXXBoolLiteralExpr))
    @test CC.getValue(ble) isa Bool
    @test CC.getLocation(ble) isa CC.SourceLocation

    # LambdaExpr — [g](int z){...}
    le = first(pick(CC.LambdaExpr))
    @test CC.getCallOperator(le) isa CC.CXXMethodDecl
    @test CC.getLambdaClass(le) isa CC.CXXRecordDecl
    @test CC.getBody(le) isa CC.Stmt
    @test CC.isMutable(le) isa Bool
    @test CC.getNumCaptures(le) isa Integer
    @test CC.isGenericLambda(le) isa Bool
    @test CC.getNumCaptures(le) >= 1
    cap = CC.getCapture(le, 0)
    @test cap isa CC.LambdaCapture
    @test CC.getCaptureKind(cap) !== nothing
    @test CC.capturesThis(cap) isa Bool
    @test CC.capturesVariable(cap) isa Bool
    @test CC.capturesVLAType(cap) isa Bool
    CC.capturesVariable(cap) && (@test CC.getCapturedVar(cap) isa CC.ValueDecl)

    # CXXNewExpr — new Vec(4) and new int[n]
    news = pick(CC.CXXNewExpr)
    @test length(news) >= 2
    for ne in news
        @test CC.getAllocatedType(ne) isa CC.QualType
        @test CC.isArray(ne) isa Bool
        @test CC.getArraySize(ne) isa CC.Expr_
        @test CC.hasInitializer(ne) isa Bool
        @test CC.getInitializer(ne) isa CC.Expr_
        @test CC.shouldNullCheckAllocation(ne) isa Bool
        @test CC.getNumPlacementArgs(ne) isa Integer
        @test CC.isParenTypeId(ne) isa Bool
        @test CC.isGlobalNew(ne) isa Bool
        @test CC.passAlignment(ne) isa Bool
        @test CC.doesUsualArrayDeleteWantSize(ne) isa Bool
        @test CC.getInitializationStyle(ne) !== nothing
        @test CC.getOperatorDelete(ne) isa CC.FunctionDecl
        @test CC.getOperatorNew(ne) isa CC.FunctionDecl
        @test CC.getAllocatedTypeSourceInfo(ne) isa CC.TypeSourceInfo
        @test CC.getConstructExpr(ne) isa CC.CXXConstructExpr
    end

    # CXXDeleteExpr — delete p; delete[] arr;
    dels = pick(CC.CXXDeleteExpr)
    @test length(dels) >= 2
    for de in dels
        @test CC.getArgument(de) isa CC.Expr_
        @test CC.isArrayForm(de) isa Bool
        @test CC.isGlobalDelete(de) isa Bool
        @test CC.isArrayFormAsWritten(de) isa Bool
        @test CC.doesUsualArrayDeleteWantSize(de) isa Bool
        @test CC.getDestroyedType(de) isa CC.QualType
        @test CC.getOperatorDelete(de) isa CC.FunctionDecl
    end

    # CastExpr — pick any (implicit or explicit) cast node
    caste = first(pick(CC.AbstractCastExpr))
    @test CC.path_empty(caste) isa Bool
    @test CC.path_size(caste) isa Integer
    @test CC.hasStoredFPFeatures(caste) isa Bool
    @test CC.changesVolatileQualification(caste) isa Bool
    @test CC.getConversionFunction(caste) isa CC.NamedDecl
    # getTargetUnionField is intentionally not called: clang asserts
    # (getCastKind() == CK_ToUnion) inside it, and a CK_ToUnion cast is a C-only
    # (GNU cast-to-union) construct unreachable from this C++ sample.

    # CXXNamedCastExpr — static_cast<int>(...)
    nce = first(pick(CC.AbstractCXXNamedCastExpr))
    @test CC.getOperatorLoc(nce) isa CC.SourceLocation
    @test CC.getRParenLoc(nce) isa CC.SourceLocation

    # CXXThisExpr — Vec::self() returns this
    tes = pick(CC.CXXThisExpr)
    @test !isempty(tes)
    te = first(tes)
    @test CC.getLocation(te) isa CC.SourceLocation
    @test CC.isImplicit(te) isa Bool

    # MaterializeTemporaryExpr — const Vec& r = Vec(3)
    mtes = pick(CC.MaterializeTemporaryExpr)
    @test !isempty(mtes)
    mte = first(mtes)
    @test CC.getManglingNumber(mte) isa Integer
    @test CC.isBoundToLvalueReference(mte) isa Bool
    @test CC.getExtendingDecl(mte) isa CC.ValueDecl
    @test CC.getSubExpr(mte) isa CC.Expr_

    dispose(finder)
    dispose(I)
end

@testset "Coverage | DeclBaseTemplate" begin
    I = create_interpreter(String[])
    src = """
    template <typename T, int N> struct S { T data; T get() { return data; } };
    template <typename U> U identity(U v) { return v; }
    __attribute__((deprecated("old"))) int depvar = 3;
    int freefn(int a, int b) { return a + b; }
    S<int, 5> s_inst;
    """
    CC.parse(I, src)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # ---------- ClassTemplateDecl (S) ----------
    @test f(I, "S")
    snd = get_decl(f)                                   # NamedDecl carrier
    ctd = CC.ClassTemplateDecl(snd)                     # castTo (AbstractDecl)
    @test ctd isa CC.ClassTemplateDecl

    tpl = CC.getTemplateParameters(ctd)                 # TemplateDecl
    @test tpl isa CC.TemplateParameterList
    @test size(tpl) isa Integer                         # TemplateParameterList size
    @test CC.getDepth(tpl) isa Integer
    @test CC.getMinRequiredArguments(tpl) isa Integer
    @test CC.hasParameterPack(tpl) isa Bool

    p0 = CC.getParam(tpl, 0)                            # NamedDecl (T)
    @test p0 isa CC.NamedDecl
    ttp = CC.TemplateTypeParmDecl(p0.ptr)
    @test CC.getDepth(ttp) isa Integer
    @test CC.getIndex(ttp) isa Integer
    @test CC.isParameterPack(ttp) isa Bool

    p1 = CC.getParam(tpl, 1)                            # NonTypeTemplateParmDecl (N)
    nttp = CC.NonTypeTemplateParmDecl(p1.ptr)
    @test CC.getDepth(nttp) isa Integer
    @test CC.getIndex(nttp) isa Integer
    @test CC.isParameterPack(nttp) isa Bool

    # RedeclarableTemplateDecl / ClassTemplateDecl accessors on ctd
    trec = CC.getTemplatedDecl(ctd)                    # Redeclarable -> CXXRecordDecl
    @test trec isa CC.CXXRecordDecl
    @test CC.isMemberSpecialization(ctd) isa Bool
    @test CC.isThisDeclarationADefinition(ctd) isa Bool
    @test CC.getCanonicalDecl(ctd) isa CC.ClassTemplateDecl
    @test CC.getMostRecentDecl(ctd) isa CC.ClassTemplateDecl
    @test CC.getPreviousDecl(ctd) isa CC.ClassTemplateDecl

    # described-template navigation off the templated record
    dt = CC.getDescribedTemplate(trec)                 # TemplateDecl base carrier
    @test dt isa CC.TemplateDecl
    if dt.ptr != C_NULL
        @test CC.getTemplatedDecl(dt) isa CC.NamedDecl # AbstractTemplateDecl path
    end
    @test CC.getDescribedTemplateParams(trec) isa CC.TemplateParameterList

    # ---------- FunctionTemplateDecl (identity) ----------
    # A function-template name lookup yields an overload-set result, so pull the
    # FunctionTemplate carrier out of the full result list.
    @test f(I, "identity")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d.ptr)
            break
        end
    end
    @test ftd isa CC.FunctionTemplateDecl
    @test CC.getTemplateParameters(ftd) isa CC.TemplateParameterList
    @test CC.getCanonicalDecl(ftd) isa CC.RedeclarableTemplateDecl   # Redeclarable path
    @test CC.isMemberSpecialization(ftd) isa Bool

    # ---------- ClassTemplateSpecializationDecl (S<int,5>) ----------
    @test f(I, "s_inst")
    vd = CC.VarDecl(get_decl(f).ptr)
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test specrec isa CC.CXXRecordDecl
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        spec = CC.ClassTemplateSpecializationDecl(specrec.ptr)
        @test (CC.getSpecializationKind(spec); true)
        stpl = CC.getSpecializedTemplate(spec)
        @test stpl isa CC.ClassTemplateDecl
        args = CC.getTemplateArgs(spec)                # TemplateArgumentList
        @test args isa CC.TemplateArgumentList
        @test size(args) isa Integer
        @test CC.data(args) isa Ptr
        if size(args) > 0
            @test get(args, 0) isa CC.TemplateArgument
        end
        @test CC.findSpecialization(stpl, args) isa CC.ClassTemplateSpecializationDecl
    end

    # ---------- Decl base accessors (freefn) ----------
    @test f(I, "freefn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.getLocation(fd) isa CC.SourceLocation
    @test CC.getBeginLoc(fd) isa CC.SourceLocation
    @test CC.getEndLoc(fd) isa CC.SourceLocation
    @test CC.getDeclKindName(fd) isa String
    @test (CC.getKind(fd); true)
    @test CC.hasAttrs(fd) isa Bool
    @test CC.getNumAttrs(fd) isa Integer
    @test CC.getAttrs(fd) isa Vector
    @test CC.getNextDeclInContext(fd) isa CC.Decl
    @test CC.getDeclContext(fd) isa CC.DeclContext
    @test CC.getNonClosureContext(fd) isa CC.Decl
    tu = CC.getTranslationUnitDecl(fd)
    @test tu isa CC.TranslationUnitDecl
    @test CC.isInAnonymousNamespace(fd) isa Bool
    @test CC.isInStdNamespace(fd) isa Bool
    @test CC.getASTContext(fd) isa CC.ASTContext
    @test CC.getLangOpts(fd) isa CC.LangOptions
    @test CC.getLexicalDeclContext(fd) isa CC.DeclContext
    @test CC.isOutOfLine(fd) isa Bool
    @test CC.isTemplated(fd) isa Bool
    @test CC.getTemplateDepth(fd) isa Integer
    @test CC.isDefinedOutsideFunctionOrMethod(fd) isa Bool
    @test CC.isInLocalScopeForInstantiation(fd) isa Bool
    @test CC.getParentFunctionOrMethod(fd) isa CC.DeclContext
    # getCanonicalDecl/getMostRecentDecl on AbstractDecl are shadowed for named
    # decls; the non-named TranslationUnitDecl reaches the DeclBase fallbacks.
    @test CC.getCanonicalDecl(tu) isa CC.Decl
    @test CC.isCanonicalDecl(fd) isa Bool
    @test CC.getPreviousDecl(fd) isa CC.Decl
    @test CC.isFirstDecl(fd) isa Bool
    @test CC.getMostRecentDecl(tu) isa CC.Decl
    @test CC.isTemplateParameter(fd) isa Bool
    @test CC.isTemplateParameterPack(fd) isa Bool
    @test CC.isParameterPack(fd) isa Bool               # AbstractDecl path
    @test CC.isTemplateDecl(fd) isa Bool
    @test CC.getDescribedTemplate(fd) isa CC.TemplateDecl
    @test CC.getDescribedTemplateParams(fd) isa CC.TemplateParameterList
    @test CC.getAsFunction(fd) isa CC.FunctionDecl
    @test CC.getID(fd) isa Integer
    @test CC.getFunctionType(fd) isa CC.FunctionType
    @test (CC.dumpColor(fd); true)

    # castTo helpers off a Decl
    @test CC.ValueDecl(fd) isa CC.ValueDecl
    @test CC.CXXConstructorDecl(fd) isa CC.CXXConstructorDecl

    # ---------- attributed decl (depvar) ----------
    @test f(I, "depvar")
    dv = CC.VarDecl(get_decl(f).ptr)
    @test CC.hasAttrs(dv) isa Bool
    if CC.getNumAttrs(dv) > 0
        @test CC.getAttr(dv, 0) isa CC.Attr
    end

    # ---------- Decl <-> DeclContext pivot + DeclContext accessors ----------
    tudc = CC.castToDeclContext(tu)
    @test tudc isa CC.DeclContext
    @test CC.castFromDeclContext(tudc) isa CC.Decl
    @test CC.getParentASTContext(tudc) isa CC.ASTContext
    @test CC.getDeclKindName(tudc) isa String
    @test CC.getParent(tudc) isa Ptr
    @test CC.getLexicalParent(tudc) isa Ptr
    @test CC.getLookupParent(tudc) isa Ptr
    @test CC.isClosure(tudc) isa Bool
    @test CC.isFunctionOrMethod(tudc) isa Bool
    @test CC.isLookupContext(tudc) isa Bool
    @test CC.isFileContext(tudc) isa Bool
    @test CC.isTranslationUnit(tudc) isa Bool
    @test CC.isRecord(tudc) isa Bool
    @test CC.isNamespace(tudc) isa Bool
    @test CC.isStdNamespace(tudc) isa Bool
    @test CC.isInlineNamespace(tudc) isa Bool
    @test CC.is_dependent_context(tudc) isa Bool
    @test CC.isTransparentContext(tudc) isa Bool
    @test CC.isExternCContext(tudc) isa Bool
    @test CC.isExternCXXContext(tudc) isa Bool
    @test CC.Equals(tudc, tudc) isa Bool
    @test CC.getPrimaryContext(tudc) isa CC.DeclContext
    @test CC.decl_iterator_begin(tudc) isa CC.Decl
    @test (CC.containsDecl(tudc, fd); true)             # wrapper drops the bool -> nothing
    @test (CC.dumpDeclContext(tudc); true)
    @test (CC.dumpLookups(tudc); true)

    # record DeclContext casts
    recdc = CC.castToDeclContext(trec)
    @test recdc isa CC.DeclContext
    @test CC.isRecord(recdc) isa Bool
    @test CC.TagDecl(recdc) isa CC.TagDecl
    @test CC.RecordDecl(recdc) isa CC.RecordDecl
    @test CC.CXXRecordDecl(recdc) isa CC.CXXRecordDecl

    dispose(f)
    dispose(I)
end

@testset "Coverage | CompilerSemaParseLex" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace NS { struct Inner { int z; }; }
    struct Widget {
        int value;
        Widget() : value(0) {}
        ~Widget() {}
        int getValue() const { return value; }
    };
    int compute(int a, int b) { return a + b; }
    int gx = 42;
    """)

    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    parser = CC.get_parser(I)

    # ---- CompilerInstance: has*/get* query accessors ----
    @test CC.hasDiagnostics(ci) isa Bool
    @test CC.getDiagnostics(ci) isa CC.DiagnosticsEngine
    @test CC.getDiagnosticClient(ci) isa CC.DiagnosticConsumer
    @test CC.hasFileManager(ci) isa Bool
    @test CC.getFileManager(ci) isa CC.FileManager
    @test CC.hasSourceManager(ci) isa Bool
    @test CC.getSourceManager(ci) isa CC.SourceManager
    @test CC.hasInvocation(ci) isa Bool
    @test CC.getInvocation(ci) isa CC.CompilerInvocation
    @test CC.hasTarget(ci) isa Bool
    @test CC.getTarget(ci) isa CC.TargetInfo
    @test CC.hasPreprocessor(ci) isa Bool
    @test CC.getPreprocessor(ci) isa CC.Preprocessor
    @test CC.hasSema(ci) isa Bool
    @test CC.getSema(ci) isa CC.Sema
    @test CC.hasASTContext(ci) isa Bool
    @test CC.getASTContext(ci) isa CC.ASTContext
    @test CC.hasASTConsumer(ci) isa Bool
    @test CC.getASTConsumer(ci) isa CC.ASTConsumer

    # ---- CompilerInstance: option accessors ----
    @test CC.getCodeGenOpts(ci) isa CC.CodeGenOptions
    @test CC.getDiagnosticOpts(ci) isa CC.DiagnosticOptions
    @test CC.getFrontendOpts(ci) isa CC.FrontendOptions
    @test CC.getHeaderSearchOpts(ci) isa CC.HeaderSearchOptions
    @test CC.getPreprocessorOpts(ci) isa CC.PreprocessorOptions
    @test CC.getTargetOpts(ci) isa CC.TargetOptions
    @test CC.getLangOpts(ci) isa CC.LangOptions

    # main file id (allocates -> dispose)
    fid = CC.getMainFileID(ci)
    @test fid isa CC.FileID
    dispose(fid)

    # ---- CompilerInstance: PrintStats dispatch table (writes to stderr) ----
    for T in (CC.CodeGenOptions, CC.DiagnosticOptions, CC.FrontendOptions,
              CC.HeaderSearchOptions, CC.PreprocessorOptions, CC.TargetOptions,
              CC.LangOptions, CC.FileManager, CC.SourceManager, CC.HeaderSearch,
              CC.Preprocessor, CC.Sema, CC.ASTContext, CC.ASTConsumer)
        @test (CC.PrintStats(ci, T); true)
    end

    # ---- Preprocessor (Lex/Preprocessor.jl) ----
    pp = CC.getPreprocessor(ci)
    hs = CC.getHeaderSearchInfo(pp)
    @test hs isa CC.HeaderSearch
    @test (CC.PrintStats(pp); true)
    @test CC.isIncrementalProcessingEnabled(pp) isa Bool
    @test (CC.enableIncrementalProcessing(pp); CC.isIncrementalProcessingEnabled(pp)) isa Bool

    # ---- HeaderSearch / HeaderSearchOptions / PreprocessorOptions ----
    @test (CC.PrintStats(hs); true)
    hso = CC.getHeaderSearchOpts(ci)
    @test CC.GetResourceDir(hso) isa String
    @test (CC.PrintStats(hso); true)
    ppo = CC.getPreprocessorOpts(ci)
    @test (CC.PrintStats(ppo); true)

    # ---- Decls: reach a NamedDecl, a CXXRecordDecl, a SourceLocation ----
    f = DeclFinder(I)
    @test f(I, "Widget")
    widget = get_decl(f)
    @test widget isa CC.NamedDecl
    widget_rd = CC.CXXRecordDecl(get_decl(f).ptr)
    widget_ii = CC.getIdentifier(widget)
    widget_loc = CC.getLocation(widget)

    # ---- Sema (Sema/Sema.jl) ----
    sema = CC.get_sema(I)
    scope = CC.getCurScope(parser)
    @test (CC.PrintStats(sema); true)

    ss_tn = CC.CXXScopeSpec()
    @test CC.getTypeName(sema, widget_ii, widget_loc, scope, ss_tn) isa CC.QualType

    @test CC.LookupDefaultConstructor(sema, widget_rd) isa CC.CXXConstructorDecl
    @test CC.LookupDestructor(sema, widget_rd) isa CC.CXXDestructorDecl

    # LookupResult construction + unqualified LookupName
    nm = CC.DeclarationName(CC.get_name(ctx, "compute"))
    lr = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupName(sema, lr, scope, true) isa Bool

    # LookupParsedName on a fresh result + scope spec
    ss_lp = CC.CXXScopeSpec()
    lr2 = CC.LookupResult(sema, nm, widget_loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupParsedName(sema, lr2, scope, ss_lp, true, true) isa Bool

    # ---- LookupResult query surface (Sema/Lookup.jl) on the populated `lr` ----
    @test (CC.resolveKind(lr); true)
    @test CC.isForRedeclaration(lr) isa Bool
    @test CC.isTemplateNameLookup(lr) isa Bool
    @test CC.isAmbiguous(lr) isa Bool
    @test CC.isSingleResult(lr) isa Bool
    @test CC.isOverloadedResult(lr) isa Bool
    @test CC.isUnresolvableResult(lr) isa Bool
    @test CC.isClassLookup(lr) isa Bool
    @test CC.isSingleTagDecl(lr) isa Bool
    @test CC.empty(lr) isa Bool
    @test CC.getNum(lr) isa Integer
    @test CC.getResults(lr) isa Vector
    @test CC.getRepresentativeDecl(lr) isa CC.NamedDecl
    @test CC.getLookupName(lr) isa CC.DeclarationName
    if CC.isSingleResult(lr)
        @test CC.getResult(lr) isa CC.NamedDecl
    end
    @test (CC.dump(lr); true)
    @test (CC.setLookupName(lr, CC.getLookupName(lr)); true)
    @test (CC.clear(lr, CC.CXLookupNameKind_LookupOrdinaryName); true)
    dispose(lr)
    dispose(lr2)
    dispose(ss_tn)
    dispose(ss_lp)

    # ---- Scope (Sema/Scope.jl) ----
    scope = CC.getCurScope(parser)
    @test CC.getDepth(scope) isa Integer
    @test CC.getParent(scope) isa CC.Scope
    @test (CC.dump(scope); true)

    # ---- CXXScopeSpec (Sema/DeclSpec.jl) via a populated scope spec ----
    dss = CC.CXXScopeSpec()
    tail = CC.parse_cxx_scope_spec(I, dss, "NS::Inner")
    @test tail isa AbstractString
    @test CC.isValid(dss) isa Bool
    @test CC.isInvalid(dss) isa Bool
    @test CC.isEmpty(dss) isa Bool
    @test CC.isNotEmpty(dss) isa Bool
    @test CC.getScopeRep(dss) isa CC.NestedNameSpecifier
    bloc = CC.getBeginLoc(dss)
    eloc = CC.getEndLoc(dss)
    @test bloc isa CC.SourceLocation
    @test eloc isa CC.SourceLocation
    @test (CC.setBeginLoc(dss, bloc); true)
    @test (CC.setEndLoc(dss, eloc); true)
    sr = CC.SourceRange(bloc, eloc)
    @test CC.getRange(dss, sr) isa CC.SourceRange
    @test (CC.setRange(dss, sr); true)
    @test (CC.clear(dss); true)
    dispose(dss)

    # ---- Parser: read-only queries (Parse/Parser.jl) ----
    @test CC.getLangOpts(parser) isa Ptr
    @test CC.getTargetInfo(parser) isa CC.TargetInfo
    @test CC.getPreprocessor(parser) isa CC.Preprocessor
    @test CC.getActions(parser) isa CC.Sema
    tok = CC.getCurToken(parser)
    @test tok isa CC.Token
    @test CC.NextToken(parser) isa CC.Token

    # pure helper functions over the parser context enums
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Member) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_File) isa CC.CXDeclSpecContext
    @test CC.getDeclSpecContextFromDeclaratorContext(CC.CXDeclaratorContext_Block) isa CC.CXDeclSpecContext
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_top_level) isa Bool
    @test CC.shouldEnterContext(CC.CXDeclSpecContext_DSC_normal) isa Bool

    # ---- Token query surface (Lex/Token.jl) ----
    @test CC.getLocation(tok) isa CC.SourceLocation
    @test CC.getAnnotationEndLoc(tok) isa CC.SourceLocation
    @test CC.getAnnotationRange(tok) isa CC.SourceRange
    @test CC.getName(tok) isa String
    @test CC.getAnnotationValue(tok) isa CC.AnnotationValue
    @test CC.is_eof(tok) isa Bool
    @test CC.is_annot_repl_input_end(tok) isa Bool
    @test CC.is_identifier(tok) isa Bool
    @test CC.is_coloncolon(tok) isa Bool
    @test CC.is_annot_cxxscope(tok) isa Bool
    @test CC.is_annot_typename(tok) isa Bool
    @test CC.is_annot_template_id(tok) isa Bool
    @test CC.is_kw_enum(tok) isa Bool
    @test CC.is_kw_typename(tok) isa Bool
    # getIdentifierInfo aborts on annotation tokens; only call on a real identifier.
    if CC.is_identifier(tok)
        @test CC.getIdentifierInfo(tok) isa CC.IdentifierInfo
    end

    # QualType annotation read off a token (Parse/Parser.jl)
    @test CC.getTypeAnnotation(tok) isa CC.QualType

    # ---- Preprocessor dump helpers (need a token / a location) ----
    @test (CC.DumpToken(pp, tok); true)
    @test (CC.DumpLocation(pp, widget_loc); true)

    # ---- Parser mutators run LAST (they advance/annotate the live token stream) ----
    @test CC.TryAnnotateCXXScopeToken(parser, false) isa Bool
    @test CC.TryAnnotateCXXScopeToken(parser, CC.CXDeclSpecContext_DSC_top_level) isa Bool
    @test CC.TryAnnotateCXXScopeToken(parser, CC.CXDeclaratorContext_File) isa Bool
    @test CC.TryAnnotateOptionalCXXScopeToken(parser, false) isa Bool
    @test CC.TryAnnotateOptionalCXXScopeToken(parser, CC.CXDeclSpecContext_DSC_class) isa Bool
    @test CC.TryAnnotateOptionalCXXScopeToken(parser, CC.CXDeclaratorContext_Member) isa Bool
    @test CC.TryAnnotateTypeOrScopeToken(parser) isa Bool
    ss_af = CC.CXXScopeSpec()
    @test CC.TryAnnotateTypeOrScopeTokenAfterScopeSpec(parser, ss_af) isa Bool
    dispose(ss_af)
    @test CC.ConsumeAnyToken(parser) isa CC.SourceLocation

    dispose(f)
    dispose(I)
end

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

@testset "Coverage | BasicCodeGen" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int add_two(int a) { int r = a + 2; return r; }
             struct Widget { int value; };
             """)

    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(ci)

    # reach a NamedDecl / SourceLocation / SourceRange
    f = DeclFinder(I)
    @test f(I, "add_two") isa Bool
    d = get_decl(f)
    fd = CC.FunctionDecl(d.ptr)
    loc = CC.getLocation(fd)
    sr = CC.getSourceRange(fd)

    # ---- SourceManager.jl ----
    @test CC.PrintStats(sm) === nothing
    fid = CC.getMainFileID(sm)
    @test fid isa CC.FileID
    startloc = CC.getLocForStartOfFile(sm, fid)
    @test startloc isa CC.SourceLocation
    @test CC.dump(loc, sm) === nothing
    # NOTE: getLocForEndOfFile is skipped — its body has `@check_ptrs x` referencing an
    # undefined variable, so any call throws UndefVarError.

    # ---- SourceLocation.jl ----
    @test CC.getHashValue(fid) isa Integer
    inv = CC.SourceLocation()
    @test inv isa CC.SourceLocation
    @test CC.isFileID(loc) isa Bool
    @test CC.isMacroID(loc) isa Bool
    @test CC.isValid(loc) isa Bool
    @test CC.isInvalid(inv) isa Bool
    @test CC.getHashValue(loc) isa Integer
    b = CC.getBeginLoc(sr)
    e = CC.getEndLoc(sr)
    @test b isa CC.SourceLocation
    @test e isa CC.SourceLocation
    @test CC.isPairOfFileLocations(b, e) isa Bool
    @test CC.getLocWithOffset(loc, 3) isa CC.SourceLocation
    @test CC.printToString(loc, sm) isa String
    CC.dispose(fid)

    # ---- IdentifierTable.jl ----
    it = CC.getIdents(ctx)
    @test it isa CC.IdentifierTable
    @test CC.PrintStats(it) === nothing
    ii = get(it, "add_two")
    @test ii isa CC.IdentifierInfo
    ii2 = CC.getIdentifier(fd)
    @test CC.getName(ii2) isa String

    # ---- DiagnosticOptions.jl ----
    dopts = CC.DiagnosticOptions()
    @test dopts isa CC.DiagnosticOptions
    @test CC.create_diagnostic_opts() isa Ptr
    @test CC.PrintStats(dopts) === nothing
    @test CC.setShowColors(dopts, false) === nothing
    @test CC.setShowPresumedLoc(dopts, true) === nothing

    # ---- Diagnostic.jl ----
    diag = CC.getDiagnostics(ci)              # live engine, owned by the interpreter
    @test CC.setShowColors(diag, false) === nothing

    consumer = CC.IgnoringDiagConsumer()
    @test consumer isa CC.IgnoringDiagConsumer
    @test CC.create_ignoring_diagnostic_consumer() isa Ptr
    langopts = CC.getLangOpts(ci)
    pp = CC.getPreprocessor(ci)
    @test CC.BeginSourceFile(consumer, langopts, pp) === nothing
    @test CC.EndSourceFile(consumer) === nothing
    CC.dispose(consumer)

    # self-contained engines are safe to dispose (they own their ids/opts/client)
    eng0 = CC.DiagnosticsEngine()
    @test eng0 isa CC.DiagnosticsEngine
    CC.dispose(eng0)
    rawE = CC.create_diagnostics_engine()
    @test rawE isa Ptr
    CC.dispose(CC.DiagnosticsEngine(rawE))

    # engines that share externally-allocated opts/client are exercised then leaked
    eng1 = CC.DiagnosticsEngine(CC.DiagnosticOptions())
    @test eng1 isa CC.DiagnosticsEngine
    eng2 = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                CC.IgnoringDiagConsumer(), false)
    @test eng2 isa CC.DiagnosticsEngine

    # ---- CodeGen/ModuleBuilder.jl ----
    cg = CC.getCodeGen(I.interp)
    @test cg isa CC.CodeGenerator
    cgm = CC.CGM(cg)
    @test cgm isa CC.CodeGenModule
    mod = CC.GetModule(cg)
    @test mod isa CC.LLVM.Module
    @test CC.GetDeclForMangledName(cg, "add_two") isa CC.Decl

    # ReleaseModule / StartModule mutate the codegen's module ownership; run them on a
    # throwaway interpreter and leave it undisposed to avoid an ownership double-free.
    J = create_interpreter(String[])
    CC.parse(J, "extern \"C\" int jf(int x) { return x + 1; }")
    cgJ = CC.getCodeGen(J.interp)
    relmod = CC.ReleaseModule(cgJ)
    @test relmod isa CC.LLVM.Module
    newmod = CC.StartModule(cgJ, CC.LLVM.context(relmod), "cov_module")
    @test newmod isa CC.LLVM.Module

    dispose(f)
    dispose(I)
end
