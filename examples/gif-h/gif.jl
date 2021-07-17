using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "gif-h-demo.cpp")

# compilation flags
args = get_compiler_args()
push!(args, "-I$(@__DIR__)")

# generate LLVM IR
irgen = generate_llvmir(src, args)

# create JIT and call function
ee = JIT(get_module(irgen))
ret = run(ee, lookup_function(ee, "main"))

# clean up
destroy(irgen)
