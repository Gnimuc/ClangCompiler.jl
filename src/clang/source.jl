"""
    mutable struct FileManager <: Any
Holds a pointer to a `Clang::FileManager` object.
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
    @assert mgr.ptr != C_NULL "file manager has a NULL pointer."
    clang_FileManager_PrintStats(mgr.ptr)
end

"""
    mutable struct FileEntry <: Any
Holds both a pointer to a `Clang::FileEntry` object.
"""
mutable struct FileEntry
    ptr::CXFileEntry
end

"""
    get_file(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true) -> FileEntry
Get a file entry from the file manager.

If `open_file` is true, the file will be opened.
If `cache_failure` is true, the failure that this file does not exist will be cached.
"""
function get_file(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true)
    @assert filemgr.ptr != C_NULL "file manager has a NULL pointer."
    ref = clang_FileManager_getFileRef(filemgr.ptr, filename, open_file, cache_failure)
    entry = clang_FileEntryRef_getFileEntry(ref)
    clang_FileEntryRef_dispose(ref)
    return FileEntry(entry)
end

function name(x::FileEntry)
    @assert x.ptr != C_NULL "file entry has a NULL pointer."
    s = clang_FileEntry_getName(x.ptr)
    return unsafe_string(s)
end

function real_path_name(x::FileEntry)
    @assert x.ptr != C_NULL "file entry has a NULL pointer."
    s = clang_FileEntry_tryGetRealPathName(x.ptr)
    return unsafe_string(s)
end

function is_valid(x::FileEntry)
    @assert x.ptr != C_NULL "file entry has a NULL pointer."
    return clang_FileEntry_isValid(x.ptr)
end

"""
    get_UID(x::FileEntry)
`UID` is a unique (small) ID for the file.
"""
function get_UID(x::FileEntry)
    @assert x.ptr != C_NULL "file entry has a NULL pointer."
    return clang_FileEntry_getUID(x.ptr)
end

function is_named_pipe(x::FileEntry)
    @assert x.ptr != C_NULL "file entry has a NULL pointer."
    return clang_FileEntry_isNamedPipe(x.ptr)
end
