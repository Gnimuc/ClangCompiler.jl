"""
    struct FileManager <: Any
Hold a pointer to a `clang::FileManager` object.
"""
struct FileManager
    ptr::CXFileManager
end

Base.unsafe_convert(::Type{CXCodeGenOptions}, x::FileManager) = x.ptr
Base.cconvert(::Type{CXCodeGenOptions}, x::FileManager) = x

"""
    struct DirectoryEntry <: Any
Hold a pointer to a `clang::DirectoryEntry` object.
"""
struct DirectoryEntry
    ptr::CXDirectoryEntry
end

Base.unsafe_convert(::Type{CXDirectoryEntry}, x::DirectoryEntry) = x.ptr
Base.cconvert(::Type{CXDirectoryEntry}, x::DirectoryEntry) = x

"""
    struct FileEntryRef <: Any
Hold a pointer to a `clang::FileEntryRef` object.
"""
struct FileEntryRef
    ptr::CXFileEntryRef
end

Base.unsafe_convert(::Type{CXFileEntryRef}, x::FileEntryRef) = x.ptr
Base.cconvert(::Type{CXFileEntryRef}, x::FileEntryRef) = x
