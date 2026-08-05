"""
    struct ASTContext <: AbstractASTContext
Hold a pointer to a `clang::ASTContext` object.
"""
struct ASTContext <: AbstractASTContext
    ptr::CXASTContext
end

