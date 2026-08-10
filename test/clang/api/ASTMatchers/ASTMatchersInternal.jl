using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

@testset "DynTypedMatcher | supported kind and convertibility" begin
    err = CC.MatcherDiagnostics()

    decl = CC.parseMatcherExpression("decl()", err)
    stmt = CC.parseMatcherExpression("stmt()", err)
    record = CC.parseMatcherExpression("cxxRecordDecl()", err)
    expr = CC.parseMatcherExpression("expr()", err)
    qt = CC.parseMatcherExpression("qualType()", err)
    @test !CC.is_null_handle(decl)
    @test !CC.is_null_handle(stmt)
    @test !CC.is_null_handle(record)
    @test !CC.is_null_handle(expr)
    @test !CC.is_null_handle(qt)
    @test CC.getNumErrors(err) == 0

    # A dynamic matcher is keyed at its node FAMILY, not at the class its name suggests:
    # `cxxRecordDecl()` and `decl()` both report "Decl", and `expr()` reports "Stmt".
    # That is what makes the string a partition rather than a per-matcher label.
    @test CC.getSupportedKind(decl) == "Decl"
    @test CC.getSupportedKind(record) == "Decl"
    @test CC.getSupportedKind(stmt) == "Stmt"
    @test CC.getSupportedKind(expr) == "Stmt"
    @test CC.getSupportedKind(qt) == "QualType"
    @test CC.getSupportedKind(decl) != CC.getSupportedKind(stmt)

    # canConvertTo is that same partition asked one pair at a time: it holds exactly when
    # two matchers share a family, so it is reflexive and SYMMETRIC -- not the directional
    # base-to-derived relation the matcher names suggest. Asserting it as an equivalence
    # over every pair is what would catch a shim that read only one operand's kind.
    all_ms = [decl, record, stmt, expr, qt]
    fams = CC.getSupportedKind.(all_ms)
    for (i, a) in enumerate(all_ms), (j, b) in enumerate(all_ms)
        @test CC.canConvertTo(a, b) == (fams[i] == fams[j])
    end

    dispose(qt)
    dispose(expr)
    dispose(record)
    dispose(stmt)
    dispose(decl)
    dispose(err)
end

@testset "DynTypedMatcher | tryBind and traversal kind" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCDTMTag { int a; };")
    ctx = CC.get_ast_context(I)
    err = CC.MatcherDiagnostics()

    base = CC.parseMatcherExpression("cxxRecordDecl(hasName(\"CCDTMTag\"), unless(isImplicit()))",
                                     err)
    @test !CC.is_null_handle(base)

    # Unbound, the match carries no ids at all.
    mf0 = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf0, base)
    @test CC.matchAST(mf0, ctx) == 1
    bn0 = CC.getMatch(mf0, 0)
    @test CC.getNumBindings(bn0) == 0

    # tryBind adds the id after the fact, without re-parsing.
    bound = CC.tryBind(base, "b")
    @test !CC.is_null_handle(bound)
    mf1 = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf1, bound)
    @test CC.matchAST(mf1, ctx) == 1
    bn1 = CC.getMatch(mf1, 0)
    @test CC.getNumBindings(bn1) == 1
    @test CC.getBindingID(bn1, 0) == "b"
    @test !CC.is_null_handle(CC.getNodeAsDecl(bn1, "b"))
    # binding does not change what is matched
    @test CC.getSupportedKind(bound) == CC.getSupportedKind(base)

    # A freshly parsed matcher defers to its context, so it forces no kind.
    @test CC.getTraversalKind(base) === nothing

    forced = CC.withTraversalKind(base, CC.CXTraversalKind_TK_IgnoreUnlessSpelledInSource)
    @test !CC.is_null_handle(forced)
    @test CC.getTraversalKind(forced) === CC.CXTraversalKind_TK_IgnoreUnlessSpelledInSource
    # the later call wins over the earlier one
    reforced = CC.withTraversalKind(forced, CC.CXTraversalKind_TK_AsIs)
    @test CC.getTraversalKind(reforced) === CC.CXTraversalKind_TK_AsIs
    # and the source matcher is untouched — these are new matchers, not mutations
    @test CC.getTraversalKind(base) === nothing
    @test CC.getTraversalKind(forced) === CC.CXTraversalKind_TK_IgnoreUnlessSpelledInSource

    # a wrapped matcher is still the same matcher: it still finds the record
    mf2 = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf2, forced)
    @test CC.matchAST(mf2, ctx) == 1

    @test CC.getNumErrors(err) == 0

    dispose(bn1)
    dispose(bn0)
    dispose(mf2)
    dispose(mf1)
    dispose(mf0)
    dispose(reforced)
    dispose(forced)
    dispose(bound)
    dispose(base)
    dispose(err)
    dispose(I)
end
