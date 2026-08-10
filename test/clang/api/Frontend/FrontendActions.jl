using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

const LXB_FA = CC.LibClangEx

@testset "the concrete FrontendActions describe themselves apart" begin
    # Every predicate below is virtual dispatch on the class clang chose for it: the
    # interesting ones are where a class overrides the FrontendAction default, because that
    # is what says the factory really built that class and not its base.
    syn = CC.SyntaxOnlyAction()
    pch = CC.GeneratePCHAction()
    prt = CC.ASTPrintAction()
    dmp = CC.ASTDumpAction()
    rpp = CC.ReadPCHAndPreprocessAction()

    # SyntaxOnlyAction is the only one of the five that offers code completion, and
    # GeneratePCHAction the only one that refuses an AST-file input and asks for a prefix
    # translation unit -- so these two partition the group.
    @test CC.hasCodeCompletionSupport(syn) == true
    @test CC.hasCodeCompletionSupport(pch) == false
    @test CC.hasCodeCompletionSupport(prt) == false
    @test CC.hasCodeCompletionSupport(dmp) == false
    @test CC.hasCodeCompletionSupport(rpp) == false

    @test CC.getTranslationUnitKind(pch) == LXB_FA.CXTranslationUnitKind_TU_Prefix
    @test CC.hasASTFileSupport(pch) == false
    for act in (syn, prt, dmp, rpp)
        @test CC.getTranslationUnitKind(act) == LXB_FA.CXTranslationUnitKind_TU_Complete
        @test CC.hasASTFileSupport(act) == true
    end

    # None of the five generates IR -- that is the CodeGen family's override, and it is what
    # makes these the cheap actions.
    for act in (syn, pch, prt, dmp, rpp)
        @test CC.hasIRSupport(act) == false
        @test CC.hasPCHSupport(act) == true
        @test CC.isModelParsingAction(act) == false
        # ReadPCHAndPreprocessAction says false explicitly precisely because it looks like a
        # preprocessor-only action and is not one.
        @test CC.usesPreprocessorOnly(act) == false
        # Outside a BeginSourceFile/EndSourceFile pair no action has a current input.
        @test CC.isCurrentInputEmpty(act) == true
    end

    for act in (rpp, dmp, prt, pch, syn)
        dispose(act)
    end
end

@testset "GeneratePCHAction writes a PCH where FrontendOptions.OutputFile says" begin
    # The two halves of this are inseparable: nothing else in the package can set
    # OutputFile, and GeneratePCHAction produces nothing without it.
    mktempdir() do dir
        src = joinpath(dir, "gpa_input.cpp")
        write(src, "struct GPAThing { int a; };\nint gpa_value = 3;\n")
        out = joinpath(dir, "gpa_input.pch")

        ci = CC.CompilerInstance()
        CC.createDiagnostics(ci)
        diag = CC.getDiagnostics(ci)
        invok = CC.createFromCommandLine(src, ["-std=c++17"], diag)
        CC.setInvocation(ci, invok)  # adopted by the instance -- no dispose

        feo = CC.getFrontendOpts(ci)
        # -fsyntax-only is what createFromCommandLine asked the driver for, so the driver
        # left no output path behind -- and with none, clang would send the PCH to standard
        # output rather than to a file.
        @test CC.getOutputFile(feo) == ""
        CC.setOutputFile(feo, out)
        @test CC.getOutputFile(feo) == out

        act = CC.GeneratePCHAction()
        @test CC.ExecuteAction(ci, act) == true
        dispose(act)

        @test isfile(out)
        # A precompiled header is a bitcode container; clang stamps it with the "CPCH"
        # magic, so the bytes prove a PCH was written and not merely a file created.
        @test filesize(out) > 4
        @test read(out, 4) == b"CPCH"

        dispose(ci)
    end
end

@testset "SyntaxOnlyAction parses without producing an output file" begin
    mktempdir() do dir
        good = joinpath(dir, "soa_good.cpp")
        bad = joinpath(dir, "soa_bad.cpp")
        write(good, "int soa_ok(int x) { return x + 1; }\n")
        write(bad, "int soa_bad(int x) { return soa_nosuch(x); }\n")

        for (src, expected) in ((good, true), (bad, false))
            ci = CC.CompilerInstance()
            CC.createDiagnostics(ci)
            buf = CC.TextDiagnosticBuffer()
            CC.setClient(CC.getDiagnostics(ci), buf, false)
            invok = CC.createFromCommandLine(src, ["-std=c++17"],
                                             CC.getDiagnostics(ci))
            CC.setInvocation(ci, invok)

            act = CC.SyntaxOnlyAction()
            # Semantic analysis really ran: the well-formed file passes and the one with an
            # undeclared callee does not.
            @test CC.ExecuteAction(ci, act) == expected
            dispose(act)

            n_err = Base.size(buf, LXB_FA.CXTextDiagnosticBuffer_Error)
            @test (n_err > 0) == !expected
            if !expected
                @test occursin("soa_nosuch",
                               CC.getMessage(buf, LXB_FA.CXTextDiagnosticBuffer_Error, 0))
            end

            dispose(ci)
            dispose(buf)
        end
    end
end
