using ClangCompiler
using ClangCompiler.LLVM

julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath

src = joinpath(@__DIR__, "embedding.cpp")

args = get_compiler_args(; version=v"7.1.0")
push!(args, "-std=c++14")
Sys.isapple() && push!(args, "-stdlib=libc++")
push!(args, "-I$julia_include_dir")

irgen = generate_llvmir(src, args)

m = get_module(irgen)

f = lookup_function(m, "main")

@eval main() = $(call_function(f, Cint))

main()
