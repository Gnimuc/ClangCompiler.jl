using ClangCompiler
using Test

@testset "function call" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_default_args()
    haskey(ENV, "CI") && push!(args, "-v")
    cpr = create_compiler(src, args)
    mod = compile(cpr)
    f = lookup_function(mod, "main")
    @eval main() = $(call_function(f, Cint))
    @test main() == 42
    destroy(cpr)
end
