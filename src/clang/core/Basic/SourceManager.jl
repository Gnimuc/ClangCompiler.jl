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
