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
    @assert mgr.ptr != C_NULL "file manager has a NULL pointer."
    return clang_FileManager_PrintStats(mgr.ptr)
end

"""
    mutable struct FileEntry <: Any
Holds both a pointer to a `clang::FileEntry` object.
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
function get_file(filemgr::FileManager, filename::AbstractString; open_file::Bool=false,
                  cache_failure::Bool=true)
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

"""
    mutable struct SourceManager <: Any
Holds a pointer to a `clang::SourceManager` object.
"""
mutable struct SourceManager
    ptr::CXSourceManager
end
function SourceManager(file_mgr::FileManager, diag::DiagnosticsEngine=DiagnosticsEngine(),
                       volatile::Bool=false)
    status = Ref{CXInit_Error}(CXInit_NoError)
    mgr = clang_SourceManager_create(diag.ptr, file_mgr.ptr, volatile, status)
    @assert status[] == CXInit_NoError
    return SourceManager(mgr)
end

function destroy(x::SourceManager)
    if x.ptr != C_NULL
        clang_SourceManager_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

"""
    mutable struct FileID <: Any
Holds a pointer to a `clang::FileID` object.

Note that, this ID is managed by source manager and should not be manually created.
"""
mutable struct FileID
    ptr::CXFileID
end

"""
    value(id::FileID) -> Int
Return the value of file ID.
"""
value(id::FileID) = Int(clang_FileID_getHashValue(id.ptr))

"""
    FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Create a file ID from a memory buffer.

This function takes ownership of the memory buffer.
"""
function FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
    return FileID(clang_SourceManager_createFileIDFromMemoryBuffer(src_mgr.ptr, buffer.ptr))
end

"""
    FileID(src_mgr::SourceManager, file_entry::FileEntry)
Create a file ID from a file entry.

See also [`get_file`](@ref).
"""
function FileID(src_mgr::SourceManager, file_entry::FileEntry)
    return FileID(clang_SourceManager_createFileIDFromFileEntry(src_mgr.ptr,
                                                                file_entry.ptr))
end

function destroy(x::FileID)
    if x.ptr != C_NULL
        clang_FileID_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

"""
    get_main_file_id(src_mgr::SourceManager) -> FileID
Return the main file ID.

This function allocates and one should call `destroy` to release the resources.
"""
function get_main_file_id(src_mgr::SourceManager)
    return FileID(clang_SourceManager_getMainFileID(src_mgr.ptr))
end

"""
    set_main_file_id(src_mgr::SourceManager, id::FileID)
Set the main file ID of the source manager to `id`.
"""
function set_main_file_id(src_mgr::SourceManager, id::FileID)
    return clang_SourceManager_setMainFileID(src_mgr.ptr, id.ptr)
end
