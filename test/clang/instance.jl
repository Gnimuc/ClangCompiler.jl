using ClangCompiler
using Test

const CC = ClangCompiler

@testset "CompilerInstance | SubModule" begin
    instance = CC.CompilerInstance()
    @test CC.has_diagnostics(instance) == false
    @test CC.has_invocation(instance) == true
    @test CC.has_file_manager(instance) == false
    @test CC.has_source_manager(instance) == false
    @test CC.has_preprocessor(instance) == false
    @test CC.has_sema(instance) == false

    CC.create_diagnostics(instance)
    @test CC.has_diagnostics(instance) == true
    @test CC.has_invocation(instance) == true
    @test CC.has_file_manager(instance) == false
    @test CC.has_source_manager(instance) == false
    @test CC.has_preprocessor(instance) == false
    @test CC.has_sema(instance) == false

    CC.create_file_manager(instance)
    @test CC.has_diagnostics(instance) == true
    @test CC.has_invocation(instance) == true
    @test CC.has_file_manager(instance) == true
    @test CC.has_source_manager(instance) == false
    @test CC.has_preprocessor(instance) == false
    @test CC.has_sema(instance) == false

    CC.create_source_manager(instance, CC.get_file_manager(instance))
    @test CC.has_diagnostics(instance) == true
    @test CC.has_invocation(instance) == true
    @test CC.has_file_manager(instance) == true
    @test CC.has_source_manager(instance) == true
    @test CC.has_preprocessor(instance) == false
    @test CC.has_sema(instance) == false

    diag = CC.get_diagnostics(instance)
    target_opts = CC.TargetOptions()
    CC.set_triple(target_opts, "x86_64-apple-darwin11.1.0")
    target = CC.TargetInfo(target_opts, diag)
    CC.set_target(instance, target)

    CC.create_preprocessor(instance)
    @test CC.has_diagnostics(instance) == true
    @test CC.has_invocation(instance) == true
    @test CC.has_file_manager(instance) == true
    @test CC.has_source_manager(instance) == true
    @test CC.has_preprocessor(instance) == true
    @test CC.has_sema(instance) == false

    @test CC.has_ast_context(instance) == false
    CC.create_ast_context(instance)
    @test CC.has_ast_context(instance) == true

    @test CC.has_ast_consumer(instance) == false
    llvm_ctx = CC.LLVM.Context()
    codegen = CC.create_llvm_codegen(instance, llvm_ctx)
    CC.set_ast_consumer(instance, codegen)
    @test CC.has_ast_consumer(instance) == true

    CC.create_sema(instance)
    @test CC.has_diagnostics(instance) == true
    @test CC.has_invocation(instance) == true
    @test CC.has_file_manager(instance) == true
    @test CC.has_source_manager(instance) == true
    @test CC.has_preprocessor(instance) == true
    @test CC.has_sema(instance) == true

    CC.destroy(instance)
    CC.LLVM.dispose(llvm_ctx)
end

@testset "CompilerInstance | SetMainFile" begin
    src = joinpath(@__DIR__, "..", "code", "main.cpp")
    args = get_compiler_args()
    push!(args, "-std=c++11")
    pushfirst!(args, "clang")
    push!(args, "-I$(@__DIR__)")

    instance = CC.CompilerInstance()
    CC.create_diagnostics(instance)
    diag = CC.get_diagnostics(instance)

    invok = CC.create_compiler_invocation_from_cmd(src, args, diag)
    CC.set_invocation(instance, invok)
    CC.set_target(instance)

    CC.create_file_manager(instance)
    CC.create_source_manager(instance)

    CC.set_main_file(instance, src)
    id = CC.get_main_file_id(instance)
    @test CC.value(id) == 1
    CC.destroy(id)

    CC.destroy(instance)
end
