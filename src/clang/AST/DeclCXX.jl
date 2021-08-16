"""
    abstract type AbstractCXXRecordDecl <: AbstractRecordDecl
Supertype for `CXXRecordDecl`s.
"""
abstract type AbstractCXXRecordDecl <: AbstractRecordDecl end

"""
    struct CXXRecordDecl <: AbstractCXXRecordDecl
Hold a pointer to a `clang::CXXRecordDecl` object.
"""
struct CXXRecordDecl <: AbstractCXXRecordDecl
    ptr::CXCXXRecordDecl
end

function get_canonical_decl(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return CXCXXRecordDecl(clang_CXXRecordDecl_getCanonicalDecl(x.ptr))
end

function get_previous_decl(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return CXCXXRecordDecl(clang_CXXRecordDecl_getPreviousDecl(x.ptr))
end

function get_most_recent_decl(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return CXCXXRecordDecl(clang_CXXRecordDecl_getMostRecentDecl(x.ptr))
end

function get_most_recent_non_injected_decl(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return CXCXXRecordDecl(clang_CXXRecordDecl_getMostRecentNonInjectedDecl(x.ptr))
end

function get_definition(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return CXCXXRecordDecl(clang_CXXRecordDecl_getDefinition(x.ptr))
end

function has_definition(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_hasDefinition(x.ptr)
end

function is_lambda(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_isLambda(x.ptr)
end

function is_generic_lambda(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_isGenericLambda(x.ptr)
end

function get_generic_lambda_template_parameter_list(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return TemplateParameterList(clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(x.ptr))
end

function is_aggregate(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_isAggregate(x.ptr)
end

function is_plain_old_data(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_isPOD(x.ptr)
end

function is_c_like(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_isCLike(x.ptr)
end

function is_empty(x::AbstractCXXRecordDecl)
    @assert x.ptr != C_NULL "CXXRecordDecl has a NULL pointer."
    return clang_CXXRecordDecl_isEmpty(x.ptr)
end
