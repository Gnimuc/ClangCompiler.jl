using ClangCompiler
using ClangCompiler.LLVM

julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath

src = joinpath(@__DIR__, "embedding.cpp")

args = get_compiler_args(; version=v"7.1.0")
push!(args, "-std=c++14")
Sys.isapple() && push!(args, "-stdlib=libc++")
push!(args, "-I$julia_include_dir")

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
