"""
    ASTConsumer() -> ASTConsumer
Build a consumer whose every callback is a no-op — what a parse-only driver installs,
because [`createSema`](@ref) requires a consumer and a driver that generates no code has
nothing for one to do.

**Adopted** by `setASTConsumer`: once installed, the `CompilerInstance` frees it and calling
`dispose` on it is a double free. Dispose it only if it never reached an instance.
"""
function ASTConsumer()
    return ASTConsumer(clang_ASTConsumer_create())
end

dispose(x::ASTConsumer) = clang_ASTConsumer_dispose(x)

function PrintStats(x::T) where {T<:AbstractASTConsumer}
    @check_ptrs x
    return clang_ASTConsumer_PrintStats(x)
end

function Initialize(csr::T, ctx::ASTContext) where {T<:AbstractASTConsumer}
    @check_ptrs csr ctx
    return clang_ASTConsumer_Initialize(csr, ctx)
end

function HandleTranslationUnit(csr::T, ctx::ASTContext) where {T<:AbstractASTConsumer}
    @check_ptrs csr ctx
    return clang_ASTConsumer_HandleTranslationUnit(csr, ctx)
end
