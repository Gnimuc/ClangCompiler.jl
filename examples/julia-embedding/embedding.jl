using ClangCompiler
using ClangCompiler.LLVM

julia_include_dir = joinpath(Sys.BINDIR, "..", "include", "julia") |> normpath

src = joinpath(@__DIR__, "embedding.cpp")

args = get_compiler_args(; version=v"7.1.0")
push!(args, "-std=c++14")
Sys.isapple() && push!(args, "-stdlib=libc++")
push!(args, "-I$julia_include_dir")

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
