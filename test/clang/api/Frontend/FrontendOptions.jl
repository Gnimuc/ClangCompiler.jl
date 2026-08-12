using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

const LXB_FEO = CC.LibClangEx

@testset "FrontendOptions: the fields that gate a run" begin
    # A bare invocation: every field below is at the value clang's own constructor chose,
    # which is what makes the defaults worth asserting.
    inv = CC.CompilerInvocation()
    feo = CC.getFrontendOpts(inv)

    @test CC.getProgramAction(feo) == LXB_FEO.CXActionKind_ParseSyntaxOnly
    @test CC.getDisableFree(feo) == false
    @test CC.getSkipFunctionBodies(feo) == false
    @test CC.getOutputFile(feo) == ""
    @test CC.getInputsNum(feo) == 0
    @test CC.getDashXLanguage(feo) == LXB_FEO.CXLanguage_Unknown
    @test CC.getDashXFormat(feo) == LXB_FEO.CXInputKind_Source
    @test CC.getDashXHeaderUnitKind(feo) == LXB_FEO.CXInputKind_HeaderUnit_None
    @test CC.isDashXPreprocessed(feo) == false
    @test CC.isDashXHeader(feo) == false

    # With no inputs at all, every indexed accessor must refuse rather than read past the
    # end of clang's vector.
    @test_throws AssertionError CC.getInputFile(feo, 0)
    @test_throws AssertionError CC.isInputFile(feo, 0)
    @test_throws AssertionError CC.isInputSystem(feo, 0)
    @test_throws AssertionError CC.getInputLanguage(feo, 0)

    # Round trips through clang's own storage.
    CC.setOutputFile(feo, "/tmp/feo_out.pch")
    @test CC.getOutputFile(feo) == "/tmp/feo_out.pch"
    CC.setProgramAction(feo, LXB_FEO.CXActionKind_GeneratePCH)
    @test CC.getProgramAction(feo) == LXB_FEO.CXActionKind_GeneratePCH
    CC.setSkipFunctionBodies(feo, true)
    @test CC.getSkipFunctionBodies(feo) == true
    CC.setDisableFree(feo, true)
    @test CC.getDisableFree(feo) == true

    # InputKind is rebuilt from its components, so a set must carry all five back.
    CC.setDashX(feo, LXB_FEO.CXLanguage_ObjCXX; fmt=LXB_FEO.CXInputKind_Precompiled, preprocessed=true,
                header_unit=LXB_FEO.CXInputKind_HeaderUnit_System, header=true)
    @test CC.getDashXLanguage(feo) == LXB_FEO.CXLanguage_ObjCXX
    @test CC.getDashXFormat(feo) == LXB_FEO.CXInputKind_Precompiled
    @test CC.getDashXHeaderUnitKind(feo) == LXB_FEO.CXInputKind_HeaderUnit_System
    @test CC.isDashXPreprocessed(feo) == true
    @test CC.isDashXHeader(feo) == true

    CC.addInputFile(feo, "/tmp/feo_a.cpp", LXB_FEO.CXLanguage_CXX)
    CC.addInputFile(feo, "/tmp/feo_b.c", LXB_FEO.CXLanguage_C; system=true)
    @test CC.getInputsNum(feo) == 2
    @test CC.getInputFile(feo, 0) == "/tmp/feo_a.cpp"
    @test CC.getInputFile(feo, 1) == "/tmp/feo_b.c"
    # Per-input state, so an accessor that ignored its index would read the same twice.
    @test CC.getInputLanguage(feo, 0) == LXB_FEO.CXLanguage_CXX
    @test CC.getInputLanguage(feo, 1) == LXB_FEO.CXLanguage_C
    @test CC.isInputSystem(feo, 0) == false
    @test CC.isInputSystem(feo, 1) == true
    @test CC.isInputFile(feo, 0) == true
    @test_throws AssertionError CC.getInputFile(feo, 2)

    CC.clearInputs(feo)
    @test CC.getInputsNum(feo) == 0

    dispose(inv)
end

@testset "FrontendOptions: what the driver fills in" begin
    mktempdir() do dir
        cxx = joinpath(dir, "feo_driver.cpp")
        c = joinpath(dir, "feo_driver.c")
        write(cxx, "int feo_cxx = 1;\n")
        write(c, "int feo_c = 1;\n")

        diag = CC.DiagnosticsEngine()

        # The language is deduced from the extension by clang's driver, not by this
        # package: the same flags over two files give two answers.
        inv_cxx = CC.createFromCommandLine(cxx, String[], diag)
        feo_cxx = CC.getFrontendOpts(inv_cxx)
        @test CC.getInputsNum(feo_cxx) == 1
        @test endswith(CC.getInputFile(feo_cxx, 0), "feo_driver.cpp")
        @test CC.getInputLanguage(feo_cxx, 0) == LXB_FEO.CXLanguage_CXX
        @test CC.getDashXLanguage(feo_cxx) == LXB_FEO.CXLanguage_CXX
        # createFromCommandLine splices -fsyntax-only in, so this is the action the driver
        # settled on rather than the class default.
        @test CC.getProgramAction(feo_cxx) == LXB_FEO.CXActionKind_ParseSyntaxOnly

        inv_c = CC.createFromCommandLine(c, String[], diag)
        feo_c = CC.getFrontendOpts(inv_c)
        @test CC.getInputLanguage(feo_c, 0) == LXB_FEO.CXLanguage_C
        @test CC.getDashXLanguage(feo_c) == LXB_FEO.CXLanguage_C

        dispose(inv_c)
        dispose(inv_cxx)
        dispose(diag)
    end
end
