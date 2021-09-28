# Scope
function dump(x::Scope)
    @check_ptrs x
    return clang_Scope_dump(x)
end

function getParent(x::Scope)
    @check_ptrs x
    return Scope(clang_Scope_getParent(x))
end

function getDepth(x::Scope)::Int
    @check_ptrs x
    return clang_Scope_getDepth(x)
end
