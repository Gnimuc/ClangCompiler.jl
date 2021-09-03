using ClangCompiler
using Test

include("clang/diagnostic.jl")
include("clang/source.jl")
include("clang/instance.jl")
haskey(ENV, "CI") && include("clang/status.jl")

include("lookup.jl")
if !Sys.iswindows()
    include("call.jl")
    include("execution.jl")
end
include("types.jl")

if get(ENV, "CLANGCOMPILER_ENABLE_BOOT", false)
    include("boot.jl")
end
