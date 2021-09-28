"""
    struct FileEntry <: Any
Hold both a pointer to a `clang::FileEntry` object.
"""
struct FileEntry
    ptr::CXFileEntry
end

Base.unsafe_convert(::Type{CXFileEntry}, x::FileEntry) = x.ptr
Base.cconvert(::Type{CXFileEntry}, x::FileEntry) = x
