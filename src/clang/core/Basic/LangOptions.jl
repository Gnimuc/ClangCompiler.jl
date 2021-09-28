"""
    struct LangOptions <: Any
Hold a pointer to a `clang::LangOptions` object.
"""
struct LangOptions
    ptr::CXLangOptions
end

Base.unsafe_convert(::Type{CXLangOptions}, x::LangOptions) = x.ptr
Base.cconvert(::Type{CXLangOptions}, x::LangOptions) = x
