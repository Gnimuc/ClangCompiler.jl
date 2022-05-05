"""
    abstract type AbstractClangInterpreter <: AbstractClangCompiler
Supertype for Clang interpreters.
"""
abstract type AbstractClangInterpreter <: AbstractClangCompiler end

# interface
get_instance(x::AbstractClangInterpreter) = x.instance
get_context(x::AbstractClangInterpreter) = x.ts_ctx

"""
    struct CXInterpreter <: AbstractClangInterpreter
"""
# struct CXInterpreter <: AbstractClangInterpreter
#     ts_ctx::ThreadSafeContext
#     incr_parser::IncrementalParser
#     incr_executor::IncrementalExecutor
# end
