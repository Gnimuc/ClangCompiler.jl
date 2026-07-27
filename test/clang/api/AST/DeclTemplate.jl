using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

@testset "template navigation" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "template<typename T, int N> struct S { T x; };")
    f = DeclFinder(I)
    @test f(I, "S")
    ctd = ClangCompiler.ClassTemplateDecl(get_decl(f).ptr)
    tpl = ClangCompiler.getTemplateParameters(ctd)
    @test ClangCompiler.getMinRequiredArguments(tpl) == 2
    ttp = ClangCompiler.TemplateTypeParmDecl(ClangCompiler.getParam(tpl, 0).ptr)
    @test ClangCompiler.getDepth(ttp) == 0
    @test ClangCompiler.getIndex(ttp) == 0
    @test !ClangCompiler.isParameterPack(ttp)
    @test ClangCompiler.getName(ClangCompiler.getTemplatedDecl(ctd)) == "S"
    dispose(f)
    dispose(I)
end

@testset "specialized template PointerUnion split" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, """
    template<typename T> struct PuBox { T v; };
    template<typename T> struct PuBox<T*> { T* p; };
    PuBox<int> pu_bi;
    PuBox<int*> pu_bp;
    """)
    ctx = ClangCompiler.get_ast_context(I)
    f = DeclFinder(I)
    for (var, on_partial, armty) in
        (("pu_bi", false, ClangCompiler.ClassTemplateDecl),
         ("pu_bp", true, ClangCompiler.ClassTemplatePartialSpecializationDecl))
        @test f(I, var)
        qt = ClangCompiler.getType(ClangCompiler.VarDecl(get_decl(f).ptr))
        canon = ClangCompiler.get_qual_type(ClangCompiler.getTypePtr(qt))
        rt = ClangCompiler.resolve(ClangCompiler.getTypePtr(canon))
        spec = ClangCompiler.ClassTemplateSpecializationDecl(ClangCompiler.getDecl(rt).ptr)
        @test ClangCompiler.specializedOnPartial(spec) == on_partial
        arm = ClangCompiler.getSpecializedTemplateOrPartial(spec)
        @test arm isa armty
        # the collapsed accessor always lands on the ClassTemplateDecl arm
        @test ClangCompiler.getSpecializedTemplate(spec) isa ClangCompiler.ClassTemplateDecl
    end
    dispose(f)
    dispose(I)
end

import ClangCompiler as CC
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
    # FunctionTemplateDecl overrides getCanonicalDecl to return FunctionTemplateDecl*,
    # so the wrapper carries the precise class rather than the Redeclarable base.
    @test CC.getCanonicalDecl(ftd) isa CC.FunctionTemplateDecl
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
        @test CC.data(args) isa CC.TemplateArgument
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
    @test CC.getParent(tudc) isa CC.DeclContext
    @test CC.getLexicalParent(tudc) isa CC.DeclContext
    @test CC.getLookupParent(tudc) isa CC.DeclContext
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
    @test CC.containsDecl(tudc, fd) isa Bool            # returns the membership bool, not nothing
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

