using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

const LXB_DDS = CC.LibClangEx

# The scanner needs no Preprocessor, SourceManager or FileManager at all, so every testset
# here builds nothing but the scan itself.

@testset "DependencyDirectivesScanner | what survives minimization" begin
    code = """
           #include <a.h>
           int not_a_directive = 1;
           #define PROBE 2
           #if PROBE
           #include "b.h"
           #endif
           """
    scan, had_error = CC.scanSourceForDependencyDirectives(code)
    @test had_error == false

    n = CC.getNumDirectives(scan)
    kinds = [CC.getDirectiveKind(scan, i) for i = 0:(Int(n) - 1)]

    # every directive that can change what gets included is kept, in source order, and
    # nothing else of that set is invented
    wanted = [LXB_DDS.CXDependencyDirectiveKind_pp_include, LXB_DDS.CXDependencyDirectiveKind_pp_define,
              LXB_DDS.CXDependencyDirectiveKind_pp_if, LXB_DDS.CXDependencyDirectiveKind_pp_include,
              LXB_DDS.CXDependencyDirectiveKind_pp_endif]
    @test filter(in(wanted), kinds) == wanted
    # and the scan is terminated by the end-of-file marker
    @test kinds[end] == LXB_DDS.CXDependencyDirectiveKind_pp_eof

    # the token ranges partition the flat token array: each directive's tokens start where
    # its own first index says and stay inside the array
    total = CC.getNumTokens(scan)
    @test total > 0
    for i = 0:(Int(n) - 1)
        cnt = CC.getNumDirectiveTokens(scan, i)
        first_idx = CC.getDirectiveFirstTokenIndex(scan, i)
        @test first_idx + cnt <= total
        @test length(CC.getDirectiveTokens(scan, i)) == cnt
    end

    # every token points at a real slice of the input
    for i = 0:(Int(total) - 1)
        t = CC.getToken(scan, i)
        @test t.offset + t.length <= ncodeunits(code)
    end

    # the printed minimization keeps the directives and drops the declaration -- which is
    # the whole point: this is the text whose change means dependencies changed
    minimized = CC.printAsSource(scan)
    @test occursin("include", minimized)
    @test occursin("PROBE", minimized)
    @test occursin("endif", minimized)
    @test !occursin("not_a_directive", minimized)

    @test_throws AssertionError CC.getDirectiveKind(scan, n)
    @test_throws AssertionError CC.getNumDirectiveTokens(scan, n)
    @test_throws AssertionError CC.getToken(scan, total)

    dispose(scan)
end

@testset "DependencyDirectivesScanner | a source with nothing to keep" begin
    scan, had_error = CC.scanSourceForDependencyDirectives("int plain = 1;\n")
    @test had_error == false
    n = CC.getNumDirectives(scan)
    kinds = [CC.getDirectiveKind(scan, i) for i = 0:(Int(n) - 1)]
    # no #include, #define or conditional appears anywhere in the answer
    @test !any(k -> k in (LXB_DDS.CXDependencyDirectiveKind_pp_include, LXB_DDS.CXDependencyDirectiveKind_pp_define,
                          LXB_DDS.CXDependencyDirectiveKind_pp_if), kinds)
    @test kinds[end] == LXB_DDS.CXDependencyDirectiveKind_pp_eof
    @test !occursin("plain", CC.printAsSource(scan))
    dispose(scan)
end

@testset "DependencyDirectivesScanner | the error flag is not hardwired" begin
    # `@import` without its semicolon is one of the shapes the scanner refuses; the flag
    # has to distinguish it from the well-formed sources above
    scan, had_error = CC.scanSourceForDependencyDirectives("@import Foo\n")
    @test had_error == true
    # A failed scan keeps NOTHING: the directives recorded before the refusal are discarded
    # rather than handed back half-complete, so the count is zero and not merely smaller
    # than a clean scan's. The handle is still a valid, disposable one -- which is what
    # makes reading the count safe enough to assert.
    @test CC.getNumDirectives(scan) == 0
    dispose(scan)
end
