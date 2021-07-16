using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "template.cpp")

# compilation flags
args = get_default_args()

# create compiler
cpr = create_compiler(src, args)

# generate IR
m = compile(cpr)

# create JIT and call function
ee = JIT(m)
ret = run(ee, lookup_function(m, "main"))

# clean up
destroy(cpr)
