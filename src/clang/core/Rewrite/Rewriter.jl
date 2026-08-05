"""
    abstract type AbstractRewriter <: Any
Supertype for `Rewriter`s.
"""
abstract type AbstractRewriter end

"""
    struct Rewriter <: AbstractRewriter
Hold a pointer to a `clang::Rewriter` object.
"""
struct Rewriter <: AbstractRewriter
    ptr::CXRewriter
end

