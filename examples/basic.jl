using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "sample.cpp")

# compilation flags
args = get_compiler_args()

# create compiler
cpr = create_compiler(src, args)

# generate IR
mod = compile(cpr)

# create JIT and call function
ee = JIT(mod)
ret = run(ee, lookup_function(mod, "main"))

# clean up
destroy(cpr)
