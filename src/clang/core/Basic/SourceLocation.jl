"""
    struct FileID <: Any
Hold a pointer to a `clang::FileID` object.

Note that, this ID is managed by source manager and should not be manually created.
"""
struct FileID
    ptr::CXFileID
end

Base.unsafe_convert(::Type{CXFileID}, x::FileID) = x.ptr
Base.cconvert(::Type{CXFileID}, x::FileID) = x

"""
    struct SourceLocation <: Any
Represent a Clang source location.

Note that, the underlying pointer is NOT a *pointer* to a `clang::SourceLocation` object.
Instead, it's the opaque pointer representation of the `clang::SourceLocation` itself.
"""
struct SourceLocation
    ptr::CXSourceLocation_
end

Base.unsafe_convert(::Type{CXSourceLocation_}, x::SourceLocation) = x.ptr
Base.cconvert(::Type{CXSourceLocation_}, x::SourceLocation) = x

"""
    struct SourceRange <: Any
Hold two `SourceLocation`s.
"""
struct SourceRange
    begin_loc::SourceLocation
    end_loc::SourceLocation
end
