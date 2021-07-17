"""
    mutable struct ASTContext <: Any
Holds a pointer to a `clang::ASTContext` object.
"""
mutable struct ASTContext
    ptr::CXASTContext
end

function status(x::ASTContext)
    @assert x.ptr != C_NULL "ASTContext has a NULL pointer."
    return clang_ASTContext_PrintStats(x.ptr)
end

"""
    abstract type AbstractASTConsumer <: Any
Supertype for ASTConsumers.
"""
abstract type AbstractASTConsumer end

"""
    mutable struct ASTConsumer <: Any
"""
mutable struct ASTConsumer
    ptr::CXASTConsumer
end

function handle_translation_unit(csr::T, ctx::ASTContext) where {T<:AbstractASTConsumer}
    @assert csr.ptr != C_NULL "$T has a NULL pointer."
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    clang_ASTConsumer_HandleTranslationUnit(csr.ptr, ctx.ptr)
end

function status(csr::T) where {T<:AbstractASTConsumer}
    @assert csr.ptr != C_NULL "$T has a NULL pointer."
    return clang_ASTConsumer_PrintStats(csr.ptr)
end
