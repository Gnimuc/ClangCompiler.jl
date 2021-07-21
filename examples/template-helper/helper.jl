using ClangCompiler
using ClangCompiler.LLVM

# source file
src = joinpath(@__DIR__, "template.cpp")

# compilation flags
args = get_compiler_args()

# generate LLVM IR
irgen = generate_llvmir(src, args)

# create JIT and call function
lljit = LLJIT(;tm=JITTargetMachine())
ts_mod = ThreadSafeModule(get_module(irgen); ctx=ThreadSafeContext())
jd = JITDylib(lljit)
add!(lljit, jd, ts_mod)

prefix = LLVM.get_prefix(lljit)
dg = LLVM.CreateDynamicLibrarySearchGeneratorForProcess(prefix)
add!(jd, dg)

addr = lookup(lljit, "main")

@eval main() = ccall($(pointer(addr)), Cint, ())

main()

# clean up
dispose(lljit)
destroy(irgen)
