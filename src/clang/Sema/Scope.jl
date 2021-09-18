"""
    struct Scope <: Any
Hold a pointer to a `clang::Scope` object.
"""
struct Scope
    ptr::CXScope
end

function dump(x::Scope)
    @check_ptrs x
    return clang_Scope_dump(x.ptr)
end

function get_parent(x::Scope)
    @check_ptrs x
    return Scope(clang_Scope_getParent(x.ptr))
end

function get_depth(x::Scope)::Int
    @check_ptrs x
    return clang_Scope_getDepth(x.ptr)
end
