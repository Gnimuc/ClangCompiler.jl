"""
    struct CodeGenModule <: AbstractCodeGenModule
Hold a pointer to a `clang::CodeGenModule` object.
"""
struct CodeGenModule <: AbstractCodeGenModule
    ptr::CXCodeGenModule
end

Base.unsafe_convert(::Type{CXCodeGenModule}, x::CodeGenModule) = x.ptr
Base.cconvert(::Type{CXCodeGenModule}, x::CodeGenModule) = x
