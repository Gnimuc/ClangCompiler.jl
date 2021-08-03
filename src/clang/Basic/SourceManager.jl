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

function status(mgr::SourceManager)
    @assert mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    return clang_SourceManager_PrintStats(mgr.ptr)
end

"""
    FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Create a file ID from a memory buffer.

This function takes ownership of the memory buffer.
"""
function FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    return FileID(clang_SourceManager_createFileIDFromMemoryBuffer(src_mgr.ptr, buffer.ref))
end

"""
    FileID(src_mgr::SourceManager, file_entry::FileEntry)
Create a file ID from a file entry.

See also [`get_file`](@ref).
"""
function FileID(src_mgr::SourceManager, file_entry::FileEntry, loc::SourceLocation=SourceLocation())
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    @assert file_entry.ptr != C_NULL "FileEntry has a NULL pointer."
    return FileID(clang_SourceManager_createFileIDFromFileEntry(src_mgr.ptr,
                                                                file_entry.ptr,
                                                                loc.ptr))
end

"""
    get_main_file_id(src_mgr::SourceManager) -> FileID
Return the main file ID.

This function allocates and one should call `destroy` to release the resources after using this object.
"""
function get_main_file_id(src_mgr::SourceManager)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    return FileID(clang_SourceManager_getMainFileID(src_mgr.ptr))
end

"""
    set_main_file_id(src_mgr::SourceManager, id::FileID)
Set the main file ID of the source manager to `id`.
"""
function set_main_file_id(src_mgr::SourceManager, id::FileID)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    @assert id.ptr != C_NULL "FileID has a NULL pointer."
    return clang_SourceManager_setMainFileID(src_mgr.ptr, id.ptr)
end

function set_main_file(src_mgr::SourceManager, file_entry::FileEntry)
    id = FileID(src_mgr, file_entry)
    set_main_file_id(src_mgr, id)
    destroy(id)
    return nothing
end

function set_main_file(src_mgr::SourceManager, buffer::MemoryBuffer)
    id = FileID(src_mgr, buffer)
    set_main_file_id(src_mgr, id)
    destroy(id)
    return nothing
end

function get_loc_for_start_of_file(src_mgr::SourceManager, id::FileID)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    @assert id.ptr != C_NULL "FileID has a NULL pointer."
    return SourceLocation(clang_SourceManager_getLocForStartOfFile(src_mgr.ptr, id.ptr))
end

function get_loc_for_start_of_main_file(src_mgr::SourceManager)
    id = get_main_file_id(src_mgr)
    loc = get_loc_for_start_of_file(src_mgr, id)
    destroy(id)
    return loc
end

function get_loc_for_end_of_file(src_mgr::SourceManager, id::FileID)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    @assert id.ptr != C_NULL "FileID has a NULL pointer."
    return SourceLocation(clang_SourceManager_getLocForEndOfFile(src_mgr.ptr, id.ptr))
end

function get_loc_for_end_of_main_file(src_mgr::SourceManager)
    id = get_main_file_id(src_mgr)
    loc = get_loc_for_end_of_file(src_mgr, id)
    destroy(id)
    return loc
end

function dump(x::SourceLocation, src_mgr::SourceManager)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    return clang_SourceLocation_dump(x.ptr, src_mgr.ptr)
end

function get_string(x::SourceLocation, src_mgr::SourceManager)
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    str = clang_SourceLocation_printToString(x.ptr, src_mgr.ptr)
    s = unsafe_string(str)
    clang_SourceLocation_disposeString(str)
    return s
end
