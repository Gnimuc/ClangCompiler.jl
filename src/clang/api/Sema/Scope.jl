# Scope
function dump(x::Scope)
    @check_ptrs x
    return clang_Scope_dump(x)
end

function getParent(x::Scope)
    @check_ptrs x
    return Scope(clang_Scope_getParent(x))
end

function getDepth(x::Scope)::Int
    @check_ptrs x
    return clang_Scope_getDepth(x)
end


function getFlags(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_getFlags(x)
end

function getFnParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getFnParent(x))
end

"""
    getEntity(x::AbstractScope) -> DeclContext
Return the entity this scope corresponds to. `clang::Scope::getEntity` reports no entity for
a template parameter scope, so the returned `DeclContext` carries a NULL pointer there.
"""
function getEntity(x::AbstractScope)
    @check_ptrs x
    return DeclContext(clang_Scope_getEntity(x))
end

function isTemplateParamScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isTemplateParamScope(x)
end

function isDeclScope(x::AbstractScope, d::AbstractDecl)
    @check_ptrs x d
    return clang_Scope_isDeclScope(x, d)
end


function isBlockScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isBlockScope(x)
end

"""
    getContinueParent(x::AbstractScope) -> Scope
Return the closest scope a `continue` statement would be affected by. The returned `Scope`
carries a NULL pointer when there is no such scope.
"""
function getContinueParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getContinueParent(x))
end

"""
    getBreakParent(x::AbstractScope) -> Scope
Return the closest scope a `break` statement would be affected by. The returned `Scope`
carries a NULL pointer when there is no such scope.
"""
function getBreakParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getBreakParent(x))
end

"""
    getBlockParent(x::AbstractScope) -> Scope
Return the immediately containing block (closure) scope. The returned `Scope` carries a
NULL pointer when there is no such scope.
"""
function getBlockParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getBlockParent(x))
end

"""
    getTemplateParamParent(x::AbstractScope) -> Scope
Return the immediately containing template parameter scope. The returned `Scope` carries a
NULL pointer when there is no such scope.
"""
function getTemplateParamParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getTemplateParamParent(x))
end

