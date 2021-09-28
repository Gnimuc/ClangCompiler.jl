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
    status = Ref{CXInit_Error}(CXInit_NoError)
    mgr = clang_FileManager_create(status)
    @assert status[] == CXInit_NoError
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
