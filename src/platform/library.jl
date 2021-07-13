function get_pkg_artifact_dir(pkg::Module, target::String)
    afts = first(values(load_artifacts_toml(find_artifacts_toml(pathof(pkg)))))
    target_arch, target_os, target_libc = get_arch_os_libc(target)
    candidates = Dict[]
    for info in afts
        if info isa Dict
            arch = get(info, "arch", "")
            os = get(info, "os", "")
            libc = get(info, "libc", "")
            if arch == target_arch && os == target_os && libc == target_libc
                push!(candidates, info)
            end
        else
            # this could be an "Any"-platform JLL package
            push!(candidates, afts)
            break
        end
    end
    isempty(candidates) && return ""
    length(candidates) > 1 && @warn "found more than one candidate artifacts, only use the first one: $(first(candidates))"
    info = first(candidates)
    download_info = info["download"][]
    id, url, chk = info["git-tree-sha1"], download_info["url"], download_info["sha256"]
    download_artifact(Base.SHA1(id), url, chk)
    return normpath(artifact_path(Base.SHA1(id)))
end

function get_pkg_include_dir(pkg::Module, target::String)
    artifact_dir = get_pkg_artifact_dir(pkg, target)
    incdir = isempty(artifact_dir) ? "" : joinpath(artifact_dir, "include")
    return incdir
end
