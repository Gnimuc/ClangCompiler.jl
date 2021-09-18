"""
    abstract type AbstractASTConsumer <: Any
Supertype for ASTConsumers.
"""
abstract type AbstractASTConsumer end

Base.unsafe_convert(::Type{CXASTConsumer}, x::T) where {T<:AbstractASTConsumer} = x.ptr
Base.cconvert(::Type{CXASTConsumer}, x::T) where {T<:AbstractASTConsumer} = x

"""
    struct ASTConsumer <: AbstractASTConsumer
"""
struct ASTConsumer <: AbstractASTConsumer
    ptr::CXASTConsumer
end
