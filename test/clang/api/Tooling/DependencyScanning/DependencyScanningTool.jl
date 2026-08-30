using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "DependencyScanningService | the configuration the workers share" begin
    svc = CC.DependencyScanningService(CC.CXScanningMode_DependencyDirectivesScan, CC.CXScanningOutputFormat_Make)
    # the defaulted parameters are Clang's own
    @test CC.getMode(svc) == CC.CXScanningMode_DependencyDirectivesScan
    @test CC.getFormat(svc) == CC.CXScanningOutputFormat_Make
    @test CC.getOptimizeArgs(svc) == CC.CXScanningOptimizations_All
    @test !CC.shouldEagerLoadModules(svc)
    dispose(svc)

    other = CC.DependencyScanningService(CC.CXScanningMode_CanonicalPreprocessing, CC.CXScanningOutputFormat_Full,
                                         CC.CXScanningOptimizations_None, true)
    @test CC.getMode(other) == CC.CXScanningMode_CanonicalPreprocessing
    @test CC.getFormat(other) == CC.CXScanningOutputFormat_Full
    @test CC.getOptimizeArgs(other) == CC.CXScanningOptimizations_None
    @test CC.shouldEagerLoadModules(other)
    dispose(other)
end

@testset "DependencyScanningTool | which headers a translation unit touches" begin
    dir = mktempdir()
    hdr = joinpath(dir, "ccdeps_header.h")
    write(hdr, "#pragma once\nint ccdeps_from_header;\n")
    src = joinpath(dir, "ccdeps_main.c")
    write(src, "#include \"ccdeps_header.h\"\nint ccdeps_main_marker;\n")

    svc = CC.DependencyScanningService(CC.CXScanningMode_DependencyDirectivesScan, CC.CXScanningOutputFormat_Make)
    tool = CC.DependencyScanningTool(svc)

    # `-nostdinc` keeps the scanner off the host's headers; `-I dir` is how the
    # local include resolves, so a scan that ignored either flag cannot name both files.
    ok, out = CC.getDependencyFile(tool, ["clang", "-nostdinc", "-c", "-x", "c", "-I", dir, src], dir)
    @test ok
    @test occursin(basename(src), out)
    @test occursin(basename(hdr), out)

    # the failing half of the partition: a source that does not exist cannot be scanned, and
    # the error is reported rather than swallowed
    bad_ok, bad_out = CC.getDependencyFile(tool, ["clang", "-c", "-x", "c", joinpath(dir, "no_such_source.c")], dir)
    @test !bad_ok
    @test !isempty(bad_out)

    dispose(tool)
    dispose(svc)
end
