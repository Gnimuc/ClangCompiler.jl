"""
    abstract type AbstractFileSystemOptions <: Any
Supertype for `clang::FileSystemOptions`.
"""
abstract type AbstractFileSystemOptions end

"""
    struct FileSystemOptions <: AbstractFileSystemOptions
Hold a pointer to a `clang::FileSystemOptions` object.
"""
struct FileSystemOptions <: AbstractFileSystemOptions
    ptr::CXFileSystemOptions
end

Base.unsafe_convert(::Type{CXFileSystemOptions}, x::FileSystemOptions) = x.ptr
Base.cconvert(::Type{CXFileSystemOptions}, x::FileSystemOptions) = x
