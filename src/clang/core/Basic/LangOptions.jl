"""
    struct LangOptions <: AbstractLangOptions
Hold a pointer to a `clang::LangOptions` object.
"""
struct LangOptions <: AbstractLangOptions
    ptr::CXLangOptions
end

Base.unsafe_convert(::Type{CXLangOptions}, x::LangOptions) = x.ptr
Base.cconvert(::Type{CXLangOptions}, x::LangOptions) = x
