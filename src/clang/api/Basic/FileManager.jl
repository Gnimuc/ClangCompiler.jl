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
function getFileEntry(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true)
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
function getFileRef(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true)
    @check_ptrs filemgr
    ref = clang_FileManager_getFileRef(filemgr, filename, open_file, cache_failure)
    @assert ref != C_NULL "failed to create a FileEntryRef to $filename."
    return FileEntryRef(ref)
end

"""
    getVirtualFileRef(filemgr::FileManager, filename::AbstractString, size::Integer,
                      modification_time::Integer) -> FileEntryRef
Return a heap-boxed `clang::FileEntryRef` for a *virtual* file: one that behaves as if a file of
that name, size and modification time were on disk. The file itself is never accessed.

Both numbers cross as 64 bits on every platform — `deps/ClangExtra/CMakeLists.txt` sets
`_FILE_OFFSET_BITS=64` so clang's `off_t` is 64 bits even on mingw, where it would otherwise be
`long` under LLP64 — so there is nothing to truncate.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function getVirtualFileRef(filemgr::FileManager, filename::AbstractString, size::Integer, modification_time::Integer)
    @check_ptrs filemgr
    ref = GC.@preserve filename clang_FileManager_getVirtualFileRef(filemgr, filename, Int64(size), Int64(modification_time))
    @assert ref != C_NULL "failed to create a virtual FileEntryRef for $filename."
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
function getBufferForFile(filemgr::FileManager, entry::FileEntryRef; is_volatile::Bool=false, requires_null_terminator::Bool=true)
    @check_ptrs filemgr entry
    buf = clang_FileManager_getBufferForFile(filemgr, entry, is_volatile, requires_null_terminator)
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
function getOptionalDirectoryRef(filemgr::FileManager, dirname::AbstractString; cache_failure::Bool=true)
    @check_ptrs filemgr
    ref = clang_FileManager_getOptionalDirectoryRef(filemgr, dirname, cache_failure)
    return ref == C_NULL ? nothing : DirectoryEntryRef(ref)
end

dispose(x::DirectoryEntryRef) = clang_DirectoryEntryRef_dispose(x)

"""
    getName(x::AbstractFileEntryRef) -> String
Return the name the reference was looked up under, following redirects to the base entry.

The bytes are borrowed from the file manager's string map — individually allocated with a
trailing NUL and never erased for the manager's lifetime.
"""
function getName(x::AbstractFileEntryRef)
    @check_ptrs x
    return unsafe_string(clang_FileEntryRef_getName(x))
end

"""
    getDir(x::AbstractFileEntryRef) -> DirectoryEntryRef
Return the directory holding the referenced file.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getDir(x::AbstractFileEntryRef)
    @check_ptrs x
    return DirectoryEntryRef(clang_FileEntryRef_getDir(x))
end

"""
    isSameRef(x::AbstractFileEntryRef, rhs::AbstractFileEntryRef) -> Bool
Return whether the two references name the same map entry.

This is *reference* identity, which is finer than file identity: two names for one file — a
path and a symlink to it — compare unequal here while their `FileEntry`s are identical.
"""
function isSameRef(x::AbstractFileEntryRef, rhs::AbstractFileEntryRef)
    @check_ptrs x rhs
    return clang_FileEntryRef_isSameRef(x, rhs)
end

"""
    getNumUniqueRealFiles(filemgr::FileManager) -> Csize_t
Return the number of unique real files `filemgr` has opened. A virtual file does not count:
its contents are never read.
"""
function getNumUniqueRealFiles(filemgr::FileManager)
    @check_ptrs filemgr
    return clang_FileManager_getNumUniqueRealFiles(filemgr)
end

"""
    getOptionalFileRef(filemgr::FileManager, filename::AbstractString; open_file::Bool=false,
                       cache_failure::Bool=true) -> Union{FileEntryRef,Nothing}
Return a reference to `filename`, or `nothing` when it cannot be opened.

This is the total form of [`getFileRef`](@ref) — the error is consumed rather than reported —
and mirrors [`getOptionalDirectoryRef`](@ref). A non-`nothing` result allocates and one should
call `dispose` to release the resources after using this object.
"""
function getOptionalFileRef(filemgr::FileManager, filename::AbstractString; open_file::Bool=false, cache_failure::Bool=true)
    @check_ptrs filemgr
    ref = clang_FileManager_getFileRef(filemgr, filename, open_file, cache_failure)
    return ref == C_NULL ? nothing : FileEntryRef(ref)
end
