"""
    mutable struct ASTContext <: Any
Holds a pointer to a `clang::ASTContext` object.
"""
mutable struct ASTContext
    ptr::CXASTContext
end
