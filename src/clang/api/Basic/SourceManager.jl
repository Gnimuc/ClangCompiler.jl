# SourceManager
function SourceManager(file_mgr::FileManager, diag::DiagnosticsEngine=DiagnosticsEngine(),
                       volatile::Bool=false)
    mgr = clang_SourceManager_create(diag, file_mgr, volatile)
    @assert mgr != C_NULL "Failed to create SourceManager"
    return SourceManager(mgr)
end

dispose(x::SourceManager) = clang_SourceManager_dispose(x)

function PrintStats(mgr::SourceManager)
    @check_ptrs mgr
    return clang_SourceManager_PrintStats(mgr)
end

"""
    FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Create a file ID from a memory buffer.

This function takes ownership of the memory buffer.
"""
function FileID(src_mgr::SourceManager, buffer::LLVM.MemoryBuffer)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_createFileIDFromMemoryBuffer(src_mgr, buffer.ref))
end

"""
    FileID(src_mgr::SourceManager, file_entry::FileEntry)
Create a file ID from a file entry.

See also [`get_file`](@ref).
"""
function FileID(src_mgr::SourceManager, file_entry::FileEntry,
                loc::SourceLocation=SourceLocation())
    @check_ptrs src_mgr file_entry
    return FileID(clang_SourceManager_createFileIDFromFileEntry(src_mgr, file_entry, loc))
end

"""
    getMainFileID(src_mgr::SourceManager) -> FileID
Return the main file ID.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getMainFileID(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_getMainFileID(src_mgr))
end

"""
    setMainFileID(src_mgr::SourceManager, id::FileID)
Set the main file ID of the source manager to `id`.
"""
function setMainFileID(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return clang_SourceManager_setMainFileID(src_mgr, id)
end

"""
    setMainFileID(src_mgr::SourceManager, file_entry::FileEntry)
Set the main file ID of the source manager to `file_entry`.
"""
function setMainFileID(src_mgr::SourceManager, file_entry::FileEntry)
    id = FileID(src_mgr, file_entry)
    setMainFileID(src_mgr, id)
    dispose(id)
    return nothing
end

"""
    setMainFileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Set the main file ID of the source manager to `buffer`.
"""
function setMainFileID(src_mgr::SourceManager, buffer::LLVM.MemoryBuffer)
    id = FileID(src_mgr, buffer)
    setMainFileID(src_mgr, id)
    dispose(id)
    return nothing
end

function getLocForStartOfFile(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_getLocForStartOfFile(src_mgr, id))
end

function getLocForEndOfFile(src_mgr::SourceManager, id::FileID)
    @check_ptrs x id
    return SourceLocation(clang_SourceManager_getLocForEndOfFile(src_mgr, id))
end

function dump(x::SourceLocation, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceLocation_dump(x, src_mgr)
end
