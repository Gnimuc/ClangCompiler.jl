using ClangCompiler
using Base.BinaryPlatforms
using Test

const J = ClangCompiler.JLLEnvs

# get_env dispatches on the target Platform to one of the cross-compilation
# environment types. On any single CI host only one branch would otherwise run,
# so drive every branch with explicit Platforms (construction is cheap — no
# artifact download).
@testset "Platform | get_env dispatch" begin
    @test J.get_env(Platform("aarch64", "macos")) isa J.MacEnv
    @test J.get_env(Platform("x86_64", "windows")) isa J.WindowsEnv
    @test J.get_env(Platform("armv7l", "linux")) isa J.ArmEnv
    @test J.get_env(Platform("x86_64", "linux"; libc="musl")) isa J.MuslEnv
    @test J.get_env(Platform("x86_64", "linux")) isa J.GnuEnv        # glibc/gnu
    @test J.get_env(Platform("aarch64", "linux")) isa J.GnuEnv
    # each carries its originating platform
    @test J.get_env(Platform("x86_64", "windows")).platform isa Platform
end
