# FileManager
FileManager() = FileManager(create_file_manager())

"""
    create_file_manager() -> CXFileManager
Return a pointer to a `clang::FileManager` object.

For now, `FileSystemOptions` is set to nothing and `llvm::vfs::FileSystem` defaults to the
"real" file system, as seen by the operating system.

TODO: support custom `FileSystemOptions` and `llvm::vfs::FileSystem`
"""
function create_file_manager()
    mgr = clang_FileManager_create()
    @assert mgr != C_NULL "Failed to create FileManager"
    return mgr
end

dispose(x::FileManager) = clang_FileManager_dispose(x)

function PrintStats(mgr::FileManager)
    @check_ptrs mgr
    return clang_FileManager_PrintStats(mgr)
end

"""
    getFileEntry(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true) -> FileEntry
Get a file entry from the file manager.

If `open_file` is true, the file will be opened.
If `cache_failure` is true, the failure that this file does not exist will be cached.
"""
function getFileEntry(filemgr::FileManager, filename::AbstractString; open_file::Bool=false,
                      cache_failure::Bool=true)
    @check_ptrs filemgr
    GC.@preserve filename begin
        ref = clang_FileManager_getFileRef(filemgr, filename, open_file, cache_failure)
        @assert ref != C_NULL "failed to create a FileRef to $filename."
        entry = clang_FileEntryRef_getFileEntry(ref)
        clang_FileEntryRef_dispose(ref)
    end
    return FileEntry(entry)
end

"""
    getFileRef(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true) -> FileEntryRef
Return a heap-boxed `clang::FileEntryRef` for `filename`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getFileRef(filemgr::FileManager, filename::AbstractString; open_file::Bool=false,
                    cache_failure::Bool=true)
    @check_ptrs filemgr
    ref = clang_FileManager_getFileRef(filemgr, filename, open_file, cache_failure)
    @assert ref != C_NULL "failed to create a FileEntryRef to $filename."
    return FileEntryRef(ref)
end

dispose(x::FileEntryRef) = clang_FileEntryRef_dispose(x)

function getFileEntry(x::FileEntryRef)
    @check_ptrs x
    return FileEntry(clang_FileEntryRef_getFileEntry(x))
end

"""
    getBufferForFile(filemgr::FileManager, entry::FileEntryRef; is_volatile::Bool=false, requires_null_terminator::Bool=true) -> LLVM.MemoryBuffer
Open the file as a caller-owned memory buffer.

This function allocates and one should call `LLVM.dispose` to release the resources after using this object.
"""
function getBufferForFile(filemgr::FileManager, entry::FileEntryRef; is_volatile::Bool=false,
                          requires_null_terminator::Bool=true)
    @check_ptrs filemgr entry
    buf = clang_FileManager_getBufferForFile(filemgr, entry, is_volatile,
                                             requires_null_terminator)
    @assert buf != C_NULL "failed to read the file into a memory buffer."
    return LLVM.MemoryBuffer(buf)
end

"""
    getDirectory(filemgr::FileManager, dirname::AbstractString; cache_failure::Bool=true) -> DirectoryEntry
Look up a directory entry. The directory must exist: the C shim dereferences the lookup
result unchecked, so passing a non-existent directory is undefined behaviour.
"""
function getDirectory(filemgr::FileManager, dirname::AbstractString; cache_failure::Bool=true)
    @check_ptrs filemgr
    return DirectoryEntry(clang_FileManager_getDirectory(filemgr, dirname, cache_failure))
end

"""
    getOptionalDirectoryRef(filemgr::FileManager, dirname::AbstractString;
                            cache_failure::Bool=true) -> Union{DirectoryEntryRef,Nothing}
Return a heap-boxed `clang::DirectoryEntryRef` for `dirname`, or `nothing` when no such
directory exists. With `cache_failure=true` a failed lookup is remembered.

This is the reference form [`DirectoryLookup`](@ref) needs; [`getDirectory`](@ref) hands back
a bare `DirectoryEntry`, which cannot be turned back into one. A non-`nothing` result allocates
and one should call `dispose` to release the resources after using this object.
"""
function getOptionalDirectoryRef(filemgr::FileManager, dirname::AbstractString;
                                 cache_failure::Bool=true)
    @check_ptrs filemgr
    ref = clang_FileManager_getOptionalDirectoryRef(filemgr, dirname, cache_failure)
    return ref == C_NULL ? nothing : DirectoryEntryRef(ref)
end

dispose(x::DirectoryEntryRef) = clang_DirectoryEntryRef_dispose(x)
