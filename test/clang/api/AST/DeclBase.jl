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
    @test CC.getSourceRange(g) isa CC.SourceRange
    @test CC.getBodyRBrace(g) isa CC.SourceLocation

    # flags
    @test CC.isInvalidDecl(g) == false
    @test CC.isImplicit(g) == false
    @test CC.isFromASTFile(g) == false
    @test CC.isFileContextDecl(g) == false
    @test CC.isFunctionPointerType(g) isa Bool
    @test CC.isLocalExternDecl(g) == false
    @test CC.getAccessUnsafe(g) isa CC.LibClangEx.CXAccessSpecifier
    @test CC.isUsed(g) isa Bool
    @test CC.isReferenced(g) isa Bool
    @test CC.isThisDeclarationReferenced(g) isa Bool

    # identifier namespaces: a function is an ordinary name, never a tag
    ns = CC.getIdentifierNamespace(g)
    @test ns & UInt32(CC.LibClangEx.CXDecl_IDNS_Ordinary) != 0
    @test CC.isInIdentifierNamespace(g, UInt32(CC.LibClangEx.CXDecl_IDNS_Ordinary))
    @test CC.hasTagIdentifierNamespace(g) == false
    @test CC.getFriendObjectKind(g) == CC.LibClangEx.CXDecl_FOK_None

    # availability / module ownership of a plain decl parsed from source
    @test CC.getAvailability(g) == CC.LibClangEx.CXAvailabilityResult_AR_Available
    @test CC.getAvailabilityMessage(g) isa String
    @test CC.isDeprecated(g) == false
    @test CC.isUnavailable(g) == false
    @test CC.isWeakImported(g) isa Bool
    @test CC.canBeWeakImported(g) isa Tuple{Bool,Bool}
    @test CC.getVersionIntroduced(g) === nothing
    @test CC.hasOwningModule(g) isa Bool
    @test CC.getModuleOwnershipKind(g) isa CC.LibClangEx.CXDecl_ModuleOwnershipKind
    @test CC.isUnconditionallyVisible(g) isa Bool
    @test CC.isReachable(g) isa Bool
    @test CC.isModulePrivate(g) isa Bool
    @test CC.isInExportDeclContext(g) isa Bool
    @test CC.isInvisibleOutsideTheOwningModule(g) isa Bool
    @test CC.isInAnotherModuleUnit(g) isa Bool

    # body + redeclaration chain
    @test CC.hasBody(g)
    @test CC.getBody(g) isa CC.Stmt
    n = CC.getNumRedecls(g)
    @test n >= 1
    @test length(CC.getRedecls(g)) == n

    # attributes: none written, so the kind-indexed queries answer negatively
    @test CC.getMaxAlignment(g) isa Integer
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
    @test CC.InEnclosingNamespaceSetOf(dc, dc) isa Bool
    @test CC.getRedeclContext(dc) isa CC.DeclContext
    @test CC.getEnclosingNamespaceContext(dc) isa CC.DeclContext
    @test CC.getNonTransparentContext(dc) isa CC.DeclContext
    @test CC.getNonTransparentDeclContext(g) isa CC.DeclContext
    @test CC.containsDecl(dc, g)
    @test CC.containsDeclAndLoad(dc, g)
    @test CC.isDeclInLexicalTraversal(dc, g)
    @test length(CC.collectAllContexts(dc)) == CC.getNumAllContexts(dc)
    @test length(CC.getUsingDirectives(dc)) == CC.getNumUsingDirectives(dc)
    @test CC.hasExternalLexicalStorage(dc) isa Bool
    @test CC.hasExternalVisibleStorage(dc) isa Bool
    @test CC.shouldUseQualifiedLookup(dc) isa Bool

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
    @test CC.getAsIdentifierInfo(name) isa CC.IdentifierInfo
    @test CC.compare(name, name) == 0
    @test CC.getAsString(CC.getUsingDirectiveName()) isa String
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
    @test CC.getSourceRange(ni) isa CC.SourceRange
    @test CC.isInstantiationDependent(ni) == false
    @test CC.containsUnexpandedParameterPack(ni) == false
    @test CC.getNamedTypeInfo(ni).ptr == C_NULL
    @test CC.getCXXOperatorNameRange(ni) isa CC.SourceRange
    @test CC.getCXXLiteralOperatorNameLoc(ni) isa CC.SourceLocation
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
    @test CC.shouldSkipCheckingODR(nd) isa Bool
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
