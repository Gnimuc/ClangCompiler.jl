using ClangCompiler
using ClangCompiler.LLVM
using Test

@testset "JIT call" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    haskey(ENV, "CI") && push!(args, "-v")
    irgen = IRGenerator(src, args)
    ee = JIT(take_module(irgen))
    f = lookup_function(ee, "main")
    ret = convert(Cint, run(ee, f))
    @test ret == 42
    dispose(irgen)
end
