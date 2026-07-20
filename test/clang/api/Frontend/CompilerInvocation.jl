using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "option object lifecycles" begin
    cgo = CC.CodeGenOptions()
    @test cgo.ptr != C_NULL
    dispose(cgo)

    tgo = CC.TargetOptions()
    CC.setTriple(tgo, "x86_64-unknown-linux-gnu")
    dispose(tgo)

    dgo = CC.DiagnosticOptions()
    CC.setShowColors(dgo, false)
    dispose(dgo)

    ids = CC.DiagnosticIDs()
    @test ids.ptr != C_NULL
    dispose(ids)

    inv = CC.CompilerInvocation(CC.LibClangEx.clang_CompilerInvocation_create())
    @test inv.ptr != C_NULL
    dispose(inv)
end
