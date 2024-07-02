using ClangCompiler
using ClangCompiler.LLVM
using ClangCompiler.LLVM_full_jll

# source file
src = joinpath(@__DIR__, "HowToUseLLJIT.cpp")

# compilation flags
llvm_include_dir = joinpath(LLVM_full_jll.artifact_dir, "include") |> normpath
@assert isdir(llvm_include_dir)

julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath
@assert isdir(julia_include_dir)

args = get_compiler_args()
push!(args, "-I$llvm_include_dir")
push!(args, "-I$julia_include_dir")

# create JIT, generate LLVM IR, and call function
jit = LLJIT(; tm=JITTargetMachine())
irgen = IRGenerator(src, args)
cc = ClangCompiler(irgen, jit)
link_process_symbols(cc)
compile(cc)

addr = lookup(jit, "lljit_main")
@eval main() = ccall($(pointer(addr)), Cint, ())

main()

# clean up
dispose(cc)
