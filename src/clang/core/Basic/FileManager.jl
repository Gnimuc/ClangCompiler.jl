"""
    struct FileManager <: Any
Hold a pointer to a `clang::FileManager` object.
"""
struct FileManager
    ptr::CXFileManager
end

Base.unsafe_convert(::Type{CXCodeGenOptions}, x::CodeGenOptions) = x.ptr
Base.cconvert(::Type{CXCodeGenOptions}, x::CodeGenOptions) = x
