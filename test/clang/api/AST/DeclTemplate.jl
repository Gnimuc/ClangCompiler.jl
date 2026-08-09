using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

@testset "template navigation" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "template<typename T, int N> struct S { T x; };")
    f = DeclFinder(I)
    @test f(I, "S")
    ctd = ClangCompiler.ClassTemplateDecl(get_decl(f))
    tpl = ClangCompiler.getTemplateParameters(ctd)
    @test ClangCompiler.getMinRequiredArguments(tpl) == 2
    ttp = ClangCompiler.TemplateTypeParmDecl(ClangCompiler.getParam(tpl, 0))
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
        qt = ClangCompiler.getType(ClangCompiler.VarDecl(get_decl(f)))
        canon = ClangCompiler.get_qual_type(ClangCompiler.getTypePtr(qt))
        rt = ClangCompiler.resolve(ClangCompiler.getTypePtr(canon))
        spec = ClangCompiler.ClassTemplateSpecializationDecl(ClangCompiler.getDecl(rt))
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
    template <typename A, typename B> struct TwoTypes { A a; B b; };
    template <typename Outer> struct NestOuter {
        template <typename Inner> struct NestInner { Inner v; };
    };
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
    @test ctd.ptr != C_NULL && CC.getName(ctd) == "S"

    tpl = CC.getTemplateParameters(ctd)                 # TemplateDecl
    @test !CC.is_null_handle(tpl) && size(tpl) == 2
    @test size(tpl) == 2                                # TemplateParameterList size
    @test CC.getDepth(tpl) == 0
    @test CC.getMinRequiredArguments(tpl) == 2
    @test !(CC.hasParameterPack(tpl))

    p0 = CC.getParam(tpl, 0)                            # NamedDecl (T)
    @test p0.ptr != C_NULL && CC.getName(p0) == "T"
    ttp = CC.TemplateTypeParmDecl(p0)
    @test CC.getDepth(ttp) == 0
    @test CC.getIndex(ttp) == 0
    @test CC.isParameterPack(ttp) == false

    @test_throws AssertionError CC.getParam(tpl, size(tpl))  # the restated clang assert (Invariant 3)
    p1 = CC.getParam(tpl, 1)                            # NonTypeTemplateParmDecl (N)
    nttp = CC.NonTypeTemplateParmDecl(p1)
    @test CC.getDepth(nttp) == 0
    @test CC.getIndex(nttp) == 1
    @test CC.isParameterPack(nttp) == false

    # Both coordinates of a TYPE parameter were only ever read at 0 here, and a depth or an
    # index that ignores its subject reads as 0 too. `TwoTypes` gives the second index and
    # `NestOuter::NestInner` the second depth, so each accessor has to be doing something.
    @test f(I, "TwoTypes")
    two_tpl = CC.getTemplateParameters(CC.ClassTemplateDecl(get_decl(f)))
    @test size(two_tpl) == 2
    a_parm = CC.TemplateTypeParmDecl(CC.getParam(two_tpl, 0))
    b_parm = CC.TemplateTypeParmDecl(CC.getParam(two_tpl, 1))
    @test CC.getName(a_parm) == "A" && CC.getName(b_parm) == "B"
    @test CC.getIndex(a_parm) == 0
    @test CC.getIndex(b_parm) == 1
    @test CC.getDepth(a_parm) == CC.getDepth(b_parm) == 0

    # The inner template is a member, so it is reached through its enclosing record rather
    # than by name at the top level.
    CC.reset(f)
    @test f(I, "NestOuter")
    outer_rec = CC.getTemplatedDecl(CC.ClassTemplateDecl(get_decl(f)))
    inner_ctd = first(d for d in CC.decls_in(CC.castToDeclContext(outer_rec))
                      if d isa CC.AbstractClassTemplateDecl)
    @test CC.getName(inner_ctd) == "NestInner"
    inner_tpl = CC.getTemplateParameters(inner_ctd)
    inner_parm = CC.TemplateTypeParmDecl(CC.getParam(inner_tpl, 0))
    @test CC.getName(inner_parm) == "Inner"
    # nested one template deep, and still the first parameter of its own list
    @test CC.getDepth(inner_parm) == 1
    @test CC.getIndex(inner_parm) == 0
    @test CC.getDepth(inner_tpl) == 1
    CC.reset(f)

    # RedeclarableTemplateDecl / ClassTemplateDecl accessors on ctd
    trec = CC.getTemplatedDecl(ctd)                    # Redeclarable -> CXXRecordDecl
    @test trec.ptr != C_NULL && CC.getName(trec) == "S"
    @test !(CC.isMemberSpecialization(ctd))
    @test CC.isThisDeclarationADefinition(ctd) == true
    @test CC.getCanonicalDecl(ctd).ptr == ctd.ptr
    @test CC.getMostRecentDecl(ctd).ptr == ctd.ptr
    @test CC.getPreviousDecl(ctd).ptr == C_NULL

    # described-template navigation off the templated record
    dt = CC.getDescribedTemplate(trec)                 # TemplateDecl base carrier
    @test dt.ptr == ctd.ptr
    if dt.ptr != C_NULL
        @test CC.getTemplatedDecl(dt).ptr == trec.ptr # AbstractTemplateDecl path
    end
    @test !CC.is_null_handle(CC.getDescribedTemplateParams(trec))

    # ---------- FunctionTemplateDecl (identity) ----------
    # A function-template name lookup yields an overload-set result, so pull the
    # FunctionTemplate carrier out of the full result list.
    @test f(I, "identity")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d)
            break
        end
    end
    @test ftd !== nothing && ftd.ptr != C_NULL && CC.getName(ftd) == "identity"
    @test !CC.is_null_handle(CC.getTemplateParameters(ftd))
    # FunctionTemplateDecl overrides getCanonicalDecl to return FunctionTemplateDecl*,
    # so the wrapper carries the precise class rather than the Redeclarable base.
    @test CC.getCanonicalDecl(ftd).ptr == ftd.ptr
    @test !(CC.isMemberSpecialization(ftd))

    # ---------- ClassTemplateSpecializationDecl (S<int,5>) ----------
    @test f(I, "s_inst")
    vd = CC.VarDecl(get_decl(f))
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test specrec.ptr != C_NULL && CC.getName(specrec) == "S"
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        spec = CC.ClassTemplateSpecializationDecl(specrec)
        @test (CC.getSpecializationKind(spec); true)
        stpl = CC.getSpecializedTemplate(spec)
        @test stpl.ptr == ctd.ptr
        args = CC.getTemplateArgs(spec)                # TemplateArgumentList
        @test args.ptr != C_NULL && size(args) == 2
        @test size(args) == 2
        @test !CC.is_null_handle(CC.data(args))
        if size(args) > 0
            @test get(args, 0).ptr != C_NULL && CC.getKind(get(args, 0)) == CC.LibClangEx.CXTemplateArgument_Type
        end
        @test CC.findSpecialization(stpl, args).ptr == spec.ptr
    end

    # ---------- Decl base accessors (freefn) ----------
    @test f(I, "freefn")
    fd = CC.FunctionDecl(get_decl(f))
    @test !CC.is_null_handle(CC.getLocation(fd))
    @test !CC.is_null_handle(CC.getBeginLoc(fd))
    @test !CC.is_null_handle(CC.getEndLoc(fd))
    @test !isempty(CC.getDeclKindName(fd))
    @test (CC.getKind(fd); true)
    @test !(CC.hasAttrs(fd))
    @test CC.getNumAttrs(fd) == 0
    @test isempty(CC.getAttrs(fd))
    @test !CC.is_null_handle(CC.getNextDeclInContext(fd))
    @test !CC.is_null_handle(CC.getDeclContext(fd))
    @test !CC.is_null_handle(CC.getNonClosureContext(fd))
    tu = CC.getTranslationUnitDecl(fd)
    @test tu.ptr != C_NULL
    @test !(CC.isInAnonymousNamespace(fd))
    @test !(CC.isInStdNamespace(fd))
    @test !CC.is_null_handle(CC.getASTContext(fd))
    @test !CC.is_null_handle(CC.getLangOpts(fd))
    @test !CC.is_null_handle(CC.getLexicalDeclContext(fd))
    @test !(CC.isOutOfLine(fd))
    @test !(CC.isTemplated(fd))
    @test CC.getTemplateDepth(fd) == 0
    @test CC.isDefinedOutsideFunctionOrMethod(fd)
    @test !(CC.isInLocalScopeForInstantiation(fd))
    @test CC.is_null_handle(CC.getParentFunctionOrMethod(fd))
    # getCanonicalDecl/getMostRecentDecl on AbstractDecl are shadowed for named
    # decls; the non-named TranslationUnitDecl reaches the DeclBase fallbacks.
    @test CC.getCanonicalDecl(tu).ptr == tu.ptr
    @test CC.isCanonicalDecl(fd)
    @test CC.getPreviousDecl(fd).ptr == C_NULL
    @test CC.isFirstDecl(fd)
    @test CC.getMostRecentDecl(tu).ptr == tu.ptr
    @test !(CC.isTemplateParameter(fd))
    @test !(CC.isTemplateParameterPack(fd))
    @test CC.isParameterPack(fd) == false               # AbstractDecl path
    @test !(CC.isTemplateDecl(fd))
    @test CC.is_null_handle(CC.getDescribedTemplate(fd))
    @test CC.is_null_handle(CC.getDescribedTemplateParams(fd))
    @test !CC.is_null_handle(CC.getAsFunction(fd))
    @test CC.getID(fd) > 0
    @test CC.getFunctionType(fd).ptr != C_NULL
    @test (CC.dumpColor(fd); true)

    # the checked casts off a Decl: a function IS a ValueDecl and is NOT a constructor
    @test CC.ValueDecl(fd) == fd
    @test_throws CC.CastError CC.CXXConstructorDecl(fd)

    # ---------- attributed decl (depvar) ----------
    @test f(I, "depvar")
    dv = CC.VarDecl(get_decl(f))
    @test CC.hasAttrs(dv)
    if CC.getNumAttrs(dv) > 0
        @test !CC.is_null_handle(CC.getAttr(dv, 0))
    end

    # ---------- Decl <-> DeclContext pivot + DeclContext accessors ----------
    tudc = CC.castToDeclContext(tu)
    @test tudc.ptr != C_NULL
    @test !CC.is_null_handle(CC.castFromDeclContext(tudc))
    @test !CC.is_null_handle(CC.getParentASTContext(tudc))
    @test !isempty(CC.getDeclKindName(tudc))
    @test CC.getParent(tudc).ptr == C_NULL
    @test CC.is_null_handle(CC.getLexicalParent(tudc))
    @test CC.is_null_handle(CC.getLookupParent(tudc))
    @test !(CC.isClosure(tudc))
    @test !(CC.isFunctionOrMethod(tudc))
    @test CC.isLookupContext(tudc)
    @test CC.isFileContext(tudc)
    @test CC.isTranslationUnit(tudc)
    @test !(CC.isRecord(tudc))
    @test !(CC.isNamespace(tudc))
    @test !(CC.isStdNamespace(tudc))
    @test !(CC.isInlineNamespace(tudc))
    @test !(CC.is_dependent_context(tudc))
    @test !(CC.isTransparentContext(tudc))
    @test !(CC.isExternCContext(tudc))
    @test !(CC.isExternCXXContext(tudc))
    @test CC.Equals(tudc, tudc)
    @test !CC.is_null_handle(CC.getPrimaryContext(tudc))
    @test !CC.is_null_handle(CC.decl_iterator_begin(tudc))
    @test CC.containsDecl(tudc, fd) == true            # returns the membership bool, not nothing
    @test (CC.dumpDeclContext(tudc); true)
    @test (CC.dumpLookups(tudc); true)

    # record DeclContext casts
    recdc = CC.castToDeclContext(trec)
    @test recdc.ptr == CC.castToDeclContext(trec).ptr
    @test CC.isRecord(recdc)
    @test !CC.is_null_handle(CC.TagDecl(recdc))
    @test !CC.is_null_handle(CC.RecordDecl(recdc))
    @test !CC.is_null_handle(CC.CXXRecordDecl(recdc))

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
    ctd = CC.ClassTemplateDecl(get_decl(f))
    # ClassTemplateDecl overrides getInstantiatedFromMemberTemplate to return its own
    # class, so the wrapper carries ClassTemplateDecl, not the Redeclarable base.
    @test CC.getInstantiatedFromMemberTemplate(ctd).ptr == C_NULL
    tpl = CC.getTemplateParameters(ctd)
    @test !CC.is_null_handle(CC.getTemplateLoc(tpl))
    @test !CC.is_null_handle(CC.getLAngleLoc(tpl))
    @test !CC.is_null_handle(CC.getRAngleLoc(tpl))

    # ---------- FunctionTemplateDecl (identity) ----------
    @test f(I, "identity")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d)
            break
        end
    end
    @test ftd !== nothing && ftd.ptr != C_NULL && CC.getName(ftd) == "identity"
    @test CC.getTemplatedDecl(ftd).ptr != C_NULL && CC.getName(CC.getTemplatedDecl(ftd)) == "identity"
    @test CC.isThisDeclarationADefinition(ftd) == true
    @test !(CC.isAbbreviated(ftd))
    @test CC.getInstantiatedFromMemberTemplate(ftd).ptr == C_NULL

    # ---------- VarTemplateDecl (vtmpl) ----------
    if f(I, "vtmpl")
        vnd = get_decl(f)
        if CC.getDeclKindName(vnd) == "VarTemplate"
            vtd = CC.VarTemplateDecl(vnd)
            @test CC.getTemplatedDecl(vtd).ptr != C_NULL && CC.getName(CC.getTemplatedDecl(vtd)) == "vtmpl"
            @test CC.isThisDeclarationADefinition(vtd) == true
        end
    end

    # ---------- TypeAliasTemplateDecl (AliasT) ----------
    if f(I, "AliasT")
        atd_nd = get_decl(f)
        if CC.getDeclKindName(atd_nd) == "TypeAliasTemplate"
            tatd = CC.TypeAliasTemplateDecl(atd_nd)
            @test CC.getTemplatedDecl(tatd).ptr != C_NULL && CC.getName(CC.getTemplatedDecl(tatd)) == "AliasT"
        end
    end

    # ---------- ClassTemplatePartialSpecializationDecl (PB<T*>) ----------
    @test f(I, "pb_use")
    vd = CC.VarDecl(get_decl(f))
    qt = CC.getType(vd)
    canon = CC.get_qual_type(CC.getTypePtr(qt))
    rt = CC.resolve(CC.getTypePtr(canon))
    spec = CC.ClassTemplateSpecializationDecl(CC.getDecl(rt))
    @test CC.specializedOnPartial(spec)
    partial = CC.getSpecializedTemplateOrPartial(spec)
    @test partial.ptr != C_NULL && CC.getName(partial) == "PB"
    @test !CC.is_null_handle(CC.getTemplateParameters(partial))
    @test !(CC.hasAssociatedConstraints(partial))
    @test !(CC.isMemberSpecialization(partial))
    @test CC.getInstantiatedFromMember(partial).ptr == C_NULL

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
    vd = CC.VarDecl(get_decl(f))
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test specrec.ptr != C_NULL && CC.getName(specrec) == "CT"
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        cspec = CC.ClassTemplateSpecializationDecl(specrec)
        @test CC.getMostRecentDecl(cspec).ptr == cspec.ptr
        @test !CC.is_null_handle(CC.getPointOfInstantiation(cspec))
        @test !(CC.isExplicitSpecialization(cspec))
        @test !(CC.isExplicitInstantiationOrSpecialization(cspec))
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
    @test vtsd !== nothing && vtsd.ptr != C_NULL && CC.getName(vtsd) == "vpi"
    if vtsd isa CC.VarTemplateSpecializationDecl
        @test CC.getMostRecentDecl(vtsd).ptr == vtsd.ptr
        @test CC.getSpecializedTemplate(vtsd).ptr != C_NULL && CC.getName(CC.getSpecializedTemplate(vtsd)) == "vpi"
        @test (CC.getSpecializationKind(vtsd); true)
        @test CC.isExplicitSpecialization(vtsd)
        @test CC.isExplicitInstantiationOrSpecialization(vtsd)
        @test CC.is_null_handle(CC.getPointOfInstantiation(vtsd))
        @test CC.is_null_handle(CC.getExternLoc(vtsd))
        @test !CC.is_null_handle(CC.getTemplateKeywordLoc(vtsd))
        on_partial = CC.specializedOnPartial(vtsd)
        @test on_partial == false
        arm = CC.getSpecializedTemplateOrPartial(vtsd)
        @test arm.ptr != C_NULL && CC.getName(arm) == "vpi"
    end

    # ---------- ConceptDecl (Small) ----------
    if f(I, "Small")
        cnd = get_decl(f)
        if CC.getDeclKindName(cnd) == "Concept"
            cd = CC.ConceptDecl(cnd)
            @test !CC.is_null_handle(CC.getConstraintExpr(cd))
            @test CC.isTypeConcept(cd)
            @test CC.getCanonicalDecl(cd).ptr == cd.ptr
            @test CC.isValid(CC.getSourceRange(cd))
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
    ctd = CC.ClassTemplateDecl(get_decl(f))
    @test CC.hasAssociatedConstraints(ctd) == false   # AbstractTemplateDecl path
    @test !(CC.isTypeAlias(ctd))
    @test !CC.isTypeAlias(ctd)                         # a class template is not an alias

    # ---------- ClassTemplateSpecializationDecl (CT<int>) ----------
    @test f(I, "ct_use")
    vd = CC.VarDecl(get_decl(f))
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test specrec.ptr != C_NULL && CC.getName(specrec) == "CT"
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        cspec = CC.ClassTemplateSpecializationDecl(specrec)
        @test !(CC.isClassScopeExplicitSpecialization(cspec))
        @test !CC.is_null_handle(CC.getTemplateInstantiationArgs(cspec))
        @test CC.getTypeAsWritten(cspec).ptr == C_NULL
        @test CC.is_null_handle(CC.getExternLoc(cspec))
        @test CC.is_null_handle(CC.getTemplateKeywordLoc(cspec))
        @test CC.isValid(CC.getSourceRange(cspec))
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

    @test vtsd !== nothing && vtsd.ptr != C_NULL
    if vtsd isa CC.VarTemplateSpecializationDecl
        @test !(CC.isClassScopeExplicitSpecialization(vtsd))
        @test !CC.is_null_handle(CC.getTemplateInstantiationArgs(vtsd))
        @test CC.getTypeAsWritten(vtsd).ptr == C_NULL
        @test CC.isValid(CC.getSourceRange(vtsd))
    end

    @test vtpsd !== nothing && vtpsd.ptr != C_NULL && CC.getName(vtpsd) == "vbox"
    if vtpsd isa CC.VarTemplatePartialSpecializationDecl
        @test !CC.is_null_handle(CC.getTemplateParameters(vtpsd))
        @test !(CC.hasAssociatedConstraints(vtpsd))
        @test !(CC.isMemberSpecialization(vtpsd))
        @test CC.getInstantiatedFromMember(vtpsd).ptr == C_NULL
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
    ivd = CC.VarDecl(get_decl(f))
    innerrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(ivd)))
    @test innerrec.ptr != C_NULL && CC.getName(innerrec) == "DtInner"
    if innerrec.ptr != C_NULL
        msi = CC.getMemberSpecializationInfo(innerrec)
        @test msi.ptr != C_NULL
        if msi.ptr != C_NULL
            @test CC.getInstantiatedFrom(msi).ptr != C_NULL && CC.getName(CC.getInstantiatedFrom(msi)) == "DtInner"
            @test CC.getTemplateSpecializationKind(msi) == CC.LibClangEx.CXTemplateSpecializationKind_TSK_ImplicitInstantiation
            @test !(CC.isExplicitSpecialization(msi))
            @test !CC.isExplicitSpecialization(msi)   # implicitly instantiated member
            @test !CC.is_null_handle(CC.getPointOfInstantiation(msi))
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
    @test ftsi !== nothing && ftsi.ptr != C_NULL
    if ftsi isa CC.FunctionTemplateSpecializationInfo
        @test !CC.is_null_handle(CC.getFunction(ftsi))
        @test CC.getName(CC.getFunction(ftsi)) == "dt_ident"
        @test !CC.is_null_handle(CC.getTemplate(ftsi))
        @test CC.getName(CC.getTemplate(ftsi)) == "dt_ident"
        @test CC.getTemplateSpecializationKind(ftsi) == CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitSpecialization
        @test CC.isExplicitSpecialization(ftsi)
        @test CC.isExplicitInstantiationOrSpecialization(ftsi)
        @test CC.is_null_handle(CC.getPointOfInstantiation(ftsi))
        # NULL unless the specialization is also a class-template member specialization
        @test CC.is_null_handle(CC.getMemberSpecializationInfo(ftsi))
    end

    # ---------- TemplateTemplateParmDecl (DtTtpBox's C) ----------
    @test f(I, "DtTtpBox")
    ttpbox = CC.ClassTemplateDecl(get_decl(f))
    p0 = CC.getParam(CC.getTemplateParameters(ttpbox), 0)
    @test CC.getDeclKindName(p0) == "TemplateTemplateParm"
    ttp = CC.TemplateTemplateParmDecl(p0)
    @test !(CC.isPackExpansion(ttp))
    @test !CC.isPackExpansion(ttp)
    @test !(CC.isExpandedParameterPack(ttp))
    @test !CC.isExpandedParameterPack(ttp)
    @test CC.hasDefaultArgument(ttp)
    @test !CC.is_null_handle(CC.getDefaultArgumentLoc(ttp))
    @test CC.isValid(CC.getDefaultArgumentLoc(ttp))
    @test !(CC.defaultArgumentWasInherited(ttp))
    @test !CC.defaultArgumentWasInherited(ttp)   # written on this very declaration
    # both expansion accessors restate the isExpandedParameterPack precondition
    @test_throws AssertionError CC.getNumExpansionTemplateParameters(ttp)
    @test_throws AssertionError CC.getExpansionTemplateParameters(ttp, 0)

    # ---------- NonTypeTemplateParmDecl (DtNttBox's N) ----------
    @test f(I, "DtNttBox")
    nttbox = CC.ClassTemplateDecl(get_decl(f))
    n0 = CC.getParam(CC.getTemplateParameters(nttbox), 0)
    @test CC.getDeclKindName(n0) == "NonTypeTemplateParm"
    nttp = CC.NonTypeTemplateParmDecl(n0)
    @test !(CC.defaultArgumentWasInherited(nttp))
    @test !CC.defaultArgumentWasInherited(nttp)
    @test !(CC.isPackExpansion(nttp))
    @test !CC.isPackExpansion(nttp)
    @test CC.is_null_handle(CC.getPlaceholderTypeConstraint(nttp))
    @test CC.getPlaceholderTypeConstraint(nttp).ptr == C_NULL   # plain `int` parameter

    # a constrained placeholder (`DtAny auto V`) carries the constraint expression
    if f(I, "DtNttC")
        c0 = CC.getParam(CC.getTemplateParameters(CC.ClassTemplateDecl(get_decl(f))), 0)
        if CC.getDeclKindName(c0) == "NonTypeTemplateParm"
            cnttp = CC.NonTypeTemplateParmDecl(c0)
            @test !CC.is_null_handle(CC.getPlaceholderTypeConstraint(cnttp))
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
    @test ctd.ptr != C_NULL && CC.getName(ctd) == "PSX"
    @test CC.getNumPartialSpecializations(ctd) == 2      # PSX<T*> and PSX<T&>
    ps = CC.getPartialSpecializations(ctd)
    @test length(ps) == 2
    @test all(p -> p.ptr != C_NULL && CC.getName(p) == "PSX", ps)
    @test all(p -> p.ptr != C_NULL, ps)
    @test !CC.is_null_handle(CC.getInjectedClassNameSpecialization(ctd))

    p0 = ps[1]
    @test CC.getMostRecentDecl(p0).ptr == p0.ptr
    @test CC.getMostRecentDecl(p0).ptr != C_NULL
    @test !CC.is_null_handle(CC.getTemplateArgsAsWritten(p0))
    tfd = CC.getTypeForDecl(p0)
    if !CC.is_null_handle(tfd) && CC.is_injected_class_name_type(tfd)
        ist = CC.getInjectedSpecializationType(p0)
        @test ist.ptr != C_NULL
        # round trip: the injected specialization type finds its own partial spec
        hit = CC.findPartialSpecialization(ctd, ist)
        @test hit.ptr == p0.ptr
        @test hit.ptr != C_NULL
    end

    # ---------- TypeAliasTemplateDecl redeclaration chain ----------
    @test f(I, "PSXAlias")
    tatd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "TypeAliasTemplate"
            tatd = CC.TypeAliasTemplateDecl(d)
            break
        end
    end
    @test tatd !== nothing && tatd.ptr != C_NULL && CC.getName(tatd) == "PSXAlias"
    if tatd isa CC.TypeAliasTemplateDecl
        @test CC.getCanonicalDecl(tatd).ptr == tatd.ptr
        @test CC.getCanonicalDecl(tatd).ptr != C_NULL
        @test CC.getPreviousDecl(tatd).ptr == C_NULL
    end

    # ---------- FunctionTemplateDecl redeclaration chain ----------
    @test f(I, "ftplx")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d)
            break
        end
    end
    @test ftd !== nothing && ftd.ptr != C_NULL && CC.getName(ftd) == "ftplx"
    if ftd isa CC.FunctionTemplateDecl
        @test CC.getCanonicalDecl(ftd).ptr != C_NULL
        @test CC.getCanonicalDecl(ftd).ptr != C_NULL
        @test CC.getMostRecentDecl(ftd).ptr != C_NULL
        @test CC.getMostRecentDecl(ftd).ptr != C_NULL
        @test CC.getPreviousDecl(ftd).ptr != C_NULL
    end

    # ---------- VarTemplateDecl chain + partial specializations ----------
    @test f(I, "tvarx")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d)
            break
        end
    end
    @test vtd !== nothing && vtd.ptr != C_NULL && CC.getName(vtd) == "tvarx"
    if vtd isa CC.VarTemplateDecl
        @test CC.getCanonicalDecl(vtd).ptr == vtd.ptr
        @test CC.getCanonicalDecl(vtd).ptr != C_NULL
        @test CC.getMostRecentDecl(vtd).ptr == vtd.ptr
        @test CC.getMostRecentDecl(vtd).ptr != C_NULL
        @test CC.getPreviousDecl(vtd).ptr == C_NULL
        @test CC.getDefinition(vtd).ptr == vtd.ptr
        @test CC.getNumPartialSpecializations(vtd) == 1  # tvarx<T*>
        vps = CC.getPartialSpecializations(vtd)
        @test length(vps) == 1
        @test vps[1].ptr != C_NULL && CC.getName(vps[1]) == "tvarx"
        @test vps[1].ptr != C_NULL
        @test !CC.is_null_handle(CC.getTemplateArgsAsWritten(vps[1]))
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
    @test vspec !== nothing && vspec.ptr != C_NULL && CC.getName(vspec) == "tvarx"
    if vspec isa CC.VarTemplateSpecializationDecl
        @test !CC.is_null_handle(CC.getTemplateArgsInfo(vspec))
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
    ctd = CC.ClassTemplateDecl(get_decl(f))
    tpl = CC.getTemplateParameters(ctd)
    @test !(CC.containsUnexpandedParameterPack(tpl))
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
    @test CC.getInstantiatedFromMemberTemplate(ctd).ptr == C_NULL

    # ---------- default arguments of the three parameter kinds ----------
    @test f(I, "DtfDefaults")
    dtd = CC.ClassTemplateDecl(get_decl(f))
    dpl = CC.getTemplateParameters(dtd)
    ttp = CC.TemplateTypeParmDecl(CC.getParam(dpl, 0))
    @test !(CC.isPackExpansion(ttp))
    @test !CC.isPackExpansion(ttp)
    @test CC.hasDefaultArgument(ttp)
    @test !CC.is_null_handle(CC.getDefaultArgumentLoc(ttp))
    @test CC.isValid(CC.getDefaultArgumentLoc(ttp))
    nttp = CC.NonTypeTemplateParmDecl(CC.getParam(dpl, 1))
    @test CC.hasDefaultArgument(nttp)
    @test !CC.is_null_handle(CC.getDefaultArgumentLoc(nttp))
    @test CC.isValid(CC.getDefaultArgumentLoc(nttp))
    ttpp = CC.TemplateTemplateParmDecl(CC.getParam(dpl, 2))
    @test CC.hasDefaultArgument(ttpp)
    tal = CC.getDefaultArgument(ttpp)
    @test tal.ptr != C_NULL
    @test tal.ptr != C_NULL

    # ---------- BuiltinTemplateDecl kind ----------
    mis = CC.getMakeIntegerSeqDecl(ctx)
    @test mis.ptr != C_NULL && CC.getName(mis) == "__make_integer_seq"
    @test CC.getBuiltinTemplateKind(mis) ==
          CC.LibClangEx.CXBuiltinTemplateKind_BTK__make_integer_seq
    tpe = CC.getTypePackElementDecl(ctx)
    @test tpe.ptr != C_NULL && CC.getName(tpe) == "__type_pack_element"
    @test CC.getBuiltinTemplateKind(tpe) ==
          CC.LibClangEx.CXBuiltinTemplateKind_BTK__type_pack_element

    # ---------- TemplateParamObjectDecl reached through its template argument ----------
    @test f(I, "dtf_obj")
    oqt = CC.getType(CC.VarDecl(get_decl(f)))
    ocanon = CC.get_qual_type(CC.getTypePtr(oqt))
    ort = CC.resolve(CC.getTypePtr(ocanon))
    ospec = CC.ClassTemplateSpecializationDecl(CC.getDecl(ort))
    oargs = CC.getTemplateArgs(ospec)
    ta = Base.get(oargs, 0)
    @test CC.getKind(ta) == CC.LibClangEx.CXTemplateArgument_Declaration
    tpo = CC.resolve(CC.getAsDecl(ta))
    @test tpo.ptr != C_NULL
    if tpo isa CC.TemplateParamObjectDecl
        @test CC.getValue(tpo).ptr != C_NULL
        @test CC.getValue(tpo).ptr != C_NULL
        @test CC.getCanonicalDecl(tpo).ptr == tpo.ptr
        @test CC.getCanonicalDecl(tpo).ptr != C_NULL
        @test !isempty(CC.printAsExpr(tpo))
        @test !isempty(CC.printAsExpr(tpo))
        @test !isempty(CC.printAsInit(tpo))
        @test !isempty(CC.printAsInit(tpo))
    end

    # ---------- narrowed member-template accessors on the other template kinds ----------
    @test f(I, "DtfAlias")
    tatd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "TypeAliasTemplate"
            tatd = CC.TypeAliasTemplateDecl(d)
            break
        end
    end
    @test tatd !== nothing && tatd.ptr != C_NULL && CC.getName(tatd) == "DtfAlias"
    if tatd isa CC.TypeAliasTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(tatd).ptr == C_NULL
    end

    @test f(I, "dtf_identity")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d)
            break
        end
    end
    @test ftd !== nothing && ftd.ptr != C_NULL && CC.getName(ftd) == "dtf_identity"
    if ftd isa CC.FunctionTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(ftd).ptr == C_NULL
        @test length(CC.getInjectedTemplateArgs(ftd)) == 1
    end

    @test f(I, "dtf_var")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d)
            break
        end
    end
    @test vtd !== nothing && vtd.ptr != C_NULL && CC.getName(vtd) == "dtf_var"
    if vtd isa CC.VarTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(vtd).ptr == C_NULL
        vps = CC.getPartialSpecializations(vtd)
        @test length(vps) == 1
        @test CC.getMostRecentDecl(vps[1]).ptr == vps[1].ptr
        @test CC.getMostRecentDecl(vps[1]).ptr != C_NULL
    end

    @test f(I, "DtfPair")
    ptd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "ClassTemplate"
            ptd = CC.ClassTemplateDecl(d)
            break
        end
    end
    @test ptd !== nothing && ptd.ptr != C_NULL && CC.getName(ptd) == "DtfPair"
    if ptd isa CC.ClassTemplateDecl
        pps = CC.getPartialSpecializations(ptd)
        @test length(pps) == 1
        @test CC.getInstantiatedFromMemberTemplate(pps[1]).ptr == C_NULL
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
    ctd = CC.ClassTemplateDecl(get_decl(f))
    CC.LoadLazySpecializations(ctd)          # no external AST source: a no-op
    n = CC.getNumSpecializations(ctd)
    @test n == 2
    @test n == 2                             # SgBox<int, 3> and SgBox<double, 4>
    cspecs = CC.getSpecializations(ctd)
    @test length(cspecs) == n
    @test length(cspecs) == 2 && all(s -> s.ptr != C_NULL && CC.getName(s) == "SgBox", cspecs)
    @test all(s -> s.ptr != C_NULL, cspecs)
    @test all(s -> CC.getName(s) == "SgBox", cspecs)

    # ---------- TemplateParameterList printing ----------
    tpl = CC.getTemplateParameters(ctd)
    s = CC.print(tpl, ctx)
    @test !isempty(s) && occursin("template", s)
    @test occursin("<", s) && occursin(">", s)
    bare = CC.print(tpl, ctx, true)
    @test !isempty(bare) && !occursin("template", bare)
    @test !occursin("template", bare)        # OmitTemplateKW drops the keyword only
    @test length(bare) < length(s)

    # ---------- TemplateTypeParmDecl: default-argument info + typename flag ----------
    p0 = CC.getParam(tpl, 0)
    @test CC.getDeclKindName(p0) == "TemplateTypeParm"
    ttp = CC.TemplateTypeParmDecl(p0)
    @test !CC.hasDefaultArgument(ttp)
    tsi = CC.getDefaultArgumentInfo(ttp)
    @test tsi.ptr == C_NULL                  # `typename T` carries no default
    was = CC.wasDeclaredWithTypename(ttp)
    @test was == true
    # round-trip: T has no type constraint, so the flag reads back exactly
    CC.setDeclaredWithTypename(ttp, !was)
    @test CC.wasDeclaredWithTypename(ttp) == !was
    CC.setDeclaredWithTypename(ttp, was)
    @test CC.wasDeclaredWithTypename(ttp) == was

    @test f(I, "SgDef")
    dtd = CC.ClassTemplateDecl(get_decl(f))
    d0 = CC.TemplateTypeParmDecl(CC.getParam(CC.getTemplateParameters(dtd), 0))
    @test CC.hasDefaultArgument(d0)
    dtsi = CC.getDefaultArgumentInfo(d0)
    @test dtsi.ptr != C_NULL                 # `typename T = int`

    # ---------- NonTypeTemplateParmDecl: position + expansion-type guard ----------
    n1 = CC.getParam(tpl, 1)
    @test CC.getDeclKindName(n1) == "NonTypeTemplateParm"
    nttp = CC.NonTypeTemplateParmDecl(n1)
    @test CC.getPosition(nttp) == CC.getIndex(nttp)   # one stored field, two names
    @test CC.getPosition(nttp) == 1
    @test !CC.isExpandedParameterPack(nttp)
    @test_throws AssertionError CC.getExpansionTypeSourceInfo(nttp, 0)

    # ---------- TemplateTemplateParmDecl: position ----------
    @test f(I, "SgTT")
    ttd = CC.ClassTemplateDecl(get_decl(f))
    t0 = CC.getParam(CC.getTemplateParameters(ttd), 0)
    @test CC.getDeclKindName(t0) == "TemplateTemplateParm"
    ttpp = CC.TemplateTemplateParmDecl(t0)
    @test CC.getPosition(ttpp) == CC.getIndex(ttpp)
    @test CC.getPosition(ttpp) == 0

    # ---------- FunctionTemplateDecl: the specialization set ----------
    @test f(I, "sg_fn")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d)
            break
        end
    end
    @test ftd !== nothing && ftd.ptr != C_NULL && CC.getName(ftd) == "sg_fn"
    if ftd isa CC.FunctionTemplateDecl
        CC.LoadLazySpecializations(ftd)
        fn = CC.getNumSpecializations(ftd)
        @test fn == 2                        # sg_fn<int> and sg_fn<char>
        fspecs = CC.getSpecializations(ftd)
        @test length(fspecs) == fn
        @test length(fspecs) == 2 && all(s -> s.ptr != C_NULL && CC.getName(s) == "sg_fn", fspecs)
        @test all(s -> s.ptr != C_NULL, fspecs)
        @test all(s -> CC.getName(s) == "sg_fn", fspecs)
    end

    # ---------- VarTemplateDecl: the specialization set ----------
    @test f(I, "sg_var")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d)
            break
        end
    end
    @test vtd !== nothing && vtd.ptr != C_NULL && CC.getName(vtd) == "sg_var"
    if vtd isa CC.VarTemplateDecl
        CC.LoadLazySpecializations(vtd)
        vn = CC.getNumSpecializations(vtd)
        @test vn == 2                        # sg_var<int> and sg_var<double>
        vspecs = CC.getSpecializations(vtd)
        @test length(vspecs) == vn
        @test length(vspecs) == 2 && all(s -> s.ptr != C_NULL && CC.getName(s) == "sg_var", vspecs)
        @test all(s -> s.ptr != C_NULL, vspecs)
        @test all(s -> CC.getName(s) == "sg_var", vspecs)
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate mutators + default-argument round-trips" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <typename T, int N = 3> struct MtBox { T v; };
    template <typename T = int> struct MtDef { T v; };
    template <typename U> struct MtArg { U u; };
    template <template <typename> class C = MtArg> struct MtTT { C<int> c; };
    template <typename T> struct MtPu { T v; };
    template <typename T> struct MtPu<T *> { T *p; };
    template <typename T> struct MtOuter { struct MtInner { T v; }; };
    template <typename T> constexpr T mt_var = T(1);
    template <typename T> T mt_fn(T v) { return v; }
    template <> int mt_fn<int>(int v) { return v + 1; }
    MtBox<int> mt_bi;
    MtPu<int *> mt_pu;
    MtOuter<int>::MtInner mt_inner_use;
    int mt_use() { return (int)mt_var<int> + mt_fn<int>(1); }
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # ---------- TemplateDecl: re-seating the parameter list ----------
    @test f(I, "MtBox")
    ctd = CC.ClassTemplateDecl(get_decl(f))
    tpl = CC.getTemplateParameters(ctd)
    @test !CC.is_null_handle(tpl) && size(tpl) == 2
    CC.setTemplateParameters(ctd, tpl)          # re-seating the same list is a no-op
    @test CC.getTemplateParameters(ctd).ptr == tpl.ptr
    loc = CC.getLocation(ctd)
    @test CC.isValid(loc)

    # ---------- ClassTemplateSpecializationDecl: the mutator tail ----------
    cspecs = CC.getSpecializations(ctd)
    @test length(cspecs) == 1                   # only MtBox<int, 3> is instantiated
    ctsd = cspecs[1]
    @test !CC.specializedOnPartial(ctsd)
    st = CC.getSpecializedTemplate(ctsd)
    CC.setSpecializedTemplate(ctsd, st)         # re-seating the same template is a no-op
    @test CC.getSpecializedTemplate(ctsd).ptr == st.ptr

    k0 = CC.getSpecializationKind(ctsd)
    CC.setSpecializationKind(ctsd, CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitSpecialization)
    @test CC.getSpecializationKind(ctsd) ==
          CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitSpecialization
    CC.setSpecializationKind(ctsd, k0)
    @test CC.getSpecializationKind(ctsd) == k0

    poi0 = CC.getPointOfInstantiation(ctsd)
    CC.setPointOfInstantiation(ctsd, loc)
    @test CC.getRawEncoding(CC.getPointOfInstantiation(ctsd)) == CC.getRawEncoding(loc)
    CC.isValid(poi0) && CC.setPointOfInstantiation(ctsd, poi0)
    # the wrapper restates Clang's "point of instantiation must be valid" assert
    @test_throws AssertionError CC.setPointOfInstantiation(ctsd, CC.SourceLocation())

    ext0 = CC.getExternLoc(ctsd)
    CC.setExternLoc(ctsd, loc)                  # allocates the ExplicitInfo block
    @test CC.getRawEncoding(CC.getExternLoc(ctsd)) == CC.getRawEncoding(loc)
    CC.setExternLoc(ctsd, ext0)                 # an invalid location is accepted here
    @test CC.getRawEncoding(CC.getExternLoc(ctsd)) == CC.getRawEncoding(ext0)

    tkw0 = CC.getTemplateKeywordLoc(ctsd)
    CC.setTemplateKeywordLoc(ctsd, loc)
    @test CC.getRawEncoding(CC.getTemplateKeywordLoc(ctsd)) == CC.getRawEncoding(loc)
    CC.setTemplateKeywordLoc(ctsd, tkw0)
    @test CC.getRawEncoding(CC.getTemplateKeywordLoc(ctsd)) == CC.getRawEncoding(tkw0)

    # setSpecializedTemplate would drop the stored partial-specialization pair, so the
    # wrapper rejects a specialization that was deduced from one
    @test f(I, "MtPu")
    puctd = nothing
    for d in CC.get_decls(f)
        CC.getDeclKindName(d) == "ClassTemplate" || continue
        puctd = CC.ClassTemplateDecl(d)
        break
    end
    @test puctd !== nothing && puctd.ptr != C_NULL && CC.getName(puctd) == "MtPu"
    if puctd isa CC.ClassTemplateDecl
        pspec = nothing
        for s in CC.getSpecializations(puctd)
            CC.specializedOnPartial(s) || continue
            pspec = s
            break
        end
        @test pspec !== nothing && pspec.ptr != C_NULL && CC.getName(pspec) == "MtPu"
        if pspec isa CC.ClassTemplateSpecializationDecl
            @test_throws AssertionError CC.setSpecializedTemplate(pspec, puctd)
        end
    end

    # ---------- VarTemplateSpecializationDecl: the mutator tail ----------
    @test f(I, "mt_var")
    vtd = nothing
    for d in CC.get_decls(f)
        CC.getDeclKindName(d) == "VarTemplate" || continue
        vtd = CC.VarTemplateDecl(d)
        break
    end
    @test vtd !== nothing && vtd.ptr != C_NULL && CC.getName(vtd) == "mt_var"
    if vtd isa CC.VarTemplateDecl
        vspecs = CC.getSpecializations(vtd)
        @test !isempty(vspecs)
        vtsd = vspecs[1]
        vk0 = CC.getSpecializationKind(vtsd)
        CC.setSpecializationKind(vtsd,
                                 CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition)
        @test CC.getSpecializationKind(vtsd) ==
              CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition
        CC.setSpecializationKind(vtsd, vk0)
        @test CC.getSpecializationKind(vtsd) == vk0

        vloc = CC.getLocation(vtd)
        @test CC.isValid(vloc)
        vpoi0 = CC.getPointOfInstantiation(vtsd)
        CC.setPointOfInstantiation(vtsd, vloc)
        @test CC.getRawEncoding(CC.getPointOfInstantiation(vtsd)) == CC.getRawEncoding(vloc)
        CC.isValid(vpoi0) && CC.setPointOfInstantiation(vtsd, vpoi0)
        @test_throws AssertionError CC.setPointOfInstantiation(vtsd, CC.SourceLocation())

        vext0 = CC.getExternLoc(vtsd)
        CC.setExternLoc(vtsd, vloc)
        @test CC.getRawEncoding(CC.getExternLoc(vtsd)) == CC.getRawEncoding(vloc)
        CC.setExternLoc(vtsd, vext0)
        @test CC.getRawEncoding(CC.getExternLoc(vtsd)) == CC.getRawEncoding(vext0)

        vtkw0 = CC.getTemplateKeywordLoc(vtsd)
        CC.setTemplateKeywordLoc(vtsd, vloc)
        @test CC.getRawEncoding(CC.getTemplateKeywordLoc(vtsd)) == CC.getRawEncoding(vloc)
        CC.setTemplateKeywordLoc(vtsd, vtkw0)
        @test CC.getRawEncoding(CC.getTemplateKeywordLoc(vtsd)) == CC.getRawEncoding(vtkw0)
    end

    # ---------- MemberSpecializationInfo: the setter pair ----------
    @test f(I, "mt_inner_use")
    ivd = CC.VarDecl(get_decl(f))
    innerrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(ivd)))
    @test innerrec.ptr != C_NULL && CC.getName(innerrec) == "MtInner"
    if innerrec isa CC.CXXRecordDecl && innerrec.ptr != C_NULL
        msi = CC.getMemberSpecializationInfo(innerrec)
        @test msi.ptr != C_NULL
        if msi.ptr != C_NULL
            mk0 = CC.getTemplateSpecializationKind(msi)
            CC.setTemplateSpecializationKind(msi,
                                             CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitSpecialization)
            @test CC.getTemplateSpecializationKind(msi) ==
                  CC.LibClangEx.CXTemplateSpecializationKind_TSK_ExplicitSpecialization
            CC.setTemplateSpecializationKind(msi, mk0)
            @test CC.getTemplateSpecializationKind(msi) == mk0
            # the two-bit encoding stores tsk - 1, so TSK_Undeclared is unrepresentable
            undecl = CC.LibClangEx.CXTemplateSpecializationKind_TSK_Undeclared
            @test_throws AssertionError CC.setTemplateSpecializationKind(msi, undecl)
            mpoi0 = CC.getPointOfInstantiation(msi)
            mloc = CC.getLocation(innerrec)
            CC.setPointOfInstantiation(msi, mloc)
            @test CC.getRawEncoding(CC.getPointOfInstantiation(msi)) == CC.getRawEncoding(mloc)
            CC.setPointOfInstantiation(msi, mpoi0)   # invalid is fine on this receiver
            @test CC.getRawEncoding(CC.getPointOfInstantiation(msi)) == CC.getRawEncoding(mpoi0)
        end
    end

    # ---------- FunctionTemplateSpecializationInfo: the setter pair ----------
    tu = CC.getTranslationUnitDecl(ivd)
    ftsi = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        d isa CC.AbstractFunctionDecl || continue
        CC.getDeclKindName(d) == "Function" || continue
        CC.isFunctionTemplateSpecialization(d) || continue
        info = CC.getTemplateSpecializationInfo(d)
        info.ptr == C_NULL || (ftsi = info; break)
    end
    @test ftsi.ptr != C_NULL
    if ftsi isa CC.FunctionTemplateSpecializationInfo
        fk0 = CC.getTemplateSpecializationKind(ftsi)
        CC.setTemplateSpecializationKind(ftsi,
                                         CC.LibClangEx.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
        @test CC.getTemplateSpecializationKind(ftsi) ==
              CC.LibClangEx.CXTemplateSpecializationKind_TSK_ImplicitInstantiation
        CC.setTemplateSpecializationKind(ftsi, fk0)
        @test CC.getTemplateSpecializationKind(ftsi) == fk0
        undecl_f = CC.LibClangEx.CXTemplateSpecializationKind_TSK_Undeclared
        @test_throws AssertionError CC.setTemplateSpecializationKind(ftsi, undecl_f)
        fpoi0 = CC.getPointOfInstantiation(ftsi)
        floc = CC.getLocation(CC.getFunction(ftsi))
        CC.setPointOfInstantiation(ftsi, floc)
        @test CC.getRawEncoding(CC.getPointOfInstantiation(ftsi)) == CC.getRawEncoding(floc)
        CC.setPointOfInstantiation(ftsi, fpoi0)
        @test CC.getRawEncoding(CC.getPointOfInstantiation(ftsi)) == CC.getRawEncoding(fpoi0)
    end

    # ---------- TemplateTypeParmDecl: default-argument remove/set round-trip ----------
    @test f(I, "MtDef")
    dtd = CC.ClassTemplateDecl(get_decl(f))
    d0 = CC.TemplateTypeParmDecl(CC.getParam(CC.getTemplateParameters(dtd), 0))
    @test CC.hasDefaultArgument(d0)
    dtsi = CC.getDefaultArgumentInfo(d0)
    @test dtsi.ptr != C_NULL
    @test dtsi.ptr != C_NULL
    CC.removeDefaultArgument(d0)
    @test !CC.hasDefaultArgument(d0)
    @test CC.getDefaultArgumentInfo(d0).ptr == C_NULL
    CC.setDefaultArgument(d0, dtsi)             # the cleared storage is arena-owned, still live
    @test CC.hasDefaultArgument(d0)
    @test CC.getDefaultArgumentInfo(d0).ptr == dtsi.ptr
    # DefaultArgStorage::set asserts the slot is still unset
    @test_throws AssertionError CC.setDefaultArgument(d0, dtsi)

    # ---------- NonTypeTemplateParmDecl: default-argument remove/set round-trip ----------
    n1 = CC.getParam(tpl, 1)
    @test CC.getDeclKindName(n1) == "NonTypeTemplateParm"
    nttp = CC.NonTypeTemplateParmDecl(n1)
    @test CC.hasDefaultArgument(nttp)
    darg = CC.getDefaultArgument(nttp)
    @test darg.ptr != C_NULL
    @test darg.ptr != C_NULL
    CC.removeDefaultArgument(nttp)
    @test !CC.hasDefaultArgument(nttp)
    CC.setDefaultArgument(nttp, darg)
    @test CC.hasDefaultArgument(nttp)
    @test CC.getDefaultArgument(nttp).ptr == darg.ptr
    @test_throws AssertionError CC.setDefaultArgument(nttp, darg)

    # ---------- TemplateTemplateParmDecl: default-argument remove/set round-trip ----------
    @test f(I, "MtTT")
    ttd = CC.ClassTemplateDecl(get_decl(f))
    t0 = CC.getParam(CC.getTemplateParameters(ttd), 0)
    @test CC.getDeclKindName(t0) == "TemplateTemplateParm"
    ttp = CC.TemplateTemplateParmDecl(t0)
    @test CC.hasDefaultArgument(ttp)
    tal = CC.getDefaultArgument(ttp)
    @test tal.ptr != C_NULL
    @test tal.ptr != C_NULL
    CC.removeDefaultArgument(ttp)
    @test !CC.hasDefaultArgument(ttp)
    CC.setDefaultArgument(ttp, ctx, tal)        # Clang copies into ASTContext storage
    @test CC.hasDefaultArgument(ttp)
    @test CC.getDefaultArgument(ttp).ptr != C_NULL
    @test_throws AssertionError CC.setDefaultArgument(ttp, ctx, tal)

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate constraints, source ranges, member links" begin
    I = create_interpreter(["-std=c++20"])
    src = """
    template <typename T> concept DtiAny = true;
    template <DtiAny T, int N> struct DtiBox { T data[N]; };
    template <DtiAny T> struct DtiBox<T, 1> { T only; };
    DtiBox<int, 3> dti_many;
    DtiBox<int, 1> dti_one;

    template <DtiAny T> T dti_var = T();
    template <DtiAny T> T *dti_var<T *> = nullptr;
    int *dti_vp = dti_var<int *>;

    template <typename T> T dti_ident(T v) { return v; }

    template <template <typename> class TT, typename U> struct DtiTT { TT<U> *v; };
    """
    CC.parse(I, src)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # ---------- TemplateDecl / TemplateParameterList ----------
    # DtiBox names both the primary template and its partial specialization, so the
    # lookup result is not unique -- pick the ClassTemplateDecl out of the full list.
    @test f(I, "DtiBox")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    @test CC.isValid(CC.getSourceRange(ctd))           # AbstractTemplateDecl path
    tpl = CC.getTemplateParameters(ctd)
    @test !(CC.shouldIncludeTypeForArgument(tpl, ctx, 0))
    @test !(CC.shouldIncludeTypeForArgument(tpl, ctx, 1))
    # the predicate is total: an index past the end of the list answers true
    @test CC.shouldIncludeTypeForArgument(tpl, ctx, 99)

    # ---------- TemplateTypeParmDecl (constrained by DtiAny) ----------
    ttp = CC.resolve(CC.getParam(tpl, 0))
    @test ttp.ptr != C_NULL && CC.getName(ttp) == "T"
    @test CC.isValid(CC.getSourceRange(ttp))
    tac = CC.getAssociatedConstraints(ttp)
    @test length(tac) == 1
    @test length(tac) == (CC.hasTypeConstraint(ttp) ? 1 : 0)
    for e in tac
        @test e.ptr != C_NULL
    end

    # ---------- NonTypeTemplateParmDecl (plain `int N`, no placeholder) ----------
    nttp = CC.resolve(CC.getParam(tpl, 1))
    @test nttp.ptr != C_NULL && CC.getName(nttp) == "N"
    @test CC.isValid(CC.getSourceRange(nttp))
    nac = CC.getAssociatedConstraints(nttp)
    @test isempty(nac)
    @test length(nac) == (CC.hasPlaceholderTypeConstraint(nttp) ? 1 : 0)

    # ---------- TemplateTemplateParmDecl ----------
    @test f(I, "DtiTT")
    tt_ctd = CC.ClassTemplateDecl(get_decl(f))
    ttparm = CC.resolve(CC.getParam(CC.getTemplateParameters(tt_ctd), 0))
    @test ttparm.ptr != C_NULL && CC.getName(ttparm) == "TT"
    @test CC.isValid(CC.getSourceRange(ttparm))

    # ---------- BuiltinTemplateDecl ----------
    btd = CC.getMakeIntegerSeqDecl(ctx)
    @test btd.ptr != C_NULL && CC.getName(btd) == "__make_integer_seq"
    @test !CC.isValid(CC.getSourceRange(btd))

    # ---------- ClassTemplatePartialSpecializationDecl ----------
    cpss = CC.getPartialSpecializations(ctd)
    @test length(cpss) == 1
    cac = CC.getAssociatedConstraints(cpss[1])
    @test length(cac) == 1
    @test CC.hasAssociatedConstraints(cpss[1]) == !isempty(cac)

    # ---------- setTypeAsWritten round-trip (class) ----------
    @test f(I, "dti_many")
    vd = CC.VarDecl(get_decl(f))
    rec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test rec.ptr != C_NULL && CC.getName(rec) == "DtiBox"
    if CC.getDeclKindName(rec) == "ClassTemplateSpecialization"
        cspec = CC.ClassTemplateSpecializationDecl(rec)
        tsi = CC.getTrivialTypeSourceInfo(ctx, CC.getType(vd), CC.getLocation(vd))
        CC.setTypeAsWritten(cspec, tsi)
        @test CC.getTypeAsWritten(cspec).ptr == tsi.ptr
    end

    # ---------- VarTemplate family ----------
    tu = CC.getTranslationUnitDecl(vd)
    vtsd = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        if !(d isa CC.VarTemplatePartialSpecializationDecl) &&
           d isa CC.VarTemplateSpecializationDecl
            vtsd = d
        end
    end
    @test vtsd !== nothing && vtsd.ptr != C_NULL && CC.getName(vtsd) == "dti_var"
    if vtsd isa CC.VarTemplateSpecializationDecl
        vtsi = CC.getTrivialTypeSourceInfo(ctx, CC.getType(vtsd), CC.getLocation(vtsd))
        CC.setTypeAsWritten(vtsd, vtsi)
        @test CC.getTypeAsWritten(vtsd).ptr == vtsi.ptr
    end

    # dti_var names the primary variable template AND its partial specialization, so
    # the lookup result is not unique -- take the VarTemplateDecl explicitly.
    @test f(I, "dti_var")
    vtd = CC.resolve(first(d for d in CC.get_decls(f)
                           if CC.getDeclKindName(d) == "VarTemplate"))
    @test vtd.ptr != C_NULL && CC.getName(vtd) == "dti_var"
    vpss = vtd isa CC.VarTemplateDecl ? CC.getPartialSpecializations(vtd) :
           CC.VarTemplatePartialSpecializationDecl[]
    @test length(vpss) == 1
    for p in vpss
        @test CC.isValid(CC.getSourceRange(p))
        vac = CC.getAssociatedConstraints(p)
        @test length(vac) == 1
        @test CC.hasAssociatedConstraints(p) == !isempty(vac)
    end

    # ---------- member-instantiation links (mutating; kept last) ----------
    # By this point the testset's own mutations have produced an instantiation of
    # dti_ident, so the lookup is no longer unique -- take the FunctionTemplate.
    @test f(I, "dti_ident")
    ftd = CC.resolve(first(d for d in CC.get_decls(f)
                           if CC.getDeclKindName(d) == "FunctionTemplate"))
    @test ftd.ptr != C_NULL && CC.getName(ftd) == "dti_ident"
    if ftd isa CC.FunctionTemplateDecl
        @test CC.getInstantiatedFromMemberTemplate(ftd).ptr == C_NULL
        CC.setInstantiatedFromMemberTemplate(ftd, ftd)
        @test CC.getInstantiatedFromMemberTemplate(ftd).ptr == ftd.ptr
    end

    # Clang's findPartialSpecInstantiatedFromMember dereferences every candidate's
    # instantiated-from-member link, so seat one on each partial specialization first.
    for p in cpss
        CC.setInstantiatedFromMember(p, p)
    end
    if !isempty(cpss)
        cps = cpss[1]
        @test CC.getInstantiatedFromMember(cps).ptr == cps.ptr
        CC.setMemberSpecialization(cps)
        @test CC.isMemberSpecialization(cps)
        cfound = CC.findPartialSpecInstantiatedFromMember(ctd, cps)
        @test cfound.ptr == cps.ptr
        @test cfound.ptr != C_NULL
    end

    for p in vpss
        CC.setInstantiatedFromMember(p, p)
    end
    if !isempty(vpss) && vtd isa CC.VarTemplateDecl
        vps = vpss[1]
        @test CC.getInstantiatedFromMember(vps).ptr == vps.ptr
        CC.setMemberSpecialization(vps)
        @test CC.isMemberSpecialization(vps)
        vfound = CC.findPartialSpecInstantiatedFromMember(vtd, vps)
        @test vfound.ptr == vps.ptr
        @test vfound.ptr != C_NULL
    end

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate kind predicates + specialization lookup" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <typename T> struct CkBox { T v; };
    template <typename T> constexpr T ck_var = T(1);
    template <typename T> constexpr T *ck_var<T *> = nullptr;
    template <typename T> T ck_fn(T x) { return x; }
    int ck_use() { return (int)ck_fn<int>(1) + (int)ck_var<int>; }
    """)
    f = DeclFinder(I)
    K = CC.LibClangEx

    # ---------- classofKind: the DeclTemplate Decl::Kind range tests ----------
    # These read a kind and not a declaration, so they are asserted against named
    # enumerators — the hierarchy they mirror is the same on every host.
    @test CC.classofKind(CC.TemplateDecl, K.CXDeclKind_ClassTemplate)
    @test CC.classofKind(CC.TemplateDecl, K.CXDeclKind_TemplateTemplateParm)
    @test CC.classofKind(CC.TemplateDecl, K.CXDeclKind_Concept)
    @test !CC.classofKind(CC.TemplateDecl, K.CXDeclKind_TemplateTypeParm)
    @test CC.classofKind(CC.RedeclarableTemplateDecl, K.CXDeclKind_VarTemplate)
    @test CC.classofKind(CC.RedeclarableTemplateDecl, K.CXDeclKind_FunctionTemplate)
    @test !CC.classofKind(CC.RedeclarableTemplateDecl, K.CXDeclKind_Concept)
    @test CC.classofKind(CC.FunctionTemplateDecl, K.CXDeclKind_FunctionTemplate)
    @test !CC.classofKind(CC.FunctionTemplateDecl, K.CXDeclKind_ClassTemplate)
    @test CC.classofKind(CC.ClassTemplateDecl, K.CXDeclKind_ClassTemplate)
    @test CC.classofKind(CC.VarTemplateDecl, K.CXDeclKind_VarTemplate)
    @test CC.classofKind(CC.TypeAliasTemplateDecl, K.CXDeclKind_TypeAliasTemplate)
    @test CC.classofKind(CC.ConceptDecl, K.CXDeclKind_Concept)
    @test CC.classofKind(CC.BuiltinTemplateDecl, K.CXDeclKind_BuiltinTemplate)
    @test CC.classofKind(CC.FriendTemplateDecl, K.CXDeclKind_FriendTemplate)
    @test CC.classofKind(CC.TemplateTypeParmDecl, K.CXDeclKind_TemplateTypeParm)
    @test CC.classofKind(CC.NonTypeTemplateParmDecl, K.CXDeclKind_NonTypeTemplateParm)
    @test CC.classofKind(CC.TemplateTemplateParmDecl, K.CXDeclKind_TemplateTemplateParm)
    @test CC.classofKind(CC.TemplateParamObjectDecl, K.CXDeclKind_TemplateParamObject)
    # the two specialization bases cover their partial-specialization subclass
    @test CC.classofKind(CC.ClassTemplateSpecializationDecl,
                         K.CXDeclKind_ClassTemplateSpecialization)
    @test CC.classofKind(CC.ClassTemplateSpecializationDecl,
                         K.CXDeclKind_ClassTemplatePartialSpecialization)
    @test !CC.classofKind(CC.ClassTemplateSpecializationDecl, K.CXDeclKind_CXXRecord)
    @test CC.classofKind(CC.ClassTemplatePartialSpecializationDecl,
                         K.CXDeclKind_ClassTemplatePartialSpecialization)
    @test !CC.classofKind(CC.ClassTemplatePartialSpecializationDecl,
                          K.CXDeclKind_ClassTemplateSpecialization)
    @test CC.classofKind(CC.VarTemplateSpecializationDecl,
                         K.CXDeclKind_VarTemplateSpecialization)
    @test CC.classofKind(CC.VarTemplateSpecializationDecl,
                         K.CXDeclKind_VarTemplatePartialSpecialization)
    @test !CC.classofKind(CC.VarTemplateSpecializationDecl, K.CXDeclKind_Var)
    @test CC.classofKind(CC.VarTemplatePartialSpecializationDecl,
                         K.CXDeclKind_VarTemplatePartialSpecialization)
    @test !CC.classofKind(CC.VarTemplatePartialSpecializationDecl,
                          K.CXDeclKind_VarTemplateSpecialization)

    # ---------- cross-check against a kind the AST actually built ----------
    @test f(I, "CkBox")
    ckd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "ClassTemplate"
            ckd = d
            break
        end
    end
    @test ckd !== nothing
    if ckd !== nothing
        @test CC.classofKind(CC.ClassTemplateDecl, CC.getKind(ckd))
        @test CC.classofKind(CC.TemplateDecl, CC.getKind(ckd))
        @test CC.classofKind(CC.RedeclarableTemplateDecl, CC.getKind(ckd))
        @test !CC.classofKind(CC.VarTemplateDecl, CC.getKind(ckd))
    end

    # ---------- FunctionTemplateDecl::findSpecialization ----------
    @test f(I, "ck_fn")
    ftd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "FunctionTemplate"
            ftd = CC.FunctionTemplateDecl(d)
            break
        end
    end
    @test ftd isa CC.FunctionTemplateDecl
    if ftd isa CC.FunctionTemplateDecl
        fspecs = CC.getSpecializations(ftd)
        @test length(fspecs) >= 1
        if !isempty(fspecs)
            fargs = CC.getTemplateSpecializationArgs(fspecs[1])
            @test fargs isa CC.TemplateArgumentList
            if fargs.ptr != C_NULL
                fhit = CC.findSpecialization(ftd, fargs)
                @test fhit isa CC.FunctionDecl
                @test fhit.ptr != C_NULL          # the arguments profile back to their own entry
                @test CC.getName(fhit) == "ck_fn"
            end
        end
    end

    # ---------- VarTemplateDecl::findSpecialization / findPartialSpecialization ----------
    @test f(I, "ck_var")
    vtd = nothing
    for d in CC.get_decls(f)
        if CC.getDeclKindName(d) == "VarTemplate"
            vtd = CC.VarTemplateDecl(d)
            break
        end
    end
    @test vtd isa CC.VarTemplateDecl
    if vtd isa CC.VarTemplateDecl
        vspecs = CC.getSpecializations(vtd)
        @test length(vspecs) >= 1
        if !isempty(vspecs)
            vargs = CC.getTemplateArgs(vspecs[1])
            @test vargs isa CC.TemplateArgumentList
            vhit = CC.findSpecialization(vtd, vargs)
            @test vhit isa CC.VarTemplateSpecializationDecl
            @test vhit.ptr != C_NULL
            @test CC.getName(vhit) == "ck_var"
        end
        vps = CC.getPartialSpecializations(vtd)
        @test length(vps) == 1                    # ck_var<T *>
        if !isempty(vps)
            p = vps[1]
            phit = CC.findPartialSpecialization(vtd, CC.getTemplateArgs(p),
                                                CC.getTemplateParameters(p))
            @test phit isa CC.VarTemplatePartialSpecializationDecl
            @test phit.ptr != C_NULL              # args + parameter list profile as a pair
            @test CC.getName(phit) == "ck_var"
        end
    end

    dispose(f)
    dispose(I)
end

@testset "TemplateArgument pack/expression accessors and TemplateArgumentLoc source info" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <typename... KTs> struct KPack { };
    template <int KN> struct KNum { };
    template <int KM> struct KDep { KNum<KM + 1> m; };
    template <typename KT> struct KBox { };
    template <template <typename> class KTT = KBox> struct KHolder { };
    template <typename KT, int KN2> struct KPart { };
    template <typename KT, int KN2> struct KPart<KT *, KN2> { };
    KPack<int, char> k_pack_obj;
    KPart<int *, 3> k_part_obj;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # ---------------- Pack argument: KPack<int, char> collapses to one Pack ----------------
    @test f(I, "k_pack_obj")
    pack_qt = CC.getType(CC.VarDecl(get_decl(f)))
    pack_rt = CC.resolve(CC.getTypePtr(CC.get_qual_type(CC.getTypePtr(pack_qt))))
    pack_spec = CC.ClassTemplateSpecializationDecl(CC.getDecl(pack_rt))
    pack_args = CC.getTemplateArgs(pack_spec)
    @test CC.size(pack_args) == 1
    pack = Base.get(pack_args, 0)
    @test CC.getKind(pack) == CC.LibClangEx.CXTemplateArgument_Pack
    @test CC.pack_size(pack) == 2
    @test CC.isPackExpansion(pack) == false
    @test CC.containsUnexpandedParameterPack(pack) == false
    e0 = CC.getPackElement(pack, 0)
    e1 = CC.getPackElement(pack, 1)
    @test e0.ptr != C_NULL
    @test e0.ptr != C_NULL
    @test CC.getKind(e0) == CC.LibClangEx.CXTemplateArgument_Type
    @test CC.structurallyEquals(e0, e0) == true
    @test CC.structurallyEquals(e0, e1) == false
    @test occursin("int", CC.print(e0, ctx, false))
    @test !isempty(CC.print(pack, ctx, true))
    @test_throws AssertionError CC.getPackElement(pack, 2)
    @test_throws AssertionError CC.pack_size(e0)

    # ---------------- Expression argument: KNum<KM + 1> inside the KDep pattern ----------------
    @test f(I, "KDep")
    kdep = CC.ClassTemplateDecl(get_decl(f))
    kdep_patt = CC.CXXRecordDecl(CC.getTemplatedDecl(kdep))
    fld = first(CC.getFields(kdep_patt))
    fty = CC.resolve(CC.getTypePtr(CC.getType(fld)))
    fty isa CC.ElaboratedType && (fty = CC.resolve(CC.getTypePtr(CC.getNamedType(fty))))
    @test fty.ptr != C_NULL
    earg = CC.getArg(fty, 0)
    @test CC.getKind(earg) == CC.LibClangEx.CXTemplateArgument_Expression
    @test !CC.is_null_handle(CC.getAsExpr(earg))
    @test CC.getAsExpr(earg).ptr != C_NULL
    @test CC.containsUnexpandedParameterPack(earg) == false
    @test CC.isPackExpansion(earg) == false

    # ---------------- TemplateArgumentLoc from a template-template default argument ----------------
    @test f(I, "KHolder")
    kholder = CC.ClassTemplateDecl(get_decl(f))
    ttp = CC.TemplateTemplateParmDecl(CC.getParam(CC.getTemplateParameters(kholder), 0))
    @test CC.hasDefaultArgument(ttp)
    tal_t = CC.getDefaultArgument(ttp)
    @test tal_t.ptr != C_NULL
    targ_t = CC.getArgument(tal_t)
    @test targ_t.ptr != C_NULL
    @test CC.getKind(targ_t) == CC.LibClangEx.CXTemplateArgument_Template
    @test !CC.is_null_handle(CC.getLocation(tal_t))
    @test CC.isValid(CC.getSourceRange(tal_t))
    @test !CC.is_null_handle(CC.getTemplateNameLoc(tal_t))
    # a plain Template argument carries no ellipsis, so that location stays invalid
    @test CC.is_null_handle(CC.getTemplateEllipsisLoc(tal_t))
    # getTypeSourceInfo is NULL for every kind other than Type
    @test CC.getTypeSourceInfo(tal_t).ptr == C_NULL
    @test_throws AssertionError CC.getSourceExpression(tal_t)
    @test_throws AssertionError CC.getAsExpr(targ_t)

    # ---------------- ASTTemplateArgumentListInfo: the args written on KPart<KT *, KN2> ----------------
    @test f(I, "k_part_obj")
    part_qt = CC.getType(CC.VarDecl(get_decl(f)))
    part_rt = CC.resolve(CC.getTypePtr(CC.get_qual_type(CC.getTypePtr(part_qt))))
    part_spec = CC.ClassTemplateSpecializationDecl(CC.getDecl(part_rt))
    @test CC.specializedOnPartial(part_spec)
    partial = CC.getSpecializedTemplateOrPartial(part_spec)
    @test partial.ptr != C_NULL && CC.getName(partial) == "KPart"
    li = CC.getTemplateArgsAsWritten(partial)
    @test li.ptr != C_NULL
    @test CC.getNumTemplateArgs(li) == 2
    @test !CC.is_null_handle(CC.getLAngleLoc(li))
    @test !CC.is_null_handle(CC.getRAngleLoc(li))
    tal0 = CC.getTemplateArg(li, 0)
    @test tal0.ptr != C_NULL
    @test CC.getKind(CC.getArgument(tal0)) == CC.LibClangEx.CXTemplateArgument_Type
    @test CC.getTypeSourceInfo(tal0).ptr != C_NULL
    @test !CC.is_null_handle(CC.getLocation(tal0))
    @test CC.isValid(CC.getSourceRange(tal0))
    tal1 = CC.getTemplateArg(li, 1)
    @test CC.getKind(CC.getArgument(tal1)) == CC.LibClangEx.CXTemplateArgument_Expression
    @test !CC.is_null_handle(CC.getSourceExpression(tal1))
    @test CC.getSourceExpression(tal1).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(li, 2)

    # ---------------- the defaulted flag round-trips on an owned, heap-boxed argument ----------------
    own = CC.TemplateArgument(part_qt)
    @test CC.getIsDefaulted(own) == false
    CC.setIsDefaulted(own, true)
    @test CC.getIsDefaulted(own) == true
    @test CC.structurallyEquals(own, own) == true
    dispose(own)

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclTemplate factories and inherited default arguments" begin
    I = create_interpreter(["-std=c++20"])
    src = """
    template <typename FT> struct FacBox { FT v; };
    template <typename FT> FT fac_identity(FT v) { return v; }
    template <typename FT> FT fac_var = FT();
    template <typename FT> using FacAlias = FacBox<FT>;
    template <typename FT> concept FacConcept = sizeof(FT) > 0;
    template <typename FA, typename FB = int> struct FacInhType { FA a; };
    template <int FM, int FN = 4> struct FacInhNonType {};
    template <template <typename> class FP, template <typename> class FQ = FacBox>
    struct FacInhTemplate {};
    """
    CC.parse(I, src)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    # a function-template lookup reports an overload set, which get_decl rejects; every name
    # below resolves to exactly one declaration, so take the first result instead.

    # Every factory below is handed the parameter list and the templated declaration of an
    # existing template, plus that template's own DeclContext: Clang re-seats the parameters'
    # owner while building the node, and re-seating them where they already live is a no-op.

    # ---------------- ClassTemplateDecl::Create ----------------
    @test f(I, "FacBox")
    ctd = CC.ClassTemplateDecl(first(CC.get_decls(f)))
    tu_dc = CC.getDeclContext(ctd)
    box_params = CC.getTemplateParameters(ctd)
    box_patt = CC.getTemplatedDecl(ctd)
    box_loc = CC.getLocation(ctd)
    ctd2 = CC.ClassTemplateDecl(ctx, tu_dc, box_loc, CC.getDeclName(ctd), box_params, box_patt)
    @test ctd2.ptr != C_NULL && CC.getName(ctd2) == "FacBox"
    @test ctd2.ptr != C_NULL
    @test ctd2.ptr != ctd.ptr
    @test CC.getName(ctd2) == "FacBox"
    @test CC.getTemplatedDecl(ctd2).ptr == box_patt.ptr
    @test CC.getTemplateParameters(ctd2).ptr == box_params.ptr

    # ---------------- FunctionTemplateDecl::Create ----------------
    @test f(I, "fac_identity")
    ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
    ftd2 = CC.FunctionTemplateDecl(ctx, CC.getDeclContext(ftd), CC.getLocation(ftd),
                                   CC.getDeclName(ftd), CC.getTemplateParameters(ftd),
                                   CC.getTemplatedDecl(ftd))
    @test ftd2.ptr != C_NULL && CC.getName(ftd2) == "fac_identity"
    @test CC.getName(ftd2) == "fac_identity"
    @test CC.getTemplatedDecl(ftd2).ptr == CC.getTemplatedDecl(ftd).ptr

    # ---------------- VarTemplateDecl::Create ----------------
    @test f(I, "fac_var")
    vtd = CC.VarTemplateDecl(first(CC.get_decls(f)))
    vtd2 = CC.VarTemplateDecl(ctx, CC.getDeclContext(vtd), CC.getLocation(vtd),
                              CC.getDeclName(vtd), CC.getTemplateParameters(vtd),
                              CC.getTemplatedDecl(vtd))
    @test vtd2.ptr != C_NULL && CC.getName(vtd2) == "fac_var"
    @test CC.getName(vtd2) == "fac_var"
    @test CC.getTemplatedDecl(vtd2).ptr == CC.getTemplatedDecl(vtd).ptr

    # ---------------- TypeAliasTemplateDecl::Create ----------------
    @test f(I, "FacAlias")
    tatd = CC.TypeAliasTemplateDecl(first(CC.get_decls(f)))
    tatd2 = CC.TypeAliasTemplateDecl(ctx, CC.getDeclContext(tatd), CC.getLocation(tatd),
                                     CC.getDeclName(tatd), CC.getTemplateParameters(tatd),
                                     CC.getTemplatedDecl(tatd))
    @test tatd2.ptr != C_NULL && CC.getName(tatd2) == "FacAlias"
    @test CC.getName(tatd2) == "FacAlias"
    # a TypeAliasDecl is not a DeclContext, so it cannot be the pattern of a class template
    @test_throws AssertionError CC.ClassTemplateDecl(ctx, tu_dc, box_loc, CC.getDeclName(ctd),
                                                     box_params, CC.getTemplatedDecl(tatd))

    # ---------------- ConceptDecl::Create ----------------
    @test f(I, "FacConcept")
    cd = CC.ConceptDecl(first(CC.get_decls(f)))
    cd2 = CC.ConceptDecl(ctx, CC.getDeclContext(cd), CC.getLocation(cd), CC.getDeclName(cd),
                         CC.getTemplateParameters(cd), CC.getConstraintExpr(cd))
    @test cd2.ptr != C_NULL && CC.getName(cd2) == "FacConcept"
    @test CC.getName(cd2) == "FacConcept"
    @test CC.getConstraintExpr(cd2).ptr == CC.getConstraintExpr(cd).ptr

    # ---------------- BuiltinTemplateDecl::Create ----------------
    btk = CC.LibClangEx.CXBuiltinTemplateKind_BTK__make_integer_seq
    btd = CC.BuiltinTemplateDecl(ctx, tu_dc, CC.getDeclName(ctd), btk)
    @test btd.ptr != C_NULL && CC.getName(btd) == "FacBox"
    @test btd.ptr != C_NULL
    @test CC.getBuiltinTemplateKind(btd) == btk
    # the parameter list is derived from the kind, not passed in
    @test CC.getTemplateParameters(btd).ptr != C_NULL

    # ---------------- FriendTemplateDecl, which Clang itself never builds ----------------
    dep_ty = CC.getType(first(CC.getFields(box_patt)))
    tsi = CC.getTrivialTypeSourceInfo(ctx, dep_ty, box_loc)
    friend_loc = CC.getLocation(cd)
    fr_d = CC.FriendTemplateDecl(ctx, tu_dc, box_loc, [box_params], ctd, friend_loc)
    @test fr_d.ptr != C_NULL
    @test fr_d.ptr != C_NULL
    @test CC.getNumTemplateParameters(fr_d) == 1
    @test CC.getTemplateParameterList(fr_d, 0).ptr == box_params.ptr
    @test CC.getFriendDecl(fr_d).ptr == ctd.ptr
    @test CC.getFriendType(fr_d).ptr == C_NULL
    @test CC.getFriendLoc(fr_d).ptr == friend_loc.ptr
    @test_throws AssertionError CC.getTemplateParameterList(fr_d, 1)

    fr_t = CC.FriendTemplateDecl(ctx, tu_dc, box_loc, [box_params], tsi, friend_loc)
    @test CC.getFriendType(fr_t).ptr == tsi.ptr
    @test CC.getFriendDecl(fr_t).ptr == C_NULL
    @test !CC.is_null_handle(CC.getFriendLoc(fr_t))

    # ---------------- inherited default arguments, one per parameter kind ----------------
    @test f(I, "FacInhType")
    tps = CC.getTemplateParameters(CC.ClassTemplateDecl(first(CC.get_decls(f))))
    p0 = CC.TemplateTypeParmDecl(CC.getParam(tps, 0))
    p1 = CC.TemplateTypeParmDecl(CC.getParam(tps, 1))
    @test !CC.hasDefaultArgument(p0)
    @test CC.hasDefaultArgument(p1)
    @test_throws AssertionError CC.setInheritedDefaultArgument(p1, ctx, p0)
    CC.setInheritedDefaultArgument(p0, ctx, p1)
    @test CC.hasDefaultArgument(p0)
    @test CC.defaultArgumentWasInherited(p0)
    @test CC.getDefaultArgumentInfo(p0).ptr == CC.getDefaultArgumentInfo(p1).ptr
    @test_throws AssertionError CC.setInheritedDefaultArgument(p0, ctx, p1)
    CC.removeDefaultArgument(p0)
    @test !CC.hasDefaultArgument(p0)

    @test f(I, "FacInhNonType")
    nps = CC.getTemplateParameters(CC.ClassTemplateDecl(first(CC.get_decls(f))))
    n0 = CC.NonTypeTemplateParmDecl(CC.getParam(nps, 0))
    n1 = CC.NonTypeTemplateParmDecl(CC.getParam(nps, 1))
    CC.setInheritedDefaultArgument(n0, ctx, n1)
    @test CC.defaultArgumentWasInherited(n0)
    @test CC.getDefaultArgument(n0).ptr == CC.getDefaultArgument(n1).ptr
    CC.removeDefaultArgument(n0)
    @test !CC.hasDefaultArgument(n0)

    @test f(I, "FacInhTemplate")
    pps = CC.getTemplateParameters(CC.ClassTemplateDecl(first(CC.get_decls(f))))
    q0 = CC.TemplateTemplateParmDecl(CC.getParam(pps, 0))
    q1 = CC.TemplateTemplateParmDecl(CC.getParam(pps, 1))
    @test CC.hasDefaultArgument(q1)
    CC.setInheritedDefaultArgument(q0, ctx, q1)
    @test CC.hasDefaultArgument(q0)
    @test CC.defaultArgumentWasInherited(q0)
    CC.removeDefaultArgument(q0)
    @test !CC.hasDefaultArgument(q0)

    dispose(f)
    dispose(I)
end

@testset "Coverage | template parameter factories, type-constraint reach-through, instantiation source" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    template <typename TpT, int TpN> struct TpBox { TpT v[TpN]; };
    template <typename TpC> concept TpConcept = sizeof(TpC) > 0;
    template <TpConcept TpX> struct TpConstrained { TpX v; };
    template <typename TpV> TpV tp_var = TpV();
    template <typename TpF> void tp_free(TpF);
    template <typename TpH> struct TpFriendHolder { friend void tp_free<>(TpH); };
    TpBox<int, 3> tp_box_use;
    int tp_var_use = tp_var<int>;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    K = CC.LibClangEx

    # ---------- the parameter factories: parms first, then the list that owns them ----------
    # An instantiated template's name resolves to more than one declaration, so every lookup
    # below selects by kind instead of calling get_decl.
    @test f(I, "TpBox")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    tpl = CC.getTemplateParameters(ctd)
    dc = CC.getDeclContext(ctd)
    loc = CC.getLocation(ctd)
    ttp = CC.TemplateTypeParmDecl(CC.getParam(tpl, 0))
    nttp = CC.NonTypeTemplateParmDecl(CC.getParam(tpl, 1))

    ttp2 = CC.TemplateTypeParmDecl(ctx, dc, loc, loc, 0, 0, CC.getIdentifier(ttp), true, false)
    @test ttp2.ptr != C_NULL && CC.getName(ttp2) == "TpT"
    @test ttp2.ptr != C_NULL
    @test ttp2.ptr != ttp.ptr
    @test CC.getDepth(ttp2) == 0
    @test CC.getIndex(ttp2) == 0
    @test CC.wasDeclaredWithTypename(ttp2)
    @test !CC.isParameterPack(ttp2)
    @test !CC.hasTypeConstraint(ttp2)
    @test !CC.hasInitializedTypeConstraint(ttp2)
    @test !CC.isExpandedParameterPack(ttp2)

    # the engaged arm of clang's std::optional<unsigned>: a pack of known expansion size
    ttp_pack = CC.TemplateTypeParmDecl(ctx, dc, loc, loc, 0, 3, nothing, true, true, false, 2)
    @test CC.isExpandedParameterPack(ttp_pack)
    @test CC.getNumExpansionParameters(ttp_pack) == 2

    nttp2 = CC.NonTypeTemplateParmDecl(ctx, dc, loc, loc, 0, 1, CC.getIdentifier(nttp),
                                       CC.getType(nttp), false)
    @test nttp2.ptr != C_NULL && CC.getName(nttp2) == "TpN"
    @test nttp2.ptr != C_NULL
    @test CC.getDepth(nttp2) == 0
    @test CC.getIndex(nttp2) == 1
    @test !CC.isParameterPack(nttp2)
    # the 12-bit position field: clang's own assert admits at most 0xFFE
    @test_throws AssertionError CC.NonTypeTemplateParmDecl(ctx, dc, loc, loc, 0, 4095, nothing,
                                                           CC.getType(nttp), false)

    ttpd = CC.TemplateTemplateParmDecl(ctx, dc, loc, 0, 2, false, CC.getIdentifier(ttp), tpl)
    @test ttpd.ptr != C_NULL
    @test ttpd.ptr != C_NULL
    @test CC.getDepth(ttpd) == 0
    @test CC.getIndex(ttpd) == 2
    @test CC.getTemplateParameters(ttpd).ptr == tpl.ptr

    tpl2 = CC.TemplateParameterList(ctx, loc, loc, [ttp2, nttp2], loc)
    @test tpl2.ptr != C_NULL && size(tpl2) == 2
    @test tpl2.ptr != C_NULL
    @test CC.size(tpl2) == 2
    @test CC.getParam(tpl2, 0).ptr == ttp2.ptr
    @test CC.getParam(tpl2, 1).ptr == nttp2.ptr
    @test CC.getDepth(tpl2) == 0
    @test CC.getRequiresClause(tpl2).ptr == C_NULL

    # ---------- depth/position are writable bit-fields on the two parm-position classes ----------
    d0, p0 = CC.getDepth(nttp2), CC.getPosition(nttp2)
    CC.setDepth(nttp2, 3)
    @test CC.getDepth(nttp2) == 3
    CC.setPosition(nttp2, 5)
    @test CC.getPosition(nttp2) == 5
    @test CC.getIndex(nttp2) == 5
    CC.setDepth(nttp2, d0)
    CC.setPosition(nttp2, p0)
    @test CC.getDepth(nttp2) == d0
    @test CC.getPosition(nttp2) == p0
    @test_throws AssertionError CC.setDepth(nttp2, 1 << 20)
    @test_throws AssertionError CC.setPosition(nttp2, 1 << 12)

    CC.setDepth(ttpd, 1)
    @test CC.getDepth(ttpd) == 1
    CC.setPosition(ttpd, 7)
    @test CC.getPosition(ttpd) == 7
    @test CC.getIndex(ttpd) == 7
    @test_throws AssertionError CC.setDepth(ttpd, 1 << 20)
    @test_throws AssertionError CC.setPosition(ttpd, 1 << 12)

    # ---------- reaching through a constrained parameter's TypeConstraint ----------
    @test f(I, "TpConstrained")
    ctd_c = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    cparm = CC.TemplateTypeParmDecl(CC.getParam(CC.getTemplateParameters(ctd_c), 0))
    @test CC.hasTypeConstraint(cparm)
    @test CC.hasInitializedTypeConstraint(cparm)
    @test !CC.is_null_handle(CC.getTypeConstraintConcept(cparm))
    @test CC.getName(CC.getTypeConstraintConcept(cparm)) == "TpConcept"
    @test !CC.is_null_handle(CC.getTypeConstraintImmediatelyDeclaredConstraint(cparm))
    @test !CC.is_null_handle(CC.getTypeConstraintConceptNameLoc(cparm))
    @test CC.is_null_handle(CC.getTypeConstraintTemplateArgsAsWritten(cparm))
    # an unconstrained parameter has no slot to read, and every accessor refuses it
    @test_throws AssertionError CC.getTypeConstraintConcept(ttp)
    @test_throws AssertionError CC.getTypeConstraintImmediatelyDeclaredConstraint(ttp)
    @test_throws AssertionError CC.getTypeConstraintConceptNameLoc(ttp)
    @test_throws AssertionError CC.getTypeConstraintTemplateArgsAsWritten(ttp)

    # ---------- what a specialization was instantiated from ----------
    @test f(I, "tp_box_use")
    boxvar = CC.VarDecl(get_decl(f))
    specrec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(boxvar)))
    @test specrec.ptr != C_NULL && CC.getName(specrec) == "TpBox"
    if CC.getDeclKindName(specrec) == "ClassTemplateSpecialization"
        cspec = CC.ClassTemplateSpecializationDecl(specrec)
        cfrom = CC.getInstantiatedFrom(cspec)
        # null for an explicit specialization, the specialized-template union otherwise
        @test cfrom.ptr == C_NULL || cfrom.ptr == CC.getSpecializedTemplateOrPartial(cspec).ptr
    end

    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    vtsd = nothing
    for d in CC.decls(tu_dc)
        if d isa CC.VarTemplateSpecializationDecl
            vtsd = d
            break
        end
    end
    if vtsd isa CC.VarTemplateSpecializationDecl
        vfrom = CC.getInstantiatedFrom(vtsd)
        @test vfrom.ptr == C_NULL || vfrom.ptr == CC.getSpecializedTemplateOrPartial(vtsd).ptr
    end

    # ---------- candidates of a dependent function-template specialization ----------
    # Only the friend declaration above carries one; every other function reports a NULL
    # handle, which the wrapper refuses instead of dereferencing.
    for d in CC.decls(tu_dc)
        d isa CC.FunctionDecl || continue
        info = CC.getDependentSpecializationInfo(d)
        info.ptr == C_NULL && continue
        cands = CC.getCandidates(info)
        @test cands isa Vector{CC.FunctionTemplateDecl}
        @test !isempty(cands)
        @test all(c -> c.ptr != C_NULL, cands)
    end
    @test_throws AssertionError CC.getCandidates(CC.DependentFunctionTemplateSpecializationInfo(C_NULL))

    # ---------- ImplicitConceptSpecializationDecl, built rather than found ----------
    @test CC.classofKind(CC.ImplicitConceptSpecializationDecl,
                         K.CXDeclKind_ImplicitConceptSpecialization)
    @test !CC.classofKind(CC.ImplicitConceptSpecializationDecl, K.CXDeclKind_Concept)
    ta1 = CC.TemplateArgument(CC.getType(boxvar))
    ta2 = CC.TemplateArgument(CC.getType(nttp))
    icsd = CC.ImplicitConceptSpecializationDecl(ctx, tu_dc, loc, [ta1])
    @test icsd.ptr != C_NULL
    @test icsd.ptr != C_NULL
    @test CC.getKind(icsd) == K.CXDeclKind_ImplicitConceptSpecialization
    @test length(CC.getTemplateArguments(icsd)) == 1
    @test first(CC.getTemplateArguments(icsd)).ptr != C_NULL
    CC.setTemplateArguments(icsd, [ta2])
    @test length(CC.getTemplateArguments(icsd)) == 1
    # the trailing array was sized once, at construction
    @test_throws AssertionError CC.setTemplateArguments(icsd, [ta1, ta2])
    dispose(ta1)
    dispose(ta2)

    dispose(f)
    dispose(I)
end
