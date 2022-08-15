# Invoke with
# `julia --project=deps deps/build_local.jl [path-to-libclangex]`

# the pre-built libclangex_jll might not be loadable on this platform
libclangex_jll = Base.UUID("82994860-12e5-56b1-9971-c34819be692e")

using Pkg, Scratch, Preferences, Libdl

# 1. Get a scratch directory
scratch_dir = get_scratch!(libclangex_jll, "build")
isdir(scratch_dir) && rm(scratch_dir; recursive=true)

source_dir = nothing
branch = nothing
if length(ARGS) == 2 
    @assert ARGS[1] == "--branch"
    branch = ARGS[2]
    source_dir = nothing
elseif length(ARGS) == 1
    source_dir = ARGS[1]
end

if branch === nothing
    branch = "master"
end

if source_dir === nothing
    scratch_src_dir = get_scratch!(libclangex_jll, "src")
    cd(scratch_src_dir) do
        if !isdir("libclangex")
            run(`git clone https://github.com/Gnimuc/libclangex`)
        end
        run(`git -C libclangex fetch`)
        run(`git -C libclangex checkout origin/$(branch)`)
    end
    source_dir = joinpath(scratch_src_dir, "libclangex")
end

# 2. Ensure that an appropriate LLVM_full_jll is installed
Pkg.activate(; temp=true)
llvm_assertions = try
    cglobal((:_ZN4llvm24DisableABIBreakingChecksE, Base.libllvm_path()), Cvoid)
    false
catch
    true
end
LLVM = if llvm_assertions
    Pkg.add(name="LLVM_full_assert_jll", version=Base.libllvm_version)
    using LLVM_full_assert_jll
    LLVM_full_assert_jll
else
    Pkg.add(name="LLVM_full_jll", version=Base.libllvm_version)
    using LLVM_full_jll
    LLVM_full_jll
end

LLVM_DIR = joinpath(LLVM.artifact_dir, "lib", "cmake", "llvm")
Clang_DIR = joinpath(LLVM.artifact_dir, "lib", "cmake", "clang")

# Build!
@info "Building" scratch_dir source_dir LLVM_DIR Clang_DIR
run(`cmake -DLLVM_DIR=$(LLVM_DIR) -DClang_DIR=$(Clang_DIR) -B$(scratch_dir) -S$(source_dir)`)
run(`cmake --build $(scratch_dir) --parallel $(Sys.CPU_THREADS)`)

# Discover built libraries
built_libs = filter(readdir(scratch_dir)) do file
    endswith(file, ".$(Libdl.dlext)") && startswith(file, "lib")
end

lib_path = joinpath(scratch_dir, only(built_libs))
isfile(lib_path) || error("Could not find library $lib_path in build directory")

# Tell libclangex_jll to load our libraries
set_preferences!(
    joinpath(dirname(@__DIR__), "LocalPreferences.toml"),
    "libclangex_jll",
    "libclangex_path" => lib_path,
    force=true,
)
