"""
    struct LangOptions <: Any
Hold a pointer to a `clang::LangOptions` object.
"""
struct LangOptions
    ptr::CXLangOptions
end

function PrintStats(x::LangOptions)
    @check_ptrs x
    return clang_LangOptions_PrintStats(x.ptr)
end
