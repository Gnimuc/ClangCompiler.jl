using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag
using Test

@testset "DeclBase | argument-taking surface" begin
    I = create_interpreter(String[])
    CC.parse(I,
             "namespace declbase_probe { struct S { int a; }; int g(int x) { return x; } }")
    f = DeclFinder(I)

    @test f(I, "declbase_probe::g")
    nd = get_decl(f)                       # resolved carrier
    g = CC.resolve(nd)

    # source range / location
    @test CC.isValid((CC.getSourceRange(g)).begin_loc)
    @test CC.isValid((CC.getSourceRange(g)).end_loc)
    @test !CC.is_null_handle(CC.getBodyRBrace(g))

    # flags
    @test CC.isInvalidDecl(g) == false
    @test CC.isImplicit(g) == false
    @test CC.isFromASTFile(g) == false
    @test CC.isFileContextDecl(g) == false
    @test !(CC.isFunctionPointerType(g))
    @test CC.isLocalExternDecl(g) == false
    @test CC.getAccessUnsafe(g) isa CC.LibClangEx.CXAccessSpecifier
    @test !(CC.isUsed(g))
    @test !(CC.isReferenced(g))
    @test !(CC.isThisDeclarationReferenced(g))

    # identifier namespaces: a function is an ordinary name, never a tag
    ns = CC.getIdentifierNamespace(g)
    @test ns & UInt32(CC.LibClangEx.CXDecl_IDNS_Ordinary) != 0
    @test CC.isInIdentifierNamespace(g, UInt32(CC.LibClangEx.CXDecl_IDNS_Ordinary))
    @test CC.hasTagIdentifierNamespace(g) == false
    @test CC.getFriendObjectKind(g) == CC.LibClangEx.CXDecl_FOK_None

    # availability / module ownership of a plain decl parsed from source
    @test CC.getAvailability(g) == CC.LibClangEx.CXAvailabilityResult_AR_Available
    @test isempty(CC.getAvailabilityMessage(g))
    @test CC.isDeprecated(g) == false
    @test CC.isUnavailable(g) == false
    @test !(CC.isWeakImported(g))
    @test CC.canBeWeakImported(g) isa Tuple{Bool,Bool}
    @test CC.getVersionIntroduced(g) === nothing
    @test !(CC.hasOwningModule(g))
    @test CC.getModuleOwnershipKind(g) isa CC.LibClangEx.CXDecl_ModuleOwnershipKind
    @test CC.isUnconditionallyVisible(g)
    @test CC.isReachable(g)
    @test !(CC.isModulePrivate(g))
    @test !(CC.isInExportDeclContext(g))
    @test !(CC.isInvisibleOutsideTheOwningModule(g))
    @test !(CC.isInAnotherModuleUnit(g))

    # body + redeclaration chain
    @test CC.hasBody(g)
    @test CC.getBody(g) isa CC.Stmt
    n = CC.getNumRedecls(g)
    @test n >= 1
    @test length(CC.getRedecls(g)) == n

    # attributes: none written, so the kind-indexed queries answer negatively
    @test Int(CC.getMaxAlignment(g)) == 0
    @test CC.hasAttrOfKind(g, CC.LibClangEx.CXAttrKind_Deprecated) == false
    @test CC.getAttrOfKind(g, CC.LibClangEx.CXAttrKind_Deprecated).ptr == C_NULL
    @test CC.hasDefiningAttr(g) == false
    # printToString renders the declaration itself (signature + body), not the
    # enclosing context's name
    @test occursin("int g(int x)", CC.printToString(g))

    # DeclContext side: the enclosing namespace
    dc = CC.getDeclContext(g)
    @test CC.classof(CC.castFromDeclContext(dc))
    @test CC.getDeclKind(dc) isa CC.LibClangEx.CXDeclKind
    @test CC.isNamespace(dc)
    @test CC.decls_empty(dc) == false
    @test CC.Encloses(dc, dc)
    @test CC.InEnclosingNamespaceSetOf(dc, dc)
    @test !CC.is_null_handle(CC.getRedeclContext(dc))
    @test !CC.is_null_handle(CC.getEnclosingNamespaceContext(dc))
    @test !CC.is_null_handle(CC.getNonTransparentContext(dc))
    @test !CC.is_null_handle(CC.getNonTransparentDeclContext(g))
    @test CC.containsDecl(dc, g)
    @test CC.containsDeclAndLoad(dc, g)
    @test CC.isDeclInLexicalTraversal(dc, g)
    @test length(CC.collectAllContexts(dc)) == CC.getNumAllContexts(dc)
    @test length(CC.getUsingDirectives(dc)) == CC.getNumUsingDirectives(dc)
    @test !(CC.hasExternalLexicalStorage(dc))
    @test !(CC.hasExternalVisibleStorage(dc))
    @test !(CC.shouldUseQualifiedLookup(dc))

    # lookup by DeclarationName round-trips back to the decl we started from
    name = CC.getDeclName(nd)
    found = CC.lookup(dc, name)
    @test length(found) == CC.getNumLookupResults(dc, name)
    @test !isempty(found)
    @test any(d -> CC.getDeclName(d) == name, found)

    # DeclarationName identity surface
    @test CC.getNameKind(name) == CC.LibClangEx.CXDeclarationName_Identifier
    @test CC.isIdentifier(name)
    @test CC.isDependentName(name) == false
    @test !CC.is_null_handle(CC.getAsIdentifierInfo(name))
    @test CC.compare(name, name) == 0
    @test !isempty(CC.getAsString(CC.getUsingDirectiveName()))
    @test CC.getCXXOverloadedOperator(name) ==
          CC.LibClangEx.CXOverloadedOperatorKind_OO_None

    # DeclarationNameTable: identifiers round-trip, operator names classify
    tbl = CC.getDeclarationNames(CC.getASTContext(nd))
    @test tbl isa CC.DeclarationNameTable
    @test CC.getIdentifier(tbl, CC.getIdentifier(nd)) == name
    op = CC.getCXXOperatorName(tbl, CC.LibClangEx.CXOverloadedOperatorKind_OO_Plus)
    @test CC.getNameKind(op) == CC.LibClangEx.CXDeclarationName_CXXOperatorName
    @test CC.getCXXOverloadedOperator(op) ==
          CC.LibClangEx.CXOverloadedOperatorKind_OO_Plus

    # DeclarationNameInfo: owned box, mutated and read back
    ni = CC.DeclarationNameInfo(name, CC.getLocation(nd))
    @test CC.isValid((CC.getSourceRange(ni)).begin_loc)
    @test CC.isValid((CC.getSourceRange(ni)).end_loc)
    @test CC.isInstantiationDependent(ni) == false
    @test CC.containsUnexpandedParameterPack(ni) == false
    @test CC.getNamedTypeInfo(ni).ptr == C_NULL
    # `ni` was built over an ordinary identifier, so the two name-kind-specific slots are
    # the defaults clang leaves them at -- the operator range invalid and the literal
    # operator location null. Asserting the range is *invalid* is what separates this
    # accessor from one reading the name's own range, which is valid.
    @test !CC.isValid((CC.getCXXOperatorNameRange(ni)).begin_loc)
    @test !CC.isValid((CC.getCXXOperatorNameRange(ni)).end_loc)
    @test CC.is_null_handle(CC.getCXXLiteralOperatorNameLoc(ni))
    CC.setName(ni, name)
    CC.setLoc(ni, CC.getLocation(nd))
    @test CC.getName(ni) == name
    dispose(ni)

    dispose(f)
    dispose(I)