"""
    getFunctionPrototypeDepth(x::AbstractScope) -> Integer
Return the number of function prototype scopes in this scope chain.
"""
function getFunctionPrototypeDepth(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_getFunctionPrototypeDepth(x)
end

"""
    getDecls(x::AbstractScope) -> Vector{Decl}
Return the declarations this scope directly introduces. `clang::Scope` keeps them in a
pointer set, so the order is that set's iteration order and carries no meaning.
"""
function getDecls(x::AbstractScope)
    @check_ptrs x
    n = clang_Scope_getNumDecls(x)
    buf = Vector{CXDecl}(undef, n)
    n > 0 && clang_Scope_getDecls(x, buf)
    return [Decl(p) for p in buf]
end

function decl_empty(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_decl_empty(x)
end

"""
    getLookupEntity(x::AbstractScope) -> DeclContext
Return the `DeclContext` unqualified lookup continues in after this scope. Unlike
`getEntity` this reports the entity of a template parameter scope as well.
"""
function getLookupEntity(x::AbstractScope)
    @check_ptrs x
    return DeclContext(clang_Scope_getLookupEntity(x))
end

function isFunctionScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isFunctionScope(x)
end

function isClassScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isClassScope(x)
end

"""
    containedInPrototypeScope(x::AbstractScope) -> Bool
Return whether this scope or one of its parents is a function prototype scope.
"""
function containedInPrototypeScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_containedInPrototypeScope(x)
end


# Scope (statement-kind and error-state predicates)
"""
    isConditionVarScope(x::AbstractScope) -> Bool
Return whether this scope holds the condition variable of an `if`/`switch`/`while`/`for`
statement.
"""
function isConditionVarScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isConditionVarScope(x)
end

"""
    hasUnrecoverableErrorOccurred(x::AbstractScope) -> Bool
Return whether an unrecoverable error has been diagnosed inside this scope. This can be
false even when the scope holds invalid declarations, because clang suppresses the errors
that follow a first invalid construct.
"""
function hasUnrecoverableErrorOccurred(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_hasUnrecoverableErrorOccurred(x)
end

"""
    isClassInheritanceScope(x::AbstractScope) -> Bool
Return whether this scope sits between a class's inheritance colon and its definition.
"""
function isClassInheritanceScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isClassInheritanceScope(x)
end

"""
    isInCXXInlineMethodScope(x::AbstractScope) -> Bool
Return whether this scope is a C++ inline method scope or is contained in one. The answer
is false outright when [`getFnParent`](@ref) is NULL; otherwise clang asserts that the
enclosing function scope has a parent, which holds for every scope a parser hands out.
"""
function isInCXXInlineMethodScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isInCXXInlineMethodScope(x)
end

"""
    isFunctionPrototypeScope(x::AbstractScope) -> Bool
Return whether this scope is a function prototype scope.
"""
function isFunctionPrototypeScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isFunctionPrototypeScope(x)
end

"""
    isFunctionDeclarationScope(x::AbstractScope) -> Bool
Return whether this scope is a function declaration scope.
"""
function isFunctionDeclarationScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isFunctionDeclarationScope(x)
end

"""
    isCatchScope(x::AbstractScope) -> Bool
Return whether this scope is a C++ `catch` statement.
"""
function isCatchScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isCatchScope(x)
end

"""
    isSwitchScope(x::AbstractScope) -> Bool
Return whether this scope is inside a `switch` statement. The walk up the parent chain
stops at the first function, class, block, template parameter or prototype boundary.
"""
function isSwitchScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isSwitchScope(x)
end

"""
    isContinueScope(x::AbstractScope) -> Bool
Return whether this scope is a `while`/`do`/`for` statement, which can hold a `continue`.
"""
function isContinueScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isContinueScope(x)
end

"""
    isTryScope(x::AbstractScope) -> Bool
Return whether this scope is a C++ `try` block.
"""
function isTryScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isTryScope(x)
end

"""
    isCompoundStmtScope(x::AbstractScope) -> Bool
Return whether this scope is a compound statement scope.
"""
function isCompoundStmtScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isCompoundStmtScope(x)
end

"""
    isControlScope(x::AbstractScope) -> Bool
Return whether this scope is the controlling scope of an `if`/`switch`/`while`/`for`
statement.
"""
function isControlScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isControlScope(x)
end


# Scope (Microsoft mangling numbers, ObjC/OpenMP/SEH scope kinds, using-directives)
"""
    getMSLastManglingParent(x::AbstractScope) -> Scope
Return the innermost enclosing scope that takes part in Microsoft mangling numbering. The
returned `Scope` carries a NULL pointer when there is no such scope.
"""
function getMSLastManglingParent(x::AbstractScope)
    @check_ptrs x
    return Scope(clang_Scope_getMSLastManglingParent(x))
end

"""
    getMSLastManglingNumber(x::AbstractScope) -> Integer
Return the Microsoft mangling number held by [`getMSLastManglingParent`](@ref), or 1 when
there is no such scope.
"""
function getMSLastManglingNumber(x::AbstractScope)
    @check_ptrs x
    return Int(clang_Scope_getMSLastManglingNumber(x))
end

"""
    getMSCurManglingNumber(x::AbstractScope) -> Integer
Return this scope's own Microsoft mangling number.
"""
function getMSCurManglingNumber(x::AbstractScope)
    @check_ptrs x
    return Int(clang_Scope_getMSCurManglingNumber(x))
end

"""
    isInObjcMethodScope(x::AbstractScope) -> Bool
Return whether this scope is, or is contained in, an Objective-C method body. The answer is
computed by walking the parent chain, so it is not constant time.
"""
function isInObjcMethodScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isInObjcMethodScope(x)
end

"""
    isInObjcMethodOuterScope(x::AbstractScope) -> Bool
Return whether this scope is itself the outermost body of an Objective-C method.
"""
function isInObjcMethodOuterScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isInObjcMethodOuterScope(x)
end

"""
    isAtCatchScope(x::AbstractScope) -> Bool
Return whether this scope is an Objective-C `@catch` clause. The C++ `catch` clause is
[`isCatchScope`](@ref).
"""
function isAtCatchScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isAtCatchScope(x)
end

"""
    isOpenMPDirectiveScope(x::AbstractScope) -> Bool
Return whether this scope is an OpenMP directive scope.
"""
function isOpenMPDirectiveScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isOpenMPDirectiveScope(x)
end

"""
    isOpenMPLoopDirectiveScope(x::AbstractScope) -> Bool
Return whether this scope is an OpenMP loop directive scope such as `omp for` or `omp simd`.

clang asserts that a scope carrying the loop-directive flag also carries the plain directive
flag. The parser never builds the other combination, so that is an internal consistency
check rather than a precondition a caller can violate from here.
"""
function isOpenMPLoopDirectiveScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isOpenMPLoopDirectiveScope(x)
end

"""
    isOpenMPSimdDirectiveScope(x::AbstractScope) -> Bool
Return whether this scope is, or is nested in, an OpenMP loop-simd directive scope such as
`omp simd` or `omp for simd`.
"""
function isOpenMPSimdDirectiveScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isOpenMPSimdDirectiveScope(x)
end

"""
    isOpenMPLoopScope(x::AbstractScope) -> Bool
Return whether this scope is a loop with an OpenMP loop directive attached. The answer comes
from the parent scope, so it is false whenever [`getParent`](@ref) is NULL.
"""
function isOpenMPLoopScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isOpenMPLoopScope(x)
end

"""
    isOpenMPOrderClauseScope(x::AbstractScope) -> Bool
Return whether this scope is an OpenMP directive carrying an `order` clause that specifies a
concurrent scope.
"""
function isOpenMPOrderClauseScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isOpenMPOrderClauseScope(x)
end

"""
    isFnTryCatchScope(x::AbstractScope) -> Bool
Return whether this scope is a function-level C++ `try` or `catch` scope.
"""
function isFnTryCatchScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isFnTryCatchScope(x)
end

"""
    isSEHTryScope(x::AbstractScope) -> Bool
Return whether this scope is a Structured Exception Handling `__try` block.
"""
function isSEHTryScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isSEHTryScope(x)
end

"""
    isSEHExceptScope(x::AbstractScope) -> Bool
Return whether this scope is a Structured Exception Handling `__except` block.
"""
function isSEHExceptScope(x::AbstractScope)
    @check_ptrs x
    return clang_Scope_isSEHExceptScope(x)
end

"""
    Contains(x::AbstractScope, y::AbstractScope) -> Bool
Return whether `y` sits deeper than `x`, which is how clang spells "`x` encloses `y`".

Precondition: one of the two scopes must be an ancestor of the other. The comparison is on
scope depth alone, so the answer is meaningless for two unrelated scopes;
`clang::Scope::Contains` makes checking that the caller's responsibility.
"""
function Contains(x::AbstractScope, y::AbstractScope)
    @check_ptrs x y
    return clang_Scope_Contains(x, y)
end

"""
    getNumUsingDirectives(x::AbstractScope) -> Integer
Return the number of `using namespace` directives pushed onto this scope.
"""
function getNumUsingDirectives(x::AbstractScope)
    @check_ptrs x
    return Int(clang_Scope_getNumUsingDirectives(x))
end

"""
    getUsingDirective(x::AbstractScope, i::Integer) -> UsingDirectiveDecl
Return the `i`-th (0-based) `using namespace` directive pushed onto this scope, in the order
the parser pushed them.
"""
function getUsingDirective(x::AbstractScope, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUsingDirectives(x) "using-directive index is out of range"
    return UsingDirectiveDecl(clang_Scope_getUsingDirective(x, i))
end

"""
    getUsingDirectives(x::AbstractScope) -> Vector{UsingDirectiveDecl}
Return the `using namespace` directives pushed onto this scope, in the order the parser
pushed them.
"""
function getUsingDirectives(x::AbstractScope)
    @check_ptrs x
    return [getUsingDirective(x, i) for i = 0:(getNumUsingDirectives(x) - 1)]
end

"""
    dumpImplToString(x::AbstractScope) -> String
Return the description [`dump`](@ref) writes to `stderr` as a string instead.
"""
function dumpImplToString(x::AbstractScope)
    @check_ptrs x
    return get_string(clang_Scope_dumpImplToString(x))
end


"""
    Scope(parent::Union{AbstractScope,Nothing}, flags::Integer,
          diag::AbstractDiagnosticsEngine) -> Scope
Build a free-standing `clang::Scope` carrying `flags` — an OR of `CXScopeFlags` values —
under `parent`, or at the root when `parent` is `nothing`. This function allocates and one
should call `dispose` to release the resources after using this object.

The scope is not pushed onto `Sema`'s scope stack and nothing in clang refers to it, so it
is what makes the mutators below usable outside the parser: filling it, re-flagging it or
advancing its mangling numbers cannot disturb a live parse. `diag` is only borrowed — the
scope's error trap keeps a reference to it — so it must outlive the scope.

`dispose` is a plain `delete`, so it must never be given a scope that came from
[`getCurScope`](@ref) or [`getParent`](@ref).
"""
function Scope(parent::Union{AbstractScope,Nothing}, flags::Integer,
               diag::AbstractDiagnosticsEngine)
    @check_ptrs diag
    if parent !== nothing
        @check_ptrs parent
    end
    p = parent === nothing ? CXScope(C_NULL) : parent.ptr
    return Scope(clang_Scope_create(p, UInt32(flags), diag))
end

dispose(x::Scope) = clang_Scope_dispose(x)

"""
    setFlags(x::AbstractScope, flags::Integer)
Replace the scope's flag word with `flags` — an OR of `CXScopeFlags` values — and re-derive
what follows from it against the scope's existing parent: the depth, the break and continue
parents, the prototype depth and the Microsoft mangling parent.
"""
function setFlags(x::AbstractScope, flags::Integer)
    @check_ptrs x
    clang_Scope_setFlags(x, UInt32(flags))
    return nothing
end

"""
    setIsConditionVarScope(x::AbstractScope, in_condition_var_scope::Bool)
Set whether this is the scope of a condition variable, in which `continue` is disallowed even
though the scope is a continue scope. [`isConditionVarScope`](@ref) reads it back.
"""
function setIsConditionVarScope(x::AbstractScope, in_condition_var_scope::Bool)
    @check_ptrs x
    clang_Scope_setIsConditionVarScope(x, in_condition_var_scope)
    return nothing
end

"""
    getNextFunctionPrototypeIndex(x::AbstractScope) -> Integer
Return the number of parameters declared in this function prototype so far, and increment it
for the next call.

Precondition: [`isFunctionPrototypeScope`](@ref) — `clang::Scope::getNextFunctionPrototypeIndex`
asserts it.
"""
function getNextFunctionPrototypeIndex(x::AbstractScope)
    @check_ptrs x
    @assert isFunctionPrototypeScope(x) "scope must be a function prototype scope"
    return Int(clang_Scope_getNextFunctionPrototypeIndex(x))
end

"""
    AddDecl(x::AbstractScope, d::AbstractDecl)
Add `d` to the declarations this scope introduces. A variable that is not a parameter is
additionally recorded as an NRVO return slot.
"""
function AddDecl(x::AbstractScope, d::AbstractDecl)
    @check_ptrs x d
    clang_Scope_AddDecl(x, d)
    return nothing
end

"""
    RemoveDecl(x::AbstractScope, d::AbstractDecl)
Remove `d` from the declarations this scope introduces. The NRVO return slots are not
touched, so a variable added with [`AddDecl`](@ref) stays a return-slot candidate.
"""
function RemoveDecl(x::AbstractScope, d::AbstractDecl)
    @check_ptrs x d
    clang_Scope_RemoveDecl(x, d)
    return nothing
end

"""
    incrementMSManglingNumber(x::AbstractScope)
Advance the Microsoft mangling number held by this scope and by its mangling parent together.
A scope with no mangling parent ([`getMSLastManglingParent`](@ref)) is left unchanged.
"""
function incrementMSManglingNumber(x::AbstractScope)
    @check_ptrs x
    clang_Scope_incrementMSManglingNumber(x)
    return nothing
end

"""
    decrementMSManglingNumber(x::AbstractScope)
Undo one [`incrementMSManglingNumber`](@ref) on this scope and its mangling parent. A scope
with no mangling parent is left unchanged.
"""
function decrementMSManglingNumber(x::AbstractScope)
    @check_ptrs x
    clang_Scope_decrementMSManglingNumber(x)
    return nothing
end

"""
    setEntity(x::AbstractScope, dc::AbstractDeclContext)
Set the `DeclContext` this scope corresponds to.

Precondition: `!isTemplateParamScope(x)` — `clang::Scope::setEntity` asserts it. Use
[`setLookupEntity`](@ref) on a template parameter scope.
"""
function setEntity(x::AbstractScope, dc::AbstractDeclContext)
    @check_ptrs x dc
    @assert !isTemplateParamScope(x) "a template parameter scope has no entity"
    clang_Scope_setEntity(x, dc)
    return nothing
end

"""
    setLookupEntity(x::AbstractScope, dc::AbstractDeclContext)
Set the `DeclContext` unqualified lookup continues in after this scope, with none of
[`setEntity`](@ref)'s restriction. On a template parameter scope the value is reported by
[`getLookupEntity`](@ref) but not by [`getEntity`](@ref).
"""
function setLookupEntity(x::AbstractScope, dc::AbstractDeclContext)
    @check_ptrs x dc
    clang_Scope_setLookupEntity(x, dc)
    return nothing
end

"""
    PushUsingDirective(x::AbstractScope, ud::AbstractUsingDirectiveDecl)
Append `ud` to the `using namespace` directives [`getUsingDirective`](@ref) indexes. Only the
pointer is stored, so `ud` must outlive the scope.
"""
function PushUsingDirective(x::AbstractScope, ud::AbstractUsingDirectiveDecl)
    @check_ptrs x ud
    clang_Scope_PushUsingDirective(x, ud)
    return nothing
end

"""
    Init(x::AbstractScope, parent::Union{AbstractScope,Nothing}, flags::Integer)
Re-initialise the scope as a child of `parent` carrying `flags` — the same work the
[`Scope`](@ref) constructor runs after allocating, which is how the parser recycles a cached
scope instead of allocating a new one.
"""
function Init(x::AbstractScope, parent::Union{AbstractScope,Nothing}, flags::Integer)
    @check_ptrs x
    if parent !== nothing
        @check_ptrs parent
    end
    p = parent === nothing ? CXScope(C_NULL) : parent.ptr
    clang_Scope_Init(x, p, UInt32(flags))
    return nothing
end
