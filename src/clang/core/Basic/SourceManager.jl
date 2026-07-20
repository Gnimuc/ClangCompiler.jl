"""
    struct SourceManager <: AbstractSourceManager
Hold a pointer to a `clang::SourceManager` object.
"""
struct SourceManager <: AbstractSourceManager
    ptr::CXSourceManager
end

Base.unsafe_convert(::Type{CXSourceManager}, x::SourceManager) = x.ptr
Base.cconvert(::Type{CXSourceManager}, x::SourceManager) = x
