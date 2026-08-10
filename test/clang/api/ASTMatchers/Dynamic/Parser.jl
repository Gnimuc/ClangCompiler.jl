using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "ASTMatchers | Dynamic Parser + Diagnostics" begin
    # A well-formed query parses, and leaves the sink clean.
    err = CC.MatcherDiagnostics()
    @test CC.getNumErrors(err) == 0
    @test isempty(CC.toString(err))
    @test isempty(CC.toStringFull(err))

    m = CC.parseMatcherExpression("cxxRecordDecl(hasName(\"Foo\"))", err)
    @test !CC.is_null_handle(m)
    @test CC.getNumErrors(err) == 0
    @test isempty(CC.toString(err))

    # ... so whatever the sink holds after the next parse came from that parse.
    bad = CC.parseMatcherExpression("noSuchMatcherAtAll()", err)
    @test CC.is_null_handle(bad)
    n1 = CC.getNumErrors(err)
    @test n1 >= 1
    @test !isempty(CC.toString(err))
    @test occursin("noSuchMatcherAtAll", CC.toString(err))
    # the full form carries the context chain on top of the same messages
    @test length(CC.toStringFull(err)) >= length(CC.toString(err))

    # One sink accumulates: a second failure is strictly more errors.
    syntax = CC.parseMatcherExpression("cxxRecordDecl(", err)
    @test CC.is_null_handle(syntax)
    @test CC.getNumErrors(err) > n1

    # An expression that parses but is not a matcher is rejected too, and a fresh
    # sink separates that failure from the ones above.
    err2 = CC.MatcherDiagnostics()
    notamatcher = CC.parseMatcherExpression("\"just a string\"", err2)
    @test CC.is_null_handle(notamatcher)
    @test CC.getNumErrors(err2) >= 1

    dispose(m)
    dispose(err2)
    dispose(err)
end

@testset "ASTMatchers | Dynamic Parser completions" begin
    # Offset 0 of an empty string is the whole root matcher set — the only way to
    # enumerate what the pinned LLVM knows without a hand-maintained list.
    root = CC.completeExpression("", 0)
    n = CC.getNumCompletions(root)
    @test n > 50

    texts = [CC.getTypedText(root, i) for i in 0:(n - 1)]
    decls = [CC.getMatcherDecl(root, i) for i in 0:(n - 1)]
    # nothing typed yet, so each completion is the whole matcher name plus its "("
    @test any(t -> startswith(t, "cxxRecordDecl("), texts)
    @test any(t -> startswith(t, "functionDecl("), texts)
    @test all(!isempty, decls)
    # Clang drops zero-specificity conversions (they always or never match), so
    # every completion that reaches here is a real narrowing
    @test all(i -> CC.getSpecificity(root, i) > 0, 0:(n - 1))

    # Inside a matcher's argument list only the convertible matchers are offered,
    # which is strictly fewer than at the root.
    inner = CC.completeExpression("cxxRecordDecl(", 14)
    ninner = CC.getNumCompletions(inner)
    @test ninner > 0
    @test ninner < n

    # An offset at the end of a partial name filters by that prefix.
    prefixed = CC.completeExpression("cxxRecord", 9)
    nprefixed = CC.getNumCompletions(prefixed)
    @test nprefixed > 0
    @test nprefixed < n

    dispose(prefixed)
    dispose(inner)
    dispose(root)
end
