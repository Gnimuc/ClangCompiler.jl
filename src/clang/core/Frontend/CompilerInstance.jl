"""
    struct CompilerInstance <: AbstractCompilerInstance
Hold a pointer to a `clang::CompilerInstance` object.
"""
struct CompilerInstance <: AbstractCompilerInstance
    ptr::CXCompilerInstance
end
