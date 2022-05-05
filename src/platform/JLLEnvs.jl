module JLLEnvs

using Pkg
using Pkg.Artifacts
using Pkg.Artifacts: load_artifacts_toml, artifact_path
using Base.BinaryPlatforms

const ARTIFACT_TOML_PATH = normpath(joinpath(@__DIR__, "..", "..", "Artifacts.toml"))
const SHARDS = load_artifacts_toml(ARTIFACT_TOML_PATH)

include("env.jl")
include("version.jl")
include("target.jl")
include("types.jl")
include("system.jl")

function get_default_args(is_cxx=false, version=GCC_MIN_VER)
    env = get_default_env(; is_cxx, version)
    args = ["-isystem" * dir for dir in get_system_includes(env)]
    push!(args, "--target=$(target(env.platform))")
    return args
end

end # module