end

@testset "DeclBase | module identity, no-load lookup, frontend timer" begin
    I = create_interpreter(String[])
    CC.parse(I,
             "namespace declbase_nl { struct T { int a; }; int h(int x) { return x; } }")
    f = DeclFinder(I)

    @test f(I, "declbase_nl::h")
    nd = get_decl(f)                       # resolved carrier

    # Objective-C container flag: absent on a C++ decl, and writes back
    @test CC.isTopLevelDeclInObjCContainer(nd) == false
    CC.setTopLevelDeclInObjCContainer(nd, false)
    @test CC.isTopLevelDeclInObjCContainer(nd) == false

    # deserialization identity of a decl parsed from source
    @test CC.isFromASTFile(nd) == false
    @test CC.isDiscardedInGlobalModuleFragment(nd) == false
    @test !(CC.shouldSkipCheckingODR(nd))
    @test CC.getGlobalID(nd) == 0
    @test CC.getOwningModuleID(nd) == 0

    # module ownership round-trips through the value it already holds
    mok = CC.getModuleOwnershipKind(nd)
    CC.setModuleOwnershipKind(nd, mok)
    @test CC.getModuleOwnershipKind(nd) == mok

    # the identifier-namespace statics agree with the decl-level predicates
    fns = CC.getIdentifierNamespaceForKind(CC.LibClangEx.CXDeclKind_Function)
    @test fns & UInt32(CC.LibClangEx.CXDecl_IDNS_Ordinary) != 0
    @test CC.isTagIdentifierNamespace(fns) == false
    @test CC.isTagIdentifierNamespace(CC.getIdentifierNamespaceForKind(CC.LibClangEx.CXDeclKind_Record))

    # the enclosing namespace, as a DeclContext
    ns = CC.getDeclContext(nd)
    @test CC.hasValidDeclKind(ns)
    @test CC.isObjCContainer(ns) == false
    @test (CC.dumpAsDecl(ns); true)       # writes to stderr

    # no-load lookup: same shape as lookup, which has already built the table
    name = CC.getDeclName(nd)
    @test length(CC.lookup(ns, name)) >= 1
    n_noload = CC.getNumNoloadLookupResults(ns, name)
    @test n_noload >= 1
    res = CC.noload_lookup(ns, name)
    @test res isa Vector{CC.NamedDecl}
    @test length(res) == n_noload
    @test all(d -> d.ptr != C_NULL, res)

    # external-storage flags: writing back the default leaves them off
    CC.setHasExternalLexicalStorage(ns, false)
    CC.setHasExternalVisibleStorage(ns, false)
    @test CC.hasExternalLexicalStorage(ns) == false
    @test CC.hasExternalVisibleStorage(ns) == false

    dispose(f)
    dispose(I)
