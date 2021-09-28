"""
    abstract type AbstractCXXRecordDecl <: AbstractRecordDecl
Supertype for `CXXRecordDecl`s.
"""
abstract type AbstractCXXRecordDecl <: AbstractRecordDecl end

"""
    struct CXXRecordDecl <: AbstractCXXRecordDecl
Hold a pointer to a `clang::CXXRecordDecl` object.
"""
struct CXXRecordDecl <: AbstractCXXRecordDecl
    ptr::CXCXXRecordDecl
end

Base.unsafe_convert(::Type{CXCXXRecordDecl}, x::CXXRecordDecl) = x.ptr
Base.cconvert(::Type{CXCXXRecordDecl}, x::CXXRecordDecl) = x
