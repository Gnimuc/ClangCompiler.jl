using ClangCompiler
using Test
using ClangCompiler:
    get_preprocessor,
    clang_Preprocessor_enableIncrementalProcessing,
    clang_Preprocessor_isIncrementalProcessingEnabled

@testset "boot" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    irgen = generate_llvmir(src, args)
    pp = get_preprocessor(irgen.instance)
    clang_Preprocessor_enableIncrementalProcessing(pp.ptr)
    @test clang_Preprocessor_isIncrementalProcessingEnabled(pp.ptr)
end
