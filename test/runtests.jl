using ClangCompiler
using Test

if haskey(ENV, "CI")
    include("clang/status.jl")
    include("platform/env.jl")
end

include("llvm/pointer_from_objref.jl")

include("clang/diagnostic.jl")
include("clang/source.jl")
include("clang/instance.jl")

include("lookup.jl")
if Sys.isapple()
    include("call.jl")
    include("execution.jl")
end
include("types.jl")

if haskey(ENV, "CLANGCOMPILER_ENABLE_BOOT")
    include("boot.jl")
end
