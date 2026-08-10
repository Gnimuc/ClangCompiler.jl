# InitializedEntity
"""
    InitializeVariable(var::AbstractVarDecl) -> InitializedEntity
Describe the initialization of a declared variable.

This function allocates and one should call `dispose` to release the resources after using
this object. The entity must outlive every sequence built from it.
"""
function InitializeVariable(var::AbstractVarDecl)
    @check_ptrs var
    return InitializedEntity(clang_InitializedEntity_InitializeVariable(var))
end

"""
    InitializeParameter(ctx::AbstractASTContext, parm::AbstractParmVarDecl) -> InitializedEntity
Describe the initialization of a call parameter, taking its type from `parm`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function InitializeParameter(ctx::AbstractASTContext, parm::AbstractParmVarDecl)
    @check_ptrs ctx parm
    return InitializedEntity(clang_InitializedEntity_InitializeParameter(ctx, parm))
end

"""
    InitializeParameter(ctx::AbstractASTContext, ty::QualType, consumed::Bool=false) -> InitializedEntity
Describe the initialization of a parameter known only by type — the shape a call assembled
from a list of argument types needs, with no `ParmVarDecl` to point at.

`consumed` is the Objective-C ARC ownership-transfer flag and is `false` for C++.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function InitializeParameter(ctx::AbstractASTContext, ty::QualType, consumed::Bool=false)
    @check_ptrs ctx ty
    return InitializedEntity(clang_InitializedEntity_InitializeParameterWithType(ctx, ty, consumed))
end

"""
    InitializeResult(loc::SourceLocation, ty::QualType) -> InitializedEntity
Describe the initialization of the object a `return` yields.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function InitializeResult(loc::SourceLocation, ty::QualType)
    @check_ptrs ty
    return InitializedEntity(clang_InitializedEntity_InitializeResult(loc, ty))
end

"""
    InitializeTemporary(ty::QualType) -> InitializedEntity
Describe the initialization of a temporary of type `ty`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function InitializeTemporary(ty::QualType)
    @check_ptrs ty
    return InitializedEntity(clang_InitializedEntity_InitializeTemporary(ty))
end

dispose(x::InitializedEntity) = clang_InitializedEntity_dispose(x)

function getType(x::AbstractInitializedEntity)
    @check_ptrs x
    return QualType(clang_InitializedEntity_getType(x))
end

# InitializationKind
"""
    CreateDirect(init_loc::SourceLocation, lparen_loc::SourceLocation, rparen_loc::SourceLocation) -> InitializationKind
Direct-initialization, `T x(args)`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CreateDirect(init_loc::SourceLocation, lparen_loc::SourceLocation, rparen_loc::SourceLocation)
    return InitializationKind(clang_InitializationKind_CreateDirect(init_loc, lparen_loc, rparen_loc))
end

"""
    CreateDirectList(init_loc::SourceLocation) -> InitializationKind
Direct-list-initialization, `T x{args}`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
CreateDirectList(init_loc::SourceLocation) = InitializationKind(clang_InitializationKind_CreateDirectList(init_loc))

"""
    CreateCopy(init_loc::SourceLocation, equal_loc::SourceLocation, allow_explicit_convs::Bool=false) -> InitializationKind
Copy-initialization, `T x = arg`. `allow_explicit_convs` lets explicit conversion functions
take part, which copy-initialization normally forbids.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CreateCopy(init_loc::SourceLocation, equal_loc::SourceLocation, allow_explicit_convs::Bool=false)
    return InitializationKind(clang_InitializationKind_CreateCopy(init_loc, equal_loc, allow_explicit_convs))
end

"""
    CreateDefault(init_loc::SourceLocation) -> InitializationKind
Default-initialization, `T x;`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
CreateDefault(init_loc::SourceLocation) = InitializationKind(clang_InitializationKind_CreateDefault(init_loc))

"""
    CreateValue(init_loc::SourceLocation, lparen_loc::SourceLocation, rparen_loc::SourceLocation, is_implicit::Bool=false) -> InitializationKind
Value-initialization, `T x{}` / `T()`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CreateValue(init_loc::SourceLocation, lparen_loc::SourceLocation, rparen_loc::SourceLocation, is_implicit::Bool=false)
    return InitializationKind(clang_InitializationKind_CreateValue(init_loc, lparen_loc, rparen_loc, is_implicit))
end

dispose(x::InitializationKind) = clang_InitializationKind_dispose(x)

# InitializationSequence
"""
    InitializationSequence(sema::AbstractSema, entity::AbstractInitializedEntity, kind::AbstractInitializationKind, args::AbstractVector{<:AbstractExpr}; top_level_of_init_list::Bool=false, treat_unavailable_as_invalid::Bool=true) -> InitializationSequence
Compute the sequence that initializes `entity` from `args` in the manner `kind` describes.

