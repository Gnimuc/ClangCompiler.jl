using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "Driver resources path" begin
    path = CC.GetResourcesPath(Libdl.dlpath(CC.libclangex))
    @test path isa String
    @test !isempty(path)
    @test occursin("clang", path)
end

@testset "Driver: standalone instance built on a DiagnosticsEngine" begin
    # Driver: a standalone instance built on top of a DiagnosticsEngine.
    diags = CC.DiagnosticsEngine()
    exe = joinpath("usr", "bin", "clang")
    triple = "x86_64-unknown-linux-gnu"
    drv = CC.Driver(exe, triple, diags)
    @test drv isa CC.Driver

    @test CC.getTargetTriple(drv) isa String
    @test occursin("x86_64", CC.getTargetTriple(drv))
    @test CC.getClangProgramPath(drv) isa String
    @test occursin("clang", CC.getClangProgramPath(drv))
    @test CC.getInstalledDir(drv) isa String
    @test CC.getDir(drv) isa String
    @test CC.getResourceDir(drv) isa String
    @test CC.getSysRoot(drv) isa String
    @test CC.getDyldPrefix(drv) isa String

    old = CC.getCheckInputsExist(drv)
    @test old isa Bool
    CC.setCheckInputsExist(drv, !old)
    @test CC.getCheckInputsExist(drv) == !old
    CC.setCheckInputsExist(drv, old)
    @test CC.getCheckInputsExist(drv) == old

    # The driver holds a reference to the engine: dispose it first.
    CC.dispose(drv)
    CC.dispose(diags)
end

@testset "Driver modes and title" begin
    # Driver half: a throwaway Driver on a throwaway DiagnosticsEngine.
    diags = CC.DiagnosticsEngine()
    drv = CC.Driver(joinpath("usr", "bin", "clang"), "x86_64-unknown-linux-gnu", diags)

    modes = [CC.CCCIsCXX(drv), CC.CCCIsCPP(drv), CC.CCCIsCC(drv), CC.IsCLMode(drv),
             CC.IsFlangMode(drv), CC.IsDXCMode(drv)]
    @test all(m -> m isa Bool, modes)
    # Driver::Mode is a single enum, so at most one predicate can be true.
    @test count(modes) <= 1

    @test CC.getCCCGenericGCCName(drv) isa String
    @test CC.getDiags(drv) isa CC.DiagnosticsEngine

    img = CC.getDefaultImageName(drv)
    @test img isa String
    @test !isempty(img)

    # getLTOMode is deliberately NOT called here: Driver::LTOMode and OffloadLTOMode
    # have no default initializer and are assigned only by setLTOMode during
    # BuildCompilation, so reading them on a driver that has not processed arguments
    # is undefined behaviour (it returned a value outside the enum on Linux CI).

    old_title = CC.getTitle(drv)
    @test old_title isa String
    CC.setTitle(drv, "clangcompiler test driver")
    @test CC.getTitle(drv) == "clangcompiler test driver"
    CC.setTitle(drv, old_title)
    @test CC.getTitle(drv) == old_title

    # The driver holds a reference to the engine: dispose it first.
    CC.dispose(drv)
    CC.dispose(diags)
end

@testset "Driver: config files, prepend arg and mode predicates" begin
    diags = CC.DiagnosticsEngine()
    drv = CC.Driver(joinpath("usr", "bin", "clang"), "x86_64-unknown-linux-gnu", diags)

    # No command line has been processed, so no configuration file was loaded.
    cfgs = CC.getConfigFiles(drv)
    @test cfgs isa Vector{String}
    @test isempty(cfgs)

    probe = CC.getProbePrecompiled(drv)
    @test probe isa Bool
    CC.setProbePrecompiled(drv, !probe)
    @test CC.getProbePrecompiled(drv) == !probe
    CC.setProbePrecompiled(drv, probe)
    @test CC.getProbePrecompiled(drv) == probe

    # The driver stores the pointer, not a copy, so `prepend` must stay rooted for
    # as long as the driver is alive.
    prepend = "clang"
    CC.setPrependArg(drv, prepend)
    @test CC.getPrependArg(drv) == "clang"

    CC.setInstalledDir(drv, "usr/lib/llvm/bin")
    @test CC.getInstalledDir(drv) == "usr/lib/llvm/bin"

    flags = [CC.isSaveTempsEnabled(drv), CC.isSaveTempsObj(drv),
             CC.embedBitcodeEnabled(drv), CC.embedBitcodeInObject(drv),
             CC.embedBitcodeMarkerOnly(drv), CC.offloadHostOnly(drv),
             CC.offloadDeviceOnly(drv), CC.hasHeaderMode(drv)]
    @test all(v -> v isa Bool, flags)
    # Driver::Offload is a single enum, so host-only and device-only exclude each
    # other; the two BitcodeEmbed spellings exclude each other the same way.
    @test !(CC.offloadHostOnly(drv) && CC.offloadDeviceOnly(drv))
    @test !(CC.embedBitcodeInObject(drv) && CC.embedBitcodeMarkerOnly(drv))

    # The driver holds a reference to the engine: dispose it first.
    CC.dispose(drv)
    CC.dispose(diags)
end

