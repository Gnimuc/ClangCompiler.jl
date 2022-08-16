using Clang.Generators

cd(@__DIR__)

options = load_options(joinpath(@__DIR__, "generator.toml"))

@add_def time_t
@add_def LLVMModuleRef
@add_def LLVMOpaqueModule
@add_def LLVMOpaqueContext
@add_def LLVMContextRef
@add_def LLVMMemoryBufferRef
@add_def LLVMGenericValueRef
@add_def LLVMTypeRef

import Pkg
import BinaryBuilderBase: PkgSpec, Prefix, temp_prefix, setup_dependencies, cleanup_dependencies, destdir

const dependencies = PkgSpec[
    PkgSpec(; name = "LLVM_full_jll"),
    PkgSpec(; name = "libclangex_jll"),
]

const libdir = joinpath(@__DIR__, "..", "lib")

for (llvm_version, julia_version) in ((v"12.0.1", v"1.7"),
                                      (v"13.0.1", v"1.8"),)
    @info "Generating..." llvm_version julia_version
    temp_prefix() do prefix
    # let prefix = Prefix(mktempdir())
        platform = Pkg.BinaryPlatforms.HostPlatform()
        platform["llvm_version"] = string(llvm_version.major)
        platform["julia_version"] = string(julia_version)
        artifact_paths = setup_dependencies(prefix, dependencies, platform; verbose=true)

        let options = deepcopy(options)
            output_file_path = joinpath(libdir, string(llvm_version.major), options["general"]["output_file_path"])
            isdir(dirname(output_file_path)) || mkpath(dirname(output_file_path))
            options["general"]["output_file_path"] = output_file_path

            include_dir = joinpath(destdir(prefix, platform), "include")
            libclangex_include_dir = joinpath(include_dir, "clang-ex")
            args = Generators.get_default_args()
            push!(args, "-isystem$include_dir")
            push!(args, "-I$libclangex_include_dir")

            headers = detect_headers(libclangex_include_dir, args)
            ctx = create_context(headers, args, options)

            build!(ctx)
        end

        cleanup_dependencies(prefix, artifact_paths, platform)
    end
end
