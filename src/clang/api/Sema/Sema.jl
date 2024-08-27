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

function getTypeName(x::Sema, ii::IdentifierInfo, name_loc::SourceLocation,
                     scope::Scope, ss::CXXScopeSpec, is_class_name::Bool=false,
                     has_trailing_dot::Bool=false, object_type::QualType=QualType(C_NULL),
                     is_ctor_or_dtor_name::Bool=false, want_nontrivial_type_source_info::Bool=false,
                     is_class_template_deduction_context::Bool=false, allow_implcit_typename::Bool=false)
    @check_ptrs x ii
    return QualType(clang_sema_getTypeName(x, ii, name_loc, scope, ss, is_class_name,
                                           has_trailing_dot, object_type, is_ctor_or_dtor_name,
                                           want_nontrivial_type_source_info,
                                           is_class_template_deduction_context,
                                           allow_implcit_typename))
end

function LookupResult(sema::Sema, name::DeclarationName, loc::SourceLocation,
                      kind::CXLookupNameKind)
    @check_ptrs sema
    result = clang_LookupResult_create(sema, name, loc, kind)
    @assert result != C_NULL "Failed to create LookupResult"
    return LookupResult(result)
end

function LookupParsedName(x::Sema, r::LookupResult, sp::Scope, ss::CXXScopeSpec,
                          allow_builtin_creation=false, entering_context=false)
    @check_ptrs x r sp ss
    return clang_Sema_LookupParsedName(x, r, sp, ss, allow_builtin_creation,
                                       entering_context)
end

function LookupName(x::Sema, r::LookupResult, sp::Scope, allow_builtin_creation::Bool=false,
                    force_no_cxx::Bool=false)
    @check_ptrs x r sp
    return clang_Sema_LookupName(x, r, sp, allow_builtin_creation, force_no_cxx)
end

function processWeakTopLevelDecls(sema::Sema, cg::CodeGenerator)
    @check_ptrs sema cg
    clang_Sema_processWeakTopLevelDecls(sema, cg)
    return nothing
end

function LookupDefaultConstructor(sema::Sema, cxxrd::CXXRecordDecl)
    @check_ptrs sema cxxrd
    return CXXConstructorDecl(clang_Sema_LookupDefaultConstructor(sema, cxxrd))
end

function LookupDestructor(sema::Sema, cxxrd::CXXRecordDecl)
    @check_ptrs sema cxxrd
    return CXXDestructorDecl(clang_Sema_LookupDestructor(sema, cxxrd))
end
