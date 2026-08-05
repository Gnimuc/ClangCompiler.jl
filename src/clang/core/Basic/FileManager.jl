"""
    struct FileManager <: AbstractFileManager
Hold a pointer to a `clang::FileManager` object.
"""
struct FileManager <: AbstractFileManager
    ptr::CXFileManager
end

"""
    struct DirectoryEntry <: AbstractDirectoryEntry
Hold a pointer to a `clang::DirectoryEntry` object.
"""
struct DirectoryEntry <: AbstractDirectoryEntry
    ptr::CXDirectoryEntry
end

"""
    struct FileEntryRef <: AbstractFileEntryRef
Hold a pointer to a `clang::FileEntryRef` object.
"""
struct FileEntryRef <: AbstractFileEntryRef
    ptr::CXFileEntryRef
end

"""
    struct DirectoryEntryRef <: AbstractDirectoryEntryRef
Hold a pointer to an owned `clang::DirectoryEntryRef` value.

The value is a heap-boxed copy of a by-value C++ object, so it is caller-owned: release it
with `dispose`.
"""
struct DirectoryEntryRef <: AbstractDirectoryEntryRef
    ptr::CXDirectoryEntryRef
end
