"""
    mutable struct Sema <: Any
Holds a pointer to a `clang::Sema` object.
"""
mutable struct Sema
    ptr::CXSema
end

function print_stats(x::Sema)
    @assert x.ptr != C_NULL "Sema has a NULL pointer."
    return clang_Sema_PrintStats(x.ptr)
end

function restore_nns_annotation(x::Sema, v::AnnotationValue, rng::SourceRange, spec::CXXScopeSpec)
    @assert x.ptr != C_NULL "Sema has a NULL pointer."
    rb = get_begin_loc(rng)
    re = get_end_loc(rng)
    clang_Sema_RestoreNestedNameSpecifierAnnotation(x.ptr, v.ptr, rb.ptr, re.ptr, spec.ptr)
end

function restore_nns_annotation(x::Sema, tok::Token, spec::CXXScopeSpec)
    val = get_annotation_value(tok)
    rng = get_annotation_range(tok)
    restore_nns_annotation(x, val, rng, spec)
end
