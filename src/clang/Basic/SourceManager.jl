"""
    struct SourceManager <: Any
Hold a pointer to a `clang::SourceManager` object.
"""
struct SourceManager
    ptr::CXSourceManager
end
function SourceManager(file_mgr::FileManager, diag::DiagnosticsEngine=DiagnosticsEngine(),
                       volatile::Bool=false)
    status = Ref{CXInit_Error}(CXInit_NoError)
    mgr = clang_SourceManager_create(diag.ptr, file_mgr.ptr, volatile, status)
    @assert status[] == CXInit_NoError
    return SourceManager(mgr)
end

dispose(x::SourceManager) = clang_SourceManager_dispose(x.ptr)

function PrintStats(mgr::SourceManager)
    @check_ptrs mgr
    return clang_SourceManager_PrintStats(mgr.ptr)
end

"""
    FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
Create a file ID from a memory buffer.

This function takes ownership of the memory buffer.
"""
function FileID(src_mgr::SourceManager, buffer::MemoryBuffer)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_createFileIDFromMemoryBuffer(src_mgr.ptr, buffer.ref))
end

"""
    FileID(src_mgr::SourceManager, file_entry::FileEntry)
Create a file ID from a file entry.

See also [`get_file`](@ref).
"""
function FileID(src_mgr::SourceManager, file_entry::FileEntry,
                loc::SourceLocation=SourceLocation())
    @check_ptrs src_mgr file_entry
    return FileID(clang_SourceManager_createFileIDFromFileEntry(src_mgr.ptr, file_entry.ptr,
                                                                loc.ptr))
end

"""
    get_main_file_id(src_mgr::SourceManager) -> FileID
Return the main file ID.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function get_main_file_id(src_mgr::SourceManager)
    @check_ptrs src_mgr
    return FileID(clang_SourceManager_getMainFileID(src_mgr.ptr))
end

"""
    set_main_file_id(src_mgr::SourceManager, id::FileID)
Set the main file ID of the source manager to `id`.
"""
function set_main_file_id(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return clang_SourceManager_setMainFileID(src_mgr.ptr, id.ptr)
end

function set_main_file(src_mgr::SourceManager, file_entry::FileEntry)
    id = FileID(src_mgr, file_entry)
    set_main_file_id(src_mgr, id)
    dispose(id)
    return nothing
end

function set_main_file(src_mgr::SourceManager, buffer::MemoryBuffer)
    id = FileID(src_mgr, buffer)
    set_main_file_id(src_mgr, id)
    dispose(id)
    return nothing
end

function get_loc_for_start_of_file(src_mgr::SourceManager, id::FileID)
    @check_ptrs src_mgr id
    return SourceLocation(clang_SourceManager_getLocForStartOfFile(src_mgr.ptr, id.ptr))
end

function get_loc_for_start_of_main_file(src_mgr::SourceManager)
    id = get_main_file_id(src_mgr)
    loc = get_loc_for_start_of_file(src_mgr, id)
    dispose(id)
    return loc
end

function get_loc_for_end_of_file(src_mgr::SourceManager, id::FileID)
    @check_ptrs x id
    return SourceLocation(clang_SourceManager_getLocForEndOfFile(src_mgr.ptr, id.ptr))
end

function get_loc_for_end_of_main_file(src_mgr::SourceManager)
    id = get_main_file_id(src_mgr)
    loc = get_loc_for_end_of_file(src_mgr, id)
    dispose(id)
    return loc
end

function dump(x::SourceLocation, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceLocation_dump(x.ptr, src_mgr.ptr)
end

function get_as_string(x::SourceLocation, src_mgr::SourceManager)
    @check_ptrs src_mgr
    str = clang_SourceLocation_printToString(x.ptr, src_mgr.ptr)
    s = unsafe_string(str)
    clang_SourceLocation_disposeString(str)
    return s
end

string(x::SourceLocation) = get_as_string(x)
