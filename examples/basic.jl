using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "sample.cpp")

# compilation flags
args = get_compiler_args()

# create JIT, generate LLVM IR, and call function
jit = LLJIT(;tm=JITTargetMachine())
irgen = generate_llvmir(src, args)
cc = CxxCompiler(irgen, jit)
link_process_symbols(cc)
compile(cc)

addr = lookup(jit, "main")
@eval main() = ccall($(pointer(addr)), Cint, ())

main()

# clean up
dispose(cc)
