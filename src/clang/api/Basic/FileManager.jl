# FileManager
FileManager() = FileManager(create_file_manager())

"""
    create_file_manager() -> CXFileManager
Return a pointer to a `clang::FileManager` object.

For now, `FileSystemOptions` is set to nothing and `llvm::vfs::FileSystem` defaults to the
"real" file system, as seen by the operating system.

The manager comes back already holding the caller's reference, so it survives being lent to
a consumer and back, and one [`dispose`](@ref) at the end still frees it. This is the general
rule for the reference-counted types the shim mints (MARSHALLING.md §12). `clang::FileManager`
is reference counted, and the consumers that borrow one take it by `IntrusiveRefCntPtr`:
`ToolInvocation`, for instance, parks it in a `CompilerInstance` that lives only for the
length of a single [`run`](@ref). Handing those a manager at a count of zero would let that
borrow run 0 to 1 and back to 0, deleting the manager the moment the consumer returned and
leaving every later use reading freed memory. The shim's `Retain` at creation makes the same
borrow run 1 to 2 and back to 1 instead.

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

"""
    fixup_relative_path(filemgr::FileManager, path::AbstractString) -> (path, changed)

Rewrite `path` according to the file manager's working directory, returning the result and
whether clang altered it.

clang takes a `SmallVectorImpl{Char}` in and out; the result crosses as a copy because its
length is not knowable before the call.
"""
function FixupRelativePath(filemgr::FileManager, path::AbstractString)
    @check_ptrs filemgr
    changed = Ref{Bool}(false)
    s = get_string(clang_FileManager_FixupRelativePath(filemgr, path, changed))
    return (path=s, changed=changed[])
end

"""
    makeAbsolutePath(filemgr::FileManager, path::AbstractString) -> (path, changed)

Make `path` absolute per the file manager's `FileSystemOptions` and working directory.
`changed` reports whether it was not already absolute. Same copying contract as
[`FixupRelativePath`](@ref).
"""
function makeAbsolutePath(filemgr::FileManager, path::AbstractString)
    @check_ptrs filemgr
    changed = Ref{Bool}(false)
    s = get_string(clang_FileManager_makeAbsolutePath(filemgr, path, changed))
    return (path=s, changed=changed[])
end

"""
    getCanonicalName(filemgr::FileManager, x) -> String

The canonical on-disk name of a file or directory reference.

Expensive even with clang's cache, and needed only when the physical layout of the file
system is. clang answers with a `StringRef` into that cache; this returns a copy, because a
borrow into storage the file manager may drop is not something this boundary can police.
"""
function getCanonicalName(filemgr::FileManager, file::AbstractFileEntryRef)
    @check_ptrs filemgr file
    return get_string(clang_FileManager_getCanonicalNameForFile(filemgr, file))
end

function getCanonicalName(filemgr::FileManager, dir::AbstractDirectoryEntryRef)
    @check_ptrs filemgr dir
    return get_string(clang_FileManager_getCanonicalNameForDir(filemgr, dir))
end

# llvm::vfs — building a file system and installing it on a FileManager.
#
# Each carrier holds one reference; `dispose` drops it, and whatever else holds a reference
# (a FileManager reading through the overlay, an overlay holding a pushed layer) keeps the
# file system alive. That is what makes disposing in any order safe here, unlike the
# create → use → dispose chains elsewhere in this file.

"""
    getRealFileSystem() -> VirtualFileSystem
Return a reference to the physical file system.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
getRealFileSystem() = VirtualFileSystem(clang_vfs_getRealFileSystem())

dispose(x::VirtualFileSystem) = clang_VirtualFileSystem_dispose(x)

"""
    exists(x::AbstractVirtualFileSystem, path::AbstractString) -> Bool
Return whether `path` resolves to something in this file system. The cheapest way to check
that an overlay is wired up the way it was meant to be.
"""
function exists(x::AbstractVirtualFileSystem, path::AbstractString)
    @check_ptrs x
    return clang_VirtualFileSystem_exists(x, path)
