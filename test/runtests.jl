using ClangCompiler
using Test

include("lint.jl")
include("abi.jl")
include("coverage.jl")
include("types.jl")
include("parse.jl")
include("lookup.jl")
include("traversal.jl")
include("wrappers_tail.jl")
include("acceptance.jl")
include("coverage_exercise.jl")
include("setter_factory.jl")
include("stmt.jl")
include("platform.jl")
include("execution.jl")

# include("llvm/pointer_from_objref.jl")
