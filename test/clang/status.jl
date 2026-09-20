using ClangCompiler
using Test

const CC = ClangCompiler

@testset "Status" begin
    src = normpath(joinpath(@__DIR__, "..", "cxx", "main.cpp"))
    args = CC.get_default_args()
    push!(args, "-std=c++11")

    instance = CC.CompilerInstance()
    CC.createDiagnostics(instance)
    diag = CC.getDiagnostics(instance)

    invok = CC.createFromCommandLine(src, args, diag)
    CC.setInvocation(instance, invok)  # adopts invok — no dispose
    CC.setTargetAndLangOpts(instance)

    # the stats dumps go to stderr; run them for coverage, drop the noise
    redirect_stdio(; stderr=devnull) do
        CC.PrintStats(instance, CC.HeaderSearchOptions)
        CC.PrintStats(instance, CC.DiagnosticOptions)
        CC.PrintStats(instance, CC.FrontendOptions)
        CC.PrintStats(instance, CC.CodeGenOptions)
        CC.PrintStats(instance, CC.PreprocessorOptions)
        CC.PrintStats(instance, CC.TargetOptions)
    end

    CC.createFileManager(instance)
    CC.createSourceManager(instance)

    entry = CC.getFileEntry(instance, src)
    @test CC.real_path_name(entry) == src
    @test CC.getSize(entry) > 0

    CC.createPreprocessor(instance)
    redirect_stdio(; stderr=devnull) do
        CC.PrintStats(instance, CC.HeaderSearch)
    end

    CC.dispose(instance)
end