@testset "Coverage | DeclTemplate subclass sweep" begin
    I = create_interpreter(String[])
    src = """
    template <typename T, int N> struct S { T data; };
    template <typename U> U identity(U v) { return v; }
    template <typename T> T vtmpl = T();
    template <typename T> using AliasT = T *;
    template <typename T> struct PB { T v; };
    template <typename T> struct PB<T *> { T *p; };
    PB<int *> pb_use;
    """
    CC.parse(I, src)
    f = DeclFinder(I)

    # ---------- ClassTemplateDecl (S): base + TemplateParameterList locs ----------
    @test f(I, "S")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    # ClassTemplateDecl overrides getInstantiatedFromMemberTemplate to return its own
    # class, so the wrapper carries ClassTemplateDecl, not the Redeclarable base.
    @test CC.getInstantiatedFromMemberTemplate(ctd) isa CC.ClassTemplateDecl
    tpl = CC.getTemplateParameters(ctd)
    @test CC.getTemplateLoc(tpl) isa CC.SourceLocation
    @test CC.getLAngleLoc(tpl) isa CC.SourceLocation
    @test CC.getRAngleLoc(tpl) isa CC.SourceLocation

    # ---------- FunctionTemplateDecl (identity) ----------
    @test f(I, "identity")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d.ptr)
            break
        end
    end
    @test ftd isa CC.FunctionTemplateDecl
    @test CC.getTemplatedDecl(ftd) isa CC.FunctionDecl
    @test CC.isThisDeclarationADefinition(ftd) isa Bool
    @test CC.isAbbreviated(ftd) isa Bool
    @test CC.getInstantiatedFromMemberTemplate(ftd) isa CC.FunctionTemplateDecl

    # ---------- VarTemplateDecl (vtmpl) ----------
    if f(I, "vtmpl")
        vnd = get_decl(f)
        if CC.getDeclKindName(vnd) == "VarTemplate"
            vtd = CC.VarTemplateDecl(vnd.ptr)
            @test CC.getTemplatedDecl(vtd) isa CC.VarDecl
            @test CC.isThisDeclarationADefinition(vtd) isa Bool
        end
    end

    # ---------- TypeAliasTemplateDecl (AliasT) ----------
    if f(I, "AliasT")
        atd_nd = get_decl(f)
        if CC.getDeclKindName(atd_nd) == "TypeAliasTemplate"
            tatd = CC.TypeAliasTemplateDecl(atd_nd.ptr)
            @test CC.getTemplatedDecl(tatd) isa CC.TypeAliasDecl
        end
    end

    # ---------- ClassTemplatePartialSpecializationDecl (PB<T*>) ----------
    @test f(I, "pb_use")
    vd = CC.VarDecl(get_decl(f).ptr)
    qt = CC.getType(vd)
    canon = CC.get_qual_type(CC.getTypePtr(qt))
    rt = CC.resolve(CC.getTypePtr(canon))
    spec = CC.ClassTemplateSpecializationDecl(CC.getDecl(rt).ptr)
    @test CC.specializedOnPartial(spec)
    partial = CC.getSpecializedTemplateOrPartial(spec)
    @test partial isa CC.ClassTemplatePartialSpecializationDecl
    @test CC.getTemplateParameters(partial) isa CC.TemplateParameterList
    @test CC.hasAssociatedConstraints(partial) isa Bool
    @test CC.isMemberSpecialization(partial) isa Bool
    @test CC.getInstantiatedFromMember(partial) isa CC.ClassTemplatePartialSpecializationDecl

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate specialization + concept tail" begin
    I = create_interpreter(["-std=c++20"])
    src = """
    template <typename T> struct CT { T v; };
    CT<int> ct_use;

    template <typename T> T vpi = T();
    template <> int vpi<int> = 7;

    template <typename T> concept Small = sizeof(T) <= 8;
    """
    CC.parse(I, src)
    f = DeclFinder(I)

    # ---------- ClassTemplateSpecializationDecl (CT<int>) ----------
    @test f(I, "ct_use")
    vd = CC.VarDecl(get_decl(f).ptr)
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test specrec isa CC.CXXRecordDecl
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        cspec = CC.ClassTemplateSpecializationDecl(specrec.ptr)
        @test CC.getMostRecentDecl(cspec) isa CC.ClassTemplateSpecializationDecl
        @test CC.getPointOfInstantiation(cspec) isa CC.SourceLocation
        @test CC.isExplicitSpecialization(cspec) isa Bool
        @test CC.isExplicitInstantiationOrSpecialization(cspec) isa Bool
    end

    # ---------- VarTemplateSpecializationDecl (vpi<int>) ----------
    tu = CC.getTranslationUnitDecl(vd)
    vtsd = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        if d isa CC.VarTemplateSpecializationDecl
            vtsd = d
            break
        end
    end
    @test vtsd isa CC.VarTemplateSpecializationDecl
    if vtsd isa CC.VarTemplateSpecializationDecl
        @test CC.getMostRecentDecl(vtsd) isa CC.VarTemplateSpecializationDecl
        @test CC.getSpecializedTemplate(vtsd) isa CC.VarTemplateDecl
        @test (CC.getSpecializationKind(vtsd); true)
        @test CC.isExplicitSpecialization(vtsd) isa Bool
        @test CC.isExplicitInstantiationOrSpecialization(vtsd) isa Bool
        @test CC.getPointOfInstantiation(vtsd) isa CC.SourceLocation
        @test CC.getExternLoc(vtsd) isa CC.SourceLocation
        @test CC.getTemplateKeywordLoc(vtsd) isa CC.SourceLocation
        on_partial = CC.specializedOnPartial(vtsd)
        @test on_partial isa Bool
        arm = CC.getSpecializedTemplateOrPartial(vtsd)
        @test arm isa (on_partial ? CC.VarTemplatePartialSpecializationDecl : CC.VarTemplateDecl)
    end

    # ---------- ConceptDecl (Small) ----------
    if f(I, "Small")
        cnd = get_decl(f)
        if CC.getDeclKindName(cnd) == "Concept"
            cd = CC.ConceptDecl(cnd.ptr)
            @test CC.getConstraintExpr(cd) isa CC.Expr_
            @test CC.isTypeConcept(cd) isa Bool
            @test CC.getCanonicalDecl(cd) isa CC.ConceptDecl
            @test CC.getSourceRange(cd) isa CC.SourceRange
        end
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate specialization/partial getters" begin
    I = create_interpreter(["-std=c++20"])
    src = """
    template <typename T> struct CT { T v; };
    CT<int> ct_use;

    template <typename T> T vbox = T();
    template <typename T> T *vbox<T *> = static_cast<T *>(nullptr);
    template <> int vbox<int> = 7;
    int *vbox_use = vbox<int *>;
    """
    CC.parse(I, src)
    f = DeclFinder(I)

    # ---------- TemplateDecl base methods (via the ClassTemplateDecl CT) ----------
    @test f(I, "CT")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    @test CC.hasAssociatedConstraints(ctd) isa Bool   # AbstractTemplateDecl path
    @test CC.isTypeAlias(ctd) isa Bool
    @test !CC.isTypeAlias(ctd)                         # a class template is not an alias

    # ---------- ClassTemplateSpecializationDecl (CT<int>) ----------
    @test f(I, "ct_use")
    vd = CC.VarDecl(get_decl(f).ptr)
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test specrec isa CC.CXXRecordDecl
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        cspec = CC.ClassTemplateSpecializationDecl(specrec.ptr)
        @test CC.isClassScopeExplicitSpecialization(cspec) isa Bool
        @test CC.getTemplateInstantiationArgs(cspec) isa CC.TemplateArgumentList
        @test CC.getTypeAsWritten(cspec) isa CC.TypeSourceInfo
        @test CC.getExternLoc(cspec) isa CC.SourceLocation
        @test CC.getTemplateKeywordLoc(cspec) isa CC.SourceLocation
        @test CC.getSourceRange(cspec) isa CC.SourceRange
    end

    # ---------- VarTemplateSpecializationDecl + its partial specialization ----------
    tu = CC.getTranslationUnitDecl(vd)
    vtsd = nothing
    vtpsd = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        if d isa CC.VarTemplatePartialSpecializationDecl
            vtpsd = d
        elseif d isa CC.VarTemplateSpecializationDecl
            vtsd = d
        end
    end
    # Backstop: reach the partial through a partial-backed specialization's arm.
    if vtpsd === nothing && vtsd isa CC.VarTemplateSpecializationDecl &&
       CC.specializedOnPartial(vtsd)
        arm = CC.getSpecializedTemplateOrPartial(vtsd)
        arm isa CC.VarTemplatePartialSpecializationDecl && (vtpsd = arm)
    end

    @test vtsd isa CC.VarTemplateSpecializationDecl
    if vtsd isa CC.VarTemplateSpecializationDecl
        @test CC.isClassScopeExplicitSpecialization(vtsd) isa Bool
        @test CC.getTemplateInstantiationArgs(vtsd) isa CC.TemplateArgumentList
        @test CC.getTypeAsWritten(vtsd) isa CC.TypeSourceInfo
        @test CC.getSourceRange(vtsd) isa CC.SourceRange
    end

    @test vtpsd isa CC.VarTemplatePartialSpecializationDecl
    if vtpsd isa CC.VarTemplatePartialSpecializationDecl
        @test CC.getTemplateParameters(vtpsd) isa CC.TemplateParameterList
        @test CC.hasAssociatedConstraints(vtpsd) isa Bool
        @test CC.isMemberSpecialization(vtpsd) isa Bool
        @test CC.getInstantiatedFromMember(vtpsd) isa CC.VarTemplatePartialSpecializationDecl
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate specialization info + parameter tails" begin
    I = create_interpreter(["-std=c++20"])
    src = """
    template <typename T> T dt_ident(T v) { return v; }
    template <> int dt_ident<int>(int v) { return v + 1; }

    template <typename T> struct DtOuter { struct DtInner { T v; }; };
    DtOuter<int>::DtInner dt_inner_use;

    template <typename T> struct DtTtpArg { T v; };
    template <template <typename> class C = DtTtpArg> struct DtTtpBox { C<int> c; };
    DtTtpBox<> dt_ttp_use;

    template <int N = 4> struct DtNttBox { int a[N]; };
    DtNttBox<> dt_ntt_use;

    template <typename T> concept DtAny = true;
    template <DtAny auto V> struct DtNttC { int v = V; };
    """
    CC.parse(I, src)
    f = DeclFinder(I)

    # ---------- MemberSpecializationInfo (DtOuter<int>::DtInner) ----------
    @test f(I, "dt_inner_use")
    ivd = CC.VarDecl(get_decl(f).ptr)
    innerrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(ivd)))
    @test innerrec isa CC.CXXRecordDecl
    if innerrec.ptr != C_NULL
        msi = CC.getMemberSpecializationInfo(innerrec)
        @test msi isa CC.MemberSpecializationInfo
        if msi.ptr != C_NULL
            @test CC.getInstantiatedFrom(msi) isa CC.NamedDecl
            @test CC.getName(CC.getInstantiatedFrom(msi)) == "DtInner"
            @test CC.getTemplateSpecializationKind(msi) isa CC.CXTemplateSpecializationKind
            @test CC.isExplicitSpecialization(msi) isa Bool
            @test !CC.isExplicitSpecialization(msi)   # implicitly instantiated member
            @test CC.getPointOfInstantiation(msi) isa CC.SourceLocation
        end
    end

    # ---------- FunctionTemplateSpecializationInfo (dt_ident<int>) ----------
    tu = CC.getTranslationUnitDecl(ivd)
    ftsi = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        d isa CC.AbstractFunctionDecl || continue
        CC.getDeclKindName(d) == "Function" || continue   # keeps getName() identifier-safe
        CC.isFunctionTemplateSpecialization(d) || continue
        info = CC.getTemplateSpecializationInfo(d)
        info.ptr == C_NULL || (ftsi = info; break)
    end
    @test ftsi isa CC.FunctionTemplateSpecializationInfo
    if ftsi isa CC.FunctionTemplateSpecializationInfo
        @test CC.getFunction(ftsi) isa CC.FunctionDecl
        @test CC.getName(CC.getFunction(ftsi)) == "dt_ident"
        @test CC.getTemplate(ftsi) isa CC.FunctionTemplateDecl
        @test CC.getName(CC.getTemplate(ftsi)) == "dt_ident"
        @test CC.getTemplateSpecializationKind(ftsi) isa CC.CXTemplateSpecializationKind
        @test CC.isExplicitSpecialization(ftsi) isa Bool
        @test CC.isExplicitInstantiationOrSpecialization(ftsi) isa Bool
        @test CC.getPointOfInstantiation(ftsi) isa CC.SourceLocation
        # NULL unless the specialization is also a class-template member specialization
        @test CC.getMemberSpecializationInfo(ftsi) isa CC.MemberSpecializationInfo
    end

    # ---------- TemplateTemplateParmDecl (DtTtpBox's C) ----------
    @test f(I, "DtTtpBox")
    ttpbox = CC.ClassTemplateDecl(get_decl(f).ptr)
    p0 = CC.getParam(CC.getTemplateParameters(ttpbox), 0)
    @test CC.getDeclKindName(p0) == "TemplateTemplateParm"
    ttp = CC.TemplateTemplateParmDecl(p0.ptr)
    @test CC.isPackExpansion(ttp) isa Bool
    @test !CC.isPackExpansion(ttp)
    @test CC.isExpandedParameterPack(ttp) isa Bool
    @test !CC.isExpandedParameterPack(ttp)
    @test CC.hasDefaultArgument(ttp)
    @test CC.getDefaultArgumentLoc(ttp) isa CC.SourceLocation
    @test CC.isValid(CC.getDefaultArgumentLoc(ttp)) isa Bool
    @test CC.defaultArgumentWasInherited(ttp) isa Bool
    @test !CC.defaultArgumentWasInherited(ttp)   # written on this very declaration
    # both expansion accessors restate the isExpandedParameterPack precondition
    @test_throws AssertionError CC.getNumExpansionTemplateParameters(ttp)
    @test_throws AssertionError CC.getExpansionTemplateParameters(ttp, 0)

    # ---------- NonTypeTemplateParmDecl (DtNttBox's N) ----------
    @test f(I, "DtNttBox")
    nttbox = CC.ClassTemplateDecl(get_decl(f).ptr)
    n0 = CC.getParam(CC.getTemplateParameters(nttbox), 0)
    @test CC.getDeclKindName(n0) == "NonTypeTemplateParm"
    nttp = CC.NonTypeTemplateParmDecl(n0.ptr)
    @test CC.defaultArgumentWasInherited(nttp) isa Bool
    @test !CC.defaultArgumentWasInherited(nttp)
    @test CC.isPackExpansion(nttp) isa Bool
    @test !CC.isPackExpansion(nttp)
    @test CC.getPlaceholderTypeConstraint(nttp) isa CC.Expr_
    @test CC.getPlaceholderTypeConstraint(nttp).ptr == C_NULL   # plain `int` parameter

    # a constrained placeholder (`DtAny auto V`) carries the constraint expression
    if f(I, "DtNttC")
        c0 = CC.getParam(CC.getTemplateParameters(CC.ClassTemplateDecl(get_decl(f).ptr)), 0)
        if CC.getDeclKindName(c0) == "NonTypeTemplateParm"
            cnttp = CC.NonTypeTemplateParmDecl(c0.ptr)
            @test CC.getPlaceholderTypeConstraint(cnttp) isa CC.Expr_
            @test CC.hasPlaceholderTypeConstraint(cnttp) ==
                  (CC.getPlaceholderTypeConstraint(cnttp).ptr != C_NULL)
        end
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate redeclaration chains + partial specializations" begin
    I = create_interpreter(["-std=c++17"])
    src = """
    template <typename T> struct PSX { T v; };
    template <typename T> struct PSX<T *> { T *p; };
    template <typename T> struct PSX<T &> { T &r; };
    PSX<int> psx_i;
    PSX<int *> psx_p;

    template <typename T> using PSXAlias = PSX<T>;
    PSXAlias<int> psx_alias;

    template <typename T> T tvarx = T();
    template <typename T> T *tvarx<T *> = nullptr;
    template <> int tvarx<int> = 7;
    int tvarx_use = tvarx<int>;
    int *tvarx_use2 = tvarx<int *>;

    template <typename T> T ftplx(T v);
    template <typename T> T ftplx(T v) { return v; }
    int ftplx_use = ftplx<int>(1);
    """
    CC.parse(I, src)
    f = DeclFinder(I)

    # ---------- ClassTemplateDecl: partial-specialization list (count + fill) ----------
    @test f(I, "PSX")
    ctd = CC.ClassTemplateDecl(get_decl(f))
    @test ctd isa CC.ClassTemplateDecl
    @test CC.getNumPartialSpecializations(ctd) == 2      # PSX<T*> and PSX<T&>
    ps = CC.getPartialSpecializations(ctd)
    @test length(ps) == 2
    @test all(p -> p isa CC.ClassTemplatePartialSpecializationDecl, ps)
    @test all(p -> p.ptr != C_NULL, ps)
    @test CC.getInjectedClassNameSpecialization(ctd) isa CC.QualType

    p0 = ps[1]
    @test CC.getMostRecentDecl(p0) isa CC.ClassTemplatePartialSpecializationDecl
    @test CC.getMostRecentDecl(p0).ptr != C_NULL
    @test CC.getTemplateArgsAsWritten(p0) isa CC.ASTTemplateArgumentListInfo
    tfd = CC.getTypeForDecl(p0)
    if tfd != C_NULL && CC.is_injected_class_name_type(CC.Type_(tfd))
        ist = CC.getInjectedSpecializationType(p0)
        @test ist isa CC.QualType
        # round trip: the injected specialization type finds its own partial spec
        hit = CC.findPartialSpecialization(ctd, ist)
        @test hit isa CC.ClassTemplatePartialSpecializationDecl
        @test hit.ptr != C_NULL
    end

    # ---------- TypeAliasTemplateDecl redeclaration chain ----------
    @test f(I, "PSXAlias")
    tatd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "TypeAliasTemplate"
            tatd = CC.TypeAliasTemplateDecl(d.ptr)
            break
        end
    end
    @test tatd isa CC.TypeAliasTemplateDecl
    if tatd isa CC.TypeAliasTemplateDecl
        @test CC.getCanonicalDecl(tatd) isa CC.TypeAliasTemplateDecl
        @test CC.getCanonicalDecl(tatd).ptr != C_NULL
        @test CC.getPreviousDecl(tatd) isa CC.TypeAliasTemplateDecl
    end

    # ---------- FunctionTemplateDecl redeclaration chain ----------
    @test f(I, "ftplx")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d.ptr)
            break
        end
    end
    @test ftd isa CC.FunctionTemplateDecl
    if ftd isa CC.FunctionTemplateDecl
        @test CC.getCanonicalDecl(ftd) isa CC.FunctionTemplateDecl
        @test CC.getCanonicalDecl(ftd).ptr != C_NULL
        @test CC.getMostRecentDecl(ftd) isa CC.FunctionTemplateDecl
        @test CC.getMostRecentDecl(ftd).ptr != C_NULL
        @test CC.getPreviousDecl(ftd) isa CC.FunctionTemplateDecl
    end

    # ---------- VarTemplateDecl chain + partial specializations ----------
    @test f(I, "tvarx")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d.ptr)
            break
        end
    end
    @test vtd isa CC.VarTemplateDecl
    if vtd isa CC.VarTemplateDecl
        @test CC.getCanonicalDecl(vtd) isa CC.VarTemplateDecl
        @test CC.getCanonicalDecl(vtd).ptr != C_NULL
        @test CC.getMostRecentDecl(vtd) isa CC.VarTemplateDecl
        @test CC.getMostRecentDecl(vtd).ptr != C_NULL
        @test CC.getPreviousDecl(vtd) isa CC.VarTemplateDecl
        @test CC.getDefinition(vtd) isa CC.VarTemplateDecl
        @test CC.getNumPartialSpecializations(vtd) == 1  # tvarx<T*>
        vps = CC.getPartialSpecializations(vtd)
        @test length(vps) == 1
        @test vps[1] isa CC.VarTemplatePartialSpecializationDecl
        @test vps[1].ptr != C_NULL
        @test CC.getTemplateArgsAsWritten(vps[1]) isa CC.ASTTemplateArgumentListInfo
    end

    # ---------- VarTemplateSpecializationDecl as-written arguments ----------
    tu = CC.getTranslationUnitDecl(ctd)
    vspec = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        if d isa CC.VarTemplateSpecializationDecl
            vspec = d
            break
        end
    end
    @test vspec isa CC.VarTemplateSpecializationDecl
    if vspec isa CC.VarTemplateSpecializationDecl
        @test CC.getTemplateArgsInfo(vspec) isa CC.ASTTemplateArgumentListInfo
    end

    dispose(f)
    dispose(I)
