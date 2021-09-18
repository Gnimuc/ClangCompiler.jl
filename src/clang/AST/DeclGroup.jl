"""
    struct DeclGroupRef <: Any
Hold a `clang::DeclGroupRef` opaque pointer.
"""
struct DeclGroupRef
    ptr::CXDeclGroupRef
end

function DeclGroupRef(x::Decl)
    @check_ptrs x
    return DeclGroupRef(clang_DeclGroupRef_fromeDecl(x.ptr))
end

function is_null(x::DeclGroupRef)
    @check_ptrs x
    return clang_DeclGroupRef_isNull(x.ptr)
end

function is_single_decl(x::DeclGroupRef)
    @check_ptrs x
    return clang_DeclGroupRef_isSingleDecl(x.ptr)
end

function get_single_decl(x::DeclGroupRef)
    @check_ptrs x
    return Decl(clang_DeclGroupRef_getSingleDecl(x.ptr))
end

function is_decl_group(x::DeclGroupRef)
    @check_ptrs x
    return clang_DeclGroupRef_isDeclGroup(x.ptr)
end
