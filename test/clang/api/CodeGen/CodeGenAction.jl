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
    for T in (CC.EmitAssemblyAction, CC.EmitBCAction, CC.EmitLLVMAction,
              CC.EmitCodeGenOnlyAction, CC.EmitObjAction)
        act = T(llvm_ctx)
        @test act isa T
        @test act.ptr != C_NULL
        dispose(act)
    end
    CC.LLVM.dispose(llvm_ctx)
end
