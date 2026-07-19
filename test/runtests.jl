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
include("stmt.jl")
include("execution.jl")

# include("llvm/pointer_from_objref.jl")
