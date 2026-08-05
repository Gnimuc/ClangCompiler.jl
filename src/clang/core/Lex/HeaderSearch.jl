"""
    struct HeaderSearch <: AbstractHeaderSearch
Hold a pointer to a `clang::HeaderSearch` object.
"""
struct HeaderSearch <: AbstractHeaderSearch
    ptr::CXHeaderSearch
end

Base.unsafe_convert(::Type{CXHeaderSearch}, x::HeaderSearch) = x.ptr
Base.cconvert(::Type{CXHeaderSearch}, x::HeaderSearch) = x


abstract type AbstractHeaderFileInfo end

"""
    struct HeaderFileInfo <: AbstractHeaderFileInfo
Hold a pointer to a `clang::HeaderFileInfo` object.
"""
struct HeaderFileInfo <: AbstractHeaderFileInfo
    ptr::CXHeaderFileInfo
end

Base.unsafe_convert(::Type{CXHeaderFileInfo}, x::HeaderFileInfo) = x.ptr
Base.cconvert(::Type{CXHeaderFileInfo}, x::HeaderFileInfo) = x
