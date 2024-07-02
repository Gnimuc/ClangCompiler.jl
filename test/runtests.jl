using ClangCompiler
using Test

# if haskey(ENV, "CI")
#     include("clang/status.jl")
# end

# include("llvm/pointer_from_objref.jl")

# include("clang/diagnostic.jl")
# include("clang/source.jl")
# include("clang/instance.jl")

# include("lookup.jl")
# include("traversal.jl")
# if Sys.isapple()
#     include("call.jl")
#     include("execution.jl")
# end
include("types.jl")
