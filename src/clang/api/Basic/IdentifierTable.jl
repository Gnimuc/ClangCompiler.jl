function PrintStats(x::IdentifierTable)
    @check_ptrs x
    return clang_IdentifierTable_PrintStats(x)
end

function Base.get(x::IdentifierTable, s::String)
    @check_ptrs x
    return IdentifierInfo(clang_IdentifierTable_get(x, s))
end

function getName(x::IdentifierInfo)
    @check_ptrs x
    return unsafe_string(clang_IdentifierInfo_getName(x))
end
