using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

const SER_LXB = CC.LibClangEx

@testset "Serialization | ASTReader file inspection" begin
    # A buffering client rather than the default printer, so the deliberate failures below
    # are recorded instead of printed -- and so the buffer can prove the failure path ran
    # at all, which an empty return value on its own cannot.
    buf = CC.TextDiagnosticBuffer()
    diag = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), buf, false)
    fm = CC.FileManager()

    inv = CC.CompilerInvocation()
    lang_opts = CC.getLangOpts(inv)
    target_opts = CC.getTargetOpts(inv)
    pp_opts = CC.getPreprocessorOpts(inv)

    missing_pch = joinpath(mktempdir(), "no-such-file.pch")
    @test !isfile(missing_pch)
    plain_source = normpath(joinpath(@__DIR__, "..", "..", "..", "cxx", "main.cpp"))
    @test isfile(plain_source)

    errs() = Base.size(buf, SER_LXB.CXTextDiagnosticBuffer_Error)
    n0 = errs()

    # Nothing to read: the empty name is the failure report, and the diagnostic is what
    # says the call reached clang's reader rather than falling out early.
    @test CC.getOriginalSourceFile(missing_pch, fm, diag) == ""
    n1 = errs()
    @test n1 > n0
    @test occursin("no-such-file.pch", CC.getMessage(buf, SER_LXB.CXTextDiagnosticBuffer_Error, n1 - 1))

    # Readable, but not an AST file: same empty answer, and another diagnostic — so the two
    # failures are distinguishable from "the reader was never asked".
    @test CC.getOriginalSourceFile(plain_source, fm, diag) == ""
    n2 = errs()
    @test n2 > n1

    # isAcceptableASTFile answers with the bool alone and reports nothing, which is what
    # makes it usable as a pre-flight check: neither file is acceptable, and the error
    # count is exactly where the previous call left it.
    @test CC.isAcceptableASTFile(missing_pch, fm, lang_opts, target_opts, pp_opts) == false
    @test CC.isAcceptableASTFile(plain_source, fm, lang_opts, target_opts, pp_opts) == false
    @test CC.isAcceptableASTFile(plain_source, fm, lang_opts, target_opts, pp_opts;
                                 require_strict_option_matches=true) == false
    @test CC.isAcceptableASTFile(plain_source, fm, lang_opts, target_opts, pp_opts;
                                 existing_module_cache_path="/nonexistent/cache") == false
    @test errs() == n2

    dispose(inv)
    dispose(fm)
    dispose(diag)
    dispose(buf)
end