@testset "Driver: temporaries, LTO usage and version parsing" begin
    diags = CC.DiagnosticsEngine()
    drv = CC.Driver(joinpath("usr", "bin", "clang"), "x86_64-unknown-linux-gnu", diags)

    # isUsingLTO reads the same uninitialized Driver::LTOMode as getLTOMode, but as a
    # comparison, so it is a valid Bool even on a driver that never processed
    # arguments -- only its meaning depends on that.
    @test CC.isUsingLTO(drv) isa Bool
    @test CC.isUsingLTO(drv, true) isa Bool

    # Both create their entry on disk and hand ownership to the caller.
    tmpfile = CC.GetTemporaryPath(drv, "clangcompiler", "tmp")
    @test tmpfile isa String
    @test !isempty(tmpfile)
    isempty(tmpfile) || rm(tmpfile; force=true)

    tmpdir = CC.GetTemporaryDirectory(drv, "clangcompiler")
    @test tmpdir isa String
    @test !isempty(tmpdir)
    isempty(tmpdir) || rm(tmpdir; force=true, recursive=true)

    v = CC.GetReleaseVersion("10.3.5")
    @test v !== nothing
    @test v == (10, 3, 5, false)
    # All groups parsed but characters left over is the documented HadExtra case.
    ve = CC.GetReleaseVersion("10.3.5extrastuff")
    @test ve !== nothing
    @test ve == (10, 3, 5, true)
    # A group the string does not provide parses as 0.
    @test CC.GetReleaseVersion("9.2") == (9, 2, 0, false)

    # The digit-group overload is the stricter one: it rejects the trailing characters
    # the four-value form tolerates, and agrees with it whenever it succeeds.
    groups = CC.GetReleaseVersionDigits("10.3.5", 3)
    @test groups === nothing || groups == [10, 3, 5]
    @test CC.GetReleaseVersionDigits("10.3.5extrastuff", 3) === nothing

    cache = CC.getDefaultModuleCachePath()
    @test cache isa String
    # Empty only when the platform provides no cache directory at all.
    @test isempty(cache) || isabspath(cache)

    # The driver holds a reference to the engine: dispose it first.
    CC.dispose(drv)
    CC.dispose(diags)
end

@testset "Driver: a Compilation and the toolchain it selects" begin
    # Building a compilation is what assigns the Driver members that have no in-class
    # initializer, so this is the only place getLTOMode is well-defined. Diagnostics are
    # swallowed: the input file is phony and only argument processing is exercised.
    diags = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                 CC.IgnoringDiagConsumer(), true)
    drv = CC.Driver(joinpath("usr", "bin", "clang"), "x86_64-unknown-linux-gnu", diags)
    CC.setCheckInputsExist(drv, false)

    src = "clangcompiler-driver-test.cpp"
    comp = CC.BuildCompilation(drv, ["clang", "-fsyntax-only", src])
    @test comp isa CC.Compilation
    @test CC.isForDiagnostics(comp) isa Bool
    @test CC.getActiveOffloadKinds(comp) isa Integer
    @test CC.getSysRoot(comp) isa String
    @test CC.getTempFiles(comp) isa Vector{String}

    # setContainsError only ever sets the bit, so this round trip is one-way.
    @test CC.containsError(comp) isa Bool
    CC.setContainsError(comp)
    @test CC.containsError(comp)

    # The driver a compilation reports is the one that built it, borrowed not copied.
    @test CC.getTargetTriple(CC.getDriver(comp)) == CC.getTargetTriple(drv)

    tc = CC.getDefaultToolChain(comp)
    @test tc isa CC.ToolChain
    @test occursin("x86_64", CC.getTripleString(tc))
    @test CC.getArchName(tc) isa String
    @test CC.getOS(tc) isa String
    @test CC.isCrossCompiling(tc) isa Bool
    @test CC.getTargetTriple(CC.getDriver(tc)) == CC.getTargetTriple(drv)

    # Neither lookup has to find anything; both always come back with a path string.
    @test CC.GetFilePath(drv, "crt1.o", tc) isa String
    @test CC.GetProgramPath(drv, "ld", tc) isa String

    banner = CC.PrintVersion(drv, comp)
    @test banner isa String
    @test !isempty(banner)

    # Arguments have now been processed, so the accessors reading Driver::LTOMode and the
    # config-file list are defined -- on a driver that never built a compilation
    # getLTOMode has been observed returning a value outside its own enum.
    @test CC.getLTOMode(drv) in (CC.CXLTOKind_LTOK_None, CC.CXLTOKind_LTOK_Full,
                                 CC.CXLTOKind_LTOK_Thin, CC.CXLTOKind_LTOK_Unknown)
    @test CC.getLTOMode(drv, true) isa CC.CXLTOKind
    @test CC.getConfigFiles(drv) isa Vector{String}

    # A compile-and-link line plans an intermediate object file, which the driver registers
    # as a temporary and the compilation's destructor removes again. A Driver is built for
    # one command line, so this uses its own.
    diags2 = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                  CC.IgnoringDiagConsumer(), true)
    drv2 = CC.Driver(joinpath("usr", "bin", "clang"), "x86_64-unknown-linux-gnu", diags2)
    CC.setCheckInputsExist(drv2, false)
    out = joinpath(tempdir(), "clangcompiler-driver-test.out")
    link = CC.BuildCompilation(drv2, ["clang", src, "-o", out])
    @test CC.getTempFiles(link) isa Vector{String}
    CC.dispose(link)
    CC.dispose(drv2)
    CC.dispose(diags2)

    # A compilation's destructor reads its driver, and the driver holds the engine.
    CC.dispose(comp)
    CC.dispose(drv)
    CC.dispose(diags)
end
