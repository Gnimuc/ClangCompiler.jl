using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "ExtractAPI | ExtractAPIAction" begin
    # Built and queried only -- never given an input, never executed -- so it cannot reach
    # any AST state another testset built.
    act = CC.ExtractAPIAction()

    # ExtractAPIAction overrides CreateASTConsumer, PrepareToExecuteAction,
    # EndSourceFileAction and CreateOutputFile, and no mode predicate, so every answer here
    # is ASTFrontendAction's or FrontendAction's.
    @test CC.usesPreprocessorOnly(act) == false
    @test CC.hasPCHSupport(act) == true
    @test CC.hasASTFileSupport(act) == true
    @test CC.hasIRSupport(act) == false
    @test CC.hasCodeCompletionSupport(act) == false
    @test CC.isModelParsingAction(act) == false
    @test CC.getTranslationUnitKind(act) == CC.LibClangEx.CXTranslationUnitKind_TU_Complete

    # No BeginSourceFile has run, so the two input-gated accessors must refuse rather than
    # trip clang's own assertion.
    @test CC.isCurrentInputEmpty(act) == true
    @test_throws AssertionError CC.isCurrentFileAST(act)
    @test_throws AssertionError CC.getCurrentFileOrBufferName(act)

    # Two factories hand back two distinct actions, not one shared object.
    other = CC.ExtractAPIAction()
    @test other.ptr != act.ptr
    dispose(other)

    dispose(act)
end
