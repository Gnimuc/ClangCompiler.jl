using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Sema | scope navigation and lookup-result configuration" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace lookup_scope_ns { struct LookupScopeWidget { int f; }; }
    int lookup_scope_fn(int a) { return a; }
    """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))

    # --- Scope navigation ---
    # Between incremental parses the parser rests at translation-unit scope. Which of the
    # parent links are populated there is decided by the driver and the host, so only the
    # carrier shape is asserted for them.
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    @test !(CC.isBlockScope(sc))
    @test !(CC.isFunctionScope(sc))
    @test !(CC.isClassScope(sc))
    @test !(CC.containedInPrototypeScope(sc))
    # not a prototype scope, as the line above asserts, so the depth is the outermost
    @test Int(CC.getFunctionPrototypeDepth(sc)) == 0
    @test CC.is_null_handle(CC.getContinueParent(sc))
    @test CC.is_null_handle(CC.getBreakParent(sc))
    @test CC.is_null_handle(CC.getBlockParent(sc))
    @test CC.is_null_handle(CC.getTemplateParamParent(sc))

    # getLookupEntity is getEntity without the template-parameter-scope masking, so the
    # two agree on every scope that is not a template parameter scope. A translation-unit
    # rest is never a template-parameter scope.
    @test !CC.isTemplateParamScope(sc)
    @test CC.getLookupEntity(sc).ptr == CC.getEntity(sc).ptr

    scope_decls = CC.getDecls(sc)
    @test scope_decls isa Vector{CC.Decl}
    @test CC.decl_empty(sc) == isempty(scope_decls)
    # every decl the fill hands back is by construction declared in this scope
    @test all(d -> CC.isDeclScope(sc, d), scope_decls)

    # --- LookupResult configuration and diagnostic suppression ---
    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "lookup_scope_fn")), loc,
                        CC.CXLookupNameKind_LookupOrdinaryName)
    # the create shim uses clang's default Sema::NotForRedeclaration, which turns both
    # diagnostic flags on and leaves Shadowed/AllowHidden at their member initializers
    @test !CC.isForExternalRedeclaration(r)
    @test !CC.isShadowed(r)
    @test !CC.isSuppressingAccessDiagnostics(r)
    @test !CC.isSuppressingAmbiguousDiagnostics(r)
    @test CC.is_null_handle(CC.getBaseObjectType(r))
    # nothing has set a lookup context on `r` yet, so the context range is still the
    # invalid default -- the same unset state the null base object type reports, and a
    # value an accessor reading the name location instead would not produce
    @test !CC.isValid((CC.getContextRange(r)).begin_loc)
    @test !CC.isValid((CC.getContextRange(r)).end_loc)

    found = CC.LookupQualifiedName(sema, r, tu)
    @test found
    nd = CC.getResult(r)
    # AllowHidden starts false and this is not an external redeclaration lookup,
    # so nothing hidden is visible through it yet
    @test !CC.isHiddenDeclarationVisible(r, nd)
    @test CC.setAllowHidden(r, true) === nothing
    @test CC.isHiddenDeclarationVisible(r, nd)

    CC.suppressDiagnostics(r)
    @test CC.isSuppressingAccessDiagnostics(r)
    @test CC.isSuppressingAmbiguousDiagnostics(r)
    CC.dispose(r)

    dispose(I)
end

@testset "Sema | scope statement-kind predicates and lookup-result assembly" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    struct ScopeFlagWidget { int f; };
    int scope_flag_fn(int a) { return a; }
    """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))

    # --- Scope statement-kind predicates ---
    # Between incremental parses the parser rests at translation-unit scope. Which flags
    # the driver has left set there is host-decided, so only the shape is asserted.
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    @test !(CC.isConditionVarScope(sc))
    @test !(CC.hasUnrecoverableErrorOccurred(sc))
    @test !(CC.isClassInheritanceScope(sc))
    @test !(CC.isInCXXInlineMethodScope(sc))
    @test !(CC.isFunctionPrototypeScope(sc))
    @test !(CC.isFunctionDeclarationScope(sc))
    @test !(CC.isCatchScope(sc))
    @test !(CC.isSwitchScope(sc))
    @test !(CC.isContinueScope(sc))
    @test !(CC.isTryScope(sc))
    @test !(CC.isCompoundStmtScope(sc))
    @test !(CC.isControlScope(sc))

    # containedInPrototypeScope starts its walk at this scope, so a prototype scope is
    # always contained in one. A translation-unit rest is not a prototype scope.
    @test !CC.isFunctionPrototypeScope(sc)
    @test !CC.containedInPrototypeScope(sc)
    # isInCXXInlineMethodScope answers through the enclosing function scope, so it is
    # false whenever there is none. A translation-unit rest has no function parent.
    @test CC.is_null_handle(CC.getFnParent(sc))
    @test !CC.isInCXXInlineMethodScope(sc)

    # --- LookupResult: the "dependent bases left unsearched" flavour of not-found ---
    dn = CC.DeclarationName(CC.getIdentifierInfo(pp, "scope_flag_fn"))
    r0 = CC.LookupResult(sema, dn, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test !CC.wasNotFoundInCurrentInstantiation(r0)
    CC.setNotFoundInCurrentInstantiation(r0)
    @test CC.wasNotFoundInCurrentInstantiation(r0)
    @test CC.getResultKind(r0) == CC.CXLookupResultKind_NotFoundInCurrentInstantiation
    CC.dispose(r0)

    # --- LookupResult: name info round-trip ---
    r1 = CC.LookupResult(sema, dn, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    ni = CC.getLookupNameInfo(r1)
    # the create shim builds the name info out of the name and location handed to it
    @test CC.getName(ni).ptr == dn.ptr
    @test CC.getLoc(ni).ptr == CC.getNameLoc(r1).ptr
    CC.dispose(ni)

    ni2 = CC.DeclarationNameInfo(CC.DeclarationName(CC.getIdentifierInfo(pp, "ScopeFlagWidget")), loc)
    CC.setLookupNameInfo(r1, ni2)
    @test CC.getLookupName(r1).ptr == CC.getName(ni2).ptr
    # the name info is copied into the result, so the box stays the caller's to dispose
    CC.dispose(ni2)
    @test CC.getLookupName(r1).ptr != dn.ptr
    CC.dispose(r1)

    # --- LookupResult: assembling a result by hand ---
    r2 = CC.LookupResult(sema, dn, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    found = CC.LookupQualifiedName(sema, r2, tu)
    @test found
    nd = CC.getResult(r2)
    r3 = CC.LookupResult(sema, dn, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.empty(r3)
    CC.addDecl(r3, nd)
    @test !CC.empty(r3)
    @test CC.getNum(r3) == 1
    @test CC.getResultKind(r3) == CC.CXLookupResultKind_Found
    @test CC.getResult(r3).ptr == nd.ptr

    r4 = CC.LookupResult(sema, dn, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    CC.addAllDecls(r4, r3)
    @test CC.getNum(r4) == CC.getNum(r3)
    @test CC.getResult(r4).ptr == nd.ptr
    CC.dispose(r4)
    CC.dispose(r3)
    CC.dispose(r2)

    # --- LookupResult: naming class and base object type ---
    fnd = DeclFinder(I)
    @test fnd(I, "ScopeFlagWidget")
    rec = CC.CXXRecordDecl(get_decl(fnd))
    @test fnd(I, "scope_flag_fn")
    qt = CC.getType(CC.FunctionDecl(get_decl(fnd)))

    r5 = CC.LookupResult(sema, dn, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test !CC.isClassLookup(r5)
    CC.setNamingClass(r5, rec)
    @test CC.isClassLookup(r5)
    @test CC.getNamingClass(r5).ptr == rec.ptr
    CC.setBaseObjectType(r5, qt)
    @test CC.getBaseObjectType(r5).ptr == qt.ptr
    # a naming class turns clang's access check on when the result is destroyed, and this
    # result was assembled by hand rather than by a lookup
    CC.suppressDiagnostics(r5)
    CC.dispose(r5)

    dispose(fnd)
    dispose(I)
end

@testset "Sema | scope kinds, using-directives and lookup-result state" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace scope_kind_ns { struct ScopeKindWidget { int f; }; }
    using namespace scope_kind_ns;
    int scope_kind_fn(int a) { return a; }
    """)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)

    # Between incremental parses the parser rests at translation-unit scope. Which scope
    # kinds are set there is decided by the driver and the host, so only shapes are asserted.
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    @test !(CC.isInObjcMethodScope(sc))
    @test !(CC.isInObjcMethodOuterScope(sc))
    @test !(CC.isAtCatchScope(sc))
    @test !(CC.isFnTryCatchScope(sc))
    @test !(CC.isSEHTryScope(sc))
    @test !(CC.isSEHExceptScope(sc))
    @test !(CC.isOpenMPDirectiveScope(sc))
    @test !(CC.isOpenMPLoopDirectiveScope(sc))
    @test !(CC.isOpenMPSimdDirectiveScope(sc))
    @test !(CC.isOpenMPOrderClauseScope(sc))
    @test !(CC.isOpenMPLoopScope(sc))

    # Microsoft mangling numbering. A translation-unit rest is not a function, class or
    # block scope, so it has no mangling parent and both numbers fall back to 1.
    @test CC.is_null_handle(CC.getMSLastManglingParent(sc))
    @test CC.getMSLastManglingNumber(sc) == 1
    @test CC.getMSCurManglingNumber(sc) == 1

    # Contains compares scope depths, so a scope never contains itself. A translation-unit
    # rest has no parent; the parent/child polarity is asserted on free-standing scopes.
    @test !CC.Contains(sc, sc)
    @test CC.is_null_handle(CC.getParent(sc))

    # A parsed using-directive is filed in the translation-unit DeclContext, not in the
    # scope the parser comes to rest in, so this scope carries none. The populated case is
    # exercised where PushUsingDirective puts one on a scratch scope.
    n_ud = CC.getNumUsingDirectives(sc)
    @test n_ud == 0
    uds = CC.getUsingDirectives(sc)
    @test uds isa Vector{CC.UsingDirectiveDecl}
    @test isempty(uds)

    # dumpImplToString renders into a string what dump writes to stderr
    @test !isempty(CC.dumpImplToString(sc))

    # --- LookupResult state that has a matching reader ---
    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "scope_kind_fn")), loc,
                        CC.CXLookupNameKind_LookupOrdinaryName)
    # clang's member initializer for TemplateNameLookup is false, so the setter round-trips
    @test !CC.isTemplateNameLookup(r)
    CC.setTemplateNameLookup(r)
    @test CC.isTemplateNameLookup(r)
    CC.setTemplateNameLookup(r, false)
    @test !CC.isTemplateNameLookup(r)

    # setShadowed is one-way -- clang exposes no reset
    @test !CC.isShadowed(r)
    CC.setShadowed(r)
    @test CC.isShadowed(r)

    CC.setContextRange(r, CC.SourceRange(loc, loc))
    cr = CC.getContextRange(r)
    @test cr.begin_loc.ptr == loc.ptr
    @test cr.end_loc.ptr == loc.ptr
    CC.dispose(r)

    dispose(I)
end

@testset "Sema | lookup-result acceptability and result filtering" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    void lookup_filter_fn(int);
    void lookup_filter_fn(double);
    void lookup_filter_fn(char);
    """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))

    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "lookup_filter_fn")), loc,
                        CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.getSema(r).ptr == sema.ptr

    # suppressAccessDiagnostics turns off only the access half; suppressDiagnostics both.
    @test !CC.isSuppressingAccessDiagnostics(r)
    @test CC.suppressAccessDiagnostics(r) === nothing
    @test CC.isSuppressingAccessDiagnostics(r)
    @test !CC.isSuppressingAmbiguousDiagnostics(r)
    CC.suppressDiagnostics(r)
    @test CC.isSuppressingAmbiguousDiagnostics(r)

    # HideTags has no getter; only the call shape can be asserted. Restore clang's default.
    @test CC.setHideTags(r, false) === nothing
    @test CC.setHideTags(r, true) === nothing

    @test CC.LookupQualifiedName(sema, r, tu)
    @test CC.getNum(r) == 3

    nd = first(CC.getResults(r))
    @test CC.isAvailableForLookup(sema, nd)
    acc = CC.getAcceptableDecl(r, nd)
    # an available decl is accepted as itself, with no redeclaration search
    @test acc.ptr == nd.ptr

    # A full pass over the filter sees exactly the declarations the lookup holds.
    f = CC.makeFilter(r)
    @test f isa CC.LookupResultFilter
    seen = CC.NamedDecl[]
    while CC.hasNext(f)
        push!(seen, CC.next(f))
    end
    @test length(seen) == 3
    @test !CC.hasNext(f)
    CC.restart(f)
    @test CC.hasNext(f)

    # Erase the first declaration the restarted pass hands out, then drain the rest.
    CC.next(f)
    @test CC.erase(f) === nothing
    while CC.hasNext(f)
        CC.next(f)
    end
    @test CC.done(f) === nothing
    dispose(f)
    @test CC.getNum(r) == 2

    # Replacing a declaration with itself keeps the set intact but still marks the pass
    # changed, so done() re-resolves the kind.
    f2 = CC.makeFilter(r)
    kept = CC.next(f2)
    @test CC.replace(f2, kept) === nothing
    while CC.hasNext(f2)
        CC.next(f2)
    end
    CC.done(f2)
    dispose(f2)
    @test CC.getNum(r) == 2
    @test CC.resolveKindAfterFilter(r) === nothing
    @test CC.getNum(r) == 2

    # setFindLocalExtern only adds or removes the local-extern bit of the namespace mask.
    idns_before = CC.getIdentifierNamespace(r)
    CC.setFindLocalExtern(r, true)
    idns_with = CC.getIdentifierNamespace(r)
    @test idns_with | idns_before == idns_with
    CC.setFindLocalExtern(r, false)
    idns_without = CC.getIdentifierNamespace(r)
    @test idns_without | idns_with == idns_with

    # Last, because an ambiguous result is only safe to destroy with its diagnostics off.
    @test CC.isSuppressingAmbiguousDiagnostics(r)
    CC.setAmbiguousQualifiedTagHiding(r)
    @test CC.isAmbiguous(r)
    @test CC.getAmbiguityKind(r) == CC.CXAmbiguityKind_AmbiguousTagHiding

    CC.dispose(r)
    dispose(I)
end

@testset "Sema | alignment-stack slots, defaulted-function kinds and SFINAE traps" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    pp = CC.getPreprocessor(sema)
    sm = CC.getSourceManager(sema)

    # Sema::AlignPackInfo -- a pure value class; every assertion below is either a shape
    # check or a round-trip of a value this test itself set.
    packed = CC.AlignPackInfo(CC.CXAlignPackInfo_Packed, 4, false)
    @test packed isa CC.AlignPackInfo
    @test CC.IsPackAttr(packed)
    @test !CC.IsAlignAttr(packed)
    @test CC.getAlignMode(packed) == CC.CXAlignPackInfo_Packed
    @test CC.getPackNumber(packed) == 4
    @test CC.IsPackSet(packed)
    @test !CC.IsXLStack(packed)

    encoding = CC.getRawEncoding(packed)
    decoded = CC.AlignPackInfo(encoding)
    @test decoded isa CC.AlignPackInfo
    @test CC.IsPackAttr(decoded)
    @test CC.getAlignMode(decoded) == CC.getAlignMode(packed)
    @test CC.getPackNumber(decoded) == CC.getPackNumber(packed)
    @test CC.IsXLStack(decoded) == CC.IsXLStack(packed)
    dispose(decoded)
    dispose(packed)

    # the #pragma align form derives its pack number from the mode instead of taking one,
    # so a non-Packed mode leaves it unset
    aligned = CC.AlignPackInfo(CC.CXAlignPackInfo_Natural, true)
    @test CC.IsAlignAttr(aligned)
    @test !CC.IsPackAttr(aligned)
    @test CC.getAlignMode(aligned) == CC.CXAlignPackInfo_Natural
    @test CC.IsXLStack(aligned)
    @test !CC.IsPackSet(aligned)
    # IsPackSet is false above, so the slot still holds AlignPackInfo::UninitPackVal --
    # clang's "no pack number recorded" sentinel, not a pack number of zero
    @test Int(CC.getPackNumber(aligned)) == 255
    dispose(aligned)

    # Sema::DefaultedFunctionKind over a record declaring four special members and one
    # ordinary method
    CC.parse(I, """
             struct SemaDFKRec {
                 SemaDFKRec();
                 SemaDFKRec(const SemaDFKRec &);
                 SemaDFKRec &operator=(const SemaDFKRec &);
                 ~SemaDFKRec();
                 int plain() const;
             };
             """)
    f = DeclFinder(I)
    @test f(I, "SemaDFKRec")
    rec = CC.CXXRecordDecl(get_decl(f))
    methods = CC.getMethods(rec)
    @test !isempty(methods)

    any_special = false
    diag_idx = Int[]
    for m in methods
        dfk = CC.getDefaultedFunctionKind(sema, m)
        @test dfk isa CC.DefaultedFunctionKind
        special = CC.asSpecialMember(dfk)
        comparison = CC.asComparison(dfk)
        @test special isa CC.CXCXXSpecialMember
        @test comparison isa CC.CXDefaultedComparisonKind
        # each predicate is exactly "this arm is not its default value"
        @test CC.isSpecialMember(dfk) == (special != CC.CXCXXSpecialMember_CXXInvalid)
        @test CC.isComparison(dfk) == (comparison != CC.CXDefaultedComparisonKind_None)
        # getSpecialMember is the already-bound spelling of the same query
        @test special == CC.getSpecialMember(sema, m)
        push!(diag_idx, Int(CC.getDiagnosticIndex(dfk)))
        any_special |= CC.isSpecialMember(dfk)
        dispose(dfk)
    end
    @test any_special
    # the diagnostic index identifies which defaulted-function arm a diagnostic is about,
    # so the four special members this record declares carry four different ones. Its
    # numeric values are clang's, but their distinctness is the source's.
    @test length(diag_idx) >= 4
    @test length(unique(diag_idx)) == length(diag_idx)

    # LookupResult: the redeclaration flavour round-trips, and the result renders
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaDFKRec")), loc,
                        CC.CXLookupNameKind_LookupTagName)
    @test CC.redeclarationKind(r) == CC.CXRedeclarationKind_NotForRedeclaration
    CC.setRedeclarationKind(r, CC.CXRedeclarationKind_ForVisibleRedeclaration)
    @test CC.redeclarationKind(r) == CC.CXRedeclarationKind_ForVisibleRedeclaration
    CC.setRedeclarationKind(r, CC.CXRedeclarationKind_ForExternalRedeclaration)
    @test CC.redeclarationKind(r) == CC.CXRedeclarationKind_ForExternalRedeclaration
    CC.setRedeclarationKind(r, CC.CXRedeclarationKind_NotForRedeclaration)
    @test CC.redeclarationKind(r) == CC.CXRedeclarationKind_NotForRedeclaration
    @test CC.LookupQualifiedName(sema, r, tu)
    rendered = CC.printToString(r)
    @test rendered isa String
    @test !isempty(rendered)
    dispose(r)

    # Sema::SFINAETrap -- balanced RAII, so the shared Sema is left exactly as it was
    trap = CC.SFINAETrap(sema)
    @test trap isa CC.SFINAETrap
    # the trap compares against the counter it captured at construction
    @test CC.hasErrorOccurred(trap) == false
    dispose(trap)

    access_trap = CC.SFINAETrap(sema, true)
    @test !(CC.hasErrorOccurred(access_trap))
    dispose(access_trap)

    dispose(f)
    dispose(I)
end

@testset "Sema | free-standing scopes, instantiation scopes and code-synthesis sentinels" begin
    # A throwaway interpreter: the scopes built here are free-standing, but they are filled
    # with declarations parsed out of this snippet, so none of it may leak into the shared
    # interpreter.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             namespace ScopeNS { int scopeNSVar = 1; }
             using namespace ScopeNS;
             int scopeFn(int n) { int scopeLocal = n; return scopeLocal; }
             """)
    sema = CC.get_sema(I)
    diag = CC.getDiagnostics(sema)
    ctx = CC.getASTContext(sema)
    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    @assert f(I, "scopeFn") "lookup failed: scopeFn"
    fd = CC.FunctionDecl(get_decl(f))
    # A using-directive never comes back from a name lookup, so reach it through the context.
    ud = CC.UsingDirectiveDecl(first(d for d in CC.decls(tu_dc) if CC.getDeclKindName(d) == "UsingDirective"))

    decl_flags = UInt32(CC.CXScopeFlags_DeclScope)
    fn_flags = UInt32(CC.CXScopeFlags_FnScope) | decl_flags

    # --- A free-standing scope, its flag word and its re-initialisation ---
    s = CC.Scope(nothing, fn_flags, diag)
    @test s isa CC.Scope
    @test CC.getFlags(s) == fn_flags
    @test CC.isFunctionScope(s)
    @test CC.getDepth(s) == 0
    CC.setFlags(s, decl_flags)
    @test CC.getFlags(s) == decl_flags
    @test !CC.isFunctionScope(s)
    CC.Init(s, nothing, fn_flags)
    @test CC.getFlags(s) == fn_flags
    @test CC.isFunctionScope(s)

    # --- The entity, and the lookup entity that outlives a template parameter scope ---
    CC.setEntity(s, tu_dc)
    @test CC.getEntity(s).ptr == tu_dc.ptr
    @test CC.getLookupEntity(s).ptr == tu_dc.ptr

    CC.setIsConditionVarScope(s, true)
    @test CC.isConditionVarScope(s)
    CC.setIsConditionVarScope(s, false)
    @test !CC.isConditionVarScope(s)

    # --- Declarations move into and out of the scope's own set ---
    @test CC.decl_empty(s)
    CC.AddDecl(s, fd)
    @test !CC.decl_empty(s)
    @test any(d -> d.ptr == fd.ptr, CC.getDecls(s))
    CC.RemoveDecl(s, fd)
    @test CC.decl_empty(s)

    # --- Using-directives are appended in order ---
    n_ud = CC.getNumUsingDirectives(s)
    CC.PushUsingDirective(s, ud)
    @test CC.getNumUsingDirectives(s) == n_ud + 1
    @test CC.getUsingDirective(s, n_ud).ptr == ud.ptr
    # the vector accessor agrees with the indexed one, and reports the element's real kind
    pushed = CC.getUsingDirectives(s)
    @test length(pushed) == n_ud + 1
    @test all(u -> CC.getDeclKindName(u) == "UsingDirective", pushed)

    # --- The mangling number and its parent's move together, so the two calls cancel ---
    ms0 = CC.getMSCurManglingNumber(s)
    CC.incrementMSManglingNumber(s)
    @test CC.getMSCurManglingNumber(s) == ms0 + 1
    CC.decrementMSManglingNumber(s)
    @test CC.getMSCurManglingNumber(s) == ms0

    # --- The prototype index is defined only on a function prototype scope ---
    @test_throws AssertionError CC.getNextFunctionPrototypeIndex(s)
    proto = CC.Scope(s, UInt32(CC.CXScopeFlags_FunctionPrototypeScope) | decl_flags, diag)
    @test CC.isFunctionPrototypeScope(proto)
    @test CC.getDepth(proto) == 1
    # Contains compares depths: a parent contains its child and never the reverse.
    @test CC.Contains(s, proto)
    @test !CC.Contains(proto, s)
    i0 = CC.getNextFunctionPrototypeIndex(proto)
    @test i0 == 0
    @test CC.getNextFunctionPrototypeIndex(proto) == 1

    # The depth counts the prototype scopes enclosing a scope, itself included, so the
    # three scopes here sit at three different values. Without a nested one the suite only
    # ever sees 0, and an accessor pinned at the outermost value is indistinguishable from
    # a working one.
    proto2 = CC.Scope(proto, UInt32(CC.CXScopeFlags_FunctionPrototypeScope) | decl_flags, diag)
    @test Int(CC.getFunctionPrototypeDepth(s)) == 0
    @test Int(CC.getFunctionPrototypeDepth(proto)) == 1
    @test Int(CC.getFunctionPrototypeDepth(proto2)) == 2
    dispose(proto2)

    # --- A template parameter scope refuses setEntity but accepts setLookupEntity ---
    tps = CC.Scope(nothing, UInt32(CC.CXScopeFlags_TemplateParamScope) | decl_flags, diag)
    @test CC.isTemplateParamScope(tps)
    @test_throws AssertionError CC.setEntity(tps, tu_dc)
    CC.setLookupEntity(tps, tu_dc)
    @test CC.getLookupEntity(tps).ptr == tu_dc.ptr
    @test CC.getEntity(tps).ptr == C_NULL

    dispose(tps)
    dispose(proto)
    dispose(s)

    # --- A local instantiation scope reports its Sema and can be exited early ---
    before = CC.hasCurrentInstantiationScope(sema)
    lis = CC.LocalInstantiationScope(sema)
    @test CC.hasCurrentInstantiationScope(sema)
    @test CC.getSema(lis).ptr == sema.ptr
    @test !(CC.isLocalPackExpansion(lis, fd))
    CC.Exit(lis)
    @test CC.hasCurrentInstantiationScope(sema) == before
    CC.Exit(lis)   # idempotent
    dispose(lis)

    # --- Clearing a code-synthesis sentinel pops exactly what it pushed ---
    loc = CC.get_main_file_begin_loc(CC.getSourceManager(sema))
    n0 = CC.getNumCodeSynthesisContexts(sema)
    inst = CC.InstantiatingTemplate(sema, loc, fd)
    @test CC.getNumCodeSynthesisContexts(sema) >= n0
    CC.Clear(inst)
    @test CC.isInvalid(inst)
    @test CC.getNumCodeSynthesisContexts(sema) == n0
    CC.Clear(inst)   # idempotent
    @test CC.getNumCodeSynthesisContexts(sema) == n0
    dispose(inst)

    # --- Acceptability, the Julia spelling shared by LookupResult and Sema ---
    @test CC.isAcceptable(sema, fd) == CC.isVisible(sema, fd)
    @test CC.isAcceptable(sema, fd, true) == CC.isReachable(sema, fd)
    @test CC.isVisible(sema, fd)
    @test CC.isReachable(sema, fd)

    dispose(f)
    dispose(I)
end

@testset "Scope | AddFlags preserves what setFlags overwrites" begin
    diag = CC.DiagnosticsEngine()
    s = CC.Scope(nothing, UInt32(CC.CXScopeFlags_ContinueScope), diag)

    # the scope starts as a continue scope and nothing else: it is its own continue parent and
    # has no break parent
    @test UInt32(CC.getFlags(s)) == UInt32(CC.CXScopeFlags_ContinueScope)
    @test CC.getContinueParent(s).ptr == s.ptr
    @test CC.is_null_handle(CC.getBreakParent(s))

    # AddFlags ORs, so the pre-existing continue flag survives and the parent links update
    CC.AddFlags(s, UInt32(CC.CXScopeFlags_BreakScope))
    @test UInt32(CC.getFlags(s)) == (UInt32(CC.CXScopeFlags_ContinueScope) | UInt32(CC.CXScopeFlags_BreakScope))
    @test CC.getBreakParent(s).ptr == s.ptr
    @test CC.getContinueParent(s).ptr == s.ptr

    # the gates: only break/continue may be added, and never one already set
    @test_throws AssertionError CC.AddFlags(s, UInt32(CC.CXScopeFlags_BreakScope))
    @test_throws AssertionError CC.AddFlags(s, UInt32(CC.CXScopeFlags_FnScope))

    # setFlags is the destructive counterpart -- it overwrites rather than ORs
    CC.setFlags(s, UInt32(CC.CXScopeFlags_FnScope))
    @test UInt32(CC.getFlags(s)) == UInt32(CC.CXScopeFlags_FnScope)

    CC.dispose(s)
    CC.dispose(diag)
end
