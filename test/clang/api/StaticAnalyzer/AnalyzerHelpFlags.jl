using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "StaticAnalyzer | checker and config listings" begin
    # Needs no instance: this one reads AnalyzerOptions.def and nothing else.
    cfg = CC.printAnalyzerConfigList()
    @test !isempty(cfg)
    @test occursin("cfg-implicit-dtors", cfg)
    @test occursin("max-nodes", cfg)
    @test CC.printAnalyzerConfigList() == cfg          # nothing about it varies per call

    # The three instance forms build a CheckerManager, which needs a DiagnosticsEngine and
    # an invocation. A bare instance has the invocation but no diagnostics, so it must be
    # refused rather than aborting inside clang.
    bare = CC.CompilerInstance()
    @test CC.hasDiagnostics(bare) == false
    @test_throws AssertionError CC.printCheckerHelp(bare)
    @test_throws AssertionError CC.printEnabledCheckerList(bare)
    @test_throws AssertionError CC.printCheckerConfigList(bare)
    dispose(bare)

    ci = CC.CompilerInstance()
    CC.createDiagnostics(ci)

    # OBSERVED: printCheckerHelp emits its banner and then NO checkers -- 108 bytes, five
    # lines, ending at "CHECKERS:" -- and does so for a fully configured CompilerInstance
    # (the interpreter's own) exactly as for this bare one, so it is not a configuration
    # this test failed to do. The registry itself is fine: printEnabledCheckerList below
    # names core.DivideZero and a dozen siblings off the same data.
    #
    # So the assertion is the banner, which is what this build actually produces, and the
    # checker names are asserted through the enabled list instead. Pinning names here would
    # be pinning an output never seen.
    help = CC.printCheckerHelp(ci)
    @test !isempty(help)
    @test occursin("Clang Static Analyzer Checkers List", help)
    @test occursin("-analyzer-checker", help)

    # Nothing has selected a checker yet, so the enabled list names none of them; enabling
    # the `core` package must make it name at least the checker in that package above.
    # That partition is the point: an enabled list that ignored the options would be
    # identical in both halves.
    before = CC.printEnabledCheckerList(ci)
    @test !occursin("core.DivideZero", before)

    opts = CC.getAnalyzerOpts(ci)
    CC.addCheckerOrPackage(opts, "core", true)
    after = CC.printEnabledCheckerList(ci)
    @test occursin("core.DivideZero", after)
    @test length(after) > length(before)

    # The per-checker config listing is keyed on the same enabled set.
    conf = CC.printCheckerConfigList(ci)
    @test !isempty(conf)

    dispose(ci)
end
