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
destroy(cc)
