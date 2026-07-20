using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "ASTConsumer Initialize on a throwaway interpreter" begin
    # Initialize rewires the consumer to an ASTContext; re-initializing a
    # throwaway interpreter's own consumer against its own context is a benign
    # re-init (a fresh CodeGenModule over the same context), and the interpreter
    # is disposed immediately after without parsing again.
    I = create_interpreter(String[])
    ci = CC.get_instance(I)
    @test CC.hasASTConsumer(ci)
    cg = CC.get_codegen(ci)                      # borrowed consumer
    @test CC.Initialize(cg, CC.get_ast_context(I)) === nothing
    dispose(I)
end
