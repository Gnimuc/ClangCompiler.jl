using ClangCompiler
using ClangCompiler.JLLEnvs

const CC = ClangCompiler

@testset "Status" begin
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

    CC.status(instance, CC.HeaderSearchOptions)
    CC.status(instance, CC.DiagnosticOptions)
    CC.status(instance, CC.FrontendOptions)
    CC.status(instance, CC.CodeGenOptions)
    CC.status(instance, CC.PreprocessorOptions)
    CC.status(instance, CC.TargetOptions)

    CC.create_file_manager(instance)
    CC.create_source_manager(instance)

    CC.get_file(instance, src)

    CC.create_preprocessor(instance)

    CC.status(instance, CC.HeaderSearch)

    CC.destroy(instance)
end
