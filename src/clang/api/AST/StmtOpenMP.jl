# OMPExecutableDirective — abstract-base payload for OpenMP directives.
function getNumClauses(x::AbstractOMPExecutableDirective)
    @check_ptrs x
    return clang_OMPExecutableDirective_getNumClauses(x)
end

function isStandaloneDirective(x::AbstractOMPExecutableDirective)
    @check_ptrs x
    return clang_OMPExecutableDirective_isStandaloneDirective(x)
end

function hasAssociatedStmt(x::AbstractOMPExecutableDirective)
    @check_ptrs x
    return clang_OMPExecutableDirective_hasAssociatedStmt(x)
end

# The captured statement the directive applies to, resolved to its concrete type.
# Only valid when `hasAssociatedStmt(x)`.
function getAssociatedStmt(x::AbstractOMPExecutableDirective)
    @check_ptrs x
    return resolve(Stmt(clang_OMPExecutableDirective_getAssociatedStmt(x)))
end
