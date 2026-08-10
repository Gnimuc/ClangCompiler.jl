using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

const LXB_FT = CC.LibClangEx

@testset "CreateFrontendAction dispatches on FrontendOptions.ProgramAction" begin
    mktempdir() do dir
        src = joinpath(dir, "cfa_input.cpp")
        write(src, "int cfa_value = 5;\n")

        ci = CC.CompilerInstance()
        CC.createDiagnostics(ci)
        invok = CC.createFromCommandLine(src, ["-std=c++17"], CC.getDiagnostics(ci))
        CC.setInvocation(ci, invok)  # adopted by the instance -- no dispose
        feo = CC.getFrontendOpts(ci)

        # The class clang picks is not observable directly, but its overrides are: a
        # SyntaxOnlyAction is the one that offers code completion, and a GeneratePCHAction
        # the one that wants a prefix translation unit and refuses AST-file input. Asking
        # for each in turn and getting each answer back is what says the switch happened.
        @test CC.getProgramAction(feo) == LXB_FT.CXActionKind_ParseSyntaxOnly
        syn = CC.CreateFrontendAction(ci)
        @test CC.hasCodeCompletionSupport(syn) == true
        @test CC.getTranslationUnitKind(syn) == LXB_FT.CXTranslationUnitKind_TU_Complete
        dispose(syn)

        CC.setProgramAction(feo, LXB_FT.CXActionKind_GeneratePCH)
        pch = CC.CreateFrontendAction(ci)
        @test CC.hasCodeCompletionSupport(pch) == false
        @test CC.getTranslationUnitKind(pch) == LXB_FT.CXTranslationUnitKind_TU_Prefix
        @test CC.hasASTFileSupport(pch) == false
        dispose(pch)

        # -E: the one action family that never builds an AST, and the one this package has
        # no factory of its own for.
        CC.setProgramAction(feo, LXB_FT.CXActionKind_PrintPreprocessedInput)
        pre = CC.CreateFrontendAction(ci)
        @test CC.usesPreprocessorOnly(pre) == true
        dispose(pre)

        dispose(ci)
    end
end

@testset "ExecuteCompilerInvocation runs the action the options name" begin
    mktempdir() do dir
        src = joinpath(dir, "eci_input.cpp")
        write(src, "struct ECIThing { double d; };\nint eci_value = 11;\n")
        pch = joinpath(dir, "eci_input.pch")
        pre = joinpath(dir, "eci_input.ii")

        # -emit-pch, chosen entirely through the options rather than through a factory.
        ci = CC.CompilerInstance()
        CC.createDiagnostics(ci)
        invok = CC.createFromCommandLine(src, ["-std=c++17"], CC.getDiagnostics(ci))
        CC.setInvocation(ci, invok)
        feo = CC.getFrontendOpts(ci)
        CC.setProgramAction(feo, LXB_FT.CXActionKind_GeneratePCH)
        CC.setOutputFile(feo, pch)
        @test CC.ExecuteCompilerInvocation(ci) == true
        @test isfile(pch)
        # clang stamps every serialized AST with this magic, so the bytes say a PCH was
        # written rather than merely a file created.
        @test read(pch, 4) == b"CPCH"
        dispose(ci)

        # -E over the same source, again selected only by ProgramAction. The two runs write
        # different things, which is the whole point of the switch.
        ci2 = CC.CompilerInstance()
        CC.createDiagnostics(ci2)
        invok2 = CC.createFromCommandLine(src, ["-std=c++17"], CC.getDiagnostics(ci2))
        CC.setInvocation(ci2, invok2)
        feo2 = CC.getFrontendOpts(ci2)
        CC.setProgramAction(feo2, LXB_FT.CXActionKind_PrintPreprocessedInput)
        CC.setOutputFile(feo2, pre)
        @test CC.ExecuteCompilerInvocation(ci2) == true
        @test isfile(pre)
        # The action really did switch: this run wrote preprocessor output, not a PCH.
        #
        # It is NOT the source text, though. PrintPreprocessedInput honours
        # PreprocessorOutputOpts, and an invocation the driver built for a *compile* leaves
        # ShowCPP off -- so what lands here is the macro dump (`-dM`-shaped) rather than the
        # expanded `struct ECIThing`. Getting the source would mean setting ShowCPP, which
        # this package does not wrap; asserting on "ECIThing" would be asserting a setting
        # nothing here turns on.
        out = read(pre, String)
        @test !isempty(out)
        @test read(pre, 4) != b"CPCH"          # ... and emphatically not a second PCH
        @test occursin("#define", out)          # preprocessor output, whichever half of it
        dispose(ci2)
    end
end

@testset "the FrontendTool entry points refuse an unconfigured instance" begin
    ci = CC.CompilerInstance()
    # Neither is usable before createDiagnostics: both read getDiagnostics() through an
    # unchecked dereference on the C++ side.
    @test CC.hasDiagnostics(ci) == false
    @test_throws AssertionError CC.CreateFrontendAction(ci)
    @test_throws AssertionError CC.ExecuteCompilerInvocation(ci)

    CC.createDiagnostics(ci)
    # Diagnostics are the only gate either entry point is missing here: clang 18's
    # CompilerInstance default-constructs an invocation, so hasInvocation is true from the
    # moment the instance exists -- before createDiagnostics as well as after. Once the
    # diagnostics are there, CreateFrontendAction is satisfied and builds the action the
    # default invocation names.
    @test CC.hasInvocation(ci) == true
    act = CC.CreateFrontendAction(ci)
    @test !CC.is_null_handle(act)
    dispose(act)
    dispose(ci)
end
