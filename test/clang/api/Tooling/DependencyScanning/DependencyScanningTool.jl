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
    # The header sits in a directory of its own and is included with angle brackets, so the
    # search never looks beside the includer and `-I incdir` is the only route to it.
    dir = mktempdir()
    incdir = joinpath(dir, "inc")
    mkdir(incdir)
    hdr = joinpath(incdir, "ccdeps_header.h")
    write(hdr, "#pragma once\nint ccdeps_from_header;\n")
    src = joinpath(dir, "ccdeps_main.c")
    write(src, "#include <ccdeps_header.h>\nint ccdeps_main_marker;\n")

    svc = CC.DependencyScanningService(CC.CXScanningMode_DependencyDirectivesScan, CC.CXScanningOutputFormat_Make)
    tool = CC.DependencyScanningTool(svc)

    # `--target` takes the toolchain choice away from the host's default triple, and
    # `-nostdinc` leaves `-I` as the whole search path. The scan only preprocesses, so the
    # target needs no backend.
    base = ["clang", "--target=x86_64-linux-gnu", "-nostdinc", "-c", "-x", "c"]
    ok, out = CC.getDependencyFile(tool, [base..., "-I", incdir, src], dir)
    @test ok
    @test occursin(basename(src), out)
    @test occursin(basename(hdr), out)

    # the same scan without `-I` cannot find the header, and says which one
    noinc_ok, noinc_out = CC.getDependencyFile(tool, [base..., src], dir)
    @test !noinc_ok
    @test occursin(basename(hdr), noinc_out)

    # the failing half of the partition: a source that does not exist cannot be scanned, and
    # the error is reported rather than swallowed
    bad_ok, bad_out = CC.getDependencyFile(tool, ["clang", "-c", "-x", "c", joinpath(dir, "no_such_source.c")], dir)
    @test !bad_ok
    @test !isempty(bad_out)

    dispose(tool)
    dispose(svc)
end
