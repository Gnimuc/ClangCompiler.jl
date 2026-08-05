# Sema
function PrintStats(x::Sema)
    @check_ptrs x
    return clang_Sema_PrintStats(x)
end

function setCollectStats(x::Sema, should_collect::Bool=true)
    @check_ptrs x
    return clang_Sema_setCollectStats(x, should_collect)
end
function RestoreNestedNameSpecifierAnnotation(x::Sema, v::AnnotationValue, rng::SourceRange, spec::CXXScopeSpec)
    @check_ptrs x
    rb = getBeginLoc(rng)
    re = getEndLoc(rng)
    # `Sema::RestoreNestedNameSpecifierAnnotation` takes the payload as clang's own opaque
    # `void *`, so the shim's parameter is `void *` too and there is no `CXAnnotationValue`
    # entry in converts.jl to marshal through -- the handle is unwrapped here instead.
    return clang_Sema_RestoreNestedNameSpecifierAnnotation(x, Ptr{Cvoid}(v.ptr), rb, re, spec)
end

function getTypeName(x::Sema, ii::IdentifierInfo, name_loc::SourceLocation, scope::Scope, ss::CXXScopeSpec, is_class_name::Bool=false, has_trailing_dot::Bool=false, object_type::QualType=QualType(C_NULL), is_ctor_or_dtor_name::Bool=false, want_nontrivial_type_source_info::Bool=false, is_class_template_deduction_context::Bool=false, allow_implicit_typename::Bool=false)
    @check_ptrs x ii
    return QualType(clang_Sema_getTypeName(x, ii, name_loc, scope, ss, is_class_name, has_trailing_dot, object_type, is_ctor_or_dtor_name, want_nontrivial_type_source_info, is_class_template_deduction_context, allow_implicit_typename))
end

function LookupResult(sema::Sema, name::DeclarationName, loc::SourceLocation, kind::CXLookupNameKind)
    @check_ptrs sema
    result = clang_LookupResult_create(sema, name, loc, kind)
    @assert result != C_NULL "Failed to create LookupResult"
    return LookupResult(result)
end

function LookupParsedName(x::Sema, r::LookupResult, sp::Scope, ss::CXXScopeSpec, allow_builtin_creation=false, entering_context=false)
    @check_ptrs x r sp ss
    return clang_Sema_LookupParsedName(x, r, sp, ss, allow_builtin_creation, entering_context)
end

function LookupName(x::Sema, r::LookupResult, sp::Scope, allow_builtin_creation::Bool=false, force_no_cxx::Bool=false)
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

function isCompleteType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType, kind::CXCompleteTypeKind=CXCompleteTypeKind_AcceptSizeless)
    @check_ptrs x ty
    return clang_Sema_isCompleteType(x, loc, ty, kind)
end

"""
    RequireCompleteType(x::AbstractSema, loc, ty, diag_id, kind)
Return true if `ty` is incomplete, emitting diagnostic `diag_id` at `loc`.

`diag_id` must be non-zero: Sema wraps it in a `BoundTypeDiagnoser` whose constructor asserts
on 0. Use [`isCompleteType`](@ref) for a non-diagnosing query.
"""
function RequireCompleteType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType, diag_id::Integer, kind::CXCompleteTypeKind=CXCompleteTypeKind_AcceptSizeless)
    @check_ptrs x ty
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireCompleteType(x, loc, ty, kind, UInt32(diag_id))
end

function RequireCompleteExprType(x::AbstractSema, e::AbstractExpr, diag_id::Integer)
    @check_ptrs x e
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireCompleteExprType(x, e, UInt32(diag_id))
end

function RequireLiteralType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType, diag_id::Integer)
    @check_ptrs x ty
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireLiteralType(x, loc, ty, UInt32(diag_id))
end

function getCompletedType(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return QualType(clang_Sema_getCompletedType(x, e))
end

function RequireCompleteDeclContext(x::AbstractSema, ss::AbstractCXXScopeSpec, dc::AbstractDeclContext)
    @check_ptrs x ss dc
    return clang_Sema_RequireCompleteDeclContext(x, ss, dc)
end

function RequireCompleteEnumDecl(x::AbstractSema, d::AbstractEnumDecl, loc::SourceLocation, ss::AbstractCXXScopeSpec=CXXScopeSpec(C_NULL))
    @check_ptrs x d
    return clang_Sema_RequireCompleteEnumDecl(x, d, loc, ss)
end

function computeDeclContext(x::AbstractSema, ty::AbstractQualType)
    @check_ptrs x ty
    return DeclContext(clang_Sema_computeDeclContextFromType(x, ty))
end

function computeDeclContext(x::AbstractSema, ss::AbstractCXXScopeSpec, entering_context::Bool=false)
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
function LookupSingleName(x::AbstractSema, sp::AbstractScope, name::DeclarationName, loc::SourceLocation, kind::CXLookupNameKind=CXLookupNameKind_LookupOrdinaryName, redecl::CXRedeclarationKind=CXRedeclarationKind_NotForRedeclaration)
    @check_ptrs x sp
    return NamedDecl(clang_Sema_LookupSingleName(x, sp, name, loc, kind, redecl))
end

function LookupQualifiedName(x::AbstractSema, r::AbstractLookupResult, ctx::AbstractDeclContext, in_unqualified_lookup::Bool=false)
    @check_ptrs x r ctx
    return clang_Sema_LookupQualifiedName(x, r, ctx, in_unqualified_lookup)
end

function LookupQualifiedName(x::AbstractSema, r::AbstractLookupResult, ctx::AbstractDeclContext, ss::AbstractCXXScopeSpec)
    @check_ptrs x r ctx ss
    return clang_Sema_LookupQualifiedNameWithScopeSpec(x, r, ctx, ss)
end

function LookupInSuper(x::AbstractSema, r::AbstractLookupResult, cls::AbstractCXXRecordDecl)
    @check_ptrs x r cls
    return clang_Sema_LookupInSuper(x, r, cls)
end

function usesPartialOrExplicitSpecialization(x::AbstractSema, loc::SourceLocation, spec::AbstractClassTemplateSpecializationDecl)
    @check_ptrs x spec
    return clang_Sema_usesPartialOrExplicitSpecialization(x, loc, spec)
end

"""
    InstantiateClassTemplateSpecialization(x::AbstractSema, loc::SourceLocation, spec, tsk, complain) -> Bool
Instantiate the definition of `spec` at `loc`. Return `true` when an error occurred.
"""
function InstantiateClassTemplateSpecialization(x::AbstractSema, loc::SourceLocation, spec::AbstractClassTemplateSpecializationDecl, tsk::CXTemplateSpecializationKind=CXTemplateSpecializationKind_TSK_ImplicitInstantiation, complain::Bool=true)
    @check_ptrs x spec
    return clang_Sema_InstantiateClassTemplateSpecialization(x, loc, spec, tsk, complain)
end

function InstantiateClassTemplateSpecializationMembers(x::AbstractSema, loc::SourceLocation, spec::AbstractClassTemplateSpecializationDecl, tsk::CXTemplateSpecializationKind=CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
    @check_ptrs x spec
    clang_Sema_InstantiateClassTemplateSpecializationMembers(x, loc, spec, tsk)
    return nothing
end

function InstantiateFunctionDefinition(x::AbstractSema, loc::SourceLocation, fd::AbstractFunctionDecl, recursive::Bool=false, definition_required::Bool=false, at_end_of_tu::Bool=false)
    @check_ptrs x fd
    clang_Sema_InstantiateFunctionDefinition(x, loc, fd, recursive, definition_required, at_end_of_tu)
    return nothing
end

function InstantiateVariableDefinition(x::AbstractSema, loc::SourceLocation, vd::AbstractVarDecl, recursive::Bool=false, definition_required::Bool=false, at_end_of_tu::Bool=false)
    @check_ptrs x vd
    clang_Sema_InstantiateVariableDefinition(x, loc, vd, recursive, definition_required, at_end_of_tu)
    return nothing
end

function PerformPendingInstantiations(x::AbstractSema, local_only::Bool=false)
    @check_ptrs x
    clang_Sema_PerformPendingInstantiations(x, local_only)
    return nothing
end

# Special-member lookup, visible-decl enumeration and the remaining type requirements

"""
    LookupConstructors(x::AbstractSema, cls::AbstractCXXRecordDecl) -> Vector{NamedDecl}
Return the constructors of `cls`, declaring its implicit constructors first.

An entry carries a constructor or, for a constructor template, its `FunctionTemplateDecl`, so the
result comes back at the container's element type and needs a checked cast to be refined. `cls`
must be a class definition that is neither dependent nor still being defined.
"""
function LookupConstructors(x::AbstractSema, cls::AbstractCXXRecordDecl)
    @check_ptrs x cls
    @assert hasDefinition(cls) && !isBeingDefined(cls) && !isDependentType(cls) "cls must be a complete, non-dependent class definition"
    n = clang_Sema_LookupConstructors(x, cls, Ptr{CXNamedDecl}(C_NULL), 0)
    n == 0 && return NamedDecl[]
    buf = Vector{CXNamedDecl}(undef, n)
    return NamedDecl.(resize!(buf, clang_Sema_LookupConstructors(x, cls, buf, n)))
end

"""
    LookupCopyingConstructor(x::AbstractSema, cls::AbstractCXXRecordDecl, quals::Integer=0)
Return the copy constructor of `cls` that takes a parameter qualified with `quals`.

`quals` is a `Qualifiers` bitmask restricted to Const (`0x1`) and Volatile (`0x4`); Sema asserts
on anything else. The carrier holds NULL when overload resolution found no usable member.
"""
function LookupCopyingConstructor(x::AbstractSema, cls::AbstractCXXRecordDecl, quals::Integer=0)
    @check_ptrs x cls
    @assert hasDefinition(cls) && !isBeingDefined(cls) && !isDependentType(cls) "cls must be a complete, non-dependent class definition"
    @assert UInt32(quals) & ~UInt32(0x5) == 0 "quals may only hold Const (0x1) / Volatile (0x4)"
    return CXXConstructorDecl(clang_Sema_LookupCopyingConstructor(x, cls, UInt32(quals)))
end

"""
    LookupCopyingAssignment(x::AbstractSema, cls, quals=0, rvalue_this=false, this_quals=0)
Return the copy-assignment operator of `cls` taking a parameter qualified with `quals` on an
implicit object parameter qualified with `this_quals`.

Both masks are `Qualifiers` bitmasks restricted to Const (`0x1`) and Volatile (`0x4`).
"""
function LookupCopyingAssignment(x::AbstractSema, cls::AbstractCXXRecordDecl, quals::Integer=0, rvalue_this::Bool=false, this_quals::Integer=0)
    @check_ptrs x cls
    @assert hasDefinition(cls) && !isBeingDefined(cls) && !isDependentType(cls) "cls must be a complete, non-dependent class definition"
    @assert UInt32(quals) & ~UInt32(0x5) == 0 "quals may only hold Const (0x1) / Volatile (0x4)"
    @assert UInt32(this_quals) & ~UInt32(0x5) == 0 "this_quals may only hold Const / Volatile"
    return CXXMethodDecl(clang_Sema_LookupCopyingAssignment(x, cls, UInt32(quals), rvalue_this, UInt32(this_quals)))
end

"""
    LookupMovingConstructor(x::AbstractSema, cls::AbstractCXXRecordDecl, quals::Integer=0)
Return the move constructor of `cls` that takes a parameter qualified with `quals`.
"""
function LookupMovingConstructor(x::AbstractSema, cls::AbstractCXXRecordDecl, quals::Integer=0)
    @check_ptrs x cls
    @assert hasDefinition(cls) && !isBeingDefined(cls) && !isDependentType(cls) "cls must be a complete, non-dependent class definition"
    @assert UInt32(quals) & ~UInt32(0x5) == 0 "quals may only hold Const (0x1) / Volatile (0x4)"
    return CXXConstructorDecl(clang_Sema_LookupMovingConstructor(x, cls, UInt32(quals)))
end

"""
    LookupMovingAssignment(x::AbstractSema, cls, quals=0, rvalue_this=false, this_quals=0)
Return the move-assignment operator of `cls` taking a parameter qualified with `quals` on an
implicit object parameter qualified with `this_quals`.
"""
function LookupMovingAssignment(x::AbstractSema, cls::AbstractCXXRecordDecl, quals::Integer=0, rvalue_this::Bool=false, this_quals::Integer=0)
    @check_ptrs x cls
    @assert hasDefinition(cls) && !isBeingDefined(cls) && !isDependentType(cls) "cls must be a complete, non-dependent class definition"
    @assert UInt32(quals) & ~UInt32(0x5) == 0 "quals may only hold Const (0x1) / Volatile (0x4)"
    @assert UInt32(this_quals) & ~UInt32(0x5) == 0 "this_quals may only hold Const / Volatile"
    return CXXMethodDecl(clang_Sema_LookupMovingAssignment(x, cls, UInt32(quals), rvalue_this, UInt32(this_quals)))
end

"""
    LookupSpecialMember(x::AbstractSema, cls, sm::CXCXXSpecialMember, const_arg=false,
                        volatile_arg=false, rvalue_this=false, const_this=false,
                        volatile_this=false)
Run overload resolution for the special member `sm` of `cls`, returning the selected method and
the outcome of the resolution as a tuple.

`clang::Sema::SpecialMemberOverloadResult` is a value type, so it crosses as its two halves: the
returned carrier holds NULL when nothing was selected, and the kind tells "no member" apart from
"deleted" and "ambiguous". This is the general form of the five lookups above.
"""
function LookupSpecialMember(x::AbstractSema, cls::AbstractCXXRecordDecl, sm::CXCXXSpecialMember, const_arg::Bool=false, volatile_arg::Bool=false, rvalue_this::Bool=false, const_this::Bool=false, volatile_this::Bool=false)
    @check_ptrs x cls
    @assert hasDefinition(cls) && !isBeingDefined(cls) && !isDependentType(cls) "cls must be a complete, non-dependent class definition"
    kind = Ref{CXSpecialMemberOverloadResultKind}(CXSpecialMemberOverloadResultKind_NoMemberOrDeleted)
    md = clang_Sema_LookupSpecialMember(x, cls, sm, const_arg, volatile_arg, rvalue_this, const_this, volatile_this, kind)
    return CXXMethodDecl(md), kind[]
end

"""
    LookupBuiltin(x::AbstractSema, r::AbstractLookupResult) -> Bool
Return true when the name in `r` names a builtin, adding the builtin's declaration to `r`.

Creating that declaration installs it in the translation-unit scope, so a builtin name mutates the
AST; a name that is not a builtin leaves everything untouched and returns false.
"""
function LookupBuiltin(x::AbstractSema, r::AbstractLookupResult)
    @check_ptrs x r
    return clang_Sema_LookupBuiltin(x, r)
end

"""
    LookupVisibleDecls(x::AbstractSema, ctx::AbstractDeclContext, kind, include_global_scope=true,
                       include_dependent_bases=false, load_external=true) -> Vector{NamedDecl}
Return every declaration of the requested `kind` that unqualified lookup can see from `ctx`.

Clang exposes this as a visitor; the C shim runs the whole walk and hands back a flat buffer
instead. The walk declares the implicit members of every class context it enters, so it is not
idempotent — the counting pass is a lower bound for the filling pass, and only what the second
walk actually wrote is returned. `include_global_scope` keeps clang's default: pass `false` to
stop the walk from reaching into the translation unit.
"""
function LookupVisibleDecls(x::AbstractSema, ctx::AbstractDeclContext, kind::CXLookupNameKind=CXLookupNameKind_LookupOrdinaryName, include_global_scope::Bool=true, include_dependent_bases::Bool=false, load_external::Bool=true)
    @check_ptrs x ctx
    n = clang_Sema_LookupVisibleDeclsInContext(x, ctx, kind, include_global_scope, include_dependent_bases, load_external, Ptr{CXNamedDecl}(C_NULL), 0)
    n == 0 && return NamedDecl[]
    buf = Vector{CXNamedDecl}(undef, n)
    m = clang_Sema_LookupVisibleDeclsInContext(x, ctx, kind, include_global_scope, include_dependent_bases, load_external, buf, n)
    return NamedDecl.(resize!(buf, m))
end

"""
    isAbstractType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType) -> Bool
Return whether `ty` is, or is an array of, a class with an unoverridden pure virtual member.

This is the question [`RequireNonAbstractType`](@ref) answers, without the diagnostic it emits —
and that difference is what makes it usable as a query, because the diagnostic raises the
interpreter's error count, which `parse`/`execute` consult afterwards.

It is also more total than [`isAbstract`](@ref) on a `CXXRecordDecl`: that one reads the record's
definition data and so needs a definition, whereas this peels array element types and answers
`false` for an incomplete record, a non-record, and non-C++. `loc` is not read by clang.
"""
function isAbstractType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType)
    @check_ptrs x ty
    return clang_Sema_isAbstractType(x, loc, ty)
end

"""
    getNamedReturnInfo(x::AbstractSema, vd::AbstractVarDecl) -> CXNamedReturnInfo_Status
Return the copy-elision status clang computes for `vd` considered as a named return operand:
`None`, `MoveEligible`, or `MoveEligibleAndCopyElidable` ([class.copy.elision]p3).

Finer than [`isNRVOVariable`](@ref), which is one bool that Sema sets only for a variable that
actually *was* returned. This answers for any local, so it distinguishes why elision is
unavailable — a parameter, static storage, `volatile`, over-alignment, a plain rvalue reference.

`vd`'s type must be complete: clang reaches `getTypeAlignInChars` for a non-volatile object type,
which asserts inside the record-layout builder on an incomplete one.
"""
function getNamedReturnInfo(x::AbstractSema, vd::AbstractVarDecl)
    @check_ptrs x vd
    @assert !isIncompleteType(getTypePtr(getType(vd))) "vd's type must be complete"
    return clang_Sema_getNamedReturnInfo(x, vd)
end

"""
    RequireNonAbstractType(x::AbstractSema, loc, ty, diag_id) -> Bool
Return true when `ty` is (an array of) an abstract class type, emitting diagnostic `diag_id` at
`loc`.

`diag_id` must be non-zero: Sema wraps it in a `BoundTypeDiagnoser` whose constructor asserts on
0, exactly as in [`RequireCompleteType`](@ref). A non-abstract type returns before the diagnoser
is consulted, so nothing is emitted for it.
"""
function RequireNonAbstractType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType, diag_id::Integer)
    @check_ptrs x ty
    @assert diag_id != 0 "diag_id must be non-zero: Sema asserts on a 0 type-diagnoser id"
    return clang_Sema_RequireNonAbstractType(x, loc, ty, UInt32(diag_id))
end

"""
    RequireStructuralType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> Bool
Return true when `ty` is not a structural type, the C++20 requirement on the type of a non-type
template parameter.

This one carries its own diagnostic ids rather than taking one, so an incomplete or
non-structural `ty` does emit diagnostics. A dependent type is accepted without checking.
"""
function RequireStructuralType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return clang_Sema_RequireStructuralType(x, ty, loc)
end

# --- Sema state queries ---

"""
    hasUncompilableErrorOccurred(x::AbstractSema) -> Bool
Return whether an error that makes the translation unit uncompilable has been emitted,
including errors carried in deferred diagnostics.
"""
function hasUncompilableErrorOccurred(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_hasUncompilableErrorOccurred(x)
end

"""
    getFixItZeroInitializerForType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> String
Return the initializer clang would suggest to zero-initialize `ty` (`" = 0"`, `"{}"`, ...),
or an empty string when it has no suggestion.
"""
function getFixItZeroInitializerForType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return get_string(clang_Sema_getFixItZeroInitializerForType(x, ty, loc))
end

"""
    getFixItZeroLiteralForType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> String
Return the bare zero literal for the scalar type `ty` (`"0"`, `"0.0"`, `"nullptr"`, ...).

`ty` must name a scalar type: unlike [`getFixItZeroInitializerForType`](@ref) this entry
point forwards to the spelling helper unconditionally, and that helper asserts scalar-ness.
"""
function getFixItZeroLiteralForType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    @assert isScalarType(getTypePtr(ty)) "the type must be a scalar type"
    return get_string(clang_Sema_getFixItZeroLiteralForType(x, ty, loc))
end

"""
    getLocForEndOfToken(x::AbstractSema, loc::SourceLocation, offset::Integer=0) -> SourceLocation
Return the location just past the end of the token starting at `loc`, shifted back by
`offset` characters. The result is invalid when `loc` points into a macro.
"""
function getLocForEndOfToken(x::AbstractSema, loc::SourceLocation, offset::Integer=0)
    @check_ptrs x
    return SourceLocation(clang_Sema_getLocForEndOfToken(x, loc, offset))
end

"""
    canThrow(x::AbstractSema, s::AbstractStmt) -> CXCanThrowResult
Return whether evaluating `s` can throw: `CT_Cannot`, `CT_Can`, or `CT_Dependent` when the
answer depends on template arguments.
"""
function canThrow(x::AbstractSema, s::AbstractStmt)
    @check_ptrs x s
    return clang_Sema_canThrow(x, s)
end

"""
    isVisible(x::AbstractSema, d::AbstractNamedDecl) -> Bool
Return whether `d` is visible to name lookup under Sema's current module visibility.
"""
function isVisible(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_Sema_isVisible(x, d)
end

"""
    isReachable(x::AbstractSema, d::AbstractNamedDecl) -> Bool
Return whether `d` is reachable from the current translation unit. Every visible
declaration is reachable.
"""
function isReachable(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_Sema_isReachable(x, d)
end

function hasVisibleMergedDefinition(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_Sema_hasVisibleMergedDefinition(x, d)
end

"""
    isEquivalentInternalLinkageDeclaration(x::AbstractSema, a, b) -> Bool
Return whether `a` and `b` are equivalent internal-linkage declarations coming from
different modules, which downgrades an ambiguity error to an extension warning.
"""
function isEquivalentInternalLinkageDeclaration(x::AbstractSema, a::AbstractNamedDecl, b::AbstractNamedDecl)
    @check_ptrs x a b
    return clang_Sema_isEquivalentInternalLinkageDeclaration(x, a, b)
end

"""
    isUsualDeallocationFunction(x::AbstractSema, md::AbstractCXXMethodDecl) -> Bool
Return whether `md` is a usual deallocation function. This is Sema's language-mode-aware
form of the plain `isUsualDeallocationFunction(::AbstractCXXMethodDecl)` predicate.
"""
function isUsualDeallocationFunction(x::AbstractSema, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    return clang_Sema_isUsualDeallocationFunction(x, md)
end

"""
    getFunctionLevelDeclContext(x::AbstractSema, allow_lambda::Bool=false) -> DeclContext
Return the innermost enclosing declaration context, skipping block, enum, captured and
requires-expression-body contexts. With `allow_lambda` a lambda call operator is kept.

Sema's declaration context is established when the parser enters the translation unit
scope; before that it is NULL and clang's walk runs `isa<>` on a null pointer, so this
wrapper gates on [`getCurLexicalContext`](@ref).
"""
function getFunctionLevelDeclContext(x::AbstractSema, allow_lambda::Bool=false)
    @check_ptrs x
    @assert getCurLexicalContext(x).ptr != C_NULL "Sema has no current declaration context"
    return DeclContext(clang_Sema_getFunctionLevelDeclContext(x, allow_lambda))
end

"""
    getCurFunctionDecl(x::AbstractSema, allow_lambda::Bool=false) -> FunctionDecl
Return the innermost enclosing function. The carrier holds NULL when the current context
is not inside a function. Same precondition as [`getFunctionLevelDeclContext`](@ref).
"""
function getCurFunctionDecl(x::AbstractSema, allow_lambda::Bool=false)
    @check_ptrs x
    @assert getCurLexicalContext(x).ptr != C_NULL "Sema has no current declaration context"
    return FunctionDecl(clang_Sema_getCurFunctionDecl(x, allow_lambda))
end

"""
    getCurFunctionOrMethodDecl(x::AbstractSema) -> NamedDecl
Return the C function or Objective-C method currently being parsed. The carrier holds NULL
otherwise. Same precondition as [`getFunctionLevelDeclContext`](@ref).
"""
function getCurFunctionOrMethodDecl(x::AbstractSema)
    @check_ptrs x
    @assert getCurLexicalContext(x).ptr != C_NULL "Sema has no current declaration context"
    return NamedDecl(clang_Sema_getCurFunctionOrMethodDecl(x))
end

"""
    IsFloatingPointPromotion(x::AbstractSema, from::AbstractQualType, to::AbstractQualType) -> Bool
Return whether converting `from` to `to` is a floating-point promotion. Both types must be
non-NULL: clang dereferences them without checking.
"""
function IsFloatingPointPromotion(x::AbstractSema, from::AbstractQualType, to::AbstractQualType)
    @check_ptrs x from to
    return clang_Sema_IsFloatingPointPromotion(x, from, to)
end

"""
    getStdNamespace(x::AbstractSema) -> NamespaceDecl
Return the `std` namespace. The carrier holds NULL until a declaration of `std` has been
seen in this translation unit.
"""
function getStdNamespace(x::AbstractSema)
    @check_ptrs x
    return NamespaceDecl(clang_Sema_getStdNamespace(x))
end

"""
    getStdBadAlloc(x::AbstractSema) -> CXXRecordDecl
Return `std::bad_alloc`. The carrier holds NULL until a declaration of it has been seen in
this translation unit.
"""
function getStdBadAlloc(x::AbstractSema)
    @check_ptrs x
    return CXXRecordDecl(clang_Sema_getStdBadAlloc(x))
end

"""
    isInitListConstructor(x::AbstractSema, ctor::AbstractFunctionDecl) -> Bool
Return whether `ctor` is an initializer-list constructor, i.e. its first parameter is a
(reference to) `std::initializer_list` and every later parameter has a default argument.
"""
function isInitListConstructor(x::AbstractSema, ctor::AbstractFunctionDecl)
    @check_ptrs x ctor
    return clang_Sema_isInitListConstructor(x, ctor)
end

"""
    isImplicitlyDeleted(x::AbstractSema, fd::AbstractFunctionDecl) -> Bool
Return whether `fd` is an implicitly-deleted special member function.
"""
function isImplicitlyDeleted(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_isImplicitlyDeleted(x, fd)
end

"""
    IsDerivedFrom(x::AbstractSema, loc::SourceLocation, derived, base) -> Bool
Return whether class type `derived` is derived from class type `base`, completing
`derived` at `loc` when it is still incomplete. Both types must be non-NULL: clang
dereferences them without checking.
"""
function IsDerivedFrom(x::AbstractSema, loc::SourceLocation, derived::AbstractQualType, base::AbstractQualType)
    @check_ptrs x derived base
    return clang_Sema_IsDerivedFrom(x, loc, derived, base)
end

"""
    getCurLexicalContext(x::AbstractSema) -> DeclContext
Return Sema's current lexical declaration context. The carrier holds NULL until the parser
has entered the translation unit scope.
"""
function getCurLexicalContext(x::AbstractSema)
    @check_ptrs x
    return DeclContext(clang_Sema_getCurLexicalContext(x))
end

# ODR-use marking, `auto` substitution and template-parameter deduction. These are the
# Sema entry points that can be driven without an active instantiation context; the
# overloads taking a MultiLevelTemplateArgumentList are not wrapped because Sema asserts
# its CodeSynthesisContexts stack is non-empty before it will substitute.

"""
    MarkUnusedFileScopedDecl(x::AbstractSema, d::AbstractDeclaratorDecl)
Record `d` on Sema's unused-file-scoped-declaration list. Sema itself filters the list
through `ShouldWarnIfUnusedFileScopedDecl`, so this is a no-op for anything clang would
not warn about, and is safe to call on any file-scope declarator.
"""
function MarkUnusedFileScopedDecl(x::AbstractSema, d::AbstractDeclaratorDecl)
    @check_ptrs x d
    clang_Sema_MarkUnusedFileScopedDecl(x, d)
    return nothing
end

"""
    MarkAnyDeclReferenced(x::AbstractSema, loc::SourceLocation, d::AbstractDecl, might_be_odr_use::Bool=true)
Mark `d` referenced at `loc`, dispatching on `d`'s kind. Pass `might_be_odr_use=false` only
when the absence of an odr-use cannot be determined from the current context.
"""
function MarkAnyDeclReferenced(x::AbstractSema, loc::SourceLocation, d::AbstractDecl, might_be_odr_use::Bool=true)
    @check_ptrs x d
    clang_Sema_MarkAnyDeclReferenced(x, loc, d, might_be_odr_use)
    return nothing
end

function MarkFunctionReferenced(x::AbstractSema, loc::SourceLocation, fd::AbstractFunctionDecl, might_be_odr_use::Bool=true)
    @check_ptrs x fd
    clang_Sema_MarkFunctionReferenced(x, loc, fd, might_be_odr_use)
    return nothing
end

function MarkVariableReferenced(x::AbstractSema, loc::SourceLocation, vd::AbstractVarDecl)
    @check_ptrs x vd
    clang_Sema_MarkVariableReferenced(x, loc, vd)
    return nothing
end

"""
    MarkDeclarationsReferencedInType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType)
Mark every declaration named inside `ty` as referenced at `loc`.
"""
function MarkDeclarationsReferencedInType(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType)
    @check_ptrs x ty
    clang_Sema_MarkDeclarationsReferencedInType(x, loc, ty)
    return nothing
end

"""
    MarkBaseAndMemberDestructorsReferenced(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl)
Mark the non-trivial destructors of `rd`'s bases and members referenced at `loc`. `rd` must
be a complete definition: the walk goes through the record's base and field ranges.
"""
function MarkBaseAndMemberDestructorsReferenced(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert isCompleteDefinition(rd) "the record must be a complete definition"
    clang_Sema_MarkBaseAndMemberDestructorsReferenced(x, loc, rd)
    return nothing
end

"""
    MarkVTableUsed(x::AbstractSema, loc::SourceLocation, cls::AbstractCXXRecordDecl, definition_required::Bool=false)
Note that `cls`'s vtable was used at `loc`. `cls` must be a complete definition — Sema's
first test is `isDynamicClass()`, which reads `CXXRecordDecl::data()`. Non-polymorphic and
dependent classes are then skipped by Sema itself, so this is a no-op for them.
"""
function MarkVTableUsed(x::AbstractSema, loc::SourceLocation, cls::AbstractCXXRecordDecl, definition_required::Bool=false)
    @check_ptrs x cls
    @assert isCompleteDefinition(cls) "the class must be a complete definition"
    clang_Sema_MarkVTableUsed(x, loc, cls, definition_required)
    return nothing
end

"""
    MarkVirtualMemberExceptionSpecsNeeded(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl)
Mark the exception specifications of `rd`'s virtual member functions as needed. `rd` must be
a complete definition — its method range is iterated.
"""
function MarkVirtualMemberExceptionSpecsNeeded(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert isCompleteDefinition(rd) "the record must be a complete definition"
    clang_Sema_MarkVirtualMemberExceptionSpecsNeeded(x, loc, rd)
    return nothing
end

"""
    MarkVirtualMembersReferenced(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl, constexpr_only::Bool=false)
Mark all virtual members of `rd` referenced at `loc`. `rd` must be a complete definition —
its method range is iterated.
"""
function MarkVirtualMembersReferenced(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl, constexpr_only::Bool=false)
    @check_ptrs x rd
    @assert isCompleteDefinition(rd) "the record must be a complete definition"
    clang_Sema_MarkVirtualMembersReferenced(x, loc, rd, constexpr_only)
    return nothing
end

"""
    CheckTemplateArgument(x::AbstractSema, arg::AbstractTypeSourceInfo) -> Bool
Check `arg` as a template *type* argument. Return `true` when it is not a valid one, in
which case a diagnostic has already been emitted into Sema's `DiagnosticsEngine`.
"""
function CheckTemplateArgument(x::AbstractSema, arg::AbstractTypeSourceInfo)
    @check_ptrs x arg
    return clang_Sema_CheckTemplateArgument(x, arg)
end

"""
    SubstAutoType(x::AbstractSema, type_with_auto::AbstractQualType, replacement::AbstractQualType) -> QualType
Substitute `replacement` for the `auto` in `type_with_auto`, retaining the `auto` sugar.

Unlike the `Subst*` overloads driven by a `MultiLevelTemplateArgumentList`, this runs as a
plain tree transform and requires no active instantiation context.
"""
function SubstAutoType(x::AbstractSema, type_with_auto::AbstractQualType, replacement::AbstractQualType)
    @check_ptrs x type_with_auto replacement
    return QualType(clang_Sema_SubstAutoType(x, type_with_auto, replacement))
end

"""
    SubstAutoTypeSourceInfo(x::AbstractSema, type_with_auto::AbstractTypeSourceInfo, replacement::AbstractQualType) -> TypeSourceInfo
The `TypeSourceInfo` form of [`SubstAutoType`](@ref); the result is ASTContext-owned.
"""
function SubstAutoTypeSourceInfo(x::AbstractSema, type_with_auto::AbstractTypeSourceInfo, replacement::AbstractQualType)
    @check_ptrs x type_with_auto replacement
    return TypeSourceInfo(clang_Sema_SubstAutoTypeSourceInfo(x, type_with_auto, replacement))
end

"""
    SubstAutoTypeDependent(x::AbstractSema, type_with_auto::AbstractQualType) -> QualType
Replace the `auto` in `type_with_auto` with a dependent `auto` type. No instantiation
context is required.
"""
function SubstAutoTypeDependent(x::AbstractSema, type_with_auto::AbstractQualType)
    @check_ptrs x type_with_auto
    return QualType(clang_Sema_SubstAutoTypeDependent(x, type_with_auto))
end

"""
    SubstAutoTypeSourceInfoDependent(x::AbstractSema, type_with_auto::AbstractTypeSourceInfo) -> TypeSourceInfo
The `TypeSourceInfo` form of [`SubstAutoTypeDependent`](@ref).
"""
function SubstAutoTypeSourceInfoDependent(x::AbstractSema, type_with_auto::AbstractTypeSourceInfo)
    @check_ptrs x type_with_auto
    return TypeSourceInfo(clang_Sema_SubstAutoTypeSourceInfoDependent(x, type_with_auto))
end

"""
    DeduceReturnType(x::AbstractSema, fd::AbstractFunctionDecl, loc::SourceLocation, diagnose::Bool=true) -> Bool
Deduce `fd`'s return type, instantiating its body when `fd` is a template instantiation.
Return `true` when deduction failed.

`fd`'s return type must still be an undeduced `auto` — Sema has nothing to deduce otherwise,
and the wrapper rejects the call rather than letting clang walk a deduced type.
"""
function DeduceReturnType(x::AbstractSema, fd::AbstractFunctionDecl, loc::SourceLocation, diagnose::Bool=true)
    @check_ptrs x fd
    @assert isUndeducedType(getTypePtr(getReturnType(fd))) "the return type must still be an undeduced `auto`"
    return clang_Sema_DeduceReturnType(x, fd, loc, diagnose)
end

"""
    MarkDeducedTemplateParameters(x::AbstractSema, ftd::AbstractFunctionTemplateDecl) -> Vector{Bool}
Return one flag per template parameter of `ftd`, `true` when that parameter is deducible
from the templated function's parameter types. Reads nothing but the template's own
declaration, so it is safe outside an instantiation.
"""
function MarkDeducedTemplateParameters(x::AbstractSema, ftd::AbstractFunctionTemplateDecl)
    @check_ptrs x ftd
    n = Int(size(getTemplateParameters(ftd)))
    deduced = fill(false, n)
    n > 0 && clang_Sema_MarkDeducedTemplateParameters(x, ftd, deduced, UInt32(n))
    return deduced
end

"""
    InstantiateDefaultArgument(x::AbstractSema, call_loc::SourceLocation, fd::AbstractFunctionDecl, param::ParmVarDecl) -> Bool
Instantiate `param`'s default argument for a call to `fd` at `call_loc`. Return `true` on
error. `param` must still carry an uninstantiated default argument.
"""
function InstantiateDefaultArgument(x::AbstractSema, call_loc::SourceLocation, fd::AbstractFunctionDecl, param::ParmVarDecl)
    @check_ptrs x fd param
    @assert hasUninstantiatedDefaultArg(param) "the parameter has no uninstantiated default argument"
    return clang_Sema_InstantiateDefaultArgument(x, call_loc, fd, param)
end

"""
    InstantiateExceptionSpec(x::AbstractSema, loc::SourceLocation, fd::AbstractFunctionDecl)
Instantiate `fd`'s exception specification when it is still uninstantiated; a no-op
otherwise. `fd`'s type must be a `FunctionProtoType` — Sema reaches it with an unchecked
`castAs<>`.
"""
function InstantiateExceptionSpec(x::AbstractSema, loc::SourceLocation, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    @assert isFunctionProtoType(getTypePtr(getType(fd))) "the function must have a prototype"
    clang_Sema_InstantiateExceptionSpec(x, loc, fd)
    return nothing
end

"""
    InstantiateFunctionDeclaration(x::AbstractSema, ftd::AbstractFunctionTemplateDecl, args::TemplateArgumentList, loc::SourceLocation) -> FunctionDecl
Instantiate — or find the existing instantiation of — `ftd` with `args`, producing the
function *declaration* only; its body comes from
[`InstantiateFunctionDefinition`](@ref). `args` must be a converted argument list holding
one argument per template parameter of `ftd`. The returned carrier holds NULL when the
substitution failed.
"""
function InstantiateFunctionDeclaration(x::AbstractSema, ftd::AbstractFunctionTemplateDecl, args::TemplateArgumentList, loc::SourceLocation)
    @check_ptrs x ftd args
    @assert size(args) == size(getTemplateParameters(ftd)) "one template argument per template parameter is required"
    return FunctionDecl(clang_Sema_InstantiateFunctionDeclaration(x, ftd, args, loc))
end

# --- Type builders (Sema's checked counterparts of the ASTContext type factories) ---
# Each one diagnoses the ill-formed cases through Sema and returns a NULL-carrying
# `QualType`, so callers should test `qt.ptr != C_NULL` before using the result.

"""
    BuildQualifiedType(x::AbstractSema, ty, loc, quals) -> QualType
Apply the `clang::Qualifiers` set `quals` to `ty`, checking the combination.

`quals` is the opaque `Qualifiers` encoding — the value [`fromCVRMask`](@ref) builds and
[`getQualifiersAsOpaqueValue`](@ref) returns, not a bare CVR mask.
"""
function BuildQualifiedType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation, quals::Integer)
    @check_ptrs x ty
    return QualType(clang_Sema_BuildQualifiedType(x, ty, loc, UInt32(quals)))
end

"""
    BuildPointerType(x::AbstractSema, ty, loc, entity=DeclarationName(C_NULL)) -> QualType
Build a pointer to `ty`, diagnosing at `loc` when that is ill-formed.

`clang::Sema::BuildPointerType` asserts that `ty` is not an Objective-C object type — such a
type has to become an `ObjCObjectPointerType` instead — so the wrapper restates it.
"""
function BuildPointerType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x ty
    @assert !isObjCObjectType(getTypePtr(ty)) "an ObjC object type needs an ObjC object pointer"
    return QualType(clang_Sema_BuildPointerType(x, ty, loc, entity))
end

"""
    BuildReferenceType(x::AbstractSema, ty, lvalue_ref, loc, entity=DeclarationName(C_NULL)) -> QualType
Build an lvalue (`lvalue_ref=true`) or rvalue reference to `ty`.

`clang::Sema::BuildReferenceType` asserts that `ty` is not the unresolved-overload
placeholder type; the wrapper rejects every placeholder type, which is the observable
superset of that condition.
"""
function BuildReferenceType(x::AbstractSema, ty::AbstractQualType, lvalue_ref::Bool, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x ty
    @assert !isPlaceholderType(getTypePtr(ty)) "a placeholder type has no reference type"
    return QualType(clang_Sema_BuildReferenceType(x, ty, lvalue_ref, loc, entity))
end

"""
    BuildArrayType(x::AbstractSema, ty, asm, array_size, quals, brackets, entity=DeclarationName(C_NULL)) -> QualType
Build an array of `ty`, diagnosing the ill-formed element types.

`array_size` may be a NULL-carrying `Expr_`, which builds an incomplete array type; `quals`
is the index type's CVR qualifier mask.
"""
function BuildArrayType(x::AbstractSema, ty::AbstractQualType, asm::CXArraySizeModifier, array_size::AbstractExpr, quals::Integer, brackets::SourceRange, entity::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x ty
    return QualType(clang_Sema_BuildArrayType(x, ty, asm, array_size, UInt32(quals), getBeginLoc(brackets), getEndLoc(brackets), entity))
end

"""
    BuildVectorType(x::AbstractSema, ty, vec_size, attr_loc) -> QualType
Build a GCC `vector_size` vector of `ty`.

`vec_size` is the vector's size in **bytes** and must be an integer constant expression that
is a whole multiple of `ty`'s size; `BuildExtVectorType` instead counts elements.
"""
function BuildVectorType(x::AbstractSema, ty::AbstractQualType, vec_size::AbstractExpr, attr_loc::SourceLocation)
    @check_ptrs x ty vec_size
    return QualType(clang_Sema_BuildVectorType(x, ty, vec_size, attr_loc))
end

"""
    BuildExtVectorType(x::AbstractSema, ty, array_size, attr_loc) -> QualType
Build an OpenCL-style `ext_vector_type` of `ty` with `array_size` **elements**.
"""
function BuildExtVectorType(x::AbstractSema, ty::AbstractQualType, array_size::AbstractExpr, attr_loc::SourceLocation)
    @check_ptrs x ty array_size
    return QualType(clang_Sema_BuildExtVectorType(x, ty, array_size, attr_loc))
end

"""
    BuildMemberPointerType(x::AbstractSema, ty, cls, loc, entity=DeclarationName(C_NULL)) -> QualType
Build a pointer to the member `ty` of the class type `cls`.
"""
function BuildMemberPointerType(x::AbstractSema, ty::AbstractQualType, cls::AbstractQualType, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x ty cls
    return QualType(clang_Sema_BuildMemberPointerType(x, ty, cls, loc, entity))
end

"""
    BuildBlockPointerType(x::AbstractSema, ty, loc, entity=DeclarationName(C_NULL)) -> QualType
Build a block pointer to the function type `ty`. Sema diagnoses a non-function `ty`.
"""
function BuildBlockPointerType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x ty
    return QualType(clang_Sema_BuildBlockPointerType(x, ty, loc, entity))
end

function BuildParenType(x::AbstractSema, ty::AbstractQualType)
    @check_ptrs x ty
    return QualType(clang_Sema_BuildParenType(x, ty))
end

"""
    BuildAtomicType(x::AbstractSema, ty, loc) -> QualType
Build `_Atomic(ty)`, diagnosing the element types C11 disallows (arrays, functions,
references, already-atomic, qualified, non-trivially-copyable and over-aligned types).
"""
function BuildAtomicType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuildAtomicType(x, ty, loc))
end

"""
    BuildBitIntType(x::AbstractSema, is_unsigned, bit_width, loc) -> QualType
Build a `_BitInt(bit_width)` type. `bit_width` must be an integer constant expression.
"""
function BuildBitIntType(x::AbstractSema, is_unsigned::Bool, bit_width::AbstractExpr, loc::SourceLocation)
    @check_ptrs x bit_width
    return QualType(clang_Sema_BuildBitIntType(x, is_unsigned, bit_width, loc))
end

"""
    BuildTypeofExprType(x::AbstractSema, e, kind=CXTypeOfKind_Qualified) -> QualType
Build the `typeof(e)` (or C23 `typeof_unqual(e)`) type.

`clang::Sema::BuildTypeofExprType` asserts that `e` carries no placeholder type, so the
wrapper restates that precondition.
"""
function BuildTypeofExprType(x::AbstractSema, e::AbstractExpr, kind::CXTypeOfKind=CXTypeOfKind_Qualified)
    @check_ptrs x e
    @assert !hasPlaceholderType(e) "the operand must not have a placeholder type"
    return QualType(clang_Sema_BuildTypeofExprType(x, e, kind))
end

"""
    BuildDecltypeType(x::AbstractSema, e, as_unevaluated=true) -> QualType
Build the `decltype(e)` type. Pass `as_unevaluated=false` to treat `e` as an evaluated
operand, the way `decltype(auto)` deduction does.

`clang::Sema::BuildDecltypeType` asserts that `e` carries no placeholder type, so the
wrapper restates that precondition.
"""
function BuildDecltypeType(x::AbstractSema, e::AbstractExpr, as_unevaluated::Bool=true)
    @check_ptrs x e
    @assert !hasPlaceholderType(e) "the operand must not have a placeholder type"
    return QualType(clang_Sema_BuildDecltypeType(x, e, as_unevaluated))
end

"""
    BuildUnaryTransformType(x::AbstractSema, ty, kind, loc) -> QualType
Build the `__add_pointer`-style transform-trait type `kind` over `ty`, running Sema's
checks (unlike [`getUnaryTransformType`](@ref), which takes the already-computed result).
"""
function BuildUnaryTransformType(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuildUnaryTransformType(x, ty, kind, loc))
end

# --- Expression builders ---
# `clang::ExprResult` is a discriminated (invalid, value) pair. It crosses the C boundary
# split (MARSHALLING.md §8) and surfaces here as `nothing` for an invalid result versus an
# `Expr_` carrier for a valid one — a carrier holding NULL is a valid-but-empty result, not
# an error. Every node returned is ASTContext-arena memory and is never disposed.

"""
    CreateBuiltinUnaryOp(x::AbstractSema, op_loc, opc, input, is_after_amp=false)
Build the built-in (non-overloaded) unary operator `opc` over `input`.

Return `nothing` when Sema rejected the operand, otherwise the built expression.
"""
function CreateBuiltinUnaryOp(x::AbstractSema, op_loc::SourceLocation, opc::CXUnaryOperatorKind, input::AbstractExpr, is_after_amp::Bool=false)
    @check_ptrs x input
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateBuiltinUnaryOp(x, op_loc, opc, input, is_after_amp, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CreateUnaryExprOrTypeTraitExpr(x::AbstractSema, tsi, op_loc, kind, rng)
Build `sizeof`/`alignof`/`vec_step` over the type described by the `TypeSourceInfo` `tsi`.

Return `nothing` when Sema rejected the operand type.
"""
function CreateUnaryExprOrTypeTraitExpr(x::AbstractSema, tsi::AbstractTypeSourceInfo, op_loc::SourceLocation, kind::CXUnaryExprOrTypeTrait, rng::SourceRange)
    @check_ptrs x tsi
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateUnaryExprOrTypeTraitExpr(x, tsi, op_loc, kind, getBeginLoc(rng), getEndLoc(rng), invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CreateBuiltinArraySubscriptExpr(x::AbstractSema, base, lloc, idx, rloc)
Build the built-in (non-overloaded) `base[idx]` subscript expression.

Return `nothing` when Sema rejected the operands.
"""
function CreateBuiltinArraySubscriptExpr(x::AbstractSema, base::AbstractExpr, lloc::SourceLocation, idx::AbstractExpr, rloc::SourceLocation)
    @check_ptrs x base idx
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateBuiltinArraySubscriptExpr(x, base, lloc, idx, rloc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CreateBuiltinBinOp(x::AbstractSema, op_loc, opc, lhs, rhs)
Build the built-in (non-overloaded) binary operator `opc` over `lhs` and `rhs`, running the
usual arithmetic conversions.

Return `nothing` when Sema rejected the operands.
"""
function CreateBuiltinBinOp(x::AbstractSema, op_loc::SourceLocation, opc::CXBinaryOperatorKind, lhs::AbstractExpr, rhs::AbstractExpr)
    @check_ptrs x lhs rhs
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateBuiltinBinOp(x, op_loc, opc, lhs, rhs, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildInitList(x::AbstractSema, lbrace_loc, inits, rbrace_loc)
Build a syntactic `InitListExpr` over `inits`.

The resulting node has the placeholder type `void` until initialization sequences give it a
real one, matching `clang::Sema::BuildInitList`. Return `nothing` when Sema rejected an
initializer.
"""
function BuildInitList(x::AbstractSema, lbrace_loc::SourceLocation, inits::AbstractVector{<:AbstractExpr}, rbrace_loc::SourceLocation)
    @check_ptrs x
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in inits]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildInitList(x, lbrace_loc, ptrs, length(ptrs), rbrace_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXNoexceptExpr(x::AbstractSema, key_loc, operand, rparen_loc)
Build `noexcept(operand)`, computing whether the operand can throw.

Return `nothing` when Sema rejected the operand.
"""
function BuildCXXNoexceptExpr(x::AbstractSema, key_loc::SourceLocation, operand::AbstractExpr, rparen_loc::SourceLocation)
    @check_ptrs x operand
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXNoexceptExpr(x, key_loc, operand, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CheckFunctionReturnType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> Bool
Return `true` when `ty` cannot be used as a function return type — an array or function
type, or an abstract class — emitting the diagnostic at `loc`.
"""
function CheckFunctionReturnType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return clang_Sema_CheckFunctionReturnType(x, ty, loc)
end

"""
    ResolveExceptionSpec(x::AbstractSema, loc::SourceLocation, fpt::AbstractFunctionProtoType) -> FunctionProtoType
Resolve a deferred exception specification, returning the `FunctionProtoType` that carries
the resolved spec — `fpt` itself when the spec needed no resolution. The returned carrier
holds NULL when resolution failed.

`fpt`'s exception specification must have been parsed: Sema diagnoses `EST_Unparsed`
instead of resolving it, so the wrapper rejects that case first.
"""
function ResolveExceptionSpec(x::AbstractSema, loc::SourceLocation, fpt::AbstractFunctionProtoType)
    @check_ptrs x fpt
    est = getExceptionSpecType(fpt)
    @assert est != CXExceptionSpecificationType_EST_Unparsed "unparsed exception spec"
    return FunctionProtoType(clang_Sema_ResolveExceptionSpec(x, loc, fpt))
end

"""
    CheckDistantExceptionSpec(x::AbstractSema, ty::AbstractQualType) -> Bool
Return `true` when `ty` is a pointer (or pointer-to-member) to a function type that carries
an exception specification. Always `false` under C++17 and later, where the specification is
part of the function type itself. Never diagnoses.
"""
function CheckDistantExceptionSpec(x::AbstractSema, ty::AbstractQualType)
    @check_ptrs x ty
    return clang_Sema_CheckDistantExceptionSpec(x, ty)
end

"""
    CheckTypeTraitArity(x::AbstractSema, arity::Integer, loc::SourceLocation, n::Integer) -> Bool
Return `true` when `n` arguments satisfy a type trait declared with arity `arity` (`0` means
variadic, and then `n` must be non-zero). Diagnoses at `loc` on a mismatch.
"""
function CheckTypeTraitArity(x::AbstractSema, arity::Integer, loc::SourceLocation, n::Integer)
    @check_ptrs x
    return clang_Sema_CheckTypeTraitArity(x, UInt32(arity), loc, UInt(n))
end

"""
    CheckCaseExpression(x::AbstractSema, e::AbstractExpr) -> Bool
Return `true` when `e` is usable as a `case` label expression: dependent, or an integral
constant expression of integral or enumeration type. Never diagnoses.
"""
function CheckCaseExpression(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return clang_Sema_CheckCaseExpression(x, e)
end

"""
    DeclareImplicitDefaultConstructor(x::AbstractSema, rd::AbstractCXXRecordDecl) -> CXXConstructorDecl
Declare the implicit default constructor of `rd` and return it.

`rd` must still need one: clang asserts `needsImplicitDefaultConstructor`, and a second call
would add a duplicate declaration of the same member.
"""
function DeclareImplicitDefaultConstructor(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert needsImplicitDefaultConstructor(rd) "the class needs no implicit default ctor"
    return CXXConstructorDecl(clang_Sema_DeclareImplicitDefaultConstructor(x, rd))
end

"""
    DeclareImplicitDestructor(x::AbstractSema, rd::AbstractCXXRecordDecl) -> CXXDestructorDecl
Declare the implicit destructor of `rd` and return it.

`rd` must still need one: clang asserts `needsImplicitDestructor`, and a second call would
add a duplicate declaration of the same member.
"""
function DeclareImplicitDestructor(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert needsImplicitDestructor(rd) "the class needs no implicit destructor"
    return CXXDestructorDecl(clang_Sema_DeclareImplicitDestructor(x, rd))
end

"""
    DeclareImplicitCopyConstructor(x::AbstractSema, rd::AbstractCXXRecordDecl) -> CXXConstructorDecl
Declare the implicit copy constructor of `rd` and return it.

`rd` must still need one: clang asserts `needsImplicitCopyConstructor`, and a second call
would add a duplicate declaration of the same member.
"""
function DeclareImplicitCopyConstructor(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert needsImplicitCopyConstructor(rd) "the class needs no implicit copy ctor"
    return CXXConstructorDecl(clang_Sema_DeclareImplicitCopyConstructor(x, rd))
end

"""
    DeclareImplicitMoveConstructor(x::AbstractSema, rd::AbstractCXXRecordDecl) -> CXXConstructorDecl
Declare the implicit move constructor of `rd` and return it. The carrier holds NULL when the
move constructor is not implicitly declared for `rd`.

`rd` must still need one: clang asserts `needsImplicitMoveConstructor`, and a second call
would add a duplicate declaration of the same member.
"""
function DeclareImplicitMoveConstructor(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert needsImplicitMoveConstructor(rd) "the class needs no implicit move ctor"
    return CXXConstructorDecl(clang_Sema_DeclareImplicitMoveConstructor(x, rd))
end

"""
    DeclareImplicitCopyAssignment(x::AbstractSema, rd::AbstractCXXRecordDecl) -> CXXMethodDecl
Declare the implicit copy assignment operator of `rd` and return it.

`rd` must still need one: clang asserts `needsImplicitCopyAssignment`, and a second call
would add a duplicate declaration of the same member.
"""
function DeclareImplicitCopyAssignment(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert needsImplicitCopyAssignment(rd) "the class needs no implicit copy assignment"
    return CXXMethodDecl(clang_Sema_DeclareImplicitCopyAssignment(x, rd))
end

"""
    DeclareImplicitMoveAssignment(x::AbstractSema, rd::AbstractCXXRecordDecl) -> CXXMethodDecl
Declare the implicit move assignment operator of `rd` and return it. The carrier holds NULL
when the move assignment operator is not implicitly declared for `rd`.

`rd` must still need one: clang asserts `needsImplicitMoveAssignment`, and a second call
would add a duplicate declaration of the same member.
"""
function DeclareImplicitMoveAssignment(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert needsImplicitMoveAssignment(rd) "the class needs no implicit move assignment"
    return CXXMethodDecl(clang_Sema_DeclareImplicitMoveAssignment(x, rd))
end

"""
    DeclareGlobalNewDelete(x::AbstractSema)
Declare the implicit global `operator new` / `operator delete` overloads. Idempotent — Sema
remembers that it has already run.
"""
function DeclareGlobalNewDelete(x::AbstractSema)
    @check_ptrs x
    clang_Sema_DeclareGlobalNewDelete(x)
    return nothing
end

"""
    FindUsualDeallocationFunction(x::AbstractSema, loc, can_provide_size, overaligned, name) -> FunctionDecl
The usual deallocation function named `name`, which is an operator name built with
`getCXXOperatorName(getDeclarationNames(ctx), CXOverloadedOperatorKind_OO_Delete)` or its
array form. The global `operator new`/`operator delete` set is declared first. The returned
carrier holds NULL when no overload is viable.
"""
function FindUsualDeallocationFunction(x::AbstractSema, loc::SourceLocation, can_provide_size::Bool, overaligned::Bool, name::DeclarationName)
    @check_ptrs x
    return FunctionDecl(clang_Sema_FindUsualDeallocationFunction(x, loc, can_provide_size, overaligned, name))
end

"""
    FindDeallocationFunctionForDestructor(x::AbstractSema, loc::SourceLocation, rd) -> FunctionDecl
The `operator delete` that a destructor of `rd` would call. The returned carrier holds NULL
when none is viable; an ambiguous class-level `operator delete` is diagnosed at `loc`.
"""
function FindDeallocationFunctionForDestructor(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    return FunctionDecl(clang_Sema_FindDeallocationFunctionForDestructor(x, loc, rd))
end

"""
    FindFirstQualifierInScope(x::AbstractSema, sp::AbstractScope, nns) -> NamedDecl
Look the leading component of the nested-name-specifier `nns` up in scope `sp`. The returned
carrier holds NULL when that component is not an identifier or the lookup is not a single
result.
"""
function FindFirstQualifierInScope(x::AbstractSema, sp::AbstractScope, nns::AbstractNestedNameSpecifier)
    @check_ptrs x sp nns
    return NamedDecl(clang_Sema_FindFirstQualifierInScope(x, sp, nns))
end

"""
    CheckDerivedToBaseConversion(x::AbstractSema, derived, base, loc, rng, ignore_access=false) -> Bool
Return `true` when the `derived` → `base` conversion is ill-formed — the base is ambiguous,
or it is inaccessible and `ignore_access` is `false` — diagnosing at `loc` over `rng`.

`derived` must actually derive from `base`: clang asserts that the base-path walk succeeds,
so the wrapper checks the derivation through the two record declarations first.
"""
function CheckDerivedToBaseConversion(x::AbstractSema, derived::QualType, base::QualType, loc::SourceLocation, rng::SourceRange, ignore_access::Bool=false)
    @check_ptrs x derived base
    drd = getAsCXXRecordDecl(getTypePtr(derived))
    brd = getAsCXXRecordDecl(getTypePtr(base))
    @assert drd.ptr != C_NULL && brd.ptr != C_NULL "both types must designate a class"
    @assert isDerivedFrom(drd, brd) "the first type must derive from the second"
    return clang_Sema_CheckDerivedToBaseConversion(x, derived, base, loc, getBeginLoc(rng), getEndLoc(rng), ignore_access)
end

"""
    CheckIfOverriddenFunctionIsMarkedFinal(x::AbstractSema, new_md, old_md) -> Bool
Return `true` when `old_md` carries the `final` attribute, in which case the illegal
override by `new_md` is diagnosed.
"""
function CheckIfOverriddenFunctionIsMarkedFinal(x::AbstractSema, new_md::AbstractCXXMethodDecl, old_md::AbstractCXXMethodDecl)
    @check_ptrs x new_md old_md
    return clang_Sema_CheckIfOverriddenFunctionIsMarkedFinal(x, new_md, old_md)
end

"""
    getCurrentModule(x::AbstractSema) -> Module_
The module unit whose scope is currently open. The carrier holds NULL when no module scope
is open, which is the ordinary case for a translation unit that declares no module.
"""
function getCurrentModule(x::AbstractSema)
    @check_ptrs x
    return Module_(clang_Sema_getCurrentModule(x))
end

"""
    hasStructuralCompatLayout(x::AbstractSema, d::AbstractDecl, suggested::AbstractDecl) -> Bool
Return `true` when `d` and `suggested` have structurally compatible layouts in the sense of
C11 6.2.7/1.

clang runs the structural-equivalence walk with complaints enabled, so a mismatch between two
tag declarations is reported through this Sema's `DiagnosticsEngine`.
"""
function hasStructuralCompatLayout(x::AbstractSema, d::AbstractDecl, suggested::AbstractDecl)
    @check_ptrs x d suggested
    return clang_Sema_hasStructuralCompatLayout(x, d, suggested)
end

"""
    getSpecialMember(x::AbstractSema, md::AbstractCXXMethodDecl) -> CXCXXSpecialMember
Classify `md` as one of the six C++ special members, or as
`CXCXXSpecialMember_CXXInvalid` when it is an ordinary member function.
"""
function getSpecialMember(x::AbstractSema, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    return clang_Sema_getSpecialMember(x, md)
end

"""
    IsOverload(x::AbstractSema, new_fd, old_fd, use_member_using_decl_rules=false,
               consider_cuda_attrs=true) -> Bool
Return `true` when `new_fd` is an overload of `old_fd` rather than a redeclaration of it.

`use_member_using_decl_rules` selects the relaxed comparison a member `using` declaration
needs; `consider_cuda_attrs` lets the CUDA host/device attributes distinguish two otherwise
identical declarations.
"""
function IsOverload(x::AbstractSema, new_fd::AbstractFunctionDecl, old_fd::AbstractFunctionDecl, use_member_using_decl_rules::Bool=false, consider_cuda_attrs::Bool=true)
    @check_ptrs x new_fd old_fd
    return clang_Sema_IsOverload(x, new_fd, old_fd, use_member_using_decl_rules, consider_cuda_attrs)
end

"""
    IsOverride(x::AbstractSema, md, base_md, use_member_using_decl_rules=false,
               consider_cuda_attrs=true) -> Bool
Return `true` when `md` would override the base-class method `base_md`. The object parameters
are ignored by the comparison, so this answers the signature question alone — it does not ask
whether the two classes are related.
"""
function IsOverride(x::AbstractSema, md::AbstractFunctionDecl, base_md::AbstractFunctionDecl, use_member_using_decl_rules::Bool=false, consider_cuda_attrs::Bool=true)
    @check_ptrs x md base_md
    return clang_Sema_IsOverride(x, md, base_md, use_member_using_decl_rules, consider_cuda_attrs)
end

"""
    IsComplexPromotion(x::AbstractSema, from::AbstractQualType, to::AbstractQualType) -> Bool
Return `true` when `from` → `to` is a complex promotion: both must be `_Complex` types whose
element types are related by a floating-point or integral promotion. A non-complex operand
simply answers `false`.

Both arguments must be non-NULL: clang dereferences them without checking.
"""
function IsComplexPromotion(x::AbstractSema, from::AbstractQualType, to::AbstractQualType)
    @check_ptrs x from to
    return clang_Sema_IsComplexPromotion(x, from, to)
end

"""
    isKnownName(x::AbstractSema, name::AbstractString) -> Bool
Return `true` when `name` resolves to an ordinary name in the translation-unit scope.

The lookup interns `name` in the identifier table, so asking about an unknown name still
creates an `IdentifierInfo` for it.
"""
function isKnownName(x::AbstractSema, name::AbstractString)
    @check_ptrs x
    return clang_Sema_isKnownName(x, name)
end

"""
    isAcceptableNestedNameSpecifier(x::AbstractSema, sd::AbstractNamedDecl) -> (Bool, Bool)
Return whether `sd` may appear as a nested-name-specifier, together with clang's
`CanCorrect` out-parameter: when the first half is `false`, the second says whether typo
correction may still offer `sd` as a candidate.

Namespaces, namespace aliases and class types are acceptable; an enumeration only in C++11
and later.
"""
function isAcceptableNestedNameSpecifier(x::AbstractSema, sd::AbstractNamedDecl)
    @check_ptrs x sd
    can_correct = Ref{Bool}(true)
    acceptable = clang_Sema_isAcceptableNestedNameSpecifier(x, sd, can_correct)
    return acceptable, can_correct[]
end

"""
    isValidPointerAttrType(x::AbstractSema, t::AbstractQualType, ref_okay=false) -> Bool
Return `true` when `t` is a valid subject for `nonnull` and the similar pointer attributes —
any pointer or block-pointer type, or a transparent union holding one. References are looked
through unless `ref_okay` is `true`, in which case a reference type is itself accepted.
"""
function isValidPointerAttrType(x::AbstractSema, t::AbstractQualType, ref_okay::Bool=false)
    @check_ptrs x t
    return clang_Sema_isValidPointerAttrType(x, t, ref_okay)
end

"""
    hasExplicitCallingConv(x::AbstractSema, t::AbstractQualType) -> Bool
Return `true` when `t` carries a calling-convention attribute written on the declarator
itself. The walk stops at the first typedef, so a convention inherited through a typedef does
not count.
"""
function hasExplicitCallingConv(x::AbstractSema, t::AbstractQualType)
    @check_ptrs x t
    return clang_Sema_hasExplicitCallingConv(x, t)
end

"""
    getCallingConvAttributedType(x::AbstractSema, t::AbstractQualType) -> AttributedType
The outermost `AttributedType` node of `t` that sets a calling convention. The carrier holds
NULL when there is none.
"""
function getCallingConvAttributedType(x::AbstractSema, t::AbstractQualType)
    @check_ptrs x t
    return AttributedType(clang_Sema_getCallingConvAttributedType(x, t))
end

"""
    getCurrentThisType(x::AbstractSema) -> QualType
The type of `this` in the current context. The returned `QualType` is null outside an
implicit-object member function.

clang walks up from the current declaration context to the enclosing function-level one, so
the wrapper gates on [`getCurLexicalContext`](@ref) exactly as
[`getFunctionLevelDeclContext`](@ref) does.
"""
function getCurrentThisType(x::AbstractSema)
    @check_ptrs x
    @assert getCurLexicalContext(x).ptr != C_NULL "Sema has no current declaration context"
    return QualType(clang_Sema_getCurrentThisType(x))
end

"""
    isUnexpandedParameterPackPermitted(x::AbstractSema) -> Bool
Return `true` when an unexpanded parameter pack could legally appear here, i.e. when some
enclosing function scope is a lambda. Used by clang for error recovery.
"""
function isUnexpandedParameterPackPermitted(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isUnexpandedParameterPackPermitted(x)
end

"""
    inTemplateInstantiation(x::AbstractSema) -> Bool
Return `true` while a template instantiation is in progress, i.e. while the code-synthesis
stack holds more than the entries that are not instantiations.
"""
function inTemplateInstantiation(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_inTemplateInstantiation(x)
end

"""
    isConstantEvaluatedContext(x::AbstractSema) -> Bool
Return `true` when the innermost expression-evaluation context is constant-evaluated.

The evaluation-context stack is never empty — Sema's constructor pushes a potentially-evaluated
entry — so this and its four siblings below are total.
"""
function isConstantEvaluatedContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isConstantEvaluatedContext(x)
end

"""
    isAlwaysConstantEvaluatedContext(x::AbstractSema) -> Bool
Return `true` when the innermost expression-evaluation context is constant-evaluated
unconditionally, i.e. not merely inside a conditionally-constant-evaluated construct.
"""
function isAlwaysConstantEvaluatedContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isAlwaysConstantEvaluatedContext(x)
end

"""
    isUnevaluatedContext(x::AbstractSema) -> Bool
Return `true` when the innermost expression-evaluation context is unevaluated per C++ [expr]p5
— the operand of `sizeof`, `decltype`, an unevaluated `typeid`, and so on.
"""
function isUnevaluatedContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isUnevaluatedContext(x)
end

"""
    isImmediateFunctionContext(x::AbstractSema) -> Bool
Return `true` when the innermost expression-evaluation context is an immediate-function
context, i.e. the body of a `consteval` function or an immediate invocation.
"""
function isImmediateFunctionContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isImmediateFunctionContext(x)
end

"""
    isCheckingDefaultArgumentOrInitializer(x::AbstractSema) -> Bool
Return `true` while a default argument or a default member initializer is being checked.
"""
function isCheckingDefaultArgumentOrInitializer(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isCheckingDefaultArgumentOrInitializer(x)
end

"""
    isPreciseFPEnabled(x::AbstractSema) -> Bool
Return `true` when precise floating-point semantics are in force, i.e. when none of
reassociation, no-signed-zero, reciprocal and approximate-function relaxation is enabled in
the current `FPFeatures`.
"""
function isPreciseFPEnabled(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isPreciseFPEnabled(x)
end

# --- Declaration, expression and trait node builders ---
# The `ExprResult` convention of the expression builders above holds here too: `nothing` is
# an invalid result and an `Expr_` carrier a valid one. The builders whose C++ return type is
# a node pointer rather than a `*Result` — `BuildParmVarDeclForTypedef`, `BuildDeclRefExpr`,
# `CreateMaterializeTemporaryExpr`, `BuildStaticAssertDeclaration` — carry no discriminator
# and return their carrier directly, NULL on failure. Every node is ASTContext-arena memory.

"""
    BuildReadPipeType(x::AbstractSema, ty, loc) -> QualType
Build the OpenCL `read_only pipe` type whose element type is `ty`, diagnosing at `loc`.
"""
function BuildReadPipeType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuildReadPipeType(x, ty, loc))
end

"""
    BuildWritePipeType(x::AbstractSema, ty, loc) -> QualType
Build the OpenCL `write_only pipe` type whose element type is `ty`, diagnosing at `loc`.
"""
function BuildWritePipeType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuildWritePipeType(x, ty, loc))
end

"""
    BuildParmVarDeclForTypedef(x::AbstractSema, dc, loc, ty) -> ParmVarDecl
Create the implicit, unnamed parameter of type `ty` in `dc` that a function typedef's
parameter list is built from. The parameter is not attached to any function.
"""
function BuildParmVarDeclForTypedef(x::AbstractSema, dc::AbstractDeclContext, loc::SourceLocation, ty::AbstractQualType)
    @check_ptrs x dc ty
    return ParmVarDecl(clang_Sema_BuildParmVarDeclForTypedef(x, dc, loc, ty))
end

"""
    CreateRecoveryExpr(x::AbstractSema, begin_loc, end_loc, subexprs, ty=QualType(C_NULL))
Build the `RecoveryExpr` that stands in for a node Sema could not create, preserving
`subexprs` as its children and `ty` as its type.

Return `nothing` when `LangOptions`'s `RecoveryAST` is off — the only way this builder fails.
"""
function CreateRecoveryExpr(x::AbstractSema, begin_loc::SourceLocation, end_loc::SourceLocation, subexprs::AbstractVector{<:AbstractExpr}, ty::AbstractQualType=QualType(C_NULL))
    @check_ptrs x
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in subexprs]
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateRecoveryExpr(x, begin_loc, end_loc, ptrs, length(ptrs), ty, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildDeclRefExpr(x::AbstractSema, d, ty, vk, loc, ss=CXXScopeSpec(C_NULL)) -> DeclRefExpr
Build a reference to `d` of type `ty` and value kind `vk`, marking `d` referenced in Sema's
current context. `ss` may be a NULL `CXXScopeSpec`, meaning the reference is unqualified.
"""
function BuildDeclRefExpr(x::AbstractSema, d::AbstractValueDecl, ty::AbstractQualType, vk::CXExprValueKind, loc::SourceLocation, ss::AbstractCXXScopeSpec=CXXScopeSpec(C_NULL))
    @check_ptrs x d ty
    return DeclRefExpr(clang_Sema_BuildDeclRefExpr(x, d, ty, vk, loc, ss))
end

"""
    BuildUnaryOp(x::AbstractSema, sp, op_loc, opc, input, is_after_amp=false)
Build the unary operator `opc` over `input`, considering the overloaded `operator`
candidates visible from `sp`.

`sp` may be a NULL `Scope`, in which case no overload lookup runs and the result is the
built-in operator. Return `nothing` when Sema rejected the operand.
"""
function BuildUnaryOp(x::AbstractSema, sp::AbstractScope, op_loc::SourceLocation, opc::CXUnaryOperatorKind, input::AbstractExpr, is_after_amp::Bool=false)
    @check_ptrs x input
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildUnaryOp(x, sp, op_loc, opc, input, is_after_amp, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCallExpr(x::AbstractSema, sp, fn, lparen_loc, args, rparen_loc, exec_config=Expr_(C_NULL), is_exec_config=false, allow_recovery=false)
Build a call of `fn` with `args`, running overload resolution over the candidates visible
from `sp` and converting the arguments to the parameter types.

`sp` and `exec_config` may be NULL carriers. Return `nothing` when Sema rejected the call.
"""
function BuildCallExpr(x::AbstractSema, sp::AbstractScope, fn::AbstractExpr, lparen_loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, rparen_loc::SourceLocation, exec_config::AbstractExpr=Expr_(C_NULL), is_exec_config::Bool=false, allow_recovery::Bool=false)
    @check_ptrs x fn
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in args]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCallExpr(x, sp, fn, lparen_loc, ptrs, length(ptrs), rparen_loc, exec_config, is_exec_config, allow_recovery, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCStyleCastExpr(x::AbstractSema, lparen_loc, ty, rparen_loc, op)
Build the C-style cast `(ty)op`, choosing and checking the cast kind.

Return `nothing` when Sema rejected the conversion.
"""
function BuildCStyleCastExpr(x::AbstractSema, lparen_loc::SourceLocation, ty::AbstractTypeSourceInfo, rparen_loc::SourceLocation, op::AbstractExpr)
    @check_ptrs x ty op
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCStyleCastExpr(x, lparen_loc, ty, rparen_loc, op, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildBinOp(x::AbstractSema, sp, op_loc, opc, lhs, rhs)
Build the binary operator `opc` over `lhs` and `rhs`, considering the overloaded `operator`
candidates visible from `sp`.

`sp` may be a NULL `Scope`, in which case no overload lookup runs and the result is the
built-in operator. Return `nothing` when Sema rejected the operands.
"""
function BuildBinOp(x::AbstractSema, sp::AbstractScope, op_loc::SourceLocation, opc::CXBinaryOperatorKind, lhs::AbstractExpr, rhs::AbstractExpr)
    @check_ptrs x lhs rhs
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildBinOp(x, sp, op_loc, opc, lhs, rhs, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildAsTypeExpr(x::AbstractSema, e, dest_ty, builtin_loc, rparen_loc)
Build `__builtin_astype(e, dest_ty)`, a bit-preserving reinterpretation of `e`.

Return `nothing` when `dest_ty` and `e`'s type differ in size, which is the only way this
builder fails.
"""
function BuildAsTypeExpr(x::AbstractSema, e::AbstractExpr, dest_ty::AbstractQualType, builtin_loc::SourceLocation, rparen_loc::SourceLocation)
    @check_ptrs x e dest_ty
    invalid = Ref{Bool}(false)
    r = clang_Sema_BuildAsTypeExpr(x, e, dest_ty, builtin_loc, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    BuildBuiltinBitCastExpr(x::AbstractSema, kw_loc, tsi, operand, rparen_loc)
Build `__builtin_bit_cast(tsi, operand)`.

Return `nothing` when either type is not trivially copyable or the two sizes differ.
"""
function BuildBuiltinBitCastExpr(x::AbstractSema, kw_loc::SourceLocation, tsi::AbstractTypeSourceInfo, operand::AbstractExpr, rparen_loc::SourceLocation)
    @check_ptrs x tsi operand
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildBuiltinBitCastExpr(x, kw_loc, tsi, operand, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildEmptyCXXFoldExpr(x::AbstractSema, ellipsis_loc, opc)
Build the value of a unary fold over an empty pack.

[temp.variadic]p9 gives one only to `BO_LAnd`, `BO_LOr` and `BO_Comma`; every other opcode is
diagnosed and returns `nothing`.
"""
function BuildEmptyCXXFoldExpr(x::AbstractSema, ellipsis_loc::SourceLocation, opc::CXBinaryOperatorKind)
    @check_ptrs x
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildEmptyCXXFoldExpr(x, ellipsis_loc, opc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXTypeConstructExpr(x::AbstractSema, ty, lparen_loc, exprs, rparen_loc, list_initialization=false)
Build the functional-notation construction `T(exprs)` — or `T{exprs}` when
`list_initialization` is true — for the type `ty` names.

Return `nothing` when Sema found no viable initialization.
"""
function BuildCXXTypeConstructExpr(x::AbstractSema, ty::AbstractTypeSourceInfo, lparen_loc::SourceLocation, exprs::AbstractVector{<:AbstractExpr}, rparen_loc::SourceLocation, list_initialization::Bool=false)
    @check_ptrs x ty
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in exprs]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXTypeConstructExpr(x, ty, lparen_loc, ptrs, length(ptrs), rparen_loc, list_initialization, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildTypeTrait(x::AbstractSema, kind, kw_loc, args, rparen_loc)
Build the type-trait expression `kind` (`__is_pod`, `__is_base_of`, …) over `args`.

`clang::Sema::BuildTypeTrait` reads `args[1]` unconditionally for the unary traits, so the
wrapper rejects an empty argument list; `args` must otherwise match the arity `kind`
declares. Return `nothing` when a required type is incomplete.
"""
function BuildTypeTrait(x::AbstractSema, kind::CXTypeTrait, kw_loc::SourceLocation, args::AbstractVector{<:AbstractTypeSourceInfo}, rparen_loc::SourceLocation)
    @check_ptrs x
    @assert !isempty(args) "a type trait needs at least one type argument"
    ptrs = CXTypeSourceInfo[Base.unsafe_convert(CXTypeSourceInfo, t) for t in args]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildTypeTrait(x, kind, kw_loc, ptrs, length(ptrs), rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildArrayTypeTrait(x::AbstractSema, att, kw_loc, tsinfo, dim_expr, rparen)
Build the array type-trait expression `att` (`__array_rank`, `__array_extent`) over the type
`tsinfo` names.

`clang::Sema::BuildArrayTypeTrait` evaluates `dim_expr` as an integer constant expression
without a null check for `ATT_ArrayExtent`, so the wrapper restates that precondition;
`ATT_ArrayRank` ignores `dim_expr` and accepts a NULL carrier.
"""
function BuildArrayTypeTrait(x::AbstractSema, att::CXArrayTypeTrait, kw_loc::SourceLocation, tsinfo::AbstractTypeSourceInfo, dim_expr::AbstractExpr, rparen::SourceLocation)
    @check_ptrs x tsinfo
    @assert att != CXArrayTypeTrait_ATT_ArrayExtent || dim_expr.ptr != C_NULL "__array_extent needs a dimension expression"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildArrayTypeTrait(x, att, kw_loc, tsinfo, dim_expr, rparen, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildExpressionTrait(x::AbstractSema, oet, kw_loc, queried, rparen)
Build the expression-trait expression `oet` (`__is_lvalue_expr`, `__is_rvalue_expr`) over
`queried`, evaluating it immediately.

Return `nothing` when `queried` is an unresolved placeholder Sema could not fix up.
"""
function BuildExpressionTrait(x::AbstractSema, oet::CXExpressionTrait, kw_loc::SourceLocation, queried::AbstractExpr, rparen::SourceLocation)
    @check_ptrs x queried
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildExpressionTrait(x, oet, kw_loc, queried, rparen, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CreateMaterializeTemporaryExpr(x::AbstractSema, ty, temporary, bound_to_lvalue_reference) -> MaterializeTemporaryExpr
Materialize `temporary` as an object of type `ty`, the node a reference binding to a
prvalue produces.

When `ty` is a class type with a non-trivial destructor this also marks Sema's current
full-expression as needing cleanups.
"""
function CreateMaterializeTemporaryExpr(x::AbstractSema, ty::AbstractQualType, temporary::AbstractExpr, bound_to_lvalue_reference::Bool)
    @check_ptrs x ty temporary
    return MaterializeTemporaryExpr(clang_Sema_CreateMaterializeTemporaryExpr(x, ty, temporary, bound_to_lvalue_reference))
end

"""
    BuildStaticAssertDeclaration(x::AbstractSema, static_assert_loc, assert_expr, assert_message_expr, rparen_loc, failed=false) -> Decl
Build a `StaticAssertDecl` from `assert_expr`, evaluating it as a constant expression and
adding the declaration to Sema's current `DeclContext`.

`assert_message_expr` may be a NULL carrier, the C++17 one-argument form. Pass `failed=true`
to record an assertion the caller already knows to have failed.
"""
function BuildStaticAssertDeclaration(x::AbstractSema, static_assert_loc::SourceLocation, assert_expr::AbstractExpr, assert_message_expr::AbstractExpr, rparen_loc::SourceLocation, failed::Bool=false)
    @check_ptrs x assert_expr
    return Decl(clang_Sema_BuildStaticAssertDeclaration(x, static_assert_loc, assert_expr, assert_message_expr, rparen_loc, failed))
end

"""
    BuildExpressionFromNonTypeTemplateArgument(x::AbstractSema, arg, loc)
Re-express the non-type template argument `arg` as the expression that denotes its value.

`clang::Sema::BuildExpressionFromNonTypeTemplateArgument` reaches `llvm_unreachable` — which
aborts the process — for the `Null`, `Type`, `Template`, `TemplateExpansion` and `Pack`
kinds, so the wrapper restates that precondition. Return `nothing` when Sema could not build
the expression.
"""
function BuildExpressionFromNonTypeTemplateArgument(x::AbstractSema, arg::TemplateArgument, loc::SourceLocation)
    @check_ptrs x arg
    @assert getKind(arg) in (CXTemplateArgument_Expression, CXTemplateArgument_NullPtr, CXTemplateArgument_Integral, CXTemplateArgument_Declaration, CXTemplateArgument_StructuralValue) "a non-type template argument is required"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildExpressionFromNonTypeTemplateArgument(x, arg, loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXFunctionalCastExpr(x::AbstractSema, tinfo, ty, lparen_loc, cast_expr, rparen_loc)
Build the C++ functional-notation cast `T(cast_expr)` where `tinfo`/`ty` name `T`.

Return `nothing` when Sema rejected the conversion.
"""
function BuildCXXFunctionalCastExpr(x::AbstractSema, tinfo::AbstractTypeSourceInfo, ty::AbstractQualType, lparen_loc::SourceLocation, cast_expr::AbstractExpr, rparen_loc::SourceLocation)
    @check_ptrs x tinfo ty cast_expr
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXFunctionalCastExpr(x, tinfo, ty, lparen_loc, cast_expr, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CheckQualifiedFunctionForTypeId(x::AbstractSema, t::QualType, loc::SourceLocation) -> Bool
Return `true` when `t` is a function type carrying cv-qualifiers or a ref-qualifier, which
makes it invalid as the operand of `typeid`, `new` or a conversion-function-id. The
rejection is diagnosed at `loc`.
"""
function CheckQualifiedFunctionForTypeId(x::AbstractSema, t::QualType, loc::SourceLocation)
    @check_ptrs x t
    return clang_Sema_CheckQualifiedFunctionForTypeId(x, t, loc)
end

"""
    CheckSpecifiedExceptionType(x::AbstractSema, t::QualType, rng::SourceRange) -> (Bool, QualType)
Check that `t` may appear in an exception specification, returning the rejection flag and
the adjusted type. clang decays an array type to a pointer and a function type to a pointer
to function before checking, and it is that adjusted type an exception specification would
carry. A `true` flag means the type was rejected — an incomplete or abstract class — which
is diagnosed over `rng`.
"""
function CheckSpecifiedExceptionType(x::AbstractSema, t::QualType, rng::SourceRange)
    @check_ptrs x t
    adjusted = Ref{CXQualType}(Base.unsafe_convert(CXQualType, t))
    bad = clang_Sema_CheckSpecifiedExceptionType(x, adjusted, getBeginLoc(rng), getEndLoc(rng))
    return bad, QualType(adjusted[])
end

"""
    CheckEquivalentExceptionSpec(x::AbstractSema, old_fd, new_fd) -> Bool
Return `true` when the exception specifications of `old_fd` and `new_fd` are incompatible,
which is diagnosed; a missing specification on `new_fd` may instead be completed from
`old_fd`'s.

Both declarations must have a prototype: clang reaches `new_fd`'s specification through an
unchecked `castAs<FunctionProtoType>`.
"""
function CheckEquivalentExceptionSpec(x::AbstractSema, old_fd::AbstractFunctionDecl, new_fd::AbstractFunctionDecl)
    @check_ptrs x old_fd new_fd
    @assert isFunctionProtoType(getTypePtr(getType(old_fd))) "`old_fd` must have a prototype"
    @assert isFunctionProtoType(getTypePtr(getType(new_fd))) "`new_fd` must have a prototype"
    return clang_Sema_CheckEquivalentExceptionSpec(x, old_fd, new_fd)
end

"""
    CheckConstexprFunctionDefinition(x::AbstractSema, fd, kind=CXCheckConstexprKind_CheckValid) -> Bool
Return whether `fd`'s definition satisfies the formal rules for a `constexpr` function in
the current language mode — `true` means it does, the opposite polarity from the `Check*`
entry points that report a rejection. `CXCheckConstexprKind_CheckValid` is a pure query
that admits no extensions; `CXCheckConstexprKind_Diagnose` reports every violation, the
ones clang accepts as extensions included.

`fd` must have a body: clang asserts on it before inspecting the definition.
"""
function CheckConstexprFunctionDefinition(x::AbstractSema, fd::AbstractFunctionDecl, kind::CXCheckConstexprKind=CXCheckConstexprKind_CheckValid)
    @check_ptrs x fd
    @assert hasBody(fd) "the function must have a body"
    return clang_Sema_CheckConstexprFunctionDefinition(x, fd, kind)
end

"""
    CheckEnumUnderlyingType(x::AbstractSema, tsi::AbstractTypeSourceInfo) -> Bool
Return `true` when the type `tsi` describes cannot be an enumeration's fixed underlying
type — it is neither an integer builtin nor a `_BitInt` — which is diagnosed at `tsi`'s
begin location.
"""
function CheckEnumUnderlyingType(x::AbstractSema, tsi::AbstractTypeSourceInfo)
    @check_ptrs x tsi
    return clang_Sema_CheckEnumUnderlyingType(x, tsi)
end

"""
    CheckRedeclarationModuleOwnership(x::AbstractSema, new_nd, old_nd) -> Bool
Return `true` when `new_nd` redeclares `old_nd` from a different C++20 module, which is
diagnosed. Outside a named module both declarations are unowned and the answer is `false`.
"""
function CheckRedeclarationModuleOwnership(x::AbstractSema, new_nd::AbstractNamedDecl, old_nd::AbstractNamedDecl)
    @check_ptrs x new_nd old_nd
    return clang_Sema_CheckRedeclarationModuleOwnership(x, new_nd, old_nd)
end

"""
    CheckRedeclarationExported(x::AbstractSema, new_nd, old_nd) -> Bool
Return `true` when exactly one of `new_nd` and `old_nd` is exported from a C++20 module
interface, which is diagnosed. Outside a named module neither is exported and the answer is
`false`.
"""
function CheckRedeclarationExported(x::AbstractSema, new_nd::AbstractNamedDecl, old_nd::AbstractNamedDecl)
    @check_ptrs x new_nd old_nd
    return clang_Sema_CheckRedeclarationExported(x, new_nd, old_nd)
end

"""
    CheckRedeclarationInModule(x::AbstractSema, new_nd, old_nd) -> Bool
Return `true` when the redeclaration of `old_nd` by `new_nd` is ill-formed under the C++20
module rules — the disjunction of [`CheckRedeclarationModuleOwnership`](@ref) and
[`CheckRedeclarationExported`](@ref).
"""
function CheckRedeclarationInModule(x::AbstractSema, new_nd::AbstractNamedDecl, old_nd::AbstractNamedDecl)
    @check_ptrs x new_nd old_nd
    return clang_Sema_CheckRedeclarationInModule(x, new_nd, old_nd)
end

"""
    CheckPlaceholderExpr(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Resolve a placeholder type — an unresolved overload set, a bound member function, a
pseudo-object expression — to a real expression. An expression whose type is not a
placeholder comes back unchanged. Return `nothing` when Sema rejected the operand.
"""
function CheckPlaceholderExpr(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_CheckPlaceholderExpr(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    CheckAllocatedType(x::AbstractSema, alloc_type::QualType, loc, rng) -> Bool
Return `true` when `alloc_type` is not a valid operand for `new` — a function or reference
type, or an incomplete or abstract class — which is diagnosed at `loc` over `rng`.
"""
function CheckAllocatedType(x::AbstractSema, alloc_type::QualType, loc::SourceLocation, rng::SourceRange)
    @check_ptrs x alloc_type
    return clang_Sema_CheckAllocatedType(x, alloc_type, loc, getBeginLoc(rng), getEndLoc(rng))
end

"""
    CheckOverridingFunctionAttributes(x::AbstractSema, new_md, old_md) -> Bool
Return `true` when `new_md` overrides `old_md` with an incompatible calling convention,
`code_seg` or parameter-ABI attribute set, which is diagnosed.

Both methods must have a prototype: clang reaches the attribute sets through an unchecked
`castAs<FunctionProtoType>`.
"""
function CheckOverridingFunctionAttributes(x::AbstractSema, new_md::AbstractCXXMethodDecl, old_md::AbstractCXXMethodDecl)
    @check_ptrs x new_md old_md
    @assert isFunctionProtoType(getTypePtr(getType(new_md))) "`new_md` must have a prototype"
    @assert isFunctionProtoType(getTypePtr(getType(old_md))) "`old_md` must have a prototype"
    return clang_Sema_CheckOverridingFunctionAttributes(x, new_md, old_md)
end

"""
    CheckOverridingFunctionReturnType(x::AbstractSema, new_md, old_md) -> Bool
Return `true` when the return type of `new_md` is neither the same as nor covariant with
the return type of the method `old_md` it overrides, which is diagnosed.
"""
function CheckOverridingFunctionReturnType(x::AbstractSema, new_md::AbstractCXXMethodDecl, old_md::AbstractCXXMethodDecl)
    @check_ptrs x new_md old_md
    return clang_Sema_CheckOverridingFunctionReturnType(x, new_md, old_md)
end

"""
    CheckOverridingFunctionExceptionSpec(x::AbstractSema, new_md, old_md) -> Bool
Return `true` when the exception specification of `new_md` is not a subset of the one on
the method `old_md` it overrides, which is diagnosed.

Both methods must have a prototype: clang reaches the specifications through an unchecked
`castAs<FunctionProtoType>`.
"""
function CheckOverridingFunctionExceptionSpec(x::AbstractSema, new_md::AbstractCXXMethodDecl, old_md::AbstractCXXMethodDecl)
    @check_ptrs x new_md old_md
    @assert isFunctionProtoType(getTypePtr(getType(new_md))) "`new_md` must have a prototype"
    @assert isFunctionProtoType(getTypePtr(getType(old_md))) "`old_md` must have a prototype"
    return clang_Sema_CheckOverridingFunctionExceptionSpec(x, new_md, old_md)
end

"""
    CheckOverloadedOperatorDeclaration(x::AbstractSema, fd::AbstractFunctionDecl) -> Bool
Return `true` when the declaration of an overloaded operator is ill-formed — the wrong
arity, no class-type parameter, a default argument where none is allowed — which is
diagnosed.

`fd` must name an overloaded operator: clang asserts on it.
"""
function CheckOverloadedOperatorDeclaration(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    @assert isOverloadedOperator(fd) "the declaration must be an overloaded operator"
    return clang_Sema_CheckOverloadedOperatorDeclaration(x, fd)
end

"""
    CheckLiteralOperatorDeclaration(x::AbstractSema, fd::AbstractFunctionDecl) -> Bool
Return `true` when the declaration of a literal operator is ill-formed — declared as a
member, with C language linkage, or with a parameter list none of the permitted forms
allows — which is diagnosed.

`fd`'s name must be a literal-operator name: clang reaches the suffix identifier through
`DeclarationName::getCXXLiteralIdentifier`, which asserts on the name kind.
"""
function CheckLiteralOperatorDeclaration(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    kind = getNameKind(getDeclName(fd))
    @assert kind == CXDeclarationName_CXXLiteralOperatorName "the declaration must be a literal operator"
    return clang_Sema_CheckLiteralOperatorDeclaration(x, fd)
end

"""
    CheckNonTypeTemplateParameterType(x::AbstractSema, t::QualType, loc) -> QualType
The type a non-type template parameter declared with type `t` would have. The returned
carrier holds NULL when `t` is not a permitted non-type template parameter type, which is
diagnosed at `loc`.
"""
function CheckNonTypeTemplateParameterType(x::AbstractSema, t::QualType, loc::SourceLocation)
    @check_ptrs x t
    return QualType(clang_Sema_CheckNonTypeTemplateParameterType(x, t, loc))
end

"""
    CheckAssignmentConstraints(x::AbstractSema, loc, lhs_type, rhs_type) -> CXAssignConvertType
Return whether a value of `rhs_type` may initialize an object of `lhs_type`, and by which
extension when the answer is not `CXAssignConvertType_Compatible`. Never diagnoses: clang
runs the check over an internal placeholder expression with the conversion disabled, so
`loc` only names the position that placeholder pretends to occupy.
"""
function CheckAssignmentConstraints(x::AbstractSema, loc::SourceLocation, lhs_type::QualType, rhs_type::QualType)
    @check_ptrs x lhs_type rhs_type
    return clang_Sema_CheckAssignmentConstraints(x, loc, lhs_type, rhs_type)
end

"""
    CheckForConstantInitializer(x::AbstractSema, e::AbstractExpr, t::QualType) -> Bool
Return `true` when `e` is not a valid constant initializer for an object of type `t`. The
subexpression that made it non-constant is diagnosed.
"""
function CheckForConstantInitializer(x::AbstractSema, e::AbstractExpr, t::QualType)
    @check_ptrs x e t
    return clang_Sema_CheckForConstantInitializer(x, e, t)
end

"""
    CheckBooleanCondition(x::AbstractSema, loc, e, is_constexpr=false) -> Union{Nothing,Expr_}
Convert `e` to the boolean condition of an `if`/`while`/`for`, applying the usual function
and array decays; `is_constexpr` requests the constexpr-if rules. Return `nothing` when the
conversion is ill-formed, which is diagnosed at `loc`.
"""
function CheckBooleanCondition(x::AbstractSema, loc::SourceLocation, e::AbstractExpr, is_constexpr::Bool=false)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_CheckBooleanCondition(x, loc, e, is_constexpr, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    VerifyIntegerConstantExpression(x::AbstractSema, e, can_fold=CXAllowFoldKind_NoFold) -> Union{Nothing,Expr_}
Verify that `e` is an integral constant expression, returning it (possibly converted) on
success and `nothing` on failure, which is diagnosed. `CXAllowFoldKind_AllowFold` downgrades
a foldable non-constant expression to a warning. The value itself is not returned — read it
with [`EvaluateAsInt`](@ref) on the result.
"""
function VerifyIntegerConstantExpression(x::AbstractSema, e::AbstractExpr, can_fold::CXAllowFoldKind=CXAllowFoldKind_NoFold)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_VerifyIntegerConstantExpression(x, e, can_fold, invalid)
    return invalid[] ? nothing : Expr_(r)
end

# --- Expression conversions and the remaining ODR-use marking ---
#
# `clang::ExprResult` crosses the C boundary split (MARSHALLING.md §8), so every conversion
# below returns `nothing` for an invalid result and an `Expr_` carrier otherwise; a carrier
# holding NULL is a valid-but-empty result, not an error. Every node produced is
# ASTContext-arena memory and is never disposed. None of these needs an active instantiation
# context, but all of them run real semantic analysis against the live `Sema` and may emit
# diagnostics into its `DiagnosticsEngine`.

"""
    PerformImplicitObjectArgumentInitialization(x::AbstractSema, from, qualifier, found_decl, method)
Initialize `method`'s implicit object parameter from the object expression `from`, inserting
the derived-to-base and qualification conversions a call would.

`method` must be an implicit object member function: Sema reaches `getThisType()`, which
asserts on a static or explicit-object member function. `qualifier` is the
nested-name-specifier `method` was named through, or `nothing`; `found_decl` is the lookup
result that named it. `from` must designate an object of `method`'s class or of a class
derived from it — otherwise Sema diagnoses and the result is `nothing`.
"""
function PerformImplicitObjectArgumentInitialization(x::AbstractSema, from::AbstractExpr, qualifier::Union{Nothing,AbstractNestedNameSpecifier}, found_decl::AbstractNamedDecl, method::AbstractCXXMethodDecl)
    @check_ptrs x from found_decl method
    @assert isImplicitObjectMemberFunction(method) "the method must be an implicit object member function"
    q = qualifier === nothing ? CXNestedNameSpecifier(C_NULL) : Base.unsafe_convert(CXNestedNameSpecifier, qualifier)
    invalid = Ref{Bool}(false)
    e = clang_Sema_PerformImplicitObjectArgumentInitialization(x, from, q, found_decl, method, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    PerformContextuallyConvertToBool(x::AbstractSema, from::AbstractExpr)
Convert `from` to `bool` the way an `if` condition does, honouring a user-defined conversion
operator. Return `nothing` when no such conversion exists.
"""
function PerformContextuallyConvertToBool(x::AbstractSema, from::AbstractExpr)
    @check_ptrs x from
    invalid = Ref{Bool}(false)
    e = clang_Sema_PerformContextuallyConvertToBool(x, from, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    PerformObjectMemberConversion(x::AbstractSema, from, qualifier, found_decl, member)
Convert the object expression `from` to the class that declares `member`, so that a member
access can be built on it.

`qualifier` is the nested-name-specifier `member` was named through, or `nothing`;
`found_decl` is the lookup result that named it. A `member` whose semantic `DeclContext` is
not a C++ class leaves `from` untouched. Return `nothing` when `from`'s class does not
reach `member`'s, in which case Sema has already diagnosed.
"""
function PerformObjectMemberConversion(x::AbstractSema, from::AbstractExpr, qualifier::Union{Nothing,AbstractNestedNameSpecifier}, found_decl::AbstractNamedDecl, member::AbstractNamedDecl)
    @check_ptrs x from found_decl member
    q = qualifier === nothing ? CXNestedNameSpecifier(C_NULL) : Base.unsafe_convert(CXNestedNameSpecifier, qualifier)
    invalid = Ref{Bool}(false)
    e = clang_Sema_PerformObjectMemberConversion(x, from, q, found_decl, member, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    MarkTypoCorrectedFunctionDefinition(x::AbstractSema, fd::AbstractNamedDecl)
Record that `fd`'s definition was reached through a typo correction, so later diagnostics
can mention it. Adds `fd` to a Sema-side set and reads nothing else.
"""
function MarkTypoCorrectedFunctionDefinition(x::AbstractSema, fd::AbstractNamedDecl)
    @check_ptrs x fd
    clang_Sema_MarkTypoCorrectedFunctionDefinition(x, fd)
    return nothing
end

"""
    MarkDeclRefReferenced(x::AbstractSema, e::AbstractDeclRefExpr, base=nothing)
Mark the declaration `e` names as referenced (and odr-used where the language says so).
`base` is the object expression of the member access `e` appears in; it is read only to
devirtualize a virtual member function and defaults to `nothing`.

`e` must not name a variable with local storage unless a function scope is active on Sema —
marking one asks Sema to capture it, which walks the function-scope stack the parser
maintains. That state has no observable proxy in the C API, so this is a documented
precondition rather than an `@assert` (MARSHALLING.md §13).
"""
function MarkDeclRefReferenced(x::AbstractSema, e::AbstractDeclRefExpr, base::Union{Nothing,AbstractExpr}=nothing)
    @check_ptrs x e
    b = base === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, base)
    clang_Sema_MarkDeclRefReferenced(x, e, b)
    return nothing
end

"""
    MarkMemberReferenced(x::AbstractSema, e::AbstractMemberExpr)
Mark the member `e` names as referenced, treating a virtual dispatch as a non-odr-use.
"""
function MarkMemberReferenced(x::AbstractSema, e::AbstractMemberExpr)
    @check_ptrs x e
    clang_Sema_MarkMemberReferenced(x, e)
    return nothing
end

"""
    MarkDeclarationsReferencedInExpr(x::AbstractSema, e::AbstractExpr, skip_local_variables=false, stop_at=Expr_[])
Mark every declaration named inside `e` as referenced. `stop_at` lists sub-expressions the
walk does not descend into.

With `skip_local_variables` left `false`, `e` must name no variable with local storage
unless a function scope is active on Sema — see `MarkDeclRefReferenced`. Passing `true` is
what makes the walk safe outside the parser: it drops exactly those references.
"""
function MarkDeclarationsReferencedInExpr(x::AbstractSema, e::AbstractExpr, skip_local_variables::Bool=false, stop_at::AbstractVector{<:AbstractExpr}=Expr_[])
    @check_ptrs x e
    @assert all(s -> s.ptr != C_NULL, stop_at) "every stop-at expression must be non-NULL"
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, s) for s in stop_at]
    clang_Sema_MarkDeclarationsReferencedInExpr(x, e, skip_local_variables, ptrs, length(ptrs))
    return nothing
end

"""
    MarkVirtualBaseDestructorsReferenced(x::AbstractSema, loc::SourceLocation, cls::AbstractCXXRecordDecl)
Mark the destructors of `cls`'s virtual bases referenced at `loc`. `cls` must be a complete
definition — its virtual base range is iterated. Dependent classes and unions are skipped by
Sema itself.

Clang's own doc comment names both the Itanium and the Microsoft C++ ABI: it describes when
clang reaches this entry point, not a target precondition.
"""
function MarkVirtualBaseDestructorsReferenced(x::AbstractSema, loc::SourceLocation, cls::AbstractCXXRecordDecl)
    @check_ptrs x cls
    @assert isCompleteDefinition(cls) "the class must be a complete definition"
    clang_Sema_MarkVirtualBaseDestructorsReferenced(x, loc, cls)
    return nothing
end

"""
    MarkUsedTemplateParameters(x::AbstractSema, e::AbstractExpr, num_params::Integer, only_deduced::Bool=false, depth::Integer=0) -> Vector{Bool}
Return `num_params` flags, `true` at index `i` when the template parameter at position
`i - 1` and nesting level `depth` occurs in `e`. With `only_deduced` set, only occurrences a
template argument could be deduced from count.

`num_params` must cover every parameter index at `depth` that `e` can name — clang indexes a
bit vector sized from it, and a smaller count trips clang's own bounds assert. Take it from
`size(getTemplateParameters(td))` of the template whose parameters `e` may mention.
"""
function MarkUsedTemplateParameters(x::AbstractSema, e::AbstractExpr, num_params::Integer, only_deduced::Bool=false, depth::Integer=0)
    @check_ptrs x e
    @assert num_params >= 0 "the template-parameter count must not be negative"
    @assert depth >= 0 "the template nesting depth must not be negative"
    used = fill(false, num_params)
    num_params > 0 && clang_Sema_MarkUsedTemplateParameters(x, e, only_deduced, UInt32(depth), used, UInt32(num_params))
    return used
end

"""
    PerformImplicitConversion(x::AbstractSema, from::AbstractExpr, to::AbstractQualType, action::CXAssignmentAction, allow_explicit::Bool=false)
Convert `from` to `to` as the implicit conversion `action` describes, running overload
resolution for a user-defined conversion when one is needed. Return `nothing` when there is
no such conversion, in which case Sema has already diagnosed it against `action`.
"""
function PerformImplicitConversion(x::AbstractSema, from::AbstractExpr, to::AbstractQualType, action::CXAssignmentAction, allow_explicit::Bool=false)
    @check_ptrs x from to
    invalid = Ref{Bool}(false)
    e = clang_Sema_PerformImplicitConversion(x, from, to, action, allow_explicit, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    PerformMemberExprBaseConversion(x::AbstractSema, base::AbstractExpr, is_arrow::Bool)
Prepare `base` to be the object expression of a member access: strip a placeholder type, and
for `is_arrow` also run the function/array-to-pointer and lvalue-to-rvalue conversions.
Return `nothing` when Sema rejected the placeholder.
"""
function PerformMemberExprBaseConversion(x::AbstractSema, base::AbstractExpr, is_arrow::Bool)
    @check_ptrs x base
    invalid = Ref{Bool}(false)
    e = clang_Sema_PerformMemberExprBaseConversion(x, base, is_arrow, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    PerformQualificationConversion(x::AbstractSema, e::AbstractExpr, ty::AbstractQualType, vk::CXExprValueKind=CXExprValueKind_VK_PRValue, cck::CXCheckedConversionKind=CXCheckedConversionKind_CCK_ImplicitConversion)
Insert the cast that takes `e` to `ty` and value kind `vk`. `ty` should differ from `e`'s
type only in qualification: the inserted cast is a no-op unless the address spaces differ,
so this neither checks nor diagnoses an unrelated `ty`.
"""
function PerformQualificationConversion(x::AbstractSema, e::AbstractExpr, ty::AbstractQualType, vk::CXExprValueKind=CXExprValueKind_VK_PRValue, cck::CXCheckedConversionKind=CXCheckedConversionKind_CCK_ImplicitConversion)
    @check_ptrs x e ty
    invalid = Ref{Bool}(false)
    r = clang_Sema_PerformQualificationConversion(x, e, ty, vk, cck, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    AddOverriddenMethods(x::AbstractSema, rd::AbstractCXXRecordDecl, md::AbstractCXXMethodDecl) -> Bool
Wire up `md`'s overridden-method list from the virtual members of `rd`'s base classes and return
`true` when at least one overridden method was found.

`rd` must have a definition, since clang walks its bases. clang appends to the list without
de-duplicating, so this may only run on a method whose override list is still empty — the parser
has already wired up every method it saw inside a class body.
"""
function AddOverriddenMethods(x::AbstractSema, rd::AbstractCXXRecordDecl, md::AbstractCXXMethodDecl)
    @check_ptrs x rd md
    @assert hasDefinition(rd) "the class must have a definition"
    @assert size_overridden_methods(md) == 0 "the method's overridden-method list must be empty"
    return clang_Sema_AddOverriddenMethods(x, rd, md)
end

"""
    SetParamDefaultArgument(x::AbstractSema, param::AbstractParmVarDecl, arg::AbstractExpr, loc)
Store `arg` as `param`'s default argument. No conversion and no checking happen here: `arg` must
already have been converted to `param`'s type. `loc` is the location of the `=`.
"""
function SetParamDefaultArgument(x::AbstractSema, param::AbstractParmVarDecl, arg::AbstractExpr, loc::SourceLocation)
    @check_ptrs x param arg
    return clang_Sema_SetParamDefaultArgument(x, param, arg, loc)
end

"""
    SetDeclDeleted(x::AbstractSema, d::AbstractDecl, loc::SourceLocation)
Mark `d` as `= delete`, blaming `loc`. A `d` that is not a function, or a redeclaration that is
not the first declaration, is reported through Sema's `DiagnosticsEngine` instead — the latter
also marks `d` invalid.
"""
function SetDeclDeleted(x::AbstractSema, d::AbstractDecl, loc::SourceLocation)
    @check_ptrs x d
    return clang_Sema_SetDeclDeleted(x, d, loc)
end

"""
    SetDeclDefaulted(x::AbstractSema, d::AbstractDecl, loc::SourceLocation)
Mark `d` as `= default`, blaming `loc`. A `d` that is not a defaultable special member or
comparison operator is reported through Sema's `DiagnosticsEngine` instead.
"""
function SetDeclDefaulted(x::AbstractSema, d::AbstractDecl, loc::SourceLocation)
    @check_ptrs x d
    return clang_Sema_SetDeclDefaulted(x, d, loc)
end

"""
    AddKnownFunctionAttributes(x::AbstractSema, fd::AbstractFunctionDecl)
Add the attributes clang infers from `fd`'s builtin ID and from its name (the libc/libm knowledge
base). Idempotent: each attribute is added only when absent.
"""
function AddKnownFunctionAttributes(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_AddKnownFunctionAttributes(x, fd)
end

"""
    AdjustDestructorExceptionSpec(x::AbstractSema, dtor::AbstractCXXDestructorDecl)
Give a user-declared destructor with no exception specification the implicit one, by retyping it
with an unevaluated exception spec. A no-op once a specification is present, so it is idempotent.

clang reaches the destructor's `FunctionProtoType` with an unchecked `castAs<>`.
"""
function AdjustDestructorExceptionSpec(x::AbstractSema, dtor::AbstractCXXDestructorDecl)
    @check_ptrs x dtor
    @assert isFunctionProtoType(getTypePtr(getType(dtor))) "the destructor must have a prototype"
    return clang_Sema_AdjustDestructorExceptionSpec(x, dtor)
end

"""
    ForceDeclarationOfImplicitMembers(x::AbstractSema, rd::AbstractCXXRecordDecl)
Declare every implicit special member of `rd` that is not declared yet, closing all six
`needsImplicit*` gates. `rd` must have a definition — each gate reads it.
"""
function ForceDeclarationOfImplicitMembers(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert hasDefinition(rd) "the class must have a definition"
    return clang_Sema_ForceDeclarationOfImplicitMembers(x, rd)
end

"""
    DefineUsedVTables(x::AbstractSema) -> Bool
Define every vtable used so far in the translation unit and mark the virtual members those
vtables reference. Return `true` when any work was done.
"""
function DefineUsedVTables(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_DefineUsedVTables(x)
end

"""
    AddImplicitlyDeclaredMembersToClass(x::AbstractSema, rd::AbstractCXXRecordDecl)
Run the parser's own end-of-class hook over `rd`: declare the implicit special members that
overload resolution already needs, and bump the `ASTContext` implicit-member statistics.

`rd` must have a definition. The declarations stay gated by the `needsImplicit*` predicates, so a
second call declares nothing new — but it does double-count those statistics.
"""
function AddImplicitlyDeclaredMembersToClass(x::AbstractSema, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert hasDefinition(rd) "the class must have a definition"
    return clang_Sema_AddImplicitlyDeclaredMembersToClass(x, rd)
end

"""
    SetMemberAccessSpecifier(x::AbstractSema, member::AbstractNamedDecl, prev, as) -> Bool
Set `member`'s access. With `prev === nothing` the lexical specifier `as` is used and `false` is
returned; otherwise the access must equal `prev`'s, and a mismatch is diagnosed and returns
`true` — `member` still takes `as`.
"""
function SetMemberAccessSpecifier(x::AbstractSema, member::AbstractNamedDecl, prev::Union{Nothing,AbstractNamedDecl}, as::CXAccessSpecifier)
    @check_ptrs x member
    prev_ptr = prev === nothing ? CXNamedDecl(C_NULL) : Base.unsafe_convert(CXNamedDecl, prev)
    return clang_Sema_SetMemberAccessSpecifier(x, member, prev_ptr, as)
end

"""
    AdjustDeclIfTemplate(x::AbstractSema, d::AbstractDecl) -> Tuple{TemplateDecl,Decl}
Return `(template, inner)`. When `d` is a `TemplateDecl`, `template` carries it and `inner` is its
templated declaration; otherwise `template` carries NULL and `inner` is `d` unchanged. `inner`
comes back at the `Decl` base — `resolve` it to reach the concrete carrier.
"""
function AdjustDeclIfTemplate(x::AbstractSema, d::AbstractDecl)
    @check_ptrs x d
    slot = Ref{CXDecl}(Base.unsafe_convert(CXDecl, d))
    td = TemplateDecl(clang_Sema_AdjustDeclIfTemplate(x, slot))
    return td, Decl(slot[])
end

"""
    DeclareImplicitDeductionGuides(x::AbstractSema, tmpl::AbstractTemplateDecl, loc::SourceLocation)
Declare the implicit deduction guides of a class template unless they already exist. A no-op
before C++17, for a `tmpl` that is not a class template, for one in a dependent context, and for
one whose deduced type is incomplete.
"""
function DeclareImplicitDeductionGuides(x::AbstractSema, tmpl::AbstractTemplateDecl, loc::SourceLocation)
    @check_ptrs x tmpl
    return clang_Sema_DeclareImplicitDeductionGuides(x, tmpl, loc)
end

"""
    AddAlignmentAttributesForRecord(x::AbstractSema, rd::AbstractRecordDecl)
Apply the `#pragma pack` / `#pragma options align` state in effect to `rd`. A no-op when no such
pragma is active.
"""
function AddAlignmentAttributesForRecord(x::AbstractSema, rd::AbstractRecordDecl)
    @check_ptrs x rd
    return clang_Sema_AddAlignmentAttributesForRecord(x, rd)
end

"""
    AddMsStructLayoutForRecord(x::AbstractSema, rd::AbstractRecordDecl)
Apply the `#pragma ms_struct` state in effect to `rd`. A no-op when it is off.
"""
function AddMsStructLayoutForRecord(x::AbstractSema, rd::AbstractRecordDecl)
    @check_ptrs x rd
    return clang_Sema_AddMsStructLayoutForRecord(x, rd)
end

"""
    AddPushedVisibilityAttribute(x::AbstractSema, d::AbstractDecl)
Apply the `#pragma GCC visibility` state in effect to `d`. A no-op when the visibility stack is
empty or `d` already carries explicit visibility.
"""
function AddPushedVisibilityAttribute(x::AbstractSema, d::AbstractDecl)
    @check_ptrs x d
    return clang_Sema_AddPushedVisibilityAttribute(x, d)
end

"""
    AddRangeBasedOptnone(x::AbstractSema, fd::AbstractFunctionDecl)
Add `optnone` to `fd` when a range-based `#pragma clang optimize off` is in effect.
"""
function AddRangeBasedOptnone(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_AddRangeBasedOptnone(x, fd)
end

"""
    AddSectionMSAllocText(x::AbstractSema, fd::AbstractFunctionDecl)
Add the code section named by an active `#pragma alloc_text` to `fd`. A no-op when `fd` has no
identifier or no pragma names it.
"""
function AddSectionMSAllocText(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_AddSectionMSAllocText(x, fd)
end

"""
    AddOptnoneAttributeIfNoConflicts(x::AbstractSema, fd::AbstractFunctionDecl, loc::SourceLocation)
Add `optnone` — and the `noinline` it implies — to `fd` unless `fd` already carries a conflicting
`minsize` / `always_inline`. `loc` is the location blamed for the attribute.
"""
function AddOptnoneAttributeIfNoConflicts(x::AbstractSema, fd::AbstractFunctionDecl, loc::SourceLocation)
    @check_ptrs x fd
    return clang_Sema_AddOptnoneAttributeIfNoConflicts(x, fd, loc)
end

"""
    AddImplicitMSFunctionNoBuiltinAttr(x::AbstractSema, fd::AbstractFunctionDecl)
Add `no_builtin` to `fd` for the names a range-based no_builtin pragma in scope covers. A no-op
when no such pragma is in effect.
"""
function AddImplicitMSFunctionNoBuiltinAttr(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_AddImplicitMSFunctionNoBuiltinAttr(x, fd)
end

"""
    findLocallyScopedExternCDecl(x::AbstractSema, name::DeclarationName) -> NamedDecl
Look up the block-scope `extern "C"` declaration named `name`. Sema keeps these in a side
table instead of the translation unit, so an ordinary qualified lookup does not reach them.
The returned carrier holds NULL when no such declaration was seen.
"""
function findLocallyScopedExternCDecl(x::AbstractSema, name::DeclarationName)
    @check_ptrs x
    return NamedDecl(clang_Sema_findLocallyScopedExternCDecl(x, name))
end

"""
    findMacroSpelling(x::AbstractSema, loc, name) -> Union{SourceLocation,Nothing}
Return the expansion location of `loc` when `loc` is a macro location spelled exactly
`name`, and `nothing` otherwise — including for an ordinary file location.
"""
function findMacroSpelling(x::AbstractSema, loc::SourceLocation, name::AbstractString)
    @check_ptrs x
    out = Ref{CXSourceLocation_}(Base.unsafe_convert(CXSourceLocation_, loc))
    return clang_Sema_findMacroSpelling(x, out, name) ? SourceLocation(out[]) : nothing
end

"""
    handlerCanCatch(x::AbstractSema, handler_ty::QualType, exception_ty::QualType) -> Bool
Return `true` when a handler declared with type `handler_ty` is a match for an exception
object of type `exception_ty` ([except.handle]p3). Emits no diagnostics.
"""
function handlerCanCatch(x::AbstractSema, handler_ty::QualType, exception_ty::QualType)
    @check_ptrs x handler_ty exception_ty
    return clang_Sema_handlerCanCatch(x, handler_ty, exception_ty)
end

"""
    currentModuleIsImplementation(x::AbstractSema) -> Bool
Return `true` when the innermost open module scope is a module implementation unit;
`false` when no module scope is open.
"""
function currentModuleIsImplementation(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_currentModuleIsImplementation(x)
end

"""
    currentModuleIsHeaderUnit(x::AbstractSema) -> Bool
Return `true` when the innermost open module scope is a C++ header unit; `false` when no
module scope is open.
"""
function currentModuleIsHeaderUnit(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_currentModuleIsHeaderUnit(x)
end

"""
    shouldLinkDependentDeclWithPrevious(x::AbstractSema, d, old_d) -> Bool
Return `true` when the dependent declaration `d` should be linked to the earlier
declaration `old_d` as a redeclaration.
"""
function shouldLinkDependentDeclWithPrevious(x::AbstractSema, d::AbstractDecl, old_d::AbstractDecl)
    @check_ptrs x d old_d
    return clang_Sema_shouldLinkDependentDeclWithPrevious(x, d, old_d)
end

"""
    FunctionParamTypesAreEqual(x::AbstractSema, old_ty, new_ty, reversed=false) -> (Bool, UInt32)
Compare the parameter lists of two function prototypes. The first element is `true` when
every parameter type matches; the second is the index of the first differing parameter and
is only meaningful when the first is `false`. `reversed` walks `new_ty`'s list back to
front.

Both prototypes must declare the same number of parameters: clang walks the two lists in
lockstep and asserts that they are the same length.
"""
function FunctionParamTypesAreEqual(x::AbstractSema, old_ty::AbstractFunctionProtoType, new_ty::AbstractFunctionProtoType, reversed::Bool=false)
    @check_ptrs x old_ty new_ty
    n = clang_FunctionProtoType_getNumParams(old_ty)
    @assert n == clang_FunctionProtoType_getNumParams(new_ty) "prototypes must declare the same number of parameters"
    pos = Ref{Cuint}(0)
    eq = clang_Sema_FunctionParamTypesAreEqual(x, old_ty, new_ty, pos, reversed)
    return eq, pos[]
end

"""
    FunctionNonObjectParamTypesAreEqual(x::AbstractSema, old_fd, new_fd, reversed=false) -> (Bool, UInt32)
Compare the non-object parameter lists of two functions, in the same shape as
[`FunctionParamTypesAreEqual`](@ref). Functions with differing non-object parameter counts
are reported unequal without reaching clang.
"""
function FunctionNonObjectParamTypesAreEqual(x::AbstractSema, old_fd::AbstractFunctionDecl, new_fd::AbstractFunctionDecl, reversed::Bool=false)
    @check_ptrs x old_fd new_fd
    getNumNonObjectParams(old_fd) == getNumNonObjectParams(new_fd) || return (false, UInt32(0))
    pos = Ref{Cuint}(0)
    eq = clang_Sema_FunctionNonObjectParamTypesAreEqual(x, old_fd, new_fd, pos, reversed)
    return eq, pos[]
end

"""
    checkAddressOfFunctionIsAvailable(x::AbstractSema, fd, complain=false, loc=SourceLocation(C_NULL)) -> Bool
Return `true` when `fd`'s address may be taken. With `complain` left `false` the call is a
pure query; passing `true` also diagnoses the failure at `loc`.
"""
function checkAddressOfFunctionIsAvailable(x::AbstractSema, fd::AbstractFunctionDecl, complain::Bool=false, loc::SourceLocation=SourceLocation(C_NULL))
    @check_ptrs x fd
    return clang_Sema_checkAddressOfFunctionIsAvailable(x, fd, complain, loc)
end

"""
    ExtractUnqualifiedFunctionType(x::AbstractSema, ty::QualType) -> QualType
Peel one pointer, reference or member-pointer layer off `ty` and drop the qualifiers, so
that `R (*)(A)`, `R (&)(A)` and `R (S::*)(A)` all reduce to `R (A)`. A non-function type
comes back unqualified.
"""
function ExtractUnqualifiedFunctionType(x::AbstractSema, ty::QualType)
    @check_ptrs x ty
    return QualType(clang_Sema_ExtractUnqualifiedFunctionType(x, ty))
end

"""
    forRedeclarationInCurContext(x::AbstractSema) -> CXRedeclarationKind
The redeclaration lookup kind appropriate to Sema's current declaration context.
"""
function forRedeclarationInCurContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_forRedeclarationInCurContext(x)
end

"""
    tryLookupUnambiguousFieldDecl(x::AbstractSema, class_decl, member) -> ValueDecl
The unique field — or indirect field — of `class_decl` named `member`. The returned carrier
holds NULL when the name is not a field of `class_decl` or names more than one.
"""
function tryLookupUnambiguousFieldDecl(x::AbstractSema, class_decl::AbstractRecordDecl, member::AbstractIdentifierInfo)
    @check_ptrs x class_decl member
    return ValueDecl(clang_Sema_tryLookupUnambiguousFieldDecl(x, class_decl, member))
end

"""
    adjustCCAndNoReturn(x::AbstractSema, arg_fn_ty, fn_ty, adjust_exception_spec=false) -> QualType
Rebuild `arg_fn_ty` with `fn_ty`'s calling convention and `noreturn` — and, when
`adjust_exception_spec` is `true`, its exception specification — which is what template
argument deduction wants when matching function types.

Both types must be function prototypes: clang reaches each through an unchecked
`castAs<FunctionProtoType>()`.
"""
function adjustCCAndNoReturn(x::AbstractSema, arg_fn_ty::QualType, fn_ty::QualType, adjust_exception_spec::Bool=false)
    @check_ptrs x arg_fn_ty fn_ty
    @assert isFunctionProtoType(getTypePtr(arg_fn_ty)) "argument type must be a function prototype"
    @assert isFunctionProtoType(getTypePtr(fn_ty)) "pattern type must be a function prototype"
    return QualType(clang_Sema_adjustCCAndNoReturn(x, arg_fn_ty, fn_ty, adjust_exception_spec))
end

"""
    ScalarTypeToBooleanCastKind(scalar_ty::QualType) -> CXCastKind
The cast kind of the conversion from `scalar_ty` to `bool`. `scalar_ty` must be a scalar
type: clang switches over `Type::getScalarTypeKind()`, which asserts `isScalarType()`.

This wraps a static member of `clang::Sema` and therefore takes no `Sema` receiver.
"""
function ScalarTypeToBooleanCastKind(scalar_ty::QualType)
    @check_ptrs scalar_ty
    @assert isScalarType(getTypePtr(scalar_ty)) "type must be a scalar type"
    return clang_Sema_ScalarTypeToBooleanCastKind(scalar_ty)
end

"""
    GetSignedVectorType(x::AbstractSema, v::QualType) -> QualType
The vector type with the same element count and element width as `v` but a signed integer
element type — the type a vector comparison yields. `v` must be a vector type (clang
reaches it through an unchecked `castAs<VectorType>()`).
"""
function GetSignedVectorType(x::AbstractSema, v::QualType)
    @check_ptrs x v
    @assert isVectorType(getTypePtr(v)) "type must be a vector type"
    return QualType(clang_Sema_GetSignedVectorType(x, v))
end

"""
    CompareReferenceRelationship(x::AbstractSema, loc, t1, t2) -> (CXReferenceCompareResult, UInt32)
Compare `cv1 t1` and `cv2 t2` for direct reference binding ([dcl.init.ref]p4). The second
element is the OR of the `CXReferenceConversions` bits describing the conversions that
binding a `t1` reference to a `t2` lvalue would perform; it is a plain integer because a
combination of flags is not one of the enumerators.

Neither `t1` nor `t2` may be a reference type — `t1` is the *pointee* type of the reference
being initialized, and clang asserts both.
"""
function CompareReferenceRelationship(x::AbstractSema, loc::SourceLocation, t1::QualType, t2::QualType)
    @check_ptrs x t1 t2
    @assert !isReferenceType(getTypePtr(t1)) "T1 must be the pointee type of the reference"
    @assert !isReferenceType(getTypePtr(t2)) "T2 must not be a reference type"
    conv = Ref{Cuint}(0)
    res = clang_Sema_CompareReferenceRelationship(x, loc, t1, t2, conv)
    return res, conv[]
end

"""
    FormatStringHasSArg(x::AbstractSema, fexpr::AbstractStringLiteral) -> Bool
Return `true` when the printf/scanf format string `fexpr` contains a `%s` conversion.
`fexpr` must be a narrow string literal: `clang::StringLiteral::getString` asserts
`getCharByteWidth() == 1`.
"""
function FormatStringHasSArg(x::AbstractSema, fexpr::AbstractStringLiteral)
    @check_ptrs x fexpr
    @assert getCharByteWidth(fexpr) == 1 "format string must be a narrow string literal"
    return clang_Sema_FormatStringHasSArg(x, fexpr)
end

"""
    TooManyArguments(num_params::Integer, num_args::Integer, partial_overloading=false) -> Bool
Return `true` when `num_args` exceeds what `num_params` accepts. With
`partial_overloading` and at least one argument, one extra argument is tolerated — the
code-completion position just after a comma.

This wraps a static member of `clang::Sema` and therefore takes no `Sema` receiver.
"""
function TooManyArguments(num_params::Integer, num_args::Integer, partial_overloading::Bool=false)
    return clang_Sema_TooManyArguments(num_params, num_args, partial_overloading)
end

"""
    isExternalWithNoLinkageType(x::AbstractSema, vd::AbstractValueDecl) -> Bool
Return whether `vd` is an external symbol that still cannot be named from another
translation unit, because its type has no linkage and it is not `extern \"C\"`.

`vd` must be a variable or a function — the C++ method documents that as its
precondition.
"""
function isExternalWithNoLinkageType(x::AbstractSema, vd::AbstractValueDecl)
    @check_ptrs x vd
    is_var_or_fn = vd isa AbstractVarDecl || vd isa AbstractFunctionDecl
    @assert is_var_or_fn "declaration must be a variable or a function"
    return clang_Sema_isExternalWithNoLinkageType(x, vd)
end

"""
    hasVisibleDeclaration(x::AbstractSema, d::AbstractNamedDecl) -> Bool
Return whether any declaration of the entity `d` declares is visible to name lookup.

The C++ method also fills an optional list of the modules that would have to be imported
to make `d` visible; that out-parameter is not exposed, so this is the plain predicate.
"""
function hasVisibleDeclaration(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_Sema_hasVisibleDeclaration(x, d)
end

"""
    hasReachableDeclaration(x::AbstractSema, d::AbstractNamedDecl) -> Bool
Return whether any declaration of the entity `d` declares is reachable from the current
translation unit. Every visible declaration is reachable.
"""
function hasReachableDeclaration(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_Sema_hasReachableDeclaration(x, d)
end

"""
    hasVisibleDefinition(x::AbstractSema, d::AbstractNamedDecl, only_need_complete=false)
        -> (Bool, NamedDecl)
Return whether `d` has a visible definition, together with the declaration that would have
to be made visible to expose that definition. The suggestion carrier holds NULL when clang
offers none. Pass `only_need_complete` when a merely complete type is enough.
"""
function hasVisibleDefinition(x::AbstractSema, d::AbstractNamedDecl, only_need_complete::Bool=false)
    @check_ptrs x d
    suggested = Ref{CXNamedDecl}(C_NULL)
    found = clang_Sema_hasVisibleDefinition(x, d, suggested, only_need_complete)
    return found, NamedDecl(suggested[])
end

"""
    hasReachableDefinition(x::AbstractSema, d::AbstractNamedDecl) -> (Bool, NamedDecl)
Return whether `d` has a reachable definition, together with the declaration that would
have to be made reachable to expose it. The suggestion carrier holds NULL when clang
offers none.
"""
function hasReachableDefinition(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    suggested = Ref{CXNamedDecl}(C_NULL)
    found = clang_Sema_hasReachableDefinition(x, d, suggested)
    return found, NamedDecl(suggested[])
end

"""
    IsIntegralPromotion(x::AbstractSema, from, from_ty::QualType, to_ty::QualType) -> Bool
Return whether converting `from_ty` to `to_ty` is an integral promotion (C++ [conv.prom]).
`from` is the expression being converted; it is read only to look through a bit-field and
may be `nothing`.
"""
function IsIntegralPromotion(x::AbstractSema, from::Union{Nothing,AbstractExpr}, from_ty::QualType, to_ty::QualType)
    @check_ptrs x from_ty to_ty
    e = from === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, from)
    return clang_Sema_IsIntegralPromotion(x, e, from_ty, to_ty)
end

"""
    IsBlockPointerConversion(x::AbstractSema, from_ty::QualType, to_ty::QualType)
        -> (Bool, QualType)
Return whether `from_ty` converts to `to_ty` by a block-pointer conversion, together with
the type it converts to. The second element is a null `QualType` when the answer is false.
"""
function IsBlockPointerConversion(x::AbstractSema, from_ty::QualType, to_ty::QualType)
    @check_ptrs x from_ty to_ty
    converted = Ref{CXQualType}(C_NULL)
    ok = clang_Sema_IsBlockPointerConversion(x, from_ty, to_ty, converted)
    return ok, QualType(converted[])
end

"""
    IsQualificationConversion(x::AbstractSema, from_ty, to_ty, c_style=false) -> (Bool, Bool)
Return whether `from_ty` converts to `to_ty` by a qualification conversion (C++ [conv.qual]).
The second element says whether the conversion also changes an Objective-C lifetime
qualifier. `c_style` relaxes the rules the way a C-style cast does.
"""
function IsQualificationConversion(x::AbstractSema, from_ty::QualType, to_ty::QualType, c_style::Bool=false)
    @check_ptrs x from_ty to_ty
    lifetime = Ref{Bool}(false)
    ok = clang_Sema_IsQualificationConversion(x, from_ty, to_ty, c_style, lifetime)
    return ok, lifetime[]
end

"""
    IsFunctionConversion(x::AbstractSema, from_ty::QualType, to_ty::QualType)
        -> (Bool, QualType)
Return whether `from_ty` converts to `to_ty` by a function-pointer conversion (dropping
`noexcept`, adding a parameter's default arguments, ...), together with the type it
converts to. The second element is a null `QualType` when the answer is false.
"""
function IsFunctionConversion(x::AbstractSema, from_ty::QualType, to_ty::QualType)
    @check_ptrs x from_ty to_ty
    result = Ref{CXQualType}(C_NULL)
    ok = clang_Sema_IsFunctionConversion(x, from_ty, to_ty, result)
    return ok, QualType(result[])
end

"""
    isSameOrCompatibleFunctionType(x::AbstractSema, param::QualType, arg::QualType) -> Bool
Return whether the parameter type `param` and the argument type `arg` are the same function
type, or differ only by a function conversion that template argument deduction tolerates.
"""
function isSameOrCompatibleFunctionType(x::AbstractSema, param::QualType, arg::QualType)
    @check_ptrs x param arg
    return clang_Sema_isSameOrCompatibleFunctionType(x, param, arg)
end

"""
    getExprRange(x::AbstractSema, e::AbstractExpr) -> SourceRange
Return the source range `e` spans.
"""
function getExprRange(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    r = clang_Sema_getExprRange(x, e)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    isStdInitializerList(x::AbstractSema, ty::QualType) -> (Bool, QualType)
Return whether `ty` is a specialization of `std::initializer_list`, together with its
element type. The second element is a null `QualType` when the answer is false.

Only meaningful in C++ — clang asserts on the language mode, so the wrapper checks it.
"""
function isStdInitializerList(x::AbstractSema, ty::QualType)
    @check_ptrs x ty
    @assert getCPlusPlus(getLangOpts(x)) "std::initializer_list only exists in C++"
    element = Ref{CXQualType}(C_NULL)
    found = clang_Sema_isStdInitializerList(x, ty, element)
    return found, QualType(element[])
end

"""
    getAsTemplateNameDecl(d::AbstractNamedDecl, allow_function_templates=true,
                          allow_dependent=true) -> NamedDecl
Return the template `d` names once using-shadow declarations have been looked through. The
carrier holds NULL when `d` does not name a template, when `allow_function_templates` is
false and `d` is a function template, or when `allow_dependent` is false and `d` is an
unresolved using declaration.

This wraps a static member of `clang::Sema` and therefore takes no `Sema` receiver.
"""
function getAsTemplateNameDecl(d::AbstractNamedDecl, allow_function_templates::Bool=true, allow_dependent::Bool=true)
    @check_ptrs d
    return NamedDecl(clang_Sema_getAsTemplateNameDecl(d, allow_function_templates, allow_dependent))
end

"""
    getOptimizeOffPragmaLocation(x::AbstractSema) -> SourceLocation
Return the location of the innermost active `#pragma clang optimize off`. An invalid
location means the pragma state is "on".
"""
function getOptimizeOffPragmaLocation(x::AbstractSema)
    @check_ptrs x
    return SourceLocation(clang_Sema_getOptimizeOffPragmaLocation(x))
end

"""
    isValidVarArgType(x::AbstractSema, ty::QualType) -> CXVarArgKind
Return how a value of type `ty` may be passed through a variadic ellipsis: `VAK_Valid`,
`VAK_ValidInCXX11`, `VAK_Undefined`, `VAK_MSVCUndefined` or `VAK_Invalid`.
"""
function isValidVarArgType(x::AbstractSema, ty::QualType)
    @check_ptrs x ty
    return clang_Sema_isValidVarArgType(x, ty)
end

"""
    hasCStrMethod(x::AbstractSema, e::AbstractExpr) -> Bool
Return whether `e`'s type is a class with a `c_str` member that can be called with no
arguments. A non-class type answers false.
"""
function hasCStrMethod(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return clang_Sema_hasCStrMethod(x, e)
end

"""
    areVectorTypesSameSize(x::AbstractSema, src::QualType, dest::QualType) -> Bool
Return whether the two vector types occupy the same number of bits, computed as element
count times raw element width. At least one operand must be a vector type — clang asserts
that.
"""
function areVectorTypesSameSize(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    is_vec = isVectorType(getTypePtr(src)) || isVectorType(getTypePtr(dest))
    @assert is_vec "at least one operand must be a vector type"
    return clang_Sema_areVectorTypesSameSize(x, src, dest)
end

"""
    areLaxCompatibleVectorTypes(x::AbstractSema, src::QualType, dest::QualType) -> Bool
Return whether the two vector types are compatible enough for a lax vector conversion. At
least one operand must be a vector type — clang asserts that.
"""
function areLaxCompatibleVectorTypes(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    is_vec = isVectorType(getTypePtr(src)) || isVectorType(getTypePtr(dest))
    @assert is_vec "at least one operand must be a vector type"
    return clang_Sema_areLaxCompatibleVectorTypes(x, src, dest)
end

"""
    isLaxVectorConversion(x::AbstractSema, src::QualType, dest::QualType) -> Bool
Return whether converting `src` to `dest` is a lax vector conversion permitted by the
current language options. At least one operand must be a vector type — clang asserts that.
"""
function isLaxVectorConversion(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    is_vec = isVectorType(getTypePtr(src)) || isVectorType(getTypePtr(dest))
    @assert is_vec "at least one operand must be a vector type"
    return clang_Sema_isLaxVectorConversion(x, src, dest)
end

"""
    getLocationOfStringLiteralByte(x::AbstractSema, sl::AbstractStringLiteral, byte_no)
        -> SourceLocation
Return the source location of byte `byte_no` of the string literal `sl`, resolving through
the concatenated tokens the literal was spelled with.

`sl` must be a narrow (ordinary or UTF-8) literal and `byte_no` must lie inside it; clang
asserts both.
"""
function getLocationOfStringLiteralByte(x::AbstractSema, sl::AbstractStringLiteral, byte_no::Integer)
    @check_ptrs x sl
    @assert getCharByteWidth(sl) == 1 "only narrow string literals are supported"
    @assert 0 <= byte_no < getByteLength(sl) "byte offset must lie inside the literal"
    return SourceLocation(clang_Sema_getLocationOfStringLiteralByte(x, sl, byte_no))
end

# --- Name, offsetof and instantiation-rebuild node builders ---

"""
    BuildFunctionType(x::AbstractSema, ret_ty, param_types, loc, entity, variadic, cc) -> (QualType, Vector{QualType})
Build the prototyped function type returning `ret_ty` over `param_types`, checked the way a
freshly instantiated template signature wants it.

The parameter list is an in/out argument in C++ — clang takes a `MutableArrayRef` and
rewrites every entry with the adjusted parameter type — so the wrapper returns the adjusted
list beside the type instead of mutating `param_types`. The `ExtProtoInfo` is flattened to
the same `variadic` + calling-convention subset as `getFunctionType(::ASTContext, ...)`.
`entity` names the entity whose type this is and is only used for diagnostics. The returned
carrier holds NULL when a parameter type was rejected.
"""
function BuildFunctionType(x::AbstractSema, ret_ty::AbstractQualType, param_types::AbstractVector{<:AbstractQualType}, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL), variadic::Bool=false, cc::CXCallingConv_=CXCallingConv_CC_C)
    @check_ptrs x ret_ty
    ptrs = CXQualType[Base.unsafe_convert(CXQualType, t) for t in param_types]
    ty = clang_Sema_BuildFunctionType(x, ret_ty, ptrs, length(ptrs), loc, entity, variadic, cc)
    return QualType(ty), QualType[QualType(p) for p in ptrs]
end

"""
    BuildConvertedConstantExpression(x::AbstractSema, from, ty, cce, dest=NamedDecl(C_NULL))
Convert `from` to `ty` under the converted-constant-expression rules of the context `cce`
names ([expr.const]), without evaluating the result.

`dest` names the entity being initialized and is only used for diagnostics; a NULL carrier is
clang's default. Return `nothing` when no implicit conversion sequence exists.
"""
function BuildConvertedConstantExpression(x::AbstractSema, from::AbstractExpr, ty::AbstractQualType, cce::CXCCEKind, dest::AbstractNamedDecl=NamedDecl(C_NULL))
    @check_ptrs x from ty
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildConvertedConstantExpression(x, from, ty, cce, dest, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildDeclarationNameExpr(x::AbstractSema, ss, r, needs_adl, accept_invalid_decl=false)
Build the expression naming what the lookup `r` found — a `DeclRefExpr` for a single
fully-resolved result, an `UnresolvedLookupExpr` otherwise.

`ss` may be an unset `CXXScopeSpec`, which is the ordinary unqualified case. An ambiguous
lookup result has no single meaning here — clang's own callers resolve the ambiguity before
reaching this point — so the wrapper rejects one. Return `nothing` when Sema rejected the
use of the declaration.
"""
function BuildDeclarationNameExpr(x::AbstractSema, ss::AbstractCXXScopeSpec, r::AbstractLookupResult, needs_adl::Bool, accept_invalid_decl::Bool=false)
    @check_ptrs x ss r
    @assert !isAmbiguous(r) "an ambiguous lookup result names no single declaration"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildDeclarationNameExpr(x, ss, r, needs_adl, accept_invalid_decl, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildPredefinedExpr(x::AbstractSema, loc, ik)
Build the predefined identifier `ik` names — `__func__`, `__FUNCTION__`,
`__PRETTY_FUNCTION__` and friends.

Sema resolves the identifier's text against its current declaration context, so it must be
inside a function body: outside one clang emits an extension diagnostic, and rendering that
diagnostic segfaults in `DiagnosticRenderer::emitDiagnostic`. `getCurFunctionDecl` is the
gate and is asserted here (`MARSHALLING.md` §13). Return `nothing` when Sema rejected the
identifier.
"""
function BuildPredefinedExpr(x::AbstractSema, loc::SourceLocation, ik::CXPredefinedIdentKind)
    @check_ptrs x
    @assert getCurFunctionDecl(x).ptr != C_NULL "a predefined identifier needs a current function"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildPredefinedExpr(x, loc, ik, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildBuiltinOffsetOf(x::AbstractSema, builtin_loc, tsinfo, loc_starts, loc_ends, is_brackets, idents, indices, rparen_loc)
Build `__builtin_offsetof(T, a.b[i].c)` for the type `tsinfo` names.

`clang::Sema::OffsetOfComponent` is a value type with no handle, so a component crosses as
its fields: five parallel collections read in lockstep. `is_brackets[i]` selects the union
arm — `true` takes `indices[i]` (an `[expr]` subscript), `false` takes `idents[i]` (a
`.member` name) — and the unused collection's slot at that index may be a NULL carrier.

Clang assumes the first component is a field designator and reaches the record through the
type `tsinfo` names, so the wrapper restates both preconditions. Return `nothing` when a
component named no member of the record.
"""
function BuildBuiltinOffsetOf(x::AbstractSema, builtin_loc::SourceLocation, tsinfo::AbstractTypeSourceInfo, loc_starts::AbstractVector{SourceLocation}, loc_ends::AbstractVector{SourceLocation}, is_brackets::AbstractVector{Bool}, idents::AbstractVector{<:AbstractIdentifierInfo}, indices::AbstractVector{<:AbstractExpr}, rparen_loc::SourceLocation)
    @check_ptrs x tsinfo
    n = length(is_brackets)
    @assert n > 0 "__builtin_offsetof needs at least one component"
    @assert length(loc_starts) == n && length(loc_ends) == n && length(idents) == n && length(indices) == n "every component collection must have the same length"
    @assert !is_brackets[1] "the first component must be a field designator, not a subscript"
    ty = getTypePtr(getType(tsinfo))
    @assert isRecordType(ty) || isDependentType(ty) "offsetof needs a record or dependent type"
    starts = CXSourceLocation_[Base.unsafe_convert(CXSourceLocation_, l) for l in loc_starts]
    ends = CXSourceLocation_[Base.unsafe_convert(CXSourceLocation_, l) for l in loc_ends]
    brackets = Bool[b for b in is_brackets]
    ids = CXIdentifierInfo[Base.unsafe_convert(CXIdentifierInfo, i) for i in idents]
    idx = CXExpr[Base.unsafe_convert(CXExpr, e) for e in indices]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildBuiltinOffsetOf(x, builtin_loc, tsinfo, starts, ends, brackets, ids, idx, n, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildSourceLocExpr(x::AbstractSema, kind, result_ty, builtin_loc, rparen_loc, parent_context)
Build the source-location builtin `kind` names — `__builtin_LINE()`, `__builtin_FILE()`,
`__builtin_source_location()` and friends — reported against `parent_context`.

`result_ty` is stored unchecked, so it must be the type the kind implies: an integer for
`Line`/`Column`, `const char *` for `File`/`FileName`/`Function`/`FuncSig`, and the
`std::source_location` implementation type for `SourceLocStruct`. `parent_context` may be a
NULL carrier. Return `nothing` when Sema rejected the request.
"""
function BuildSourceLocExpr(x::AbstractSema, kind::CXSourceLocIdentKind, result_ty::AbstractQualType, builtin_loc::SourceLocation, rparen_loc::SourceLocation, parent_context::AbstractDeclContext)
    @check_ptrs x result_ty
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildSourceLocExpr(x, kind, result_ty, builtin_loc, rparen_loc, parent_context, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXThrow(x::AbstractSema, op_loc, ex, is_thrown_var_in_scope=false)
Build `throw ex`, copy-initializing the exception object from `ex`.

`ex` may be a NULL-carrying `Expr_`, which builds the re-throw form `throw;`.
`is_thrown_var_in_scope` records that the operand names a variable whose scope encloses the
throw, which only affects diagnostics. Sema diagnoses the throw when C++ exceptions are
disabled for the translation unit. Return `nothing` when the exception object could not be
initialized from `ex`.
"""
function BuildCXXThrow(x::AbstractSema, op_loc::SourceLocation, ex::AbstractExpr, is_thrown_var_in_scope::Bool=false)
    @check_ptrs x
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXThrow(x, op_loc, ex, is_thrown_var_in_scope, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildTemplateIdExpr(x::AbstractSema, ss, template_kw_loc, r, requires_adl, template_args)
Build the template-id expression `name<args>` over the templates the lookup `r` found.

`clang::Sema::BuildTemplateIdExpr` asserts both that `r` is not ambiguous and that either
`template_args` is non-NULL or `template_kw_loc` is valid, so the wrapper restates both.
Return `nothing` when Sema rejected the template arguments.
"""
function BuildTemplateIdExpr(x::AbstractSema, ss::AbstractCXXScopeSpec, template_kw_loc::SourceLocation, r::AbstractLookupResult, requires_adl::Bool, template_args::TemplateArgumentListInfo=TemplateArgumentListInfo(C_NULL))
    @check_ptrs x ss r
    @assert !isAmbiguous(r) "an ambiguous lookup result names no single template"
    @assert template_args.ptr != C_NULL || isValid(template_kw_loc) "a template-id needs an argument list or the `template` keyword"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildTemplateIdExpr(x, ss, template_kw_loc, r, requires_adl, template_args, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    RebuildTypeInCurrentInstantiation(x::AbstractSema, t, loc, name=DeclarationName(C_NULL)) -> TypeSourceInfo
Rebuild `t` against Sema's current instantiation, resolving the members of the current
instantiation that could not be resolved while the template was parsed.

A type that is not instantiation-dependent needs no rebuilding and is returned as it came
in. `name` names the entity whose type this is and is only used for diagnostics. The
returned carrier holds NULL when the rebuild failed.
"""
function RebuildTypeInCurrentInstantiation(x::AbstractSema, t::AbstractTypeSourceInfo, loc::SourceLocation, name::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x t
    return TypeSourceInfo(clang_Sema_RebuildTypeInCurrentInstantiation(x, t, loc, name))
end

"""
    RebuildNestedNameSpecifierInCurrentInstantiation(x::AbstractSema, ss) -> Bool
Rebuild `ss`'s qualifier against Sema's current instantiation, adopting the rebuilt
qualifier into `ss` on success.

Return `true` on *failure*, matching `clang::Sema`; an unset or invalid `ss` is one of the
failing cases.
"""
function RebuildNestedNameSpecifierInCurrentInstantiation(x::AbstractSema, ss::AbstractCXXScopeSpec)
    @check_ptrs x ss
    return clang_Sema_RebuildNestedNameSpecifierInCurrentInstantiation(x, ss)
end

"""
    RebuildExprInCurrentInstantiation(x::AbstractSema, e)
Rebuild `e` against Sema's current instantiation.

The rebuilder only reconstructs the nodes it has to, so a node with nothing left to resolve
comes back as it went in. Return `nothing` when the rebuild failed.
"""
function RebuildExprInCurrentInstantiation(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_RebuildExprInCurrentInstantiation(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    RebuildTemplateParamsInCurrentInstantiation(x::AbstractSema, params) -> Bool
Rebuild the type of every non-type parameter of `params` against Sema's current
instantiation, rewriting each parameter in place.

Type parameters carry nothing to rebuild and are skipped; a template template parameter
recurses into its own parameter list. Return `true` on *failure*, matching `clang::Sema`.
"""
function RebuildTemplateParamsInCurrentInstantiation(x::AbstractSema, params::AbstractTemplateParameterList)
    @check_ptrs x params
    return clang_Sema_RebuildTemplateParamsInCurrentInstantiation(x, params)
end

# --- Conversion and operand checks ---------------------------------------------------------
# Each wrapper below runs one Sema check over an expression or a pair of types that already
# exist. None of them drives the parser; the ones that rewrite their operand return the
# rewritten expression rather than mutating in place.

"""
    TryImplicitConversion(x::AbstractSema, from, to_type, ics, suppress_user_conversions=true,
                          allow_explicit=CXAllowedExplicit_None, in_overload_resolution=false,
                          c_style=false, allow_objc_writeback_conversion=false) -> ics
Compute the implicit conversion sequence converting `from` to `to_type` and write it into
`ics`, which the caller makes with `ImplicitConversionSequence()` and releases with `dispose`.
The sequence is returned so the call can be chained into a query on it.

Nothing is diagnosed and `from` is left untouched: a conversion that does not exist comes back
as a bad sequence, which `getKind` reports.
"""
function TryImplicitConversion(x::AbstractSema, from::AbstractExpr, to_type::QualType, ics::AbstractImplicitConversionSequence, suppress_user_conversions::Bool=true, allow_explicit::CXAllowedExplicit=CXAllowedExplicit_None, in_overload_resolution::Bool=false, c_style::Bool=false, allow_objc_writeback_conversion::Bool=false)
    @check_ptrs x from to_type ics
    clang_Sema_TryImplicitConversion(x, from, to_type, suppress_user_conversions, allow_explicit, in_overload_resolution, c_style, allow_objc_writeback_conversion, ics)
    return ics
end

"""
    CheckPointerConversion(x::AbstractSema, from, to_type, ignore_base_access=false,
                           diagnose=true) -> (Bool, CXCastKind)
Return whether converting `from` to the pointer type `to_type` is ill-formed, together with
the cast kind the conversion would use. `ignore_base_access` skips the access check on a
derived-to-base step; `diagnose` selects whether a rejection is reported.

The base-specifier path clang fills alongside the cast kind is not exposed.
"""
function CheckPointerConversion(x::AbstractSema, from::AbstractExpr, to_type::QualType, ignore_base_access::Bool=false, diagnose::Bool=true)
    @check_ptrs x from to_type
    kind = Ref{CXCastKind}(CXCastKind_CK_Dependent)
    failed = clang_Sema_CheckPointerConversion(x, from, to_type, kind, ignore_base_access, diagnose)
    return failed, kind[]
end

"""
    CheckLiteralKind(x::AbstractSema, from::AbstractExpr) -> CXObjCLiteralKind
Return which Objective-C literal form `from` is, after parentheses and implicit casts are
stripped. The classification is total over every expression — anything that is not one of the
literal forms answers `CXObjCLiteralKind_LK_None` — and nothing is diagnosed.
"""
function CheckLiteralKind(x::AbstractSema, from::AbstractExpr)
    @check_ptrs x from
    return clang_Sema_CheckLiteralKind(x, from)
end

"""
    CheckUnevaluatedOperand(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Check `e` as the operand of an unevaluated context and return the checked expression, or
`nothing` when it is ill-formed, which Sema has then already diagnosed.
"""
function CheckUnevaluatedOperand(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_CheckUnevaluatedOperand(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    CheckLValueToRValueConversionOperand(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Check `e` as the operand an lvalue-to-rvalue conversion is about to be applied to, and return
the checked expression, or `nothing` when it is ill-formed.
"""
function CheckLValueToRValueConversionOperand(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_CheckLValueToRValueConversionOperand(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    CheckLoopHintExpr(x::AbstractSema, e::AbstractExpr, loc::SourceLocation) -> Bool
Return `true` when `e` is not usable as the argument of a `#pragma clang loop` hint, which is
diagnosed at `loc`.
"""
function CheckLoopHintExpr(x::AbstractSema, e::AbstractExpr, loc::SourceLocation)
    @check_ptrs x e
    return clang_Sema_CheckLoopHintExpr(x, e, loc)
end

"""
    CheckUnaryExprOrTypeTraitOperand(x::AbstractSema, e, kind::CXUnaryExprOrTypeTrait) -> Bool
`CheckUnaryExprOrTypeTraitOperand(Expr *, UnaryExprOrTypeTrait)` overload: return `true` when
`e` is not a valid operand of the `sizeof`/`alignof`/`vec_step` family, which is diagnosed.

`e`'s type must not be a reference type — clang asserts on it.
"""
function CheckUnaryExprOrTypeTraitOperand(x::AbstractSema, e::AbstractExpr, kind::CXUnaryExprOrTypeTrait)
    @check_ptrs x e
    qty = getType(e)
    @assert !isNull(qty) "an unevaluated string literal is not a sizeof/alignof operand"
    @assert !isReferenceType(getTypePtr(qty)) "operand may not have reference type"
    return clang_Sema_CheckUnaryExprOrTypeTraitOperand(x, e, kind)
end

"""
    CheckSingleAssignmentConstraints(x::AbstractSema, lhs_type, rhs, diagnose=true,
                                     diagnose_cf_audited=false,
                                     convert_rhs=true) -> (CXAssignConvertType, Union{Nothing,Expr_})
Return whether a value of `rhs`'s type may initialize an object of `lhs_type` — and by which
extension when the answer is not `CXAssignConvertType_Compatible` — together with the
right-hand side after the conversion, or `nothing` when it is no longer usable.

With `convert_rhs` the returned expression carries the conversions the assignment performs;
without it `rhs` comes back unchanged, and clang then also requires `diagnose` to be `false`,
which this wrapper restates.
"""
function CheckSingleAssignmentConstraints(x::AbstractSema, lhs_type::QualType, rhs::AbstractExpr, diagnose::Bool=true, diagnose_cf_audited::Bool=false, convert_rhs::Bool=true)
    @check_ptrs x lhs_type rhs
    @assert convert_rhs || !diagnose "diagnostics require the right-hand side to be converted"
    converted = Ref{CXExpr}(C_NULL)
    invalid = Ref{Bool}(false)
    res = clang_Sema_CheckSingleAssignmentConstraints(x, lhs_type, rhs, diagnose, diagnose_cf_audited, convert_rhs, converted, invalid)
    return res, invalid[] ? nothing : Expr_(converted[])
end

"""
    CheckTransparentUnionArgumentConstraints(x::AbstractSema, arg_type,
                                             rhs) -> (CXAssignConvertType, Union{Nothing,Expr_})
Return whether `rhs` may initialize the transparent union `arg_type`, together with the
right-hand side after the conversion. An `arg_type` that is not a union carrying the
`transparent_union` attribute answers `CXAssignConvertType_Incompatible`.
"""
function CheckTransparentUnionArgumentConstraints(x::AbstractSema, arg_type::QualType, rhs::AbstractExpr)
    @check_ptrs x arg_type rhs
    converted = Ref{CXExpr}(C_NULL)
    invalid = Ref{Bool}(false)
    res = clang_Sema_CheckTransparentUnionArgumentConstraints(x, arg_type, rhs, converted, invalid)
    return res, invalid[] ? nothing : Expr_(converted[])
end

"""
    CheckExceptionSpecCompatibility(x::AbstractSema, from::AbstractExpr, to_type::QualType) -> Bool
Return `true` when `from`'s exception specification is incompatible with the one carried by
the function `to_type` designates, which is diagnosed. A `to_type` that does not resolve to a
function type answers `false`.
"""
function CheckExceptionSpecCompatibility(x::AbstractSema, from::AbstractExpr, to_type::QualType)
    @check_ptrs x from to_type
    return clang_Sema_CheckExceptionSpecCompatibility(x, from, to_type)
end

"""
    CheckVectorCast(x::AbstractSema, rng::SourceRange, vector_ty, ty) -> (Bool, CXCastKind)
Return whether a cast from `ty` to the vector type `vector_ty` is ill-formed, together with
the cast kind the conversion would use. A rejection is diagnosed over `rng`.

`vector_ty` must be a vector type: clang asserts on it before comparing the two widths.
"""
function CheckVectorCast(x::AbstractSema, rng::SourceRange, vector_ty::QualType, ty::QualType)
    @check_ptrs x vector_ty ty
    @assert isVectorType(getTypePtr(vector_ty)) "destination type must be a vector type"
    kind = Ref{CXCastKind}(CXCastKind_CK_Dependent)
    failed = clang_Sema_CheckVectorCast(x, getBeginLoc(rng), getEndLoc(rng), vector_ty, ty, kind)
    return failed, kind[]
end

"""
    CheckObjCARCUnavailableWeakConversion(x::AbstractSema, cast_type, expr_type) -> Bool
Apply the ARC unavailable-`__weak` rule to a conversion from `expr_type` to `cast_type`. A
pure comparison of the two canonicalized types; nothing is diagnosed.
"""
function CheckObjCARCUnavailableWeakConversion(x::AbstractSema, cast_type::QualType, expr_type::QualType)
    @check_ptrs x cast_type expr_type
    return clang_Sema_CheckObjCARCUnavailableWeakConversion(x, cast_type, expr_type)
end

"""
    CheckSwitchCondition(x::AbstractSema, switch_loc, cond) -> Union{Nothing,Expr_}
Convert `cond` to the condition of a `switch`, applying the contextual conversion to an
integral or enumeration type. Return `nothing` when the conversion is ill-formed, which is
diagnosed at `switch_loc`.
"""
function CheckSwitchCondition(x::AbstractSema, switch_loc::SourceLocation, cond::AbstractExpr)
    @check_ptrs x cond
    invalid = Ref{Bool}(false)
    r = clang_Sema_CheckSwitchCondition(x, switch_loc, cond, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    CheckCXXBooleanCondition(x::AbstractSema, cond::AbstractExpr, is_constexpr=false) -> Union{Nothing,Expr_}
Convert `cond` to `bool` with the C++ contextual-conversion rules; `is_constexpr` asks for the
constexpr-if rules. Return `nothing` when the conversion is ill-formed, which is diagnosed.
"""
function CheckCXXBooleanCondition(x::AbstractSema, cond::AbstractExpr, is_constexpr::Bool=false)
    @check_ptrs x cond
    invalid = Ref{Bool}(false)
    r = clang_Sema_CheckCXXBooleanCondition(x, cond, is_constexpr, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    VerifyBitField(x::AbstractSema, field_loc, field_name, field_ty, is_ms_struct,
                   bit_width) -> Union{Nothing,Expr_}
Verify that `bit_width` is a valid bit-field width for a field of type `field_ty`, and return
the converted width expression. `field_name` is the field's identifier, or `nothing` for an
unnamed bit field. Return `nothing` when the width is invalid, which is diagnosed at
`field_loc`.
"""
function VerifyBitField(x::AbstractSema, field_loc::SourceLocation, field_name::Union{Nothing,AbstractIdentifierInfo}, field_ty::QualType, is_ms_struct::Bool, bit_width::AbstractExpr)
    @check_ptrs x field_ty bit_width
    n = field_name === nothing ? CXIdentifierInfo(C_NULL) : Base.unsafe_convert(CXIdentifierInfo, field_name)
    invalid = Ref{Bool}(false)
    r = clang_Sema_VerifyBitField(x, field_loc, n, field_ty, is_ms_struct, bit_width, invalid)
    return invalid[] ? nothing : Expr_(r)
end

# --- Declaration groups, default-argument conversion and template deduction ---
#
# None of these needs the parser to be running. The two `Convert*` conversions run real
# semantic analysis against the live `Sema` and report an ill-formed conversion both as
# `nothing` and through its `DiagnosticsEngine`; the deduction entry points report through
# a `CXTemplateDeductionResult` and a caller-owned [`TemplateDeductionInfo`](@ref) instead.

"""
    ConvertDeclToDeclGroup(x::AbstractSema, d::AbstractDecl, owned_type=nothing) -> DeclGroupRef
Wrap `d` in a `DeclGroupRef`, together with `owned_type` — the tag declaration a declaration
statement owns, as in `struct S {} s;` — when one is given.
"""
function ConvertDeclToDeclGroup(x::AbstractSema, d::AbstractDecl, owned_type::Union{Nothing,AbstractDecl}=nothing)
    @check_ptrs x d
    owned = owned_type === nothing ? CXDecl(C_NULL) : Base.unsafe_convert(CXDecl, owned_type)
    return DeclGroupRef(clang_Sema_ConvertDeclToDeclGroup(x, d, owned))
end

"""
    ConvertParamDefaultArgument(x::AbstractSema, param, default_arg, equal_loc) -> Union{Nothing,Expr_}
Convert `default_arg` to `param`'s type the way a parameter's `= <expr>` initializer is
converted, returning the converted expression. The result is *not* stored on `param` —
[`SetParamDefaultArgument`](@ref) does that. Return `nothing` when the conversion is
ill-formed, which is diagnosed at `equal_loc`.
"""
function ConvertParamDefaultArgument(x::AbstractSema, param::AbstractParmVarDecl, default_arg::AbstractExpr, equal_loc::SourceLocation)
    @check_ptrs x param default_arg
    invalid = Ref{Bool}(false)
    r = clang_Sema_ConvertParamDefaultArgument(x, param, default_arg, equal_loc, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    ConvertMemberDefaultInitExpression(x::AbstractSema, fd, init_expr, init_loc) -> Union{Nothing,Expr_}
The same conversion for a default member initializer `int m = <expr>;`, returning the
converted expression. The result is not stored on `fd`. Return `nothing` when the conversion
is ill-formed, which is diagnosed.
"""
function ConvertMemberDefaultInitExpression(x::AbstractSema, fd::AbstractFieldDecl, init_expr::AbstractExpr, init_loc::SourceLocation)
    @check_ptrs x fd init_expr
    invalid = Ref{Bool}(false)
    r = clang_Sema_ConvertMemberDefaultInitExpression(x, fd, init_expr, init_loc, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    TemplateParameterListsAreEqual(x::AbstractSema, new_list, old_list, complain, kind, loc) -> Bool
Compare two template parameter lists structurally, the way clang matches redeclarations.
`complain = false` makes this a pure query; `complain = true` reports every mismatch through
Sema's `DiagnosticsEngine`. Both lists must be non-null — clang reads their sizes first.
"""
function TemplateParameterListsAreEqual(x::AbstractSema, new_list::AbstractTemplateParameterList, old_list::AbstractTemplateParameterList, complain::Bool, kind::CXTemplateParameterListEqualKind, loc::SourceLocation)
    @check_ptrs x new_list old_list
    return clang_Sema_TemplateParameterListsAreEqual(x, new_list, old_list, complain, kind, loc)
end

"""
    DeduceTemplateArguments(x::AbstractSema, partial, args, info) -> CXTemplateDeductionResult
Match `args` against the argument pattern of the class template partial specialization
`partial`. On `CXTemplateDeductionResult_TDK_Success` the deduced arguments are read back
with [`takeSugared`](@ref)`(info)`; on failure the parameter and arguments the mismatch was
about stay in `info`.
"""
function DeduceTemplateArguments(x::AbstractSema, partial::AbstractClassTemplatePartialSpecializationDecl, args::TemplateArgumentList, info::TemplateDeductionInfo)
    @check_ptrs x partial args info
    return clang_Sema_DeduceTemplateArguments(x, partial, args, info)
end

"""
    DeduceTemplateArguments(x::AbstractSema, partial::AbstractVarTemplatePartialSpecializationDecl,
                            args, info) -> CXTemplateDeductionResult
The variable-template twin of the call above, with the same protocol. C has no overloading so the
two reach different bindings, but on this side they are one name and dispatch picks.
"""
function DeduceTemplateArguments(x::AbstractSema, partial::AbstractVarTemplatePartialSpecializationDecl, args::TemplateArgumentList, info::TemplateDeductionInfo)
    @check_ptrs x partial args info
    return clang_Sema_DeduceTemplateArgumentsVarPartial(x, partial, args, info)
end

"""
    DeduceTemplateArguments(x::AbstractSema, ft::AbstractFunctionTemplateDecl,
                            info::TemplateDeductionInfo;
                            explicit_args=nothing, arg_function_type=nothing,
                            is_address_of_function::Bool=false)
        -> Tuple{CXTemplateDeductionResult,Union{FunctionDecl,Nothing}}
Deduce a specialization of `ft` from explicit template arguments and/or a target function type.

Both inputs are optional; omitting both is [temp.arg.explicit]p3's form, which reports
`TDK_Incomplete` unless every parameter has a default. The specialization comes back only on
`TDK_Success`, and is `nothing` otherwise.

`arg_function_type`, when given, must be a function *prototype* type — clang casts to one
unchecked while adjusting the calling convention.
"""
function DeduceTemplateArguments(x::AbstractSema, ft::AbstractFunctionTemplateDecl, info::TemplateDeductionInfo; explicit_args::Union{TemplateArgumentListInfo,Nothing}=nothing, arg_function_type::Union{AbstractQualType,Nothing}=nothing, is_address_of_function::Bool=false)
    @check_ptrs x ft info
    if arg_function_type !== nothing
        @assert isFunctionProtoType(getTypePtr(arg_function_type)) "arg_function_type must be a function prototype type"
    end
    ea = explicit_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_args)
    aft = arg_function_type === nothing ? CXQualType(C_NULL) : Base.unsafe_convert(CXQualType, arg_function_type)
    spec = Ref{CXFunctionDecl}(CXFunctionDecl(C_NULL))
    r = clang_Sema_DeduceTemplateArgumentsFunctionTemplate(x, ft, ea, aft, spec, info, is_address_of_function)
    got = spec[] == CXFunctionDecl(C_NULL) ? nothing : FunctionDecl(spec[])
    return r, got
end

"""
    DeduceAutoType(x::AbstractSema, auto_type_loc, initializer, info, dependent_deduction=false,
                   ignore_constraints=false) -> (CXTemplateDeductionResult, Union{Nothing,QualType})
Deduce the type the `auto` in `auto_type_loc` stands for from `initializer`, returning the
outcome and the deduced type (`nothing` unless deduction succeeded). `dependent_deduction`
allows a dependent initializer and `ignore_constraints` skips the constrained-`auto` check.

The type located by `auto_type_loc` must contain an `auto` type: clang reaches it through an
unchecked `getContainedAutoType()`, so the wrapper asserts it first.
"""
function DeduceAutoType(x::AbstractSema, auto_type_loc::TypeLoc, initializer::AbstractExpr, info::TemplateDeductionInfo, dependent_deduction::Bool=false, ignore_constraints::Bool=false)
    @check_ptrs x auto_type_loc initializer info
    contained = getContainedAutoType(getTypePtr(getType(auto_type_loc)))
    @assert contained.ptr != C_NULL "the located type must contain an `auto` type"
    result = Ref{CXQualType}(C_NULL)
    r = clang_Sema_DeduceAutoType(x, auto_type_loc, initializer, result, info, dependent_deduction, ignore_constraints)
    return r, (result[] == C_NULL ? nothing : QualType(result[]))
end

# --- Defining the implicitly-declared special members ---
#
# Each function below synthesizes the body of a special member that has so far only been
# declared (by the matching `DeclareImplicit*` or `Lookup*` call) and marks it used, so every
# one of them mutates the AST. `clang::Sema` asserts that the member is defaulted, is the
# special member the call names, has no body yet and is not deleted; each wrapper restates
# those four conditions. A definition that would be ill-formed leaves the member invalid
# instead, diagnosed through Sema's `DiagnosticsEngine`.

"""
    DefineImplicitDefaultConstructor(x::AbstractSema, loc::SourceLocation, ctor)
Synthesize the body of the implicitly-declared default constructor `ctor` at `loc` and mark
it used. `ctor` must be a defaulted, body-less, non-deleted default constructor.
"""
function DefineImplicitDefaultConstructor(x::AbstractSema, loc::SourceLocation, ctor::AbstractCXXConstructorDecl)
    @check_ptrs x ctor
    @assert isDefaulted(ctor) && isDefaultConstructor(ctor) && !doesThisDeclarationHaveABody(ctor) && !isDeleted(ctor) "ctor must be a defaulted, body-less, non-deleted default ctor"
    clang_Sema_DefineImplicitDefaultConstructor(x, loc, ctor)
    return nothing
end

"""
    DefineImplicitDestructor(x::AbstractSema, loc::SourceLocation, dtor)
Synthesize the body of the implicitly-declared destructor `dtor` at `loc` and mark it used.
`dtor` must be defaulted, body-less and not deleted.
"""
function DefineImplicitDestructor(x::AbstractSema, loc::SourceLocation, dtor::AbstractCXXDestructorDecl)
    @check_ptrs x dtor
    @assert isDefaulted(dtor) && !doesThisDeclarationHaveABody(dtor) && !isDeleted(dtor) "dtor must be a defaulted, body-less, non-deleted destructor"
    clang_Sema_DefineImplicitDestructor(x, loc, dtor)
    return nothing
end

"""
    DefineImplicitCopyConstructor(x::AbstractSema, loc::SourceLocation, ctor)
Synthesize the body of the implicitly-declared copy constructor `ctor` at `loc` and mark it
used. `ctor` must be a defaulted, body-less, non-deleted copy constructor.
"""
function DefineImplicitCopyConstructor(x::AbstractSema, loc::SourceLocation, ctor::AbstractCXXConstructorDecl)
    @check_ptrs x ctor
    @assert isDefaulted(ctor) && isCopyConstructor(ctor) && !doesThisDeclarationHaveABody(ctor) && !isDeleted(ctor) "ctor must be a defaulted, body-less, non-deleted copy ctor"
    clang_Sema_DefineImplicitCopyConstructor(x, loc, ctor)
    return nothing
end

"""
    DefineImplicitMoveConstructor(x::AbstractSema, loc::SourceLocation, ctor)
Synthesize the body of the implicitly-declared move constructor `ctor` at `loc` and mark it
used. `ctor` must be a defaulted, body-less, non-deleted move constructor.
"""
function DefineImplicitMoveConstructor(x::AbstractSema, loc::SourceLocation, ctor::AbstractCXXConstructorDecl)
    @check_ptrs x ctor
    @assert isDefaulted(ctor) && isMoveConstructor(ctor) && !doesThisDeclarationHaveABody(ctor) && !isDeleted(ctor) "ctor must be a defaulted, body-less, non-deleted move ctor"
    clang_Sema_DefineImplicitMoveConstructor(x, loc, ctor)
    return nothing
end

"""
    DefineImplicitCopyAssignment(x::AbstractSema, loc::SourceLocation, md)
Synthesize the body of the implicitly-declared copy assignment operator `md` at `loc` and
mark it used. `md` must be a defaulted, body-less, non-deleted copy assignment operator.
"""
function DefineImplicitCopyAssignment(x::AbstractSema, loc::SourceLocation, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    @assert isDefaulted(md) && isCopyAssignmentOperator(md) && !doesThisDeclarationHaveABody(md) && !isDeleted(md) "md must be a defaulted, body-less, non-deleted copy assignment"
    clang_Sema_DefineImplicitCopyAssignment(x, loc, md)
    return nothing
end

"""
    DefineImplicitMoveAssignment(x::AbstractSema, loc::SourceLocation, md)
Synthesize the body of the implicitly-declared move assignment operator `md` at `loc` and
mark it used. `md` must be a defaulted, body-less, non-deleted move assignment operator.
"""
function DefineImplicitMoveAssignment(x::AbstractSema, loc::SourceLocation, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    @assert isDefaulted(md) && isMoveAssignmentOperator(md) && !doesThisDeclarationHaveABody(md) && !isDeleted(md) "md must be a defaulted, body-less, non-deleted move assignment"
    clang_Sema_DefineImplicitMoveAssignment(x, loc, md)
    return nothing
end

# --- Lookup-result filters and declaration-level pragma helpers ---
#
# The three filters narrow a `LookupResult` the caller owns and dispose of; Sema itself is
# only read by them, so they are safe between parses. The remaining three record state on a
# declaration or in Sema's own tables.

"""
    FilterAcceptableTemplateNames(x::AbstractSema, r::AbstractLookupResult,
                                  allow_function_templates=true, allow_dependent=true)
Drop from `r` every result that cannot be read as a template name, replacing a result that
reaches a template through a using-shadow declaration by the template itself.
`allow_function_templates` keeps function templates; `allow_dependent` keeps
unresolved-using declarations that might name templates.
"""
function FilterAcceptableTemplateNames(x::AbstractSema, r::AbstractLookupResult, allow_function_templates::Bool=true, allow_dependent::Bool=true)
    @check_ptrs x r
    clang_Sema_FilterAcceptableTemplateNames(x, r, allow_function_templates, allow_dependent)
    return nothing
end

"""
    FilterLookupForScope(x::AbstractSema, r::AbstractLookupResult, ctx::AbstractDeclContext,
                         sp::AbstractScope, consider_linkage=false,
                         allow_inline_namespace=false)
Drop from `r` every declaration that is not in scope in `ctx`/`sp`. `consider_linkage` keeps
an out-of-scope previous declaration that would still redeclare, and
`allow_inline_namespace` lets an enclosing inline namespace count as the same scope.
"""
function FilterLookupForScope(x::AbstractSema, r::AbstractLookupResult, ctx::AbstractDeclContext, sp::AbstractScope, consider_linkage::Bool=false, allow_inline_namespace::Bool=false)
    @check_ptrs x r ctx sp
    clang_Sema_FilterLookupForScope(x, r, ctx, sp, consider_linkage, allow_inline_namespace)
    return nothing
end

"""
    FilterUsingLookup(x::AbstractSema, sp::AbstractScope, r::AbstractLookupResult)
Drop from `r` everything already in scope in Sema's current context, leaving what a
using-declaration naming those results would newly introduce.
"""
function FilterUsingLookup(x::AbstractSema, sp::AbstractScope, r::AbstractLookupResult)
    @check_ptrs x sp r
    clang_Sema_FilterUsingLookup(x, sp, r)
    return nothing
end

"""
    setTagNameForLinkagePurposes(x::AbstractSema, tag::AbstractTagDecl, td)
Give the unnamed tag definition `tag` the typedef name `td` it takes on for linkage
purposes. A defined no-op when `tag` is invalid, already has a name for linkage, or `td`'s
underlying type is not `tag`'s own type. `tag` must be a definition — clang asserts on that
once the name-for-linkage check has passed.
"""
function setTagNameForLinkagePurposes(x::AbstractSema, tag::AbstractTagDecl, td::AbstractTypedefNameDecl)
    @check_ptrs x tag td
    @assert isThisDeclarationADefinition(tag) "tag must be a tag definition"
    clang_Sema_setTagNameForLinkagePurposes(x, tag, td)
    return nothing
end

"""
    RegisterTypeTagForDatatype(x::AbstractSema, argument_kind, magic_value::Integer,
                               ty::AbstractQualType, layout_compatible=false,
                               must_be_null=false)
Register `magic_value` as a type tag mapping to `ty` for the `type_tag_for_datatype`
argument kind named by `argument_kind`. This only inserts into a Sema-side table: nothing in
the AST changes and nothing is diagnosed, and the first registration of a given
`(argument_kind, magic_value)` pair wins.
"""
function RegisterTypeTagForDatatype(x::AbstractSema, argument_kind::AbstractIdentifierInfo, magic_value::Integer, ty::AbstractQualType, layout_compatible::Bool=false, must_be_null::Bool=false)
    @check_ptrs x argument_kind ty
    clang_Sema_RegisterTypeTagForDatatype(x, argument_kind, UInt64(magic_value), ty, layout_compatible, must_be_null)
    return nothing
end

"""
    AddCFAuditedAttribute(x::AbstractSema, d::AbstractDecl)
Add to `d` the CoreFoundation ownership-transfer attribute implied by an open
`#pragma clang arc_cf_code_audited` region. A no-op outside such a region and when `d`
already carries an audited or unknown-transfer attribute.
"""
function AddCFAuditedAttribute(x::AbstractSema, d::AbstractDecl)
    @check_ptrs x d
    clang_Sema_AddCFAuditedAttribute(x, d)
    return nothing
end

"""
    AddPragmaAttributes(x::AbstractSema, sp::AbstractScope, d::AbstractDecl)
Apply to `d` every attribute pushed by an open `#pragma clang attribute` region whose
subject-match rules `d` satisfies, processing them in scope `sp`. A no-op when no such
region is open.
"""
function AddPragmaAttributes(x::AbstractSema, sp::AbstractScope, d::AbstractDecl)
    @check_ptrs x sp d
    clang_Sema_AddPragmaAttributes(x, sp, d)
    return nothing
end

# --- Unary type-transform trait implementations ---
# The individual transforms `BuildUnaryTransformType` dispatches to. A transform that
# cannot apply comes back as a NULL-pointer `QualType`, after clang has reported it
# through Sema's `DiagnosticsEngine`; the `kind` argument names which spelling of a shared
# transform is meant and is asserted, because it also selects that diagnostic.

"""
    BuiltinEnumUnderlyingType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> QualType
The `__underlying_type(ty)` transform: the integer type `ty`'s enumerators are stored in.

`ty` must be a complete enumeration type — clang diagnoses anything else and answers a
NULL `QualType`, so the precondition is restated here.
"""
function BuiltinEnumUnderlyingType(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    @assert isEnumeralType(getTypePtr(ty)) "type must be an enumeration type"
    return QualType(clang_Sema_BuiltinEnumUnderlyingType(x, ty, loc))
end

"""
    BuiltinAddPointer(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> QualType
The `__add_pointer(ty)` transform. Total: a type no pointer can be formed to comes back
unchanged rather than as a failure.
"""
function BuiltinAddPointer(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuiltinAddPointer(x, ty, loc))
end

"""
    BuiltinRemovePointer(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> QualType
The `__remove_pointer(ty)` transform. Total: a non-pointer comes back unchanged.
"""
function BuiltinRemovePointer(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuiltinRemovePointer(x, ty, loc))
end

"""
    BuiltinDecay(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation) -> QualType
The `__decay(ty)` transform: array-to-pointer and function-to-pointer decay followed by
removal of the top-level qualifiers. Total.
"""
function BuiltinDecay(x::AbstractSema, ty::AbstractQualType, loc::SourceLocation)
    @check_ptrs x ty
    return QualType(clang_Sema_BuiltinDecay(x, ty, loc))
end

"""
    BuiltinAddReference(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc) -> QualType
The `__add_lvalue_reference` / `__add_rvalue_reference` transform, with `kind` selecting
which. A type no reference can be formed to comes back unchanged.

C++ only: clang asserts `LangOptions::CPlusPlus`, which the wrapper checks through
[`getCPlusPlus`](@ref).
"""
function BuiltinAddReference(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc::SourceLocation)
    @check_ptrs x ty
    @assert getCPlusPlus(getLangOpts(x)) "add-reference is a C++-only transform"
    @assert kind in (CXUTTKind_AddLvalueReference, CXUTTKind_AddRvalueReference) "unrelated transform kind"
    return QualType(clang_Sema_BuiltinAddReference(x, ty, kind, loc))
end

"""
    BuiltinRemoveExtent(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc) -> QualType
The `__remove_extent` / `__remove_all_extents` transform, with `kind` selecting which.
"""
function BuiltinRemoveExtent(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc::SourceLocation)
    @check_ptrs x ty
    @assert kind in (CXUTTKind_RemoveExtent, CXUTTKind_RemoveAllExtents) "unrelated transform kind"
    return QualType(clang_Sema_BuiltinRemoveExtent(x, ty, kind, loc))
end

"""
    BuiltinRemoveReference(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc) -> QualType
The `__remove_reference_t` / `__remove_cvref` transform, with `kind` selecting whether the
cv-qualifiers are stripped too.
"""
function BuiltinRemoveReference(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc::SourceLocation)
    @check_ptrs x ty
    @assert kind in (CXUTTKind_RemoveReference, CXUTTKind_RemoveCVRef) "unrelated transform kind"
    return QualType(clang_Sema_BuiltinRemoveReference(x, ty, kind, loc))
end

"""
    BuiltinChangeCVRQualifiers(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc) -> QualType
The `__remove_const` / `__remove_cv` / `__remove_restrict` / `__remove_volatile`
transform, with `kind` selecting which qualifiers are stripped.
"""
function BuiltinChangeCVRQualifiers(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc::SourceLocation)
    @check_ptrs x ty
    @assert kind in (CXUTTKind_RemoveConst, CXUTTKind_RemoveCV, CXUTTKind_RemoveRestrict, CXUTTKind_RemoveVolatile) "unrelated transform kind"
    return QualType(clang_Sema_BuiltinChangeCVRQualifiers(x, ty, kind, loc))
end

"""
    BuiltinChangeSignedness(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc) -> QualType
The `__make_signed` / `__make_unsigned` transform, with `kind` selecting which.

`ty` must be an integral or enumeration type. clang still diagnoses the cases the traits
themselves exclude — `bool` among them — and answers a NULL `QualType` for those.
"""
function BuiltinChangeSignedness(x::AbstractSema, ty::AbstractQualType, kind::CXUTTKind, loc::SourceLocation)
    @check_ptrs x ty
    @assert kind in (CXUTTKind_MakeSigned, CXUTTKind_MakeUnsigned) "unrelated transform kind"
    @assert isIntegerType(getTypePtr(ty)) "type must be an integral or enumeration type"
    return QualType(clang_Sema_BuiltinChangeSignedness(x, ty, kind, loc))
end

"""
    ReplaceAutoType(x::AbstractSema, type_with_auto::AbstractQualType, replacement::AbstractQualType) -> QualType
Replace the `auto` in `type_with_auto` with `replacement`, dropping the `auto` sugar that
[`SubstAutoType`](@ref) retains.
"""
function ReplaceAutoType(x::AbstractSema, type_with_auto::AbstractQualType, replacement::AbstractQualType)
    @check_ptrs x type_with_auto replacement
    return QualType(clang_Sema_ReplaceAutoType(x, type_with_auto, replacement))
end

"""
    ReplaceAutoTypeSourceInfo(x::AbstractSema, type_with_auto::AbstractTypeSourceInfo, replacement::AbstractQualType) -> TypeSourceInfo
The [`ReplaceAutoType`](@ref) transform over a `TypeSourceInfo`, keeping its source
locations.
"""
function ReplaceAutoTypeSourceInfo(x::AbstractSema, type_with_auto::AbstractTypeSourceInfo, replacement::AbstractQualType)
    @check_ptrs x type_with_auto replacement
    return TypeSourceInfo(clang_Sema_ReplaceAutoTypeSourceInfo(x, type_with_auto, replacement))
end

# --- Standard expression conversions ---
# The C and C++ standard conversions Sema applies to an operand before using it. Each
# rewrites an expression that already exists, so none of them needs the parser to be
# running. They surface `clang::ExprResult` the same way the other builders do
# (MARSHALLING.md §8): `nothing` for an invalid result, an `Expr_` carrier otherwise. Every
# node they build is ASTContext-arena memory and is never disposed.

"""
    IgnoredValueConversions(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Apply the conversions required when `e`'s result is syntactically ignored, as in an
expression statement.
"""
function IgnoredValueConversions(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_IgnoredValueConversions(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    UsualUnaryConversions(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Apply the usual unary conversions to `e`: the integer promotions of C99 6.3.1.1p2 plus
function- and array-to-pointer decay.
"""
function UsualUnaryConversions(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_UsualUnaryConversions(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    DefaultFunctionArrayConversion(x::AbstractSema, e::AbstractExpr, diagnose::Bool=true) -> Union{Nothing,Expr_}
Decay `e` from function or array type to the corresponding pointer type (C99 6.3.2.1).
`diagnose` selects whether an ill-formed operand is reported through Sema's
`DiagnosticsEngine`; `true` is clang's own default.
"""
function DefaultFunctionArrayConversion(x::AbstractSema, e::AbstractExpr, diagnose::Bool=true)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_DefaultFunctionArrayConversion(x, e, diagnose, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    DefaultFunctionArrayLvalueConversion(x::AbstractSema, e::AbstractExpr, diagnose::Bool=true) -> Union{Nothing,Expr_}
[`DefaultFunctionArrayConversion`](@ref) followed by the lvalue-to-rvalue conversion.
"""
function DefaultFunctionArrayLvalueConversion(x::AbstractSema, e::AbstractExpr, diagnose::Bool=true)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_DefaultFunctionArrayLvalueConversion(x, e, diagnose, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    DefaultLvalueConversion(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Apply the lvalue-to-rvalue conversion to `e`. A no-op when `e` has function or array type.
"""
function DefaultLvalueConversion(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_DefaultLvalueConversion(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    DefaultArgumentPromotion(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Apply the default argument promotions of C99 6.5.2.2p6 to `e` — the integer promotions,
plus `float` to `double`.
"""
function DefaultArgumentPromotion(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_DefaultArgumentPromotion(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    PreferredConditionType(x::AbstractSema, kind::CXConditionKind) -> QualType
The type a condition of `kind` is contextually converted to: `int` for a `switch`
condition, `bool` for the `if`/`while`/`for` and `if constexpr` kinds.
"""
function PreferredConditionType(x::AbstractSema, kind::CXConditionKind)
    @check_ptrs x
    return QualType(clang_Sema_PreferredConditionType(x, kind))
end

"""
    GetFormatStringType(attr::AbstractFormatAttr) -> CXFormatStringType
Which format-string dialect `attr` names, decoded from its type identifier;
`CXFormatStringType_FST_Unknown` for a spelling clang does not recognise.

This wraps a static member of `clang::Sema` and therefore takes no `Sema` receiver.
"""
function GetFormatStringType(attr::AbstractFormatAttr)
    @check_ptrs attr
    return clang_Sema_GetFormatStringType(attr)
end

"""
    GetFormatNSStringIdx(attr::AbstractFormatAttr) -> Union{Nothing,Cuint}
The zero-based index of `attr`'s format-string argument when `attr` is an NSString format,
and `nothing` for every other dialect.

This wraps a static member of `clang::Sema` and therefore takes no `Sema` receiver.
"""
function GetFormatNSStringIdx(attr::AbstractFormatAttr)
    @check_ptrs attr
    idx = Ref{Cuint}(0)
    return clang_Sema_GetFormatNSStringIdx(attr, idx) ? idx[] : nothing
end

# --- Sema state queries: current context, modules and type classification ---

"""
    getASTConsumer(x::AbstractSema) -> ASTConsumer
The `ASTConsumer` this `Sema` was constructed with. Borrowed from the owning
`CompilerInstance` — never `dispose` it through this handle.
"""
function getASTConsumer(x::AbstractSema)
    @check_ptrs x
    return ASTConsumer(clang_Sema_getASTConsumer(x))
end

"""
    getScopeForContext(x::AbstractSema, ctx::AnyDeclContext) -> Scope
The innermost enclosing `Scope` whose entity is `ctx`'s primary context. The returned
carrier holds NULL when there is no such scope, which is always the case between parses
because `Sema` then has no current scope at all.
"""
function getScopeForContext(x::AbstractSema, ctx::AnyDeclContext)
    @check_ptrs x ctx
    return Scope(clang_Sema_getScopeForContext(x, ctx))
end

"""
    hasCurFunction(x::AbstractSema) -> Bool
Whether a function scope is on `Sema`'s scope stack. This is the gate for
[`hasAnyUnrecoverableErrorsInThisFunction`](@ref), which clang implements by
dereferencing the current function scope with no null check.
"""
function hasCurFunction(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_hasCurFunction(x)
end

"""
    hasAnyUnrecoverableErrorsInThisFunction(x::AbstractSema) -> Bool
Whether an unrecoverable error has been diagnosed inside the function currently being
analysed. Requires [`hasCurFunction`](@ref): clang reads the current function scope's
error trap without checking it for null, and the scope stack is empty between parses.
"""
function hasAnyUnrecoverableErrorsInThisFunction(x::AbstractSema)
    @check_ptrs x
    @assert hasCurFunction(x) "Sema has no current function scope"
    return clang_Sema_hasAnyUnrecoverableErrorsInThisFunction(x)
end

"""
    isModuleVisible(x::AbstractSema, m::AbstractModule, module_private::Bool=false) -> Bool
Whether module `m` is visible from the translation unit `x` is analysing. With
`module_private` set, the narrower question is asked instead: whether `m` is part of the
module currently being built.
"""
function isModuleVisible(x::AbstractSema, m::AbstractModule, module_private::Bool=false)
    @check_ptrs x m
    return clang_Sema_isModuleVisible(x, m, module_private)
end

"""
    hasMergedDefinitionInCurrentModule(x::AbstractSema, d::AbstractNamedDecl) -> Bool
Whether `d` has a merged definition owned by a module usable from the module currently
being built.
"""
function hasMergedDefinitionInCurrentModule(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_Sema_hasMergedDefinitionInCurrentModule(x, d)
end

"""
    getDecltypeForExpr(x::AbstractSema, e::AbstractExpr) -> QualType
The type `decltype(e)` denotes, without the `DecltypeType` sugar around it. Unlike
`BuildDecltypeType` this never diagnoses, so it is safe to call between parses.
"""
function getDecltypeForExpr(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return QualType(clang_Sema_getDecltypeForExpr(x, e))
end

"""
    isSimpleTypeSpecifier(x::AbstractSema, kind::Integer) -> Bool
Whether `kind` names one of the simple-type-specifier keywords (`int`, `char`, `_Bool`,
…). `kind` is a raw `clang::tok::TokenKind` value, as returned by [`getTokenID`](@ref).
"""
function isSimpleTypeSpecifier(x::AbstractSema, kind::Integer)
    @check_ptrs x
    return clang_Sema_isSimpleTypeSpecifier(x, kind)
end

"""
    isDeclInScope(x::AbstractSema, d::AbstractNamedDecl, ctx::AnyDeclContext,
                  s::Union{Nothing,AbstractScope}=nothing,
                  allow_inline_namespace::Bool=false) -> Bool
Whether `d` is declared in `ctx` — and, when `ctx`'s redeclaration context is a function
or method, whether it is declared in the scope `s`. `s` may be left out only for a
non-function context: in the function case clang walks the scope's parent chain with no
null check. `allow_inline_namespace` accepts a declaration anywhere in `ctx`'s enclosing
namespace set rather than directly inside it.
"""
function isDeclInScope(x::AbstractSema, d::AbstractNamedDecl, ctx::AnyDeclContext, s::Union{Nothing,AbstractScope}=nothing, allow_inline_namespace::Bool=false)
    @check_ptrs x d ctx
    sp = s === nothing ? CXScope(C_NULL) : Base.unsafe_convert(CXScope, s)
    if sp == C_NULL
        @assert !isFunctionOrMethod(getRedeclContext(ctx)) "a function or method context needs a scope"
    end
    return clang_Sema_isDeclInScope(x, d, ctx, sp, allow_inline_namespace)
end

"""
    IsStringInit(x::AbstractSema, init::AbstractExpr, at::AbstractArrayType) -> Bool
Whether `init` is a valid string initializer for the array type `at` — a string literal
whose character kind matches `at`'s element type.
"""
function IsStringInit(x::AbstractSema, init::AbstractExpr, at::AbstractArrayType)
    @check_ptrs x init at
    return clang_Sema_IsStringInit(x, init, at)
end

"""
    getEmissionStatus(x::AbstractSema, fd::AbstractFunctionDecl,
                      final::Bool=false) -> CXFunctionEmissionStatus
Whether codegen will emit `fd`, and when it will not, why it is discarded. `final` asks
the end-of-translation-unit question instead of the point-of-use one.
"""
function getEmissionStatus(x::AbstractSema, fd::AbstractFunctionDecl, final::Bool=false)
    @check_ptrs x fd
    return clang_Sema_getEmissionStatus(x, fd, final)
end

"""
    getDefaultCXXMethodAddrSpace(x::AbstractSema) -> CXLangAS
The address space implicitly applied to the qualifiers of a C++ method:
`CXLangAS_opencl_generic` when compiling OpenCL, `CXLangAS_Default` otherwise.
"""
function getDefaultCXXMethodAddrSpace(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_getDefaultCXXMethodAddrSpace(x)
end

"""
    getStdAlignValT(x::AbstractSema) -> EnumDecl
The `std::align_val_t` enumeration. The returned carrier holds NULL until a header has
declared it.
"""
function getStdAlignValT(x::AbstractSema)
    @check_ptrs x
    return EnumDecl(clang_Sema_getStdAlignValT(x))
end

"""
    isThisOutsideMemberFunctionBody(x::AbstractSema, base_type::QualType) -> Bool
Whether `base_type` is the type of a `this` used outside the body of a member function,
for a class that is currently being defined.
"""
function isThisOutsideMemberFunctionBody(x::AbstractSema, base_type::QualType)
    @check_ptrs x base_type
    return clang_Sema_isThisOutsideMemberFunctionBody(x, base_type)
end

"""
    isUnavailableAlignedAllocationFunction(x::AbstractSema, fd::AbstractFunctionDecl) -> Bool
Whether `fd` is an aligned allocation or deallocation function that the deployment target
does not provide.
"""
function isUnavailableAlignedAllocationFunction(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_isUnavailableAlignedAllocationFunction(x, fd)
end

"""
    IsInsideALocalClassWithinATemplateFunction(x::AbstractSema) -> Bool
Whether `Sema`'s current context sits inside a class local to a function template.
"""
function IsInsideALocalClassWithinATemplateFunction(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_IsInsideALocalClassWithinATemplateFunction(x)
end

"""
    CanBeGetReturnObject(fd::AbstractFunctionDecl) -> Bool
Whether `fd` could be the `get_return_object` member of a coroutine promise type. clang
decides this from the name alone, so it is a heuristic rather than a full check.

This wraps a static member of `clang::Sema` and therefore takes no `Sema` receiver.
"""
function CanBeGetReturnObject(fd::AbstractFunctionDecl)
    @check_ptrs fd
    return clang_Sema_CanBeGetReturnObject(fd)
end

"""
    IsStringLiteralToNonConstPointerConversion(x::AbstractSema, from::AbstractExpr,
                                               to_type::QualType) -> Bool
Whether converting `from` to `to_type` is the deprecated string-literal-to-`char *`
conversion.
"""
function IsStringLiteralToNonConstPointerConversion(x::AbstractSema, from::AbstractExpr, to_type::QualType)
    @check_ptrs x from to_type
    return clang_Sema_IsStringLiteralToNonConstPointerConversion(x, from, to_type)
end

"""
    isValidSveBitcast(x::AbstractSema, src::QualType, dest::QualType) -> Bool
Whether bitcasting between `src` and `dest` is one of the permitted SVE
sizeless/fixed-length vector conversions. At least one operand must be a vector type —
clang asserts that.
"""
function isValidSveBitcast(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    is_vec = isVectorType(getTypePtr(src)) || isVectorType(getTypePtr(dest))
    @assert is_vec "at least one operand must be a vector type"
    return clang_Sema_isValidSveBitcast(x, src, dest)
end

"""
    isValidRVVBitcast(x::AbstractSema, src::QualType, dest::QualType) -> Bool
The RISC-V vector counterpart of [`isValidSveBitcast`](@ref). At least one operand must
be a vector type — clang asserts that.
"""
function isValidRVVBitcast(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    is_vec = isVectorType(getTypePtr(src)) || isVectorType(getTypePtr(dest))
    @assert is_vec "at least one operand must be a vector type"
    return clang_Sema_isValidRVVBitcast(x, src, dest)
end

"""
    getCurObjCLexicalContext(x::AbstractSema) -> DeclContext
The lexical context an Objective-C attribute would be read from: the current lexical
context, with a category mapped to the interface it extends.
"""
function getCurObjCLexicalContext(x::AbstractSema)
    @check_ptrs x
    return DeclContext(clang_Sema_getCurObjCLexicalContext(x))
end

"""
    BuildDeclaratorGroup(x::AbstractSema, group) -> DeclGroupRef
Package `group` into the `DeclGroupRef` a declarator list produces, after checking that
every deduced type in the group agrees.

An empty `group` yields a null `DeclGroupRef`, matching `clang::DeclGroupRef::Create`.
"""
function BuildDeclaratorGroup(x::AbstractSema, group::AbstractVector{<:AbstractDecl})
    @check_ptrs x
    ptrs = CXDecl[Base.unsafe_convert(CXDecl, d) for d in group]
    return DeclGroupRef(clang_Sema_BuildDeclaratorGroup(x, ptrs, length(ptrs)))
end

"""
    MakeFullExpr(x::AbstractSema, arg, cc=getExprLoc(arg)) -> Expr_
Finish `arg` as a full expression at `cc`, running the conversions, cleanup bookkeeping and
completeness checks clang applies at the end of every full expression.

A NULL carrier comes back when Sema rejected the expression.
"""
function MakeFullExpr(x::AbstractSema, arg::AbstractExpr, cc::SourceLocation=getExprLoc(arg))
    @check_ptrs x arg
    return Expr_(clang_Sema_MakeFullExpr(x, arg, cc))
end

"""
    MakeFullDiscardedValueExpr(x::AbstractSema, arg) -> Expr_
Finish `arg` as a full expression whose value is discarded, at `arg`'s own location.

A NULL carrier comes back when Sema rejected the expression.
"""
function MakeFullDiscardedValueExpr(x::AbstractSema, arg::AbstractExpr)
    @check_ptrs x arg
    return Expr_(clang_Sema_MakeFullDiscardedValueExpr(x, arg))
end

"""
    BuildExceptionDeclaration(x::AbstractSema, sp, tsinfo, start_loc, id_loc, id) -> VarDecl
Build the variable a `catch (T name)` clause declares, marked as an exception variable.

`id` may be a NULL carrier, the unnamed-handler form. The declaration is created in Sema's
current `DeclContext` but is not added to it; a NULL carrier comes back when the exception
type was rejected.
"""
function BuildExceptionDeclaration(x::AbstractSema, sp::AbstractScope, tsinfo::AbstractTypeSourceInfo, start_loc::SourceLocation, id_loc::SourceLocation, id::AbstractIdentifierInfo=IdentifierInfo(C_NULL))
    @check_ptrs x tsinfo
    return VarDecl(clang_Sema_BuildExceptionDeclaration(x, sp, tsinfo, start_loc, id_loc, id))
end

"""
    BuildSYCLUniqueStableNameExpr(x::AbstractSema, op_loc, lparen, rparen, tsinfo)
Build `__builtin_sycl_unique_stable_name(T)` over the type `tsinfo` names; the result type
is always `const char *`.

Return `nothing` when Sema rejected the type.
"""
function BuildSYCLUniqueStableNameExpr(x::AbstractSema, op_loc::SourceLocation, lparen::SourceLocation, rparen::SourceLocation, tsinfo::AbstractTypeSourceInfo)
    @check_ptrs x tsinfo
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildSYCLUniqueStableNameExpr(x, op_loc, lparen, rparen, tsinfo, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildFieldReferenceExpr(x::AbstractSema, base, is_arrow, op_loc, ss, field, found_decl, access, name_info)
Build `base.field` (`is_arrow=false`) or `base->field` (`is_arrow=true`) for the already
resolved `field`.

`clang::DeclAccessPair` has no handle, so the declaration lookup found crosses as
`found_decl` together with the `access` it was found with. `ss` may be an unset
`CXXScopeSpec`, the ordinary unqualified case. Return `nothing` when Sema rejected the
member access.
"""
function BuildFieldReferenceExpr(x::AbstractSema, base::AbstractExpr, is_arrow::Bool, op_loc::SourceLocation, ss::AbstractCXXScopeSpec, field::AbstractFieldDecl, found_decl::AbstractNamedDecl, access::CXAccessSpecifier, name_info::AbstractDeclarationNameInfo)
    @check_ptrs x base ss field found_decl name_info
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildFieldReferenceExpr(x, base, is_arrow, op_loc, ss, field, found_decl, access, name_info, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCompoundLiteralExpr(x::AbstractSema, lparen_loc, tsinfo, rparen_loc, literal)
Build the compound literal `(T){...}`, initializing an object of the type `tsinfo` names
from `literal`.

Return `nothing` when Sema rejected the initialization.
"""
function BuildCompoundLiteralExpr(x::AbstractSema, lparen_loc::SourceLocation, tsinfo::AbstractTypeSourceInfo, rparen_loc::SourceLocation, literal::AbstractExpr)
    @check_ptrs x tsinfo literal
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCompoundLiteralExpr(x, lparen_loc, tsinfo, rparen_loc, literal, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildVAArgExpr(x::AbstractSema, builtin_loc, e, tsinfo, rp_loc)
Build `__builtin_va_arg(e, T)` for the type `tsinfo` names.

Sema requires `e` to have the target's `va_list` type and diagnoses anything else, so a
wrongly-typed operand simply returns `nothing`.
"""
function BuildVAArgExpr(x::AbstractSema, builtin_loc::SourceLocation, e::AbstractExpr, tsinfo::AbstractTypeSourceInfo, rp_loc::SourceLocation)
    @check_ptrs x e tsinfo
    invalid = Ref{Bool}(false)
    r = clang_Sema_BuildVAArgExpr(x, builtin_loc, e, tsinfo, rp_loc, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    BuildCXXNamedCast(x::AbstractSema, op_loc, kind, ty, e, angle_brackets, parens)
Build the named cast `kind` — `static_cast`, `dynamic_cast`, `const_cast`,
`reinterpret_cast` or `addrspace_cast` — of `e` to the type `ty` names.

`kind` is a raw `clang::tok::TokenKind` value, as returned by
[`getTokenID`](@ref); `clang::Sema::BuildCXXNamedCast` reaches `llvm_unreachable` — which
aborts the process — for any other token, so the wrapper restates that precondition. Return
`nothing` when Sema rejected the conversion.
"""
function BuildCXXNamedCast(x::AbstractSema, op_loc::SourceLocation, kind::Integer, ty::AbstractTypeSourceInfo, e::AbstractExpr, angle_brackets::SourceRange, parens::SourceRange)
    @check_ptrs x ty e
    # TokenKinds.def stringifies a KEYWORD(X, Y) entry as #X, so tok::kw_static_cast is
    # named "static_cast" — the kw_ prefix is the enumerator's, not the name's
    casts = ("const_cast", "dynamic_cast", "reinterpret_cast", "static_cast", "addrspace_cast")
    @assert getTokenName(kind) in casts "kind must name one of the five C++ cast keywords"
    invalid = Ref{Bool}(false)
    r = clang_Sema_BuildCXXNamedCast(x, op_loc, kind, ty, e, getBeginLoc(angle_brackets), getEndLoc(angle_brackets), getBeginLoc(parens), getEndLoc(parens), invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    BuildCXXTypeId(x::AbstractSema, type_info_type, typeid_loc, operand, rparen_loc)
Build `typeid(T)` for the type `operand` names.

`type_info_type` becomes the const-qualified type of the resulting expression and is stored
unchecked — clang's parser passes the `std::type_info` it looked up in the current scope.
Return `nothing` when the operand type was rejected.
"""
function BuildCXXTypeId(x::AbstractSema, type_info_type::AbstractQualType, typeid_loc::SourceLocation, operand::AbstractTypeSourceInfo, rparen_loc::SourceLocation)
    @check_ptrs x type_info_type operand
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXTypeId(x, type_info_type, typeid_loc, operand, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXUuidof(x::AbstractSema, type_info_type, typeid_loc, operand, rparen_loc)
Build `__uuidof(T)` for the type `operand` names, the Microsoft extension that yields the GUID
attached to a type. Same protocol as [`BuildCXXTypeId`](@ref); returns `nothing` when the operand
was rejected.

The interpreter must have been built with Microsoft extensions enabled (`-fms-extensions`, or
Borland mode). Clang only creates the `MSGuidTagDecl` this needs under those language options and
reaches for it unchecked, so calling this without them is undefined rather than merely fruitless.
"""
function BuildCXXUuidof(x::AbstractSema, type_info_type::AbstractQualType, typeid_loc::SourceLocation, operand::AbstractTypeSourceInfo, rparen_loc::SourceLocation)
    @check_ptrs x type_info_type operand
    lo = getLangOpts(x)
    @assert getMicrosoftExt(lo) || getBorland(lo) "__uuidof needs -fms-extensions (or Borland mode)"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXUuidof(x, type_info_type, typeid_loc, operand, rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildExpressionFromDeclTemplateArgument(x::AbstractSema, arg, param_type, loc)
Re-express the template argument `arg` as the expression that denotes the declaration it
names, converted to `param_type`.

`clang::Sema::BuildExpressionFromDeclTemplateArgument` asserts that `arg` is a `Declaration`
argument, so the wrapper restates that precondition. Return `nothing` when Sema could not
build the expression.
"""
function BuildExpressionFromDeclTemplateArgument(x::AbstractSema, arg::TemplateArgument, param_type::AbstractQualType, loc::SourceLocation)
    @check_ptrs x arg param_type
    @assert getKind(arg) == CXTemplateArgument_Declaration "arg must be a declaration template argument"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildExpressionFromDeclTemplateArgument(x, arg, param_type, loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    CheckDelegatingCtorCycles(x::AbstractSema) -> Nothing
Walk every delegating constructor Sema has recorded and mark the members of a delegation
cycle invalid; the cycle itself is diagnosed. A translation unit without one is left
untouched, so this is idempotent on well-formed code.
"""
function CheckDelegatingCtorCycles(x::AbstractSema)
    @check_ptrs x
    clang_Sema_CheckDelegatingCtorCycles(x)
    return nothing
end

"""
    CheckCastAlign(x::AbstractSema, op::AbstractExpr, ty::QualType, rng::SourceRange) -> Nothing
Warn when casting `op` to the pointer type `ty` raises the required alignment. The warning
is `-Wcast-align`, which is off by default; clang tests that first and returns, so with the
default diagnostic settings this call does nothing.
"""
function CheckCastAlign(x::AbstractSema, op::AbstractExpr, ty::QualType, rng::SourceRange)
    @check_ptrs x op ty
    clang_Sema_CheckCastAlign(x, op, ty, getBeginLoc(rng), getEndLoc(rng))
    return nothing
end

"""
    CheckNontrivialField(x::AbstractSema, fd::AbstractFieldDecl) -> Bool
Return `true` when `fd`'s type has a non-trivial special member, which C++98 forbids in a
union or an anonymous struct; the offending member is diagnosed at `fd`. A field of trivial
type answers `false` and diagnoses nothing.
"""
function CheckNontrivialField(x::AbstractSema, fd::AbstractFieldDecl)
    @check_ptrs x fd
    @assert getCPlusPlus(getLangOpts(x)) "clang asserts this check runs only in C++"
    return clang_Sema_CheckNontrivialField(x, fd)
end

"""
    CheckEnumRedeclaration(x::AbstractSema, enum_loc::SourceLocation, is_scoped::Bool,
                           underlying_ty::QualType, is_fixed::Bool,
                           prev::AbstractEnumDecl) -> Bool
Return `true` when redeclaring `prev` with this scopedness and fixed underlying type
contradicts it, which is diagnosed at `enum_loc`. Passing `prev`'s own `isScoped`,
`getIntegerType` and `isFixed` answers `false` and diagnoses nothing. `underlying_ty` may be
a null `QualType` when `is_fixed` is `false`.
"""
function CheckEnumRedeclaration(x::AbstractSema, enum_loc::SourceLocation, is_scoped::Bool, underlying_ty::QualType, is_fixed::Bool, prev::AbstractEnumDecl)
    @check_ptrs x prev
    return clang_Sema_CheckEnumRedeclaration(x, enum_loc, is_scoped, underlying_ty, is_fixed, prev)
end

"""
    CheckCallReturnType(x::AbstractSema, return_ty::QualType, loc::SourceLocation,
                        ce=nothing, fd=nothing) -> Bool
Return `true` when `return_ty` is an incomplete non-`void` type, which is diagnosed at
`loc`. `ce` and `fd` only name the call in that diagnostic and may both be `nothing`.
"""
function CheckCallReturnType(x::AbstractSema, return_ty::QualType, loc::SourceLocation, ce::Union{Nothing,AbstractCallExpr}=nothing, fd::Union{Nothing,AbstractFunctionDecl}=nothing)
    @check_ptrs x return_ty
    return clang_Sema_CheckCallReturnType(x, return_ty, loc, ce === nothing ? CXCallExpr(C_NULL) : Base.unsafe_convert(CXCallExpr, ce), fd === nothing ? CXFunctionDecl(C_NULL) : Base.unsafe_convert(CXFunctionDecl, fd))
end

"""
    CheckCXXDefaultArguments(x::AbstractSema, fd::AbstractFunctionDecl) -> Nothing
Check that every parameter of `fd` following the first defaulted one is itself defaulted. A
gap is diagnosed and the stray default argument dropped; a function whose defaults are all
trailing is left untouched.
"""
function CheckCXXDefaultArguments(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    clang_Sema_CheckCXXDefaultArguments(x, fd)
    return nothing
end

"""
    CheckAlignasUnderalignment(x::AbstractSema, d::AbstractValueDecl) -> Nothing
    CheckAlignasUnderalignment(x::AbstractSema, d::AbstractTagDecl) -> Nothing
Diagnose an `alignas` on `d` weaker than the alignment `d`'s type requires. clang declares
this on `Decl` but reaches the type through an unchecked `cast<TagDecl>` for anything that
is not a `ValueDecl`, so those two classes are the whole domain and the receiver is typed at
both rather than at `Decl`. clang also asserts that the declaration carries attributes.
"""
function CheckAlignasUnderalignment(x::AbstractSema, d::AbstractValueDecl)
    @check_ptrs x d
    @assert hasAttrs(d) "clang asserts the declaration carries attributes"
    clang_Sema_CheckAlignasUnderalignment(x, d)
    return nothing
end

function CheckAlignasUnderalignment(x::AbstractSema, d::AbstractTagDecl)
    @check_ptrs x d
    @assert hasAttrs(d) "clang asserts the declaration carries attributes"
    clang_Sema_CheckAlignasUnderalignment(x, d)
    return nothing
end

"""
    CheckUnusedVolatileAssignment(x::AbstractSema, e::AbstractExpr) -> Nothing
Drop `e`'s left operand from the enclosing evaluation context's list of volatile assignment
targets, which is what suppresses the C++20 deprecation warning for a volatile compound
assignment. An `e` whose type is not volatile-qualified, or a language mode before C++20,
returns at once.
"""
function CheckUnusedVolatileAssignment(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    clang_Sema_CheckUnusedVolatileAssignment(x, e)
    return nothing
end

"""
    CheckVecStepExpr(x::AbstractSema, e::AbstractExpr) -> Bool
Return `true` when `e` is not a valid `vec_step` operand — an incomplete, sizeless or array
type — which is diagnosed at `e`. The shared operand check asserts that the operand's type
is not a reference type, so the wrapper rejects that case first.
"""
function CheckVecStepExpr(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    qty = getType(e)
    @assert !isNull(qty) "an unevaluated string literal is not a vec_step operand"
    @assert !isReferenceType(getTypePtr(qty)) "operand must not have reference type"
    return clang_Sema_CheckVecStepExpr(x, e)
end

"""
    CheckStaticArrayArgument(x::AbstractSema, call_loc::SourceLocation,
                             param::AbstractParmVarDecl, arg::AbstractExpr) -> Nothing
Diagnose an argument too short for a parameter declared with a static array bound
(`void f(int a[static 4])`). C++ has no such parameters, so under a C++ language mode clang
returns immediately.
"""
function CheckStaticArrayArgument(x::AbstractSema, call_loc::SourceLocation, param::AbstractParmVarDecl, arg::AbstractExpr)
    @check_ptrs x param arg
    clang_Sema_CheckStaticArrayArgument(x, call_loc, param, arg)
    return nothing
end

"""
    CheckCompatibleReinterpretCast(x::AbstractSema, src_ty::QualType, dest_ty::QualType,
                                   is_dereference::Bool, rng::SourceRange) -> Nothing
Warn when reinterpreting `src_ty` as `dest_ty` has undefined behaviour. `is_dereference`
selects the "indirection through the result" form, which needs both types to be pointer
types; the other form needs `dest_ty` to be a reference type. Anything else, and an ignored
`-Wundefined-reinterpret-cast`, returns immediately.
"""
function CheckCompatibleReinterpretCast(x::AbstractSema, src_ty::QualType, dest_ty::QualType, is_dereference::Bool, rng::SourceRange)
    @check_ptrs x src_ty dest_ty
    clang_Sema_CheckCompatibleReinterpretCast(x, src_ty, dest_ty, is_dereference, getBeginLoc(rng), getEndLoc(rng))
    return nothing
end

"""
    CheckConstraintExpression(x::AbstractSema, e::AbstractExpr,
                              is_trailing_requires_clause::Bool=false) -> (Bool, Bool)
Return whether `e` is a valid constraint expression, together with clang's guess at why it
is not. A conjunction or disjunction is checked operand by operand, so a `bool`-typed `e`
can still fail on a nested operand, which is diagnosed there. The second element is set when
the failure looks like a call written without the parentheses a constraint needs;
`is_trailing_requires_clause` only refines that guess.

The wrapper rejects an `e` that is neither `bool`-typed nor dependent before the ccall,
since that is the input clang diagnoses. Note the check is applied to the expression as
written, while clang looks through parentheses and implicit casts first.

clang also takes the token the parser had lexed after the constraint; there is none outside
the parser, so a cleared token is passed and it feeds nothing but that guess.
"""
function CheckConstraintExpression(x::AbstractSema, e::AbstractExpr, is_trailing_requires_clause::Bool=false)
    @check_ptrs x e
    ty = expr_type_ptr(e)
    @assert isBooleanType(ty)||isDependentType(ty) "a constraint expression must have type bool"
    non_primary = Ref{Bool}(false)
    ok = clang_Sema_CheckConstraintExpression(x, e, non_primary, is_trailing_requires_clause)
    return ok, non_primary[]
end

"""
    CheckConstructor(x::AbstractSema, ctor::AbstractCXXConstructorDecl) -> Nothing
Apply C++ [class.copy]p3 to `ctor`: one whose first parameter is its own class by value,
with every later parameter defaulted, is diagnosed and marked invalid. A `ctor` whose
semantic context is not a class is marked invalid without a diagnostic.
"""
function CheckConstructor(x::AbstractSema, ctor::AbstractCXXConstructorDecl)
    @check_ptrs x ctor
    clang_Sema_CheckConstructor(x, ctor)
    return nothing
end

"""
    CheckOverrideControl(x::AbstractSema, d::AbstractNamedDecl) -> Nothing
Apply the C++11 override-control rules to `d`: `override` on a method that overrides
nothing, or `final` on a non-virtual one, is diagnosed. A declaration carrying neither
attribute returns immediately.
"""
function CheckOverrideControl(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    clang_Sema_CheckOverrideControl(x, d)
    return nothing
end

"""
    CheckFloatComparison(x::AbstractSema, loc::SourceLocation, lhs::AbstractExpr,
                         rhs::AbstractExpr, opcode::CXBinaryOperatorKind) -> Nothing
Warn about comparing floating-point operands for equality with `opcode`. The warning is
`-Wfloat-equal`, which is off by default; two references to the same declaration, and a
literal the source type represents exactly, return before it.
"""
function CheckFloatComparison(x::AbstractSema, loc::SourceLocation, lhs::AbstractExpr, rhs::AbstractExpr, opcode::CXBinaryOperatorKind)
    @check_ptrs x lhs rhs
    clang_Sema_CheckFloatComparison(x, loc, lhs, rhs, opcode)
    return nothing
end

# --- Driving a substitution from outside the parser ---

"""
    getNumCodeSynthesisContexts(x::AbstractSema) -> Integer
Return the depth of Sema's code-synthesis stack — the number of template instantiations,
substitutions and other synthesis records currently active.

Every `Subst*` entry point asserts that this is non-zero, so it is the gate those wrappers
check before their ccall. Records are pushed by [`InstantiatingTemplate`](@ref).
"""
function getNumCodeSynthesisContexts(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_getNumCodeSynthesisContexts(x)
end

"""
    InstantiatingTemplate(x::AbstractSema, point_of_instantiation::SourceLocation,
                          entity::AbstractDecl, instantiation_range::SourceRange) -> InstantiatingTemplate
Push a code-synthesis record naming `entity` onto Sema's stack and return the RAII sentinel
that owns it. This function allocates and one should call `dispose` to release the resources
after using this object; disposing it is what pops the record, so nested sentinels must be
disposed in reverse construction order.

`clang::Sema::InstantiatingTemplate` is the object clang itself uses to open an
instantiation. Outside the parser it is the only way to satisfy the precondition every
`Subst*` wrapper checks. Check [`isInvalid`](@ref) before substituting: construction fails,
and pushes nothing, once the maximum recursive instantiation depth is exceeded.
"""
function InstantiatingTemplate(x::AbstractSema, point_of_instantiation::SourceLocation, entity::AbstractDecl, instantiation_range::SourceRange=SourceRange(SourceLocation(C_NULL), SourceLocation(C_NULL)))
    @check_ptrs x entity
    range = CXSourceRange_(instantiation_range.begin_loc.ptr, instantiation_range.end_loc.ptr)
    return InstantiatingTemplate(clang_InstantiatingTemplate_create(x, point_of_instantiation, entity, range))
end

dispose(x::InstantiatingTemplate) = clang_InstantiatingTemplate_dispose(x)

"""
    isInvalid(x::AbstractInstantiatingTemplate) -> Bool
Return whether construction exceeded the maximum recursive instantiation depth. An invalid
sentinel pushed nothing, so no substitution may be run under it.
"""
function isInvalid(x::AbstractInstantiatingTemplate)
    @check_ptrs x
    return clang_InstantiatingTemplate_isInvalid(x)
end

"""
    isAlreadyInstantiating(x::AbstractInstantiatingTemplate) -> Bool
Return whether some surrounding active instantiation is already instantiating this same
specialization.
"""
function isAlreadyInstantiating(x::AbstractInstantiatingTemplate)
    @check_ptrs x
    return clang_InstantiatingTemplate_isAlreadyInstantiating(x)
end

"""
    SubstTypeSourceInfo(x::AbstractSema, t::AbstractTypeSourceInfo, template_args, loc,
                        entity=DeclarationName(C_NULL), allow_deduced_tst=false) -> TypeSourceInfo
Rebuild `t` with `template_args` substituted for the template parameters it mentions,
keeping its written source locations. The `TypeSourceInfo` overload of Clang's `SubstType`.

`entity` only names the entity being substituted into in a diagnostic and may be the null
`DeclarationName`. The result is ASTContext-owned; a NULL carrier means substitution failed.

Sema asserts that its code-synthesis stack is non-empty, so a live
[`InstantiatingTemplate`](@ref) is a precondition — the whole `Subst*` family restates it.
"""
function SubstTypeSourceInfo(x::AbstractSema, t::AbstractTypeSourceInfo, template_args::AbstractMultiLevelTemplateArgumentList, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL), allow_deduced_tst::Bool=false)
    @check_ptrs x t template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return TypeSourceInfo(clang_Sema_SubstTypeSourceInfo(x, t, template_args, loc, entity, allow_deduced_tst))
end

"""
    SubstType(x::AbstractSema, t::AbstractQualType, template_args, loc,
              entity=DeclarationName(C_NULL)) -> QualType
The `QualType` form of [`SubstTypeSourceInfo`](@ref); a NULL carrier means substitution
failed. Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstType(x::AbstractSema, t::AbstractQualType, template_args::AbstractMultiLevelTemplateArgumentList, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL))
    @check_ptrs x t template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return QualType(clang_Sema_SubstType(x, t, template_args, loc, entity))
end

"""
    SubstExpr(x::AbstractSema, e::AbstractExpr, template_args) -> Union{Expr_,Nothing}
Rebuild `e` with `template_args` substituted for the template parameters it mentions.
Return `nothing` when the substitution errored. Requires a live
[`InstantiatingTemplate`](@ref).
"""
function SubstExpr(x::AbstractSema, e::AbstractExpr, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x e template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    invalid = Ref{Bool}(false)
    r = clang_Sema_SubstExpr(x, e, template_args, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    SubstConstraintExpr(x::AbstractSema, e::AbstractExpr, template_args) -> Union{Expr_,Nothing}
[`SubstExpr`](@ref) with constraint satisfaction checked — the form to use at
constraint-checking time. Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstConstraintExpr(x::AbstractSema, e::AbstractExpr, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x e template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    invalid = Ref{Bool}(false)
    r = clang_Sema_SubstConstraintExpr(x, e, template_args, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    SubstConstraintExprWithoutSatisfaction(x::AbstractSema, e::AbstractExpr, template_args) -> Union{Expr_,Nothing}
[`SubstConstraintExpr`](@ref) with constraint satisfaction left unevaluated. Requires a live
[`InstantiatingTemplate`](@ref).
"""
function SubstConstraintExprWithoutSatisfaction(x::AbstractSema, e::AbstractExpr, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x e template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    invalid = Ref{Bool}(false)
    r = clang_Sema_SubstConstraintExprWithoutSatisfaction(x, e, template_args, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    SubstStmt(x::AbstractSema, s::AbstractStmt, template_args) -> Union{Stmt,Nothing}
Rebuild `s` with `template_args` substituted for the template parameters it mentions.
Return `nothing` when the substitution errored, and the base `Stmt` carrier otherwise —
`resolve` it to refine. Requires a live [`InstantiatingTemplate`](@ref).

Substituting a statement that names a local variable or a parameter also needs a local
instantiation scope, which this layer does not expose: clang looks the pattern's local decls
up in `Sema::CurrentInstantiationScope`.

It also needs a current function scope: transforming a `CompoundStmt` calls
`Sema::PushCompoundScope`, which dereferences `getCurFunction()` with no null check and
segfaults on an empty stack. [`hasCurFunction`](@ref) is that gate and is asserted here.
"""
function SubstStmt(x::AbstractSema, s::AbstractStmt, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x s template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasCurFunction(x) "statement substitution needs a current function scope"
    invalid = Ref{Bool}(false)
    r = clang_Sema_SubstStmt(x, s, template_args, invalid)
    return invalid[] ? nothing : Stmt(r)
end

"""
    SubstInitializer(x::AbstractSema, e::AbstractExpr, template_args, cxx_direct_init::Bool) -> Union{Expr_,Nothing}
[`SubstExpr`](@ref) for an initializer; `cxx_direct_init` selects the `T x(a)` reading over
the `T x = a` one. Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstInitializer(x::AbstractSema, e::AbstractExpr, template_args::AbstractMultiLevelTemplateArgumentList, cxx_direct_init::Bool)
    @check_ptrs x e template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    invalid = Ref{Bool}(false)
    r = clang_Sema_SubstInitializer(x, e, template_args, cxx_direct_init, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    SubstNestedNameSpecifierLoc(x::AbstractSema, nns::AbstractNestedNameSpecifierLoc, template_args) -> NestedNameSpecifierLoc
Rebuild the written qualifier `nns` with `template_args` substituted into it. An empty
qualifier substitutes to an empty one. This function allocates and one should call `dispose`
to release the resources after using this object.

Requires a live [`InstantiatingTemplate`](@ref): a dependent qualifier reaches the same
asserting substitution machinery as [`SubstType`](@ref).
"""
function SubstNestedNameSpecifierLoc(x::AbstractSema, nns::AbstractNestedNameSpecifierLoc, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x nns template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return NestedNameSpecifierLoc(clang_Sema_SubstNestedNameSpecifierLoc(x, nns, template_args))
end

"""
    SubstDeclarationNameInfo(x::AbstractSema, name_info::AbstractDeclarationNameInfo, template_args) -> DeclarationNameInfo
Rebuild `name_info` with `template_args` substituted into it — only conversion-function and
constructor names carry a type to substitute, so an identifier comes back unchanged. This
function allocates and one should call `dispose` to release the resources after using this
object.

Requires a live [`InstantiatingTemplate`](@ref), for the same reason as
[`SubstNestedNameSpecifierLoc`](@ref).
"""
function SubstDeclarationNameInfo(x::AbstractSema, name_info::AbstractDeclarationNameInfo, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x name_info template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return DeclarationNameInfo(clang_Sema_SubstDeclarationNameInfo(x, name_info, template_args))
end

"""
    FindHiddenVirtualMethods(x::AbstractSema, md::AbstractCXXMethodDecl) -> Vector{CXXMethodDecl}
Return the base-class virtual methods `md` hides without overriding — the walk that backs
`-Woverloaded-virtual`, with no diagnostic emitted.

`md`'s parent class must have a definition, because clang walks its base classes.
"""
function FindHiddenVirtualMethods(x::AbstractSema, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    @assert hasDefinition(getParent(md)) "the method's parent class must have a definition"
    n = clang_Sema_FindHiddenVirtualMethods(x, md, Ptr{CXCXXMethodDecl}(C_NULL), 0)
    n == 0 && return CXXMethodDecl[]
    buf = Vector{CXCXXMethodDecl}(undef, n)
    clang_Sema_FindHiddenVirtualMethods(x, md, buf, n)
    return [CXXMethodDecl(p) for p in buf]
end

"""
    AddOverloadCandidate(x::AbstractSema, fd::AbstractFunctionDecl, found::AbstractNamedDecl,
                         access::CXAccessSpecifier, args::AbstractVector{<:AbstractExpr},
                         cs::AbstractOverloadCandidateSet; kwargs...)
Add `fd` — found as `found` with access `access` — as a candidate for a call with `args`,
recording it in the caller-owned candidate set `cs`.

`fd` must not be the pattern of a function template; clang asserts on that and wants
[`AddTemplateOverloadCandidate`](@ref) instead. The keyword arguments mirror clang's
defaults: `suppress_user_conversions`, `partial_overloading`, `allow_explicit`,
`allow_explicit_conversion`, `uses_adl`, `reversed` (the reversed parameter order of a
rewritten comparison) and `aggregate_deduction`.
"""
function AddOverloadCandidate(x::AbstractSema, fd::AbstractFunctionDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; suppress_user_conversions::Bool=false, partial_overloading::Bool=false, allow_explicit::Bool=true, allow_explicit_conversion::Bool=false, uses_adl::Bool=false, reversed::Bool=false, aggregate_deduction::Bool=false)
    @check_ptrs x fd found cs
    @assert getDescribedFunctionTemplate(fd).ptr == C_NULL "a function template pattern needs AddTemplateOverloadCandidate"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddOverloadCandidate(x, fd, found, access, buf, length(buf), cs, suppress_user_conversions, partial_overloading, allow_explicit, allow_explicit_conversion, uses_adl, reversed, aggregate_deduction)
end

"""
    AddFunctionCandidates(x::AbstractSema, fns::AbstractVector{<:AbstractNamedDecl},
                          accesses::AbstractVector{CXAccessSpecifier},
                          args::AbstractVector{<:AbstractExpr},
                          cs::AbstractOverloadCandidateSet; kwargs...)
Add every declaration of an overload set as a candidate at once, dispatching each to the
plain, method or template form as its kind requires.

`fns` and `accesses` are read in lockstep, so they must have the same length. When
`first_argument_is_base` is set, a member function in the set takes `args[1]` as its
implicit object argument.
"""
function AddFunctionCandidates(x::AbstractSema, fns::AbstractVector{<:AbstractNamedDecl}, accesses::AbstractVector{CXAccessSpecifier}, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; explicit_template_args::Union{Nothing,AbstractTemplateArgumentListInfo}=nothing, suppress_user_conversions::Bool=false, partial_overloading::Bool=false, first_argument_is_base::Bool=false)
    @check_ptrs x cs
    @assert length(fns) == length(accesses) "fns and accesses must have the same length"
    fbuf = CXNamedDecl[Base.unsafe_convert(CXNamedDecl, d) for d in fns]
    abuf = collect(accesses)
    ebuf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    tali = explicit_template_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_template_args)
    return clang_Sema_AddFunctionCandidates(x, fbuf, abuf, length(fbuf), ebuf, length(ebuf), cs, tali, suppress_user_conversions, partial_overloading, first_argument_is_base)
end

"""
    AddMethodCandidate(x::AbstractSema, md::AbstractCXXMethodDecl, found::AbstractNamedDecl,
                       access::CXAccessSpecifier, acting::AbstractCXXRecordDecl,
                       object::AbstractExpr, args::AbstractVector{<:AbstractExpr},
                       cs::AbstractOverloadCandidateSet; kwargs...)
Add `md`, found in `acting` as `found` with access `access`, as a candidate for a call on
the object expression `object` with `args`.

clang takes the implicit object argument as a type plus a value classification; this
wrapper reads both off `object`, which is what a call site does. `md` must be a non-static
member function and must not be a constructor — clang asserts on a constructor and wants
[`AddOverloadCandidate`](@ref) for it.
"""
function AddMethodCandidate(x::AbstractSema, md::AbstractCXXMethodDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, acting::AbstractCXXRecordDecl, object::AbstractExpr, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; suppress_user_conversions::Bool=false, partial_overloading::Bool=false, reversed::Bool=false)
    @check_ptrs x md found acting object cs
    @assert !isStatic(md) "a static member function is a candidate through AddOverloadCandidate"
    @assert getDeclKindName(md) != "CXXConstructor" "a constructor is a candidate through AddOverloadCandidate"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddMethodCandidate(x, md, found, access, acting, object, buf, length(buf), cs, suppress_user_conversions, partial_overloading, reversed)
end

"""
    AddTemplateOverloadCandidate(x::AbstractSema, ftd::AbstractFunctionTemplateDecl,
                                 found::AbstractNamedDecl, access::CXAccessSpecifier,
                                 args::AbstractVector{<:AbstractExpr},
                                 cs::AbstractOverloadCandidateSet; kwargs...)
Deduce `ftd` against `args` and add the resulting specialization to `cs`.

A deduction failure is recorded in the set as a non-viable candidate rather than reported,
so the set grows either way. Pass `explicit_template_args` to supply a written template
argument list.
"""
function AddTemplateOverloadCandidate(x::AbstractSema, ftd::AbstractFunctionTemplateDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; explicit_template_args::Union{Nothing,AbstractTemplateArgumentListInfo}=nothing, suppress_user_conversions::Bool=false, partial_overloading::Bool=false, allow_explicit::Bool=true, uses_adl::Bool=false, reversed::Bool=false, aggregate_deduction::Bool=false)
    @check_ptrs x ftd found cs
    tali = explicit_template_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_template_args)
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddTemplateOverloadCandidate(x, ftd, found, access, tali, buf, length(buf), cs, suppress_user_conversions, partial_overloading, allow_explicit, uses_adl, reversed, aggregate_deduction)
end

"""
    AddMemberOperatorCandidates(x::AbstractSema, op::CXOverloadedOperatorKind,
                                loc::SourceLocation, args::AbstractVector{<:AbstractExpr},
                                cs::AbstractOverloadCandidateSet; reversed::Bool=false)
Add the member `operator op` candidates for a call whose left operand is `args[1]`.

`args` must be non-empty and `op` must name a real operator: clang reads `args[1]`'s type
to pick the class to look in.
"""
function AddMemberOperatorCandidates(x::AbstractSema, op::CXOverloadedOperatorKind, loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; reversed::Bool=false)
    @check_ptrs x cs
    @assert op != CXOverloadedOperatorKind_OO_None "an operator kind is required"
    @assert !isempty(args) "the left operand is read to pick the class to look in"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddMemberOperatorCandidates(x, op, loc, buf, length(buf), cs, reversed)
end

"""
    AddBuiltinCandidate(x::AbstractSema, param_tys::AbstractVector{QualType},
                        args::AbstractVector{<:AbstractExpr},
                        cs::AbstractOverloadCandidateSet; kwargs...)
Add one built-in candidate taking `param_tys` for a call with `args`.

clang reads one parameter type per argument, so `param_tys` and `args` must have the same
length.
"""
function AddBuiltinCandidate(x::AbstractSema, param_tys::AbstractVector{QualType}, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; is_assignment_operator::Bool=false, num_contextual_bool_arguments::Integer=0)
    @check_ptrs x cs
    @assert length(param_tys) == length(args) "one parameter type is read per argument"
    pbuf = CXQualType[Base.unsafe_convert(CXQualType, p) for p in param_tys]
    ebuf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddBuiltinCandidate(x, pbuf, ebuf, length(ebuf), cs, is_assignment_operator, num_contextual_bool_arguments)
end

"""
    AddBuiltinOperatorCandidates(x::AbstractSema, op::CXOverloadedOperatorKind,
                                 loc::SourceLocation, args::AbstractVector{<:AbstractExpr},
                                 cs::AbstractOverloadCandidateSet)
Add every built-in candidate for `operator op` over `args`.

`op` must be an operator that has built-in forms: clang's builder reaches an
`llvm_unreachable` — which aborts the process — for `OO_None` and for
`new`/`delete`/`new[]`/`delete[]`/`()`. Built-in operators are unary or binary, so `args`
carries one or two expressions.
"""
function AddBuiltinOperatorCandidates(x::AbstractSema, op::CXOverloadedOperatorKind, loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet)
    @check_ptrs x cs
    @assert op ∉ (CXOverloadedOperatorKind_OO_None, CXOverloadedOperatorKind_OO_New, CXOverloadedOperatorKind_OO_Delete, CXOverloadedOperatorKind_OO_Array_New, CXOverloadedOperatorKind_OO_Array_Delete, CXOverloadedOperatorKind_OO_Call) "this operator has no built-in candidates"
    @assert 1 <= length(args) <= 2 "a built-in operator is unary or binary"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddBuiltinOperatorCandidates(x, op, loc, buf, length(buf), cs)
end

"""
    AddArgumentDependentLookupCandidates(x::AbstractSema, name::DeclarationName,
                                         loc::SourceLocation,
                                         args::AbstractVector{<:AbstractExpr},
                                         cs::AbstractOverloadCandidateSet; kwargs...)
Add the candidates argument-dependent lookup finds for `name` over `args`.

Declarations already in `cs` are skipped, so an ADL pass may legitimately add nothing to a
set that already saw the same functions by ordinary lookup.
"""
function AddArgumentDependentLookupCandidates(x::AbstractSema, name::DeclarationName, loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; explicit_template_args::Union{Nothing,AbstractTemplateArgumentListInfo}=nothing, partial_overloading::Bool=false)
    @check_ptrs x name cs
    tali = explicit_template_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_template_args)
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddArgumentDependentLookupCandidates(x, name, loc, buf, length(buf), tali, cs, partial_overloading)
end

"""
    AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(x::AbstractSema,
                                                                     fd::AbstractFunctionDecl)
Attach the attributes clang gives a replaceable global allocation function — the alignment,
nothrow and allocation-size ones — to `fd`.

`fd` must be a replaceable global allocation function; clang leaves anything else alone,
and the assert keeps a pointless call from looking like it did something.
"""
function AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    @assert isReplaceableGlobalAllocationFunction(fd) "fd must be a replaceable global allocation function"
    return clang_Sema_AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(x, fd)
end

"""
    DeclareGlobalAllocationFunction(x::AbstractSema, name::DeclarationName, ret::QualType,
                                    params::AbstractVector{QualType}=QualType[])
Declare the global allocation function `name` with return type `ret` and parameter types
`params` in the translation unit, unless a declaration with exactly those parameter types
is already visible.

`name` must be one of the four `operator new`/`operator delete` names — clang keys the
exception specification and the implicit attributes off it. Declaring an `operator new`
form before C++11 additionally makes clang reach for `std::bad_alloc`, which a translation
unit that never parsed `<new>` does not have, so that combination is rejected here.
"""
function DeclareGlobalAllocationFunction(x::AbstractSema, name::DeclarationName, ret::QualType, params::AbstractVector{QualType}=QualType[])
    @check_ptrs x name ret
    op = getCXXOverloadedOperator(name)
    news = (CXOverloadedOperatorKind_OO_New, CXOverloadedOperatorKind_OO_Array_New)
    @assert op ∈ (news..., CXOverloadedOperatorKind_OO_Delete, CXOverloadedOperatorKind_OO_Array_Delete) "name must be an operator new/delete name"
    @assert op ∉ news || getCPlusPlus11(getLangOpts(x)) "declaring an operator new form needs C++11 or later"
    buf = CXQualType[Base.unsafe_convert(CXQualType, p) for p in params]
    return clang_Sema_DeclareGlobalAllocationFunction(x, name, ret, buf, length(buf))
end

"""
    FindDeallocationFunction(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl,
                             name::DeclarationName; kwargs...) -> Tuple{Bool,FunctionDecl}
Look `name` up as a member `operator delete` of `rd` and return `(failed, operator)`.

`failed` is true when the lookup was ambiguous or its result inaccessible; `operator` is
the chosen function, a NULL carrier when `rd` declares no usual deallocation function.
`rd` must have a definition, and the lookup declares `rd`'s implicit members as a side
effect. `diagnose` stays false by default: outside the parser clang has no source context
to render a diagnostic against.
"""
function FindDeallocationFunction(x::AbstractSema, loc::SourceLocation, rd::AbstractCXXRecordDecl, name::DeclarationName; diagnose::Bool=false, want_size::Bool=false, want_aligned::Bool=false)
    @check_ptrs x rd name
    @assert hasDefinition(rd) "the class must have a definition to look a member up in it"
    op = Ref{CXFunctionDecl}(C_NULL)
    failed = clang_Sema_FindDeallocationFunction(x, loc, rd, name, op, diagnose, want_size, want_aligned)
    return failed, FunctionDecl(op[])
end

# Weak top-level declarations, capture and ADL queries, and the remaining standard
# conversions

"""
    getNumWeakTopLevelDecls(x::AbstractSema) -> UInt32
Return how many declarations `#pragma weak name = alias` has cloned into Sema's weak
top-level list. The list stays empty until such a pragma has been processed.
"""
function getNumWeakTopLevelDecls(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_getNumWeakTopLevelDecls(x)
end

"""
    getWeakTopLevelDecl(x::AbstractSema, i::Integer) -> Decl
Return the `i`-th (zero-based) declaration of Sema's weak top-level list.
"""
function getWeakTopLevelDecl(x::AbstractSema, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumWeakTopLevelDecls(x) "weak top-level declaration index out of range"
    return Decl(clang_Sema_getWeakTopLevelDecl(x, i))
end

"""
    InventAbbreviatedTemplateParameterTypeName(x::AbstractSema, param_name, index::Integer) -> IdentifierInfo
Return the identifier clang invents for the parameter of an abbreviated function template:
`"<param_name>:auto"`, or `"auto:<index + 1>"` when `param_name` is `nothing`. The name is
interned in the ASTContext's identifier table, so the result is Clang-owned.
"""
function InventAbbreviatedTemplateParameterTypeName(x::AbstractSema, param_name::Union{Nothing,IdentifierInfo}, index::Integer)
    @check_ptrs x
    p = param_name === nothing ? CXIdentifierInfo(C_NULL) : Base.unsafe_convert(CXIdentifierInfo, param_name)
    return IdentifierInfo(clang_Sema_InventAbbreviatedTemplateParameterTypeName(x, p, index))
end

"""
    mightBeIntendedToBeTemplateName(x::AbstractSema, e::AbstractExpr) -> Tuple{Bool,Bool}
Return whether `e` is plausibly a mis-parsed template-name, together with whether that
answer rests on a dependent-scope node.
"""
function mightBeIntendedToBeTemplateName(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    dependent = Ref{Bool}(false)
    might = clang_Sema_mightBeIntendedToBeTemplateName(x, e, dependent)
    return might, dependent[]
end

"""
    adjustContextForLocalExternDecl(dc::AbstractDeclContext) -> Union{Nothing,DeclContext}
Return the semantic context a block-scope `extern` declaration written in `dc` belongs to —
the nearest enclosing namespace or translation unit — or `nothing` when `dc` is not a
function or method, in which case no adjustment applies and `dc` itself is the answer.

`clang::Sema::adjustContextForLocalExternDecl` is a static member, so there is no `Sema`
receiver.
"""
function adjustContextForLocalExternDecl(dc::AbstractDeclContext)
    @check_ptrs dc
    ref = Ref{CXDeclContext}(Base.unsafe_convert(CXDeclContext, dc))
    return clang_Sema_adjustContextForLocalExternDecl(ref) ? DeclContext(ref[]) : nothing
end

"""
    NeedToCaptureVariable(x::AbstractSema, var::AbstractValueDecl, loc::SourceLocation) -> Bool
Return whether a reference to `var` at `loc` would have to be captured by an enclosing
lambda, block or captured region. The capture machinery runs with capture building and
diagnostics both disabled, so this is a pure query.
"""
function NeedToCaptureVariable(x::AbstractSema, var::AbstractValueDecl, loc::SourceLocation)
    @check_ptrs x var
    return clang_Sema_NeedToCaptureVariable(x, var, loc)
end

"""
    UseArgumentDependentLookup(x::AbstractSema, ss::CXXScopeSpec, r::LookupResult, has_trailing_lparen::Bool) -> Bool
Return whether argument-dependent lookup should be performed for a call whose callee was
named by `r`. `ss` is the scope specifier written before the name — an empty one when there
was none — and `has_trailing_lparen` whether the name is directly followed by `(`. Emits no
diagnostics.
"""
function UseArgumentDependentLookup(x::AbstractSema, ss::CXXScopeSpec, r::LookupResult, has_trailing_lparen::Bool)
    @check_ptrs x ss r
    return clang_Sema_UseArgumentDependentLookup(x, ss, r, has_trailing_lparen)
end

"""
    LookupBinOp(x::AbstractSema, sc::Scope, op_loc::SourceLocation, opc::CXBinaryOperatorKind) -> Vector{NamedDecl}
Return the non-member candidate functions for the built-in binary operator `opc` — the
unqualified lookup of `operator@` from `sc`, member functions excluded.

An entry carries a function or, for a function template, its `FunctionTemplateDecl`, so the
result comes back at the container's element type and needs a checked cast to be refined.
"""
function LookupBinOp(x::AbstractSema, sc::Scope, op_loc::SourceLocation, opc::CXBinaryOperatorKind)
    @check_ptrs x sc
    n = clang_Sema_LookupBinOp(x, sc, op_loc, opc, Ptr{CXNamedDecl}(C_NULL), 0)
    n == 0 && return NamedDecl[]
    buf = Vector{CXNamedDecl}(undef, n)
    return NamedDecl.(resize!(buf, clang_Sema_LookupBinOp(x, sc, op_loc, opc, buf, n)))
end

"""
    CurFPFeatureOverrides(x::AbstractSema) -> UInt64
Return the floating-point options the innermost `#pragma float_control` overrides, as the
opaque integer encoding of `clang::FPOptionsOverride` that the expression accessors already
use. Zero — the default-constructed encoding — when no pragma is in effect.
"""
function CurFPFeatureOverrides(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_CurFPFeatureOverrides(x)
end

"""
    anyAltivecTypes(x::AbstractSema, src::QualType, dest::QualType) -> Bool
Return whether either operand is an AltiVec vector type. Like the other vector predicates,
clang asserts that at least one of `src` and `dest` is a vector type.
"""
function anyAltivecTypes(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    @assert isVectorType(getTypePtr(src)) || isVectorType(getTypePtr(dest)) "at least one operand must be a vector type"
    return clang_Sema_anyAltivecTypes(x, src, dest)
end

"""
    CallExprUnaryConversions(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Apply the unary conversions a call expression applies to its callee: function-to-pointer
decay followed by the lvalue-to-rvalue conversion, with no integer promotion.
"""
function CallExprUnaryConversions(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_CallExprUnaryConversions(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    TemporaryMaterializationConversion(x::AbstractSema, e::AbstractExpr) -> Union{Nothing,Expr_}
Materialize the prvalue `e` as an xvalue. A non-prvalue operand comes back unchanged, and so
does every operand in C++98, which has no xvalues.

A prvalue operand must have a complete type: clang requires completeness and diagnoses when
it is missing.
"""
function TemporaryMaterializationConversion(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    @assert !isPRValue(e) || isCompleteType(x, getExprLoc(e), getType(e)) "a prvalue operand must have a complete type"
    invalid = Ref{Bool}(false)
    r = clang_Sema_TemporaryMaterializationConversion(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    DefaultVariadicArgumentPromotion(x::AbstractSema, e::AbstractExpr, ct::CXVariadicCallType, fd=nothing) -> Union{Nothing,Expr_}
Apply the default argument promotions to `e` as an argument passed through an ellipsis. `fd`
is the callee whose ellipsis `e` is passed through and may be `nothing`.

`e`'s type must not be `CXVarArgKind_VAK_Undefined` for a variadic call: clang does not
promote such an operand at all, it rewrites it into a call to `__builtin_trap` through a
parser action that needs a live translation-unit scope.
"""
function DefaultVariadicArgumentPromotion(x::AbstractSema, e::AbstractExpr, ct::CXVariadicCallType, fd::Union{Nothing,AbstractFunctionDecl}=nothing)
    @check_ptrs x e
    @assert isValidVarArgType(x, getType(e)) != CXVarArgKind_VAK_Undefined "the operand's type must be valid for a variadic call"
    d = fd === nothing ? CXFunctionDecl(C_NULL) : Base.unsafe_convert(CXFunctionDecl, fd)
    invalid = Ref{Bool}(false)
    r = clang_Sema_DefaultVariadicArgumentPromotion(x, e, ct, d, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    UsualArithmeticConversions(x::AbstractSema, lhs, rhs, loc::SourceLocation, ack::CXArithConvKind) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Apply the usual arithmetic conversions of C99 6.3.1.8 to `lhs` and `rhs`, returning the
common type together with the two converted operands.

Returns `nothing` when the operands are not both arithmetic — clang leaves that diagnostic
to its caller — or when either operand's conversion failed.
"""
function UsualArithmeticConversions(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, ack::CXArithConvKind)
    @check_ptrs x lhs rhs
    lhs_out = Ref{CXExpr}(C_NULL)
    rhs_out = Ref{CXExpr}(C_NULL)
    t = clang_Sema_UsualArithmeticConversions(x, lhs, rhs, loc, ack, lhs_out, rhs_out)
    (t == C_NULL || lhs_out[] == C_NULL || rhs_out[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_out[]), Expr_(rhs_out[])
end

"""
    prepareVectorSplat(x::AbstractSema, vector_ty::QualType, splatted::AbstractExpr) -> Union{Nothing,Expr_}
Convert `splatted` to `vector_ty`'s element type so it can be splatted across a vector.

`vector_ty` must be a vector type — clang reaches its element type through an unchecked
`castAs<VectorType>` — and `splatted` must already be a prvalue of scalar type: the element
conversion is inserted as an implicit prvalue cast, which clang asserts against an operand
that is still an lvalue.
"""
function prepareVectorSplat(x::AbstractSema, vector_ty::QualType, splatted::AbstractExpr)
    @check_ptrs x vector_ty splatted
    @assert isVectorType(getTypePtr(vector_ty)) "vector_ty must be a vector type"
    @assert isScalarType(expr_type_ptr(splatted)) "the splatted operand must have scalar type"
    @assert isPRValue(splatted) "the splatted operand must already be a prvalue"
    invalid = Ref{Bool}(false)
    r = clang_Sema_prepareVectorSplat(x, vector_ty, splatted, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    SpecialMemberIsTrivial(x::AbstractSema, md::AbstractCXXMethodDecl, csm::CXCXXSpecialMember, tah=CXTrivialABIHandling_TAH_IgnoreTrivialABI, diagnose::Bool=false) -> Bool
Return whether `md` is a trivial `csm` of its class.

`csm` must name a special member and `md` must not be user-provided — clang asserts both.
`diagnose` reports why a non-trivial member is non-trivial through Sema's
`DiagnosticsEngine`; the default `false` makes the call a pure query.
"""
function SpecialMemberIsTrivial(x::AbstractSema, md::AbstractCXXMethodDecl, csm::CXCXXSpecialMember, tah::CXTrivialABIHandling=CXTrivialABIHandling_TAH_IgnoreTrivialABI, diagnose::Bool=false)
    @check_ptrs x md
    @assert csm != CXCXXSpecialMember_CXXInvalid "csm must name a special member"
    @assert !isUserProvided(md) "the member must not be user-provided"
    return clang_Sema_SpecialMemberIsTrivial(x, md, csm, tah, diagnose)
end

"""
    isObjCMethodDecl(x::AbstractSema, d::AbstractDecl) -> Bool
Return whether `d` is an Objective-C method declaration.
"""
function isObjCMethodDecl(x::AbstractSema, d::AbstractDecl)
    @check_ptrs x d
    return clang_Sema_isObjCMethodDecl(x, d)
end

"""
    canSkipFunctionBody(x::AbstractSema, d::AbstractDecl) -> Bool
Return whether the body of the function (or function template) `d` may be skipped without
breaking the parse of the rest of the translation unit.

A `constexpr` function or one with an undeduced return type can never be skipped. clang asks
the `ASTConsumer` last, so the answer is a property of the frontend action in flight as much
as of `d`.
"""
function canSkipFunctionBody(x::AbstractSema, d::AbstractDecl)
    @check_ptrs x d
    return clang_Sema_canSkipFunctionBody(x, d)
end

"""
    IsRedefinitionInModule(x::AbstractSema, new_decl::AbstractNamedDecl, old_decl::AbstractNamedDecl) -> Bool
Return whether `new_decl` and `old_decl` declare the same entity in two different modules,
which makes `new_decl` a redefinition rather than a redeclaration.
"""
function IsRedefinitionInModule(x::AbstractSema, new_decl::AbstractNamedDecl, old_decl::AbstractNamedDecl)
    @check_ptrs x new_decl old_decl
    return clang_Sema_IsRedefinitionInModule(x, new_decl, old_decl)
end

"""
    isValidSectionSpecifier(x::AbstractSema, s::AbstractString) -> Bool
Return whether `s` is a section specifier the target accepts.

Only Darwin targets parse the specifier at all; every other target accepts any string, so the
answer is decided by the host triple. clang reports a rejection as an `llvm::Error`, which the
shim consumes and reports as `false`.
"""
function isValidSectionSpecifier(x::AbstractSema, s::AbstractString)
    @check_ptrs x
    return clang_Sema_isValidSectionSpecifier(x, s)
end

"""
    ShouldWarnIfUnusedFileScopedDecl(x::AbstractSema, d::AbstractDeclaratorDecl) -> Bool
Return whether `d` is a file-scoped declaration worth warning about if it ends up unused.
"""
function ShouldWarnIfUnusedFileScopedDecl(x::AbstractSema, d::AbstractDeclaratorDecl)
    @check_ptrs x d
    return clang_Sema_ShouldWarnIfUnusedFileScopedDecl(x, d)
end

"""
    getNonOdrUseReasonInCurrentContext(x::AbstractSema, d::AbstractValueDecl) -> CXNonOdrUseReason
Return why `d` cannot be odr-used in the expression evaluation context Sema currently sits in,
or `CXNonOdrUseReason_NOUR_None` when it can.

The answer is read off Sema's expression-evaluation-context stack, which its constructor
primes, so the query is defined between parses as well as during one.
"""
function getNonOdrUseReasonInCurrentContext(x::AbstractSema, d::AbstractValueDecl)
    @check_ptrs x d
    return clang_Sema_getNonOdrUseReasonInCurrentContext(x, d)
end

"""
    isQualifiedMemberAccess(x::AbstractSema, e::AbstractExpr) -> Bool
Return whether `e` names a non-static class member through an explicit
nested-name-specifier, as in `&C::m`.
"""
function isQualifiedMemberAccess(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return clang_Sema_isQualifiedMemberAccess(x, e)
end

"""
    getLambdaConversionFunctionResultType(x::AbstractSema, proto::AbstractFunctionProtoType, cc::CXCallingConv_) -> QualType
Return the result type of a lambda's conversion-to-function-pointer operator, given the type
`proto` of its call operator and the calling convention `cc` wanted for the pointer.

`proto` must carry no ref-qualifier: clang copies its `ExtProtoInfo` onto the invoker and
asserts that the invoker never gains a reference qualifier.
"""
function getLambdaConversionFunctionResultType(x::AbstractSema, proto::AbstractFunctionProtoType, cc::CXCallingConv_)
    @check_ptrs x proto
    @assert getRefQualifier(proto) == CXRefQualifierKind_RQ_None "proto must carry no ref-qualifier"
    return QualType(clang_Sema_getLambdaConversionFunctionResultType(x, proto, cc))
end

"""
    IsSimplyAccessible(x::AbstractSema, d::AbstractNamedDecl, naming_class::AbstractCXXRecordDecl, base_ty::QualType) -> Bool
Return whether `d` is accessible from Sema's current context when named through
`naming_class` on an object of type `base_ty`.

`base_ty` is expected to be `naming_class`'s own type: clang builds a single access-check
entity out of the pair and re-derives neither from the other.
"""
function IsSimplyAccessible(x::AbstractSema, d::AbstractNamedDecl, naming_class::AbstractCXXRecordDecl, base_ty::QualType)
    @check_ptrs x d naming_class base_ty
    return clang_Sema_IsSimplyAccessible(x, d, naming_class, base_ty)
end

"""
    getTopMostPointOfInstantiation(x::AbstractSema, d::AbstractNamedDecl) -> SourceLocation
Return the outermost point of instantiation that led to `d`, or `d`'s own location when no
instantiation is in flight.
"""
function getTopMostPointOfInstantiation(x::AbstractSema, d::AbstractNamedDecl)
    @check_ptrs x d
    return SourceLocation(clang_Sema_getTopMostPointOfInstantiation(x, d))
end

"""
    isSFINAEContext(x::AbstractSema) -> Union{Nothing,TemplateDeductionInfo}
Return the nearest template-deduction context when Sema sits inside a SFINAE context — where
template argument substitution failures are not errors — and `nothing` when it does not.

A SFINAE context that records no diagnostics comes back as a null `TemplateDeductionInfo`
carrier rather than as `nothing`: clang keeps the two answers distinct, and so does this
wrapper. The carrier borrows Sema's context stack and must not outlive it.
"""
function isSFINAEContext(x::AbstractSema)
    @check_ptrs x
    info = Ref{CXTemplateDeductionInfo}(C_NULL)
    return clang_Sema_isSFINAEContext(x, info) ? TemplateDeductionInfo(info[]) : nothing
end

"""
    CanBeGetReturnTypeOnAllocFailure(fd::AbstractFunctionDecl) -> Bool
Return whether `fd` could be the `get_return_object_on_allocation_failure` member of a
coroutine promise type.

The decision is a heuristic on the name alone. `clang::Sema` declares it static, so no Sema
receiver is involved.
"""
function CanBeGetReturnTypeOnAllocFailure(fd::AbstractFunctionDecl)
    @check_ptrs fd
    return clang_Sema_CanBeGetReturnTypeOnAllocFailure(fd)
end

"""
    isInOpenMPAssumeScope(x::AbstractSema) -> Bool
Return whether a `#pragma omp begin assumes` region is currently open.
"""
function isInOpenMPAssumeScope(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isInOpenMPAssumeScope(x)
end

"""
    hasGlobalOpenMPAssumes(x::AbstractSema) -> Bool
Return whether a global `#pragma omp assumes` directive is in effect.
"""
function hasGlobalOpenMPAssumes(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_hasGlobalOpenMPAssumes(x)
end

"""
    isCast(cck::CXCheckedConversionKind) -> Bool
Return whether `cck` denotes a cast — C-style, functional, or other — rather than an implicit
conversion.

`clang::Sema` declares it static, so no Sema receiver is involved.
"""
function isCast(cck::CXCheckedConversionKind)
    return clang_Sema_isCast(cck)
end

"""
    getVariadicCallType(x::AbstractSema, proto::AbstractFunctionProtoType, fd=nothing, fn=nothing) -> CXVariadicCallType
Return which flavour of variadic call an argument promotion through `proto` belongs to.

`fd` is the callee declaration when one is known and `fn` the callee expression; clang tests
both for null itself, so either may be left out. A non-variadic `proto` answers
`CXVariadicCallType_VariadicDoesNotApply` before either is consulted.
"""
function getVariadicCallType(x::AbstractSema, proto::AbstractFunctionProtoType, fd::Union{Nothing,AbstractFunctionDecl}=nothing, fn::Union{Nothing,AbstractExpr}=nothing)
    @check_ptrs x proto
    d = fd === nothing ? CXFunctionDecl(C_NULL) : Base.unsafe_convert(CXFunctionDecl, fd)
    e = fn === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, fn)
    return clang_Sema_getVariadicCallType(x, d, proto, e)
end

"""
    isCUDAImplicitHostDeviceFunction(d::AbstractFunctionDecl) -> Bool
Return whether `d` carries both an implicit `__host__` and an implicit `__device__` attribute.

`clang::Sema` declares it static, so no Sema receiver is involved.
"""
function isCUDAImplicitHostDeviceFunction(d::AbstractFunctionDecl)
    @check_ptrs d
    return clang_Sema_isCUDAImplicitHostDeviceFunction(d)
end

"""
    getCudaConfigureFuncName(x::AbstractSema) -> String
Return the name of the kernel launch configuration function for the CUDA/HIP dialect and
target SDK version in effect.

The HIP and CUDA dialects, and the two CUDA launch ABIs, each name a different function, so
the value is decided by the language options and the target — never assert a specific one.
"""
function getCudaConfigureFuncName(x::AbstractSema)
    @check_ptrs x
    return get_string(clang_Sema_getCudaConfigureFuncName(x))
end

"""
    getNSErrorIdent(x::AbstractSema) -> IdentifierInfo
Return the identifier `NSError`, interning it in the identifier table on first use.
"""
function getNSErrorIdent(x::AbstractSema)
    @check_ptrs x
    return IdentifierInfo(clang_Sema_getNSErrorIdent(x))
end

"""
    getSuperIdentifier(x::AbstractSema) -> IdentifierInfo
Return the identifier Objective-C spells `super`, interning it on first use.
"""
function getSuperIdentifier(x::AbstractSema)
    @check_ptrs x
    return IdentifierInfo(clang_Sema_getSuperIdentifier(x))
end

"""
    CreateOverloadedArraySubscriptExpr(x::AbstractSema, lloc, rloc, base, args)
Build `base[args...]` by overload resolution over `base`'s `operator[]` members.

`base` must designate an object of class type, since `operator[]` is only ever a member.
Return `nothing` when Sema rejected the subscript.
"""
function CreateOverloadedArraySubscriptExpr(x::AbstractSema, lloc::SourceLocation, rloc::SourceLocation, base::AbstractExpr, args::AbstractVector{<:AbstractExpr})
    @check_ptrs x base
    @assert isRecordType(expr_type_ptr(base)) "the subscripted operand must have class type"
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in args]
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateOverloadedArraySubscriptExpr(x, lloc, rloc, base, ptrs, length(ptrs), invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCallToObjectOfClassType(x::AbstractSema, sp, object, lparen_loc, args, rparen_loc)
Build `object(args...)` by overload resolution over `object`'s `operator()` members and its
surrogate conversions to function pointers.

`object` must designate an object of class type; `sp` may be a NULL carrier. Return
`nothing` when Sema rejected the call.
"""
function BuildCallToObjectOfClassType(x::AbstractSema, sp::AbstractScope, object::AbstractExpr, lparen_loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, rparen_loc::SourceLocation)
    @check_ptrs x object
    @assert isRecordType(expr_type_ptr(object)) "the called operand must have class type"
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in args]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCallToObjectOfClassType(x, sp, object, lparen_loc, ptrs, length(ptrs), rparen_loc, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildOverloadedArrowExpr(x::AbstractSema, sp, base, op_loc)
Build the `operator->` call `base->` names, by overload resolution over `base`'s class. Only
one step is taken, so the result has whatever type that operator returns.

`base` must designate an object of class type; `sp` may be a NULL carrier. Return a
`(result, no_arrow_operator_found)` pair: `result` is `nothing` when Sema produced no node,
and `no_arrow_operator_found` is a second, independent discriminator saying the class
declares no `operator->` at all.
"""
function BuildOverloadedArrowExpr(x::AbstractSema, sp::AbstractScope, base::AbstractExpr, op_loc::SourceLocation)
    @check_ptrs x base
    @assert isRecordType(expr_type_ptr(base)) "the left-hand operand must have class type"
    no_arrow = Ref{Bool}(false)
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildOverloadedArrowExpr(x, sp, base, op_loc, no_arrow, invalid)
    return (invalid[] ? nothing : Expr_(e)), no_arrow[]
end

"""
    BuildAttributedStmt(x::AbstractSema, attrs_loc, attrs, sub_stmt)
Build an `AttributedStmt` applying `attrs` to `sub_stmt`, re-checking the attributes first.

`attrs` must be non-empty, as `clang::AttributedStmt::Create` requires; the attributes are
copied into the node, so the vector need not outlive the call. Return `nothing` when Sema
rejected the attribute list.
"""
function BuildAttributedStmt(x::AbstractSema, attrs_loc::SourceLocation, attrs::AbstractVector{<:AbstractAttr}, sub_stmt::AbstractStmt)
    @check_ptrs x sub_stmt
    @assert !isempty(attrs) "an AttributedStmt needs at least one attribute"
    @assert all(a -> a.ptr != C_NULL, attrs) "attribute list holds no null slot"
    ptrs = CXAttr[Base.unsafe_convert(CXAttr, a) for a in attrs]
    invalid = Ref{Bool}(false)
    s = clang_Sema_BuildAttributedStmt(x, attrs_loc, ptrs, length(ptrs), sub_stmt, invalid)
    return invalid[] ? nothing : Stmt(s)
end

"""
    CreateGenericSelectionExpr(x::AbstractSema, key_loc, default_loc, rparen_loc, controlling, types, exprs)
Build `_Generic(controlling, types[i]: exprs[i], ...)`.

`controlling` is the discriminated controlling operand: an expression selects the expression
predicate, a `TypeSourceInfo` the type predicate. `types` and `exprs` are read in lockstep
and must have the same length; a `nothing` entry in `types` is the `default` association.
Exactly one association has to select, which is what clang diagnoses otherwise. Return
`nothing` when Sema rejected the selection.
"""
function CreateGenericSelectionExpr(x::AbstractSema, key_loc::SourceLocation, default_loc::SourceLocation, rparen_loc::SourceLocation, controlling::Union{AbstractExpr,TypeSourceInfo}, types::AbstractVector{<:Union{Nothing,TypeSourceInfo}}, exprs::AbstractVector{<:AbstractExpr})
    @check_ptrs x controlling
    @assert length(types) == length(exprs) "every association needs a type and an expression"
    ty_ptrs = CXTypeSourceInfo[t === nothing ? CXTypeSourceInfo(C_NULL) : Base.unsafe_convert(CXTypeSourceInfo, t) for t in types]
    e_ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in exprs]
    invalid = Ref{Bool}(false)
    e = clang_Sema_CreateGenericSelectionExpr(x, key_loc, default_loc, rparen_loc,
                                              # clang holds the controlling operand as a
                                              # `void *` discriminated by the flag beside it
                                              controlling isa AbstractExpr, Ptr{Cvoid}(controlling.ptr), ty_ptrs, e_ptrs, length(e_ptrs), invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildResolvedCallExpr(x::AbstractSema, fn, ndecl, lparen_loc, args, rparen_loc, config=Expr_(C_NULL), is_exec_config=false, uses_adl=false)
Build a call of the already-resolved `ndecl` through the callee expression `fn`, converting
`args` to the parameter types and filling in default arguments.

`config` may be a NULL carrier. `uses_adl` records `clang::Sema::ADLCallKind` on the node
and reads back through `usesADL`. Return `nothing` when Sema rejected the call.
"""
function BuildResolvedCallExpr(x::AbstractSema, fn::AbstractExpr, ndecl::AbstractNamedDecl, lparen_loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, rparen_loc::SourceLocation, config::AbstractExpr=Expr_(C_NULL), is_exec_config::Bool=false, uses_adl::Bool=false)
    @check_ptrs x fn ndecl
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in args]
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildResolvedCallExpr(x, fn, ndecl, lparen_loc, ptrs, length(ptrs), rparen_loc, config, is_exec_config, uses_adl, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXDefaultInitExpr(x::AbstractSema, loc, field)
Build the `CXXDefaultInitExpr` standing for `field`'s in-class initializer, instantiating
that initializer if it has not been instantiated yet.

`field` must have an in-class initializer and belong to a C++ class, both of which clang
reaches without a check. Return `nothing` when Sema could not build the initializer.
"""
function BuildCXXDefaultInitExpr(x::AbstractSema, loc::SourceLocation, field::AbstractFieldDecl)
    @check_ptrs x field
    @assert hasInClassInitializer(field) "the field must have an in-class initializer"
    @assert getDeclKindName(getParent(field)) == "CXXRecord" "the field must belong to a C++ class"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXDefaultInitExpr(x, loc, field, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXDefaultArgExpr(x::AbstractSema, call_loc, fd, param, init=Expr_(C_NULL))
Build the `CXXDefaultArgExpr` standing for `param`'s default argument in a call of `fd`,
instantiating that argument if needed.

`param` must have a default argument. `init` may be a NULL carrier, which is the ordinary
case. Return `nothing` when Sema could not build the argument.
"""
function BuildCXXDefaultArgExpr(x::AbstractSema, call_loc::SourceLocation, fd::AbstractFunctionDecl, param::ParmVarDecl, init::AbstractExpr=Expr_(C_NULL))
    @check_ptrs x fd param
    @assert hasDefaultArg(param) "the parameter must have a default argument"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXDefaultArgExpr(x, call_loc, fd, param, init, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXMemberCallExpr(x::AbstractSema, exp, found_decl, method, had_multiple_candidates=false)
Build the call of the conversion function `method` on the object expression `exp`.

`exp` must designate an object of class type whose class declares or inherits `method`,
since clang initializes the implicit object parameter from `exp` with no fallback;
`found_decl` is what name lookup produced, normally `method` itself. Return `nothing` when
Sema rejected the conversion.
"""
function BuildCXXMemberCallExpr(x::AbstractSema, exp::AbstractExpr, found_decl::AbstractNamedDecl, method::AbstractCXXConversionDecl, had_multiple_candidates::Bool=false)
    @check_ptrs x exp found_decl method
    @assert isRecordType(expr_type_ptr(exp)) "the object operand must have class type"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXMemberCallExpr(x, exp, found_decl, method, had_multiple_candidates, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildMemberInitializer(x::AbstractSema, member, init, id_loc)
Build the `CXXCtorInitializer` that initializes `member` from `init`.

`member` must be a `FieldDecl` or an `IndirectFieldDecl`, which is what
`clang::Sema::BuildMemberInitializer` asserts. Return `nothing` when Sema rejected the
initializer.
"""
function BuildMemberInitializer(x::AbstractSema, member::Union{AbstractFieldDecl,AbstractIndirectFieldDecl}, init::AbstractExpr, id_loc::SourceLocation)
    @check_ptrs x member init
    invalid = Ref{Bool}(false)
    ci = clang_Sema_BuildMemberInitializer(x, member, init, id_loc, invalid)
    return invalid[] ? nothing : CXXCtorInitializer(ci)
end

# --- Per-operator operand type checking ---
# The checks `CreateBuiltinBinOp` dispatches to once it knows the opcode. Each answers the
# type the operator yields together with the operands after the conversions the check
# inserted, or `nothing` when the operands are ill-formed — which clang diagnoses at `loc`.

"""
    CheckMultiplyDivideOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, is_comp_assign::Bool=false, is_divide::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check the operands of `*` or `/`, returning the result type and the two converted
operands. `is_divide` selects the division-specific diagnostics; `is_comp_assign` says the
caller is checking `*=` or `/=` rather than the plain operator.

Returns `nothing` when the operands are not both arithmetic, which is diagnosed at `loc`.
"""
function CheckMultiplyDivideOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, is_comp_assign::Bool=false, is_divide::Bool=false)
    @check_ptrs x lhs rhs
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckMultiplyDivideOperands(x, lhs_io, rhs_io, loc, is_comp_assign, is_divide)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckRemainderOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, is_comp_assign::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check the operands of `%` or `%=`, returning the result type and the two converted
operands. Returns `nothing` when the operands do not both end up integral, which is
diagnosed at `loc`.
"""
function CheckRemainderOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, is_comp_assign::Bool=false)
    @check_ptrs x lhs rhs
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckRemainderOperands(x, lhs_io, rhs_io, loc, is_comp_assign)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckAdditionOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, opc::CXBinaryOperatorKind, is_comp_assign::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_,Union{Nothing,QualType}}}
Type-check the operands of `+` or `+=`, returning the result type, the two converted
operands, and the compound-assignment left-operand type.

`opc` distinguishes the two spellings in the diagnostics. The fourth element is `nothing`
unless `is_comp_assign` is set, in which case it is the left operand's type *before* the
usual arithmetic conversions — the type a compound assignment converts back to.

Returns `nothing` when the operands are ill-formed, which is diagnosed at `loc`.
"""
function CheckAdditionOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, opc::CXBinaryOperatorKind, is_comp_assign::Bool=false)
    @check_ptrs x lhs rhs
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    comp = Ref{CXQualType}(C_NULL)
    t = clang_Sema_CheckAdditionOperands(x, lhs_io, rhs_io, loc, opc, is_comp_assign, comp)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[]), is_comp_assign ? QualType(comp[]) : nothing
end

"""
    CheckSubtractionOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, is_comp_assign::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_,Union{Nothing,QualType}}}
Type-check the operands of `-` or `-=`, with the same four-element result as
[`CheckAdditionOperands`](@ref): the result type, the two converted operands, and — only
when `is_comp_assign` is set — the left operand's type before the usual arithmetic
conversions.

Returns `nothing` when the operands are ill-formed, which is diagnosed at `loc`.
"""
function CheckSubtractionOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, is_comp_assign::Bool=false)
    @check_ptrs x lhs rhs
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    comp = Ref{CXQualType}(C_NULL)
    t = clang_Sema_CheckSubtractionOperands(x, lhs_io, rhs_io, loc, is_comp_assign, comp)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[]), is_comp_assign ? QualType(comp[]) : nothing
end

"""
    CheckShiftOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, opc::CXBinaryOperatorKind, is_comp_assign::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check the operands of `<<` or `>>`, returning the result type and the two converted
operands. `opc` selects which of the two — and, with `is_comp_assign`, which compound form
— is being checked.

Returns `nothing` when the operands are ill-formed, which is diagnosed at `loc`.
"""
function CheckShiftOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, opc::CXBinaryOperatorKind, is_comp_assign::Bool=false)
    @check_ptrs x lhs rhs
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckShiftOperands(x, lhs_io, rhs_io, loc, opc, is_comp_assign)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckPtrComparisonWithNullChar(x::AbstractSema, e::AbstractExpr, null_e::AbstractExpr) -> Union{Nothing,Tuple{Expr_,Expr_}}
Warn about comparing a pointer against a `'\\0'` character literal, returning the two
operands. Neither operand being a pointer returns before the warning, so this is a no-op on
arithmetic operands.
"""
function CheckPtrComparisonWithNullChar(x::AbstractSema, e::AbstractExpr, null_e::AbstractExpr)
    @check_ptrs x e null_e
    e_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, e))
    null_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, null_e))
    clang_Sema_CheckPtrComparisonWithNullChar(x, e_io, null_io)
    (e_io[] == C_NULL || null_io[] == C_NULL) && return nothing
    return Expr_(e_io[]), Expr_(null_io[])
end

"""
    CheckCompareOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, opc::CXBinaryOperatorKind) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check the operands of a relational, equality or three-way comparison operator,
returning the result type and the two converted operands.

Returns `nothing` when the operands are not comparable, which is diagnosed at `loc`.
"""
function CheckCompareOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, opc::CXBinaryOperatorKind)
    @check_ptrs x lhs rhs
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckCompareOperands(x, lhs_io, rhs_io, loc, opc)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckAssignmentOperands(x::AbstractSema, lhs_expr, rhs, loc::SourceLocation, compound_type=QualType(C_NULL), opc=CXBinaryOperatorKind_BO_Assign) -> Union{Nothing,Tuple{QualType,Expr_}}
Type-check an assignment, returning the type of the assignment expression together with the
converted right operand. The left operand is never converted, so only the right one comes
back.

A NULL `compound_type` selects simple assignment; otherwise it is the type the compound
operator computed. `lhs_expr` must be a modifiable lvalue — clang diagnoses anything else
at `loc`, so the wrapper rejects it first.
"""
function CheckAssignmentOperands(x::AbstractSema, lhs_expr::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, compound_type::QualType=QualType(C_NULL), opc::CXBinaryOperatorKind=CXBinaryOperatorKind_BO_Assign)
    @check_ptrs x lhs_expr rhs
    mlv = isModifiableLvalue(lhs_expr, getASTContext(x))
    @assert mlv == CXExpr_MLV_Valid "the left operand must be a modifiable lvalue"
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckAssignmentOperands(x, lhs_expr, rhs_io, loc, compound_type, opc)
    (t == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(rhs_io[])
end

"""
    CheckPointerToMemberOperands(x::AbstractSema, lhs, rhs, op_loc::SourceLocation, is_indirect::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_,CXExprValueKind}}
Type-check the operands of `.*` (`is_indirect` false) or `->*` (`is_indirect` true),
returning the result type, the two converted operands and the value kind of the result.

`rhs` must have member-pointer type, and `->*` additionally needs a pointer as its left
operand — clang diagnoses anything else at `op_loc`.
"""
function CheckPointerToMemberOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, op_loc::SourceLocation, is_indirect::Bool=false)
    @check_ptrs x lhs rhs
    @assert isMemberPointerType(expr_type_ptr(rhs)) "the right operand of .* / ->* must have member-pointer type"
    @assert !is_indirect || isPointerType(expr_type_ptr(lhs)) "->* takes a pointer as its left operand"
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    vk = Ref{CXExprValueKind}(CXExprValueKind_VK_PRValue)
    t = clang_Sema_CheckPointerToMemberOperands(x, lhs_io, rhs_io, vk, op_loc, is_indirect)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[]), vk[]
end

"""
    CheckAddressOfOperand(x::AbstractSema, operand::AbstractExpr, op_loc::SourceLocation) -> Union{Nothing,Tuple{QualType,Expr_}}
Type-check the operand of the unary `&`, returning the pointer (or pointer-to-member) type
the operator yields together with the possibly-resolved operand.

The operand must be an lvalue, or carry a placeholder type — an unresolved overload set is
the case clang resolves here. clang diagnoses a plain prvalue at `op_loc`, so the wrapper
rejects it first. Returns `nothing` when the address still cannot be taken.
"""
function CheckAddressOfOperand(x::AbstractSema, operand::AbstractExpr, op_loc::SourceLocation)
    @check_ptrs x operand
    addressable = isLValue(operand) || isPlaceholderType(expr_type_ptr(operand))
    @assert addressable "the operand of unary & must be an lvalue or an overload set"
    op_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, operand))
    t = clang_Sema_CheckAddressOfOperand(x, op_io, op_loc)
    (t == C_NULL || op_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(op_io[])
end

"""
    CheckExtVectorCast(x::AbstractSema, rng::SourceRange, dest_ty::QualType, cast_expr::AbstractExpr) -> Union{Nothing,Tuple{Expr_,CXCastKind}}
Convert `cast_expr` to the extended vector type `dest_ty`, splatting a scalar across it,
and return the converted expression together with the cast kind.

`dest_ty` must be an `ext_vector` type — clang asserts on it — and a scalar `cast_expr` must
already be a prvalue, since the splat is inserted as an implicit prvalue cast. Returns
`nothing` when Sema rejected the cast, which is diagnosed over `rng`.
"""
function CheckExtVectorCast(x::AbstractSema, rng::SourceRange, dest_ty::QualType, cast_expr::AbstractExpr)
    @check_ptrs x dest_ty cast_expr
    @assert isExtVectorType(getTypePtr(dest_ty)) "dest_ty must be an ext_vector type"
    src = expr_type_ptr(cast_expr)
    @assert isVectorType(src) || isPRValue(cast_expr) "a scalar operand must be a prvalue"
    kind = Ref{CXCastKind}(CXCastKind_CK_Dependent)
    invalid = Ref{Bool}(false)
    e = clang_Sema_CheckExtVectorCast(x, getBeginLoc(rng), getEndLoc(rng), dest_ty, cast_expr, kind, invalid)
    return invalid[] ? nothing : (Expr_(e), kind[])
end

"""
    CheckMemberPointerConversion(x::AbstractSema, from::AbstractExpr, to_type::QualType, ignore_base_access::Bool=false) -> (Bool, CXCastKind)
Return whether converting `from` to the member-pointer type `to_type` is ill-formed,
together with the cast kind the conversion would use. `ignore_base_access` skips the access
check on the base step.

`to_type` must be a member-pointer type — clang reaches it through an unchecked `castAs` —
and `from` must either have member-pointer type too or be a null pointer constant, which
clang asserts. The base-specifier path clang fills alongside the cast kind is not exposed.
"""
function CheckMemberPointerConversion(x::AbstractSema, from::AbstractExpr, to_type::QualType, ignore_base_access::Bool=false)
    @check_ptrs x from to_type
    @assert isMemberPointerType(getTypePtr(to_type)) "to_type must be a member-pointer type"
    npc = isNullPointerConstant(from, getASTContext(x), CXExpr_NPC_ValueDependentIsNull)
    from_ok = isMemberPointerType(expr_type_ptr(from)) || npc != CXExpr_NPCK_NotNull
    @assert from_ok "from must be a member pointer or a null pointer constant"
    kind = Ref{CXCastKind}(CXCastKind_CK_Dependent)
    failed = clang_Sema_CheckMemberPointerConversion(x, from, to_type, kind, ignore_base_access)
    return failed, kind[]
end

"""
    CheckExplicitObjectOverride(x::AbstractSema, new_md::AbstractCXXMethodDecl, old_md::AbstractCXXMethodDecl) -> Bool
Apply the explicit-object-parameter rule to `new_md` overriding `old_md`. A violation is
diagnosed at `new_md` and marks it invalid; an overrider with no explicit object parameter
is accepted without any diagnostic.
"""
function CheckExplicitObjectOverride(x::AbstractSema, new_md::AbstractCXXMethodDecl, old_md::AbstractCXXMethodDecl)
    @check_ptrs x new_md old_md
    return clang_Sema_CheckExplicitObjectOverride(x, new_md, old_md)
end

"""
    CheckDelayedMemberExceptionSpecs(x::AbstractSema) -> Nothing
Run the exception-specification checks Sema deferred while a class was still being defined,
then clear the deferred lists. Between parses both lists are empty, so this does nothing.
"""
function CheckDelayedMemberExceptionSpecs(x::AbstractSema)
    @check_ptrs x
    clang_Sema_CheckDelayedMemberExceptionSpecs(x)
    return nothing
end

"""
    CheckCoroutineWrapper(x::AbstractSema, fd::AbstractFunctionDecl) -> Nothing
Diagnose `fd` when its return type carries the coroutine-return-type attribute but `fd` is
neither a coroutine nor marked as a coroutine wrapper. A function whose return type is not
such a record returns immediately, so this is a no-op on ordinary functions.
"""
function CheckCoroutineWrapper(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    clang_Sema_CheckCoroutineWrapper(x, fd)
    return nothing
end

# --- Rebuilding declarations, parameters and template names ---

"""
    hasCurrentInstantiationScope(x::AbstractSema) -> Bool
Return whether a local instantiation scope is currently open on `x`.

The wrappers that rebuild a declaration assert this before their ccall: clang writes the
pattern-to-instance mapping through `Sema::CurrentInstantiationScope` without checking it,
so an unset scope is a segfault rather than a failed substitution. Scopes are opened by
[`LocalInstantiationScope`](@ref).
"""
function hasCurrentInstantiationScope(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_hasCurrentInstantiationScope(x)
end

"""
    SubstFunctionDeclType(x::AbstractSema, t::AbstractTypeSourceInfo, template_args, loc,
                          entity=DeclarationName(C_NULL), this_context=CXXRecordDecl(C_NULL),
                          this_type_quals=0, evaluate_constraints=true) -> TypeSourceInfo
Rebuild the function type `t` with `template_args` substituted into it. Unlike
[`SubstTypeSourceInfo`](@ref) a function-prototype `TypeLoc` is transformed specially, so
that `this` inside the parameters and the trailing return type resolves against
`this_context` with `this_type_quals` (a `Qualifiers` opaque value) applied. A NULL carrier
means substitution failed.

Rebuilding a prototype rebuilds its parameters, so this needs both a live
[`InstantiatingTemplate`](@ref) and a live [`LocalInstantiationScope`](@ref).
"""
function SubstFunctionDeclType(x::AbstractSema, t::AbstractTypeSourceInfo, template_args::AbstractMultiLevelTemplateArgumentList, loc::SourceLocation, entity::DeclarationName=DeclarationName(C_NULL), this_context::AbstractCXXRecordDecl=CXXRecordDecl(C_NULL), this_type_quals::Integer=0, evaluate_constraints::Bool=true)
    @check_ptrs x t template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasCurrentInstantiationScope(x) "rebuilding a prototype needs a live LocalInstantiationScope"
    return TypeSourceInfo(clang_Sema_SubstFunctionDeclType(x, t, template_args, loc, entity, this_context, this_type_quals, evaluate_constraints))
end

"""
    SubstExceptionSpec(x::AbstractSema, new_fd::AbstractFunctionDecl,
                       proto::AbstractFunctionProtoType, template_args)
Substitute `template_args` into `proto`'s exception specification and install the result on
`new_fd` and every redeclaration of it. A no-op when `proto` carries neither a computed
`noexcept` nor a dynamic exception list.

Clang reads `new_fd`'s `TypeSourceInfo` for the diagnostic location with no null check, so a
function that has one is a precondition and is asserted here. Requires a live
[`InstantiatingTemplate`](@ref).
"""
function SubstExceptionSpec(x::AbstractSema, new_fd::AbstractFunctionDecl, proto::AbstractFunctionProtoType, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x new_fd proto template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert getTypeSourceInfo(new_fd).ptr != C_NULL "the function must have a TypeSourceInfo"
    return clang_Sema_SubstExceptionSpec(x, new_fd, proto, template_args)
end

"""
    SubstParmVarDecl(x::AbstractSema, d::AbstractParmVarDecl, template_args,
                     index_adjustment=0, num_expansions=nothing,
                     expect_parameter_pack=false, evaluate_constraints=true) -> ParmVarDecl
Rebuild parameter `d` with `template_args` substituted into its type and default argument.
`index_adjustment` shifts the new parameter's index, and `num_expansions` is Clang's
`optional<unsigned>` pack size. A NULL carrier means substitution failed.

The new parameter is created in the translation unit until the caller reparents it, and the
`d` to result mapping is recorded in the current scope, so this needs both a live
[`InstantiatingTemplate`](@ref) and a live [`LocalInstantiationScope`](@ref).
"""
function SubstParmVarDecl(x::AbstractSema, d::AbstractParmVarDecl, template_args::AbstractMultiLevelTemplateArgumentList, index_adjustment::Integer=0, num_expansions::Union{Nothing,Integer}=nothing, expect_parameter_pack::Bool=false, evaluate_constraints::Bool=true)
    @check_ptrs x d template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasCurrentInstantiationScope(x) "rebuilding a parameter needs a live LocalInstantiationScope"
    return ParmVarDecl(clang_Sema_SubstParmVarDecl(x, d, template_args, index_adjustment, num_expansions !== nothing, num_expansions === nothing ? 0 : num_expansions, expect_parameter_pack, evaluate_constraints))
end

"""
    SubstExprs(x::AbstractSema, exprs, is_call::Bool, template_args) -> Union{Nothing,Vector{Expr_}}
Rebuild every expression in `exprs` with `template_args` substituted into it, expanding pack
expansions, and return the results. The result length is therefore not the input length.
Return `nothing` when the substitution errored.

`is_call` marks the list as a call's argument list, in which case default arguments are
dropped. Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstExprs(x::AbstractSema, exprs::AbstractVector{<:AbstractExpr}, is_call::Bool, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x template_args
    @assert all(e -> e.ptr != C_NULL, exprs) "every expression must be non-NULL"
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    in_buf = CXExpr[Base.unsafe_convert(CXExpr, e) for e in exprs]
    produced = Ref{Cuint}(0)
    out = Vector{CXExpr}(undef, length(in_buf))
    clang_Sema_SubstExprs(x, in_buf, length(in_buf), is_call, template_args, out, length(out), produced) && return nothing
    if produced[] > length(out)
        out = Vector{CXExpr}(undef, produced[])
        clang_Sema_SubstExprs(x, in_buf, length(in_buf), is_call, template_args, out, length(out), produced) && return nothing
    end
    return Expr_[Expr_(out[i]) for i = 1:Int(produced[])]
end

"""
    SubstTemplateParams(x::AbstractSema, params::AbstractTemplateParameterList,
                        owner::AbstractDeclContext, template_args,
                        evaluate_constraints=true) -> TemplateParameterList
Rebuild the template parameter list `params` inside `owner`, substituting `template_args`
into each parameter's type, default argument and type constraint. A NULL carrier means some
parameter failed to substitute.

Each rebuilt parameter is recorded in the current scope, so this needs both a live
[`InstantiatingTemplate`](@ref) and a live [`LocalInstantiationScope`](@ref).
"""
function SubstTemplateParams(x::AbstractSema, params::AbstractTemplateParameterList, owner::AbstractDeclContext, template_args::AbstractMultiLevelTemplateArgumentList, evaluate_constraints::Bool=true)
    @check_ptrs x params owner template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasCurrentInstantiationScope(x) "rebuilding a parameter needs a live LocalInstantiationScope"
    return TemplateParameterList(clang_Sema_SubstTemplateParams(x, params, owner, template_args, evaluate_constraints))
end

"""
    SubstDecl(x::AbstractSema, d::AbstractDecl, owner::AbstractDeclContext, template_args) -> Decl
Rebuild declaration `d` inside `owner` with `template_args` substituted into it - the
declaration-level counterpart of [`SubstType`](@ref). A NULL carrier means substitution
failed.

This *mutates* `owner`: most declaration kinds are added to it as they are built. The result
comes back at the `Decl` floor because its class is `d`'s own; refine it with an explicit
cast. Needs both a live [`InstantiatingTemplate`](@ref) and a live
[`LocalInstantiationScope`](@ref).
"""
function SubstDecl(x::AbstractSema, d::AbstractDecl, owner::AbstractDeclContext, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x d owner template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasCurrentInstantiationScope(x) "rebuilding a declaration needs a live LocalInstantiationScope"
    return Decl(clang_Sema_SubstDecl(x, d, owner, template_args))
end

"""
    SubstTemplateName(x::AbstractSema, name::TemplateName, loc::SourceLocation, template_args,
                      qualifier_loc=NestedNameSpecifierLoc(C_NULL)) -> TemplateName
Rebuild the template name `name` with `template_args` substituted into it. `qualifier_loc`
is the written nested-name-specifier the name appeared after and defaults to the NULL
carrier, meaning the name was written unqualified; Clang takes it first, this wrapper takes
it last so it can be defaulted. A null result means substitution failed.

Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstTemplateName(x::AbstractSema, name::TemplateName, loc::SourceLocation, template_args::AbstractMultiLevelTemplateArgumentList, qualifier_loc::AbstractNestedNameSpecifierLoc=NestedNameSpecifierLoc(C_NULL))
    @check_ptrs x template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return TemplateName(clang_Sema_SubstTemplateName(x, qualifier_loc, name, loc, template_args))
end

"""
    InstantiateInClassInitializer(x::AbstractSema, point_of_instantiation::SourceLocation,
                                  instantiation::AbstractFieldDecl, pattern::AbstractFieldDecl,
                                  template_args) -> Bool
Instantiate `pattern`'s default member initializer into `instantiation` and return whether
that failed. Returns `false` without reading anything else out of either field when
`pattern` has no default member initializer at all.

When `pattern` does have one, clang asserts that the two fields agree on their in-class
initializer style; [`hasInClassInitializer`](@ref) is the part of that condition this layer
can observe, and it is asserted here. Requires a live [`InstantiatingTemplate`](@ref).
"""
function InstantiateInClassInitializer(x::AbstractSema, point_of_instantiation::SourceLocation, instantiation::AbstractFieldDecl, pattern::AbstractFieldDecl, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x instantiation pattern template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasInClassInitializer(instantiation) == hasInClassInitializer(pattern) "the two fields must agree on having a default member initializer"
    return clang_Sema_InstantiateInClassInitializer(x, point_of_instantiation, instantiation, pattern, template_args)
end

"""
    InstantiateAttrs(x::AbstractSema, template_args, pattern::AbstractDecl, inst::AbstractDecl,
                     outer_most_scope=LocalInstantiationScope(C_NULL))
Copy `pattern`'s attributes onto `inst`, substituting `template_args` into the ones that
carry expressions or types. `outer_most_scope` may be the NULL carrier.

Clang's `LateAttrs` out-parameter is not exposed: it exists so the parser can defer
attributes whose arguments are not parsed yet, and nothing outside the parser can consume
one, so this always passes the null Clang itself passes off the parser path. Requires a live
[`InstantiatingTemplate`](@ref).
"""
function InstantiateAttrs(x::AbstractSema, template_args::AbstractMultiLevelTemplateArgumentList, pattern::AbstractDecl, inst::AbstractDecl, outer_most_scope::AbstractLocalInstantiationScope=LocalInstantiationScope(C_NULL))
    @check_ptrs x template_args pattern inst
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return clang_Sema_InstantiateAttrs(x, template_args, pattern, inst, outer_most_scope)
end

"""
    InstantiateAttrsForDecl(x::AbstractSema, template_args, pattern::AbstractDecl,
                            inst::AbstractDecl, outer_most_scope=LocalInstantiationScope(C_NULL))
The subset of [`InstantiateAttrs`](@ref) that has to run before the instantiated
declaration's type is built. A no-op unless `inst` is a `NamedDecl`.
"""
function InstantiateAttrsForDecl(x::AbstractSema, template_args::AbstractMultiLevelTemplateArgumentList, pattern::AbstractDecl, inst::AbstractDecl, outer_most_scope::AbstractLocalInstantiationScope=LocalInstantiationScope(C_NULL))
    @check_ptrs x template_args pattern inst
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    return clang_Sema_InstantiateAttrsForDecl(x, template_args, pattern, inst, outer_most_scope)
end

"""
    PerformDependentDiagnostics(x::AbstractSema, pattern::AbstractDeclContext, template_args)
Replay the access checks Sema deferred while parsing the dependent context `pattern`, now
that `template_args` makes them checkable.

Clang asserts that `pattern` is dependent before iterating the stored diagnostics, so
[`is_dependent_context`](@ref) is restated here as a precondition.
"""
function PerformDependentDiagnostics(x::AbstractSema, pattern::AbstractDeclContext, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x pattern template_args
    @assert is_dependent_context(pattern) "the pattern context must be dependent"
    return clang_Sema_PerformDependentDiagnostics(x, pattern, template_args)
end

"""
    FindAllocationFunctions(x::AbstractSema, start_loc::SourceLocation, range::SourceRange,
                            new_scope::CXAllocationFunctionScope,
                            delete_scope::CXAllocationFunctionScope, alloc_ty::QualType;
                            is_array::Bool=false, pass_alignment::Bool=false,
                            place_args=Expr_[], diagnose::Bool=false)
        -> (Bool, Bool, FunctionDecl, FunctionDecl)
Look the `operator new` and `operator delete` a new-expression allocating `alloc_ty` would
call up in `new_scope` and `delete_scope`.

Returns the failure flag, the alignment flag read back — whether the chosen `operator new`
actually takes an alignment argument — and the two operators; a slot is a null-pointer
carrier when nothing was chosen. Declaring the implicit global `operator new`/`operator
delete` is a side effect on the translation unit, so run this against an interpreter you
own. `diagnose` reports why a lookup failed through Sema's `DiagnosticsEngine`; it must
stay `false` outside the parser, which has no source context to render a diagnostic
against.
"""
function FindAllocationFunctions(x::AbstractSema, start_loc::SourceLocation, range::SourceRange, new_scope::CXAllocationFunctionScope, delete_scope::CXAllocationFunctionScope, alloc_ty::QualType; is_array::Bool=false, pass_alignment::Bool=false, place_args::AbstractVector{<:AbstractExpr}=Expr_[], diagnose::Bool=false)
    @check_ptrs x alloc_ty
    @assert all(a -> a.ptr != C_NULL, place_args) "a placement argument holds no null slot"
    align = Ref{Bool}(pass_alignment)
    argbuf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in place_args]
    opnew = Ref{CXFunctionDecl}(C_NULL)
    opdel = Ref{CXFunctionDecl}(C_NULL)
    failed = clang_Sema_FindAllocationFunctions(x, start_loc, getBeginLoc(range), getEndLoc(range), new_scope, delete_scope, alloc_ty, is_array, align, argbuf, length(argbuf), opnew, opdel, diagnose)
    return failed, align[], FunctionDecl(opnew[]), FunctionDecl(opdel[])
end

"""
    FindCompositePointerType(x::AbstractSema, loc::SourceLocation, e1::AbstractExpr,
                             e2::AbstractExpr; convert_args::Bool=false)
        -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
The composite pointer type of `e1` and `e2` together with the two operands, or `nothing`
when they have no composite pointer type — clang leaves that diagnostic to its caller.

`convert_args` inserts the implicit conversions to the composite type into the operands
that come back. It defaults to `false`, which makes the call a pure type computation: a
conversion clang cannot build is diagnosed, and outside a parse there is no source context
to render a diagnostic against.
"""
function FindCompositePointerType(x::AbstractSema, loc::SourceLocation, e1::AbstractExpr, e2::AbstractExpr; convert_args::Bool=false)
    @check_ptrs x e1 e2
    a = Ref{CXExpr}(Base.unsafe_convert(CXExpr, e1))
    b = Ref{CXExpr}(Base.unsafe_convert(CXExpr, e2))
    t = clang_Sema_FindCompositePointerType(x, loc, a, b, convert_args)
    t == C_NULL && return nothing
    return QualType(t), Expr_(a[]), Expr_(b[])
end

"""
    FindInstantiatedDecl(x::AbstractSema, loc::SourceLocation, d::AbstractNamedDecl,
                         args::AbstractMultiLevelTemplateArgumentList,
                         finding_instantiated_context::Bool=false) -> NamedDecl
The declaration `d` denotes once `args` have been substituted for the enclosing template's
parameters — `d` itself when nothing about its declaration context depends on them.

PARTIAL: for a function parameter, a template parameter, or a declaration local to a
dependent function, clang looks the instantiation up in the current local instantiation
scope and asserts when it is not there. A wrapper call carries no such scope, so those
inputs are rejected here.
"""
function FindInstantiatedDecl(x::AbstractSema, loc::SourceLocation, d::AbstractNamedDecl, args::AbstractMultiLevelTemplateArgumentList, finding_instantiated_context::Bool=false)
    @check_ptrs x d args
    @assert getDeclKindName(d) ∉ ("ParmVar", "TemplateTypeParm", "NonTypeTemplateParm", "TemplateTemplateParm") "a parameter declaration needs a live local instantiation scope"
    @assert !isFunctionOrMethod(getDeclContext(d)) "a declaration local to a function needs a live local instantiation scope"
    return NamedDecl(clang_Sema_FindInstantiatedDecl(x, loc, d, args, finding_instantiated_context))
end

"""
    FindInstantiatedContext(x::AbstractSema, loc::SourceLocation, ctx::AnyDeclContext,
                            args::AbstractMultiLevelTemplateArgumentList) -> DeclContext
The declaration context `ctx` denotes once `args` have been substituted.

A context that is not itself a named declaration — the translation unit, a linkage
specification — comes back unchanged; anything else is routed through
[`FindInstantiatedDecl`](@ref) and carries its precondition, so a function or method
context is rejected here.
"""
function FindInstantiatedContext(x::AbstractSema, loc::SourceLocation, ctx::AnyDeclContext, args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x ctx args
    @assert !isFunctionOrMethod(ctx) "a function or method context needs a live local instantiation scope"
    return DeclContext(clang_Sema_FindInstantiatedContext(x, loc, ctx, args))
end

"""
    ResolveSingleFunctionTemplateSpecialization(x::AbstractSema, ovl::AbstractOverloadExpr;
                                                complain::Bool=false)
        -> Union{Nothing,Tuple{FunctionDecl,NamedDecl,CXAccessSpecifier}}
The single function template specialization `ovl` names, together with the declaration that
was found and the access it was found with, or `nothing` when the overload set does not
resolve to exactly one specialization.

`complain` reports why a set did not resolve through Sema's `DiagnosticsEngine`; it
defaults to `false`, which makes the call a pure query.
"""
function ResolveSingleFunctionTemplateSpecialization(x::AbstractSema, ovl::AbstractOverloadExpr; complain::Bool=false)
    @check_ptrs x ovl
    found = Ref{CXNamedDecl}(C_NULL)
    access = Ref{CXAccessSpecifier}(CXAccessSpecifier_AS_none)
    p = clang_Sema_ResolveSingleFunctionTemplateSpecialization(x, ovl, complain, found, access)
    p == C_NULL && return nothing
    return FunctionDecl(p), NamedDecl(found[]), access[]
end

"""
    AdjustParameterTypeForObjCAutoRefCount(x::AbstractSema, ty::QualType,
                                           name_loc::SourceLocation,
                                           tsi::AbstractTypeSourceInfo) -> QualType
`ty` with the Objective-C lifetime qualifier a parameter of that type would be given
inferred. Outside ARC clang returns `ty` unchanged, so in a C or C++ translation unit this
is the identity. `tsi` supplies the source range the inference is reported against.
"""
function AdjustParameterTypeForObjCAutoRefCount(x::AbstractSema, ty::QualType, name_loc::SourceLocation, tsi::AbstractTypeSourceInfo)
    @check_ptrs x ty tsi
    return QualType(clang_Sema_AdjustParameterTypeForObjCAutoRefCount(x, ty, name_loc, tsi))
end

"""
    SetFunctionBodyKind(x::AbstractSema, fd::AbstractFunctionDecl, loc::SourceLocation,
                        kind::CXFnBodyKind) -> Nothing
Give `fd` the body kind a `= default;` or `= delete;` definition would give it.

`kind` must be `CXFnBodyKind_Default` or `CXFnBodyKind_Delete`: `CXFnBodyKind_Other` is the
parser's "an ordinary compound statement follows" state, which this entry point has no
handling for. `fd` must not already have a body and must be the first declaration of its
function — a later one is diagnosed, and rendering a diagnostic outside a parse is not
safe. The receiver is typed at `AbstractFunctionDecl` although clang's parameter is a plain
`Decl *`, because a declaration that is not a function is diagnosed too.
"""
function SetFunctionBodyKind(x::AbstractSema, fd::AbstractFunctionDecl, loc::SourceLocation, kind::CXFnBodyKind)
    @check_ptrs x fd
    @assert kind != CXFnBodyKind_Other "the body kind must be Default or Delete"
    @assert !hasBody(fd) "the function must not already have a body"
    @assert getPreviousDecl(fd).ptr == C_NULL "only the first declaration of a function can be defaulted or deleted"
    clang_Sema_SetFunctionBodyKind(x, fd, loc, kind)
    return nothing
end

"""
    setExceptionMode(x::AbstractSema, loc::SourceLocation,
                     mode::CXFPExceptionModeKind) -> Nothing
Set the floating-point exception behaviour in force from `loc` on, exactly as
`#pragma clang fp exceptions(...)` would.

The change lands in Sema's current FP features, so [`CurFPFeatureOverrides`](@ref) reports
it afterwards, and it stays in force for every expression built later — call it on an
interpreter you own.
"""
function setExceptionMode(x::AbstractSema, loc::SourceLocation, mode::CXFPExceptionModeKind)
    @check_ptrs x
    clang_Sema_setExceptionMode(x, loc, mode)
    return nothing
end

"""
    RegisterLocallyScopedExternCDecl(x::AbstractSema, nd::AbstractNamedDecl,
                                     s::Union{Nothing,AbstractScope}=nothing) -> Nothing
Record `nd` in the side table Sema keeps for block-scope `extern "C"` declarations — the
table [`findLocallyScopedExternCDecl`](@ref) reads.

`s` names the scope the declaration was seen in and may be left out. The table outlives the
call, so run this against an interpreter you own.
"""
function RegisterLocallyScopedExternCDecl(x::AbstractSema, nd::AbstractNamedDecl, s::Union{Nothing,AbstractScope}=nothing)
    @check_ptrs x nd
    sp = s === nothing ? CXScope(C_NULL) : Base.unsafe_convert(CXScope, s)
    clang_Sema_RegisterLocallyScopedExternCDecl(x, nd, sp)
    return nothing
end

"""
    MergeVarDeclTypes(x::AbstractSema, new_vd::AbstractVarDecl, old_vd::AbstractVarDecl,
                      merge_type_with_old::Bool=false) -> Nothing
Give `new_vd` the type merged from its own and `old_vd`'s, as a redeclaration of `old_vd`
would.

`merge_type_with_old` picks `old_vd`'s type where the two differ only in a way the merge
tolerates. Types that do not merge are diagnosed at `new_vd` and leave it invalid, so pass
declarations whose types already merge: rendering a diagnostic outside a parse is not safe.
`new_vd` is mutated, so run this against an interpreter you own.
"""
function MergeVarDeclTypes(x::AbstractSema, new_vd::AbstractVarDecl, old_vd::AbstractVarDecl, merge_type_with_old::Bool=false)
    @check_ptrs x new_vd old_vd
    clang_Sema_MergeVarDeclTypes(x, new_vd, old_vd, merge_type_with_old)
    return nothing
end

"""
    MergeVarDeclExceptionSpecs(x::AbstractSema, new_vd::AbstractVarDecl,
                               old_vd::AbstractVarDecl) -> Nothing
Check that `new_vd` and `old_vd` agree on the exception specification of the prototyped
function type they point or refer to, and mark `new_vd` invalid when they do not.

A variable that is not a pointer or reference to such a function is left alone. A mismatch
is diagnosed, so pass declarations whose specifications already agree: rendering a
diagnostic outside a parse is not safe.
"""
function MergeVarDeclExceptionSpecs(x::AbstractSema, new_vd::AbstractVarDecl, old_vd::AbstractVarDecl)
    @check_ptrs x new_vd old_vd
    clang_Sema_MergeVarDeclExceptionSpecs(x, new_vd, old_vd)
    return nothing
end

"""
    LookupOverloadedOperatorName(x::AbstractSema, op::CXOverloadedOperatorKind,
                                 sc::Scope) -> Vector{NamedDecl}
Return the non-member `operator op` functions visible from `sc`, member functions excluded.

This is the general form of [`LookupBinOp`](@ref), which is the binary-operator convenience
over it and cannot reach the call, subscript or unary operators. An entry carries a function
or, for a function template, its `FunctionTemplateDecl`, so the result comes back at the
container's element type and needs a checked cast to be refined.
"""
function LookupOverloadedOperatorName(x::AbstractSema, op::CXOverloadedOperatorKind, sc::Scope)
    @check_ptrs x sc
    @assert op != CXOverloadedOperatorKind_OO_None "an operator kind is required"
    n = clang_Sema_LookupOverloadedOperatorName(x, op, sc, Ptr{CXNamedDecl}(C_NULL), 0)
    n == 0 && return NamedDecl[]
    buf = Vector{CXNamedDecl}(undef, n)
    return NamedDecl.(resize!(buf, clang_Sema_LookupOverloadedOperatorName(x, op, sc, buf, n)))
end

"""
    LookupOverloadedBinOp(x::AbstractSema, cs::AbstractOverloadCandidateSet,
                          op::CXOverloadedOperatorKind,
                          fns::AbstractVector{<:AbstractNamedDecl},
                          accesses::AbstractVector{CXAccessSpecifier},
                          args::AbstractVector{<:AbstractExpr}; requires_adl::Bool=true)
Score the candidates for the overloaded binary operator `op` into `cs`: the member
candidates, the non-member ones named by `fns`, the built-in ones and, when `requires_adl`,
the argument-dependent ones.

`fns` and `accesses` are read in lockstep, so they must have the same length; `fns` is
usually what [`LookupOverloadedOperatorName`](@ref) returned. `args` holds the two operands.
"""
function LookupOverloadedBinOp(x::AbstractSema, cs::AbstractOverloadCandidateSet, op::CXOverloadedOperatorKind, fns::AbstractVector{<:AbstractNamedDecl}, accesses::AbstractVector{CXAccessSpecifier}, args::AbstractVector{<:AbstractExpr}; requires_adl::Bool=true)
    @check_ptrs x cs
    @assert op != CXOverloadedOperatorKind_OO_None "an operator kind is required"
    @assert length(fns) == length(accesses) "fns and accesses must have the same length"
    @assert length(args) == 2 "a binary operator takes both of its operands"
    fbuf = CXNamedDecl[Base.unsafe_convert(CXNamedDecl, d) for d in fns]
    abuf = collect(accesses)
    ebuf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_LookupOverloadedBinOp(x, cs, op, fbuf, abuf, length(fbuf), ebuf, length(ebuf), requires_adl)
end

"""
    currentEvaluationContext(x::AbstractSema) -> ExpressionEvaluationContextRecord
Return the innermost record of Sema's expression-evaluation context stack.

The stack is never empty — Sema's constructor pushes a potentially-evaluated record at the
bottom — so the carrier is never NULL. It borrows an interior pointer into that stack, so
read what you need out of it before anything pushes or pops a context.
"""
function currentEvaluationContext(x::AbstractSema)
    @check_ptrs x
    return ExpressionEvaluationContextRecord(clang_Sema_currentEvaluationContext(x))
end

"""
    getContext(x::AbstractExpressionEvaluationContextRecord) -> CXExpressionEvaluationContext
Return which evaluation context `x` is.
"""
function getContext(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    return clang_ExpressionEvaluationContextRecord_getContext(x)
end

"""
    getNumCleanupObjects(x::AbstractExpressionEvaluationContextRecord) -> Integer
Return the number of active cleanup objects when `x` was entered.
"""
function getNumCleanupObjects(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    return clang_ExpressionEvaluationContextRecord_getNumCleanupObjects(x)
end

"""
    getNumTypos(x::AbstractExpressionEvaluationContextRecord) -> Integer
Return the number of `TypoExpr`s created inside `x`.
"""
function getNumTypos(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    return clang_ExpressionEvaluationContextRecord_getNumTypos(x)
end

"""
    getManglingContextDecl(x::AbstractExpressionEvaluationContextRecord) -> Decl
Return the declaration providing the mangling context for lambdas and block literals when
the normal declaration context does not suffice. The returned carrier holds NULL in an
ordinary context.
"""
function getManglingContextDecl(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    return Decl(clang_ExpressionEvaluationContextRecord_getManglingContextDecl(x))
end

"""
    getExprContext(x::AbstractExpressionEvaluationContextRecord) -> CXExpressionKind
Return which syntactic construct opened `x`: a `decltype` operand, a template argument, or
anything else.
"""
function getExprContext(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    return clang_ExpressionEvaluationContextRecord_getExprContext(x)
end

"""
    isDiscardedStatementContext(x::AbstractExpressionEvaluationContextRecord) -> Bool
Return whether `x` is a discarded statement, or an immediate function context nested in one.

The record's three sibling predicates are already reachable at the Sema level, where they
ask this same innermost record: [`isUnevaluatedContext`](@ref),
[`isConstantEvaluatedContext`](@ref) and [`isImmediateFunctionContext`](@ref).
"""
function isDiscardedStatementContext(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    return clang_ExpressionEvaluationContextRecord_isDiscardedStatementContext(x)
end

"""
    getDelayedDefaultInitializationContext(x::AbstractExpressionEvaluationContextRecord) ->
        Union{Nothing,Tuple{SourceLocation,ValueDecl,DeclContext}}
Return the declaration whose default argument or default member initializer is being
evaluated in `x`, as the location, the declaration and its context, or `nothing` when there
is none. Both carriers are non-null whenever the triple is returned.
"""
function getDelayedDefaultInitializationContext(x::AbstractExpressionEvaluationContextRecord)
    @check_ptrs x
    loc = Ref{CXSourceLocation_}(C_NULL)
    decl = Ref{CXValueDecl}(C_NULL)
    ctx = Ref{CXDeclContext}(C_NULL)
    clang_ExpressionEvaluationContextRecord_getDelayedDefaultInitializationContext(x, loc, decl, ctx) || return nothing
    return SourceLocation(loc[]), ValueDecl(decl[]), DeclContext(ctx[])
end

"""
    InnermostDeclarationWithDelayedImmediateInvocations(x::AbstractSema) ->
        Union{Nothing,Tuple{SourceLocation,ValueDecl,DeclContext}}
Return the innermost declaration on the evaluation-context stack whose default argument or
default member initializer has delayed immediate invocations, as the location, the
declaration and its context — or `nothing` when there is none. The search stops at the first
constant-evaluated, immediate-function or unevaluated context.
"""
function InnermostDeclarationWithDelayedImmediateInvocations(x::AbstractSema)
    @check_ptrs x
    loc = Ref{CXSourceLocation_}(C_NULL)
    decl = Ref{CXValueDecl}(C_NULL)
    ctx = Ref{CXDeclContext}(C_NULL)
    clang_Sema_InnermostDeclarationWithDelayedImmediateInvocations(x, loc, decl, ctx) || return nothing
    return SourceLocation(loc[]), ValueDecl(decl[]), DeclContext(ctx[])
end

"""
    OutermostDeclarationWithDelayedImmediateInvocations(x::AbstractSema) ->
        Union{Nothing,Tuple{SourceLocation,ValueDecl,DeclContext}}
Return the outermost such declaration, with the same marshalling and the same stopping rule
as [`InnermostDeclarationWithDelayedImmediateInvocations`](@ref).
"""
function OutermostDeclarationWithDelayedImmediateInvocations(x::AbstractSema)
    @check_ptrs x
    loc = Ref{CXSourceLocation_}(C_NULL)
    decl = Ref{CXValueDecl}(C_NULL)
    ctx = Ref{CXDeclContext}(C_NULL)
    clang_Sema_OutermostDeclarationWithDelayedImmediateInvocations(x, loc, decl, ctx) || return nothing
    return SourceLocation(loc[]), ValueDecl(decl[]), DeclContext(ctx[])
end

"""
    IdentifyCUDATarget(x::AbstractSema, d::AbstractFunctionDecl,
                       ignore_implicit_hd_attr::Bool=false) -> CXCUDAFunctionTarget
Return whether `d` is a CUDA device, host, kernel or host-device function.

The answer comes from `d`'s attributes rather than from the language mode, so it is defined
for a non-CUDA translation unit too. `ignore_implicit_hd_attr` skips the host-device
attributes clang itself added.
"""
function IdentifyCUDATarget(x::AbstractSema, d::AbstractFunctionDecl, ignore_implicit_hd_attr::Bool=false)
    @check_ptrs x d
    return clang_Sema_IdentifyCUDATarget(x, d, ignore_implicit_hd_attr)
end

"""
    CurrentCUDATarget(x::AbstractSema) -> CXCUDAFunctionTarget
Return the CUDA target of the context Sema is in: the enclosing function's when the current
context is a function, and the global host/device context's otherwise.
"""
function CurrentCUDATarget(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_CurrentCUDATarget(x)
end

"""
    IdentifyCUDAPreference(x::AbstractSema, caller::Union{Nothing,AbstractFunctionDecl},
                           callee::AbstractFunctionDecl) -> CXCUDAFunctionPreference
Return how preferable the `caller`/`callee` combination is, from their host/device
attributes; `CXCUDAFunctionPreference_CFP_Never` means the call is not allowed. Pass
`nothing` for `caller` to ask about the global context.
"""
function IdentifyCUDAPreference(x::AbstractSema, caller::Union{Nothing,AbstractFunctionDecl}, callee::AbstractFunctionDecl)
    @check_ptrs x callee
    c = caller === nothing ? CXFunctionDecl(C_NULL) : Base.unsafe_convert(CXFunctionDecl, caller)
    return clang_Sema_IdentifyCUDAPreference(x, c, callee)
end

"""
    AlignPackInfo(mode::CXAlignPackInfo_Mode, num::Integer, is_xl::Bool) -> AlignPackInfo
Build the `#pragma pack` form of an alignment-stack slot: `mode` together with an explicit
pack number. `is_xl` marks the slot as belonging to an XL-style align/pack stack. This
function allocates and one should call `dispose` to release the resources after using this
object.

`num` must fit in an unsigned char: clang stores the pack number in one and asserts that it
was not truncated.
"""
function AlignPackInfo(mode::CXAlignPackInfo_Mode, num::Integer, is_xl::Bool)
    @assert 0 <= num <= 255 "the pack number must fit in an unsigned char"
    return AlignPackInfo(clang_AlignPackInfo_createPack(mode, num, is_xl))
end

"""
    AlignPackInfo(mode::CXAlignPackInfo_Mode, is_xl::Bool) -> AlignPackInfo
Build the `#pragma align` form of an alignment-stack slot: the pack number is derived from
`mode` (1 for `CXAlignPackInfo_Packed`, otherwise left unset) rather than given. This
function allocates and one should call `dispose` to release the resources after using this
object.
"""
function AlignPackInfo(mode::CXAlignPackInfo_Mode, is_xl::Bool)
    return AlignPackInfo(clang_AlignPackInfo_createAlign(mode, is_xl))
end

"""
    AlignPackInfo(encoding::Integer) -> AlignPackInfo
Rebuild a slot from an encoding produced by [`getRawEncoding`](@ref) — the Julia spelling of
`clang::Sema::AlignPackInfo::getFromRawEncoding`, which cannot use that name because
`getFromRawEncoding(::Integer)` already decodes a `SourceLocation`. This function allocates
and one should call `dispose` to release the resources after using this object.

The encoding carries only the low five bits of the pack number, so a slot built with a pack
number of 32 or more does not round-trip; an align slot, whose pack number is re-derived
from the mode, always does.
"""
function AlignPackInfo(encoding::Integer)
    return AlignPackInfo(clang_AlignPackInfo_getFromRawEncoding(encoding))
end

dispose(x::AlignPackInfo) = clang_AlignPackInfo_dispose(x)

"""
    getRawEncoding(x::AbstractAlignPackInfo) -> UInt32
Return the 32-bit encoding of the slot. It is meant only to be handed back to
`AlignPackInfo(encoding)`, not inspected.
"""
function getRawEncoding(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_getRawEncoding(x)
end

"""
    IsPackAttr(x::AbstractAlignPackInfo) -> Bool
Return whether the slot came from a `#pragma pack` rather than a `#pragma align`.
"""
function IsPackAttr(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_IsPackAttr(x)
end

"""
    IsAlignAttr(x::AbstractAlignPackInfo) -> Bool
Return whether the slot came from a `#pragma align` rather than a `#pragma pack`.
"""
function IsAlignAttr(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_IsAlignAttr(x)
end

"""
    getAlignMode(x::AbstractAlignPackInfo) -> CXAlignPackInfo_Mode
Return the alignment mode in effect for the slot. `CXAlignPackInfo_Native` stands for the
target's own default, so its meaning varies by platform.
"""
function getAlignMode(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_getAlignMode(x)
end

"""
    getPackNumber(x::AbstractAlignPackInfo) -> UInt32
Return the slot's pack number. It is meaningful only when [`IsPackSet`](@ref) holds; an
unset slot reports clang's sentinel value.
"""
function getPackNumber(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_getPackNumber(x)
end

"""
    IsPackSet(x::AbstractAlignPackInfo) -> Bool
Return whether a pack number was actually set. `#pragma align`, `#pragma pack()` and
`#pragma pack(0)` all leave it unset.
"""
function IsPackSet(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_IsPackSet(x)
end

"""
    IsXLStack(x::AbstractAlignPackInfo) -> Bool
Return whether the slot belongs to an XL-style `#pragma align`/`#pragma pack` stack.
"""
function IsXLStack(x::AbstractAlignPackInfo)
    @check_ptrs x
    return clang_AlignPackInfo_IsXLStack(x)
end

"""
    getDefaultedFunctionKind(x::AbstractSema, fd::AbstractFunctionDecl) -> DefaultedFunctionKind
Classify `fd` as one of the defaultable functions — a C++ special member, a defaultable
comparison operator, or neither. This function allocates and one should call `dispose` to
release the resources after using this object.

The classification is read off `fd`'s own declaration; it needs no live parse and emits no
diagnostic. [`getSpecialMember`](@ref) is the same query with the comparison arm dropped.
"""
function getDefaultedFunctionKind(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return DefaultedFunctionKind(clang_Sema_getDefaultedFunctionKind(x, fd))
end

dispose(x::DefaultedFunctionKind) = clang_DefaultedFunctionKind_dispose(x)

"""
    isSpecialMember(x::AbstractDefaultedFunctionKind) -> Bool
Return whether the classified function is a C++ special member.
"""
function isSpecialMember(x::AbstractDefaultedFunctionKind)
    @check_ptrs x
    return clang_DefaultedFunctionKind_isSpecialMember(x)
end

"""
    isComparison(x::AbstractDefaultedFunctionKind) -> Bool
Return whether the classified function is a defaultable comparison operator.
"""
function isComparison(x::AbstractDefaultedFunctionKind)
    @check_ptrs x
    return clang_DefaultedFunctionKind_isComparison(x)
end

"""
    asSpecialMember(x::AbstractDefaultedFunctionKind) -> CXCXXSpecialMember
Return which special member the classified function is, or
`CXCXXSpecialMember_CXXInvalid` when it is not one.
"""
function asSpecialMember(x::AbstractDefaultedFunctionKind)
    @check_ptrs x
    return clang_DefaultedFunctionKind_asSpecialMember(x)
end

"""
    asComparison(x::AbstractDefaultedFunctionKind) -> CXDefaultedComparisonKind
Return which defaultable comparison the classified function is, or
`CXDefaultedComparisonKind_None` when it is not one.
"""
function asComparison(x::AbstractDefaultedFunctionKind)
    @check_ptrs x
    return clang_DefaultedFunctionKind_asComparison(x)
end

"""
    getDiagnosticIndex(x::AbstractDefaultedFunctionKind) -> UInt32
Return the index clang's own diagnostic tables use for this kind: the special-member value
plus the comparison value, at most one of which is ever non-default.
"""
function getDiagnosticIndex(x::AbstractDefaultedFunctionKind)
    @check_ptrs x
    return clang_DefaultedFunctionKind_getDiagnosticIndex(x)
end

"""
    SFINAETrap(x::AbstractSema, access_checking_sfinae::Bool=false) -> SFINAETrap
Open a SFINAE trap over `x` and return the RAII sentinel that owns it. This function
allocates and one should call `dispose` to release the resources after using this object;
disposing it is what closes the trap, so nested traps must be disposed in reverse
construction order.

While a trap is live Sema is a SFINAE context, so a SFINAE-able error is counted instead of
emitted. That is what makes the `Subst*` family safe to drive outside a parse: without a
trap a substitution failure reaches clang's diagnostic renderer, which crashes on
synthesised locations. Ask [`hasErrorOccurred`](@ref) afterwards to learn whether anything
was trapped. Pass `access_checking_sfinae` to have access-control failures trapped too.
"""
function SFINAETrap(x::AbstractSema, access_checking_sfinae::Bool=false)
    @check_ptrs x
    return SFINAETrap(clang_SFINAETrap_create(x, access_checking_sfinae))
end

dispose(x::SFINAETrap) = clang_SFINAETrap_dispose(x)

"""
    hasErrorOccurred(x::AbstractSFINAETrap) -> Bool
Return whether any SFINAE error has been trapped since this trap was constructed. It is
always `false` on a freshly built trap, which records the counter it compares against.
"""
function hasErrorOccurred(x::AbstractSFINAETrap)
    @check_ptrs x
    return clang_SFINAETrap_hasErrorOccurred(x)
end

"""
    getUndefinedButUsed(x::AbstractSema) -> Vector{Tuple{NamedDecl,SourceLocation}}
Return the declarations that were odr-used in this translation unit but never defined in it,
each paired with the location clang recorded the use at.

The list is rebuilt from Sema's own map on every call, so it grows as more of the translation
unit is parsed and loses an entry once a definition arrives. Only declarations that could not
be defined in another translation unit are tracked, so an ordinary `extern` declaration never
appears here.
"""
function getUndefinedButUsed(x::AbstractSema)
    @check_ptrs x
    n = Int(clang_Sema_getUndefinedButUsed(x, CXNamedDecl[], CXSourceLocation_[], 0))
    n == 0 && return Tuple{NamedDecl,SourceLocation}[]
    decls = Vector{CXNamedDecl}(undef, n)
    locs = Vector{CXSourceLocation_}(undef, n)
    got = min(Int(clang_Sema_getUndefinedButUsed(x, decls, locs, n)), n)
    return [(NamedDecl(decls[i]), SourceLocation(locs[i])) for i = 1:got]
end

"""
    canCalleeThrow(x::AbstractSema, e, d, loc::SourceLocation) -> CXCanThrowResult
Return whether the callee of a call can throw: `CT_Cannot`, `CT_Can`, or `CT_Dependent` when
the answer depends on template arguments.

`e` is the callee expression and `d` the callee declaration; clang documents both as optional
and tests them for null itself, so either may be left out. `clang::Sema` declares this static,
so the Sema receiver is only there to reach the language options.
"""
function canCalleeThrow(x::AbstractSema, e::Union{Nothing,AbstractExpr}, d::Union{Nothing,AbstractDecl}, loc::SourceLocation)
    @check_ptrs x
    return clang_Sema_canCalleeThrow(x, e === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, e), d === nothing ? CXDecl(C_NULL) : Base.unsafe_convert(CXDecl, d), loc)
end

"""
    getTemplateNameKindForDiagnostics(x::AbstractSema, name::TemplateName) -> CXTemplateNameKindForDiagnostics
Return the detailed kind of the template `name`, the way clang's diagnostics classify it. A
name that resolves to no declaration at all is reported as `DependentTemplate`.
"""
function getTemplateNameKindForDiagnostics(x::AbstractSema, name::TemplateName)
    @check_ptrs x name
    return clang_Sema_getTemplateNameKindForDiagnostics(x, name)
end

"""
    getNonTagTypeDeclKind(x::AbstractSema, d::AbstractDecl, tag_kind::CXTagTypeKind) -> CXNonTagKind
Return how `d` introduces a type name without a tag — the classification clang uses in the
diagnostic that rejects it where a tag was written. `tag_kind` is the tag keyword the caller
wrote and selects the answer for a `d` that is none of the alias or template forms.
"""
function getNonTagTypeDeclKind(x::AbstractSema, d::AbstractDecl, tag_kind::CXTagTypeKind)
    @check_ptrs x d
    return clang_Sema_getNonTagTypeDeclKind(x, d, tag_kind)
end

"""
    getSelfAssignmentClassMemberCandidate(x::AbstractSema, self_assigned::AbstractValueDecl) -> FieldDecl
Return the field of the enclosing class whose name matches `self_assigned` — the candidate
clang's self-assignment warning points at. The carrier is NULL unless Sema's current context is
a C++ method whose class has such a field.
"""
function getSelfAssignmentClassMemberCandidate(x::AbstractSema, self_assigned::AbstractValueDecl)
    @check_ptrs x self_assigned
    return FieldDecl(clang_Sema_getSelfAssignmentClassMemberCandidate(x, self_assigned))
end

"""
    CanUseDecl(x::AbstractSema, d::AbstractNamedDecl, treat_unavailable_as_invalid::Bool=true) -> Bool
Return whether `d` may be referenced at all: `false` for a deleted function, for a variable
whose `auto` type is still being deduced, and for an `UnresolvedUsingIfExistsDecl`.
`treat_unavailable_as_invalid` additionally rejects an unavailable aligned allocation function.

This is the non-diagnosing half of clang's use check, so it emits nothing whatever the answer.
"""
function CanUseDecl(x::AbstractSema, d::AbstractNamedDecl, treat_unavailable_as_invalid::Bool=true)
    @check_ptrs x d
    return clang_Sema_CanUseDecl(x, d, treat_unavailable_as_invalid)
end

"""
    ShouldSplatAltivecScalarInCast(x::AbstractSema, vec_ty::AbstractVectorType) -> Bool
Return whether a scalar initializing `vec_ty` is splatted across every element rather than
stored into element zero. True for an AltiVecVector vector, and for AltiVecBool and
AltiVecPixel when `-faltivec-src-compat=xl` is in effect.
"""
function ShouldSplatAltivecScalarInCast(x::AbstractSema, vec_ty::AbstractVectorType)
    @check_ptrs x vec_ty
    return clang_Sema_ShouldSplatAltivecScalarInCast(x, vec_ty)
end

"""
    IsInvalidSMECallConversion(x::AbstractSema, from::AbstractQualType, to::AbstractQualType) -> Bool
Return whether converting `from` to `to` is ill-formed because the two disagree on their
AArch64 SME function attributes.

Both types must be prototyped function types: the attributes live on a `FunctionProtoType` and
the query has nothing to say about any other type.
"""
function IsInvalidSMECallConversion(x::AbstractSema, from::AbstractQualType, to::AbstractQualType)
    @check_ptrs x from to
    @assert isFunctionProtoType(getTypePtr(from)) "the source type must be a function prototype"
    @assert isFunctionProtoType(getTypePtr(to)) "the destination type must be a function prototype"
    return clang_Sema_IsInvalidSMECallConversion(x, from, to)
end

"""
    hasAnyAcceptableTemplateNames(x::AbstractSema, r::AbstractLookupResult;
                                  allow_function_templates=true, allow_dependent=true,
                                  allow_non_template_functions=false) -> Bool
Return whether any declaration in `r` can be read as a template name. Unlike
[`FilterAcceptableTemplateNames`](@ref) this leaves `r` alone.
"""
function hasAnyAcceptableTemplateNames(x::AbstractSema, r::AbstractLookupResult; allow_function_templates::Bool=true, allow_dependent::Bool=true, allow_non_template_functions::Bool=false)
    @check_ptrs x r
    return clang_Sema_hasAnyAcceptableTemplateNames(x, r, allow_function_templates, allow_dependent, allow_non_template_functions)
end

"""
    getReturnTypeLoc(x::AbstractSema, fd::AbstractFunctionDecl) -> TypeLoc
Return the `TypeLoc` of `fd`'s written return type. This function allocates and one should call
`dispose` to release the resources after using this object.

`fd` must carry a `TypeSourceInfo` and its written type must be a function prototype: clang
reaches the return location through an unchecked cast of that `TypeLoc`, so an implicit
declaration or an unprototyped one is undefined behaviour rather than an empty result.
"""
function getReturnTypeLoc(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    @assert getTypeSourceInfo(fd).ptr != C_NULL "the function must carry a TypeSourceInfo"
    @assert isFunctionProtoType(getTypePtr(getType(fd))) "the written type must be a function prototype"
    return TypeLoc(clang_Sema_getReturnTypeLoc(x, fd))
end

"""
    getMoreSpecializedPartialSpecialization(x::AbstractSema,
                                           ps1::AbstractClassTemplatePartialSpecializationDecl,
                                           ps2::AbstractClassTemplatePartialSpecializationDecl,
                                           loc::SourceLocation) -> ClassTemplatePartialSpecializationDecl
Return whichever of `ps1` and `ps2` is the more specialized, or a NULL carrier when neither is.
Both must be partial specializations of the same class template; `loc` is the location the
partial ordering is performed at.
"""
function getMoreSpecializedPartialSpecialization(x::AbstractSema, ps1::AbstractClassTemplatePartialSpecializationDecl, ps2::AbstractClassTemplatePartialSpecializationDecl, loc::SourceLocation)
    @check_ptrs x ps1 ps2
    return ClassTemplatePartialSpecializationDecl(clang_Sema_getMoreSpecializedPartialSpecialization(x, ps1, ps2, loc))
end

"""
    isMoreSpecializedThanPrimary(x::AbstractSema,
                                 t::AbstractClassTemplatePartialSpecializationDecl,
                                 info::AbstractTemplateDeductionInfo) -> Bool
Return whether the partial specialization `t` is more specialized than the primary template it
specializes — the well-formedness rule every partial specialization has to satisfy. `info`
records the deduction failure when the answer is `false`.
"""
function isMoreSpecializedThanPrimary(x::AbstractSema, t::AbstractClassTemplatePartialSpecializationDecl, info::AbstractTemplateDeductionInfo)
    @check_ptrs x t info
    return clang_Sema_isMoreSpecializedThanPrimary(x, t, info)
end

"""
    isInOpenMPDeclareVariantScope(x::AbstractSema) -> Bool
Return whether an `omp begin/end declare variant` scope is currently open.
"""
function isInOpenMPDeclareVariantScope(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isInOpenMPDeclareVariantScope(x)
end

"""
    isInOpenMPDeclareTargetContext(x::AbstractSema) -> Bool
Return whether an OpenMP declare target region is currently open.
"""
function isInOpenMPDeclareTargetContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_isInOpenMPDeclareTargetContext(x)
end

"""
    getNullabilityKeyword(x::AbstractSema, nullability::CXNullabilityKind) -> IdentifierInfo
Return the identifier spelling the nullability qualifier `nullability` (`_Nonnull` and
friends). The identifier is interned on first use.
"""
function getNullabilityKeyword(x::AbstractSema, nullability::CXNullabilityKind)
    @check_ptrs x
    return IdentifierInfo(clang_Sema_getNullabilityKeyword(x, nullability))
end

"""
    isCFError(x::AbstractSema, d::AbstractRecordDecl) -> Bool
Return whether `d` is the record `CFErrorRef` points at, which clang identifies from its bridge
to `NSError`.
"""
function isCFError(x::AbstractSema, d::AbstractRecordDecl)
    @check_ptrs x d
    return clang_Sema_isCFError(x, d)
end

"""
    CreateBuiltin(x::AbstractSema, ii, ty, id, loc) -> FunctionDecl
Create the implicit declaration of the builtin `id` under the name `ii` with the function
type `ty`, parented to the translation unit — behind an implicit `extern "C"` block in C++.

`id` is a `clang::Builtin::ID`; pass `0` (`Builtin::NotBuiltin`) to declare an ordinary
implicit function. `ty` must be a function type, since `clang::FunctionDecl::Create` stores
it unchecked and the parameters are built from it, so a prototype gives the declaration its
`ParmVarDecl`s. The declaration is `ASTContext` arena memory.
"""
function CreateBuiltin(x::AbstractSema, ii::AbstractIdentifierInfo, ty::AbstractQualType, id::Integer, loc::SourceLocation)
    @check_ptrs x ii ty
    @assert isFunctionType(getTypePtr(ty)) "a builtin declaration needs a function type"
    return FunctionDecl(clang_Sema_CreateBuiltin(x, ii, ty, id, loc))
end

"""
    CreateCapturedStmtRecordDecl(x::AbstractSema, loc, num_params) -> (RecordDecl, CapturedDecl)
Create the closure record a captured statement needs together with its `CapturedDecl`, both
added to the nearest enclosing function, record or file context.

The record is implicit, marked as a captured record, and left in the started-but-unfinished
state clang leaves it in; `num_params` sizes the `CapturedDecl`'s parameter array. Requires
[`getCurLexicalContext`](@ref) to be non-null — clang walks up from `CurContext` without a
null check.
"""
function CreateCapturedStmtRecordDecl(x::AbstractSema, loc::SourceLocation, num_params::Integer)
    @check_ptrs x
    @assert getCurLexicalContext(x).ptr != C_NULL "Sema has no current declaration context"
    cd = Ref{CXCapturedDecl}(C_NULL)
    rd = clang_Sema_CreateCapturedStmtRecordDecl(x, cd, loc, num_params)
    return RecordDecl(rd), CapturedDecl(cd[])
end

"""
    BuildStmtExpr(x::AbstractSema, lparen_loc, sub_stmt, rparen_loc, template_depth=0)
Build the GNU statement expression `({ ... })` whose body is `sub_stmt`.

The receiver of the body is typed at `AbstractCompoundStmt` because
`clang::Sema::BuildStmtExpr` asserts its operand is a compound statement. Requires
[`hasCurFunction`](@ref): clang reads the current function scope to propagate the body's
error state and its branch-protected scope, and that stack is empty between parses. Return
`nothing` when Sema rejected the body.
"""
function BuildStmtExpr(x::AbstractSema, lparen_loc::SourceLocation, sub_stmt::AbstractCompoundStmt, rparen_loc::SourceLocation, template_depth::Integer=0)
    @check_ptrs x sub_stmt
    @assert hasCurFunction(x) "a statement expression needs a current function scope"
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildStmtExpr(x, lparen_loc, sub_stmt, rparen_loc, template_depth, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildMSDependentExistsStmt(x::AbstractSema, keyword_loc, is_if_exists, qualifier_loc, name_info, nested)
Build the `__if_exists` / `__if_not_exists` statement guarding `nested` on whether
`qualifier_loc`-qualified `name_info` names anything.

`is_if_exists` selects `__if_exists` over `__if_not_exists`. No name lookup happens here —
that is the parser callback's job — so a dependent qualifier is the point of this form.
`nested` is typed at `AbstractCompoundStmt` because clang casts it to one. Both value boxes
are read, not adopted, and remain the caller's to `dispose`. Return `nothing` when Sema
rejected the statement.
"""
function BuildMSDependentExistsStmt(x::AbstractSema, keyword_loc::SourceLocation, is_if_exists::Bool, qualifier_loc::AbstractNestedNameSpecifierLoc, name_info::AbstractDeclarationNameInfo, nested::AbstractCompoundStmt)
    @check_ptrs x qualifier_loc name_info nested
    invalid = Ref{Bool}(false)
    s = clang_Sema_BuildMSDependentExistsStmt(x, keyword_loc, is_if_exists, qualifier_loc, name_info, nested, invalid)
    return invalid[] ? nothing : Stmt(s)
end

"""
    BuildStdInitializerList(x::AbstractSema, element, loc) -> QualType
Instantiate `std::initializer_list<element>` and return its written form, which is sugared
through an `ElaboratedType`.

Requires a declaration of namespace `std` to have been seen, i.e. [`getStdNamespace`](@ref)
non-null, which is the precondition this wrapper asserts. The remaining failure mode is a
missing or malformed `std::initializer_list`: clang then diagnoses at `loc` and the result
is a null `QualType`. [`isStdInitializerList`](@ref) recognises the built type again.
"""
function BuildStdInitializerList(x::AbstractSema, element::AbstractQualType, loc::SourceLocation)
    @check_ptrs x element
    @assert getStdNamespace(x).ptr != C_NULL "namespace std has not been declared"
    return QualType(clang_Sema_BuildStdInitializerList(x, element, loc))
end

"""
    BuildUsingPackDecl(x::AbstractSema, instantiated_from, expansions) -> NamedDecl
Build the pack of using-declarations `expansions` that the pack expansion
`instantiated_from` expanded to, and add it to Sema's current declaration context with
`instantiated_from`'s access.

The carrier is the declared return type, `NamedDecl`; the node clang builds is a
`UsingPackDecl`, so refine with the checked cast `UsingPackDecl(d)`, which asks clang and
raises `CastError` if the node is anything else.
Requires [`getCurLexicalContext`](@ref) to be non-null — the new declaration is added to it
without a null check. The expansions are copied into the node's trailing storage, so the
vector need not outlive the call.
"""
function BuildUsingPackDecl(x::AbstractSema, instantiated_from::AbstractNamedDecl, expansions::AbstractVector{<:AbstractNamedDecl})
    @check_ptrs x instantiated_from
    @assert getCurLexicalContext(x).ptr != C_NULL "Sema has no current declaration context"
    @assert all(d -> d.ptr != C_NULL, expansions) "expansion list holds no null slot"
    ptrs = CXNamedDecl[Base.unsafe_convert(CXNamedDecl, d) for d in expansions]
    return NamedDecl(clang_Sema_BuildUsingPackDecl(x, instantiated_from, ptrs, length(ptrs)))
end

"""
    BuildCXXFoldExpr(x::AbstractSema, callee, lparen_loc, lhs, op, ellipsis_loc, rhs, rparen_loc, num_expansions=nothing)
Build the C++17 fold expression `(lhs op ... op rhs)`, the non-empty counterpart of
[`BuildEmptyCXXFoldExpr`](@ref).

A unary fold leaves one side absent: pass a NULL-pointer `Expr_` for it. `callee` is the
unresolved lookup of the operator and may likewise be a NULL-pointer carrier.
`num_expansions` is the pack's length once it is known and `nothing` while it is not.
Nothing about the operands is checked here — that is the parser callback's job — and the
node gets the `ASTContext`'s dependent type. Return `nothing` when Sema rejected the fold.
"""
function BuildCXXFoldExpr(x::AbstractSema, callee::AbstractUnresolvedLookupExpr, lparen_loc::SourceLocation, lhs::AbstractExpr, op::CXBinaryOperatorKind, ellipsis_loc::SourceLocation, rhs::AbstractExpr, rparen_loc::SourceLocation, num_expansions::Union{Nothing,Integer}=nothing)
    @check_ptrs x
    has_n = num_expansions !== nothing
    invalid = Ref{Bool}(false)
    e = clang_Sema_BuildCXXFoldExpr(x, callee, lparen_loc, lhs, op, ellipsis_loc, rhs, rparen_loc, has_n, has_n ? num_expansions : 0, invalid)
    return invalid[] ? nothing : Expr_(e)
end

"""
    BuildCXXThisExpr(x::AbstractSema, loc, ty, is_implicit) -> Expr_
Build the `this` expression of type `ty` and mark it referenced, capturing `this` into any
enclosing lambda that needs it.

Requires a `this` to exist — [`getCurrentThisType`](@ref) must be non-null — because clang
diagnoses a `this` capture it cannot perform, and rendering that diagnostic outside a parse
is the crash [`BuildPredefinedExpr`](@ref) documents.
"""
function BuildCXXThisExpr(x::AbstractSema, loc::SourceLocation, ty::AbstractQualType, is_implicit::Bool)
    @check_ptrs x ty
    @assert getCurrentThisType(x).ptr != C_NULL "there is no `this` in the current context"
    return Expr_(clang_Sema_BuildCXXThisExpr(x, loc, ty, is_implicit))
end

"""
    CheckArgsForPlaceholders(x::AbstractSema, args::AbstractVector{<:AbstractExpr}) -> Tuple{Bool,Vector{Expr_}}
Check an argument list for placeholder types clang will not handle later, returning whether
any argument could not be converted together with the argument list after the conversions.

An argument that carries no placeholder type comes back unchanged; a failure is diagnosed at
the argument that caused it.
"""
function CheckArgsForPlaceholders(x::AbstractSema, args::AbstractVector{<:AbstractExpr})
    @check_ptrs x
    @assert all(a -> a.ptr != C_NULL, args) "every argument must be non-NULL"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    failed = clang_Sema_CheckArgsForPlaceholders(x, buf, length(buf))
    return failed, Expr_[Expr_(p) for p in buf]
end

"""
    CheckEnableIf(x::AbstractSema, func::AbstractFunctionDecl, call_loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, missing_implicit_this::Bool=false) -> Union{Nothing,EnableIfAttr}
Evaluate the `enable_if` attributes on `func` against the argument list `args` and return the
first attribute whose condition fails.

Returns `nothing` when every condition succeeds, which is also what a function carrying no
`enable_if` attribute reports. `missing_implicit_this` says `args` leaves the implicit object
argument out.
"""
function CheckEnableIf(x::AbstractSema, func::AbstractFunctionDecl, call_loc::SourceLocation, args::AbstractVector{<:AbstractExpr}, missing_implicit_this::Bool=false)
    @check_ptrs x func
    @assert all(a -> a.ptr != C_NULL, args) "every argument must be non-NULL"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    p = clang_Sema_CheckEnableIf(x, func, call_loc, buf, length(buf), missing_implicit_this)
    p == C_NULL && return nothing
    # CheckEnableIf answers with the enable_if attribute that failed, typed at the base
    return unchecked_cast(EnableIfAttr, p)
end

"""
    CheckAlignasTypeArgument(x::AbstractSema, kw_name::AbstractString, t_info::AbstractTypeSourceInfo, op_loc::SourceLocation, rng::SourceRange) -> Bool
Return whether the type `t_info` designates is *not* a valid operand for the alignment
operator spelled `kw_name` — an incomplete or function type is the usual rejection, which is
diagnosed at `op_loc` over `rng`.
"""
function CheckAlignasTypeArgument(x::AbstractSema, kw_name::AbstractString, t_info::AbstractTypeSourceInfo, op_loc::SourceLocation, rng::SourceRange)
    @check_ptrs x t_info
    return clang_Sema_CheckAlignasTypeArgument(x, kw_name, t_info, op_loc, getBeginLoc(rng), getEndLoc(rng))
end

"""
    CheckCXXThrowOperand(x::AbstractSema, throw_loc::SourceLocation, throw_ty::QualType, e::AbstractExpr) -> Bool
Return whether `throw_ty` cannot be the type of an exception object thrown from `e` — an
incomplete or abstract class type, or one whose copy constructor or destructor is not usable,
is the rejection, which is diagnosed at `throw_loc`.

For a class type this marks the copy constructor and the destructor referenced, exactly as
building a real `throw` expression would.
"""
function CheckCXXThrowOperand(x::AbstractSema, throw_loc::SourceLocation, throw_ty::QualType, e::AbstractExpr)
    @check_ptrs x throw_ty e
    return clang_Sema_CheckCXXThrowOperand(x, throw_loc, throw_ty, e)
end

"""
    CheckMemberAccess(x::AbstractSema, use_loc::SourceLocation, naming_class::AbstractCXXRecordDecl, found::AbstractNamedDecl, found_access::CXAccessSpecifier) -> CXAccessResult
Return whether the member `found`, named through `naming_class` with path access
`found_access`, is accessible from Sema's current context. An inaccessible member is
diagnosed at `use_loc`.

`found` and `found_access` are the two components of the `DeclAccessPair` clang takes; a
public member is reported accessible without any base-path walk.
"""
function CheckMemberAccess(x::AbstractSema, use_loc::SourceLocation, naming_class::AbstractCXXRecordDecl, found::AbstractNamedDecl, found_access::CXAccessSpecifier)
    @check_ptrs x naming_class found
    return clang_Sema_CheckMemberAccess(x, use_loc, naming_class, found, found_access)
end

"""
    CheckStructuredBindingMemberAccess(x::AbstractSema, use_loc::SourceLocation, decomposed_class::AbstractCXXRecordDecl, field::AbstractNamedDecl, field_access::CXAccessSpecifier) -> CXAccessResult
Return whether `field`, reached by decomposing `decomposed_class` in a structured binding, is
accessible from Sema's current context. Only the diagnostic differs from
[`CheckMemberAccess`](@ref).
"""
function CheckStructuredBindingMemberAccess(x::AbstractSema, use_loc::SourceLocation, decomposed_class::AbstractCXXRecordDecl, field::AbstractNamedDecl, field_access::CXAccessSpecifier)
    @check_ptrs x decomposed_class field
    return clang_Sema_CheckStructuredBindingMemberAccess(x, use_loc, decomposed_class, field, field_access)
end

"""
    CheckConditionalOperands(x::AbstractSema, cond, lhs, rhs, question_loc::SourceLocation) -> Union{Nothing,Tuple{QualType,Expr_,Expr_,Expr_,CXExprValueKind,CXExprObjectKind}}
Type-check the operands of `cond ? lhs : rhs`, returning the result type, the three converted
operands and the value and object kind of the result.

clang dispatches to the C++ rules from inside this entry point when the language mode is C++.
Returns `nothing` when the operands are ill-formed, which is diagnosed at `question_loc`.
"""
function CheckConditionalOperands(x::AbstractSema, cond::AbstractExpr, lhs::AbstractExpr, rhs::AbstractExpr, question_loc::SourceLocation)
    @check_ptrs x cond lhs rhs
    cond_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, cond))
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    vk = Ref{CXExprValueKind}(CXExprValueKind_VK_PRValue)
    ok = Ref{CXExprObjectKind}(CXExprObjectKind_OK_Ordinary)
    t = clang_Sema_CheckConditionalOperands(x, cond_io, lhs_io, rhs_io, vk, ok, question_loc)
    (t == C_NULL || cond_io[] == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(cond_io[]), Expr_(lhs_io[]), Expr_(rhs_io[]), vk[], ok[]
end

"""
    CXXCheckConditionalOperands(x::AbstractSema, cond, lhs, rhs, question_loc::SourceLocation) -> Union{Nothing,Tuple{QualType,Expr_,Expr_,Expr_,CXExprValueKind,CXExprObjectKind}}
Type-check the operands of `cond ? lhs : rhs` under the C++ rules, reached unconditionally
rather than through the language-mode dispatch inside [`CheckConditionalOperands`](@ref).

Returns `nothing` when the operands are ill-formed, which is diagnosed at `question_loc`.
"""
function CXXCheckConditionalOperands(x::AbstractSema, cond::AbstractExpr, lhs::AbstractExpr, rhs::AbstractExpr, question_loc::SourceLocation)
    @check_ptrs x cond lhs rhs
    cond_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, cond))
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    vk = Ref{CXExprValueKind}(CXExprValueKind_VK_PRValue)
    ok = Ref{CXExprObjectKind}(CXExprObjectKind_OK_Ordinary)
    t = clang_Sema_CXXCheckConditionalOperands(x, cond_io, lhs_io, rhs_io, vk, ok, question_loc)
    (t == C_NULL || cond_io[] == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(cond_io[]), Expr_(lhs_io[]), Expr_(rhs_io[]), vk[], ok[]
end

"""
    CheckVectorConditionalTypes(x::AbstractSema, cond, lhs, rhs, question_loc::SourceLocation) -> Union{Nothing,Tuple{QualType,Expr_,Expr_,Expr_}}
Type-check the operands of the vector form of `cond ? lhs : rhs`, returning the result type
and the three converted operands.

`cond` must have vector type — clang reaches its element type through an unchecked
`castAs<VectorType>`, so the wrapper rejects anything else first. Returns `nothing` when the
operands are ill-formed, which is diagnosed at `question_loc`.
"""
function CheckVectorConditionalTypes(x::AbstractSema, cond::AbstractExpr, lhs::AbstractExpr, rhs::AbstractExpr, question_loc::SourceLocation)
    @check_ptrs x cond lhs rhs
    @assert isVectorType(expr_type_ptr(cond)) "the condition must have vector type"
    cond_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, cond))
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckVectorConditionalTypes(x, cond_io, lhs_io, rhs_io, question_loc)
    (t == C_NULL || cond_io[] == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(cond_io[]), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckVectorOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, is_comp_assign::Bool=false, allow_both_bool::Bool=true, allow_bool_conversion::Bool=false, allow_bool_operation::Bool=false, report_invalid::Bool=false) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check a binary operator over vector operands, returning the result type and the two
converted operands. One side may be a scalar of the element type, so at least one operand must
have vector type.

The four policy flags are the ones clang's own callers pass per operator: `allow_both_bool`
admits two boolean vectors, `allow_bool_conversion` a conversion to a boolean vector,
`allow_bool_operation` the operation on boolean element types, and `report_invalid` selects
whether a rejection is diagnosed at `loc` or only reported by the `nothing` return.
"""
function CheckVectorOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, is_comp_assign::Bool=false, allow_both_bool::Bool=true, allow_bool_conversion::Bool=false, allow_bool_operation::Bool=false, report_invalid::Bool=false)
    @check_ptrs x lhs rhs
    vec = isVectorType(expr_type_ptr(lhs)) || isVectorType(expr_type_ptr(rhs))
    @assert vec "at least one operand must have vector type"
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckVectorOperands(x, lhs_io, rhs_io, loc, is_comp_assign, allow_both_bool, allow_bool_conversion, allow_bool_operation, report_invalid)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckVectorCompareOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation, opc::CXBinaryOperatorKind) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check a relational or equality operator over vector operands, returning the signed
integer vector type the comparison yields together with the two converted operands.

One side may be a scalar of the element type, so at least one operand must have vector type.
Returns `nothing` when the operands are ill-formed, which is diagnosed at `loc`.
"""
function CheckVectorCompareOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation, opc::CXBinaryOperatorKind)
    @check_ptrs x lhs rhs
    vec = isVectorType(expr_type_ptr(lhs)) || isVectorType(expr_type_ptr(rhs))
    @assert vec "at least one operand must have vector type"
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckVectorCompareOperands(x, lhs_io, rhs_io, loc, opc)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    CheckVectorLogicalOperands(x::AbstractSema, lhs, rhs, loc::SourceLocation) -> Union{Nothing,Tuple{QualType,Expr_,Expr_}}
Type-check `&&` or `||` over vector operands, returning the signed integer vector type the
operator yields together with the two converted operands.

One side may be a scalar of the element type, so at least one operand must have vector type.
Returns `nothing` when the operands are ill-formed, which is diagnosed at `loc`.
"""
function CheckVectorLogicalOperands(x::AbstractSema, lhs::AbstractExpr, rhs::AbstractExpr, loc::SourceLocation)
    @check_ptrs x lhs rhs
    vec = isVectorType(expr_type_ptr(lhs)) || isVectorType(expr_type_ptr(rhs))
    @assert vec "at least one operand must have vector type"
    lhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, lhs))
    rhs_io = Ref{CXExpr}(Base.unsafe_convert(CXExpr, rhs))
    t = clang_Sema_CheckVectorLogicalOperands(x, lhs_io, rhs_io, loc)
    (t == C_NULL || lhs_io[] == C_NULL || rhs_io[] == C_NULL) && return nothing
    return QualType(t), Expr_(lhs_io[]), Expr_(rhs_io[])
end

"""
    SubstParmTypes(x::AbstractSema, loc::SourceLocation, params,
                   template_args) -> Union{Nothing,Tuple{Vector{QualType},Vector{ParmVarDecl}}}
Rebuild the parameter list `params` with `template_args` substituted into each parameter's
type, and return the substituted types alongside the parameters that carry them. Return
`nothing` when the substitution errored.

Pack expansions make the result longer than `params`. Clang's `ExtParameterInfo` input and
the builder it fills are not exposed: they only mean anything to a caller that goes on to
build a `FunctionProtoType`, which this API cannot do from them.

Each rebuilt parameter is recorded in the current scope, so this needs both a live
[`InstantiatingTemplate`](@ref) and a live [`LocalInstantiationScope`](@ref), and calling it
twice builds a second set of parameters.
"""
function SubstParmTypes(x::AbstractSema, loc::SourceLocation, params::AbstractVector{<:AbstractParmVarDecl}, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x template_args
    @assert all(p -> p.ptr != C_NULL, params) "every parameter must be non-NULL"
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasCurrentInstantiationScope(x) "rebuilding a parameter needs a live LocalInstantiationScope"
    in_buf = CXParmVarDecl[Base.unsafe_convert(CXParmVarDecl, p) for p in params]
    produced = Ref{Cuint}(0)
    types = Vector{CXQualType}(undef, length(in_buf))
    new_params = Vector{CXParmVarDecl}(undef, length(in_buf))
    clang_Sema_SubstParmTypes(x, loc, in_buf, length(in_buf), template_args, types, new_params, length(types), produced) && return nothing
    if produced[] > length(types)
        types = Vector{CXQualType}(undef, produced[])
        new_params = Vector{CXParmVarDecl}(undef, produced[])
        clang_Sema_SubstParmTypes(x, loc, in_buf, length(in_buf), template_args, types, new_params, length(types), produced) && return nothing
    end
    n = Int(produced[])
    return QualType[QualType(types[i]) for i = 1:n], ParmVarDecl[ParmVarDecl(new_params[i]) for i = 1:n]
end

"""
    SubstDefaultArgument(x::AbstractSema, loc::SourceLocation, param::AbstractParmVarDecl,
                         template_args, for_call_expr=false) -> Bool
Substitute `template_args` into `param`'s uninstantiated default argument and install the
result as its real default argument, so afterwards [`hasDefaultArg`](@ref) holds and
[`hasUninstantiatedDefaultArg`](@ref) does not. Return `true` on error, which is diagnosed.

`for_call_expr` checks the substituted expression as an argument of a call rather than as a
parameter initializer.

Clang reads the pattern through an accessor that asserts, and reaches the enclosing function
with an unchecked cast, so both are asserted here. Requires a live
[`InstantiatingTemplate`](@ref) and a `template_args` with at least one level, whose
innermost list names the record clang opens around the substitution.
"""
function SubstDefaultArgument(x::AbstractSema, loc::SourceLocation, param::AbstractParmVarDecl, template_args::AbstractMultiLevelTemplateArgumentList, for_call_expr::Bool=false)
    @check_ptrs x param template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert getNumLevels(template_args) > 0 "the argument list must have an innermost level"
    @assert hasUninstantiatedDefaultArg(param) "the parameter must carry an uninstantiated default argument"
    fd = getAsFunction(castFromDeclContext(getDeclContext(param)))
    @assert fd.ptr != C_NULL "the parameter must belong to a function"
    return clang_Sema_SubstDefaultArgument(x, loc, param, template_args, for_call_expr)
end

"""
    SubstTemplateArguments(x::AbstractSema, args, template_args,
                           outputs::TemplateArgumentListInfo) -> Bool
Substitute `template_args` into the written template arguments `args` and append the results
to `outputs`. Return `true` on error.

A pack expansion makes the number of entries appended differ from `length(args)`, and
whatever `outputs` already held is kept. Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstTemplateArguments(x::AbstractSema, args::AbstractVector{<:AbstractTemplateArgumentLoc}, template_args::AbstractMultiLevelTemplateArgumentList, outputs::TemplateArgumentListInfo)
    @check_ptrs x template_args outputs
    @assert all(a -> a.ptr != C_NULL, args) "every written template argument must be non-NULL"
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    in_buf = CXTemplateArgumentLoc[Base.unsafe_convert(CXTemplateArgumentLoc, a) for a in args]
    return clang_Sema_SubstTemplateArguments(x, in_buf, length(in_buf), template_args, outputs)
end

"""
    SubstBaseSpecifiers(x::AbstractSema, instantiation::AbstractCXXRecordDecl,
                        pattern::AbstractCXXRecordDecl, template_args) -> Bool
Substitute `template_args` into `pattern`'s base-specifier list and attach the result to
`instantiation`, which this *mutates*. Return `true` when a base failed to substitute or the
attached list was rejected, which is diagnosed.

A `pattern` with no bases is a total no-op. Clang walks `pattern`'s bases through
`CXXRecordDecl::data()` with no check, so a definition is a precondition and is asserted
here. Requires a live [`InstantiatingTemplate`](@ref).
"""
function SubstBaseSpecifiers(x::AbstractSema, instantiation::AbstractCXXRecordDecl, pattern::AbstractCXXRecordDecl, template_args::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x instantiation pattern template_args
    @assert getNumCodeSynthesisContexts(x) > 0 "substitution needs a live InstantiatingTemplate"
    @assert hasDefinition(pattern) "the pattern must have a definition"
    return clang_Sema_SubstBaseSpecifiers(x, instantiation, pattern, template_args)
end

"""
    AddMethodTemplateCandidate(x::AbstractSema, ftd::AbstractFunctionTemplateDecl,
                               found::AbstractNamedDecl, access::CXAccessSpecifier,
                               acting::AbstractCXXRecordDecl, object::AbstractExpr,
                               args::AbstractVector{<:AbstractExpr},
                               cs::AbstractOverloadCandidateSet; kwargs...)
Deduce the member function template `ftd` — found in `acting` as `found` with access
`access` — against `args` and add the resulting specialization as a candidate for a call on
the object expression `object`.

`ftd` must describe a member function, because clang casts the deduced specialization to
`CXXMethodDecl`, and `object` must designate an object of class type, because the implicit
object parameter's class is reached through an unchecked cast. As in
[`AddMethodCandidate`](@ref) both the object type and its value classification are read off
`object`, which is what a call site does. A deduction failure is recorded in the set as a
non-viable candidate rather than reported, so the set grows either way; pass
`explicit_template_args` to supply a written template argument list.
"""
function AddMethodTemplateCandidate(x::AbstractSema, ftd::AbstractFunctionTemplateDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, acting::AbstractCXXRecordDecl, object::AbstractExpr, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; explicit_template_args::Union{Nothing,AbstractTemplateArgumentListInfo}=nothing, suppress_user_conversions::Bool=false, partial_overloading::Bool=false, reversed::Bool=false)
    @check_ptrs x ftd found acting object cs
    @assert getDeclKindName(getTemplatedDecl(ftd)) in ("CXXMethod", "CXXConstructor", "CXXConversion") "the template must describe a member function"
    oty = expr_type_ptr(object)
    isPointerType(oty) && (oty = getTypePtr(getPointeeType(oty)))
    @assert isRecordType(oty) "the object expression must designate an object of class type"
    tali = explicit_template_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_template_args)
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddMethodTemplateCandidate(x, ftd, found, access, acting, tali, object, buf, length(buf), cs, suppress_user_conversions, partial_overloading, reversed)
end

"""
    AddConversionCandidate(x::AbstractSema, conv::AbstractCXXConversionDecl,
                           found::AbstractNamedDecl, access::CXAccessSpecifier,
                           acting::AbstractCXXRecordDecl, from::AbstractExpr, to::QualType,
                           cs::AbstractOverloadCandidateSet; kwargs...)
Add the conversion function `conv` — found in `acting` as `found` with access `access` — as
a candidate for converting `from` to `to`.

`conv` must not be the pattern of a conversion function template; clang asserts on that and
wants [`AddTemplateConversionCandidate`](@ref) instead. `from` must designate an object of
class type, or a pointer to one, because clang reaches the implicit object parameter's class
through an unchecked cast. The keyword arguments mirror clang's own:
`allow_objc_conversion_on_explicit`, `allow_explicit` and `allow_result_conversion`.
"""
function AddConversionCandidate(x::AbstractSema, conv::AbstractCXXConversionDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, acting::AbstractCXXRecordDecl, from::AbstractExpr, to::QualType, cs::AbstractOverloadCandidateSet; allow_objc_conversion_on_explicit::Bool=false, allow_explicit::Bool=true, allow_result_conversion::Bool=true)
    @check_ptrs x conv found acting from to cs
    @assert getDescribedFunctionTemplate(conv).ptr == C_NULL "a conversion function template pattern needs AddTemplateConversionCandidate"
    fty = expr_type_ptr(from)
    isPointerType(fty) && (fty = getTypePtr(getPointeeType(fty)))
    @assert isRecordType(fty) "the source expression must designate an object of class type"
    return clang_Sema_AddConversionCandidate(x, conv, found, access, acting, from, to, cs, allow_objc_conversion_on_explicit, allow_explicit, allow_result_conversion)
end

"""
    AddTemplateConversionCandidate(x::AbstractSema, ftd::AbstractFunctionTemplateDecl,
                                   found::AbstractNamedDecl, access::CXAccessSpecifier,
                                   acting::AbstractCXXRecordDecl, from::AbstractExpr,
                                   to::QualType, cs::AbstractOverloadCandidateSet;
                                   kwargs...)
Deduce the conversion function template `ftd` against `to` and add the resulting conversion
function through [`AddConversionCandidate`](@ref), whose precondition on `from` therefore
applies here too.

`ftd` must describe a conversion function. A deduction failure is recorded in the set as a
non-viable candidate rather than reported, so the set grows either way.
"""
function AddTemplateConversionCandidate(x::AbstractSema, ftd::AbstractFunctionTemplateDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, acting::AbstractCXXRecordDecl, from::AbstractExpr, to::QualType, cs::AbstractOverloadCandidateSet; allow_objc_conversion_on_explicit::Bool=false, allow_explicit::Bool=true, allow_result_conversion::Bool=true)
    @check_ptrs x ftd found acting from to cs
    @assert getDeclKindName(getTemplatedDecl(ftd)) == "CXXConversion" "the template must describe a conversion function"
    fty = expr_type_ptr(from)
    isPointerType(fty) && (fty = getTypePtr(getPointeeType(fty)))
    @assert isRecordType(fty) "the source expression must designate an object of class type"
    return clang_Sema_AddTemplateConversionCandidate(x, ftd, found, access, acting, from, to, cs, allow_objc_conversion_on_explicit, allow_explicit, allow_result_conversion)
end

"""
    AddSurrogateCandidate(x::AbstractSema, conv::AbstractCXXConversionDecl,
                          found::AbstractNamedDecl, access::CXAccessSpecifier,
                          acting::AbstractCXXRecordDecl, proto::AbstractFunctionProtoType,
                          object::AbstractExpr, args::AbstractVector{<:AbstractExpr},
                          cs::AbstractOverloadCandidateSet)
Add the surrogate candidate for calling `object` with `args` through the function pointer or
reference the conversion function `conv` yields; `proto` is the function prototype behind
that pointer.

The preconditions of [`AddConversionCandidate`](@ref) hold here as well: `conv` must not be
a conversion function template pattern, and `object` must designate an object of class type.
"""
function AddSurrogateCandidate(x::AbstractSema, conv::AbstractCXXConversionDecl, found::AbstractNamedDecl, access::CXAccessSpecifier, acting::AbstractCXXRecordDecl, proto::AbstractFunctionProtoType, object::AbstractExpr, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet)
    @check_ptrs x conv found acting proto object cs
    @assert getDescribedFunctionTemplate(conv).ptr == C_NULL "a conversion function template pattern has no surrogate form"
    oty = expr_type_ptr(object)
    isPointerType(oty) && (oty = getTypePtr(getPointeeType(oty)))
    @assert isRecordType(oty) "the object expression must designate an object of class type"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddSurrogateCandidate(x, conv, found, access, acting, proto, object, buf, length(buf), cs)
end

"""
    AddNonMemberOperatorCandidates(x::AbstractSema,
                                   fns::AbstractVector{<:AbstractNamedDecl},
                                   accesses::AbstractVector{CXAccessSpecifier},
                                   args::AbstractVector{<:AbstractExpr},
                                   cs::AbstractOverloadCandidateSet;
                                   explicit_template_args=nothing)
Add the non-member `operator` candidates an overload set contributes for a call with `args`.

`fns` and `accesses` are read in lockstep, so they must have the same length, and every
entry must name a function or a function template because clang casts each one
unconditionally. Pass `explicit_template_args` to supply a written template argument list.
"""
function AddNonMemberOperatorCandidates(x::AbstractSema, fns::AbstractVector{<:AbstractNamedDecl}, accesses::AbstractVector{CXAccessSpecifier}, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; explicit_template_args::Union{Nothing,AbstractTemplateArgumentListInfo}=nothing)
    @check_ptrs x cs
    @assert length(fns) == length(accesses) "fns and accesses must have the same length"
    @assert all(d -> getDeclKindName(d) in ("Function", "CXXMethod", "CXXConstructor", "CXXConversion", "CXXDeductionGuide", "FunctionTemplate", "UsingShadow"), fns) "every entry must name a function or a function template"
    fbuf = CXNamedDecl[Base.unsafe_convert(CXNamedDecl, d) for d in fns]
    abuf = collect(accesses)
    ebuf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    tali = explicit_template_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_template_args)
    return clang_Sema_AddNonMemberOperatorCandidates(x, fbuf, abuf, length(fbuf), ebuf, length(ebuf), cs, tali)
end

"""
    ResolveAddressOfOverloadedFunction(x::AbstractSema, e::AbstractExpr, target::QualType;
                                       complain::Bool=false)
        -> Union{Nothing,Tuple{FunctionDecl,NamedDecl,CXAccessSpecifier,Bool}}
The one function in the overload set `e` names whose type matches `target`, together with
the declaration that was found, the access it was found with, and whether more than one
candidate was considered — or `nothing` when the set does not resolve to exactly one.

`e` must name an overload set, i.e. carry the overload placeholder type; clang asserts on
anything else. `complain` reports the failure through Sema's `DiagnosticsEngine` and
defaults to `false`, which makes the call a pure query.
"""
function ResolveAddressOfOverloadedFunction(x::AbstractSema, e::AbstractExpr, target::QualType; complain::Bool=false)
    @check_ptrs x e target
    ety = expr_type_ptr(e)
    @assert isPlaceholderType(ety) && !isNonOverloadPlaceholderType(ety) "the expression must name an overload set"
    found = Ref{CXNamedDecl}(C_NULL)
    access = Ref{CXAccessSpecifier}(CXAccessSpecifier_AS_none)
    multiple = Ref{Bool}(false)
    p = clang_Sema_ResolveAddressOfOverloadedFunction(x, e, target, complain, found, access, multiple)
    p == C_NULL && return nothing
    return FunctionDecl(p), NamedDecl(found[]), access[], multiple[]
end

"""
    AddOverloadedCallCandidates(x::AbstractSema, ule::AbstractUnresolvedLookupExpr,
                                args::AbstractVector{<:AbstractExpr},
                                cs::AbstractOverloadCandidateSet;
                                partial_overloading::Bool=false)
Add every declaration the unresolved lookup `ule` names as a candidate for a call with
`args`.

A `ule` that requires argument-dependent lookup must carry no nested-name-specifier and come
from a C++ translation unit; clang re-checks both under an assertions build.
"""
function AddOverloadedCallCandidates(x::AbstractSema, ule::AbstractUnresolvedLookupExpr, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; partial_overloading::Bool=false)
    @check_ptrs x ule cs
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddOverloadedCallCandidates(x, ule, buf, length(buf), cs, partial_overloading)
end

"""
    AddOverloadedCallCandidates(x::AbstractSema, r::AbstractLookupResult,
                                args::AbstractVector{<:AbstractExpr},
                                cs::AbstractOverloadCandidateSet;
                                explicit_template_args=nothing)
The same collection driven from a lookup result rather than from an expression, with
`explicit_template_args` applied to every template among the results.

Every result must name a function or a function template, because clang casts each one
unconditionally.
"""
function AddOverloadedCallCandidates(x::AbstractSema, r::AbstractLookupResult, args::AbstractVector{<:AbstractExpr}, cs::AbstractOverloadCandidateSet; explicit_template_args::Union{Nothing,AbstractTemplateArgumentListInfo}=nothing)
    @check_ptrs x r cs
    @assert all(d -> getDeclKindName(d) in ("Function", "CXXMethod", "CXXConstructor", "CXXConversion", "CXXDeductionGuide", "FunctionTemplate", "UsingShadow"), getResults(r)) "every result must name a function or a function template"
    tali = explicit_template_args === nothing ? CXTemplateArgumentListInfo(C_NULL) : Base.unsafe_convert(CXTemplateArgumentListInfo, explicit_template_args)
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_Sema_AddOverloadedCallCandidatesWithLookupResult(x, r, tali, buf, length(buf), cs)
end

"""
    FindAssociatedClassesAndNamespaces(x::AbstractSema, loc::SourceLocation,
                                       args::AbstractVector{<:AbstractExpr})
        -> Tuple{Vector{DeclContext},Vector{CXXRecordDecl}}
The namespaces and classes argument-dependent lookup associates with `args`, as instantiated
at `loc`.

clang computes both sets in one walk that reads nothing but `args`, so the counting call and
the filling call this makes report the same sets in the same order. Fundamental types
associate nothing, so a call whose arguments are all built-in comes back empty.
"""
function FindAssociatedClassesAndNamespaces(x::AbstractSema, loc::SourceLocation, args::AbstractVector{<:AbstractExpr})
    @check_ptrs x
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    nns = Ref{Cuint}(0)
    ncs = Ref{Cuint}(0)
    clang_Sema_FindAssociatedClassesAndNamespaces(x, loc, buf, length(buf), Ptr{CXDeclContext}(C_NULL), 0, nns, Ptr{CXCXXRecordDecl}(C_NULL), 0, ncs)
    nsbuf = Vector{CXDeclContext}(undef, nns[])
    clsbuf = Vector{CXCXXRecordDecl}(undef, ncs[])
    clang_Sema_FindAssociatedClassesAndNamespaces(x, loc, buf, length(buf), nsbuf, nns[], nns, clsbuf, ncs[], ncs)
    return [DeclContext(p) for p in nsbuf], [CXXRecordDecl(p) for p in clsbuf]
end

"""
    CompleteConstructorCall(x::AbstractSema, ctor::AbstractCXXConstructorDecl,
                            init_type::QualType, args::AbstractVector{<:AbstractExpr},
                            loc::SourceLocation; allow_explicit::Bool=false,
                            list_initialization::Bool=false)
        -> Tuple{Bool,Vector{Expr_}}
Convert `args` to `ctor`'s parameter types, filling in default arguments, as a constructor
call initializing `init_type` would; return whether the call is ill-formed together with the
converted arguments.

An ill-formed call is reported through Sema's `DiagnosticsEngine`, and rendering a
diagnostic outside a parse is not safe, so only call this with arguments the constructor can
actually take. The output buffer is sized from `args` and `ctor`'s parameter count, which
bounds the result, so the conversion runs exactly once.
"""
function CompleteConstructorCall(x::AbstractSema, ctor::AbstractCXXConstructorDecl, init_type::QualType, args::AbstractVector{<:AbstractExpr}, loc::SourceLocation; allow_explicit::Bool=false, list_initialization::Bool=false)
    @check_ptrs x ctor init_type
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    cap = length(buf) + Int(getNumParams(ctor))
    out = Vector{CXExpr}(undef, cap)
    n = Ref{Cuint}(0)
    invalid = clang_Sema_CompleteConstructorCall(x, ctor, init_type, buf, length(buf), loc, out, cap, n, allow_explicit, list_initialization)
    return invalid, [Expr_(p) for p in view(out, 1:Int(n[]))]
end

"""
    GatherArgumentsForCall(x::AbstractSema, call_loc::SourceLocation,
                           fd::AbstractFunctionDecl, proto::AbstractFunctionProtoType,
                           first_param::Integer, args::AbstractVector{<:AbstractExpr};
                           kwargs...) -> Tuple{Bool,Vector{Expr_}}
Convert `args` to the parameter types `proto` declares, starting at parameter `first_param`
and filling in `fd`'s default arguments; return whether the call is ill-formed together with
the converted arguments.

`fd` is required rather than optional: clang asserts on a missing callee as soon as a
parameter needs its default argument. An ill-formed call is reported through Sema's
`DiagnosticsEngine`, with the same caveat as [`CompleteConstructorCall`](@ref). `call_type`
says which flavour of variadic call an argument passed through an ellipsis belongs to.
"""
function GatherArgumentsForCall(x::AbstractSema, call_loc::SourceLocation, fd::AbstractFunctionDecl, proto::AbstractFunctionProtoType, first_param::Integer, args::AbstractVector{<:AbstractExpr}; call_type::CXVariadicCallType=CXVariadicCallType_VariadicDoesNotApply, allow_explicit::Bool=false, list_initialization::Bool=false)
    @check_ptrs x fd proto
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    cap = length(buf) + Int(getNumParams(fd))
    out = Vector{CXExpr}(undef, cap)
    n = Ref{Cuint}(0)
    invalid = clang_Sema_GatherArgumentsForCall(x, call_loc, fd, proto, first_param, buf, length(buf), out, cap, n, call_type, allow_explicit, list_initialization)
    return invalid, [Expr_(p) for p in view(out, 1:Int(n[]))]
end

# --- External-source loads, cleanup wrapping and the remaining conversion helpers ---

"""
    LoadExternalWeakUndeclaredIdentifiers(x::AbstractSema)
Pull the `#pragma weak` identifiers recorded by an external AST source into Sema's own table.

A no-op when no external Sema source is attached, which is the case for an interpreter that
has loaded neither a precompiled header nor a module file.
"""
function LoadExternalWeakUndeclaredIdentifiers(x::AbstractSema)
    @check_ptrs x
    clang_Sema_LoadExternalWeakUndeclaredIdentifiers(x)
    return nothing
end

"""
    findFailedBooleanCondition(x::AbstractSema, cond::AbstractExpr) -> (Expr_, String)
Find the conjunct of the boolean constant expression `cond` that evaluated to false, and
describe it.

The first element is the blamed sub-expression and the second its pretty-printed spelling.
When no conjunct can be blamed — because every one of them held, or none of them is a
constant — clang falls back to `cond` itself, so the expression is never null.
"""
function findFailedBooleanCondition(x::AbstractSema, cond::AbstractExpr)
    @check_ptrs x cond
    failed = Ref{CXExpr}(C_NULL)
    desc = get_string(clang_Sema_findFailedBooleanCondition(x, cond, failed))
    return Expr_(failed[]), desc
end

"""
    shouldIgnoreInHostDeviceCheck(x::AbstractSema, callee::AbstractFunctionDecl) -> Bool
Return whether `callee` is discarded by the CUDA/HIP or OpenMP host/device split, and so
takes no part in the host/device call check.

Defined for an ordinary C++ translation unit too, where nothing is discarded.
"""
function shouldIgnoreInHostDeviceCheck(x::AbstractSema, callee::AbstractFunctionDecl)
    @check_ptrs x callee
    return clang_Sema_shouldIgnoreInHostDeviceCheck(x, callee)
end

"""
    adjustMemberFunctionCC(x::AbstractSema, ty::QualType, has_this_pointer::Bool,
                           is_ctor_or_dtor::Bool, loc::SourceLocation) -> QualType
Return `ty` carrying the calling convention a member function has in the target's ABI, when
`ty` does not name one explicitly.

`ty` must be a function type: `clang::Sema::adjustMemberFunctionCC` reaches the `FunctionType`
through an unchecked `castAs<>`. `loc` only locates the diagnostic clang emits when an
explicitly written convention cannot be honoured.
"""
function adjustMemberFunctionCC(x::AbstractSema, ty::QualType, has_this_pointer::Bool, is_ctor_or_dtor::Bool, loc::SourceLocation)
    @check_ptrs x ty
    @assert isFunctionType(getTypePtr(ty)) "the adjusted type must be a function type"
    return QualType(clang_Sema_adjustMemberFunctionCC(x, ty, has_this_pointer, is_ctor_or_dtor, loc))
end

"""
    HandleExprEvaluationContextForTypeof(x::AbstractSema, e::AbstractExpr)
        -> Union{Nothing,Expr_}
Prepare `e` to be the operand of a `typeof`/`decltype`.

A placeholder is resolved, and a variably-modified operand is transformed back to a
potentially-evaluated one; an operand that is neither comes back unchanged. Return `nothing`
when Sema rejected the expression.
"""
function HandleExprEvaluationContextForTypeof(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    invalid = Ref{Bool}(false)
    r = clang_Sema_HandleExprEvaluationContextForTypeof(x, e, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    tryConvertExprToType(x::AbstractSema, e::AbstractExpr, ty::QualType)
        -> Union{Nothing,Expr_}
Copy-initialize a temporary of type `ty` from `e` and return the converted expression.

Return `nothing` when no initialization sequence exists; clang checks the sequence before
performing it, so a rejected conversion is silent.
"""
function tryConvertExprToType(x::AbstractSema, e::AbstractExpr, ty::QualType)
    @check_ptrs x e ty
    invalid = Ref{Bool}(false)
    r = clang_Sema_tryConvertExprToType(x, e, ty, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    PrepareScalarCast(x::AbstractSema, src::AbstractExpr, dest_ty::QualType)
        -> (CXCastKind, Expr_)
Return the cast kind taking `src`'s type to `dest_ty`, together with the source expression
clang ended up with.

Both types must be scalar, and `src`'s type must not be a member-pointer type: clang asserts
the first and reaches an `llvm_unreachable` for the second. Some conversions rewrite the
operand — a complex-to-real conversion inserts a cast — so the second element is `src` itself
only when nothing was rewritten, and wraps `C_NULL` when the rewrite failed.
"""
function PrepareScalarCast(x::AbstractSema, src::AbstractExpr, dest_ty::QualType)
    @check_ptrs x src dest_ty
    src_ty = expr_type_ptr(src)
    @assert isScalarType(src_ty) "the source of a scalar cast must have scalar type"
    @assert isScalarType(getTypePtr(dest_ty)) "the destination of a scalar cast must be scalar"
    @assert !isMemberPointerType(src_ty) "clang handles no member-pointer source here"
    adjusted = Ref{CXExpr}(C_NULL)
    ck = clang_Sema_PrepareScalarCast(x, src, dest_ty, adjusted)
    return ck, Expr_(adjusted[])
end

"""
    MaybeCreateExprWithCleanups(x::AbstractSema, e::AbstractExpr) -> Expr_
Wrap `e` in an `ExprWithCleanups` when the full-expression under construction needs cleanups,
otherwise return `e` unchanged.
"""
function MaybeCreateExprWithCleanups(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    return Expr_(clang_Sema_MaybeCreateExprWithCleanups(x, e))
end

"""
    MaybeCreateStmtWithCleanups(x::AbstractSema, s::AbstractStmt) -> Stmt
The statement form of `MaybeCreateExprWithCleanups`: wrap `s` in a statement expression
carrying the pending cleanups, or return `s` unchanged when there are none.
"""
function MaybeCreateStmtWithCleanups(x::AbstractSema, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_Sema_MaybeCreateStmtWithCleanups(x, s))
end

"""
    LoadExternalVTableUses(x::AbstractSema)
Pull the vtable uses recorded by an external AST source into Sema's own set.

A no-op when no external Sema source is attached.
"""
function LoadExternalVTableUses(x::AbstractSema)
    @check_ptrs x
    clang_Sema_LoadExternalVTableUses(x)
    return nothing
end

"""
    EvaluateStaticAssertMessageAsString(x::AbstractSema, message::AbstractExpr,
                                        ctx::ASTContext,
                                        error_on_invalid_message::Bool=false)
        -> Union{Nothing,String}
Return the text of a `static_assert` message, or `nothing` when it could not be evaluated.

`message` must be a string literal, or an object of class type modelling the `size()`/`data()`
protocol of a user-generated message: every other operand is diagnosed at the message's own
location, which is the precondition asserted here. clang additionally asserts, in an
assertions-enabled build, that a string-literal message is an *unevaluated* string — which is
what the parser builds for `static_assert`.

An unevaluated string literal carries a null `QualType`, so the class-type arm of the
precondition may only read the type once the string-literal arm has been ruled out.
"""
function EvaluateStaticAssertMessageAsString(x::AbstractSema, message::AbstractExpr, ctx::ASTContext, error_on_invalid_message::Bool=false)
    @check_ptrs x message ctx
    ty = getType(message)
    @assert (resolve(message) isa StringLiteral || (!isNull(ty) && (isRecordType(getTypePtr(ty)) || isReferenceType(getTypePtr(ty))))) "a static_assert message is a string literal or a class object"
    ok = Ref{Bool}(false)
    s = get_string(clang_Sema_EvaluateStaticAssertMessageAsString(x, message, ctx, error_on_invalid_message, ok))
    return ok[] ? s : nothing
end

"""
    AreConstraintExpressionsEqual(x::AbstractSema, old_decl, old_constr::AbstractExpr,
                                  new_decl, new_constr::AbstractExpr) -> Bool
Return whether two constraint expressions are the same, ignoring a difference in template
depth.

`old_decl` and `new_decl` are the declarations the constraints were written on and are read
only to work out that relative depth; either may be `nothing`. `new_decl` crosses as the plain
declaration arm of `clang::Sema::TemplateCompareNewDeclInfo`.
"""
function AreConstraintExpressionsEqual(x::AbstractSema, old_decl::Union{Nothing,AbstractNamedDecl}, old_constr::AbstractExpr, new_decl::Union{Nothing,AbstractNamedDecl}, new_constr::AbstractExpr)
    @check_ptrs x old_constr new_constr
    od = old_decl === nothing ? CXNamedDecl(C_NULL) : Base.unsafe_convert(CXNamedDecl, old_decl)
    nd = new_decl === nothing ? CXNamedDecl(C_NULL) : Base.unsafe_convert(CXNamedDecl, new_decl)
    return clang_Sema_AreConstraintExpressionsEqual(x, od, old_constr, nd, new_constr)
end

"""
    ImpCastExprToType(x::AbstractSema, e::AbstractExpr, ty::QualType, ck::CXCastKind,
                      vk::CXExprValueKind=CXExprValueKind_VK_PRValue,
                      cck::CXCheckedConversionKind=CXCheckedConversionKind_CCK_ImplicitConversion)
        -> Union{Nothing,Expr_}
Insert an implicit cast of `e` to `ty`, merging into an implicit cast `e` already carries.

The base-class path is always empty here, so this builds no derived-to-base conversion; the
cast builders cover that. The two assertions restate clang's own: a prvalue result needs `e`
to be a prvalue already unless `ck` consumes an lvalue, and a glvalue result needs `e` not to
be a prvalue. Return `nothing` when Sema rejected the cast.
"""
function ImpCastExprToType(x::AbstractSema, e::AbstractExpr, ty::QualType, ck::CXCastKind, vk::CXExprValueKind=CXExprValueKind_VK_PRValue, cck::CXCheckedConversionKind=CXCheckedConversionKind_CCK_ImplicitConversion)
    @check_ptrs x e ty
    prv = isPRValue(e)
    @assert (vk != CXExprValueKind_VK_PRValue || prv || ck in (CXCastKind_CK_Dependent, CXCastKind_CK_LValueToRValue, CXCastKind_CK_ArrayToPointerDecay, CXCastKind_CK_FunctionToPointerDecay, CXCastKind_CK_ToVoid, CXCastKind_CK_NonAtomicToAtomic)) "this cast kind cannot consume an lvalue"
    @assert (vk == CXExprValueKind_VK_PRValue || ck == CXCastKind_CK_Dependent || !prv) "a prvalue operand cannot yield a glvalue cast"
    invalid = Ref{Bool}(false)
    r = clang_Sema_ImpCastExprToType(x, e, ty, ck, vk, cck, invalid)
    return invalid[] ? nothing : Expr_(r)
end

"""
    Clear(x::AbstractInstantiatingTemplate)
Pop the code-synthesis record this sentinel pushed, which is what `dispose` does through the
destructor. clang guards on its own flag, so calling this twice — and disposing an
already-cleared sentinel — leave [`getNumCodeSynthesisContexts`](@ref) at the value it had
before construction. A cleared sentinel is spent: no `Subst*` entry point may run under it
afterwards.
"""
function Clear(x::AbstractInstantiatingTemplate)
    @check_ptrs x
    clang_InstantiatingTemplate_Clear(x)
    return nothing
end

"""
    PushDeclContext(x::AbstractSema, sc::Scope, dc::AbstractDeclContext)
Enter `dc` as `Sema`'s current declaration context, remembering the one it replaces.

Pair every call with [`PopDeclContext`](@ref): the two maintain one stack, and the parse
state a later call sees is whatever the last unmatched push left behind.
"""
function PushDeclContext(x::AbstractSema, sc::Scope, dc::AbstractDeclContext)
    @check_ptrs x sc dc
    return clang_Sema_PushDeclContext(x, sc, dc)
end

"""
    PopDeclContext(x::AbstractSema)
Leave the current declaration context, restoring the one [`PushDeclContext`](@ref) saved.

The pop moves to the *containing* context, so the translation unit is the floor: popping
while it is current leaves `Sema` with no context at all rather than reporting an error.
That is the precondition asserted here.
"""
function PopDeclContext(x::AbstractSema)
    @check_ptrs x
    cur = getCurLexicalContext(x)
    @assert cur.ptr != C_NULL "Sema has no current declaration context"
    tu = castToDeclContext(getTranslationUnitDecl(getASTContext(x)))
    @assert cur.ptr != tu.ptr "the translation unit is the outermost context and cannot be popped"
    return clang_Sema_PopDeclContext(x)
end

"""
    PushFunctionScope(x::AbstractSema)
Push a bare function scope, the base every function body's scope-info stack is built on.
"""
function PushFunctionScope(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_PushFunctionScope(x)
end

"""
    PushBlockScope(x::AbstractSema, block_scope::Scope, block::AbstractBlockDecl)
Push a scope for the body of the block literal `block`.
"""
function PushBlockScope(x::AbstractSema, block_scope::Scope, block::AbstractBlockDecl)
    @check_ptrs x block_scope block
    return clang_Sema_PushBlockScope(x, block_scope, block)
end

"""
    PushCapturedRegionScope(x::AbstractSema, region_scope::Scope, cd::AbstractCapturedDecl,
                            rd::AbstractRecordDecl, k::CXCapturedRegionKind,
                            openmp_capture_level::Integer=0)
Push a scope for a captured region — a `CapturedStmt` or OpenMP construct body.

`rd` is the record holding the captured fields and `k` says which construct introduced the
region.
"""
function PushCapturedRegionScope(x::AbstractSema, region_scope::Scope, cd::AbstractCapturedDecl, rd::AbstractRecordDecl, k::CXCapturedRegionKind, openmp_capture_level::Integer=0)
    @check_ptrs x region_scope cd rd
    return clang_Sema_PushCapturedRegionScope(x, region_scope, cd, rd, k, openmp_capture_level)
end

"""
    PushCompoundScope(x::AbstractSema, is_stmt_expr::Bool=false)
Push a compound-statement scope onto the innermost function scope.

There must *be* an innermost function scope: the C++ method dereferences `getCurFunction()`
unchecked, so this gates on [`hasCurFunction`](@ref). Pair with
[`PopCompoundScope`](@ref).
"""
function PushCompoundScope(x::AbstractSema, is_stmt_expr::Bool=false)
    @check_ptrs x
    @assert hasCurFunction(x) "Sema has no current function scope"
    return clang_Sema_PushCompoundScope(x, is_stmt_expr)
end

"""
    PopCompoundScope(x::AbstractSema)
Pop the innermost compound-statement scope, undoing one [`PushCompoundScope`](@ref).
"""
function PopCompoundScope(x::AbstractSema)
    @check_ptrs x
    @assert hasCurFunction(x) "Sema has no current function scope"
    return clang_Sema_PopCompoundScope(x)
end

"""
    PushExpressionEvaluationContext(x::AbstractSema, ctx::CXExpressionEvaluationContext,
                                    lambda_context_decl=nothing,
                                    kind::CXExpressionKind=CXExpressionKind_EK_Other)
Push an expression-evaluation context — what tells `Sema` whether the expressions it next
sees are evaluated, unevaluated, or constant-evaluated.

Pair with [`PopExpressionEvaluationContext`](@ref). The C++ overload taking
`ReuseLambdaContextDecl_t` is not wrapped: it exists to thread parser state this boundary
does not carry.
"""
function PushExpressionEvaluationContext(x::AbstractSema, ctx::CXExpressionEvaluationContext, lambda_context_decl::Union{Nothing,AbstractDecl}=nothing, kind::CXExpressionKind=CXExpressionKind_EK_Other)
    @check_ptrs x
    decl = lambda_context_decl === nothing ? CXDecl(C_NULL) : Base.unsafe_convert(CXDecl, lambda_context_decl)
    return clang_Sema_PushExpressionEvaluationContext(x, ctx, decl, kind)
end

"""
    PopExpressionEvaluationContext(x::AbstractSema)
Leave the innermost expression-evaluation context.

`Sema` keeps one context for the translation unit itself, so this may only undo a context
[`PushExpressionEvaluationContext`](@ref) added.
"""
function PopExpressionEvaluationContext(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_PopExpressionEvaluationContext(x)
end

"""
    PushForceCUDAHostDevice(x::AbstractSema)
Force `__host__ __device__` onto declarations formed until the matching
[`PopForceCUDAHostDevice`](@ref).
"""
function PushForceCUDAHostDevice(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_PushForceCUDAHostDevice(x)
end

"""
    PopForceCUDAHostDevice(x::AbstractSema) -> Bool
Undo one [`PushForceCUDAHostDevice`](@ref), returning whether there was one to undo.

This is the rare unbalanced-pop that reports itself instead of underflowing, so `false` is
an answer rather than a precondition violation.
"""
function PopForceCUDAHostDevice(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_PopForceCUDAHostDevice(x)
end

"""
    PopPragmaVisibility(x::AbstractSema, is_namespace_end::Bool, end_loc::SourceLocation)
Pop a `#pragma visibility` (`is_namespace_end` false) or the visibility a namespace's
attribute introduced (`is_namespace_end` true, paired with
[`PushNamespaceVisibilityAttr`](@ref)).
"""
function PopPragmaVisibility(x::AbstractSema, is_namespace_end::Bool, end_loc::SourceLocation)
    @check_ptrs x
    return clang_Sema_PopPragmaVisibility(x, is_namespace_end, end_loc)
end

"""
    PushOnScopeChains(x::AbstractSema, d::AbstractNamedDecl, sc::Scope,
                      add_to_context::Bool=true)
Make `d` visible to unqualified lookup in `sc` and, unless `add_to_context` is false, add it
to the current declaration context.
"""
function PushOnScopeChains(x::AbstractSema, d::AbstractNamedDecl, sc::Scope, add_to_context::Bool=true)
    @check_ptrs x d sc
    return clang_Sema_PushOnScopeChains(x, d, sc, add_to_context)
end

"""
    PushUsingDirective(x::AbstractSema, sc::Scope, udir::AbstractUsingDirectiveDecl)
Record `udir` as a using-directive active in `sc`.
"""
function PushUsingDirective(x::AbstractSema, sc::Scope, udir::AbstractUsingDirectiveDecl)
    @check_ptrs x sc udir
    return clang_Sema_PushUsingDirective(x, sc, udir)
end

"""
    PushNamespaceVisibilityAttr(x::AbstractSema, attr::AbstractVisibilityAttr,
                                loc::SourceLocation)
Push the visibility a namespace-level visibility attribute establishes.

Pair with [`PopPragmaVisibility`](@ref) called with `is_namespace_end` true.
"""
function PushNamespaceVisibilityAttr(x::AbstractSema, attr::AbstractVisibilityAttr, loc::SourceLocation)
    @check_ptrs x attr
    return clang_Sema_PushNamespaceVisibilityAttr(x, attr, loc)
end

"""
    getCurrentInstantiationOf(x::AbstractSema, nns::AbstractNestedNameSpecifier)
        -> CXXRecordDecl
Return the class `nns` names when it designates the current instantiation, or a NULL-pointer
carrier when it does not.
"""
function getCurrentInstantiationOf(x::AbstractSema, nns::AbstractNestedNameSpecifier)
    @check_ptrs x nns
    return CXXRecordDecl(clang_Sema_getCurrentInstantiationOf(x, nns))
end

"""
    getDefaultedComparisonKind(x::AbstractSema, fd::AbstractFunctionDecl)
        -> CXDefaultedComparisonKind
Return which defaulted comparison, if any, `fd` declares.
"""
function getDefaultedComparisonKind(x::AbstractSema, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_Sema_getDefaultedComparisonKind(x, fd)
end

"""
    getNonFieldDeclScope(x::AbstractSema, sc::Scope) -> Scope
Return the nearest enclosing scope of `sc` that can hold a non-field declaration.

clang climbs `getParent` until it reaches a scope that qualifies, with no null check on the
way up, so a chain containing none runs off the end of the chain rather than returning
`nothing`. The loop's exit condition is restated here and the chain is required to satisfy
it — a bare scope built with no flags and no parent is the case that would otherwise crash.
"""
function getNonFieldDeclScope(x::AbstractSema, sc::Scope)
    @check_ptrs x sc
    cxx = getCPlusPlus(getLangOpts(x))
    s, qualifies = sc, false
    while !qualifies && s.ptr != C_NULL
        entity = getEntity(s)
        qualifies = (getFlags(s) & UInt32(CXScopeFlags_DeclScope)) != 0 && !(entity.ptr != C_NULL && isTransparentContext(entity)) && !(isClassScope(s) && !cxx)
        s = getParent(s)
    end
    @assert qualifies "no scope in the chain can hold a non-field declaration"
    return Scope(clang_Sema_getNonFieldDeclScope(x, sc))
end

"""
    getOrCreateStdNamespace(x::AbstractSema) -> NamespaceDecl
Return namespace `std`, creating it if the translation unit has not declared it.

This mutates the AST on first call, so it belongs to a throwaway interpreter rather than one
whose declarations other work depends on.
"""
function getOrCreateStdNamespace(x::AbstractSema)
    @check_ptrs x
    return NamespaceDecl(clang_Sema_getOrCreateStdNamespace(x))
end

"""
    getOwningModule(x::AbstractSema, entity::AbstractDecl) -> Module_
Return the module owning `entity`, or a NULL-pointer carrier when no module owns it.
"""
function getOwningModule(x::AbstractSema, entity::AbstractDecl)
    @check_ptrs x entity
    return Module_(clang_Sema_getOwningModule(x, entity))
end

"""
    getScopeForDeclContext(sc::Scope, dc::AbstractDeclContext) -> Scope
Return the scope in `sc`'s chain corresponding to `dc`, or a NULL-pointer carrier when the
chain contains none.

This mirrors a static member, so it takes no `Sema`.
"""
function getScopeForDeclContext(sc::Scope, dc::AbstractDeclContext)
    @check_ptrs sc dc
    return Scope(clang_Sema_getScopeForDeclContext(sc, dc))
end

"""
    getTemplateDepth(x::AbstractSema, sc::Scope) -> Int
Return the template depth `sc` sits at.
"""
function getTemplateDepth(x::AbstractSema, sc::Scope)::Int
    @check_ptrs x sc
    return clang_Sema_getTemplateDepth(x, sc)
end

"""
    getModuleLoader(x::AbstractSema) -> ModuleLoader
Return the module loader the compiler instance installed.
"""
function getModuleLoader(x::AbstractSema)
    @check_ptrs x
    return ModuleLoader(clang_Sema_getModuleLoader(x))
end

"""
    getCapturedDeclRefType(x::AbstractSema, var::AbstractValueDecl, loc::SourceLocation)
        -> QualType
Return the type a reference to `var` has once the capture at `loc` is accounted for.

The result is a *null* `QualType` when `var` cannot be captured at `loc` — the ordinary
answer whenever `loc` is not inside a lambda or block that could capture it — so callers
must test [`isNull`](@ref) before reaching for the type pointer.
"""
function getCapturedDeclRefType(x::AbstractSema, var::AbstractValueDecl, loc::SourceLocation)
    @check_ptrs x var
    return QualType(clang_Sema_getCapturedDeclRefType(x, var, loc))
end

"""
    getImplicitCodeSegOrSectionAttrForFunction(x::AbstractSema, fd::AbstractFunctionDecl,
                                               is_definition::Bool) -> Attr
Return the `code_seg` or `section` attribute `fd` implicitly carries, or a NULL-pointer
carrier when it carries neither.
"""
function getImplicitCodeSegOrSectionAttrForFunction(x::AbstractSema, fd::AbstractFunctionDecl, is_definition::Bool)
    @check_ptrs x fd
    return Attr(clang_Sema_getImplicitCodeSegOrSectionAttrForFunction(x, fd, is_definition))
end

"""
    isAcceptable(x::AbstractSema, d::AbstractNamedDecl, kind::CXAcceptableKind) -> Bool
Return `true` iff `d` is acceptable to name lookup under `kind` —
`CXAcceptableKind_Visible` requires it to be visible, `CXAcceptableKind_Reachable` also
accepts a declaration reachable through a module dependency.
"""
function isAcceptable(x::AbstractSema, d::AbstractNamedDecl, kind::CXAcceptableKind)
    @check_ptrs x d
    return clang_Sema_isAcceptable(x, d, kind)
end

"""
    hasAcceptableDefinition(x::AbstractSema, d::AbstractNamedDecl, kind::CXAcceptableKind;
                            only_need_complete::Bool=false) -> (Bool, Union{NamedDecl,Nothing})

Return whether `d` has an acceptable definition under `kind`, together with the declaration
worth suggesting instead when it does not.

The suggestion is `nothing` whenever the definition *is* acceptable — Clang only writes the
out-parameter on the failing path, so there is no second declaration to report on success.
Pass `only_need_complete` to ask about a complete type rather than a full definition.
"""
function hasAcceptableDefinition(x::AbstractSema, d::AbstractNamedDecl, kind::CXAcceptableKind; only_need_complete::Bool=false)
    @check_ptrs x d
    suggested = Ref{CXNamedDecl}(C_NULL)
    ok = clang_Sema_hasAcceptableDefinition(x, d, suggested, kind, only_need_complete)
    return ok, suggested[] == C_NULL ? nothing : NamedDecl(suggested[])
end

"""
    areMatrixTypesOfTheSameDimension(x::AbstractSema, src::QualType, dest::QualType) -> Bool
Return `true` iff the two matrix types have the same number of rows and columns.

Both operands must be *constant* matrix types. `clang::ConstantMatrixType` is the only matrix
type carrying dimensions to compare — a dependent-sized one, as written inside an
uninstantiated template, has none — so the dimensions are read through a cast this wrapper
has to establish rather than the callee. Matrix types need `-fenable-matrix`.
"""
function areMatrixTypesOfTheSameDimension(x::AbstractSema, src::QualType, dest::QualType)
    @check_ptrs x src dest
    @assert isConstantMatrixType(getTypePtr(src)) "source must be a constant matrix type"
    @assert isConstantMatrixType(getTypePtr(dest)) "destination must be a constant matrix type"
    return clang_Sema_areMatrixTypesOfTheSameDimension(x, src, dest)
end

"""
    getTemplateArgumentBindingsText(x::AbstractSema, params::TemplateParameterList,
                                    args::TemplateArgumentList) -> String
Return the `[with T = int]` text describing how `params` were bound to `args`, as
diagnostics spell it.
"""
function getTemplateArgumentBindingsText(x::AbstractSema, params::TemplateParameterList, args::TemplateArgumentList)
    @check_ptrs x params args
    return get_string(clang_Sema_getTemplateArgumentBindingsText(x, params, args))
end

"""
    getFullyPackExpandedSize(x::AbstractSema, arg::TemplateArgument) -> Union{UInt32,Nothing}
Return the number of elements the fully-expanded pack `arg` holds, or `nothing` when that
size is not yet known because the pack is still dependent.
"""
function getFullyPackExpandedSize(x::AbstractSema, arg::TemplateArgument)
    @check_ptrs x arg
    size = Ref{Cuint}(0)
    return clang_Sema_getFullyPackExpandedSize(x, arg, size) ? size[] : nothing
end

"""
    getCurFPFeatures(x::AbstractSema) -> UInt32
Return the floating-point options in effect at the parser's current point, as the `FPOptions`
word the decoders read — [`getRoundingMode`](@ref), [`getExceptionMode`](@ref),
[`allowFPContractWithinStatement`](@ref) and [`isFPConstrained`](@ref).
"""
function getCurFPFeatures(x::AbstractSema)
    @check_ptrs x
    return clang_Sema_getCurFPFeatures(x)
end

"""
    isTemplateTemplateParameterAtLeastAsSpecializedAs(x::AbstractSema,
        pparam::TemplateParameterList, aarg::AbstractTemplateDecl,
        loc::SourceLocation) -> Bool
Return whether the parameter list `pparam` is at least as specialized as the template `aarg`,
the partial-ordering test for template template parameters.
"""
function isTemplateTemplateParameterAtLeastAsSpecializedAs(x::AbstractSema, pparam::TemplateParameterList, aarg::AbstractTemplateDecl, loc::SourceLocation)
    @check_ptrs x pparam aarg
    return clang_Sema_isTemplateTemplateParameterAtLeastAsSpecializedAs(x, pparam, aarg, loc)
end

"""
    getIdentityTemplateArgumentLoc(x::AbstractSema, param::AbstractNamedDecl,
                                   loc::SourceLocation) -> TemplateArgumentLoc
Return the template argument that maps `param` to itself — the injected self-argument, `T` for
`template <typename T>` — which is the input template-substitution queries take.

`param` must be a template type, non-type or template template parameter: the dispatch ends in
an unchecked cast for anything else.

This function allocates and one should call `dispose` to release the resources after using
this object. Unlike every `TemplateArgumentLoc` reached through a getter, this one is owned.
"""
function getIdentityTemplateArgumentLoc(x::AbstractSema, param::AbstractNamedDecl, loc::SourceLocation)
    @check_ptrs x param
    k = getKind(param)
    @assert k in (CXDeclKind_TemplateTypeParm, CXDeclKind_NonTypeTemplateParm, CXDeclKind_TemplateTemplateParm) "expected a template parameter declaration"
    return TemplateArgumentLoc(clang_Sema_getIdentityTemplateArgumentLoc(x, param, loc))
end

"""
    getTemplateArgumentPackExpansionPattern(x::AbstractSema, orig::TemplateArgumentLoc)
        -> (TemplateArgumentLoc, SourceLocation, Union{UInt32,Nothing})
Return the pattern of the pack-expansion argument `orig`, together with the location of its
ellipsis and the number of expansions when that is already known.

`orig`'s argument must be a pack expansion. The returned pattern allocates and one should call
`dispose` to release the resources after using this object.
"""
function getTemplateArgumentPackExpansionPattern(x::AbstractSema, orig::TemplateArgumentLoc)
    @check_ptrs x orig
    @assert isPackExpansion(getArgument(orig)) "template argument must be a pack expansion"
    ellipsis = Ref{CXSourceLocation_}(C_NULL)
    has_n = Ref{Bool}(false)
    n = Ref{Cuint}(0)
    pat = clang_Sema_getTemplateArgumentPackExpansionPattern(x, orig, ellipsis, has_n, n)
    return TemplateArgumentLoc(pat), SourceLocation(ellipsis[]), has_n[] ? n[] : nothing
end

"""
    IsPointerConversion(x::AbstractSema, from::AbstractExpr, from_ty::QualType,
                        to_ty::QualType; in_overload_resolution::Bool=false)
        -> (Bool, QualType)
Return whether `from`, of type `from_ty`, converts to `to_ty` by a pointer conversion, together
with the converted type when it does.

The converted type is a null `QualType` when the answer is `false`, so test the flag rather
than the type.
"""
function IsPointerConversion(x::AbstractSema, from::AbstractExpr, from_ty::QualType, to_ty::QualType; in_overload_resolution::Bool=false)
    @check_ptrs x from from_ty to_ty
    converted = Ref{CXQualType}(C_NULL)
    incompatible = Ref{Bool}(false)
    ok = clang_Sema_IsPointerConversion(x, from, from_ty, to_ty, in_overload_resolution, converted, incompatible)
    return ok, QualType(converted[])
end

"""
    getMoreSpecializedTemplate(x::AbstractSema, ft1::AbstractFunctionTemplateDecl,
                               ft2::AbstractFunctionTemplateDecl, loc::SourceLocation,
                               tpoc::CXTPOC, num_call_arguments1::Integer,
                               num_call_arguments2::Integer;
                               reversed::Bool=false) -> Union{FunctionTemplateDecl,Nothing}
Return whichever of `ft1` and `ft2` is more specialized under partial ordering, or `nothing`
when neither is.

`tpoc` says which context the ordering is for. `reversed` selects the reversed-parameter-order
form, which is defined only for `CXTPOC_TPOC_Call`.
"""
function getMoreSpecializedTemplate(x::AbstractSema, ft1::AbstractFunctionTemplateDecl, ft2::AbstractFunctionTemplateDecl, loc::SourceLocation, tpoc::CXTPOC, num_call_arguments1::Integer, num_call_arguments2::Integer; reversed::Bool=false)
    @check_ptrs x ft1 ft2
    @assert !reversed || tpoc == CXTPOC_TPOC_Call "the reversed form is only defined for call-context ordering"
    p = clang_Sema_getMoreSpecializedTemplate(x, ft1, ft2, loc, tpoc, num_call_arguments1, num_call_arguments2, reversed)
    return p == C_NULL ? nothing : FunctionTemplateDecl(p)
end

"""
    getFormatStringInfo(attr::AbstractFormatAttr, is_cxx_member::Bool,
                        is_variadic::Bool) -> Union{NamedTuple,Nothing}
Decode a `format` attribute into `(format_idx, first_data_arg, arg_passing_kind)`, or `nothing`
when the attribute does not describe a usable format string.

Static: it takes no `Sema`, so unlike the rest of this file it has no reachable diagnostics
engine and structurally cannot diagnose. The indices it returns are adjusted for
`is_cxx_member` (an implicit `this` shifts them) and `is_variadic`.
"""
function getFormatStringInfo(attr::AbstractFormatAttr, is_cxx_member::Bool, is_variadic::Bool)
    @check_ptrs attr
    idx = Ref{Cuint}(0)
    first = Ref{Cuint}(0)
    kind = Ref{CXFormatArgumentPassingKind}(CXFormatArgumentPassingKind_FAPK_Fixed)
    ok = clang_Sema_getFormatStringInfo(attr, is_cxx_member, is_variadic, idx, first, kind)
    ok || return nothing
    return (format_idx=idx[], first_data_arg=first[], arg_passing_kind=kind[])
end

"""
    DefineDefaultedComparison(x::AbstractSema, loc::SourceLocation,
                              fd::AbstractFunctionDecl, dck::CXDefaultedComparisonKind)
Define the body of the defaulted comparison operator `fd`.

`fd` must be a defaulted, non-deleted comparison whose kind really is `dck` — the kind is read
back here with [`getDefaultedComparisonKind`](@ref) rather than trusted from the caller, since
passing the wrong one would have clang synthesize the wrong body.
"""
function DefineDefaultedComparison(x::AbstractSema, loc::SourceLocation, fd::AbstractFunctionDecl, dck::CXDefaultedComparisonKind)
    @check_ptrs x fd
    @assert dck != CXDefaultedComparisonKind_None "a defaulted comparison kind is required"
    @assert getDefaultedComparisonKind(x, fd) == dck "dck must be the declaration's own comparison kind"
    @assert isDefaulted(fd) "the function must be defaulted"
    @assert !isDeleted(fd) "a deleted function has no body to define"
    return clang_Sema_DefineDefaultedComparison(x, loc, fd, dck)
end

"""
    getTemplateInstantiationArgs(x::AbstractSema, d::AbstractNamedDecl,
        dc::Union{DeclContext,Nothing}=nothing; final::Bool=false,
        innermost::Union{TemplateArgumentList,Nothing}=nothing,
        relative_to_primary::Bool=false, pattern::Union{AbstractFunctionDecl,Nothing}=nothing,
        for_constraint_instantiation::Bool=false,
        skip_for_specialization::Bool=false) -> MultiLevelTemplateArgumentList
Return the template argument lists in scope for `d`, outermost level last.

At least one of `d` and `dc` must be present. The result is a copy of clang's by-value list, so
its retained-outer-level count travels with it; this function allocates and one should call
`dispose` to release the resources after using this object.
"""
function getTemplateInstantiationArgs(x::AbstractSema, d::AbstractNamedDecl, dc::Union{DeclContext,Nothing}=nothing; final::Bool=false, innermost::Union{TemplateArgumentList,Nothing}=nothing, relative_to_primary::Bool=false, pattern::Union{AbstractFunctionDecl,Nothing}=nothing, for_constraint_instantiation::Bool=false, skip_for_specialization::Bool=false)
    @check_ptrs x
    @assert !is_null_handle(d) || dc !== nothing "at least one of d and dc must be given"
    return MultiLevelTemplateArgumentList(clang_Sema_getTemplateInstantiationArgs(x, d, dc === nothing ? C_NULL : dc, final, innermost === nothing ? C_NULL : innermost, relative_to_primary, pattern === nothing ? C_NULL : pattern, for_constraint_instantiation, skip_for_specialization))
end

"""
    resolveAddressOfSingleOverloadCandidate(x::AbstractSema, e::AbstractExpr)
        -> Union{Tuple{FunctionDecl,NamedDecl,CXAccessSpecifier},Nothing}
Return the single function the overload-set expression `e` names, together with the declaration
found and its access, or `nothing` when `e` names none or more than one.

`e` must carry the overload placeholder type — the same precondition
[`ResolveAddressOfOverloadedFunction`](@ref) restates, since both route through
`OverloadExpr::find`.
"""
function resolveAddressOfSingleOverloadCandidate(x::AbstractSema, e::AbstractExpr)
    @check_ptrs x e
    ety = expr_type_ptr(e)
    @assert isPlaceholderType(ety) && !isNonOverloadPlaceholderType(ety) "the expression must name an overload set"
    found = Ref{CXNamedDecl}(C_NULL)
    access = Ref{CXAccessSpecifier}(CXAccessSpecifier_AS_none)
    p = clang_Sema_resolveAddressOfSingleOverloadCandidate(x, e, found, access)
    p == C_NULL && return nothing
    return FunctionDecl(p), NamedDecl(found[]), access[]
end
