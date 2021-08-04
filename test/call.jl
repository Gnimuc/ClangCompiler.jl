using ClangCompiler
using Test

@testset "function call" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    haskey(ENV, "CI") && push!(args, "-v")
    irgen = generate_llvmir(src, args)
    f = lookup_function(get_module(irgen), "main")
    @eval main() = $(call_function(f, Cint))
    @test main() == 42
    dispose(irgen)
end
