"""
    shim_type_width(name::Symbol) -> Int

The size in bytes the *shim* was compiled with for a C type whose width is platform-dependent.
`name` is `:off_t` or `:time_t`.

This layer mirrors `off_t` with the alias `off_t = Clong`, which is the same width as the C type
on every target this package builds for — but only while the shim is built as it is now.
`_FILE_OFFSET_BITS=64` in a future toolchain would make mingw's `off_t` 64 bits and leave the
alias half a value wide, with nothing to say so: an ABI mismatch is a misread register, not an
error. `time_t` needs no alias for the opposite reason, being 64 bits everywhere, and the two
shim entry points taking one spell `int64_t`.

Asking the shim is what turns either assumption into something `test/abi.jl` can check.
"""
function shim_type_width(name::Symbol)
    name === :off_t && return Int(clang_sizeof_off_t())
    name === :time_t && return Int(clang_sizeof_time_t())
    throw(ArgumentError("no width is recorded for $name; :off_t and :time_t are the " *
                        "platform-dependent C types this layer mirrors"))
end

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

# SourceLocation
value(x::SourceLocation) = getHashValue(x)

get_string(x::SourceLocation, src_mgr::SourceManager) = printToString(x, src_mgr)

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

"""
    module_ancestors(x::AbstractModule) -> ChainIterator
Iterate `x` and the modules containing it, outward to its top-level module.
"""
module_ancestors(x::AbstractModule) = ChainIterator(x, getParent)
