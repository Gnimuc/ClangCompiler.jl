using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "StaticAnalyzer | CreateAnalysisConsumer" begin
    # A bare instance has an invocation but nothing else, and the factory dereferences the
    # diagnostics engine, the preprocessor and the AST context without checking, so it must
    # be refused here rather than aborting inside clang.
    bare = CC.CompilerInstance()
    @test_throws AssertionError CC.CreateAnalysisConsumer(bare)
    dispose(bare)

    # A standalone instance, built up the same way test/clang/instance.jl does, so nothing
    # here touches an interpreter's live pipeline.
    ci = CC.CompilerInstance()
    CC.createDiagnostics(ci)
    CC.createFileManager(ci)
    CC.createSourceManager(ci, CC.getFileManager(ci))

    target_opts = CC.TargetOptions()
    CC.setTriple(target_opts, "x86_64-apple-darwin11.1.0")
    CC.setTarget(ci, CC.TargetInfo(target_opts, CC.getDiagnostics(ci)))  # absorbs target_opts
    CC.createPreprocessor(ci)
    # Still short of an AST context, which the cross-TU context inside the consumer binds to.
    @test CC.hasASTContext(ci) == false
    @test_throws AssertionError CC.CreateAnalysisConsumer(ci)

    CC.createASTContext(ci)

    # PD_NONE keeps the consumer from opening a path-diagnostic client: the default is
    # PD_HTML, which wants an output directory this instance has no reason to have.
    CC.setAnalysisDiagOpt(CC.getAnalyzerOpts(ci), CC.LibClangEx.CXAnalysisDiagClients_PD_NONE)

    @test CC.hasASTConsumer(ci) == false
    csr = CC.CreateAnalysisConsumer(ci)
    @test csr.ptr != C_NULL

    # Installing it is the adoption: the instance now owns the consumer, hasASTConsumer
    # flips, and disposing the instance is what frees it.
    CC.setASTConsumer(ci, csr)
    @test CC.hasASTConsumer(ci) == true
    @test CC.getASTConsumer(ci).ptr == csr.ptr

    dispose(ci)
end