end

@testset "DeclBase | flexible-array probe, group printing, uncached lookup, name-location union" begin
    I = create_interpreter(String[])
    CC.parse(I, """
                namespace declbase_a {
                struct FlexTail { int n; int tail[1]; };
                void grouped_a();
                void grouped_b();
                void nonmember_probe(int);
                void localextern_probe();
                void idns_probe();
                }
                """)
    f = DeclFinder(I)

    @test f(I, "declbase_a::FlexTail")
    rd = CC.CXXRecordDecl(get_decl(f))
    ctx = CC.getASTContext(rd)

    # Decl::isFlexibleArrayMemberLike is static, so it takes the declaration as an argument and
    # accepts none at all. Same type, same rule level, one with the trailing member and one with
    # no declaration: the answers differ, which is what says the DECLARATION is read rather than
    # the type alone.
    flds = CC.getFields(rd)
    tail = flds[end]
    @test CC.getName(tail) == "tail"
    lvl = CC.LibClangEx.CXStrictFlexArraysLevelKind_Default
    @test CC.isFlexibleArrayMemberLike(ctx, tail, CC.getType(tail), lvl) == true
    @test CC.isFlexibleArrayMemberLike(ctx, CC.Decl(C_NULL), CC.getType(tail), lvl, true) == false

    # printGroup: a single declaration, then two printed as one group
    @test f(I, "declbase_a::grouped_a")
    ga = get_decl(f)
    @test f(I, "declbase_a::grouped_b")
    gb = get_decl(f)
    @test occursin("grouped_a", CC.printGroupToString([ga]))
    both = CC.printGroupToString([ga, gb], 0)
    @test occursin("grouped_a", both)
    @test occursin("grouped_b", both)

    # the DeclContext corners that bypass the cached lookup table
    dc = CC.getDeclContext(ga)
    @test !CC.is_null_handle(CC.noload_decls_begin(dc))
    @test CC.noload_decls_begin(dc).ptr != C_NULL
    gname = CC.getDeclName(ga)
    uncached = CC.localUncachedLookup(dc, gname)
    @test uncached isa Vector{CC.NamedDecl}
    @test all(d -> d.ptr != C_NULL, uncached)
    @test any(d -> CC.getDeclName(d) == gname, uncached)
    prim = CC.getPrimaryContext(dc)
    CC.setMustBuildLookupTable(prim)
    @test !isempty(CC.lookup(prim, gname))

    # a C++ identifier has neither Objective-C selector shape
    @test CC.isObjCZeroArgSelector(gname) == false
    @test CC.isObjCOneArgSelector(gname) == false

    # DeclarationNameInfo: each location-union setter, on the name kind it asserts
    tbl = CC.getDeclarationNames(ctx)
    rec_ty = CC.getCanonicalType(ctx, CC.getRecordType(ctx, rd))
    loc = CC.getLocation(rd)
    ni = CC.DeclarationNameInfo(CC.getCXXConstructorName(tbl, rec_ty), loc)
    @test CC.getNamedTypeInfo(ni).ptr == C_NULL
    tsi = CC.getTrivialTypeSourceInfo(ctx, rec_ty, loc)
    CC.setNamedTypeInfo(ni, tsi)
    @test CC.getNamedTypeInfo(ni).ptr == tsi.ptr
    dispose(ni)

    op = CC.getCXXOperatorName(tbl, CC.LibClangEx.CXOverloadedOperatorKind_OO_Plus)
    nio = CC.DeclarationNameInfo(op, loc)
    CC.setCXXOperatorNameRange(nio, CC.SourceRange(loc, loc))
    @test CC.getCXXOperatorNameRange(nio).begin_loc.ptr == loc.ptr
    dispose(nio)

    ii = CC.getIdentifier(ga)
    nlit = CC.DeclarationNameInfo(CC.getCXXLiteralOperatorName(tbl, ii), loc)
    CC.setCXXLiteralOperatorNameLoc(nlit, loc)
    @test CC.getCXXLiteralOperatorNameLoc(nlit).ptr == loc.ptr
    dispose(nlit)

    # NestedNameSpecifier static builders, all interned in the context's arena
    g = CC.GlobalSpecifier(ctx)
    @test g isa CC.NestedNameSpecifier
    @test CC.getKind(g) == CC.LibClangEx.CXNestedNameSpecifierKind_Global
    sup = CC.SuperSpecifier(ctx, rd)
    @test CC.getKind(sup) == CC.LibClangEx.CXNestedNameSpecifierKind_Super
    @test CC.getAsRecordDecl(sup).ptr == rd.ptr
    nns = CC.NestedNameSpecifier(ctx, CC.NestedNameSpecifier(C_NULL), ii)
    @test CC.getKind(nns) == CC.LibClangEx.CXNestedNameSpecifierKind_Identifier
    @test CC.getAsIdentifier(nns).ptr == ii.ptr

    # the identifier-namespace mutators, each on a declaration written only for it
    # and looked up before it is mutated
    nmo = UInt32(CC.LibClangEx.CXDecl_IDNS_NonMemberOperator)
    @test f(I, "declbase_a::nonmember_probe")
    nm = get_decl(f)
    @test CC.getKind(nm) == CC.LibClangEx.CXDeclKind_Function
    @test CC.isInIdentifierNamespace(nm, nmo) == false
    CC.setNonMemberOperator(nm)
    @test CC.isInIdentifierNamespace(nm, nmo)

    @test f(I, "declbase_a::localextern_probe")
    le = get_decl(f)
    @test CC.isLocalExternDecl(le) == false
    CC.setLocalExternDecl(le)
    @test CC.isLocalExternDecl(le)

    @test f(I, "declbase_a::idns_probe")
    ip = get_decl(f)
    @test CC.getIdentifierNamespace(ip) != 0
    CC.clearIdentifierNamespace(ip)
    @test CC.getIdentifierNamespace(ip) == 0

    dispose(f)
    dispose(I)
