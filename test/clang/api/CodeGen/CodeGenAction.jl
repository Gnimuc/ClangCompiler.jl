using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "codegen emit actions" begin
    llvm_ctx = CC.LLVM.Context()
    for T in (CC.EmitAssemblyAction, CC.EmitBCAction, CC.EmitLLVMAction, CC.EmitCodeGenOnlyAction, CC.EmitObjAction)
        act = T(llvm_ctx)
        try
            # CreateASTConsumer has not run, so the action has no generator yet — the
            # same lifecycle the LLVMOnlyAction testset asserts, for every emit flavour.
            @test CC.getCodeGenerator(act) === nothing
        finally
            dispose(act)
        end
    end
    CC.LLVM.dispose(llvm_ctx)
end

@testset "an action hands back the context it was given, and no generator before it runs" begin
    llvm_ctx = CC.LLVM.Context()
    act = CC.LLVMOnlyAction(llvm_ctx)

    # every constructor above supplies the context, so taking it back is the identity: the
    # action never made one of its own to hand over
    @test CC.takeLLVMContext(act).ref == llvm_ctx.ref

    # the code generator lives on the action's backend consumer, and that consumer is built
    # in CreateASTConsumer -- reaching for it beforehand dereferences a null pointer inside
    # clang, so the shim answers rather than crashing
    @test CC.getCodeGenerator(act) === nothing

    dispose(act)
    CC.LLVM.dispose(llvm_ctx)
end
