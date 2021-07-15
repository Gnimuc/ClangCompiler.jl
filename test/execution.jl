using ClangCompiler
using ClangCompiler.LLVM
using Test

@testset "JIT call" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_default_args()
    haskey(ENV, "CI") && push!(args, "-v")
    cpr = create_compiler(src, args)
    mod = compile(cpr)
    ee = JIT(mod)
    f = lookup_function(ee, "main")
    ret = convert(Cint, run(ee, f))
    @test ret == 42
    destroy(cpr)
end
