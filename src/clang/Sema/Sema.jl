"""
    struct Sema <: Any
Holds a pointer to a `clang::Sema` object.
"""
struct Sema
    ptr::CXSema
end

function print_stats(x::Sema)
    @assert x.ptr != C_NULL "Sema has a NULL pointer."
    return clang_Sema_PrintStats(x.ptr)
end

function restore_nns_annotation(x::Sema, v::AnnotationValue, rng::SourceRange,
                                spec::CXXScopeSpec)
    @assert x.ptr != C_NULL "Sema has a NULL pointer."
    rb = get_begin_loc(rng)
    re = get_end_loc(rng)
    return clang_Sema_RestoreNestedNameSpecifierAnnotation(x.ptr, v.ptr, rb.ptr, re.ptr,
                                                           spec.ptr)
end

function restore_nns_annotation(x::Sema, tok::Token, spec::CXXScopeSpec)
    val = get_annotation_value(tok)
    rng = get_annotation_range(tok)
    return restore_nns_annotation(x, val, rng, spec)
end

function LookupResult(sema::Sema, name::DeclarationName, loc::SourceLocation,
                      kind::CXLookupNameKind)
    @assert sema.ptr != C_NULL "Sema has a NULL pointer."
    status = Ref{CXInit_Error}(CXInit_NoError)
    result = clang_LookupResult_create(sema.ptr, name.ptr, loc.ptr, kind, status)
    @assert status[] == CXInit_NoError
    return LookupResult(result)
end

function lookup_parsed_name(x::Sema, r::LookupResult, sp::Scope, ss::CXXScopeSpec,
                            allow_builtin_creation=false, entering_context=false)
    @assert x.ptr != C_NULL "Sema has a NULL pointer."
    @assert r.ptr != C_NULL "LookupResult has a NULL pointer."
    @assert sp.ptr != C_NULL "Scope has a NULL pointer."
    @assert ss.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_Sema_LookupParsedName(x.ptr, r.ptr, sp.ptr, ss.ptr, allow_builtin_creation,
                                       entering_context)
end
