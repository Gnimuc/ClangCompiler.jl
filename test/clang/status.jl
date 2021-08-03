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

    CC.print_stats(instance, CC.HeaderSearchOptions)
    CC.print_stats(instance, CC.DiagnosticOptions)
    CC.print_stats(instance, CC.FrontendOptions)
    CC.print_stats(instance, CC.CodeGenOptions)
    CC.print_stats(instance, CC.PreprocessorOptions)
    CC.print_stats(instance, CC.TargetOptions)

    CC.create_file_manager(instance)
    CC.create_source_manager(instance)

    CC.get_file(instance, src)

    CC.create_preprocessor(instance)

    CC.print_stats(instance, CC.HeaderSearch)

    CC.destroy(instance)
end
