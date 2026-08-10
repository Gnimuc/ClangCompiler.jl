using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "StaticAnalyzer | AnalysisAction" begin
    # Built and queried only -- never given an input, never executed -- so it cannot reach
    # any AST state another testset built.
    act = CC.AnalysisAction()
    @test act.ptr != C_NULL

    # ento::AnalysisAction is a plain ASTFrontendAction: it overrides CreateASTConsumer and
    # nothing else, so every mode predicate is the base class's answer. usesPreprocessorOnly
    # is the one ASTFrontendAction itself pins, and the rest follow FrontendAction.
    @test CC.usesPreprocessorOnly(act) == false
    @test CC.hasPCHSupport(act) == true
    @test CC.hasASTFileSupport(act) == true
    @test CC.hasIRSupport(act) == false
    @test CC.hasCodeCompletionSupport(act) == false
    # ParseModelFileAction is the class in this header that answers true; this is the other.
    @test CC.isModelParsingAction(act) == false
    @test CC.getTranslationUnitKind(act) == CC.LibClangEx.CXTranslationUnitKind_TU_Complete

    # Outside a BeginSourceFile/EndSourceFile pair there is no current input, and the two
    # accessors gated on it must refuse rather than trip clang's own assertion.
    @test CC.isCurrentInputEmpty(act) == true
    @test_throws AssertionError CC.isCurrentFileAST(act)
    @test_throws AssertionError CC.getCurrentFileOrBufferName(act)

    # setCompilerInstance stores a raw, non-owning pointer, so the round trip hands back the
    # very same instance and `ci` still owns itself.
    ci = CC.CompilerInstance()
    @test CC.setCompilerInstance(act, ci) === nothing
    @test CC.getCompilerInstance(act).ptr == ci.ptr
    dispose(ci)

    dispose(act)
end
