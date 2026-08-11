"""
    get_compiler_flags(; is_cxx=true, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
Return the default compiler flags for the C/C++ compiler JLL build environment.

`triple` pins the target instead of taking the host's. The include paths come from that
target's GCC shard, so the resulting interpreter parses and lays out types exactly as it would
on that platform — sizes, alignments, record layout and mangling all follow the pinned target
rather than the machine running the tests. This is for parsing and AST inspection.

Executing under a pinned triple is a trap rather than a refusal. The JIT registers only the
native target, so a pin whose *architecture* differs from the host cannot run — but a
same-architecture pin across operating systems (`x86_64-linux-gnu` on an x86_64 mac) emits,
links and runs, using another platform's headers and ABI, and nothing raises.
"""
function get_compiler_flags(; is_cxx=true, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
    # Config the JLL build environment
    env = triple === nothing ? JLLEnvs.get_default_env(; version, is_cxx) : JLLEnvs.get_default_env(String(triple); version, is_cxx)
    args = ["-isystem" * dir for dir in JLLEnvs.get_system_includes(env)]
    clang_inc = joinpath(Clang_jll.artifact_dir, "lib", "clang", llvm_version, "include")
    push!(args, "-isystem" * clang_inc)
    push!(args, "--target=$(JLLEnvs.target(env.platform))")

    # Clean up default system includes
    is_cxx && push!(args, "-nostdinc++", "-nostdlib++")
    push!(args, "-nostdinc", "-nostdlib")

    return args
end

"""
    get_default_args(; is_cxx=true, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
Return the default arguments for the C/C++ compiler JLL build environment. `triple` pins the
target; see [`get_compiler_flags`](@ref).
"""
function get_default_args(; is_cxx=true, version=JLLEnvs.GCC_MIN_VER, triple=nothing)
    default_args = get_compiler_flags(; is_cxx, version, triple)
    is_cxx && push!(default_args, "-xc++")
    # clang_bin = joinpath(Clang_jll.artifact_dir, "bin", "clang")
    # pushfirst!(default_args, clang_bin)  # Argv0
    return default_args
end
