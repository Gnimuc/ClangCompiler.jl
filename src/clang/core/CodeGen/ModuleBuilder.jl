"""
    struct CodeGenerator <: AbstractASTConsumer
Hold a pointer to a `clang::CodeGenerator` object.
"""
struct CodeGenerator <: AbstractASTConsumer
    ptr::CXCodeGenerator
end

Base.unsafe_convert(::Type{CXCodeGenerator}, x::CodeGenerator) = x.ptr
Base.cconvert(::Type{CXCodeGenerator}, x::CodeGenerator) = x
