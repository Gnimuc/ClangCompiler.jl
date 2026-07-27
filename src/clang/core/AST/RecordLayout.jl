abstract type AbstractASTRecordLayout end

"""
    struct ASTRecordLayout <: AbstractASTRecordLayout
Hold a pointer to a `clang::ASTRecordLayout` object.

The pointee is owned by the `ASTContext` arena — there is no `dispose`.
"""
struct ASTRecordLayout <: AbstractASTRecordLayout
    ptr::CXASTRecordLayout
end

Base.unsafe_convert(::Type{CXASTRecordLayout}, x::ASTRecordLayout) = x.ptr
Base.cconvert(::Type{CXASTRecordLayout}, x::ASTRecordLayout) = x
