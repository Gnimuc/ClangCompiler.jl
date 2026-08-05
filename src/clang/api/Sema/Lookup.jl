# LookupResult
dispose(x::LookupResult) = clang_LookupResult_dispose(x)

function isForRedeclaration(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isForRedeclaration(x)
end

function isTemplateNameLookup(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isTemplateNameLookup(x)
end

function isAmbiguous(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isAmbiguous(x)
end

function isSingleResult(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isSingleResult(x)
end

function isOverloadedResult(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isOverloadedResult(x)
end

function isUnresolvableResult(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isUnresolvableResult(x)
end

function isClassLookup(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isClassLookup(x)
end

function resolveKind(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_resolveKind(x)
end

function isSingleTagDecl(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_isSingleTagDecl(x)
end

function clear(x::LookupResult, kind::CXLookupNameKind)
    @check_ptrs x
    return clang_LookupResult_clear(x, kind)
end

function dump(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_dump(x)
end

function empty(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_empty(x)
end

function setLookupName(x::LookupResult, dn::DeclarationName)
    @check_ptrs x
    return clang_LookupResult_setLookupName(x, dn)
end

function getRepresentativeDecl(x::LookupResult)
    @check_ptrs x
    return NamedDecl(clang_LookupResult_getRepresentativeDecl(x))
end

function getLookupName(x::LookupResult)
    @check_ptrs x
    return DeclarationName(clang_LookupResult_getLookupName(x))
end

function getNum(x::LookupResult)
    @check_ptrs x
    return clang_LookupResult_getNum(x)
end

function getResults(x::LookupResult)
    @check_ptrs x
    n = getNum(x)
    v = Vector{CXNamedDecl}(undef, n)
    clang_LookupResult_getResults(x, v, n)
    return NamedDecl.(v)
end

function getResult(x::LookupResult)
    @check_ptrs x
    return NamedDecl(clang_LookupResult_getResult(x))
end


function getResultKind(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_getResultKind(x)
end

"""
    getAmbiguityKind(x::AbstractLookupResult) -> CXAmbiguityKind
Precondition: the lookup is ambiguous -- `clang::LookupResult::getAmbiguityKind` asserts it.
"""
function getAmbiguityKind(x::AbstractLookupResult)
    @check_ptrs x
    @assert isAmbiguous(x) "the lookup result is not ambiguous"
    return clang_LookupResult_getAmbiguityKind(x)
end

"""
    getFoundDecl(x::AbstractLookupResult) -> NamedDecl
Precondition: `getResultKind(x) == CXLookupResultKind_Found` --
`clang::LookupResult::getFoundDecl` asserts the result is unique before dereferencing it.
"""
function getFoundDecl(x::AbstractLookupResult)
    @check_ptrs x
    @assert getResultKind(x) == CXLookupResultKind_Found "the lookup result is not a unique decl"
    return NamedDecl(clang_LookupResult_getFoundDecl(x))
end

function getNamingClass(x::AbstractLookupResult)
    @check_ptrs x
    return CXXRecordDecl(clang_LookupResult_getNamingClass(x))
end

function getLookupKind(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_getLookupKind(x)
end

function getNameLoc(x::AbstractLookupResult)
    @check_ptrs x
    return SourceLocation(clang_LookupResult_getNameLoc(x))
end

function getIdentifierNamespace(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_getIdentifierNamespace(x)
end

function suppressDiagnostics(x::AbstractLookupResult)
    @check_ptrs x
    clang_LookupResult_suppressDiagnostics(x)
    return nothing
end


function isForExternalRedeclaration(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_isForExternalRedeclaration(x)
end

"""
    setAllowHidden(x::AbstractLookupResult, allow::Bool)
Let this lookup see declarations hidden by a module that has not been imported.
"""
function setAllowHidden(x::AbstractLookupResult, allow::Bool)
    @check_ptrs x
    clang_LookupResult_setAllowHidden(x, allow)
    return nothing
end

"""
    isHiddenDeclarationVisible(x::AbstractLookupResult, nd::AbstractNamedDecl) -> Bool
Return whether this lookup is permitted to see `nd` when `nd` is hidden. True as soon as
`setAllowHidden(x, true)` has been called; otherwise only for an external redeclaration
lookup of an externally declarable decl.
"""
function isHiddenDeclarationVisible(x::AbstractLookupResult, nd::AbstractNamedDecl)
    @check_ptrs x nd
    return clang_LookupResult_isHiddenDeclarationVisible(x, nd)
end

"""
    getBaseObjectType(x::AbstractLookupResult) -> QualType
Return the base object type associated with this lookup. Most lookups have none, and the
returned `QualType` then carries a NULL encoding.
"""
function getBaseObjectType(x::AbstractLookupResult)
    @check_ptrs x
    return QualType(clang_LookupResult_getBaseObjectType(x))
end

function isShadowed(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_isShadowed(x)
end

function isSuppressingAccessDiagnostics(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_isSuppressingAccessDiagnostics(x)
end

function isSuppressingAmbiguousDiagnostics(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_isSuppressingAmbiguousDiagnostics(x)
end

"""
    getContextRange(x::AbstractLookupResult) -> SourceRange
Return the source range of the context of the looked-up name; for a C++ qualified lookup
this is the range of the scope specifier. Both locations are invalid when unset.
"""
function getContextRange(x::AbstractLookupResult)
    @check_ptrs x
    r = clang_LookupResult_getContextRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end


# LookupResult (name info and result assembly)
"""
    getLookupNameInfo(x::AbstractLookupResult) -> DeclarationNameInfo
Return the name info this lookup searches for.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getLookupNameInfo(x::AbstractLookupResult)
    @check_ptrs x
    return DeclarationNameInfo(clang_LookupResult_getLookupNameInfo(x))
end

"""
    setLookupNameInfo(x::AbstractLookupResult, ni::DeclarationNameInfo)
Set the name info this lookup searches for. `ni` is copied, not adopted, and stays the
caller's to `dispose`.
"""
function setLookupNameInfo(x::AbstractLookupResult, ni::DeclarationNameInfo)
    @check_ptrs x ni
    clang_LookupResult_setLookupNameInfo(x, ni)
    return nothing
end

"""
    setNamingClass(x::AbstractLookupResult, rd::AbstractCXXRecordDecl)
Set the class that names the members this lookup found. Setting it makes the lookup a class
lookup, which turns clang's access check on when the result is destroyed; call
[`suppressDiagnostics`](@ref) first on a result that was assembled by hand rather than by a
lookup.
"""
function setNamingClass(x::AbstractLookupResult, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    clang_LookupResult_setNamingClass(x, rd)
    return nothing
end

"""
    setBaseObjectType(x::AbstractLookupResult, ty::AbstractQualType)
Set the base object type this lookup was performed against, which `[class.protected]`
depends on.
"""
function setBaseObjectType(x::AbstractLookupResult, ty::AbstractQualType)
    @check_ptrs x ty
    clang_LookupResult_setBaseObjectType(x, ty)
    return nothing
end

"""
    addDecl(x::AbstractLookupResult, nd::AbstractNamedDecl)
Add `nd` to the results with its natural access and mark the result as found. No acceptance
criterion is tested.

Precondition: `nd`'s access specifier must be set when `nd` is a class member --
`clang::LookupResult::addDecl` reads `getAccess()`, which asserts otherwise. Adding more
than one declaration also leaves the result kind inconsistent with the declaration count
until [`resolveKind`](@ref) has run, and clang asserts on that in an assertion build.
"""
function addDecl(x::AbstractLookupResult, nd::AbstractNamedDecl)
    @check_ptrs x nd
    @assert(!isCXXClassMember(nd) || getAccessUnsafe(nd) != CXAccessSpecifier_AS_none,
            "a class member's access specifier must be set before it is added to a result")
    clang_LookupResult_addDecl(x, nd)
    return nothing
end

"""
    addAllDecls(x::AbstractLookupResult, other::AbstractLookupResult)
Append every declaration of `other` to `x` and mark `x` as found. The same
[`resolveKind`](@ref) requirement as [`addDecl`](@ref) applies once `x` holds more than one
declaration.
"""
function addAllDecls(x::AbstractLookupResult, other::AbstractLookupResult)
    @check_ptrs x other
    clang_LookupResult_addAllDecls(x, other)
    return nothing
end

"""
    wasNotFoundInCurrentInstantiation(x::AbstractLookupResult) -> Bool
Return whether the lookup found nothing because it could not search into the dependent base
classes of the current instantiation.
"""
function wasNotFoundInCurrentInstantiation(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_wasNotFoundInCurrentInstantiation(x)
end

"""
    setNotFoundInCurrentInstantiation(x::AbstractLookupResult)
Record that nothing was found and that dependent base classes of the current instantiation
were left unsearched.

Precondition: the result kind is `CXLookupResultKind_NotFound` and the result is empty --
`clang::LookupResult::setNotFoundInCurrentInstantiation` asserts both.
"""
function setNotFoundInCurrentInstantiation(x::AbstractLookupResult)
    @check_ptrs x
    @assert getResultKind(x) == CXLookupResultKind_NotFound "the lookup already found something"
    @assert empty(x) "the lookup result is not empty"
    clang_LookupResult_setNotFoundInCurrentInstantiation(x)
    return nothing
end


# LookupResult (the remaining configuration setters)
"""
    setTemplateNameLookup(x::AbstractLookupResult, v::Bool=true)
Set whether this is a template-name lookup, in which an injected-class-name names the
template itself rather than a specialization of it. Read it back with
[`isTemplateNameLookup`](@ref).
"""
function setTemplateNameLookup(x::AbstractLookupResult, v::Bool=true)
    @check_ptrs x
    clang_LookupResult_setTemplateNameLookup(x, v)
    return nothing
end

"""
    setShadowed(x::AbstractLookupResult)
Record that lookup found and ignored a declaration. `clang::LookupResult` offers no way back
to the unshadowed state; read the flag with [`isShadowed`](@ref).
"""
function setShadowed(x::AbstractLookupResult)
    @check_ptrs x
    clang_LookupResult_setShadowed(x)
    return nothing
end

"""
    setContextRange(x::AbstractLookupResult, r::SourceRange)
Set the source range of the context of the looked-up name; for a C++ qualified lookup this
is the range of the scope specifier. Read it back with [`getContextRange`](@ref).
"""
function setContextRange(x::AbstractLookupResult, r::SourceRange)
    @check_ptrs x
    clang_LookupResult_setContextRange(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
    return nothing
end


# LookupResult (acceptability and the remaining configuration)
"""
    setHideTags(x::AbstractLookupResult, hide::Bool)
Set whether tag declarations are hidden by non-tag declarations while the result kind is
resolved. The default is `true`.
"""
function setHideTags(x::AbstractLookupResult, hide::Bool)
    @check_ptrs x
    clang_LookupResult_setHideTags(x, hide)
    return nothing
end

"""
    isAvailableForLookup(s::AbstractSema, nd::AbstractNamedDecl) -> Bool
Return whether `nd` is available to a name lookup performed by `s`. Availability is weaker
than visibility: a declaration reached through a non-exported import is available to lookup
without being visible to it.
"""
function isAvailableForLookup(s::AbstractSema, nd::AbstractNamedDecl)
    @check_ptrs s nd
    return clang_LookupResult_isAvailableForLookup(s, nd)
end

"""
    getAcceptableDecl(x::AbstractLookupResult, nd::AbstractNamedDecl) -> NamedDecl
Return the redeclaration of `nd` that this lookup accepts. The returned carrier holds NULL
when `nd` inhabits none of the lookup's identifier namespaces and has no acceptable
redeclaration.
"""
function getAcceptableDecl(x::AbstractLookupResult, nd::AbstractNamedDecl)
    @check_ptrs x nd
    return NamedDecl(clang_LookupResult_getAcceptableDecl(x, nd))
end

"""
    resolveKindAfterFilter(x::AbstractLookupResult)
Recompute the result kind after declarations have been removed. [`done`](@ref) already does
this for the filter it ends; call it directly only after editing the results another way.
"""
function resolveKindAfterFilter(x::AbstractLookupResult)
    @check_ptrs x
    clang_LookupResult_resolveKindAfterFilter(x)
    return nothing
end

"""
    setAmbiguousQualifiedTagHiding(x::AbstractLookupResult)
Record that the name was found in different contexts and that a tag declaration was hidden
by an ordinary declaration in another one. Read the ambiguity back with
[`getAmbiguityKind`](@ref).

Precondition: the result must already suppress its ambiguity diagnostics -- destroying an
ambiguous result runs `Sema::DiagnoseAmbiguousLookup`, and rendering a diagnostic outside a
parse crashes clang's diagnostic renderer. Call [`suppressDiagnostics`](@ref) first.
"""
function setAmbiguousQualifiedTagHiding(x::AbstractLookupResult)
    @check_ptrs x
    @assert(isSuppressingAmbiguousDiagnostics(x),
            "suppress the result's ambiguity diagnostics before making it ambiguous")
    clang_LookupResult_setAmbiguousQualifiedTagHiding(x)
    return nothing
end

"""
    suppressAccessDiagnostics(x::AbstractLookupResult)
Suppress the access-control diagnostic clang emits when a class lookup is destroyed, leaving
the ambiguity diagnostic on. [`suppressDiagnostics`](@ref) turns both off.
"""
function suppressAccessDiagnostics(x::AbstractLookupResult)
    @check_ptrs x
    clang_LookupResult_suppressAccessDiagnostics(x)
    return nothing
end

"""
    getSema(x::AbstractLookupResult) -> Sema
Return the `Sema` this lookup was created against.
"""
function getSema(x::AbstractLookupResult)
    @check_ptrs x
    return Sema(clang_LookupResult_getSema(x))
end

"""
    setFindLocalExtern(x::AbstractLookupResult, find::Bool)
Add (or remove) the local-extern identifier namespace to the ones this lookup searches,
which is what makes a block-scope `extern` declaration findable. Observe the change through
[`getIdentifierNamespace`](@ref).
"""
function setFindLocalExtern(x::AbstractLookupResult, find::Bool)
    @check_ptrs x
    clang_LookupResult_setFindLocalExtern(x, find)
    return nothing
end

# LookupResult::Filter
"""
    makeFilter(x::AbstractLookupResult) -> LookupResultFilter
Create a filter over this result set, for walking the declarations the lookup found and
erasing or replacing them.

The filter borrows `x`, which must outlive it. This function allocates and one should call
[`done`](@ref) and then `dispose` to release the resources after using this object --
`clang::LookupResult::Filter`'s destructor asserts that `done` has run, and the flag it
reads is private, so `dispose` cannot check it for you.
"""
function makeFilter(x::AbstractLookupResult)
    @check_ptrs x
    return LookupResultFilter(clang_LookupResult_makeFilter(x))
end

dispose(x::LookupResultFilter) = clang_LookupResult_Filter_dispose(x)

"""
    hasNext(x::AbstractLookupResultFilter) -> Bool
Return whether the filter still has a declaration to hand out.
"""
function hasNext(x::AbstractLookupResultFilter)
    @check_ptrs x
    return clang_LookupResult_Filter_hasNext(x)
end

"""
    next(x::AbstractLookupResultFilter) -> NamedDecl
Return the next declaration and advance the filter. It is the declaration lookup found,
possibly sugared -- not its underlying declaration.

Precondition: [`hasNext`](@ref) -- `clang::LookupResult::Filter::next` asserts it.
"""
function next(x::AbstractLookupResultFilter)
    @check_ptrs x
    @assert hasNext(x) "the filter has no declaration left to hand out"
    return NamedDecl(clang_LookupResult_Filter_next(x))
end

"""
    restart(x::AbstractLookupResultFilter)
Restart the iteration at the first declaration of the result set.
"""
function restart(x::AbstractLookupResultFilter)
    @check_ptrs x
    clang_LookupResult_Filter_restart(x)
    return nothing
end

"""
    erase(x::AbstractLookupResultFilter)
Remove the declaration last returned by [`next`](@ref) from the result set.

Precondition: [`next`](@ref) has been called at least once since the filter was made or
[`restart`](@ref)ed. `clang::LookupResult::Filter` steps its iterator back with no check and
exposes no way to observe the iterator, so this precondition is documented rather than
asserted.
"""
function erase(x::AbstractLookupResultFilter)
    @check_ptrs x
    clang_LookupResult_Filter_erase(x)
    return nothing
end

"""
    replace(x::AbstractLookupResultFilter, nd::AbstractNamedDecl)
Replace the declaration last returned by [`next`](@ref) with `nd`, keeping the access bits
of the entry it replaces. This extends `Base.replace` instead of defining a new `replace`,
which would shadow the string method this package calls in `src/lookup.jl`.

Precondition: the same as [`erase`](@ref)'s, and equally undetectable.
"""
function Base.replace(x::AbstractLookupResultFilter, nd::AbstractNamedDecl)
    @check_ptrs x nd
    clang_LookupResult_Filter_replace(x, nd)
    return nothing
end

"""
    done(x::AbstractLookupResultFilter)
End the filtering pass, re-resolving the result kind when anything was erased or replaced.
Call it before `dispose`.

Precondition: not already called on this filter -- `clang::LookupResult::Filter::done`
asserts it, and the flag it reads is private, so this precondition is documented rather than
asserted.
"""
function done(x::AbstractLookupResultFilter)
    @check_ptrs x
    clang_LookupResult_Filter_done(x)
    return nothing
end


"""
    redeclarationKind(x::AbstractLookupResult) -> CXRedeclarationKind
Return which flavour of redeclaration lookup this result was configured for.
"""
function redeclarationKind(x::AbstractLookupResult)
    @check_ptrs x
    return clang_LookupResult_redeclarationKind(x)
end

"""
    setRedeclarationKind(x::AbstractLookupResult, rk::CXRedeclarationKind)
Change the redeclaration flavour of `x` and reconfigure the identifier namespaces it
accepts.

Reconfiguration is not free of side effects: when the looked-up name is one of the
allocation or deallocation operators, clang declares the implicit global `operator new` /
`operator delete` into the translation unit. Constructing a [`LookupResult`](@ref) and
[`clear`](@ref)ing one already do the same thing.
"""
function setRedeclarationKind(x::AbstractLookupResult, rk::CXRedeclarationKind)
    @check_ptrs x
    return clang_LookupResult_setRedeclarationKind(x, rk)
end

"""
    printToString(x::AbstractLookupResult) -> String
Render the result — the number of declarations found, whether it is ambiguous or carries
base paths, and each declaration — the way `clang::LookupResult::print` writes it to a
stream.
"""
function printToString(x::AbstractLookupResult)
    @check_ptrs x
    return get_string(clang_LookupResult_printToString(x))
end


"""
    isAcceptable(s::AbstractSema, d::AbstractNamedDecl, reachable::Bool=false) -> Bool
Return whether `d` is acceptable to name lookup: visible when `reachable` is `false`,
reachable when it is `true`.

`clang::LookupResult::isAcceptable` and `clang::Sema::isAcceptable` are both a two-way branch
over the visibility and reachability predicates, so this is written over the existing
[`isVisible`](@ref) and [`isReachable`](@ref) wrappers rather than adding a third C symbol
that would compute the same answer.
"""
function isAcceptable(s::AbstractSema, d::AbstractNamedDecl, reachable::Bool=false)
    @check_ptrs s d
    return reachable ? isReachable(s, d) : isVisible(s, d)
end
