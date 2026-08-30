using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

@testset "VariantValue | one alternative at a time" begin
    nothing_v = CC.VariantValue()
    b = CC.VariantValue(true)
    u = CC.VariantValue(42)
    d = CC.VariantValue(2.5)
    s = CC.VariantValue("hello")

    @test !CC.hasValue(nothing_v)
    @test CC.hasValue(b)
    @test CC.hasValue(u)
    @test CC.hasValue(d)
    @test CC.hasValue(s)

    # Each value answers yes to exactly one tag, so the tags partition them.
    tags = [CC.isBoolean, CC.isUnsigned, CC.isDouble, CC.isString, CC.isMatcher]
    for v in (b, u, d, s)
        @test count(f -> f(v), tags) == 1
    end
    @test count(f -> f(nothing_v), tags) == 0

    # ... and the payload survives the round trip.
    @test CC.isBoolean(b) && CC.getBoolean(b)
    @test CC.isUnsigned(u) && CC.getUnsigned(u) == 42
    @test CC.isDouble(d) && CC.getDouble(d) == 2.5
    @test CC.isString(s) && CC.getString(s) == "hello"
    @test !CC.getBoolean(CC.VariantValue(false))

    # `Bool` is not the unsigned alternative, matching Clang's own disambiguation.
    @test !CC.isUnsigned(b)
    @test !CC.isBoolean(u)

    # Reading through the wrong tag is undefined in Clang, so the wrapper refuses.
    @test_throws AssertionError CC.getUnsigned(b)
    @test_throws AssertionError CC.getString(u)
    @test_throws AssertionError CC.getDouble(s)
    @test_throws AssertionError CC.getBoolean(nothing_v)

    # The type name is per-alternative and never empty.
    names = [CC.getTypeAsString(v) for v in (nothing_v, b, u, d, s)]
    @test all(!isempty, names)
    @test length(unique(names)) == length(names)

    # Nothing is a matcher here, so the total accessor answers NULL rather than
    # asserting.
    @test CC.is_null_handle(CC.getSingleMatcher(s))
    @test CC.is_null_handle(CC.getSingleMatcher(nothing_v))

    dispose(s)
    dispose(d)
    dispose(u)
    dispose(b)
    dispose(nothing_v)
end

@testset "VariantValue | the matcher alternative" begin
    err = CC.MatcherDiagnostics()
    m = CC.parseMatcherExpression("cxxRecordDecl()", err)

    v = CC.VariantValue(m)
    @test CC.hasValue(v)
    @test CC.isMatcher(v)
    @test !CC.isString(v)
    @test occursin("Matcher<", CC.getTypeAsString(v))

    round = CC.getSingleMatcher(v)
    @test CC.getSupportedKind(round) == CC.getSupportedKind(m)

    # the value holds its own copy: disposing the source leaves it usable
    dispose(m)
    @test CC.isMatcher(v)

    dispose(round)
    dispose(v)
    dispose(err)
end

@testset "NamedValueMap | let-bound matchers in a query string" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCNVMTag { int a; };")
    ctx = CC.get_ast_context(I)

    err = CC.MatcherDiagnostics()
    m = CC.parseMatcherExpression("cxxRecordDecl(hasName(\"CCNVMTag\"), unless(isImplicit()))", err)

    nv = CC.NamedValueMap()
    @test size(nv) == 0
    @test !contains(nv, "ccnvmRecord")

    v = CC.VariantValue(m)
    CC.set(nv, "ccnvmRecord", v)
    @test size(nv) == 1
    @test contains(nv, "ccnvmRecord")
    @test !contains(nv, "ccnvmOther")

    # Re-binding the same name replaces rather than adds.
    shadow = CC.VariantValue(true)
    CC.set(nv, "ccnvmRecord", shadow)
    @test size(nv) == 1
    CC.set(nv, "ccnvmRecord", v)
    @test size(nv) == 1
    dispose(shadow)

    # Without the dictionary the bare identifier is not a matcher ...
    errbare = CC.MatcherDiagnostics()
    bare = CC.parseMatcherExpression("ccnvmRecord", errbare)
    @test CC.is_null_handle(bare)
    @test CC.getNumErrors(errbare) >= 1

    # ... and with it, the name stands in for the matcher it was bound to.
    errnamed = CC.MatcherDiagnostics()
    named = CC.parseMatcherExpression("ccnvmRecord", nv, errnamed)
    @test CC.getNumErrors(errnamed) == 0
    @test CC.getSupportedKind(named) == CC.getSupportedKind(m)

    bound = CC.tryBind(named, "n")
    mf = CC.MatchFinder()
    @test CC.addDynamicMatcher(mf, bound)
    @test CC.matchAST(mf, ctx) == 1
    bn = CC.getMatch(mf, 0)
    @test CC.getBindingID(bn, 0) == "n"
    @test CC.getName(CC.resolve(CC.getNodeAsDecl(bn, "n"))) == "CCNVMTag"

    dispose(bn)
    dispose(mf)
    dispose(bound)
    dispose(named)
    dispose(errnamed)
    dispose(errbare)
    dispose(v)
    dispose(nv)
    dispose(m)
    dispose(err)
    dispose(I)
end
