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
    return clang_ASTConsumer_HandleTranslationUnit(csr.ptr, ctx.ptr)
end

function status(csr::T) where {T<:AbstractASTConsumer}
    @assert csr.ptr != C_NULL "$T has a NULL pointer."
    return clang_ASTConsumer_PrintStats(csr.ptr)
end
