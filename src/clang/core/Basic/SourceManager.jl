"""
    struct SourceManager <: AbstractSourceManager
Hold a pointer to a `clang::SourceManager` object.
"""
struct SourceManager <: AbstractSourceManager
    ptr::CXSourceManager
end

Base.unsafe_convert(::Type{CXSourceManager}, x::SourceManager) = x.ptr
Base.cconvert(::Type{CXSourceManager}, x::SourceManager) = x


"""
    abstract type AbstractFileInfo <: Any
Supertype for `clang::SrcMgr::FileInfo`.
"""
abstract type AbstractFileInfo end

"""
    struct FileInfo <: AbstractFileInfo
Hold a pointer to a `clang::SrcMgr::FileInfo` object.
"""
struct FileInfo <: AbstractFileInfo
    ptr::CXFileInfo
end

Base.unsafe_convert(::Type{CXFileInfo}, x::FileInfo) = x.ptr
Base.cconvert(::Type{CXFileInfo}, x::FileInfo) = x

"""
    abstract type AbstractExpansionInfo <: Any
Supertype for `clang::SrcMgr::ExpansionInfo`.
"""
abstract type AbstractExpansionInfo end

"""
    struct ExpansionInfo <: AbstractExpansionInfo
Hold a pointer to a `clang::SrcMgr::ExpansionInfo` object.
"""
struct ExpansionInfo <: AbstractExpansionInfo
    ptr::CXExpansionInfo
end

Base.unsafe_convert(::Type{CXExpansionInfo}, x::ExpansionInfo) = x.ptr
Base.cconvert(::Type{CXExpansionInfo}, x::ExpansionInfo) = x

"""
    abstract type AbstractSLocEntry <: Any
Supertype for `clang::SrcMgr::SLocEntry`.
"""
abstract type AbstractSLocEntry end

"""
    struct SLocEntry <: AbstractSLocEntry
Hold a pointer to a `clang::SrcMgr::SLocEntry` object.
"""
struct SLocEntry <: AbstractSLocEntry
    ptr::CXSLocEntry
end

Base.unsafe_convert(::Type{CXSLocEntry}, x::SLocEntry) = x.ptr
Base.cconvert(::Type{CXSLocEntry}, x::SLocEntry) = x


"""
    abstract type AbstractContentCache <: Any
Supertype for `clang::SrcMgr::ContentCache`.
"""
abstract type AbstractContentCache end

"""
    struct ContentCache <: AbstractContentCache
Hold a pointer to a `clang::SrcMgr::ContentCache` object.
"""
struct ContentCache <: AbstractContentCache
    ptr::CXContentCache
end

Base.unsafe_convert(::Type{CXContentCache}, x::ContentCache) = x.ptr
Base.cconvert(::Type{CXContentCache}, x::ContentCache) = x


"""
    abstract type AbstractLineOffsetMapping <: Any
Supertype for `clang::SrcMgr::LineOffsetMapping`.
"""
abstract type AbstractLineOffsetMapping end

"""
    struct LineOffsetMapping <: AbstractLineOffsetMapping
Hold a pointer to a `clang::SrcMgr::LineOffsetMapping` object.

The C++ value keeps its offsets in a bump allocator it does not own, so the handle points at
a box holding both; the box is caller-owned and released with `dispose`.
"""
struct LineOffsetMapping <: AbstractLineOffsetMapping
    ptr::CXLineOffsetMapping
end

Base.unsafe_convert(::Type{CXLineOffsetMapping}, x::LineOffsetMapping) = x.ptr
Base.cconvert(::Type{CXLineOffsetMapping}, x::LineOffsetMapping) = x

"""
    abstract type AbstractSourceManagerForFile <: Any
Supertype for `clang::SourceManagerForFile`.
"""
abstract type AbstractSourceManagerForFile end

"""
    struct SourceManagerForFile <: AbstractSourceManagerForFile
Hold a pointer to a `clang::SourceManagerForFile` object.

The object owns the `FileManager`, `DiagnosticsEngine` and `SourceManager` it builds, plus
copies of the file name and contents they read, so it is caller-owned and released with
`dispose`.
"""
struct SourceManagerForFile <: AbstractSourceManagerForFile
    ptr::CXSourceManagerForFile
end

Base.unsafe_convert(::Type{CXSourceManagerForFile}, x::SourceManagerForFile) = x.ptr
Base.cconvert(::Type{CXSourceManagerForFile}, x::SourceManagerForFile) = x
