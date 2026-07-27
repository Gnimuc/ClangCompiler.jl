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
