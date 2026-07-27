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


getRawEncoding(x::SourceLocation) = clang_SourceLocation_getRawEncoding(x)

getFromRawEncoding(encoding::Integer) = SourceLocation(clang_SourceLocation_getFromRawEncoding(encoding))

isValid(x::SourceRange) = isValid(x.begin_loc) && isValid(x.end_loc)
isInvalid(x::SourceRange) = !isValid(x)

"""
    fullyContains(x::SourceRange, other::SourceRange) -> Bool
Return `true` iff `other` is wholly contained within `x` (raw-encoding order — meaningful
only when both ranges are in the same FileID).
"""
function fullyContains(x::SourceRange, other::SourceRange)
    return getRawEncoding(x.begin_loc) <= getRawEncoding(other.begin_loc) &&
           getRawEncoding(x.end_loc) >= getRawEncoding(other.end_loc)
end

function printToString(x::SourceRange, src_mgr::SourceManager)
    @check_ptrs src_mgr
    r = CXSourceRange_(x.begin_loc.ptr, x.end_loc.ptr)
    return get_string(clang_SourceRange_printToString(r, src_mgr))
end

function dump(x::SourceRange, src_mgr::SourceManager)
    @check_ptrs src_mgr
    return clang_SourceRange_dump(CXSourceRange_(x.begin_loc.ptr, x.end_loc.ptr), src_mgr)
end
