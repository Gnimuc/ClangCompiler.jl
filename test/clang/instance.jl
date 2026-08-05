using ClangCompiler
using Test

const CC = ClangCompiler

@testset "CompilerInstance | SubModule" begin
    instance = CC.CompilerInstance()
    @test CC.hasDiagnostics(instance) == false
    @test CC.hasInvocation(instance) == true
    @test CC.hasFileManager(instance) == false
    @test CC.hasSourceManager(instance) == false
    @test CC.hasPreprocessor(instance) == false
    @test CC.hasSema(instance) == false

    CC.createDiagnostics(instance)
    @test CC.hasDiagnostics(instance) == true
    @test CC.hasFileManager(instance) == false

    CC.createFileManager(instance)
    @test CC.hasFileManager(instance) == true
    @test CC.hasSourceManager(instance) == false

    CC.createSourceManager(instance, CC.getFileManager(instance))
    @test CC.hasSourceManager(instance) == true
    @test CC.hasPreprocessor(instance) == false

    diag = CC.getDiagnostics(instance)
    target_opts = CC.TargetOptions()
    CC.setTriple(target_opts, "x86_64-apple-darwin11.1.0")
    target = CC.TargetInfo(target_opts, diag)  # absorbs target_opts
    CC.setTarget(instance, target)

    CC.createPreprocessor(instance)
    @test CC.hasPreprocessor(instance) == true
    @test CC.hasSema(instance) == false

    @test CC.hasASTContext(instance) == false
    CC.createASTContext(instance)
    @test CC.hasASTContext(instance) == true

    # createSema needs an ASTConsumer; CodeGenerator is reachable only through
    # an interpreter's consumer, so the Sema step is exercised in execution.jl.
    @test CC.hasASTConsumer(instance) == false

    CC.dispose(instance)
end

@testset "CompilerInstance | SetMainFile" begin
    src = normpath(joinpath(@__DIR__, "..", "cxx", "main.cpp"))
    args = CC.get_default_args()
    push!(args, "-std=c++11")

    instance = CC.CompilerInstance()
    CC.createDiagnostics(instance)
    diag = CC.getDiagnostics(instance)

    invok = CC.create_compiler_invocation_from_cmd(src, args, diag)
    CC.setInvocation(instance, invok)  # adopts invok — no dispose
    CC.setTargetAndLangOpts(instance)

    CC.createFileManager(instance)
    CC.createSourceManager(instance)

    CC.setMainFileID(instance, src)
    id = CC.getMainFileID(instance)
    @test CC.getHashValue(id) == 1
    CC.dispose(id)

    CC.dispose(instance)
end
