"""
    struct CodeGenerator <: AbstractCodeGenerator
Hold a pointer to a `clang::CodeGenerator` object.
"""
struct CodeGenerator <: AbstractCodeGenerator
    ptr::CXCodeGenerator
end
