using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

@testset "BoundNodes | ids and per-family extraction" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ccbn_var = 0;")
    ctx = CC.get_ast_context(I)
    err = CC.MatcherDiagnostics()

    # One match binding two nodes of different families: the variable itself and
    # its type.
    m = CC.parseMatcherExpression("varDecl(hasName(\"ccbn_var\"), hasType(qualType().bind(\"t\"))).bind(\"v\")", err)

    mf = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf, m)
    @test CC.matchAST(mf, ctx) == 1

    bn = CC.getMatch(mf, 0)
    @test CC.getNumBindings(bn) == 2
    # Clang keys the map on std::string, so the ids come back sorted
    @test CC.getBindingID(bn, 0) == "t"
    @test CC.getBindingID(bn, 1) == "v"
    @test_throws AssertionError CC.getBindingID(bn, 2)

    # The four accessors are the discriminator: the right family answers, the
    # wrong one is NULL, and so is an id nothing was bound to.
    d = CC.getNodeAsDecl(bn, "v")
    @test CC.getName(CC.resolve(d)) == "ccbn_var"
    @test CC.is_null_handle(CC.getNodeAsStmt(bn, "v"))
    @test CC.is_null_handle(CC.getNodeAsQualType(bn, "v"))

    t = CC.getNodeAsQualType(bn, "t")
    @test CC.getAsString(t) == "int"
    @test CC.is_null_handle(CC.getNodeAsDecl(bn, "t"))

    @test CC.is_null_handle(CC.getNodeAsDecl(bn, "no-such-id"))
    @test CC.is_null_handle(CC.getNodeAsStmt(bn, "no-such-id"))

    # The copy outlives the next run of the finder it came from.
    @test CC.matchAST(mf, ctx) == 1
    @test CC.getNumBindings(bn) == 2
    @test CC.decl_id(CC.getNodeAsDecl(bn, "v")) == CC.decl_id(d)

    dispose(bn)
    dispose(mf)
    dispose(m)
    dispose(err)
    dispose(I)
end

@testset "BoundNodes | TypeLoc bindings are owned boxes" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCBNLoc { int a; };")
    ctx = CC.get_ast_context(I)
    err = CC.MatcherDiagnostics()

    m = CC.parseMatcherExpression("typeLoc().bind(\"tl\")", err)
    mf = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf, m)
    @test CC.matchAST(mf, ctx) >= 1

    bn = CC.getMatch(mf, 0)
    @test CC.getNumBindings(bn) == 1
    @test CC.getBindingID(bn, 0) == "tl"

    tl = CC.getNodeAsTypeLoc(bn, "tl")
    @test !CC.is_null_handle(tl)
    @test !CC.isNull(tl)
    # a TypeLoc is a type plus where it was written, so it must name a type
    @test !CC.is_null_handle(CC.getType(tl))
    # ... and the same id is not a declaration
    @test CC.is_null_handle(CC.getNodeAsDecl(bn, "tl"))

    # each extraction is its own box, disposable independently
    tl2 = CC.getNodeAsTypeLoc(bn, "tl")
    @test tl2.ptr != tl.ptr
    @test CC.getAsString(CC.getType(tl2)) == CC.getAsString(CC.getType(tl))

    dispose(tl2)
    dispose(tl)
    dispose(bn)
    dispose(mf)
    dispose(m)
    dispose(err)
    dispose(I)
end
