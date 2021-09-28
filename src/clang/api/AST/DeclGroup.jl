# DeclGroupRef
function DeclGroupRef(x::Decl)
    @check_ptrs x
    return DeclGroupRef(clang_DeclGroupRef_fromeDecl(x))
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
