# FileEntry
function getName(x::FileEntry)
    @check_ptrs x
    s = clang_FileEntry_getName(x)
    return unsafe_string(s)
end

function tryGetRealPathName(x::FileEntry)
    @check_ptrs x
    s = clang_FileEntry_tryGetRealPathName(x)
    return unsafe_string(s)
end

"""
    getUID(x::FileEntry)
`UID` is a unique (small) ID for the file.
"""
function getUID(x::FileEntry)::Int
    @check_ptrs x
    return clang_FileEntry_getUID(x)
end

"""
    getModificationTime(x::FileEntry) -> Int
Return the file's last-modification time as reported by the file system.
"""
function getModificationTime(x::FileEntry)::Int
    @check_ptrs x
    return clang_FileEntry_getModificationTime(x)
end

function getDir(x::FileEntry)
    @check_ptrs x
    return DirectoryEntry(clang_FileEntry_getDir(x))
end
function isNamedPipe(x::FileEntry)::Bool
    @check_ptrs x
    return clang_FileEntry_isNamedPipe(x)
end

"""
    getSize(x::AbstractFileEntry) -> Int64
Return the file's size in bytes, as the file manager recorded it — for a virtual file, the size
it was registered with rather than anything read from disk.
"""
function getSize(x::AbstractFileEntry)
    @check_ptrs x
    return clang_FileEntry_getSize(x)
end
