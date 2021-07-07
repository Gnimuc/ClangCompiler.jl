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
