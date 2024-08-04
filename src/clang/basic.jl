# IdentifierTable
get_name(x::IdentifierTable, s::String) = get(x, s)

# FileID
"""
    value(id::FileID) -> Int
Return the value of file ID.
"""
value(id::FileID) = Int(getHashValue(id))

# FileEntry
real_path_name(x::FileEntry) = tryGetRealPathName(x)
get_name(x::FileEntry) = getName(x)

# SourceLocation
value(x::SourceLocation) = getHashValue(x)

get_string(x::SourceLocation) = printToString(x)

get_begin_loc(x::SourceRange) = getBeginLoc(x)
get_end_loc(x::SourceRange) = getEndLoc(x)

# SourceManager
function get_main_file_begin_loc(src_mgr::SourceManager)
    id = getMainFileID(src_mgr)
    loc = getLocForStartOfFile(src_mgr, id)
    dispose(id)
    return loc
end

function get_main_file_end_loc(src_mgr::SourceManager)
    id = getMainFileID(src_mgr)
    loc = getLocForEndOfFile(src_mgr, id)
    dispose(id)
    return loc
end
