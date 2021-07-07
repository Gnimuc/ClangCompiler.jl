using ClangCompiler
using ClangCompiler.JLLEnvs
using Test

const CC = ClangCompiler

@testset "CompilerInstance | init" begin
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

    # CC.create_ast_context(instance)
    # CC.create_ast_consumer ?

    # CC.create_sema(instance)
    # @test CC.has_diagnostics(instance) == true
    # @test CC.has_invocation(instance) == true
    # @test CC.has_file_manager(instance) == true
    # @test CC.has_source_manager(instance) == true
    # @test CC.has_preprocessor(instance) == true
    # @test CC.has_sema(instance) == true

    CC.destroy(instance)
end

@testset "CompilerInstance | SetMainFile" begin
    src = joinpath(@__DIR__, "..", "code", "main.cpp")
    args = JLLEnvs.get_default_args()
    push!(args, "-nostdinc")
    push!(args, "-nostdinc++")
    push!(args, "-nostdlib")
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
