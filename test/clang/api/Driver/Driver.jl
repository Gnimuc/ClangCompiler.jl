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
