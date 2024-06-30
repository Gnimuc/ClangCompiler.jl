"""
    get_compiler_flags(; is_cxx=true, version=JLLEnvs.GCC_MIN_VER)
Return the default compiler flags for the C/C++ compiler JLL build environment.
"""
function get_compiler_flags(; is_cxx=true, version=JLLEnvs.GCC_MIN_VER)
    # Config the JLL build environment
    env = JLLEnvs.get_default_env(; version, is_cxx)
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
    get_default_args(; is_cxx=true, version=v"7.1.0")
Return the default arguments for the C/C++ compiler JLL build environment.
"""
function get_default_args(; is_cxx=true, version=v"7.1.0")
    default_args = get_compiler_flags(; is_cxx, version)
    is_cxx && push!(default_args, "-xc++")
    clang_bin = joinpath(Clang_jll.artifact_dir, "bin", "clang")
    pushfirst!(default_args, clang_bin)  # Argv0
    return default_args
end
