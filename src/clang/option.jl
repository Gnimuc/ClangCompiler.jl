# Other options like `DiagnosticOptions` are living in the corresponding source files

"""
    mutable struct CodeGenOptions <: Any
Holds a pointer to a `clang::CodeGenOptions` object.
"""
mutable struct CodeGenOptions
    ptr::CXCodeGenOptions
end

"""
    mutable struct FrontendOptions <: Any
Holds a pointer to a `clang::FrontendOptions` object.
"""
mutable struct FrontendOptions
    ptr::CXFrontendOptions
end

"""
    mutable struct HeaderSearchOptions <: Any
Holds a pointer to a `clang::HeaderSearchOptions` object.
"""
mutable struct HeaderSearchOptions
    ptr::CXHeaderSearchOptions
end

"""
    mutable struct PreprocessorOptions <: Any
Holds a pointer to a `clang::PreprocessorOptions` object.
"""
mutable struct PreprocessorOptions
    ptr::CXPreprocessorOptions
end
