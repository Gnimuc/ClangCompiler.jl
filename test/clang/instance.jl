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
    @test CC.hasInvocation(instance) == true
    @test CC.hasFileManager(instance) == false
    @test CC.hasSourceManager(instance) == false
    @test CC.hasPreprocessor(instance) == false
    @test CC.hasSema(instance) == false

    CC.createFileManager(instance)
    @test CC.hasDiagnostics(instance) == true
    @test CC.hasInvocation(instance) == true
    @test CC.hasFileManager(instance) == true
    @test CC.hasSourceManager(instance) == false
    @test CC.hasPreprocessor(instance) == false
    @test CC.hasSema(instance) == false

    CC.createSourceManager(instance, CC.getFileManager(instance))
    @test CC.hasDiagnostics(instance) == true
    @test CC.hasInvocation(instance) == true
    @test CC.hasFileManager(instance) == true
    @test CC.hasSourceManager(instance) == true
    @test CC.hasPreprocessor(instance) == false
    @test CC.hasSema(instance) == false

    diag = CC.getDiagnostics(instance)
    target_opts = CC.TargetOptions()
    CC.setTriple(target_opts, "x86_64-apple-darwin11.1.0")
    target = CC.TargetInfo(target_opts, diag)
    CC.setTarget(instance, target)

    CC.createPreprocessor(instance)
    @test CC.hasDiagnostics(instance) == true
    @test CC.hasInvocation(instance) == true
    @test CC.hasFileManager(instance) == true
    @test CC.hasSourceManager(instance) == true
    @test CC.hasPreprocessor(instance) == true
    @test CC.hasSema(instance) == false

    @test CC.hasASTContext(instance) == false
    CC.createASTContext(instance)
    @test CC.hasASTContext(instance) == true

    @test CC.hasASTConsumer(instance) == false
    llvm_ctx = CC.LLVM.Context()
    codegen = CC.CreateLLVMCodeGen(instance, llvm_ctx)
    CC.setASTConsumer(instance, codegen)
    @test CC.hasASTConsumer(instance) == true

    CC.createSema(instance)
    @test CC.hasDiagnostics(instance) == true
    @test CC.hasInvocation(instance) == true
    @test CC.hasFileManager(instance) == true
    @test CC.hasSourceManager(instance) == true
    @test CC.hasPreprocessor(instance) == true
    @test CC.hasSema(instance) == true

    CC.dispose(instance)
    CC.LLVM.dispose(llvm_ctx)
end

@testset "CompilerInstance | SetMainFile" begin
    src = joinpath(@__DIR__, "..", "code", "main.cpp")
    args = get_compiler_args()
    push!(args, "-std=c++11")
    pushfirst!(args, "clang")
    push!(args, "-I$(@__DIR__)")

    instance = CC.CompilerInstance()
    CC.createDiagnostics(instance)
    diag = CC.getDiagnostics(instance)

    invok = CC.create_compiler_invocation_from_cmd(src, args, diag)
    CC.setInvocation(instance, invok)
    CC.setTargetAndLangOpts(instance)

    CC.createFileManager(instance)
    CC.createSourceManager(instance)

    CC.setMainFileID(instance, src)
    id = CC.getMainFileID(instance)
    @test CC.value(id) == 1
    CC.dispose(id)

    CC.dispose(instance)
end
