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

addr = lookup(lljit, "lljit_main")

@eval main() = ccall($(pointer(addr)), Cint, ())

main()

# argc = length(ARGS)
# argv = pointer.(ARGS)
# argv = Base.unsafe_convert(Ptr{Ptr{UInt8}}, ARGS)

# run(ee, f, [
#     GenericValue(LLVM.Int32Type(irgen.ctx), argc),
#     GenericValue(argv)
# ])

# clean up
# destroy(irgen)
# dispose(lljit)
