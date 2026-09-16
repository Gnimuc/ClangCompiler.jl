function get_env(p::Platform; version::VersionNumber=GCC_MIN_VER, is_cxx=false)
    if os(p) == "macos"
        return MacEnv(p, version, is_cxx)
    elseif os(p) == "windows"
        return WindowsEnv(p, version, is_cxx)
    elseif arch(p) == "armv7l"
        return ArmEnv(p, version, is_cxx)
    elseif libc(p) == "musl"
        return MuslEnv(p, version, is_cxx)
    elseif libc(p) == "glibc" || libc(p) == "gnu"
        return GnuEnv(p, version, is_cxx)
    else
        @warn "unknown platform! using default GNU environment."
        return GnuEnv(p, version, is_cxx)
    end
end

function get_default_env(; version::VersionNumber=GCC_MIN_VER, is_cxx=false)
    p = HostPlatform()
    # tweak the default version for aarch64 macos
    v = version == GCC_MIN_VER && os(p) == "macos" && arch(p) == "aarch64" ? v"11.0.0-iains" : version
    return get_env(p; version=v, is_cxx)
end

function get_default_env(triple::AbstractString; version::VersionNumber=GCC_MIN_VER, is_cxx=false)
    p = parse(Platform, triple)
    # tweak the default version for aarch64 macos
    v = version == GCC_MIN_VER && os(p) == "macos" && arch(p) == "aarch64" ? v"11.0.0-iains" : version
    return get_env(p; version=v, is_cxx)
end

function _ensure_gcc_prefix(env::AbstractJLLEnv)
    gcc_info = get_environment_info(env.platform, env.gcc_version)
    if haskey(ENV, "JULIA_CLANG_SHARDS_URL") && !isempty(get(ENV, "JULIA_CLANG_SHARDS_URL", ""))
        @info "Downloading artifact($(gcc_info.id))"
    end
    name = get_gcc_shard_key(env.platform, env.gcc_version)
    Artifacts.ensure_artifact_installed(name, JLL_ENV_SHARDS[name][], ARTIFACT_TOML_PATH[])
    return artifact_path(Base.SHA1(gcc_info.id))
end

function get_system_includes(env::AbstractJLLEnv=get_default_env())
    gcc_prefix = _ensure_gcc_prefix(env)
    isys = String[]
    get_system_includes!(env, gcc_prefix, isys)
    for dir in isys
        @assert isdir(dir) "failed to setup environment due to missing dir: $dir, please file an issue."
    end
    return normpath.(isys)
end

"""
    get_system_libdirs(env::AbstractJLLEnv=get_default_env()) -> Vector{String}

Library directories of the GCC shard used for `env` — the counterpart of
[`get_system_includes`](@ref). Only directories that exist are returned.
"""
function get_system_libdirs(env::AbstractJLLEnv=get_default_env())
    gcc_prefix = _ensure_gcc_prefix(env)
    libs = String[]
    get_system_libdirs!(env, gcc_prefix, libs)
    return unique!(normpath.(libs))
end

function get_system_libdirs!(env::MacEnv, prefix::String, libs::Vector{String})
    triple = __triplet(env.platform)
    for dir in (joinpath(prefix, triple, "lib"), joinpath(prefix, triple, "sys-root", "usr", "lib"),
                joinpath(prefix, "lib"))
        isdir(dir) && push!(libs, dir)
    end
    return libs
end

function get_system_libdirs!(env::WindowsEnv, prefix::String, libs::Vector{String})
    triple = __triplet(env.platform)
    version = env.gcc_version
    for dir in (joinpath(prefix, triple, "lib"), joinpath(prefix, "lib", "gcc", triple, string(version)),
                joinpath(prefix, triple, "sys-root", "lib"))
        isdir(dir) && push!(libs, dir)
    end
    return libs
end

function get_system_libdirs!(env::Union{GnuEnv,MuslEnv}, prefix::String, libs::Vector{String})
    triple = __triplet(env.platform)
    version = env.gcc_version
    for dir in (joinpath(prefix, triple, "lib"), joinpath(prefix, triple, "lib64"),
                joinpath(prefix, "lib", "gcc", triple, string(version)),
                joinpath(prefix, triple, "sys-root", "lib"), joinpath(prefix, triple, "sys-root", "usr", "lib"),
                joinpath(prefix, triple, "sys-root", "usr", "lib64"))
        isdir(dir) && push!(libs, dir)
    end
    return libs
end

function get_system_libdirs!(env::ArmEnv, prefix::String, libs::Vector{String})
    t = env.platform == Platform("armv7l", "linux") ? "arm-linux-gnueabihf" : "arm-linux-musleabihf"
    version = env.gcc_version
    for dir in (joinpath(prefix, t, "lib"), joinpath(prefix, "lib", "gcc", t, string(version)),
                joinpath(prefix, t, "sys-root", "usr", "lib"))
        isdir(dir) && push!(libs, dir)
    end
    return libs
end