Computing the sequence runs overload resolution but builds nothing; [`Perform`](@ref) is
what produces the expression, and it must be given the same arguments.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function InitializationSequence(sema::AbstractSema, entity::AbstractInitializedEntity,
                                kind::AbstractInitializationKind,
                                args::AbstractVector{<:AbstractExpr};
                                top_level_of_init_list::Bool=false,
                                treat_unavailable_as_invalid::Bool=true)
    @check_ptrs sema entity kind
    buf = [Base.unsafe_convert(CXExpr, a) for a in args]
    return InitializationSequence(clang_InitializationSequence_create(sema, entity, kind, buf,
                                                                      length(buf),
                                                                      top_level_of_init_list,
                                                                      treat_unavailable_as_invalid))
end

dispose(x::InitializationSequence) = clang_InitializationSequence_dispose(x)

"""
    Failed(x::AbstractInitializationSequence) -> Bool
Return whether the sequence could not be formed — no conversion or constructor makes the
initialization legal.
"""
function Failed(x::AbstractInitializationSequence)
    @check_ptrs x
    return clang_InitializationSequence_Failed(x)
end

"""
    getFailureKind(x::AbstractInitializationSequence) -> UInt32
Return which of clang's `FailureKind`s explains the failure.
"""
function getFailureKind(x::AbstractInitializationSequence)
    @check_ptrs x
    @assert Failed(x) "the failure kind is only defined for a failed sequence"
    return clang_InitializationSequence_getFailureKind(x)
end

"""
    getKind(x::AbstractInitializationSequence) -> UInt32
Return which of clang's `SequenceKind`s the sequence is.
"""
function getKind(x::AbstractInitializationSequence)
    @check_ptrs x
    return clang_InitializationSequence_getKind(x)
end

"""
    Perform(x::AbstractInitializationSequence, sema::AbstractSema, entity::AbstractInitializedEntity, kind::AbstractInitializationKind, args::AbstractVector{<:AbstractExpr}) -> Expr_
Build the initialization expression, returning a carrier holding `NULL` if it failed.

`args` must be the same arguments the sequence was computed from.
"""
function Perform(x::AbstractInitializationSequence, sema::AbstractSema,
                 entity::AbstractInitializedEntity, kind::AbstractInitializationKind,
                 args::AbstractVector{<:AbstractExpr})
    @check_ptrs x sema entity kind
    buf = [Base.unsafe_convert(CXExpr, a) for a in args]
    invalid = Ref{Bool}(false)
    e = clang_InitializationSequence_Perform(x, sema, entity, kind, buf, length(buf), invalid)
    return Expr_(e)
end

"""
    Diagnose(x::AbstractInitializationSequence, sema::AbstractSema, entity::AbstractInitializedEntity, kind::AbstractInitializationKind, args::AbstractVector{<:AbstractExpr}) -> Bool
Emit the diagnostics explaining a failed sequence, returning whether it was ill-formed.
"""
function Diagnose(x::AbstractInitializationSequence, sema::AbstractSema,
                  entity::AbstractInitializedEntity, kind::AbstractInitializationKind,
                  args::AbstractVector{<:AbstractExpr})
    @check_ptrs x sema entity kind
    buf = [Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_InitializationSequence_Diagnose(x, sema, entity, kind, buf, length(buf))
end

# Sema one-shots
"""
    CanPerformCopyInitialization(sema::AbstractSema, entity::AbstractInitializedEntity, init::AbstractExpr) -> Bool
Return whether `init` could copy-initialize `entity`, asked without building anything or
emitting diagnostics.
"""
function CanPerformCopyInitialization(sema::AbstractSema, entity::AbstractInitializedEntity, init::AbstractExpr)
    @check_ptrs sema entity init
    return clang_Sema_CanPerformCopyInitialization(sema, entity, init)
end

"""
    PerformCopyInitialization(sema::AbstractSema, entity::AbstractInitializedEntity, init::AbstractExpr; equal_loc::SourceLocation=SourceLocation(), top_level_of_init_list::Bool=false, allow_explicit::Bool=false) -> Expr_
Copy-initialize `entity` from `init` — the one-shot over the three-step dance above, and
what binding a call argument or a return value goes through.

Returns a carrier holding `NULL` when the initialization was rejected.
"""
function PerformCopyInitialization(sema::AbstractSema, entity::AbstractInitializedEntity,
                                   init::AbstractExpr; equal_loc::SourceLocation=SourceLocation(),
                                   top_level_of_init_list::Bool=false, allow_explicit::Bool=false)
    @check_ptrs sema entity init
    invalid = Ref{Bool}(false)
    e = clang_Sema_PerformCopyInitialization(sema, entity, equal_loc, init,
                                             top_level_of_init_list, allow_explicit, invalid)
    return Expr_(e)
end
