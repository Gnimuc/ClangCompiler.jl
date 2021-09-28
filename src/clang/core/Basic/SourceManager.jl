"""
    struct SourceManager <: Any
Hold a pointer to a `clang::SourceManager` object.
"""
struct SourceManager
    ptr::CXSourceManager
end

Base.unsafe_convert(::Type{CXSourceManager}, x::SourceManager) = x.ptr
Base.cconvert(::Type{CXSourceManager}, x::SourceManager) = x
