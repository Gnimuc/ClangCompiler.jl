"""
    struct CompilerInstance <: Any
Hold a pointer to a `clang::CompilerInstance` object.
"""
struct CompilerInstance
    ptr::CXCompilerInstance
end

Base.unsafe_convert(::Type{CXCompilerInstance}, x::CompilerInstance) = x.ptr
Base.cconvert(::Type{CXCompilerInstance}, x::CompilerInstance) = x