end

@testset "DeclTemplate constraints, injected args and parameter objects" begin
    I = create_interpreter(["-std=c++20"])
    src = """
    template <typename T>
        requires(sizeof(T) > 0)
    struct DtfCon { T v; };
    template <typename T, typename U> struct DtfPair { T a; U b; };
    template <typename T> struct DtfPair<T, T *> { T a; };
    DtfPair<int, int *> dtf_pp;
    template <typename T> using DtfAlias = T *;
    template <typename T> constexpr int dtf_var = 1;
    template <typename T> constexpr int dtf_var<T *> = 2;
    constexpr int dtf_var_use = dtf_var<int *>;
    template <typename T> T dtf_identity(T x) { return x; }
    template <typename A = int, int N = 3, template <typename> class C = DtfAlias>
    struct DtfDefaults {};
    struct DtfPoint { int x; int y; };
    template <DtfPoint P> struct DtfObj { static constexpr int k = P.x; };
    DtfObj<DtfPoint{1, 2}> dtf_obj;
    """
    CC.parse(I, src)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # ---------- associated constraints: parameter list and template ----------
    @test f(I, "DtfCon")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    tpl = CC.getTemplateParameters(ctd)
    @test CC.containsUnexpandedParameterPack(tpl) isa Bool
    @test !CC.containsUnexpandedParameterPack(tpl)
    @test CC.hasAssociatedConstraints(tpl)
    plc = CC.getAssociatedConstraints(tpl)
    @test plc isa Vector{CC.Expr_}
    @test length(plc) >= 1
    @test all(e -> e.ptr != C_NULL, plc)
    tdc = CC.getAssociatedConstraints(ctd)
    @test tdc isa Vector{CC.Expr_}
    @test length(tdc) == length(plc)

    # ---------- injected template arguments (borrowed, count + index) ----------
    inj = CC.getInjectedTemplateArgs(ctd)
    @test inj isa Vector{CC.TemplateArgument}
    @test length(inj) == 1
    @test all(a -> a.ptr != C_NULL, inj)
    @test CC.getInstantiatedFromMemberTemplate(ctd) isa CC.ClassTemplateDecl

    # ---------- default arguments of the three parameter kinds ----------
    @test f(I, "DtfDefaults")
    dtd = CC.ClassTemplateDecl(get_decl(f).ptr)
    dpl = CC.getTemplateParameters(dtd)
    ttp = CC.TemplateTypeParmDecl(CC.getParam(dpl, 0).ptr)
    @test CC.isPackExpansion(ttp) isa Bool
    @test !CC.isPackExpansion(ttp)
    @test CC.hasDefaultArgument(ttp)
    @test CC.getDefaultArgumentLoc(ttp) isa CC.SourceLocation
    @test CC.isValid(CC.getDefaultArgumentLoc(ttp))
    nttp = CC.NonTypeTemplateParmDecl(CC.getParam(dpl, 1).ptr)
    @test CC.hasDefaultArgument(nttp)
    @test CC.getDefaultArgumentLoc(nttp) isa CC.SourceLocation
    @test CC.isValid(CC.getDefaultArgumentLoc(nttp))
    ttpp = CC.TemplateTemplateParmDecl(CC.getParam(dpl, 2).ptr)
    @test CC.hasDefaultArgument(ttpp)
    tal = CC.getDefaultArgument(ttpp)
    @test tal isa CC.TemplateArgumentLoc
    @test tal.ptr != C_NULL

    # ---------- BuiltinTemplateDecl kind ----------
    mis = CC.getMakeIntegerSeqDecl(ctx)
    @test mis isa CC.BuiltinTemplateDecl
    @test CC.getBuiltinTemplateKind(mis) ==
          CC.LibClangEx.CXBuiltinTemplateKind_BTK__make_integer_seq
    tpe = CC.getTypePackElementDecl(ctx)
    @test tpe isa CC.BuiltinTemplateDecl
    @test CC.getBuiltinTemplateKind(tpe) ==
          CC.LibClangEx.CXBuiltinTemplateKind_BTK__type_pack_element

    # ---------- TemplateParamObjectDecl reached through its template argument ----------
    @test f(I, "dtf_obj")
    oqt = CC.getType(CC.VarDecl(get_decl(f).ptr))
    ocanon = CC.get_qual_type(CC.getTypePtr(oqt))
    ort = CC.resolve(CC.getTypePtr(ocanon))
    ospec = CC.ClassTemplateSpecializationDecl(CC.getDecl(ort).ptr)
    oargs = CC.getTemplateArgs(ospec)
    ta = Base.get(oargs, 0)
    @test CC.getKind(ta) == CC.LibClangEx.CXTemplateArgument_Declaration
    tpo = CC.resolve(CC.getAsDecl(ta))
    @test tpo isa CC.TemplateParamObjectDecl
    if tpo isa CC.TemplateParamObjectDecl
        @test CC.getValue(tpo) isa CC.APValue
        @test CC.getValue(tpo).ptr != C_NULL
        @test CC.getCanonicalDecl(tpo) isa CC.TemplateParamObjectDecl
        @test CC.getCanonicalDecl(tpo).ptr != C_NULL
        @test CC.printAsExpr(tpo) isa String
        @test !isempty(CC.printAsExpr(tpo))
        @test CC.printAsInit(tpo) isa String
        @test !isempty(CC.printAsInit(tpo))
    end

    # ---------- narrowed member-template accessors on the other template kinds ----------
    @test f(I, "DtfAlias")
    tatd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "TypeAliasTemplate"
            tatd = CC.TypeAliasTemplateDecl(d.ptr)
            break
        end
    end
    @test tatd isa CC.TypeAliasTemplateDecl
    if tatd isa CC.TypeAliasTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(tatd) isa CC.TypeAliasTemplateDecl
    end

    @test f(I, "dtf_identity")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d.ptr)
            break
        end
    end
    @test ftd isa CC.FunctionTemplateDecl
    if ftd isa CC.FunctionTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(ftd) isa CC.FunctionTemplateDecl
        @test length(CC.getInjectedTemplateArgs(ftd)) == 1
    end

    @test f(I, "dtf_var")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d.ptr)
            break
        end
    end
    @test vtd isa CC.VarTemplateDecl
    if vtd isa CC.VarTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(vtd) isa CC.VarTemplateDecl
        vps = CC.getPartialSpecializations(vtd)
        @test length(vps) == 1
        @test CC.getMostRecentDecl(vps[1]) isa CC.VarTemplatePartialSpecializationDecl
        @test CC.getMostRecentDecl(vps[1]).ptr != C_NULL
    end

    @test f(I, "DtfPair")
    ptd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "ClassTemplate"
            ptd = CC.ClassTemplateDecl(d.ptr)
            break
        end
    end
    @test ptd isa CC.ClassTemplateDecl
    if ptd isa CC.ClassTemplateDecl
        pps = CC.getPartialSpecializations(ptd)
        @test length(pps) == 1
        @test CC.getInstantiatedFromMemberTemplate(pps[1]) isa
              CC.ClassTemplatePartialSpecializationDecl
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate specialization sets, parm positions, list printing" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <typename T, int N = 3> struct SgBox { T v; };
    template <typename T = int> struct SgDef { T v; };
    template <typename U> struct SgOne { U u; };
    template <template <typename> class Tmpl> struct SgTT { Tmpl<int> t; };
    template <typename T> T sg_fn(T x) { return x; }
    template <typename T> constexpr T sg_var = T(1);
    SgBox<int> sg_bi;
    SgBox<double, 4> sg_bd;
    int sg_use() {
      return sg_fn<int>(1) + (int)sg_fn<char>('a') + (int)sg_var<int> + (int)sg_var<double>;
    }
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # ---------- ClassTemplateDecl: the specialization set ----------
    @test f(I, "SgBox")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    CC.LoadLazySpecializations(ctd)          # no external AST source: a no-op
    n = CC.getNumSpecializations(ctd)
    @test n isa Int
    @test n == 2                             # SgBox<int, 3> and SgBox<double, 4>
    cspecs = CC.getSpecializations(ctd)
    @test length(cspecs) == n
    @test all(s -> s isa CC.ClassTemplateSpecializationDecl, cspecs)
    @test all(s -> s.ptr != C_NULL, cspecs)
    @test all(s -> CC.getName(s) == "SgBox", cspecs)

    # ---------- TemplateParameterList printing ----------
    tpl = CC.getTemplateParameters(ctd)
    s = CC.print(tpl, ctx)
    @test s isa String
    @test occursin("template", s)
    @test occursin("<", s) && occursin(">", s)
    bare = CC.print(tpl, ctx, true)
    @test bare isa String
    @test !occursin("template", bare)        # OmitTemplateKW drops the keyword only
    @test occursin("<", bare) && occursin(">", bare)
    @test length(bare) < length(s)

    # ---------- TemplateTypeParmDecl: default-argument info + typename flag ----------
    p0 = CC.getParam(tpl, 0)
    @test CC.getDeclKindName(p0) == "TemplateTypeParm"
    ttp = CC.TemplateTypeParmDecl(p0.ptr)
    @test !CC.hasDefaultArgument(ttp)
    tsi = CC.getDefaultArgumentInfo(ttp)
    @test tsi isa CC.TypeSourceInfo
    @test tsi.ptr == C_NULL                  # `typename T` carries no default
    was = CC.wasDeclaredWithTypename(ttp)
    @test was isa Bool
    # round-trip: T has no type constraint, so the flag reads back exactly
    CC.setDeclaredWithTypename(ttp, !was)
    @test CC.wasDeclaredWithTypename(ttp) == !was
    CC.setDeclaredWithTypename(ttp, was)
    @test CC.wasDeclaredWithTypename(ttp) == was

    @test f(I, "SgDef")
    dtd = CC.ClassTemplateDecl(get_decl(f).ptr)
    d0 = CC.TemplateTypeParmDecl(CC.getParam(CC.getTemplateParameters(dtd), 0).ptr)
    @test CC.hasDefaultArgument(d0)
    dtsi = CC.getDefaultArgumentInfo(d0)
    @test dtsi isa CC.TypeSourceInfo
    @test dtsi.ptr != C_NULL                 # `typename T = int`

    # ---------- NonTypeTemplateParmDecl: position + expansion-type guard ----------
    n1 = CC.getParam(tpl, 1)
    @test CC.getDeclKindName(n1) == "NonTypeTemplateParm"
    nttp = CC.NonTypeTemplateParmDecl(n1.ptr)
    @test CC.getPosition(nttp) == CC.getIndex(nttp)   # one stored field, two names
    @test CC.getPosition(nttp) == 1
    @test !CC.isExpandedParameterPack(nttp)
    @test_throws AssertionError CC.getExpansionTypeSourceInfo(nttp, 0)

    # ---------- TemplateTemplateParmDecl: position ----------
    @test f(I, "SgTT")
    ttd = CC.ClassTemplateDecl(get_decl(f).ptr)
    t0 = CC.getParam(CC.getTemplateParameters(ttd), 0)
    @test CC.getDeclKindName(t0) == "TemplateTemplateParm"
    ttpp = CC.TemplateTemplateParmDecl(t0.ptr)
    @test CC.getPosition(ttpp) == CC.getIndex(ttpp)
    @test CC.getPosition(ttpp) == 0

    # ---------- FunctionTemplateDecl: the specialization set ----------
    @test f(I, "sg_fn")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d.ptr)
            break
        end
    end
    @test ftd isa CC.FunctionTemplateDecl
    if ftd isa CC.FunctionTemplateDecl
        CC.LoadLazySpecializations(ftd)
        fn = CC.getNumSpecializations(ftd)
        @test fn isa Int
        @test fn == 2                        # sg_fn<int> and sg_fn<char>
        fspecs = CC.getSpecializations(ftd)
        @test length(fspecs) == fn
        @test all(s -> s isa CC.FunctionDecl, fspecs)
        @test all(s -> s.ptr != C_NULL, fspecs)
        @test all(s -> CC.getName(s) == "sg_fn", fspecs)
    end

    # ---------- VarTemplateDecl: the specialization set ----------
    @test f(I, "sg_var")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d.ptr)
            break
        end
    end
    @test vtd isa CC.VarTemplateDecl
    if vtd isa CC.VarTemplateDecl
        CC.LoadLazySpecializations(vtd)
        vn = CC.getNumSpecializations(vtd)
        @test vn isa Int
        @test vn == 2                        # sg_var<int> and sg_var<double>
        vspecs = CC.getSpecializations(vtd)
        @test length(vspecs) == vn
        @test all(s -> s isa CC.VarTemplateSpecializationDecl, vspecs)
        @test all(s -> s.ptr != C_NULL, vspecs)
        @test all(s -> CC.getName(s) == "sg_var", vspecs)
    end

    dispose(f)
    dispose(I)
end
