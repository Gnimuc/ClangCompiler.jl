"""
    struct HeaderSearchOptions <: AbstractHeaderSearchOptions
Hold a pointer to a `clang::HeaderSearchOptions` object.
"""
struct HeaderSearchOptions <: AbstractHeaderSearchOptions
    ptr::CXHeaderSearchOptions
end
