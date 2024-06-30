"""
    struct ASTConsumer <: AbstractASTConsumer
"""
struct ASTConsumer <: AbstractASTConsumer
    ptr::CXASTConsumer
end

Base.unsafe_convert(::Type{CXASTConsumer}, x::ASTConsumer) = x.ptr
Base.cconvert(::Type{CXASTConsumer}, x::ASTConsumer) = x
