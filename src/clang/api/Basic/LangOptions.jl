function PrintStats(x::LangOptions)
    @check_ptrs x
    return clang_LangOptions_PrintStats(x.ptr)
end
