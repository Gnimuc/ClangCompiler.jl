"""
    mutable struct FileManager <: Any
Holds a pointer to a `clang::FileManager` object.
"""
mutable struct FileManager
    ptr::CXFileManager
end
FileManager() = FileManager(create_file_manager())

"""
    create_file_manager() -> CXFileManager
Return a pointer to a `clang::FileManager` object.

For now, `FileSystemOptions` is set to nothing and `llvm::vfs::FileSystem` defaults to the
"real" file system, as seen by the operating system.

TODO: support custom `FileSystemOptions` and `llvm::vfs::FileSystem`
"""
function create_file_manager()
    status = Ref{CXInit_Error}(CXInit_NoError)
    mgr = clang_FileManager_create(status)
    @assert status[] == CXInit_NoError
    return mgr
end

function destroy(x::FileManager)
    if x.ptr != C_NULL
        clang_FileManager_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

function status(mgr::FileManager)
    @assert mgr.ptr != C_NULL "FileManager has a NULL pointer."
    return clang_FileManager_PrintStats(mgr.ptr)
end

"""
    get_file(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true) -> FileEntry
Get a file entry from the file manager.

If `open_file` is true, the file will be opened.
If `cache_failure` is true, the failure that this file does not exist will be cached.
"""
function get_file(filemgr::FileManager, filename::AbstractString; open_file::Bool=false,
                  cache_failure::Bool=true)
    @assert filemgr.ptr != C_NULL "FileManager has a NULL pointer."
    GC.@preserve filename begin
        ref = clang_FileManager_getFileRef(filemgr.ptr, filename, open_file, cache_failure)
        @assert ref != C_NULL "failed to create a FileRef to $filename."
        entry = clang_FileEntryRef_getFileEntry(ref)
        clang_FileEntryRef_dispose(ref)
    end
    return FileEntry(entry)
end
