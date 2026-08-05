"""
    struct CodeGenModule <: AbstractCodeGenModule
Hold a pointer to a `clang::CodeGenModule` object.
"""
struct CodeGenModule <: AbstractCodeGenModule
    ptr::CXCodeGenModule
end
