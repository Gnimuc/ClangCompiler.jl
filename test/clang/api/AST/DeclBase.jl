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
    nd = get_decl(f)                       # NamedDecl
    g = CC.resolve(nd)

    # source range / location
    @test CC.getSourceRange(g) isa CC.SourceRange  # shape-only
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
    @test CC.getMaxAlignment(g) isa Integer  # shape-only: the host decides this
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
    @test CC.getSourceRange(ni) isa CC.SourceRange  # shape-only
    @test CC.isInstantiationDependent(ni) == false
    @test CC.containsUnexpandedParameterPack(ni) == false
    @test CC.getNamedTypeInfo(ni).ptr == C_NULL
    @test CC.getCXXOperatorNameRange(ni) isa CC.SourceRange  # shape-only
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
    nd = get_decl(f)                       # NamedDecl

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
    rd = CC.CXXRecordDecl(get_decl(f).ptr)
    ctx = CC.getASTContext(rd)

    # Decl::isFlexibleArrayMemberLike is static: the trailing member, then the same
    # query with no declaration at all (the rule level is passed, never read out of ctx,
    # so only the shape of the answer is host-independent)
    flds = CC.getFields(rd)
    tail = flds[end]
    @test CC.getName(tail) == "tail"
    lvl = CC.LibClangEx.CXStrictFlexArraysLevelKind_Default
    @test CC.isFlexibleArrayMemberLike(ctx, tail, CC.getType(tail), lvl)
    @test CC.isFlexibleArrayMemberLike(ctx, CC.Decl(C_NULL), CC.getType(tail), lvl,
                                       true) isa Bool

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
