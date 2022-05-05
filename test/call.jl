using ClangCompiler
using Test

@testset "function call" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    haskey(ENV, "CI") && push!(args, "-v")
    irgen = IRGenerator(src, args)
    f = lookup_function(take_module(irgen), "main")
    @eval main() = $(call_function(f, Cint))
    @test main() == 42
    dispose(irgen)
end
