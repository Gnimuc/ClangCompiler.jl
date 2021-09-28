# HeaderSearch
function PrintStats(x::HeaderSearch)
    @check_ptrs x
    return clang_HeaderSearch_PrintStats(x)
end
