"""
    struct IdentifierTable <: Any
Hold a pointer to a `clang::IdentifierTable` object.
"""
struct IdentifierTable
    ptr::CXIdentifierTable
end

function print_stats(x::IdentifierTable)
    @assert x.ptr != C_NULL "IdentifierTable has a NULL pointer."
    return clang_IdentifierTable_PrintStats(x.ptr)
end

function get_name(x::IdentifierTable, s::String)
    @assert x.ptr != C_NULL "IdentifierTable has a NULL pointer."
    return IdentifierInfo(clang_IdentifierTable_get(x.ptr, s))
end

"""
    struct IdentifierInfo <: Any
Hold a pointer to a `clang::IdentifierInfo` object.
"""
struct IdentifierInfo
    ptr::CXIdentifierInfo
end