end

@testset "DeclBase | attribute-list assignment and the lookup-name surface" begin
    I = create_interpreter(String[])
    CC.parse(I,
             """
             namespace declbase_k {
             __attribute__((deprecated)) void attr_source();
             void attr_sink();
             int lookup_probe(int);
             struct LookupTag { int m; };
             }
             namespace declbase_k2 { void elsewhere(); }
             """)
    f = DeclFinder(I)

    # setAttrs: the attribute list of one declaration, installed on a bare one
    @test f(I, "declbase_k::attr_source")
    src = get_decl(f)
    @test CC.hasAttrs(src)
    attrs = CC.getAttrs(src)
    @test !isempty(attrs)
    @test f(I, "declbase_k::attr_sink")
    sink = get_decl(f)
    @test CC.hasAttrs(sink) == false
    CC.setAttrs(sink, attrs)
    @test CC.hasAttrs(sink)
    @test CC.getNumAttrs(sink) == length(attrs)
    @test CC.getAttr(sink, 0).ptr == attrs[1].ptr
    @test_throws AssertionError CC.getAttr(sink, CC.getNumAttrs(sink))  # the restated clang assert (Invariant 3)
    CC.dropAttrs(sink)                      # leave the declaration as it was found
    @test CC.hasAttrs(sink) == false

    # the lookup table itself, on the context that owns it
    @test f(I, "declbase_k::lookup_probe")
    lp = get_decl(f)
    dc = CC.getDeclContext(lp)
    prim = CC.getPrimaryContext(dc)
    @test CC.buildLookup(prim)
    @test CC.hasLookupTable(prim)

    # lookups(): one entry per name, every entry a usable lookup key
    names = CC.getLookupNames(dc)
    @test names isa Vector{CC.DeclarationName}
    @test length(names) == CC.getNumLookupNames(dc)
    @test all(n -> n.ptr != C_NULL, names)
    @test "lookup_probe" in [CC.getAsString(n) for n in names]

    # noload_lookups(): the same walk restricted to what is already loaded
    nol = CC.getNoloadLookupNames(prim, true)
    @test nol isa Vector{CC.DeclarationName}
    @test length(nol) == CC.getNumNoloadLookupNames(prim, true)
    @test length(nol) <= length(names)

    # lookupSingleResult: the unique declaration behind a name, and nothing for a
    # name this context does not declare
    single = CC.lookupSingleResult(dc, CC.getDeclName(lp))
    @test single.ptr != C_NULL
    @test CC.getName(single) == "lookup_probe"
    @test f(I, "declbase_k2::elsewhere")
    other = CC.getDeclName(get_decl(f))
    @test CC.getNumLookupResults(dc, other) == 0
    @test CC.lookupSingleResult(dc, other).ptr == C_NULL

    dispose(f)
    dispose(I)
