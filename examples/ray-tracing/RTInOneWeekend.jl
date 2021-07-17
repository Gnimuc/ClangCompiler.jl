using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "InOneWeekend", "main.cc")

# includes
common_incdir = joinpath(@__DIR__, "common")
incdir = joinpath(@__DIR__, "InOneWeekend")

# compilation flags
args = get_compiler_args()
push!(args, "-I$common_incdir")
push!(args, "-I$incdir")

# generate LLVM IR
irgen = generate_llvmir(src, args)

# create JIT and call function
ee = JIT(get_module(irgen))

ret = run(ee, lookup_function(ee, "main"))

# clean up
destroy(irgen)
