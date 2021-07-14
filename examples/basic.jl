using ClangCompiler
using ClangCompiler.LLVM

src = joinpath(@__DIR__, "sample.cpp")

args = get_default_args()

cpr = create_compiler(src, args)
mod = compile(cpr)
ee = JIT(mod)

f = lookup_function(mod, "main")

ret = run(ee, f)

destroy(cpr)
