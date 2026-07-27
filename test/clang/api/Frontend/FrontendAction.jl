using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "frontend action queries and component ownership transfer" begin
    # A CodeGenAction is the only concrete FrontendAction this API can build. It is only
    # queried here — never given an input, never executed — so it cannot reach any AST
    # state an earlier testset built.
    lctx = CC.LLVM.Context()
    act = CC.LLVMOnlyAction(lctx)
    ci = CC.CompilerInstance()

    # setCompilerInstance stores a raw, non-owning pointer, so the round trip hands back
    # the very same instance and `ci` still owns itself.
    @test CC.setCompilerInstance(act, ci) === nothing
    @test CC.getCompilerInstance(act) isa CC.CompilerInstance
    @test CC.getCompilerInstance(act).ptr == ci.ptr

    # The supported-mode predicates are plain virtual dispatch and are valid before any
    # input; only hasIRSupport is overridden out of line by CodeGenAction.
    @test CC.isModelParsingAction(act) == false
    @test CC.usesPreprocessorOnly(act) == false
    @test CC.hasPCHSupport(act) == true
    @test CC.hasASTFileSupport(act) == true
    @test CC.hasIRSupport(act) isa Bool
    @test CC.hasCodeCompletionSupport(act) == false
    @test CC.getTranslationUnitKind(act) == CC.LibClangEx.CXTranslationUnitKind_TU_Complete

    # Outside a BeginSourceFile/EndSourceFile pair there is no current input, and the two
    # accessors gated on it must refuse rather than trip clang's own assertion.
    @test CC.isCurrentInputEmpty(act) == true
    @test_throws AssertionError CC.isCurrentFileAST(act)
    @test_throws AssertionError CC.getCurrentFileOrBufferName(act)

    dispose(act)
    CC.LLVM.dispose(lctx)

    # resetAndLeak* buries the component instead of freeing it. Nothing is set on this
    # fresh instance, so every call buries a null pointer and leaks nothing;
    # resetAndLeakPreprocessor alone leaves the instance's own pointer in place.
    @test CC.hasFileManager(ci) == false
    @test CC.resetAndLeakFileManager(ci) === nothing
    @test CC.hasFileManager(ci) == false
    @test CC.hasSourceManager(ci) == false
    @test CC.resetAndLeakSourceManager(ci) === nothing
    @test CC.hasSourceManager(ci) == false
    @test CC.hasPreprocessor(ci) == false
    @test CC.resetAndLeakPreprocessor(ci) === nothing
    @test CC.hasPreprocessor(ci) == false
    @test CC.hasASTContext(ci) == false
    @test CC.resetAndLeakASTContext(ci) === nothing
    @test CC.hasASTContext(ci) == false
    @test CC.hasSema(ci) == false
    @test CC.resetAndLeakSema(ci) === nothing
    @test CC.hasSema(ci) == false
    dispose(ci)

    # Both invocation resets mutate in place and leave the invocation usable.
    inv = CC.CompilerInvocation()
    @test CC.resetNonModularOptions(inv) === nothing
    @test CC.clearImplicitModuleBuildOptions(inv) === nothing
    @test CC.getModuleHash(inv) isa String
    @test !isempty(CC.getModuleHash(inv))
    dispose(inv)
end
