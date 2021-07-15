using ClangCompiler
using ClangCompiler.LLVM

julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath

src = joinpath(@__DIR__, "embedding.cpp")

args = get_default_args(; version=v"7.1.0")
push!(args, "-std=c++14")
Sys.isapple() && push!(args, "-stdlib=libc++")
push!(args, "-I$julia_include_dir")

cpr = create_compiler(src, args)
m = compile(cpr);

f = lookup_function(m, "main")

@eval main() = $(call_function(f, Cint))

main()
