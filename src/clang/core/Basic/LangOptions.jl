"""
    struct LangOptions <: AbstractLangOptions
Hold a pointer to a `clang::LangOptions` object.
"""
struct LangOptions <: AbstractLangOptions
    ptr::CXLangOptions
end
