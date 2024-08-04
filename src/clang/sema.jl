# Sema
function restore_nns_annotation(x::Sema, v::AnnotationValue, rng::SourceRange,
                                spec::CXXScopeSpec)
    return RestoreNestedNameSpecifierAnnotation(x, v, rng, spec)
end

function restore_nns_annotation(x::Sema, tok::Token, spec::CXXScopeSpec)
    val = getAnnotationValue(tok)
    rng = getAnnotationRange(tok)
    return restore_nns_annotation(x, val, rng, spec)
end

is_empty(x::LookupResult) = empty(x)
is_template_name(x::LookupResult) = isTemplateNameLookup(x)
is_ambiguous(x::LookupResult) = isAmbiguous(x)
is_unique(x::LookupResult) = isSingleResult(x)
is_overloaded(x::LookupResult) = isOverloadedResult(x)
is_class_lookup(x::LookupResult) = isClassLookup(x)
is_tag(x::LookupResult) = isSingleTagDecl(x)
