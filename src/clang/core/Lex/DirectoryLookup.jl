abstract type AbstractDirectoryLookup end

"""
    struct DirectoryLookup <: AbstractDirectoryLookup
Hold a pointer to an owned `clang::DirectoryLookup` value.

A search-path entry is a by-value C++ object with no pointer form, so this is a heap-boxed
copy and caller-owned: release it with `dispose`. `AddSearchPath` and `AddSystemSearchPath`
copy it into the search, so it may be disposed as soon as either has been called.
"""
struct DirectoryLookup <: AbstractDirectoryLookup
    ptr::CXDirectoryLookup
end
