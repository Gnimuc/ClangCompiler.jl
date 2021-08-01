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

function destroy(x::FileID)
    if x.ptr != C_NULL
        clang_FileID_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end
