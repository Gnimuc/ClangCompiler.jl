"""
    struct IdentifierTable <: Any
Hold a pointer to a `clang::IdentifierTable` object.
"""
struct IdentifierTable
    ptr::CXIdentifierTable
end

Base.unsafe_convert(::Type{CXIdentifierTable}, x::IdentifierTable) = x.ptr
Base.cconvert(::Type{CXIdentifierTable}, x::IdentifierTable) = x

"""
    struct IdentifierInfo <: Any
Hold a pointer to a `clang::IdentifierInfo` object.
"""
struct IdentifierInfo
    ptr::CXIdentifierInfo
end

Base.unsafe_convert(::Type{CXIdentifierInfo}, x::IdentifierInfo) = x.ptr
Base.cconvert(::Type{CXIdentifierInfo}, x::IdentifierInfo) = x
