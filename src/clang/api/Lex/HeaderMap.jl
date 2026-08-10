# HeaderMap
"""
    lookupFilename(x::AbstractHeaderMap, filename::AbstractString) -> String
Return the file `filename` maps to, or `""` when the map has no entry for it.

This is what an Apple `.hmap` does to an `#include`: to the resolution process it acts like
a directory of symlinks, so a failed include in an Xcode-generated project is explained by
what this returns.
"""
function lookupFilename(x::AbstractHeaderMap, filename::AbstractString)
    @check_ptrs x
    return get_string(clang_HeaderMap_lookupFilename(x, filename))
end

"""
    getFileName(x::AbstractHeaderMap) -> String
Return the path of the `.hmap` file itself.
"""
function getFileName(x::AbstractHeaderMap)
    @check_ptrs x
    return get_string(clang_HeaderMap_getFileName(x))
end

"""
    reverseLookupFilename(x::AbstractHeaderMap, dest_path::AbstractString) -> String
Return the key that maps to `dest_path`, or `""`. This inverts [`lookupFilename`](@ref) and
turns a resolved path back into the spelling a user wrote.
"""
function reverseLookupFilename(x::AbstractHeaderMap, dest_path::AbstractString)
    @check_ptrs x
    return get_string(clang_HeaderMap_reverseLookupFilename(x, dest_path))
end

"""
    dump(x::AbstractHeaderMap)
Dump every bucket of the map to stderr.
"""
function dump(x::AbstractHeaderMap)
    @check_ptrs x
    return clang_HeaderMap_dump(x)
end

"""
    getKeys(x::AbstractHeaderMap) -> Vector{String}
Return every key in the map, in bucket order.
"""
function getKeys(x::AbstractHeaderMap)
    @check_ptrs x
    return get_string(clang_HeaderMap_getKeys(x))
end
