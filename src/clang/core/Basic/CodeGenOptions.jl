"""
    struct CodeGenOptions <: AbstractCodeGenOptions
Hold a pointer to a `clang::CodeGenOptions` object.
"""
struct CodeGenOptions <: AbstractCodeGenOptions
    ptr::CXCodeGenOptions
end
