"""
    struct ASTContext <: AbstractASTContext
Hold a pointer to a `clang::ASTContext` object.
"""
struct ASTContext <: AbstractASTContext
    ptr::CXASTContext
end

Base.unsafe_convert(::Type{CXASTContext}, x::ASTContext) = x.ptr
Base.cconvert(::Type{CXASTContext}, x::ASTContext) = x
