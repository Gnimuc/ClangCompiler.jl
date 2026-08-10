using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "MatchFinder | run a parsed query over the AST" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCMFTag { int a; }; void ccmf_fn(int p) { int q = p; }")
    ctx = CC.get_ast_context(I)

    err = CC.MatcherDiagnostics()

    # An explicit record declaration. `unless(isImplicit())` drops the
    # injected-class-name Clang synthesises inside every C++ class, which carries
    # the same name and would otherwise match too.
    m = CC.parseMatcherExpression("cxxRecordDecl(hasName(\"CCMFTag\"), unless(isImplicit())).bind(\"r\")",
                                  err)
    @test !CC.is_null_handle(m)

    mf = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf, m)
    @test CC.matchAST(mf, ctx) == 1
    @test CC.getNumMatches(mf) == 1

    # Re-running clears rather than appends: the same query over the same AST
    # gives the same count, not twice it.
    @test CC.matchAST(mf, ctx) == 1
    @test CC.getNumMatches(mf) == 1

    # The match names the same declaration ordinary name lookup finds.
    bn = CC.getMatch(mf, 0)
    d = CC.getNodeAsDecl(bn, "r")
    @test !CC.is_null_handle(d)
    f = DeclFinder(I)
    @test f(I, "CCMFTag")
    @test CC.decl_id(d) == CC.decl_id(get_decl(f))
    dispose(f)

    # Dropping the `unless` can only add matches, never remove them.
    mall = CC.parseMatcherExpression("cxxRecordDecl(hasName(\"CCMFTag\"))", err)
    mfall = CC.MatchFinder()
    @test CC.addDynamicMatcher(mfall, mall)
    @test CC.matchAST(mfall, ctx) >= 1

    # A name nothing carries matches nothing — the same pipeline, zero results.
    mnone = CC.parseMatcherExpression("cxxRecordDecl(hasName(\"CCMFNoSuchTag\"))", err)
    mfnone = CC.MatchFinder()
    @test CC.addDynamicMatcher(mfnone, mnone)
    @test CC.matchAST(mfnone, ctx) == 0
    @test CC.getNumMatches(mfnone) == 0

    # Two matchers in one finder collect into one list.
    mfn = CC.parseMatcherExpression("functionDecl(hasName(\"ccmf_fn\")).bind(\"f\")", err)
    mboth = CC.MatchFinder()
    @test CC.addDynamicMatcher(mboth, m)
    @test CC.addDynamicMatcher(mboth, mfn)
    @test CC.matchAST(mboth, ctx) == 2

    @test CC.getNumErrors(err) == 0

    dispose(bn)
    dispose(mboth)
    dispose(mfnone)
    dispose(mfall)
    dispose(mf)
    dispose(mfn)
    dispose(mnone)
    dispose(mall)
    dispose(m)
    dispose(err)
    dispose(I)
end

@testset "MatchFinder | match on a single node" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCMFNodeTag { int a; }; void ccmf_node_fn() { int q = 1; }")
    ctx = CC.get_ast_context(I)
    err = CC.MatcherDiagnostics()

    f = DeclFinder(I)
    @test f(I, "CCMFNodeTag")
    tag = get_decl(f)
    fn = DeclFinder(I)
    @test fn(I, "ccmf_node_fn")
    func = get_decl(fn)

    # `match` tests the node itself, so the same finder answers 1 for a record and
    # 0 for a function — the discrimination is Clang's, not the shim's.
    mrec = CC.parseMatcherExpression("cxxRecordDecl()", err)
    mfr = CC.MatchFinder()
    @test CC.addDynamicMatcher(mfr, mrec)
    @test CC.matchDecl(mfr, tag, ctx) == 1
    @test CC.matchDecl(mfr, func, ctx) == 0
    @test CC.getNumMatches(mfr) == 0        # cleared by the second run

    # Statements: find one in the AST, then feed it back as a single node.
    mstmt = CC.parseMatcherExpression("declStmt().bind(\"s\")", err)
    mfs = CC.MatchFinder()
    @test CC.addDynamicMatcher(mfs, mstmt)
    @test CC.matchAST(mfs, ctx) >= 1
    bs = CC.getMatch(mfs, 0)
    s = CC.getNodeAsStmt(bs, "s")
    @test !CC.is_null_handle(s)

    mstmt2 = CC.parseMatcherExpression("declStmt()", err)
    mfs2 = CC.MatchFinder()
    @test CC.addDynamicMatcher(mfs2, mstmt2)
    @test CC.matchStmt(mfs2, s, ctx) == 1

    # Types: `int` against a type matcher.
    qt = CC.get_qual_type(CC.IntTy(ctx))
    mty = CC.parseMatcherExpression("qualType().bind(\"t\")", err)
    mft = CC.MatchFinder()
    @test CC.addDynamicMatcher(mft, mty)
    @test CC.matchQualType(mft, qt, ctx) == 1
    bt = CC.getMatch(mft, 0)
    @test CC.getAsString(CC.getNodeAsQualType(bt, "t")) == CC.getAsString(qt)

    @test CC.getNumErrors(err) == 0

    dispose(bt)
    dispose(bs)
    dispose(mft)
    dispose(mfs2)
    dispose(mfs)
    dispose(mfr)
    dispose(mty)
    dispose(mstmt2)
    dispose(mstmt)
    dispose(mrec)
    dispose(fn)
    dispose(f)
    dispose(err)
    dispose(I)
end
