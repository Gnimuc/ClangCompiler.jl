function PrintStats(x::T) where {T<:AbstractASTConsumer}
    @check_ptrs x
    return clang_ASTConsumer_PrintStats(x)
end

function HandleTranslationUnit(csr::T, ctx::ASTContext) where {T<:AbstractASTConsumer}
    @check_ptrs csr ctx
    return clang_ASTConsumer_HandleTranslationUnit(csr, ctx)
end
