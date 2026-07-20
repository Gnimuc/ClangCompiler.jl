"""
    struct CompilerInvocation <: AbstractCompilerInvocation
Hold a pointer to a `clang::CompilerInvocation` object.
"""
struct CompilerInvocation <: AbstractCompilerInvocation
    ptr::CXCompilerInvocation
end

Base.unsafe_convert(::Type{CXCompilerInvocation}, x::CompilerInvocation) = x.ptr
Base.cconvert(::Type{CXCompilerInvocation}, x::CompilerInvocation) = x
