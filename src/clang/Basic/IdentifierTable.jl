"""
    mutable struct IdentifierTable <: Any
Holds a pointer to a `clang::IdentifierTable` object.
"""
mutable struct IdentifierTable
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
    mutable struct IdentifierInfo <: Any
Holds a pointer to a `clang::IdentifierInfo` object.
"""
mutable struct IdentifierInfo
    ptr::CXIdentifierInfo
end
