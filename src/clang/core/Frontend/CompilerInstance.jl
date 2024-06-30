"""
    struct CompilerInstance <: AbstractCompilerInstance
Hold a pointer to a `clang::CompilerInstance` object.
"""
struct CompilerInstance <: AbstractCompilerInstance
    ptr::CXCompilerInstance
end

Base.unsafe_convert(::Type{CXCompilerInstance}, x::CompilerInstance) = x.ptr
Base.cconvert(::Type{CXCompilerInstance}, x::CompilerInstance) = x
