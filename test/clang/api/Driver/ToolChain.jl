using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# The no-ArgList query surface of a ToolChain: where it would look for compiler-rt, the C++
# standard library, its linker and its search paths. Pinned to one triple so the answers do
# not depend on the machine running the test; diagnostics are swallowed because the input
# file is phony and only argument processing is exercised.

const TC_TRIPLE = "x86_64-unknown-linux-gnu"

function toolchain_for(args)
    diags = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), CC.IgnoringDiagConsumer(), true)
    drv = CC.Driver(joinpath("usr", "bin", "clang"), TC_TRIPLE, diags)
    CC.setCheckInputsExist(drv, false)
    comp = CC.BuildCompilation(drv, args)
    return CC.getDefaultToolChain(comp), comp, drv, diags
end

@testset "ToolChain | runtime and stdlib discovery" begin
    src = "clangcompiler-toolchain-test.cpp"
    tc, comp, drv, diags = toolchain_for(["clang", "-fsyntax-only", src])

    # Every path below is built from the driver's resource directory, so each is asserted
    # against that rather than against a literal a different install would break.
    resource = CC.getResourceDir(drv)
    @test !isempty(resource)

    # ToolChain::getCompilerRTPath is <resource>/lib/<osname>, and the osname of a Linux
    # triple is the OS component of the triple itself.
    @test CC.getOSLibName(tc) == "linux"
    rt = CC.getCompilerRTPath(tc)
    @test startswith(rt, resource)
    @test endswith(rt, "linux")

    # getArchSpecificLibPaths builds <resource>/lib/<triple> and <resource>/lib/<os>/<arch>.
    arch_paths = CC.getArchSpecificLibPaths(tc)
    @test length(arch_paths) >= 2
    @test all(p -> startswith(p, resource), arch_paths)
    @test any(p -> occursin(CC.getTripleString(tc), p), arch_paths)
    @test any(p -> occursin(CC.getOSLibName(tc), p) && occursin(CC.getArchName(tc), p), arch_paths)

    # The optional-valued pair: absent is reported as an empty string, and a present one is
    # under the resource directory like everything else here.
    for p in (CC.getRuntimePath(tc), CC.getStdlibPath(tc))
        @test isempty(p) || startswith(p, resource)
    end

    # Each of the three search lists crosses as a copy, so mutating what a caller got back
    # cannot reach the toolchain's own storage.
    file_paths = CC.getFilePaths(tc)
    push!(file_paths, "clangcompiler-mutated")
    @test !("clangcompiler-mutated" in CC.getFilePaths(tc))
    # and they read three different members: an accessor wired to the wrong one shows up as
    # the file paths coming back under a program- or library-path name
    @test isempty(CC.getFilePaths(tc)) || CC.getProgramPaths(tc) != CC.getFilePaths(tc)
    @test isempty(CC.getFilePaths(tc)) || CC.getLibraryPaths(tc) != CC.getFilePaths(tc)

    # -arch spelling and the linker the toolchain would run.
    @test CC.getDefaultUniversalArchName(tc) == "x86_64"
    @test !isempty(CC.getDefaultLinker(tc))
    linker, is_lld = CC.GetLinkerPath(tc)
    @test !isempty(linker)
    # clang sets the flag from the linker it selected, so a true answer has to name LLD
    @test !is_lld || occursin("lld", linker)
    @test !isempty(CC.GetStaticLibToolPath(tc))

    # No --sysroot was passed, so the toolchain computes none of its own.
    @test CC.computeSysRoot(tc) == ""

    # LookupTypeForExtension is the toolchain's view of the driver's own type table, so the
    # two must agree on an ordinary C++ extension.
    cxx = CC.LookupTypeForExtension(tc, "cpp")
    @test cxx == CC.lookupTypeForExtension("cpp")
    @test CC.isCXX(cxx)
    @test CC.LookupTypeForExtension(tc, "clangcompiler-unknown-ext") == 0

    # Both are pure virtuals every concrete toolchain overrides; which way they answer is a
    # property of the target.
    @test CC.isPICDefault(tc) isa Bool          # shape-only: the target decides it
    @test CC.isPICDefaultForced(tc) isa Bool    # shape-only: the target decides it
    @test CC.GetDefaultCXXStdlibType(tc) in (CC.CXCXXStdlibType_CST_Libcxx, CC.CXCXXStdlibType_CST_Libstdcxx)
    @test CC.GetDefaultRuntimeLibType(tc) in (CC.CXRuntimeLibType_RLT_CompilerRT, CC.CXRuntimeLibType_RLT_Libgcc)

    dispose(comp)
    dispose(drv)
    dispose(diags)

    # --sysroot is what computeSysRoot reports back when one was given, which is the
    # partition the empty answer above needs.
    root = joinpath(tempdir(), "clangcompiler-sysroot")
    tc2, comp2, drv2, diags2 = toolchain_for(["clang", "--sysroot=" * root, "-fsyntax-only", src])
    @test CC.computeSysRoot(tc2) == root
    dispose(comp2)
    dispose(drv2)
    dispose(diags2)
end
