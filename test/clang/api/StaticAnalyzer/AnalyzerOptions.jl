using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "StaticAnalyzer | AnalyzerOptions" begin
    # The generated name lists are static and need no invocation at all. Both filters are
    # partitions: `debug.*` is always gone, `alpha.*` only appears with the experimental
    # flag, so the two calls must disagree in exactly that way.
    checkers = CC.getRegisteredCheckers()
    experimental = CC.getRegisteredCheckers(; include_experimental=true)
    @test "core.DivideZero" in checkers
    @test !any(startswith("debug."), checkers)
    @test !any(startswith("alpha."), checkers)
    @test any(startswith("alpha."), experimental)
    @test !any(startswith("debug."), experimental)
    @test issubset(checkers, experimental)
    @test length(experimental) > length(checkers)

    packages = CC.getRegisteredPackages()
    packages_experimental = CC.getRegisteredPackages(; include_experimental=true)
    @test "core" in packages
    @test "cplusplus" in packages
    @test !("debug" in packages)
    @test !("alpha" in packages)
    @test "alpha" in packages_experimental
    @test !("debug" in packages_experimental)

    # Everything below is a borrowed view onto the invocation's own options object, so the
    # invocation owns it and there is nothing to dispose but the invocation.
    inv = CC.CompilerInvocation()
    opts = CC.getAnalyzerOpts(inv)

    # A fresh invocation carries no checker selection at all.
    @test CC.getNumCheckersAndPackages(opts) == 0
    CC.addCheckerOrPackage(opts, "core", true)
    CC.addCheckerOrPackage(opts, "deadcode.DeadStores", false)
    @test CC.getNumCheckersAndPackages(opts) == 2
    @test CC.getCheckerOrPackageName(opts, 0) == "core"
    @test CC.isCheckerOrPackageEnabled(opts, 0) == true
    @test CC.getCheckerOrPackageName(opts, 1) == "deadcode.DeadStores"
    @test CC.isCheckerOrPackageEnabled(opts, 1) == false
    @test_throws AssertionError CC.getCheckerOrPackageName(opts, 2)
    @test_throws AssertionError CC.isCheckerOrPackageEnabled(opts, 2)

    @test CC.getNumSilencedCheckersAndPackages(opts) == 0
    CC.addSilencedCheckerOrPackage(opts, "core.NullDereference")
    @test CC.getNumSilencedCheckersAndPackages(opts) == 1
    @test CC.getSilencedCheckerOrPackage(opts, 0) == "core.NullDereference"
    @test_throws AssertionError CC.getSilencedCheckerOrPackage(opts, 1)

    # Config is a map, so the round trip is by key; the index enumeration must agree with
    # it, whatever bucket order the StringMap happens to use.
    @test CC.getNumConfigEntries(opts) == 0
    @test CC.getConfig(opts, "widen-loops") == ""
    CC.setConfig(opts, "widen-loops", "true")
    CC.setConfig(opts, "max-nodes", "75000")
    @test CC.getNumConfigEntries(opts) == 2
    @test CC.getConfig(opts, "widen-loops") == "true"
    CC.setConfig(opts, "widen-loops", "false")     # overwrites rather than appends
    @test CC.getNumConfigEntries(opts) == 2
    @test CC.getConfig(opts, "widen-loops") == "false"
    seen = Dict(CC.getConfigKey(opts, i) => CC.getConfigValue(opts, i) for i = 0:1)
    @test seen == Dict("widen-loops" => "false", "max-nodes" => "75000")
    @test_throws AssertionError CC.getConfigKey(opts, 2)
    @test_throws AssertionError CC.getConfigValue(opts, 2)

    # Scalar knobs: each default is the one clang's own constructor sets, and each setter
    # must move it somewhere else.
    @test CC.getAnalysisDiagOpt(opts) == CC.LibClangEx.CXAnalysisDiagClients_PD_HTML
    CC.setAnalysisDiagOpt(opts, CC.LibClangEx.CXAnalysisDiagClients_PD_TEXT)
    @test CC.getAnalysisDiagOpt(opts) == CC.LibClangEx.CXAnalysisDiagClients_PD_TEXT

    @test CC.getAnalysisConstraintsOpt(opts) == CC.LibClangEx.CXAnalysisConstraints_RangeConstraintsModel
    CC.setAnalysisConstraintsOpt(opts, CC.LibClangEx.CXAnalysisConstraints_Z3ConstraintsModel)
    @test CC.getAnalysisConstraintsOpt(opts) == CC.LibClangEx.CXAnalysisConstraints_Z3ConstraintsModel
    CC.setAnalysisConstraintsOpt(opts, CC.LibClangEx.CXAnalysisConstraints_RangeConstraintsModel)

    @test CC.getAnalyzeSpecificFunction(opts) == ""
    CC.setAnalyzeSpecificFunction(opts, "only_this_one")
    @test CC.getAnalyzeSpecificFunction(opts) == "only_this_one"
    CC.setAnalyzeSpecificFunction(opts, "")
    @test CC.getAnalyzeSpecificFunction(opts) == ""

    @test CC.getDumpExplodedGraphTo(opts) == ""
    CC.setDumpExplodedGraphTo(opts, "/tmp/eg.dot")
    @test CC.getDumpExplodedGraphTo(opts) == "/tmp/eg.dot"

    CC.setMaxBlockVisitOnPath(opts, 7)
    @test CC.getMaxBlockVisitOnPath(opts) == 7

    # The four bitfields. Each is value-copied through the shim, so a set on one must not
    # disturb its neighbours in the same word -- which is what asserting all four after
    # flipping each one in turn actually checks.
    @test CC.getDisableAllCheckers(opts) == false
    @test CC.getAnalyzeAll(opts) == false
    @test CC.getAnalyzerWerror(opts) == false
    @test CC.getShouldEmitErrorsOnInvalidConfigValue(opts) == false

    CC.setAnalyzeAll(opts, true)
    @test CC.getAnalyzeAll(opts) == true
    @test CC.getDisableAllCheckers(opts) == false
    @test CC.getAnalyzerWerror(opts) == false
    @test CC.getShouldEmitErrorsOnInvalidConfigValue(opts) == false

    CC.setAnalyzerWerror(opts, true)
    CC.setShouldEmitErrorsOnInvalidConfigValue(opts, true)
    CC.setDisableAllCheckers(opts, true)
    @test CC.getAnalyzeAll(opts) == true
    @test CC.getDisableAllCheckers(opts) == true
    @test CC.getAnalyzerWerror(opts) == true
    @test CC.getShouldEmitErrorsOnInvalidConfigValue(opts) == true

    CC.setAnalyzeAll(opts, false)
    @test CC.getAnalyzeAll(opts) == false
    @test CC.getDisableAllCheckers(opts) == true

    dispose(inv)
end