function get_system_includes!(env::MacEnv, prefix::String, isys::Vector{String})
    p = env.platform
    triple = __triplet(env.platform)
    version = env.gcc_version
    if os(p) == "macos" && arch(p) == "x86_64"
        if env.is_cxx
            push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include", "c++", "v1"))
            push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
            push!(isys, joinpath(prefix, triple, "include", "c++", string(version)))
            push!(isys, joinpath(prefix, triple, "include", "c++", string(version), triple))
            push!(isys, joinpath(prefix, triple, "include", "c++", string(version), "backward"))
            push!(isys, joinpath(prefix, triple, "include"))
            push!(isys, joinpath(prefix, triple, "sys-root", "System", "Library", "Frameworks"))
        else
            push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include"))
            push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include-fixed"))
            push!(isys, joinpath(prefix, triple, "include"))
            push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
            push!(isys, joinpath(prefix, triple, "sys-root", "System", "Library", "Frameworks"))
        end
    else  # "aarch64-apple-darwin20"
        ver = VersionNumber(version.major, version.minor, version.patch)
        if env.is_cxx
            push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include", "c++", "v1"))
            push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
            push!(isys, joinpath(prefix, triple, "sys-root", "System", "Library", "Frameworks"))
        else
            push!(isys, joinpath(prefix, "lib", "gcc", triple, string(ver), "include"))
            push!(isys, joinpath(prefix, "lib", "gcc", triple, string(ver), "include-fixed"))
            push!(isys, joinpath(prefix, triple, "include"))
            push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
            push!(isys, joinpath(prefix, triple, "sys-root", "System", "Library", "Frameworks"))
        end
    end
end

function get_system_includes!(env::WindowsEnv, prefix::String, isys::Vector{String})
    triple = __triplet(env.platform)
    version = env.gcc_version
    if env.is_cxx
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version)))
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version), triple))
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version), "backward"))
        push!(isys, joinpath(prefix, triple, "include"))
        push!(isys, joinpath(prefix, triple, "sys-root", "include"))
    else
        push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include"))
        push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include-fixed"))
        push!(isys, joinpath(prefix, triple, "include"))
        push!(isys, joinpath(prefix, triple, "sys-root", "include"))
    end
end

function get_system_includes!(env::GnuEnv, prefix::String, isys::Vector{String})
    triple = __triplet(env.platform)
    version = env.gcc_version
    if env.is_cxx
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version)))
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version), triple))
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version), "backward"))
        push!(isys, joinpath(prefix, triple, "include"))
        push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
    else
        push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include"))
        push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include-fixed"))
        push!(isys, joinpath(prefix, triple, "include"))
        push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
    end
end

function get_system_includes!(env::MuslEnv, prefix::String, isys::Vector{String})
    triple = __triplet(env.platform)
    version = env.gcc_version
    if env.is_cxx
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version)))
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version), triple))
        push!(isys, joinpath(prefix, triple, "include", "c++", string(version), "backward"))
        push!(isys, joinpath(prefix, triple, "include"))
        push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
    else
        push!(isys, joinpath(prefix, "lib", "gcc", triple, string(version), "include"))
        push!(isys, joinpath(prefix, triple, "include"))
        push!(isys, joinpath(prefix, triple, "sys-root", "usr", "include"))
    end
end

function get_system_includes!(env::ArmEnv, prefix::String, isys::Vector{String})
    triple = __triplet(env.platform)
    version = env.gcc_version
    if env.platform == Platform("armv7l", "linux")
        if env.is_cxx
            push!(isys, joinpath(prefix, "arm-linux-gnueabihf", "include", "c++", string(version)))
            push!(isys,
                  joinpath(prefix, "arm-linux-gnueabihf", "include", "c++", string(version), "arm-linux-gnueabihf"))
            push!(isys, joinpath(prefix, "arm-linux-gnueabihf", "include", "c++", string(version), "backward"))
            push!(isys, joinpath(prefix, "arm-linux-gnueabihf", "include"))
            push!(isys, joinpath(prefix, "arm-linux-gnueabihf", "sys-root", "usr", "include"))
        else
            push!(isys, joinpath(prefix, "lib", "gcc", "arm-linux-gnueabihf", string(version), "include"))
            push!(isys, joinpath(prefix, "lib", "gcc", "arm-linux-gnueabihf", string(version), "include-fixed"))
            push!(isys, joinpath(prefix, "arm-linux-gnueabihf", "include"))
            push!(isys, joinpath(prefix, "arm-linux-gnueabihf", "sys-root", "usr", "include"))
        end
    else  # "armv7l-linux-musleabihf"
        if env.is_cxx
            push!(isys, joinpath(prefix, "arm-linux-musleabihf", "include", "c++", string(version)))
            push!(isys,
                  joinpath(prefix, "arm-linux-musleabihf", "include", "c++", string(version), "arm-linux-musleabihf"))
            push!(isys, joinpath(prefix, "arm-linux-musleabihf", "include", "c++", string(version), "backward"))
            push!(isys, joinpath(prefix, "arm-linux-musleabihf", "include"))
            push!(isys, joinpath(prefix, "arm-linux-musleabihf", "sys-root", "usr", "include"))
        else
            push!(isys, joinpath(prefix, "lib", "gcc", "arm-linux-musleabihf", string(version), "include"))
            push!(isys, joinpath(prefix, "lib", "gcc", "arm-linux-musleabihf", string(version), "include-fixed"))
            push!(isys, joinpath(prefix, "arm-linux-musleabihf", "include"))
            push!(isys, joinpath(prefix, "arm-linux-musleabihf", "sys-root", "usr", "include"))
        end
    end
end
