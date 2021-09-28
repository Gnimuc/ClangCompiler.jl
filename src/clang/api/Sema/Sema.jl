# Sema
function PrintStats(x::Sema)
    @check_ptrs x
    return clang_Sema_PrintStats(x)
end

function RestoreNestedNameSpecifierAnnotation(x::Sema, v::AnnotationValue, rng::SourceRange,
                                              spec::CXXScopeSpec)
    @check_ptrs x
    rb = getBeginLoc(rng)
    re = getEndLoc(rng)
    return clang_Sema_RestoreNestedNameSpecifierAnnotation(x, v, rb, re, spec)
end

function LookupResult(sema::Sema, name::DeclarationName, loc::SourceLocation,
                      kind::CXLookupNameKind)
    @check_ptrs sema
    status = Ref{CXInit_Error}(CXInit_NoError)
    result = clang_LookupResult_create(sema, name, loc, kind, status)
    @assert status[] == CXInit_NoError
    return LookupResult(result)
end

function LookupParsedName(x::Sema, r::LookupResult, sp::Scope, ss::CXXScopeSpec,
                          allow_builtin_creation=false, entering_context=false)
    @check_ptrs x r sp ss
    return clang_Sema_LookupParsedName(x, r, sp, ss, allow_builtin_creation,
                                       entering_context)
end

function LookupName(x::Sema, r::LookupResult, sp::Scope, allow_builtin_creation=false)
    @check_ptrs x r sp
    return clang_Sema_LookupName(x, r, sp, allow_builtin_creation)
end
