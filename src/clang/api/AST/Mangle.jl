# MangleContext
"""
    createMangleContext(x::ASTContext, ti::TargetInfo) -> MangleContext
Create a name mangler for the target. **The result is caller-owned — `dispose` it.**

This is the odd one out in the AST area: nearly everything reachable from an `ASTContext` is
arena memory that dies with the context, so it needs no release. `ASTContext::createMangleContext`
instead returns a `new`ed object, and until `clang_MangleContext_dispose` existed there was no way
to free it.
"""
function createMangleContext(x::ASTContext, ti::TargetInfo)
    @check_ptrs x ti
    return MangleContext(clang_ASTContext_createMangleContext(x, ti))
end

"""
    dispose(x::MangleContext)
Release a mangle context created by [`createMangleContext`](@ref).

`clang::MangleContext` has a virtual destructor, so deleting through the base runs the Itanium or
Microsoft subclass's own.
"""
dispose(x::MangleContext) = clang_MangleContext_dispose(x)

function getKind(x::MangleContext)
    @check_ptrs x
    return clang_MangleContext_getKind(x)
end

function getASTContext(x::MangleContext)
    @check_ptrs x
    return ASTContext(clang_MangleContext_getASTContext(x))
end

function getDiags(x::MangleContext)
    @check_ptrs x
    return DiagnosticsEngine(clang_MangleContext_getDiags(x))
end

