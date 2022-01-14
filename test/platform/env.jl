using ClangCompiler.JLLEnvs
using Test
using Base.BinaryPlatforms

@testset "JLLEnv" begin
    p = HostPlatform()
    @info p
    @info os(p), arch(p), libc(p)
    @test_nowarn JLLEnvs.get_default_env(; is_cxx=true, version=v"7.0.1")
end
