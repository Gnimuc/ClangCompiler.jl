using ClangCompiler
using Test

include("types.jl")
include("parse.jl")
include("lookup.jl")

# if haskey(ENV, "CI")
#     include("clang/status.jl")
# end

# include("llvm/pointer_from_objref.jl")

# include("clang/diagnostic.jl")
# include("clang/source.jl")
# include("clang/instance.jl")

# include("traversal.jl")
# if Sys.isapple()
#     include("call.jl")
#     include("execution.jl")
# end
