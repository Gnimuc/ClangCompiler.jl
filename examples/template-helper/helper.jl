using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "template.cpp")

# compilation flags
args = get_compiler_args()

# generate LLVM IR
irgen = generate_llvmir(src, args)

# create JIT and call function
ee = JIT(get_module(irgen))

ret = run(ee, lookup_function(ee, "main"))

# clean up
destroy(irgen)
