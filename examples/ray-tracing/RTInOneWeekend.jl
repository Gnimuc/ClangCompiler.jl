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

# create compiler
cpr = create_compiler(src, args)

# generate IR
mod = compile(cpr)

# create JIT and call function
ee = JIT(mod)
ret = run(ee, lookup_function(mod, "main"))

# clean up
destroy(cpr)
