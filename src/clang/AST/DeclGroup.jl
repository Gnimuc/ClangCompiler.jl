"""
    struct DeclGroupRef <: Any
Holds a `clang::DeclGroupRef` opaque pointer.
"""
struct DeclGroupRef
    ptr::CXDeclGroupRef
end

function DeclGroupRef(x::Decl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return DeclGroupRef(clang_DeclGroupRef_fromeDecl(x.ptr))
end

function is_null(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return clang_DeclGroupRef_isNull(x.ptr)
end

function is_single_decl(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return clang_DeclGroupRef_isSingleDecl(x.ptr)
end

function get_single_decl(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return Decl(clang_DeclGroupRef_getSingleDecl(x.ptr))
end

function is_decl_group(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return clang_DeclGroupRef_isDeclGroup(x.ptr)
end
