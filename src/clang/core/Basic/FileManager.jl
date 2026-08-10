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

# llvm::vfs — the three handles the FileManager cluster installs and reads through. Each
# carrier holds a heap-allocated reference-counted pointer, so disposing one drops a
# reference rather than destroying a file system a `FileManager` is still reading through.
#
# The three abstract types are deliberately unrelated even though `InMemoryFileSystem` and
# `OverlayFileSystem` derive from `FileSystem` in C++: the C handles are distinct types, and
# the upcast is spelled out as `castToFileSystem`, the same way a `Decl` reaches its
# `DeclContext`.

abstract type AbstractVirtualFileSystem end

"""
    struct VirtualFileSystem <: AbstractVirtualFileSystem
Hold a pointer to an owned reference to an `llvm::vfs::FileSystem` object.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
struct VirtualFileSystem <: AbstractVirtualFileSystem
    ptr::CXVirtualFileSystem
end

abstract type AbstractInMemoryFileSystem end

"""
    struct InMemoryFileSystem <: AbstractInMemoryFileSystem
Hold a pointer to an owned reference to an `llvm::vfs::InMemoryFileSystem` object.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
struct InMemoryFileSystem <: AbstractInMemoryFileSystem
    ptr::CXInMemoryFileSystem
end

abstract type AbstractOverlayFileSystem end

"""
    struct OverlayFileSystem <: AbstractOverlayFileSystem
Hold a pointer to an owned reference to an `llvm::vfs::OverlayFileSystem` object.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
struct OverlayFileSystem <: AbstractOverlayFileSystem
    ptr::CXOverlayFileSystem
end
