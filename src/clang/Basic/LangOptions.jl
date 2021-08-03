"""
    mutable struct LangOptions <: Any
Holds a pointer to a `clang::LangOptions` object.
"""
mutable struct LangOptions
    ptr::CXLangOptions
end

function print_stats(x::LangOptions)
    @assert x.ptr != C_NULL "LangOptions has a NULL pointer."
    return clang_LangOptions_PrintStats(x.ptr)
end
