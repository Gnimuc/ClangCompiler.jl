using ClangCompiler
using Test

const CC = ClangCompiler

@testset "Status" begin
    src = joinpath(@__DIR__, "..", "code", "main.cpp")
    args = get_compiler_args()
    push!(args, "-std=c++11")
    pushfirst!(args, "clang")
    push!(args, "-I$(@__DIR__)")

    instance = CC.CompilerInstance()
    CC.createDiagnostics(instance)
    diag = CC.getDiagnostics(instance)

    invok = CC.createFromCommandLine(src, args, diag)
    CC.setInvocation(instance, invok)
    CC.setTargetAndLangOpts(instance)

    CC.PrintStats(instance, CC.HeaderSearchOptions)
    CC.PrintStats(instance, CC.DiagnosticOptions)
    CC.PrintStats(instance, CC.FrontendOptions)
    CC.PrintStats(instance, CC.CodeGenOptions)
    CC.PrintStats(instance, CC.PreprocessorOptions)
    CC.PrintStats(instance, CC.TargetOptions)

    CC.createFileManager(instance)
    CC.createSourceManager(instance)

    CC.getFileEntry(instance, src)

    CC.createPreprocessor(instance)

    CC.PrintStats(instance, CC.HeaderSearch)

    CC.dispose(instance)
end