function getAnonymousStructId(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_getAnonymousStructId(x, d)
end

function shouldMangleDeclName(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_shouldMangleDeclName(x, d)
end

function shouldMangleCXXName(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_shouldMangleCXXName(x, d)
end

function shouldMangleStringLiteral(x::MangleContext, sl::AbstractStringLiteral)
    @check_ptrs x sl
    return clang_MangleContext_shouldMangleStringLiteral(x, sl)
end

"""
    mangleName(x::MangleContext, d::AbstractNamedDecl) -> String
Return the mangled linkage name of `d`.

`d` must not be a constructor or a destructor. Those have *several* mangled names — for a
constructor the complete-object, base-object and allocating variants — so clang's entry point
takes a `GlobalDecl` carrying which one is meant, and building one from a bare
`CXXConstructorDecl` trips `assert(!isa<CXXConstructorDecl>(D) && "Use other ctor with ctor
decls!")` in GlobalDecl.h. That assert is compiled into the release libclang-cpp, so the
process aborts rather than returning. Ask [`getAllManglings`](@ref) for those.
"""
function mangleName(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    @assert !(d isa AbstractCXXConstructorDecl) && !(d isa AbstractCXXDestructorDecl) "a " * "constructor or destructor has several mangled names; use `getAllManglings`"
    return get_string(clang_MangleContext_mangleName(x, d))
end

# ASTNameGenerator
"""
    ASTNameGenerator(ctx::ASTContext) -> ASTNameGenerator
Build a name generator bound to `ctx`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ASTNameGenerator(ctx::ASTContext)
    @check_ptrs ctx
    return ASTNameGenerator(clang_ASTNameGenerator_create(ctx))
end

dispose(x::ASTNameGenerator) = (@check_ptrs x; clang_ASTNameGenerator_dispose(x))

function getName(x::ASTNameGenerator, d::AbstractDecl)
    @check_ptrs x d
    return get_string(clang_ASTNameGenerator_getName(x, d))
end

"""
    getAllManglings(x::ASTNameGenerator, d::AbstractDecl) -> Vector{String}
Return all of the mangled names of the declaration (constructors and destructors have
several).
"""
function getAllManglings(x::ASTNameGenerator, d::AbstractDecl)
    @check_ptrs x d
    return get_string(clang_ASTNameGenerator_getAllManglings(x, d))
end

# True only for the auxiliary-target mangler of an offloading compilation.
function isAux(x::MangleContext)
    @check_ptrs x
    return clang_MangleContext_isAux(x)
end

"""
    startNewFunction(x::MangleContext)
Reset the mangler's per-function block numbering before mangling a new function.
"""
function startNewFunction(x::MangleContext)
    @check_ptrs x
    return clang_MangleContext_startNewFunction(x)
end

# The id `getAnonymousStructId` previously handed out for `d`; 0 when none was
# assigned yet.
function getAnonymousStructIdForDebugInfo(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_getAnonymousStructIdForDebugInfo(x, d)
end

"""
    mangleCXXRTTIName(x::MangleContext, ty::QualType, normalize_integers::Bool=false) -> String
Return the mangled RTTI type-name string of `ty` (the Itanium `_ZTS...` symbol name).
"""
function mangleCXXRTTIName(x::MangleContext, ty::QualType, normalize_integers::Bool=false)
    @check_ptrs x ty
    return get_string(clang_MangleContext_mangleCXXRTTIName(x, ty, normalize_integers))
end

"""
    mangleCanonicalTypeName(x::MangleContext, ty::QualType, normalize_integers::Bool=false) -> String
Return a unique string for the canonical form of `ty`, as used for TBAA and type uniquing.
"""
function mangleCanonicalTypeName(x::MangleContext, ty::QualType, normalize_integers::Bool=false)
    @check_ptrs x ty
    return get_string(clang_MangleContext_mangleCanonicalTypeName(x, ty, normalize_integers))
end

"""
    createDeviceMangleContext(x::ASTContext, ti::TargetInfo) -> MangleContext
Create the device-side name mangler used to mangle lambdas in a mixed host/device
compilation. The result is a caller-owned heap object with no dispose entry point (the
same known leak as `createMangleContext`).

PRECONDITION: `ti`'s C++ ABI must not be Microsoft — clang asserts it and the mangler
switch has no Microsoft arm.
"""
function createDeviceMangleContext(x::ASTContext, ti::TargetInfo)
    @check_ptrs x ti
    @assert getCXXABI(ti) != CXTargetCXXABI_Microsoft "device mangling needs a non-Microsoft C++ ABI"
    return MangleContext(clang_ASTContext_createDeviceMangleContext(x, ti))
end

"""
    isUniqueInternalLinkageDecl(x::MangleContext, d::AbstractNamedDecl) -> Bool
Return whether `d` is given a uniqued internal-linkage name. Always `false` until
`needsUniqueInternalLinkageNames` has been called on the mangler, and `false` for every
declaration the base `MangleContext` implementation sees.
"""
function isUniqueInternalLinkageDecl(x::MangleContext, d::AbstractNamedDecl)
    @check_ptrs x d
    return clang_MangleContext_isUniqueInternalLinkageDecl(x, d)
end

"""
    needsUniqueInternalLinkageNames(x::MangleContext)
Ask the mangler to give internal-linkage declarations unique names from here on. This
mutates the mangler, so every later `isUniqueInternalLinkageDecl` query sees the flag.
"""
function needsUniqueInternalLinkageNames(x::MangleContext)
    @check_ptrs x
    return clang_MangleContext_needsUniqueInternalLinkageNames(x)
end

"""
    getLambdaString(x::MangleContext, rd::AbstractCXXRecordDecl) -> String
Return the `<lambda...>` spelling the closure type `rd` contributes to mangled names.
The Itanium mangler spells it `<lambdaN>` and the Microsoft one `<lambda_N>`.

PRECONDITION: `rd` must be a lambda closure class — clang asserts `isLambda()` and then
reads the lambda-only fields (`getLambdaContextDecl`, `getLambdaManglingNumber`)
unconditionally.
"""
function getLambdaString(x::MangleContext, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert isLambda(rd) "getLambdaString needs a lambda closure class"
    return get_string(clang_MangleContext_getLambdaString(x, rd))
end

"""
    mangleCXXRTTI(x::MangleContext, ty::QualType) -> String
Return the mangled name of the RTTI descriptor for `ty` (the Itanium `_ZTI...` symbol).
The companion `mangleCXXRTTIName` returns the `_ZTS...` type-name string instead.

PRECONDITION: `ty` must carry no qualifiers — RTTI is emitted for the unqualified type
and the Itanium mangler asserts on a qualified one.
"""
function mangleCXXRTTI(x::MangleContext, ty::QualType)
    @check_ptrs x ty
    @assert !hasQualifiers(ty) "RTTI mangling needs an unqualified type"
    return get_string(clang_MangleContext_mangleCXXRTTI(x, ty))
end

"""
    mangleStaticGuardVariable(x::MangleContext, d::AbstractVarDecl) -> String
Return the mangled name of the guard variable that protects `d`'s one-time
initialization.
"""
function mangleStaticGuardVariable(x::MangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_MangleContext_mangleStaticGuardVariable(x, d))
end

"""
    mangleDynamicInitializer(x::MangleContext, d::AbstractVarDecl) -> String
Return the symbol name of the stub that runs `d`'s dynamic initialization.
"""
function mangleDynamicInitializer(x::MangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_MangleContext_mangleDynamicInitializer(x, d))
end

# The mangler entry points that write straight into a raw_ostream. Every string below is
# target-ABI specific, so callers must not compare one across hosts.
"""
    mangleCXXName(x::MangleContext, d::AbstractFunctionDecl) -> String
    mangleCXXName(x::MangleContext, d::AbstractVarDecl) -> String
Return the C++-mangled name of `d`, applying the C++ mangling rules directly instead of
the `asm` label and "does this need mangling at all" fallbacks `mangleName` tries first.

PRECONDITION: `d` must not be a constructor or a destructor — clang's
`GlobalDecl(NamedDecl *)` contract asserts it, because those two carry a variant type this
entry point cannot supply.
"""
function mangleCXXName(x::MangleContext, d::AbstractFunctionDecl)
    @check_ptrs x d
    kind = getDeclKindName(d)
    @assert kind != "CXXConstructor" && kind != "CXXDestructor" "a ctor or dtor needs its variant type"
    return get_string(clang_MangleContext_mangleCXXName(x, d))
end

function mangleCXXName(x::MangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_MangleContext_mangleCXXName(x, d))
end

"""
    mangleReferenceTemporary(x::MangleContext, d::AbstractVarDecl, mangling_number::Integer=1) -> String
Return the symbol name of the reference temporary materialized for `d`.
`mangling_number` distinguishes the temporaries created by one initializer and is 1-based,
matching the numbers clang's `MangleNumberingContext` hands out.
"""
function mangleReferenceTemporary(x::MangleContext, d::AbstractVarDecl, mangling_number::Integer=1)
    @check_ptrs x d
    return get_string(clang_MangleContext_mangleReferenceTemporary(x, d, mangling_number))
end

"""
    mangleDynamicAtExitDestructor(x::MangleContext, d::AbstractVarDecl) -> String
Return the symbol name of the stub that runs `d`'s registered at-exit destructor.
"""
function mangleDynamicAtExitDestructor(x::MangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_MangleContext_mangleDynamicAtExitDestructor(x, d))
end

"""
    mangleSEHFilterExpression(x::MangleContext, d::AbstractFunctionDecl) -> String
Return the symbol name of the SEH filter expression outlined from `d`.

PRECONDITION: `d` must not be a constructor or a destructor — `GlobalDecl(FunctionDecl *)`
asserts it.
"""
function mangleSEHFilterExpression(x::MangleContext, d::AbstractFunctionDecl)
    @check_ptrs x d
    kind = getDeclKindName(d)
    @assert kind != "CXXConstructor" && kind != "CXXDestructor" "a ctor or dtor cannot enclose SEH"
    return get_string(clang_MangleContext_mangleSEHFilterExpression(x, d))
end

"""
    mangleSEHFinallyBlock(x::MangleContext, d::AbstractFunctionDecl) -> String
Return the symbol name of the SEH finally block outlined from `d`.

PRECONDITION: `d` must not be a constructor or a destructor — `GlobalDecl(FunctionDecl *)`
asserts it.
"""
function mangleSEHFinallyBlock(x::MangleContext, d::AbstractFunctionDecl)
    @check_ptrs x d
    kind = getDeclKindName(d)
    @assert kind != "CXXConstructor" && kind != "CXXDestructor" "a ctor or dtor cannot enclose SEH"
    return get_string(clang_MangleContext_mangleSEHFinallyBlock(x, d))
end

# ItaniumMangleContext
"""
    ItaniumMangleContext(x::MangleContext) -> ItaniumMangleContext
Refine a mangler carrier to the Itanium mangler, the class that declares the vtable, VTT,
thread-local, comdat, lambda-signature and module-initializer entry points. The result
holds NULL when `x` is not an Itanium mangler (i.e. under the Microsoft C++ ABI), so test
`.ptr` before using it.

The carrier names the very same object as `x` rather than a new one, so it must never be
disposed separately.
"""
function ItaniumMangleContext(x::MangleContext)
    @check_ptrs x
    return ItaniumMangleContext(clang_MangleContext_castToItaniumMangleContext(x))
end

"""
    mangleCXXVTable(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl) -> String
Return the symbol name of `rd`'s virtual table.
"""
function mangleCXXVTable(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    return get_string(clang_ItaniumMangleContext_mangleCXXVTable(x, rd))
end

"""
    mangleCXXVTT(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl) -> String
Return the symbol name of `rd`'s virtual table table.
"""
function mangleCXXVTT(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    return get_string(clang_ItaniumMangleContext_mangleCXXVTT(x, rd))
end

"""
    mangleCXXCtorVTable(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl,
                        offset::Integer, base::AbstractCXXRecordDecl) -> String
Return the symbol name of the construction vtable emitted for `base` sitting at byte
`offset` inside `rd`.
"""
function mangleCXXCtorVTable(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl, offset::Integer, base::AbstractCXXRecordDecl)
    @check_ptrs x rd base
    return get_string(clang_ItaniumMangleContext_mangleCXXCtorVTable(x, rd, offset, base))
end

"""
    mangleItaniumThreadLocalInit(x::AbstractItaniumMangleContext, d::AbstractVarDecl) -> String
Return the symbol name of the thread-local initialization function of `d`.
"""
function mangleItaniumThreadLocalInit(x::AbstractItaniumMangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_ItaniumMangleContext_mangleItaniumThreadLocalInit(x, d))
end

"""
    mangleItaniumThreadLocalWrapper(x::AbstractItaniumMangleContext, d::AbstractVarDecl) -> String
Return the symbol name of the thread-local access wrapper of `d`.
"""
function mangleItaniumThreadLocalWrapper(x::AbstractItaniumMangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_ItaniumMangleContext_mangleItaniumThreadLocalWrapper(x, d))
end

"""
    mangleCXXCtorComdat(x::AbstractItaniumMangleContext, d::AbstractCXXConstructorDecl) -> String
Return the name of the comdat group that holds `d`'s constructor variants.
"""
function mangleCXXCtorComdat(x::AbstractItaniumMangleContext, d::AbstractCXXConstructorDecl)
    @check_ptrs x d
    return get_string(clang_ItaniumMangleContext_mangleCXXCtorComdat(x, d))
end

"""
    mangleCXXDtorComdat(x::AbstractItaniumMangleContext, d::AbstractCXXDestructorDecl) -> String
Return the name of the comdat group that holds `d`'s destructor variants.
"""
function mangleCXXDtorComdat(x::AbstractItaniumMangleContext, d::AbstractCXXDestructorDecl)
    @check_ptrs x d
    return get_string(clang_ItaniumMangleContext_mangleCXXDtorComdat(x, d))
end

"""
    mangleLambdaSig(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl) -> String
Return the mangled call-operator signature of the closure type `rd`.

PRECONDITION: `rd` must be a lambda closure class — the mangler reads its call operator
unconditionally.
"""
function mangleLambdaSig(x::AbstractItaniumMangleContext, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert isLambda(rd) "mangleLambdaSig needs a lambda closure class"
    return get_string(clang_ItaniumMangleContext_mangleLambdaSig(x, rd))
end

"""
    mangleDynamicStermFinalizer(x::AbstractItaniumMangleContext, d::AbstractVarDecl) -> String
Return the symbol name of the finalizer stub registered for `d` by `at_thread_exit`.
"""
function mangleDynamicStermFinalizer(x::AbstractItaniumMangleContext, d::AbstractVarDecl)
    @check_ptrs x d
    return get_string(clang_ItaniumMangleContext_mangleDynamicStermFinalizer(x, d))
end

"""
    mangleModuleInitializer(x::AbstractItaniumMangleContext, m::AbstractModule) -> String
Return the symbol name of the module-initializer function of the named module `m`. Only
`m`'s name, kind and parent chain are read, so a `Module_` built by hand works.
"""
function mangleModuleInitializer(x::AbstractItaniumMangleContext, m::AbstractModule)
    @check_ptrs x m
    return get_string(clang_ItaniumMangleContext_mangleModuleInitializer(x, m))
end

"""
    getBlockId(x::AbstractMangleContext, bd::AbstractBlockDecl, local_id::Bool) -> Cuint
Return the mangling id of `bd`.

This *mutates* the context: the id is assigned on the first query and is stable afterwards, so
two contexts can answer differently for the same block, and the answer depends on how many
blocks this context has already numbered.
"""
function getBlockId(x::AbstractMangleContext, bd::AbstractBlockDecl, local_id::Bool)
    @check_ptrs x bd
    return clang_MangleContext_getBlockId(x, bd, local_id)
end
