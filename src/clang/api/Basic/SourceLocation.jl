# FileID
getHashValue(id::FileID) = clang_FileID_getHashValue(id)

dispose(x::FileID) = clang_FileID_dispose(x)

# SourceLocation
SourceLocation() = SourceLocation(clang_SourceLocation_createInvalid())

isFileID(x::SourceLocation) = clang_SourceLocation_isFileID(x)
isMacroID(x::SourceLocation) = clang_SourceLocation_isMacroID(x)
isValid(x::SourceLocation) = clang_SourceLocation_isValid(x)
isInvalid(x::SourceLocation) = clang_SourceLocation_isInvalid(x)
getHashValue(x::SourceLocation) = clang_SourceLocation_getHashValue(x)

function isPairOfFileLocations(b::SourceLocation, e::SourceLocation)
    return clang_SourceLocation_isPairOfFileLocations(b, e)
end

function getLocWithOffset(x::SourceLocation, offset::Integer)
    return SourceLocation(clang_SourceLocation_getLocWithOffset(x, offset))
end

function printToString(x::SourceLocation, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return get_string(clang_SourceLocation_printToString(x, src_mgr))
end

# SourceRange
getBeginLoc(x::SourceRange) = x.begin_loc
getEndLoc(x::SourceRange) = x.end_loc
