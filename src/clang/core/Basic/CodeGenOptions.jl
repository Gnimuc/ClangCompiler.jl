"""
    struct CodeGenOptions <: AbstractCodeGenOptions
Hold a pointer to a `clang::CodeGenOptions` object.
"""
struct CodeGenOptions <: AbstractCodeGenOptions
    ptr::CXCodeGenOptions
end

Base.unsafe_convert(::Type{CXCodeGenOptions}, x::CodeGenOptions) = x.ptr
Base.cconvert(::Type{CXCodeGenOptions}, x::CodeGenOptions) = x
