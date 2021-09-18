"""
    struct Sema <: Any
Hold a pointer to a `clang::Sema` object.
"""
struct Sema
    ptr::CXSema
end

function PrintStats(x::Sema)
    @check_ptrs x
    return clang_Sema_PrintStats(x.ptr)
end

function restore_nns_annotation(x::Sema, v::AnnotationValue, rng::SourceRange,
                                spec::CXXScopeSpec)
    @check_ptrs x
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
    @check_ptrs sema
    status = Ref{CXInit_Error}(CXInit_NoError)
    result = clang_LookupResult_create(sema.ptr, name.ptr, loc.ptr, kind, status)
    @assert status[] == CXInit_NoError
    return LookupResult(result)
end

function lookup_parsed_name(x::Sema, r::LookupResult, sp::Scope, ss::CXXScopeSpec,
                            allow_builtin_creation=false, entering_context=false)
    @check_ptrs x r sp ss
    return clang_Sema_LookupParsedName(x.ptr, r.ptr, sp.ptr, ss.ptr, allow_builtin_creation,
                                       entering_context)
end

function lookup_name(x::Sema, r::LookupResult, sp::Scope, allow_builtin_creation=false)
    @check_ptrs x r sp
    return clang_Sema_LookupName(x.ptr, r.ptr, sp.ptr, allow_builtin_creation)
end
