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

