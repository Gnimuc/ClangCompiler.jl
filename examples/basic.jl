using ClangCompiler
using ClangCompiler.LLVM
using Libdl

libcxx = joinpath(Sys.BINDIR, "..", "lib", "julia", "libstdc++.$(Libdl.dlext)") |> normpath

LLVM.load_library_permantly(libcxx)

src = joinpath(@__DIR__, "main.cpp")

args = get_default_args()

cpr = create_compiler(src, args)
mod = compile(cpr)

ee = JIT(mod)

LLVM.API.LLVMRunStaticConstructors(ee.ref)

f = get(functions(ee), "mycppfunction", 0)

run(ee, f)

# @eval foo() = $(ClangCompiler.call_function(f, Cvoid))
# foo()

destroy(cpr)
