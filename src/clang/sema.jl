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
