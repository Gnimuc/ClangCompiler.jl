"""
    struct FileEntry <: AbstractFileEntry
Hold both a pointer to a `clang::FileEntry` object.
"""
struct FileEntry <: AbstractFileEntry
    ptr::CXFileEntry
end
