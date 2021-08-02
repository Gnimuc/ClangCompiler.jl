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

"""
    mutable struct SourceLocation <: Any
Holds a `clang::SourceLocation` opaque pointer.
"""
mutable struct SourceLocation
    ptr::CXSourceLocation_
end
SourceLocation() = SourceLocation(clang_SourceLocation_createInvalid())

is_file_id(x::SourceLocation) = clang_SourceLocation_isFileID(x.ptr)
is_macro_id(x::SourceLocation) = clang_SourceLocation_isMacroID(x.ptr)
is_valid(x::SourceLocation) = clang_SourceLocation_isValid(x.ptr)
is_invalid(x::SourceLocation) = clang_SourceLocation_isInvalid(x.ptr)
value(x::SourceLocation) = clang_SourceLocation_getHashValue(x.ptr)

function is_pair_of_file_loc(begin_::SourceLocation, end_::SourceLocation)
    return clang_SourceLocation_isPairOfFileLocations(begin_.ptr, end_.ptr)
end

"""
    mutable struct SourceRange <: Any
Holds two `SourceLocation`s.
"""
mutable struct SourceRange
    begin_loc::SourceLocation
    end_loc::SourceLocation
end

get_begin_loc(x::SourceRange) = x.begin_loc
get_end_loc(x::SourceRange) = x.end_loc
