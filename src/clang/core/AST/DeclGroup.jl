"""
    struct DeclGroupRef <: AbstractDeclGroupRef
Hold a `clang::DeclGroupRef` opaque pointer.
"""
struct DeclGroupRef <: AbstractDeclGroupRef
    ptr::CXDeclGroupRef
end

