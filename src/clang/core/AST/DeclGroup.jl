"""
    struct DeclGroupRef <: AbstractDeclGroupRef
Hold a `clang::DeclGroupRef` opaque pointer.
"""
struct DeclGroupRef <: AbstractDeclGroupRef
    ptr::CXDeclGroupRef
end

Base.unsafe_convert(::Type{CXDeclGroupRef}, x::DeclGroupRef) = x.ptr
Base.cconvert(::Type{CXDeclGroupRef}, x::DeclGroupRef) = x
