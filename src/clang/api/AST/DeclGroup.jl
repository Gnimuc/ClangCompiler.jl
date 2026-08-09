# DeclGroupRef
function DeclGroupRef(x::Decl)
    @check_ptrs x
    return DeclGroupRef(clang_DeclGroupRef_fromDecl(x))
end

function isNull(x::DeclGroupRef)
    @check_ptrs x
    return clang_DeclGroupRef_isNull(x)
end

function isSingleDecl(x::DeclGroupRef)
    @check_ptrs x
    return clang_DeclGroupRef_isSingleDecl(x)
end

function getSingleDecl(x::DeclGroupRef)
    @check_ptrs x
    return Decl(clang_DeclGroupRef_getSingleDecl(x))
end

function isDeclGroup(x::DeclGroupRef)
    @check_ptrs x
    return clang_DeclGroupRef_isDeclGroup(x)
end

"""
    size(x::DeclGroupRef) -> UInt32
The number of declarations in the group. `0` for a null group, `1` for a single
declaration, and the group's own size otherwise — [`getSingleDecl`](@ref) asserts on that
last case, so this is the accessor to reach `int a, b;` with.
"""
function Base.size(x::DeclGroupRef)
    return clang_DeclGroupRef_size(x)
end

function getDecl(x::DeclGroupRef, i::Integer)
    @assert 0 <= i < Base.size(x) "declaration index $i out of range"
    return Decl(clang_DeclGroupRef_getDecl(x, i))
end
