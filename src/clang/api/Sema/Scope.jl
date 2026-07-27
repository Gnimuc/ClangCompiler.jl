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


function getFlags(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_getFlags(x)
end

function getFnParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getFnParent(x))
end

"""
    getEntity(x::AbstractScope) -> DeclContext
Return the entity this scope corresponds to. `clang::Scope::getEntity` reports no entity for
a template parameter scope, so the returned `DeclContext` carries a NULL pointer there.
"""
function getEntity(x::AbstractScope)
    @check_ptrs x
    return DeclContext(clang_Scope_getEntity(x))
end

function isTemplateParamScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isTemplateParamScope(x)
end

function isDeclScope(x::AbstractScope, d::AbstractDecl)
    @check_ptrs x d
    return clang_Scope_isDeclScope(x, d)
end