end

@testset "DeclContext forwarding: a context decl reaches the DeclContext API" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fwd_gvar; namespace FwdNS { int inner; } struct FwdS { int m; };")
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    f = DeclFinder(I)

    # A forwarded call and the explicit pivot are the same call. Not a tautology: the
    # forwarding applies clang_Decl_castToDeclContext, and skipping it would read
    # DeclContext fields out of Decl storage instead.
    @test CC.isTranslationUnit(tu) == CC.isTranslationUnit(CC.castToDeclContext(tu))
    @test CC.isTranslationUnit(tu)
    @test CC.isFileContext(tu)
    @test !CC.isRecord(tu)

    @test f(I, "FwdNS")
    ns = CC.NamespaceDecl(get_decl(f))
    @test CC.isNamespace(ns)
    @test !CC.isTranslationUnit(ns)
    # the offset really was applied: the namespace's parent context is the TU's context,
    # which is a different address from the TU's Decl*
    @test CC.getParent(ns).ptr == CC.castToDeclContext(tu).ptr
    @test CC.getParent(ns).ptr != tu.ptr

    @test f(I, "FwdS")
    rec = CC.resolve(get_decl(f))
    @test CC.isRecord(rec)
    @test !CC.isNamespace(rec)

    # A decl that is not a DeclContext is refused by dispatch, so the pivot's assert is
    # unreachable from here -- that is what the Union buys over a runtime check.
    @test f(I, "fwd_gvar")
    vd = CC.VarDecl(get_decl(f))
    @test !(vd isa CC.AbstractDeclContextDecl)
    @test_throws MethodError CC.isNamespace(vd)
    @test_throws MethodError CC.decls_empty(vd)

    # The Union admits exactly clang's DECL_CONTEXT set.
    @test tu isa CC.AbstractDeclContextDecl
    @test ns isa CC.AbstractDeclContextDecl
    @test rec isa CC.AbstractDeclContextDecl

    # `getDeclKindName` is declared on both Decl and DeclContext, so it is deliberately not
    # forwarded -- a context decl still reaches the Decl-side method.
    @test CC.getDeclKindName(tu) == "TranslationUnit"

    # `Decl::EnableStatistics` and `Decl::PrintStats` are static, so the class is a `::Type`
    # tag and not a receiver. Calling them is the whole assertion: the shape this replaced
    # passed a declaration to a binding that declares no parameters, so *every* call raised
    # a MethodError and no test could have noticed while none existed.
    @test (CC.EnableStatistics(CC.Decl); true)
    @test (CC.PrintStats(CC.Decl); true)
    # the tag is what keeps the two hierarchies' statics apart, and a declaration is no
    # longer a way to ask -- the receiver-taking spelling was the broken one
    @test !applicable(CC.PrintStats, tu)
    @test !applicable(CC.EnableStatistics, tu)

    dispose(f)
    dispose(I)
