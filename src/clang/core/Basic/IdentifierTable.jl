"""
    struct IdentifierTable <: AbstractIdentifierTable
Hold a pointer to a `clang::IdentifierTable` object.
"""
struct IdentifierTable <: AbstractIdentifierTable
    ptr::CXIdentifierTable
end

Base.unsafe_convert(::Type{CXIdentifierTable}, x::IdentifierTable) = x.ptr
Base.cconvert(::Type{CXIdentifierTable}, x::IdentifierTable) = x

"""
    struct IdentifierInfo <: AbstractIdentifierInfo
Hold a pointer to a `clang::IdentifierInfo` object.
"""
struct IdentifierInfo <: AbstractIdentifierInfo
    ptr::CXIdentifierInfo
end

Base.unsafe_convert(::Type{CXIdentifierInfo}, x::IdentifierInfo) = x.ptr
Base.cconvert(::Type{CXIdentifierInfo}, x::IdentifierInfo) = x
