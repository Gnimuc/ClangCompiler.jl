using ClangCompiler
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
