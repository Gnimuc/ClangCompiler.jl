# build a local version of ClangExtra

using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

if haskey(ENV, "GITHUB_ACTIONS")
    println("::warning ::Using a locally-built ClangExtra; A bump of libclangex_jll will be required before releasing ClangCompiler.jl.")
end

using Pkg, Scratch, Preferences, Libdl, CMake_jll

ClangCompiler = Base.UUID("06fc9500-c033-43bc-8ca2-e20da63309d9")

# get scratch directories
scratch_dir = get_scratch!(ClangCompiler, "build")
isdir(scratch_dir) && rm(scratch_dir; recursive=true)
source_dir = joinpath(@__DIR__, "ClangExtra")

# get build directory
build_dir = if isempty(ARGS)
    mktempdir()
else
    ARGS[1]
end
mkpath(build_dir)

# download LLVM
Pkg.activate(; temp=true)
llvm_assertions = try
    cglobal((:_ZN4llvm24DisableABIBreakingChecksE, Base.libllvm_path()), Cvoid)
    false
catch
    true
end
llvm_pkg_version = "$(Base.libllvm_version.major).$(Base.libllvm_version.minor)"
LLVM = if llvm_assertions
    Pkg.add(; name="LLVM_full_assert_jll", version=llvm_pkg_version)
    using LLVM_full_assert_jll
    LLVM_full_assert_jll
else
    Pkg.add(; name="LLVM_full_jll", version=llvm_pkg_version)
    using LLVM_full_jll
    LLVM_full_jll
end
LLVM_DIR = joinpath(LLVM.artifact_dir, "lib", "cmake", "llvm")
Clang_DIR = joinpath(LLVM.artifact_dir, "lib", "cmake", "clang")

# build and install
@info "Building" source_dir scratch_dir build_dir LLVM_DIR Clang_DIR
cmake() do cmake_path
    config_opts = `-DLLVM_DIR=$(LLVM_DIR) -DClang_DIR=$(Clang_DIR) -DCMAKE_INSTALL_PREFIX=$(scratch_dir)`
    if Sys.iswindows()
        # prevent picking up MSVC
        config_opts = `$config_opts -G "MSYS Makefiles"`
    end
    run(`$cmake_path $config_opts -B$(build_dir) -S$(source_dir)`)
    run(`$cmake_path --build $(build_dir) --target install --parallel $(Sys.CPU_THREADS)`)
end

# discover built libraries
built_libs = filter(readdir(joinpath(scratch_dir, "lib"))) do file
    endswith(file, ".$(Libdl.dlext)")
end
lib_path = joinpath(scratch_dir, "lib", only(built_libs))
isfile(lib_path) || error("Could not find library $lib_path in build directory")

# tell ClangCompiler.jl to load our library instead of the default artifact one
set_preferences!(joinpath(dirname(@__DIR__), "LocalPreferences.toml"),
                 "ClangCompiler",
                 "libclangex" => lib_path;
                 force=true,)
