# TypeName
"""
    getFullyQualifiedName(x::QualType, ctx::AbstractASTContext, policy::AbstractPrintingPolicy, with_global_ns_prefix::Bool=false) -> String
Return `x` spelled as it would have to be written at the end of the translation unit:
namespaces expanded, using-declarations resolved, template arguments qualified.

This is not what a printer gives — a printer spells the type the way the AST records it, so
a type reached through a `using` prints unqualified. `with_global_ns_prefix` prepends `::`.
"""
function getFullyQualifiedName(x::QualType, ctx::AbstractASTContext, policy::AbstractPrintingPolicy, with_global_ns_prefix::Bool=false)
    @check_ptrs x ctx policy
    return get_string(clang_TypeName_getFullyQualifiedName(x, ctx, policy, with_global_ns_prefix))
end

"""
    getFullyQualifiedType(x::QualType, ctx::AbstractASTContext, with_global_ns_prefix::Bool=false) -> QualType
Return the same requalification [`getFullyQualifiedName`](@ref) prints, as a `QualType`
rather than a string — for feeding back into the AST rather than displaying.
"""
function getFullyQualifiedType(x::QualType, ctx::AbstractASTContext, with_global_ns_prefix::Bool=false)
    @check_ptrs x ctx
    return QualType(clang_TypeName_getFullyQualifiedType(x, ctx, with_global_ns_prefix))
end