end

"""
    InMemoryFileSystem() -> InMemoryFileSystem
Create an empty in-memory file system.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
InMemoryFileSystem() = InMemoryFileSystem(clang_InMemoryFileSystem_create())

dispose(x::InMemoryFileSystem) = clang_InMemoryFileSystem_dispose(x)

"""
    addFile(x::AbstractInMemoryFileSystem, path::AbstractString, mtime::Integer,
            buffer::LLVM.MemoryBuffer) -> Bool
Add `path` with the contents of `buffer`, taking ownership of the buffer. Return `false`
when a file of that name is already present with different contents, in which case the
buffer is dropped rather than installed.
"""
function addFile(x::AbstractInMemoryFileSystem, path::AbstractString, mtime::Integer, buffer::LLVM.MemoryBuffer)
    @check_ptrs x
    return clang_InMemoryFileSystem_addFile(x, path, Int64(mtime), buffer)
end

"""
    toString(x::AbstractInMemoryFileSystem) -> String
Return a one-entry-per-line rendering of the tree — what was added, and under which names.
"""
function toString(x::AbstractInMemoryFileSystem)
    @check_ptrs x
    return get_string(clang_InMemoryFileSystem_toString(x))
end

"""
    castToFileSystem(x::AbstractInMemoryFileSystem) -> VirtualFileSystem
Return the same reference viewed as a plain file system, which is what an overlay and a
file manager take. Borrowed: the result shares the argument's reference and must not be
disposed separately.
"""
function castToFileSystem(x::AbstractInMemoryFileSystem)
    @check_ptrs x
    return VirtualFileSystem(clang_InMemoryFileSystem_castToFileSystem(x))
end

"""
    OverlayFileSystem(base::AbstractVirtualFileSystem) -> OverlayFileSystem
Create an overlay stack whose bottom layer is `base`. Later
[`pushOverlay`](@ref) calls shadow earlier ones.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function OverlayFileSystem(base::AbstractVirtualFileSystem)
    @check_ptrs base
    return OverlayFileSystem(clang_OverlayFileSystem_create(base))
end

dispose(x::OverlayFileSystem) = clang_OverlayFileSystem_dispose(x)

"""
    pushOverlay(x::AbstractOverlayFileSystem, overlay::AbstractVirtualFileSystem)
Push a file system on top of the stack, so it shadows every layer already there.
"""
function pushOverlay(x::AbstractOverlayFileSystem, overlay::AbstractVirtualFileSystem)
    @check_ptrs x overlay
    return clang_OverlayFileSystem_pushOverlay(x, overlay)
end

"""
    castToFileSystem(x::AbstractOverlayFileSystem) -> VirtualFileSystem
Return the same reference viewed as a plain file system. Borrowed, exactly as the
`InMemoryFileSystem` method.
"""
function castToFileSystem(x::AbstractOverlayFileSystem)
    @check_ptrs x
    return VirtualFileSystem(clang_OverlayFileSystem_castToFileSystem(x))
end

"""
    getVirtualFileSystem(filemgr::AbstractFileManager) -> VirtualFileSystem
Return a new reference to the file system this manager reads through.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getVirtualFileSystem(filemgr::AbstractFileManager)
    @check_ptrs filemgr
    return VirtualFileSystem(clang_FileManager_getVirtualFileSystem(filemgr))
end

"""
    setVirtualFileSystem(filemgr::AbstractFileManager, fs::AbstractVirtualFileSystem)
Install a different file system on the manager.

The manager keeps the caches it has already filled, so this belongs before the first
lookup: a file already resolved through the old file system stays resolved that way.
"""
function setVirtualFileSystem(filemgr::AbstractFileManager, fs::AbstractVirtualFileSystem)
    @check_ptrs filemgr fs
    return clang_FileManager_setVirtualFileSystem(filemgr, fs)
end
