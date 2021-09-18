using ClangCompiler

const CC = ClangCompiler

@testset "Status" begin
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

    CC.PrintStats(instance, CC.HeaderSearchOptions)
    CC.PrintStats(instance, CC.DiagnosticOptions)
    CC.PrintStats(instance, CC.FrontendOptions)
    CC.PrintStats(instance, CC.CodeGenOptions)
    CC.PrintStats(instance, CC.PreprocessorOptions)
    CC.PrintStats(instance, CC.TargetOptions)

    CC.create_file_manager(instance)
    CC.create_source_manager(instance)

    CC.get_file(instance, src)

    CC.create_preprocessor(instance)

    CC.PrintStats(instance, CC.HeaderSearch)

    CC.dispose(instance)
end
