using ClangCompiler
using Test

include("clang/diagnostic.jl")
include("clang/source.jl")
include("clang/instance.jl")
haskey(ENV, "CI") && include("clang/status.jl")

include("lookup.jl")
include("call.jl")
include("execution.jl")
include("boot.jl")
