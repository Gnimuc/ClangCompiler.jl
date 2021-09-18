"""
    struct FileEntry <: Any
Hold both a pointer to a `clang::FileEntry` object.
"""
struct FileEntry
    ptr::CXFileEntry
end

function name(x::FileEntry)
   @check_ptrs x
    s = clang_FileEntry_getName(x.ptr)
    return unsafe_string(s)
end

function real_path_name(x::FileEntry)
   @check_ptrs x
    s = clang_FileEntry_tryGetRealPathName(x.ptr)
    return unsafe_string(s)
end

function is_valid(x::FileEntry)::Bool
   @check_ptrs x
    return clang_FileEntry_isValid(x.ptr)
end

"""
    get_UID(x::FileEntry)
`UID` is a unique (small) ID for the file.
"""
function get_UID(x::FileEntry)::Int
   @check_ptrs x
    return clang_FileEntry_getUID(x.ptr)
end

function is_named_pipe(x::FileEntry)::Bool
   @check_ptrs x
    return clang_FileEntry_isNamedPipe(x.ptr)
end
