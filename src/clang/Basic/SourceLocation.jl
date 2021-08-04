"""
    struct FileID <: Any
Holds a pointer to a `clang::FileID` object.

Note that, this ID is managed by source manager and should not be manually created.
"""
struct FileID
    ptr::CXFileID
end

"""
    value(id::FileID) -> Int
Return the value of file ID.
"""
value(id::FileID) = Int(clang_FileID_getHashValue(id.ptr))

dispose(x::FileID) = clang_FileID_dispose(x.ptr)

"""
    struct SourceLocation <: Any
Holds a `clang::SourceLocation` opaque pointer.
"""
struct SourceLocation
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

function get_loc_with_offset(x::SourceLocation, offset::Integer)
    return SourceLocation(clang_SourceLocation_getLocWithOffset(x.ptr, offset))
end

function get_string(x::SourceLocation)
    str = clang_SourceLocation_printToString(x.ptr)
    s = unsafe_string(str)
    clang_SourceLocation_disposeString(str)
    return s
end

"""
    struct SourceRange <: Any
Holds two `SourceLocation`s.
"""
struct SourceRange
    begin_loc::SourceLocation
    end_loc::SourceLocation
end

get_begin_loc(x::SourceRange) = x.begin_loc
get_end_loc(x::SourceRange) = x.end_loc
