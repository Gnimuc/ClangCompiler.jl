using ClangCompiler
import ClangCompiler as CC
using Base.BinaryPlatforms
using Test

const J = CC.JLLEnvs

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

@testset "coverage tail: JLLEnvs helpers" begin
    J = CC.JLLEnvs

    # triple2target: mapped and unmapped triples
    @test J.triple2target("x86_64-linux-gnu") == "x86_64-unknown-linux-gnu"
    @test J.triple2target("not-a-triple") == "unknown"

    # get_arch / get_os / get_libc / get_arch_os_libc — pure string splitters
    @test J.get_arch("x86_64-linux-gnu") == "x86_64"
    @test J.get_os("aarch64-apple-darwin20") == "macos"
    @test J.get_os("x86_64-w64-mingw32") == "windows"
    @test J.get_os("x86_64-unknown-freebsd13.2") == "freebsd"
    @test J.get_os("x86_64-linux-gnu") == "linux"
    @test J.get_libc("x86_64-linux-gnu") == "glibc"
    @test J.get_libc("x86_64-linux-musl") == "musl"
    @test J.get_libc("aarch64-apple-darwin20") == ""
    @test J.get_arch_os_libc("x86_64-linux-gnu") == ("x86_64", "linux", "glibc")

    # get_default_env(triple): every env-dispatch branch (construction only)
    @test J.get_default_env("aarch64-apple-darwin20") isa J.MacEnv
    @test J.get_default_env("x86_64-w64-mingw32") isa J.WindowsEnv
    @test J.get_default_env("armv7l-linux-gnueabihf") isa J.ArmEnv
    @test J.get_default_env("x86_64-linux-musl") isa J.MuslEnv
    @test J.get_default_env("x86_64-linux-gnu") isa J.GnuEnv

    # get_system_includes! for every non-mac env flavor: pure path
    # construction against a fake prefix — no artifact downloads
    for triple in ("x86_64-w64-mingw32", "x86_64-linux-gnu", "x86_64-linux-musl", "armv7l-linux-gnueabihf",
                   "armv7l-linux-musleabihf")
        for is_cxx in (false, true)
            env = J.get_default_env(triple; is_cxx)
            isys = String[]
            J.get_system_includes!(env, "cefp-prefix", isys)
            @test !isempty(isys)
            @test all(p -> startswith(p, "cefp-prefix"), isys)
        end
    end

    # host-shard-backed lookups: the same shard/artifacts the interpreter's
    # default flags resolve, so they are present wherever the suite runs
    env = J.get_default_env(; is_cxx=true)
    host_triple = J.__triplet(env.platform)
    dirs = J.get_system_dirs(host_triple, J.GCC_MIN_VER, true)
    @test dirs isa Vector{String}
    @test !isempty(dirs)
    @test all(isdir, dirs)

    adir = J.get_pkg_artifact_dir(CC.libclangex_jll, host_triple)
    @test adir isa String
    @test isdir(adir)
    idir = J.get_pkg_include_dir(CC.libclangex_jll, host_triple)
    @test idir isa String
    @test !isempty(idir)
end
