# Sema
function PrintStats(x::Sema)
    @check_ptrs x
    return clang_Sema_PrintStats(x)
end

function setCollectStats(x::Sema, should_collect::Bool=true)
    @check_ptrs x
    return clang_Sema_setCollectStats(x, should_collect)
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


function getASTContext(x::AbstractSema)
    @check_ptrs x
    return ASTContext(clang_Sema_getASTContext(x))
end

function getSourceManager(x::AbstractSema)
    @check_ptrs x
    return SourceManager(clang_Sema_getSourceManager(x))
end

function getDiagnostics(x::AbstractSema)
    @check_ptrs x
    return DiagnosticsEngine(clang_Sema_getDiagnostics(x))
end

function getPreprocessor(x::AbstractSema)
    @check_ptrs x
    return Preprocessor(clang_Sema_getPreprocessor(x))
end

function getLangOpts(x::AbstractSema)
    @check_ptrs x
    return LangOptions(clang_Sema_getLangOpts(x))
end

"""
    getCurScope(x::AbstractSema)
Return the scope Sema is currently in. The pointer is NULL outside of parsing.
"""
function getCurScope(x::AbstractSema)
    @check_ptrs x
    return Scope(clang_Sema_getCurScope(x))
end

function isCompleteType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType,
                        kind::CXCompleteTypeKind=CXCompleteTypeKind_AcceptSizeless)
    @check_ptrs x ty
    return clang_Sema_isCompleteType(x, loc, ty, kind)
end

"""
    RequireCompleteType(x::AbstractSema, loc, ty, diag_id, kind)
Return true if `ty` is incomplete, emitting diagnostic `diag_id` at `loc`.

`diag_id` must be non-zero: Sema wraps it in a `BoundTypeDiagnoser` whose constructor asserts
on 0. Use [`isCompleteType`](@ref) for a non-diagnosing query.
"""
function RequireCompleteType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType,
                             diag_id::Integer,
                             kind::CXCompleteTypeKind=CXCompleteTypeKind_AcceptSizeless)
    @check_ptrs x ty
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireCompleteType(x, loc, ty, kind, UInt32(diag_id))
end

function RequireCompleteExprType(x::AbstractSema, e::AbstractExpr, diag_id::Integer)
    @check_ptrs x e
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireCompleteExprType(x, e, UInt32(diag_id))
end

function RequireLiteralType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType,
                            diag_id::Integer)
    @check_ptrs x ty
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireLiteralType(x, loc, ty, UInt32(diag_id))
end

function getCompletedType(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return QualType(clang_Sema_getCompletedType(x, e))
end

function RequireCompleteDeclContext(x::AbstractSema, ss::AbstractCXXScopeSpec,
                                    dc::AbstractDeclContext)
    @check_ptrs x ss dc
    return clang_Sema_RequireCompleteDeclContext(x, ss, dc)
end

function RequireCompleteEnumDecl(x::AbstractSema, d::AbstractEnumDecl, loc::SourceLocation,
                                 ss::AbstractCXXScopeSpec=CXXScopeSpec(C_NULL))
    @check_ptrs x d
    return clang_Sema_RequireCompleteEnumDecl(x, d, loc, ss)
end

function computeDeclContext(x::AbstractSema, ty::AbstractQualType)
    @check_ptrs x ty
    return DeclContext(clang_Sema_computeDeclContextFromType(x, ty))
end

function computeDeclContext(x::AbstractSema, ss::AbstractCXXScopeSpec,
                            entering_context::Bool=false)
    @check_ptrs x ss
    return DeclContext(clang_Sema_computeDeclContext(x, ss, entering_context))
end

function isDependentScopeSpecifier(x::AbstractSema, ss::AbstractCXXScopeSpec)
    @check_ptrs x ss
    return clang_Sema_isDependentScopeSpecifier(x, ss)
end

"""
    LookupSingleName(x::AbstractSema, sp, name, loc, kind, redecl)
Look up `name`, returning a single declaration. The returned carrier holds NULL when the
results were absent, ambiguous, or overloaded.
"""
function LookupSingleName(x::AbstractSema, sp::AbstractScope, name::DeclarationName,
                          loc::SourceLocation,
                          kind::CXLookupNameKind=CXLookupNameKind_LookupOrdinaryName,
                          redecl::CXRedeclarationKind=CXRedeclarationKind_NotForRedeclaration)
    @check_ptrs x sp
    return NamedDecl(clang_Sema_LookupSingleName(x, sp, name, loc, kind, redecl))
end

function LookupQualifiedName(x::AbstractSema, r::AbstractLookupResult,
                             ctx::AbstractDeclContext, in_unqualified_lookup::Bool=false)
    @check_ptrs x r ctx
    return clang_Sema_LookupQualifiedName(x, r, ctx, in_unqualified_lookup)
end

function LookupQualifiedName(x::AbstractSema, r::AbstractLookupResult,
                             ctx::AbstractDeclContext, ss::AbstractCXXScopeSpec)
    @check_ptrs x r ctx ss
    return clang_Sema_LookupQualifiedNameWithScopeSpec(x, r, ctx, ss)
end

function LookupInSuper(x::AbstractSema, r::AbstractLookupResult, cls::AbstractCXXRecordDecl)
    @check_ptrs x r cls
    return clang_Sema_LookupInSuper(x, r, cls)
end


function usesPartialOrExplicitSpecialization(x::AbstractSema, loc::SourceLocation,
                                             spec::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x spec
    return clang_Sema_usesPartialOrExplicitSpecialization(x, loc, spec)
end

"""
    InstantiateClassTemplateSpecialization(x::AbstractSema, loc::SourceLocation, spec, tsk, complain) -> Bool
Instantiate the definition of `spec` at `loc`. Return `true` when an error occurred.
"""
function InstantiateClassTemplateSpecialization(x::AbstractSema, loc::SourceLocation,
                                                spec::AbstractClassTemplateSpecializationDecl,
                                                tsk::CXTemplateSpecializationKind=CXTemplateSpecializationKind_TSK_ImplicitInstantiation,
                                                complain::Bool=true)
    @check_ptrs x spec
    return clang_Sema_InstantiateClassTemplateSpecialization(x, loc, spec, tsk, complain)
end

function InstantiateClassTemplateSpecializationMembers(x::AbstractSema, loc::SourceLocation,
                                                       spec::AbstractClassTemplateSpecializationDecl,
                                                       tsk::CXTemplateSpecializationKind=CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
    @check_ptrs x spec
    clang_Sema_InstantiateClassTemplateSpecializationMembers(x, loc, spec, tsk)
    return nothing
end

function InstantiateFunctionDefinition(x::AbstractSema, loc::SourceLocation,
                                       fd::AbstractFunctionDecl, recursive::Bool=false,
                                       definition_required::Bool=false,
                                       at_end_of_tu::Bool=false)
    @check_ptrs x fd
    clang_Sema_InstantiateFunctionDefinition(x, loc, fd, recursive, definition_required,
                                             at_end_of_tu)
    return nothing
end

function InstantiateVariableDefinition(x::AbstractSema, loc::SourceLocation,
                                       vd::AbstractVarDecl, recursive::Bool=false,
                                       definition_required::Bool=false,
                                       at_end_of_tu::Bool=false)
    @check_ptrs x vd
    clang_Sema_InstantiateVariableDefinition(x, loc, vd, recursive, definition_required,
                                             at_end_of_tu)
    return nothing
end

function PerformPendingInstantiations(x::AbstractSema, local_only::Bool=false)
    @check_ptrs x
    clang_Sema_PerformPendingInstantiations(x, local_only)
    return nothing
end
