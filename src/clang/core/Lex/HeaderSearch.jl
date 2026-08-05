"""
    struct HeaderSearch <: AbstractHeaderSearch
Hold a pointer to a `clang::HeaderSearch` object.
"""
struct HeaderSearch <: AbstractHeaderSearch
    ptr::CXHeaderSearch
end

abstract type AbstractHeaderFileInfo end

"""
    struct HeaderFileInfo <: AbstractHeaderFileInfo
Hold a pointer to a `clang::HeaderFileInfo` object.
"""
struct HeaderFileInfo <: AbstractHeaderFileInfo
    ptr::CXHeaderFileInfo
end