end

# The ObjC runtime is target-picked, and only Darwin's is non-fragile; pinning it keeps this
# fixture parsing the same way on all three CI hosts. See test/clang/api/AST/DeclObjC.jl.
const OBJC_ARGS = ["-x", "objective-c++", "-fobjc-runtime=macosx"]

@testset "stamped Decl predicate/cast surface" begin
    # The Attr and Stmt families each have a sweep like this; the Decl family had none, so
    # every `is<Name>Decl`/`<Name>Decl` pair was covered only where some test happened to
    # narrow to that class by hand — which for the ObjC classes was nowhere.
    #
    # Objective-C++ so both kinds of node are in one translation unit: a sweep over a single
    # node exercises the *refusing* branch of every cast but the handful that match it, and
    # the ObjC classes match nothing a C++ declaration can be.
    I = create_interpreter(OBJC_ARGS)
    # Wide enough that every stamped ObjC class has an instance: with one interface only two
    # of the fourteen ever ran their MATCHING branch, and a cast that matched nothing would
    # have passed the sweep by refusing everything.
    CC.parse(I, """
             int cd2_fn(int x) { return x; }
             @protocol CD2Proto
             - (void)cd2Proto;
             @end
             @interface CD2Iface <CD2Proto>
             {
                 int cd2_ivar;
             }
             @property (assign) int cd2Prop;
             - (void)cd2Method;
             @end
             @interface CD2Iface (CD2Cat)
             - (void)cd2Cat;
             @end
             @implementation CD2Iface
             @synthesize cd2Prop = cd2_ivar;
             - (void)cd2Method {}
             @end
             @implementation CD2Iface (CD2Cat)
             - (void)cd2Cat {}
             @end
             @compatibility_alias CD2Alias CD2Iface;
             @interface CD2Gen<CD2T> : CD2Iface
             @end
             """)
    ctx = CC.get_ast_context(I)
    top = collect(CC.decls_in(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))))
    fd = only(filter(d -> d isa CC.AbstractFunctionDecl, top))
    iface = only(filter(d -> d isa CC.ObjCInterfaceDecl &&
                             CC.getNameAsString(d) == "CD2Iface", top))
    @test CC.getNameAsString(fd) == "cd2_fn"
    @test CC.getNameAsString(iface) == "CD2Iface"

    # One representative per concrete ObjC carrier, found by walking rather than by naming the
    # classes: a class the walk cannot reach is a coverage hole the sweep should not hide.
    function walk!(out, dc)
        for d in CC.decls_in(dc)
            push!(out, d)
            d isa CC.AbstractDeclContextDecl && walk!(out, CC.castToDeclContext(d))
        end
        return out
    end
    everything = walk!(CC.AbstractDecl[], CC.castToDeclContext(CC.getTranslationUnitDecl(ctx)))
    gen = only(filter(d -> d isa CC.ObjCInterfaceDecl &&
                           CC.getNameAsString(d) == "CD2Gen", top))
    # A type parameter hangs off an ObjCTypeParamList rather than off the interface's
    # DeclContext, so the walk cannot reach it and it has to be asked for by name.
    push!(everything, CC.getTypeParam(gen, 0))
    reps = Dict{DataType,Any}()
    for d in everything
        startswith(string(nameof(typeof(d))), "ObjC") || continue
        get!(reps, typeof(d), d)
    end

    # Pair each stamped cast with the predicate of the same name rather than sweeping every
    # `is*` on a Decl: the hand-written predicates share that prefix and are not this
    # surface, and some of them carry preconditions a blind sweep would walk into.
    stamped = Tuple{Symbol,Any,Any}[]
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        v = getproperty(CC, nm)
        v isa Type && v !== CC.Decl || continue
        hasmethod(v, Tuple{CC.Decl}) || continue
        which(v, Tuple{CC.Decl}).sig <: Tuple{Type,CC.AbstractDecl} || continue
        pred = Symbol("is", nm)
        isdefined(CC, pred) || continue
        p = getproperty(CC, pred)
        hasmethod(p, Tuple{CC.Decl}) || continue
        push!(stamped, (nm, v, p))
    end
    # 90 pairs, one per class DeclWrappers.jl stamps a carrier for; the floor guards
    # against the enumeration silently matching nothing rather than pinning the count.
    @test length(stamped) >= 85

    # Every stamped ObjC class has a node above, except three that structurally cannot: two are
    # abstract C++ bases clang never instantiates (their casts still match, through the
    # interface and the implementation), and `@defs` is gone from ObjC 2.0. Comparing sets
    # rather than counting means a newly stamped class fails here instead of quietly going
    # unexercised.
    objc_stamped = Set(string(nm) for (nm, _, _) in stamped if startswith(string(nm), "ObjC"))
    never_a_node = Set(["ObjCContainerDecl", "ObjCImplDecl", "ObjCAtDefsFieldDecl"])
    @test setdiff(objc_stamped, never_a_node) ==
          Set(string(nameof(T)) for T in keys(reps))

    for node in [fd; sort!(collect(values(reps)); by=d -> string(nameof(typeof(d))))]
        base = CC.Decl(node)                 # widen: the cast has to establish the class
        r = CC.resolve(base)
        nmatch = 0
        for (nm, v, p) in stamped
            hit = p(base)
            @test hit isa Bool
            absT = isdefined(CC, Symbol("Abstract", nm)) ?
                   getproperty(CC, Symbol("Abstract", nm)) : nothing
            if hit
                # predicate, cast and the Julia abstract are three spellings of one
                # `classof`; a generated hierarchy that disagrees with clang shows up here
                absT === nothing || @test r isa absT
                @test v(base).ptr == base.ptr
                nmatch += 1
            else
                absT === nothing || @test !(r isa absT)
                @test_throws CC.CastError v(base)
            end
        end
        # a declaration matches its own class and every wrapped base above it, never zero
        @test nmatch >= 1
    end

    # Every stamped ObjC cast now runs its matching branch on some node above, and its
    # refusing branch on the C++ function. Spelled out once for the interface, since the loop
    # asserts the relationship and this asserts the class.
    @test CC.isObjCInterfaceDecl(CC.Decl(iface))
    @test !CC.isObjCInterfaceDecl(CC.Decl(fd))
    @test_throws CC.CastError CC.ObjCInterfaceDecl(CC.Decl(fd))
    @test CC.isObjCContainerDecl(CC.Decl(iface))     # the abstract base, also stamped

    dispose(I)
end
