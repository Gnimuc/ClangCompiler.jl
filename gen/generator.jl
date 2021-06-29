using Clang.Generators
using LLVM_full_jll

cd(@__DIR__)

llvm_include_dir = joinpath(LLVM_full_jll.artifact_dir, "include") |> normpath
include_dir = joinpath(ENV["LIBCLANGEX_INSTALL_PREFIX"], "include") |> normpath

options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-isystem$llvm_include_dir")
push!(args, "-I$include_dir")

headers = detect_headers(include_dir, args)

@add_def time_t

ctx = create_context(headers, args, options)

build!(ctx)
